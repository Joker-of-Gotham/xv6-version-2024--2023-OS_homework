
user/_init：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	a6250513          	addi	a0,a0,-1438 # a70 <malloc+0x106>
  16:	480000ef          	jal	496 <open>
  1a:	04054563          	bltz	a0,64 <main+0x64>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  1e:	4501                	li	a0,0
  20:	4ae000ef          	jal	4ce <dup>
  dup(0);  // stderr
  24:	4501                	li	a0,0
  26:	4a8000ef          	jal	4ce <dup>

  for(;;){
    printf("init: starting sh\n");
  2a:	00001917          	auipc	s2,0x1
  2e:	a4e90913          	addi	s2,s2,-1458 # a78 <malloc+0x10e>
  32:	854a                	mv	a0,s2
  34:	083000ef          	jal	8b6 <printf>
    pid = fork();
  38:	416000ef          	jal	44e <fork>
  3c:	84aa                	mv	s1,a0
    if(pid < 0){
  3e:	04054363          	bltz	a0,84 <main+0x84>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  42:	c931                	beqz	a0,96 <main+0x96>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  44:	4501                	li	a0,0
  46:	418000ef          	jal	45e <wait>
      if(wpid == pid){
  4a:	fea484e3          	beq	s1,a0,32 <main+0x32>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  4e:	fe055be3          	bgez	a0,44 <main+0x44>
        printf("init: wait returned an error\n");
  52:	00001517          	auipc	a0,0x1
  56:	a7650513          	addi	a0,a0,-1418 # ac8 <malloc+0x15e>
  5a:	05d000ef          	jal	8b6 <printf>
        exit(1);
  5e:	4505                	li	a0,1
  60:	3f6000ef          	jal	456 <exit>
    mknod("console", CONSOLE, 0);
  64:	4601                	li	a2,0
  66:	4585                	li	a1,1
  68:	00001517          	auipc	a0,0x1
  6c:	a0850513          	addi	a0,a0,-1528 # a70 <malloc+0x106>
  70:	42e000ef          	jal	49e <mknod>
    open("console", O_RDWR);
  74:	4589                	li	a1,2
  76:	00001517          	auipc	a0,0x1
  7a:	9fa50513          	addi	a0,a0,-1542 # a70 <malloc+0x106>
  7e:	418000ef          	jal	496 <open>
  82:	bf71                	j	1e <main+0x1e>
      printf("init: fork failed\n");
  84:	00001517          	auipc	a0,0x1
  88:	a0c50513          	addi	a0,a0,-1524 # a90 <malloc+0x126>
  8c:	02b000ef          	jal	8b6 <printf>
      exit(1);
  90:	4505                	li	a0,1
  92:	3c4000ef          	jal	456 <exit>
      exec("sh", argv);
  96:	00001597          	auipc	a1,0x1
  9a:	f6a58593          	addi	a1,a1,-150 # 1000 <argv>
  9e:	00001517          	auipc	a0,0x1
  a2:	a0a50513          	addi	a0,a0,-1526 # aa8 <malloc+0x13e>
  a6:	3e8000ef          	jal	48e <exec>
      printf("init: exec sh failed\n");
  aa:	00001517          	auipc	a0,0x1
  ae:	a0650513          	addi	a0,a0,-1530 # ab0 <malloc+0x146>
  b2:	005000ef          	jal	8b6 <printf>
      exit(1);
  b6:	4505                	li	a0,1
  b8:	39e000ef          	jal	456 <exit>

00000000000000bc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  extern int main();
  main();
  c4:	f3dff0ef          	jal	0 <main>
  exit(0);
  c8:	4501                	li	a0,0
  ca:	38c000ef          	jal	456 <exit>

00000000000000ce <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ce:	1141                	addi	sp,sp,-16
  d0:	e422                	sd	s0,8(sp)
  d2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d4:	87aa                	mv	a5,a0
  d6:	0585                	addi	a1,a1,1
  d8:	0785                	addi	a5,a5,1
  da:	fff5c703          	lbu	a4,-1(a1)
  de:	fee78fa3          	sb	a4,-1(a5)
  e2:	fb75                	bnez	a4,d6 <strcpy+0x8>
    ;
  return os;
}
  e4:	6422                	ld	s0,8(sp)
  e6:	0141                	addi	sp,sp,16
  e8:	8082                	ret

00000000000000ea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e422                	sd	s0,8(sp)
  ee:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  f0:	00054783          	lbu	a5,0(a0)
  f4:	cb91                	beqz	a5,108 <strcmp+0x1e>
  f6:	0005c703          	lbu	a4,0(a1)
  fa:	00f71763          	bne	a4,a5,108 <strcmp+0x1e>
    p++, q++;
  fe:	0505                	addi	a0,a0,1
 100:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 102:	00054783          	lbu	a5,0(a0)
 106:	fbe5                	bnez	a5,f6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 108:	0005c503          	lbu	a0,0(a1)
}
 10c:	40a7853b          	subw	a0,a5,a0
 110:	6422                	ld	s0,8(sp)
 112:	0141                	addi	sp,sp,16
 114:	8082                	ret

0000000000000116 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 116:	1141                	addi	sp,sp,-16
 118:	e422                	sd	s0,8(sp)
 11a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q) {
 11c:	ce11                	beqz	a2,138 <strncmp+0x22>
 11e:	00054783          	lbu	a5,0(a0)
 122:	cf89                	beqz	a5,13c <strncmp+0x26>
 124:	0005c703          	lbu	a4,0(a1)
 128:	00f71a63          	bne	a4,a5,13c <strncmp+0x26>
    n--;
 12c:	367d                	addiw	a2,a2,-1
    p++;
 12e:	0505                	addi	a0,a0,1
    q++;
 130:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q) {
 132:	f675                	bnez	a2,11e <strncmp+0x8>
  }
  if(n == 0)
    return 0;
 134:	4501                	li	a0,0
 136:	a801                	j	146 <strncmp+0x30>
 138:	4501                	li	a0,0
 13a:	a031                	j	146 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
 13c:	00054503          	lbu	a0,0(a0)
 140:	0005c783          	lbu	a5,0(a1)
 144:	9d1d                	subw	a0,a0,a5
}
 146:	6422                	ld	s0,8(sp)
 148:	0141                	addi	sp,sp,16
 14a:	8082                	ret

000000000000014c <strlen>:

