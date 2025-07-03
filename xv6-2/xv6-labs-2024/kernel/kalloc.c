// // kernel/kalloc.c (未优化版本 - 用于基线测试)

// #include "types.h"
// #include "param.h"
// #include "memlayout.h"
// #include "spinlock.h" // 确保这里定义的 struct spinlock 有 tas_spins 字段
// #include "riscv.h"
// #include "defs.h"

// void freerange(void *pa_start, void *pa_end);

// extern char end[]; // first address after kernel.
//                    // defined by kernel.ld.

// struct run {
//   struct run *next;
// };

// // 全局的 kmem 结构体，包含一个锁
// struct {
//   struct spinlock lock; // 这个 lock 结构体现在应该有 tas_spins 字段 (在 spinlock.h 中定义)
//   struct run *freelist;
// } kmem;

// void
// kinit()
// {
//   // initlock 会将 kmem.lock.tas_spins 初始化为 0 (假设你修改了 initlock)
//   initlock(&kmem.lock, "kmem"); // 使用全局锁，名称为 "kmem"
//   freerange(end, (void*)PHYSTOP);
// }

// void
// freerange(void *pa_start, void *pa_end)
// {
//   char *p;
//   p = (char*)PGROUNDUP((uint64)pa_start);
//   for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
//     kfree(p); // kfree 会使用全局的 kmem.lock
// }

// // Free the page of physical memory pointed at by v,
// // which normally should have been returned by a
// // call to kalloc().
// void
// kfree(void *pa)
// {
//   struct run *r;

//   if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
//     panic("kfree");

//   // Fill with junk to catch dangling refs.
//   memset(pa, 1, PGSIZE);

//   r = (struct run*)pa;

//   acquire(&kmem.lock); // 获取全局锁
//   r->next = kmem.freelist;
//   kmem.freelist = r;
//   release(&kmem.lock); // 释放全局锁
// }

// // Allocate one 4096-byte page of physical memory.
// // Returns a pointer that the kernel can use.
// // Returns 0 if the memory cannot be allocated.
// void *
// kalloc(void)
// {
//   struct run *r;

//   acquire(&kmem.lock); // 获取全局锁
//   r = kmem.freelist;
//   if(r)
//     kmem.freelist = r->next;
//   release(&kmem.lock); // 释放全局锁

//   if(r)
//     memset((char*)r, 5, PGSIZE); // fill with junk
//   return (void*)r;
// }

// // --- 针对未优化版本的统计函数 ---
// // 这些函数由 sys_ntas() 调用

// void
// reset_lock_stats(void)
// {
//   // 对于未优化版本，我们只关心全局的 kmem.lock
//   // 假设 acquire/release 自身不会递归调用这些统计函数
//   // 或者 ntas(0) 在一个没有锁竞争的时刻被调用
//   // 为了简单和与 kalloctest.c 的 ntas(0) 意图一致，直接重置。
//   // acquire(&kmem.lock); // 通常不应该锁住一个锁来修改它自己的统计字段
//   kmem.lock.tas_spins = 0;
//   // release(&kmem.lock);
// }

// int
// report_lock_stats(void)
// {
//   // 对于未优化版本，只报告全局 kmem.lock 的旋转次数
//   // acquire(&kmem.lock); // 同上，直接读取
//   int spins = kmem.lock.tas_spins;
//   // release(&kmem.lock);
//   return spins;
// }
// ------------------------------------------------------------------------------------
// In kernel/kalloc.c
// kernel/kalloc.c

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"    // For SUPERPGSIZE, NSUPERPG, SUPERPGROUNDDOWN, PHYSTOP, PGROUNDUP etc.
#include "defs.h"     // For printf, panic, memset, cpuid

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel. Defined by kernel.ld.

// --- Data structures for the 4KB page allocator ---
struct run {
  struct run *next;
};

// Per-CPU memory allocator structure for 4KB pages
struct kmem_cpu {
  struct spinlock lock;    // Lock protecting this CPU's freelist
  struct run *freelist;  // This CPU's list of free pages
  char name[16];         // Name for the lock, e.g., "kmem_0"
};

struct kmem_cpu kmems[NCPU]; // One instance per CPU

// --- Data structures for the Superpage (2MB) allocator ---
struct spinlock superlock;           // Global lock protecting superpages_status
char superpages_status[NSUPERPG];    // Status for each 2MB block (0: free, 1: used)
uint64 superpages_physaddr_start;  // Starting physical address of the first 2MB block
static int superpages_pool_active = 0; // Flag: 1 if superpage pool is successfully initialized

