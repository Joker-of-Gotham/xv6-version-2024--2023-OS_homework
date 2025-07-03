#ifndef __DEFS_H_XV6__
#define __DEFS_H_XV6__
#include "spinlock.h" // <--- 确保这一行存在，并且在任何使用 struct lock_stat_entry_kernel 的原型之前
#include "proc.h"

struct buf;
struct context;
struct file;
struct inode;
struct pipe;
struct proc;
struct spinlock;
struct sleeplock;
struct stat;
struct superblock;

typedef struct {
    pte_t *pte;       // Pointer to the leaf Page Table Entry
    uint64 page_size; // PGSIZE or SUPERPGSIZE, or 0 if error/not found
    // int level;     // Optional: 0 for L0 leaf, 1 for L1 leaf, -1 for error
} walk_info_t;

// bio.c
void            binit(void);
struct buf*     bread(uint, uint);
void            brelse(struct buf*);
void            bwrite(struct buf*);
void            bpin(struct buf*);
void            bunpin(struct buf*);

// console.c
void            consoleinit(void);
void            consoleintr(int);
void            consputc(int);

// exec.c
int             exec(char*, char**);

// file.c
struct file*    filealloc(void);
void            fileclose(struct file*);
struct file*    filedup(struct file*);
void            fileinit(void);
int             fileread(struct file*, uint64, int n);
int             filestat(struct file*, uint64 addr);
int             filewrite(struct file*, uint64, int n);

// fs.c
void            fsinit(int);
int             dirlink(struct inode*, char*, uint);
struct inode*   dirlookup(struct inode*, char*, uint*);
struct inode*   ialloc(uint, short);
struct inode*   idup(struct inode*);
void            iinit();
void            ilock(struct inode*);
void            iput(struct inode*);
void            iunlock(struct inode*);
void            iunlockput(struct inode*);
void            iupdate(struct inode*);
int             namecmp(const char*, const char*);
struct inode*   namei(char*);
struct inode*   nameiparent(char*, char*);
int             readi(struct inode*, int, uint64, uint, uint);
void            stati(struct inode*, struct stat*);
int             writei(struct inode*, int, uint64, uint, uint);
void            itrunc(struct inode*);

// ramdisk.c
void            ramdiskinit(void);
void            ramdiskintr(void);
void            ramdiskrw(struct buf*);

// kalloc.c
void*   kalloc(void);
void    kfree(void*);
void    kinit(void);
void*   superalloc(void); // Superpage allocation
void    superfree(void*); // Superpage free

// log.c
void            initlog(int, struct superblock*);
void            log_write(struct buf*);
void            begin_op(void);
void            end_op(void);

// pipe.c
int             pipealloc(struct file**, struct file**);
void            pipeclose(struct pipe*, int);
int             piperead(struct pipe*, uint64, int);
int             pipewrite(struct pipe*, uint64, int);

// printf.c
int             printf(char*, ...) __attribute__ ((format (printf, 1, 2)));
void            panic(char*) __attribute__((noreturn));
void            printfinit(void);

// proc.c
int             cpuid(void);
void            exit(int);
int             fork(void);
int             growproc(int);
void            proc_mapstacks(pagetable_t);
pagetable_t     proc_pagetable(struct proc *);
void            proc_freepagetable(pagetable_t, uint64);
int             kill(int);
int             killed(struct proc*);
void            setkilled(struct proc*);
struct cpu*     mycpu(void);
struct cpu*     getmycpu(void);
struct proc*    myproc();
void            procinit(void);
void            scheduler(void) __attribute__((noreturn));
void            sched(void);
void            sleep(void*, struct spinlock*);
void            userinit(void);
int             wait(uint64);
void            wakeup(void*);
void            yield(void);
int             either_copyout(int user_dst, uint64 dst, void *src, uint64 len);
int             either_copyin(void *dst, int user_src, uint64 src, uint64 len);
void            procdump(void);
struct proc*    allocproc(void); // Ensure this is declared if used by allocproc
void            freeproc(struct proc*); // Ensure this is declared

// swtch.S
void            swtch(struct context*, struct context*);

