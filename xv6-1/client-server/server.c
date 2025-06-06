#define _DEFAULT_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>
#include <time.h>
#include <math.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h> // For strerror
#include <errno.h>  // For errno
#include <signal.h> // For signal handling (optional but good)

#define BUFFER_SIZE 20
#define INITIAL_CONSUMERS 3
#define MAX_CONSUMERS 10
#define MIN_CONSUMERS 3
#define FIFO_PATH "/tmp/cs_fifo" // Must match Makefile and client.c

// Thresholds for dynamic thread adjustment
#define HIGH_WATERMARK (BUFFER_SIZE * 0.9) // e.g., 18
#define LOW_WATERMARK  (BUFFER_SIZE * 0.25) // e.g., 5
#define MANAGER_SLEEP_INTERVAL 1 // Seconds between manager checks


// --- Global Variables ---
int buffer[BUFFER_SIZE];
int buffer_index_put = 0; // Index for next item to be put (by pipe receiver)
int buffer_index_get = 0; // Index for next item to be gotten (by consumers)

pthread_mutex_t buffer_mutex;      // Mutex for buffer access
sem_t empty_slots;          // Semaphore for empty slots count
sem_t filled_slots;         // Semaphore for filled slots count

int pipe_fd = -1;           // File descriptor for the named pipe (read end)
double lambda_s;            // Parameter for consumer delay

// Dynamic Thread Management Globals
pthread_t consumer_threads[MAX_CONSUMERS];
volatile int consumer_active[MAX_CONSUMERS]; // 0=inactive/terminating, 1=active
volatile int num_active_consumers = 0;
pthread_mutex_t manager_mutex;      // Mutex to protect consumer thread list/count

volatile sig_atomic_t keep_running = 1; // Flag for graceful shutdown

// Structure to pass arguments to consumer threads
typedef struct {
    int id; // Represents the index in the consumer_threads array (0 to MAX_CONSUMERS-1)
} consumer_args_t;

// --- Function Prototypes ---
double neg_exp_delay(double lambda);
void *consumer_thread(void *arg);
void *pipe_receiver_thread(void *arg);
void *manager_thread(void *arg);
void cleanup_resources(); // Function to centralize cleanup
void sigint_handler(int sig); // Handle Ctrl+C

