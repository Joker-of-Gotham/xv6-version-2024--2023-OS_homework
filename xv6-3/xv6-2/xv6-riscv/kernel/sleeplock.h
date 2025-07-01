// kernel/sleeplock.h
#ifndef __SLEEPLOCK_H__  // <-- 添加这一行
#define __SLEEPLOCK_H__  // <-- 添加这一行

// Long-term locks for processes
struct sleeplock {
  uint locked;       // Is the lock held?
  struct spinlock lk; // spinlock protecting this sleep lock
  
  // For debugging:
  char *name;        // Name of lock.
  int pid;           // Process holding lock
};

#endif // __SLEEPLOCK_H__ // <-- 添加这一行