
user/_stressfs：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	a9a78793          	addi	a5,a5,-1382 # ab0 <malloc+0x12a>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	a5450513          	addi	a0,a0,-1452 # a80 <malloc+0xfa>
  34:	09f000ef          	jal	8d2 <printf>
  memset(data, 'a', sizeof(data));
  38:	20000613          	li	a2,512
  3c:	06100593          	li	a1,97
  40:	dd040513          	addi	a0,s0,-560
  44:	14e000ef          	jal	192 <memset>

  for(i = 0; i < 4; i++)
  48:	4481                	li	s1,0
  4a:	4911                	li	s2,4
    if(fork() > 0)
  4c:	41e000ef          	jal	46a <fork>
  50:	00a04563          	bgtz	a0,5a <main+0x5a>
  for(i = 0; i < 4; i++)
  54:	2485                	addiw	s1,s1,1
  56:	ff249be3          	bne	s1,s2,4c <main+0x4c>
      break;

  printf("write %d\n", i);
  5a:	85a6                	mv	a1,s1
  5c:	00001517          	auipc	a0,0x1
  60:	a3c50513          	addi	a0,a0,-1476 # a98 <malloc+0x112>
  64:	06f000ef          	jal	8d2 <printf>

  path[8] += i;
  68:	fd844783          	lbu	a5,-40(s0)
  6c:	9fa5                	addw	a5,a5,s1
  6e:	fcf40c23          	sb	a5,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  72:	20200593          	li	a1,514
  76:	fd040513          	addi	a0,s0,-48
  7a:	438000ef          	jal	4b2 <open>
  7e:	892a                	mv	s2,a0
  80:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  82:	20000613          	li	a2,512
  86:	dd040593          	addi	a1,s0,-560
  8a:	854a                	mv	a0,s2
  8c:	406000ef          	jal	492 <write>
  for(i = 0; i < 20; i++)
  90:	34fd                	addiw	s1,s1,-1
  92:	f8e5                	bnez	s1,82 <main+0x82>
  close(fd);
  94:	854a                	mv	a0,s2
  96:	404000ef          	jal	49a <close>

  printf("read\n");
  9a:	00001517          	auipc	a0,0x1
  9e:	a0e50513          	addi	a0,a0,-1522 # aa8 <malloc+0x122>
  a2:	031000ef          	jal	8d2 <printf>

  fd = open(path, O_RDONLY);
  a6:	4581                	li	a1,0
  a8:	fd040513          	addi	a0,s0,-48
  ac:	406000ef          	jal	4b2 <open>
  b0:	892a                	mv	s2,a0
  b2:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  b4:	20000613          	li	a2,512
  b8:	dd040593          	addi	a1,s0,-560
  bc:	854a                	mv	a0,s2
  be:	3cc000ef          	jal	48a <read>
  for (i = 0; i < 20; i++)
  c2:	34fd                	addiw	s1,s1,-1
  c4:	f8e5                	bnez	s1,b4 <main+0xb4>
  close(fd);
  c6:	854a                	mv	a0,s2
  c8:	3d2000ef          	jal	49a <close>

  wait(0);
  cc:	4501                	li	a0,0
  ce:	3ac000ef          	jal	47a <wait>

  exit(0);
  d2:	4501                	li	a0,0
  d4:	39e000ef          	jal	472 <exit>

00000000000000d8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  d8:	1141                	addi	sp,sp,-16
  da:	e406                	sd	ra,8(sp)
  dc:	e022                	sd	s0,0(sp)
  de:	0800                	addi	s0,sp,16
  extern int main();
  main();
  e0:	f21ff0ef          	jal	0 <main>
  exit(0);
  e4:	4501                	li	a0,0
  e6:	38c000ef          	jal	472 <exit>

00000000000000ea <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e422                	sd	s0,8(sp)
  ee:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  f0:	87aa                	mv	a5,a0
  f2:	0585                	addi	a1,a1,1
  f4:	0785                	addi	a5,a5,1
  f6:	fff5c703          	lbu	a4,-1(a1)
  fa:	fee78fa3          	sb	a4,-1(a5)
  fe:	fb75                	bnez	a4,f2 <strcpy+0x8>
    ;
  return os;
}
 100:	6422                	ld	s0,8(sp)
 102:	0141                	addi	sp,sp,16
 104:	8082                	ret

0000000000000106 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 106:	1141                	addi	sp,sp,-16
 108:	e422                	sd	s0,8(sp)
 10a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 10c:	00054783          	lbu	a5,0(a0)
 110:	cb91                	beqz	a5,124 <strcmp+0x1e>
 112:	0005c703          	lbu	a4,0(a1)
 116:	00f71763          	bne	a4,a5,124 <strcmp+0x1e>
    p++, q++;
 11a:	0505                	addi	a0,a0,1
 11c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 11e:	00054783          	lbu	a5,0(a0)
 122:	fbe5                	bnez	a5,112 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 124:	0005c503          	lbu	a0,0(a1)
}
 128:	40a7853b          	subw	a0,a5,a0
 12c:	6422                	ld	s0,8(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 132:	1141                	addi	sp,sp,-16
 134:	e422                	sd	s0,8(sp)
 136:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q) {
 138:	ce11                	beqz	a2,154 <strncmp+0x22>
 13a:	00054783          	lbu	a5,0(a0)
 13e:	cf89                	beqz	a5,158 <strncmp+0x26>
 140:	0005c703          	lbu	a4,0(a1)
 144:	00f71a63          	bne	a4,a5,158 <strncmp+0x26>
    n--;
 148:	367d                	addiw	a2,a2,-1
    p++;
 14a:	0505                	addi	a0,a0,1
    q++;
 14c:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q) {
 14e:	f675                	bnez	a2,13a <strncmp+0x8>
  }
  if(n == 0)
    return 0;
 150:	4501                	li	a0,0
 152:	a801                	j	162 <strncmp+0x30>
 154:	4501                	li	a0,0
 156:	a031                	j	162 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
 158:	00054503          	lbu	a0,0(a0)
 15c:	0005c783          	lbu	a5,0(a1)
 160:	9d1d                	subw	a0,a0,a5
}
 162:	6422                	ld	s0,8(sp)
 164:	0141                	addi	sp,sp,16
 166:	8082                	ret

0000000000000168 <strlen>:

