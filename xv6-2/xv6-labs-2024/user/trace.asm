
user/_trace：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "/home/liuzhh268/Operating_System_Homework/xv6/xv6-labs-2024/kernel/syscall.h" // 包含 SYS_ 定义
#include "/home/liuzhh268/Operating_System_Homework/xv6/xv6-labs-2024/kernel/param.h"

int
main(int argc, char *argv[])
{
   0:	712d                	addi	sp,sp,-288
   2:	ee06                	sd	ra,280(sp)
   4:	ea22                	sd	s0,272(sp)
   6:	1200                	addi	s0,sp,288
  int i;
  char *nargv[MAXARG]; // 用于 exec 的新参数列表

  // 检查参数数量是否足够 (trace mask command [args...])
  if(argc < 3){
   8:	4789                	li	a5,2
   a:	00a7ce63          	blt	a5,a0,26 <main+0x26>
   e:	e626                	sd	s1,264(sp)
  10:	e24a                	sd	s2,256(sp)
    fprintf(2, "用法: trace mask command [args...]\n");
  12:	00001597          	auipc	a1,0x1
  16:	a3e58593          	addi	a1,a1,-1474 # a50 <malloc+0xfa>
  1a:	4509                	li	a0,2
  1c:	05d000ef          	jal	878 <fprintf>
    exit(1);
  20:	4505                	li	a0,1
  22:	420000ef          	jal	442 <exit>
  26:	e626                	sd	s1,264(sp)
  28:	e24a                	sd	s2,256(sp)
  2a:	892a                	mv	s2,a0
  2c:	84ae                	mv	s1,a1
  }

  // 调用 trace 系统调用，设置追踪掩码
  // atoi 用于将字符串类型的掩码转换为整数
  if (trace(atoi(argv[1])) < 0) {
  2e:	6588                	ld	a0,8(a1)
  30:	222000ef          	jal	252 <atoi>
  34:	4d6000ef          	jal	50a <trace>
  38:	04054e63          	bltz	a0,94 <main+0x94>
  3c:	01048593          	addi	a1,s1,16
  40:	ee040713          	addi	a4,s0,-288
  }

  // 准备 exec 的参数列表
  // nargv[0] 是要执行的命令 (argv[2])
  // nargv[1] 是命令的第一个参数 (argv[3])，依此类推
  for(i = 2; i < argc && i < MAXARG; i++){
  44:	4789                	li	a5,2
  46:	02000613          	li	a2,32
    nargv[i-2] = argv[i];
  4a:	6194                	ld	a3,0(a1)
  4c:	e314                	sd	a3,0(a4)
  for(i = 2; i < argc && i < MAXARG; i++){
  4e:	86be                	mv	a3,a5
  50:	2785                	addiw	a5,a5,1
  52:	00f90763          	beq	s2,a5,60 <main+0x60>
  56:	05a1                	addi	a1,a1,8
  58:	0721                	addi	a4,a4,8
  5a:	fec798e3          	bne	a5,a2,4a <main+0x4a>
  5e:	46fd                	li	a3,31
  }
  nargv[i-2] = 0; // 参数列表以 null 指针结束
  60:	36fd                	addiw	a3,a3,-1
  62:	068e                	slli	a3,a3,0x3
  64:	fe068793          	addi	a5,a3,-32
  68:	008786b3          	add	a3,a5,s0
  6c:	f006b023          	sd	zero,-256(a3)

  // 执行目标命令
  exec(nargv[0], nargv);
  70:	ee040593          	addi	a1,s0,-288
  74:	ee043503          	ld	a0,-288(s0)
  78:	402000ef          	jal	47a <exec>

  // 如果 exec 成功，则不会执行到这里
  // 如果 exec 失败，则打印错误并退出
  fprintf(2, "trace: exec %s failed\n", nargv[0]);
  7c:	ee043603          	ld	a2,-288(s0)
  80:	00001597          	auipc	a1,0x1
  84:	a1058593          	addi	a1,a1,-1520 # a90 <malloc+0x13a>
  88:	4509                	li	a0,2
  8a:	7ee000ef          	jal	878 <fprintf>
  exit(1);
  8e:	4505                	li	a0,1
  90:	3b2000ef          	jal	442 <exit>
    fprintf(2, "trace: trace failed\n");
  94:	00001597          	auipc	a1,0x1
  98:	9e458593          	addi	a1,a1,-1564 # a78 <malloc+0x122>
  9c:	4509                	li	a0,2
  9e:	7da000ef          	jal	878 <fprintf>
    exit(1);
  a2:	4505                	li	a0,1
  a4:	39e000ef          	jal	442 <exit>

00000000000000a8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  a8:	1141                	addi	sp,sp,-16
  aa:	e406                	sd	ra,8(sp)
  ac:	e022                	sd	s0,0(sp)
  ae:	0800                	addi	s0,sp,16
  extern int main();
  main();
  b0:	f51ff0ef          	jal	0 <main>
  exit(0);
  b4:	4501                	li	a0,0
  b6:	38c000ef          	jal	442 <exit>

00000000000000ba <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ba:	1141                	addi	sp,sp,-16
  bc:	e422                	sd	s0,8(sp)
  be:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  c0:	87aa                	mv	a5,a0
  c2:	0585                	addi	a1,a1,1
  c4:	0785                	addi	a5,a5,1
  c6:	fff5c703          	lbu	a4,-1(a1)
  ca:	fee78fa3          	sb	a4,-1(a5)
  ce:	fb75                	bnez	a4,c2 <strcpy+0x8>
    ;
  return os;
}
  d0:	6422                	ld	s0,8(sp)
  d2:	0141                	addi	sp,sp,16
  d4:	8082                	ret

00000000000000d6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e422                	sd	s0,8(sp)
  da:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  dc:	00054783          	lbu	a5,0(a0)
  e0:	cb91                	beqz	a5,f4 <strcmp+0x1e>
  e2:	0005c703          	lbu	a4,0(a1)
  e6:	00f71763          	bne	a4,a5,f4 <strcmp+0x1e>
    p++, q++;
  ea:	0505                	addi	a0,a0,1
  ec:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ee:	00054783          	lbu	a5,0(a0)
  f2:	fbe5                	bnez	a5,e2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  f4:	0005c503          	lbu	a0,0(a1)
}
  f8:	40a7853b          	subw	a0,a5,a0
  fc:	6422                	ld	s0,8(sp)
  fe:	0141                	addi	sp,sp,16
 100:	8082                	ret

