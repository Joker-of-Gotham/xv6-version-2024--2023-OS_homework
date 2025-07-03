
user/_sleep：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "/home/liuzhh268/Operating_System_Homework/xv6/xv6-labs-2024/kernel/types.h" // 包含 xv6 基本类型定义，如 uint
#include "user.h"   // 包含用户程序需要的接口声明，如 sleep(), atoi(), exit(), fprintf()

int main(int argc, char *argv[]) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
    int ticks; // 用于存储需要休眠的 ticks 数

    // 检查命令行参数数量是否正确
    // argc 应该是 2: 程序名本身 (argv[0]) 和 一个参数 (argv[1])
    if (argc != 2) {
   8:	4789                	li	a5,2
   a:	00f50d63          	beq	a0,a5,24 <main+0x24>
   e:	e426                	sd	s1,8(sp)
        // 参数数量不对，向标准错误(文件描述符2)输出用法提示
        fprintf(2, "用法: sleep ticks\n");
  10:	00001597          	auipc	a1,0x1
  14:	9f058593          	addi	a1,a1,-1552 # a00 <malloc+0x100>
  18:	4509                	li	a0,2
  1a:	009000ef          	jal	822 <fprintf>
        // 以非零状态码退出，表示程序出错
        exit(1);
  1e:	4505                	li	a0,1
  20:	3cc000ef          	jal	3ec <exit>
  24:	e426                	sd	s1,8(sp)
  26:	84ae                	mv	s1,a1
    }

    // 将命令行参数（字符串）转换为整数
    // argv[1] 是第一个参数的字符串形式
    ticks = atoi(argv[1]);
  28:	6588                	ld	a0,8(a1)
  2a:	1d2000ef          	jal	1fc <atoi>

    // （可选但推荐）检查转换后的 ticks 是否为正数
    // 如果 atoi 遇到非数字输入可能返回0，或者用户可能输入0或负数
    if (ticks <= 0) {
  2e:	00a05763          	blez	a0,3c <main+0x3c>
    }

    // 调用 xv6 的 sleep 系统调用
    // 这个 sleep() 是 user/user.h 中声明的用户态接口函数
    // 它会触发进入内核执行 sys_sleep
    sleep(ticks);
  32:	44a000ef          	jal	47c <sleep>

    // 程序成功完成，以状态码 0 退出
    exit(0);
  36:	4501                	li	a0,0
  38:	3b4000ef          	jal	3ec <exit>
        fprintf(2, "sleep: 无效的时间间隔 '%s'\n", argv[1]);
  3c:	6490                	ld	a2,8(s1)
  3e:	00001597          	auipc	a1,0x1
  42:	9da58593          	addi	a1,a1,-1574 # a18 <malloc+0x118>
  46:	4509                	li	a0,2
  48:	7da000ef          	jal	822 <fprintf>
        exit(1);
  4c:	4505                	li	a0,1
  4e:	39e000ef          	jal	3ec <exit>

0000000000000052 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  52:	1141                	addi	sp,sp,-16
  54:	e406                	sd	ra,8(sp)
  56:	e022                	sd	s0,0(sp)
  58:	0800                	addi	s0,sp,16
  extern int main();
  main();
  5a:	fa7ff0ef          	jal	0 <main>
  exit(0);
  5e:	4501                	li	a0,0
  60:	38c000ef          	jal	3ec <exit>

0000000000000064 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  64:	1141                	addi	sp,sp,-16
  66:	e422                	sd	s0,8(sp)
  68:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6a:	87aa                	mv	a5,a0
  6c:	0585                	addi	a1,a1,1
  6e:	0785                	addi	a5,a5,1
  70:	fff5c703          	lbu	a4,-1(a1)
  74:	fee78fa3          	sb	a4,-1(a5)
  78:	fb75                	bnez	a4,6c <strcpy+0x8>
    ;
  return os;
}
  7a:	6422                	ld	s0,8(sp)
  7c:	0141                	addi	sp,sp,16
  7e:	8082                	ret

0000000000000080 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80:	1141                	addi	sp,sp,-16
  82:	e422                	sd	s0,8(sp)
  84:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cb91                	beqz	a5,9e <strcmp+0x1e>
  8c:	0005c703          	lbu	a4,0(a1)
  90:	00f71763          	bne	a4,a5,9e <strcmp+0x1e>
    p++, q++;
  94:	0505                	addi	a0,a0,1
  96:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	fbe5                	bnez	a5,8c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  9e:	0005c503          	lbu	a0,0(a1)
}
  a2:	40a7853b          	subw	a0,a5,a0
  a6:	6422                	ld	s0,8(sp)
  a8:	0141                	addi	sp,sp,16
  aa:	8082                	ret

00000000000000ac <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e422                	sd	s0,8(sp)
  b0:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q) {
  b2:	ce11                	beqz	a2,ce <strncmp+0x22>
  b4:	00054783          	lbu	a5,0(a0)
  b8:	cf89                	beqz	a5,d2 <strncmp+0x26>
  ba:	0005c703          	lbu	a4,0(a1)
  be:	00f71a63          	bne	a4,a5,d2 <strncmp+0x26>
    n--;
  c2:	367d                	addiw	a2,a2,-1
    p++;
  c4:	0505                	addi	a0,a0,1
    q++;
  c6:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q) {
  c8:	f675                	bnez	a2,b4 <strncmp+0x8>
  }
  if(n == 0)
    return 0;
  ca:	4501                	li	a0,0
  cc:	a801                	j	dc <strncmp+0x30>
  ce:	4501                	li	a0,0
  d0:	a031                	j	dc <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
  d2:	00054503          	lbu	a0,0(a0)
  d6:	0005c783          	lbu	a5,0(a1)
  da:	9d1d                	subw	a0,a0,a5
}
  dc:	6422                	ld	s0,8(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret

00000000000000e2 <strlen>:

uint
strlen(const char *s)
{
  e2:	1141                	addi	sp,sp,-16
  e4:	e422                	sd	s0,8(sp)
  e6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e8:	00054783          	lbu	a5,0(a0)
  ec:	cf91                	beqz	a5,108 <strlen+0x26>
  ee:	0505                	addi	a0,a0,1
  f0:	87aa                	mv	a5,a0
  f2:	86be                	mv	a3,a5
  f4:	0785                	addi	a5,a5,1
  f6:	fff7c703          	lbu	a4,-1(a5)
  fa:	ff65                	bnez	a4,f2 <strlen+0x10>
  fc:	40a6853b          	subw	a0,a3,a0
 100:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 102:	6422                	ld	s0,8(sp)
 104:	0141                	addi	sp,sp,16
 106:	8082                	ret
  for(n = 0; s[n]; n++)
 108:	4501                	li	a0,0
 10a:	bfe5                	j	102 <strlen+0x20>

000000000000010c <memset>:

void*
memset(void *dst, int c, uint n)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 112:	ca19                	beqz	a2,128 <memset+0x1c>
 114:	87aa                	mv	a5,a0
 116:	1602                	slli	a2,a2,0x20
 118:	9201                	srli	a2,a2,0x20
 11a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 11e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 122:	0785                	addi	a5,a5,1
 124:	fee79de3          	bne	a5,a4,11e <memset+0x12>
  }
  return dst;
}
 128:	6422                	ld	s0,8(sp)
 12a:	0141                	addi	sp,sp,16
 12c:	8082                	ret

