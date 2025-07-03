
user/_forktest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:

#define N  1000

void
print(const char *s)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  write(1, s, strlen(s));
   c:	15a000ef          	jal	166 <strlen>
  10:	0005061b          	sext.w	a2,a0
  14:	85a6                	mv	a1,s1
  16:	4505                	li	a0,1
  18:	478000ef          	jal	490 <write>
}
  1c:	60e2                	ld	ra,24(sp)
  1e:	6442                	ld	s0,16(sp)
  20:	64a2                	ld	s1,8(sp)
  22:	6105                	addi	sp,sp,32
  24:	8082                	ret

0000000000000026 <forktest>:

void
forktest(void)
{
  26:	1101                	addi	sp,sp,-32
  28:	ec06                	sd	ra,24(sp)
  2a:	e822                	sd	s0,16(sp)
  2c:	e426                	sd	s1,8(sp)
  2e:	e04a                	sd	s2,0(sp)
  30:	1000                	addi	s0,sp,32
  int n, pid;

  print("fork test\n");
  32:	00001517          	auipc	a0,0x1
  36:	a4650513          	addi	a0,a0,-1466 # a78 <malloc+0xf4>
  3a:	fc7ff0ef          	jal	0 <print>

  for(n=0; n<N; n++){
  3e:	4481                	li	s1,0
  40:	3e800913          	li	s2,1000
    pid = fork();
  44:	424000ef          	jal	468 <fork>
    if(pid < 0)
  48:	04054363          	bltz	a0,8e <forktest+0x68>
      break;
    if(pid == 0)
  4c:	cd09                	beqz	a0,66 <forktest+0x40>
  for(n=0; n<N; n++){
  4e:	2485                	addiw	s1,s1,1
  50:	ff249ae3          	bne	s1,s2,44 <forktest+0x1e>
      exit(0);
  }

  if(n == N){
    print("fork claimed to work N times!\n");
  54:	00001517          	auipc	a0,0x1
  58:	a7450513          	addi	a0,a0,-1420 # ac8 <malloc+0x144>
  5c:	fa5ff0ef          	jal	0 <print>
    exit(1);
  60:	4505                	li	a0,1
  62:	40e000ef          	jal	470 <exit>
      exit(0);
  66:	40a000ef          	jal	470 <exit>
  }

  for(; n > 0; n--){
    if(wait(0) < 0){
      print("wait stopped early\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	a1e50513          	addi	a0,a0,-1506 # a88 <malloc+0x104>
  72:	f8fff0ef          	jal	0 <print>
      exit(1);
  76:	4505                	li	a0,1
  78:	3f8000ef          	jal	470 <exit>
    }
  }

  if(wait(0) != -1){
    print("wait got too many\n");
  7c:	00001517          	auipc	a0,0x1
  80:	a2450513          	addi	a0,a0,-1500 # aa0 <malloc+0x11c>
  84:	f7dff0ef          	jal	0 <print>
    exit(1);
  88:	4505                	li	a0,1
  8a:	3e6000ef          	jal	470 <exit>
  for(; n > 0; n--){
  8e:	00905963          	blez	s1,a0 <forktest+0x7a>
    if(wait(0) < 0){
  92:	4501                	li	a0,0
  94:	3e4000ef          	jal	478 <wait>
  98:	fc0549e3          	bltz	a0,6a <forktest+0x44>
  for(; n > 0; n--){
  9c:	34fd                	addiw	s1,s1,-1
  9e:	f8f5                	bnez	s1,92 <forktest+0x6c>
  if(wait(0) != -1){
  a0:	4501                	li	a0,0
  a2:	3d6000ef          	jal	478 <wait>
  a6:	57fd                	li	a5,-1
  a8:	fcf51ae3          	bne	a0,a5,7c <forktest+0x56>
  }

  print("fork test OK\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	a0c50513          	addi	a0,a0,-1524 # ab8 <malloc+0x134>
  b4:	f4dff0ef          	jal	0 <print>
}
  b8:	60e2                	ld	ra,24(sp)
  ba:	6442                	ld	s0,16(sp)
  bc:	64a2                	ld	s1,8(sp)
  be:	6902                	ld	s2,0(sp)
  c0:	6105                	addi	sp,sp,32
  c2:	8082                	ret

00000000000000c4 <main>:

int
main(void)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e406                	sd	ra,8(sp)
  c8:	e022                	sd	s0,0(sp)
  ca:	0800                	addi	s0,sp,16
  forktest();
  cc:	f5bff0ef          	jal	26 <forktest>
  exit(0);
  d0:	4501                	li	a0,0
  d2:	39e000ef          	jal	470 <exit>

00000000000000d6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e406                	sd	ra,8(sp)
  da:	e022                	sd	s0,0(sp)
  dc:	0800                	addi	s0,sp,16
  extern int main();
  main();
  de:	fe7ff0ef          	jal	c4 <main>
  exit(0);
  e2:	4501                	li	a0,0
  e4:	38c000ef          	jal	470 <exit>

00000000000000e8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e422                	sd	s0,8(sp)
  ec:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ee:	87aa                	mv	a5,a0
  f0:	0585                	addi	a1,a1,1
  f2:	0785                	addi	a5,a5,1
  f4:	fff5c703          	lbu	a4,-1(a1)
  f8:	fee78fa3          	sb	a4,-1(a5)
  fc:	fb75                	bnez	a4,f0 <strcpy+0x8>
    ;
  return os;
}
  fe:	6422                	ld	s0,8(sp)
 100:	0141                	addi	sp,sp,16
 102:	8082                	ret

0000000000000104 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 104:	1141                	addi	sp,sp,-16
 106:	e422                	sd	s0,8(sp)
 108:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 10a:	00054783          	lbu	a5,0(a0)
 10e:	cb91                	beqz	a5,122 <strcmp+0x1e>
 110:	0005c703          	lbu	a4,0(a1)
 114:	00f71763          	bne	a4,a5,122 <strcmp+0x1e>
    p++, q++;
 118:	0505                	addi	a0,a0,1
 11a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 11c:	00054783          	lbu	a5,0(a0)
 120:	fbe5                	bnez	a5,110 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 122:	0005c503          	lbu	a0,0(a1)
}
 126:	40a7853b          	subw	a0,a5,a0
 12a:	6422                	ld	s0,8(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret

0000000000000130 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 130:	1141                	addi	sp,sp,-16
 132:	e422                	sd	s0,8(sp)
 134:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q) {
 136:	ce11                	beqz	a2,152 <strncmp+0x22>
 138:	00054783          	lbu	a5,0(a0)
 13c:	cf89                	beqz	a5,156 <strncmp+0x26>
 13e:	0005c703          	lbu	a4,0(a1)
 142:	00f71a63          	bne	a4,a5,156 <strncmp+0x26>
    n--;
 146:	367d                	addiw	a2,a2,-1
    p++;
 148:	0505                	addi	a0,a0,1
    q++;
 14a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q) {
 14c:	f675                	bnez	a2,138 <strncmp+0x8>
  }
  if(n == 0)
    return 0;
 14e:	4501                	li	a0,0
 150:	a801                	j	160 <strncmp+0x30>
 152:	4501                	li	a0,0
 154:	a031                	j	160 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
 156:	00054503          	lbu	a0,0(a0)
 15a:	0005c783          	lbu	a5,0(a1)
 15e:	9d1d                	subw	a0,a0,a5
}
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret

0000000000000166 <strlen>:

uint
strlen(const char *s)
{
 166:	1141                	addi	sp,sp,-16
 168:	e422                	sd	s0,8(sp)
 16a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 16c:	00054783          	lbu	a5,0(a0)
 170:	cf91                	beqz	a5,18c <strlen+0x26>
 172:	0505                	addi	a0,a0,1
 174:	87aa                	mv	a5,a0
 176:	86be                	mv	a3,a5
 178:	0785                	addi	a5,a5,1
 17a:	fff7c703          	lbu	a4,-1(a5)
 17e:	ff65                	bnez	a4,176 <strlen+0x10>
 180:	40a6853b          	subw	a0,a3,a0
 184:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret
  for(n = 0; s[n]; n++)
 18c:	4501                	li	a0,0
 18e:	bfe5                	j	186 <strlen+0x20>

0000000000000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 196:	ca19                	beqz	a2,1ac <memset+0x1c>
 198:	87aa                	mv	a5,a0
 19a:	1602                	slli	a2,a2,0x20
 19c:	9201                	srli	a2,a2,0x20
 19e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a6:	0785                	addi	a5,a5,1
 1a8:	fee79de3          	bne	a5,a4,1a2 <memset+0x12>
  }
  return dst;
}
 1ac:	6422                	ld	s0,8(sp)
 1ae:	0141                	addi	sp,sp,16
 1b0:	8082                	ret

00000000000001b2 <strchr>:

char*
strchr(const char *s, char c)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	cb99                	beqz	a5,1d2 <strchr+0x20>
    if(*s == c)
 1be:	00f58763          	beq	a1,a5,1cc <strchr+0x1a>
  for(; *s; s++)
 1c2:	0505                	addi	a0,a0,1
 1c4:	00054783          	lbu	a5,0(a0)
 1c8:	fbfd                	bnez	a5,1be <strchr+0xc>
      return (char*)s;
  return 0;
 1ca:	4501                	li	a0,0
}
 1cc:	6422                	ld	s0,8(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret
  return 0;
 1d2:	4501                	li	a0,0
 1d4:	bfe5                	j	1cc <strchr+0x1a>

00000000000001d6 <gets>:

char*
gets(char *buf, int max)
{
 1d6:	711d                	addi	sp,sp,-96
 1d8:	ec86                	sd	ra,88(sp)
 1da:	e8a2                	sd	s0,80(sp)
 1dc:	e4a6                	sd	s1,72(sp)
 1de:	e0ca                	sd	s2,64(sp)
 1e0:	fc4e                	sd	s3,56(sp)
 1e2:	f852                	sd	s4,48(sp)
 1e4:	f456                	sd	s5,40(sp)
 1e6:	f05a                	sd	s6,32(sp)
 1e8:	ec5e                	sd	s7,24(sp)
 1ea:	1080                	addi	s0,sp,96
 1ec:	8baa                	mv	s7,a0
 1ee:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f0:	892a                	mv	s2,a0
 1f2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f4:	4aa9                	li	s5,10
 1f6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1f8:	89a6                	mv	s3,s1
 1fa:	2485                	addiw	s1,s1,1
 1fc:	0344d663          	bge	s1,s4,228 <gets+0x52>
    cc = read(0, &c, 1);
 200:	4605                	li	a2,1
 202:	faf40593          	addi	a1,s0,-81
 206:	4501                	li	a0,0
 208:	280000ef          	jal	488 <read>
    if(cc < 1)
 20c:	00a05e63          	blez	a0,228 <gets+0x52>
    buf[i++] = c;
 210:	faf44783          	lbu	a5,-81(s0)
 214:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 218:	01578763          	beq	a5,s5,226 <gets+0x50>
 21c:	0905                	addi	s2,s2,1
 21e:	fd679de3          	bne	a5,s6,1f8 <gets+0x22>
    buf[i++] = c;
 222:	89a6                	mv	s3,s1
 224:	a011                	j	228 <gets+0x52>
 226:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 228:	99de                	add	s3,s3,s7
 22a:	00098023          	sb	zero,0(s3)
  return buf;
}
 22e:	855e                	mv	a0,s7
 230:	60e6                	ld	ra,88(sp)
 232:	6446                	ld	s0,80(sp)
 234:	64a6                	ld	s1,72(sp)
 236:	6906                	ld	s2,64(sp)
 238:	79e2                	ld	s3,56(sp)
 23a:	7a42                	ld	s4,48(sp)
 23c:	7aa2                	ld	s5,40(sp)
 23e:	7b02                	ld	s6,32(sp)
 240:	6be2                	ld	s7,24(sp)
 242:	6125                	addi	sp,sp,96
 244:	8082                	ret

0000000000000246 <stat>:

int
stat(const char *n, struct stat *st)
{
 246:	1101                	addi	sp,sp,-32
 248:	ec06                	sd	ra,24(sp)
 24a:	e822                	sd	s0,16(sp)
 24c:	e04a                	sd	s2,0(sp)
 24e:	1000                	addi	s0,sp,32
 250:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 252:	4581                	li	a1,0
 254:	25c000ef          	jal	4b0 <open>
  if(fd < 0)
 258:	02054263          	bltz	a0,27c <stat+0x36>
 25c:	e426                	sd	s1,8(sp)
 25e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 260:	85ca                	mv	a1,s2
 262:	266000ef          	jal	4c8 <fstat>
 266:	892a                	mv	s2,a0
  close(fd);
 268:	8526                	mv	a0,s1
 26a:	22e000ef          	jal	498 <close>
  return r;
 26e:	64a2                	ld	s1,8(sp)
}
 270:	854a                	mv	a0,s2
 272:	60e2                	ld	ra,24(sp)
 274:	6442                	ld	s0,16(sp)
 276:	6902                	ld	s2,0(sp)
 278:	6105                	addi	sp,sp,32
 27a:	8082                	ret
    return -1;
 27c:	597d                	li	s2,-1
 27e:	bfcd                	j	270 <stat+0x2a>

0000000000000280 <atoi>:

int
atoi(const char *s)
{
 280:	1141                	addi	sp,sp,-16
 282:	e422                	sd	s0,8(sp)
 284:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 286:	00054683          	lbu	a3,0(a0)
 28a:	fd06879b          	addiw	a5,a3,-48
 28e:	0ff7f793          	zext.b	a5,a5
 292:	4625                	li	a2,9
 294:	02f66863          	bltu	a2,a5,2c4 <atoi+0x44>
 298:	872a                	mv	a4,a0
  n = 0;
 29a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 29c:	0705                	addi	a4,a4,1
 29e:	0025179b          	slliw	a5,a0,0x2
 2a2:	9fa9                	addw	a5,a5,a0
 2a4:	0017979b          	slliw	a5,a5,0x1
 2a8:	9fb5                	addw	a5,a5,a3
 2aa:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2ae:	00074683          	lbu	a3,0(a4)
 2b2:	fd06879b          	addiw	a5,a3,-48
 2b6:	0ff7f793          	zext.b	a5,a5
 2ba:	fef671e3          	bgeu	a2,a5,29c <atoi+0x1c>
  return n;
}
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret
  n = 0;
 2c4:	4501                	li	a0,0
 2c6:	bfe5                	j	2be <atoi+0x3e>

00000000000002c8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e422                	sd	s0,8(sp)
 2cc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ce:	02b57463          	bgeu	a0,a1,2f6 <memmove+0x2e>
    while(n-- > 0)
 2d2:	00c05f63          	blez	a2,2f0 <memmove+0x28>
 2d6:	1602                	slli	a2,a2,0x20
 2d8:	9201                	srli	a2,a2,0x20
 2da:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2de:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e0:	0585                	addi	a1,a1,1
 2e2:	0705                	addi	a4,a4,1
 2e4:	fff5c683          	lbu	a3,-1(a1)
 2e8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ec:	fef71ae3          	bne	a4,a5,2e0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f0:	6422                	ld	s0,8(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
    dst += n;
 2f6:	00c50733          	add	a4,a0,a2
    src += n;
 2fa:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2fc:	fec05ae3          	blez	a2,2f0 <memmove+0x28>
 300:	fff6079b          	addiw	a5,a2,-1
 304:	1782                	slli	a5,a5,0x20
 306:	9381                	srli	a5,a5,0x20
 308:	fff7c793          	not	a5,a5
 30c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 30e:	15fd                	addi	a1,a1,-1
 310:	177d                	addi	a4,a4,-1
 312:	0005c683          	lbu	a3,0(a1)
 316:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 31a:	fee79ae3          	bne	a5,a4,30e <memmove+0x46>
 31e:	bfc9                	j	2f0 <memmove+0x28>

0000000000000320 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 320:	1141                	addi	sp,sp,-16
 322:	e422                	sd	s0,8(sp)
 324:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 326:	ca05                	beqz	a2,356 <memcmp+0x36>
 328:	fff6069b          	addiw	a3,a2,-1
 32c:	1682                	slli	a3,a3,0x20
 32e:	9281                	srli	a3,a3,0x20
 330:	0685                	addi	a3,a3,1
 332:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 334:	00054783          	lbu	a5,0(a0)
 338:	0005c703          	lbu	a4,0(a1)
 33c:	00e79863          	bne	a5,a4,34c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 340:	0505                	addi	a0,a0,1
    p2++;
 342:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 344:	fed518e3          	bne	a0,a3,334 <memcmp+0x14>
  }
  return 0;
 348:	4501                	li	a0,0
 34a:	a019                	j	350 <memcmp+0x30>
      return *p1 - *p2;
 34c:	40e7853b          	subw	a0,a5,a4
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret
  return 0;
 356:	4501                	li	a0,0
 358:	bfe5                	j	350 <memcmp+0x30>

000000000000035a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 35a:	1141                	addi	sp,sp,-16
 35c:	e406                	sd	ra,8(sp)
 35e:	e022                	sd	s0,0(sp)
 360:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 362:	f67ff0ef          	jal	2c8 <memmove>
}
 366:	60a2                	ld	ra,8(sp)
 368:	6402                	ld	s0,0(sp)
 36a:	0141                	addi	sp,sp,16
 36c:	8082                	ret

000000000000036e <simplesort>:

void
simplesort(void *base, uint nmemb, uint size, int (*compar)(const void *, const void *))
{
 36e:	7119                	addi	sp,sp,-128
 370:	fc86                	sd	ra,120(sp)
 372:	f8a2                	sd	s0,112(sp)
 374:	0100                	addi	s0,sp,128
 376:	f8b43423          	sd	a1,-120(s0)
  char *arr = (char *)base; // Treat array as char array for byte-level manipulation
  char *temp;               // Temporary storage for an element

  if (nmemb <= 1 || size == 0) {
 37a:	4785                	li	a5,1
 37c:	00b7fc63          	bgeu	a5,a1,394 <simplesort+0x26>
 380:	e8d2                	sd	s4,80(sp)
 382:	e4d6                	sd	s5,72(sp)
 384:	f466                	sd	s9,40(sp)
 386:	8aaa                	mv	s5,a0
 388:	8a32                	mv	s4,a2
 38a:	8cb6                	mv	s9,a3
 38c:	ea01                	bnez	a2,39c <simplesort+0x2e>
 38e:	6a46                	ld	s4,80(sp)
 390:	6aa6                	ld	s5,72(sp)
 392:	7ca2                	ld	s9,40(sp)
    // Place temp at its correct position
    memmove(arr + j * size, temp, size);
  }

  free(temp); // Free temporary space
 394:	70e6                	ld	ra,120(sp)
 396:	7446                	ld	s0,112(sp)
 398:	6109                	addi	sp,sp,128
 39a:	8082                	ret
 39c:	fc5e                	sd	s7,56(sp)
 39e:	f862                	sd	s8,48(sp)
 3a0:	f06a                	sd	s10,32(sp)
 3a2:	ec6e                	sd	s11,24(sp)
  temp = malloc(size); // Allocate temporary space for one element
 3a4:	8532                	mv	a0,a2
 3a6:	5de000ef          	jal	984 <malloc>
 3aa:	8baa                	mv	s7,a0
  if (temp == 0) {
 3ac:	4d81                	li	s11,0
  for (uint i = 1; i < nmemb; i++) {
 3ae:	4d05                	li	s10,1
    memmove(temp, arr + i * size, size);
 3b0:	000a0c1b          	sext.w	s8,s4
  if (temp == 0) {
 3b4:	c511                	beqz	a0,3c0 <simplesort+0x52>
 3b6:	f4a6                	sd	s1,104(sp)
 3b8:	f0ca                	sd	s2,96(sp)
 3ba:	ecce                	sd	s3,88(sp)
 3bc:	e0da                	sd	s6,64(sp)
 3be:	a82d                	j	3f8 <simplesort+0x8a>
    printf("simplesort: malloc failed, cannot sort\n");
 3c0:	00000517          	auipc	a0,0x0
 3c4:	72850513          	addi	a0,a0,1832 # ae8 <malloc+0x164>
 3c8:	508000ef          	jal	8d0 <printf>
    return;
 3cc:	6a46                	ld	s4,80(sp)
 3ce:	6aa6                	ld	s5,72(sp)
 3d0:	7be2                	ld	s7,56(sp)
 3d2:	7c42                	ld	s8,48(sp)
 3d4:	7ca2                	ld	s9,40(sp)
 3d6:	7d02                	ld	s10,32(sp)
 3d8:	6de2                	ld	s11,24(sp)
 3da:	bf6d                	j	394 <simplesort+0x26>
    memmove(arr + j * size, temp, size);
 3dc:	036a053b          	mulw	a0,s4,s6
 3e0:	1502                	slli	a0,a0,0x20
 3e2:	9101                	srli	a0,a0,0x20
 3e4:	8662                	mv	a2,s8
 3e6:	85de                	mv	a1,s7
 3e8:	9556                	add	a0,a0,s5
 3ea:	edfff0ef          	jal	2c8 <memmove>
  for (uint i = 1; i < nmemb; i++) {
 3ee:	2d05                	addiw	s10,s10,1
 3f0:	f8843783          	ld	a5,-120(s0)
 3f4:	05a78b63          	beq	a5,s10,44a <simplesort+0xdc>
    memmove(temp, arr + i * size, size);
 3f8:	000d899b          	sext.w	s3,s11
 3fc:	01ba05bb          	addw	a1,s4,s11
 400:	00058d9b          	sext.w	s11,a1
 404:	1582                	slli	a1,a1,0x20
 406:	9181                	srli	a1,a1,0x20
 408:	8662                	mv	a2,s8
 40a:	95d6                	add	a1,a1,s5
 40c:	855e                	mv	a0,s7
 40e:	ebbff0ef          	jal	2c8 <memmove>
    uint j = i;
 412:	896a                	mv	s2,s10
 414:	00090b1b          	sext.w	s6,s2
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 418:	397d                	addiw	s2,s2,-1
 41a:	02099493          	slli	s1,s3,0x20
 41e:	9081                	srli	s1,s1,0x20
 420:	94d6                	add	s1,s1,s5
 422:	85de                	mv	a1,s7
 424:	8526                	mv	a0,s1
 426:	9c82                	jalr	s9
 428:	faa05ae3          	blez	a0,3dc <simplesort+0x6e>
      memmove(arr + j * size, arr + (j - 1) * size, size); // Shift element
 42c:	0149853b          	addw	a0,s3,s4
 430:	1502                	slli	a0,a0,0x20
 432:	9101                	srli	a0,a0,0x20
 434:	8662                	mv	a2,s8
 436:	85a6                	mv	a1,s1
 438:	9556                	add	a0,a0,s5
 43a:	e8fff0ef          	jal	2c8 <memmove>
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 43e:	414989bb          	subw	s3,s3,s4
 442:	fc0919e3          	bnez	s2,414 <simplesort+0xa6>
 446:	8b4a                	mv	s6,s2
 448:	bf51                	j	3dc <simplesort+0x6e>
  free(temp); // Free temporary space
 44a:	855e                	mv	a0,s7
 44c:	4b6000ef          	jal	902 <free>
 450:	74a6                	ld	s1,104(sp)
 452:	7906                	ld	s2,96(sp)
 454:	69e6                	ld	s3,88(sp)
 456:	6a46                	ld	s4,80(sp)
 458:	6aa6                	ld	s5,72(sp)
 45a:	6b06                	ld	s6,64(sp)
 45c:	7be2                	ld	s7,56(sp)
 45e:	7c42                	ld	s8,48(sp)
 460:	7ca2                	ld	s9,40(sp)
 462:	7d02                	ld	s10,32(sp)
 464:	6de2                	ld	s11,24(sp)
 466:	b73d                	j	394 <simplesort+0x26>

0000000000000468 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 468:	4885                	li	a7,1
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <exit>:
.global exit
exit:
 li a7, SYS_exit
 470:	4889                	li	a7,2
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <wait>:
.global wait
wait:
 li a7, SYS_wait
 478:	488d                	li	a7,3
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 480:	4891                	li	a7,4
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <read>:
.global read
read:
 li a7, SYS_read
 488:	4895                	li	a7,5
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <write>:
.global write
write:
 li a7, SYS_write
 490:	48c1                	li	a7,16
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <close>:
.global close
close:
 li a7, SYS_close
 498:	48d5                	li	a7,21
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4a0:	4899                	li	a7,6
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4a8:	489d                	li	a7,7
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <open>:
.global open
open:
 li a7, SYS_open
 4b0:	48bd                	li	a7,15
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4b8:	48c5                	li	a7,17
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4c0:	48c9                	li	a7,18
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4c8:	48a1                	li	a7,8
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <link>:
.global link
link:
 li a7, SYS_link
 4d0:	48cd                	li	a7,19
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4d8:	48d1                	li	a7,20
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4e0:	48a5                	li	a7,9
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4e8:	48a9                	li	a7,10
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4f0:	48ad                	li	a7,11
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4f8:	48b1                	li	a7,12
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 500:	48b5                	li	a7,13
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 508:	48b9                	li	a7,14
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 510:	48dd                	li	a7,23
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <statistics>:
.global statistics
statistics:
 li a7, SYS_statistics
 518:	48e1                	li	a7,24
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <reset_stats>:
.global reset_stats
reset_stats:
 li a7, SYS_reset_stats
 520:	48e5                	li	a7,25
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <resetlockstats>:
.global resetlockstats
resetlockstats:
 li a7, SYS_resetlockstats
 528:	48e9                	li	a7,26
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <getlockstats>:
.global getlockstats
getlockstats:
 li a7, SYS_getlockstats
 530:	48ed                	li	a7,27
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <trace>:
.global trace
trace:
 li a7, SYS_trace
 538:	48d9                	li	a7,22
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 540:	48f1                	li	a7,28
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <ugetpid>:
.global ugetpid
ugetpid:
 li a7, SYS_ugetpid
 548:	48f5                	li	a7,29
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 550:	48f9                	li	a7,30
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 558:	1101                	addi	sp,sp,-32
 55a:	ec06                	sd	ra,24(sp)
 55c:	e822                	sd	s0,16(sp)
 55e:	1000                	addi	s0,sp,32
 560:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 564:	4605                	li	a2,1
 566:	fef40593          	addi	a1,s0,-17
 56a:	f27ff0ef          	jal	490 <write>
}
 56e:	60e2                	ld	ra,24(sp)
 570:	6442                	ld	s0,16(sp)
 572:	6105                	addi	sp,sp,32
 574:	8082                	ret

0000000000000576 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 576:	7139                	addi	sp,sp,-64
 578:	fc06                	sd	ra,56(sp)
 57a:	f822                	sd	s0,48(sp)
 57c:	f426                	sd	s1,40(sp)
 57e:	0080                	addi	s0,sp,64
 580:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 582:	c299                	beqz	a3,588 <printint+0x12>
 584:	0805c963          	bltz	a1,616 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 588:	2581                	sext.w	a1,a1
  neg = 0;
 58a:	4881                	li	a7,0
 58c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 590:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 592:	2601                	sext.w	a2,a2
 594:	00000517          	auipc	a0,0x0
 598:	58450513          	addi	a0,a0,1412 # b18 <digits>
 59c:	883a                	mv	a6,a4
 59e:	2705                	addiw	a4,a4,1
 5a0:	02c5f7bb          	remuw	a5,a1,a2
 5a4:	1782                	slli	a5,a5,0x20
 5a6:	9381                	srli	a5,a5,0x20
 5a8:	97aa                	add	a5,a5,a0
 5aa:	0007c783          	lbu	a5,0(a5)
 5ae:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5b2:	0005879b          	sext.w	a5,a1
 5b6:	02c5d5bb          	divuw	a1,a1,a2
 5ba:	0685                	addi	a3,a3,1
 5bc:	fec7f0e3          	bgeu	a5,a2,59c <printint+0x26>
  if(neg)
 5c0:	00088c63          	beqz	a7,5d8 <printint+0x62>
    buf[i++] = '-';
 5c4:	fd070793          	addi	a5,a4,-48
 5c8:	00878733          	add	a4,a5,s0
 5cc:	02d00793          	li	a5,45
 5d0:	fef70823          	sb	a5,-16(a4)
 5d4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5d8:	02e05a63          	blez	a4,60c <printint+0x96>
 5dc:	f04a                	sd	s2,32(sp)
 5de:	ec4e                	sd	s3,24(sp)
 5e0:	fc040793          	addi	a5,s0,-64
 5e4:	00e78933          	add	s2,a5,a4
 5e8:	fff78993          	addi	s3,a5,-1
 5ec:	99ba                	add	s3,s3,a4
 5ee:	377d                	addiw	a4,a4,-1
 5f0:	1702                	slli	a4,a4,0x20
 5f2:	9301                	srli	a4,a4,0x20
 5f4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5f8:	fff94583          	lbu	a1,-1(s2)
 5fc:	8526                	mv	a0,s1
 5fe:	f5bff0ef          	jal	558 <putc>
  while(--i >= 0)
 602:	197d                	addi	s2,s2,-1
 604:	ff391ae3          	bne	s2,s3,5f8 <printint+0x82>
 608:	7902                	ld	s2,32(sp)
 60a:	69e2                	ld	s3,24(sp)
}
 60c:	70e2                	ld	ra,56(sp)
 60e:	7442                	ld	s0,48(sp)
 610:	74a2                	ld	s1,40(sp)
 612:	6121                	addi	sp,sp,64
 614:	8082                	ret
    x = -xx;
 616:	40b005bb          	negw	a1,a1
    neg = 1;
 61a:	4885                	li	a7,1
    x = -xx;
 61c:	bf85                	j	58c <printint+0x16>

000000000000061e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 61e:	711d                	addi	sp,sp,-96
 620:	ec86                	sd	ra,88(sp)
 622:	e8a2                	sd	s0,80(sp)
 624:	e0ca                	sd	s2,64(sp)
 626:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 628:	0005c903          	lbu	s2,0(a1)
 62c:	26090863          	beqz	s2,89c <vprintf+0x27e>
 630:	e4a6                	sd	s1,72(sp)
 632:	fc4e                	sd	s3,56(sp)
 634:	f852                	sd	s4,48(sp)
 636:	f456                	sd	s5,40(sp)
 638:	f05a                	sd	s6,32(sp)
 63a:	ec5e                	sd	s7,24(sp)
 63c:	e862                	sd	s8,16(sp)
 63e:	e466                	sd	s9,8(sp)
 640:	8b2a                	mv	s6,a0
 642:	8a2e                	mv	s4,a1
 644:	8bb2                	mv	s7,a2
  state = 0;
 646:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 648:	4481                	li	s1,0
 64a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 64c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 650:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 654:	06c00c93          	li	s9,108
 658:	a005                	j	678 <vprintf+0x5a>
        putc(fd, c0);
 65a:	85ca                	mv	a1,s2
 65c:	855a                	mv	a0,s6
 65e:	efbff0ef          	jal	558 <putc>
 662:	a019                	j	668 <vprintf+0x4a>
    } else if(state == '%'){
 664:	03598263          	beq	s3,s5,688 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 668:	2485                	addiw	s1,s1,1
 66a:	8726                	mv	a4,s1
 66c:	009a07b3          	add	a5,s4,s1
 670:	0007c903          	lbu	s2,0(a5)
 674:	20090c63          	beqz	s2,88c <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 678:	0009079b          	sext.w	a5,s2
    if(state == 0){
 67c:	fe0994e3          	bnez	s3,664 <vprintf+0x46>
      if(c0 == '%'){
 680:	fd579de3          	bne	a5,s5,65a <vprintf+0x3c>
        state = '%';
 684:	89be                	mv	s3,a5
 686:	b7cd                	j	668 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 688:	00ea06b3          	add	a3,s4,a4
 68c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 690:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 692:	c681                	beqz	a3,69a <vprintf+0x7c>
 694:	9752                	add	a4,a4,s4
 696:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 69a:	03878f63          	beq	a5,s8,6d8 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 69e:	05978963          	beq	a5,s9,6f0 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6a2:	07500713          	li	a4,117
 6a6:	0ee78363          	beq	a5,a4,78c <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6aa:	07800713          	li	a4,120
 6ae:	12e78563          	beq	a5,a4,7d8 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6b2:	07000713          	li	a4,112
 6b6:	14e78a63          	beq	a5,a4,80a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6ba:	07300713          	li	a4,115
 6be:	18e78a63          	beq	a5,a4,852 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6c2:	02500713          	li	a4,37
 6c6:	04e79563          	bne	a5,a4,710 <vprintf+0xf2>
        putc(fd, '%');
 6ca:	02500593          	li	a1,37
 6ce:	855a                	mv	a0,s6
 6d0:	e89ff0ef          	jal	558 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	bf49                	j	668 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6d8:	008b8913          	addi	s2,s7,8
 6dc:	4685                	li	a3,1
 6de:	4629                	li	a2,10
 6e0:	000ba583          	lw	a1,0(s7)
 6e4:	855a                	mv	a0,s6
 6e6:	e91ff0ef          	jal	576 <printint>
 6ea:	8bca                	mv	s7,s2
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	bfad                	j	668 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6f0:	06400793          	li	a5,100
 6f4:	02f68963          	beq	a3,a5,726 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6f8:	06c00793          	li	a5,108
 6fc:	04f68263          	beq	a3,a5,740 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 700:	07500793          	li	a5,117
 704:	0af68063          	beq	a3,a5,7a4 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 708:	07800793          	li	a5,120
 70c:	0ef68263          	beq	a3,a5,7f0 <vprintf+0x1d2>
        putc(fd, '%');
 710:	02500593          	li	a1,37
 714:	855a                	mv	a0,s6
 716:	e43ff0ef          	jal	558 <putc>
        putc(fd, c0);
 71a:	85ca                	mv	a1,s2
 71c:	855a                	mv	a0,s6
 71e:	e3bff0ef          	jal	558 <putc>
      state = 0;
 722:	4981                	li	s3,0
 724:	b791                	j	668 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 726:	008b8913          	addi	s2,s7,8
 72a:	4685                	li	a3,1
 72c:	4629                	li	a2,10
 72e:	000ba583          	lw	a1,0(s7)
 732:	855a                	mv	a0,s6
 734:	e43ff0ef          	jal	576 <printint>
        i += 1;
 738:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 73a:	8bca                	mv	s7,s2
      state = 0;
 73c:	4981                	li	s3,0
        i += 1;
 73e:	b72d                	j	668 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 740:	06400793          	li	a5,100
 744:	02f60763          	beq	a2,a5,772 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 748:	07500793          	li	a5,117
 74c:	06f60963          	beq	a2,a5,7be <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 750:	07800793          	li	a5,120
 754:	faf61ee3          	bne	a2,a5,710 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 758:	008b8913          	addi	s2,s7,8
 75c:	4681                	li	a3,0
 75e:	4641                	li	a2,16
 760:	000ba583          	lw	a1,0(s7)
 764:	855a                	mv	a0,s6
 766:	e11ff0ef          	jal	576 <printint>
        i += 2;
 76a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 76c:	8bca                	mv	s7,s2
      state = 0;
 76e:	4981                	li	s3,0
        i += 2;
 770:	bde5                	j	668 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 772:	008b8913          	addi	s2,s7,8
 776:	4685                	li	a3,1
 778:	4629                	li	a2,10
 77a:	000ba583          	lw	a1,0(s7)
 77e:	855a                	mv	a0,s6
 780:	df7ff0ef          	jal	576 <printint>
        i += 2;
 784:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 786:	8bca                	mv	s7,s2
      state = 0;
 788:	4981                	li	s3,0
        i += 2;
 78a:	bdf9                	j	668 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 78c:	008b8913          	addi	s2,s7,8
 790:	4681                	li	a3,0
 792:	4629                	li	a2,10
 794:	000ba583          	lw	a1,0(s7)
 798:	855a                	mv	a0,s6
 79a:	dddff0ef          	jal	576 <printint>
 79e:	8bca                	mv	s7,s2
      state = 0;
 7a0:	4981                	li	s3,0
 7a2:	b5d9                	j	668 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a4:	008b8913          	addi	s2,s7,8
 7a8:	4681                	li	a3,0
 7aa:	4629                	li	a2,10
 7ac:	000ba583          	lw	a1,0(s7)
 7b0:	855a                	mv	a0,s6
 7b2:	dc5ff0ef          	jal	576 <printint>
        i += 1;
 7b6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b8:	8bca                	mv	s7,s2
      state = 0;
 7ba:	4981                	li	s3,0
        i += 1;
 7bc:	b575                	j	668 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7be:	008b8913          	addi	s2,s7,8
 7c2:	4681                	li	a3,0
 7c4:	4629                	li	a2,10
 7c6:	000ba583          	lw	a1,0(s7)
 7ca:	855a                	mv	a0,s6
 7cc:	dabff0ef          	jal	576 <printint>
        i += 2;
 7d0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d2:	8bca                	mv	s7,s2
      state = 0;
 7d4:	4981                	li	s3,0
        i += 2;
 7d6:	bd49                	j	668 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7d8:	008b8913          	addi	s2,s7,8
 7dc:	4681                	li	a3,0
 7de:	4641                	li	a2,16
 7e0:	000ba583          	lw	a1,0(s7)
 7e4:	855a                	mv	a0,s6
 7e6:	d91ff0ef          	jal	576 <printint>
 7ea:	8bca                	mv	s7,s2
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	bdad                	j	668 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7f0:	008b8913          	addi	s2,s7,8
 7f4:	4681                	li	a3,0
 7f6:	4641                	li	a2,16
 7f8:	000ba583          	lw	a1,0(s7)
 7fc:	855a                	mv	a0,s6
 7fe:	d79ff0ef          	jal	576 <printint>
        i += 1;
 802:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 804:	8bca                	mv	s7,s2
      state = 0;
 806:	4981                	li	s3,0
        i += 1;
 808:	b585                	j	668 <vprintf+0x4a>
 80a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 80c:	008b8d13          	addi	s10,s7,8
 810:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 814:	03000593          	li	a1,48
 818:	855a                	mv	a0,s6
 81a:	d3fff0ef          	jal	558 <putc>
  putc(fd, 'x');
 81e:	07800593          	li	a1,120
 822:	855a                	mv	a0,s6
 824:	d35ff0ef          	jal	558 <putc>
 828:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 82a:	00000b97          	auipc	s7,0x0
 82e:	2eeb8b93          	addi	s7,s7,750 # b18 <digits>
 832:	03c9d793          	srli	a5,s3,0x3c
 836:	97de                	add	a5,a5,s7
 838:	0007c583          	lbu	a1,0(a5)
 83c:	855a                	mv	a0,s6
 83e:	d1bff0ef          	jal	558 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 842:	0992                	slli	s3,s3,0x4
 844:	397d                	addiw	s2,s2,-1
 846:	fe0916e3          	bnez	s2,832 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 84a:	8bea                	mv	s7,s10
      state = 0;
 84c:	4981                	li	s3,0
 84e:	6d02                	ld	s10,0(sp)
 850:	bd21                	j	668 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 852:	008b8993          	addi	s3,s7,8
 856:	000bb903          	ld	s2,0(s7)
 85a:	00090f63          	beqz	s2,878 <vprintf+0x25a>
        for(; *s; s++)
 85e:	00094583          	lbu	a1,0(s2)
 862:	c195                	beqz	a1,886 <vprintf+0x268>
          putc(fd, *s);
 864:	855a                	mv	a0,s6
 866:	cf3ff0ef          	jal	558 <putc>
        for(; *s; s++)
 86a:	0905                	addi	s2,s2,1
 86c:	00094583          	lbu	a1,0(s2)
 870:	f9f5                	bnez	a1,864 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 872:	8bce                	mv	s7,s3
      state = 0;
 874:	4981                	li	s3,0
 876:	bbcd                	j	668 <vprintf+0x4a>
          s = "(null)";
 878:	00000917          	auipc	s2,0x0
 87c:	29890913          	addi	s2,s2,664 # b10 <malloc+0x18c>
        for(; *s; s++)
 880:	02800593          	li	a1,40
 884:	b7c5                	j	864 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 886:	8bce                	mv	s7,s3
      state = 0;
 888:	4981                	li	s3,0
 88a:	bbf9                	j	668 <vprintf+0x4a>
 88c:	64a6                	ld	s1,72(sp)
 88e:	79e2                	ld	s3,56(sp)
 890:	7a42                	ld	s4,48(sp)
 892:	7aa2                	ld	s5,40(sp)
 894:	7b02                	ld	s6,32(sp)
 896:	6be2                	ld	s7,24(sp)
 898:	6c42                	ld	s8,16(sp)
 89a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 89c:	60e6                	ld	ra,88(sp)
 89e:	6446                	ld	s0,80(sp)
 8a0:	6906                	ld	s2,64(sp)
 8a2:	6125                	addi	sp,sp,96
 8a4:	8082                	ret

00000000000008a6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8a6:	715d                	addi	sp,sp,-80
 8a8:	ec06                	sd	ra,24(sp)
 8aa:	e822                	sd	s0,16(sp)
 8ac:	1000                	addi	s0,sp,32
 8ae:	e010                	sd	a2,0(s0)
 8b0:	e414                	sd	a3,8(s0)
 8b2:	e818                	sd	a4,16(s0)
 8b4:	ec1c                	sd	a5,24(s0)
 8b6:	03043023          	sd	a6,32(s0)
 8ba:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8be:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8c2:	8622                	mv	a2,s0
 8c4:	d5bff0ef          	jal	61e <vprintf>
}
 8c8:	60e2                	ld	ra,24(sp)
 8ca:	6442                	ld	s0,16(sp)
 8cc:	6161                	addi	sp,sp,80
 8ce:	8082                	ret

00000000000008d0 <printf>:

void
printf(const char *fmt, ...)
{
 8d0:	711d                	addi	sp,sp,-96
 8d2:	ec06                	sd	ra,24(sp)
 8d4:	e822                	sd	s0,16(sp)
 8d6:	1000                	addi	s0,sp,32
 8d8:	e40c                	sd	a1,8(s0)
 8da:	e810                	sd	a2,16(s0)
 8dc:	ec14                	sd	a3,24(s0)
 8de:	f018                	sd	a4,32(s0)
 8e0:	f41c                	sd	a5,40(s0)
 8e2:	03043823          	sd	a6,48(s0)
 8e6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8ea:	00840613          	addi	a2,s0,8
 8ee:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8f2:	85aa                	mv	a1,a0
 8f4:	4505                	li	a0,1
 8f6:	d29ff0ef          	jal	61e <vprintf>
}
 8fa:	60e2                	ld	ra,24(sp)
 8fc:	6442                	ld	s0,16(sp)
 8fe:	6125                	addi	sp,sp,96
 900:	8082                	ret

0000000000000902 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 902:	1141                	addi	sp,sp,-16
 904:	e422                	sd	s0,8(sp)
 906:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 908:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90c:	00000797          	auipc	a5,0x0
 910:	7147b783          	ld	a5,1812(a5) # 1020 <freep>
 914:	a02d                	j	93e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 916:	4618                	lw	a4,8(a2)
 918:	9f2d                	addw	a4,a4,a1
 91a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 91e:	6398                	ld	a4,0(a5)
 920:	6310                	ld	a2,0(a4)
 922:	a83d                	j	960 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 924:	ff852703          	lw	a4,-8(a0)
 928:	9f31                	addw	a4,a4,a2
 92a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 92c:	ff053683          	ld	a3,-16(a0)
 930:	a091                	j	974 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 932:	6398                	ld	a4,0(a5)
 934:	00e7e463          	bltu	a5,a4,93c <free+0x3a>
 938:	00e6ea63          	bltu	a3,a4,94c <free+0x4a>
{
 93c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 93e:	fed7fae3          	bgeu	a5,a3,932 <free+0x30>
 942:	6398                	ld	a4,0(a5)
 944:	00e6e463          	bltu	a3,a4,94c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 948:	fee7eae3          	bltu	a5,a4,93c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 94c:	ff852583          	lw	a1,-8(a0)
 950:	6390                	ld	a2,0(a5)
 952:	02059813          	slli	a6,a1,0x20
 956:	01c85713          	srli	a4,a6,0x1c
 95a:	9736                	add	a4,a4,a3
 95c:	fae60de3          	beq	a2,a4,916 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 960:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 964:	4790                	lw	a2,8(a5)
 966:	02061593          	slli	a1,a2,0x20
 96a:	01c5d713          	srli	a4,a1,0x1c
 96e:	973e                	add	a4,a4,a5
 970:	fae68ae3          	beq	a3,a4,924 <free+0x22>
    p->s.ptr = bp->s.ptr;
 974:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 976:	00000717          	auipc	a4,0x0
 97a:	6af73523          	sd	a5,1706(a4) # 1020 <freep>
}
 97e:	6422                	ld	s0,8(sp)
 980:	0141                	addi	sp,sp,16
 982:	8082                	ret

0000000000000984 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 984:	7139                	addi	sp,sp,-64
 986:	fc06                	sd	ra,56(sp)
 988:	f822                	sd	s0,48(sp)
 98a:	f426                	sd	s1,40(sp)
 98c:	ec4e                	sd	s3,24(sp)
 98e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 990:	02051493          	slli	s1,a0,0x20
 994:	9081                	srli	s1,s1,0x20
 996:	04bd                	addi	s1,s1,15
 998:	8091                	srli	s1,s1,0x4
 99a:	0014899b          	addiw	s3,s1,1
 99e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9a0:	00000517          	auipc	a0,0x0
 9a4:	68053503          	ld	a0,1664(a0) # 1020 <freep>
 9a8:	c915                	beqz	a0,9dc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9aa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ac:	4798                	lw	a4,8(a5)
 9ae:	08977863          	bgeu	a4,s1,a3e <malloc+0xba>
 9b2:	f04a                	sd	s2,32(sp)
 9b4:	e852                	sd	s4,16(sp)
 9b6:	e456                	sd	s5,8(sp)
 9b8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9ba:	8a4e                	mv	s4,s3
 9bc:	0009871b          	sext.w	a4,s3
 9c0:	6685                	lui	a3,0x1
 9c2:	00d77363          	bgeu	a4,a3,9c8 <malloc+0x44>
 9c6:	6a05                	lui	s4,0x1
 9c8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9cc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9d0:	00000917          	auipc	s2,0x0
 9d4:	65090913          	addi	s2,s2,1616 # 1020 <freep>
  if(p == (char*)-1)
 9d8:	5afd                	li	s5,-1
 9da:	a835                	j	a16 <malloc+0x92>
 9dc:	f04a                	sd	s2,32(sp)
 9de:	e852                	sd	s4,16(sp)
 9e0:	e456                	sd	s5,8(sp)
 9e2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9e4:	80c18793          	addi	a5,gp,-2036 # 1028 <base>
 9e8:	00000717          	auipc	a4,0x0
 9ec:	62f73c23          	sd	a5,1592(a4) # 1020 <freep>
 9f0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9f2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9f6:	b7d1                	j	9ba <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9f8:	6398                	ld	a4,0(a5)
 9fa:	e118                	sd	a4,0(a0)
 9fc:	a8a9                	j	a56 <malloc+0xd2>
  hp->s.size = nu;
 9fe:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a02:	0541                	addi	a0,a0,16
 a04:	effff0ef          	jal	902 <free>
  return freep;
 a08:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a0c:	c12d                	beqz	a0,a6e <malloc+0xea>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a0e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a10:	4798                	lw	a4,8(a5)
 a12:	02977263          	bgeu	a4,s1,a36 <malloc+0xb2>
    if(p == freep)
 a16:	00093703          	ld	a4,0(s2)
 a1a:	853e                	mv	a0,a5
 a1c:	fef719e3          	bne	a4,a5,a0e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a20:	8552                	mv	a0,s4
 a22:	ad7ff0ef          	jal	4f8 <sbrk>
  if(p == (char*)-1)
 a26:	fd551ce3          	bne	a0,s5,9fe <malloc+0x7a>
        return 0;
 a2a:	4501                	li	a0,0
 a2c:	7902                	ld	s2,32(sp)
 a2e:	6a42                	ld	s4,16(sp)
 a30:	6aa2                	ld	s5,8(sp)
 a32:	6b02                	ld	s6,0(sp)
 a34:	a03d                	j	a62 <malloc+0xde>
 a36:	7902                	ld	s2,32(sp)
 a38:	6a42                	ld	s4,16(sp)
 a3a:	6aa2                	ld	s5,8(sp)
 a3c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a3e:	fae48de3          	beq	s1,a4,9f8 <malloc+0x74>
        p->s.size -= nunits;
 a42:	4137073b          	subw	a4,a4,s3
 a46:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a48:	02071693          	slli	a3,a4,0x20
 a4c:	01c6d713          	srli	a4,a3,0x1c
 a50:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a52:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a56:	00000717          	auipc	a4,0x0
 a5a:	5ca73523          	sd	a0,1482(a4) # 1020 <freep>
      return (void*)(p + 1);
 a5e:	01078513          	addi	a0,a5,16
  }
}
 a62:	70e2                	ld	ra,56(sp)
 a64:	7442                	ld	s0,48(sp)
 a66:	74a2                	ld	s1,40(sp)
 a68:	69e2                	ld	s3,24(sp)
 a6a:	6121                	addi	sp,sp,64
 a6c:	8082                	ret
 a6e:	7902                	ld	s2,32(sp)
 a70:	6a42                	ld	s4,16(sp)
 a72:	6aa2                	ld	s5,8(sp)
 a74:	6b02                	ld	s6,0(sp)
 a76:	b7f5                	j	a62 <malloc+0xde>
