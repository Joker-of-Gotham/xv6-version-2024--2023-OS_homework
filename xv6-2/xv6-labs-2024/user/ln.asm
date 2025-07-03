
user/_ln：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  if(argc != 3){
   8:	478d                	li	a5,3
   a:	00f50d63          	beq	a0,a5,24 <main+0x24>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	9f058593          	addi	a1,a1,-1552 # a00 <malloc+0x104>
  18:	4509                	li	a0,2
  1a:	005000ef          	jal	81e <fprintf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	3c8000ef          	jal	3e8 <exit>
  24:	e426                	sd	s1,8(sp)
  26:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  28:	698c                	ld	a1,16(a1)
  2a:	6488                	ld	a0,8(s1)
  2c:	41c000ef          	jal	448 <link>
  30:	00054563          	bltz	a0,3a <main+0x3a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  34:	4501                	li	a0,0
  36:	3b2000ef          	jal	3e8 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  3a:	6894                	ld	a3,16(s1)
  3c:	6490                	ld	a2,8(s1)
  3e:	00001597          	auipc	a1,0x1
  42:	9da58593          	addi	a1,a1,-1574 # a18 <malloc+0x11c>
  46:	4509                	li	a0,2
  48:	7d6000ef          	jal	81e <fprintf>
  4c:	b7e5                	j	34 <main+0x34>

000000000000004e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  extern int main();
  main();
  56:	fabff0ef          	jal	0 <main>
  exit(0);
  5a:	4501                	li	a0,0
  5c:	38c000ef          	jal	3e8 <exit>

0000000000000060 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  60:	1141                	addi	sp,sp,-16
  62:	e422                	sd	s0,8(sp)
  64:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	87aa                	mv	a5,a0
  68:	0585                	addi	a1,a1,1
  6a:	0785                	addi	a5,a5,1
  6c:	fff5c703          	lbu	a4,-1(a1)
  70:	fee78fa3          	sb	a4,-1(a5)
  74:	fb75                	bnez	a4,68 <strcpy+0x8>
    ;
  return os;
}
  76:	6422                	ld	s0,8(sp)
  78:	0141                	addi	sp,sp,16
  7a:	8082                	ret

000000000000007c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7c:	1141                	addi	sp,sp,-16
  7e:	e422                	sd	s0,8(sp)
  80:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  82:	00054783          	lbu	a5,0(a0)
  86:	cb91                	beqz	a5,9a <strcmp+0x1e>
  88:	0005c703          	lbu	a4,0(a1)
  8c:	00f71763          	bne	a4,a5,9a <strcmp+0x1e>
    p++, q++;
  90:	0505                	addi	a0,a0,1
  92:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  94:	00054783          	lbu	a5,0(a0)
  98:	fbe5                	bnez	a5,88 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  9a:	0005c503          	lbu	a0,0(a1)
}
  9e:	40a7853b          	subw	a0,a5,a0
  a2:	6422                	ld	s0,8(sp)
  a4:	0141                	addi	sp,sp,16
  a6:	8082                	ret

00000000000000a8 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  a8:	1141                	addi	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q) {
  ae:	ce11                	beqz	a2,ca <strncmp+0x22>
  b0:	00054783          	lbu	a5,0(a0)
  b4:	cf89                	beqz	a5,ce <strncmp+0x26>
  b6:	0005c703          	lbu	a4,0(a1)
  ba:	00f71a63          	bne	a4,a5,ce <strncmp+0x26>
    n--;
  be:	367d                	addiw	a2,a2,-1
    p++;
  c0:	0505                	addi	a0,a0,1
    q++;
  c2:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q) {
  c4:	f675                	bnez	a2,b0 <strncmp+0x8>
  }
  if(n == 0)
    return 0;
  c6:	4501                	li	a0,0
  c8:	a801                	j	d8 <strncmp+0x30>
  ca:	4501                	li	a0,0
  cc:	a031                	j	d8 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
  ce:	00054503          	lbu	a0,0(a0)
  d2:	0005c783          	lbu	a5,0(a1)
  d6:	9d1d                	subw	a0,a0,a5
}
  d8:	6422                	ld	s0,8(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret

00000000000000de <strlen>:

uint
strlen(const char *s)
{
  de:	1141                	addi	sp,sp,-16
  e0:	e422                	sd	s0,8(sp)
  e2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e4:	00054783          	lbu	a5,0(a0)
  e8:	cf91                	beqz	a5,104 <strlen+0x26>
  ea:	0505                	addi	a0,a0,1
  ec:	87aa                	mv	a5,a0
  ee:	86be                	mv	a3,a5
  f0:	0785                	addi	a5,a5,1
  f2:	fff7c703          	lbu	a4,-1(a5)
  f6:	ff65                	bnez	a4,ee <strlen+0x10>
  f8:	40a6853b          	subw	a0,a3,a0
  fc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  fe:	6422                	ld	s0,8(sp)
 100:	0141                	addi	sp,sp,16
 102:	8082                	ret
  for(n = 0; s[n]; n++)
 104:	4501                	li	a0,0
 106:	bfe5                	j	fe <strlen+0x20>

0000000000000108 <memset>:

void*
memset(void *dst, int c, uint n)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e422                	sd	s0,8(sp)
 10c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 10e:	ca19                	beqz	a2,124 <memset+0x1c>
 110:	87aa                	mv	a5,a0
 112:	1602                	slli	a2,a2,0x20
 114:	9201                	srli	a2,a2,0x20
 116:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 11a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 11e:	0785                	addi	a5,a5,1
 120:	fee79de3          	bne	a5,a4,11a <memset+0x12>
  }
  return dst;
}
 124:	6422                	ld	s0,8(sp)
 126:	0141                	addi	sp,sp,16
 128:	8082                	ret

000000000000012a <strchr>:

char*
strchr(const char *s, char c)
{
 12a:	1141                	addi	sp,sp,-16
 12c:	e422                	sd	s0,8(sp)
 12e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 130:	00054783          	lbu	a5,0(a0)
 134:	cb99                	beqz	a5,14a <strchr+0x20>
    if(*s == c)
 136:	00f58763          	beq	a1,a5,144 <strchr+0x1a>
  for(; *s; s++)
 13a:	0505                	addi	a0,a0,1
 13c:	00054783          	lbu	a5,0(a0)
 140:	fbfd                	bnez	a5,136 <strchr+0xc>
      return (char*)s;
  return 0;
 142:	4501                	li	a0,0
}
 144:	6422                	ld	s0,8(sp)
 146:	0141                	addi	sp,sp,16
 148:	8082                	ret
  return 0;
 14a:	4501                	li	a0,0
 14c:	bfe5                	j	144 <strchr+0x1a>

000000000000014e <gets>:

char*
gets(char *buf, int max)
{
 14e:	711d                	addi	sp,sp,-96
 150:	ec86                	sd	ra,88(sp)
 152:	e8a2                	sd	s0,80(sp)
 154:	e4a6                	sd	s1,72(sp)
 156:	e0ca                	sd	s2,64(sp)
 158:	fc4e                	sd	s3,56(sp)
 15a:	f852                	sd	s4,48(sp)
 15c:	f456                	sd	s5,40(sp)
 15e:	f05a                	sd	s6,32(sp)
 160:	ec5e                	sd	s7,24(sp)
 162:	1080                	addi	s0,sp,96
 164:	8baa                	mv	s7,a0
 166:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 168:	892a                	mv	s2,a0
 16a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 16c:	4aa9                	li	s5,10
 16e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 170:	89a6                	mv	s3,s1
 172:	2485                	addiw	s1,s1,1
 174:	0344d663          	bge	s1,s4,1a0 <gets+0x52>
    cc = read(0, &c, 1);
 178:	4605                	li	a2,1
 17a:	faf40593          	addi	a1,s0,-81
 17e:	4501                	li	a0,0
 180:	280000ef          	jal	400 <read>
    if(cc < 1)
 184:	00a05e63          	blez	a0,1a0 <gets+0x52>
    buf[i++] = c;
 188:	faf44783          	lbu	a5,-81(s0)
 18c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 190:	01578763          	beq	a5,s5,19e <gets+0x50>
 194:	0905                	addi	s2,s2,1
 196:	fd679de3          	bne	a5,s6,170 <gets+0x22>
    buf[i++] = c;
 19a:	89a6                	mv	s3,s1
 19c:	a011                	j	1a0 <gets+0x52>
 19e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a0:	99de                	add	s3,s3,s7
 1a2:	00098023          	sb	zero,0(s3)
  return buf;
}
 1a6:	855e                	mv	a0,s7
 1a8:	60e6                	ld	ra,88(sp)
 1aa:	6446                	ld	s0,80(sp)
 1ac:	64a6                	ld	s1,72(sp)
 1ae:	6906                	ld	s2,64(sp)
 1b0:	79e2                	ld	s3,56(sp)
 1b2:	7a42                	ld	s4,48(sp)
 1b4:	7aa2                	ld	s5,40(sp)
 1b6:	7b02                	ld	s6,32(sp)
 1b8:	6be2                	ld	s7,24(sp)
 1ba:	6125                	addi	sp,sp,96
 1bc:	8082                	ret

00000000000001be <stat>:

int
stat(const char *n, struct stat *st)
{
 1be:	1101                	addi	sp,sp,-32
 1c0:	ec06                	sd	ra,24(sp)
 1c2:	e822                	sd	s0,16(sp)
 1c4:	e04a                	sd	s2,0(sp)
 1c6:	1000                	addi	s0,sp,32
 1c8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ca:	4581                	li	a1,0
 1cc:	25c000ef          	jal	428 <open>
  if(fd < 0)
 1d0:	02054263          	bltz	a0,1f4 <stat+0x36>
 1d4:	e426                	sd	s1,8(sp)
 1d6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1d8:	85ca                	mv	a1,s2
 1da:	266000ef          	jal	440 <fstat>
 1de:	892a                	mv	s2,a0
  close(fd);
 1e0:	8526                	mv	a0,s1
 1e2:	22e000ef          	jal	410 <close>
  return r;
 1e6:	64a2                	ld	s1,8(sp)
}
 1e8:	854a                	mv	a0,s2
 1ea:	60e2                	ld	ra,24(sp)
 1ec:	6442                	ld	s0,16(sp)
 1ee:	6902                	ld	s2,0(sp)
 1f0:	6105                	addi	sp,sp,32
 1f2:	8082                	ret
    return -1;
 1f4:	597d                	li	s2,-1
 1f6:	bfcd                	j	1e8 <stat+0x2a>

00000000000001f8 <atoi>:

int
atoi(const char *s)
{
 1f8:	1141                	addi	sp,sp,-16
 1fa:	e422                	sd	s0,8(sp)
 1fc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1fe:	00054683          	lbu	a3,0(a0)
 202:	fd06879b          	addiw	a5,a3,-48
 206:	0ff7f793          	zext.b	a5,a5
 20a:	4625                	li	a2,9
 20c:	02f66863          	bltu	a2,a5,23c <atoi+0x44>
 210:	872a                	mv	a4,a0
  n = 0;
 212:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 214:	0705                	addi	a4,a4,1
 216:	0025179b          	slliw	a5,a0,0x2
 21a:	9fa9                	addw	a5,a5,a0
 21c:	0017979b          	slliw	a5,a5,0x1
 220:	9fb5                	addw	a5,a5,a3
 222:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 226:	00074683          	lbu	a3,0(a4)
 22a:	fd06879b          	addiw	a5,a3,-48
 22e:	0ff7f793          	zext.b	a5,a5
 232:	fef671e3          	bgeu	a2,a5,214 <atoi+0x1c>
  return n;
}
 236:	6422                	ld	s0,8(sp)
 238:	0141                	addi	sp,sp,16
 23a:	8082                	ret
  n = 0;
 23c:	4501                	li	a0,0
 23e:	bfe5                	j	236 <atoi+0x3e>