uint
strlen(const char *s)
{
 168:	1141                	addi	sp,sp,-16
 16a:	e422                	sd	s0,8(sp)
 16c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 16e:	00054783          	lbu	a5,0(a0)
 172:	cf91                	beqz	a5,18e <strlen+0x26>
 174:	0505                	addi	a0,a0,1
 176:	87aa                	mv	a5,a0
 178:	86be                	mv	a3,a5
 17a:	0785                	addi	a5,a5,1
 17c:	fff7c703          	lbu	a4,-1(a5)
 180:	ff65                	bnez	a4,178 <strlen+0x10>
 182:	40a6853b          	subw	a0,a3,a0
 186:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 188:	6422                	ld	s0,8(sp)
 18a:	0141                	addi	sp,sp,16
 18c:	8082                	ret
  for(n = 0; s[n]; n++)
 18e:	4501                	li	a0,0
 190:	bfe5                	j	188 <strlen+0x20>

0000000000000192 <memset>:

void*
memset(void *dst, int c, uint n)
{
 192:	1141                	addi	sp,sp,-16
 194:	e422                	sd	s0,8(sp)
 196:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 198:	ca19                	beqz	a2,1ae <memset+0x1c>
 19a:	87aa                	mv	a5,a0
 19c:	1602                	slli	a2,a2,0x20
 19e:	9201                	srli	a2,a2,0x20
 1a0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a8:	0785                	addi	a5,a5,1
 1aa:	fee79de3          	bne	a5,a4,1a4 <memset+0x12>
  }
  return dst;
}
 1ae:	6422                	ld	s0,8(sp)
 1b0:	0141                	addi	sp,sp,16
 1b2:	8082                	ret

00000000000001b4 <strchr>:

char*
strchr(const char *s, char c)
{
 1b4:	1141                	addi	sp,sp,-16
 1b6:	e422                	sd	s0,8(sp)
 1b8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1ba:	00054783          	lbu	a5,0(a0)
 1be:	cb99                	beqz	a5,1d4 <strchr+0x20>
    if(*s == c)
 1c0:	00f58763          	beq	a1,a5,1ce <strchr+0x1a>
  for(; *s; s++)
 1c4:	0505                	addi	a0,a0,1
 1c6:	00054783          	lbu	a5,0(a0)
 1ca:	fbfd                	bnez	a5,1c0 <strchr+0xc>
      return (char*)s;
  return 0;
 1cc:	4501                	li	a0,0
}
 1ce:	6422                	ld	s0,8(sp)
 1d0:	0141                	addi	sp,sp,16
 1d2:	8082                	ret
  return 0;
 1d4:	4501                	li	a0,0
 1d6:	bfe5                	j	1ce <strchr+0x1a>

00000000000001d8 <gets>:

char*
gets(char *buf, int max)
{
 1d8:	711d                	addi	sp,sp,-96
 1da:	ec86                	sd	ra,88(sp)
 1dc:	e8a2                	sd	s0,80(sp)
 1de:	e4a6                	sd	s1,72(sp)
 1e0:	e0ca                	sd	s2,64(sp)
 1e2:	fc4e                	sd	s3,56(sp)
 1e4:	f852                	sd	s4,48(sp)
 1e6:	f456                	sd	s5,40(sp)
 1e8:	f05a                	sd	s6,32(sp)
 1ea:	ec5e                	sd	s7,24(sp)
 1ec:	1080                	addi	s0,sp,96
 1ee:	8baa                	mv	s7,a0
 1f0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f2:	892a                	mv	s2,a0
 1f4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f6:	4aa9                	li	s5,10
 1f8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1fa:	89a6                	mv	s3,s1
 1fc:	2485                	addiw	s1,s1,1
 1fe:	0344d663          	bge	s1,s4,22a <gets+0x52>
    cc = read(0, &c, 1);
 202:	4605                	li	a2,1
 204:	faf40593          	addi	a1,s0,-81
 208:	4501                	li	a0,0
 20a:	280000ef          	jal	48a <read>
    if(cc < 1)
 20e:	00a05e63          	blez	a0,22a <gets+0x52>
    buf[i++] = c;
 212:	faf44783          	lbu	a5,-81(s0)
 216:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 21a:	01578763          	beq	a5,s5,228 <gets+0x50>
 21e:	0905                	addi	s2,s2,1
 220:	fd679de3          	bne	a5,s6,1fa <gets+0x22>
    buf[i++] = c;
 224:	89a6                	mv	s3,s1
 226:	a011                	j	22a <gets+0x52>
 228:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 22a:	99de                	add	s3,s3,s7
 22c:	00098023          	sb	zero,0(s3)
  return buf;
}
 230:	855e                	mv	a0,s7
 232:	60e6                	ld	ra,88(sp)
 234:	6446                	ld	s0,80(sp)
 236:	64a6                	ld	s1,72(sp)
 238:	6906                	ld	s2,64(sp)
 23a:	79e2                	ld	s3,56(sp)
 23c:	7a42                	ld	s4,48(sp)
 23e:	7aa2                	ld	s5,40(sp)
 240:	7b02                	ld	s6,32(sp)
 242:	6be2                	ld	s7,24(sp)
 244:	6125                	addi	sp,sp,96
 246:	8082                	ret

0000000000000248 <stat>:

int
stat(const char *n, struct stat *st)
{
 248:	1101                	addi	sp,sp,-32
 24a:	ec06                	sd	ra,24(sp)
 24c:	e822                	sd	s0,16(sp)
 24e:	e04a                	sd	s2,0(sp)
 250:	1000                	addi	s0,sp,32
 252:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 254:	4581                	li	a1,0
 256:	25c000ef          	jal	4b2 <open>
  if(fd < 0)
 25a:	02054263          	bltz	a0,27e <stat+0x36>
 25e:	e426                	sd	s1,8(sp)
 260:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 262:	85ca                	mv	a1,s2
 264:	266000ef          	jal	4ca <fstat>
 268:	892a                	mv	s2,a0
  close(fd);
 26a:	8526                	mv	a0,s1
 26c:	22e000ef          	jal	49a <close>
  return r;
 270:	64a2                	ld	s1,8(sp)
}
 272:	854a                	mv	a0,s2
 274:	60e2                	ld	ra,24(sp)
 276:	6442                	ld	s0,16(sp)
 278:	6902                	ld	s2,0(sp)
 27a:	6105                	addi	sp,sp,32
 27c:	8082                	ret
    return -1;
 27e:	597d                	li	s2,-1
 280:	bfcd                	j	272 <stat+0x2a>

