#include "/home/liuzhh268/Operating_System_Homework/xv6/xv6-labs-2024/kernel/types.h" // 确保这一行或类似的间接包含存在

struct stat;

// system calls
int fork(void);
int exit(int) __attribute__((noreturn));
int wait(int*);
int pipe(int*);
int write(int, const void*, int);
int read(int, void*, int);
int close(int);
int kill(int);
int exec(const char*, char**);
int open(const char*, int);
int mknod(const char*, short, short);
int unlink(const char*);
int fstat(int fd, struct stat*);
int link(const char*, const char*);
int mkdir(const char*);
int chdir(const char*);
int dup(int);
int getpid(void);
char* sbrk(int);
int sleep(int);
int uptime(void);

// ulib.c
int stat(const char*, struct stat*);
char* strcpy(char*, const char*);
void *memmove(void*, const void*, int);
char* strchr(const char*, char c);
int strcmp(const char*, const char*);
void fprintf(int, const char*, ...) __attribute__ ((format (printf, 2, 3)));
void printf(const char*, ...) __attribute__ ((format (printf, 1, 2)));
char* gets(char*, int max);
uint strlen(const char*);
void* memset(void*, int, uint);
int atoi(const char*);
int memcmp(const void *, const void *, uint);
void *memcpy(void *, const void *, uint);

// umalloc.c
void* malloc(uint);
void free(void*);

// call trace
int trace(int);

// call kpgtbl
int kpgtbl(void); // 系统调用原型声明

// call ntas
int statistics(char *buf, int bufsz); // 系统调用存根声明
int reset_stats(void); 

#define LOCKNAME_MAX_LEN_USER 32 // 与内核中的 LOCKNAME_MAX_LEN 保持一致

struct lock_stat_entry_user { // 用户空间使用的结构体名称
  char name[LOCKNAME_MAX_LEN_USER];
  unsigned int acquire_count; // 使用与内核匹配的类型，或者在用户端转换
  unsigned int tas_spins;
};

int resetlockstats(void);
int getlockstats(struct lock_stat_entry_user *entries, int max_entries);
int strncmp(const char *p, const char *q, uint n);
void simplesort(void *base, uint nmemb, uint size, int (*compar)(const void *, const void *));

// SuperPage
uint64 pgpte(void *va); // 返回类型是 uint64 (pte_t 在用户态不可见)

uint64 sys_ugetpid(void);
int pgaccess(void *base, int len, void *mask);

int ugetpid(void);

int sigalarm(int ticks, void (*handler)());
int sigreturn(void);