void
kinit(void)
{
  // Initialize locks for per-CPU 4KB allocators
  for (int i = 0; i < NCPU; i++) {
    // Manually construct lock name "kmem_X"
    // This is a bit verbose but avoids snprintf in this early stage.
    kmems[i].name[0] = 'k'; kmems[i].name[1] = 'm'; kmems[i].name[2] = 'e'; kmems[i].name[3] = 'm';
    kmems[i].name[4] = '_';
    if (i < 10) {
        kmems[i].name[5] = (char)('0' + i);
        kmems[i].name[6] = '\0';
    } else if (i < 100) { // Support up to NCPU=99, adjust if NCPU can be larger
        kmems[i].name[5] = (char)('0' + (i / 10));
        kmems[i].name[6] = (char)('0' + (i % 10));
        kmems[i].name[7] = '\0';
    } else {
        panic("kinit: NCPU too large for simple manual lock naming");
    }
    initlock(&kmems[i].lock, kmems[i].name);
    kmems[i].freelist = 0; // Initialize freelist
  }

  // Initialize lock for the superpage allocator
  initlock(&superlock, "superkmem");

  // Initialize superpage status array (all free)
  // No lock needed here yet as it's single-threaded during kinit's early phase
  // before other CPUs are fully up or interrupts enabled widely.
  for(int i = 0; i < NSUPERPG; i++) {
    superpages_status[i] = 0;
  }
  
  // --- Initialize Superpage Pool ---
  // This part needs to be done carefully before freerange for 4KB pages,
  // so freerange knows which memory is reserved for superpages.
  // No lock needed for 'superpages_pool_active' and 'superpages_physaddr_start'
  // during this initial setup as it's still single-threaded execution.
  // However, using the lock if other CPUs *could* theoretically access these early is safer.
  // For xv6 kinit, it's effectively single-threaded here.

  uint64 total_super_pool_size = (uint64)NSUPERPG * SUPERPGSIZE;
  
  // Attempt to place the superpage pool at the very top of usable physical memory,
  // ensuring it's 2MB aligned.
  uint64 potential_sp_start = SUPERPGROUNDDOWN(PHYSTOP - total_super_pool_size);

  if (PHYSTOP < (uint64)end + total_super_pool_size) { // Not enough memory even for kernel + superpages
      printf("kalloc: Not enough physical memory for kernel and superpage pool. Superpages disabled.\n");
      superpages_physaddr_start = 0; // Effectively disables superalloc
      superpages_pool_active = 0;
  } else if (potential_sp_start < (uint64)end) { // Overlaps with kernel
      printf("kalloc: Calculated superpage pool at 0x%lx overlaps kernel (ends at 0x%lx). Superpages disabled.\n",
             potential_sp_start, (uint64)end);
      superpages_physaddr_start = 0;
      superpages_pool_active = 0;
  } else {
      superpages_physaddr_start = potential_sp_start;
      superpages_pool_active = 1;
      printf("kalloc: Superpage pool active: [0x%lx - 0x%lx), %d blocks.\n", 
             superpages_physaddr_start, superpages_physaddr_start + total_super_pool_size, NSUPERPG);
  }
  // --- End of Superpage Pool Initialization ---

  // Add the remaining physical memory (not used by kernel or superpage pool)
  // to the 4KB page allocator.
  // The range for 4KB pages is from the end of the kernel up to
  // the start of the superpage pool (if active) or up to PHYSTOP.
  uint64 pa_4k_end;
  if (superpages_pool_active) {
    pa_4k_end = superpages_physaddr_start; // 4KB pages go up to where superpages begin
  } else {
    pa_4k_end = PHYSTOP; // No superpages, 4KB pages go up to PHYSTOP
  }
  freerange(end, (void*)pa_4k_end);
}

// Add physical memory from pa_start to pa_end (exclusive of pa_end)
// to the 4KB page free list. pa_start and pa_end are page-aligned.
void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start); // Align pa_start up to a page boundary

  // Distribute initial pages somewhat evenly, or all to CPU 0.
  // For simplicity in xv6 init, often all given to CPU 0, and others steal.
  int bootstrap_cpu_id = 0; // Or r_mhartid() if kinit is called by each hart, but typically just once.
                            // If kinit is called once globally, bootstrap_cpu_id = 0 is fine.

  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    // No need to check for superpage pool overlap here anymore,
    // because pa_end for this freerange call is already adjusted
    // to not include the superpage pool.
    struct run *r = (struct run*)p;

    // Add page to the bootstrap CPU's freelist
    acquire(&kmems[bootstrap_cpu_id].lock);
    r->next = kmems[bootstrap_cpu_id].freelist;
    kmems[bootstrap_cpu_id].freelist = r;
    release(&kmems[bootstrap_cpu_id].lock);
  }
}

