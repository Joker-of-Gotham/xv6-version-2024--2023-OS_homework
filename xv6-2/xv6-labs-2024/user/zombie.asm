
user/_zombie：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	3a8000ef          	jal	3b0 <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    sleep(5);  // Let child exit before parent.
  exit(0);
  10:	4501                	li	a0,0
  12:	3a6000ef          	jal	3b8 <exit>
    sleep(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	430000ef          	jal	448 <sleep>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  extern int main();
  main();
  26:	fdbff0ef          	jal	0 <main>
  exit(0);
  2a:	4501                	li	a0,0
  2c:	38c000ef          	jal	3b8 <exit>

0000000000000030 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  30:	1141                	addi	sp,sp,-16
  32:	e422                	sd	s0,8(sp)
  34:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  36:	87aa                	mv	a5,a0
  38:	0585                	addi	a1,a1,1
  3a:	0785                	addi	a5,a5,1
  3c:	fff5c703          	lbu	a4,-1(a1)
  40:	fee78fa3          	sb	a4,-1(a5)
  44:	fb75                	bnez	a4,38 <strcpy+0x8>
    ;
  return os;
}
  46:	6422                	ld	s0,8(sp)
  48:	0141                	addi	sp,sp,16
  4a:	8082                	ret

000000000000004c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4c:	1141                	addi	sp,sp,-16
  4e:	e422                	sd	s0,8(sp)
  50:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  52:	00054783          	lbu	a5,0(a0)
  56:	cb91                	beqz	a5,6a <strcmp+0x1e>
  58:	0005c703          	lbu	a4,0(a1)
  5c:	00f71763          	bne	a4,a5,6a <strcmp+0x1e>
    p++, q++;
  60:	0505                	addi	a0,a0,1
  62:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  64:	00054783          	lbu	a5,0(a0)
  68:	fbe5                	bnez	a5,58 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  6a:	0005c503          	lbu	a0,0(a1)
}
  6e:	40a7853b          	subw	a0,a5,a0
  72:	6422                	ld	s0,8(sp)
  74:	0141                	addi	sp,sp,16
  76:	8082                	ret

