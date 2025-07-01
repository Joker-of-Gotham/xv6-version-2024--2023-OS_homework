// Mutual exclusion lock.
// struct spinlock {
//   uint locked;       // Is the lock held?

//   // For debugging:
//   char *name;        // Name of lock.
//   struct cpu *cpu;   // The cpu holding the lock.
// };

// 将 struct spinlock 修改为:
struct spinlock {
  uint locked;       // 锁是否被持有?

  // 以下用于调试
  char *name;        // 锁的名称
  struct cpu *cpu;   // 持有该锁的CPU
};