// kernel/spinlock.c

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "proc.h"
#include "defs.h" // For printf, panic, k_itoa, strlen, memmove

// ------------ Global Lock List for Statistics ------------
struct spinlock *all_registered_locks[MAX_LOCKS]; // static 使其只在本文件可见
int num_registered_locks = 0;                     // static
struct spinlock all_locks_list_meta_lock;         // static, 元锁

// 初始化锁列表和其保护锁，在 main() 中早期调用
void
lockstatsinit(void)
{
  // 直接初始化元锁字段，避免调用 initlock 导致递归注册
  all_locks_list_meta_lock.name = "all_locks_meta"; // 简短且唯一的名称
  all_locks_list_meta_lock.locked = 0;
  all_locks_list_meta_lock.cpu = 0;
  all_locks_list_meta_lock.acquire_count = 0;
  all_locks_list_meta_lock.tas_spins = 0;
  // 元锁自身不加入 all_registered_locks 列表，因为它不应该被用户统计
  num_registered_locks = 0;
}

// 内部函数，将锁注册到全局列表
static void // static, 因为只被 initlock 调用
register_lock_to_list(struct spinlock *lk)
{
  acquire(&all_locks_list_meta_lock);

  int found = 0;
  for (int i = 0; i < num_registered_locks; i++) {
    if (all_registered_locks[i] == lk) {
      found = 1;
      break;
    }
  }

  if (!found) {
    if (num_registered_locks < MAX_LOCKS) {
      all_registered_locks[num_registered_locks++] = lk;
    } else {
      // 如果锁太多，可以选择 panic 或静默失败
      // printf("register_lock_to_list: too many locks, cannot register %s\n", lk->name);
    }
  }
  release(&all_locks_list_meta_lock);
}

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
  lk->locked = 0;
  lk->cpu = 0;
  lk->acquire_count = 0;
  lk->tas_spins = 0;

  // 只有在 lockstatsinit 完成后 (元锁有了名字) 才注册
  // 并且不注册元锁本身
  if (all_locks_list_meta_lock.name != 0 && lk != &all_locks_list_meta_lock) {
    register_lock_to_list(lk);
  }
}

void
acquire(struct spinlock *lk)
{
  lk->acquire_count++; // 记录尝试获取的次数

  push_off();
  if(holding(lk)) {
    struct cpu* c = mycpu();
    int hart_id = -1;
    if(c) hart_id = c - cpus;
    printf("acquire: hart %d already holding lock '%s'\n", hart_id, lk->name);
    panic("acquire");
  }

  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    lk->tas_spins++; // 记录旋转次数
  }
  __sync_synchronize();
  lk->cpu = mycpu();
}

void
release(struct spinlock *lk)
{
  if(!holding(lk)) {
    // struct cpu* c = mycpu();
    // int hart_id = -1;
    // if(c) hart_id = c - cpus;
    // printf("release: hart %d not holding lock '%s'\n", hart_id, lk->name);
    panic("release");
  }
  lk->cpu = 0;
  __sync_synchronize();
  __sync_lock_release(&lk->locked);
  pop_off();
}

int
holding(struct spinlock *lk)
{
  int r;
  struct cpu* c = mycpu();
  if (c == 0 && lk->locked != 0) { 
    // This case can happen if a lock is held and an NMI occurs on another CPU
    // that doesn't have a cpu struct yet, or very early boot.
    // For simplicity, if no cpu context, assume not holding.
    // A more robust check might be needed if locks are used before full CPU init.
    return 0; 
  }
  if (c == 0 && lk->locked == 0) return 0;
  r = (lk->locked && lk->cpu == c);
  return r;
}

void
push_off(void)
{
int old = intr_get();
intr_off();
if(mycpu()->noff == 0)
mycpu()->intena = old;
mycpu()->noff += 1;
}

void
pop_off(void)
{
struct cpu *c = mycpu();
if(intr_get())
panic("pop_off - interruptible");
if(c->noff < 1)
panic("pop_off");
c->noff -= 1;
if(c->noff == 0 && c->intena)
intr_on();
}


// --- 新的内核内部函数，供 sys_resetlockstats 和 sys_statistics 调用 ---
void
reset_all_lock_stats_kernel(void)
{
  acquire(&all_locks_list_meta_lock);
  for (int i = 0; i < num_registered_locks; i++) {
    if(all_registered_locks[i]) {
        all_registered_locks[i]->acquire_count = 0;
        all_registered_locks[i]->tas_spins = 0;
    }
  }
  release(&all_locks_list_meta_lock);
}

// 格式化所有锁的统计信息到一个缓冲区，返回实际写入的字符数 (不包括末尾的\0)
// 或者在出错时返回 -1。
// 这个函数需要 k_itoa, strlen, memmove。
// 为了简单起见，我们这里只关注 kmem 和 bcache 的 tas_spins 总和，
// 并以 kalloctest.c 的 ntas() 函数期望的简单格式输出。
// 如果要输出所有锁的详细列表，这个函数会复杂得多。
// 我们将实现一个只返回 "kmem_bcache_spins = TOTAL_SPINS\n" 的版本
// 以匹配 kalloctest.c 中 ntas() 的解析逻辑。
int
report_kmem_bcache_spins_formatted(char *buf, int bufsz)
{
  long long current_total_spins = 0; // 使用 long long 以防溢出
  char num_str[22];
  int num_len;
  int len = 0;
  char *prefix = "kmem_bcache_spins = "; // kalloctest.c 的 ntas 会找 '='
  int prefix_len = strlen(prefix);

  acquire(&all_locks_list_meta_lock);
  for (int i = 0; i < num_registered_locks; i++) {
    struct spinlock *lk = all_registered_locks[i];
    if (lk && lk->name) { // 确保锁和名字有效
      // 累加所有以 "kmem" 或 "bcache" 开头的锁的 tas_spins
      // 这包括了你优化后的 kmem_0, kmem_1 等
      if (strncmp(lk->name, "kmem", 4) == 0 || strncmp(lk->name, "bcache", 6) == 0) {
        current_total_spins += lk->tas_spins;
      }
    }
  }
  release(&all_locks_list_meta_lock);

  // 格式化输出字符串
  if (prefix_len >= bufsz - 12) return -1; // 检查前缀空间
  memmove(buf, prefix, prefix_len);
  len = prefix_len;

  num_len = k_itoa(current_total_spins, num_str, 10);
  if (len + num_len + 1 >= bufsz) return -1; // 检查数字和换行符空间 (+1 for '\n')
  memmove(buf + len, num_str, num_len);
  len += num_len;

  buf[len++] = '\n';
  buf[len] = '\0';

  return len; // 返回写入的字符数 (不包括最后的 \0)
}