0000000000000240 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 240:	1141                	addi	sp,sp,-16
 242:	e422                	sd	s0,8(sp)
 244:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 246:	02b57463          	bgeu	a0,a1,26e <memmove+0x2e>
    while(n-- > 0)
 24a:	00c05f63          	blez	a2,268 <memmove+0x28>
 24e:	1602                	slli	a2,a2,0x20
 250:	9201                	srli	a2,a2,0x20
 252:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 256:	872a                	mv	a4,a0
      *dst++ = *src++;
 258:	0585                	addi	a1,a1,1
 25a:	0705                	addi	a4,a4,1
 25c:	fff5c683          	lbu	a3,-1(a1)
 260:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 264:	fef71ae3          	bne	a4,a5,258 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 268:	6422                	ld	s0,8(sp)
 26a:	0141                	addi	sp,sp,16
 26c:	8082                	ret
    dst += n;
 26e:	00c50733          	add	a4,a0,a2
    src += n;
 272:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 274:	fec05ae3          	blez	a2,268 <memmove+0x28>
 278:	fff6079b          	addiw	a5,a2,-1
 27c:	1782                	slli	a5,a5,0x20
 27e:	9381                	srli	a5,a5,0x20
 280:	fff7c793          	not	a5,a5
 284:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 286:	15fd                	addi	a1,a1,-1
 288:	177d                	addi	a4,a4,-1
 28a:	0005c683          	lbu	a3,0(a1)
 28e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 292:	fee79ae3          	bne	a5,a4,286 <memmove+0x46>
 296:	bfc9                	j	268 <memmove+0x28>

