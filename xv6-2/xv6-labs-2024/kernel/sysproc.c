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

// uint64
// sys_sbrk(void)
// {
//   uint64 addr;
//   int n;

//   argint(0, &n);
//   addr = myproc()->sz;
//   if(growproc(n) < 0)
//     return -1;
//   return addr;
// }

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;
  struct proc *p = myproc();

  if(argint(0, &n) < 0)
    return -1;
  
  addr = p->sz; // sbrk returns old size
  if(growproc(n) < 0) // growproc now returns new size on success, or -1 on error
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

// Implementation for the sys_kpgtbl
uint64
sys_kpgtbl(void)
{
  struct proc *p = myproc(); // 获取当前进程
  if (p == 0 || p->pagetable == 0) { // 基本完整性检查
    return -1; // 错误
  }
  vmprint(p->pagetable); // 调用vmprint函数打印当前进程的页表
  return 0; // 成功
}

// 假设 kalloc.c 中定义了这些函数和变量
extern void reset_lock_stats(void); // 重置所有相关锁的统计
extern int  report_lock_stats(void);  // 报告kmem相关锁的竞争总数

uint64
sys_reset_stats(void)
{
  reset_all_lock_stats_kernel();
  return 0; // 成功
}

// 从 spinlock.c 中 extern 这些
extern struct spinlock *all_registered_locks[MAX_LOCKS];
extern int num_registered_locks;
extern struct spinlock all_locks_list_lock;

// 系统调用: 重置所有锁的统计数据
uint64
sys_resetlockstats(void) // kalloctest.c 会调用 resetlockstats()
{
  reset_all_lock_stats_kernel(); // 调用 spinlock.c 中的内核函数
  return 0;
}

// System call to get lock statistics as a formatted string
uint64
sys_statistics(void) // 对应 kalloctest.c 的 statistics(buf, sz)
{
  char kernel_buf[128]; // 内核临时缓冲区
  uint64 user_buf_addr;
  int user_buf_size;
  int len;
  struct proc *p = myproc();

  if(argaddr(0, &user_buf_addr) < 0 || argint(1, &user_buf_size) < 0) {
    return -1;
  }

  if(user_buf_size <= 0) { // 基本的无效大小检查
    return -1;
  }
  // 确保内核缓冲区大小不会导致问题，但这里kernel_buf是固定的
  // 实际复制长度由 report_kmem_bcache_spins_formatted 返回

  len = report_kmem_bcache_spins_formatted(kernel_buf, sizeof(kernel_buf));

  if (len < 0) { // 格式化出错或内部缓冲区不足
    return -1;
  }
  if (len + 1 > user_buf_size) { // +1 for null terminator,检查用户缓冲区是否足够
    return -1; 
  }

  if (copyout(p->pagetable, user_buf_addr, kernel_buf, len + 1) < 0) { // 复制 len+1 字节 (包括 \0)
    return -1;
  }

  return len; // 返回实际写入用户缓冲区的字节数 (不包括 \0)
}

// 内核端与用户空间交互的结构体，确保与 user/user.h 中的定义匹配
// (可以放在 defs.h 或一个共享的头文件中)
// #ifndef KERNEL_LOCK_STATS_STRUCT_DEF // 避免在多个地方重复定义
// #define KERNEL_LOCK_STATS_STRUCT_DEF
// #define LOCKNAME_MAX_LEN_SHARED 32 // 与用户端一致
// struct lock_stat_entry_shared {
//   char name[LOCKNAME_MAX_LEN_SHARED];
//   unsigned int acquire_count;
//   unsigned int tas_spins;
// };
// #endif


// 系统调用: 获取所有已注册锁的详细统计信息
// kalloctest.c 的 ntas() 函数内部会调用名为 statistics() 的 syscall stub,
// 我们将 SYS_statistics 映射到这个 sys_getlockstats 实现。
// 或者，你可以将此函数重命名为 sys_statistics 并更新 syscall.h/c。
// 为了清晰，我们用 sys_getlockstats，并假设 kalloctest.c 会调用 getlockstats() 这个 stub。
// 如果 kalloctest.c 坚持调用 statistics() stub，那么你需要将此函数命名为 sys_statistics。
// 让我们假设 kalloctest.c 将调用 getlockstats() 这个存根。
uint64
sys_getlockstats(void)
{
  uint64 user_buf_addr;
  int max_user_entries;
  struct proc *p = myproc();
  int copied_count = 0;
  // struct lock_stat_entry_kernel k_entry_buf[MAX_LOCKS]; // <--- 不再在栈上分配大数组

  if (argaddr(0, &user_buf_addr) < 0 || argint(1, &max_user_entries) < 0) {
    return -1;
  }

  if (max_user_entries <= 0) {
    return 0;
  }

  acquire(&all_locks_list_meta_lock); // 保护全局锁列表

  for (int i = 0; i < num_registered_locks && copied_count < max_user_entries; i++) {
    struct spinlock *lk = all_registered_locks[i];
    
    // 只处理有效且有名字的锁
    if (lk != 0 && lk->name != 0 && strlen(lk->name) > 0) {
        struct lock_stat_entry_kernel current_kernel_entry; // 在栈上分配一个*单个*条目的空间

        safestrcpy(current_kernel_entry.name, lk->name, LOCKNAME_MAX_LEN);
        current_kernel_entry.acquire_count = lk->acquire_count;
        current_kernel_entry.tas_spins = lk->tas_spins;

        // 将这个单个条目复制到用户空间数组的下一个位置
        if (copyout(p->pagetable,
                    user_buf_addr + copied_count * sizeof(struct lock_stat_entry_kernel), // 注意这里的类型大小
                    (char *)&current_kernel_entry,
                    sizeof(struct lock_stat_entry_kernel)) < 0) {
          // 如果 copyout 失败，可能用户地址无效或页表问题
          // 此时已经获取了 all_locks_list_meta_lock，需要释放它
          release(&all_locks_list_meta_lock);
          return -1; // 返回错误
        }
        copied_count++; // 成功复制一个条目
    }
  }
  release(&all_locks_list_meta_lock);
  return copied_count; // 返回实际复制到用户空间的条目数量
}