0000000000000078 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q) {
  7e:	ce11                	beqz	a2,9a <strncmp+0x22>
  80:	00054783          	lbu	a5,0(a0)
  84:	cf89                	beqz	a5,9e <strncmp+0x26>
  86:	0005c703          	lbu	a4,0(a1)
  8a:	00f71a63          	bne	a4,a5,9e <strncmp+0x26>
    n--;
  8e:	367d                	addiw	a2,a2,-1
    p++;
  90:	0505                	addi	a0,a0,1
    q++;
  92:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q) {
  94:	f675                	bnez	a2,80 <strncmp+0x8>
  }
  if(n == 0)
    return 0;
  96:	4501                	li	a0,0
  98:	a801                	j	a8 <strncmp+0x30>
  9a:	4501                	li	a0,0
  9c:	a031                	j	a8 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
  9e:	00054503          	lbu	a0,0(a0)
  a2:	0005c783          	lbu	a5,0(a1)
  a6:	9d1d                	subw	a0,a0,a5
}
  a8:	6422                	ld	s0,8(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strlen>:

uint
strlen(const char *s)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e422                	sd	s0,8(sp)
  b2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b4:	00054783          	lbu	a5,0(a0)
  b8:	cf91                	beqz	a5,d4 <strlen+0x26>
  ba:	0505                	addi	a0,a0,1
  bc:	87aa                	mv	a5,a0
  be:	86be                	mv	a3,a5
  c0:	0785                	addi	a5,a5,1
  c2:	fff7c703          	lbu	a4,-1(a5)
  c6:	ff65                	bnez	a4,be <strlen+0x10>
  c8:	40a6853b          	subw	a0,a3,a0
  cc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  ce:	6422                	ld	s0,8(sp)
  d0:	0141                	addi	sp,sp,16
  d2:	8082                	ret
  for(n = 0; s[n]; n++)
  d4:	4501                	li	a0,0
  d6:	bfe5                	j	ce <strlen+0x20>

00000000000000d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  de:	ca19                	beqz	a2,f4 <memset+0x1c>
  e0:	87aa                	mv	a5,a0
  e2:	1602                	slli	a2,a2,0x20
  e4:	9201                	srli	a2,a2,0x20
  e6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ea:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ee:	0785                	addi	a5,a5,1
  f0:	fee79de3          	bne	a5,a4,ea <memset+0x12>
  }
  return dst;
}
  f4:	6422                	ld	s0,8(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret

00000000000000fa <strchr>:

char*
strchr(const char *s, char c)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e422                	sd	s0,8(sp)
  fe:	0800                	addi	s0,sp,16
  for(; *s; s++)
 100:	00054783          	lbu	a5,0(a0)
 104:	cb99                	beqz	a5,11a <strchr+0x20>
    if(*s == c)
 106:	00f58763          	beq	a1,a5,114 <strchr+0x1a>
  for(; *s; s++)
 10a:	0505                	addi	a0,a0,1
 10c:	00054783          	lbu	a5,0(a0)
 110:	fbfd                	bnez	a5,106 <strchr+0xc>
      return (char*)s;
  return 0;
 112:	4501                	li	a0,0
}
 114:	6422                	ld	s0,8(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret
  return 0;
 11a:	4501                	li	a0,0
 11c:	bfe5                	j	114 <strchr+0x1a>

000000000000011e <gets>:

char*
gets(char *buf, int max)
{
 11e:	711d                	addi	sp,sp,-96
 120:	ec86                	sd	ra,88(sp)
 122:	e8a2                	sd	s0,80(sp)
 124:	e4a6                	sd	s1,72(sp)
 126:	e0ca                	sd	s2,64(sp)
 128:	fc4e                	sd	s3,56(sp)
 12a:	f852                	sd	s4,48(sp)
 12c:	f456                	sd	s5,40(sp)
 12e:	f05a                	sd	s6,32(sp)
 130:	ec5e                	sd	s7,24(sp)
 132:	1080                	addi	s0,sp,96
 134:	8baa                	mv	s7,a0
 136:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 138:	892a                	mv	s2,a0
 13a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 13c:	4aa9                	li	s5,10
 13e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 140:	89a6                	mv	s3,s1
 142:	2485                	addiw	s1,s1,1
 144:	0344d663          	bge	s1,s4,170 <gets+0x52>
    cc = read(0, &c, 1);
 148:	4605                	li	a2,1
 14a:	faf40593          	addi	a1,s0,-81
 14e:	4501                	li	a0,0
 150:	280000ef          	jal	3d0 <read>
    if(cc < 1)
 154:	00a05e63          	blez	a0,170 <gets+0x52>
    buf[i++] = c;
 158:	faf44783          	lbu	a5,-81(s0)
 15c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 160:	01578763          	beq	a5,s5,16e <gets+0x50>
 164:	0905                	addi	s2,s2,1
 166:	fd679de3          	bne	a5,s6,140 <gets+0x22>
    buf[i++] = c;
 16a:	89a6                	mv	s3,s1
 16c:	a011                	j	170 <gets+0x52>
 16e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 170:	99de                	add	s3,s3,s7
 172:	00098023          	sb	zero,0(s3)
  return buf;
}
 176:	855e                	mv	a0,s7
 178:	60e6                	ld	ra,88(sp)
 17a:	6446                	ld	s0,80(sp)
 17c:	64a6                	ld	s1,72(sp)
 17e:	6906                	ld	s2,64(sp)
 180:	79e2                	ld	s3,56(sp)
 182:	7a42                	ld	s4,48(sp)
 184:	7aa2                	ld	s5,40(sp)
 186:	7b02                	ld	s6,32(sp)
 188:	6be2                	ld	s7,24(sp)
 18a:	6125                	addi	sp,sp,96
 18c:	8082                	ret

000000000000018e <stat>:

int
stat(const char *n, struct stat *st)
{
 18e:	1101                	addi	sp,sp,-32
 190:	ec06                	sd	ra,24(sp)
 192:	e822                	sd	s0,16(sp)
 194:	e04a                	sd	s2,0(sp)
 196:	1000                	addi	s0,sp,32
 198:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19a:	4581                	li	a1,0
 19c:	25c000ef          	jal	3f8 <open>
  if(fd < 0)
 1a0:	02054263          	bltz	a0,1c4 <stat+0x36>
 1a4:	e426                	sd	s1,8(sp)
 1a6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a8:	85ca                	mv	a1,s2
 1aa:	266000ef          	jal	410 <fstat>
 1ae:	892a                	mv	s2,a0
  close(fd);
 1b0:	8526                	mv	a0,s1
 1b2:	22e000ef          	jal	3e0 <close>
  return r;
 1b6:	64a2                	ld	s1,8(sp)
}
 1b8:	854a                	mv	a0,s2
 1ba:	60e2                	ld	ra,24(sp)
 1bc:	6442                	ld	s0,16(sp)
 1be:	6902                	ld	s2,0(sp)
 1c0:	6105                	addi	sp,sp,32
 1c2:	8082                	ret
    return -1;
 1c4:	597d                	li	s2,-1
 1c6:	bfcd                	j	1b8 <stat+0x2a>

00000000000001c8 <atoi>:

int
atoi(const char *s)
{
 1c8:	1141                	addi	sp,sp,-16
 1ca:	e422                	sd	s0,8(sp)
 1cc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ce:	00054683          	lbu	a3,0(a0)
 1d2:	fd06879b          	addiw	a5,a3,-48
 1d6:	0ff7f793          	zext.b	a5,a5
 1da:	4625                	li	a2,9
 1dc:	02f66863          	bltu	a2,a5,20c <atoi+0x44>
 1e0:	872a                	mv	a4,a0
  n = 0;
 1e2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1e4:	0705                	addi	a4,a4,1
 1e6:	0025179b          	slliw	a5,a0,0x2
 1ea:	9fa9                	addw	a5,a5,a0
 1ec:	0017979b          	slliw	a5,a5,0x1
 1f0:	9fb5                	addw	a5,a5,a3
 1f2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f6:	00074683          	lbu	a3,0(a4)
 1fa:	fd06879b          	addiw	a5,a3,-48
 1fe:	0ff7f793          	zext.b	a5,a5
 202:	fef671e3          	bgeu	a2,a5,1e4 <atoi+0x1c>
  return n;
}
 206:	6422                	ld	s0,8(sp)
 208:	0141                	addi	sp,sp,16
 20a:	8082                	ret
  n = 0;
 20c:	4501                	li	a0,0
 20e:	bfe5                	j	206 <atoi+0x3e>

0000000000000210 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 210:	1141                	addi	sp,sp,-16
 212:	e422                	sd	s0,8(sp)
 214:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 216:	02b57463          	bgeu	a0,a1,23e <memmove+0x2e>
    while(n-- > 0)
 21a:	00c05f63          	blez	a2,238 <memmove+0x28>
 21e:	1602                	slli	a2,a2,0x20
 220:	9201                	srli	a2,a2,0x20
 222:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 226:	872a                	mv	a4,a0
      *dst++ = *src++;
 228:	0585                	addi	a1,a1,1
 22a:	0705                	addi	a4,a4,1
 22c:	fff5c683          	lbu	a3,-1(a1)
 230:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 234:	fef71ae3          	bne	a4,a5,228 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret
    dst += n;
 23e:	00c50733          	add	a4,a0,a2
    src += n;
 242:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 244:	fec05ae3          	blez	a2,238 <memmove+0x28>
 248:	fff6079b          	addiw	a5,a2,-1
 24c:	1782                	slli	a5,a5,0x20
 24e:	9381                	srli	a5,a5,0x20
 250:	fff7c793          	not	a5,a5
 254:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 256:	15fd                	addi	a1,a1,-1
 258:	177d                	addi	a4,a4,-1
 25a:	0005c683          	lbu	a3,0(a1)
 25e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 262:	fee79ae3          	bne	a5,a4,256 <memmove+0x46>
 266:	bfc9                	j	238 <memmove+0x28>

0000000000000268 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e422                	sd	s0,8(sp)
 26c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 26e:	ca05                	beqz	a2,29e <memcmp+0x36>
 270:	fff6069b          	addiw	a3,a2,-1
 274:	1682                	slli	a3,a3,0x20
 276:	9281                	srli	a3,a3,0x20
 278:	0685                	addi	a3,a3,1
 27a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 27c:	00054783          	lbu	a5,0(a0)
 280:	0005c703          	lbu	a4,0(a1)
 284:	00e79863          	bne	a5,a4,294 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 288:	0505                	addi	a0,a0,1
    p2++;
 28a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 28c:	fed518e3          	bne	a0,a3,27c <memcmp+0x14>
  }
  return 0;
 290:	4501                	li	a0,0
 292:	a019                	j	298 <memcmp+0x30>
      return *p1 - *p2;
 294:	40e7853b          	subw	a0,a5,a4
}
 298:	6422                	ld	s0,8(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
  return 0;
 29e:	4501                	li	a0,0
 2a0:	bfe5                	j	298 <memcmp+0x30>

00000000000002a2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e406                	sd	ra,8(sp)
 2a6:	e022                	sd	s0,0(sp)
 2a8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2aa:	f67ff0ef          	jal	210 <memmove>
}
 2ae:	60a2                	ld	ra,8(sp)
 2b0:	6402                	ld	s0,0(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret

00000000000002b6 <simplesort>:

void
simplesort(void *base, uint nmemb, uint size, int (*compar)(const void *, const void *))
{
 2b6:	7119                	addi	sp,sp,-128
 2b8:	fc86                	sd	ra,120(sp)
 2ba:	f8a2                	sd	s0,112(sp)
 2bc:	0100                	addi	s0,sp,128
 2be:	f8b43423          	sd	a1,-120(s0)
  char *arr = (char *)base; // Treat array as char array for byte-level manipulation
  char *temp;               // Temporary storage for an element

  if (nmemb <= 1 || size == 0) {
 2c2:	4785                	li	a5,1
 2c4:	00b7fc63          	bgeu	a5,a1,2dc <simplesort+0x26>
 2c8:	e8d2                	sd	s4,80(sp)
 2ca:	e4d6                	sd	s5,72(sp)
 2cc:	f466                	sd	s9,40(sp)
 2ce:	8aaa                	mv	s5,a0
 2d0:	8a32                	mv	s4,a2
 2d2:	8cb6                	mv	s9,a3
 2d4:	ea01                	bnez	a2,2e4 <simplesort+0x2e>
 2d6:	6a46                	ld	s4,80(sp)
 2d8:	6aa6                	ld	s5,72(sp)
 2da:	7ca2                	ld	s9,40(sp)
    // Place temp at its correct position
    memmove(arr + j * size, temp, size);
  }

  free(temp); // Free temporary space
 2dc:	70e6                	ld	ra,120(sp)
 2de:	7446                	ld	s0,112(sp)
 2e0:	6109                	addi	sp,sp,128
 2e2:	8082                	ret
 2e4:	fc5e                	sd	s7,56(sp)
 2e6:	f862                	sd	s8,48(sp)
 2e8:	f06a                	sd	s10,32(sp)
 2ea:	ec6e                	sd	s11,24(sp)
  temp = malloc(size); // Allocate temporary space for one element
 2ec:	8532                	mv	a0,a2
 2ee:	5de000ef          	jal	8cc <malloc>
 2f2:	8baa                	mv	s7,a0
  if (temp == 0) {
 2f4:	4d81                	li	s11,0
  for (uint i = 1; i < nmemb; i++) {
 2f6:	4d05                	li	s10,1
    memmove(temp, arr + i * size, size);
 2f8:	000a0c1b          	sext.w	s8,s4
  if (temp == 0) {
 2fc:	c511                	beqz	a0,308 <simplesort+0x52>
 2fe:	f4a6                	sd	s1,104(sp)
 300:	f0ca                	sd	s2,96(sp)
 302:	ecce                	sd	s3,88(sp)
 304:	e0da                	sd	s6,64(sp)
 306:	a82d                	j	340 <simplesort+0x8a>
    printf("simplesort: malloc failed, cannot sort\n");
 308:	00000517          	auipc	a0,0x0
 30c:	6c850513          	addi	a0,a0,1736 # 9d0 <malloc+0x104>
 310:	508000ef          	jal	818 <printf>
    return;
 314:	6a46                	ld	s4,80(sp)
 316:	6aa6                	ld	s5,72(sp)
 318:	7be2                	ld	s7,56(sp)
 31a:	7c42                	ld	s8,48(sp)
 31c:	7ca2                	ld	s9,40(sp)
 31e:	7d02                	ld	s10,32(sp)
 320:	6de2                	ld	s11,24(sp)
 322:	bf6d                	j	2dc <simplesort+0x26>
    memmove(arr + j * size, temp, size);
 324:	036a053b          	mulw	a0,s4,s6
 328:	1502                	slli	a0,a0,0x20
 32a:	9101                	srli	a0,a0,0x20
 32c:	8662                	mv	a2,s8
 32e:	85de                	mv	a1,s7
 330:	9556                	add	a0,a0,s5
 332:	edfff0ef          	jal	210 <memmove>
  for (uint i = 1; i < nmemb; i++) {
 336:	2d05                	addiw	s10,s10,1
 338:	f8843783          	ld	a5,-120(s0)
 33c:	05a78b63          	beq	a5,s10,392 <simplesort+0xdc>
    memmove(temp, arr + i * size, size);
 340:	000d899b          	sext.w	s3,s11
 344:	01ba05bb          	addw	a1,s4,s11
 348:	00058d9b          	sext.w	s11,a1
 34c:	1582                	slli	a1,a1,0x20
 34e:	9181                	srli	a1,a1,0x20
 350:	8662                	mv	a2,s8
 352:	95d6                	add	a1,a1,s5
 354:	855e                	mv	a0,s7
 356:	ebbff0ef          	jal	210 <memmove>
    uint j = i;
 35a:	896a                	mv	s2,s10
 35c:	00090b1b          	sext.w	s6,s2
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 360:	397d                	addiw	s2,s2,-1
 362:	02099493          	slli	s1,s3,0x20
 366:	9081                	srli	s1,s1,0x20
 368:	94d6                	add	s1,s1,s5
 36a:	85de                	mv	a1,s7
 36c:	8526                	mv	a0,s1
 36e:	9c82                	jalr	s9
 370:	faa05ae3          	blez	a0,324 <simplesort+0x6e>
      memmove(arr + j * size, arr + (j - 1) * size, size); // Shift element
 374:	0149853b          	addw	a0,s3,s4
 378:	1502                	slli	a0,a0,0x20
 37a:	9101                	srli	a0,a0,0x20
 37c:	8662                	mv	a2,s8
 37e:	85a6                	mv	a1,s1
 380:	9556                	add	a0,a0,s5
 382:	e8fff0ef          	jal	210 <memmove>
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 386:	414989bb          	subw	s3,s3,s4
 38a:	fc0919e3          	bnez	s2,35c <simplesort+0xa6>
 38e:	8b4a                	mv	s6,s2
 390:	bf51                	j	324 <simplesort+0x6e>
  free(temp); // Free temporary space
 392:	855e                	mv	a0,s7
 394:	4b6000ef          	jal	84a <free>
 398:	74a6                	ld	s1,104(sp)
 39a:	7906                	ld	s2,96(sp)
 39c:	69e6                	ld	s3,88(sp)
 39e:	6a46                	ld	s4,80(sp)
 3a0:	6aa6                	ld	s5,72(sp)
 3a2:	6b06                	ld	s6,64(sp)
 3a4:	7be2                	ld	s7,56(sp)
 3a6:	7c42                	ld	s8,48(sp)
 3a8:	7ca2                	ld	s9,40(sp)
 3aa:	7d02                	ld	s10,32(sp)
 3ac:	6de2                	ld	s11,24(sp)
 3ae:	b73d                	j	2dc <simplesort+0x26>

00000000000003b0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3b0:	4885                	li	a7,1
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3b8:	4889                	li	a7,2
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3c0:	488d                	li	a7,3
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3c8:	4891                	li	a7,4
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <read>:
.global read
read:
 li a7, SYS_read
 3d0:	4895                	li	a7,5
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <write>:
.global write
write:
 li a7, SYS_write
 3d8:	48c1                	li	a7,16
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <close>:
.global close
close:
 li a7, SYS_close
 3e0:	48d5                	li	a7,21
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3e8:	4899                	li	a7,6
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3f0:	489d                	li	a7,7
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <open>:
.global open
open:
 li a7, SYS_open
 3f8:	48bd                	li	a7,15
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 400:	48c5                	li	a7,17
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 408:	48c9                	li	a7,18
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 410:	48a1                	li	a7,8
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <link>:
.global link
link:
 li a7, SYS_link
 418:	48cd                	li	a7,19
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 420:	48d1                	li	a7,20
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 428:	48a5                	li	a7,9
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <dup>:
.global dup
dup:
 li a7, SYS_dup
 430:	48a9                	li	a7,10
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 438:	48ad                	li	a7,11
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 440:	48b1                	li	a7,12
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 448:	48b5                	li	a7,13
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 450:	48b9                	li	a7,14
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 458:	48dd                	li	a7,23
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <statistics>:
.global statistics
statistics:
 li a7, SYS_statistics
 460:	48e1                	li	a7,24
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <reset_stats>:
.global reset_stats
reset_stats:
 li a7, SYS_reset_stats
 468:	48e5                	li	a7,25
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <resetlockstats>:
.global resetlockstats
resetlockstats:
 li a7, SYS_resetlockstats
 470:	48e9                	li	a7,26
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <getlockstats>:
.global getlockstats
getlockstats:
 li a7, SYS_getlockstats
 478:	48ed                	li	a7,27
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <trace>:
.global trace
trace:
 li a7, SYS_trace
 480:	48d9                	li	a7,22
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 488:	48f1                	li	a7,28
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <ugetpid>:
.global ugetpid
ugetpid:
 li a7, SYS_ugetpid
 490:	48f5                	li	a7,29
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 498:	48f9                	li	a7,30
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4a0:	1101                	addi	sp,sp,-32
 4a2:	ec06                	sd	ra,24(sp)
 4a4:	e822                	sd	s0,16(sp)
 4a6:	1000                	addi	s0,sp,32
 4a8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ac:	4605                	li	a2,1
 4ae:	fef40593          	addi	a1,s0,-17
 4b2:	f27ff0ef          	jal	3d8 <write>
}
 4b6:	60e2                	ld	ra,24(sp)
 4b8:	6442                	ld	s0,16(sp)
 4ba:	6105                	addi	sp,sp,32
 4bc:	8082                	ret

00000000000004be <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4be:	7139                	addi	sp,sp,-64
 4c0:	fc06                	sd	ra,56(sp)
 4c2:	f822                	sd	s0,48(sp)
 4c4:	f426                	sd	s1,40(sp)
 4c6:	0080                	addi	s0,sp,64
 4c8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4ca:	c299                	beqz	a3,4d0 <printint+0x12>
 4cc:	0805c963          	bltz	a1,55e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4d0:	2581                	sext.w	a1,a1
  neg = 0;
 4d2:	4881                	li	a7,0
 4d4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4d8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4da:	2601                	sext.w	a2,a2
 4dc:	00000517          	auipc	a0,0x0
 4e0:	52450513          	addi	a0,a0,1316 # a00 <digits>
 4e4:	883a                	mv	a6,a4
 4e6:	2705                	addiw	a4,a4,1
 4e8:	02c5f7bb          	remuw	a5,a1,a2
 4ec:	1782                	slli	a5,a5,0x20
 4ee:	9381                	srli	a5,a5,0x20
 4f0:	97aa                	add	a5,a5,a0
 4f2:	0007c783          	lbu	a5,0(a5)
 4f6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4fa:	0005879b          	sext.w	a5,a1
 4fe:	02c5d5bb          	divuw	a1,a1,a2
 502:	0685                	addi	a3,a3,1
 504:	fec7f0e3          	bgeu	a5,a2,4e4 <printint+0x26>
  if(neg)
 508:	00088c63          	beqz	a7,520 <printint+0x62>
    buf[i++] = '-';
 50c:	fd070793          	addi	a5,a4,-48
 510:	00878733          	add	a4,a5,s0
 514:	02d00793          	li	a5,45
 518:	fef70823          	sb	a5,-16(a4)
 51c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 520:	02e05a63          	blez	a4,554 <printint+0x96>
 524:	f04a                	sd	s2,32(sp)
 526:	ec4e                	sd	s3,24(sp)
 528:	fc040793          	addi	a5,s0,-64
 52c:	00e78933          	add	s2,a5,a4
 530:	fff78993          	addi	s3,a5,-1
 534:	99ba                	add	s3,s3,a4
 536:	377d                	addiw	a4,a4,-1
 538:	1702                	slli	a4,a4,0x20
 53a:	9301                	srli	a4,a4,0x20
 53c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 540:	fff94583          	lbu	a1,-1(s2)
 544:	8526                	mv	a0,s1
 546:	f5bff0ef          	jal	4a0 <putc>
  while(--i >= 0)
 54a:	197d                	addi	s2,s2,-1
 54c:	ff391ae3          	bne	s2,s3,540 <printint+0x82>
 550:	7902                	ld	s2,32(sp)
 552:	69e2                	ld	s3,24(sp)
}
 554:	70e2                	ld	ra,56(sp)
 556:	7442                	ld	s0,48(sp)
 558:	74a2                	ld	s1,40(sp)
 55a:	6121                	addi	sp,sp,64
 55c:	8082                	ret
    x = -xx;
 55e:	40b005bb          	negw	a1,a1
    neg = 1;
 562:	4885                	li	a7,1
    x = -xx;
 564:	bf85                	j	4d4 <printint+0x16>

0000000000000566 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 566:	711d                	addi	sp,sp,-96
 568:	ec86                	sd	ra,88(sp)
 56a:	e8a2                	sd	s0,80(sp)
 56c:	e0ca                	sd	s2,64(sp)
 56e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 570:	0005c903          	lbu	s2,0(a1)
 574:	26090863          	beqz	s2,7e4 <vprintf+0x27e>
 578:	e4a6                	sd	s1,72(sp)
 57a:	fc4e                	sd	s3,56(sp)
 57c:	f852                	sd	s4,48(sp)
 57e:	f456                	sd	s5,40(sp)
 580:	f05a                	sd	s6,32(sp)
 582:	ec5e                	sd	s7,24(sp)
 584:	e862                	sd	s8,16(sp)
 586:	e466                	sd	s9,8(sp)
 588:	8b2a                	mv	s6,a0
 58a:	8a2e                	mv	s4,a1
 58c:	8bb2                	mv	s7,a2
  state = 0;
 58e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 590:	4481                	li	s1,0
 592:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 594:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 598:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 59c:	06c00c93          	li	s9,108
 5a0:	a005                	j	5c0 <vprintf+0x5a>
        putc(fd, c0);
 5a2:	85ca                	mv	a1,s2
 5a4:	855a                	mv	a0,s6
 5a6:	efbff0ef          	jal	4a0 <putc>
 5aa:	a019                	j	5b0 <vprintf+0x4a>
    } else if(state == '%'){
 5ac:	03598263          	beq	s3,s5,5d0 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5b0:	2485                	addiw	s1,s1,1
 5b2:	8726                	mv	a4,s1
 5b4:	009a07b3          	add	a5,s4,s1
 5b8:	0007c903          	lbu	s2,0(a5)
 5bc:	20090c63          	beqz	s2,7d4 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 5c0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5c4:	fe0994e3          	bnez	s3,5ac <vprintf+0x46>
      if(c0 == '%'){
 5c8:	fd579de3          	bne	a5,s5,5a2 <vprintf+0x3c>
        state = '%';
 5cc:	89be                	mv	s3,a5
 5ce:	b7cd                	j	5b0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5d0:	00ea06b3          	add	a3,s4,a4
 5d4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5d8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5da:	c681                	beqz	a3,5e2 <vprintf+0x7c>
 5dc:	9752                	add	a4,a4,s4
 5de:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5e2:	03878f63          	beq	a5,s8,620 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 5e6:	05978963          	beq	a5,s9,638 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5ea:	07500713          	li	a4,117
 5ee:	0ee78363          	beq	a5,a4,6d4 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5f2:	07800713          	li	a4,120
 5f6:	12e78563          	beq	a5,a4,720 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5fa:	07000713          	li	a4,112
 5fe:	14e78a63          	beq	a5,a4,752 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 602:	07300713          	li	a4,115
 606:	18e78a63          	beq	a5,a4,79a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 60a:	02500713          	li	a4,37
 60e:	04e79563          	bne	a5,a4,658 <vprintf+0xf2>
        putc(fd, '%');
 612:	02500593          	li	a1,37
 616:	855a                	mv	a0,s6
 618:	e89ff0ef          	jal	4a0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 61c:	4981                	li	s3,0
 61e:	bf49                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 620:	008b8913          	addi	s2,s7,8
 624:	4685                	li	a3,1
 626:	4629                	li	a2,10
 628:	000ba583          	lw	a1,0(s7)
 62c:	855a                	mv	a0,s6
 62e:	e91ff0ef          	jal	4be <printint>
 632:	8bca                	mv	s7,s2
      state = 0;
 634:	4981                	li	s3,0
 636:	bfad                	j	5b0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 638:	06400793          	li	a5,100
 63c:	02f68963          	beq	a3,a5,66e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 640:	06c00793          	li	a5,108
 644:	04f68263          	beq	a3,a5,688 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 648:	07500793          	li	a5,117
 64c:	0af68063          	beq	a3,a5,6ec <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 650:	07800793          	li	a5,120
 654:	0ef68263          	beq	a3,a5,738 <vprintf+0x1d2>
        putc(fd, '%');
 658:	02500593          	li	a1,37
 65c:	855a                	mv	a0,s6
 65e:	e43ff0ef          	jal	4a0 <putc>
        putc(fd, c0);
 662:	85ca                	mv	a1,s2
 664:	855a                	mv	a0,s6
 666:	e3bff0ef          	jal	4a0 <putc>
      state = 0;
 66a:	4981                	li	s3,0
 66c:	b791                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 66e:	008b8913          	addi	s2,s7,8
 672:	4685                	li	a3,1
 674:	4629                	li	a2,10
 676:	000ba583          	lw	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	e43ff0ef          	jal	4be <printint>
        i += 1;
 680:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 682:	8bca                	mv	s7,s2
      state = 0;
 684:	4981                	li	s3,0
        i += 1;
 686:	b72d                	j	5b0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 688:	06400793          	li	a5,100
 68c:	02f60763          	beq	a2,a5,6ba <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 690:	07500793          	li	a5,117
 694:	06f60963          	beq	a2,a5,706 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 698:	07800793          	li	a5,120
 69c:	faf61ee3          	bne	a2,a5,658 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a0:	008b8913          	addi	s2,s7,8
 6a4:	4681                	li	a3,0
 6a6:	4641                	li	a2,16
 6a8:	000ba583          	lw	a1,0(s7)
 6ac:	855a                	mv	a0,s6
 6ae:	e11ff0ef          	jal	4be <printint>
        i += 2;
 6b2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b4:	8bca                	mv	s7,s2
      state = 0;
 6b6:	4981                	li	s3,0
        i += 2;
 6b8:	bde5                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ba:	008b8913          	addi	s2,s7,8
 6be:	4685                	li	a3,1
 6c0:	4629                	li	a2,10
 6c2:	000ba583          	lw	a1,0(s7)
 6c6:	855a                	mv	a0,s6
 6c8:	df7ff0ef          	jal	4be <printint>
        i += 2;
 6cc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ce:	8bca                	mv	s7,s2
      state = 0;
 6d0:	4981                	li	s3,0
        i += 2;
 6d2:	bdf9                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 6d4:	008b8913          	addi	s2,s7,8
 6d8:	4681                	li	a3,0
 6da:	4629                	li	a2,10
 6dc:	000ba583          	lw	a1,0(s7)
 6e0:	855a                	mv	a0,s6
 6e2:	dddff0ef          	jal	4be <printint>
 6e6:	8bca                	mv	s7,s2
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	b5d9                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ec:	008b8913          	addi	s2,s7,8
 6f0:	4681                	li	a3,0
 6f2:	4629                	li	a2,10
 6f4:	000ba583          	lw	a1,0(s7)
 6f8:	855a                	mv	a0,s6
 6fa:	dc5ff0ef          	jal	4be <printint>
        i += 1;
 6fe:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 700:	8bca                	mv	s7,s2
      state = 0;
 702:	4981                	li	s3,0
        i += 1;
 704:	b575                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 706:	008b8913          	addi	s2,s7,8
 70a:	4681                	li	a3,0
 70c:	4629                	li	a2,10
 70e:	000ba583          	lw	a1,0(s7)
 712:	855a                	mv	a0,s6
 714:	dabff0ef          	jal	4be <printint>
        i += 2;
 718:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 71a:	8bca                	mv	s7,s2
      state = 0;
 71c:	4981                	li	s3,0
        i += 2;
 71e:	bd49                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 720:	008b8913          	addi	s2,s7,8
 724:	4681                	li	a3,0
 726:	4641                	li	a2,16
 728:	000ba583          	lw	a1,0(s7)
 72c:	855a                	mv	a0,s6
 72e:	d91ff0ef          	jal	4be <printint>
 732:	8bca                	mv	s7,s2
      state = 0;
 734:	4981                	li	s3,0
 736:	bdad                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 738:	008b8913          	addi	s2,s7,8
 73c:	4681                	li	a3,0
 73e:	4641                	li	a2,16
 740:	000ba583          	lw	a1,0(s7)
 744:	855a                	mv	a0,s6
 746:	d79ff0ef          	jal	4be <printint>
        i += 1;
 74a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 74c:	8bca                	mv	s7,s2
      state = 0;
 74e:	4981                	li	s3,0
        i += 1;
 750:	b585                	j	5b0 <vprintf+0x4a>
 752:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 754:	008b8d13          	addi	s10,s7,8
 758:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 75c:	03000593          	li	a1,48
 760:	855a                	mv	a0,s6
 762:	d3fff0ef          	jal	4a0 <putc>
  putc(fd, 'x');
 766:	07800593          	li	a1,120
 76a:	855a                	mv	a0,s6
 76c:	d35ff0ef          	jal	4a0 <putc>
 770:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 772:	00000b97          	auipc	s7,0x0
 776:	28eb8b93          	addi	s7,s7,654 # a00 <digits>
 77a:	03c9d793          	srli	a5,s3,0x3c
 77e:	97de                	add	a5,a5,s7
 780:	0007c583          	lbu	a1,0(a5)
 784:	855a                	mv	a0,s6
 786:	d1bff0ef          	jal	4a0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 78a:	0992                	slli	s3,s3,0x4
 78c:	397d                	addiw	s2,s2,-1
 78e:	fe0916e3          	bnez	s2,77a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 792:	8bea                	mv	s7,s10
      state = 0;
 794:	4981                	li	s3,0
 796:	6d02                	ld	s10,0(sp)
 798:	bd21                	j	5b0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 79a:	008b8993          	addi	s3,s7,8
 79e:	000bb903          	ld	s2,0(s7)
 7a2:	00090f63          	beqz	s2,7c0 <vprintf+0x25a>
        for(; *s; s++)
 7a6:	00094583          	lbu	a1,0(s2)
 7aa:	c195                	beqz	a1,7ce <vprintf+0x268>
          putc(fd, *s);
 7ac:	855a                	mv	a0,s6
 7ae:	cf3ff0ef          	jal	4a0 <putc>
        for(; *s; s++)
 7b2:	0905                	addi	s2,s2,1
 7b4:	00094583          	lbu	a1,0(s2)
 7b8:	f9f5                	bnez	a1,7ac <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7ba:	8bce                	mv	s7,s3
      state = 0;
 7bc:	4981                	li	s3,0
 7be:	bbcd                	j	5b0 <vprintf+0x4a>
          s = "(null)";
 7c0:	00000917          	auipc	s2,0x0
 7c4:	23890913          	addi	s2,s2,568 # 9f8 <malloc+0x12c>
        for(; *s; s++)
 7c8:	02800593          	li	a1,40
 7cc:	b7c5                	j	7ac <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7ce:	8bce                	mv	s7,s3
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	bbf9                	j	5b0 <vprintf+0x4a>
 7d4:	64a6                	ld	s1,72(sp)
 7d6:	79e2                	ld	s3,56(sp)
 7d8:	7a42                	ld	s4,48(sp)
 7da:	7aa2                	ld	s5,40(sp)
 7dc:	7b02                	ld	s6,32(sp)
 7de:	6be2                	ld	s7,24(sp)
 7e0:	6c42                	ld	s8,16(sp)
 7e2:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7e4:	60e6                	ld	ra,88(sp)
 7e6:	6446                	ld	s0,80(sp)
 7e8:	6906                	ld	s2,64(sp)
 7ea:	6125                	addi	sp,sp,96
 7ec:	8082                	ret

00000000000007ee <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ee:	715d                	addi	sp,sp,-80
 7f0:	ec06                	sd	ra,24(sp)
 7f2:	e822                	sd	s0,16(sp)
 7f4:	1000                	addi	s0,sp,32
 7f6:	e010                	sd	a2,0(s0)
 7f8:	e414                	sd	a3,8(s0)
 7fa:	e818                	sd	a4,16(s0)
 7fc:	ec1c                	sd	a5,24(s0)
 7fe:	03043023          	sd	a6,32(s0)
 802:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 806:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 80a:	8622                	mv	a2,s0
 80c:	d5bff0ef          	jal	566 <vprintf>
}
 810:	60e2                	ld	ra,24(sp)
 812:	6442                	ld	s0,16(sp)
 814:	6161                	addi	sp,sp,80
 816:	8082                	ret

0000000000000818 <printf>:

void
printf(const char *fmt, ...)
{
 818:	711d                	addi	sp,sp,-96
 81a:	ec06                	sd	ra,24(sp)
 81c:	e822                	sd	s0,16(sp)
 81e:	1000                	addi	s0,sp,32
 820:	e40c                	sd	a1,8(s0)
 822:	e810                	sd	a2,16(s0)
 824:	ec14                	sd	a3,24(s0)
 826:	f018                	sd	a4,32(s0)
 828:	f41c                	sd	a5,40(s0)
 82a:	03043823          	sd	a6,48(s0)
 82e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 832:	00840613          	addi	a2,s0,8
 836:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 83a:	85aa                	mv	a1,a0
 83c:	4505                	li	a0,1
 83e:	d29ff0ef          	jal	566 <vprintf>
}
 842:	60e2                	ld	ra,24(sp)
 844:	6442                	ld	s0,16(sp)
 846:	6125                	addi	sp,sp,96
 848:	8082                	ret

000000000000084a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 84a:	1141                	addi	sp,sp,-16
 84c:	e422                	sd	s0,8(sp)
 84e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 850:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 854:	00000797          	auipc	a5,0x0
 858:	7ac7b783          	ld	a5,1964(a5) # 1000 <freep>
 85c:	a02d                	j	886 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 85e:	4618                	lw	a4,8(a2)
 860:	9f2d                	addw	a4,a4,a1
 862:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 866:	6398                	ld	a4,0(a5)
 868:	6310                	ld	a2,0(a4)
 86a:	a83d                	j	8a8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 86c:	ff852703          	lw	a4,-8(a0)
 870:	9f31                	addw	a4,a4,a2
 872:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 874:	ff053683          	ld	a3,-16(a0)
 878:	a091                	j	8bc <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 87a:	6398                	ld	a4,0(a5)
 87c:	00e7e463          	bltu	a5,a4,884 <free+0x3a>
 880:	00e6ea63          	bltu	a3,a4,894 <free+0x4a>
{
 884:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 886:	fed7fae3          	bgeu	a5,a3,87a <free+0x30>
 88a:	6398                	ld	a4,0(a5)
 88c:	00e6e463          	bltu	a3,a4,894 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 890:	fee7eae3          	bltu	a5,a4,884 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 894:	ff852583          	lw	a1,-8(a0)
 898:	6390                	ld	a2,0(a5)
 89a:	02059813          	slli	a6,a1,0x20
 89e:	01c85713          	srli	a4,a6,0x1c
 8a2:	9736                	add	a4,a4,a3
 8a4:	fae60de3          	beq	a2,a4,85e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8a8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8ac:	4790                	lw	a2,8(a5)
 8ae:	02061593          	slli	a1,a2,0x20
 8b2:	01c5d713          	srli	a4,a1,0x1c
 8b6:	973e                	add	a4,a4,a5
 8b8:	fae68ae3          	beq	a3,a4,86c <free+0x22>
    p->s.ptr = bp->s.ptr;
 8bc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8be:	00000717          	auipc	a4,0x0
 8c2:	74f73123          	sd	a5,1858(a4) # 1000 <freep>
}
 8c6:	6422                	ld	s0,8(sp)
 8c8:	0141                	addi	sp,sp,16
 8ca:	8082                	ret

00000000000008cc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8cc:	7139                	addi	sp,sp,-64
 8ce:	fc06                	sd	ra,56(sp)
 8d0:	f822                	sd	s0,48(sp)
 8d2:	f426                	sd	s1,40(sp)
 8d4:	ec4e                	sd	s3,24(sp)
 8d6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d8:	02051493          	slli	s1,a0,0x20
 8dc:	9081                	srli	s1,s1,0x20
 8de:	04bd                	addi	s1,s1,15
 8e0:	8091                	srli	s1,s1,0x4
 8e2:	0014899b          	addiw	s3,s1,1
 8e6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8e8:	00000517          	auipc	a0,0x0
 8ec:	71853503          	ld	a0,1816(a0) # 1000 <freep>
 8f0:	c915                	beqz	a0,924 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f4:	4798                	lw	a4,8(a5)
 8f6:	08977a63          	bgeu	a4,s1,98a <malloc+0xbe>
 8fa:	f04a                	sd	s2,32(sp)
 8fc:	e852                	sd	s4,16(sp)
 8fe:	e456                	sd	s5,8(sp)
 900:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 902:	8a4e                	mv	s4,s3
 904:	0009871b          	sext.w	a4,s3
 908:	6685                	lui	a3,0x1
 90a:	00d77363          	bgeu	a4,a3,910 <malloc+0x44>
 90e:	6a05                	lui	s4,0x1
 910:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 914:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 918:	00000917          	auipc	s2,0x0
 91c:	6e890913          	addi	s2,s2,1768 # 1000 <freep>
  if(p == (char*)-1)
 920:	5afd                	li	s5,-1
 922:	a081                	j	962 <malloc+0x96>
 924:	f04a                	sd	s2,32(sp)
 926:	e852                	sd	s4,16(sp)
 928:	e456                	sd	s5,8(sp)
 92a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 92c:	00000797          	auipc	a5,0x0
 930:	6e478793          	addi	a5,a5,1764 # 1010 <base>
 934:	00000717          	auipc	a4,0x0
 938:	6cf73623          	sd	a5,1740(a4) # 1000 <freep>
 93c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 93e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 942:	b7c1                	j	902 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 944:	6398                	ld	a4,0(a5)
 946:	e118                	sd	a4,0(a0)
 948:	a8a9                	j	9a2 <malloc+0xd6>
  hp->s.size = nu;
 94a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 94e:	0541                	addi	a0,a0,16
 950:	efbff0ef          	jal	84a <free>
  return freep;
 954:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 958:	c12d                	beqz	a0,9ba <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 95c:	4798                	lw	a4,8(a5)
 95e:	02977263          	bgeu	a4,s1,982 <malloc+0xb6>
    if(p == freep)
 962:	00093703          	ld	a4,0(s2)
 966:	853e                	mv	a0,a5
 968:	fef719e3          	bne	a4,a5,95a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 96c:	8552                	mv	a0,s4
 96e:	ad3ff0ef          	jal	440 <sbrk>
  if(p == (char*)-1)
 972:	fd551ce3          	bne	a0,s5,94a <malloc+0x7e>
        return 0;
 976:	4501                	li	a0,0
 978:	7902                	ld	s2,32(sp)
 97a:	6a42                	ld	s4,16(sp)
 97c:	6aa2                	ld	s5,8(sp)
 97e:	6b02                	ld	s6,0(sp)
 980:	a03d                	j	9ae <malloc+0xe2>
 982:	7902                	ld	s2,32(sp)
 984:	6a42                	ld	s4,16(sp)
 986:	6aa2                	ld	s5,8(sp)
 988:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 98a:	fae48de3          	beq	s1,a4,944 <malloc+0x78>
        p->s.size -= nunits;
 98e:	4137073b          	subw	a4,a4,s3
 992:	c798                	sw	a4,8(a5)
        p += p->s.size;
 994:	02071693          	slli	a3,a4,0x20
 998:	01c6d713          	srli	a4,a3,0x1c
 99c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 99e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9a2:	00000717          	auipc	a4,0x0
 9a6:	64a73f23          	sd	a0,1630(a4) # 1000 <freep>
      return (void*)(p + 1);
 9aa:	01078513          	addi	a0,a5,16
  }
}
 9ae:	70e2                	ld	ra,56(sp)
 9b0:	7442                	ld	s0,48(sp)
 9b2:	74a2                	ld	s1,40(sp)
 9b4:	69e2                	ld	s3,24(sp)
 9b6:	6121                	addi	sp,sp,64
 9b8:	8082                	ret
 9ba:	7902                	ld	s2,32(sp)
 9bc:	6a42                	ld	s4,16(sp)
 9be:	6aa2                	ld	s5,8(sp)
 9c0:	6b02                	ld	s6,0(sp)
 9c2:	b7f5                	j	9ae <malloc+0xe2>
