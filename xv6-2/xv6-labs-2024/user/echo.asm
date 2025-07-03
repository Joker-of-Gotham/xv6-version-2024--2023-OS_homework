
user/_echo：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
  12:	4785                	li	a5,1
  14:	06a7d063          	bge	a5,a0,74 <main+0x74>
  18:	00858493          	addi	s1,a1,8
  1c:	3579                	addiw	a0,a0,-2
  1e:	02051793          	slli	a5,a0,0x20
  22:	01d7d513          	srli	a0,a5,0x1d
  26:	00a48a33          	add	s4,s1,a0
  2a:	05c1                	addi	a1,a1,16
  2c:	00a589b3          	add	s3,a1,a0
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  30:	00001a97          	auipc	s5,0x1
  34:	9f0a8a93          	addi	s5,s5,-1552 # a20 <malloc+0xf8>
  38:	a809                	j	4a <main+0x4a>
  3a:	4605                	li	a2,1
  3c:	85d6                	mv	a1,s5
  3e:	4505                	li	a0,1
  40:	3f4000ef          	jal	434 <write>
  for(i = 1; i < argc; i++){
  44:	04a1                	addi	s1,s1,8
  46:	03348763          	beq	s1,s3,74 <main+0x74>
    write(1, argv[i], strlen(argv[i]));
  4a:	0004b903          	ld	s2,0(s1)
  4e:	854a                	mv	a0,s2
  50:	0ba000ef          	jal	10a <strlen>
  54:	0005061b          	sext.w	a2,a0
  58:	85ca                	mv	a1,s2
  5a:	4505                	li	a0,1
  5c:	3d8000ef          	jal	434 <write>
    if(i + 1 < argc){
  60:	fd449de3          	bne	s1,s4,3a <main+0x3a>
    } else {
      write(1, "\n", 1);
  64:	4605                	li	a2,1
  66:	00001597          	auipc	a1,0x1
  6a:	9c258593          	addi	a1,a1,-1598 # a28 <malloc+0x100>
  6e:	4505                	li	a0,1
  70:	3c4000ef          	jal	434 <write>
    }
  }
  exit(0);
  74:	4501                	li	a0,0
  76:	39e000ef          	jal	414 <exit>

000000000000007a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  7a:	1141                	addi	sp,sp,-16
  7c:	e406                	sd	ra,8(sp)
  7e:	e022                	sd	s0,0(sp)
  80:	0800                	addi	s0,sp,16
  extern int main();
  main();
  82:	f7fff0ef          	jal	0 <main>
  exit(0);
  86:	4501                	li	a0,0
  88:	38c000ef          	jal	414 <exit>

000000000000008c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e422                	sd	s0,8(sp)
  90:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  92:	87aa                	mv	a5,a0
  94:	0585                	addi	a1,a1,1
  96:	0785                	addi	a5,a5,1
  98:	fff5c703          	lbu	a4,-1(a1)
  9c:	fee78fa3          	sb	a4,-1(a5)
  a0:	fb75                	bnez	a4,94 <strcpy+0x8>
    ;
  return os;
}
  a2:	6422                	ld	s0,8(sp)
  a4:	0141                	addi	sp,sp,16
  a6:	8082                	ret

00000000000000a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a8:	1141                	addi	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ae:	00054783          	lbu	a5,0(a0)
  b2:	cb91                	beqz	a5,c6 <strcmp+0x1e>
  b4:	0005c703          	lbu	a4,0(a1)
  b8:	00f71763          	bne	a4,a5,c6 <strcmp+0x1e>
    p++, q++;
  bc:	0505                	addi	a0,a0,1
  be:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c0:	00054783          	lbu	a5,0(a0)
  c4:	fbe5                	bnez	a5,b4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  c6:	0005c503          	lbu	a0,0(a1)
}
  ca:	40a7853b          	subw	a0,a5,a0
  ce:	6422                	ld	s0,8(sp)
  d0:	0141                	addi	sp,sp,16
  d2:	8082                	ret

00000000000000d4 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e422                	sd	s0,8(sp)
  d8:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q) {
  da:	ce11                	beqz	a2,f6 <strncmp+0x22>
  dc:	00054783          	lbu	a5,0(a0)
  e0:	cf89                	beqz	a5,fa <strncmp+0x26>
  e2:	0005c703          	lbu	a4,0(a1)
  e6:	00f71a63          	bne	a4,a5,fa <strncmp+0x26>
    n--;
  ea:	367d                	addiw	a2,a2,-1
    p++;
  ec:	0505                	addi	a0,a0,1
    q++;
  ee:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q) {
  f0:	f675                	bnez	a2,dc <strncmp+0x8>
  }
  if(n == 0)
    return 0;
  f2:	4501                	li	a0,0
  f4:	a801                	j	104 <strncmp+0x30>
  f6:	4501                	li	a0,0
  f8:	a031                	j	104 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
  fa:	00054503          	lbu	a0,0(a0)
  fe:	0005c783          	lbu	a5,0(a1)
 102:	9d1d                	subw	a0,a0,a5
}
 104:	6422                	ld	s0,8(sp)
 106:	0141                	addi	sp,sp,16
 108:	8082                	ret

000000000000010a <strlen>:

uint
strlen(const char *s)
{
 10a:	1141                	addi	sp,sp,-16
 10c:	e422                	sd	s0,8(sp)
 10e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 110:	00054783          	lbu	a5,0(a0)
 114:	cf91                	beqz	a5,130 <strlen+0x26>
 116:	0505                	addi	a0,a0,1
 118:	87aa                	mv	a5,a0
 11a:	86be                	mv	a3,a5
 11c:	0785                	addi	a5,a5,1
 11e:	fff7c703          	lbu	a4,-1(a5)
 122:	ff65                	bnez	a4,11a <strlen+0x10>
 124:	40a6853b          	subw	a0,a3,a0
 128:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 12a:	6422                	ld	s0,8(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret
  for(n = 0; s[n]; n++)
 130:	4501                	li	a0,0
 132:	bfe5                	j	12a <strlen+0x20>

0000000000000134 <memset>:

void*
memset(void *dst, int c, uint n)
{
 134:	1141                	addi	sp,sp,-16
 136:	e422                	sd	s0,8(sp)
 138:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 13a:	ca19                	beqz	a2,150 <memset+0x1c>
 13c:	87aa                	mv	a5,a0
 13e:	1602                	slli	a2,a2,0x20
 140:	9201                	srli	a2,a2,0x20
 142:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 146:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 14a:	0785                	addi	a5,a5,1
 14c:	fee79de3          	bne	a5,a4,146 <memset+0x12>
  }
  return dst;
}
 150:	6422                	ld	s0,8(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret

0000000000000156 <strchr>:

char*
strchr(const char *s, char c)
{
 156:	1141                	addi	sp,sp,-16
 158:	e422                	sd	s0,8(sp)
 15a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 15c:	00054783          	lbu	a5,0(a0)
 160:	cb99                	beqz	a5,176 <strchr+0x20>
    if(*s == c)
 162:	00f58763          	beq	a1,a5,170 <strchr+0x1a>
  for(; *s; s++)
 166:	0505                	addi	a0,a0,1
 168:	00054783          	lbu	a5,0(a0)
 16c:	fbfd                	bnez	a5,162 <strchr+0xc>
      return (char*)s;
  return 0;
 16e:	4501                	li	a0,0
}
 170:	6422                	ld	s0,8(sp)
 172:	0141                	addi	sp,sp,16
 174:	8082                	ret
  return 0;
 176:	4501                	li	a0,0
 178:	bfe5                	j	170 <strchr+0x1a>

000000000000017a <gets>:

char*
gets(char *buf, int max)
{
 17a:	711d                	addi	sp,sp,-96
 17c:	ec86                	sd	ra,88(sp)
 17e:	e8a2                	sd	s0,80(sp)
 180:	e4a6                	sd	s1,72(sp)
 182:	e0ca                	sd	s2,64(sp)
 184:	fc4e                	sd	s3,56(sp)
 186:	f852                	sd	s4,48(sp)
 188:	f456                	sd	s5,40(sp)
 18a:	f05a                	sd	s6,32(sp)
 18c:	ec5e                	sd	s7,24(sp)
 18e:	1080                	addi	s0,sp,96
 190:	8baa                	mv	s7,a0
 192:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 194:	892a                	mv	s2,a0
 196:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 198:	4aa9                	li	s5,10
 19a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 19c:	89a6                	mv	s3,s1
 19e:	2485                	addiw	s1,s1,1
 1a0:	0344d663          	bge	s1,s4,1cc <gets+0x52>
    cc = read(0, &c, 1);
 1a4:	4605                	li	a2,1
 1a6:	faf40593          	addi	a1,s0,-81
 1aa:	4501                	li	a0,0
 1ac:	280000ef          	jal	42c <read>
    if(cc < 1)
 1b0:	00a05e63          	blez	a0,1cc <gets+0x52>
    buf[i++] = c;
 1b4:	faf44783          	lbu	a5,-81(s0)
 1b8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1bc:	01578763          	beq	a5,s5,1ca <gets+0x50>
 1c0:	0905                	addi	s2,s2,1
 1c2:	fd679de3          	bne	a5,s6,19c <gets+0x22>
    buf[i++] = c;
 1c6:	89a6                	mv	s3,s1
 1c8:	a011                	j	1cc <gets+0x52>
 1ca:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1cc:	99de                	add	s3,s3,s7
 1ce:	00098023          	sb	zero,0(s3)
  return buf;
}
 1d2:	855e                	mv	a0,s7
 1d4:	60e6                	ld	ra,88(sp)
 1d6:	6446                	ld	s0,80(sp)
 1d8:	64a6                	ld	s1,72(sp)
 1da:	6906                	ld	s2,64(sp)
 1dc:	79e2                	ld	s3,56(sp)
 1de:	7a42                	ld	s4,48(sp)
 1e0:	7aa2                	ld	s5,40(sp)
 1e2:	7b02                	ld	s6,32(sp)
 1e4:	6be2                	ld	s7,24(sp)
 1e6:	6125                	addi	sp,sp,96
 1e8:	8082                	ret

00000000000001ea <stat>:

int
stat(const char *n, struct stat *st)
{
 1ea:	1101                	addi	sp,sp,-32
 1ec:	ec06                	sd	ra,24(sp)
 1ee:	e822                	sd	s0,16(sp)
 1f0:	e04a                	sd	s2,0(sp)
 1f2:	1000                	addi	s0,sp,32
 1f4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f6:	4581                	li	a1,0
 1f8:	25c000ef          	jal	454 <open>
  if(fd < 0)
 1fc:	02054263          	bltz	a0,220 <stat+0x36>
 200:	e426                	sd	s1,8(sp)
 202:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 204:	85ca                	mv	a1,s2
 206:	266000ef          	jal	46c <fstat>
 20a:	892a                	mv	s2,a0
  close(fd);
 20c:	8526                	mv	a0,s1
 20e:	22e000ef          	jal	43c <close>
  return r;
 212:	64a2                	ld	s1,8(sp)
}
 214:	854a                	mv	a0,s2
 216:	60e2                	ld	ra,24(sp)
 218:	6442                	ld	s0,16(sp)
 21a:	6902                	ld	s2,0(sp)
 21c:	6105                	addi	sp,sp,32
 21e:	8082                	ret
    return -1;
 220:	597d                	li	s2,-1
 222:	bfcd                	j	214 <stat+0x2a>

0000000000000224 <atoi>:

int
atoi(const char *s)
{
 224:	1141                	addi	sp,sp,-16
 226:	e422                	sd	s0,8(sp)
 228:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 22a:	00054683          	lbu	a3,0(a0)
 22e:	fd06879b          	addiw	a5,a3,-48
 232:	0ff7f793          	zext.b	a5,a5
 236:	4625                	li	a2,9
 238:	02f66863          	bltu	a2,a5,268 <atoi+0x44>
 23c:	872a                	mv	a4,a0
  n = 0;
 23e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 240:	0705                	addi	a4,a4,1
 242:	0025179b          	slliw	a5,a0,0x2
 246:	9fa9                	addw	a5,a5,a0
 248:	0017979b          	slliw	a5,a5,0x1
 24c:	9fb5                	addw	a5,a5,a3
 24e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 252:	00074683          	lbu	a3,0(a4)
 256:	fd06879b          	addiw	a5,a3,-48
 25a:	0ff7f793          	zext.b	a5,a5
 25e:	fef671e3          	bgeu	a2,a5,240 <atoi+0x1c>
  return n;
}
 262:	6422                	ld	s0,8(sp)
 264:	0141                	addi	sp,sp,16
 266:	8082                	ret
  n = 0;
 268:	4501                	li	a0,0
 26a:	bfe5                	j	262 <atoi+0x3e>

000000000000026c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 272:	02b57463          	bgeu	a0,a1,29a <memmove+0x2e>
    while(n-- > 0)
 276:	00c05f63          	blez	a2,294 <memmove+0x28>
 27a:	1602                	slli	a2,a2,0x20
 27c:	9201                	srli	a2,a2,0x20
 27e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 282:	872a                	mv	a4,a0
      *dst++ = *src++;
 284:	0585                	addi	a1,a1,1
 286:	0705                	addi	a4,a4,1
 288:	fff5c683          	lbu	a3,-1(a1)
 28c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 290:	fef71ae3          	bne	a4,a5,284 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 294:	6422                	ld	s0,8(sp)
 296:	0141                	addi	sp,sp,16
 298:	8082                	ret
    dst += n;
 29a:	00c50733          	add	a4,a0,a2
    src += n;
 29e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2a0:	fec05ae3          	blez	a2,294 <memmove+0x28>
 2a4:	fff6079b          	addiw	a5,a2,-1
 2a8:	1782                	slli	a5,a5,0x20
 2aa:	9381                	srli	a5,a5,0x20
 2ac:	fff7c793          	not	a5,a5
 2b0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2b2:	15fd                	addi	a1,a1,-1
 2b4:	177d                	addi	a4,a4,-1
 2b6:	0005c683          	lbu	a3,0(a1)
 2ba:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2be:	fee79ae3          	bne	a5,a4,2b2 <memmove+0x46>
 2c2:	bfc9                	j	294 <memmove+0x28>

00000000000002c4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e422                	sd	s0,8(sp)
 2c8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ca:	ca05                	beqz	a2,2fa <memcmp+0x36>
 2cc:	fff6069b          	addiw	a3,a2,-1
 2d0:	1682                	slli	a3,a3,0x20
 2d2:	9281                	srli	a3,a3,0x20
 2d4:	0685                	addi	a3,a3,1
 2d6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2d8:	00054783          	lbu	a5,0(a0)
 2dc:	0005c703          	lbu	a4,0(a1)
 2e0:	00e79863          	bne	a5,a4,2f0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2e4:	0505                	addi	a0,a0,1
    p2++;
 2e6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2e8:	fed518e3          	bne	a0,a3,2d8 <memcmp+0x14>
  }
  return 0;
 2ec:	4501                	li	a0,0
 2ee:	a019                	j	2f4 <memcmp+0x30>
      return *p1 - *p2;
 2f0:	40e7853b          	subw	a0,a5,a4
}
 2f4:	6422                	ld	s0,8(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret
  return 0;
 2fa:	4501                	li	a0,0
 2fc:	bfe5                	j	2f4 <memcmp+0x30>

00000000000002fe <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e406                	sd	ra,8(sp)
 302:	e022                	sd	s0,0(sp)
 304:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 306:	f67ff0ef          	jal	26c <memmove>
}
 30a:	60a2                	ld	ra,8(sp)
 30c:	6402                	ld	s0,0(sp)
 30e:	0141                	addi	sp,sp,16
 310:	8082                	ret