uint64
sys_pgpte(void)
{
  uint64 va;
  // pte_t *pte; // 原来可能是这样，或者你是用了 walk_info_t winfo;
  pte_t *pte_ptr; // <--- 将接收 walk 返回值的变量类型改为 pte_t*
  struct proc *p = myproc();

  if (argaddr(0, &va) < 0)
    return 0; 

  if (va >= MAXVA)
    return 0;

  acquire(&p->lock);
  pte_ptr = walk(p->pagetable, va, 0); // walk 现在返回 pte_t*
  release(&p->lock);

  if (pte_ptr == 0 || !(*pte_ptr & PTE_V)) // 检查指针是否为NULL以及PTE是否有效
    return 0; 

  return *pte_ptr; // 返回PTE的值
}

uint64
sys_ugetpid(void)
{
  struct proc *p = myproc();
  if (p == 0) // 基本检查，虽然myproc()在正常情况下不应返回0
    return -1; // 或者panic，取决于错误处理策略
  return p->pid;
}

uint64
sys_pgaccess(void)
{
  uint64 base_va; 
  int len;        
  uint64 mask_addr; 
  struct proc *p = myproc();
  unsigned int access_mask = 0;
  int pte_a_was_cleared = 0; // 标志位，记录是否有PTE_A被清除

  if (argaddr(0, &base_va) < 0 || argint(1, &len) < 0 || argaddr(2, &mask_addr) < 0) {
    return -1;
  }

  if (len <= 0 || len > (sizeof(access_mask) * 8) ) { // 确保len不超过掩码的位数
      return -1;
  }
  // 进一步的VA范围检查可以添加在这里，确保 base_va + len*PGSIZE 不会溢出或超过MAXVA

  acquire(&p->lock);

  for (int i = 0; i < len; i++) {
    uint64 current_va = base_va + (uint64)i * PGSIZE;
    if (current_va >= MAXVA) { // 增加对current_va的边界检查
        // 或者在这里跳出循环，或者返回错误，取决于具体需求
        // 为简单起见，如果超出范围，我们可能不应该继续
        break; 
    }

    // walk_info_t winfo = walk(p->pagetable, current_va, 0); // 旧的，错误的
    pte_t *pte_ptr = walk(p->pagetable, current_va, 0); // <--- 修改这里，接收 pte_t*

    // printf("sys_pgaccess: i=%d, va=0x%lx, pte_ptr=0x%p", i, current_va, pte_ptr); // DEBUG
    if (pte_ptr != 0 && (*pte_ptr & PTE_V) && (*pte_ptr & PTE_U)) {
      // printf(", pte_val=0x%lx", *pte_ptr); // DEBUG
      if (*pte_ptr & PTE_A) {
        // printf(", PTE_A is SET\n"); // DEBUG
        access_mask |= (1U << i); // 使用 1U 确保是无符号移位
        // 根据实验指导决定是否清除PTE_A
        // *pte_ptr &= ~PTE_A; 
        // if(*pte_ptr &= ~PTE_A) pte_a_was_cleared = 1; // 如果清除了，设置标志
      } else {
        // printf(", PTE_A is CLEAR\n"); // DEBUG
      }
    } else {
      // printf(", pte invalid or not user accessible or walk failed\n"); // DEBUG
    }
  }

  if (pte_a_was_cleared) {
      sfence_vma(); // 如果清除了任何PTE_A位，刷新TLB
  }
  release(&p->lock);

  // printf("sys_pgaccess: final access_mask (kernel) = 0x%x\n", access_mask); // DEBUG
  if (copyout(p->pagetable, mask_addr, (char *)&access_mask, sizeof(access_mask)) < 0) {
    // printf("sys_pgaccess: copyout failed!\n"); //DEBUG
    return -1;
  }

  return 0; // 成功
}