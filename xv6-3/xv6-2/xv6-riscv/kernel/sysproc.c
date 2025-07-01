#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "fcntl.h"
#include "file.h"  // <--- 添加这一行
#include "buf.h"  // <--- 在这里添加这一行
#include <stddef.h>

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

// sys_mmap 返回虚拟地址，失败返回 (void *)-1
void *
sys_mmap(void)
{
  uint64 addr_in;
  int length, prot, flags, fd, offset;
  struct file *f;
  struct proc *p = myproc();

  if(argaddr(0, &addr_in) < 0 || argint(1, &length) < 0 || argint(2, &prot) < 0 ||
     argint(3, &flags) < 0 || argint(4, &fd) < 0 || argint(5, &offset) < 0) {
    return (void *)-1;
  }
  
  if (addr_in != 0 || offset != 0 || length <= 0) {
    return (void *)-1;
  }

  if (fd < 0 || fd >= NOFILE || (f = p->ofile[fd]) == 0) {
    return (void*)-1;
  }
  
  if (!f->readable && (prot & PROT_READ)) return (void*)-1;
  if (!f->writable && (prot & PROT_WRITE) && (flags & MAP_SHARED)) return (void*)-1;

  struct vma *vma = 0;
  for (int i = 0; i < MAX_VMA; i++) {
    if (p->vmas[i].len == 0) {
      vma = &p->vmas[i];
      break;
    }
  }
  if (vma == 0) {
    return (void *)-1;
  }

  // 分配虚拟地址时，使用对齐后的长度来计算
  uint64 map_len_aligned = PGROUNDUP(length);
  uint64 map_addr = p->mmap_base - map_len_aligned;
  if (map_addr < p->sz) {
      return (void *)-1;
  }
  p->mmap_base = map_addr;

  // --- 关键修正 ---
  // 在 VMA 中存储用户请求的原始长度
  vma->len = length; 
  // -----------------

  vma->addr = map_addr;
  vma->prot = prot;
  vma->flags = flags;
  vma->f = filedup(f);

  return (void*)map_addr;
}

uint64
sys_munmap(void)
{
  uint64 addr;
  int length;
  struct proc *p = myproc();

  if(argaddr(0, &addr) < 0 || argint(1, &length) < 0) { return -1; }
  if(length <= 0) { return -1; }

  uint64 len_aligned = PGROUNDUP(length);
  struct vma *vma = 0;

  for(int i = 0; i < MAX_VMA; i++) {
    if (p->vmas[i].len > 0 && 
        addr >= p->vmas[i].addr && 
        addr < p->vmas[i].addr + PGROUNDUP(p->vmas[i].len)) {
      vma = &p->vmas[i];
      break;
    }
  }

  if (vma == 0) { return -1; }

  uint64 vma_len_aligned = PGROUNDUP(vma->len);

  // 只处理从头或到尾的解除映射
  if (addr == vma->addr || (addr + len_aligned == vma->addr + vma_len_aligned)) {
    if (vma->flags & MAP_SHARED) {
      begin_op();
      ilock(vma->f->ip);
      for (uint64 a = addr; a < addr + len_aligned; a += PGSIZE) {
        pte_t *pte = walk(p->pagetable, a, 0);
        if (pte && (*pte & PTE_V) && (*pte & PTE_D)) {
          uint off = a - vma->addr;
          
          // --- 核心修正：手动更新文件大小 ---
          // 如果写入的偏移量超出了当前文件大小，则扩展它
          if (off + PGSIZE > vma->f->ip->size) {
            vma->f->ip->size = off + PGSIZE;
          }
          // ------------------------------------

          uint bn = bmap(vma->f->ip, off / BSIZE);
          struct buf *bp = bread(vma->f->ip->dev, bn);
          memmove(bp->data, (void*)PTE2PA(*pte), PGSIZE);
          log_write(bp);
          brelse(bp);
        }
      }
      iupdate(vma->f->ip);
      iunlock(vma->f->ip);
      end_op();
    }
    
    uvmunmap(p->pagetable, addr, len_aligned / PGSIZE, 1);
    
    if (addr == vma->addr) {
      vma->addr += len_aligned;
      vma->len -= length; // 使用原始 length 更新
    } else {
      vma->len = addr - vma->addr;
    }

    if (vma->len <= 0) {
      vma->len = 0;
      fileclose(vma->f);
    }
    return 0;
  } else {
    return -1;
  }
}