// Free the 4KB physical page at pa,
// which is returned by kalloc().
// Adds the page to the current CPU's free list.
void
kfree(void *pa)
{
  struct run *r;
  int cid;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree: freeing invalid physical address");
  
  // Check if trying to kfree a page within the active superpage pool.
  // This should not happen; superpages are freed by superfree.
  if (superpages_pool_active &&
      (uint64)pa >= superpages_physaddr_start &&
      (uint64)pa < superpages_physaddr_start + (uint64)NSUPERPG * SUPERPGSIZE)
  {
    panic("kfree: attempt to free a 4KB page within the superpage reserved area");
  }

  // Fill with junk to catch dangling references.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  push_off(); // Disable interrupts to safely get cpuid
  cid = cpuid();
  pop_off();  // Re-enable interrupts
  
  acquire(&kmems[cid].lock);
  r->next = kmems[cid].freelist;
  kmems[cid].freelist = r;
  release(&kmems[cid].lock);
}

// Allocate one 4KB physical page.
// Returns a pointer to the page, or 0 if out of memory.
// Tries local CPU list first, then steals from other CPUs.
void *
kalloc(void)
{
  struct run *r;
  int my_cid;

  push_off();
  my_cid = cpuid();
  pop_off();
  
  // 1. Try to allocate from the current CPU's local freelist
  acquire(&kmems[my_cid].lock);
  r = kmems[my_cid].freelist;
  if(r){
    kmems[my_cid].freelist = r->next;
    release(&kmems[my_cid].lock);
    memset((char*)r, 5, PGSIZE); // fill with junk
    return (void*)r;
  }
  release(&kmems[my_cid].lock); // Local list is empty, release its lock

  // 2. Try to steal a page from other CPUs' freelists
  for(int other_cid = 0; other_cid < NCPU; other_cid++){
    if(other_cid == my_cid)
      continue; // Don't try to steal from self

    acquire(&kmems[other_cid].lock);
    r = kmems[other_cid].freelist;
    if(r){ // If the other CPU has a free page
      kmems[other_cid].freelist = r->next; 
      release(&kmems[other_cid].lock);
      memset((char*)r, 5, PGSIZE); // fill with junk
      return (void*)r; 
    }
    release(&kmems[other_cid].lock);
  }
  
  // printf("kalloc: 4KB out of memory!\n"); // Optional: uncomment for debugging OOM
  return 0; // All CPUs' freelists are empty
}

// --- Superpage Allocation Functions ---

// Allocate a 2MB-aligned physical superpage.
// Returns a pointer to the page if successful, 0 otherwise.
void*
superalloc(void)
{
  if (!superpages_pool_active) { // Check if pool was successfully initialized
    return 0; 
  }

  acquire(&superlock);
  for (int i = 0; i < NSUPERPG; i++) {
    if (superpages_status[i] == 0) { // If block 'i' is free
      superpages_status[i] = 1;    // Mark as used
      release(&superlock);
      uint64 pa = superpages_physaddr_start + (uint64)i * SUPERPGSIZE;
      memset((void*)pa, 0, SUPERPGSIZE); // Zero out the superpage
      return (void*)pa;
    }
  }
  release(&superlock);
  // printf("superalloc: out of superpages!\n"); // Optional: uncomment for debugging
  return 0; // No free superpages found
}

// Free a 2MB-aligned physical superpage.
// 'pa' must be a pointer previously returned by superalloc().
void
superfree(void *pa) 
{
  if (!superpages_pool_active) { // Pool not active, something is wrong if we try to free
    panic("superfree: called but superpage pool is not active"); 
  }
  // Validate that 'pa' is within the managed superpage pool range
  if ((uint64)pa < superpages_physaddr_start ||
      (uint64)pa >= superpages_physaddr_start + (uint64)NSUPERPG * SUPERPGSIZE)
  {
    panic("superfree: physical address out of superpage pool range"); 
  }
  // Validate that 'pa' is aligned to a SUPERPGSIZE boundary
  if (((uint64)pa - superpages_physaddr_start) % SUPERPGSIZE != 0) {
    panic("superfree: physical address not superpage aligned"); 
  }

  int index = ((uint64)pa - superpages_physaddr_start) / SUPERPGSIZE;

  acquire(&superlock);
  if (superpages_status[index] == 0) { // Check if trying to free an already free page
    panic("superfree: freeing an already free superpage"); 
  }
  superpages_status[index] = 0; // Mark as free
  // Optionally, could fill with junk like kfree does for 4KB pages, e.g., memset(pa, 2, SUPERPGSIZE);
  release(&superlock);
}
