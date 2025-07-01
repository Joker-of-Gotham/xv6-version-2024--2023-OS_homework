#include "common.h"
#include <sys/epoll.h>

#define MAX_EVENTS 10
#define READ_BUFFER_SIZE (MSG_SIZE * 10) // 缓冲区大小，可以缓存10条消息

// 使用 volatile sig_atomic_t 保证信号处理的原子性和可见性
volatile sig_atomic_t keep_running = 1;

void sigint_handler(int signum) {
    (void)signum;
    keep_running = 0;
}

int main() {
    // 注册信号处理器，用于优雅地关闭服务器 (Ctrl+C)
    signal(SIGINT, sigint_handler);
    signal(SIGTERM, sigint_handler);

    // 1. 创建命名管道 (FIFO)
    unlink(FIFO_PATH); // 如果已存在，先删除，避免旧问题
    if (mkfifo(FIFO_PATH, 0666) == -1) error_exit("mkfifo");

    // 2. 以非阻塞方式打开 FIFO
    printf("Server: 等待Client连接...\n");
    int fifo_fd = open(FIFO_PATH, O_RDONLY | O_NONBLOCK);
    if (fifo_fd == -1) error_exit("打开FIFO失败");
    // 此处不会阻塞，即使Client没连接

    // 3. 打开用于写入数据的文件
    FILE* data_file = fopen("data.txt", "w");
    if (!data_file) error_exit("打开data.txt失败");
    // 设置为行缓冲，每写入一行（或缓冲区满）就刷新到OS
    setvbuf(data_file, NULL, _IOLBF, 0);

    // 4. 创建 epoll 实例
    int epoll_fd = epoll_create1(0);
    if (epoll_fd == -1) error_exit("epoll_create1");

    // 5. 将 fifo_fd 添加到 epoll 监听集合
    struct epoll_event event;
    event.events = EPOLLIN; // 监听读事件 (数据到达)
    event.data.fd = fifo_fd;
    if (epoll_ctl(epoll_fd, EPOLL_CTL_ADD, fifo_fd, &event) == -1) {
        error_exit("epoll_ctl");
    }

    // 6. 准备读缓冲区和事件数组
    char read_buffer[READ_BUFFER_SIZE];
    size_t buffer_len = 0;
    struct epoll_event events[MAX_EVENTS];
    
    long long total_msg_count = 0;

    printf("Server已启动。正在等待消息。按 Ctrl+C 退出。\n");

    // 7. 主事件循环
    while (keep_running) {
        int n_events = epoll_wait(epoll_fd, events, MAX_EVENTS, 200); // 等待200ms
        if (n_events < 0) {
            if (errno == EINTR) continue; // 被信号中断，正常现象
            error_exit("epoll_wait");
        }
        
        if (n_events == 0) {
            // epoll_wait超时，可以在这里做一些周期性任务
            // printf("No events in last 200ms...\n");
            continue;
        }

        // 我们只监听了一个fd，所以一定是fifo_fd
        if (events[0].data.fd == fifo_fd) {
            // a. 从管道读取数据到缓冲区
            while (1) {
                ssize_t bytes_read = read(fifo_fd, read_buffer + buffer_len, READ_BUFFER_SIZE - buffer_len);
                if (bytes_read > 0) {
                    buffer_len += bytes_read;
                } else if (bytes_read == 0) { // 客户端关闭了写端
                    printf("Server: Client已断开连接。\n");
                    keep_running = 0;
                    break;
                } else { // bytes_read < 0
                    if (errno == EAGAIN || errno == EWOULDBLOCK) {
                        // 数据已读完，可以跳出去处理缓冲区了
                        break;
                    }
                    perror("从FIFO读取失败");
                    keep_running = 0;
                    break;
                }
                if (buffer_len == READ_BUFFER_SIZE) {
                    fprintf(stderr, "Server: 读缓冲区已满！可能消息速率过高。\n");
                    break;
                }
            }

            // b. 循环处理缓冲区中的完整消息
            while (buffer_len >= MSG_SIZE) {
                struct message* msg = (struct message*)read_buffer;

                // 校验消息完整性
                uint32_t expected_checksum = msg->checksum;
                msg->checksum = 0; // 临时清零以计算
                uint32_t actual_checksum = calculate_checksum(msg);
                msg->checksum = expected_checksum; // 恢复

                if (expected_checksum == actual_checksum) {
                    // 提取 src_tid 和 seq，写入文件
                    fprintf(data_file, "TID: %lu, SEQ: %u\n", (unsigned long)msg->src_tid, msg->seq);
                    total_msg_count++;
                } else {
                    fprintf(stderr, "Server: 收到损坏的消息 (checksum mismatch)，已丢弃。\n");
                }

                // 从缓冲区移除已处理的消息
                buffer_len -= MSG_SIZE;
                memmove(read_buffer, read_buffer + MSG_SIZE, buffer_len);
            }
        }
    }

    // 8. 清理
    printf("\nServer正在关闭... 共处理了 %lld 条消息。\n", total_msg_count);
    fclose(data_file);
    close(fifo_fd);
    close(epoll_fd);
    unlink(FIFO_PATH); // 删除命名管道文件

    return 0;
}