// spinlock.c
void            acquire(struct spinlock*);
int             holding(struct spinlock*);
void            initlock(struct spinlock*, char*);
void            release(struct spinlock*);
void            push_off(void);
void            pop_off(void);
void            lockstatsinit(void); // 初始化锁统计系统
// The following are kernel internal and might not need to be in defs.h
// if only called by syscalls defined in sysproc.c which includes spinlock.c headers.
// However, if other kernel modules might reset/get stats, declare them.
void            reset_all_lock_stats_kernel(void);// 内核接口
int             report_kmem_bcache_spins_formatted(char *buf, int bufsz);

// sleeplock.c
void            acquiresleep(struct sleeplock*);
void            releasesleep(struct sleeplock*);
int             holdingsleep(struct sleeplock*);
void            initsleeplock(struct sleeplock*, char*);

// string.c
int             memcmp(const void*, const void*, uint);
void*           memmove(void*, const void*, uint);
void*           memset(void*, int, uint);
char*           safestrcpy(char*, const char*, int);
int             strlen(const char*);
int             strncmp(const char*, const char*, uint);
char*           strncpy(char*, const char*, int);
// add new func
int             k_itoa(long long, char*, int);
void            k_strrev(char*, int);

// syscall.c
int            argint(int, int*);
int             argstr(int, char*, int);
int            argaddr(int, uint64 *);
int             fetchstr(uint64, char*, int);
int             fetchaddr(uint64, uint64*);
void            syscall();

// sysproc.c  <--- 你可以自己添加这个注释行
uint64          sys_trace(void); // <--- 添加这一行声明

// trap.c
extern uint     ticks;
void            trapinit(void);
void            trapinithart(void);
extern struct spinlock tickslock;
void            usertrapret(void);

// uart.c
void            uartinit(void);
void            uartintr(void);
void            uartputc(int);
void            uartputc_sync(int);
int             uartgetc(void);

// vm.c
pagetable_t uvmcreate(void);
void            uvmfirst(pagetable_t, uchar*, uint);
uint64          uvmalloc(pagetable_t, uint64, uint64, int);
uint64          uvmdealloc(pagetable_t, uint64, uint64);
int             uvmcopy(pagetable_t, pagetable_t, uint64);
void            uvmfree(pagetable_t, uint64);
void            uvmunmap(pagetable_t, uint64, uint64, int);
void            uvmclear(pagetable_t, uint64);
pte_t*          walk(pagetable_t, uint64, int);
uint64          walkaddr(pagetable_t, uint64);
int             mappages(pagetable_t, uint64, uint64, uint64, int);
pagetable_t     kvmmake(void);
void            kvminit(void);
void            kvminithart(void);
void            kvmmap(pagetable_t, uint64, uint64, uint64, int);
int             copyout(pagetable_t, uint64, char*, uint64);
int             copyin(pagetable_t, char*, uint64, uint64);
int             copyinstr(pagetable_t, char*, uint64, uint64);

// plic.c
void            plicinit(void);
void            plicinithart(void);
int             plic_claim(void);
void            plic_complete(int);

// virtio_disk.c
void            virtio_disk_init(void);
void            virtio_disk_rw(struct buf *, int);
void            virtio_disk_intr(void);

// number of elements in fixed-size array
#define NELEM(x) (sizeof(x)/sizeof((x)[0]))

// Add: vmprint 的函数原型
void            vmprint(pagetable_t); // <--- 添加这一行

// Add: reset_lock_stats and report_lock_stats的函数原型
void            reset_lock_stats(void); // 新增
int             report_lock_stats(void); // 新增
void            lockstatsinit(void); // <--- 添加这一行声明
void            register_lock(struct spinlock*); // <--- 如果 register_lock 也可能被其他模块调用，也声明它
// sysproc.c (系统调用处理函数)
uint64          sys_resetlockstats(void);
uint64          sys_getlockstats(void); // 或者 sys_statistics，取决于你如何命名

#define LOCKNAME_MAX_LEN 32 // 与用户空间的定义一致

// Superpage related functions
void*           kalloc_super(void);         // Allocates a SUPERPGSIZE physical block
int             mappages_super(pagetable_t, uint64, uint64, int); // Maps a superpage
void            kfree_super(void*);         // Frees a SUPERPGSIZE physical block
void            superpage_init(void); // <--- 添加这一行
void            kmem_locks_init(void);
void            superpage_area_setup(void*, void*); // <--- 这是新的、正确的原型
void            kmem_freerange_init(void*, void*);

// New Superpage mapping function (used by growproc, uvmcopy)
int             uvmmap_super(pagetable_t, uint64, uint64, int); // <--- Add this

#endif // __DEFS_H_XV6__