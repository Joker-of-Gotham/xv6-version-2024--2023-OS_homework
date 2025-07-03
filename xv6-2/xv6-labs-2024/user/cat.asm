
user/_cat：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	00090913          	mv	s2,s2
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	47c000ef          	jal	49c <read>
  24:	84aa                	mv	s1,a0
  26:	02a05363          	blez	a0,4c <cat+0x4c>
    if (write(1, buf, n) != n) {
  2a:	8626                	mv	a2,s1
  2c:	85ca                	mv	a1,s2
  2e:	4505                	li	a0,1
  30:	474000ef          	jal	4a4 <write>
  34:	fe9502e3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  38:	00001597          	auipc	a1,0x1
  3c:	a5858593          	addi	a1,a1,-1448 # a90 <malloc+0xf8>
  40:	4509                	li	a0,2
  42:	079000ef          	jal	8ba <fprintf>
      exit(1);
  46:	4505                	li	a0,1
  48:	43c000ef          	jal	484 <exit>
    }
  }
  if(n < 0){
  4c:	00054963          	bltz	a0,5e <cat+0x5e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  50:	70a2                	ld	ra,40(sp)
  52:	7402                	ld	s0,32(sp)
  54:	64e2                	ld	s1,24(sp)
  56:	6942                	ld	s2,16(sp)
  58:	69a2                	ld	s3,8(sp)
  5a:	6145                	addi	sp,sp,48
  5c:	8082                	ret
    fprintf(2, "cat: read error\n");
  5e:	00001597          	auipc	a1,0x1
  62:	a4a58593          	addi	a1,a1,-1462 # aa8 <malloc+0x110>
  66:	4509                	li	a0,2
  68:	053000ef          	jal	8ba <fprintf>
    exit(1);
  6c:	4505                	li	a0,1
  6e:	416000ef          	jal	484 <exit>

0000000000000072 <main>:

int
main(int argc, char *argv[])
{
  72:	7179                	addi	sp,sp,-48
  74:	f406                	sd	ra,40(sp)
  76:	f022                	sd	s0,32(sp)
  78:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  7a:	4785                	li	a5,1
  7c:	04a7d263          	bge	a5,a0,c0 <main+0x4e>
  80:	ec26                	sd	s1,24(sp)
  82:	e84a                	sd	s2,16(sp)
  84:	e44e                	sd	s3,8(sp)
  86:	00858913          	addi	s2,a1,8
  8a:	ffe5099b          	addiw	s3,a0,-2
  8e:	02099793          	slli	a5,s3,0x20
  92:	01d7d993          	srli	s3,a5,0x1d
  96:	05c1                	addi	a1,a1,16
  98:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
  9a:	4581                	li	a1,0
  9c:	00093503          	ld	a0,0(s2) # 1010 <buf>
  a0:	424000ef          	jal	4c4 <open>
  a4:	84aa                	mv	s1,a0
  a6:	02054663          	bltz	a0,d2 <main+0x60>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  aa:	f57ff0ef          	jal	0 <cat>
    close(fd);
  ae:	8526                	mv	a0,s1
  b0:	3fc000ef          	jal	4ac <close>
  for(i = 1; i < argc; i++){
  b4:	0921                	addi	s2,s2,8
  b6:	ff3912e3          	bne	s2,s3,9a <main+0x28>
  }
  exit(0);
  ba:	4501                	li	a0,0
  bc:	3c8000ef          	jal	484 <exit>
  c0:	ec26                	sd	s1,24(sp)
  c2:	e84a                	sd	s2,16(sp)
  c4:	e44e                	sd	s3,8(sp)
    cat(0);
  c6:	4501                	li	a0,0
  c8:	f39ff0ef          	jal	0 <cat>
    exit(0);
  cc:	4501                	li	a0,0
  ce:	3b6000ef          	jal	484 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  d2:	00093603          	ld	a2,0(s2)
  d6:	00001597          	auipc	a1,0x1
  da:	9ea58593          	addi	a1,a1,-1558 # ac0 <malloc+0x128>
  de:	4509                	li	a0,2
  e0:	7da000ef          	jal	8ba <fprintf>
      exit(1);
  e4:	4505                	li	a0,1
  e6:	39e000ef          	jal	484 <exit>

00000000000000ea <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e406                	sd	ra,8(sp)
  ee:	e022                	sd	s0,0(sp)
  f0:	0800                	addi	s0,sp,16
  extern int main();
  main();
  f2:	f81ff0ef          	jal	72 <main>
  exit(0);
  f6:	4501                	li	a0,0
  f8:	38c000ef          	jal	484 <exit>

00000000000000fc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  fc:	1141                	addi	sp,sp,-16
  fe:	e422                	sd	s0,8(sp)
 100:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 102:	87aa                	mv	a5,a0
 104:	0585                	addi	a1,a1,1
 106:	0785                	addi	a5,a5,1
 108:	fff5c703          	lbu	a4,-1(a1)
 10c:	fee78fa3          	sb	a4,-1(a5)
 110:	fb75                	bnez	a4,104 <strcpy+0x8>
    ;
  return os;
}
 112:	6422                	ld	s0,8(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e422                	sd	s0,8(sp)
 11c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 11e:	00054783          	lbu	a5,0(a0)
 122:	cb91                	beqz	a5,136 <strcmp+0x1e>
 124:	0005c703          	lbu	a4,0(a1)
 128:	00f71763          	bne	a4,a5,136 <strcmp+0x1e>
    p++, q++;
 12c:	0505                	addi	a0,a0,1
 12e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 130:	00054783          	lbu	a5,0(a0)
 134:	fbe5                	bnez	a5,124 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 136:	0005c503          	lbu	a0,0(a1)
}
 13a:	40a7853b          	subw	a0,a5,a0
 13e:	6422                	ld	s0,8(sp)
 140:	0141                	addi	sp,sp,16
 142:	8082                	ret

0000000000000144 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 144:	1141                	addi	sp,sp,-16
 146:	e422                	sd	s0,8(sp)
 148:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q) {
 14a:	ce11                	beqz	a2,166 <strncmp+0x22>
 14c:	00054783          	lbu	a5,0(a0)
 150:	cf89                	beqz	a5,16a <strncmp+0x26>
 152:	0005c703          	lbu	a4,0(a1)
 156:	00f71a63          	bne	a4,a5,16a <strncmp+0x26>
    n--;
 15a:	367d                	addiw	a2,a2,-1
    p++;
 15c:	0505                	addi	a0,a0,1
    q++;
 15e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q) {
 160:	f675                	bnez	a2,14c <strncmp+0x8>
  }
  if(n == 0)
    return 0;
 162:	4501                	li	a0,0
 164:	a801                	j	174 <strncmp+0x30>
 166:	4501                	li	a0,0
 168:	a031                	j	174 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
 16a:	00054503          	lbu	a0,0(a0)
 16e:	0005c783          	lbu	a5,0(a1)
 172:	9d1d                	subw	a0,a0,a5
}
 174:	6422                	ld	s0,8(sp)
 176:	0141                	addi	sp,sp,16
 178:	8082                	ret