0000000000000102 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 102:	1141                	addi	sp,sp,-16
 104:	e422                	sd	s0,8(sp)
 106:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q) {
 108:	ce11                	beqz	a2,124 <strncmp+0x22>
 10a:	00054783          	lbu	a5,0(a0)
 10e:	cf89                	beqz	a5,128 <strncmp+0x26>
 110:	0005c703          	lbu	a4,0(a1)
 114:	00f71a63          	bne	a4,a5,128 <strncmp+0x26>
    n--;
 118:	367d                	addiw	a2,a2,-1
    p++;
 11a:	0505                	addi	a0,a0,1
    q++;
 11c:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q) {
 11e:	f675                	bnez	a2,10a <strncmp+0x8>
  }
  if(n == 0)
    return 0;
 120:	4501                	li	a0,0
 122:	a801                	j	132 <strncmp+0x30>
 124:	4501                	li	a0,0
 126:	a031                	j	132 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
 128:	00054503          	lbu	a0,0(a0)
 12c:	0005c783          	lbu	a5,0(a1)
 130:	9d1d                	subw	a0,a0,a5
}
 132:	6422                	ld	s0,8(sp)
 134:	0141                	addi	sp,sp,16
 136:	8082                	ret

0000000000000138 <strlen>:

uint
strlen(const char *s)
{
 138:	1141                	addi	sp,sp,-16
 13a:	e422                	sd	s0,8(sp)
 13c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 13e:	00054783          	lbu	a5,0(a0)
 142:	cf91                	beqz	a5,15e <strlen+0x26>
 144:	0505                	addi	a0,a0,1
 146:	87aa                	mv	a5,a0
 148:	86be                	mv	a3,a5
 14a:	0785                	addi	a5,a5,1
 14c:	fff7c703          	lbu	a4,-1(a5)
 150:	ff65                	bnez	a4,148 <strlen+0x10>
 152:	40a6853b          	subw	a0,a3,a0
 156:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 158:	6422                	ld	s0,8(sp)
 15a:	0141                	addi	sp,sp,16
 15c:	8082                	ret
  for(n = 0; s[n]; n++)
 15e:	4501                	li	a0,0
 160:	bfe5                	j	158 <strlen+0x20>

0000000000000162 <memset>:

void*
memset(void *dst, int c, uint n)
{
 162:	1141                	addi	sp,sp,-16
 164:	e422                	sd	s0,8(sp)
 166:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 168:	ca19                	beqz	a2,17e <memset+0x1c>
 16a:	87aa                	mv	a5,a0
 16c:	1602                	slli	a2,a2,0x20
 16e:	9201                	srli	a2,a2,0x20
 170:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 174:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 178:	0785                	addi	a5,a5,1
 17a:	fee79de3          	bne	a5,a4,174 <memset+0x12>
  }
  return dst;
}
 17e:	6422                	ld	s0,8(sp)
 180:	0141                	addi	sp,sp,16
 182:	8082                	ret

0000000000000184 <strchr>:

char*
strchr(const char *s, char c)
{
 184:	1141                	addi	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	addi	s0,sp,16
  for(; *s; s++)
 18a:	00054783          	lbu	a5,0(a0)
 18e:	cb99                	beqz	a5,1a4 <strchr+0x20>
    if(*s == c)
 190:	00f58763          	beq	a1,a5,19e <strchr+0x1a>
  for(; *s; s++)
 194:	0505                	addi	a0,a0,1
 196:	00054783          	lbu	a5,0(a0)
 19a:	fbfd                	bnez	a5,190 <strchr+0xc>
      return (char*)s;
  return 0;
 19c:	4501                	li	a0,0
}
 19e:	6422                	ld	s0,8(sp)
 1a0:	0141                	addi	sp,sp,16
 1a2:	8082                	ret
  return 0;
 1a4:	4501                	li	a0,0
 1a6:	bfe5                	j	19e <strchr+0x1a>

00000000000001a8 <gets>:

char*
gets(char *buf, int max)
{
 1a8:	711d                	addi	sp,sp,-96
 1aa:	ec86                	sd	ra,88(sp)
 1ac:	e8a2                	sd	s0,80(sp)
 1ae:	e4a6                	sd	s1,72(sp)
 1b0:	e0ca                	sd	s2,64(sp)
 1b2:	fc4e                	sd	s3,56(sp)
 1b4:	f852                	sd	s4,48(sp)
 1b6:	f456                	sd	s5,40(sp)
 1b8:	f05a                	sd	s6,32(sp)
 1ba:	ec5e                	sd	s7,24(sp)
 1bc:	1080                	addi	s0,sp,96
 1be:	8baa                	mv	s7,a0
 1c0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c2:	892a                	mv	s2,a0
 1c4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1c6:	4aa9                	li	s5,10
 1c8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ca:	89a6                	mv	s3,s1
 1cc:	2485                	addiw	s1,s1,1
 1ce:	0344d663          	bge	s1,s4,1fa <gets+0x52>
    cc = read(0, &c, 1);
 1d2:	4605                	li	a2,1
 1d4:	faf40593          	addi	a1,s0,-81
 1d8:	4501                	li	a0,0
 1da:	280000ef          	jal	45a <read>
    if(cc < 1)
 1de:	00a05e63          	blez	a0,1fa <gets+0x52>
    buf[i++] = c;
 1e2:	faf44783          	lbu	a5,-81(s0)
 1e6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ea:	01578763          	beq	a5,s5,1f8 <gets+0x50>
 1ee:	0905                	addi	s2,s2,1
 1f0:	fd679de3          	bne	a5,s6,1ca <gets+0x22>
    buf[i++] = c;
 1f4:	89a6                	mv	s3,s1
 1f6:	a011                	j	1fa <gets+0x52>
 1f8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1fa:	99de                	add	s3,s3,s7
 1fc:	00098023          	sb	zero,0(s3)
  return buf;
}
 200:	855e                	mv	a0,s7
 202:	60e6                	ld	ra,88(sp)
 204:	6446                	ld	s0,80(sp)
 206:	64a6                	ld	s1,72(sp)
 208:	6906                	ld	s2,64(sp)
 20a:	79e2                	ld	s3,56(sp)
 20c:	7a42                	ld	s4,48(sp)
 20e:	7aa2                	ld	s5,40(sp)
 210:	7b02                	ld	s6,32(sp)
 212:	6be2                	ld	s7,24(sp)
 214:	6125                	addi	sp,sp,96
 216:	8082                	ret

0000000000000218 <stat>:

int
stat(const char *n, struct stat *st)
{
 218:	1101                	addi	sp,sp,-32
 21a:	ec06                	sd	ra,24(sp)
 21c:	e822                	sd	s0,16(sp)
 21e:	e04a                	sd	s2,0(sp)
 220:	1000                	addi	s0,sp,32
 222:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 224:	4581                	li	a1,0
 226:	25c000ef          	jal	482 <open>
  if(fd < 0)
 22a:	02054263          	bltz	a0,24e <stat+0x36>
 22e:	e426                	sd	s1,8(sp)
 230:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 232:	85ca                	mv	a1,s2
 234:	266000ef          	jal	49a <fstat>
 238:	892a                	mv	s2,a0
  close(fd);
 23a:	8526                	mv	a0,s1
 23c:	22e000ef          	jal	46a <close>
  return r;
 240:	64a2                	ld	s1,8(sp)
}
 242:	854a                	mv	a0,s2
 244:	60e2                	ld	ra,24(sp)
 246:	6442                	ld	s0,16(sp)
 248:	6902                	ld	s2,0(sp)
 24a:	6105                	addi	sp,sp,32
 24c:	8082                	ret
    return -1;
 24e:	597d                	li	s2,-1
 250:	bfcd                	j	242 <stat+0x2a>

0000000000000252 <atoi>:

int
atoi(const char *s)
{
 252:	1141                	addi	sp,sp,-16
 254:	e422                	sd	s0,8(sp)
 256:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 258:	00054683          	lbu	a3,0(a0)
 25c:	fd06879b          	addiw	a5,a3,-48
 260:	0ff7f793          	zext.b	a5,a5
 264:	4625                	li	a2,9
 266:	02f66863          	bltu	a2,a5,296 <atoi+0x44>
 26a:	872a                	mv	a4,a0
  n = 0;
 26c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 26e:	0705                	addi	a4,a4,1
 270:	0025179b          	slliw	a5,a0,0x2
 274:	9fa9                	addw	a5,a5,a0
 276:	0017979b          	slliw	a5,a5,0x1
 27a:	9fb5                	addw	a5,a5,a3
 27c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 280:	00074683          	lbu	a3,0(a4)
 284:	fd06879b          	addiw	a5,a3,-48
 288:	0ff7f793          	zext.b	a5,a5
 28c:	fef671e3          	bgeu	a2,a5,26e <atoi+0x1c>
  return n;
}
 290:	6422                	ld	s0,8(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret
  n = 0;
 296:	4501                	li	a0,0
 298:	bfe5                	j	290 <atoi+0x3e>

000000000000029a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 29a:	1141                	addi	sp,sp,-16
 29c:	e422                	sd	s0,8(sp)
 29e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2a0:	02b57463          	bgeu	a0,a1,2c8 <memmove+0x2e>
    while(n-- > 0)
 2a4:	00c05f63          	blez	a2,2c2 <memmove+0x28>
 2a8:	1602                	slli	a2,a2,0x20
 2aa:	9201                	srli	a2,a2,0x20
 2ac:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2b0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2b2:	0585                	addi	a1,a1,1
 2b4:	0705                	addi	a4,a4,1
 2b6:	fff5c683          	lbu	a3,-1(a1)
 2ba:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2be:	fef71ae3          	bne	a4,a5,2b2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2c2:	6422                	ld	s0,8(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret
    dst += n;
 2c8:	00c50733          	add	a4,a0,a2
    src += n;
 2cc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2ce:	fec05ae3          	blez	a2,2c2 <memmove+0x28>
 2d2:	fff6079b          	addiw	a5,a2,-1
 2d6:	1782                	slli	a5,a5,0x20
 2d8:	9381                	srli	a5,a5,0x20
 2da:	fff7c793          	not	a5,a5
 2de:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2e0:	15fd                	addi	a1,a1,-1
 2e2:	177d                	addi	a4,a4,-1
 2e4:	0005c683          	lbu	a3,0(a1)
 2e8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ec:	fee79ae3          	bne	a5,a4,2e0 <memmove+0x46>
 2f0:	bfc9                	j	2c2 <memmove+0x28>

00000000000002f2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e422                	sd	s0,8(sp)
 2f6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2f8:	ca05                	beqz	a2,328 <memcmp+0x36>
 2fa:	fff6069b          	addiw	a3,a2,-1
 2fe:	1682                	slli	a3,a3,0x20
 300:	9281                	srli	a3,a3,0x20
 302:	0685                	addi	a3,a3,1
 304:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 306:	00054783          	lbu	a5,0(a0)
 30a:	0005c703          	lbu	a4,0(a1)
 30e:	00e79863          	bne	a5,a4,31e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 312:	0505                	addi	a0,a0,1
    p2++;
 314:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 316:	fed518e3          	bne	a0,a3,306 <memcmp+0x14>
  }
  return 0;
 31a:	4501                	li	a0,0
 31c:	a019                	j	322 <memcmp+0x30>
      return *p1 - *p2;
 31e:	40e7853b          	subw	a0,a5,a4
}
 322:	6422                	ld	s0,8(sp)
 324:	0141                	addi	sp,sp,16
 326:	8082                	ret
  return 0;
 328:	4501                	li	a0,0
 32a:	bfe5                	j	322 <memcmp+0x30>

000000000000032c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 32c:	1141                	addi	sp,sp,-16
 32e:	e406                	sd	ra,8(sp)
 330:	e022                	sd	s0,0(sp)
 332:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 334:	f67ff0ef          	jal	29a <memmove>
}
 338:	60a2                	ld	ra,8(sp)
 33a:	6402                	ld	s0,0(sp)
 33c:	0141                	addi	sp,sp,16
 33e:	8082                	ret

0000000000000340 <simplesort>:

void
simplesort(void *base, uint nmemb, uint size, int (*compar)(const void *, const void *))
{
 340:	7119                	addi	sp,sp,-128
 342:	fc86                	sd	ra,120(sp)
 344:	f8a2                	sd	s0,112(sp)
 346:	0100                	addi	s0,sp,128
 348:	f8b43423          	sd	a1,-120(s0)
  char *arr = (char *)base; // Treat array as char array for byte-level manipulation
  char *temp;               // Temporary storage for an element

  if (nmemb <= 1 || size == 0) {
 34c:	4785                	li	a5,1
 34e:	00b7fc63          	bgeu	a5,a1,366 <simplesort+0x26>
 352:	e8d2                	sd	s4,80(sp)
 354:	e4d6                	sd	s5,72(sp)
 356:	f466                	sd	s9,40(sp)
 358:	8aaa                	mv	s5,a0
 35a:	8a32                	mv	s4,a2
 35c:	8cb6                	mv	s9,a3
 35e:	ea01                	bnez	a2,36e <simplesort+0x2e>
 360:	6a46                	ld	s4,80(sp)
 362:	6aa6                	ld	s5,72(sp)
 364:	7ca2                	ld	s9,40(sp)
    // Place temp at its correct position
    memmove(arr + j * size, temp, size);
  }

  free(temp); // Free temporary space
 366:	70e6                	ld	ra,120(sp)
 368:	7446                	ld	s0,112(sp)
 36a:	6109                	addi	sp,sp,128
 36c:	8082                	ret
 36e:	fc5e                	sd	s7,56(sp)
 370:	f862                	sd	s8,48(sp)
 372:	f06a                	sd	s10,32(sp)
 374:	ec6e                	sd	s11,24(sp)
  temp = malloc(size); // Allocate temporary space for one element
 376:	8532                	mv	a0,a2
 378:	5de000ef          	jal	956 <malloc>
 37c:	8baa                	mv	s7,a0
  if (temp == 0) {
 37e:	4d81                	li	s11,0
  for (uint i = 1; i < nmemb; i++) {
 380:	4d05                	li	s10,1
    memmove(temp, arr + i * size, size);
 382:	000a0c1b          	sext.w	s8,s4
  if (temp == 0) {
 386:	c511                	beqz	a0,392 <simplesort+0x52>
 388:	f4a6                	sd	s1,104(sp)
 38a:	f0ca                	sd	s2,96(sp)
 38c:	ecce                	sd	s3,88(sp)
 38e:	e0da                	sd	s6,64(sp)
 390:	a82d                	j	3ca <simplesort+0x8a>
    printf("simplesort: malloc failed, cannot sort\n");
 392:	00000517          	auipc	a0,0x0
 396:	71650513          	addi	a0,a0,1814 # aa8 <malloc+0x152>
 39a:	508000ef          	jal	8a2 <printf>
    return;
 39e:	6a46                	ld	s4,80(sp)
 3a0:	6aa6                	ld	s5,72(sp)
 3a2:	7be2                	ld	s7,56(sp)
 3a4:	7c42                	ld	s8,48(sp)
 3a6:	7ca2                	ld	s9,40(sp)
 3a8:	7d02                	ld	s10,32(sp)
 3aa:	6de2                	ld	s11,24(sp)
 3ac:	bf6d                	j	366 <simplesort+0x26>
    memmove(arr + j * size, temp, size);
 3ae:	036a053b          	mulw	a0,s4,s6
 3b2:	1502                	slli	a0,a0,0x20
 3b4:	9101                	srli	a0,a0,0x20
 3b6:	8662                	mv	a2,s8
 3b8:	85de                	mv	a1,s7
 3ba:	9556                	add	a0,a0,s5
 3bc:	edfff0ef          	jal	29a <memmove>
  for (uint i = 1; i < nmemb; i++) {
 3c0:	2d05                	addiw	s10,s10,1
 3c2:	f8843783          	ld	a5,-120(s0)
 3c6:	05a78b63          	beq	a5,s10,41c <simplesort+0xdc>
    memmove(temp, arr + i * size, size);
 3ca:	000d899b          	sext.w	s3,s11
 3ce:	01ba05bb          	addw	a1,s4,s11
 3d2:	00058d9b          	sext.w	s11,a1
 3d6:	1582                	slli	a1,a1,0x20
 3d8:	9181                	srli	a1,a1,0x20
 3da:	8662                	mv	a2,s8
 3dc:	95d6                	add	a1,a1,s5
 3de:	855e                	mv	a0,s7
 3e0:	ebbff0ef          	jal	29a <memmove>
    uint j = i;
 3e4:	896a                	mv	s2,s10
 3e6:	00090b1b          	sext.w	s6,s2
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 3ea:	397d                	addiw	s2,s2,-1
 3ec:	02099493          	slli	s1,s3,0x20
 3f0:	9081                	srli	s1,s1,0x20
 3f2:	94d6                	add	s1,s1,s5
 3f4:	85de                	mv	a1,s7
 3f6:	8526                	mv	a0,s1
 3f8:	9c82                	jalr	s9
 3fa:	faa05ae3          	blez	a0,3ae <simplesort+0x6e>
      memmove(arr + j * size, arr + (j - 1) * size, size); // Shift element
 3fe:	0149853b          	addw	a0,s3,s4
 402:	1502                	slli	a0,a0,0x20
 404:	9101                	srli	a0,a0,0x20
 406:	8662                	mv	a2,s8
 408:	85a6                	mv	a1,s1
 40a:	9556                	add	a0,a0,s5
 40c:	e8fff0ef          	jal	29a <memmove>
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 410:	414989bb          	subw	s3,s3,s4
 414:	fc0919e3          	bnez	s2,3e6 <simplesort+0xa6>
 418:	8b4a                	mv	s6,s2
 41a:	bf51                	j	3ae <simplesort+0x6e>
  free(temp); // Free temporary space
 41c:	855e                	mv	a0,s7
 41e:	4b6000ef          	jal	8d4 <free>
 422:	74a6                	ld	s1,104(sp)
 424:	7906                	ld	s2,96(sp)
 426:	69e6                	ld	s3,88(sp)
 428:	6a46                	ld	s4,80(sp)
 42a:	6aa6                	ld	s5,72(sp)
 42c:	6b06                	ld	s6,64(sp)
 42e:	7be2                	ld	s7,56(sp)
 430:	7c42                	ld	s8,48(sp)
 432:	7ca2                	ld	s9,40(sp)
 434:	7d02                	ld	s10,32(sp)
 436:	6de2                	ld	s11,24(sp)
 438:	b73d                	j	366 <simplesort+0x26>

000000000000043a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 43a:	4885                	li	a7,1
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <exit>:
.global exit
exit:
 li a7, SYS_exit
 442:	4889                	li	a7,2
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <wait>:
.global wait
wait:
 li a7, SYS_wait
 44a:	488d                	li	a7,3
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 452:	4891                	li	a7,4
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <read>:
.global read
read:
 li a7, SYS_read
 45a:	4895                	li	a7,5
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <write>:
.global write
write:
 li a7, SYS_write
 462:	48c1                	li	a7,16
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <close>:
.global close
close:
 li a7, SYS_close
 46a:	48d5                	li	a7,21
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <kill>:
.global kill
kill:
 li a7, SYS_kill
 472:	4899                	li	a7,6
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <exec>:
.global exec
exec:
 li a7, SYS_exec
 47a:	489d                	li	a7,7
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <open>:
.global open
open:
 li a7, SYS_open
 482:	48bd                	li	a7,15
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 48a:	48c5                	li	a7,17
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 492:	48c9                	li	a7,18
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 49a:	48a1                	li	a7,8
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <link>:
.global link
link:
 li a7, SYS_link
 4a2:	48cd                	li	a7,19
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4aa:	48d1                	li	a7,20
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4b2:	48a5                	li	a7,9
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <dup>:
.global dup
dup:
 li a7, SYS_dup
 4ba:	48a9                	li	a7,10
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4c2:	48ad                	li	a7,11
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4ca:	48b1                	li	a7,12
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4d2:	48b5                	li	a7,13
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4da:	48b9                	li	a7,14
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 4e2:	48dd                	li	a7,23
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <statistics>:
.global statistics
statistics:
 li a7, SYS_statistics
 4ea:	48e1                	li	a7,24
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <reset_stats>:
.global reset_stats
reset_stats:
 li a7, SYS_reset_stats
 4f2:	48e5                	li	a7,25
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <resetlockstats>:
.global resetlockstats
resetlockstats:
 li a7, SYS_resetlockstats
 4fa:	48e9                	li	a7,26
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <getlockstats>:
.global getlockstats
getlockstats:
 li a7, SYS_getlockstats
 502:	48ed                	li	a7,27
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <trace>:
.global trace
trace:
 li a7, SYS_trace
 50a:	48d9                	li	a7,22
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 512:	48f1                	li	a7,28
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <ugetpid>:
.global ugetpid
ugetpid:
 li a7, SYS_ugetpid
 51a:	48f5                	li	a7,29
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 522:	48f9                	li	a7,30
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 52a:	1101                	addi	sp,sp,-32
 52c:	ec06                	sd	ra,24(sp)
 52e:	e822                	sd	s0,16(sp)
 530:	1000                	addi	s0,sp,32
 532:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 536:	4605                	li	a2,1
 538:	fef40593          	addi	a1,s0,-17
 53c:	f27ff0ef          	jal	462 <write>
}
 540:	60e2                	ld	ra,24(sp)
 542:	6442                	ld	s0,16(sp)
 544:	6105                	addi	sp,sp,32
 546:	8082                	ret

0000000000000548 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 548:	7139                	addi	sp,sp,-64
 54a:	fc06                	sd	ra,56(sp)
 54c:	f822                	sd	s0,48(sp)
 54e:	f426                	sd	s1,40(sp)
 550:	0080                	addi	s0,sp,64
 552:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 554:	c299                	beqz	a3,55a <printint+0x12>
 556:	0805c963          	bltz	a1,5e8 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 55a:	2581                	sext.w	a1,a1
  neg = 0;
 55c:	4881                	li	a7,0
 55e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 562:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 564:	2601                	sext.w	a2,a2
 566:	00000517          	auipc	a0,0x0
 56a:	57250513          	addi	a0,a0,1394 # ad8 <digits>
 56e:	883a                	mv	a6,a4
 570:	2705                	addiw	a4,a4,1
 572:	02c5f7bb          	remuw	a5,a1,a2
 576:	1782                	slli	a5,a5,0x20
 578:	9381                	srli	a5,a5,0x20
 57a:	97aa                	add	a5,a5,a0
 57c:	0007c783          	lbu	a5,0(a5)
 580:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 584:	0005879b          	sext.w	a5,a1
 588:	02c5d5bb          	divuw	a1,a1,a2
 58c:	0685                	addi	a3,a3,1
 58e:	fec7f0e3          	bgeu	a5,a2,56e <printint+0x26>
  if(neg)
 592:	00088c63          	beqz	a7,5aa <printint+0x62>
    buf[i++] = '-';
 596:	fd070793          	addi	a5,a4,-48
 59a:	00878733          	add	a4,a5,s0
 59e:	02d00793          	li	a5,45
 5a2:	fef70823          	sb	a5,-16(a4)
 5a6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5aa:	02e05a63          	blez	a4,5de <printint+0x96>
 5ae:	f04a                	sd	s2,32(sp)
 5b0:	ec4e                	sd	s3,24(sp)
 5b2:	fc040793          	addi	a5,s0,-64
 5b6:	00e78933          	add	s2,a5,a4
 5ba:	fff78993          	addi	s3,a5,-1
 5be:	99ba                	add	s3,s3,a4
 5c0:	377d                	addiw	a4,a4,-1
 5c2:	1702                	slli	a4,a4,0x20
 5c4:	9301                	srli	a4,a4,0x20
 5c6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5ca:	fff94583          	lbu	a1,-1(s2)
 5ce:	8526                	mv	a0,s1
 5d0:	f5bff0ef          	jal	52a <putc>
  while(--i >= 0)
 5d4:	197d                	addi	s2,s2,-1
 5d6:	ff391ae3          	bne	s2,s3,5ca <printint+0x82>
 5da:	7902                	ld	s2,32(sp)
 5dc:	69e2                	ld	s3,24(sp)
}
 5de:	70e2                	ld	ra,56(sp)
 5e0:	7442                	ld	s0,48(sp)
 5e2:	74a2                	ld	s1,40(sp)
 5e4:	6121                	addi	sp,sp,64
 5e6:	8082                	ret
    x = -xx;
 5e8:	40b005bb          	negw	a1,a1
    neg = 1;
 5ec:	4885                	li	a7,1
    x = -xx;
 5ee:	bf85                	j	55e <printint+0x16>

00000000000005f0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5f0:	711d                	addi	sp,sp,-96
 5f2:	ec86                	sd	ra,88(sp)
 5f4:	e8a2                	sd	s0,80(sp)
 5f6:	e0ca                	sd	s2,64(sp)
 5f8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5fa:	0005c903          	lbu	s2,0(a1)
 5fe:	26090863          	beqz	s2,86e <vprintf+0x27e>
 602:	e4a6                	sd	s1,72(sp)
 604:	fc4e                	sd	s3,56(sp)
 606:	f852                	sd	s4,48(sp)
 608:	f456                	sd	s5,40(sp)
 60a:	f05a                	sd	s6,32(sp)
 60c:	ec5e                	sd	s7,24(sp)
 60e:	e862                	sd	s8,16(sp)
 610:	e466                	sd	s9,8(sp)
 612:	8b2a                	mv	s6,a0
 614:	8a2e                	mv	s4,a1
 616:	8bb2                	mv	s7,a2
  state = 0;
 618:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 61a:	4481                	li	s1,0
 61c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 61e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 622:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 626:	06c00c93          	li	s9,108
 62a:	a005                	j	64a <vprintf+0x5a>
        putc(fd, c0);
 62c:	85ca                	mv	a1,s2
 62e:	855a                	mv	a0,s6
 630:	efbff0ef          	jal	52a <putc>
 634:	a019                	j	63a <vprintf+0x4a>
    } else if(state == '%'){
 636:	03598263          	beq	s3,s5,65a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 63a:	2485                	addiw	s1,s1,1
 63c:	8726                	mv	a4,s1
 63e:	009a07b3          	add	a5,s4,s1
 642:	0007c903          	lbu	s2,0(a5)
 646:	20090c63          	beqz	s2,85e <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 64a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 64e:	fe0994e3          	bnez	s3,636 <vprintf+0x46>
      if(c0 == '%'){
 652:	fd579de3          	bne	a5,s5,62c <vprintf+0x3c>
        state = '%';
 656:	89be                	mv	s3,a5
 658:	b7cd                	j	63a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 65a:	00ea06b3          	add	a3,s4,a4
 65e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 662:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 664:	c681                	beqz	a3,66c <vprintf+0x7c>
 666:	9752                	add	a4,a4,s4
 668:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 66c:	03878f63          	beq	a5,s8,6aa <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 670:	05978963          	beq	a5,s9,6c2 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 674:	07500713          	li	a4,117
 678:	0ee78363          	beq	a5,a4,75e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 67c:	07800713          	li	a4,120
 680:	12e78563          	beq	a5,a4,7aa <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 684:	07000713          	li	a4,112
 688:	14e78a63          	beq	a5,a4,7dc <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 68c:	07300713          	li	a4,115
 690:	18e78a63          	beq	a5,a4,824 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 694:	02500713          	li	a4,37
 698:	04e79563          	bne	a5,a4,6e2 <vprintf+0xf2>
        putc(fd, '%');
 69c:	02500593          	li	a1,37
 6a0:	855a                	mv	a0,s6
 6a2:	e89ff0ef          	jal	52a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	bf49                	j	63a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6aa:	008b8913          	addi	s2,s7,8
 6ae:	4685                	li	a3,1
 6b0:	4629                	li	a2,10
 6b2:	000ba583          	lw	a1,0(s7)
 6b6:	855a                	mv	a0,s6
 6b8:	e91ff0ef          	jal	548 <printint>
 6bc:	8bca                	mv	s7,s2
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	bfad                	j	63a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6c2:	06400793          	li	a5,100
 6c6:	02f68963          	beq	a3,a5,6f8 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6ca:	06c00793          	li	a5,108
 6ce:	04f68263          	beq	a3,a5,712 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 6d2:	07500793          	li	a5,117
 6d6:	0af68063          	beq	a3,a5,776 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 6da:	07800793          	li	a5,120
 6de:	0ef68263          	beq	a3,a5,7c2 <vprintf+0x1d2>
        putc(fd, '%');
 6e2:	02500593          	li	a1,37
 6e6:	855a                	mv	a0,s6
 6e8:	e43ff0ef          	jal	52a <putc>
        putc(fd, c0);
 6ec:	85ca                	mv	a1,s2
 6ee:	855a                	mv	a0,s6
 6f0:	e3bff0ef          	jal	52a <putc>
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b791                	j	63a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f8:	008b8913          	addi	s2,s7,8
 6fc:	4685                	li	a3,1
 6fe:	4629                	li	a2,10
 700:	000ba583          	lw	a1,0(s7)
 704:	855a                	mv	a0,s6
 706:	e43ff0ef          	jal	548 <printint>
        i += 1;
 70a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 70c:	8bca                	mv	s7,s2
      state = 0;
 70e:	4981                	li	s3,0
        i += 1;
 710:	b72d                	j	63a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 712:	06400793          	li	a5,100
 716:	02f60763          	beq	a2,a5,744 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 71a:	07500793          	li	a5,117
 71e:	06f60963          	beq	a2,a5,790 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 722:	07800793          	li	a5,120
 726:	faf61ee3          	bne	a2,a5,6e2 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 72a:	008b8913          	addi	s2,s7,8
 72e:	4681                	li	a3,0
 730:	4641                	li	a2,16
 732:	000ba583          	lw	a1,0(s7)
 736:	855a                	mv	a0,s6
 738:	e11ff0ef          	jal	548 <printint>
        i += 2;
 73c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 73e:	8bca                	mv	s7,s2
      state = 0;
 740:	4981                	li	s3,0
        i += 2;
 742:	bde5                	j	63a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 744:	008b8913          	addi	s2,s7,8
 748:	4685                	li	a3,1
 74a:	4629                	li	a2,10
 74c:	000ba583          	lw	a1,0(s7)
 750:	855a                	mv	a0,s6
 752:	df7ff0ef          	jal	548 <printint>
        i += 2;
 756:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 758:	8bca                	mv	s7,s2
      state = 0;
 75a:	4981                	li	s3,0
        i += 2;
 75c:	bdf9                	j	63a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 75e:	008b8913          	addi	s2,s7,8
 762:	4681                	li	a3,0
 764:	4629                	li	a2,10
 766:	000ba583          	lw	a1,0(s7)
 76a:	855a                	mv	a0,s6
 76c:	dddff0ef          	jal	548 <printint>
 770:	8bca                	mv	s7,s2
      state = 0;
 772:	4981                	li	s3,0
 774:	b5d9                	j	63a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 776:	008b8913          	addi	s2,s7,8
 77a:	4681                	li	a3,0
 77c:	4629                	li	a2,10
 77e:	000ba583          	lw	a1,0(s7)
 782:	855a                	mv	a0,s6
 784:	dc5ff0ef          	jal	548 <printint>
        i += 1;
 788:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 78a:	8bca                	mv	s7,s2
      state = 0;
 78c:	4981                	li	s3,0
        i += 1;
 78e:	b575                	j	63a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 790:	008b8913          	addi	s2,s7,8
 794:	4681                	li	a3,0
 796:	4629                	li	a2,10
 798:	000ba583          	lw	a1,0(s7)
 79c:	855a                	mv	a0,s6
 79e:	dabff0ef          	jal	548 <printint>
        i += 2;
 7a2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a4:	8bca                	mv	s7,s2
      state = 0;
 7a6:	4981                	li	s3,0
        i += 2;
 7a8:	bd49                	j	63a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7aa:	008b8913          	addi	s2,s7,8
 7ae:	4681                	li	a3,0
 7b0:	4641                	li	a2,16
 7b2:	000ba583          	lw	a1,0(s7)
 7b6:	855a                	mv	a0,s6
 7b8:	d91ff0ef          	jal	548 <printint>
 7bc:	8bca                	mv	s7,s2
      state = 0;
 7be:	4981                	li	s3,0
 7c0:	bdad                	j	63a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c2:	008b8913          	addi	s2,s7,8
 7c6:	4681                	li	a3,0
 7c8:	4641                	li	a2,16
 7ca:	000ba583          	lw	a1,0(s7)
 7ce:	855a                	mv	a0,s6
 7d0:	d79ff0ef          	jal	548 <printint>
        i += 1;
 7d4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d6:	8bca                	mv	s7,s2
      state = 0;
 7d8:	4981                	li	s3,0
        i += 1;
 7da:	b585                	j	63a <vprintf+0x4a>
 7dc:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7de:	008b8d13          	addi	s10,s7,8
 7e2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7e6:	03000593          	li	a1,48
 7ea:	855a                	mv	a0,s6
 7ec:	d3fff0ef          	jal	52a <putc>
  putc(fd, 'x');
 7f0:	07800593          	li	a1,120
 7f4:	855a                	mv	a0,s6
 7f6:	d35ff0ef          	jal	52a <putc>
 7fa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7fc:	00000b97          	auipc	s7,0x0
 800:	2dcb8b93          	addi	s7,s7,732 # ad8 <digits>
 804:	03c9d793          	srli	a5,s3,0x3c
 808:	97de                	add	a5,a5,s7
 80a:	0007c583          	lbu	a1,0(a5)
 80e:	855a                	mv	a0,s6
 810:	d1bff0ef          	jal	52a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 814:	0992                	slli	s3,s3,0x4
 816:	397d                	addiw	s2,s2,-1
 818:	fe0916e3          	bnez	s2,804 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 81c:	8bea                	mv	s7,s10
      state = 0;
 81e:	4981                	li	s3,0
 820:	6d02                	ld	s10,0(sp)
 822:	bd21                	j	63a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 824:	008b8993          	addi	s3,s7,8
 828:	000bb903          	ld	s2,0(s7)
 82c:	00090f63          	beqz	s2,84a <vprintf+0x25a>
        for(; *s; s++)
 830:	00094583          	lbu	a1,0(s2)
 834:	c195                	beqz	a1,858 <vprintf+0x268>
          putc(fd, *s);
 836:	855a                	mv	a0,s6
 838:	cf3ff0ef          	jal	52a <putc>
        for(; *s; s++)
 83c:	0905                	addi	s2,s2,1
 83e:	00094583          	lbu	a1,0(s2)
 842:	f9f5                	bnez	a1,836 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 844:	8bce                	mv	s7,s3
      state = 0;
 846:	4981                	li	s3,0
 848:	bbcd                	j	63a <vprintf+0x4a>
          s = "(null)";
 84a:	00000917          	auipc	s2,0x0
 84e:	28690913          	addi	s2,s2,646 # ad0 <malloc+0x17a>
        for(; *s; s++)
 852:	02800593          	li	a1,40
 856:	b7c5                	j	836 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 858:	8bce                	mv	s7,s3
      state = 0;
 85a:	4981                	li	s3,0
 85c:	bbf9                	j	63a <vprintf+0x4a>
 85e:	64a6                	ld	s1,72(sp)
 860:	79e2                	ld	s3,56(sp)
 862:	7a42                	ld	s4,48(sp)
 864:	7aa2                	ld	s5,40(sp)
 866:	7b02                	ld	s6,32(sp)
 868:	6be2                	ld	s7,24(sp)
 86a:	6c42                	ld	s8,16(sp)
 86c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 86e:	60e6                	ld	ra,88(sp)
 870:	6446                	ld	s0,80(sp)
 872:	6906                	ld	s2,64(sp)
 874:	6125                	addi	sp,sp,96
 876:	8082                	ret

0000000000000878 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 878:	715d                	addi	sp,sp,-80
 87a:	ec06                	sd	ra,24(sp)
 87c:	e822                	sd	s0,16(sp)
 87e:	1000                	addi	s0,sp,32
 880:	e010                	sd	a2,0(s0)
 882:	e414                	sd	a3,8(s0)
 884:	e818                	sd	a4,16(s0)
 886:	ec1c                	sd	a5,24(s0)
 888:	03043023          	sd	a6,32(s0)
 88c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 890:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 894:	8622                	mv	a2,s0
 896:	d5bff0ef          	jal	5f0 <vprintf>
}
 89a:	60e2                	ld	ra,24(sp)
 89c:	6442                	ld	s0,16(sp)
 89e:	6161                	addi	sp,sp,80
 8a0:	8082                	ret

00000000000008a2 <printf>:

void
printf(const char *fmt, ...)
{
 8a2:	711d                	addi	sp,sp,-96
 8a4:	ec06                	sd	ra,24(sp)
 8a6:	e822                	sd	s0,16(sp)
 8a8:	1000                	addi	s0,sp,32
 8aa:	e40c                	sd	a1,8(s0)
 8ac:	e810                	sd	a2,16(s0)
 8ae:	ec14                	sd	a3,24(s0)
 8b0:	f018                	sd	a4,32(s0)
 8b2:	f41c                	sd	a5,40(s0)
 8b4:	03043823          	sd	a6,48(s0)
 8b8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8bc:	00840613          	addi	a2,s0,8
 8c0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8c4:	85aa                	mv	a1,a0
 8c6:	4505                	li	a0,1
 8c8:	d29ff0ef          	jal	5f0 <vprintf>
}
 8cc:	60e2                	ld	ra,24(sp)
 8ce:	6442                	ld	s0,16(sp)
 8d0:	6125                	addi	sp,sp,96
 8d2:	8082                	ret

00000000000008d4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8d4:	1141                	addi	sp,sp,-16
 8d6:	e422                	sd	s0,8(sp)
 8d8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8da:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8de:	00000797          	auipc	a5,0x0
 8e2:	7227b783          	ld	a5,1826(a5) # 1000 <freep>
 8e6:	a02d                	j	910 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8e8:	4618                	lw	a4,8(a2)
 8ea:	9f2d                	addw	a4,a4,a1
 8ec:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8f0:	6398                	ld	a4,0(a5)
 8f2:	6310                	ld	a2,0(a4)
 8f4:	a83d                	j	932 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8f6:	ff852703          	lw	a4,-8(a0)
 8fa:	9f31                	addw	a4,a4,a2
 8fc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8fe:	ff053683          	ld	a3,-16(a0)
 902:	a091                	j	946 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 904:	6398                	ld	a4,0(a5)
 906:	00e7e463          	bltu	a5,a4,90e <free+0x3a>
 90a:	00e6ea63          	bltu	a3,a4,91e <free+0x4a>
{
 90e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 910:	fed7fae3          	bgeu	a5,a3,904 <free+0x30>
 914:	6398                	ld	a4,0(a5)
 916:	00e6e463          	bltu	a3,a4,91e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 91a:	fee7eae3          	bltu	a5,a4,90e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 91e:	ff852583          	lw	a1,-8(a0)
 922:	6390                	ld	a2,0(a5)
 924:	02059813          	slli	a6,a1,0x20
 928:	01c85713          	srli	a4,a6,0x1c
 92c:	9736                	add	a4,a4,a3
 92e:	fae60de3          	beq	a2,a4,8e8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 932:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 936:	4790                	lw	a2,8(a5)
 938:	02061593          	slli	a1,a2,0x20
 93c:	01c5d713          	srli	a4,a1,0x1c
 940:	973e                	add	a4,a4,a5
 942:	fae68ae3          	beq	a3,a4,8f6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 946:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 948:	00000717          	auipc	a4,0x0
 94c:	6af73c23          	sd	a5,1720(a4) # 1000 <freep>
}
 950:	6422                	ld	s0,8(sp)
 952:	0141                	addi	sp,sp,16
 954:	8082                	ret

0000000000000956 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 956:	7139                	addi	sp,sp,-64
 958:	fc06                	sd	ra,56(sp)
 95a:	f822                	sd	s0,48(sp)
 95c:	f426                	sd	s1,40(sp)
 95e:	ec4e                	sd	s3,24(sp)
 960:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 962:	02051493          	slli	s1,a0,0x20
 966:	9081                	srli	s1,s1,0x20
 968:	04bd                	addi	s1,s1,15
 96a:	8091                	srli	s1,s1,0x4
 96c:	0014899b          	addiw	s3,s1,1
 970:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 972:	00000517          	auipc	a0,0x0
 976:	68e53503          	ld	a0,1678(a0) # 1000 <freep>
 97a:	c915                	beqz	a0,9ae <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 97e:	4798                	lw	a4,8(a5)
 980:	08977a63          	bgeu	a4,s1,a14 <malloc+0xbe>
 984:	f04a                	sd	s2,32(sp)
 986:	e852                	sd	s4,16(sp)
 988:	e456                	sd	s5,8(sp)
 98a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 98c:	8a4e                	mv	s4,s3
 98e:	0009871b          	sext.w	a4,s3
 992:	6685                	lui	a3,0x1
 994:	00d77363          	bgeu	a4,a3,99a <malloc+0x44>
 998:	6a05                	lui	s4,0x1
 99a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 99e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9a2:	00000917          	auipc	s2,0x0
 9a6:	65e90913          	addi	s2,s2,1630 # 1000 <freep>
  if(p == (char*)-1)
 9aa:	5afd                	li	s5,-1
 9ac:	a081                	j	9ec <malloc+0x96>
 9ae:	f04a                	sd	s2,32(sp)
 9b0:	e852                	sd	s4,16(sp)
 9b2:	e456                	sd	s5,8(sp)
 9b4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9b6:	00000797          	auipc	a5,0x0
 9ba:	65a78793          	addi	a5,a5,1626 # 1010 <base>
 9be:	00000717          	auipc	a4,0x0
 9c2:	64f73123          	sd	a5,1602(a4) # 1000 <freep>
 9c6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9c8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9cc:	b7c1                	j	98c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9ce:	6398                	ld	a4,0(a5)
 9d0:	e118                	sd	a4,0(a0)
 9d2:	a8a9                	j	a2c <malloc+0xd6>
  hp->s.size = nu;
 9d4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9d8:	0541                	addi	a0,a0,16
 9da:	efbff0ef          	jal	8d4 <free>
  return freep;
 9de:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9e2:	c12d                	beqz	a0,a44 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e6:	4798                	lw	a4,8(a5)
 9e8:	02977263          	bgeu	a4,s1,a0c <malloc+0xb6>
    if(p == freep)
 9ec:	00093703          	ld	a4,0(s2)
 9f0:	853e                	mv	a0,a5
 9f2:	fef719e3          	bne	a4,a5,9e4 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9f6:	8552                	mv	a0,s4
 9f8:	ad3ff0ef          	jal	4ca <sbrk>
  if(p == (char*)-1)
 9fc:	fd551ce3          	bne	a0,s5,9d4 <malloc+0x7e>
        return 0;
 a00:	4501                	li	a0,0
 a02:	7902                	ld	s2,32(sp)
 a04:	6a42                	ld	s4,16(sp)
 a06:	6aa2                	ld	s5,8(sp)
 a08:	6b02                	ld	s6,0(sp)
 a0a:	a03d                	j	a38 <malloc+0xe2>
 a0c:	7902                	ld	s2,32(sp)
 a0e:	6a42                	ld	s4,16(sp)
 a10:	6aa2                	ld	s5,8(sp)
 a12:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a14:	fae48de3          	beq	s1,a4,9ce <malloc+0x78>
        p->s.size -= nunits;
 a18:	4137073b          	subw	a4,a4,s3
 a1c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a1e:	02071693          	slli	a3,a4,0x20
 a22:	01c6d713          	srli	a4,a3,0x1c
 a26:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a28:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a2c:	00000717          	auipc	a4,0x0
 a30:	5ca73a23          	sd	a0,1492(a4) # 1000 <freep>
      return (void*)(p + 1);
 a34:	01078513          	addi	a0,a5,16
  }
}
 a38:	70e2                	ld	ra,56(sp)
 a3a:	7442                	ld	s0,48(sp)
 a3c:	74a2                	ld	s1,40(sp)
 a3e:	69e2                	ld	s3,24(sp)
 a40:	6121                	addi	sp,sp,64
 a42:	8082                	ret
 a44:	7902                	ld	s2,32(sp)
 a46:	6a42                	ld	s4,16(sp)
 a48:	6aa2                	ld	s5,8(sp)
 a4a:	6b02                	ld	s6,0(sp)
 a4c:	b7f5                	j	a38 <malloc+0xe2>