// --- Main Function ---
int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <lambda_s>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    lambda_s = atof(argv[1]);
    if (lambda_s <= 0) {
        fprintf(stderr, "Error: lambda_s must be positive.\n");
        exit(EXIT_FAILURE);
    }

    printf("Server (PID: %d) started with lambda_s = %.2f\n", getpid(), lambda_s);

    // Set up signal handler for graceful shutdown on Ctrl+C
    signal(SIGINT, sigint_handler);
    signal(SIGTERM, sigint_handler); // Also handle termination signal

    // Seed random number generator
    srand48(time(NULL));

    // --- Initialize Mutexes and Semaphores ---
    if (pthread_mutex_init(&buffer_mutex, NULL) != 0) {
        perror("Buffer Mutex init failed"); exit(EXIT_FAILURE); }
    if (pthread_mutex_init(&manager_mutex, NULL) != 0) {
        perror("Manager Mutex init failed"); pthread_mutex_destroy(&buffer_mutex); exit(EXIT_FAILURE); }
    if (sem_init(&empty_slots, 0, BUFFER_SIZE) != 0) {
        perror("Semaphore empty_slots init failed"); pthread_mutex_destroy(&manager_mutex); pthread_mutex_destroy(&buffer_mutex); exit(EXIT_FAILURE); }
    if (sem_init(&filled_slots, 0, 0) != 0) {
        perror("Semaphore filled_slots init failed"); sem_destroy(&empty_slots); pthread_mutex_destroy(&manager_mutex); pthread_mutex_destroy(&buffer_mutex); exit(EXIT_FAILURE); }

    // --- Create and Open the Named Pipe (FIFO) ---
    // Remove existing FIFO if it exists (optional, prevents EEXIST error)
    unlink(FIFO_PATH);
    if (mkfifo(FIFO_PATH, 0666) == -1) {
        if (errno != EEXIST) { // Ignore error if it already exists
            perror("Server: mkfifo failed");
            cleanup_resources(); // Use cleanup function
            exit(EXIT_FAILURE);
        }
         printf("Server: FIFO %s already exists. Proceeding.\n", FIFO_PATH);
    } else {
        printf("Server: Created FIFO %s\n", FIFO_PATH);
    }

    printf("Server: Waiting for client to connect to FIFO %s...\n", FIFO_PATH);
    pipe_fd = open(FIFO_PATH, O_RDONLY);
    if (pipe_fd == -1) {
        perror("Server: Error opening FIFO for reading");
        cleanup_resources();
        exit(EXIT_FAILURE);
    }
    printf("Server: Client connected. FIFO opened for reading (fd=%d).\n", pipe_fd);


    // --- Initialize Consumer Thread Tracking ---
    for (int i = 0; i < MAX_CONSUMERS; ++i) {
        consumer_threads[i] = 0; // Indicate slot is empty
        consumer_active[i] = 0;
    }
    num_active_consumers = 0;

    // --- Create Initial Consumer Threads ---
    pthread_mutex_lock(&manager_mutex); // Lock before modifying shared manager state
    consumer_args_t consumer_args[MAX_CONSUMERS]; // Args need to persist
    for (int i = 0; i < INITIAL_CONSUMERS; ++i) {
        consumer_args[i].id = i; // Pass index as ID
        consumer_active[i] = 1;
        if (pthread_create(&consumer_threads[i], NULL, consumer_thread, &consumer_args[i]) != 0) {
            perror("Failed to create initial consumer thread");
            consumer_active[i] = 0; // Mark as inactive on failure
            // More robust error handling would join already created threads
            keep_running = 0; // Signal shutdown on error
            break; // Stop creating threads
        } else {
            num_active_consumers++;
            printf("Server: Created initial Consumer Thread %d (Index: %d, TID: %lu)\n", num_active_consumers, i, (unsigned long)consumer_threads[i]);
        }
    }
    pthread_mutex_unlock(&manager_mutex);

    // --- Create Pipe Receiver and Manager Threads ---
    pthread_t pipe_receiver_tid = 0;
    pthread_t manager_tid = 0;

    if (keep_running && pthread_create(&pipe_receiver_tid, NULL, pipe_receiver_thread, NULL) != 0) {
        perror("Failed to create pipe receiver thread");
        keep_running = 0; // Signal shutdown
    }

    if (keep_running && pthread_create(&manager_tid, NULL, manager_thread, NULL) != 0) {
        perror("Failed to create manager thread");
        keep_running = 0; // Signal shutdown
    }

    // --- Wait for critical threads to complete ---
    if (pipe_receiver_tid != 0) {
        pthread_join(pipe_receiver_tid, NULL);
        printf("Server: Pipe receiver thread finished (Client likely disconnected).\n");
    } else {
         printf("Server: Pipe receiver thread failed to start.\n");
    }

     // Signal remaining threads to stop *after* receiver finishes or if startup failed
    printf("Server: Signaling shutdown to other threads...\n");
    keep_running = 0;

    // Wake up any potentially blocked consumers/manager
    pthread_mutex_lock(&manager_mutex);
    int current_consumers = num_active_consumers; // Capture count under lock
    pthread_mutex_unlock(&manager_mutex);

    printf("Server: Posting to filled_slots %d times to unblock consumers.\n", current_consumers + 1); // +1 for manager if it waits?
    for (int i = 0; i < current_consumers + 1; ++i) {
        sem_post(&filled_slots); // Wake up consumers waiting on filled slots
    }
     // Manager loop uses sleep, should see keep_running eventually.


    // --- Join remaining threads ---
    if (manager_tid != 0) {
        printf("Server: Joining manager thread...\n");
        pthread_join(manager_tid, NULL);
        printf("Server: Manager thread joined.\n");

    }
    printf("Server: Joining consumer threads...\n");
    pthread_mutex_lock(&manager_mutex);
    for (int i = 0; i < MAX_CONSUMERS; ++i) {
        if (consumer_threads[i] != 0) { // Check if thread was actually created
             printf("Server: Joining consumer index %d (TID %lu)...\n", i, (unsigned long) consumer_threads[i]);
             pthread_join(consumer_threads[i], NULL);
              printf("Server: Consumer index %d joined.\n", i);
             consumer_threads[i] = 0; // Mark as joined
        }
    }
     num_active_consumers = 0; // Reset count after joining
    pthread_mutex_unlock(&manager_mutex);
    printf("Server: All consumer threads joined.\n");


    // --- Final Cleanup ---
    cleanup_resources();
    printf("Server finished.\n");
    return 0;
}

