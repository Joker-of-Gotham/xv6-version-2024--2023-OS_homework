#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "syscall.h"
#include "defs.h"

// Fetch the uint64 at addr from the current process.
int
fetchaddr(uint64 addr, uint64 *ip)
{
  struct proc *p = myproc();
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    return -1;
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    return -1;
  return 0;
}

// Fetch the nul-terminated string at addr from the current process.
// Returns length of string, not including nul, or -1 for error.
int
fetchstr(uint64 addr, char *buf, int max)
{
  struct proc *p = myproc();
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    return -1;
  return strlen(buf);
}

static uint64
argraw(int n)
{
  struct proc *p = myproc();
  switch (n) {
  case 0:
    return p->trapframe->a0;
  case 1:
    return p->trapframe->a1;
  case 2:
    return p->trapframe->a2;
  case 3:
    return p->trapframe->a3;
  case 4:
    return p->trapframe->a4;
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  *ip = argraw(n);

  return 0; // <--- 添加这行，明确返回 0 表示成功
}

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int // <--- 修改返回类型为 int
argaddr(int n, uint64 *ip)
{
  *ip = argraw(n);
  // 如果 argraw 本身不进行错误检查并可能 panic，
  // 那么 argaddr 自身可能无法检测到很多错误。
  // 但为了与 if (argaddr(...) < 0) 的模式兼容，它应该返回 0。
  // 如果 argraw 失败会 panic，那么这个返回值其实不太会被检查到失败路径。
  // 但如果 argraw 将来可能返回错误，或者为了接口一致性，返回 int 是好的。
  return 0; // 表示成功获取了原始值
}

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
}

// Prototypes for the functions that handle system calls.
extern uint64 sys_fork(void);
extern uint64 sys_exit(void);
extern uint64 sys_wait(void);
extern uint64 sys_pipe(void);
extern uint64 sys_read(void);
extern uint64 sys_kill(void);
extern uint64 sys_exec(void);
extern uint64 sys_fstat(void);
extern uint64 sys_chdir(void);
extern uint64 sys_dup(void);
extern uint64 sys_getpid(void);
extern uint64 sys_sbrk(void);
extern uint64 sys_sleep(void);
extern uint64 sys_uptime(void);
extern uint64 sys_open(void);
extern uint64 sys_write(void);
extern uint64 sys_mknod(void);
extern uint64 sys_unlink(void);
extern uint64 sys_link(void);
extern uint64 sys_mkdir(void);
extern uint64 sys_close(void);
extern uint64 sys_kpgtbl(void); // 声明
extern uint64 sys_ntas(void); // 声明 ntas 处理函数
extern uint64 sys_statistics(void);
extern uint64 sys_reset_stats(void);
extern uint64 sys_resetlockstats(void);
extern uint64 sys_getlockstats(void);
extern uint64 sys_pgpte(void);
extern uint64 sys_ugetpid(void);
extern uint64 sys_pgaccess(void);

// An array mapping syscall numbers from syscall.h
// to the function that handles the system call.
static uint64 (*syscalls[])(void) = {
[SYS_pgaccess]  sys_pgaccess,
[SYS_ugetpid]   sys_ugetpid,
[SYS_pgpte]    sys_pgpte, // 添加这行
[SYS_resetlockstats] sys_resetlockstats,
[SYS_getlockstats]   sys_getlockstats,
[SYS_statistics] sys_statistics,
[SYS_reset_stats] sys_reset_stats,
[SYS_kpgtbl]   sys_kpgtbl,
[SYS_fork]    sys_fork,
[SYS_exit]    sys_exit,
[SYS_wait]    sys_wait,
[SYS_pipe]    sys_pipe,
[SYS_read]    sys_read,
[SYS_kill]    sys_kill,
[SYS_exec]    sys_exec,
[SYS_fstat]   sys_fstat,
[SYS_chdir]   sys_chdir,
[SYS_dup]     sys_dup,
[SYS_getpid]  sys_getpid,
[SYS_sbrk]    sys_sbrk,
[SYS_sleep]   sys_sleep,
[SYS_uptime]  sys_uptime,
[SYS_open]    sys_open,
[SYS_write]   sys_write,
[SYS_mknod]   sys_mknod,
[SYS_unlink]  sys_unlink,
[SYS_link]    sys_link,
[SYS_mkdir]   sys_mkdir,
[SYS_close]   sys_close,
[SYS_trace]   sys_trace, // <--- 添加这一行
};

// 添加一个 syscall 名称数组 (后面打印时会用到)
static char *syscall_names[] = {
  [SYS_fork]    "fork",
  [SYS_exit]    "exit",
  [SYS_wait]    "wait",
  [SYS_pipe]    "pipe",
  [SYS_read]    "read",
  [SYS_kill]    "kill",
  [SYS_exec]    "exec",
  [SYS_fstat]   "fstat",
  [SYS_chdir]   "chdir",
  [SYS_dup]     "dup",
  [SYS_getpid]  "getpid",
  [SYS_sbrk]    "sbrk",
  [SYS_sleep]   "sleep",
  [SYS_uptime]  "uptime",
  [SYS_open]    "open",
  [SYS_write]   "write",
  [SYS_mknod]   "mknod",
  [SYS_unlink]  "unlink",
  [SYS_link]    "link",
  [SYS_mkdir]   "mkdir",
  [SYS_close]   "close",
  [SYS_trace]   "trace", // <--- 添加 trace 的名称
  };

void
syscall(void)
{
  int num;
  struct proc *p = myproc();

  //start test
  // printf("NELEM(syscalls) = %lu\n", NELEM(syscalls)); // <--- 将 %d 改为 %lu

  num = p->trapframe->a7;

  // printf("syscall num = %d\n", num); // 打印 num 用 %d 是对的 (假设 num 是 int)
  // printf("syscalls[SYS_fork]: %p\n", syscalls[SYS_fork]);
  // printf("syscalls[SYS_exec]: %p\n", syscalls[SYS_exec]);
  // printf("syscalls[SYS_write]: %p\n", syscalls[SYS_write]);
  // printf("syscalls[SYS_trace]: %p\n", syscalls[SYS_trace]); // 打印地址用 %p
  // end test

  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();

    // ---- 添加追踪逻辑 ----
    // 检查当前进程的 tracemask 中是否设置了对应系统调用号的位
    // (1 << num) 创建一个只有第 num 位为 1 的掩码
    if ((p->tracemask & (1 << num))) {
         // 检查 syscall_names 数组是否有效，避免越界或访问空指针
         if (num > 0 && num < NELEM(syscall_names) && syscall_names[num]) {
              // 在 syscall() 函数的追踪逻辑部分
              printf("%d: syscall %s -> %lu\n", p->pid, syscall_names[num], p->trapframe->a0);
         }
    // ---- 追踪逻辑结束 ----
  }
  } else {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    p->trapframe->a0 = -1;
  }
}