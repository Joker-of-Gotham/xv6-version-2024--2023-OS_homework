// kernel/spinlock.h (或者 lockstatsdefs.h)
#ifndef XV6_SPINLOCK_H // 如果这是 spinlock.h
#define XV6_SPINLOCK_H

#include "types.h"

#define MAX_LOCKS 128          // 定义全局最大锁数量
#define LOCKNAME_MAX_LEN 32    // 定义锁名称最大长度 (与用户空间一致)

struct cpu; // 前向声明

struct spinlock {
  uint locked;
  char *name;
  struct cpu *cpu;
  uint acquire_count;
  uint tas_spins;
};

// 与用户空间交互的结构体 (可以在这里定义，或者在 defs.h)
struct lock_stat_entry_kernel { // 或者叫 _shared
  char name[LOCKNAME_MAX_LEN];
  unsigned int acquire_count;
  unsigned int tas_spins;
};

// 全局锁列表的 extern 声明 (在 spinlock.c 中定义)
extern struct spinlock *all_registered_locks[MAX_LOCKS]; // 现在 MAX_LOCKS 可见了
extern int num_registered_locks;
extern struct spinlock all_locks_list_meta_lock;

#endif // XV6_SPINLOCK_H