//
// File-system system calls.
// Mostly argument checking, since we don't trust
// user code, and calls into file.c and fs.c.
//

#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "stat.h"
#include "spinlock.h"
#include "proc.h"
#include "fs.h"
#include "sleeplock.h"
#include "file.h"
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
int
argfd(int n, int *pfd, struct file **pf)
{
  int fd;
  struct file *f;
  struct proc *p = myproc(); // 获取当前进程

  if(argint(n, &fd) < 0) // 获取 int 类型的 fd
    return -1;
  
  // printf("DEBUG argfd: received fd = %d\n", fd); // 打印收到的 fd

  // 这里的检查至关重要
  if(fd < 0 || fd >= NOFILE || (f = p->ofile[fd]) == 0) { // <-- 关键检查点
    // printf("DEBUG argfd: fd %d is invalid or not open. p->ofile[fd] = 0x%lx, NOFILE = %d\n", fd, (uint64)p->ofile[fd], NOFILE);
    return -1; // fd 无效或文件未打开
  }

  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  
  // printf("DEBUG argfd: Successfully retrieved fd %d, file 0x%lx\n", fd, (uint64)f);
  return 0;
}

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *p = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(p->ofile[fd] == 0){
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}

uint64
sys_dup(void)
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}

uint64
sys_read(void)
{
  struct file *f;
  int n;
  uint64 p;

  argaddr(1, &p);
  argint(2, &n);
  if(argfd(0, 0, &f) < 0)
    return -1;
  return fileread(f, p, n);
}

uint64
sys_write(void)
{
  struct file *f;
  int n;
  uint64 p;
  
  argaddr(1, &p);
  argint(2, &n);
  if(argfd(0, 0, &f) < 0)
    return -1;

  return filewrite(f, p, n);
}

uint64
sys_close(void)
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}

uint64
sys_fstat(void)
{
  struct file *f;
  uint64 st; // user pointer to struct stat

  argaddr(1, &st);
  if(argfd(0, 0, &f) < 0)
    return -1;
  return filestat(f, st);
}

// Create the path new as a link to the same inode as old.
uint64
sys_link(void)
{
  char name[DIRSIZ], new[MAXPATH], old[MAXPATH];
  struct inode *dp, *ip;

  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;

bad:
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
}

uint64
sys_unlink(void)
{
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], path[MAXPATH];
  uint off;

  if(argstr(0, path, MAXPATH) < 0)
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
    return -1;
  }

  ilock(dp);

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;

  ilock(dp);

  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0){
    iunlockput(dp);
    return 0;
  }

  ilock(ip);
  ip->major = major;
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      goto fail;
  }

  if(dirlink(dp, name, ip->inum) < 0)
    goto fail;

  if(type == T_DIR){
    // now that success is guaranteed:
    dp->nlink++;  // for ".."
    iupdate(dp);
  }

  iunlockput(dp);

  return ip;

 fail:
  // something went wrong. de-allocate ip.
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}

uint64
sys_open(void)
{
  char path[MAXPATH];
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
  if((n = argstr(0, path, MAXPATH)) < 0)
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
      iunlockput(ip);
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    f->off = 0;
  }
  f->ip = ip;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  if((omode & O_TRUNC) && ip->type == T_FILE){
    itrunc(ip);
  }

  iunlock(ip);
  end_op();

  return fd;
}

uint64
sys_mkdir(void)
{
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
  end_op();
  return 0;
}