// --- Cleanup Function ---
void cleanup_resources() {
    printf("Server: Cleaning up resources...\n");
    if (pipe_fd != -1) {
        close(pipe_fd);
        pipe_fd = -1;
        printf("Server: Closed pipe FD.\n");
    }
    // Remove the FIFO file
    if (unlink(FIFO_PATH) == -1 && errno != ENOENT) {
         perror("Server: Error unlinking FIFO");
    } else {
         printf("Server: Unlinked FIFO %s.\n", FIFO_PATH);
    }

    // Destroy semaphores and mutexes
    sem_destroy(&filled_slots);
    sem_destroy(&empty_slots);
    pthread_mutex_destroy(&buffer_mutex);
    pthread_mutex_destroy(&manager_mutex);
    printf("Server: Destroyed semaphores and mutexes.\n");
}

// --- Signal Handler ---
void sigint_handler(int sig) {
    printf("\nServer: Signal %d received. Initiating graceful shutdown...\n", sig);
    keep_running = 0;
    // Note: Sem_post calls to unblock threads are now in main after receiver joins.
    // Avoid doing too much work in a signal handler itself.
}


// --- Negative Exponential Delay Function ---
double neg_exp_delay(double lambda) {
    double u = drand48();
    if (u >= 1.0) u = 0.9999999;
    if (u <= 0.0) u = 0.0000001;
    return -log(1.0 - u) / lambda;
}

