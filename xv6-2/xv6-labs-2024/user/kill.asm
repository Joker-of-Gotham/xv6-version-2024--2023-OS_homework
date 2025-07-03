
user/_kill：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7d963          	bge	a5,a0,3c <main+0x3c>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	1d6000ef          	jal	1fe <atoi>
  2c:	3f2000ef          	jal	41e <kill>
  for(i=1; i<argc; i++)
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  36:	4501                	li	a0,0
  38:	3b6000ef          	jal	3ee <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  40:	00001597          	auipc	a1,0x1
  44:	9c058593          	addi	a1,a1,-1600 # a00 <malloc+0xfe>
  48:	4509                	li	a0,2
  4a:	7da000ef          	jal	824 <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	39e000ef          	jal	3ee <exit>

0000000000000054 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  5c:	fa5ff0ef          	jal	0 <main>
  exit(0);
  60:	4501                	li	a0,0
  62:	38c000ef          	jal	3ee <exit>

0000000000000066 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  66:	1141                	addi	sp,sp,-16
  68:	e422                	sd	s0,8(sp)
  6a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6c:	87aa                	mv	a5,a0
  6e:	0585                	addi	a1,a1,1
  70:	0785                	addi	a5,a5,1
  72:	fff5c703          	lbu	a4,-1(a1)
  76:	fee78fa3          	sb	a4,-1(a5)
  7a:	fb75                	bnez	a4,6e <strcpy+0x8>
    ;
  return os;
}
  7c:	6422                	ld	s0,8(sp)
  7e:	0141                	addi	sp,sp,16
  80:	8082                	ret

