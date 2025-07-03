#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "syscall.h" // 确保包含 syscall.h 以便使用 SYS_ 定义// ... (其他 sys_ 函数) ...

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

// Implementation for the trace system call
uint64
sys_trace(void)
{
  int mask; // 用于存储从用户空间获取的 mask 参数
  struct proc *p = myproc(); // 获取当前进程的 proc 结构体指针

  // 从系统调用参数中获取第一个整数参数 (index 0)
  // 并将其存储在局部变量 mask 中
  if(argint(0, &mask) < 0) {
    // 如果获取参数失败，返回 -1 表示错误
    return -1;
  }

  // 将获取到的 mask 存储到当前进程的 tracemask 字段中
  p->tracemask = mask;

  // 系统调用成功，返回 0
  return 0;
}

uint64
sys_sigalarm(void) // <--- 重命名为 sys_sigalarm
{
  int ticks_from_user_arg;
  uint64 handler_va_from_user_arg;
  struct proc *p = myproc();

  if(argint(0, &ticks_from_user_arg) < 0) {
    return -1;
  }
  argaddr(1, &handler_va_from_user_arg);

  acquire(&p->lock);
  p->alarmticks = ticks_from_user_arg;
  p->user_alarm_handler_va = handler_va_from_user_arg;

  if (ticks_from_user_arg > 0) {
    p->curticks = 0;
  } else {
    p->alarmticks = 0;
    p->curticks = 0;
  }
  release(&p->lock);

  return 0;
}

// sys_sigreturn 也需要确保 proc.h 中的字段名被正确使用
uint64
sys_sigreturn(void) {
    struct proc *p = myproc();
    uint64 original_a0_val;

    acquire(&p->lock);
    if (p->handling_alarm == 0) { // 使用 proc.h 中的 handling_alarm
        release(&p->lock);
        return -1;
    }

    // 使用 proc.h 中的 alarm_trapframe_backup
    memmove(p->trapframe, &p->alarm_trapframe_backup, sizeof(struct trapframe));
    original_a0_val = p->trapframe->a0;
    p->handling_alarm = 0;
    // curticks 在 trap.c 中当闹钟触发时已经重置
    release(&p->lock);
    return original_a0_val;
}