0000000000000282 <atoi>:

int
atoi(const char *s)
{
 282:	1141                	addi	sp,sp,-16
 284:	e422                	sd	s0,8(sp)
 286:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 288:	00054683          	lbu	a3,0(a0)
 28c:	fd06879b          	addiw	a5,a3,-48
 290:	0ff7f793          	zext.b	a5,a5
 294:	4625                	li	a2,9
 296:	02f66863          	bltu	a2,a5,2c6 <atoi+0x44>
 29a:	872a                	mv	a4,a0
  n = 0;
 29c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 29e:	0705                	addi	a4,a4,1
 2a0:	0025179b          	slliw	a5,a0,0x2
 2a4:	9fa9                	addw	a5,a5,a0
 2a6:	0017979b          	slliw	a5,a5,0x1
 2aa:	9fb5                	addw	a5,a5,a3
 2ac:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b0:	00074683          	lbu	a3,0(a4)
 2b4:	fd06879b          	addiw	a5,a3,-48
 2b8:	0ff7f793          	zext.b	a5,a5
 2bc:	fef671e3          	bgeu	a2,a5,29e <atoi+0x1c>
  return n;
}
 2c0:	6422                	ld	s0,8(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret
  n = 0;
 2c6:	4501                	li	a0,0
 2c8:	bfe5                	j	2c0 <atoi+0x3e>

00000000000002ca <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ca:	1141                	addi	sp,sp,-16
 2cc:	e422                	sd	s0,8(sp)
 2ce:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d0:	02b57463          	bgeu	a0,a1,2f8 <memmove+0x2e>
    while(n-- > 0)
 2d4:	00c05f63          	blez	a2,2f2 <memmove+0x28>
 2d8:	1602                	slli	a2,a2,0x20
 2da:	9201                	srli	a2,a2,0x20
 2dc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2e0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e2:	0585                	addi	a1,a1,1
 2e4:	0705                	addi	a4,a4,1
 2e6:	fff5c683          	lbu	a3,-1(a1)
 2ea:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ee:	fef71ae3          	bne	a4,a5,2e2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f2:	6422                	ld	s0,8(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret
    dst += n;
 2f8:	00c50733          	add	a4,a0,a2
    src += n;
 2fc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2fe:	fec05ae3          	blez	a2,2f2 <memmove+0x28>
 302:	fff6079b          	addiw	a5,a2,-1
 306:	1782                	slli	a5,a5,0x20
 308:	9381                	srli	a5,a5,0x20
 30a:	fff7c793          	not	a5,a5
 30e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 310:	15fd                	addi	a1,a1,-1
 312:	177d                	addi	a4,a4,-1
 314:	0005c683          	lbu	a3,0(a1)
 318:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 31c:	fee79ae3          	bne	a5,a4,310 <memmove+0x46>
 320:	bfc9                	j	2f2 <memmove+0x28>

0000000000000322 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 322:	1141                	addi	sp,sp,-16
 324:	e422                	sd	s0,8(sp)
 326:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 328:	ca05                	beqz	a2,358 <memcmp+0x36>
 32a:	fff6069b          	addiw	a3,a2,-1
 32e:	1682                	slli	a3,a3,0x20
 330:	9281                	srli	a3,a3,0x20
 332:	0685                	addi	a3,a3,1
 334:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 336:	00054783          	lbu	a5,0(a0)
 33a:	0005c703          	lbu	a4,0(a1)
 33e:	00e79863          	bne	a5,a4,34e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 342:	0505                	addi	a0,a0,1
    p2++;
 344:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 346:	fed518e3          	bne	a0,a3,336 <memcmp+0x14>
  }
  return 0;
 34a:	4501                	li	a0,0
 34c:	a019                	j	352 <memcmp+0x30>
      return *p1 - *p2;
 34e:	40e7853b          	subw	a0,a5,a4
}
 352:	6422                	ld	s0,8(sp)
 354:	0141                	addi	sp,sp,16
 356:	8082                	ret
  return 0;
 358:	4501                	li	a0,0
 35a:	bfe5                	j	352 <memcmp+0x30>