000000000000017a <strlen>:

uint
strlen(const char *s)
{
 17a:	1141                	addi	sp,sp,-16
 17c:	e422                	sd	s0,8(sp)
 17e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 180:	00054783          	lbu	a5,0(a0)
 184:	cf91                	beqz	a5,1a0 <strlen+0x26>
 186:	0505                	addi	a0,a0,1
 188:	87aa                	mv	a5,a0
 18a:	86be                	mv	a3,a5
 18c:	0785                	addi	a5,a5,1
 18e:	fff7c703          	lbu	a4,-1(a5)
 192:	ff65                	bnez	a4,18a <strlen+0x10>
 194:	40a6853b          	subw	a0,a3,a0
 198:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 19a:	6422                	ld	s0,8(sp)
 19c:	0141                	addi	sp,sp,16
 19e:	8082                	ret
  for(n = 0; s[n]; n++)
 1a0:	4501                	li	a0,0
 1a2:	bfe5                	j	19a <strlen+0x20>

00000000000001a4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1aa:	ca19                	beqz	a2,1c0 <memset+0x1c>
 1ac:	87aa                	mv	a5,a0
 1ae:	1602                	slli	a2,a2,0x20
 1b0:	9201                	srli	a2,a2,0x20
 1b2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1b6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ba:	0785                	addi	a5,a5,1
 1bc:	fee79de3          	bne	a5,a4,1b6 <memset+0x12>
  }
  return dst;
}
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret

00000000000001c6 <strchr>:

char*
strchr(const char *s, char c)
{
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e422                	sd	s0,8(sp)
 1ca:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	cb99                	beqz	a5,1e6 <strchr+0x20>
    if(*s == c)
 1d2:	00f58763          	beq	a1,a5,1e0 <strchr+0x1a>
  for(; *s; s++)
 1d6:	0505                	addi	a0,a0,1
 1d8:	00054783          	lbu	a5,0(a0)
 1dc:	fbfd                	bnez	a5,1d2 <strchr+0xc>
      return (char*)s;
  return 0;
 1de:	4501                	li	a0,0
}
 1e0:	6422                	ld	s0,8(sp)
 1e2:	0141                	addi	sp,sp,16
 1e4:	8082                	ret
  return 0;
 1e6:	4501                	li	a0,0
 1e8:	bfe5                	j	1e0 <strchr+0x1a>

00000000000001ea <gets>:

char*
gets(char *buf, int max)
{
 1ea:	711d                	addi	sp,sp,-96
 1ec:	ec86                	sd	ra,88(sp)
 1ee:	e8a2                	sd	s0,80(sp)
 1f0:	e4a6                	sd	s1,72(sp)
 1f2:	e0ca                	sd	s2,64(sp)
 1f4:	fc4e                	sd	s3,56(sp)
 1f6:	f852                	sd	s4,48(sp)
 1f8:	f456                	sd	s5,40(sp)
 1fa:	f05a                	sd	s6,32(sp)
 1fc:	ec5e                	sd	s7,24(sp)
 1fe:	1080                	addi	s0,sp,96
 200:	8baa                	mv	s7,a0
 202:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 204:	892a                	mv	s2,a0
 206:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 208:	4aa9                	li	s5,10
 20a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 20c:	89a6                	mv	s3,s1
 20e:	2485                	addiw	s1,s1,1
 210:	0344d663          	bge	s1,s4,23c <gets+0x52>
    cc = read(0, &c, 1);
 214:	4605                	li	a2,1
 216:	faf40593          	addi	a1,s0,-81
 21a:	4501                	li	a0,0
 21c:	280000ef          	jal	49c <read>
    if(cc < 1)
 220:	00a05e63          	blez	a0,23c <gets+0x52>
    buf[i++] = c;
 224:	faf44783          	lbu	a5,-81(s0)
 228:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 22c:	01578763          	beq	a5,s5,23a <gets+0x50>
 230:	0905                	addi	s2,s2,1
 232:	fd679de3          	bne	a5,s6,20c <gets+0x22>
    buf[i++] = c;
 236:	89a6                	mv	s3,s1
 238:	a011                	j	23c <gets+0x52>
 23a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 23c:	99de                	add	s3,s3,s7
 23e:	00098023          	sb	zero,0(s3)
  return buf;
}
 242:	855e                	mv	a0,s7
 244:	60e6                	ld	ra,88(sp)
 246:	6446                	ld	s0,80(sp)
 248:	64a6                	ld	s1,72(sp)
 24a:	6906                	ld	s2,64(sp)
 24c:	79e2                	ld	s3,56(sp)
 24e:	7a42                	ld	s4,48(sp)
 250:	7aa2                	ld	s5,40(sp)
 252:	7b02                	ld	s6,32(sp)
 254:	6be2                	ld	s7,24(sp)
 256:	6125                	addi	sp,sp,96
 258:	8082                	ret

000000000000025a <stat>:

int
stat(const char *n, struct stat *st)
{
 25a:	1101                	addi	sp,sp,-32
 25c:	ec06                	sd	ra,24(sp)
 25e:	e822                	sd	s0,16(sp)
 260:	e04a                	sd	s2,0(sp)
 262:	1000                	addi	s0,sp,32
 264:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 266:	4581                	li	a1,0
 268:	25c000ef          	jal	4c4 <open>
  if(fd < 0)
 26c:	02054263          	bltz	a0,290 <stat+0x36>
 270:	e426                	sd	s1,8(sp)
 272:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 274:	85ca                	mv	a1,s2
 276:	266000ef          	jal	4dc <fstat>
 27a:	892a                	mv	s2,a0
  close(fd);
 27c:	8526                	mv	a0,s1
 27e:	22e000ef          	jal	4ac <close>
  return r;
 282:	64a2                	ld	s1,8(sp)
}
 284:	854a                	mv	a0,s2
 286:	60e2                	ld	ra,24(sp)
 288:	6442                	ld	s0,16(sp)
 28a:	6902                	ld	s2,0(sp)
 28c:	6105                	addi	sp,sp,32
 28e:	8082                	ret
    return -1;
 290:	597d                	li	s2,-1
 292:	bfcd                	j	284 <stat+0x2a>