// --- Consumer Thread Function ---
void *consumer_thread(void *arg) {
    consumer_args_t *args = (consumer_args_t *)arg;
    int consumer_idx = args->id; // Index in the global arrays
    pid_t pid = getpid();
    pthread_t tid = pthread_self();

    printf("Consumer Thread (Index: %d, PID: %d, TID: %lu) started.\n", consumer_idx, pid, (unsigned long)tid);

    while (keep_running && consumer_active[consumer_idx]) { // Check global and individual flags
        // 1. Wait for a filled slot
         // Use timed wait or check keep_running frequently if using simple wait
        struct timespec ts;
        clock_gettime(CLOCK_REALTIME, &ts);
        ts.tv_sec += 1; // Wait for 1 second at most

        int sem_status = sem_timedwait(&filled_slots, &ts);

        if (!keep_running || !consumer_active[consumer_idx]) break; // Check flags again after wait/timeout

        if (sem_status == -1) {
            if (errno == ETIMEDOUT) {
                continue; // Timeout, loop again to check flags
            } else if (errno == EINTR) {
                continue; // Interrupted, loop again
            } else {
                perror("Consumer: sem_timedwait(filled_slots) failed");
                break; // Exit on other semaphore errors
            }
        }

        // We successfully got a filled slot token

        // 2. Acquire mutex
        pthread_mutex_lock(&buffer_mutex);

        // Check again if active *after* acquiring mutex,
        // and if buffer actually has content (sem_getvalue isn't atomic with wait)
        int current_fill;
        sem_getvalue(&filled_slots, &current_fill); // Check approx fill count

        if (!consumer_active[consumer_idx] || current_fill < 0 ) { // current_fill < 0 check might not be needed if logic correct
            pthread_mutex_unlock(&buffer_mutex);
             sem_post(&filled_slots); // Put token back if we are exiting prematurely
             printf("Consumer %d: Exiting due to inactive flag or unexpected buffer state after lock.\n", consumer_idx);
            break;
        }

        // 3. Get data from buffer
        int data = buffer[buffer_index_get];
        int item_index = buffer_index_get;
        buffer_index_get = (buffer_index_get + 1) % BUFFER_SIZE;

        // 4. Release mutex
        pthread_mutex_unlock(&buffer_mutex);

        // 5. Signal that a slot is now empty
        if (sem_post(&empty_slots) != 0) {
            perror("Consumer: sem_post(empty_slots) failed");
             // This is problematic, might lead to producer block. Maybe log and exit?
            break;
        }

        // 6. Process data (simulate with delay)
        double delay_sec = neg_exp_delay(lambda_s);
        usleep((useconds_t)(delay_sec * 1000000.0));

        // 7. Print information
        printf("Server PID: %d, Consumer TID: %lu (Index %d), Consumed: %d (from buffer index %d)\n",
               pid, (unsigned long)tid, consumer_idx, data, item_index);
    }

    printf("Consumer Thread (Index: %d, PID: %d, TID: %lu) exiting.\n", consumer_idx, pid, (unsigned long)tid);
    // Ensure this consumer is marked inactive if it wasn't already
    pthread_mutex_lock(&manager_mutex);
    if (consumer_active[consumer_idx]) {
        consumer_active[consumer_idx] = 0;
        // Only decrement if it was considered active by the manager.
        // If manager already decremented, this avoids double counting.
        // num_active_consumers--; // Let manager handle count changes
         printf("Consumer %d marking itself inactive.\n", consumer_idx);
    }
     consumer_threads[consumer_idx] = 0; // Clear TID entry after exit setup? Or let main do it after join.
    pthread_mutex_unlock(&manager_mutex);

    pthread_exit(NULL);
}


// --- Pipe Receiver Thread Function ---
void *pipe_receiver_thread(void *arg) {
    (void)arg; // Indicate arg is intentionally unused
    pid_t pid = getpid();
    pthread_t tid = pthread_self();
    int data;

    printf("Pipe Receiver Thread (PID: %d, TID: %lu) started.\n", pid, (unsigned long)tid);

    while (keep_running) {
        // 1. Read data from the pipe
        ssize_t bytes_read = read(pipe_fd, &data, sizeof(data));

        if (bytes_read == -1) {
             if (errno == EINTR) continue; // Interrupted, try again
            perror("Pipe Receiver: Error reading from pipe");
            keep_running = 0; // Signal shutdown on error
            break;
        } else if (bytes_read == 0) {
            printf("Pipe Receiver: EOF detected (Client closed the pipe). Signaling shutdown.\n");
            keep_running = 0; // Signal shutdown
            break; // Exit loop
        } else if (bytes_read < (ssize_t)sizeof(data)) {
             fprintf(stderr, "Pipe Receiver: Partial read occurred (%zd bytes). Corrupted data? Signaling shutdown.\n", bytes_read);
              keep_running = 0; // Signal shutdown
             break;
        }

        // Data received successfully

        // 2. Wait for an empty slot in the buffer
         if (sem_wait(&empty_slots) != 0) {
             if (errno == EINTR) continue; // Interrupted, retry outer loop? or just this wait?
             perror("Pipe Receiver: sem_wait(empty_slots) failed");
             keep_running = 0;
             break; // Exit loop on semaphore error
         }

        // 3. Acquire mutex
        pthread_mutex_lock(&buffer_mutex);

        // 4. Put data into buffer
        buffer[buffer_index_put] = data;
        buffer_index_put = (buffer_index_put + 1) % BUFFER_SIZE;

        // 5. Release mutex
        pthread_mutex_unlock(&buffer_mutex);

        // 6. Signal that a slot is now filled
        if (sem_post(&filled_slots) != 0) {
            perror("Pipe Receiver: sem_post(filled_slots) failed");
             keep_running = 0;
            break;
        }
         // Optional: Print received data
         // printf("Pipe Receiver: Received %d, placed in buffer.\n", data);
    }

    printf("Pipe Receiver Thread (PID: %d, TID: %lu) exiting.\n", pid, (unsigned long)tid);
    // Ensure other threads know pipe is closed by setting keep_running = 0
    keep_running = 0;
    // Wake up consumers who might be waiting, main loop does this now.
    pthread_exit(NULL);
}