000000000000012e <strchr>:

char*
strchr(const char *s, char c)
{
 12e:	1141                	addi	sp,sp,-16
 130:	e422                	sd	s0,8(sp)
 132:	0800                	addi	s0,sp,16
  for(; *s; s++)
 134:	00054783          	lbu	a5,0(a0)
 138:	cb99                	beqz	a5,14e <strchr+0x20>
    if(*s == c)
 13a:	00f58763          	beq	a1,a5,148 <strchr+0x1a>
  for(; *s; s++)
 13e:	0505                	addi	a0,a0,1
 140:	00054783          	lbu	a5,0(a0)
 144:	fbfd                	bnez	a5,13a <strchr+0xc>
      return (char*)s;
  return 0;
 146:	4501                	li	a0,0
}
 148:	6422                	ld	s0,8(sp)
 14a:	0141                	addi	sp,sp,16
 14c:	8082                	ret
  return 0;
 14e:	4501                	li	a0,0
 150:	bfe5                	j	148 <strchr+0x1a>

0000000000000152 <gets>:

char*
gets(char *buf, int max)
{
 152:	711d                	addi	sp,sp,-96
 154:	ec86                	sd	ra,88(sp)
 156:	e8a2                	sd	s0,80(sp)
 158:	e4a6                	sd	s1,72(sp)
 15a:	e0ca                	sd	s2,64(sp)
 15c:	fc4e                	sd	s3,56(sp)
 15e:	f852                	sd	s4,48(sp)
 160:	f456                	sd	s5,40(sp)
 162:	f05a                	sd	s6,32(sp)
 164:	ec5e                	sd	s7,24(sp)
 166:	1080                	addi	s0,sp,96
 168:	8baa                	mv	s7,a0
 16a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16c:	892a                	mv	s2,a0
 16e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 170:	4aa9                	li	s5,10
 172:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 174:	89a6                	mv	s3,s1
 176:	2485                	addiw	s1,s1,1
 178:	0344d663          	bge	s1,s4,1a4 <gets+0x52>
    cc = read(0, &c, 1);
 17c:	4605                	li	a2,1
 17e:	faf40593          	addi	a1,s0,-81
 182:	4501                	li	a0,0
 184:	280000ef          	jal	404 <read>
    if(cc < 1)
 188:	00a05e63          	blez	a0,1a4 <gets+0x52>
    buf[i++] = c;
 18c:	faf44783          	lbu	a5,-81(s0)
 190:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 194:	01578763          	beq	a5,s5,1a2 <gets+0x50>
 198:	0905                	addi	s2,s2,1
 19a:	fd679de3          	bne	a5,s6,174 <gets+0x22>
    buf[i++] = c;
 19e:	89a6                	mv	s3,s1
 1a0:	a011                	j	1a4 <gets+0x52>
 1a2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a4:	99de                	add	s3,s3,s7
 1a6:	00098023          	sb	zero,0(s3)
  return buf;
}
 1aa:	855e                	mv	a0,s7
 1ac:	60e6                	ld	ra,88(sp)
 1ae:	6446                	ld	s0,80(sp)
 1b0:	64a6                	ld	s1,72(sp)
 1b2:	6906                	ld	s2,64(sp)
 1b4:	79e2                	ld	s3,56(sp)
 1b6:	7a42                	ld	s4,48(sp)
 1b8:	7aa2                	ld	s5,40(sp)
 1ba:	7b02                	ld	s6,32(sp)
 1bc:	6be2                	ld	s7,24(sp)
 1be:	6125                	addi	sp,sp,96
 1c0:	8082                	ret

00000000000001c2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c2:	1101                	addi	sp,sp,-32
 1c4:	ec06                	sd	ra,24(sp)
 1c6:	e822                	sd	s0,16(sp)
 1c8:	e04a                	sd	s2,0(sp)
 1ca:	1000                	addi	s0,sp,32
 1cc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ce:	4581                	li	a1,0
 1d0:	25c000ef          	jal	42c <open>
  if(fd < 0)
 1d4:	02054263          	bltz	a0,1f8 <stat+0x36>
 1d8:	e426                	sd	s1,8(sp)
 1da:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1dc:	85ca                	mv	a1,s2
 1de:	266000ef          	jal	444 <fstat>
 1e2:	892a                	mv	s2,a0
  close(fd);
 1e4:	8526                	mv	a0,s1
 1e6:	22e000ef          	jal	414 <close>
  return r;
 1ea:	64a2                	ld	s1,8(sp)
}
 1ec:	854a                	mv	a0,s2
 1ee:	60e2                	ld	ra,24(sp)
 1f0:	6442                	ld	s0,16(sp)
 1f2:	6902                	ld	s2,0(sp)
 1f4:	6105                	addi	sp,sp,32
 1f6:	8082                	ret
    return -1;
 1f8:	597d                	li	s2,-1
 1fa:	bfcd                	j	1ec <stat+0x2a>

00000000000001fc <atoi>:

int
atoi(const char *s)
{
 1fc:	1141                	addi	sp,sp,-16
 1fe:	e422                	sd	s0,8(sp)
 200:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 202:	00054683          	lbu	a3,0(a0)
 206:	fd06879b          	addiw	a5,a3,-48
 20a:	0ff7f793          	zext.b	a5,a5
 20e:	4625                	li	a2,9
 210:	02f66863          	bltu	a2,a5,240 <atoi+0x44>
 214:	872a                	mv	a4,a0
  n = 0;
 216:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 218:	0705                	addi	a4,a4,1
 21a:	0025179b          	slliw	a5,a0,0x2
 21e:	9fa9                	addw	a5,a5,a0
 220:	0017979b          	slliw	a5,a5,0x1
 224:	9fb5                	addw	a5,a5,a3
 226:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 22a:	00074683          	lbu	a3,0(a4)
 22e:	fd06879b          	addiw	a5,a3,-48
 232:	0ff7f793          	zext.b	a5,a5
 236:	fef671e3          	bgeu	a2,a5,218 <atoi+0x1c>
  return n;
}
 23a:	6422                	ld	s0,8(sp)
 23c:	0141                	addi	sp,sp,16
 23e:	8082                	ret
  n = 0;
 240:	4501                	li	a0,0
 242:	bfe5                	j	23a <atoi+0x3e>

0000000000000244 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 244:	1141                	addi	sp,sp,-16
 246:	e422                	sd	s0,8(sp)
 248:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 24a:	02b57463          	bgeu	a0,a1,272 <memmove+0x2e>
    while(n-- > 0)
 24e:	00c05f63          	blez	a2,26c <memmove+0x28>
 252:	1602                	slli	a2,a2,0x20
 254:	9201                	srli	a2,a2,0x20
 256:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 25a:	872a                	mv	a4,a0
      *dst++ = *src++;
 25c:	0585                	addi	a1,a1,1
 25e:	0705                	addi	a4,a4,1
 260:	fff5c683          	lbu	a3,-1(a1)
 264:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 268:	fef71ae3          	bne	a4,a5,25c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret
    dst += n;
 272:	00c50733          	add	a4,a0,a2
    src += n;
 276:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 278:	fec05ae3          	blez	a2,26c <memmove+0x28>
 27c:	fff6079b          	addiw	a5,a2,-1
 280:	1782                	slli	a5,a5,0x20
 282:	9381                	srli	a5,a5,0x20
 284:	fff7c793          	not	a5,a5
 288:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 28a:	15fd                	addi	a1,a1,-1
 28c:	177d                	addi	a4,a4,-1
 28e:	0005c683          	lbu	a3,0(a1)
 292:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 296:	fee79ae3          	bne	a5,a4,28a <memmove+0x46>
 29a:	bfc9                	j	26c <memmove+0x28>