uint
strlen(const char *s)
{
 14c:	1141                	addi	sp,sp,-16
 14e:	e422                	sd	s0,8(sp)
 150:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 152:	00054783          	lbu	a5,0(a0)
 156:	cf91                	beqz	a5,172 <strlen+0x26>
 158:	0505                	addi	a0,a0,1
 15a:	87aa                	mv	a5,a0
 15c:	86be                	mv	a3,a5
 15e:	0785                	addi	a5,a5,1
 160:	fff7c703          	lbu	a4,-1(a5)
 164:	ff65                	bnez	a4,15c <strlen+0x10>
 166:	40a6853b          	subw	a0,a3,a0
 16a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 16c:	6422                	ld	s0,8(sp)
 16e:	0141                	addi	sp,sp,16
 170:	8082                	ret
  for(n = 0; s[n]; n++)
 172:	4501                	li	a0,0
 174:	bfe5                	j	16c <strlen+0x20>

0000000000000176 <memset>:

void*
memset(void *dst, int c, uint n)
{
 176:	1141                	addi	sp,sp,-16
 178:	e422                	sd	s0,8(sp)
 17a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 17c:	ca19                	beqz	a2,192 <memset+0x1c>
 17e:	87aa                	mv	a5,a0
 180:	1602                	slli	a2,a2,0x20
 182:	9201                	srli	a2,a2,0x20
 184:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 188:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 18c:	0785                	addi	a5,a5,1
 18e:	fee79de3          	bne	a5,a4,188 <memset+0x12>
  }
  return dst;
}
 192:	6422                	ld	s0,8(sp)
 194:	0141                	addi	sp,sp,16
 196:	8082                	ret

0000000000000198 <strchr>:

char*
strchr(const char *s, char c)
{
 198:	1141                	addi	sp,sp,-16
 19a:	e422                	sd	s0,8(sp)
 19c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 19e:	00054783          	lbu	a5,0(a0)
 1a2:	cb99                	beqz	a5,1b8 <strchr+0x20>
    if(*s == c)
 1a4:	00f58763          	beq	a1,a5,1b2 <strchr+0x1a>
  for(; *s; s++)
 1a8:	0505                	addi	a0,a0,1
 1aa:	00054783          	lbu	a5,0(a0)
 1ae:	fbfd                	bnez	a5,1a4 <strchr+0xc>
      return (char*)s;
  return 0;
 1b0:	4501                	li	a0,0
}
 1b2:	6422                	ld	s0,8(sp)
 1b4:	0141                	addi	sp,sp,16
 1b6:	8082                	ret
  return 0;
 1b8:	4501                	li	a0,0
 1ba:	bfe5                	j	1b2 <strchr+0x1a>

00000000000001bc <gets>:

char*
gets(char *buf, int max)
{
 1bc:	711d                	addi	sp,sp,-96
 1be:	ec86                	sd	ra,88(sp)
 1c0:	e8a2                	sd	s0,80(sp)
 1c2:	e4a6                	sd	s1,72(sp)
 1c4:	e0ca                	sd	s2,64(sp)
 1c6:	fc4e                	sd	s3,56(sp)
 1c8:	f852                	sd	s4,48(sp)
 1ca:	f456                	sd	s5,40(sp)
 1cc:	f05a                	sd	s6,32(sp)
 1ce:	ec5e                	sd	s7,24(sp)
 1d0:	1080                	addi	s0,sp,96
 1d2:	8baa                	mv	s7,a0
 1d4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d6:	892a                	mv	s2,a0
 1d8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1da:	4aa9                	li	s5,10
 1dc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1de:	89a6                	mv	s3,s1
 1e0:	2485                	addiw	s1,s1,1
 1e2:	0344d663          	bge	s1,s4,20e <gets+0x52>
    cc = read(0, &c, 1);
 1e6:	4605                	li	a2,1
 1e8:	faf40593          	addi	a1,s0,-81
 1ec:	4501                	li	a0,0
 1ee:	280000ef          	jal	46e <read>
    if(cc < 1)
 1f2:	00a05e63          	blez	a0,20e <gets+0x52>
    buf[i++] = c;
 1f6:	faf44783          	lbu	a5,-81(s0)
 1fa:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1fe:	01578763          	beq	a5,s5,20c <gets+0x50>
 202:	0905                	addi	s2,s2,1
 204:	fd679de3          	bne	a5,s6,1de <gets+0x22>
    buf[i++] = c;
 208:	89a6                	mv	s3,s1
 20a:	a011                	j	20e <gets+0x52>
 20c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 20e:	99de                	add	s3,s3,s7
 210:	00098023          	sb	zero,0(s3)
  return buf;
}
 214:	855e                	mv	a0,s7
 216:	60e6                	ld	ra,88(sp)
 218:	6446                	ld	s0,80(sp)
 21a:	64a6                	ld	s1,72(sp)
 21c:	6906                	ld	s2,64(sp)
 21e:	79e2                	ld	s3,56(sp)
 220:	7a42                	ld	s4,48(sp)
 222:	7aa2                	ld	s5,40(sp)
 224:	7b02                	ld	s6,32(sp)
 226:	6be2                	ld	s7,24(sp)
 228:	6125                	addi	sp,sp,96
 22a:	8082                	ret

000000000000022c <stat>:

int
stat(const char *n, struct stat *st)
{
 22c:	1101                	addi	sp,sp,-32
 22e:	ec06                	sd	ra,24(sp)
 230:	e822                	sd	s0,16(sp)
 232:	e04a                	sd	s2,0(sp)
 234:	1000                	addi	s0,sp,32
 236:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 238:	4581                	li	a1,0
 23a:	25c000ef          	jal	496 <open>
  if(fd < 0)
 23e:	02054263          	bltz	a0,262 <stat+0x36>
 242:	e426                	sd	s1,8(sp)
 244:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 246:	85ca                	mv	a1,s2
 248:	266000ef          	jal	4ae <fstat>
 24c:	892a                	mv	s2,a0
  close(fd);
 24e:	8526                	mv	a0,s1
 250:	22e000ef          	jal	47e <close>
  return r;
 254:	64a2                	ld	s1,8(sp)
}
 256:	854a                	mv	a0,s2
 258:	60e2                	ld	ra,24(sp)
 25a:	6442                	ld	s0,16(sp)
 25c:	6902                	ld	s2,0(sp)
 25e:	6105                	addi	sp,sp,32
 260:	8082                	ret
    return -1;
 262:	597d                	li	s2,-1
 264:	bfcd                	j	256 <stat+0x2a>