// --- Manager Thread Function ---
void *manager_thread(void *arg) {
    (void)arg; // Indicate arg is intentionally unused
    pid_t pid = getpid();
    pthread_t tid = pthread_self();
    consumer_args_t consumer_args[MAX_CONSUMERS]; // Need persistent args for new threads


    printf("Manager Thread (PID: %d, TID: %lu) started.\n", pid, (unsigned long)tid);

    while (keep_running) {
        sleep(MANAGER_SLEEP_INTERVAL); // Check periodically

        if (!keep_running) break; // Check flag after sleep

        int current_fill = 0;
        if (sem_getvalue(&filled_slots, &current_fill) != 0) {
            perror("Manager: sem_getvalue failed");
            continue; // Skip this check cycle
        }

        // Lock manager state before checking/modifying consumer threads
        pthread_mutex_lock(&manager_mutex);

        int active_count = num_active_consumers; // Get current count under lock

        // --- Increase Threads ---
        if (current_fill >= HIGH_WATERMARK && active_count < MAX_CONSUMERS) {
            // Find an available slot for the new thread
            int new_idx = -1;
            for (int i = 0; i < MAX_CONSUMERS; ++i) {
                if (consumer_threads[i] == 0 && !consumer_active[i]) { // Find truly empty slot
                    new_idx = i;
                    break;
                }
            }

            if (new_idx != -1) {
                consumer_args[new_idx].id = new_idx; // Use index as ID
                consumer_active[new_idx] = 1; // Mark as active *before* creating
                if (pthread_create(&consumer_threads[new_idx], NULL, consumer_thread, &consumer_args[new_idx]) == 0) {
                    num_active_consumers++;
                    printf("Manager: Buffer level high (%d/%d). Added Consumer Thread (Index: %d, TID: %lu). Total active: %d\n",
                           current_fill, BUFFER_SIZE, new_idx, (unsigned long)consumer_threads[new_idx], num_active_consumers);
                } else {
                    perror("Manager: Failed to create new consumer thread");
                    consumer_active[new_idx] = 0; // Rollback active flag on failure
                    consumer_threads[new_idx] = 0; // Ensure TID is 0
                }
            } else {
                 printf("Manager: Buffer level high, but no available thread slots (max %d reached internally).\n", MAX_CONSUMERS);
            }
        }
        // --- Decrease Threads ---
        else if (current_fill <= LOW_WATERMARK && active_count > MIN_CONSUMERS) {
            // Find an active consumer to terminate (e.g., the highest index one)
            int term_idx = -1;
            for (int i = MAX_CONSUMERS - 1; i >= 0; --i) {
                if (consumer_active[i]) { // Find an active one
                    term_idx = i;
                    break;
                }
            }

            if (term_idx != -1) {
                printf("Manager: Buffer level low (%d/%d). Signaling Consumer Thread (Index: %d, TID: %lu) to terminate. Total active will be %d\n",
                       current_fill, BUFFER_SIZE, term_idx, (unsigned long)consumer_threads[term_idx], active_count - 1);
                consumer_active[term_idx] = 0; // Signal the thread to stop
                num_active_consumers--; // Decrement the logical count
                 // Wake up the specific consumer if it's blocked on filled_slots?
                 // sem_post(&filled_slots); // This is tricky, might wake wrong thread. Rely on timedwait/flag check.
                 // The thread will exit on its own when it checks the flag.
                 // Main function will join it later.
            }
        }

        pthread_mutex_unlock(&manager_mutex);
    }

    printf("Manager Thread (PID: %d, TID: %lu) exiting.\n", pid, (unsigned long)tid);
    pthread_exit(NULL);
}