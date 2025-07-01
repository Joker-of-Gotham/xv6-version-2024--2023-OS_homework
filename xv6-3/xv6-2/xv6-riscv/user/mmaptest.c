// user/mmaptest.c

#include "kernel/param.h" // 包含 BSIZE, PGSIZE, NPROC 等宏
#include "kernel/fcntl.h" // 包含 O_RDONLY, O_WRONLY, O_CREATE, PROT_READ, MAP_PRIVATE 等宏
#include "kernel/types.h" // 包含 uint64 等类型
#include "kernel/stat.h"  // 包含 stat 结构体，可能间接需要
#include "kernel/riscv.h" // 包含 RISC-V 相关的宏，如 PTE_V 等，虽然这里不直接用，但内核代码需要
#include "kernel/fs.h"    // 包含文件系统相关的定义，如 struct inode
#include "user/user.h"    // 包含用户态系统调用声明（如 printf, exit, open, mmap, munmap, fork, wait, unlink, memset, memcmp 等）

// 如果 mmap 函数原型没有自动引入，可能需要单独声明
// void *mmap(void *addr, uint64 len, int prot, int flags, int fd, uint64 offset);
// int munmap(void *addr, uint64 len);

// extern void*mmap(void *addr, uint64 len, int prot, int flags, int fd, uint64 offset);
// extern int munmap(void *addr, uint64 len);

// MAP_FAILED 通常定义为 -1，这里明确为 char* 类型
#define MAP_FAILED ((char *) -1)

// 在 mmap.h 中可能定义了这些，为了独立性，这里也列出
// 确保这些值与 kernel/fcntl.h 中的定义一致
#ifndef PROT_READ
#define PROT_READ  0x1
#endif
#ifndef PROT_WRITE
#define PROT_WRITE 0x2
#endif
#ifndef MAP_SHARED
#define MAP_SHARED 0x1
#endif
#ifndef MAP_PRIVATE
#define MAP_PRIVATE 0x2
#endif

// 前向声明测试函数
void mmap_test();
void fork_test();

// BSIZE 已经在 kernel/param.h 中定义，如果需要全局缓冲区，可以使用它
char buf[BSIZE]; // 注意：这个 buf 必须足够大以容纳 BSIZE 字节

// main 函数
int main(int argc, char *argv[])
{
  mmap_test();
  fork_test();
  printf("mmaptest: all tests succeeded\n");
  exit(0);
}

char *testname = "???";

// 错误处理函数
void err(char *why)
{
  printf("mmaptest: %s failed: %s, pid=%d\n", testname, why, getpid());
  exit(1);
}

// 检查两个映射页面的内容
void _v1(char *p)
{
  printf("DEBUG: _v1 received p = 0x%lx\n", (uint64)p); // <-- 这里使用 p
  int i;
  for (i = 0; i < PGSIZE*2; i++) {
    if (i < PGSIZE + (PGSIZE/2)) { // 前1.5页应该是 'A'
      if (p[i] != 'A') {
        printf("mismatch at %d, wanted 'A', got 0x%x\n", i, p[i]);
        err("v1 mismatch (1)");
      }
    } else { // 后半页应该是 0 (因为文件内容是1.5页A和0.5页0)
      if (p[i] != 0) {
        printf("mismatch at %d, wanted zero, got 0x%x\n", i, p[i]);
        err("v1 mismatch (2)");
      }
    }
  }
}

void makefile(const char *f)
{
  unlink(f); // 删除旧文件

  int fd = open(f, O_WRONLY | O_CREATE);
  if (fd < 0)
    err("open makefile");

  // 分配一个临时缓冲区，大小 PGSIZE，用来写一整页的 'A'
  char *pagebuf = malloc(PGSIZE);
  if (!pagebuf)
    err("malloc makefile");
  memset(pagebuf, 'A', PGSIZE);

  // 写入 1 整页的 'A'
  if (write(fd, pagebuf, PGSIZE) != PGSIZE)
    err("write full page in makefile");

  // 写入 半页 的 'A'
  int half = PGSIZE / 2;
  if (write(fd, pagebuf, half) != half)
    err("write half page in makefile");

  // 关闭并释放缓冲
  if (close(fd) < 0)
    err("close makefile");
  free(pagebuf);
}