0000000000000266 <atoi>:

int
atoi(const char *s)
{
 266:	1141                	addi	sp,sp,-16
 268:	e422                	sd	s0,8(sp)
 26a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26c:	00054683          	lbu	a3,0(a0)
 270:	fd06879b          	addiw	a5,a3,-48
 274:	0ff7f793          	zext.b	a5,a5
 278:	4625                	li	a2,9
 27a:	02f66863          	bltu	a2,a5,2aa <atoi+0x44>
 27e:	872a                	mv	a4,a0
  n = 0;
 280:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 282:	0705                	addi	a4,a4,1
 284:	0025179b          	slliw	a5,a0,0x2
 288:	9fa9                	addw	a5,a5,a0
 28a:	0017979b          	slliw	a5,a5,0x1
 28e:	9fb5                	addw	a5,a5,a3
 290:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 294:	00074683          	lbu	a3,0(a4)
 298:	fd06879b          	addiw	a5,a3,-48
 29c:	0ff7f793          	zext.b	a5,a5
 2a0:	fef671e3          	bgeu	a2,a5,282 <atoi+0x1c>
  return n;
}
 2a4:	6422                	ld	s0,8(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret
  n = 0;
 2aa:	4501                	li	a0,0
 2ac:	bfe5                	j	2a4 <atoi+0x3e>

00000000000002ae <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ae:	1141                	addi	sp,sp,-16
 2b0:	e422                	sd	s0,8(sp)
 2b2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2b4:	02b57463          	bgeu	a0,a1,2dc <memmove+0x2e>
    while(n-- > 0)
 2b8:	00c05f63          	blez	a2,2d6 <memmove+0x28>
 2bc:	1602                	slli	a2,a2,0x20
 2be:	9201                	srli	a2,a2,0x20
 2c0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2c4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2c6:	0585                	addi	a1,a1,1
 2c8:	0705                	addi	a4,a4,1
 2ca:	fff5c683          	lbu	a3,-1(a1)
 2ce:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2d2:	fef71ae3          	bne	a4,a5,2c6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret
    dst += n;
 2dc:	00c50733          	add	a4,a0,a2
    src += n;
 2e0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2e2:	fec05ae3          	blez	a2,2d6 <memmove+0x28>
 2e6:	fff6079b          	addiw	a5,a2,-1
 2ea:	1782                	slli	a5,a5,0x20
 2ec:	9381                	srli	a5,a5,0x20
 2ee:	fff7c793          	not	a5,a5
 2f2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2f4:	15fd                	addi	a1,a1,-1
 2f6:	177d                	addi	a4,a4,-1
 2f8:	0005c683          	lbu	a3,0(a1)
 2fc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 300:	fee79ae3          	bne	a5,a4,2f4 <memmove+0x46>
 304:	bfc9                	j	2d6 <memmove+0x28>

0000000000000306 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 306:	1141                	addi	sp,sp,-16
 308:	e422                	sd	s0,8(sp)
 30a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 30c:	ca05                	beqz	a2,33c <memcmp+0x36>
 30e:	fff6069b          	addiw	a3,a2,-1
 312:	1682                	slli	a3,a3,0x20
 314:	9281                	srli	a3,a3,0x20
 316:	0685                	addi	a3,a3,1
 318:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 31a:	00054783          	lbu	a5,0(a0)
 31e:	0005c703          	lbu	a4,0(a1)
 322:	00e79863          	bne	a5,a4,332 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 326:	0505                	addi	a0,a0,1
    p2++;
 328:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 32a:	fed518e3          	bne	a0,a3,31a <memcmp+0x14>
  }
  return 0;
 32e:	4501                	li	a0,0
 330:	a019                	j	336 <memcmp+0x30>
      return *p1 - *p2;
 332:	40e7853b          	subw	a0,a5,a4
}
 336:	6422                	ld	s0,8(sp)
 338:	0141                	addi	sp,sp,16
 33a:	8082                	ret
  return 0;
 33c:	4501                	li	a0,0
 33e:	bfe5                	j	336 <memcmp+0x30>

