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

#define BUFFER_SIZE 20
#define NUM_PRODUCERS 3
#define FIFO_PATH "/tmp/cs_fifo" // Must match Makefile and server.c

// --- Global Variables ---
int buffer[BUFFER_SIZE];
int buffer_index_put = 0; // Index for next item to be put
int buffer_index_get = 0; // Index for next item to be gotten (used by pipe sender)

pthread_mutex_t mutex;     // Mutex for buffer access
sem_t empty_slots;         // Semaphore for empty slots count
sem_t filled_slots;        // Semaphore for filled slots count

int pipe_fd = -1;          // File descriptor for the named pipe (write end)
double lambda_c;           // Parameter for producer delay

// Structure to pass arguments to producer threads
typedef struct {
    int id;
} producer_args_t;

// --- Function Prototypes ---
double neg_exp_delay(double lambda);
void *producer_thread(void *arg);
void *pipe_sender_thread(void *arg);

// --- Main Function ---
int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <lambda_c>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    lambda_c = atof(argv[1]);
    if (lambda_c <= 0) {
        fprintf(stderr, "Error: lambda_c must be positive.\n");
        exit(EXIT_FAILURE);
    }

    printf("Client (PID: %d) started with lambda_c = %.2f\n", getpid(), lambda_c);

    // Seed random number generator (use drand48 for better randomness)
    srand48(time(NULL));

    // Initialize mutex and semaphores
    if (pthread_mutex_init(&mutex, NULL) != 0) {
        perror("Mutex init failed");
        exit(EXIT_FAILURE);
    }
    if (sem_init(&empty_slots, 0, BUFFER_SIZE) != 0) { // Initial empty slots = buffer size
        perror("Semaphore empty_slots init failed");
        pthread_mutex_destroy(&mutex);
        exit(EXIT_FAILURE);
    }
    if (sem_init(&filled_slots, 0, 0) != 0) { // Initial filled slots = 0
        perror("Semaphore filled_slots init failed");
        sem_destroy(&empty_slots);
        pthread_mutex_destroy(&mutex);
        exit(EXIT_FAILURE);
    }

    // --- Open the named pipe (FIFO) for writing ---
    // Keep trying until the server has created and opened it for reading
    printf("Client waiting to open FIFO %s for writing...\n", FIFO_PATH);
    while ((pipe_fd = open(FIFO_PATH, O_WRONLY)) == -1) {
        perror("Client: Error opening FIFO for writing");
        if (errno == ENOENT) {
            printf("Client: FIFO not found, waiting for server...\n");
            sleep(1); // Wait and retry if FIFO doesn't exist yet
        } else {
            // Other errors
            sem_destroy(&filled_slots);
            sem_destroy(&empty_slots);
            pthread_mutex_destroy(&mutex);
            exit(EXIT_FAILURE);
        }
    }
    printf("Client successfully opened FIFO for writing (fd=%d).\n", pipe_fd);

    // --- Create threads ---
    pthread_t producer_tids[NUM_PRODUCERS];
    pthread_t pipe_sender_tid;
    producer_args_t producer_args[NUM_PRODUCERS];

    // Create Producer threads
    for (int i = 0; i < NUM_PRODUCERS; ++i) {
        producer_args[i].id = i + 1; // Producer IDs 1, 2, 3
        if (pthread_create(&producer_tids[i], NULL, producer_thread, &producer_args[i]) != 0) {
            perror("Failed to create producer thread");
            // Basic cleanup before exiting
            close(pipe_fd);
            sem_destroy(&filled_slots);
            sem_destroy(&empty_slots);
            pthread_mutex_destroy(&mutex);
            exit(EXIT_FAILURE); // Simplified exit on thread creation failure
        }
    }

    // Create Pipe Sender thread
    if (pthread_create(&pipe_sender_tid, NULL, pipe_sender_thread, NULL) != 0) {
        perror("Failed to create pipe sender thread");
        // Basic cleanup
        close(pipe_fd);
        sem_destroy(&filled_slots);
        sem_destroy(&empty_slots);
        pthread_mutex_destroy(&mutex);
        exit(EXIT_FAILURE);
    }

    // --- Wait for threads to complete (optional - could run indefinitely) ---
    // For simplicity, we'll just wait for the sender thread.
    // Producers will run until the sender potentially exits (e.g., pipe error).
    pthread_join(pipe_sender_tid, NULL);
    printf("Client: Pipe sender thread finished. Signaling producers might be needed if implementing termination.\n");
    // In a real scenario, you might need a signal mechanism to stop producers gracefully.

    // --- Cleanup ---
    printf("Client cleaning up...\n");
    close(pipe_fd); // Close the pipe
    sem_destroy(&filled_slots);
    sem_destroy(&empty_slots);
    pthread_mutex_destroy(&mutex);

    printf("Client finished.\n");
    return 0;
}