// mmap 测试主函数
void mmap_test(void)
{
  int fd;
  int i;
  const char * const f = "mmap.dur";
  printf("test mmap f starting\n"); // 修改为更清晰的起始信息
  testname = "mmap_test";

  // 创建一个已知内容的文件，映射到内存，并检查内容
  makefile(f);
  if ((fd = open(f, O_RDONLY)) == -1)
    err("open");

  printf("test mmap basic read (MAP_PRIVATE)\n"); // 更具体地描述测试目的
  // 映射文件内容到地址空间。
  // 0: 内核选择虚拟地址。
  // PGSIZE*2: 映射 2 页（8KB）。文件实际只有1.5页，多余的0.5页应为0。
  // PROT_READ: 只读权限。
  // MAP_PRIVATE: 私有映射，修改不写回文件。
  // fd: 文件描述符。
  // 0: 文件偏移量从0开始。
  char *p = (char *)mmap(0, PGSIZE*2, PROT_READ, MAP_PRIVATE, fd, 0);
  printf("USER DEBUG: mmaptest received mapped address p = 0x%lx\n", (uint64)p); // 打印 p 的值

  if (p == MAP_FAILED)
    err("mmap basic read (1)");
  _v1(p); // 验证映射内容
  if (munmap(p, PGSIZE*2) == -1)
    err("munmap basic read (1)");
  printf("test mmap basic read (MAP_PRIVATE): OK\n");
    
  printf("test mmap private writable\n");
  // 应该能用私有写权限映射一个只读打开的文件（因为私有写不会影响原文件）
  p = (char *)mmap(0, PGSIZE*2, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
  if (p == MAP_FAILED)
    err("mmap private writable (2)");
  if (close(fd) == -1) // 关闭文件描述符，映射应该依然有效
    err("close fd after mmap");
  _v1(p); // 验证初始内容
  for (i = 0; i < PGSIZE*2; i++)
    p[i] = 'Z'; // 修改私有映射
  if (munmap(p, PGSIZE*2) == -1)
    err("munmap private writable (2)");
  printf("test mmap private writable: OK\n");
    
  printf("test mmap read-only shared (should fail write)\n");
    
  // 检查 mmap 是否禁止对只读打开的文件进行读写共享映射。
  // 因为 MAP_SHARED 意味着修改会写回文件，但文件是只读打开的。
  if ((fd = open(f, O_RDONLY)) == -1)
    err("open for read-only shared test");
  p = (char *)mmap(0, PGSIZE*3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  if (p != MAP_FAILED)
    err("mmap call should have failed for read-only shared mapping");
  if (close(fd) == -1)
    err("close after read-only shared test");
  printf("test mmap read-only shared (should fail write): OK\n");
    
  printf("test mmap read/write shared\n");
  
  // 检查 mmap 是否允许对读写打开的文件进行读写共享映射。
  if ((fd = open(f, O_RDWR)) == -1)
    err("open for read/write shared test");
  p = (char *)mmap(0, PGSIZE*3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  if (p == MAP_FAILED)
    err("mmap read/write shared (3)");
  if (close(fd) == -1)
    err("close fd after read/write shared mmap");

  // 检查关闭 fd 后映射是否仍然有效。
  _v1(p);

  // 写入映射内存。
  for (i = 0; i < PGSIZE*2; i++)
    p[i] = 'Z';

  // 只解除映射 3 页中的前 2 页。
  if (munmap(p, PGSIZE*2) == -1)
    err("munmap read/write shared (3)");
  
  printf("test mmap read/write shared: OK\n");
  
  printf("test mmap dirty write-back\n");
  
  // 检查对映射内存的写入是否已写回文件。
  if ((fd = open(f, O_RDWR)) == -1)
    err("open for dirty write-back test");
  for (i = 0; i < PGSIZE + (PGSIZE/2); i++){ // 检查前1.5页
    char b;
    if (read(fd, &b, 1) != 1)
      err("read from file (1)");
    if (b != 'Z')
      err("file does not contain modifications");
  }
  // 检查文件后半部分是否依然是 0
  for (i = 0; i < PGSIZE/2; i++){
    char b;
    if (read(fd, &b, 1) != 1)
      err("read from file (2)");
    if (b != 'Z')
      err("file contains unexpected data after modification");
  }
  if (close(fd) == -1)
    err("close after dirty write-back test");

  printf("test mmap dirty write-back: OK\n");

  printf("test munmap not-mapped region\n");
  
  // 解除映射剩余的内存。
  if (munmap(p+PGSIZE*2, PGSIZE) == -1)
    err("munmap not-mapped region (4)");
  printf("test munmap not-mapped region: OK\n");
    
  printf("test mmap two different files\n");
  
  // 同时映射两个文件。
  int fd1;
  if((fd1 = open("mmap1", O_RDWR|O_CREATE)) < 0)
    err("open mmap1");
  if(write(fd1, "12345", 5) != 5)
    err("write mmap1");
  char *p1 = (char *)mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd1, 0);
  if(p1 == MAP_FAILED)
    err("mmap mmap1");
  close(fd1);
  unlink("mmap1");

  int fd2;
  if((fd2 = open("mmap2", O_RDWR|O_CREATE)) < 0)
    err("open mmap2");
  if(write(fd2, "67890", 5) != 5)
    err("write mmap2");
  char *p2 = (char *)mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd2, 0);
  if(p2 == MAP_FAILED)
    err("mmap mmap2");
  close(fd2);
  unlink("mmap2");

  // 验证两个映射的内容
  if(memcmp(p1, "12345", 5) != 0)
    err("mmap1 mismatch");
  if(memcmp(p2, "67890", 5) != 0)
    err("mmap2 mismatch");

  // 解除映射 p1，检查 p2 是否仍然有效
  munmap(p1, PGSIZE);
  if(memcmp(p2, "67890", 5) != 0)
    err("mmap2 mismatch (2)");
  munmap(p2, PGSIZE); // 解除映射 p2
  
  printf("test mmap two different files: OK\n");
  
  printf("mmap_test: ALL OK\n"); // 整体测试完成
}

// 
// 映射一个文件，然后 fork。
// 检查子进程是否能看到映射的文件。
// (此测试会验证物理页共享，如果你的实现支持的话)
//
void
fork_test(void)
{
  int fd;
  int pid;
  const char * const f = "mmap.dur";
  
  printf("fork_test starting\n");
  testname = "fork_test";
  
  makefile(f);
  if ((fd = open(f, O_RDWR)) == -1)
    err("open in fork_test");
  
  // We don't unlink(f) here, so we can re-open it later for verification.
  
  char *p1 = (char *)mmap(0, PGSIZE*2, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  if (p1 == MAP_FAILED)
    err("mmap (4) in fork_test");
  
  char *p2 = (char *)mmap(0, PGSIZE*2, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  if (p2 == MAP_FAILED)
    err("mmap (5) in fork_test");

  if(*(p1+PGSIZE) != 'A')
    err("fork mismatch (1) initial check");

  if((pid = fork()) < 0)
    err("fork in fork_test");
  
  if (pid == 0) { // child
    _v1(p1);
    for (int i = 0; i < PGSIZE*2; i++)
        p1[i] = 'B'; 
    munmap(p1, PGSIZE*2);
    // The child can close its copy of the fd.
    close(fd); 
    exit(0);
  }

  int status = -1;
  wait(&status);

  if(status != 0){
    printf("fork_test failed: child exited with status %d\n", status);
    exit(1);
  }

  // Parent checks its memory. Due to physical page sharing,
  // it should see the child's modifications.
  for (int i = 0; i < PGSIZE*2; i++) {
      if (p1[i] != 'B') {
          printf("mismatch at %d, wanted 'B', got 0x%x\n", i, p1[i]);
          err("fork mismatch (2) parent p1 after child exit");
      }
  }
  
  for (int i = 0; i < PGSIZE*2; i++) {
      if (p2[i] != 'B') {
          printf("mismatch at %d, wanted 'B', got 0x%x\n", i, p2[i]);
          err("fork mismatch (4) parent p2 after child exit");
      }
  }

  // Parent unmaps its regions.
  if (munmap(p1, PGSIZE*2) == -1)
    err("munmap p1 in fork_test");
  if (munmap(p2, PGSIZE*2) == -1)
    err("munmap p2 in fork_test");

  // Parent closes its copy of the fd.
  close(fd);
  
  // Now that all processes have unmapped and closed the file,
  // the modifications should be persistent on disk. Re-open to verify.
  if ((fd = open(f, O_RDONLY)) == -1)
    err("open file for final check in fork_test");

  // Verify file content.
  for (int i = 0; i < PGSIZE*2; i++) {
    char b;
    if (read(fd, &b, 1) != 1)
      err("read from file for final check");
    if (b != 'B') {
      printf("file content mismatch at %d, wanted 'B', got 0x%x\n", i, b);
      err("file content not written back correctly");
    }
  }
  close(fd);

  // Clean up the file at the very end.
  unlink(f);
  
  printf("fork_test OK\n");
}
