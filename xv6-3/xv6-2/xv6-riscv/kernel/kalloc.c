// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
  int ref[PHYSTOP / PGSIZE]; // Reference count for each physical page
} kmem;

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    // Before kfree(), the page's ref count is 0.
    // kfree() expects the ref count to be >= 1.
    // So, manually set the ref count to 1, then kfree() will
    // decrement it to 0 and add the page to the freelist.
    kmem.ref[(uint64)p / PGSIZE] = 1;
    kfree(p);
  }
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  acquire(&kmem.lock);
  if(kmem.ref[(uint64)pa / PGSIZE] < 1)
    panic("kfree: ref count < 1");
  
  kmem.ref[(uint64)pa / PGSIZE]--;
  if(kmem.ref[(uint64)pa / PGSIZE] > 0) {
    release(&kmem.lock);
    return;
  }
  release(&kmem.lock); // Release lock before memset and list manipulation

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r){
    kmem.freelist = r->next;
    kmem.ref[(uint64)r / PGSIZE] = 1;
  }
  release(&kmem.lock);

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}

// 新增函数：增加物理页的引用计数
void
kget(void *pa)
{
  acquire(&kmem.lock);
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kget");
  if(kmem.ref[(uint64)pa / PGSIZE] < 1)
    panic("kget on free page");
  kmem.ref[(uint64)pa / PGSIZE]++;
  release(&kmem.lock);
}