// --- Negative Exponential Delay Function ---
double neg_exp_delay(double lambda) {
    double u;
    // drand48() returns a value in [0.0, 1.0)
    u = drand48();
    // Avoid log(0) issues, though u=1.0 is highly unlikely with drand48
    if (u >= 1.0) u = 0.9999999;
    if (u <= 0.0) u = 0.0000001; // Avoid log(1) issues slightly more robustly
    return -log(1.0 - u) / lambda; // Delay in seconds
}

// --- Producer Thread Function ---
void *producer_thread(void *arg) {
    producer_args_t *args = (producer_args_t *)arg;
    int producer_id = args->id;
    pid_t pid = getpid();
    pthread_t tid = pthread_self(); // Get own thread ID

    printf("Producer Thread %d (PID: %d, TID: %lu) started.\n", producer_id, pid, (unsigned long)tid);

    while (1) { // Run indefinitely (or until pipe error stops sender)
        // 1. Generate random data
        int data = rand() % 1000; // Simple random integer data

        // 2. Simulate production time (negative exponential delay)
        double delay_sec = neg_exp_delay(lambda_c);
        usleep((useconds_t)(delay_sec * 1000000.0));

        // 3. Wait for an empty slot in the buffer
        if (sem_wait(&empty_slots) != 0) {
             if (errno == EINTR) continue; // Interrupted by signal, retry
             perror("Producer: sem_wait(empty_slots) failed");
             break; // Exit loop on semaphore error
        }

        // 4. Acquire mutex to access the buffer
        pthread_mutex_lock(&mutex);

        // 5. Put data into the buffer
        buffer[buffer_index_put] = data;
        int item_index = buffer_index_put; // Store index before updating
        buffer_index_put = (buffer_index_put + 1) % BUFFER_SIZE;

        // 6. Release mutex
        pthread_mutex_unlock(&mutex);

        // 7. Signal that a slot is now filled
        if (sem_post(&filled_slots) != 0) {
            perror("Producer: sem_post(filled_slots) failed");
             // Attempt to recover? Maybe just log and continue/exit?
            break;
        }


        // 8. Print information
        printf("Client PID: %d, Producer TID: %lu, Produced: %d (at buffer index %d)\n",
               pid, (unsigned long)tid, data, item_index);
    }

    printf("Producer Thread %d (PID: %d, TID: %lu) exiting.\n", producer_id, pid, (unsigned long)tid);
    pthread_exit(NULL);
}

// --- Pipe Sender Thread Function ---
void *pipe_sender_thread(void *arg) {
    (void)arg; // Indicate arg is intentionally unused
    pid_t pid = getpid();
    pthread_t tid = pthread_self();

    printf("Pipe Sender Thread (PID: %d, TID: %lu) started.\n", pid, (unsigned long)tid);

    while (1) {
        // 1. Wait for a filled slot in the buffer
        if (sem_wait(&filled_slots) != 0) {
            if (errno == EINTR) continue; // Interrupted by signal, retry
            perror("Pipe Sender: sem_wait(filled_slots) failed");
            break; // Exit loop on semaphore error
        }

        // 2. Acquire mutex to access the buffer
        pthread_mutex_lock(&mutex);

        // 3. Get data from the buffer
        int data = buffer[buffer_index_get];
        buffer_index_get = (buffer_index_get + 1) % BUFFER_SIZE;

        // 4. Release mutex
        pthread_mutex_unlock(&mutex);

        // 5. Signal that a slot is now empty
        if (sem_post(&empty_slots) != 0) {
            perror("Pipe Sender: sem_post(empty_slots) failed");
            // Consider how to handle this - might lead to deadlock if ignored
            break;
        }

        // 6. Write data to the pipe
        ssize_t bytes_written = write(pipe_fd, &data, sizeof(data));
        if (bytes_written == -1) {
            if (errno == EPIPE) {
                fprintf(stderr, "Pipe Sender: Detected broken pipe (Server likely closed). Exiting.\n");
            } else {
                perror("Pipe Sender: Error writing to pipe");
            }
            break; // Exit loop on write error or broken pipe
        } else if (bytes_written < (ssize_t)sizeof(data)) {
             fprintf(stderr, "Pipe Sender: Partial write occurred (%zd bytes). Exiting (simplification).\n", bytes_written);
             break; // Handle partial writes appropriately in production code
        }

        // Optional: Print confirmation
        // printf("Pipe Sender: Sent %d (from buffer index %d) to server.\n", data, item_index);
    }

    printf("Pipe Sender Thread (PID: %d, TID: %lu) exiting.\n", pid, (unsigned long)tid);
    // Close pipe FD only once in main cleanup ideally, but could close here if certain.
    // Note: Closing pipe_fd here might cause issues if producers are still running and trying to add items.
    // A more robust shutdown involves signaling producers too.
    pthread_exit(NULL);
}