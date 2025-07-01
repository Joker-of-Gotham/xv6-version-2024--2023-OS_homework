#ifndef COMMON_H
#define COMMON_H

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <pthread.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <time.h>
#include <math.h>
#include <errno.h>
#include <stdint.h> // 使用定长类型，保证跨平台一致性
#include <signal.h> // 用于信号处理

// 命名管道的路径
#define FIFO_PATH "/tmp/cs_fifo_project"

// 消息负载大小
#define MSG_PAYLOAD_SIZE 4096

// 定义消息结构
// 使用 __attribute__((packed)) 确保结构体成员之间没有填充字节，避免因对齐导致的大小问题
struct message {
    uint32_t checksum; // 校验和，用于保证消息完整性
    uint64_t src_tid;  // 线程ID (pthread_t 在64位系统上是8字节)
    uint32_t seq;      // 序列号
    char payload[MSG_PAYLOAD_SIZE];
};

#define MSG_SIZE sizeof(struct message)

// 统一的错误处理函数
static inline void error_exit(const char *msg) {
    perror(msg);
    exit(EXIT_FAILURE);
}

/**
 * @brief 计算消息的校验和.
 * 这是一个简单的累加和校验，易于实现. 实际应用可用CRC32.
 * @param msg 指向消息的指针.
 * @return 32位的校验和.
 */
static inline uint32_t calculate_checksum(const struct message* msg) {
    uint32_t sum = 0;
    // 对tid和seq进行计算
    const uint32_t* p = (const uint32_t*)&(msg->src_tid);
    sum += p[0];
    sum += p[1];
    sum += msg->seq;
    // 对payload进行计算
    for (int i = 0; i < MSG_PAYLOAD_SIZE; ++i) {
        sum += msg->payload[i];
    }
    return sum;
}

/**
 * @brief 保证将所有数据写入文件描述符.
 * 处理 write() 可能发生的“部分写入”或被信号中断(EINTR)的情况.
 * @param fd 文件描述符.
 * @param buf 数据缓冲区.
 * @param count 要写入的字节数.
 * @return 成功返回写入的字节数(count), 失败返回-1.
 */
static inline ssize_t write_all(int fd, const void* buf, size_t count) {
    size_t bytes_written = 0;
    const char* ptr = (const char*)buf;
    while (bytes_written < count) {
        ssize_t result = write(fd, ptr + bytes_written, count - bytes_written);
        if (result < 0) {
            // 如果是被信号中断，则继续尝试写入
            if (errno == EINTR) {
                continue;
            }
            // 其他错误则返回失败
            return -1;
        }
        bytes_written += result;
    }
    return bytes_written;
}

#endif // COMMON_H