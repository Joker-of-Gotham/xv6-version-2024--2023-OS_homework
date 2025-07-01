#include "common.h"

// 传递给生产者线程的参数结构体
typedef struct {
    int thread_idx;       // 线程的逻辑索引（非tid）
    double lambda_c;      // 负指数分布的λ参数
    int pipe_write_fd;    // 内部匿名管道的写端
} producer_args_t;

// 生产者线程函数
void* producer_thread_func(void* args) {
    producer_args_t* p_args = (producer_args_t*)args;
    struct message msg;
    uint32_t seq_num = 0;

    // 确保每个线程有不同的随机数种子
    srand(time(NULL) ^ (unsigned int)pthread_self());

    printf("生产者线程 #%d (TID: %lu) 已启动。\n", p_args->thread_idx, (unsigned long)pthread_self());

    while (1) {
        // 1. 构造消息
        msg.src_tid = (uint64_t)pthread_self();
        msg.seq = seq_num++;
        memset(msg.payload, 0, MSG_PAYLOAD_SIZE);
        
        // 2. 计算并设置校验和
        msg.checksum = calculate_checksum(&msg);

        // 3. 将消息完整地写入内部管道
        if (write_all(p_args->pipe_write_fd, &msg, MSG_SIZE) != MSG_SIZE) {
            perror("生产者无法写入内部管道");
            break; 
        }

        // 4. 计算并等待一个负指数分布的时间间隔
        double u = (double)rand() / RAND_MAX; // 产生[0, 1]范围的随机数
        if (u == 0.0) u = 1e-9; // 避免log(0)
        double sleep_time_sec = -log(u) / p_args->lambda_c;
        usleep((useconds_t)(sleep_time_sec * 1000000));
    }
    
    free(p_args);
    return NULL;
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "用法: %s <线程数> <lambda_c>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    int n_threads = atoi(argv[1]);
    double lambda_c = atof(argv[2]);

    if (n_threads <= 0 || lambda_c <= 0.0) {
        fprintf(stderr, "线程数和lambda_c必须为正数。\n");
        exit(EXIT_FAILURE);
    }

    // 1. 创建用于线程和主进程通信的匿名管道
    int internal_pipe[2];
    if (pipe(internal_pipe) == -1) error_exit("pipe");

    // 2. 打开到服务器的命名管道 (FIFO)
    printf("Client: 等待Server打开FIFO...\n");
    int fifo_fd = open(FIFO_PATH, O_WRONLY);
    if (fifo_fd == -1) error_exit("打开FIFO失败");
    printf("Client: FIFO已连接。正在启动生产者线程。\n");

    // 3. 创建 n 个生产者线程
    pthread_t threads[n_threads];
    for (int i = 0; i < n_threads; ++i) {
        producer_args_t* args = malloc(sizeof(producer_args_t));
        if (!args) error_exit("malloc");
        args->thread_idx = i + 1;
        args->lambda_c = lambda_c;
        args->pipe_write_fd = internal_pipe[1];

        if (pthread_create(&threads[i], NULL, producer_thread_func, args) != 0) {
            error_exit("pthread_create");
        }
    }

    // 4. Client 主线程循环：从内部管道读取，并写入命名管道
    struct message received_msg;
    printf("Client主线程: 准备转发消息到Server。\n");
    while (1) {
        // 从内部管道读取一个完整的消息（阻塞）
        ssize_t bytes_read = read(internal_pipe[0], &received_msg, MSG_SIZE);
        if (bytes_read == 0) {
            printf("Client主线程: 内部管道已关闭，正在退出。\n");
            break;
        }
        if (bytes_read < 0) {
            perror("从内部管道读取失败");
            break;
        }
        if (bytes_read != MSG_SIZE) {
             fprintf(stderr, "Client主线程: 从内部管道收到不完整的消息，已忽略。\n");
             continue;
        }

        // 将消息同步写入到命名管道
        if (write_all(fifo_fd, &received_msg, MSG_SIZE) != MSG_SIZE) {
            // 如果管道断开 (EPIPE)，说明服务器已关闭
            if (errno == EPIPE) {
                fprintf(stderr, "错误: Server已关闭管道。正在退出。\n");
            } else {
                perror("写入FIFO失败");
            }
            break;
        }
    }

    // 清理
    printf("Client正在关闭。\n");
    close(fifo_fd);
    close(internal_pipe[0]);
    close(internal_pipe[1]);
    // 在一个真实的应用中，需要有机制来优雅地停止所有生产者线程。
    // 这里我们允许它们随主进程的退出而终止。
    exit(0);
}