000000000000035c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 35c:	1141                	addi	sp,sp,-16
 35e:	e406                	sd	ra,8(sp)
 360:	e022                	sd	s0,0(sp)
 362:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 364:	f67ff0ef          	jal	2ca <memmove>
}
 368:	60a2                	ld	ra,8(sp)
 36a:	6402                	ld	s0,0(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret

0000000000000370 <simplesort>:

void
simplesort(void *base, uint nmemb, uint size, int (*compar)(const void *, const void *))
{
 370:	7119                	addi	sp,sp,-128
 372:	fc86                	sd	ra,120(sp)
 374:	f8a2                	sd	s0,112(sp)
 376:	0100                	addi	s0,sp,128
 378:	f8b43423          	sd	a1,-120(s0)
  char *arr = (char *)base; // Treat array as char array for byte-level manipulation
  char *temp;               // Temporary storage for an element

  if (nmemb <= 1 || size == 0) {
 37c:	4785                	li	a5,1
 37e:	00b7fc63          	bgeu	a5,a1,396 <simplesort+0x26>
 382:	e8d2                	sd	s4,80(sp)
 384:	e4d6                	sd	s5,72(sp)
 386:	f466                	sd	s9,40(sp)
 388:	8aaa                	mv	s5,a0
 38a:	8a32                	mv	s4,a2
 38c:	8cb6                	mv	s9,a3
 38e:	ea01                	bnez	a2,39e <simplesort+0x2e>
 390:	6a46                	ld	s4,80(sp)
 392:	6aa6                	ld	s5,72(sp)
 394:	7ca2                	ld	s9,40(sp)
    // Place temp at its correct position
    memmove(arr + j * size, temp, size);
  }

  free(temp); // Free temporary space
 396:	70e6                	ld	ra,120(sp)
 398:	7446                	ld	s0,112(sp)
 39a:	6109                	addi	sp,sp,128
 39c:	8082                	ret
 39e:	fc5e                	sd	s7,56(sp)
 3a0:	f862                	sd	s8,48(sp)
 3a2:	f06a                	sd	s10,32(sp)
 3a4:	ec6e                	sd	s11,24(sp)
  temp = malloc(size); // Allocate temporary space for one element
 3a6:	8532                	mv	a0,a2
 3a8:	5de000ef          	jal	986 <malloc>
 3ac:	8baa                	mv	s7,a0
  if (temp == 0) {
 3ae:	4d81                	li	s11,0
  for (uint i = 1; i < nmemb; i++) {
 3b0:	4d05                	li	s10,1
    memmove(temp, arr + i * size, size);
 3b2:	000a0c1b          	sext.w	s8,s4
  if (temp == 0) {
 3b6:	c511                	beqz	a0,3c2 <simplesort+0x52>
 3b8:	f4a6                	sd	s1,104(sp)
 3ba:	f0ca                	sd	s2,96(sp)
 3bc:	ecce                	sd	s3,88(sp)
 3be:	e0da                	sd	s6,64(sp)
 3c0:	a82d                	j	3fa <simplesort+0x8a>
    printf("simplesort: malloc failed, cannot sort\n");
 3c2:	00000517          	auipc	a0,0x0
 3c6:	6fe50513          	addi	a0,a0,1790 # ac0 <malloc+0x13a>
 3ca:	508000ef          	jal	8d2 <printf>
    return;
 3ce:	6a46                	ld	s4,80(sp)
 3d0:	6aa6                	ld	s5,72(sp)
 3d2:	7be2                	ld	s7,56(sp)
 3d4:	7c42                	ld	s8,48(sp)
 3d6:	7ca2                	ld	s9,40(sp)
 3d8:	7d02                	ld	s10,32(sp)
 3da:	6de2                	ld	s11,24(sp)
 3dc:	bf6d                	j	396 <simplesort+0x26>
    memmove(arr + j * size, temp, size);
 3de:	036a053b          	mulw	a0,s4,s6
 3e2:	1502                	slli	a0,a0,0x20
 3e4:	9101                	srli	a0,a0,0x20
 3e6:	8662                	mv	a2,s8
 3e8:	85de                	mv	a1,s7
 3ea:	9556                	add	a0,a0,s5
 3ec:	edfff0ef          	jal	2ca <memmove>
  for (uint i = 1; i < nmemb; i++) {
 3f0:	2d05                	addiw	s10,s10,1
 3f2:	f8843783          	ld	a5,-120(s0)
 3f6:	05a78b63          	beq	a5,s10,44c <simplesort+0xdc>
    memmove(temp, arr + i * size, size);
 3fa:	000d899b          	sext.w	s3,s11
 3fe:	01ba05bb          	addw	a1,s4,s11
 402:	00058d9b          	sext.w	s11,a1
 406:	1582                	slli	a1,a1,0x20
 408:	9181                	srli	a1,a1,0x20
 40a:	8662                	mv	a2,s8
 40c:	95d6                	add	a1,a1,s5
 40e:	855e                	mv	a0,s7
 410:	ebbff0ef          	jal	2ca <memmove>
    uint j = i;
 414:	896a                	mv	s2,s10
 416:	00090b1b          	sext.w	s6,s2
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 41a:	397d                	addiw	s2,s2,-1
 41c:	02099493          	slli	s1,s3,0x20
 420:	9081                	srli	s1,s1,0x20
 422:	94d6                	add	s1,s1,s5
 424:	85de                	mv	a1,s7
 426:	8526                	mv	a0,s1
 428:	9c82                	jalr	s9
 42a:	faa05ae3          	blez	a0,3de <simplesort+0x6e>
      memmove(arr + j * size, arr + (j - 1) * size, size); // Shift element
 42e:	0149853b          	addw	a0,s3,s4
 432:	1502                	slli	a0,a0,0x20
 434:	9101                	srli	a0,a0,0x20
 436:	8662                	mv	a2,s8
 438:	85a6                	mv	a1,s1
 43a:	9556                	add	a0,a0,s5
 43c:	e8fff0ef          	jal	2ca <memmove>
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 440:	414989bb          	subw	s3,s3,s4
 444:	fc0919e3          	bnez	s2,416 <simplesort+0xa6>
 448:	8b4a                	mv	s6,s2
 44a:	bf51                	j	3de <simplesort+0x6e>
  free(temp); // Free temporary space
 44c:	855e                	mv	a0,s7
 44e:	4b6000ef          	jal	904 <free>
 452:	74a6                	ld	s1,104(sp)
 454:	7906                	ld	s2,96(sp)
 456:	69e6                	ld	s3,88(sp)
 458:	6a46                	ld	s4,80(sp)
 45a:	6aa6                	ld	s5,72(sp)
 45c:	6b06                	ld	s6,64(sp)
 45e:	7be2                	ld	s7,56(sp)
 460:	7c42                	ld	s8,48(sp)
 462:	7ca2                	ld	s9,40(sp)
 464:	7d02                	ld	s10,32(sp)
 466:	6de2                	ld	s11,24(sp)
 468:	b73d                	j	396 <simplesort+0x26>

000000000000046a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 46a:	4885                	li	a7,1
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <exit>:
.global exit
exit:
 li a7, SYS_exit
 472:	4889                	li	a7,2
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <wait>:
.global wait
wait:
 li a7, SYS_wait
 47a:	488d                	li	a7,3
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 482:	4891                	li	a7,4
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <read>:
.global read
read:
 li a7, SYS_read
 48a:	4895                	li	a7,5
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <write>:
.global write
write:
 li a7, SYS_write
 492:	48c1                	li	a7,16
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <close>:
.global close
close:
 li a7, SYS_close
 49a:	48d5                	li	a7,21
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4a2:	4899                	li	a7,6
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <exec>:
.global exec
exec:
 li a7, SYS_exec
 4aa:	489d                	li	a7,7
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <open>:
.global open
open:
 li a7, SYS_open
 4b2:	48bd                	li	a7,15
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4ba:	48c5                	li	a7,17
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4c2:	48c9                	li	a7,18
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4ca:	48a1                	li	a7,8
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <link>:
.global link
link:
 li a7, SYS_link
 4d2:	48cd                	li	a7,19
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4da:	48d1                	li	a7,20
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4e2:	48a5                	li	a7,9
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <dup>:
.global dup
dup:
 li a7, SYS_dup
 4ea:	48a9                	li	a7,10
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4f2:	48ad                	li	a7,11
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4fa:	48b1                	li	a7,12
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 502:	48b5                	li	a7,13
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 50a:	48b9                	li	a7,14
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 512:	48dd                	li	a7,23
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <statistics>:
.global statistics
statistics:
 li a7, SYS_statistics
 51a:	48e1                	li	a7,24
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <reset_stats>:
.global reset_stats
reset_stats:
 li a7, SYS_reset_stats
 522:	48e5                	li	a7,25
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <resetlockstats>:
.global resetlockstats
resetlockstats:
 li a7, SYS_resetlockstats
 52a:	48e9                	li	a7,26
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <getlockstats>:
.global getlockstats
getlockstats:
 li a7, SYS_getlockstats
 532:	48ed                	li	a7,27
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <trace>:
.global trace
trace:
 li a7, SYS_trace
 53a:	48d9                	li	a7,22
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 542:	48f1                	li	a7,28
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <ugetpid>:
.global ugetpid
ugetpid:
 li a7, SYS_ugetpid
 54a:	48f5                	li	a7,29
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 552:	48f9                	li	a7,30
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 55a:	1101                	addi	sp,sp,-32
 55c:	ec06                	sd	ra,24(sp)
 55e:	e822                	sd	s0,16(sp)
 560:	1000                	addi	s0,sp,32
 562:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 566:	4605                	li	a2,1
 568:	fef40593          	addi	a1,s0,-17
 56c:	f27ff0ef          	jal	492 <write>
}
 570:	60e2                	ld	ra,24(sp)
 572:	6442                	ld	s0,16(sp)
 574:	6105                	addi	sp,sp,32
 576:	8082                	ret

0000000000000578 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 578:	7139                	addi	sp,sp,-64
 57a:	fc06                	sd	ra,56(sp)
 57c:	f822                	sd	s0,48(sp)
 57e:	f426                	sd	s1,40(sp)
 580:	0080                	addi	s0,sp,64
 582:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 584:	c299                	beqz	a3,58a <printint+0x12>
 586:	0805c963          	bltz	a1,618 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 58a:	2581                	sext.w	a1,a1
  neg = 0;
 58c:	4881                	li	a7,0
 58e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 592:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 594:	2601                	sext.w	a2,a2
 596:	00000517          	auipc	a0,0x0
 59a:	55a50513          	addi	a0,a0,1370 # af0 <digits>
 59e:	883a                	mv	a6,a4
 5a0:	2705                	addiw	a4,a4,1
 5a2:	02c5f7bb          	remuw	a5,a1,a2
 5a6:	1782                	slli	a5,a5,0x20
 5a8:	9381                	srli	a5,a5,0x20
 5aa:	97aa                	add	a5,a5,a0
 5ac:	0007c783          	lbu	a5,0(a5)
 5b0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5b4:	0005879b          	sext.w	a5,a1
 5b8:	02c5d5bb          	divuw	a1,a1,a2
 5bc:	0685                	addi	a3,a3,1
 5be:	fec7f0e3          	bgeu	a5,a2,59e <printint+0x26>
  if(neg)
 5c2:	00088c63          	beqz	a7,5da <printint+0x62>
    buf[i++] = '-';
 5c6:	fd070793          	addi	a5,a4,-48
 5ca:	00878733          	add	a4,a5,s0
 5ce:	02d00793          	li	a5,45
 5d2:	fef70823          	sb	a5,-16(a4)
 5d6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5da:	02e05a63          	blez	a4,60e <printint+0x96>
 5de:	f04a                	sd	s2,32(sp)
 5e0:	ec4e                	sd	s3,24(sp)
 5e2:	fc040793          	addi	a5,s0,-64
 5e6:	00e78933          	add	s2,a5,a4
 5ea:	fff78993          	addi	s3,a5,-1
 5ee:	99ba                	add	s3,s3,a4
 5f0:	377d                	addiw	a4,a4,-1
 5f2:	1702                	slli	a4,a4,0x20
 5f4:	9301                	srli	a4,a4,0x20
 5f6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5fa:	fff94583          	lbu	a1,-1(s2)
 5fe:	8526                	mv	a0,s1
 600:	f5bff0ef          	jal	55a <putc>
  while(--i >= 0)
 604:	197d                	addi	s2,s2,-1
 606:	ff391ae3          	bne	s2,s3,5fa <printint+0x82>
 60a:	7902                	ld	s2,32(sp)
 60c:	69e2                	ld	s3,24(sp)
}
 60e:	70e2                	ld	ra,56(sp)
 610:	7442                	ld	s0,48(sp)
 612:	74a2                	ld	s1,40(sp)
 614:	6121                	addi	sp,sp,64
 616:	8082                	ret
    x = -xx;
 618:	40b005bb          	negw	a1,a1
    neg = 1;
 61c:	4885                	li	a7,1
    x = -xx;
 61e:	bf85                	j	58e <printint+0x16>

0000000000000620 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 620:	711d                	addi	sp,sp,-96
 622:	ec86                	sd	ra,88(sp)
 624:	e8a2                	sd	s0,80(sp)
 626:	e0ca                	sd	s2,64(sp)
 628:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 62a:	0005c903          	lbu	s2,0(a1)
 62e:	26090863          	beqz	s2,89e <vprintf+0x27e>
 632:	e4a6                	sd	s1,72(sp)
 634:	fc4e                	sd	s3,56(sp)
 636:	f852                	sd	s4,48(sp)
 638:	f456                	sd	s5,40(sp)
 63a:	f05a                	sd	s6,32(sp)
 63c:	ec5e                	sd	s7,24(sp)
 63e:	e862                	sd	s8,16(sp)
 640:	e466                	sd	s9,8(sp)
 642:	8b2a                	mv	s6,a0
 644:	8a2e                	mv	s4,a1
 646:	8bb2                	mv	s7,a2
  state = 0;
 648:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 64a:	4481                	li	s1,0
 64c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 64e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 652:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 656:	06c00c93          	li	s9,108
 65a:	a005                	j	67a <vprintf+0x5a>
        putc(fd, c0);
 65c:	85ca                	mv	a1,s2
 65e:	855a                	mv	a0,s6
 660:	efbff0ef          	jal	55a <putc>
 664:	a019                	j	66a <vprintf+0x4a>
    } else if(state == '%'){
 666:	03598263          	beq	s3,s5,68a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 66a:	2485                	addiw	s1,s1,1
 66c:	8726                	mv	a4,s1
 66e:	009a07b3          	add	a5,s4,s1
 672:	0007c903          	lbu	s2,0(a5)
 676:	20090c63          	beqz	s2,88e <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 67a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 67e:	fe0994e3          	bnez	s3,666 <vprintf+0x46>
      if(c0 == '%'){
 682:	fd579de3          	bne	a5,s5,65c <vprintf+0x3c>
        state = '%';
 686:	89be                	mv	s3,a5
 688:	b7cd                	j	66a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 68a:	00ea06b3          	add	a3,s4,a4
 68e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 692:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 694:	c681                	beqz	a3,69c <vprintf+0x7c>
 696:	9752                	add	a4,a4,s4
 698:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 69c:	03878f63          	beq	a5,s8,6da <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 6a0:	05978963          	beq	a5,s9,6f2 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6a4:	07500713          	li	a4,117
 6a8:	0ee78363          	beq	a5,a4,78e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6ac:	07800713          	li	a4,120
 6b0:	12e78563          	beq	a5,a4,7da <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6b4:	07000713          	li	a4,112
 6b8:	14e78a63          	beq	a5,a4,80c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6bc:	07300713          	li	a4,115
 6c0:	18e78a63          	beq	a5,a4,854 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6c4:	02500713          	li	a4,37
 6c8:	04e79563          	bne	a5,a4,712 <vprintf+0xf2>
        putc(fd, '%');
 6cc:	02500593          	li	a1,37
 6d0:	855a                	mv	a0,s6
 6d2:	e89ff0ef          	jal	55a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6d6:	4981                	li	s3,0
 6d8:	bf49                	j	66a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6da:	008b8913          	addi	s2,s7,8
 6de:	4685                	li	a3,1
 6e0:	4629                	li	a2,10
 6e2:	000ba583          	lw	a1,0(s7)
 6e6:	855a                	mv	a0,s6
 6e8:	e91ff0ef          	jal	578 <printint>
 6ec:	8bca                	mv	s7,s2
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	bfad                	j	66a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6f2:	06400793          	li	a5,100
 6f6:	02f68963          	beq	a3,a5,728 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6fa:	06c00793          	li	a5,108
 6fe:	04f68263          	beq	a3,a5,742 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 702:	07500793          	li	a5,117
 706:	0af68063          	beq	a3,a5,7a6 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 70a:	07800793          	li	a5,120
 70e:	0ef68263          	beq	a3,a5,7f2 <vprintf+0x1d2>
        putc(fd, '%');
 712:	02500593          	li	a1,37
 716:	855a                	mv	a0,s6
 718:	e43ff0ef          	jal	55a <putc>
        putc(fd, c0);
 71c:	85ca                	mv	a1,s2
 71e:	855a                	mv	a0,s6
 720:	e3bff0ef          	jal	55a <putc>
      state = 0;
 724:	4981                	li	s3,0
 726:	b791                	j	66a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 728:	008b8913          	addi	s2,s7,8
 72c:	4685                	li	a3,1
 72e:	4629                	li	a2,10
 730:	000ba583          	lw	a1,0(s7)
 734:	855a                	mv	a0,s6
 736:	e43ff0ef          	jal	578 <printint>
        i += 1;
 73a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 73c:	8bca                	mv	s7,s2
      state = 0;
 73e:	4981                	li	s3,0
        i += 1;
 740:	b72d                	j	66a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 742:	06400793          	li	a5,100
 746:	02f60763          	beq	a2,a5,774 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 74a:	07500793          	li	a5,117
 74e:	06f60963          	beq	a2,a5,7c0 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 752:	07800793          	li	a5,120
 756:	faf61ee3          	bne	a2,a5,712 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 75a:	008b8913          	addi	s2,s7,8
 75e:	4681                	li	a3,0
 760:	4641                	li	a2,16
 762:	000ba583          	lw	a1,0(s7)
 766:	855a                	mv	a0,s6
 768:	e11ff0ef          	jal	578 <printint>
        i += 2;
 76c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 76e:	8bca                	mv	s7,s2
      state = 0;
 770:	4981                	li	s3,0
        i += 2;
 772:	bde5                	j	66a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 774:	008b8913          	addi	s2,s7,8
 778:	4685                	li	a3,1
 77a:	4629                	li	a2,10
 77c:	000ba583          	lw	a1,0(s7)
 780:	855a                	mv	a0,s6
 782:	df7ff0ef          	jal	578 <printint>
        i += 2;
 786:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 788:	8bca                	mv	s7,s2
      state = 0;
 78a:	4981                	li	s3,0
        i += 2;
 78c:	bdf9                	j	66a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 78e:	008b8913          	addi	s2,s7,8
 792:	4681                	li	a3,0
 794:	4629                	li	a2,10
 796:	000ba583          	lw	a1,0(s7)
 79a:	855a                	mv	a0,s6
 79c:	dddff0ef          	jal	578 <printint>
 7a0:	8bca                	mv	s7,s2
      state = 0;
 7a2:	4981                	li	s3,0
 7a4:	b5d9                	j	66a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a6:	008b8913          	addi	s2,s7,8
 7aa:	4681                	li	a3,0
 7ac:	4629                	li	a2,10
 7ae:	000ba583          	lw	a1,0(s7)
 7b2:	855a                	mv	a0,s6
 7b4:	dc5ff0ef          	jal	578 <printint>
        i += 1;
 7b8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ba:	8bca                	mv	s7,s2
      state = 0;
 7bc:	4981                	li	s3,0
        i += 1;
 7be:	b575                	j	66a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c0:	008b8913          	addi	s2,s7,8
 7c4:	4681                	li	a3,0
 7c6:	4629                	li	a2,10
 7c8:	000ba583          	lw	a1,0(s7)
 7cc:	855a                	mv	a0,s6
 7ce:	dabff0ef          	jal	578 <printint>
        i += 2;
 7d2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d4:	8bca                	mv	s7,s2
      state = 0;
 7d6:	4981                	li	s3,0
        i += 2;
 7d8:	bd49                	j	66a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7da:	008b8913          	addi	s2,s7,8
 7de:	4681                	li	a3,0
 7e0:	4641                	li	a2,16
 7e2:	000ba583          	lw	a1,0(s7)
 7e6:	855a                	mv	a0,s6
 7e8:	d91ff0ef          	jal	578 <printint>
 7ec:	8bca                	mv	s7,s2
      state = 0;
 7ee:	4981                	li	s3,0
 7f0:	bdad                	j	66a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7f2:	008b8913          	addi	s2,s7,8
 7f6:	4681                	li	a3,0
 7f8:	4641                	li	a2,16
 7fa:	000ba583          	lw	a1,0(s7)
 7fe:	855a                	mv	a0,s6
 800:	d79ff0ef          	jal	578 <printint>
        i += 1;
 804:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 806:	8bca                	mv	s7,s2
      state = 0;
 808:	4981                	li	s3,0
        i += 1;
 80a:	b585                	j	66a <vprintf+0x4a>
 80c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 80e:	008b8d13          	addi	s10,s7,8
 812:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 816:	03000593          	li	a1,48
 81a:	855a                	mv	a0,s6
 81c:	d3fff0ef          	jal	55a <putc>
  putc(fd, 'x');
 820:	07800593          	li	a1,120
 824:	855a                	mv	a0,s6
 826:	d35ff0ef          	jal	55a <putc>
 82a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 82c:	00000b97          	auipc	s7,0x0
 830:	2c4b8b93          	addi	s7,s7,708 # af0 <digits>
 834:	03c9d793          	srli	a5,s3,0x3c
 838:	97de                	add	a5,a5,s7
 83a:	0007c583          	lbu	a1,0(a5)
 83e:	855a                	mv	a0,s6
 840:	d1bff0ef          	jal	55a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 844:	0992                	slli	s3,s3,0x4
 846:	397d                	addiw	s2,s2,-1
 848:	fe0916e3          	bnez	s2,834 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 84c:	8bea                	mv	s7,s10
      state = 0;
 84e:	4981                	li	s3,0
 850:	6d02                	ld	s10,0(sp)
 852:	bd21                	j	66a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 854:	008b8993          	addi	s3,s7,8
 858:	000bb903          	ld	s2,0(s7)
 85c:	00090f63          	beqz	s2,87a <vprintf+0x25a>
        for(; *s; s++)
 860:	00094583          	lbu	a1,0(s2)
 864:	c195                	beqz	a1,888 <vprintf+0x268>
          putc(fd, *s);
 866:	855a                	mv	a0,s6
 868:	cf3ff0ef          	jal	55a <putc>
        for(; *s; s++)
 86c:	0905                	addi	s2,s2,1
 86e:	00094583          	lbu	a1,0(s2)
 872:	f9f5                	bnez	a1,866 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 874:	8bce                	mv	s7,s3
      state = 0;
 876:	4981                	li	s3,0
 878:	bbcd                	j	66a <vprintf+0x4a>
          s = "(null)";
 87a:	00000917          	auipc	s2,0x0
 87e:	26e90913          	addi	s2,s2,622 # ae8 <malloc+0x162>
        for(; *s; s++)
 882:	02800593          	li	a1,40
 886:	b7c5                	j	866 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 888:	8bce                	mv	s7,s3
      state = 0;
 88a:	4981                	li	s3,0
 88c:	bbf9                	j	66a <vprintf+0x4a>
 88e:	64a6                	ld	s1,72(sp)
 890:	79e2                	ld	s3,56(sp)
 892:	7a42                	ld	s4,48(sp)
 894:	7aa2                	ld	s5,40(sp)
 896:	7b02                	ld	s6,32(sp)
 898:	6be2                	ld	s7,24(sp)
 89a:	6c42                	ld	s8,16(sp)
 89c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 89e:	60e6                	ld	ra,88(sp)
 8a0:	6446                	ld	s0,80(sp)
 8a2:	6906                	ld	s2,64(sp)
 8a4:	6125                	addi	sp,sp,96
 8a6:	8082                	ret

00000000000008a8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8a8:	715d                	addi	sp,sp,-80
 8aa:	ec06                	sd	ra,24(sp)
 8ac:	e822                	sd	s0,16(sp)
 8ae:	1000                	addi	s0,sp,32
 8b0:	e010                	sd	a2,0(s0)
 8b2:	e414                	sd	a3,8(s0)
 8b4:	e818                	sd	a4,16(s0)
 8b6:	ec1c                	sd	a5,24(s0)
 8b8:	03043023          	sd	a6,32(s0)
 8bc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8c0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8c4:	8622                	mv	a2,s0
 8c6:	d5bff0ef          	jal	620 <vprintf>
}
 8ca:	60e2                	ld	ra,24(sp)
 8cc:	6442                	ld	s0,16(sp)
 8ce:	6161                	addi	sp,sp,80
 8d0:	8082                	ret

00000000000008d2 <printf>:

void
printf(const char *fmt, ...)
{
 8d2:	711d                	addi	sp,sp,-96
 8d4:	ec06                	sd	ra,24(sp)
 8d6:	e822                	sd	s0,16(sp)
 8d8:	1000                	addi	s0,sp,32
 8da:	e40c                	sd	a1,8(s0)
 8dc:	e810                	sd	a2,16(s0)
 8de:	ec14                	sd	a3,24(s0)
 8e0:	f018                	sd	a4,32(s0)
 8e2:	f41c                	sd	a5,40(s0)
 8e4:	03043823          	sd	a6,48(s0)
 8e8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8ec:	00840613          	addi	a2,s0,8
 8f0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8f4:	85aa                	mv	a1,a0
 8f6:	4505                	li	a0,1
 8f8:	d29ff0ef          	jal	620 <vprintf>
}
 8fc:	60e2                	ld	ra,24(sp)
 8fe:	6442                	ld	s0,16(sp)
 900:	6125                	addi	sp,sp,96
 902:	8082                	ret

0000000000000904 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 904:	1141                	addi	sp,sp,-16
 906:	e422                	sd	s0,8(sp)
 908:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 90a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90e:	00000797          	auipc	a5,0x0
 912:	6f27b783          	ld	a5,1778(a5) # 1000 <freep>
 916:	a02d                	j	940 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 918:	4618                	lw	a4,8(a2)
 91a:	9f2d                	addw	a4,a4,a1
 91c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 920:	6398                	ld	a4,0(a5)
 922:	6310                	ld	a2,0(a4)
 924:	a83d                	j	962 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 926:	ff852703          	lw	a4,-8(a0)
 92a:	9f31                	addw	a4,a4,a2
 92c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 92e:	ff053683          	ld	a3,-16(a0)
 932:	a091                	j	976 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 934:	6398                	ld	a4,0(a5)
 936:	00e7e463          	bltu	a5,a4,93e <free+0x3a>
 93a:	00e6ea63          	bltu	a3,a4,94e <free+0x4a>
{
 93e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 940:	fed7fae3          	bgeu	a5,a3,934 <free+0x30>
 944:	6398                	ld	a4,0(a5)
 946:	00e6e463          	bltu	a3,a4,94e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 94a:	fee7eae3          	bltu	a5,a4,93e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 94e:	ff852583          	lw	a1,-8(a0)
 952:	6390                	ld	a2,0(a5)
 954:	02059813          	slli	a6,a1,0x20
 958:	01c85713          	srli	a4,a6,0x1c
 95c:	9736                	add	a4,a4,a3
 95e:	fae60de3          	beq	a2,a4,918 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 962:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 966:	4790                	lw	a2,8(a5)
 968:	02061593          	slli	a1,a2,0x20
 96c:	01c5d713          	srli	a4,a1,0x1c
 970:	973e                	add	a4,a4,a5
 972:	fae68ae3          	beq	a3,a4,926 <free+0x22>
    p->s.ptr = bp->s.ptr;
 976:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 978:	00000717          	auipc	a4,0x0
 97c:	68f73423          	sd	a5,1672(a4) # 1000 <freep>
}
 980:	6422                	ld	s0,8(sp)
 982:	0141                	addi	sp,sp,16
 984:	8082                	ret

0000000000000986 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 986:	7139                	addi	sp,sp,-64
 988:	fc06                	sd	ra,56(sp)
 98a:	f822                	sd	s0,48(sp)
 98c:	f426                	sd	s1,40(sp)
 98e:	ec4e                	sd	s3,24(sp)
 990:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 992:	02051493          	slli	s1,a0,0x20
 996:	9081                	srli	s1,s1,0x20
 998:	04bd                	addi	s1,s1,15
 99a:	8091                	srli	s1,s1,0x4
 99c:	0014899b          	addiw	s3,s1,1
 9a0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9a2:	00000517          	auipc	a0,0x0
 9a6:	65e53503          	ld	a0,1630(a0) # 1000 <freep>
 9aa:	c915                	beqz	a0,9de <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ae:	4798                	lw	a4,8(a5)
 9b0:	08977a63          	bgeu	a4,s1,a44 <malloc+0xbe>
 9b4:	f04a                	sd	s2,32(sp)
 9b6:	e852                	sd	s4,16(sp)
 9b8:	e456                	sd	s5,8(sp)
 9ba:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9bc:	8a4e                	mv	s4,s3
 9be:	0009871b          	sext.w	a4,s3
 9c2:	6685                	lui	a3,0x1
 9c4:	00d77363          	bgeu	a4,a3,9ca <malloc+0x44>
 9c8:	6a05                	lui	s4,0x1
 9ca:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9ce:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9d2:	00000917          	auipc	s2,0x0
 9d6:	62e90913          	addi	s2,s2,1582 # 1000 <freep>
  if(p == (char*)-1)
 9da:	5afd                	li	s5,-1
 9dc:	a081                	j	a1c <malloc+0x96>
 9de:	f04a                	sd	s2,32(sp)
 9e0:	e852                	sd	s4,16(sp)
 9e2:	e456                	sd	s5,8(sp)
 9e4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9e6:	00000797          	auipc	a5,0x0
 9ea:	62a78793          	addi	a5,a5,1578 # 1010 <base>
 9ee:	00000717          	auipc	a4,0x0
 9f2:	60f73923          	sd	a5,1554(a4) # 1000 <freep>
 9f6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9f8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9fc:	b7c1                	j	9bc <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9fe:	6398                	ld	a4,0(a5)
 a00:	e118                	sd	a4,0(a0)
 a02:	a8a9                	j	a5c <malloc+0xd6>
  hp->s.size = nu;
 a04:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a08:	0541                	addi	a0,a0,16
 a0a:	efbff0ef          	jal	904 <free>
  return freep;
 a0e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a12:	c12d                	beqz	a0,a74 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a14:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a16:	4798                	lw	a4,8(a5)
 a18:	02977263          	bgeu	a4,s1,a3c <malloc+0xb6>
    if(p == freep)
 a1c:	00093703          	ld	a4,0(s2)
 a20:	853e                	mv	a0,a5
 a22:	fef719e3          	bne	a4,a5,a14 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a26:	8552                	mv	a0,s4
 a28:	ad3ff0ef          	jal	4fa <sbrk>
  if(p == (char*)-1)
 a2c:	fd551ce3          	bne	a0,s5,a04 <malloc+0x7e>
        return 0;
 a30:	4501                	li	a0,0
 a32:	7902                	ld	s2,32(sp)
 a34:	6a42                	ld	s4,16(sp)
 a36:	6aa2                	ld	s5,8(sp)
 a38:	6b02                	ld	s6,0(sp)
 a3a:	a03d                	j	a68 <malloc+0xe2>
 a3c:	7902                	ld	s2,32(sp)
 a3e:	6a42                	ld	s4,16(sp)
 a40:	6aa2                	ld	s5,8(sp)
 a42:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a44:	fae48de3          	beq	s1,a4,9fe <malloc+0x78>
        p->s.size -= nunits;
 a48:	4137073b          	subw	a4,a4,s3
 a4c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a4e:	02071693          	slli	a3,a4,0x20
 a52:	01c6d713          	srli	a4,a3,0x1c
 a56:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a58:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a5c:	00000717          	auipc	a4,0x0
 a60:	5aa73223          	sd	a0,1444(a4) # 1000 <freep>
      return (void*)(p + 1);
 a64:	01078513          	addi	a0,a5,16
  }
}
 a68:	70e2                	ld	ra,56(sp)
 a6a:	7442                	ld	s0,48(sp)
 a6c:	74a2                	ld	s1,40(sp)
 a6e:	69e2                	ld	s3,24(sp)
 a70:	6121                	addi	sp,sp,64
 a72:	8082                	ret
 a74:	7902                	ld	s2,32(sp)
 a76:	6a42                	ld	s4,16(sp)
 a78:	6aa2                	ld	s5,8(sp)
 a7a:	6b02                	ld	s6,0(sp)
 a7c:	b7f5                	j	a68 <malloc+0xe2>
