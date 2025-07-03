
user/_mkdir：     文件格式 elf64-littleriscv


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
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7d763          	bge	a5,a0,38 <main+0x38>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	440000ef          	jal	468 <mkdir>
  2c:	02054263          	bltz	a0,50 <main+0x50>
  for(i = 1; i < argc; i++){
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  36:	a02d                	j	60 <main+0x60>
  38:	e426                	sd	s1,8(sp)
  3a:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: mkdir files...\n");
  3c:	00001597          	auipc	a1,0x1
  40:	9d458593          	addi	a1,a1,-1580 # a10 <malloc+0xfc>
  44:	4509                	li	a0,2
  46:	7f0000ef          	jal	836 <fprintf>
    exit(1);
  4a:	4505                	li	a0,1
  4c:	3b4000ef          	jal	400 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  50:	6090                	ld	a2,0(s1)
  52:	00001597          	auipc	a1,0x1
  56:	9d658593          	addi	a1,a1,-1578 # a28 <malloc+0x114>
  5a:	4509                	li	a0,2
  5c:	7da000ef          	jal	836 <fprintf>
      break;
    }
  }

  exit(0);
  60:	4501                	li	a0,0
  62:	39e000ef          	jal	400 <exit>

0000000000000066 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  66:	1141                	addi	sp,sp,-16
  68:	e406                	sd	ra,8(sp)
  6a:	e022                	sd	s0,0(sp)
  6c:	0800                	addi	s0,sp,16
  extern int main();
  main();
  6e:	f93ff0ef          	jal	0 <main>
  exit(0);
  72:	4501                	li	a0,0
  74:	38c000ef          	jal	400 <exit>

0000000000000078 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7e:	87aa                	mv	a5,a0
  80:	0585                	addi	a1,a1,1
  82:	0785                	addi	a5,a5,1
  84:	fff5c703          	lbu	a4,-1(a1)
  88:	fee78fa3          	sb	a4,-1(a5)
  8c:	fb75                	bnez	a4,80 <strcpy+0x8>
    ;
  return os;
}
  8e:	6422                	ld	s0,8(sp)
  90:	0141                	addi	sp,sp,16
  92:	8082                	ret

0000000000000094 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  94:	1141                	addi	sp,sp,-16
  96:	e422                	sd	s0,8(sp)
  98:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	cb91                	beqz	a5,b2 <strcmp+0x1e>
  a0:	0005c703          	lbu	a4,0(a1)
  a4:	00f71763          	bne	a4,a5,b2 <strcmp+0x1e>
    p++, q++;
  a8:	0505                	addi	a0,a0,1
  aa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ac:	00054783          	lbu	a5,0(a0)
  b0:	fbe5                	bnez	a5,a0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  b2:	0005c503          	lbu	a0,0(a1)
}
  b6:	40a7853b          	subw	a0,a5,a0
  ba:	6422                	ld	s0,8(sp)
  bc:	0141                	addi	sp,sp,16
  be:	8082                	ret

