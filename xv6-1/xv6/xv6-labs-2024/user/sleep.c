#include "/home/liuzhh268/Operating_System_Homework/xv6/xv6-labs-2024/kernel/types.h" // 包含 xv6 基本类型定义，如 uint
#include "user.h"   // 包含用户程序需要的接口声明，如 sleep(), atoi(), exit(), fprintf()

int main(int argc, char *argv[]) {
    int ticks; // 用于存储需要休眠的 ticks 数

    // 检查命令行参数数量是否正确
    // argc 应该是 2: 程序名本身 (argv[0]) 和 一个参数 (argv[1])
    if (argc != 2) {
        // 参数数量不对，向标准错误(文件描述符2)输出用法提示
        fprintf(2, "用法: sleep ticks\n");
        // 以非零状态码退出，表示程序出错
        exit(1);
    }

    // 将命令行参数（字符串）转换为整数
    // argv[1] 是第一个参数的字符串形式
    ticks = atoi(argv[1]);

    // （可选但推荐）检查转换后的 ticks 是否为正数
    // 如果 atoi 遇到非数字输入可能返回0，或者用户可能输入0或负数
    if (ticks <= 0) {
        fprintf(2, "sleep: 无效的时间间隔 '%s'\n", argv[1]);
        exit(1);
    }

    // 调用 xv6 的 sleep 系统调用
    // 这个 sleep() 是 user/user.h 中声明的用户态接口函数
    // 它会触发进入内核执行 sys_sleep
    sleep(ticks);

    // 程序成功完成，以状态码 0 退出
    exit(0);
}