000000000000029c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 29c:	1141                	addi	sp,sp,-16
 29e:	e422                	sd	s0,8(sp)
 2a0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a2:	ca05                	beqz	a2,2d2 <memcmp+0x36>
 2a4:	fff6069b          	addiw	a3,a2,-1
 2a8:	1682                	slli	a3,a3,0x20
 2aa:	9281                	srli	a3,a3,0x20
 2ac:	0685                	addi	a3,a3,1
 2ae:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2b0:	00054783          	lbu	a5,0(a0)
 2b4:	0005c703          	lbu	a4,0(a1)
 2b8:	00e79863          	bne	a5,a4,2c8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2bc:	0505                	addi	a0,a0,1
    p2++;
 2be:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c0:	fed518e3          	bne	a0,a3,2b0 <memcmp+0x14>
  }
  return 0;
 2c4:	4501                	li	a0,0
 2c6:	a019                	j	2cc <memcmp+0x30>
      return *p1 - *p2;
 2c8:	40e7853b          	subw	a0,a5,a4
}
 2cc:	6422                	ld	s0,8(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret
  return 0;
 2d2:	4501                	li	a0,0
 2d4:	bfe5                	j	2cc <memcmp+0x30>

00000000000002d6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e406                	sd	ra,8(sp)
 2da:	e022                	sd	s0,0(sp)
 2dc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2de:	f67ff0ef          	jal	244 <memmove>
}
 2e2:	60a2                	ld	ra,8(sp)
 2e4:	6402                	ld	s0,0(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <simplesort>:

void
simplesort(void *base, uint nmemb, uint size, int (*compar)(const void *, const void *))
{
 2ea:	7119                	addi	sp,sp,-128
 2ec:	fc86                	sd	ra,120(sp)
 2ee:	f8a2                	sd	s0,112(sp)
 2f0:	0100                	addi	s0,sp,128
 2f2:	f8b43423          	sd	a1,-120(s0)
  char *arr = (char *)base; // Treat array as char array for byte-level manipulation
  char *temp;               // Temporary storage for an element

  if (nmemb <= 1 || size == 0) {
 2f6:	4785                	li	a5,1
 2f8:	00b7fc63          	bgeu	a5,a1,310 <simplesort+0x26>
 2fc:	e8d2                	sd	s4,80(sp)
 2fe:	e4d6                	sd	s5,72(sp)
 300:	f466                	sd	s9,40(sp)
 302:	8aaa                	mv	s5,a0
 304:	8a32                	mv	s4,a2
 306:	8cb6                	mv	s9,a3
 308:	ea01                	bnez	a2,318 <simplesort+0x2e>
 30a:	6a46                	ld	s4,80(sp)
 30c:	6aa6                	ld	s5,72(sp)
 30e:	7ca2                	ld	s9,40(sp)
    // Place temp at its correct position
    memmove(arr + j * size, temp, size);
  }

  free(temp); // Free temporary space
 310:	70e6                	ld	ra,120(sp)
 312:	7446                	ld	s0,112(sp)
 314:	6109                	addi	sp,sp,128
 316:	8082                	ret
 318:	fc5e                	sd	s7,56(sp)
 31a:	f862                	sd	s8,48(sp)
 31c:	f06a                	sd	s10,32(sp)
 31e:	ec6e                	sd	s11,24(sp)
  temp = malloc(size); // Allocate temporary space for one element
 320:	8532                	mv	a0,a2
 322:	5de000ef          	jal	900 <malloc>
 326:	8baa                	mv	s7,a0
  if (temp == 0) {
 328:	4d81                	li	s11,0
  for (uint i = 1; i < nmemb; i++) {
 32a:	4d05                	li	s10,1
    memmove(temp, arr + i * size, size);
 32c:	000a0c1b          	sext.w	s8,s4
  if (temp == 0) {
 330:	c511                	beqz	a0,33c <simplesort+0x52>
 332:	f4a6                	sd	s1,104(sp)
 334:	f0ca                	sd	s2,96(sp)
 336:	ecce                	sd	s3,88(sp)
 338:	e0da                	sd	s6,64(sp)
 33a:	a82d                	j	374 <simplesort+0x8a>
    printf("simplesort: malloc failed, cannot sort\n");
 33c:	00000517          	auipc	a0,0x0
 340:	70450513          	addi	a0,a0,1796 # a40 <malloc+0x140>
 344:	508000ef          	jal	84c <printf>
    return;
 348:	6a46                	ld	s4,80(sp)
 34a:	6aa6                	ld	s5,72(sp)
 34c:	7be2                	ld	s7,56(sp)
 34e:	7c42                	ld	s8,48(sp)
 350:	7ca2                	ld	s9,40(sp)
 352:	7d02                	ld	s10,32(sp)
 354:	6de2                	ld	s11,24(sp)
 356:	bf6d                	j	310 <simplesort+0x26>
    memmove(arr + j * size, temp, size);
 358:	036a053b          	mulw	a0,s4,s6
 35c:	1502                	slli	a0,a0,0x20
 35e:	9101                	srli	a0,a0,0x20
 360:	8662                	mv	a2,s8
 362:	85de                	mv	a1,s7
 364:	9556                	add	a0,a0,s5
 366:	edfff0ef          	jal	244 <memmove>
  for (uint i = 1; i < nmemb; i++) {
 36a:	2d05                	addiw	s10,s10,1
 36c:	f8843783          	ld	a5,-120(s0)
 370:	05a78b63          	beq	a5,s10,3c6 <simplesort+0xdc>
    memmove(temp, arr + i * size, size);
 374:	000d899b          	sext.w	s3,s11
 378:	01ba05bb          	addw	a1,s4,s11
 37c:	00058d9b          	sext.w	s11,a1
 380:	1582                	slli	a1,a1,0x20
 382:	9181                	srli	a1,a1,0x20
 384:	8662                	mv	a2,s8
 386:	95d6                	add	a1,a1,s5
 388:	855e                	mv	a0,s7
 38a:	ebbff0ef          	jal	244 <memmove>
    uint j = i;
 38e:	896a                	mv	s2,s10
 390:	00090b1b          	sext.w	s6,s2
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 394:	397d                	addiw	s2,s2,-1
 396:	02099493          	slli	s1,s3,0x20
 39a:	9081                	srli	s1,s1,0x20
 39c:	94d6                	add	s1,s1,s5
 39e:	85de                	mv	a1,s7
 3a0:	8526                	mv	a0,s1
 3a2:	9c82                	jalr	s9
 3a4:	faa05ae3          	blez	a0,358 <simplesort+0x6e>
      memmove(arr + j * size, arr + (j - 1) * size, size); // Shift element
 3a8:	0149853b          	addw	a0,s3,s4
 3ac:	1502                	slli	a0,a0,0x20
 3ae:	9101                	srli	a0,a0,0x20
 3b0:	8662                	mv	a2,s8
 3b2:	85a6                	mv	a1,s1
 3b4:	9556                	add	a0,a0,s5
 3b6:	e8fff0ef          	jal	244 <memmove>
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 3ba:	414989bb          	subw	s3,s3,s4
 3be:	fc0919e3          	bnez	s2,390 <simplesort+0xa6>
 3c2:	8b4a                	mv	s6,s2
 3c4:	bf51                	j	358 <simplesort+0x6e>
  free(temp); // Free temporary space
 3c6:	855e                	mv	a0,s7
 3c8:	4b6000ef          	jal	87e <free>
 3cc:	74a6                	ld	s1,104(sp)
 3ce:	7906                	ld	s2,96(sp)
 3d0:	69e6                	ld	s3,88(sp)
 3d2:	6a46                	ld	s4,80(sp)
 3d4:	6aa6                	ld	s5,72(sp)
 3d6:	6b06                	ld	s6,64(sp)
 3d8:	7be2                	ld	s7,56(sp)
 3da:	7c42                	ld	s8,48(sp)
 3dc:	7ca2                	ld	s9,40(sp)
 3de:	7d02                	ld	s10,32(sp)
 3e0:	6de2                	ld	s11,24(sp)
 3e2:	b73d                	j	310 <simplesort+0x26>

00000000000003e4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3e4:	4885                	li	a7,1
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ec:	4889                	li	a7,2
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3f4:	488d                	li	a7,3
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3fc:	4891                	li	a7,4
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <read>:
.global read
read:
 li a7, SYS_read
 404:	4895                	li	a7,5
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <write>:
.global write
write:
 li a7, SYS_write
 40c:	48c1                	li	a7,16
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <close>:
.global close
close:
 li a7, SYS_close
 414:	48d5                	li	a7,21
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <kill>:
.global kill
kill:
 li a7, SYS_kill
 41c:	4899                	li	a7,6
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <exec>:
.global exec
exec:
 li a7, SYS_exec
 424:	489d                	li	a7,7
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <open>:
.global open
open:
 li a7, SYS_open
 42c:	48bd                	li	a7,15
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 434:	48c5                	li	a7,17
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 43c:	48c9                	li	a7,18
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 444:	48a1                	li	a7,8
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <link>:
.global link
link:
 li a7, SYS_link
 44c:	48cd                	li	a7,19
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 454:	48d1                	li	a7,20
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 45c:	48a5                	li	a7,9
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <dup>:
.global dup
dup:
 li a7, SYS_dup
 464:	48a9                	li	a7,10
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 46c:	48ad                	li	a7,11
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 474:	48b1                	li	a7,12
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 47c:	48b5                	li	a7,13
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 484:	48b9                	li	a7,14
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 48c:	48dd                	li	a7,23
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <statistics>:
.global statistics
statistics:
 li a7, SYS_statistics
 494:	48e1                	li	a7,24
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <reset_stats>:
.global reset_stats
reset_stats:
 li a7, SYS_reset_stats
 49c:	48e5                	li	a7,25
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <resetlockstats>:
.global resetlockstats
resetlockstats:
 li a7, SYS_resetlockstats
 4a4:	48e9                	li	a7,26
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <getlockstats>:
.global getlockstats
getlockstats:
 li a7, SYS_getlockstats
 4ac:	48ed                	li	a7,27
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <trace>:
.global trace
trace:
 li a7, SYS_trace
 4b4:	48d9                	li	a7,22
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 4bc:	48f1                	li	a7,28
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <ugetpid>:
.global ugetpid
ugetpid:
 li a7, SYS_ugetpid
 4c4:	48f5                	li	a7,29
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 4cc:	48f9                	li	a7,30
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4d4:	1101                	addi	sp,sp,-32
 4d6:	ec06                	sd	ra,24(sp)
 4d8:	e822                	sd	s0,16(sp)
 4da:	1000                	addi	s0,sp,32
 4dc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4e0:	4605                	li	a2,1
 4e2:	fef40593          	addi	a1,s0,-17
 4e6:	f27ff0ef          	jal	40c <write>
}
 4ea:	60e2                	ld	ra,24(sp)
 4ec:	6442                	ld	s0,16(sp)
 4ee:	6105                	addi	sp,sp,32
 4f0:	8082                	ret

00000000000004f2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f2:	7139                	addi	sp,sp,-64
 4f4:	fc06                	sd	ra,56(sp)
 4f6:	f822                	sd	s0,48(sp)
 4f8:	f426                	sd	s1,40(sp)
 4fa:	0080                	addi	s0,sp,64
 4fc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4fe:	c299                	beqz	a3,504 <printint+0x12>
 500:	0805c963          	bltz	a1,592 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 504:	2581                	sext.w	a1,a1
  neg = 0;
 506:	4881                	li	a7,0
 508:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 50c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 50e:	2601                	sext.w	a2,a2
 510:	00000517          	auipc	a0,0x0
 514:	56050513          	addi	a0,a0,1376 # a70 <digits>
 518:	883a                	mv	a6,a4
 51a:	2705                	addiw	a4,a4,1
 51c:	02c5f7bb          	remuw	a5,a1,a2
 520:	1782                	slli	a5,a5,0x20
 522:	9381                	srli	a5,a5,0x20
 524:	97aa                	add	a5,a5,a0
 526:	0007c783          	lbu	a5,0(a5)
 52a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 52e:	0005879b          	sext.w	a5,a1
 532:	02c5d5bb          	divuw	a1,a1,a2
 536:	0685                	addi	a3,a3,1
 538:	fec7f0e3          	bgeu	a5,a2,518 <printint+0x26>
  if(neg)
 53c:	00088c63          	beqz	a7,554 <printint+0x62>
    buf[i++] = '-';
 540:	fd070793          	addi	a5,a4,-48
 544:	00878733          	add	a4,a5,s0
 548:	02d00793          	li	a5,45
 54c:	fef70823          	sb	a5,-16(a4)
 550:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 554:	02e05a63          	blez	a4,588 <printint+0x96>
 558:	f04a                	sd	s2,32(sp)
 55a:	ec4e                	sd	s3,24(sp)
 55c:	fc040793          	addi	a5,s0,-64
 560:	00e78933          	add	s2,a5,a4
 564:	fff78993          	addi	s3,a5,-1
 568:	99ba                	add	s3,s3,a4
 56a:	377d                	addiw	a4,a4,-1
 56c:	1702                	slli	a4,a4,0x20
 56e:	9301                	srli	a4,a4,0x20
 570:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 574:	fff94583          	lbu	a1,-1(s2)
 578:	8526                	mv	a0,s1
 57a:	f5bff0ef          	jal	4d4 <putc>
  while(--i >= 0)
 57e:	197d                	addi	s2,s2,-1
 580:	ff391ae3          	bne	s2,s3,574 <printint+0x82>
 584:	7902                	ld	s2,32(sp)
 586:	69e2                	ld	s3,24(sp)
}
 588:	70e2                	ld	ra,56(sp)
 58a:	7442                	ld	s0,48(sp)
 58c:	74a2                	ld	s1,40(sp)
 58e:	6121                	addi	sp,sp,64
 590:	8082                	ret
    x = -xx;
 592:	40b005bb          	negw	a1,a1
    neg = 1;
 596:	4885                	li	a7,1
    x = -xx;
 598:	bf85                	j	508 <printint+0x16>

000000000000059a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 59a:	711d                	addi	sp,sp,-96
 59c:	ec86                	sd	ra,88(sp)
 59e:	e8a2                	sd	s0,80(sp)
 5a0:	e0ca                	sd	s2,64(sp)
 5a2:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5a4:	0005c903          	lbu	s2,0(a1)
 5a8:	26090863          	beqz	s2,818 <vprintf+0x27e>
 5ac:	e4a6                	sd	s1,72(sp)
 5ae:	fc4e                	sd	s3,56(sp)
 5b0:	f852                	sd	s4,48(sp)
 5b2:	f456                	sd	s5,40(sp)
 5b4:	f05a                	sd	s6,32(sp)
 5b6:	ec5e                	sd	s7,24(sp)
 5b8:	e862                	sd	s8,16(sp)
 5ba:	e466                	sd	s9,8(sp)
 5bc:	8b2a                	mv	s6,a0
 5be:	8a2e                	mv	s4,a1
 5c0:	8bb2                	mv	s7,a2
  state = 0;
 5c2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5c4:	4481                	li	s1,0
 5c6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5c8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5cc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5d0:	06c00c93          	li	s9,108
 5d4:	a005                	j	5f4 <vprintf+0x5a>
        putc(fd, c0);
 5d6:	85ca                	mv	a1,s2
 5d8:	855a                	mv	a0,s6
 5da:	efbff0ef          	jal	4d4 <putc>
 5de:	a019                	j	5e4 <vprintf+0x4a>
    } else if(state == '%'){
 5e0:	03598263          	beq	s3,s5,604 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5e4:	2485                	addiw	s1,s1,1
 5e6:	8726                	mv	a4,s1
 5e8:	009a07b3          	add	a5,s4,s1
 5ec:	0007c903          	lbu	s2,0(a5)
 5f0:	20090c63          	beqz	s2,808 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 5f4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5f8:	fe0994e3          	bnez	s3,5e0 <vprintf+0x46>
      if(c0 == '%'){
 5fc:	fd579de3          	bne	a5,s5,5d6 <vprintf+0x3c>
        state = '%';
 600:	89be                	mv	s3,a5
 602:	b7cd                	j	5e4 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 604:	00ea06b3          	add	a3,s4,a4
 608:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 60c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 60e:	c681                	beqz	a3,616 <vprintf+0x7c>
 610:	9752                	add	a4,a4,s4
 612:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 616:	03878f63          	beq	a5,s8,654 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 61a:	05978963          	beq	a5,s9,66c <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 61e:	07500713          	li	a4,117
 622:	0ee78363          	beq	a5,a4,708 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 626:	07800713          	li	a4,120
 62a:	12e78563          	beq	a5,a4,754 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 62e:	07000713          	li	a4,112
 632:	14e78a63          	beq	a5,a4,786 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 636:	07300713          	li	a4,115
 63a:	18e78a63          	beq	a5,a4,7ce <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 63e:	02500713          	li	a4,37
 642:	04e79563          	bne	a5,a4,68c <vprintf+0xf2>
        putc(fd, '%');
 646:	02500593          	li	a1,37
 64a:	855a                	mv	a0,s6
 64c:	e89ff0ef          	jal	4d4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 650:	4981                	li	s3,0
 652:	bf49                	j	5e4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 654:	008b8913          	addi	s2,s7,8
 658:	4685                	li	a3,1
 65a:	4629                	li	a2,10
 65c:	000ba583          	lw	a1,0(s7)
 660:	855a                	mv	a0,s6
 662:	e91ff0ef          	jal	4f2 <printint>
 666:	8bca                	mv	s7,s2
      state = 0;
 668:	4981                	li	s3,0
 66a:	bfad                	j	5e4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 66c:	06400793          	li	a5,100
 670:	02f68963          	beq	a3,a5,6a2 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 674:	06c00793          	li	a5,108
 678:	04f68263          	beq	a3,a5,6bc <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 67c:	07500793          	li	a5,117
 680:	0af68063          	beq	a3,a5,720 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 684:	07800793          	li	a5,120
 688:	0ef68263          	beq	a3,a5,76c <vprintf+0x1d2>
        putc(fd, '%');
 68c:	02500593          	li	a1,37
 690:	855a                	mv	a0,s6
 692:	e43ff0ef          	jal	4d4 <putc>
        putc(fd, c0);
 696:	85ca                	mv	a1,s2
 698:	855a                	mv	a0,s6
 69a:	e3bff0ef          	jal	4d4 <putc>
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	b791                	j	5e4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6a2:	008b8913          	addi	s2,s7,8
 6a6:	4685                	li	a3,1
 6a8:	4629                	li	a2,10
 6aa:	000ba583          	lw	a1,0(s7)
 6ae:	855a                	mv	a0,s6
 6b0:	e43ff0ef          	jal	4f2 <printint>
        i += 1;
 6b4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b6:	8bca                	mv	s7,s2
      state = 0;
 6b8:	4981                	li	s3,0
        i += 1;
 6ba:	b72d                	j	5e4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6bc:	06400793          	li	a5,100
 6c0:	02f60763          	beq	a2,a5,6ee <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6c4:	07500793          	li	a5,117
 6c8:	06f60963          	beq	a2,a5,73a <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6cc:	07800793          	li	a5,120
 6d0:	faf61ee3          	bne	a2,a5,68c <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d4:	008b8913          	addi	s2,s7,8
 6d8:	4681                	li	a3,0
 6da:	4641                	li	a2,16
 6dc:	000ba583          	lw	a1,0(s7)
 6e0:	855a                	mv	a0,s6
 6e2:	e11ff0ef          	jal	4f2 <printint>
        i += 2;
 6e6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e8:	8bca                	mv	s7,s2
      state = 0;
 6ea:	4981                	li	s3,0
        i += 2;
 6ec:	bde5                	j	5e4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ee:	008b8913          	addi	s2,s7,8
 6f2:	4685                	li	a3,1
 6f4:	4629                	li	a2,10
 6f6:	000ba583          	lw	a1,0(s7)
 6fa:	855a                	mv	a0,s6
 6fc:	df7ff0ef          	jal	4f2 <printint>
        i += 2;
 700:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 702:	8bca                	mv	s7,s2
      state = 0;
 704:	4981                	li	s3,0
        i += 2;
 706:	bdf9                	j	5e4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 708:	008b8913          	addi	s2,s7,8
 70c:	4681                	li	a3,0
 70e:	4629                	li	a2,10
 710:	000ba583          	lw	a1,0(s7)
 714:	855a                	mv	a0,s6
 716:	dddff0ef          	jal	4f2 <printint>
 71a:	8bca                	mv	s7,s2
      state = 0;
 71c:	4981                	li	s3,0
 71e:	b5d9                	j	5e4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 720:	008b8913          	addi	s2,s7,8
 724:	4681                	li	a3,0
 726:	4629                	li	a2,10
 728:	000ba583          	lw	a1,0(s7)
 72c:	855a                	mv	a0,s6
 72e:	dc5ff0ef          	jal	4f2 <printint>
        i += 1;
 732:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 734:	8bca                	mv	s7,s2
      state = 0;
 736:	4981                	li	s3,0
        i += 1;
 738:	b575                	j	5e4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 73a:	008b8913          	addi	s2,s7,8
 73e:	4681                	li	a3,0
 740:	4629                	li	a2,10
 742:	000ba583          	lw	a1,0(s7)
 746:	855a                	mv	a0,s6
 748:	dabff0ef          	jal	4f2 <printint>
        i += 2;
 74c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 74e:	8bca                	mv	s7,s2
      state = 0;
 750:	4981                	li	s3,0
        i += 2;
 752:	bd49                	j	5e4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 754:	008b8913          	addi	s2,s7,8
 758:	4681                	li	a3,0
 75a:	4641                	li	a2,16
 75c:	000ba583          	lw	a1,0(s7)
 760:	855a                	mv	a0,s6
 762:	d91ff0ef          	jal	4f2 <printint>
 766:	8bca                	mv	s7,s2
      state = 0;
 768:	4981                	li	s3,0
 76a:	bdad                	j	5e4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 76c:	008b8913          	addi	s2,s7,8
 770:	4681                	li	a3,0
 772:	4641                	li	a2,16
 774:	000ba583          	lw	a1,0(s7)
 778:	855a                	mv	a0,s6
 77a:	d79ff0ef          	jal	4f2 <printint>
        i += 1;
 77e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 780:	8bca                	mv	s7,s2
      state = 0;
 782:	4981                	li	s3,0
        i += 1;
 784:	b585                	j	5e4 <vprintf+0x4a>
 786:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 788:	008b8d13          	addi	s10,s7,8
 78c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 790:	03000593          	li	a1,48
 794:	855a                	mv	a0,s6
 796:	d3fff0ef          	jal	4d4 <putc>
  putc(fd, 'x');
 79a:	07800593          	li	a1,120
 79e:	855a                	mv	a0,s6
 7a0:	d35ff0ef          	jal	4d4 <putc>
 7a4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7a6:	00000b97          	auipc	s7,0x0
 7aa:	2cab8b93          	addi	s7,s7,714 # a70 <digits>
 7ae:	03c9d793          	srli	a5,s3,0x3c
 7b2:	97de                	add	a5,a5,s7
 7b4:	0007c583          	lbu	a1,0(a5)
 7b8:	855a                	mv	a0,s6
 7ba:	d1bff0ef          	jal	4d4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7be:	0992                	slli	s3,s3,0x4
 7c0:	397d                	addiw	s2,s2,-1
 7c2:	fe0916e3          	bnez	s2,7ae <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7c6:	8bea                	mv	s7,s10
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	6d02                	ld	s10,0(sp)
 7cc:	bd21                	j	5e4 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7ce:	008b8993          	addi	s3,s7,8
 7d2:	000bb903          	ld	s2,0(s7)
 7d6:	00090f63          	beqz	s2,7f4 <vprintf+0x25a>
        for(; *s; s++)
 7da:	00094583          	lbu	a1,0(s2)
 7de:	c195                	beqz	a1,802 <vprintf+0x268>
          putc(fd, *s);
 7e0:	855a                	mv	a0,s6
 7e2:	cf3ff0ef          	jal	4d4 <putc>
        for(; *s; s++)
 7e6:	0905                	addi	s2,s2,1
 7e8:	00094583          	lbu	a1,0(s2)
 7ec:	f9f5                	bnez	a1,7e0 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7ee:	8bce                	mv	s7,s3
      state = 0;
 7f0:	4981                	li	s3,0
 7f2:	bbcd                	j	5e4 <vprintf+0x4a>
          s = "(null)";
 7f4:	00000917          	auipc	s2,0x0
 7f8:	27490913          	addi	s2,s2,628 # a68 <malloc+0x168>
        for(; *s; s++)
 7fc:	02800593          	li	a1,40
 800:	b7c5                	j	7e0 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 802:	8bce                	mv	s7,s3
      state = 0;
 804:	4981                	li	s3,0
 806:	bbf9                	j	5e4 <vprintf+0x4a>
 808:	64a6                	ld	s1,72(sp)
 80a:	79e2                	ld	s3,56(sp)
 80c:	7a42                	ld	s4,48(sp)
 80e:	7aa2                	ld	s5,40(sp)
 810:	7b02                	ld	s6,32(sp)
 812:	6be2                	ld	s7,24(sp)
 814:	6c42                	ld	s8,16(sp)
 816:	6ca2                	ld	s9,8(sp)
    }
  }
}
 818:	60e6                	ld	ra,88(sp)
 81a:	6446                	ld	s0,80(sp)
 81c:	6906                	ld	s2,64(sp)
 81e:	6125                	addi	sp,sp,96
 820:	8082                	ret

0000000000000822 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 822:	715d                	addi	sp,sp,-80
 824:	ec06                	sd	ra,24(sp)
 826:	e822                	sd	s0,16(sp)
 828:	1000                	addi	s0,sp,32
 82a:	e010                	sd	a2,0(s0)
 82c:	e414                	sd	a3,8(s0)
 82e:	e818                	sd	a4,16(s0)
 830:	ec1c                	sd	a5,24(s0)
 832:	03043023          	sd	a6,32(s0)
 836:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 83a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 83e:	8622                	mv	a2,s0
 840:	d5bff0ef          	jal	59a <vprintf>
}
 844:	60e2                	ld	ra,24(sp)
 846:	6442                	ld	s0,16(sp)
 848:	6161                	addi	sp,sp,80
 84a:	8082                	ret

000000000000084c <printf>:

void
printf(const char *fmt, ...)
{
 84c:	711d                	addi	sp,sp,-96
 84e:	ec06                	sd	ra,24(sp)
 850:	e822                	sd	s0,16(sp)
 852:	1000                	addi	s0,sp,32
 854:	e40c                	sd	a1,8(s0)
 856:	e810                	sd	a2,16(s0)
 858:	ec14                	sd	a3,24(s0)
 85a:	f018                	sd	a4,32(s0)
 85c:	f41c                	sd	a5,40(s0)
 85e:	03043823          	sd	a6,48(s0)
 862:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 866:	00840613          	addi	a2,s0,8
 86a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 86e:	85aa                	mv	a1,a0
 870:	4505                	li	a0,1
 872:	d29ff0ef          	jal	59a <vprintf>
}
 876:	60e2                	ld	ra,24(sp)
 878:	6442                	ld	s0,16(sp)
 87a:	6125                	addi	sp,sp,96
 87c:	8082                	ret

000000000000087e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 87e:	1141                	addi	sp,sp,-16
 880:	e422                	sd	s0,8(sp)
 882:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 884:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 888:	00000797          	auipc	a5,0x0
 88c:	7787b783          	ld	a5,1912(a5) # 1000 <freep>
 890:	a02d                	j	8ba <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 892:	4618                	lw	a4,8(a2)
 894:	9f2d                	addw	a4,a4,a1
 896:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 89a:	6398                	ld	a4,0(a5)
 89c:	6310                	ld	a2,0(a4)
 89e:	a83d                	j	8dc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8a0:	ff852703          	lw	a4,-8(a0)
 8a4:	9f31                	addw	a4,a4,a2
 8a6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8a8:	ff053683          	ld	a3,-16(a0)
 8ac:	a091                	j	8f0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ae:	6398                	ld	a4,0(a5)
 8b0:	00e7e463          	bltu	a5,a4,8b8 <free+0x3a>
 8b4:	00e6ea63          	bltu	a3,a4,8c8 <free+0x4a>
{
 8b8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ba:	fed7fae3          	bgeu	a5,a3,8ae <free+0x30>
 8be:	6398                	ld	a4,0(a5)
 8c0:	00e6e463          	bltu	a3,a4,8c8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c4:	fee7eae3          	bltu	a5,a4,8b8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8c8:	ff852583          	lw	a1,-8(a0)
 8cc:	6390                	ld	a2,0(a5)
 8ce:	02059813          	slli	a6,a1,0x20
 8d2:	01c85713          	srli	a4,a6,0x1c
 8d6:	9736                	add	a4,a4,a3
 8d8:	fae60de3          	beq	a2,a4,892 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8dc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8e0:	4790                	lw	a2,8(a5)
 8e2:	02061593          	slli	a1,a2,0x20
 8e6:	01c5d713          	srli	a4,a1,0x1c
 8ea:	973e                	add	a4,a4,a5
 8ec:	fae68ae3          	beq	a3,a4,8a0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8f0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8f2:	00000717          	auipc	a4,0x0
 8f6:	70f73723          	sd	a5,1806(a4) # 1000 <freep>
}
 8fa:	6422                	ld	s0,8(sp)
 8fc:	0141                	addi	sp,sp,16
 8fe:	8082                	ret

0000000000000900 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 900:	7139                	addi	sp,sp,-64
 902:	fc06                	sd	ra,56(sp)
 904:	f822                	sd	s0,48(sp)
 906:	f426                	sd	s1,40(sp)
 908:	ec4e                	sd	s3,24(sp)
 90a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 90c:	02051493          	slli	s1,a0,0x20
 910:	9081                	srli	s1,s1,0x20
 912:	04bd                	addi	s1,s1,15
 914:	8091                	srli	s1,s1,0x4
 916:	0014899b          	addiw	s3,s1,1
 91a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 91c:	00000517          	auipc	a0,0x0
 920:	6e453503          	ld	a0,1764(a0) # 1000 <freep>
 924:	c915                	beqz	a0,958 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 926:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 928:	4798                	lw	a4,8(a5)
 92a:	08977a63          	bgeu	a4,s1,9be <malloc+0xbe>
 92e:	f04a                	sd	s2,32(sp)
 930:	e852                	sd	s4,16(sp)
 932:	e456                	sd	s5,8(sp)
 934:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 936:	8a4e                	mv	s4,s3
 938:	0009871b          	sext.w	a4,s3
 93c:	6685                	lui	a3,0x1
 93e:	00d77363          	bgeu	a4,a3,944 <malloc+0x44>
 942:	6a05                	lui	s4,0x1
 944:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 948:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 94c:	00000917          	auipc	s2,0x0
 950:	6b490913          	addi	s2,s2,1716 # 1000 <freep>
  if(p == (char*)-1)
 954:	5afd                	li	s5,-1
 956:	a081                	j	996 <malloc+0x96>
 958:	f04a                	sd	s2,32(sp)
 95a:	e852                	sd	s4,16(sp)
 95c:	e456                	sd	s5,8(sp)
 95e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 960:	00000797          	auipc	a5,0x0
 964:	6b078793          	addi	a5,a5,1712 # 1010 <base>
 968:	00000717          	auipc	a4,0x0
 96c:	68f73c23          	sd	a5,1688(a4) # 1000 <freep>
 970:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 972:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 976:	b7c1                	j	936 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 978:	6398                	ld	a4,0(a5)
 97a:	e118                	sd	a4,0(a0)
 97c:	a8a9                	j	9d6 <malloc+0xd6>
  hp->s.size = nu;
 97e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 982:	0541                	addi	a0,a0,16
 984:	efbff0ef          	jal	87e <free>
  return freep;
 988:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 98c:	c12d                	beqz	a0,9ee <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 990:	4798                	lw	a4,8(a5)
 992:	02977263          	bgeu	a4,s1,9b6 <malloc+0xb6>
    if(p == freep)
 996:	00093703          	ld	a4,0(s2)
 99a:	853e                	mv	a0,a5
 99c:	fef719e3          	bne	a4,a5,98e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9a0:	8552                	mv	a0,s4
 9a2:	ad3ff0ef          	jal	474 <sbrk>
  if(p == (char*)-1)
 9a6:	fd551ce3          	bne	a0,s5,97e <malloc+0x7e>
        return 0;
 9aa:	4501                	li	a0,0
 9ac:	7902                	ld	s2,32(sp)
 9ae:	6a42                	ld	s4,16(sp)
 9b0:	6aa2                	ld	s5,8(sp)
 9b2:	6b02                	ld	s6,0(sp)
 9b4:	a03d                	j	9e2 <malloc+0xe2>
 9b6:	7902                	ld	s2,32(sp)
 9b8:	6a42                	ld	s4,16(sp)
 9ba:	6aa2                	ld	s5,8(sp)
 9bc:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9be:	fae48de3          	beq	s1,a4,978 <malloc+0x78>
        p->s.size -= nunits;
 9c2:	4137073b          	subw	a4,a4,s3
 9c6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9c8:	02071693          	slli	a3,a4,0x20
 9cc:	01c6d713          	srli	a4,a3,0x1c
 9d0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9d2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9d6:	00000717          	auipc	a4,0x0
 9da:	62a73523          	sd	a0,1578(a4) # 1000 <freep>
      return (void*)(p + 1);
 9de:	01078513          	addi	a0,a5,16
  }
}
 9e2:	70e2                	ld	ra,56(sp)
 9e4:	7442                	ld	s0,48(sp)
 9e6:	74a2                	ld	s1,40(sp)
 9e8:	69e2                	ld	s3,24(sp)
 9ea:	6121                	addi	sp,sp,64
 9ec:	8082                	ret
 9ee:	7902                	ld	s2,32(sp)
 9f0:	6a42                	ld	s4,16(sp)
 9f2:	6aa2                	ld	s5,8(sp)
 9f4:	6b02                	ld	s6,0(sp)
 9f6:	b7f5                	j	9e2 <malloc+0xe2>