0000000000000294 <atoi>:

int
atoi(const char *s)
{
 294:	1141                	addi	sp,sp,-16
 296:	e422                	sd	s0,8(sp)
 298:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 29a:	00054683          	lbu	a3,0(a0)
 29e:	fd06879b          	addiw	a5,a3,-48
 2a2:	0ff7f793          	zext.b	a5,a5
 2a6:	4625                	li	a2,9
 2a8:	02f66863          	bltu	a2,a5,2d8 <atoi+0x44>
 2ac:	872a                	mv	a4,a0
  n = 0;
 2ae:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2b0:	0705                	addi	a4,a4,1
 2b2:	0025179b          	slliw	a5,a0,0x2
 2b6:	9fa9                	addw	a5,a5,a0
 2b8:	0017979b          	slliw	a5,a5,0x1
 2bc:	9fb5                	addw	a5,a5,a3
 2be:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2c2:	00074683          	lbu	a3,0(a4)
 2c6:	fd06879b          	addiw	a5,a3,-48
 2ca:	0ff7f793          	zext.b	a5,a5
 2ce:	fef671e3          	bgeu	a2,a5,2b0 <atoi+0x1c>
  return n;
}
 2d2:	6422                	ld	s0,8(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret
  n = 0;
 2d8:	4501                	li	a0,0
 2da:	bfe5                	j	2d2 <atoi+0x3e>

00000000000002dc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e422                	sd	s0,8(sp)
 2e0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e2:	02b57463          	bgeu	a0,a1,30a <memmove+0x2e>
    while(n-- > 0)
 2e6:	00c05f63          	blez	a2,304 <memmove+0x28>
 2ea:	1602                	slli	a2,a2,0x20
 2ec:	9201                	srli	a2,a2,0x20
 2ee:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f4:	0585                	addi	a1,a1,1
 2f6:	0705                	addi	a4,a4,1
 2f8:	fff5c683          	lbu	a3,-1(a1)
 2fc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 300:	fef71ae3          	bne	a4,a5,2f4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 304:	6422                	ld	s0,8(sp)
 306:	0141                	addi	sp,sp,16
 308:	8082                	ret
    dst += n;
 30a:	00c50733          	add	a4,a0,a2
    src += n;
 30e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 310:	fec05ae3          	blez	a2,304 <memmove+0x28>
 314:	fff6079b          	addiw	a5,a2,-1
 318:	1782                	slli	a5,a5,0x20
 31a:	9381                	srli	a5,a5,0x20
 31c:	fff7c793          	not	a5,a5
 320:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 322:	15fd                	addi	a1,a1,-1
 324:	177d                	addi	a4,a4,-1
 326:	0005c683          	lbu	a3,0(a1)
 32a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 32e:	fee79ae3          	bne	a5,a4,322 <memmove+0x46>
 332:	bfc9                	j	304 <memmove+0x28>

0000000000000334 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 334:	1141                	addi	sp,sp,-16
 336:	e422                	sd	s0,8(sp)
 338:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 33a:	ca05                	beqz	a2,36a <memcmp+0x36>
 33c:	fff6069b          	addiw	a3,a2,-1
 340:	1682                	slli	a3,a3,0x20
 342:	9281                	srli	a3,a3,0x20
 344:	0685                	addi	a3,a3,1
 346:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 348:	00054783          	lbu	a5,0(a0)
 34c:	0005c703          	lbu	a4,0(a1)
 350:	00e79863          	bne	a5,a4,360 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 354:	0505                	addi	a0,a0,1
    p2++;
 356:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 358:	fed518e3          	bne	a0,a3,348 <memcmp+0x14>
  }
  return 0;
 35c:	4501                	li	a0,0
 35e:	a019                	j	364 <memcmp+0x30>
      return *p1 - *p2;
 360:	40e7853b          	subw	a0,a5,a4
}
 364:	6422                	ld	s0,8(sp)
 366:	0141                	addi	sp,sp,16
 368:	8082                	ret
  return 0;
 36a:	4501                	li	a0,0
 36c:	bfe5                	j	364 <memcmp+0x30>

000000000000036e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 36e:	1141                	addi	sp,sp,-16
 370:	e406                	sd	ra,8(sp)
 372:	e022                	sd	s0,0(sp)
 374:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 376:	f67ff0ef          	jal	2dc <memmove>
}
 37a:	60a2                	ld	ra,8(sp)
 37c:	6402                	ld	s0,0(sp)
 37e:	0141                	addi	sp,sp,16
 380:	8082                	ret

0000000000000382 <simplesort>:

void
simplesort(void *base, uint nmemb, uint size, int (*compar)(const void *, const void *))
{
 382:	7119                	addi	sp,sp,-128
 384:	fc86                	sd	ra,120(sp)
 386:	f8a2                	sd	s0,112(sp)
 388:	0100                	addi	s0,sp,128
 38a:	f8b43423          	sd	a1,-120(s0)
  char *arr = (char *)base; // Treat array as char array for byte-level manipulation
  char *temp;               // Temporary storage for an element

  if (nmemb <= 1 || size == 0) {
 38e:	4785                	li	a5,1
 390:	00b7fc63          	bgeu	a5,a1,3a8 <simplesort+0x26>
 394:	e8d2                	sd	s4,80(sp)
 396:	e4d6                	sd	s5,72(sp)
 398:	f466                	sd	s9,40(sp)
 39a:	8aaa                	mv	s5,a0
 39c:	8a32                	mv	s4,a2
 39e:	8cb6                	mv	s9,a3
 3a0:	ea01                	bnez	a2,3b0 <simplesort+0x2e>
 3a2:	6a46                	ld	s4,80(sp)
 3a4:	6aa6                	ld	s5,72(sp)
 3a6:	7ca2                	ld	s9,40(sp)
    // Place temp at its correct position
    memmove(arr + j * size, temp, size);
  }

  free(temp); // Free temporary space
 3a8:	70e6                	ld	ra,120(sp)
 3aa:	7446                	ld	s0,112(sp)
 3ac:	6109                	addi	sp,sp,128
 3ae:	8082                	ret
 3b0:	fc5e                	sd	s7,56(sp)
 3b2:	f862                	sd	s8,48(sp)
 3b4:	f06a                	sd	s10,32(sp)
 3b6:	ec6e                	sd	s11,24(sp)
  temp = malloc(size); // Allocate temporary space for one element
 3b8:	8532                	mv	a0,a2
 3ba:	5de000ef          	jal	998 <malloc>
 3be:	8baa                	mv	s7,a0
  if (temp == 0) {
 3c0:	4d81                	li	s11,0
  for (uint i = 1; i < nmemb; i++) {
 3c2:	4d05                	li	s10,1
    memmove(temp, arr + i * size, size);
 3c4:	000a0c1b          	sext.w	s8,s4
  if (temp == 0) {
 3c8:	c511                	beqz	a0,3d4 <simplesort+0x52>
 3ca:	f4a6                	sd	s1,104(sp)
 3cc:	f0ca                	sd	s2,96(sp)
 3ce:	ecce                	sd	s3,88(sp)
 3d0:	e0da                	sd	s6,64(sp)
 3d2:	a82d                	j	40c <simplesort+0x8a>
    printf("simplesort: malloc failed, cannot sort\n");
 3d4:	00000517          	auipc	a0,0x0
 3d8:	70450513          	addi	a0,a0,1796 # ad8 <malloc+0x140>
 3dc:	508000ef          	jal	8e4 <printf>
    return;
 3e0:	6a46                	ld	s4,80(sp)
 3e2:	6aa6                	ld	s5,72(sp)
 3e4:	7be2                	ld	s7,56(sp)
 3e6:	7c42                	ld	s8,48(sp)
 3e8:	7ca2                	ld	s9,40(sp)
 3ea:	7d02                	ld	s10,32(sp)
 3ec:	6de2                	ld	s11,24(sp)
 3ee:	bf6d                	j	3a8 <simplesort+0x26>
    memmove(arr + j * size, temp, size);
 3f0:	036a053b          	mulw	a0,s4,s6
 3f4:	1502                	slli	a0,a0,0x20
 3f6:	9101                	srli	a0,a0,0x20
 3f8:	8662                	mv	a2,s8
 3fa:	85de                	mv	a1,s7
 3fc:	9556                	add	a0,a0,s5
 3fe:	edfff0ef          	jal	2dc <memmove>
  for (uint i = 1; i < nmemb; i++) {
 402:	2d05                	addiw	s10,s10,1
 404:	f8843783          	ld	a5,-120(s0)
 408:	05a78b63          	beq	a5,s10,45e <simplesort+0xdc>
    memmove(temp, arr + i * size, size);
 40c:	000d899b          	sext.w	s3,s11
 410:	01ba05bb          	addw	a1,s4,s11
 414:	00058d9b          	sext.w	s11,a1
 418:	1582                	slli	a1,a1,0x20
 41a:	9181                	srli	a1,a1,0x20
 41c:	8662                	mv	a2,s8
 41e:	95d6                	add	a1,a1,s5
 420:	855e                	mv	a0,s7
 422:	ebbff0ef          	jal	2dc <memmove>
    uint j = i;
 426:	896a                	mv	s2,s10
 428:	00090b1b          	sext.w	s6,s2
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 42c:	397d                	addiw	s2,s2,-1
 42e:	02099493          	slli	s1,s3,0x20
 432:	9081                	srli	s1,s1,0x20
 434:	94d6                	add	s1,s1,s5
 436:	85de                	mv	a1,s7
 438:	8526                	mv	a0,s1
 43a:	9c82                	jalr	s9
 43c:	faa05ae3          	blez	a0,3f0 <simplesort+0x6e>
      memmove(arr + j * size, arr + (j - 1) * size, size); // Shift element
 440:	0149853b          	addw	a0,s3,s4
 444:	1502                	slli	a0,a0,0x20
 446:	9101                	srli	a0,a0,0x20
 448:	8662                	mv	a2,s8
 44a:	85a6                	mv	a1,s1
 44c:	9556                	add	a0,a0,s5
 44e:	e8fff0ef          	jal	2dc <memmove>
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 452:	414989bb          	subw	s3,s3,s4
 456:	fc0919e3          	bnez	s2,428 <simplesort+0xa6>
 45a:	8b4a                	mv	s6,s2
 45c:	bf51                	j	3f0 <simplesort+0x6e>
  free(temp); // Free temporary space
 45e:	855e                	mv	a0,s7
 460:	4b6000ef          	jal	916 <free>
 464:	74a6                	ld	s1,104(sp)
 466:	7906                	ld	s2,96(sp)
 468:	69e6                	ld	s3,88(sp)
 46a:	6a46                	ld	s4,80(sp)
 46c:	6aa6                	ld	s5,72(sp)
 46e:	6b06                	ld	s6,64(sp)
 470:	7be2                	ld	s7,56(sp)
 472:	7c42                	ld	s8,48(sp)
 474:	7ca2                	ld	s9,40(sp)
 476:	7d02                	ld	s10,32(sp)
 478:	6de2                	ld	s11,24(sp)
 47a:	b73d                	j	3a8 <simplesort+0x26>

000000000000047c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 47c:	4885                	li	a7,1
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <exit>:
.global exit
exit:
 li a7, SYS_exit
 484:	4889                	li	a7,2
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <wait>:
.global wait
wait:
 li a7, SYS_wait
 48c:	488d                	li	a7,3
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 494:	4891                	li	a7,4
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <read>:
.global read
read:
 li a7, SYS_read
 49c:	4895                	li	a7,5
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <write>:
.global write
write:
 li a7, SYS_write
 4a4:	48c1                	li	a7,16
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <close>:
.global close
close:
 li a7, SYS_close
 4ac:	48d5                	li	a7,21
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4b4:	4899                	li	a7,6
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <exec>:
.global exec
exec:
 li a7, SYS_exec
 4bc:	489d                	li	a7,7
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <open>:
.global open
open:
 li a7, SYS_open
 4c4:	48bd                	li	a7,15
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4cc:	48c5                	li	a7,17
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4d4:	48c9                	li	a7,18
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4dc:	48a1                	li	a7,8
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <link>:
.global link
link:
 li a7, SYS_link
 4e4:	48cd                	li	a7,19
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4ec:	48d1                	li	a7,20
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4f4:	48a5                	li	a7,9
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <dup>:
.global dup
dup:
 li a7, SYS_dup
 4fc:	48a9                	li	a7,10
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 504:	48ad                	li	a7,11
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 50c:	48b1                	li	a7,12
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 514:	48b5                	li	a7,13
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 51c:	48b9                	li	a7,14
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 524:	48dd                	li	a7,23
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <statistics>:
.global statistics
statistics:
 li a7, SYS_statistics
 52c:	48e1                	li	a7,24
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <reset_stats>:
.global reset_stats
reset_stats:
 li a7, SYS_reset_stats
 534:	48e5                	li	a7,25
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <resetlockstats>:
.global resetlockstats
resetlockstats:
 li a7, SYS_resetlockstats
 53c:	48e9                	li	a7,26
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <getlockstats>:
.global getlockstats
getlockstats:
 li a7, SYS_getlockstats
 544:	48ed                	li	a7,27
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <trace>:
.global trace
trace:
 li a7, SYS_trace
 54c:	48d9                	li	a7,22
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 554:	48f1                	li	a7,28
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <ugetpid>:
.global ugetpid
ugetpid:
 li a7, SYS_ugetpid
 55c:	48f5                	li	a7,29
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 564:	48f9                	li	a7,30
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 56c:	1101                	addi	sp,sp,-32
 56e:	ec06                	sd	ra,24(sp)
 570:	e822                	sd	s0,16(sp)
 572:	1000                	addi	s0,sp,32
 574:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 578:	4605                	li	a2,1
 57a:	fef40593          	addi	a1,s0,-17
 57e:	f27ff0ef          	jal	4a4 <write>
}
 582:	60e2                	ld	ra,24(sp)
 584:	6442                	ld	s0,16(sp)
 586:	6105                	addi	sp,sp,32
 588:	8082                	ret

000000000000058a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 58a:	7139                	addi	sp,sp,-64
 58c:	fc06                	sd	ra,56(sp)
 58e:	f822                	sd	s0,48(sp)
 590:	f426                	sd	s1,40(sp)
 592:	0080                	addi	s0,sp,64
 594:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 596:	c299                	beqz	a3,59c <printint+0x12>
 598:	0805c963          	bltz	a1,62a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 59c:	2581                	sext.w	a1,a1
  neg = 0;
 59e:	4881                	li	a7,0
 5a0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5a4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5a6:	2601                	sext.w	a2,a2
 5a8:	00000517          	auipc	a0,0x0
 5ac:	56050513          	addi	a0,a0,1376 # b08 <digits>
 5b0:	883a                	mv	a6,a4
 5b2:	2705                	addiw	a4,a4,1
 5b4:	02c5f7bb          	remuw	a5,a1,a2
 5b8:	1782                	slli	a5,a5,0x20
 5ba:	9381                	srli	a5,a5,0x20
 5bc:	97aa                	add	a5,a5,a0
 5be:	0007c783          	lbu	a5,0(a5)
 5c2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5c6:	0005879b          	sext.w	a5,a1
 5ca:	02c5d5bb          	divuw	a1,a1,a2
 5ce:	0685                	addi	a3,a3,1
 5d0:	fec7f0e3          	bgeu	a5,a2,5b0 <printint+0x26>
  if(neg)
 5d4:	00088c63          	beqz	a7,5ec <printint+0x62>
    buf[i++] = '-';
 5d8:	fd070793          	addi	a5,a4,-48
 5dc:	00878733          	add	a4,a5,s0
 5e0:	02d00793          	li	a5,45
 5e4:	fef70823          	sb	a5,-16(a4)
 5e8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5ec:	02e05a63          	blez	a4,620 <printint+0x96>
 5f0:	f04a                	sd	s2,32(sp)
 5f2:	ec4e                	sd	s3,24(sp)
 5f4:	fc040793          	addi	a5,s0,-64
 5f8:	00e78933          	add	s2,a5,a4
 5fc:	fff78993          	addi	s3,a5,-1
 600:	99ba                	add	s3,s3,a4
 602:	377d                	addiw	a4,a4,-1
 604:	1702                	slli	a4,a4,0x20
 606:	9301                	srli	a4,a4,0x20
 608:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 60c:	fff94583          	lbu	a1,-1(s2)
 610:	8526                	mv	a0,s1
 612:	f5bff0ef          	jal	56c <putc>
  while(--i >= 0)
 616:	197d                	addi	s2,s2,-1
 618:	ff391ae3          	bne	s2,s3,60c <printint+0x82>
 61c:	7902                	ld	s2,32(sp)
 61e:	69e2                	ld	s3,24(sp)
}
 620:	70e2                	ld	ra,56(sp)
 622:	7442                	ld	s0,48(sp)
 624:	74a2                	ld	s1,40(sp)
 626:	6121                	addi	sp,sp,64
 628:	8082                	ret
    x = -xx;
 62a:	40b005bb          	negw	a1,a1
    neg = 1;
 62e:	4885                	li	a7,1
    x = -xx;
 630:	bf85                	j	5a0 <printint+0x16>

0000000000000632 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 632:	711d                	addi	sp,sp,-96
 634:	ec86                	sd	ra,88(sp)
 636:	e8a2                	sd	s0,80(sp)
 638:	e0ca                	sd	s2,64(sp)
 63a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 63c:	0005c903          	lbu	s2,0(a1)
 640:	26090863          	beqz	s2,8b0 <vprintf+0x27e>
 644:	e4a6                	sd	s1,72(sp)
 646:	fc4e                	sd	s3,56(sp)
 648:	f852                	sd	s4,48(sp)
 64a:	f456                	sd	s5,40(sp)
 64c:	f05a                	sd	s6,32(sp)
 64e:	ec5e                	sd	s7,24(sp)
 650:	e862                	sd	s8,16(sp)
 652:	e466                	sd	s9,8(sp)
 654:	8b2a                	mv	s6,a0
 656:	8a2e                	mv	s4,a1
 658:	8bb2                	mv	s7,a2
  state = 0;
 65a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 65c:	4481                	li	s1,0
 65e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 660:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 664:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 668:	06c00c93          	li	s9,108
 66c:	a005                	j	68c <vprintf+0x5a>
        putc(fd, c0);
 66e:	85ca                	mv	a1,s2
 670:	855a                	mv	a0,s6
 672:	efbff0ef          	jal	56c <putc>
 676:	a019                	j	67c <vprintf+0x4a>
    } else if(state == '%'){
 678:	03598263          	beq	s3,s5,69c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 67c:	2485                	addiw	s1,s1,1
 67e:	8726                	mv	a4,s1
 680:	009a07b3          	add	a5,s4,s1
 684:	0007c903          	lbu	s2,0(a5)
 688:	20090c63          	beqz	s2,8a0 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 68c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 690:	fe0994e3          	bnez	s3,678 <vprintf+0x46>
      if(c0 == '%'){
 694:	fd579de3          	bne	a5,s5,66e <vprintf+0x3c>
        state = '%';
 698:	89be                	mv	s3,a5
 69a:	b7cd                	j	67c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 69c:	00ea06b3          	add	a3,s4,a4
 6a0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6a4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6a6:	c681                	beqz	a3,6ae <vprintf+0x7c>
 6a8:	9752                	add	a4,a4,s4
 6aa:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6ae:	03878f63          	beq	a5,s8,6ec <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 6b2:	05978963          	beq	a5,s9,704 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6b6:	07500713          	li	a4,117
 6ba:	0ee78363          	beq	a5,a4,7a0 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6be:	07800713          	li	a4,120
 6c2:	12e78563          	beq	a5,a4,7ec <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6c6:	07000713          	li	a4,112
 6ca:	14e78a63          	beq	a5,a4,81e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6ce:	07300713          	li	a4,115
 6d2:	18e78a63          	beq	a5,a4,866 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6d6:	02500713          	li	a4,37
 6da:	04e79563          	bne	a5,a4,724 <vprintf+0xf2>
        putc(fd, '%');
 6de:	02500593          	li	a1,37
 6e2:	855a                	mv	a0,s6
 6e4:	e89ff0ef          	jal	56c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bf49                	j	67c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6ec:	008b8913          	addi	s2,s7,8
 6f0:	4685                	li	a3,1
 6f2:	4629                	li	a2,10
 6f4:	000ba583          	lw	a1,0(s7)
 6f8:	855a                	mv	a0,s6
 6fa:	e91ff0ef          	jal	58a <printint>
 6fe:	8bca                	mv	s7,s2
      state = 0;
 700:	4981                	li	s3,0
 702:	bfad                	j	67c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 704:	06400793          	li	a5,100
 708:	02f68963          	beq	a3,a5,73a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 70c:	06c00793          	li	a5,108
 710:	04f68263          	beq	a3,a5,754 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 714:	07500793          	li	a5,117
 718:	0af68063          	beq	a3,a5,7b8 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 71c:	07800793          	li	a5,120
 720:	0ef68263          	beq	a3,a5,804 <vprintf+0x1d2>
        putc(fd, '%');
 724:	02500593          	li	a1,37
 728:	855a                	mv	a0,s6
 72a:	e43ff0ef          	jal	56c <putc>
        putc(fd, c0);
 72e:	85ca                	mv	a1,s2
 730:	855a                	mv	a0,s6
 732:	e3bff0ef          	jal	56c <putc>
      state = 0;
 736:	4981                	li	s3,0
 738:	b791                	j	67c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 73a:	008b8913          	addi	s2,s7,8
 73e:	4685                	li	a3,1
 740:	4629                	li	a2,10
 742:	000ba583          	lw	a1,0(s7)
 746:	855a                	mv	a0,s6
 748:	e43ff0ef          	jal	58a <printint>
        i += 1;
 74c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 74e:	8bca                	mv	s7,s2
      state = 0;
 750:	4981                	li	s3,0
        i += 1;
 752:	b72d                	j	67c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 754:	06400793          	li	a5,100
 758:	02f60763          	beq	a2,a5,786 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 75c:	07500793          	li	a5,117
 760:	06f60963          	beq	a2,a5,7d2 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 764:	07800793          	li	a5,120
 768:	faf61ee3          	bne	a2,a5,724 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 76c:	008b8913          	addi	s2,s7,8
 770:	4681                	li	a3,0
 772:	4641                	li	a2,16
 774:	000ba583          	lw	a1,0(s7)
 778:	855a                	mv	a0,s6
 77a:	e11ff0ef          	jal	58a <printint>
        i += 2;
 77e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 780:	8bca                	mv	s7,s2
      state = 0;
 782:	4981                	li	s3,0
        i += 2;
 784:	bde5                	j	67c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 786:	008b8913          	addi	s2,s7,8
 78a:	4685                	li	a3,1
 78c:	4629                	li	a2,10
 78e:	000ba583          	lw	a1,0(s7)
 792:	855a                	mv	a0,s6
 794:	df7ff0ef          	jal	58a <printint>
        i += 2;
 798:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 79a:	8bca                	mv	s7,s2
      state = 0;
 79c:	4981                	li	s3,0
        i += 2;
 79e:	bdf9                	j	67c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7a0:	008b8913          	addi	s2,s7,8
 7a4:	4681                	li	a3,0
 7a6:	4629                	li	a2,10
 7a8:	000ba583          	lw	a1,0(s7)
 7ac:	855a                	mv	a0,s6
 7ae:	dddff0ef          	jal	58a <printint>
 7b2:	8bca                	mv	s7,s2
      state = 0;
 7b4:	4981                	li	s3,0
 7b6:	b5d9                	j	67c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b8:	008b8913          	addi	s2,s7,8
 7bc:	4681                	li	a3,0
 7be:	4629                	li	a2,10
 7c0:	000ba583          	lw	a1,0(s7)
 7c4:	855a                	mv	a0,s6
 7c6:	dc5ff0ef          	jal	58a <printint>
        i += 1;
 7ca:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7cc:	8bca                	mv	s7,s2
      state = 0;
 7ce:	4981                	li	s3,0
        i += 1;
 7d0:	b575                	j	67c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d2:	008b8913          	addi	s2,s7,8
 7d6:	4681                	li	a3,0
 7d8:	4629                	li	a2,10
 7da:	000ba583          	lw	a1,0(s7)
 7de:	855a                	mv	a0,s6
 7e0:	dabff0ef          	jal	58a <printint>
        i += 2;
 7e4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e6:	8bca                	mv	s7,s2
      state = 0;
 7e8:	4981                	li	s3,0
        i += 2;
 7ea:	bd49                	j	67c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7ec:	008b8913          	addi	s2,s7,8
 7f0:	4681                	li	a3,0
 7f2:	4641                	li	a2,16
 7f4:	000ba583          	lw	a1,0(s7)
 7f8:	855a                	mv	a0,s6
 7fa:	d91ff0ef          	jal	58a <printint>
 7fe:	8bca                	mv	s7,s2
      state = 0;
 800:	4981                	li	s3,0
 802:	bdad                	j	67c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 804:	008b8913          	addi	s2,s7,8
 808:	4681                	li	a3,0
 80a:	4641                	li	a2,16
 80c:	000ba583          	lw	a1,0(s7)
 810:	855a                	mv	a0,s6
 812:	d79ff0ef          	jal	58a <printint>
        i += 1;
 816:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 818:	8bca                	mv	s7,s2
      state = 0;
 81a:	4981                	li	s3,0
        i += 1;
 81c:	b585                	j	67c <vprintf+0x4a>
 81e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 820:	008b8d13          	addi	s10,s7,8
 824:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 828:	03000593          	li	a1,48
 82c:	855a                	mv	a0,s6
 82e:	d3fff0ef          	jal	56c <putc>
  putc(fd, 'x');
 832:	07800593          	li	a1,120
 836:	855a                	mv	a0,s6
 838:	d35ff0ef          	jal	56c <putc>
 83c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 83e:	00000b97          	auipc	s7,0x0
 842:	2cab8b93          	addi	s7,s7,714 # b08 <digits>
 846:	03c9d793          	srli	a5,s3,0x3c
 84a:	97de                	add	a5,a5,s7
 84c:	0007c583          	lbu	a1,0(a5)
 850:	855a                	mv	a0,s6
 852:	d1bff0ef          	jal	56c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 856:	0992                	slli	s3,s3,0x4
 858:	397d                	addiw	s2,s2,-1
 85a:	fe0916e3          	bnez	s2,846 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 85e:	8bea                	mv	s7,s10
      state = 0;
 860:	4981                	li	s3,0
 862:	6d02                	ld	s10,0(sp)
 864:	bd21                	j	67c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 866:	008b8993          	addi	s3,s7,8
 86a:	000bb903          	ld	s2,0(s7)
 86e:	00090f63          	beqz	s2,88c <vprintf+0x25a>
        for(; *s; s++)
 872:	00094583          	lbu	a1,0(s2)
 876:	c195                	beqz	a1,89a <vprintf+0x268>
          putc(fd, *s);
 878:	855a                	mv	a0,s6
 87a:	cf3ff0ef          	jal	56c <putc>
        for(; *s; s++)
 87e:	0905                	addi	s2,s2,1
 880:	00094583          	lbu	a1,0(s2)
 884:	f9f5                	bnez	a1,878 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 886:	8bce                	mv	s7,s3
      state = 0;
 888:	4981                	li	s3,0
 88a:	bbcd                	j	67c <vprintf+0x4a>
          s = "(null)";
 88c:	00000917          	auipc	s2,0x0
 890:	27490913          	addi	s2,s2,628 # b00 <malloc+0x168>
        for(; *s; s++)
 894:	02800593          	li	a1,40
 898:	b7c5                	j	878 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 89a:	8bce                	mv	s7,s3
      state = 0;
 89c:	4981                	li	s3,0
 89e:	bbf9                	j	67c <vprintf+0x4a>
 8a0:	64a6                	ld	s1,72(sp)
 8a2:	79e2                	ld	s3,56(sp)
 8a4:	7a42                	ld	s4,48(sp)
 8a6:	7aa2                	ld	s5,40(sp)
 8a8:	7b02                	ld	s6,32(sp)
 8aa:	6be2                	ld	s7,24(sp)
 8ac:	6c42                	ld	s8,16(sp)
 8ae:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8b0:	60e6                	ld	ra,88(sp)
 8b2:	6446                	ld	s0,80(sp)
 8b4:	6906                	ld	s2,64(sp)
 8b6:	6125                	addi	sp,sp,96
 8b8:	8082                	ret

00000000000008ba <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8ba:	715d                	addi	sp,sp,-80
 8bc:	ec06                	sd	ra,24(sp)
 8be:	e822                	sd	s0,16(sp)
 8c0:	1000                	addi	s0,sp,32
 8c2:	e010                	sd	a2,0(s0)
 8c4:	e414                	sd	a3,8(s0)
 8c6:	e818                	sd	a4,16(s0)
 8c8:	ec1c                	sd	a5,24(s0)
 8ca:	03043023          	sd	a6,32(s0)
 8ce:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8d2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8d6:	8622                	mv	a2,s0
 8d8:	d5bff0ef          	jal	632 <vprintf>
}
 8dc:	60e2                	ld	ra,24(sp)
 8de:	6442                	ld	s0,16(sp)
 8e0:	6161                	addi	sp,sp,80
 8e2:	8082                	ret

00000000000008e4 <printf>:

void
printf(const char *fmt, ...)
{
 8e4:	711d                	addi	sp,sp,-96
 8e6:	ec06                	sd	ra,24(sp)
 8e8:	e822                	sd	s0,16(sp)
 8ea:	1000                	addi	s0,sp,32
 8ec:	e40c                	sd	a1,8(s0)
 8ee:	e810                	sd	a2,16(s0)
 8f0:	ec14                	sd	a3,24(s0)
 8f2:	f018                	sd	a4,32(s0)
 8f4:	f41c                	sd	a5,40(s0)
 8f6:	03043823          	sd	a6,48(s0)
 8fa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8fe:	00840613          	addi	a2,s0,8
 902:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 906:	85aa                	mv	a1,a0
 908:	4505                	li	a0,1
 90a:	d29ff0ef          	jal	632 <vprintf>
}
 90e:	60e2                	ld	ra,24(sp)
 910:	6442                	ld	s0,16(sp)
 912:	6125                	addi	sp,sp,96
 914:	8082                	ret

0000000000000916 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 916:	1141                	addi	sp,sp,-16
 918:	e422                	sd	s0,8(sp)
 91a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 91c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 920:	00000797          	auipc	a5,0x0
 924:	6e07b783          	ld	a5,1760(a5) # 1000 <freep>
 928:	a02d                	j	952 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 92a:	4618                	lw	a4,8(a2)
 92c:	9f2d                	addw	a4,a4,a1
 92e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 932:	6398                	ld	a4,0(a5)
 934:	6310                	ld	a2,0(a4)
 936:	a83d                	j	974 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 938:	ff852703          	lw	a4,-8(a0)
 93c:	9f31                	addw	a4,a4,a2
 93e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 940:	ff053683          	ld	a3,-16(a0)
 944:	a091                	j	988 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 946:	6398                	ld	a4,0(a5)
 948:	00e7e463          	bltu	a5,a4,950 <free+0x3a>
 94c:	00e6ea63          	bltu	a3,a4,960 <free+0x4a>
{
 950:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 952:	fed7fae3          	bgeu	a5,a3,946 <free+0x30>
 956:	6398                	ld	a4,0(a5)
 958:	00e6e463          	bltu	a3,a4,960 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 95c:	fee7eae3          	bltu	a5,a4,950 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 960:	ff852583          	lw	a1,-8(a0)
 964:	6390                	ld	a2,0(a5)
 966:	02059813          	slli	a6,a1,0x20
 96a:	01c85713          	srli	a4,a6,0x1c
 96e:	9736                	add	a4,a4,a3
 970:	fae60de3          	beq	a2,a4,92a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 974:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 978:	4790                	lw	a2,8(a5)
 97a:	02061593          	slli	a1,a2,0x20
 97e:	01c5d713          	srli	a4,a1,0x1c
 982:	973e                	add	a4,a4,a5
 984:	fae68ae3          	beq	a3,a4,938 <free+0x22>
    p->s.ptr = bp->s.ptr;
 988:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 98a:	00000717          	auipc	a4,0x0
 98e:	66f73b23          	sd	a5,1654(a4) # 1000 <freep>
}
 992:	6422                	ld	s0,8(sp)
 994:	0141                	addi	sp,sp,16
 996:	8082                	ret

0000000000000998 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 998:	7139                	addi	sp,sp,-64
 99a:	fc06                	sd	ra,56(sp)
 99c:	f822                	sd	s0,48(sp)
 99e:	f426                	sd	s1,40(sp)
 9a0:	ec4e                	sd	s3,24(sp)
 9a2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9a4:	02051493          	slli	s1,a0,0x20
 9a8:	9081                	srli	s1,s1,0x20
 9aa:	04bd                	addi	s1,s1,15
 9ac:	8091                	srli	s1,s1,0x4
 9ae:	0014899b          	addiw	s3,s1,1
 9b2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9b4:	00000517          	auipc	a0,0x0
 9b8:	64c53503          	ld	a0,1612(a0) # 1000 <freep>
 9bc:	c915                	beqz	a0,9f0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9c0:	4798                	lw	a4,8(a5)
 9c2:	08977a63          	bgeu	a4,s1,a56 <malloc+0xbe>
 9c6:	f04a                	sd	s2,32(sp)
 9c8:	e852                	sd	s4,16(sp)
 9ca:	e456                	sd	s5,8(sp)
 9cc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9ce:	8a4e                	mv	s4,s3
 9d0:	0009871b          	sext.w	a4,s3
 9d4:	6685                	lui	a3,0x1
 9d6:	00d77363          	bgeu	a4,a3,9dc <malloc+0x44>
 9da:	6a05                	lui	s4,0x1
 9dc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9e0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9e4:	00000917          	auipc	s2,0x0
 9e8:	61c90913          	addi	s2,s2,1564 # 1000 <freep>
  if(p == (char*)-1)
 9ec:	5afd                	li	s5,-1
 9ee:	a081                	j	a2e <malloc+0x96>
 9f0:	f04a                	sd	s2,32(sp)
 9f2:	e852                	sd	s4,16(sp)
 9f4:	e456                	sd	s5,8(sp)
 9f6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9f8:	00001797          	auipc	a5,0x1
 9fc:	81878793          	addi	a5,a5,-2024 # 1210 <base>
 a00:	00000717          	auipc	a4,0x0
 a04:	60f73023          	sd	a5,1536(a4) # 1000 <freep>
 a08:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a0a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a0e:	b7c1                	j	9ce <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a10:	6398                	ld	a4,0(a5)
 a12:	e118                	sd	a4,0(a0)
 a14:	a8a9                	j	a6e <malloc+0xd6>
  hp->s.size = nu;
 a16:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a1a:	0541                	addi	a0,a0,16
 a1c:	efbff0ef          	jal	916 <free>
  return freep;
 a20:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a24:	c12d                	beqz	a0,a86 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a26:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a28:	4798                	lw	a4,8(a5)
 a2a:	02977263          	bgeu	a4,s1,a4e <malloc+0xb6>
    if(p == freep)
 a2e:	00093703          	ld	a4,0(s2)
 a32:	853e                	mv	a0,a5
 a34:	fef719e3          	bne	a4,a5,a26 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a38:	8552                	mv	a0,s4
 a3a:	ad3ff0ef          	jal	50c <sbrk>
  if(p == (char*)-1)
 a3e:	fd551ce3          	bne	a0,s5,a16 <malloc+0x7e>
        return 0;
 a42:	4501                	li	a0,0
 a44:	7902                	ld	s2,32(sp)
 a46:	6a42                	ld	s4,16(sp)
 a48:	6aa2                	ld	s5,8(sp)
 a4a:	6b02                	ld	s6,0(sp)
 a4c:	a03d                	j	a7a <malloc+0xe2>
 a4e:	7902                	ld	s2,32(sp)
 a50:	6a42                	ld	s4,16(sp)
 a52:	6aa2                	ld	s5,8(sp)
 a54:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a56:	fae48de3          	beq	s1,a4,a10 <malloc+0x78>
        p->s.size -= nunits;
 a5a:	4137073b          	subw	a4,a4,s3
 a5e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a60:	02071693          	slli	a3,a4,0x20
 a64:	01c6d713          	srli	a4,a3,0x1c
 a68:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a6a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a6e:	00000717          	auipc	a4,0x0
 a72:	58a73923          	sd	a0,1426(a4) # 1000 <freep>
      return (void*)(p + 1);
 a76:	01078513          	addi	a0,a5,16
  }
}
 a7a:	70e2                	ld	ra,56(sp)
 a7c:	7442                	ld	s0,48(sp)
 a7e:	74a2                	ld	s1,40(sp)
 a80:	69e2                	ld	s3,24(sp)
 a82:	6121                	addi	sp,sp,64
 a84:	8082                	ret
 a86:	7902                	ld	s2,32(sp)
 a88:	6a42                	ld	s4,16(sp)
 a8a:	6aa2                	ld	s5,8(sp)
 a8c:	6b02                	ld	s6,0(sp)
 a8e:	b7f5                	j	a7a <malloc+0xe2>