0000000000000298 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 29e:	ca05                	beqz	a2,2ce <memcmp+0x36>
 2a0:	fff6069b          	addiw	a3,a2,-1
 2a4:	1682                	slli	a3,a3,0x20
 2a6:	9281                	srli	a3,a3,0x20
 2a8:	0685                	addi	a3,a3,1
 2aa:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ac:	00054783          	lbu	a5,0(a0)
 2b0:	0005c703          	lbu	a4,0(a1)
 2b4:	00e79863          	bne	a5,a4,2c4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2b8:	0505                	addi	a0,a0,1
    p2++;
 2ba:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2bc:	fed518e3          	bne	a0,a3,2ac <memcmp+0x14>
  }
  return 0;
 2c0:	4501                	li	a0,0
 2c2:	a019                	j	2c8 <memcmp+0x30>
      return *p1 - *p2;
 2c4:	40e7853b          	subw	a0,a5,a4
}
 2c8:	6422                	ld	s0,8(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret
  return 0;
 2ce:	4501                	li	a0,0
 2d0:	bfe5                	j	2c8 <memcmp+0x30>

00000000000002d2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e406                	sd	ra,8(sp)
 2d6:	e022                	sd	s0,0(sp)
 2d8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2da:	f67ff0ef          	jal	240 <memmove>
}
 2de:	60a2                	ld	ra,8(sp)
 2e0:	6402                	ld	s0,0(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret

00000000000002e6 <simplesort>:

void
simplesort(void *base, uint nmemb, uint size, int (*compar)(const void *, const void *))
{
 2e6:	7119                	addi	sp,sp,-128
 2e8:	fc86                	sd	ra,120(sp)
 2ea:	f8a2                	sd	s0,112(sp)
 2ec:	0100                	addi	s0,sp,128
 2ee:	f8b43423          	sd	a1,-120(s0)
  char *arr = (char *)base; // Treat array as char array for byte-level manipulation
  char *temp;               // Temporary storage for an element

  if (nmemb <= 1 || size == 0) {
 2f2:	4785                	li	a5,1
 2f4:	00b7fc63          	bgeu	a5,a1,30c <simplesort+0x26>
 2f8:	e8d2                	sd	s4,80(sp)
 2fa:	e4d6                	sd	s5,72(sp)
 2fc:	f466                	sd	s9,40(sp)
 2fe:	8aaa                	mv	s5,a0
 300:	8a32                	mv	s4,a2
 302:	8cb6                	mv	s9,a3
 304:	ea01                	bnez	a2,314 <simplesort+0x2e>
 306:	6a46                	ld	s4,80(sp)
 308:	6aa6                	ld	s5,72(sp)
 30a:	7ca2                	ld	s9,40(sp)
    // Place temp at its correct position
    memmove(arr + j * size, temp, size);
  }

  free(temp); // Free temporary space
 30c:	70e6                	ld	ra,120(sp)
 30e:	7446                	ld	s0,112(sp)
 310:	6109                	addi	sp,sp,128
 312:	8082                	ret
 314:	fc5e                	sd	s7,56(sp)
 316:	f862                	sd	s8,48(sp)
 318:	f06a                	sd	s10,32(sp)
 31a:	ec6e                	sd	s11,24(sp)
  temp = malloc(size); // Allocate temporary space for one element
 31c:	8532                	mv	a0,a2
 31e:	5de000ef          	jal	8fc <malloc>
 322:	8baa                	mv	s7,a0
  if (temp == 0) {
 324:	4d81                	li	s11,0
  for (uint i = 1; i < nmemb; i++) {
 326:	4d05                	li	s10,1
    memmove(temp, arr + i * size, size);
 328:	000a0c1b          	sext.w	s8,s4
  if (temp == 0) {
 32c:	c511                	beqz	a0,338 <simplesort+0x52>
 32e:	f4a6                	sd	s1,104(sp)
 330:	f0ca                	sd	s2,96(sp)
 332:	ecce                	sd	s3,88(sp)
 334:	e0da                	sd	s6,64(sp)
 336:	a82d                	j	370 <simplesort+0x8a>
    printf("simplesort: malloc failed, cannot sort\n");
 338:	00000517          	auipc	a0,0x0
 33c:	6f850513          	addi	a0,a0,1784 # a30 <malloc+0x134>
 340:	508000ef          	jal	848 <printf>
    return;
 344:	6a46                	ld	s4,80(sp)
 346:	6aa6                	ld	s5,72(sp)
 348:	7be2                	ld	s7,56(sp)
 34a:	7c42                	ld	s8,48(sp)
 34c:	7ca2                	ld	s9,40(sp)
 34e:	7d02                	ld	s10,32(sp)
 350:	6de2                	ld	s11,24(sp)
 352:	bf6d                	j	30c <simplesort+0x26>
    memmove(arr + j * size, temp, size);
 354:	036a053b          	mulw	a0,s4,s6
 358:	1502                	slli	a0,a0,0x20
 35a:	9101                	srli	a0,a0,0x20
 35c:	8662                	mv	a2,s8
 35e:	85de                	mv	a1,s7
 360:	9556                	add	a0,a0,s5
 362:	edfff0ef          	jal	240 <memmove>
  for (uint i = 1; i < nmemb; i++) {
 366:	2d05                	addiw	s10,s10,1
 368:	f8843783          	ld	a5,-120(s0)
 36c:	05a78b63          	beq	a5,s10,3c2 <simplesort+0xdc>
    memmove(temp, arr + i * size, size);
 370:	000d899b          	sext.w	s3,s11
 374:	01ba05bb          	addw	a1,s4,s11
 378:	00058d9b          	sext.w	s11,a1
 37c:	1582                	slli	a1,a1,0x20
 37e:	9181                	srli	a1,a1,0x20
 380:	8662                	mv	a2,s8
 382:	95d6                	add	a1,a1,s5
 384:	855e                	mv	a0,s7
 386:	ebbff0ef          	jal	240 <memmove>
    uint j = i;
 38a:	896a                	mv	s2,s10
 38c:	00090b1b          	sext.w	s6,s2
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 390:	397d                	addiw	s2,s2,-1
 392:	02099493          	slli	s1,s3,0x20
 396:	9081                	srli	s1,s1,0x20
 398:	94d6                	add	s1,s1,s5
 39a:	85de                	mv	a1,s7
 39c:	8526                	mv	a0,s1
 39e:	9c82                	jalr	s9
 3a0:	faa05ae3          	blez	a0,354 <simplesort+0x6e>
      memmove(arr + j * size, arr + (j - 1) * size, size); // Shift element
 3a4:	0149853b          	addw	a0,s3,s4
 3a8:	1502                	slli	a0,a0,0x20
 3aa:	9101                	srli	a0,a0,0x20
 3ac:	8662                	mv	a2,s8
 3ae:	85a6                	mv	a1,s1
 3b0:	9556                	add	a0,a0,s5
 3b2:	e8fff0ef          	jal	240 <memmove>
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 3b6:	414989bb          	subw	s3,s3,s4
 3ba:	fc0919e3          	bnez	s2,38c <simplesort+0xa6>
 3be:	8b4a                	mv	s6,s2
 3c0:	bf51                	j	354 <simplesort+0x6e>
  free(temp); // Free temporary space
 3c2:	855e                	mv	a0,s7
 3c4:	4b6000ef          	jal	87a <free>
 3c8:	74a6                	ld	s1,104(sp)
 3ca:	7906                	ld	s2,96(sp)
 3cc:	69e6                	ld	s3,88(sp)
 3ce:	6a46                	ld	s4,80(sp)
 3d0:	6aa6                	ld	s5,72(sp)
 3d2:	6b06                	ld	s6,64(sp)
 3d4:	7be2                	ld	s7,56(sp)
 3d6:	7c42                	ld	s8,48(sp)
 3d8:	7ca2                	ld	s9,40(sp)
 3da:	7d02                	ld	s10,32(sp)
 3dc:	6de2                	ld	s11,24(sp)
 3de:	b73d                	j	30c <simplesort+0x26>

00000000000003e0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3e0:	4885                	li	a7,1
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3e8:	4889                	li	a7,2
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3f0:	488d                	li	a7,3
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3f8:	4891                	li	a7,4
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <read>:
.global read
read:
 li a7, SYS_read
 400:	4895                	li	a7,5
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <write>:
.global write
write:
 li a7, SYS_write
 408:	48c1                	li	a7,16
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <close>:
.global close
close:
 li a7, SYS_close
 410:	48d5                	li	a7,21
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <kill>:
.global kill
kill:
 li a7, SYS_kill
 418:	4899                	li	a7,6
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <exec>:
.global exec
exec:
 li a7, SYS_exec
 420:	489d                	li	a7,7
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <open>:
.global open
open:
 li a7, SYS_open
 428:	48bd                	li	a7,15
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 430:	48c5                	li	a7,17
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 438:	48c9                	li	a7,18
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 440:	48a1                	li	a7,8
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <link>:
.global link
link:
 li a7, SYS_link
 448:	48cd                	li	a7,19
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 450:	48d1                	li	a7,20
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 458:	48a5                	li	a7,9
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <dup>:
.global dup
dup:
 li a7, SYS_dup
 460:	48a9                	li	a7,10
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 468:	48ad                	li	a7,11
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 470:	48b1                	li	a7,12
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 478:	48b5                	li	a7,13
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 480:	48b9                	li	a7,14
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 488:	48dd                	li	a7,23
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <statistics>:
.global statistics
statistics:
 li a7, SYS_statistics
 490:	48e1                	li	a7,24
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <reset_stats>:
.global reset_stats
reset_stats:
 li a7, SYS_reset_stats
 498:	48e5                	li	a7,25
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <resetlockstats>:
.global resetlockstats
resetlockstats:
 li a7, SYS_resetlockstats
 4a0:	48e9                	li	a7,26
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <getlockstats>:
.global getlockstats
getlockstats:
 li a7, SYS_getlockstats
 4a8:	48ed                	li	a7,27
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <trace>:
.global trace
trace:
 li a7, SYS_trace
 4b0:	48d9                	li	a7,22
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 4b8:	48f1                	li	a7,28
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <ugetpid>:
.global ugetpid
ugetpid:
 li a7, SYS_ugetpid
 4c0:	48f5                	li	a7,29
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 4c8:	48f9                	li	a7,30
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4d0:	1101                	addi	sp,sp,-32
 4d2:	ec06                	sd	ra,24(sp)
 4d4:	e822                	sd	s0,16(sp)
 4d6:	1000                	addi	s0,sp,32
 4d8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4dc:	4605                	li	a2,1
 4de:	fef40593          	addi	a1,s0,-17
 4e2:	f27ff0ef          	jal	408 <write>
}
 4e6:	60e2                	ld	ra,24(sp)
 4e8:	6442                	ld	s0,16(sp)
 4ea:	6105                	addi	sp,sp,32
 4ec:	8082                	ret

00000000000004ee <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ee:	7139                	addi	sp,sp,-64
 4f0:	fc06                	sd	ra,56(sp)
 4f2:	f822                	sd	s0,48(sp)
 4f4:	f426                	sd	s1,40(sp)
 4f6:	0080                	addi	s0,sp,64
 4f8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4fa:	c299                	beqz	a3,500 <printint+0x12>
 4fc:	0805c963          	bltz	a1,58e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 500:	2581                	sext.w	a1,a1
  neg = 0;
 502:	4881                	li	a7,0
 504:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 508:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 50a:	2601                	sext.w	a2,a2
 50c:	00000517          	auipc	a0,0x0
 510:	55450513          	addi	a0,a0,1364 # a60 <digits>
 514:	883a                	mv	a6,a4
 516:	2705                	addiw	a4,a4,1
 518:	02c5f7bb          	remuw	a5,a1,a2
 51c:	1782                	slli	a5,a5,0x20
 51e:	9381                	srli	a5,a5,0x20
 520:	97aa                	add	a5,a5,a0
 522:	0007c783          	lbu	a5,0(a5)
 526:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 52a:	0005879b          	sext.w	a5,a1
 52e:	02c5d5bb          	divuw	a1,a1,a2
 532:	0685                	addi	a3,a3,1
 534:	fec7f0e3          	bgeu	a5,a2,514 <printint+0x26>
  if(neg)
 538:	00088c63          	beqz	a7,550 <printint+0x62>
    buf[i++] = '-';
 53c:	fd070793          	addi	a5,a4,-48
 540:	00878733          	add	a4,a5,s0
 544:	02d00793          	li	a5,45
 548:	fef70823          	sb	a5,-16(a4)
 54c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 550:	02e05a63          	blez	a4,584 <printint+0x96>
 554:	f04a                	sd	s2,32(sp)
 556:	ec4e                	sd	s3,24(sp)
 558:	fc040793          	addi	a5,s0,-64
 55c:	00e78933          	add	s2,a5,a4
 560:	fff78993          	addi	s3,a5,-1
 564:	99ba                	add	s3,s3,a4
 566:	377d                	addiw	a4,a4,-1
 568:	1702                	slli	a4,a4,0x20
 56a:	9301                	srli	a4,a4,0x20
 56c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 570:	fff94583          	lbu	a1,-1(s2)
 574:	8526                	mv	a0,s1
 576:	f5bff0ef          	jal	4d0 <putc>
  while(--i >= 0)
 57a:	197d                	addi	s2,s2,-1
 57c:	ff391ae3          	bne	s2,s3,570 <printint+0x82>
 580:	7902                	ld	s2,32(sp)
 582:	69e2                	ld	s3,24(sp)
}
 584:	70e2                	ld	ra,56(sp)
 586:	7442                	ld	s0,48(sp)
 588:	74a2                	ld	s1,40(sp)
 58a:	6121                	addi	sp,sp,64
 58c:	8082                	ret
    x = -xx;
 58e:	40b005bb          	negw	a1,a1
    neg = 1;
 592:	4885                	li	a7,1
    x = -xx;
 594:	bf85                	j	504 <printint+0x16>

0000000000000596 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 596:	711d                	addi	sp,sp,-96
 598:	ec86                	sd	ra,88(sp)
 59a:	e8a2                	sd	s0,80(sp)
 59c:	e0ca                	sd	s2,64(sp)
 59e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5a0:	0005c903          	lbu	s2,0(a1)
 5a4:	26090863          	beqz	s2,814 <vprintf+0x27e>
 5a8:	e4a6                	sd	s1,72(sp)
 5aa:	fc4e                	sd	s3,56(sp)
 5ac:	f852                	sd	s4,48(sp)
 5ae:	f456                	sd	s5,40(sp)
 5b0:	f05a                	sd	s6,32(sp)
 5b2:	ec5e                	sd	s7,24(sp)
 5b4:	e862                	sd	s8,16(sp)
 5b6:	e466                	sd	s9,8(sp)
 5b8:	8b2a                	mv	s6,a0
 5ba:	8a2e                	mv	s4,a1
 5bc:	8bb2                	mv	s7,a2
  state = 0;
 5be:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5c0:	4481                	li	s1,0
 5c2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5c4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5c8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5cc:	06c00c93          	li	s9,108
 5d0:	a005                	j	5f0 <vprintf+0x5a>
        putc(fd, c0);
 5d2:	85ca                	mv	a1,s2
 5d4:	855a                	mv	a0,s6
 5d6:	efbff0ef          	jal	4d0 <putc>
 5da:	a019                	j	5e0 <vprintf+0x4a>
    } else if(state == '%'){
 5dc:	03598263          	beq	s3,s5,600 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5e0:	2485                	addiw	s1,s1,1
 5e2:	8726                	mv	a4,s1
 5e4:	009a07b3          	add	a5,s4,s1
 5e8:	0007c903          	lbu	s2,0(a5)
 5ec:	20090c63          	beqz	s2,804 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 5f0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5f4:	fe0994e3          	bnez	s3,5dc <vprintf+0x46>
      if(c0 == '%'){
 5f8:	fd579de3          	bne	a5,s5,5d2 <vprintf+0x3c>
        state = '%';
 5fc:	89be                	mv	s3,a5
 5fe:	b7cd                	j	5e0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 600:	00ea06b3          	add	a3,s4,a4
 604:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 608:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 60a:	c681                	beqz	a3,612 <vprintf+0x7c>
 60c:	9752                	add	a4,a4,s4
 60e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 612:	03878f63          	beq	a5,s8,650 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 616:	05978963          	beq	a5,s9,668 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 61a:	07500713          	li	a4,117
 61e:	0ee78363          	beq	a5,a4,704 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 622:	07800713          	li	a4,120
 626:	12e78563          	beq	a5,a4,750 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 62a:	07000713          	li	a4,112
 62e:	14e78a63          	beq	a5,a4,782 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 632:	07300713          	li	a4,115
 636:	18e78a63          	beq	a5,a4,7ca <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 63a:	02500713          	li	a4,37
 63e:	04e79563          	bne	a5,a4,688 <vprintf+0xf2>
        putc(fd, '%');
 642:	02500593          	li	a1,37
 646:	855a                	mv	a0,s6
 648:	e89ff0ef          	jal	4d0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 64c:	4981                	li	s3,0
 64e:	bf49                	j	5e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 650:	008b8913          	addi	s2,s7,8
 654:	4685                	li	a3,1
 656:	4629                	li	a2,10
 658:	000ba583          	lw	a1,0(s7)
 65c:	855a                	mv	a0,s6
 65e:	e91ff0ef          	jal	4ee <printint>
 662:	8bca                	mv	s7,s2
      state = 0;
 664:	4981                	li	s3,0
 666:	bfad                	j	5e0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 668:	06400793          	li	a5,100
 66c:	02f68963          	beq	a3,a5,69e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 670:	06c00793          	li	a5,108
 674:	04f68263          	beq	a3,a5,6b8 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 678:	07500793          	li	a5,117
 67c:	0af68063          	beq	a3,a5,71c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 680:	07800793          	li	a5,120
 684:	0ef68263          	beq	a3,a5,768 <vprintf+0x1d2>
        putc(fd, '%');
 688:	02500593          	li	a1,37
 68c:	855a                	mv	a0,s6
 68e:	e43ff0ef          	jal	4d0 <putc>
        putc(fd, c0);
 692:	85ca                	mv	a1,s2
 694:	855a                	mv	a0,s6
 696:	e3bff0ef          	jal	4d0 <putc>
      state = 0;
 69a:	4981                	li	s3,0
 69c:	b791                	j	5e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 69e:	008b8913          	addi	s2,s7,8
 6a2:	4685                	li	a3,1
 6a4:	4629                	li	a2,10
 6a6:	000ba583          	lw	a1,0(s7)
 6aa:	855a                	mv	a0,s6
 6ac:	e43ff0ef          	jal	4ee <printint>
        i += 1;
 6b0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b2:	8bca                	mv	s7,s2
      state = 0;
 6b4:	4981                	li	s3,0
        i += 1;
 6b6:	b72d                	j	5e0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6b8:	06400793          	li	a5,100
 6bc:	02f60763          	beq	a2,a5,6ea <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6c0:	07500793          	li	a5,117
 6c4:	06f60963          	beq	a2,a5,736 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6c8:	07800793          	li	a5,120
 6cc:	faf61ee3          	bne	a2,a5,688 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d0:	008b8913          	addi	s2,s7,8
 6d4:	4681                	li	a3,0
 6d6:	4641                	li	a2,16
 6d8:	000ba583          	lw	a1,0(s7)
 6dc:	855a                	mv	a0,s6
 6de:	e11ff0ef          	jal	4ee <printint>
        i += 2;
 6e2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e4:	8bca                	mv	s7,s2
      state = 0;
 6e6:	4981                	li	s3,0
        i += 2;
 6e8:	bde5                	j	5e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ea:	008b8913          	addi	s2,s7,8
 6ee:	4685                	li	a3,1
 6f0:	4629                	li	a2,10
 6f2:	000ba583          	lw	a1,0(s7)
 6f6:	855a                	mv	a0,s6
 6f8:	df7ff0ef          	jal	4ee <printint>
        i += 2;
 6fc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6fe:	8bca                	mv	s7,s2
      state = 0;
 700:	4981                	li	s3,0
        i += 2;
 702:	bdf9                	j	5e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 704:	008b8913          	addi	s2,s7,8
 708:	4681                	li	a3,0
 70a:	4629                	li	a2,10
 70c:	000ba583          	lw	a1,0(s7)
 710:	855a                	mv	a0,s6
 712:	dddff0ef          	jal	4ee <printint>
 716:	8bca                	mv	s7,s2
      state = 0;
 718:	4981                	li	s3,0
 71a:	b5d9                	j	5e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 71c:	008b8913          	addi	s2,s7,8
 720:	4681                	li	a3,0
 722:	4629                	li	a2,10
 724:	000ba583          	lw	a1,0(s7)
 728:	855a                	mv	a0,s6
 72a:	dc5ff0ef          	jal	4ee <printint>
        i += 1;
 72e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 730:	8bca                	mv	s7,s2
      state = 0;
 732:	4981                	li	s3,0
        i += 1;
 734:	b575                	j	5e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 736:	008b8913          	addi	s2,s7,8
 73a:	4681                	li	a3,0
 73c:	4629                	li	a2,10
 73e:	000ba583          	lw	a1,0(s7)
 742:	855a                	mv	a0,s6
 744:	dabff0ef          	jal	4ee <printint>
        i += 2;
 748:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 74a:	8bca                	mv	s7,s2
      state = 0;
 74c:	4981                	li	s3,0
        i += 2;
 74e:	bd49                	j	5e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 750:	008b8913          	addi	s2,s7,8
 754:	4681                	li	a3,0
 756:	4641                	li	a2,16
 758:	000ba583          	lw	a1,0(s7)
 75c:	855a                	mv	a0,s6
 75e:	d91ff0ef          	jal	4ee <printint>
 762:	8bca                	mv	s7,s2
      state = 0;
 764:	4981                	li	s3,0
 766:	bdad                	j	5e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 768:	008b8913          	addi	s2,s7,8
 76c:	4681                	li	a3,0
 76e:	4641                	li	a2,16
 770:	000ba583          	lw	a1,0(s7)
 774:	855a                	mv	a0,s6
 776:	d79ff0ef          	jal	4ee <printint>
        i += 1;
 77a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 77c:	8bca                	mv	s7,s2
      state = 0;
 77e:	4981                	li	s3,0
        i += 1;
 780:	b585                	j	5e0 <vprintf+0x4a>
 782:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 784:	008b8d13          	addi	s10,s7,8
 788:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 78c:	03000593          	li	a1,48
 790:	855a                	mv	a0,s6
 792:	d3fff0ef          	jal	4d0 <putc>
  putc(fd, 'x');
 796:	07800593          	li	a1,120
 79a:	855a                	mv	a0,s6
 79c:	d35ff0ef          	jal	4d0 <putc>
 7a0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7a2:	00000b97          	auipc	s7,0x0
 7a6:	2beb8b93          	addi	s7,s7,702 # a60 <digits>
 7aa:	03c9d793          	srli	a5,s3,0x3c
 7ae:	97de                	add	a5,a5,s7
 7b0:	0007c583          	lbu	a1,0(a5)
 7b4:	855a                	mv	a0,s6
 7b6:	d1bff0ef          	jal	4d0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7ba:	0992                	slli	s3,s3,0x4
 7bc:	397d                	addiw	s2,s2,-1
 7be:	fe0916e3          	bnez	s2,7aa <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7c2:	8bea                	mv	s7,s10
      state = 0;
 7c4:	4981                	li	s3,0
 7c6:	6d02                	ld	s10,0(sp)
 7c8:	bd21                	j	5e0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7ca:	008b8993          	addi	s3,s7,8
 7ce:	000bb903          	ld	s2,0(s7)
 7d2:	00090f63          	beqz	s2,7f0 <vprintf+0x25a>
        for(; *s; s++)
 7d6:	00094583          	lbu	a1,0(s2)
 7da:	c195                	beqz	a1,7fe <vprintf+0x268>
          putc(fd, *s);
 7dc:	855a                	mv	a0,s6
 7de:	cf3ff0ef          	jal	4d0 <putc>
        for(; *s; s++)
 7e2:	0905                	addi	s2,s2,1
 7e4:	00094583          	lbu	a1,0(s2)
 7e8:	f9f5                	bnez	a1,7dc <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7ea:	8bce                	mv	s7,s3
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	bbcd                	j	5e0 <vprintf+0x4a>
          s = "(null)";
 7f0:	00000917          	auipc	s2,0x0
 7f4:	26890913          	addi	s2,s2,616 # a58 <malloc+0x15c>
        for(; *s; s++)
 7f8:	02800593          	li	a1,40
 7fc:	b7c5                	j	7dc <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7fe:	8bce                	mv	s7,s3
      state = 0;
 800:	4981                	li	s3,0
 802:	bbf9                	j	5e0 <vprintf+0x4a>
 804:	64a6                	ld	s1,72(sp)
 806:	79e2                	ld	s3,56(sp)
 808:	7a42                	ld	s4,48(sp)
 80a:	7aa2                	ld	s5,40(sp)
 80c:	7b02                	ld	s6,32(sp)
 80e:	6be2                	ld	s7,24(sp)
 810:	6c42                	ld	s8,16(sp)
 812:	6ca2                	ld	s9,8(sp)
    }
  }
}
 814:	60e6                	ld	ra,88(sp)
 816:	6446                	ld	s0,80(sp)
 818:	6906                	ld	s2,64(sp)
 81a:	6125                	addi	sp,sp,96
 81c:	8082                	ret

000000000000081e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 81e:	715d                	addi	sp,sp,-80
 820:	ec06                	sd	ra,24(sp)
 822:	e822                	sd	s0,16(sp)
 824:	1000                	addi	s0,sp,32
 826:	e010                	sd	a2,0(s0)
 828:	e414                	sd	a3,8(s0)
 82a:	e818                	sd	a4,16(s0)
 82c:	ec1c                	sd	a5,24(s0)
 82e:	03043023          	sd	a6,32(s0)
 832:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 836:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 83a:	8622                	mv	a2,s0
 83c:	d5bff0ef          	jal	596 <vprintf>
}
 840:	60e2                	ld	ra,24(sp)
 842:	6442                	ld	s0,16(sp)
 844:	6161                	addi	sp,sp,80
 846:	8082                	ret

0000000000000848 <printf>:

void
printf(const char *fmt, ...)
{
 848:	711d                	addi	sp,sp,-96
 84a:	ec06                	sd	ra,24(sp)
 84c:	e822                	sd	s0,16(sp)
 84e:	1000                	addi	s0,sp,32
 850:	e40c                	sd	a1,8(s0)
 852:	e810                	sd	a2,16(s0)
 854:	ec14                	sd	a3,24(s0)
 856:	f018                	sd	a4,32(s0)
 858:	f41c                	sd	a5,40(s0)
 85a:	03043823          	sd	a6,48(s0)
 85e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 862:	00840613          	addi	a2,s0,8
 866:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 86a:	85aa                	mv	a1,a0
 86c:	4505                	li	a0,1
 86e:	d29ff0ef          	jal	596 <vprintf>
}
 872:	60e2                	ld	ra,24(sp)
 874:	6442                	ld	s0,16(sp)
 876:	6125                	addi	sp,sp,96
 878:	8082                	ret

000000000000087a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 87a:	1141                	addi	sp,sp,-16
 87c:	e422                	sd	s0,8(sp)
 87e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 880:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 884:	00000797          	auipc	a5,0x0
 888:	77c7b783          	ld	a5,1916(a5) # 1000 <freep>
 88c:	a02d                	j	8b6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 88e:	4618                	lw	a4,8(a2)
 890:	9f2d                	addw	a4,a4,a1
 892:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 896:	6398                	ld	a4,0(a5)
 898:	6310                	ld	a2,0(a4)
 89a:	a83d                	j	8d8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 89c:	ff852703          	lw	a4,-8(a0)
 8a0:	9f31                	addw	a4,a4,a2
 8a2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8a4:	ff053683          	ld	a3,-16(a0)
 8a8:	a091                	j	8ec <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8aa:	6398                	ld	a4,0(a5)
 8ac:	00e7e463          	bltu	a5,a4,8b4 <free+0x3a>
 8b0:	00e6ea63          	bltu	a3,a4,8c4 <free+0x4a>
{
 8b4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b6:	fed7fae3          	bgeu	a5,a3,8aa <free+0x30>
 8ba:	6398                	ld	a4,0(a5)
 8bc:	00e6e463          	bltu	a3,a4,8c4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c0:	fee7eae3          	bltu	a5,a4,8b4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8c4:	ff852583          	lw	a1,-8(a0)
 8c8:	6390                	ld	a2,0(a5)
 8ca:	02059813          	slli	a6,a1,0x20
 8ce:	01c85713          	srli	a4,a6,0x1c
 8d2:	9736                	add	a4,a4,a3
 8d4:	fae60de3          	beq	a2,a4,88e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8d8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8dc:	4790                	lw	a2,8(a5)
 8de:	02061593          	slli	a1,a2,0x20
 8e2:	01c5d713          	srli	a4,a1,0x1c
 8e6:	973e                	add	a4,a4,a5
 8e8:	fae68ae3          	beq	a3,a4,89c <free+0x22>
    p->s.ptr = bp->s.ptr;
 8ec:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8ee:	00000717          	auipc	a4,0x0
 8f2:	70f73923          	sd	a5,1810(a4) # 1000 <freep>
}
 8f6:	6422                	ld	s0,8(sp)
 8f8:	0141                	addi	sp,sp,16
 8fa:	8082                	ret

00000000000008fc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8fc:	7139                	addi	sp,sp,-64
 8fe:	fc06                	sd	ra,56(sp)
 900:	f822                	sd	s0,48(sp)
 902:	f426                	sd	s1,40(sp)
 904:	ec4e                	sd	s3,24(sp)
 906:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 908:	02051493          	slli	s1,a0,0x20
 90c:	9081                	srli	s1,s1,0x20
 90e:	04bd                	addi	s1,s1,15
 910:	8091                	srli	s1,s1,0x4
 912:	0014899b          	addiw	s3,s1,1
 916:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 918:	00000517          	auipc	a0,0x0
 91c:	6e853503          	ld	a0,1768(a0) # 1000 <freep>
 920:	c915                	beqz	a0,954 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 922:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 924:	4798                	lw	a4,8(a5)
 926:	08977a63          	bgeu	a4,s1,9ba <malloc+0xbe>
 92a:	f04a                	sd	s2,32(sp)
 92c:	e852                	sd	s4,16(sp)
 92e:	e456                	sd	s5,8(sp)
 930:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 932:	8a4e                	mv	s4,s3
 934:	0009871b          	sext.w	a4,s3
 938:	6685                	lui	a3,0x1
 93a:	00d77363          	bgeu	a4,a3,940 <malloc+0x44>
 93e:	6a05                	lui	s4,0x1
 940:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 944:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 948:	00000917          	auipc	s2,0x0
 94c:	6b890913          	addi	s2,s2,1720 # 1000 <freep>
  if(p == (char*)-1)
 950:	5afd                	li	s5,-1
 952:	a081                	j	992 <malloc+0x96>
 954:	f04a                	sd	s2,32(sp)
 956:	e852                	sd	s4,16(sp)
 958:	e456                	sd	s5,8(sp)
 95a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 95c:	00000797          	auipc	a5,0x0
 960:	6b478793          	addi	a5,a5,1716 # 1010 <base>
 964:	00000717          	auipc	a4,0x0
 968:	68f73e23          	sd	a5,1692(a4) # 1000 <freep>
 96c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 96e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 972:	b7c1                	j	932 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 974:	6398                	ld	a4,0(a5)
 976:	e118                	sd	a4,0(a0)
 978:	a8a9                	j	9d2 <malloc+0xd6>
  hp->s.size = nu;
 97a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 97e:	0541                	addi	a0,a0,16
 980:	efbff0ef          	jal	87a <free>
  return freep;
 984:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 988:	c12d                	beqz	a0,9ea <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 98c:	4798                	lw	a4,8(a5)
 98e:	02977263          	bgeu	a4,s1,9b2 <malloc+0xb6>
    if(p == freep)
 992:	00093703          	ld	a4,0(s2)
 996:	853e                	mv	a0,a5
 998:	fef719e3          	bne	a4,a5,98a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 99c:	8552                	mv	a0,s4
 99e:	ad3ff0ef          	jal	470 <sbrk>
  if(p == (char*)-1)
 9a2:	fd551ce3          	bne	a0,s5,97a <malloc+0x7e>
        return 0;
 9a6:	4501                	li	a0,0
 9a8:	7902                	ld	s2,32(sp)
 9aa:	6a42                	ld	s4,16(sp)
 9ac:	6aa2                	ld	s5,8(sp)
 9ae:	6b02                	ld	s6,0(sp)
 9b0:	a03d                	j	9de <malloc+0xe2>
 9b2:	7902                	ld	s2,32(sp)
 9b4:	6a42                	ld	s4,16(sp)
 9b6:	6aa2                	ld	s5,8(sp)
 9b8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9ba:	fae48de3          	beq	s1,a4,974 <malloc+0x78>
        p->s.size -= nunits;
 9be:	4137073b          	subw	a4,a4,s3
 9c2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9c4:	02071693          	slli	a3,a4,0x20
 9c8:	01c6d713          	srli	a4,a3,0x1c
 9cc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ce:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9d2:	00000717          	auipc	a4,0x0
 9d6:	62a73723          	sd	a0,1582(a4) # 1000 <freep>
      return (void*)(p + 1);
 9da:	01078513          	addi	a0,a5,16
  }
}
 9de:	70e2                	ld	ra,56(sp)
 9e0:	7442                	ld	s0,48(sp)
 9e2:	74a2                	ld	s1,40(sp)
 9e4:	69e2                	ld	s3,24(sp)
 9e6:	6121                	addi	sp,sp,64
 9e8:	8082                	ret
 9ea:	7902                	ld	s2,32(sp)
 9ec:	6a42                	ld	s4,16(sp)
 9ee:	6aa2                	ld	s5,8(sp)
 9f0:	6b02                	ld	s6,0(sp)
 9f2:	b7f5                	j	9de <malloc+0xe2>