uint64
sys_mknod(void)
{
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
  argint(1, &major);
  argint(2, &minor);
  if((argstr(0, path, MAXPATH)) < 0 ||
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
  end_op();
  return 0;
}

uint64
sys_chdir(void)
{
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
  
  begin_op();
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
  iput(p->cwd);
  end_op();
  p->cwd = ip;
  return 0;
}

// uint64
// sys_exec(char* path, char** argv) 
// {
//   char path[MAXPATH], *argv[MAXARG];
//   int i;
//   uint64 uargv, uarg;

//   argaddr(1, &uargv);
//   if(argstr(0, path, MAXPATH) < 0) {
//     return -1;
//   }
//   memset(argv, 0, sizeof(argv));
//   for(i=0;; i++){
//     if(i >= NELEM(argv)){
//       goto bad;
//     }
//     if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
//       goto bad;
//     }
//     if(uarg == 0){
//       argv[i] = 0;
//       break;
//     }
//     argv[i] = kalloc();
//     if(argv[i] == 0)
//       goto bad;
//     if(fetchstr(uarg, argv[i], PGSIZE) < 0)
//       goto bad;
//   }

//   int ret = exec(path, argv);

//   for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
//     kfree(argv[i]);

//   return ret;

//  bad:
//   for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
//     kfree(argv[i]);
//   return -1;
// }

uint64
sys_exec(char* user_path, char** user_argv) // <-- 参数名改为 user_path 和 user_argv，避免冲突
{
  char path_buf[MAXPATH];  // <-- 局部缓冲区用于复制用户态的路径字符串
  char *argv_buf[MAXARG];  // <-- 局部数组用于存储复制到内核的参数字符串指针
  int i;
  uint64 uarg_ptr; // 用于从用户态 argv 数组中读取单个 char* 指针的地址

  // struct proc *p = myproc(); // 获取当前进程

  // 1. 从用户态复制路径到内核缓冲区
  // argstr(0, path_buf, MAXPATH) 获取第一个参数（path）并复制到 path_buf
  if(argstr(0, path_buf, MAXPATH) < 0) {
    return -1; // 复制失败
  }

  // 2. 从用户态复制 argv 数组到内核缓冲区
  // argaddr(1, &uarg_ptr) 获取第二个参数（argv 数组的起始地址）
  if(argaddr(1, &uarg_ptr) < 0) { // uarg_ptr 现在存储 user_argv 的地址
    return -1;
  }
  
  // 初始化 argv_buf 数组为 0，以便在出错时正确 kfree
  memset(argv_buf, 0, sizeof(argv_buf));

  // 遍历用户态的 argv 数组，复制每个参数字符串
  for(i=0; i<MAXARG-1; i++){ // MAXARG-1 是为了为末尾的 NULL 指针留出空间
    uint64 uarg_val; // 从用户态 argv 数组中读取到的单个参数字符串的用户虚拟地址

    // 从用户态 argv 数组中读取第 i 个参数字符串的指针
    // fetchaddr(uarg_ptr + sizeof(uint64)*i, &uarg_val)
    // uarg_ptr 是 user_argv 数组的起始地址
    // sizeof(uint64)*i 是当前参数指针在数组中的偏移量
    // &uarg_val 是内核缓冲区，用于接收读取到的用户态参数指针的值
    if(fetchaddr(uarg_ptr + sizeof(uint64)*i, &uarg_val) < 0){
      goto bad; // 读取用户态指针失败
    }

    if(uarg_val == 0){ // 遇到 NULL 指针，表示参数列表结束
      argv_buf[i] = 0;
      break;
    }

    // 为每个参数字符串在内核中分配一个页面（PGSIZE）来存储
    argv_buf[i] = kalloc();
    if(argv_buf[i] == 0)
      goto bad; // 分配内存失败

    // 将用户态的参数字符串复制到新分配的内核页面中
    // fetchstr(uarg_val, argv_buf[i], PGSIZE)
    // uarg_val 是用户态参数字符串的虚拟地址
    // argv_buf[i] 是内核中分配的缓冲区
    // PGSIZE 是缓冲区最大大小
    if(fetchstr(uarg_val, argv_buf[i], PGSIZE) < 0)
      goto bad; // 复制字符串失败
  }
  if(i == MAXARG-1){ // 参数数量超过 MAXARG-1
    goto bad;
  }

  // 3. 调用实际的 exec 函数（在 proc.c 中实现）
  // 这个 exec 会负责切换进程的地址空间和加载新程序
  int ret = exec(path_buf, argv_buf); // 调用 exec，传递内核中的路径和参数数组

  // 4. 清理：exec 成功不会返回，只有失败才返回
  // 如果 exec 失败，需要释放所有为参数字符串分配的内存
  for(i = 0; i < MAXARG && argv_buf[i] != 0; i++) // 遍历 argv_buf，释放所有已分配的页面
    kfree(argv_buf[i]);

  return ret; // exec 失败时返回 -1

 bad:
  // 错误处理路径：释放所有已分配的内存
  for(i = 0; i < MAXARG && argv_buf[i] != 0; i++)
    kfree(argv_buf[i]);
  return -1;
}

uint64
sys_pipe(void)
{
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();

  argaddr(0, &fdarray);
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    p->ofile[fd0] = 0;
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
}