0000000000000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	1141                	addi	sp,sp,-16
  84:	e422                	sd	s0,8(sp)
  86:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  88:	00054783          	lbu	a5,0(a0)
  8c:	cb91                	beqz	a5,a0 <strcmp+0x1e>
  8e:	0005c703          	lbu	a4,0(a1)
  92:	00f71763          	bne	a4,a5,a0 <strcmp+0x1e>
    p++, q++;
  96:	0505                	addi	a0,a0,1
  98:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	fbe5                	bnez	a5,8e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  a0:	0005c503          	lbu	a0,0(a1)
}
  a4:	40a7853b          	subw	a0,a5,a0
  a8:	6422                	ld	s0,8(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e422                	sd	s0,8(sp)
  b2:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q) {
  b4:	ce11                	beqz	a2,d0 <strncmp+0x22>
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cf89                	beqz	a5,d4 <strncmp+0x26>
  bc:	0005c703          	lbu	a4,0(a1)
  c0:	00f71a63          	bne	a4,a5,d4 <strncmp+0x26>
    n--;
  c4:	367d                	addiw	a2,a2,-1
    p++;
  c6:	0505                	addi	a0,a0,1
    q++;
  c8:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q) {
  ca:	f675                	bnez	a2,b6 <strncmp+0x8>
  }
  if(n == 0)
    return 0;
  cc:	4501                	li	a0,0
  ce:	a801                	j	de <strncmp+0x30>
  d0:	4501                	li	a0,0
  d2:	a031                	j	de <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
  d4:	00054503          	lbu	a0,0(a0)
  d8:	0005c783          	lbu	a5,0(a1)
  dc:	9d1d                	subw	a0,a0,a5
}
  de:	6422                	ld	s0,8(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret

00000000000000e4 <strlen>:

uint
strlen(const char *s)
{
  e4:	1141                	addi	sp,sp,-16
  e6:	e422                	sd	s0,8(sp)
  e8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ea:	00054783          	lbu	a5,0(a0)
  ee:	cf91                	beqz	a5,10a <strlen+0x26>
  f0:	0505                	addi	a0,a0,1
  f2:	87aa                	mv	a5,a0
  f4:	86be                	mv	a3,a5
  f6:	0785                	addi	a5,a5,1
  f8:	fff7c703          	lbu	a4,-1(a5)
  fc:	ff65                	bnez	a4,f4 <strlen+0x10>
  fe:	40a6853b          	subw	a0,a3,a0
 102:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 104:	6422                	ld	s0,8(sp)
 106:	0141                	addi	sp,sp,16
 108:	8082                	ret
  for(n = 0; s[n]; n++)
 10a:	4501                	li	a0,0
 10c:	bfe5                	j	104 <strlen+0x20>

000000000000010e <memset>:

void*
memset(void *dst, int c, uint n)
{
 10e:	1141                	addi	sp,sp,-16
 110:	e422                	sd	s0,8(sp)
 112:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 114:	ca19                	beqz	a2,12a <memset+0x1c>
 116:	87aa                	mv	a5,a0
 118:	1602                	slli	a2,a2,0x20
 11a:	9201                	srli	a2,a2,0x20
 11c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 120:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 124:	0785                	addi	a5,a5,1
 126:	fee79de3          	bne	a5,a4,120 <memset+0x12>
  }
  return dst;
}
 12a:	6422                	ld	s0,8(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret

0000000000000130 <strchr>:

char*
strchr(const char *s, char c)
{
 130:	1141                	addi	sp,sp,-16
 132:	e422                	sd	s0,8(sp)
 134:	0800                	addi	s0,sp,16
  for(; *s; s++)
 136:	00054783          	lbu	a5,0(a0)
 13a:	cb99                	beqz	a5,150 <strchr+0x20>
    if(*s == c)
 13c:	00f58763          	beq	a1,a5,14a <strchr+0x1a>
  for(; *s; s++)
 140:	0505                	addi	a0,a0,1
 142:	00054783          	lbu	a5,0(a0)
 146:	fbfd                	bnez	a5,13c <strchr+0xc>
      return (char*)s;
  return 0;
 148:	4501                	li	a0,0
}
 14a:	6422                	ld	s0,8(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret
  return 0;
 150:	4501                	li	a0,0
 152:	bfe5                	j	14a <strchr+0x1a>

0000000000000154 <gets>:

char*
gets(char *buf, int max)
{
 154:	711d                	addi	sp,sp,-96
 156:	ec86                	sd	ra,88(sp)
 158:	e8a2                	sd	s0,80(sp)
 15a:	e4a6                	sd	s1,72(sp)
 15c:	e0ca                	sd	s2,64(sp)
 15e:	fc4e                	sd	s3,56(sp)
 160:	f852                	sd	s4,48(sp)
 162:	f456                	sd	s5,40(sp)
 164:	f05a                	sd	s6,32(sp)
 166:	ec5e                	sd	s7,24(sp)
 168:	1080                	addi	s0,sp,96
 16a:	8baa                	mv	s7,a0
 16c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16e:	892a                	mv	s2,a0
 170:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 172:	4aa9                	li	s5,10
 174:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 176:	89a6                	mv	s3,s1
 178:	2485                	addiw	s1,s1,1
 17a:	0344d663          	bge	s1,s4,1a6 <gets+0x52>
    cc = read(0, &c, 1);
 17e:	4605                	li	a2,1
 180:	faf40593          	addi	a1,s0,-81
 184:	4501                	li	a0,0
 186:	280000ef          	jal	406 <read>
    if(cc < 1)
 18a:	00a05e63          	blez	a0,1a6 <gets+0x52>
    buf[i++] = c;
 18e:	faf44783          	lbu	a5,-81(s0)
 192:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 196:	01578763          	beq	a5,s5,1a4 <gets+0x50>
 19a:	0905                	addi	s2,s2,1
 19c:	fd679de3          	bne	a5,s6,176 <gets+0x22>
    buf[i++] = c;
 1a0:	89a6                	mv	s3,s1
 1a2:	a011                	j	1a6 <gets+0x52>
 1a4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a6:	99de                	add	s3,s3,s7
 1a8:	00098023          	sb	zero,0(s3)
  return buf;
}
 1ac:	855e                	mv	a0,s7
 1ae:	60e6                	ld	ra,88(sp)
 1b0:	6446                	ld	s0,80(sp)
 1b2:	64a6                	ld	s1,72(sp)
 1b4:	6906                	ld	s2,64(sp)
 1b6:	79e2                	ld	s3,56(sp)
 1b8:	7a42                	ld	s4,48(sp)
 1ba:	7aa2                	ld	s5,40(sp)
 1bc:	7b02                	ld	s6,32(sp)
 1be:	6be2                	ld	s7,24(sp)
 1c0:	6125                	addi	sp,sp,96
 1c2:	8082                	ret

00000000000001c4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c4:	1101                	addi	sp,sp,-32
 1c6:	ec06                	sd	ra,24(sp)
 1c8:	e822                	sd	s0,16(sp)
 1ca:	e04a                	sd	s2,0(sp)
 1cc:	1000                	addi	s0,sp,32
 1ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d0:	4581                	li	a1,0
 1d2:	25c000ef          	jal	42e <open>
  if(fd < 0)
 1d6:	02054263          	bltz	a0,1fa <stat+0x36>
 1da:	e426                	sd	s1,8(sp)
 1dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1de:	85ca                	mv	a1,s2
 1e0:	266000ef          	jal	446 <fstat>
 1e4:	892a                	mv	s2,a0
  close(fd);
 1e6:	8526                	mv	a0,s1
 1e8:	22e000ef          	jal	416 <close>
  return r;
 1ec:	64a2                	ld	s1,8(sp)
}
 1ee:	854a                	mv	a0,s2
 1f0:	60e2                	ld	ra,24(sp)
 1f2:	6442                	ld	s0,16(sp)
 1f4:	6902                	ld	s2,0(sp)
 1f6:	6105                	addi	sp,sp,32
 1f8:	8082                	ret
    return -1;
 1fa:	597d                	li	s2,-1
 1fc:	bfcd                	j	1ee <stat+0x2a>

00000000000001fe <atoi>:

int
atoi(const char *s)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 204:	00054683          	lbu	a3,0(a0)
 208:	fd06879b          	addiw	a5,a3,-48
 20c:	0ff7f793          	zext.b	a5,a5
 210:	4625                	li	a2,9
 212:	02f66863          	bltu	a2,a5,242 <atoi+0x44>
 216:	872a                	mv	a4,a0
  n = 0;
 218:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 21a:	0705                	addi	a4,a4,1
 21c:	0025179b          	slliw	a5,a0,0x2
 220:	9fa9                	addw	a5,a5,a0
 222:	0017979b          	slliw	a5,a5,0x1
 226:	9fb5                	addw	a5,a5,a3
 228:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 22c:	00074683          	lbu	a3,0(a4)
 230:	fd06879b          	addiw	a5,a3,-48
 234:	0ff7f793          	zext.b	a5,a5
 238:	fef671e3          	bgeu	a2,a5,21a <atoi+0x1c>
  return n;
}
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret
  n = 0;
 242:	4501                	li	a0,0
 244:	bfe5                	j	23c <atoi+0x3e>

0000000000000246 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 246:	1141                	addi	sp,sp,-16
 248:	e422                	sd	s0,8(sp)
 24a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 24c:	02b57463          	bgeu	a0,a1,274 <memmove+0x2e>
    while(n-- > 0)
 250:	00c05f63          	blez	a2,26e <memmove+0x28>
 254:	1602                	slli	a2,a2,0x20
 256:	9201                	srli	a2,a2,0x20
 258:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 25c:	872a                	mv	a4,a0
      *dst++ = *src++;
 25e:	0585                	addi	a1,a1,1
 260:	0705                	addi	a4,a4,1
 262:	fff5c683          	lbu	a3,-1(a1)
 266:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 26a:	fef71ae3          	bne	a4,a5,25e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret
    dst += n;
 274:	00c50733          	add	a4,a0,a2
    src += n;
 278:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 27a:	fec05ae3          	blez	a2,26e <memmove+0x28>
 27e:	fff6079b          	addiw	a5,a2,-1
 282:	1782                	slli	a5,a5,0x20
 284:	9381                	srli	a5,a5,0x20
 286:	fff7c793          	not	a5,a5
 28a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 28c:	15fd                	addi	a1,a1,-1
 28e:	177d                	addi	a4,a4,-1
 290:	0005c683          	lbu	a3,0(a1)
 294:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 298:	fee79ae3          	bne	a5,a4,28c <memmove+0x46>
 29c:	bfc9                	j	26e <memmove+0x28>

000000000000029e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e422                	sd	s0,8(sp)
 2a2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a4:	ca05                	beqz	a2,2d4 <memcmp+0x36>
 2a6:	fff6069b          	addiw	a3,a2,-1
 2aa:	1682                	slli	a3,a3,0x20
 2ac:	9281                	srli	a3,a3,0x20
 2ae:	0685                	addi	a3,a3,1
 2b0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2b2:	00054783          	lbu	a5,0(a0)
 2b6:	0005c703          	lbu	a4,0(a1)
 2ba:	00e79863          	bne	a5,a4,2ca <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2be:	0505                	addi	a0,a0,1
    p2++;
 2c0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c2:	fed518e3          	bne	a0,a3,2b2 <memcmp+0x14>
  }
  return 0;
 2c6:	4501                	li	a0,0
 2c8:	a019                	j	2ce <memcmp+0x30>
      return *p1 - *p2;
 2ca:	40e7853b          	subw	a0,a5,a4
}
 2ce:	6422                	ld	s0,8(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret
  return 0;
 2d4:	4501                	li	a0,0
 2d6:	bfe5                	j	2ce <memcmp+0x30>

00000000000002d8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e406                	sd	ra,8(sp)
 2dc:	e022                	sd	s0,0(sp)
 2de:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e0:	f67ff0ef          	jal	246 <memmove>
}
 2e4:	60a2                	ld	ra,8(sp)
 2e6:	6402                	ld	s0,0(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret

00000000000002ec <simplesort>:

void
simplesort(void *base, uint nmemb, uint size, int (*compar)(const void *, const void *))
{
 2ec:	7119                	addi	sp,sp,-128
 2ee:	fc86                	sd	ra,120(sp)
 2f0:	f8a2                	sd	s0,112(sp)
 2f2:	0100                	addi	s0,sp,128
 2f4:	f8b43423          	sd	a1,-120(s0)
  char *arr = (char *)base; // Treat array as char array for byte-level manipulation
  char *temp;               // Temporary storage for an element

  if (nmemb <= 1 || size == 0) {
 2f8:	4785                	li	a5,1
 2fa:	00b7fc63          	bgeu	a5,a1,312 <simplesort+0x26>
 2fe:	e8d2                	sd	s4,80(sp)
 300:	e4d6                	sd	s5,72(sp)
 302:	f466                	sd	s9,40(sp)
 304:	8aaa                	mv	s5,a0
 306:	8a32                	mv	s4,a2
 308:	8cb6                	mv	s9,a3
 30a:	ea01                	bnez	a2,31a <simplesort+0x2e>
 30c:	6a46                	ld	s4,80(sp)
 30e:	6aa6                	ld	s5,72(sp)
 310:	7ca2                	ld	s9,40(sp)
    // Place temp at its correct position
    memmove(arr + j * size, temp, size);
  }

  free(temp); // Free temporary space
 312:	70e6                	ld	ra,120(sp)
 314:	7446                	ld	s0,112(sp)
 316:	6109                	addi	sp,sp,128
 318:	8082                	ret
 31a:	fc5e                	sd	s7,56(sp)
 31c:	f862                	sd	s8,48(sp)
 31e:	f06a                	sd	s10,32(sp)
 320:	ec6e                	sd	s11,24(sp)
  temp = malloc(size); // Allocate temporary space for one element
 322:	8532                	mv	a0,a2
 324:	5de000ef          	jal	902 <malloc>
 328:	8baa                	mv	s7,a0
  if (temp == 0) {
 32a:	4d81                	li	s11,0
  for (uint i = 1; i < nmemb; i++) {
 32c:	4d05                	li	s10,1
    memmove(temp, arr + i * size, size);
 32e:	000a0c1b          	sext.w	s8,s4
  if (temp == 0) {
 332:	c511                	beqz	a0,33e <simplesort+0x52>
 334:	f4a6                	sd	s1,104(sp)
 336:	f0ca                	sd	s2,96(sp)
 338:	ecce                	sd	s3,88(sp)
 33a:	e0da                	sd	s6,64(sp)
 33c:	a82d                	j	376 <simplesort+0x8a>
    printf("simplesort: malloc failed, cannot sort\n");
 33e:	00000517          	auipc	a0,0x0
 342:	6da50513          	addi	a0,a0,1754 # a18 <malloc+0x116>
 346:	508000ef          	jal	84e <printf>
    return;
 34a:	6a46                	ld	s4,80(sp)
 34c:	6aa6                	ld	s5,72(sp)
 34e:	7be2                	ld	s7,56(sp)
 350:	7c42                	ld	s8,48(sp)
 352:	7ca2                	ld	s9,40(sp)
 354:	7d02                	ld	s10,32(sp)
 356:	6de2                	ld	s11,24(sp)
 358:	bf6d                	j	312 <simplesort+0x26>
    memmove(arr + j * size, temp, size);
 35a:	036a053b          	mulw	a0,s4,s6
 35e:	1502                	slli	a0,a0,0x20
 360:	9101                	srli	a0,a0,0x20
 362:	8662                	mv	a2,s8
 364:	85de                	mv	a1,s7
 366:	9556                	add	a0,a0,s5
 368:	edfff0ef          	jal	246 <memmove>
  for (uint i = 1; i < nmemb; i++) {
 36c:	2d05                	addiw	s10,s10,1
 36e:	f8843783          	ld	a5,-120(s0)
 372:	05a78b63          	beq	a5,s10,3c8 <simplesort+0xdc>
    memmove(temp, arr + i * size, size);
 376:	000d899b          	sext.w	s3,s11
 37a:	01ba05bb          	addw	a1,s4,s11
 37e:	00058d9b          	sext.w	s11,a1
 382:	1582                	slli	a1,a1,0x20
 384:	9181                	srli	a1,a1,0x20
 386:	8662                	mv	a2,s8
 388:	95d6                	add	a1,a1,s5
 38a:	855e                	mv	a0,s7
 38c:	ebbff0ef          	jal	246 <memmove>
    uint j = i;
 390:	896a                	mv	s2,s10
 392:	00090b1b          	sext.w	s6,s2
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 396:	397d                	addiw	s2,s2,-1
 398:	02099493          	slli	s1,s3,0x20
 39c:	9081                	srli	s1,s1,0x20
 39e:	94d6                	add	s1,s1,s5
 3a0:	85de                	mv	a1,s7
 3a2:	8526                	mv	a0,s1
 3a4:	9c82                	jalr	s9
 3a6:	faa05ae3          	blez	a0,35a <simplesort+0x6e>
      memmove(arr + j * size, arr + (j - 1) * size, size); // Shift element
 3aa:	0149853b          	addw	a0,s3,s4
 3ae:	1502                	slli	a0,a0,0x20
 3b0:	9101                	srli	a0,a0,0x20
 3b2:	8662                	mv	a2,s8
 3b4:	85a6                	mv	a1,s1
 3b6:	9556                	add	a0,a0,s5
 3b8:	e8fff0ef          	jal	246 <memmove>
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 3bc:	414989bb          	subw	s3,s3,s4
 3c0:	fc0919e3          	bnez	s2,392 <simplesort+0xa6>
 3c4:	8b4a                	mv	s6,s2
 3c6:	bf51                	j	35a <simplesort+0x6e>
  free(temp); // Free temporary space
 3c8:	855e                	mv	a0,s7
 3ca:	4b6000ef          	jal	880 <free>
 3ce:	74a6                	ld	s1,104(sp)
 3d0:	7906                	ld	s2,96(sp)
 3d2:	69e6                	ld	s3,88(sp)
 3d4:	6a46                	ld	s4,80(sp)
 3d6:	6aa6                	ld	s5,72(sp)
 3d8:	6b06                	ld	s6,64(sp)
 3da:	7be2                	ld	s7,56(sp)
 3dc:	7c42                	ld	s8,48(sp)
 3de:	7ca2                	ld	s9,40(sp)
 3e0:	7d02                	ld	s10,32(sp)
 3e2:	6de2                	ld	s11,24(sp)
 3e4:	b73d                	j	312 <simplesort+0x26>

00000000000003e6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3e6:	4885                	li	a7,1
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ee:	4889                	li	a7,2
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3f6:	488d                	li	a7,3
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3fe:	4891                	li	a7,4
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <read>:
.global read
read:
 li a7, SYS_read
 406:	4895                	li	a7,5
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <write>:
.global write
write:
 li a7, SYS_write
 40e:	48c1                	li	a7,16
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <close>:
.global close
close:
 li a7, SYS_close
 416:	48d5                	li	a7,21
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <kill>:
.global kill
kill:
 li a7, SYS_kill
 41e:	4899                	li	a7,6
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <exec>:
.global exec
exec:
 li a7, SYS_exec
 426:	489d                	li	a7,7
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <open>:
.global open
open:
 li a7, SYS_open
 42e:	48bd                	li	a7,15
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 436:	48c5                	li	a7,17
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 43e:	48c9                	li	a7,18
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 446:	48a1                	li	a7,8
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <link>:
.global link
link:
 li a7, SYS_link
 44e:	48cd                	li	a7,19
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 456:	48d1                	li	a7,20
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 45e:	48a5                	li	a7,9
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <dup>:
.global dup
dup:
 li a7, SYS_dup
 466:	48a9                	li	a7,10
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 46e:	48ad                	li	a7,11
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 476:	48b1                	li	a7,12
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 47e:	48b5                	li	a7,13
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 486:	48b9                	li	a7,14
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 48e:	48dd                	li	a7,23
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <statistics>:
.global statistics
statistics:
 li a7, SYS_statistics
 496:	48e1                	li	a7,24
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <reset_stats>:
.global reset_stats
reset_stats:
 li a7, SYS_reset_stats
 49e:	48e5                	li	a7,25
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <resetlockstats>:
.global resetlockstats
resetlockstats:
 li a7, SYS_resetlockstats
 4a6:	48e9                	li	a7,26
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <getlockstats>:
.global getlockstats
getlockstats:
 li a7, SYS_getlockstats
 4ae:	48ed                	li	a7,27
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <trace>:
.global trace
trace:
 li a7, SYS_trace
 4b6:	48d9                	li	a7,22
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 4be:	48f1                	li	a7,28
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <ugetpid>:
.global ugetpid
ugetpid:
 li a7, SYS_ugetpid
 4c6:	48f5                	li	a7,29
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 4ce:	48f9                	li	a7,30
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4d6:	1101                	addi	sp,sp,-32
 4d8:	ec06                	sd	ra,24(sp)
 4da:	e822                	sd	s0,16(sp)
 4dc:	1000                	addi	s0,sp,32
 4de:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4e2:	4605                	li	a2,1
 4e4:	fef40593          	addi	a1,s0,-17
 4e8:	f27ff0ef          	jal	40e <write>
}
 4ec:	60e2                	ld	ra,24(sp)
 4ee:	6442                	ld	s0,16(sp)
 4f0:	6105                	addi	sp,sp,32
 4f2:	8082                	ret

00000000000004f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f4:	7139                	addi	sp,sp,-64
 4f6:	fc06                	sd	ra,56(sp)
 4f8:	f822                	sd	s0,48(sp)
 4fa:	f426                	sd	s1,40(sp)
 4fc:	0080                	addi	s0,sp,64
 4fe:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 500:	c299                	beqz	a3,506 <printint+0x12>
 502:	0805c963          	bltz	a1,594 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 506:	2581                	sext.w	a1,a1
  neg = 0;
 508:	4881                	li	a7,0
 50a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 50e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 510:	2601                	sext.w	a2,a2
 512:	00000517          	auipc	a0,0x0
 516:	53650513          	addi	a0,a0,1334 # a48 <digits>
 51a:	883a                	mv	a6,a4
 51c:	2705                	addiw	a4,a4,1
 51e:	02c5f7bb          	remuw	a5,a1,a2
 522:	1782                	slli	a5,a5,0x20
 524:	9381                	srli	a5,a5,0x20
 526:	97aa                	add	a5,a5,a0
 528:	0007c783          	lbu	a5,0(a5)
 52c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 530:	0005879b          	sext.w	a5,a1
 534:	02c5d5bb          	divuw	a1,a1,a2
 538:	0685                	addi	a3,a3,1
 53a:	fec7f0e3          	bgeu	a5,a2,51a <printint+0x26>
  if(neg)
 53e:	00088c63          	beqz	a7,556 <printint+0x62>
    buf[i++] = '-';
 542:	fd070793          	addi	a5,a4,-48
 546:	00878733          	add	a4,a5,s0
 54a:	02d00793          	li	a5,45
 54e:	fef70823          	sb	a5,-16(a4)
 552:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 556:	02e05a63          	blez	a4,58a <printint+0x96>
 55a:	f04a                	sd	s2,32(sp)
 55c:	ec4e                	sd	s3,24(sp)
 55e:	fc040793          	addi	a5,s0,-64
 562:	00e78933          	add	s2,a5,a4
 566:	fff78993          	addi	s3,a5,-1
 56a:	99ba                	add	s3,s3,a4
 56c:	377d                	addiw	a4,a4,-1
 56e:	1702                	slli	a4,a4,0x20
 570:	9301                	srli	a4,a4,0x20
 572:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 576:	fff94583          	lbu	a1,-1(s2)
 57a:	8526                	mv	a0,s1
 57c:	f5bff0ef          	jal	4d6 <putc>
  while(--i >= 0)
 580:	197d                	addi	s2,s2,-1
 582:	ff391ae3          	bne	s2,s3,576 <printint+0x82>
 586:	7902                	ld	s2,32(sp)
 588:	69e2                	ld	s3,24(sp)
}
 58a:	70e2                	ld	ra,56(sp)
 58c:	7442                	ld	s0,48(sp)
 58e:	74a2                	ld	s1,40(sp)
 590:	6121                	addi	sp,sp,64
 592:	8082                	ret
    x = -xx;
 594:	40b005bb          	negw	a1,a1
    neg = 1;
 598:	4885                	li	a7,1
    x = -xx;
 59a:	bf85                	j	50a <printint+0x16>

000000000000059c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 59c:	711d                	addi	sp,sp,-96
 59e:	ec86                	sd	ra,88(sp)
 5a0:	e8a2                	sd	s0,80(sp)
 5a2:	e0ca                	sd	s2,64(sp)
 5a4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5a6:	0005c903          	lbu	s2,0(a1)
 5aa:	26090863          	beqz	s2,81a <vprintf+0x27e>
 5ae:	e4a6                	sd	s1,72(sp)
 5b0:	fc4e                	sd	s3,56(sp)
 5b2:	f852                	sd	s4,48(sp)
 5b4:	f456                	sd	s5,40(sp)
 5b6:	f05a                	sd	s6,32(sp)
 5b8:	ec5e                	sd	s7,24(sp)
 5ba:	e862                	sd	s8,16(sp)
 5bc:	e466                	sd	s9,8(sp)
 5be:	8b2a                	mv	s6,a0
 5c0:	8a2e                	mv	s4,a1
 5c2:	8bb2                	mv	s7,a2
  state = 0;
 5c4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5c6:	4481                	li	s1,0
 5c8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5ca:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5ce:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5d2:	06c00c93          	li	s9,108
 5d6:	a005                	j	5f6 <vprintf+0x5a>
        putc(fd, c0);
 5d8:	85ca                	mv	a1,s2
 5da:	855a                	mv	a0,s6
 5dc:	efbff0ef          	jal	4d6 <putc>
 5e0:	a019                	j	5e6 <vprintf+0x4a>
    } else if(state == '%'){
 5e2:	03598263          	beq	s3,s5,606 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5e6:	2485                	addiw	s1,s1,1
 5e8:	8726                	mv	a4,s1
 5ea:	009a07b3          	add	a5,s4,s1
 5ee:	0007c903          	lbu	s2,0(a5)
 5f2:	20090c63          	beqz	s2,80a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 5f6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5fa:	fe0994e3          	bnez	s3,5e2 <vprintf+0x46>
      if(c0 == '%'){
 5fe:	fd579de3          	bne	a5,s5,5d8 <vprintf+0x3c>
        state = '%';
 602:	89be                	mv	s3,a5
 604:	b7cd                	j	5e6 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 606:	00ea06b3          	add	a3,s4,a4
 60a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 60e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 610:	c681                	beqz	a3,618 <vprintf+0x7c>
 612:	9752                	add	a4,a4,s4
 614:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 618:	03878f63          	beq	a5,s8,656 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 61c:	05978963          	beq	a5,s9,66e <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 620:	07500713          	li	a4,117
 624:	0ee78363          	beq	a5,a4,70a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 628:	07800713          	li	a4,120
 62c:	12e78563          	beq	a5,a4,756 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 630:	07000713          	li	a4,112
 634:	14e78a63          	beq	a5,a4,788 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 638:	07300713          	li	a4,115
 63c:	18e78a63          	beq	a5,a4,7d0 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 640:	02500713          	li	a4,37
 644:	04e79563          	bne	a5,a4,68e <vprintf+0xf2>
        putc(fd, '%');
 648:	02500593          	li	a1,37
 64c:	855a                	mv	a0,s6
 64e:	e89ff0ef          	jal	4d6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 652:	4981                	li	s3,0
 654:	bf49                	j	5e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 656:	008b8913          	addi	s2,s7,8
 65a:	4685                	li	a3,1
 65c:	4629                	li	a2,10
 65e:	000ba583          	lw	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	e91ff0ef          	jal	4f4 <printint>
 668:	8bca                	mv	s7,s2
      state = 0;
 66a:	4981                	li	s3,0
 66c:	bfad                	j	5e6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 66e:	06400793          	li	a5,100
 672:	02f68963          	beq	a3,a5,6a4 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 676:	06c00793          	li	a5,108
 67a:	04f68263          	beq	a3,a5,6be <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 67e:	07500793          	li	a5,117
 682:	0af68063          	beq	a3,a5,722 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 686:	07800793          	li	a5,120
 68a:	0ef68263          	beq	a3,a5,76e <vprintf+0x1d2>
        putc(fd, '%');
 68e:	02500593          	li	a1,37
 692:	855a                	mv	a0,s6
 694:	e43ff0ef          	jal	4d6 <putc>
        putc(fd, c0);
 698:	85ca                	mv	a1,s2
 69a:	855a                	mv	a0,s6
 69c:	e3bff0ef          	jal	4d6 <putc>
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	b791                	j	5e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6a4:	008b8913          	addi	s2,s7,8
 6a8:	4685                	li	a3,1
 6aa:	4629                	li	a2,10
 6ac:	000ba583          	lw	a1,0(s7)
 6b0:	855a                	mv	a0,s6
 6b2:	e43ff0ef          	jal	4f4 <printint>
        i += 1;
 6b6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b8:	8bca                	mv	s7,s2
      state = 0;
 6ba:	4981                	li	s3,0
        i += 1;
 6bc:	b72d                	j	5e6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6be:	06400793          	li	a5,100
 6c2:	02f60763          	beq	a2,a5,6f0 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6c6:	07500793          	li	a5,117
 6ca:	06f60963          	beq	a2,a5,73c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6ce:	07800793          	li	a5,120
 6d2:	faf61ee3          	bne	a2,a5,68e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d6:	008b8913          	addi	s2,s7,8
 6da:	4681                	li	a3,0
 6dc:	4641                	li	a2,16
 6de:	000ba583          	lw	a1,0(s7)
 6e2:	855a                	mv	a0,s6
 6e4:	e11ff0ef          	jal	4f4 <printint>
        i += 2;
 6e8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ea:	8bca                	mv	s7,s2
      state = 0;
 6ec:	4981                	li	s3,0
        i += 2;
 6ee:	bde5                	j	5e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f0:	008b8913          	addi	s2,s7,8
 6f4:	4685                	li	a3,1
 6f6:	4629                	li	a2,10
 6f8:	000ba583          	lw	a1,0(s7)
 6fc:	855a                	mv	a0,s6
 6fe:	df7ff0ef          	jal	4f4 <printint>
        i += 2;
 702:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 704:	8bca                	mv	s7,s2
      state = 0;
 706:	4981                	li	s3,0
        i += 2;
 708:	bdf9                	j	5e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 70a:	008b8913          	addi	s2,s7,8
 70e:	4681                	li	a3,0
 710:	4629                	li	a2,10
 712:	000ba583          	lw	a1,0(s7)
 716:	855a                	mv	a0,s6
 718:	dddff0ef          	jal	4f4 <printint>
 71c:	8bca                	mv	s7,s2
      state = 0;
 71e:	4981                	li	s3,0
 720:	b5d9                	j	5e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 722:	008b8913          	addi	s2,s7,8
 726:	4681                	li	a3,0
 728:	4629                	li	a2,10
 72a:	000ba583          	lw	a1,0(s7)
 72e:	855a                	mv	a0,s6
 730:	dc5ff0ef          	jal	4f4 <printint>
        i += 1;
 734:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 736:	8bca                	mv	s7,s2
      state = 0;
 738:	4981                	li	s3,0
        i += 1;
 73a:	b575                	j	5e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 73c:	008b8913          	addi	s2,s7,8
 740:	4681                	li	a3,0
 742:	4629                	li	a2,10
 744:	000ba583          	lw	a1,0(s7)
 748:	855a                	mv	a0,s6
 74a:	dabff0ef          	jal	4f4 <printint>
        i += 2;
 74e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 750:	8bca                	mv	s7,s2
      state = 0;
 752:	4981                	li	s3,0
        i += 2;
 754:	bd49                	j	5e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 756:	008b8913          	addi	s2,s7,8
 75a:	4681                	li	a3,0
 75c:	4641                	li	a2,16
 75e:	000ba583          	lw	a1,0(s7)
 762:	855a                	mv	a0,s6
 764:	d91ff0ef          	jal	4f4 <printint>
 768:	8bca                	mv	s7,s2
      state = 0;
 76a:	4981                	li	s3,0
 76c:	bdad                	j	5e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 76e:	008b8913          	addi	s2,s7,8
 772:	4681                	li	a3,0
 774:	4641                	li	a2,16
 776:	000ba583          	lw	a1,0(s7)
 77a:	855a                	mv	a0,s6
 77c:	d79ff0ef          	jal	4f4 <printint>
        i += 1;
 780:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 782:	8bca                	mv	s7,s2
      state = 0;
 784:	4981                	li	s3,0
        i += 1;
 786:	b585                	j	5e6 <vprintf+0x4a>
 788:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 78a:	008b8d13          	addi	s10,s7,8
 78e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 792:	03000593          	li	a1,48
 796:	855a                	mv	a0,s6
 798:	d3fff0ef          	jal	4d6 <putc>
  putc(fd, 'x');
 79c:	07800593          	li	a1,120
 7a0:	855a                	mv	a0,s6
 7a2:	d35ff0ef          	jal	4d6 <putc>
 7a6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7a8:	00000b97          	auipc	s7,0x0
 7ac:	2a0b8b93          	addi	s7,s7,672 # a48 <digits>
 7b0:	03c9d793          	srli	a5,s3,0x3c
 7b4:	97de                	add	a5,a5,s7
 7b6:	0007c583          	lbu	a1,0(a5)
 7ba:	855a                	mv	a0,s6
 7bc:	d1bff0ef          	jal	4d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7c0:	0992                	slli	s3,s3,0x4
 7c2:	397d                	addiw	s2,s2,-1
 7c4:	fe0916e3          	bnez	s2,7b0 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7c8:	8bea                	mv	s7,s10
      state = 0;
 7ca:	4981                	li	s3,0
 7cc:	6d02                	ld	s10,0(sp)
 7ce:	bd21                	j	5e6 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7d0:	008b8993          	addi	s3,s7,8
 7d4:	000bb903          	ld	s2,0(s7)
 7d8:	00090f63          	beqz	s2,7f6 <vprintf+0x25a>
        for(; *s; s++)
 7dc:	00094583          	lbu	a1,0(s2)
 7e0:	c195                	beqz	a1,804 <vprintf+0x268>
          putc(fd, *s);
 7e2:	855a                	mv	a0,s6
 7e4:	cf3ff0ef          	jal	4d6 <putc>
        for(; *s; s++)
 7e8:	0905                	addi	s2,s2,1
 7ea:	00094583          	lbu	a1,0(s2)
 7ee:	f9f5                	bnez	a1,7e2 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7f0:	8bce                	mv	s7,s3
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	bbcd                	j	5e6 <vprintf+0x4a>
          s = "(null)";
 7f6:	00000917          	auipc	s2,0x0
 7fa:	24a90913          	addi	s2,s2,586 # a40 <malloc+0x13e>
        for(; *s; s++)
 7fe:	02800593          	li	a1,40
 802:	b7c5                	j	7e2 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 804:	8bce                	mv	s7,s3
      state = 0;
 806:	4981                	li	s3,0
 808:	bbf9                	j	5e6 <vprintf+0x4a>
 80a:	64a6                	ld	s1,72(sp)
 80c:	79e2                	ld	s3,56(sp)
 80e:	7a42                	ld	s4,48(sp)
 810:	7aa2                	ld	s5,40(sp)
 812:	7b02                	ld	s6,32(sp)
 814:	6be2                	ld	s7,24(sp)
 816:	6c42                	ld	s8,16(sp)
 818:	6ca2                	ld	s9,8(sp)
    }
  }
}
 81a:	60e6                	ld	ra,88(sp)
 81c:	6446                	ld	s0,80(sp)
 81e:	6906                	ld	s2,64(sp)
 820:	6125                	addi	sp,sp,96
 822:	8082                	ret

0000000000000824 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 824:	715d                	addi	sp,sp,-80
 826:	ec06                	sd	ra,24(sp)
 828:	e822                	sd	s0,16(sp)
 82a:	1000                	addi	s0,sp,32
 82c:	e010                	sd	a2,0(s0)
 82e:	e414                	sd	a3,8(s0)
 830:	e818                	sd	a4,16(s0)
 832:	ec1c                	sd	a5,24(s0)
 834:	03043023          	sd	a6,32(s0)
 838:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 83c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 840:	8622                	mv	a2,s0
 842:	d5bff0ef          	jal	59c <vprintf>
}
 846:	60e2                	ld	ra,24(sp)
 848:	6442                	ld	s0,16(sp)
 84a:	6161                	addi	sp,sp,80
 84c:	8082                	ret

000000000000084e <printf>:

void
printf(const char *fmt, ...)
{
 84e:	711d                	addi	sp,sp,-96
 850:	ec06                	sd	ra,24(sp)
 852:	e822                	sd	s0,16(sp)
 854:	1000                	addi	s0,sp,32
 856:	e40c                	sd	a1,8(s0)
 858:	e810                	sd	a2,16(s0)
 85a:	ec14                	sd	a3,24(s0)
 85c:	f018                	sd	a4,32(s0)
 85e:	f41c                	sd	a5,40(s0)
 860:	03043823          	sd	a6,48(s0)
 864:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 868:	00840613          	addi	a2,s0,8
 86c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 870:	85aa                	mv	a1,a0
 872:	4505                	li	a0,1
 874:	d29ff0ef          	jal	59c <vprintf>
}
 878:	60e2                	ld	ra,24(sp)
 87a:	6442                	ld	s0,16(sp)
 87c:	6125                	addi	sp,sp,96
 87e:	8082                	ret

0000000000000880 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 880:	1141                	addi	sp,sp,-16
 882:	e422                	sd	s0,8(sp)
 884:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 886:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88a:	00000797          	auipc	a5,0x0
 88e:	7767b783          	ld	a5,1910(a5) # 1000 <freep>
 892:	a02d                	j	8bc <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 894:	4618                	lw	a4,8(a2)
 896:	9f2d                	addw	a4,a4,a1
 898:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 89c:	6398                	ld	a4,0(a5)
 89e:	6310                	ld	a2,0(a4)
 8a0:	a83d                	j	8de <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8a2:	ff852703          	lw	a4,-8(a0)
 8a6:	9f31                	addw	a4,a4,a2
 8a8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8aa:	ff053683          	ld	a3,-16(a0)
 8ae:	a091                	j	8f2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b0:	6398                	ld	a4,0(a5)
 8b2:	00e7e463          	bltu	a5,a4,8ba <free+0x3a>
 8b6:	00e6ea63          	bltu	a3,a4,8ca <free+0x4a>
{
 8ba:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8bc:	fed7fae3          	bgeu	a5,a3,8b0 <free+0x30>
 8c0:	6398                	ld	a4,0(a5)
 8c2:	00e6e463          	bltu	a3,a4,8ca <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c6:	fee7eae3          	bltu	a5,a4,8ba <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8ca:	ff852583          	lw	a1,-8(a0)
 8ce:	6390                	ld	a2,0(a5)
 8d0:	02059813          	slli	a6,a1,0x20
 8d4:	01c85713          	srli	a4,a6,0x1c
 8d8:	9736                	add	a4,a4,a3
 8da:	fae60de3          	beq	a2,a4,894 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8de:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8e2:	4790                	lw	a2,8(a5)
 8e4:	02061593          	slli	a1,a2,0x20
 8e8:	01c5d713          	srli	a4,a1,0x1c
 8ec:	973e                	add	a4,a4,a5
 8ee:	fae68ae3          	beq	a3,a4,8a2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8f2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8f4:	00000717          	auipc	a4,0x0
 8f8:	70f73623          	sd	a5,1804(a4) # 1000 <freep>
}
 8fc:	6422                	ld	s0,8(sp)
 8fe:	0141                	addi	sp,sp,16
 900:	8082                	ret

0000000000000902 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 902:	7139                	addi	sp,sp,-64
 904:	fc06                	sd	ra,56(sp)
 906:	f822                	sd	s0,48(sp)
 908:	f426                	sd	s1,40(sp)
 90a:	ec4e                	sd	s3,24(sp)
 90c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 90e:	02051493          	slli	s1,a0,0x20
 912:	9081                	srli	s1,s1,0x20
 914:	04bd                	addi	s1,s1,15
 916:	8091                	srli	s1,s1,0x4
 918:	0014899b          	addiw	s3,s1,1
 91c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 91e:	00000517          	auipc	a0,0x0
 922:	6e253503          	ld	a0,1762(a0) # 1000 <freep>
 926:	c915                	beqz	a0,95a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 928:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 92a:	4798                	lw	a4,8(a5)
 92c:	08977a63          	bgeu	a4,s1,9c0 <malloc+0xbe>
 930:	f04a                	sd	s2,32(sp)
 932:	e852                	sd	s4,16(sp)
 934:	e456                	sd	s5,8(sp)
 936:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 938:	8a4e                	mv	s4,s3
 93a:	0009871b          	sext.w	a4,s3
 93e:	6685                	lui	a3,0x1
 940:	00d77363          	bgeu	a4,a3,946 <malloc+0x44>
 944:	6a05                	lui	s4,0x1
 946:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 94a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 94e:	00000917          	auipc	s2,0x0
 952:	6b290913          	addi	s2,s2,1714 # 1000 <freep>
  if(p == (char*)-1)
 956:	5afd                	li	s5,-1
 958:	a081                	j	998 <malloc+0x96>
 95a:	f04a                	sd	s2,32(sp)
 95c:	e852                	sd	s4,16(sp)
 95e:	e456                	sd	s5,8(sp)
 960:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 962:	00000797          	auipc	a5,0x0
 966:	6ae78793          	addi	a5,a5,1710 # 1010 <base>
 96a:	00000717          	auipc	a4,0x0
 96e:	68f73b23          	sd	a5,1686(a4) # 1000 <freep>
 972:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 974:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 978:	b7c1                	j	938 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 97a:	6398                	ld	a4,0(a5)
 97c:	e118                	sd	a4,0(a0)
 97e:	a8a9                	j	9d8 <malloc+0xd6>
  hp->s.size = nu;
 980:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 984:	0541                	addi	a0,a0,16
 986:	efbff0ef          	jal	880 <free>
  return freep;
 98a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 98e:	c12d                	beqz	a0,9f0 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 990:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 992:	4798                	lw	a4,8(a5)
 994:	02977263          	bgeu	a4,s1,9b8 <malloc+0xb6>
    if(p == freep)
 998:	00093703          	ld	a4,0(s2)
 99c:	853e                	mv	a0,a5
 99e:	fef719e3          	bne	a4,a5,990 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9a2:	8552                	mv	a0,s4
 9a4:	ad3ff0ef          	jal	476 <sbrk>
  if(p == (char*)-1)
 9a8:	fd551ce3          	bne	a0,s5,980 <malloc+0x7e>
        return 0;
 9ac:	4501                	li	a0,0
 9ae:	7902                	ld	s2,32(sp)
 9b0:	6a42                	ld	s4,16(sp)
 9b2:	6aa2                	ld	s5,8(sp)
 9b4:	6b02                	ld	s6,0(sp)
 9b6:	a03d                	j	9e4 <malloc+0xe2>
 9b8:	7902                	ld	s2,32(sp)
 9ba:	6a42                	ld	s4,16(sp)
 9bc:	6aa2                	ld	s5,8(sp)
 9be:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9c0:	fae48de3          	beq	s1,a4,97a <malloc+0x78>
        p->s.size -= nunits;
 9c4:	4137073b          	subw	a4,a4,s3
 9c8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9ca:	02071693          	slli	a3,a4,0x20
 9ce:	01c6d713          	srli	a4,a3,0x1c
 9d2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9d4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9d8:	00000717          	auipc	a4,0x0
 9dc:	62a73423          	sd	a0,1576(a4) # 1000 <freep>
      return (void*)(p + 1);
 9e0:	01078513          	addi	a0,a5,16
  }
}
 9e4:	70e2                	ld	ra,56(sp)
 9e6:	7442                	ld	s0,48(sp)
 9e8:	74a2                	ld	s1,40(sp)
 9ea:	69e2                	ld	s3,24(sp)
 9ec:	6121                	addi	sp,sp,64
 9ee:	8082                	ret
 9f0:	7902                	ld	s2,32(sp)
 9f2:	6a42                	ld	s4,16(sp)
 9f4:	6aa2                	ld	s5,8(sp)
 9f6:	6b02                	ld	s6,0(sp)
 9f8:	b7f5                	j	9e4 <malloc+0xe2>
