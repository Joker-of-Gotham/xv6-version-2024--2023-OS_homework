#include "/home/liuzhh268/Operating_System_Homework/xv6/xv6-labs-2024/kernel/types.h"
#include "/home/liuzhh268/Operating_System_Homework/xv6/xv6-labs-2024/kernel/stat.h"
#include "user.h"
#include "/home/liuzhh268/Operating_System_Homework/xv6/xv6-labs-2024/kernel/syscall.h" // 包含 SYS_ 定义
#include "/home/liuzhh268/Operating_System_Homework/xv6/xv6-labs-2024/kernel/param.h"

int
main(int argc, char *argv[])
{
  int i;
  char *nargv[MAXARG]; // 用于 exec 的新参数列表

  // 检查参数数量是否足够 (trace mask command [args...])
  if(argc < 3){
    fprintf(2, "用法: trace mask command [args...]\n");
    exit(1);
  }

  // 调用 trace 系统调用，设置追踪掩码
  // atoi 用于将字符串类型的掩码转换为整数
  if (trace(atoi(argv[1])) < 0) {
    fprintf(2, "trace: trace failed\n");
    exit(1);
  }

  // 准备 exec 的参数列表
  // nargv[0] 是要执行的命令 (argv[2])
  // nargv[1] 是命令的第一个参数 (argv[3])，依此类推
  for(i = 2; i < argc && i < MAXARG; i++){
    nargv[i-2] = argv[i];
  }
  nargv[i-2] = 0; // 参数列表以 null 指针结束

  // 执行目标命令
  exec(nargv[0], nargv);

  // 如果 exec 成功，则不会执行到这里
  // 如果 exec 失败，则打印错误并退出
  fprintf(2, "trace: exec %s failed\n", nargv[0]);
  exit(1);
}