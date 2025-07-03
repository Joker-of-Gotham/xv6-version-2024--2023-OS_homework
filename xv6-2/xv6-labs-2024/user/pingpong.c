#include "/home/liuzhh268/Operating_System_Homework/xv6/xv6-labs-2024/kernel/types.h"
#include "user.h"

int main(int argc, char *argv[]) {
    int p_to_c[2]; // 管道：父进程 -> 子进程 [0]读 [1]写
    int c_to_p[2]; // 管道：子进程 -> 父进程 [0]读 [1]写
    char buf[1];   // 用于传递字节的缓冲区
    int pid;

    // 创建第一个管道 (父 -> 子)
    if (pipe(p_to_c) < 0) {
        fprintf(2, "pingpong: pipe 创建失败\n");
        exit(1);
    }

    // 创建第二个管道 (子 -> 父)
    if (pipe(c_to_p) < 0) {
        fprintf(2, "pingpong: pipe 创建失败\n");
        // 关闭已创建的第一个管道的文件描述符
        close(p_to_c[0]);
        close(p_to_c[1]);
        exit(1);
    }

    // 创建子进程
    pid = fork();

    if (pid < 0) {
        fprintf(2, "pingpong: fork 失败\n");
        // 关闭所有已创建的管道文件描述符
        close(p_to_c[0]);
        close(p_to_c[1]);
        close(c_to_p[0]);
        close(c_to_p[1]);
        exit(1);
    }

    if (pid == 0) {
        // --- 子进程 ---
        // 关闭不需要的管道端口：父写端(p_to_c[1]) 和 子读端(c_to_p[0])
        close(p_to_c[1]);
        close(c_to_p[0]);

        // 从 父->子 管道读取一个字节
        if (read(p_to_c[0], buf, 1) != 1) {
            fprintf(2, "pingpong: 子进程 read 失败\n");
            close(p_to_c[0]); // 关闭剩余端口
            close(c_to_p[1]);
            exit(1);
        }

        // 打印 "received ping" 消息
        printf("%d: received ping\n", getpid());

        // 将接收到的字节写回 子->父 管道
        if (write(c_to_p[1], buf, 1) != 1) {
            fprintf(2, "pingpong: 子进程 write 失败\n");
            close(p_to_c[0]); // 关闭剩余端口
            close(c_to_p[1]);
            exit(1);
        }

        // 关闭使用完毕的端口
        close(p_to_c[0]);
        close(c_to_p[1]);

        // 子进程正常退出
        exit(0);

    } else {
        // --- 父进程 ---
        // 关闭不需要的管道端口：子读端(p_to_c[0]) 和 父写端(c_to_p[1])
        close(p_to_c[0]);
        close(c_to_p[1]);

        // 向 父->子 管道写入一个字节 (内容不重要，任意字符即可)
        buf[0] = 'X'; // 可以是任意字节
        if (write(p_to_c[1], buf, 1) != 1) {
            fprintf(2, "pingpong: 父进程 write 失败\n");
            close(p_to_c[1]); // 关闭剩余端口
            close(c_to_p[0]);
            wait(0); // 等待子进程结束（即使失败也尝试等待）
            exit(1);
        }

        // 从 子->父 管道读取一个字节
        if (read(c_to_p[0], buf, 1) != 1) {
            fprintf(2, "pingpong: 父进程 read 失败\n");
            close(p_to_c[1]); // 关闭剩余端口
            close(c_to_p[0]);
            wait(0); // 等待子进程结束
            exit(1);
        }

        // 打印 "received pong" 消息
        printf("%d: received pong\n", getpid());

        // 关闭使用完毕的端口
        close(p_to_c[1]);
        close(c_to_p[0]);

        // (可选) 等待子进程完全退出，确保资源回收
        wait(0);

        // 父进程正常退出
        exit(0);
    }
}