#include "/home/liuzhh268/Operating_System_Homework/xv6/xv6-labs-2024/kernel/types.h"
#include "/home/liuzhh268/Operating_System_Homework/xv6/xv6-labs-2024/kernel/stat.h"
#include "/home/liuzhh268/Operating_System_Homework/xv6/xv6-labs-2024/user/user.h"

int
main(int argc, char *argv[])
{
  printf("kpgtbltest: main started.\n"); // 1
  int ret = kpgtbl();
  printf("kpgtbltest: kpgtbl() returned %d.\n", ret); // 2
  if(ret < 0){
    printf("kpgtbltest: kpgtbl() call explicitly failed.\n"); // 3
  }
  printf("kpgtbltest: main finishing.\n"); // 4
  exit(0);
}