0000000000000312 <simplesort>:

void
simplesort(void *base, uint nmemb, uint size, int (*compar)(const void *, const void *))
{
 312:	7119                	addi	sp,sp,-128
 314:	fc86                	sd	ra,120(sp)
 316:	f8a2                	sd	s0,112(sp)
 318:	0100                	addi	s0,sp,128
 31a:	f8b43423          	sd	a1,-120(s0)
  char *arr = (char *)base; // Treat array as char array for byte-level manipulation
  char *temp;               // Temporary storage for an element

  if (nmemb <= 1 || size == 0) {
 31e:	4785                	li	a5,1
 320:	00b7fc63          	bgeu	a5,a1,338 <simplesort+0x26>
 324:	e8d2                	sd	s4,80(sp)
 326:	e4d6                	sd	s5,72(sp)
 328:	f466                	sd	s9,40(sp)
 32a:	8aaa                	mv	s5,a0
 32c:	8a32                	mv	s4,a2
 32e:	8cb6                	mv	s9,a3
 330:	ea01                	bnez	a2,340 <simplesort+0x2e>
 332:	6a46                	ld	s4,80(sp)
 334:	6aa6                	ld	s5,72(sp)
 336:	7ca2                	ld	s9,40(sp)
    // Place temp at its correct position
    memmove(arr + j * size, temp, size);
  }

  free(temp); // Free temporary space
 338:	70e6                	ld	ra,120(sp)
 33a:	7446                	ld	s0,112(sp)
 33c:	6109                	addi	sp,sp,128
 33e:	8082                	ret
 340:	fc5e                	sd	s7,56(sp)
 342:	f862                	sd	s8,48(sp)
 344:	f06a                	sd	s10,32(sp)
 346:	ec6e                	sd	s11,24(sp)
  temp = malloc(size); // Allocate temporary space for one element
 348:	8532                	mv	a0,a2
 34a:	5de000ef          	jal	928 <malloc>
 34e:	8baa                	mv	s7,a0
  if (temp == 0) {
 350:	4d81                	li	s11,0
  for (uint i = 1; i < nmemb; i++) {
 352:	4d05                	li	s10,1
    memmove(temp, arr + i * size, size);
 354:	000a0c1b          	sext.w	s8,s4
  if (temp == 0) {
 358:	c511                	beqz	a0,364 <simplesort+0x52>
 35a:	f4a6                	sd	s1,104(sp)
 35c:	f0ca                	sd	s2,96(sp)
 35e:	ecce                	sd	s3,88(sp)
 360:	e0da                	sd	s6,64(sp)
 362:	a82d                	j	39c <simplesort+0x8a>
    printf("simplesort: malloc failed, cannot sort\n");
 364:	00000517          	auipc	a0,0x0
 368:	6cc50513          	addi	a0,a0,1740 # a30 <malloc+0x108>
 36c:	508000ef          	jal	874 <printf>
    return;
 370:	6a46                	ld	s4,80(sp)
 372:	6aa6                	ld	s5,72(sp)
 374:	7be2                	ld	s7,56(sp)
 376:	7c42                	ld	s8,48(sp)
 378:	7ca2                	ld	s9,40(sp)
 37a:	7d02                	ld	s10,32(sp)
 37c:	6de2                	ld	s11,24(sp)
 37e:	bf6d                	j	338 <simplesort+0x26>
    memmove(arr + j * size, temp, size);
 380:	036a053b          	mulw	a0,s4,s6
 384:	1502                	slli	a0,a0,0x20
 386:	9101                	srli	a0,a0,0x20
 388:	8662                	mv	a2,s8
 38a:	85de                	mv	a1,s7
 38c:	9556                	add	a0,a0,s5
 38e:	edfff0ef          	jal	26c <memmove>
  for (uint i = 1; i < nmemb; i++) {
 392:	2d05                	addiw	s10,s10,1
 394:	f8843783          	ld	a5,-120(s0)
 398:	05a78b63          	beq	a5,s10,3ee <simplesort+0xdc>
    memmove(temp, arr + i * size, size);
 39c:	000d899b          	sext.w	s3,s11
 3a0:	01ba05bb          	addw	a1,s4,s11
 3a4:	00058d9b          	sext.w	s11,a1
 3a8:	1582                	slli	a1,a1,0x20
 3aa:	9181                	srli	a1,a1,0x20
 3ac:	8662                	mv	a2,s8
 3ae:	95d6                	add	a1,a1,s5
 3b0:	855e                	mv	a0,s7
 3b2:	ebbff0ef          	jal	26c <memmove>
    uint j = i;
 3b6:	896a                	mv	s2,s10
 3b8:	00090b1b          	sext.w	s6,s2
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 3bc:	397d                	addiw	s2,s2,-1
 3be:	02099493          	slli	s1,s3,0x20
 3c2:	9081                	srli	s1,s1,0x20
 3c4:	94d6                	add	s1,s1,s5
 3c6:	85de                	mv	a1,s7
 3c8:	8526                	mv	a0,s1
 3ca:	9c82                	jalr	s9
 3cc:	faa05ae3          	blez	a0,380 <simplesort+0x6e>
      memmove(arr + j * size, arr + (j - 1) * size, size); // Shift element
 3d0:	0149853b          	addw	a0,s3,s4
 3d4:	1502                	slli	a0,a0,0x20
 3d6:	9101                	srli	a0,a0,0x20
 3d8:	8662                	mv	a2,s8
 3da:	85a6                	mv	a1,s1
 3dc:	9556                	add	a0,a0,s5
 3de:	e8fff0ef          	jal	26c <memmove>
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 3e2:	414989bb          	subw	s3,s3,s4
 3e6:	fc0919e3          	bnez	s2,3b8 <simplesort+0xa6>
 3ea:	8b4a                	mv	s6,s2
 3ec:	bf51                	j	380 <simplesort+0x6e>
  free(temp); // Free temporary space
 3ee:	855e                	mv	a0,s7
 3f0:	4b6000ef          	jal	8a6 <free>
 3f4:	74a6                	ld	s1,104(sp)
 3f6:	7906                	ld	s2,96(sp)
 3f8:	69e6                	ld	s3,88(sp)
 3fa:	6a46                	ld	s4,80(sp)
 3fc:	6aa6                	ld	s5,72(sp)
 3fe:	6b06                	ld	s6,64(sp)
 400:	7be2                	ld	s7,56(sp)
 402:	7c42                	ld	s8,48(sp)
 404:	7ca2                	ld	s9,40(sp)
 406:	7d02                	ld	s10,32(sp)
 408:	6de2                	ld	s11,24(sp)
 40a:	b73d                	j	338 <simplesort+0x26>

000000000000040c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 40c:	4885                	li	a7,1
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <exit>:
.global exit
exit:
 li a7, SYS_exit
 414:	4889                	li	a7,2
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <wait>:
.global wait
wait:
 li a7, SYS_wait
 41c:	488d                	li	a7,3
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 424:	4891                	li	a7,4
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <read>:
.global read
read:
 li a7, SYS_read
 42c:	4895                	li	a7,5
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <write>:
.global write
write:
 li a7, SYS_write
 434:	48c1                	li	a7,16
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <close>:
.global close
close:
 li a7, SYS_close
 43c:	48d5                	li	a7,21
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <kill>:
.global kill
kill:
 li a7, SYS_kill
 444:	4899                	li	a7,6
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <exec>:
.global exec
exec:
 li a7, SYS_exec
 44c:	489d                	li	a7,7
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <open>:
.global open
open:
 li a7, SYS_open
 454:	48bd                	li	a7,15
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 45c:	48c5                	li	a7,17
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 464:	48c9                	li	a7,18
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 46c:	48a1                	li	a7,8
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <link>:
.global link
link:
 li a7, SYS_link
 474:	48cd                	li	a7,19
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 47c:	48d1                	li	a7,20
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 484:	48a5                	li	a7,9
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <dup>:
.global dup
dup:
 li a7, SYS_dup
 48c:	48a9                	li	a7,10
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 494:	48ad                	li	a7,11
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 49c:	48b1                	li	a7,12
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4a4:	48b5                	li	a7,13
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4ac:	48b9                	li	a7,14
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 4b4:	48dd                	li	a7,23
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <statistics>:
.global statistics
statistics:
 li a7, SYS_statistics
 4bc:	48e1                	li	a7,24
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <reset_stats>:
.global reset_stats
reset_stats:
 li a7, SYS_reset_stats
 4c4:	48e5                	li	a7,25
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <resetlockstats>:
.global resetlockstats
resetlockstats:
 li a7, SYS_resetlockstats
 4cc:	48e9                	li	a7,26
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <getlockstats>:
.global getlockstats
getlockstats:
 li a7, SYS_getlockstats
 4d4:	48ed                	li	a7,27
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <trace>:
.global trace
trace:
 li a7, SYS_trace
 4dc:	48d9                	li	a7,22
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 4e4:	48f1                	li	a7,28
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <ugetpid>:
.global ugetpid
ugetpid:
 li a7, SYS_ugetpid
 4ec:	48f5                	li	a7,29
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 4f4:	48f9                	li	a7,30
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4fc:	1101                	addi	sp,sp,-32
 4fe:	ec06                	sd	ra,24(sp)
 500:	e822                	sd	s0,16(sp)
 502:	1000                	addi	s0,sp,32
 504:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 508:	4605                	li	a2,1
 50a:	fef40593          	addi	a1,s0,-17
 50e:	f27ff0ef          	jal	434 <write>
}
 512:	60e2                	ld	ra,24(sp)
 514:	6442                	ld	s0,16(sp)
 516:	6105                	addi	sp,sp,32
 518:	8082                	ret

000000000000051a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 51a:	7139                	addi	sp,sp,-64
 51c:	fc06                	sd	ra,56(sp)
 51e:	f822                	sd	s0,48(sp)
 520:	f426                	sd	s1,40(sp)
 522:	0080                	addi	s0,sp,64
 524:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 526:	c299                	beqz	a3,52c <printint+0x12>
 528:	0805c963          	bltz	a1,5ba <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 52c:	2581                	sext.w	a1,a1
  neg = 0;
 52e:	4881                	li	a7,0
 530:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 534:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 536:	2601                	sext.w	a2,a2
 538:	00000517          	auipc	a0,0x0
 53c:	52850513          	addi	a0,a0,1320 # a60 <digits>
 540:	883a                	mv	a6,a4
 542:	2705                	addiw	a4,a4,1
 544:	02c5f7bb          	remuw	a5,a1,a2
 548:	1782                	slli	a5,a5,0x20
 54a:	9381                	srli	a5,a5,0x20
 54c:	97aa                	add	a5,a5,a0
 54e:	0007c783          	lbu	a5,0(a5)
 552:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 556:	0005879b          	sext.w	a5,a1
 55a:	02c5d5bb          	divuw	a1,a1,a2
 55e:	0685                	addi	a3,a3,1
 560:	fec7f0e3          	bgeu	a5,a2,540 <printint+0x26>
  if(neg)
 564:	00088c63          	beqz	a7,57c <printint+0x62>
    buf[i++] = '-';
 568:	fd070793          	addi	a5,a4,-48
 56c:	00878733          	add	a4,a5,s0
 570:	02d00793          	li	a5,45
 574:	fef70823          	sb	a5,-16(a4)
 578:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 57c:	02e05a63          	blez	a4,5b0 <printint+0x96>
 580:	f04a                	sd	s2,32(sp)
 582:	ec4e                	sd	s3,24(sp)
 584:	fc040793          	addi	a5,s0,-64
 588:	00e78933          	add	s2,a5,a4
 58c:	fff78993          	addi	s3,a5,-1
 590:	99ba                	add	s3,s3,a4
 592:	377d                	addiw	a4,a4,-1
 594:	1702                	slli	a4,a4,0x20
 596:	9301                	srli	a4,a4,0x20
 598:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 59c:	fff94583          	lbu	a1,-1(s2)
 5a0:	8526                	mv	a0,s1
 5a2:	f5bff0ef          	jal	4fc <putc>
  while(--i >= 0)
 5a6:	197d                	addi	s2,s2,-1
 5a8:	ff391ae3          	bne	s2,s3,59c <printint+0x82>
 5ac:	7902                	ld	s2,32(sp)
 5ae:	69e2                	ld	s3,24(sp)
}
 5b0:	70e2                	ld	ra,56(sp)
 5b2:	7442                	ld	s0,48(sp)
 5b4:	74a2                	ld	s1,40(sp)
 5b6:	6121                	addi	sp,sp,64
 5b8:	8082                	ret
    x = -xx;
 5ba:	40b005bb          	negw	a1,a1
    neg = 1;
 5be:	4885                	li	a7,1
    x = -xx;
 5c0:	bf85                	j	530 <printint+0x16>

00000000000005c2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5c2:	711d                	addi	sp,sp,-96
 5c4:	ec86                	sd	ra,88(sp)
 5c6:	e8a2                	sd	s0,80(sp)
 5c8:	e0ca                	sd	s2,64(sp)
 5ca:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5cc:	0005c903          	lbu	s2,0(a1)
 5d0:	26090863          	beqz	s2,840 <vprintf+0x27e>
 5d4:	e4a6                	sd	s1,72(sp)
 5d6:	fc4e                	sd	s3,56(sp)
 5d8:	f852                	sd	s4,48(sp)
 5da:	f456                	sd	s5,40(sp)
 5dc:	f05a                	sd	s6,32(sp)
 5de:	ec5e                	sd	s7,24(sp)
 5e0:	e862                	sd	s8,16(sp)
 5e2:	e466                	sd	s9,8(sp)
 5e4:	8b2a                	mv	s6,a0
 5e6:	8a2e                	mv	s4,a1
 5e8:	8bb2                	mv	s7,a2
  state = 0;
 5ea:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5ec:	4481                	li	s1,0
 5ee:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5f0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5f4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5f8:	06c00c93          	li	s9,108
 5fc:	a005                	j	61c <vprintf+0x5a>
        putc(fd, c0);
 5fe:	85ca                	mv	a1,s2
 600:	855a                	mv	a0,s6
 602:	efbff0ef          	jal	4fc <putc>
 606:	a019                	j	60c <vprintf+0x4a>
    } else if(state == '%'){
 608:	03598263          	beq	s3,s5,62c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 60c:	2485                	addiw	s1,s1,1
 60e:	8726                	mv	a4,s1
 610:	009a07b3          	add	a5,s4,s1
 614:	0007c903          	lbu	s2,0(a5)
 618:	20090c63          	beqz	s2,830 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 61c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 620:	fe0994e3          	bnez	s3,608 <vprintf+0x46>
      if(c0 == '%'){
 624:	fd579de3          	bne	a5,s5,5fe <vprintf+0x3c>
        state = '%';
 628:	89be                	mv	s3,a5
 62a:	b7cd                	j	60c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 62c:	00ea06b3          	add	a3,s4,a4
 630:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 634:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 636:	c681                	beqz	a3,63e <vprintf+0x7c>
 638:	9752                	add	a4,a4,s4
 63a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 63e:	03878f63          	beq	a5,s8,67c <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 642:	05978963          	beq	a5,s9,694 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 646:	07500713          	li	a4,117
 64a:	0ee78363          	beq	a5,a4,730 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 64e:	07800713          	li	a4,120
 652:	12e78563          	beq	a5,a4,77c <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 656:	07000713          	li	a4,112
 65a:	14e78a63          	beq	a5,a4,7ae <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 65e:	07300713          	li	a4,115
 662:	18e78a63          	beq	a5,a4,7f6 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 666:	02500713          	li	a4,37
 66a:	04e79563          	bne	a5,a4,6b4 <vprintf+0xf2>
        putc(fd, '%');
 66e:	02500593          	li	a1,37
 672:	855a                	mv	a0,s6
 674:	e89ff0ef          	jal	4fc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 678:	4981                	li	s3,0
 67a:	bf49                	j	60c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 67c:	008b8913          	addi	s2,s7,8
 680:	4685                	li	a3,1
 682:	4629                	li	a2,10
 684:	000ba583          	lw	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	e91ff0ef          	jal	51a <printint>
 68e:	8bca                	mv	s7,s2
      state = 0;
 690:	4981                	li	s3,0
 692:	bfad                	j	60c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 694:	06400793          	li	a5,100
 698:	02f68963          	beq	a3,a5,6ca <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 69c:	06c00793          	li	a5,108
 6a0:	04f68263          	beq	a3,a5,6e4 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 6a4:	07500793          	li	a5,117
 6a8:	0af68063          	beq	a3,a5,748 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 6ac:	07800793          	li	a5,120
 6b0:	0ef68263          	beq	a3,a5,794 <vprintf+0x1d2>
        putc(fd, '%');
 6b4:	02500593          	li	a1,37
 6b8:	855a                	mv	a0,s6
 6ba:	e43ff0ef          	jal	4fc <putc>
        putc(fd, c0);
 6be:	85ca                	mv	a1,s2
 6c0:	855a                	mv	a0,s6
 6c2:	e3bff0ef          	jal	4fc <putc>
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	b791                	j	60c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ca:	008b8913          	addi	s2,s7,8
 6ce:	4685                	li	a3,1
 6d0:	4629                	li	a2,10
 6d2:	000ba583          	lw	a1,0(s7)
 6d6:	855a                	mv	a0,s6
 6d8:	e43ff0ef          	jal	51a <printint>
        i += 1;
 6dc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6de:	8bca                	mv	s7,s2
      state = 0;
 6e0:	4981                	li	s3,0
        i += 1;
 6e2:	b72d                	j	60c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6e4:	06400793          	li	a5,100
 6e8:	02f60763          	beq	a2,a5,716 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6ec:	07500793          	li	a5,117
 6f0:	06f60963          	beq	a2,a5,762 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6f4:	07800793          	li	a5,120
 6f8:	faf61ee3          	bne	a2,a5,6b4 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fc:	008b8913          	addi	s2,s7,8
 700:	4681                	li	a3,0
 702:	4641                	li	a2,16
 704:	000ba583          	lw	a1,0(s7)
 708:	855a                	mv	a0,s6
 70a:	e11ff0ef          	jal	51a <printint>
        i += 2;
 70e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 710:	8bca                	mv	s7,s2
      state = 0;
 712:	4981                	li	s3,0
        i += 2;
 714:	bde5                	j	60c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 716:	008b8913          	addi	s2,s7,8
 71a:	4685                	li	a3,1
 71c:	4629                	li	a2,10
 71e:	000ba583          	lw	a1,0(s7)
 722:	855a                	mv	a0,s6
 724:	df7ff0ef          	jal	51a <printint>
        i += 2;
 728:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 72a:	8bca                	mv	s7,s2
      state = 0;
 72c:	4981                	li	s3,0
        i += 2;
 72e:	bdf9                	j	60c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 730:	008b8913          	addi	s2,s7,8
 734:	4681                	li	a3,0
 736:	4629                	li	a2,10
 738:	000ba583          	lw	a1,0(s7)
 73c:	855a                	mv	a0,s6
 73e:	dddff0ef          	jal	51a <printint>
 742:	8bca                	mv	s7,s2
      state = 0;
 744:	4981                	li	s3,0
 746:	b5d9                	j	60c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 748:	008b8913          	addi	s2,s7,8
 74c:	4681                	li	a3,0
 74e:	4629                	li	a2,10
 750:	000ba583          	lw	a1,0(s7)
 754:	855a                	mv	a0,s6
 756:	dc5ff0ef          	jal	51a <printint>
        i += 1;
 75a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 75c:	8bca                	mv	s7,s2
      state = 0;
 75e:	4981                	li	s3,0
        i += 1;
 760:	b575                	j	60c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 762:	008b8913          	addi	s2,s7,8
 766:	4681                	li	a3,0
 768:	4629                	li	a2,10
 76a:	000ba583          	lw	a1,0(s7)
 76e:	855a                	mv	a0,s6
 770:	dabff0ef          	jal	51a <printint>
        i += 2;
 774:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 776:	8bca                	mv	s7,s2
      state = 0;
 778:	4981                	li	s3,0
        i += 2;
 77a:	bd49                	j	60c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 77c:	008b8913          	addi	s2,s7,8
 780:	4681                	li	a3,0
 782:	4641                	li	a2,16
 784:	000ba583          	lw	a1,0(s7)
 788:	855a                	mv	a0,s6
 78a:	d91ff0ef          	jal	51a <printint>
 78e:	8bca                	mv	s7,s2
      state = 0;
 790:	4981                	li	s3,0
 792:	bdad                	j	60c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 794:	008b8913          	addi	s2,s7,8
 798:	4681                	li	a3,0
 79a:	4641                	li	a2,16
 79c:	000ba583          	lw	a1,0(s7)
 7a0:	855a                	mv	a0,s6
 7a2:	d79ff0ef          	jal	51a <printint>
        i += 1;
 7a6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7a8:	8bca                	mv	s7,s2
      state = 0;
 7aa:	4981                	li	s3,0
        i += 1;
 7ac:	b585                	j	60c <vprintf+0x4a>
 7ae:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7b0:	008b8d13          	addi	s10,s7,8
 7b4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7b8:	03000593          	li	a1,48
 7bc:	855a                	mv	a0,s6
 7be:	d3fff0ef          	jal	4fc <putc>
  putc(fd, 'x');
 7c2:	07800593          	li	a1,120
 7c6:	855a                	mv	a0,s6
 7c8:	d35ff0ef          	jal	4fc <putc>
 7cc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ce:	00000b97          	auipc	s7,0x0
 7d2:	292b8b93          	addi	s7,s7,658 # a60 <digits>
 7d6:	03c9d793          	srli	a5,s3,0x3c
 7da:	97de                	add	a5,a5,s7
 7dc:	0007c583          	lbu	a1,0(a5)
 7e0:	855a                	mv	a0,s6
 7e2:	d1bff0ef          	jal	4fc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7e6:	0992                	slli	s3,s3,0x4
 7e8:	397d                	addiw	s2,s2,-1
 7ea:	fe0916e3          	bnez	s2,7d6 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7ee:	8bea                	mv	s7,s10
      state = 0;
 7f0:	4981                	li	s3,0
 7f2:	6d02                	ld	s10,0(sp)
 7f4:	bd21                	j	60c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7f6:	008b8993          	addi	s3,s7,8
 7fa:	000bb903          	ld	s2,0(s7)
 7fe:	00090f63          	beqz	s2,81c <vprintf+0x25a>
        for(; *s; s++)
 802:	00094583          	lbu	a1,0(s2)
 806:	c195                	beqz	a1,82a <vprintf+0x268>
          putc(fd, *s);
 808:	855a                	mv	a0,s6
 80a:	cf3ff0ef          	jal	4fc <putc>
        for(; *s; s++)
 80e:	0905                	addi	s2,s2,1
 810:	00094583          	lbu	a1,0(s2)
 814:	f9f5                	bnez	a1,808 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 816:	8bce                	mv	s7,s3
      state = 0;
 818:	4981                	li	s3,0
 81a:	bbcd                	j	60c <vprintf+0x4a>
          s = "(null)";
 81c:	00000917          	auipc	s2,0x0
 820:	23c90913          	addi	s2,s2,572 # a58 <malloc+0x130>
        for(; *s; s++)
 824:	02800593          	li	a1,40
 828:	b7c5                	j	808 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 82a:	8bce                	mv	s7,s3
      state = 0;
 82c:	4981                	li	s3,0
 82e:	bbf9                	j	60c <vprintf+0x4a>
 830:	64a6                	ld	s1,72(sp)
 832:	79e2                	ld	s3,56(sp)
 834:	7a42                	ld	s4,48(sp)
 836:	7aa2                	ld	s5,40(sp)
 838:	7b02                	ld	s6,32(sp)
 83a:	6be2                	ld	s7,24(sp)
 83c:	6c42                	ld	s8,16(sp)
 83e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 840:	60e6                	ld	ra,88(sp)
 842:	6446                	ld	s0,80(sp)
 844:	6906                	ld	s2,64(sp)
 846:	6125                	addi	sp,sp,96
 848:	8082                	ret

000000000000084a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 84a:	715d                	addi	sp,sp,-80
 84c:	ec06                	sd	ra,24(sp)
 84e:	e822                	sd	s0,16(sp)
 850:	1000                	addi	s0,sp,32
 852:	e010                	sd	a2,0(s0)
 854:	e414                	sd	a3,8(s0)
 856:	e818                	sd	a4,16(s0)
 858:	ec1c                	sd	a5,24(s0)
 85a:	03043023          	sd	a6,32(s0)
 85e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 862:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 866:	8622                	mv	a2,s0
 868:	d5bff0ef          	jal	5c2 <vprintf>
}
 86c:	60e2                	ld	ra,24(sp)
 86e:	6442                	ld	s0,16(sp)
 870:	6161                	addi	sp,sp,80
 872:	8082                	ret

0000000000000874 <printf>:

void
printf(const char *fmt, ...)
{
 874:	711d                	addi	sp,sp,-96
 876:	ec06                	sd	ra,24(sp)
 878:	e822                	sd	s0,16(sp)
 87a:	1000                	addi	s0,sp,32
 87c:	e40c                	sd	a1,8(s0)
 87e:	e810                	sd	a2,16(s0)
 880:	ec14                	sd	a3,24(s0)
 882:	f018                	sd	a4,32(s0)
 884:	f41c                	sd	a5,40(s0)
 886:	03043823          	sd	a6,48(s0)
 88a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 88e:	00840613          	addi	a2,s0,8
 892:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 896:	85aa                	mv	a1,a0
 898:	4505                	li	a0,1
 89a:	d29ff0ef          	jal	5c2 <vprintf>
}
 89e:	60e2                	ld	ra,24(sp)
 8a0:	6442                	ld	s0,16(sp)
 8a2:	6125                	addi	sp,sp,96
 8a4:	8082                	ret

00000000000008a6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8a6:	1141                	addi	sp,sp,-16
 8a8:	e422                	sd	s0,8(sp)
 8aa:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ac:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b0:	00000797          	auipc	a5,0x0
 8b4:	7507b783          	ld	a5,1872(a5) # 1000 <freep>
 8b8:	a02d                	j	8e2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8ba:	4618                	lw	a4,8(a2)
 8bc:	9f2d                	addw	a4,a4,a1
 8be:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c2:	6398                	ld	a4,0(a5)
 8c4:	6310                	ld	a2,0(a4)
 8c6:	a83d                	j	904 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8c8:	ff852703          	lw	a4,-8(a0)
 8cc:	9f31                	addw	a4,a4,a2
 8ce:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8d0:	ff053683          	ld	a3,-16(a0)
 8d4:	a091                	j	918 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d6:	6398                	ld	a4,0(a5)
 8d8:	00e7e463          	bltu	a5,a4,8e0 <free+0x3a>
 8dc:	00e6ea63          	bltu	a3,a4,8f0 <free+0x4a>
{
 8e0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e2:	fed7fae3          	bgeu	a5,a3,8d6 <free+0x30>
 8e6:	6398                	ld	a4,0(a5)
 8e8:	00e6e463          	bltu	a3,a4,8f0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ec:	fee7eae3          	bltu	a5,a4,8e0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8f0:	ff852583          	lw	a1,-8(a0)
 8f4:	6390                	ld	a2,0(a5)
 8f6:	02059813          	slli	a6,a1,0x20
 8fa:	01c85713          	srli	a4,a6,0x1c
 8fe:	9736                	add	a4,a4,a3
 900:	fae60de3          	beq	a2,a4,8ba <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 904:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 908:	4790                	lw	a2,8(a5)
 90a:	02061593          	slli	a1,a2,0x20
 90e:	01c5d713          	srli	a4,a1,0x1c
 912:	973e                	add	a4,a4,a5
 914:	fae68ae3          	beq	a3,a4,8c8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 918:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 91a:	00000717          	auipc	a4,0x0
 91e:	6ef73323          	sd	a5,1766(a4) # 1000 <freep>
}
 922:	6422                	ld	s0,8(sp)
 924:	0141                	addi	sp,sp,16
 926:	8082                	ret

0000000000000928 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 928:	7139                	addi	sp,sp,-64
 92a:	fc06                	sd	ra,56(sp)
 92c:	f822                	sd	s0,48(sp)
 92e:	f426                	sd	s1,40(sp)
 930:	ec4e                	sd	s3,24(sp)
 932:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 934:	02051493          	slli	s1,a0,0x20
 938:	9081                	srli	s1,s1,0x20
 93a:	04bd                	addi	s1,s1,15
 93c:	8091                	srli	s1,s1,0x4
 93e:	0014899b          	addiw	s3,s1,1
 942:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 944:	00000517          	auipc	a0,0x0
 948:	6bc53503          	ld	a0,1724(a0) # 1000 <freep>
 94c:	c915                	beqz	a0,980 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 94e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 950:	4798                	lw	a4,8(a5)
 952:	08977a63          	bgeu	a4,s1,9e6 <malloc+0xbe>
 956:	f04a                	sd	s2,32(sp)
 958:	e852                	sd	s4,16(sp)
 95a:	e456                	sd	s5,8(sp)
 95c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 95e:	8a4e                	mv	s4,s3
 960:	0009871b          	sext.w	a4,s3
 964:	6685                	lui	a3,0x1
 966:	00d77363          	bgeu	a4,a3,96c <malloc+0x44>
 96a:	6a05                	lui	s4,0x1
 96c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 970:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 974:	00000917          	auipc	s2,0x0
 978:	68c90913          	addi	s2,s2,1676 # 1000 <freep>
  if(p == (char*)-1)
 97c:	5afd                	li	s5,-1
 97e:	a081                	j	9be <malloc+0x96>
 980:	f04a                	sd	s2,32(sp)
 982:	e852                	sd	s4,16(sp)
 984:	e456                	sd	s5,8(sp)
 986:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 988:	00000797          	auipc	a5,0x0
 98c:	68878793          	addi	a5,a5,1672 # 1010 <base>
 990:	00000717          	auipc	a4,0x0
 994:	66f73823          	sd	a5,1648(a4) # 1000 <freep>
 998:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 99a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 99e:	b7c1                	j	95e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9a0:	6398                	ld	a4,0(a5)
 9a2:	e118                	sd	a4,0(a0)
 9a4:	a8a9                	j	9fe <malloc+0xd6>
  hp->s.size = nu;
 9a6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9aa:	0541                	addi	a0,a0,16
 9ac:	efbff0ef          	jal	8a6 <free>
  return freep;
 9b0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9b4:	c12d                	beqz	a0,a16 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9b8:	4798                	lw	a4,8(a5)
 9ba:	02977263          	bgeu	a4,s1,9de <malloc+0xb6>
    if(p == freep)
 9be:	00093703          	ld	a4,0(s2)
 9c2:	853e                	mv	a0,a5
 9c4:	fef719e3          	bne	a4,a5,9b6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9c8:	8552                	mv	a0,s4
 9ca:	ad3ff0ef          	jal	49c <sbrk>
  if(p == (char*)-1)
 9ce:	fd551ce3          	bne	a0,s5,9a6 <malloc+0x7e>
        return 0;
 9d2:	4501                	li	a0,0
 9d4:	7902                	ld	s2,32(sp)
 9d6:	6a42                	ld	s4,16(sp)
 9d8:	6aa2                	ld	s5,8(sp)
 9da:	6b02                	ld	s6,0(sp)
 9dc:	a03d                	j	a0a <malloc+0xe2>
 9de:	7902                	ld	s2,32(sp)
 9e0:	6a42                	ld	s4,16(sp)
 9e2:	6aa2                	ld	s5,8(sp)
 9e4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9e6:	fae48de3          	beq	s1,a4,9a0 <malloc+0x78>
        p->s.size -= nunits;
 9ea:	4137073b          	subw	a4,a4,s3
 9ee:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9f0:	02071693          	slli	a3,a4,0x20
 9f4:	01c6d713          	srli	a4,a3,0x1c
 9f8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9fa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9fe:	00000717          	auipc	a4,0x0
 a02:	60a73123          	sd	a0,1538(a4) # 1000 <freep>
      return (void*)(p + 1);
 a06:	01078513          	addi	a0,a5,16
  }
}
 a0a:	70e2                	ld	ra,56(sp)
 a0c:	7442                	ld	s0,48(sp)
 a0e:	74a2                	ld	s1,40(sp)
 a10:	69e2                	ld	s3,24(sp)
 a12:	6121                	addi	sp,sp,64
 a14:	8082                	ret
 a16:	7902                	ld	s2,32(sp)
 a18:	6a42                	ld	s4,16(sp)
 a1a:	6aa2                	ld	s5,8(sp)
 a1c:	6b02                	ld	s6,0(sp)
 a1e:	b7f5                	j	a0a <malloc+0xe2>