00000000000000c0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  c0:	1141                	addi	sp,sp,-16
  c2:	e422                	sd	s0,8(sp)
  c4:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q) {
  c6:	ce11                	beqz	a2,e2 <strncmp+0x22>
  c8:	00054783          	lbu	a5,0(a0)
  cc:	cf89                	beqz	a5,e6 <strncmp+0x26>
  ce:	0005c703          	lbu	a4,0(a1)
  d2:	00f71a63          	bne	a4,a5,e6 <strncmp+0x26>
    n--;
  d6:	367d                	addiw	a2,a2,-1
    p++;
  d8:	0505                	addi	a0,a0,1
    q++;
  da:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q) {
  dc:	f675                	bnez	a2,c8 <strncmp+0x8>
  }
  if(n == 0)
    return 0;
  de:	4501                	li	a0,0
  e0:	a801                	j	f0 <strncmp+0x30>
  e2:	4501                	li	a0,0
  e4:	a031                	j	f0 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
  e6:	00054503          	lbu	a0,0(a0)
  ea:	0005c783          	lbu	a5,0(a1)
  ee:	9d1d                	subw	a0,a0,a5
}
  f0:	6422                	ld	s0,8(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret

00000000000000f6 <strlen>:

uint
strlen(const char *s)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  fc:	00054783          	lbu	a5,0(a0)
 100:	cf91                	beqz	a5,11c <strlen+0x26>
 102:	0505                	addi	a0,a0,1
 104:	87aa                	mv	a5,a0
 106:	86be                	mv	a3,a5
 108:	0785                	addi	a5,a5,1
 10a:	fff7c703          	lbu	a4,-1(a5)
 10e:	ff65                	bnez	a4,106 <strlen+0x10>
 110:	40a6853b          	subw	a0,a3,a0
 114:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 116:	6422                	ld	s0,8(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret
  for(n = 0; s[n]; n++)
 11c:	4501                	li	a0,0
 11e:	bfe5                	j	116 <strlen+0x20>

0000000000000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	1141                	addi	sp,sp,-16
 122:	e422                	sd	s0,8(sp)
 124:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 126:	ca19                	beqz	a2,13c <memset+0x1c>
 128:	87aa                	mv	a5,a0
 12a:	1602                	slli	a2,a2,0x20
 12c:	9201                	srli	a2,a2,0x20
 12e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 132:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 136:	0785                	addi	a5,a5,1
 138:	fee79de3          	bne	a5,a4,132 <memset+0x12>
  }
  return dst;
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret

0000000000000142 <strchr>:

char*
strchr(const char *s, char c)
{
 142:	1141                	addi	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	addi	s0,sp,16
  for(; *s; s++)
 148:	00054783          	lbu	a5,0(a0)
 14c:	cb99                	beqz	a5,162 <strchr+0x20>
    if(*s == c)
 14e:	00f58763          	beq	a1,a5,15c <strchr+0x1a>
  for(; *s; s++)
 152:	0505                	addi	a0,a0,1
 154:	00054783          	lbu	a5,0(a0)
 158:	fbfd                	bnez	a5,14e <strchr+0xc>
      return (char*)s;
  return 0;
 15a:	4501                	li	a0,0
}
 15c:	6422                	ld	s0,8(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret
  return 0;
 162:	4501                	li	a0,0
 164:	bfe5                	j	15c <strchr+0x1a>

0000000000000166 <gets>:

char*
gets(char *buf, int max)
{
 166:	711d                	addi	sp,sp,-96
 168:	ec86                	sd	ra,88(sp)
 16a:	e8a2                	sd	s0,80(sp)
 16c:	e4a6                	sd	s1,72(sp)
 16e:	e0ca                	sd	s2,64(sp)
 170:	fc4e                	sd	s3,56(sp)
 172:	f852                	sd	s4,48(sp)
 174:	f456                	sd	s5,40(sp)
 176:	f05a                	sd	s6,32(sp)
 178:	ec5e                	sd	s7,24(sp)
 17a:	1080                	addi	s0,sp,96
 17c:	8baa                	mv	s7,a0
 17e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 180:	892a                	mv	s2,a0
 182:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 184:	4aa9                	li	s5,10
 186:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 188:	89a6                	mv	s3,s1
 18a:	2485                	addiw	s1,s1,1
 18c:	0344d663          	bge	s1,s4,1b8 <gets+0x52>
    cc = read(0, &c, 1);
 190:	4605                	li	a2,1
 192:	faf40593          	addi	a1,s0,-81
 196:	4501                	li	a0,0
 198:	280000ef          	jal	418 <read>
    if(cc < 1)
 19c:	00a05e63          	blez	a0,1b8 <gets+0x52>
    buf[i++] = c;
 1a0:	faf44783          	lbu	a5,-81(s0)
 1a4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1a8:	01578763          	beq	a5,s5,1b6 <gets+0x50>
 1ac:	0905                	addi	s2,s2,1
 1ae:	fd679de3          	bne	a5,s6,188 <gets+0x22>
    buf[i++] = c;
 1b2:	89a6                	mv	s3,s1
 1b4:	a011                	j	1b8 <gets+0x52>
 1b6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1b8:	99de                	add	s3,s3,s7
 1ba:	00098023          	sb	zero,0(s3)
  return buf;
}
 1be:	855e                	mv	a0,s7
 1c0:	60e6                	ld	ra,88(sp)
 1c2:	6446                	ld	s0,80(sp)
 1c4:	64a6                	ld	s1,72(sp)
 1c6:	6906                	ld	s2,64(sp)
 1c8:	79e2                	ld	s3,56(sp)
 1ca:	7a42                	ld	s4,48(sp)
 1cc:	7aa2                	ld	s5,40(sp)
 1ce:	7b02                	ld	s6,32(sp)
 1d0:	6be2                	ld	s7,24(sp)
 1d2:	6125                	addi	sp,sp,96
 1d4:	8082                	ret

00000000000001d6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d6:	1101                	addi	sp,sp,-32
 1d8:	ec06                	sd	ra,24(sp)
 1da:	e822                	sd	s0,16(sp)
 1dc:	e04a                	sd	s2,0(sp)
 1de:	1000                	addi	s0,sp,32
 1e0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e2:	4581                	li	a1,0
 1e4:	25c000ef          	jal	440 <open>
  if(fd < 0)
 1e8:	02054263          	bltz	a0,20c <stat+0x36>
 1ec:	e426                	sd	s1,8(sp)
 1ee:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f0:	85ca                	mv	a1,s2
 1f2:	266000ef          	jal	458 <fstat>
 1f6:	892a                	mv	s2,a0
  close(fd);
 1f8:	8526                	mv	a0,s1
 1fa:	22e000ef          	jal	428 <close>
  return r;
 1fe:	64a2                	ld	s1,8(sp)
}
 200:	854a                	mv	a0,s2
 202:	60e2                	ld	ra,24(sp)
 204:	6442                	ld	s0,16(sp)
 206:	6902                	ld	s2,0(sp)
 208:	6105                	addi	sp,sp,32
 20a:	8082                	ret
    return -1;
 20c:	597d                	li	s2,-1
 20e:	bfcd                	j	200 <stat+0x2a>

0000000000000210 <atoi>:

int
atoi(const char *s)
{
 210:	1141                	addi	sp,sp,-16
 212:	e422                	sd	s0,8(sp)
 214:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 216:	00054683          	lbu	a3,0(a0)
 21a:	fd06879b          	addiw	a5,a3,-48
 21e:	0ff7f793          	zext.b	a5,a5
 222:	4625                	li	a2,9
 224:	02f66863          	bltu	a2,a5,254 <atoi+0x44>
 228:	872a                	mv	a4,a0
  n = 0;
 22a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 22c:	0705                	addi	a4,a4,1
 22e:	0025179b          	slliw	a5,a0,0x2
 232:	9fa9                	addw	a5,a5,a0
 234:	0017979b          	slliw	a5,a5,0x1
 238:	9fb5                	addw	a5,a5,a3
 23a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 23e:	00074683          	lbu	a3,0(a4)
 242:	fd06879b          	addiw	a5,a3,-48
 246:	0ff7f793          	zext.b	a5,a5
 24a:	fef671e3          	bgeu	a2,a5,22c <atoi+0x1c>
  return n;
}
 24e:	6422                	ld	s0,8(sp)
 250:	0141                	addi	sp,sp,16
 252:	8082                	ret
  n = 0;
 254:	4501                	li	a0,0
 256:	bfe5                	j	24e <atoi+0x3e>

0000000000000258 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 258:	1141                	addi	sp,sp,-16
 25a:	e422                	sd	s0,8(sp)
 25c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 25e:	02b57463          	bgeu	a0,a1,286 <memmove+0x2e>
    while(n-- > 0)
 262:	00c05f63          	blez	a2,280 <memmove+0x28>
 266:	1602                	slli	a2,a2,0x20
 268:	9201                	srli	a2,a2,0x20
 26a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 26e:	872a                	mv	a4,a0
      *dst++ = *src++;
 270:	0585                	addi	a1,a1,1
 272:	0705                	addi	a4,a4,1
 274:	fff5c683          	lbu	a3,-1(a1)
 278:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 27c:	fef71ae3          	bne	a4,a5,270 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 280:	6422                	ld	s0,8(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret
    dst += n;
 286:	00c50733          	add	a4,a0,a2
    src += n;
 28a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 28c:	fec05ae3          	blez	a2,280 <memmove+0x28>
 290:	fff6079b          	addiw	a5,a2,-1
 294:	1782                	slli	a5,a5,0x20
 296:	9381                	srli	a5,a5,0x20
 298:	fff7c793          	not	a5,a5
 29c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 29e:	15fd                	addi	a1,a1,-1
 2a0:	177d                	addi	a4,a4,-1
 2a2:	0005c683          	lbu	a3,0(a1)
 2a6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2aa:	fee79ae3          	bne	a5,a4,29e <memmove+0x46>
 2ae:	bfc9                	j	280 <memmove+0x28>

00000000000002b0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e422                	sd	s0,8(sp)
 2b4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b6:	ca05                	beqz	a2,2e6 <memcmp+0x36>
 2b8:	fff6069b          	addiw	a3,a2,-1
 2bc:	1682                	slli	a3,a3,0x20
 2be:	9281                	srli	a3,a3,0x20
 2c0:	0685                	addi	a3,a3,1
 2c2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	0005c703          	lbu	a4,0(a1)
 2cc:	00e79863          	bne	a5,a4,2dc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2d0:	0505                	addi	a0,a0,1
    p2++;
 2d2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d4:	fed518e3          	bne	a0,a3,2c4 <memcmp+0x14>
  }
  return 0;
 2d8:	4501                	li	a0,0
 2da:	a019                	j	2e0 <memcmp+0x30>
      return *p1 - *p2;
 2dc:	40e7853b          	subw	a0,a5,a4
}
 2e0:	6422                	ld	s0,8(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret
  return 0;
 2e6:	4501                	li	a0,0
 2e8:	bfe5                	j	2e0 <memcmp+0x30>

00000000000002ea <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f2:	f67ff0ef          	jal	258 <memmove>
}
 2f6:	60a2                	ld	ra,8(sp)
 2f8:	6402                	ld	s0,0(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret

00000000000002fe <simplesort>:

void
simplesort(void *base, uint nmemb, uint size, int (*compar)(const void *, const void *))
{
 2fe:	7119                	addi	sp,sp,-128
 300:	fc86                	sd	ra,120(sp)
 302:	f8a2                	sd	s0,112(sp)
 304:	0100                	addi	s0,sp,128
 306:	f8b43423          	sd	a1,-120(s0)
  char *arr = (char *)base; // Treat array as char array for byte-level manipulation
  char *temp;               // Temporary storage for an element

  if (nmemb <= 1 || size == 0) {
 30a:	4785                	li	a5,1
 30c:	00b7fc63          	bgeu	a5,a1,324 <simplesort+0x26>
 310:	e8d2                	sd	s4,80(sp)
 312:	e4d6                	sd	s5,72(sp)
 314:	f466                	sd	s9,40(sp)
 316:	8aaa                	mv	s5,a0
 318:	8a32                	mv	s4,a2
 31a:	8cb6                	mv	s9,a3
 31c:	ea01                	bnez	a2,32c <simplesort+0x2e>
 31e:	6a46                	ld	s4,80(sp)
 320:	6aa6                	ld	s5,72(sp)
 322:	7ca2                	ld	s9,40(sp)
    // Place temp at its correct position
    memmove(arr + j * size, temp, size);
  }

  free(temp); // Free temporary space
 324:	70e6                	ld	ra,120(sp)
 326:	7446                	ld	s0,112(sp)
 328:	6109                	addi	sp,sp,128
 32a:	8082                	ret
 32c:	fc5e                	sd	s7,56(sp)
 32e:	f862                	sd	s8,48(sp)
 330:	f06a                	sd	s10,32(sp)
 332:	ec6e                	sd	s11,24(sp)
  temp = malloc(size); // Allocate temporary space for one element
 334:	8532                	mv	a0,a2
 336:	5de000ef          	jal	914 <malloc>
 33a:	8baa                	mv	s7,a0
  if (temp == 0) {
 33c:	4d81                	li	s11,0
  for (uint i = 1; i < nmemb; i++) {
 33e:	4d05                	li	s10,1
    memmove(temp, arr + i * size, size);
 340:	000a0c1b          	sext.w	s8,s4
  if (temp == 0) {
 344:	c511                	beqz	a0,350 <simplesort+0x52>
 346:	f4a6                	sd	s1,104(sp)
 348:	f0ca                	sd	s2,96(sp)
 34a:	ecce                	sd	s3,88(sp)
 34c:	e0da                	sd	s6,64(sp)
 34e:	a82d                	j	388 <simplesort+0x8a>
    printf("simplesort: malloc failed, cannot sort\n");
 350:	00000517          	auipc	a0,0x0
 354:	6f850513          	addi	a0,a0,1784 # a48 <malloc+0x134>
 358:	508000ef          	jal	860 <printf>
    return;
 35c:	6a46                	ld	s4,80(sp)
 35e:	6aa6                	ld	s5,72(sp)
 360:	7be2                	ld	s7,56(sp)
 362:	7c42                	ld	s8,48(sp)
 364:	7ca2                	ld	s9,40(sp)
 366:	7d02                	ld	s10,32(sp)
 368:	6de2                	ld	s11,24(sp)
 36a:	bf6d                	j	324 <simplesort+0x26>
    memmove(arr + j * size, temp, size);
 36c:	036a053b          	mulw	a0,s4,s6
 370:	1502                	slli	a0,a0,0x20
 372:	9101                	srli	a0,a0,0x20
 374:	8662                	mv	a2,s8
 376:	85de                	mv	a1,s7
 378:	9556                	add	a0,a0,s5
 37a:	edfff0ef          	jal	258 <memmove>
  for (uint i = 1; i < nmemb; i++) {
 37e:	2d05                	addiw	s10,s10,1
 380:	f8843783          	ld	a5,-120(s0)
 384:	05a78b63          	beq	a5,s10,3da <simplesort+0xdc>
    memmove(temp, arr + i * size, size);
 388:	000d899b          	sext.w	s3,s11
 38c:	01ba05bb          	addw	a1,s4,s11
 390:	00058d9b          	sext.w	s11,a1
 394:	1582                	slli	a1,a1,0x20
 396:	9181                	srli	a1,a1,0x20
 398:	8662                	mv	a2,s8
 39a:	95d6                	add	a1,a1,s5
 39c:	855e                	mv	a0,s7
 39e:	ebbff0ef          	jal	258 <memmove>
    uint j = i;
 3a2:	896a                	mv	s2,s10
 3a4:	00090b1b          	sext.w	s6,s2
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 3a8:	397d                	addiw	s2,s2,-1
 3aa:	02099493          	slli	s1,s3,0x20
 3ae:	9081                	srli	s1,s1,0x20
 3b0:	94d6                	add	s1,s1,s5
 3b2:	85de                	mv	a1,s7
 3b4:	8526                	mv	a0,s1
 3b6:	9c82                	jalr	s9
 3b8:	faa05ae3          	blez	a0,36c <simplesort+0x6e>
      memmove(arr + j * size, arr + (j - 1) * size, size); // Shift element
 3bc:	0149853b          	addw	a0,s3,s4
 3c0:	1502                	slli	a0,a0,0x20
 3c2:	9101                	srli	a0,a0,0x20
 3c4:	8662                	mv	a2,s8
 3c6:	85a6                	mv	a1,s1
 3c8:	9556                	add	a0,a0,s5
 3ca:	e8fff0ef          	jal	258 <memmove>
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 3ce:	414989bb          	subw	s3,s3,s4
 3d2:	fc0919e3          	bnez	s2,3a4 <simplesort+0xa6>
 3d6:	8b4a                	mv	s6,s2
 3d8:	bf51                	j	36c <simplesort+0x6e>
  free(temp); // Free temporary space
 3da:	855e                	mv	a0,s7
 3dc:	4b6000ef          	jal	892 <free>
 3e0:	74a6                	ld	s1,104(sp)
 3e2:	7906                	ld	s2,96(sp)
 3e4:	69e6                	ld	s3,88(sp)
 3e6:	6a46                	ld	s4,80(sp)
 3e8:	6aa6                	ld	s5,72(sp)
 3ea:	6b06                	ld	s6,64(sp)
 3ec:	7be2                	ld	s7,56(sp)
 3ee:	7c42                	ld	s8,48(sp)
 3f0:	7ca2                	ld	s9,40(sp)
 3f2:	7d02                	ld	s10,32(sp)
 3f4:	6de2                	ld	s11,24(sp)
 3f6:	b73d                	j	324 <simplesort+0x26>

00000000000003f8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3f8:	4885                	li	a7,1
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <exit>:
.global exit
exit:
 li a7, SYS_exit
 400:	4889                	li	a7,2
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <wait>:
.global wait
wait:
 li a7, SYS_wait
 408:	488d                	li	a7,3
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 410:	4891                	li	a7,4
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <read>:
.global read
read:
 li a7, SYS_read
 418:	4895                	li	a7,5
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <write>:
.global write
write:
 li a7, SYS_write
 420:	48c1                	li	a7,16
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <close>:
.global close
close:
 li a7, SYS_close
 428:	48d5                	li	a7,21
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <kill>:
.global kill
kill:
 li a7, SYS_kill
 430:	4899                	li	a7,6
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <exec>:
.global exec
exec:
 li a7, SYS_exec
 438:	489d                	li	a7,7
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <open>:
.global open
open:
 li a7, SYS_open
 440:	48bd                	li	a7,15
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 448:	48c5                	li	a7,17
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 450:	48c9                	li	a7,18
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 458:	48a1                	li	a7,8
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <link>:
.global link
link:
 li a7, SYS_link
 460:	48cd                	li	a7,19
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 468:	48d1                	li	a7,20
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 470:	48a5                	li	a7,9
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <dup>:
.global dup
dup:
 li a7, SYS_dup
 478:	48a9                	li	a7,10
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 480:	48ad                	li	a7,11
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 488:	48b1                	li	a7,12
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 490:	48b5                	li	a7,13
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 498:	48b9                	li	a7,14
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 4a0:	48dd                	li	a7,23
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <statistics>:
.global statistics
statistics:
 li a7, SYS_statistics
 4a8:	48e1                	li	a7,24
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <reset_stats>:
.global reset_stats
reset_stats:
 li a7, SYS_reset_stats
 4b0:	48e5                	li	a7,25
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <resetlockstats>:
.global resetlockstats
resetlockstats:
 li a7, SYS_resetlockstats
 4b8:	48e9                	li	a7,26
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <getlockstats>:
.global getlockstats
getlockstats:
 li a7, SYS_getlockstats
 4c0:	48ed                	li	a7,27
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <trace>:
.global trace
trace:
 li a7, SYS_trace
 4c8:	48d9                	li	a7,22
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 4d0:	48f1                	li	a7,28
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <ugetpid>:
.global ugetpid
ugetpid:
 li a7, SYS_ugetpid
 4d8:	48f5                	li	a7,29
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 4e0:	48f9                	li	a7,30
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4e8:	1101                	addi	sp,sp,-32
 4ea:	ec06                	sd	ra,24(sp)
 4ec:	e822                	sd	s0,16(sp)
 4ee:	1000                	addi	s0,sp,32
 4f0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4f4:	4605                	li	a2,1
 4f6:	fef40593          	addi	a1,s0,-17
 4fa:	f27ff0ef          	jal	420 <write>
}
 4fe:	60e2                	ld	ra,24(sp)
 500:	6442                	ld	s0,16(sp)
 502:	6105                	addi	sp,sp,32
 504:	8082                	ret

0000000000000506 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 506:	7139                	addi	sp,sp,-64
 508:	fc06                	sd	ra,56(sp)
 50a:	f822                	sd	s0,48(sp)
 50c:	f426                	sd	s1,40(sp)
 50e:	0080                	addi	s0,sp,64
 510:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 512:	c299                	beqz	a3,518 <printint+0x12>
 514:	0805c963          	bltz	a1,5a6 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 518:	2581                	sext.w	a1,a1
  neg = 0;
 51a:	4881                	li	a7,0
 51c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 520:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 522:	2601                	sext.w	a2,a2
 524:	00000517          	auipc	a0,0x0
 528:	55450513          	addi	a0,a0,1364 # a78 <digits>
 52c:	883a                	mv	a6,a4
 52e:	2705                	addiw	a4,a4,1
 530:	02c5f7bb          	remuw	a5,a1,a2
 534:	1782                	slli	a5,a5,0x20
 536:	9381                	srli	a5,a5,0x20
 538:	97aa                	add	a5,a5,a0
 53a:	0007c783          	lbu	a5,0(a5)
 53e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 542:	0005879b          	sext.w	a5,a1
 546:	02c5d5bb          	divuw	a1,a1,a2
 54a:	0685                	addi	a3,a3,1
 54c:	fec7f0e3          	bgeu	a5,a2,52c <printint+0x26>
  if(neg)
 550:	00088c63          	beqz	a7,568 <printint+0x62>
    buf[i++] = '-';
 554:	fd070793          	addi	a5,a4,-48
 558:	00878733          	add	a4,a5,s0
 55c:	02d00793          	li	a5,45
 560:	fef70823          	sb	a5,-16(a4)
 564:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 568:	02e05a63          	blez	a4,59c <printint+0x96>
 56c:	f04a                	sd	s2,32(sp)
 56e:	ec4e                	sd	s3,24(sp)
 570:	fc040793          	addi	a5,s0,-64
 574:	00e78933          	add	s2,a5,a4
 578:	fff78993          	addi	s3,a5,-1
 57c:	99ba                	add	s3,s3,a4
 57e:	377d                	addiw	a4,a4,-1
 580:	1702                	slli	a4,a4,0x20
 582:	9301                	srli	a4,a4,0x20
 584:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 588:	fff94583          	lbu	a1,-1(s2)
 58c:	8526                	mv	a0,s1
 58e:	f5bff0ef          	jal	4e8 <putc>
  while(--i >= 0)
 592:	197d                	addi	s2,s2,-1
 594:	ff391ae3          	bne	s2,s3,588 <printint+0x82>
 598:	7902                	ld	s2,32(sp)
 59a:	69e2                	ld	s3,24(sp)
}
 59c:	70e2                	ld	ra,56(sp)
 59e:	7442                	ld	s0,48(sp)
 5a0:	74a2                	ld	s1,40(sp)
 5a2:	6121                	addi	sp,sp,64
 5a4:	8082                	ret
    x = -xx;
 5a6:	40b005bb          	negw	a1,a1
    neg = 1;
 5aa:	4885                	li	a7,1
    x = -xx;
 5ac:	bf85                	j	51c <printint+0x16>

00000000000005ae <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5ae:	711d                	addi	sp,sp,-96
 5b0:	ec86                	sd	ra,88(sp)
 5b2:	e8a2                	sd	s0,80(sp)
 5b4:	e0ca                	sd	s2,64(sp)
 5b6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5b8:	0005c903          	lbu	s2,0(a1)
 5bc:	26090863          	beqz	s2,82c <vprintf+0x27e>
 5c0:	e4a6                	sd	s1,72(sp)
 5c2:	fc4e                	sd	s3,56(sp)
 5c4:	f852                	sd	s4,48(sp)
 5c6:	f456                	sd	s5,40(sp)
 5c8:	f05a                	sd	s6,32(sp)
 5ca:	ec5e                	sd	s7,24(sp)
 5cc:	e862                	sd	s8,16(sp)
 5ce:	e466                	sd	s9,8(sp)
 5d0:	8b2a                	mv	s6,a0
 5d2:	8a2e                	mv	s4,a1
 5d4:	8bb2                	mv	s7,a2
  state = 0;
 5d6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5d8:	4481                	li	s1,0
 5da:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5dc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5e0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5e4:	06c00c93          	li	s9,108
 5e8:	a005                	j	608 <vprintf+0x5a>
        putc(fd, c0);
 5ea:	85ca                	mv	a1,s2
 5ec:	855a                	mv	a0,s6
 5ee:	efbff0ef          	jal	4e8 <putc>
 5f2:	a019                	j	5f8 <vprintf+0x4a>
    } else if(state == '%'){
 5f4:	03598263          	beq	s3,s5,618 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5f8:	2485                	addiw	s1,s1,1
 5fa:	8726                	mv	a4,s1
 5fc:	009a07b3          	add	a5,s4,s1
 600:	0007c903          	lbu	s2,0(a5)
 604:	20090c63          	beqz	s2,81c <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 608:	0009079b          	sext.w	a5,s2
    if(state == 0){
 60c:	fe0994e3          	bnez	s3,5f4 <vprintf+0x46>
      if(c0 == '%'){
 610:	fd579de3          	bne	a5,s5,5ea <vprintf+0x3c>
        state = '%';
 614:	89be                	mv	s3,a5
 616:	b7cd                	j	5f8 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 618:	00ea06b3          	add	a3,s4,a4
 61c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 620:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 622:	c681                	beqz	a3,62a <vprintf+0x7c>
 624:	9752                	add	a4,a4,s4
 626:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 62a:	03878f63          	beq	a5,s8,668 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 62e:	05978963          	beq	a5,s9,680 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 632:	07500713          	li	a4,117
 636:	0ee78363          	beq	a5,a4,71c <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 63a:	07800713          	li	a4,120
 63e:	12e78563          	beq	a5,a4,768 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 642:	07000713          	li	a4,112
 646:	14e78a63          	beq	a5,a4,79a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 64a:	07300713          	li	a4,115
 64e:	18e78a63          	beq	a5,a4,7e2 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 652:	02500713          	li	a4,37
 656:	04e79563          	bne	a5,a4,6a0 <vprintf+0xf2>
        putc(fd, '%');
 65a:	02500593          	li	a1,37
 65e:	855a                	mv	a0,s6
 660:	e89ff0ef          	jal	4e8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 664:	4981                	li	s3,0
 666:	bf49                	j	5f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 668:	008b8913          	addi	s2,s7,8
 66c:	4685                	li	a3,1
 66e:	4629                	li	a2,10
 670:	000ba583          	lw	a1,0(s7)
 674:	855a                	mv	a0,s6
 676:	e91ff0ef          	jal	506 <printint>
 67a:	8bca                	mv	s7,s2
      state = 0;
 67c:	4981                	li	s3,0
 67e:	bfad                	j	5f8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 680:	06400793          	li	a5,100
 684:	02f68963          	beq	a3,a5,6b6 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 688:	06c00793          	li	a5,108
 68c:	04f68263          	beq	a3,a5,6d0 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 690:	07500793          	li	a5,117
 694:	0af68063          	beq	a3,a5,734 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 698:	07800793          	li	a5,120
 69c:	0ef68263          	beq	a3,a5,780 <vprintf+0x1d2>
        putc(fd, '%');
 6a0:	02500593          	li	a1,37
 6a4:	855a                	mv	a0,s6
 6a6:	e43ff0ef          	jal	4e8 <putc>
        putc(fd, c0);
 6aa:	85ca                	mv	a1,s2
 6ac:	855a                	mv	a0,s6
 6ae:	e3bff0ef          	jal	4e8 <putc>
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	b791                	j	5f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b6:	008b8913          	addi	s2,s7,8
 6ba:	4685                	li	a3,1
 6bc:	4629                	li	a2,10
 6be:	000ba583          	lw	a1,0(s7)
 6c2:	855a                	mv	a0,s6
 6c4:	e43ff0ef          	jal	506 <printint>
        i += 1;
 6c8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ca:	8bca                	mv	s7,s2
      state = 0;
 6cc:	4981                	li	s3,0
        i += 1;
 6ce:	b72d                	j	5f8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6d0:	06400793          	li	a5,100
 6d4:	02f60763          	beq	a2,a5,702 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6d8:	07500793          	li	a5,117
 6dc:	06f60963          	beq	a2,a5,74e <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6e0:	07800793          	li	a5,120
 6e4:	faf61ee3          	bne	a2,a5,6a0 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e8:	008b8913          	addi	s2,s7,8
 6ec:	4681                	li	a3,0
 6ee:	4641                	li	a2,16
 6f0:	000ba583          	lw	a1,0(s7)
 6f4:	855a                	mv	a0,s6
 6f6:	e11ff0ef          	jal	506 <printint>
        i += 2;
 6fa:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fc:	8bca                	mv	s7,s2
      state = 0;
 6fe:	4981                	li	s3,0
        i += 2;
 700:	bde5                	j	5f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 702:	008b8913          	addi	s2,s7,8
 706:	4685                	li	a3,1
 708:	4629                	li	a2,10
 70a:	000ba583          	lw	a1,0(s7)
 70e:	855a                	mv	a0,s6
 710:	df7ff0ef          	jal	506 <printint>
        i += 2;
 714:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 716:	8bca                	mv	s7,s2
      state = 0;
 718:	4981                	li	s3,0
        i += 2;
 71a:	bdf9                	j	5f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 71c:	008b8913          	addi	s2,s7,8
 720:	4681                	li	a3,0
 722:	4629                	li	a2,10
 724:	000ba583          	lw	a1,0(s7)
 728:	855a                	mv	a0,s6
 72a:	dddff0ef          	jal	506 <printint>
 72e:	8bca                	mv	s7,s2
      state = 0;
 730:	4981                	li	s3,0
 732:	b5d9                	j	5f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 734:	008b8913          	addi	s2,s7,8
 738:	4681                	li	a3,0
 73a:	4629                	li	a2,10
 73c:	000ba583          	lw	a1,0(s7)
 740:	855a                	mv	a0,s6
 742:	dc5ff0ef          	jal	506 <printint>
        i += 1;
 746:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 748:	8bca                	mv	s7,s2
      state = 0;
 74a:	4981                	li	s3,0
        i += 1;
 74c:	b575                	j	5f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 74e:	008b8913          	addi	s2,s7,8
 752:	4681                	li	a3,0
 754:	4629                	li	a2,10
 756:	000ba583          	lw	a1,0(s7)
 75a:	855a                	mv	a0,s6
 75c:	dabff0ef          	jal	506 <printint>
        i += 2;
 760:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 762:	8bca                	mv	s7,s2
      state = 0;
 764:	4981                	li	s3,0
        i += 2;
 766:	bd49                	j	5f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 768:	008b8913          	addi	s2,s7,8
 76c:	4681                	li	a3,0
 76e:	4641                	li	a2,16
 770:	000ba583          	lw	a1,0(s7)
 774:	855a                	mv	a0,s6
 776:	d91ff0ef          	jal	506 <printint>
 77a:	8bca                	mv	s7,s2
      state = 0;
 77c:	4981                	li	s3,0
 77e:	bdad                	j	5f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 780:	008b8913          	addi	s2,s7,8
 784:	4681                	li	a3,0
 786:	4641                	li	a2,16
 788:	000ba583          	lw	a1,0(s7)
 78c:	855a                	mv	a0,s6
 78e:	d79ff0ef          	jal	506 <printint>
        i += 1;
 792:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 794:	8bca                	mv	s7,s2
      state = 0;
 796:	4981                	li	s3,0
        i += 1;
 798:	b585                	j	5f8 <vprintf+0x4a>
 79a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 79c:	008b8d13          	addi	s10,s7,8
 7a0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7a4:	03000593          	li	a1,48
 7a8:	855a                	mv	a0,s6
 7aa:	d3fff0ef          	jal	4e8 <putc>
  putc(fd, 'x');
 7ae:	07800593          	li	a1,120
 7b2:	855a                	mv	a0,s6
 7b4:	d35ff0ef          	jal	4e8 <putc>
 7b8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ba:	00000b97          	auipc	s7,0x0
 7be:	2beb8b93          	addi	s7,s7,702 # a78 <digits>
 7c2:	03c9d793          	srli	a5,s3,0x3c
 7c6:	97de                	add	a5,a5,s7
 7c8:	0007c583          	lbu	a1,0(a5)
 7cc:	855a                	mv	a0,s6
 7ce:	d1bff0ef          	jal	4e8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7d2:	0992                	slli	s3,s3,0x4
 7d4:	397d                	addiw	s2,s2,-1
 7d6:	fe0916e3          	bnez	s2,7c2 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7da:	8bea                	mv	s7,s10
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	6d02                	ld	s10,0(sp)
 7e0:	bd21                	j	5f8 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7e2:	008b8993          	addi	s3,s7,8
 7e6:	000bb903          	ld	s2,0(s7)
 7ea:	00090f63          	beqz	s2,808 <vprintf+0x25a>
        for(; *s; s++)
 7ee:	00094583          	lbu	a1,0(s2)
 7f2:	c195                	beqz	a1,816 <vprintf+0x268>
          putc(fd, *s);
 7f4:	855a                	mv	a0,s6
 7f6:	cf3ff0ef          	jal	4e8 <putc>
        for(; *s; s++)
 7fa:	0905                	addi	s2,s2,1
 7fc:	00094583          	lbu	a1,0(s2)
 800:	f9f5                	bnez	a1,7f4 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 802:	8bce                	mv	s7,s3
      state = 0;
 804:	4981                	li	s3,0
 806:	bbcd                	j	5f8 <vprintf+0x4a>
          s = "(null)";
 808:	00000917          	auipc	s2,0x0
 80c:	26890913          	addi	s2,s2,616 # a70 <malloc+0x15c>
        for(; *s; s++)
 810:	02800593          	li	a1,40
 814:	b7c5                	j	7f4 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 816:	8bce                	mv	s7,s3
      state = 0;
 818:	4981                	li	s3,0
 81a:	bbf9                	j	5f8 <vprintf+0x4a>
 81c:	64a6                	ld	s1,72(sp)
 81e:	79e2                	ld	s3,56(sp)
 820:	7a42                	ld	s4,48(sp)
 822:	7aa2                	ld	s5,40(sp)
 824:	7b02                	ld	s6,32(sp)
 826:	6be2                	ld	s7,24(sp)
 828:	6c42                	ld	s8,16(sp)
 82a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 82c:	60e6                	ld	ra,88(sp)
 82e:	6446                	ld	s0,80(sp)
 830:	6906                	ld	s2,64(sp)
 832:	6125                	addi	sp,sp,96
 834:	8082                	ret

0000000000000836 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 836:	715d                	addi	sp,sp,-80
 838:	ec06                	sd	ra,24(sp)
 83a:	e822                	sd	s0,16(sp)
 83c:	1000                	addi	s0,sp,32
 83e:	e010                	sd	a2,0(s0)
 840:	e414                	sd	a3,8(s0)
 842:	e818                	sd	a4,16(s0)
 844:	ec1c                	sd	a5,24(s0)
 846:	03043023          	sd	a6,32(s0)
 84a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 84e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 852:	8622                	mv	a2,s0
 854:	d5bff0ef          	jal	5ae <vprintf>
}
 858:	60e2                	ld	ra,24(sp)
 85a:	6442                	ld	s0,16(sp)
 85c:	6161                	addi	sp,sp,80
 85e:	8082                	ret

0000000000000860 <printf>:

void
printf(const char *fmt, ...)
{
 860:	711d                	addi	sp,sp,-96
 862:	ec06                	sd	ra,24(sp)
 864:	e822                	sd	s0,16(sp)
 866:	1000                	addi	s0,sp,32
 868:	e40c                	sd	a1,8(s0)
 86a:	e810                	sd	a2,16(s0)
 86c:	ec14                	sd	a3,24(s0)
 86e:	f018                	sd	a4,32(s0)
 870:	f41c                	sd	a5,40(s0)
 872:	03043823          	sd	a6,48(s0)
 876:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 87a:	00840613          	addi	a2,s0,8
 87e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 882:	85aa                	mv	a1,a0
 884:	4505                	li	a0,1
 886:	d29ff0ef          	jal	5ae <vprintf>
}
 88a:	60e2                	ld	ra,24(sp)
 88c:	6442                	ld	s0,16(sp)
 88e:	6125                	addi	sp,sp,96
 890:	8082                	ret

0000000000000892 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 892:	1141                	addi	sp,sp,-16
 894:	e422                	sd	s0,8(sp)
 896:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 898:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89c:	00000797          	auipc	a5,0x0
 8a0:	7647b783          	ld	a5,1892(a5) # 1000 <freep>
 8a4:	a02d                	j	8ce <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8a6:	4618                	lw	a4,8(a2)
 8a8:	9f2d                	addw	a4,a4,a1
 8aa:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ae:	6398                	ld	a4,0(a5)
 8b0:	6310                	ld	a2,0(a4)
 8b2:	a83d                	j	8f0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8b4:	ff852703          	lw	a4,-8(a0)
 8b8:	9f31                	addw	a4,a4,a2
 8ba:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8bc:	ff053683          	ld	a3,-16(a0)
 8c0:	a091                	j	904 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c2:	6398                	ld	a4,0(a5)
 8c4:	00e7e463          	bltu	a5,a4,8cc <free+0x3a>
 8c8:	00e6ea63          	bltu	a3,a4,8dc <free+0x4a>
{
 8cc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ce:	fed7fae3          	bgeu	a5,a3,8c2 <free+0x30>
 8d2:	6398                	ld	a4,0(a5)
 8d4:	00e6e463          	bltu	a3,a4,8dc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d8:	fee7eae3          	bltu	a5,a4,8cc <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8dc:	ff852583          	lw	a1,-8(a0)
 8e0:	6390                	ld	a2,0(a5)
 8e2:	02059813          	slli	a6,a1,0x20
 8e6:	01c85713          	srli	a4,a6,0x1c
 8ea:	9736                	add	a4,a4,a3
 8ec:	fae60de3          	beq	a2,a4,8a6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8f0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8f4:	4790                	lw	a2,8(a5)
 8f6:	02061593          	slli	a1,a2,0x20
 8fa:	01c5d713          	srli	a4,a1,0x1c
 8fe:	973e                	add	a4,a4,a5
 900:	fae68ae3          	beq	a3,a4,8b4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 904:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 906:	00000717          	auipc	a4,0x0
 90a:	6ef73d23          	sd	a5,1786(a4) # 1000 <freep>
}
 90e:	6422                	ld	s0,8(sp)
 910:	0141                	addi	sp,sp,16
 912:	8082                	ret

0000000000000914 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 914:	7139                	addi	sp,sp,-64
 916:	fc06                	sd	ra,56(sp)
 918:	f822                	sd	s0,48(sp)
 91a:	f426                	sd	s1,40(sp)
 91c:	ec4e                	sd	s3,24(sp)
 91e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 920:	02051493          	slli	s1,a0,0x20
 924:	9081                	srli	s1,s1,0x20
 926:	04bd                	addi	s1,s1,15
 928:	8091                	srli	s1,s1,0x4
 92a:	0014899b          	addiw	s3,s1,1
 92e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 930:	00000517          	auipc	a0,0x0
 934:	6d053503          	ld	a0,1744(a0) # 1000 <freep>
 938:	c915                	beqz	a0,96c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 93c:	4798                	lw	a4,8(a5)
 93e:	08977a63          	bgeu	a4,s1,9d2 <malloc+0xbe>
 942:	f04a                	sd	s2,32(sp)
 944:	e852                	sd	s4,16(sp)
 946:	e456                	sd	s5,8(sp)
 948:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 94a:	8a4e                	mv	s4,s3
 94c:	0009871b          	sext.w	a4,s3
 950:	6685                	lui	a3,0x1
 952:	00d77363          	bgeu	a4,a3,958 <malloc+0x44>
 956:	6a05                	lui	s4,0x1
 958:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 95c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 960:	00000917          	auipc	s2,0x0
 964:	6a090913          	addi	s2,s2,1696 # 1000 <freep>
  if(p == (char*)-1)
 968:	5afd                	li	s5,-1
 96a:	a081                	j	9aa <malloc+0x96>
 96c:	f04a                	sd	s2,32(sp)
 96e:	e852                	sd	s4,16(sp)
 970:	e456                	sd	s5,8(sp)
 972:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 974:	00000797          	auipc	a5,0x0
 978:	69c78793          	addi	a5,a5,1692 # 1010 <base>
 97c:	00000717          	auipc	a4,0x0
 980:	68f73223          	sd	a5,1668(a4) # 1000 <freep>
 984:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 986:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 98a:	b7c1                	j	94a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 98c:	6398                	ld	a4,0(a5)
 98e:	e118                	sd	a4,0(a0)
 990:	a8a9                	j	9ea <malloc+0xd6>
  hp->s.size = nu;
 992:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 996:	0541                	addi	a0,a0,16
 998:	efbff0ef          	jal	892 <free>
  return freep;
 99c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9a0:	c12d                	beqz	a0,a02 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9a4:	4798                	lw	a4,8(a5)
 9a6:	02977263          	bgeu	a4,s1,9ca <malloc+0xb6>
    if(p == freep)
 9aa:	00093703          	ld	a4,0(s2)
 9ae:	853e                	mv	a0,a5
 9b0:	fef719e3          	bne	a4,a5,9a2 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9b4:	8552                	mv	a0,s4
 9b6:	ad3ff0ef          	jal	488 <sbrk>
  if(p == (char*)-1)
 9ba:	fd551ce3          	bne	a0,s5,992 <malloc+0x7e>
        return 0;
 9be:	4501                	li	a0,0
 9c0:	7902                	ld	s2,32(sp)
 9c2:	6a42                	ld	s4,16(sp)
 9c4:	6aa2                	ld	s5,8(sp)
 9c6:	6b02                	ld	s6,0(sp)
 9c8:	a03d                	j	9f6 <malloc+0xe2>
 9ca:	7902                	ld	s2,32(sp)
 9cc:	6a42                	ld	s4,16(sp)
 9ce:	6aa2                	ld	s5,8(sp)
 9d0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9d2:	fae48de3          	beq	s1,a4,98c <malloc+0x78>
        p->s.size -= nunits;
 9d6:	4137073b          	subw	a4,a4,s3
 9da:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9dc:	02071693          	slli	a3,a4,0x20
 9e0:	01c6d713          	srli	a4,a3,0x1c
 9e4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9e6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ea:	00000717          	auipc	a4,0x0
 9ee:	60a73b23          	sd	a0,1558(a4) # 1000 <freep>
      return (void*)(p + 1);
 9f2:	01078513          	addi	a0,a5,16
  }
}
 9f6:	70e2                	ld	ra,56(sp)
 9f8:	7442                	ld	s0,48(sp)
 9fa:	74a2                	ld	s1,40(sp)
 9fc:	69e2                	ld	s3,24(sp)
 9fe:	6121                	addi	sp,sp,64
 a00:	8082                	ret
 a02:	7902                	ld	s2,32(sp)
 a04:	6a42                	ld	s4,16(sp)
 a06:	6aa2                	ld	s5,8(sp)
 a08:	6b02                	ld	s6,0(sp)
 a0a:	b7f5                	j	9f6 <malloc+0xe2>