0000000000000340 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 340:	1141                	addi	sp,sp,-16
 342:	e406                	sd	ra,8(sp)
 344:	e022                	sd	s0,0(sp)
 346:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 348:	f67ff0ef          	jal	2ae <memmove>
}
 34c:	60a2                	ld	ra,8(sp)
 34e:	6402                	ld	s0,0(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret

0000000000000354 <simplesort>:

void
simplesort(void *base, uint nmemb, uint size, int (*compar)(const void *, const void *))
{
 354:	7119                	addi	sp,sp,-128
 356:	fc86                	sd	ra,120(sp)
 358:	f8a2                	sd	s0,112(sp)
 35a:	0100                	addi	s0,sp,128
 35c:	f8b43423          	sd	a1,-120(s0)
  char *arr = (char *)base; // Treat array as char array for byte-level manipulation
  char *temp;               // Temporary storage for an element

  if (nmemb <= 1 || size == 0) {
 360:	4785                	li	a5,1
 362:	00b7fc63          	bgeu	a5,a1,37a <simplesort+0x26>
 366:	e8d2                	sd	s4,80(sp)
 368:	e4d6                	sd	s5,72(sp)
 36a:	f466                	sd	s9,40(sp)
 36c:	8aaa                	mv	s5,a0
 36e:	8a32                	mv	s4,a2
 370:	8cb6                	mv	s9,a3
 372:	ea01                	bnez	a2,382 <simplesort+0x2e>
 374:	6a46                	ld	s4,80(sp)
 376:	6aa6                	ld	s5,72(sp)
 378:	7ca2                	ld	s9,40(sp)
    // Place temp at its correct position
    memmove(arr + j * size, temp, size);
  }

  free(temp); // Free temporary space
 37a:	70e6                	ld	ra,120(sp)
 37c:	7446                	ld	s0,112(sp)
 37e:	6109                	addi	sp,sp,128
 380:	8082                	ret
 382:	fc5e                	sd	s7,56(sp)
 384:	f862                	sd	s8,48(sp)
 386:	f06a                	sd	s10,32(sp)
 388:	ec6e                	sd	s11,24(sp)
  temp = malloc(size); // Allocate temporary space for one element
 38a:	8532                	mv	a0,a2
 38c:	5de000ef          	jal	96a <malloc>
 390:	8baa                	mv	s7,a0
  if (temp == 0) {
 392:	4d81                	li	s11,0
  for (uint i = 1; i < nmemb; i++) {
 394:	4d05                	li	s10,1
    memmove(temp, arr + i * size, size);
 396:	000a0c1b          	sext.w	s8,s4
  if (temp == 0) {
 39a:	c511                	beqz	a0,3a6 <simplesort+0x52>
 39c:	f4a6                	sd	s1,104(sp)
 39e:	f0ca                	sd	s2,96(sp)
 3a0:	ecce                	sd	s3,88(sp)
 3a2:	e0da                	sd	s6,64(sp)
 3a4:	a82d                	j	3de <simplesort+0x8a>
    printf("simplesort: malloc failed, cannot sort\n");
 3a6:	00000517          	auipc	a0,0x0
 3aa:	74250513          	addi	a0,a0,1858 # ae8 <malloc+0x17e>
 3ae:	508000ef          	jal	8b6 <printf>
    return;
 3b2:	6a46                	ld	s4,80(sp)
 3b4:	6aa6                	ld	s5,72(sp)
 3b6:	7be2                	ld	s7,56(sp)
 3b8:	7c42                	ld	s8,48(sp)
 3ba:	7ca2                	ld	s9,40(sp)
 3bc:	7d02                	ld	s10,32(sp)
 3be:	6de2                	ld	s11,24(sp)
 3c0:	bf6d                	j	37a <simplesort+0x26>
    memmove(arr + j * size, temp, size);
 3c2:	036a053b          	mulw	a0,s4,s6
 3c6:	1502                	slli	a0,a0,0x20
 3c8:	9101                	srli	a0,a0,0x20
 3ca:	8662                	mv	a2,s8
 3cc:	85de                	mv	a1,s7
 3ce:	9556                	add	a0,a0,s5
 3d0:	edfff0ef          	jal	2ae <memmove>
  for (uint i = 1; i < nmemb; i++) {
 3d4:	2d05                	addiw	s10,s10,1
 3d6:	f8843783          	ld	a5,-120(s0)
 3da:	05a78b63          	beq	a5,s10,430 <simplesort+0xdc>
    memmove(temp, arr + i * size, size);
 3de:	000d899b          	sext.w	s3,s11
 3e2:	01ba05bb          	addw	a1,s4,s11
 3e6:	00058d9b          	sext.w	s11,a1
 3ea:	1582                	slli	a1,a1,0x20
 3ec:	9181                	srli	a1,a1,0x20
 3ee:	8662                	mv	a2,s8
 3f0:	95d6                	add	a1,a1,s5
 3f2:	855e                	mv	a0,s7
 3f4:	ebbff0ef          	jal	2ae <memmove>
    uint j = i;
 3f8:	896a                	mv	s2,s10
 3fa:	00090b1b          	sext.w	s6,s2
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 3fe:	397d                	addiw	s2,s2,-1
 400:	02099493          	slli	s1,s3,0x20
 404:	9081                	srli	s1,s1,0x20
 406:	94d6                	add	s1,s1,s5
 408:	85de                	mv	a1,s7
 40a:	8526                	mv	a0,s1
 40c:	9c82                	jalr	s9
 40e:	faa05ae3          	blez	a0,3c2 <simplesort+0x6e>
      memmove(arr + j * size, arr + (j - 1) * size, size); // Shift element
 412:	0149853b          	addw	a0,s3,s4
 416:	1502                	slli	a0,a0,0x20
 418:	9101                	srli	a0,a0,0x20
 41a:	8662                	mv	a2,s8
 41c:	85a6                	mv	a1,s1
 41e:	9556                	add	a0,a0,s5
 420:	e8fff0ef          	jal	2ae <memmove>
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 424:	414989bb          	subw	s3,s3,s4
 428:	fc0919e3          	bnez	s2,3fa <simplesort+0xa6>
 42c:	8b4a                	mv	s6,s2
 42e:	bf51                	j	3c2 <simplesort+0x6e>
  free(temp); // Free temporary space
 430:	855e                	mv	a0,s7
 432:	4b6000ef          	jal	8e8 <free>
 436:	74a6                	ld	s1,104(sp)
 438:	7906                	ld	s2,96(sp)
 43a:	69e6                	ld	s3,88(sp)
 43c:	6a46                	ld	s4,80(sp)
 43e:	6aa6                	ld	s5,72(sp)
 440:	6b06                	ld	s6,64(sp)
 442:	7be2                	ld	s7,56(sp)
 444:	7c42                	ld	s8,48(sp)
 446:	7ca2                	ld	s9,40(sp)
 448:	7d02                	ld	s10,32(sp)
 44a:	6de2                	ld	s11,24(sp)
 44c:	b73d                	j	37a <simplesort+0x26>

000000000000044e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 44e:	4885                	li	a7,1
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <exit>:
.global exit
exit:
 li a7, SYS_exit
 456:	4889                	li	a7,2
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <wait>:
.global wait
wait:
 li a7, SYS_wait
 45e:	488d                	li	a7,3
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 466:	4891                	li	a7,4
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <read>:
.global read
read:
 li a7, SYS_read
 46e:	4895                	li	a7,5
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <write>:
.global write
write:
 li a7, SYS_write
 476:	48c1                	li	a7,16
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <close>:
.global close
close:
 li a7, SYS_close
 47e:	48d5                	li	a7,21
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <kill>:
.global kill
kill:
 li a7, SYS_kill
 486:	4899                	li	a7,6
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <exec>:
.global exec
exec:
 li a7, SYS_exec
 48e:	489d                	li	a7,7
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <open>:
.global open
open:
 li a7, SYS_open
 496:	48bd                	li	a7,15
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 49e:	48c5                	li	a7,17
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4a6:	48c9                	li	a7,18
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4ae:	48a1                	li	a7,8
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <link>:
.global link
link:
 li a7, SYS_link
 4b6:	48cd                	li	a7,19
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4be:	48d1                	li	a7,20
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4c6:	48a5                	li	a7,9
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <dup>:
.global dup
dup:
 li a7, SYS_dup
 4ce:	48a9                	li	a7,10
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4d6:	48ad                	li	a7,11
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4de:	48b1                	li	a7,12
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4e6:	48b5                	li	a7,13
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4ee:	48b9                	li	a7,14
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 4f6:	48dd                	li	a7,23
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <statistics>:
.global statistics
statistics:
 li a7, SYS_statistics
 4fe:	48e1                	li	a7,24
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <reset_stats>:
.global reset_stats
reset_stats:
 li a7, SYS_reset_stats
 506:	48e5                	li	a7,25
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <resetlockstats>:
.global resetlockstats
resetlockstats:
 li a7, SYS_resetlockstats
 50e:	48e9                	li	a7,26
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <getlockstats>:
.global getlockstats
getlockstats:
 li a7, SYS_getlockstats
 516:	48ed                	li	a7,27
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <trace>:
.global trace
trace:
 li a7, SYS_trace
 51e:	48d9                	li	a7,22
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 526:	48f1                	li	a7,28
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <ugetpid>:
.global ugetpid
ugetpid:
 li a7, SYS_ugetpid
 52e:	48f5                	li	a7,29
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 536:	48f9                	li	a7,30
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 53e:	1101                	addi	sp,sp,-32
 540:	ec06                	sd	ra,24(sp)
 542:	e822                	sd	s0,16(sp)
 544:	1000                	addi	s0,sp,32
 546:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 54a:	4605                	li	a2,1
 54c:	fef40593          	addi	a1,s0,-17
 550:	f27ff0ef          	jal	476 <write>
}
 554:	60e2                	ld	ra,24(sp)
 556:	6442                	ld	s0,16(sp)
 558:	6105                	addi	sp,sp,32
 55a:	8082                	ret

000000000000055c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 55c:	7139                	addi	sp,sp,-64
 55e:	fc06                	sd	ra,56(sp)
 560:	f822                	sd	s0,48(sp)
 562:	f426                	sd	s1,40(sp)
 564:	0080                	addi	s0,sp,64
 566:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 568:	c299                	beqz	a3,56e <printint+0x12>
 56a:	0805c963          	bltz	a1,5fc <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 56e:	2581                	sext.w	a1,a1
  neg = 0;
 570:	4881                	li	a7,0
 572:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 576:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 578:	2601                	sext.w	a2,a2
 57a:	00000517          	auipc	a0,0x0
 57e:	59e50513          	addi	a0,a0,1438 # b18 <digits>
 582:	883a                	mv	a6,a4
 584:	2705                	addiw	a4,a4,1
 586:	02c5f7bb          	remuw	a5,a1,a2
 58a:	1782                	slli	a5,a5,0x20
 58c:	9381                	srli	a5,a5,0x20
 58e:	97aa                	add	a5,a5,a0
 590:	0007c783          	lbu	a5,0(a5)
 594:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 598:	0005879b          	sext.w	a5,a1
 59c:	02c5d5bb          	divuw	a1,a1,a2
 5a0:	0685                	addi	a3,a3,1
 5a2:	fec7f0e3          	bgeu	a5,a2,582 <printint+0x26>
  if(neg)
 5a6:	00088c63          	beqz	a7,5be <printint+0x62>
    buf[i++] = '-';
 5aa:	fd070793          	addi	a5,a4,-48
 5ae:	00878733          	add	a4,a5,s0
 5b2:	02d00793          	li	a5,45
 5b6:	fef70823          	sb	a5,-16(a4)
 5ba:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5be:	02e05a63          	blez	a4,5f2 <printint+0x96>
 5c2:	f04a                	sd	s2,32(sp)
 5c4:	ec4e                	sd	s3,24(sp)
 5c6:	fc040793          	addi	a5,s0,-64
 5ca:	00e78933          	add	s2,a5,a4
 5ce:	fff78993          	addi	s3,a5,-1
 5d2:	99ba                	add	s3,s3,a4
 5d4:	377d                	addiw	a4,a4,-1
 5d6:	1702                	slli	a4,a4,0x20
 5d8:	9301                	srli	a4,a4,0x20
 5da:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5de:	fff94583          	lbu	a1,-1(s2)
 5e2:	8526                	mv	a0,s1
 5e4:	f5bff0ef          	jal	53e <putc>
  while(--i >= 0)
 5e8:	197d                	addi	s2,s2,-1
 5ea:	ff391ae3          	bne	s2,s3,5de <printint+0x82>
 5ee:	7902                	ld	s2,32(sp)
 5f0:	69e2                	ld	s3,24(sp)
}
 5f2:	70e2                	ld	ra,56(sp)
 5f4:	7442                	ld	s0,48(sp)
 5f6:	74a2                	ld	s1,40(sp)
 5f8:	6121                	addi	sp,sp,64
 5fa:	8082                	ret
    x = -xx;
 5fc:	40b005bb          	negw	a1,a1
    neg = 1;
 600:	4885                	li	a7,1
    x = -xx;
 602:	bf85                	j	572 <printint+0x16>

0000000000000604 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 604:	711d                	addi	sp,sp,-96
 606:	ec86                	sd	ra,88(sp)
 608:	e8a2                	sd	s0,80(sp)
 60a:	e0ca                	sd	s2,64(sp)
 60c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 60e:	0005c903          	lbu	s2,0(a1)
 612:	26090863          	beqz	s2,882 <vprintf+0x27e>
 616:	e4a6                	sd	s1,72(sp)
 618:	fc4e                	sd	s3,56(sp)
 61a:	f852                	sd	s4,48(sp)
 61c:	f456                	sd	s5,40(sp)
 61e:	f05a                	sd	s6,32(sp)
 620:	ec5e                	sd	s7,24(sp)
 622:	e862                	sd	s8,16(sp)
 624:	e466                	sd	s9,8(sp)
 626:	8b2a                	mv	s6,a0
 628:	8a2e                	mv	s4,a1
 62a:	8bb2                	mv	s7,a2
  state = 0;
 62c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 62e:	4481                	li	s1,0
 630:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 632:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 636:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 63a:	06c00c93          	li	s9,108
 63e:	a005                	j	65e <vprintf+0x5a>
        putc(fd, c0);
 640:	85ca                	mv	a1,s2
 642:	855a                	mv	a0,s6
 644:	efbff0ef          	jal	53e <putc>
 648:	a019                	j	64e <vprintf+0x4a>
    } else if(state == '%'){
 64a:	03598263          	beq	s3,s5,66e <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 64e:	2485                	addiw	s1,s1,1
 650:	8726                	mv	a4,s1
 652:	009a07b3          	add	a5,s4,s1
 656:	0007c903          	lbu	s2,0(a5)
 65a:	20090c63          	beqz	s2,872 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 65e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 662:	fe0994e3          	bnez	s3,64a <vprintf+0x46>
      if(c0 == '%'){
 666:	fd579de3          	bne	a5,s5,640 <vprintf+0x3c>
        state = '%';
 66a:	89be                	mv	s3,a5
 66c:	b7cd                	j	64e <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 66e:	00ea06b3          	add	a3,s4,a4
 672:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 676:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 678:	c681                	beqz	a3,680 <vprintf+0x7c>
 67a:	9752                	add	a4,a4,s4
 67c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 680:	03878f63          	beq	a5,s8,6be <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 684:	05978963          	beq	a5,s9,6d6 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 688:	07500713          	li	a4,117
 68c:	0ee78363          	beq	a5,a4,772 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 690:	07800713          	li	a4,120
 694:	12e78563          	beq	a5,a4,7be <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 698:	07000713          	li	a4,112
 69c:	14e78a63          	beq	a5,a4,7f0 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6a0:	07300713          	li	a4,115
 6a4:	18e78a63          	beq	a5,a4,838 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6a8:	02500713          	li	a4,37
 6ac:	04e79563          	bne	a5,a4,6f6 <vprintf+0xf2>
        putc(fd, '%');
 6b0:	02500593          	li	a1,37
 6b4:	855a                	mv	a0,s6
 6b6:	e89ff0ef          	jal	53e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	bf49                	j	64e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6be:	008b8913          	addi	s2,s7,8
 6c2:	4685                	li	a3,1
 6c4:	4629                	li	a2,10
 6c6:	000ba583          	lw	a1,0(s7)
 6ca:	855a                	mv	a0,s6
 6cc:	e91ff0ef          	jal	55c <printint>
 6d0:	8bca                	mv	s7,s2
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	bfad                	j	64e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6d6:	06400793          	li	a5,100
 6da:	02f68963          	beq	a3,a5,70c <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6de:	06c00793          	li	a5,108
 6e2:	04f68263          	beq	a3,a5,726 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 6e6:	07500793          	li	a5,117
 6ea:	0af68063          	beq	a3,a5,78a <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 6ee:	07800793          	li	a5,120
 6f2:	0ef68263          	beq	a3,a5,7d6 <vprintf+0x1d2>
        putc(fd, '%');
 6f6:	02500593          	li	a1,37
 6fa:	855a                	mv	a0,s6
 6fc:	e43ff0ef          	jal	53e <putc>
        putc(fd, c0);
 700:	85ca                	mv	a1,s2
 702:	855a                	mv	a0,s6
 704:	e3bff0ef          	jal	53e <putc>
      state = 0;
 708:	4981                	li	s3,0
 70a:	b791                	j	64e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 70c:	008b8913          	addi	s2,s7,8
 710:	4685                	li	a3,1
 712:	4629                	li	a2,10
 714:	000ba583          	lw	a1,0(s7)
 718:	855a                	mv	a0,s6
 71a:	e43ff0ef          	jal	55c <printint>
        i += 1;
 71e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 720:	8bca                	mv	s7,s2
      state = 0;
 722:	4981                	li	s3,0
        i += 1;
 724:	b72d                	j	64e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 726:	06400793          	li	a5,100
 72a:	02f60763          	beq	a2,a5,758 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 72e:	07500793          	li	a5,117
 732:	06f60963          	beq	a2,a5,7a4 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 736:	07800793          	li	a5,120
 73a:	faf61ee3          	bne	a2,a5,6f6 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 73e:	008b8913          	addi	s2,s7,8
 742:	4681                	li	a3,0
 744:	4641                	li	a2,16
 746:	000ba583          	lw	a1,0(s7)
 74a:	855a                	mv	a0,s6
 74c:	e11ff0ef          	jal	55c <printint>
        i += 2;
 750:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 752:	8bca                	mv	s7,s2
      state = 0;
 754:	4981                	li	s3,0
        i += 2;
 756:	bde5                	j	64e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 758:	008b8913          	addi	s2,s7,8
 75c:	4685                	li	a3,1
 75e:	4629                	li	a2,10
 760:	000ba583          	lw	a1,0(s7)
 764:	855a                	mv	a0,s6
 766:	df7ff0ef          	jal	55c <printint>
        i += 2;
 76a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 76c:	8bca                	mv	s7,s2
      state = 0;
 76e:	4981                	li	s3,0
        i += 2;
 770:	bdf9                	j	64e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 772:	008b8913          	addi	s2,s7,8
 776:	4681                	li	a3,0
 778:	4629                	li	a2,10
 77a:	000ba583          	lw	a1,0(s7)
 77e:	855a                	mv	a0,s6
 780:	dddff0ef          	jal	55c <printint>
 784:	8bca                	mv	s7,s2
      state = 0;
 786:	4981                	li	s3,0
 788:	b5d9                	j	64e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 78a:	008b8913          	addi	s2,s7,8
 78e:	4681                	li	a3,0
 790:	4629                	li	a2,10
 792:	000ba583          	lw	a1,0(s7)
 796:	855a                	mv	a0,s6
 798:	dc5ff0ef          	jal	55c <printint>
        i += 1;
 79c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 79e:	8bca                	mv	s7,s2
      state = 0;
 7a0:	4981                	li	s3,0
        i += 1;
 7a2:	b575                	j	64e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a4:	008b8913          	addi	s2,s7,8
 7a8:	4681                	li	a3,0
 7aa:	4629                	li	a2,10
 7ac:	000ba583          	lw	a1,0(s7)
 7b0:	855a                	mv	a0,s6
 7b2:	dabff0ef          	jal	55c <printint>
        i += 2;
 7b6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b8:	8bca                	mv	s7,s2
      state = 0;
 7ba:	4981                	li	s3,0
        i += 2;
 7bc:	bd49                	j	64e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7be:	008b8913          	addi	s2,s7,8
 7c2:	4681                	li	a3,0
 7c4:	4641                	li	a2,16
 7c6:	000ba583          	lw	a1,0(s7)
 7ca:	855a                	mv	a0,s6
 7cc:	d91ff0ef          	jal	55c <printint>
 7d0:	8bca                	mv	s7,s2
      state = 0;
 7d2:	4981                	li	s3,0
 7d4:	bdad                	j	64e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d6:	008b8913          	addi	s2,s7,8
 7da:	4681                	li	a3,0
 7dc:	4641                	li	a2,16
 7de:	000ba583          	lw	a1,0(s7)
 7e2:	855a                	mv	a0,s6
 7e4:	d79ff0ef          	jal	55c <printint>
        i += 1;
 7e8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ea:	8bca                	mv	s7,s2
      state = 0;
 7ec:	4981                	li	s3,0
        i += 1;
 7ee:	b585                	j	64e <vprintf+0x4a>
 7f0:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7f2:	008b8d13          	addi	s10,s7,8
 7f6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7fa:	03000593          	li	a1,48
 7fe:	855a                	mv	a0,s6
 800:	d3fff0ef          	jal	53e <putc>
  putc(fd, 'x');
 804:	07800593          	li	a1,120
 808:	855a                	mv	a0,s6
 80a:	d35ff0ef          	jal	53e <putc>
 80e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 810:	00000b97          	auipc	s7,0x0
 814:	308b8b93          	addi	s7,s7,776 # b18 <digits>
 818:	03c9d793          	srli	a5,s3,0x3c
 81c:	97de                	add	a5,a5,s7
 81e:	0007c583          	lbu	a1,0(a5)
 822:	855a                	mv	a0,s6
 824:	d1bff0ef          	jal	53e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 828:	0992                	slli	s3,s3,0x4
 82a:	397d                	addiw	s2,s2,-1
 82c:	fe0916e3          	bnez	s2,818 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 830:	8bea                	mv	s7,s10
      state = 0;
 832:	4981                	li	s3,0
 834:	6d02                	ld	s10,0(sp)
 836:	bd21                	j	64e <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 838:	008b8993          	addi	s3,s7,8
 83c:	000bb903          	ld	s2,0(s7)
 840:	00090f63          	beqz	s2,85e <vprintf+0x25a>
        for(; *s; s++)
 844:	00094583          	lbu	a1,0(s2)
 848:	c195                	beqz	a1,86c <vprintf+0x268>
          putc(fd, *s);
 84a:	855a                	mv	a0,s6
 84c:	cf3ff0ef          	jal	53e <putc>
        for(; *s; s++)
 850:	0905                	addi	s2,s2,1
 852:	00094583          	lbu	a1,0(s2)
 856:	f9f5                	bnez	a1,84a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 858:	8bce                	mv	s7,s3
      state = 0;
 85a:	4981                	li	s3,0
 85c:	bbcd                	j	64e <vprintf+0x4a>
          s = "(null)";
 85e:	00000917          	auipc	s2,0x0
 862:	2b290913          	addi	s2,s2,690 # b10 <malloc+0x1a6>
        for(; *s; s++)
 866:	02800593          	li	a1,40
 86a:	b7c5                	j	84a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 86c:	8bce                	mv	s7,s3
      state = 0;
 86e:	4981                	li	s3,0
 870:	bbf9                	j	64e <vprintf+0x4a>
 872:	64a6                	ld	s1,72(sp)
 874:	79e2                	ld	s3,56(sp)
 876:	7a42                	ld	s4,48(sp)
 878:	7aa2                	ld	s5,40(sp)
 87a:	7b02                	ld	s6,32(sp)
 87c:	6be2                	ld	s7,24(sp)
 87e:	6c42                	ld	s8,16(sp)
 880:	6ca2                	ld	s9,8(sp)
    }
  }
}
 882:	60e6                	ld	ra,88(sp)
 884:	6446                	ld	s0,80(sp)
 886:	6906                	ld	s2,64(sp)
 888:	6125                	addi	sp,sp,96
 88a:	8082                	ret

000000000000088c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 88c:	715d                	addi	sp,sp,-80
 88e:	ec06                	sd	ra,24(sp)
 890:	e822                	sd	s0,16(sp)
 892:	1000                	addi	s0,sp,32
 894:	e010                	sd	a2,0(s0)
 896:	e414                	sd	a3,8(s0)
 898:	e818                	sd	a4,16(s0)
 89a:	ec1c                	sd	a5,24(s0)
 89c:	03043023          	sd	a6,32(s0)
 8a0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8a4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8a8:	8622                	mv	a2,s0
 8aa:	d5bff0ef          	jal	604 <vprintf>
}
 8ae:	60e2                	ld	ra,24(sp)
 8b0:	6442                	ld	s0,16(sp)
 8b2:	6161                	addi	sp,sp,80
 8b4:	8082                	ret

00000000000008b6 <printf>:

void
printf(const char *fmt, ...)
{
 8b6:	711d                	addi	sp,sp,-96
 8b8:	ec06                	sd	ra,24(sp)
 8ba:	e822                	sd	s0,16(sp)
 8bc:	1000                	addi	s0,sp,32
 8be:	e40c                	sd	a1,8(s0)
 8c0:	e810                	sd	a2,16(s0)
 8c2:	ec14                	sd	a3,24(s0)
 8c4:	f018                	sd	a4,32(s0)
 8c6:	f41c                	sd	a5,40(s0)
 8c8:	03043823          	sd	a6,48(s0)
 8cc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8d0:	00840613          	addi	a2,s0,8
 8d4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8d8:	85aa                	mv	a1,a0
 8da:	4505                	li	a0,1
 8dc:	d29ff0ef          	jal	604 <vprintf>
}
 8e0:	60e2                	ld	ra,24(sp)
 8e2:	6442                	ld	s0,16(sp)
 8e4:	6125                	addi	sp,sp,96
 8e6:	8082                	ret

00000000000008e8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8e8:	1141                	addi	sp,sp,-16
 8ea:	e422                	sd	s0,8(sp)
 8ec:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ee:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f2:	00000797          	auipc	a5,0x0
 8f6:	71e7b783          	ld	a5,1822(a5) # 1010 <freep>
 8fa:	a02d                	j	924 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8fc:	4618                	lw	a4,8(a2)
 8fe:	9f2d                	addw	a4,a4,a1
 900:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 904:	6398                	ld	a4,0(a5)
 906:	6310                	ld	a2,0(a4)
 908:	a83d                	j	946 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 90a:	ff852703          	lw	a4,-8(a0)
 90e:	9f31                	addw	a4,a4,a2
 910:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 912:	ff053683          	ld	a3,-16(a0)
 916:	a091                	j	95a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 918:	6398                	ld	a4,0(a5)
 91a:	00e7e463          	bltu	a5,a4,922 <free+0x3a>
 91e:	00e6ea63          	bltu	a3,a4,932 <free+0x4a>
{
 922:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 924:	fed7fae3          	bgeu	a5,a3,918 <free+0x30>
 928:	6398                	ld	a4,0(a5)
 92a:	00e6e463          	bltu	a3,a4,932 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 92e:	fee7eae3          	bltu	a5,a4,922 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 932:	ff852583          	lw	a1,-8(a0)
 936:	6390                	ld	a2,0(a5)
 938:	02059813          	slli	a6,a1,0x20
 93c:	01c85713          	srli	a4,a6,0x1c
 940:	9736                	add	a4,a4,a3
 942:	fae60de3          	beq	a2,a4,8fc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 946:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 94a:	4790                	lw	a2,8(a5)
 94c:	02061593          	slli	a1,a2,0x20
 950:	01c5d713          	srli	a4,a1,0x1c
 954:	973e                	add	a4,a4,a5
 956:	fae68ae3          	beq	a3,a4,90a <free+0x22>
    p->s.ptr = bp->s.ptr;
 95a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 95c:	00000717          	auipc	a4,0x0
 960:	6af73a23          	sd	a5,1716(a4) # 1010 <freep>
}
 964:	6422                	ld	s0,8(sp)
 966:	0141                	addi	sp,sp,16
 968:	8082                	ret

000000000000096a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 96a:	7139                	addi	sp,sp,-64
 96c:	fc06                	sd	ra,56(sp)
 96e:	f822                	sd	s0,48(sp)
 970:	f426                	sd	s1,40(sp)
 972:	ec4e                	sd	s3,24(sp)
 974:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 976:	02051493          	slli	s1,a0,0x20
 97a:	9081                	srli	s1,s1,0x20
 97c:	04bd                	addi	s1,s1,15
 97e:	8091                	srli	s1,s1,0x4
 980:	0014899b          	addiw	s3,s1,1
 984:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 986:	00000517          	auipc	a0,0x0
 98a:	68a53503          	ld	a0,1674(a0) # 1010 <freep>
 98e:	c915                	beqz	a0,9c2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 990:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 992:	4798                	lw	a4,8(a5)
 994:	08977a63          	bgeu	a4,s1,a28 <malloc+0xbe>
 998:	f04a                	sd	s2,32(sp)
 99a:	e852                	sd	s4,16(sp)
 99c:	e456                	sd	s5,8(sp)
 99e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9a0:	8a4e                	mv	s4,s3
 9a2:	0009871b          	sext.w	a4,s3
 9a6:	6685                	lui	a3,0x1
 9a8:	00d77363          	bgeu	a4,a3,9ae <malloc+0x44>
 9ac:	6a05                	lui	s4,0x1
 9ae:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9b2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9b6:	00000917          	auipc	s2,0x0
 9ba:	65a90913          	addi	s2,s2,1626 # 1010 <freep>
  if(p == (char*)-1)
 9be:	5afd                	li	s5,-1
 9c0:	a081                	j	a00 <malloc+0x96>
 9c2:	f04a                	sd	s2,32(sp)
 9c4:	e852                	sd	s4,16(sp)
 9c6:	e456                	sd	s5,8(sp)
 9c8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9ca:	00000797          	auipc	a5,0x0
 9ce:	65678793          	addi	a5,a5,1622 # 1020 <base>
 9d2:	00000717          	auipc	a4,0x0
 9d6:	62f73f23          	sd	a5,1598(a4) # 1010 <freep>
 9da:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9dc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9e0:	b7c1                	j	9a0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9e2:	6398                	ld	a4,0(a5)
 9e4:	e118                	sd	a4,0(a0)
 9e6:	a8a9                	j	a40 <malloc+0xd6>
  hp->s.size = nu;
 9e8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9ec:	0541                	addi	a0,a0,16
 9ee:	efbff0ef          	jal	8e8 <free>
  return freep;
 9f2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9f6:	c12d                	beqz	a0,a58 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9fa:	4798                	lw	a4,8(a5)
 9fc:	02977263          	bgeu	a4,s1,a20 <malloc+0xb6>
    if(p == freep)
 a00:	00093703          	ld	a4,0(s2)
 a04:	853e                	mv	a0,a5
 a06:	fef719e3          	bne	a4,a5,9f8 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a0a:	8552                	mv	a0,s4
 a0c:	ad3ff0ef          	jal	4de <sbrk>
  if(p == (char*)-1)
 a10:	fd551ce3          	bne	a0,s5,9e8 <malloc+0x7e>
        return 0;
 a14:	4501                	li	a0,0
 a16:	7902                	ld	s2,32(sp)
 a18:	6a42                	ld	s4,16(sp)
 a1a:	6aa2                	ld	s5,8(sp)
 a1c:	6b02                	ld	s6,0(sp)
 a1e:	a03d                	j	a4c <malloc+0xe2>
 a20:	7902                	ld	s2,32(sp)
 a22:	6a42                	ld	s4,16(sp)
 a24:	6aa2                	ld	s5,8(sp)
 a26:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a28:	fae48de3          	beq	s1,a4,9e2 <malloc+0x78>
        p->s.size -= nunits;
 a2c:	4137073b          	subw	a4,a4,s3
 a30:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a32:	02071693          	slli	a3,a4,0x20
 a36:	01c6d713          	srli	a4,a3,0x1c
 a3a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a3c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a40:	00000717          	auipc	a4,0x0
 a44:	5ca73823          	sd	a0,1488(a4) # 1010 <freep>
      return (void*)(p + 1);
 a48:	01078513          	addi	a0,a5,16
  }
}
 a4c:	70e2                	ld	ra,56(sp)
 a4e:	7442                	ld	s0,48(sp)
 a50:	74a2                	ld	s1,40(sp)
 a52:	69e2                	ld	s3,24(sp)
 a54:	6121                	addi	sp,sp,64
 a56:	8082                	ret
 a58:	7902                	ld	s2,32(sp)
 a5a:	6a42                	ld	s4,16(sp)
 a5c:	6aa2                	ld	s5,8(sp)
 a5e:	6b02                	ld	s6,0(sp)
 a60:	b7f5                	j	a4c <malloc+0xe2>
