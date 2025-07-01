#ifndef __SPINLOCK_H__   // <-- 添加这一行
#define __SPINLOCK_H__   // <-- 添加这一行

// Mutual exclusion lock.
struct spinlock {
  uint locked;       // Is the lock held?

  // For debugging:
  char *name;        // Name of lock.
  struct cpu *cpu;   // The cpu holding the lock.
};

#endif // __SPINLOCK_H__ // <-- 添加这一行