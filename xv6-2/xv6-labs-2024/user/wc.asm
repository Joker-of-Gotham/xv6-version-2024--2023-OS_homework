
user/_wc：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4d01                	li	s10,0
  2a:	4c81                	li	s9,0
  2c:	4c01                	li	s8,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00002d97          	auipc	s11,0x2
  32:	fe2d8d93          	addi	s11,s11,-30 # 2010 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	ad8a0a13          	addi	s4,s4,-1320 # b10 <malloc+0x106>
        inword = 0;
  40:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a035                	j	6e <wc+0x6e>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	1f2000ef          	jal	238 <strchr>
  4a:	c919                	beqz	a0,60 <wc+0x60>
        inword = 0;
  4c:	895e                	mv	s2,s7
    for(i=0; i<n; i++){
  4e:	0485                	addi	s1,s1,1
  50:	01348d63          	beq	s1,s3,6a <wc+0x6a>
      if(buf[i] == '\n')
  54:	0004c583          	lbu	a1,0(s1)
  58:	ff5596e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  5c:	2c05                	addiw	s8,s8,1
  5e:	b7dd                	j	44 <wc+0x44>
      else if(!inword){
  60:	fe0917e3          	bnez	s2,4e <wc+0x4e>
        w++;
  64:	2c85                	addiw	s9,s9,1
        inword = 1;
  66:	4905                	li	s2,1
  68:	b7dd                	j	4e <wc+0x4e>
  6a:	01ab0d3b          	addw	s10,s6,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  6e:	20000613          	li	a2,512
  72:	85ee                	mv	a1,s11
  74:	f8843503          	ld	a0,-120(s0)
  78:	496000ef          	jal	50e <read>
  7c:	8b2a                	mv	s6,a0
  7e:	00a05963          	blez	a0,90 <wc+0x90>
    for(i=0; i<n; i++){
  82:	00002497          	auipc	s1,0x2
  86:	f8e48493          	addi	s1,s1,-114 # 2010 <buf>
  8a:	009509b3          	add	s3,a0,s1
  8e:	b7d9                	j	54 <wc+0x54>
      }
    }
  }
  if(n < 0){
  90:	02054c63          	bltz	a0,c8 <wc+0xc8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  94:	f8043703          	ld	a4,-128(s0)
  98:	86ea                	mv	a3,s10
  9a:	8666                	mv	a2,s9
  9c:	85e2                	mv	a1,s8
  9e:	00001517          	auipc	a0,0x1
  a2:	a9250513          	addi	a0,a0,-1390 # b30 <malloc+0x126>
  a6:	0b1000ef          	jal	956 <printf>
}
  aa:	70e6                	ld	ra,120(sp)
  ac:	7446                	ld	s0,112(sp)
  ae:	74a6                	ld	s1,104(sp)
  b0:	7906                	ld	s2,96(sp)
  b2:	69e6                	ld	s3,88(sp)
  b4:	6a46                	ld	s4,80(sp)
  b6:	6aa6                	ld	s5,72(sp)
  b8:	6b06                	ld	s6,64(sp)
  ba:	7be2                	ld	s7,56(sp)
  bc:	7c42                	ld	s8,48(sp)
  be:	7ca2                	ld	s9,40(sp)
  c0:	7d02                	ld	s10,32(sp)
  c2:	6de2                	ld	s11,24(sp)
  c4:	6109                	addi	sp,sp,128
  c6:	8082                	ret
    printf("wc: read error\n");
  c8:	00001517          	auipc	a0,0x1
  cc:	a5850513          	addi	a0,a0,-1448 # b20 <malloc+0x116>
  d0:	087000ef          	jal	956 <printf>
    exit(1);
  d4:	4505                	li	a0,1
  d6:	420000ef          	jal	4f6 <exit>

00000000000000da <main>:

int
main(int argc, char *argv[])
{
  da:	7179                	addi	sp,sp,-48
  dc:	f406                	sd	ra,40(sp)
  de:	f022                	sd	s0,32(sp)
  e0:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  e2:	4785                	li	a5,1
  e4:	04a7d463          	bge	a5,a0,12c <main+0x52>
  e8:	ec26                	sd	s1,24(sp)
  ea:	e84a                	sd	s2,16(sp)
  ec:	e44e                	sd	s3,8(sp)
  ee:	00858913          	addi	s2,a1,8
  f2:	ffe5099b          	addiw	s3,a0,-2
  f6:	02099793          	slli	a5,s3,0x20
  fa:	01d7d993          	srli	s3,a5,0x1d
  fe:	05c1                	addi	a1,a1,16
 100:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 102:	4581                	li	a1,0
 104:	00093503          	ld	a0,0(s2)
 108:	42e000ef          	jal	536 <open>
 10c:	84aa                	mv	s1,a0
 10e:	02054c63          	bltz	a0,146 <main+0x6c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 112:	00093583          	ld	a1,0(s2)
 116:	eebff0ef          	jal	0 <wc>
    close(fd);
 11a:	8526                	mv	a0,s1
 11c:	402000ef          	jal	51e <close>
  for(i = 1; i < argc; i++){
 120:	0921                	addi	s2,s2,8
 122:	ff3910e3          	bne	s2,s3,102 <main+0x28>
  }
  exit(0);
 126:	4501                	li	a0,0
 128:	3ce000ef          	jal	4f6 <exit>
 12c:	ec26                	sd	s1,24(sp)
 12e:	e84a                	sd	s2,16(sp)
 130:	e44e                	sd	s3,8(sp)
    wc(0, "");
 132:	00001597          	auipc	a1,0x1
 136:	9e658593          	addi	a1,a1,-1562 # b18 <malloc+0x10e>
 13a:	4501                	li	a0,0
 13c:	ec5ff0ef          	jal	0 <wc>
    exit(0);
 140:	4501                	li	a0,0
 142:	3b4000ef          	jal	4f6 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 146:	00093583          	ld	a1,0(s2)
 14a:	00001517          	auipc	a0,0x1
 14e:	9f650513          	addi	a0,a0,-1546 # b40 <malloc+0x136>
 152:	005000ef          	jal	956 <printf>
      exit(1);
 156:	4505                	li	a0,1
 158:	39e000ef          	jal	4f6 <exit>

000000000000015c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
  extern int main();
  main();
 164:	f77ff0ef          	jal	da <main>
  exit(0);
 168:	4501                	li	a0,0
 16a:	38c000ef          	jal	4f6 <exit>

000000000000016e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 174:	87aa                	mv	a5,a0
 176:	0585                	addi	a1,a1,1
 178:	0785                	addi	a5,a5,1
 17a:	fff5c703          	lbu	a4,-1(a1)
 17e:	fee78fa3          	sb	a4,-1(a5)
 182:	fb75                	bnez	a4,176 <strcpy+0x8>
    ;
  return os;
}
 184:	6422                	ld	s0,8(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret

000000000000018a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 190:	00054783          	lbu	a5,0(a0)
 194:	cb91                	beqz	a5,1a8 <strcmp+0x1e>
 196:	0005c703          	lbu	a4,0(a1)
 19a:	00f71763          	bne	a4,a5,1a8 <strcmp+0x1e>
    p++, q++;
 19e:	0505                	addi	a0,a0,1
 1a0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	fbe5                	bnez	a5,196 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1a8:	0005c503          	lbu	a0,0(a1)
}
 1ac:	40a7853b          	subw	a0,a5,a0
 1b0:	6422                	ld	s0,8(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret

00000000000001b6 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q) {
 1bc:	ce11                	beqz	a2,1d8 <strncmp+0x22>
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	cf89                	beqz	a5,1dc <strncmp+0x26>
 1c4:	0005c703          	lbu	a4,0(a1)
 1c8:	00f71a63          	bne	a4,a5,1dc <strncmp+0x26>
    n--;
 1cc:	367d                	addiw	a2,a2,-1
    p++;
 1ce:	0505                	addi	a0,a0,1
    q++;
 1d0:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q) {
 1d2:	f675                	bnez	a2,1be <strncmp+0x8>
  }
  if(n == 0)
    return 0;
 1d4:	4501                	li	a0,0
 1d6:	a801                	j	1e6 <strncmp+0x30>
 1d8:	4501                	li	a0,0
 1da:	a031                	j	1e6 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
 1dc:	00054503          	lbu	a0,0(a0)
 1e0:	0005c783          	lbu	a5,0(a1)
 1e4:	9d1d                	subw	a0,a0,a5
}
 1e6:	6422                	ld	s0,8(sp)
 1e8:	0141                	addi	sp,sp,16
 1ea:	8082                	ret

00000000000001ec <strlen>:

uint
strlen(const char *s)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e422                	sd	s0,8(sp)
 1f0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1f2:	00054783          	lbu	a5,0(a0)
 1f6:	cf91                	beqz	a5,212 <strlen+0x26>
 1f8:	0505                	addi	a0,a0,1
 1fa:	87aa                	mv	a5,a0
 1fc:	86be                	mv	a3,a5
 1fe:	0785                	addi	a5,a5,1
 200:	fff7c703          	lbu	a4,-1(a5)
 204:	ff65                	bnez	a4,1fc <strlen+0x10>
 206:	40a6853b          	subw	a0,a3,a0
 20a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret
  for(n = 0; s[n]; n++)
 212:	4501                	li	a0,0
 214:	bfe5                	j	20c <strlen+0x20>

0000000000000216 <memset>:

void*
memset(void *dst, int c, uint n)
{
 216:	1141                	addi	sp,sp,-16
 218:	e422                	sd	s0,8(sp)
 21a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 21c:	ca19                	beqz	a2,232 <memset+0x1c>
 21e:	87aa                	mv	a5,a0
 220:	1602                	slli	a2,a2,0x20
 222:	9201                	srli	a2,a2,0x20
 224:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 228:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 22c:	0785                	addi	a5,a5,1
 22e:	fee79de3          	bne	a5,a4,228 <memset+0x12>
  }
  return dst;
}
 232:	6422                	ld	s0,8(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret

0000000000000238 <strchr>:

char*
strchr(const char *s, char c)
{
 238:	1141                	addi	sp,sp,-16
 23a:	e422                	sd	s0,8(sp)
 23c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 23e:	00054783          	lbu	a5,0(a0)
 242:	cb99                	beqz	a5,258 <strchr+0x20>
    if(*s == c)
 244:	00f58763          	beq	a1,a5,252 <strchr+0x1a>
  for(; *s; s++)
 248:	0505                	addi	a0,a0,1
 24a:	00054783          	lbu	a5,0(a0)
 24e:	fbfd                	bnez	a5,244 <strchr+0xc>
      return (char*)s;
  return 0;
 250:	4501                	li	a0,0
}
 252:	6422                	ld	s0,8(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret
  return 0;
 258:	4501                	li	a0,0
 25a:	bfe5                	j	252 <strchr+0x1a>

000000000000025c <gets>:

char*
gets(char *buf, int max)
{
 25c:	711d                	addi	sp,sp,-96
 25e:	ec86                	sd	ra,88(sp)
 260:	e8a2                	sd	s0,80(sp)
 262:	e4a6                	sd	s1,72(sp)
 264:	e0ca                	sd	s2,64(sp)
 266:	fc4e                	sd	s3,56(sp)
 268:	f852                	sd	s4,48(sp)
 26a:	f456                	sd	s5,40(sp)
 26c:	f05a                	sd	s6,32(sp)
 26e:	ec5e                	sd	s7,24(sp)
 270:	1080                	addi	s0,sp,96
 272:	8baa                	mv	s7,a0
 274:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 276:	892a                	mv	s2,a0
 278:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 27a:	4aa9                	li	s5,10
 27c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 27e:	89a6                	mv	s3,s1
 280:	2485                	addiw	s1,s1,1
 282:	0344d663          	bge	s1,s4,2ae <gets+0x52>
    cc = read(0, &c, 1);
 286:	4605                	li	a2,1
 288:	faf40593          	addi	a1,s0,-81
 28c:	4501                	li	a0,0
 28e:	280000ef          	jal	50e <read>
    if(cc < 1)
 292:	00a05e63          	blez	a0,2ae <gets+0x52>
    buf[i++] = c;
 296:	faf44783          	lbu	a5,-81(s0)
 29a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 29e:	01578763          	beq	a5,s5,2ac <gets+0x50>
 2a2:	0905                	addi	s2,s2,1
 2a4:	fd679de3          	bne	a5,s6,27e <gets+0x22>
    buf[i++] = c;
 2a8:	89a6                	mv	s3,s1
 2aa:	a011                	j	2ae <gets+0x52>
 2ac:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2ae:	99de                	add	s3,s3,s7
 2b0:	00098023          	sb	zero,0(s3)
  return buf;
}
 2b4:	855e                	mv	a0,s7
 2b6:	60e6                	ld	ra,88(sp)
 2b8:	6446                	ld	s0,80(sp)
 2ba:	64a6                	ld	s1,72(sp)
 2bc:	6906                	ld	s2,64(sp)
 2be:	79e2                	ld	s3,56(sp)
 2c0:	7a42                	ld	s4,48(sp)
 2c2:	7aa2                	ld	s5,40(sp)
 2c4:	7b02                	ld	s6,32(sp)
 2c6:	6be2                	ld	s7,24(sp)
 2c8:	6125                	addi	sp,sp,96
 2ca:	8082                	ret

00000000000002cc <stat>:

int
stat(const char *n, struct stat *st)
{
 2cc:	1101                	addi	sp,sp,-32
 2ce:	ec06                	sd	ra,24(sp)
 2d0:	e822                	sd	s0,16(sp)
 2d2:	e04a                	sd	s2,0(sp)
 2d4:	1000                	addi	s0,sp,32
 2d6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d8:	4581                	li	a1,0
 2da:	25c000ef          	jal	536 <open>
  if(fd < 0)
 2de:	02054263          	bltz	a0,302 <stat+0x36>
 2e2:	e426                	sd	s1,8(sp)
 2e4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2e6:	85ca                	mv	a1,s2
 2e8:	266000ef          	jal	54e <fstat>
 2ec:	892a                	mv	s2,a0
  close(fd);
 2ee:	8526                	mv	a0,s1
 2f0:	22e000ef          	jal	51e <close>
  return r;
 2f4:	64a2                	ld	s1,8(sp)
}
 2f6:	854a                	mv	a0,s2
 2f8:	60e2                	ld	ra,24(sp)
 2fa:	6442                	ld	s0,16(sp)
 2fc:	6902                	ld	s2,0(sp)
 2fe:	6105                	addi	sp,sp,32
 300:	8082                	ret
    return -1;
 302:	597d                	li	s2,-1
 304:	bfcd                	j	2f6 <stat+0x2a>

0000000000000306 <atoi>:

int
atoi(const char *s)
{
 306:	1141                	addi	sp,sp,-16
 308:	e422                	sd	s0,8(sp)
 30a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 30c:	00054683          	lbu	a3,0(a0)
 310:	fd06879b          	addiw	a5,a3,-48
 314:	0ff7f793          	zext.b	a5,a5
 318:	4625                	li	a2,9
 31a:	02f66863          	bltu	a2,a5,34a <atoi+0x44>
 31e:	872a                	mv	a4,a0
  n = 0;
 320:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 322:	0705                	addi	a4,a4,1
 324:	0025179b          	slliw	a5,a0,0x2
 328:	9fa9                	addw	a5,a5,a0
 32a:	0017979b          	slliw	a5,a5,0x1
 32e:	9fb5                	addw	a5,a5,a3
 330:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 334:	00074683          	lbu	a3,0(a4)
 338:	fd06879b          	addiw	a5,a3,-48
 33c:	0ff7f793          	zext.b	a5,a5
 340:	fef671e3          	bgeu	a2,a5,322 <atoi+0x1c>
  return n;
}
 344:	6422                	ld	s0,8(sp)
 346:	0141                	addi	sp,sp,16
 348:	8082                	ret
  n = 0;
 34a:	4501                	li	a0,0
 34c:	bfe5                	j	344 <atoi+0x3e>

000000000000034e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 34e:	1141                	addi	sp,sp,-16
 350:	e422                	sd	s0,8(sp)
 352:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 354:	02b57463          	bgeu	a0,a1,37c <memmove+0x2e>
    while(n-- > 0)
 358:	00c05f63          	blez	a2,376 <memmove+0x28>
 35c:	1602                	slli	a2,a2,0x20
 35e:	9201                	srli	a2,a2,0x20
 360:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 364:	872a                	mv	a4,a0
      *dst++ = *src++;
 366:	0585                	addi	a1,a1,1
 368:	0705                	addi	a4,a4,1
 36a:	fff5c683          	lbu	a3,-1(a1)
 36e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 372:	fef71ae3          	bne	a4,a5,366 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 376:	6422                	ld	s0,8(sp)
 378:	0141                	addi	sp,sp,16
 37a:	8082                	ret
    dst += n;
 37c:	00c50733          	add	a4,a0,a2
    src += n;
 380:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 382:	fec05ae3          	blez	a2,376 <memmove+0x28>
 386:	fff6079b          	addiw	a5,a2,-1
 38a:	1782                	slli	a5,a5,0x20
 38c:	9381                	srli	a5,a5,0x20
 38e:	fff7c793          	not	a5,a5
 392:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 394:	15fd                	addi	a1,a1,-1
 396:	177d                	addi	a4,a4,-1
 398:	0005c683          	lbu	a3,0(a1)
 39c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3a0:	fee79ae3          	bne	a5,a4,394 <memmove+0x46>
 3a4:	bfc9                	j	376 <memmove+0x28>

00000000000003a6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3a6:	1141                	addi	sp,sp,-16
 3a8:	e422                	sd	s0,8(sp)
 3aa:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3ac:	ca05                	beqz	a2,3dc <memcmp+0x36>
 3ae:	fff6069b          	addiw	a3,a2,-1
 3b2:	1682                	slli	a3,a3,0x20
 3b4:	9281                	srli	a3,a3,0x20
 3b6:	0685                	addi	a3,a3,1
 3b8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3ba:	00054783          	lbu	a5,0(a0)
 3be:	0005c703          	lbu	a4,0(a1)
 3c2:	00e79863          	bne	a5,a4,3d2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3c6:	0505                	addi	a0,a0,1
    p2++;
 3c8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3ca:	fed518e3          	bne	a0,a3,3ba <memcmp+0x14>
  }
  return 0;
 3ce:	4501                	li	a0,0
 3d0:	a019                	j	3d6 <memcmp+0x30>
      return *p1 - *p2;
 3d2:	40e7853b          	subw	a0,a5,a4
}
 3d6:	6422                	ld	s0,8(sp)
 3d8:	0141                	addi	sp,sp,16
 3da:	8082                	ret
  return 0;
 3dc:	4501                	li	a0,0
 3de:	bfe5                	j	3d6 <memcmp+0x30>

00000000000003e0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3e0:	1141                	addi	sp,sp,-16
 3e2:	e406                	sd	ra,8(sp)
 3e4:	e022                	sd	s0,0(sp)
 3e6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3e8:	f67ff0ef          	jal	34e <memmove>
}
 3ec:	60a2                	ld	ra,8(sp)
 3ee:	6402                	ld	s0,0(sp)
 3f0:	0141                	addi	sp,sp,16
 3f2:	8082                	ret

00000000000003f4 <simplesort>:

void
simplesort(void *base, uint nmemb, uint size, int (*compar)(const void *, const void *))
{
 3f4:	7119                	addi	sp,sp,-128
 3f6:	fc86                	sd	ra,120(sp)
 3f8:	f8a2                	sd	s0,112(sp)
 3fa:	0100                	addi	s0,sp,128
 3fc:	f8b43423          	sd	a1,-120(s0)
  char *arr = (char *)base; // Treat array as char array for byte-level manipulation
  char *temp;               // Temporary storage for an element

  if (nmemb <= 1 || size == 0) {
 400:	4785                	li	a5,1
 402:	00b7fc63          	bgeu	a5,a1,41a <simplesort+0x26>
 406:	e8d2                	sd	s4,80(sp)
 408:	e4d6                	sd	s5,72(sp)
 40a:	f466                	sd	s9,40(sp)
 40c:	8aaa                	mv	s5,a0
 40e:	8a32                	mv	s4,a2
 410:	8cb6                	mv	s9,a3
 412:	ea01                	bnez	a2,422 <simplesort+0x2e>
 414:	6a46                	ld	s4,80(sp)
 416:	6aa6                	ld	s5,72(sp)
 418:	7ca2                	ld	s9,40(sp)
    // Place temp at its correct position
    memmove(arr + j * size, temp, size);
  }

  free(temp); // Free temporary space
 41a:	70e6                	ld	ra,120(sp)
 41c:	7446                	ld	s0,112(sp)
 41e:	6109                	addi	sp,sp,128
 420:	8082                	ret
 422:	fc5e                	sd	s7,56(sp)
 424:	f862                	sd	s8,48(sp)
 426:	f06a                	sd	s10,32(sp)
 428:	ec6e                	sd	s11,24(sp)
  temp = malloc(size); // Allocate temporary space for one element
 42a:	8532                	mv	a0,a2
 42c:	5de000ef          	jal	a0a <malloc>
 430:	8baa                	mv	s7,a0
  if (temp == 0) {
 432:	4d81                	li	s11,0
  for (uint i = 1; i < nmemb; i++) {
 434:	4d05                	li	s10,1
    memmove(temp, arr + i * size, size);
 436:	000a0c1b          	sext.w	s8,s4
  if (temp == 0) {
 43a:	c511                	beqz	a0,446 <simplesort+0x52>
 43c:	f4a6                	sd	s1,104(sp)
 43e:	f0ca                	sd	s2,96(sp)
 440:	ecce                	sd	s3,88(sp)
 442:	e0da                	sd	s6,64(sp)
 444:	a82d                	j	47e <simplesort+0x8a>
    printf("simplesort: malloc failed, cannot sort\n");
 446:	00000517          	auipc	a0,0x0
 44a:	71250513          	addi	a0,a0,1810 # b58 <malloc+0x14e>
 44e:	508000ef          	jal	956 <printf>
    return;
 452:	6a46                	ld	s4,80(sp)
 454:	6aa6                	ld	s5,72(sp)
 456:	7be2                	ld	s7,56(sp)
 458:	7c42                	ld	s8,48(sp)
 45a:	7ca2                	ld	s9,40(sp)
 45c:	7d02                	ld	s10,32(sp)
 45e:	6de2                	ld	s11,24(sp)
 460:	bf6d                	j	41a <simplesort+0x26>
    memmove(arr + j * size, temp, size);
 462:	036a053b          	mulw	a0,s4,s6
 466:	1502                	slli	a0,a0,0x20
 468:	9101                	srli	a0,a0,0x20
 46a:	8662                	mv	a2,s8
 46c:	85de                	mv	a1,s7
 46e:	9556                	add	a0,a0,s5
 470:	edfff0ef          	jal	34e <memmove>
  for (uint i = 1; i < nmemb; i++) {
 474:	2d05                	addiw	s10,s10,1
 476:	f8843783          	ld	a5,-120(s0)
 47a:	05a78b63          	beq	a5,s10,4d0 <simplesort+0xdc>
    memmove(temp, arr + i * size, size);
 47e:	000d899b          	sext.w	s3,s11
 482:	01ba05bb          	addw	a1,s4,s11
 486:	00058d9b          	sext.w	s11,a1
 48a:	1582                	slli	a1,a1,0x20
 48c:	9181                	srli	a1,a1,0x20
 48e:	8662                	mv	a2,s8
 490:	95d6                	add	a1,a1,s5
 492:	855e                	mv	a0,s7
 494:	ebbff0ef          	jal	34e <memmove>
    uint j = i;
 498:	896a                	mv	s2,s10
 49a:	00090b1b          	sext.w	s6,s2
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 49e:	397d                	addiw	s2,s2,-1
 4a0:	02099493          	slli	s1,s3,0x20
 4a4:	9081                	srli	s1,s1,0x20
 4a6:	94d6                	add	s1,s1,s5
 4a8:	85de                	mv	a1,s7
 4aa:	8526                	mv	a0,s1
 4ac:	9c82                	jalr	s9
 4ae:	faa05ae3          	blez	a0,462 <simplesort+0x6e>
      memmove(arr + j * size, arr + (j - 1) * size, size); // Shift element
 4b2:	0149853b          	addw	a0,s3,s4
 4b6:	1502                	slli	a0,a0,0x20
 4b8:	9101                	srli	a0,a0,0x20
 4ba:	8662                	mv	a2,s8
 4bc:	85a6                	mv	a1,s1
 4be:	9556                	add	a0,a0,s5
 4c0:	e8fff0ef          	jal	34e <memmove>
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 4c4:	414989bb          	subw	s3,s3,s4
 4c8:	fc0919e3          	bnez	s2,49a <simplesort+0xa6>
 4cc:	8b4a                	mv	s6,s2
 4ce:	bf51                	j	462 <simplesort+0x6e>
  free(temp); // Free temporary space
 4d0:	855e                	mv	a0,s7
 4d2:	4b6000ef          	jal	988 <free>
 4d6:	74a6                	ld	s1,104(sp)
 4d8:	7906                	ld	s2,96(sp)
 4da:	69e6                	ld	s3,88(sp)
 4dc:	6a46                	ld	s4,80(sp)
 4de:	6aa6                	ld	s5,72(sp)
 4e0:	6b06                	ld	s6,64(sp)
 4e2:	7be2                	ld	s7,56(sp)
 4e4:	7c42                	ld	s8,48(sp)
 4e6:	7ca2                	ld	s9,40(sp)
 4e8:	7d02                	ld	s10,32(sp)
 4ea:	6de2                	ld	s11,24(sp)
 4ec:	b73d                	j	41a <simplesort+0x26>

00000000000004ee <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ee:	4885                	li	a7,1
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4f6:	4889                	li	a7,2
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <wait>:
.global wait
wait:
 li a7, SYS_wait
 4fe:	488d                	li	a7,3
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 506:	4891                	li	a7,4
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <read>:
.global read
read:
 li a7, SYS_read
 50e:	4895                	li	a7,5
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <write>:
.global write
write:
 li a7, SYS_write
 516:	48c1                	li	a7,16
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <close>:
.global close
close:
 li a7, SYS_close
 51e:	48d5                	li	a7,21
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <kill>:
.global kill
kill:
 li a7, SYS_kill
 526:	4899                	li	a7,6
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <exec>:
.global exec
exec:
 li a7, SYS_exec
 52e:	489d                	li	a7,7
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <open>:
.global open
open:
 li a7, SYS_open
 536:	48bd                	li	a7,15
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 53e:	48c5                	li	a7,17
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 546:	48c9                	li	a7,18
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 54e:	48a1                	li	a7,8
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <link>:
.global link
link:
 li a7, SYS_link
 556:	48cd                	li	a7,19
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 55e:	48d1                	li	a7,20
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 566:	48a5                	li	a7,9
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <dup>:
.global dup
dup:
 li a7, SYS_dup
 56e:	48a9                	li	a7,10
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 576:	48ad                	li	a7,11
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 57e:	48b1                	li	a7,12
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 586:	48b5                	li	a7,13
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 58e:	48b9                	li	a7,14
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 596:	48dd                	li	a7,23
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <statistics>:
.global statistics
statistics:
 li a7, SYS_statistics
 59e:	48e1                	li	a7,24
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <reset_stats>:
.global reset_stats
reset_stats:
 li a7, SYS_reset_stats
 5a6:	48e5                	li	a7,25
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <resetlockstats>:
.global resetlockstats
resetlockstats:
 li a7, SYS_resetlockstats
 5ae:	48e9                	li	a7,26
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <getlockstats>:
.global getlockstats
getlockstats:
 li a7, SYS_getlockstats
 5b6:	48ed                	li	a7,27
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <trace>:
.global trace
trace:
 li a7, SYS_trace
 5be:	48d9                	li	a7,22
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 5c6:	48f1                	li	a7,28
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <ugetpid>:
.global ugetpid
ugetpid:
 li a7, SYS_ugetpid
 5ce:	48f5                	li	a7,29
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 5d6:	48f9                	li	a7,30
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5de:	1101                	addi	sp,sp,-32
 5e0:	ec06                	sd	ra,24(sp)
 5e2:	e822                	sd	s0,16(sp)
 5e4:	1000                	addi	s0,sp,32
 5e6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5ea:	4605                	li	a2,1
 5ec:	fef40593          	addi	a1,s0,-17
 5f0:	f27ff0ef          	jal	516 <write>
}
 5f4:	60e2                	ld	ra,24(sp)
 5f6:	6442                	ld	s0,16(sp)
 5f8:	6105                	addi	sp,sp,32
 5fa:	8082                	ret

00000000000005fc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5fc:	7139                	addi	sp,sp,-64
 5fe:	fc06                	sd	ra,56(sp)
 600:	f822                	sd	s0,48(sp)
 602:	f426                	sd	s1,40(sp)
 604:	0080                	addi	s0,sp,64
 606:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 608:	c299                	beqz	a3,60e <printint+0x12>
 60a:	0805c963          	bltz	a1,69c <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 60e:	2581                	sext.w	a1,a1
  neg = 0;
 610:	4881                	li	a7,0
 612:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 616:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 618:	2601                	sext.w	a2,a2
 61a:	00000517          	auipc	a0,0x0
 61e:	56e50513          	addi	a0,a0,1390 # b88 <digits>
 622:	883a                	mv	a6,a4
 624:	2705                	addiw	a4,a4,1
 626:	02c5f7bb          	remuw	a5,a1,a2
 62a:	1782                	slli	a5,a5,0x20
 62c:	9381                	srli	a5,a5,0x20
 62e:	97aa                	add	a5,a5,a0
 630:	0007c783          	lbu	a5,0(a5)
 634:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 638:	0005879b          	sext.w	a5,a1
 63c:	02c5d5bb          	divuw	a1,a1,a2
 640:	0685                	addi	a3,a3,1
 642:	fec7f0e3          	bgeu	a5,a2,622 <printint+0x26>
  if(neg)
 646:	00088c63          	beqz	a7,65e <printint+0x62>
    buf[i++] = '-';
 64a:	fd070793          	addi	a5,a4,-48
 64e:	00878733          	add	a4,a5,s0
 652:	02d00793          	li	a5,45
 656:	fef70823          	sb	a5,-16(a4)
 65a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 65e:	02e05a63          	blez	a4,692 <printint+0x96>
 662:	f04a                	sd	s2,32(sp)
 664:	ec4e                	sd	s3,24(sp)
 666:	fc040793          	addi	a5,s0,-64
 66a:	00e78933          	add	s2,a5,a4
 66e:	fff78993          	addi	s3,a5,-1
 672:	99ba                	add	s3,s3,a4
 674:	377d                	addiw	a4,a4,-1
 676:	1702                	slli	a4,a4,0x20
 678:	9301                	srli	a4,a4,0x20
 67a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 67e:	fff94583          	lbu	a1,-1(s2)
 682:	8526                	mv	a0,s1
 684:	f5bff0ef          	jal	5de <putc>
  while(--i >= 0)
 688:	197d                	addi	s2,s2,-1
 68a:	ff391ae3          	bne	s2,s3,67e <printint+0x82>
 68e:	7902                	ld	s2,32(sp)
 690:	69e2                	ld	s3,24(sp)
}
 692:	70e2                	ld	ra,56(sp)
 694:	7442                	ld	s0,48(sp)
 696:	74a2                	ld	s1,40(sp)
 698:	6121                	addi	sp,sp,64
 69a:	8082                	ret
    x = -xx;
 69c:	40b005bb          	negw	a1,a1
    neg = 1;
 6a0:	4885                	li	a7,1
    x = -xx;
 6a2:	bf85                	j	612 <printint+0x16>

00000000000006a4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6a4:	711d                	addi	sp,sp,-96
 6a6:	ec86                	sd	ra,88(sp)
 6a8:	e8a2                	sd	s0,80(sp)
 6aa:	e0ca                	sd	s2,64(sp)
 6ac:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6ae:	0005c903          	lbu	s2,0(a1)
 6b2:	26090863          	beqz	s2,922 <vprintf+0x27e>
 6b6:	e4a6                	sd	s1,72(sp)
 6b8:	fc4e                	sd	s3,56(sp)
 6ba:	f852                	sd	s4,48(sp)
 6bc:	f456                	sd	s5,40(sp)
 6be:	f05a                	sd	s6,32(sp)
 6c0:	ec5e                	sd	s7,24(sp)
 6c2:	e862                	sd	s8,16(sp)
 6c4:	e466                	sd	s9,8(sp)
 6c6:	8b2a                	mv	s6,a0
 6c8:	8a2e                	mv	s4,a1
 6ca:	8bb2                	mv	s7,a2
  state = 0;
 6cc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6ce:	4481                	li	s1,0
 6d0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6d2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6d6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6da:	06c00c93          	li	s9,108
 6de:	a005                	j	6fe <vprintf+0x5a>
        putc(fd, c0);
 6e0:	85ca                	mv	a1,s2
 6e2:	855a                	mv	a0,s6
 6e4:	efbff0ef          	jal	5de <putc>
 6e8:	a019                	j	6ee <vprintf+0x4a>
    } else if(state == '%'){
 6ea:	03598263          	beq	s3,s5,70e <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 6ee:	2485                	addiw	s1,s1,1
 6f0:	8726                	mv	a4,s1
 6f2:	009a07b3          	add	a5,s4,s1
 6f6:	0007c903          	lbu	s2,0(a5)
 6fa:	20090c63          	beqz	s2,912 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 6fe:	0009079b          	sext.w	a5,s2
    if(state == 0){
 702:	fe0994e3          	bnez	s3,6ea <vprintf+0x46>
      if(c0 == '%'){
 706:	fd579de3          	bne	a5,s5,6e0 <vprintf+0x3c>
        state = '%';
 70a:	89be                	mv	s3,a5
 70c:	b7cd                	j	6ee <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 70e:	00ea06b3          	add	a3,s4,a4
 712:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 716:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 718:	c681                	beqz	a3,720 <vprintf+0x7c>
 71a:	9752                	add	a4,a4,s4
 71c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 720:	03878f63          	beq	a5,s8,75e <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 724:	05978963          	beq	a5,s9,776 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 728:	07500713          	li	a4,117
 72c:	0ee78363          	beq	a5,a4,812 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 730:	07800713          	li	a4,120
 734:	12e78563          	beq	a5,a4,85e <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 738:	07000713          	li	a4,112
 73c:	14e78a63          	beq	a5,a4,890 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 740:	07300713          	li	a4,115
 744:	18e78a63          	beq	a5,a4,8d8 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 748:	02500713          	li	a4,37
 74c:	04e79563          	bne	a5,a4,796 <vprintf+0xf2>
        putc(fd, '%');
 750:	02500593          	li	a1,37
 754:	855a                	mv	a0,s6
 756:	e89ff0ef          	jal	5de <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 75a:	4981                	li	s3,0
 75c:	bf49                	j	6ee <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 75e:	008b8913          	addi	s2,s7,8
 762:	4685                	li	a3,1
 764:	4629                	li	a2,10
 766:	000ba583          	lw	a1,0(s7)
 76a:	855a                	mv	a0,s6
 76c:	e91ff0ef          	jal	5fc <printint>
 770:	8bca                	mv	s7,s2
      state = 0;
 772:	4981                	li	s3,0
 774:	bfad                	j	6ee <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 776:	06400793          	li	a5,100
 77a:	02f68963          	beq	a3,a5,7ac <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 77e:	06c00793          	li	a5,108
 782:	04f68263          	beq	a3,a5,7c6 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 786:	07500793          	li	a5,117
 78a:	0af68063          	beq	a3,a5,82a <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 78e:	07800793          	li	a5,120
 792:	0ef68263          	beq	a3,a5,876 <vprintf+0x1d2>
        putc(fd, '%');
 796:	02500593          	li	a1,37
 79a:	855a                	mv	a0,s6
 79c:	e43ff0ef          	jal	5de <putc>
        putc(fd, c0);
 7a0:	85ca                	mv	a1,s2
 7a2:	855a                	mv	a0,s6
 7a4:	e3bff0ef          	jal	5de <putc>
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	b791                	j	6ee <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7ac:	008b8913          	addi	s2,s7,8
 7b0:	4685                	li	a3,1
 7b2:	4629                	li	a2,10
 7b4:	000ba583          	lw	a1,0(s7)
 7b8:	855a                	mv	a0,s6
 7ba:	e43ff0ef          	jal	5fc <printint>
        i += 1;
 7be:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c0:	8bca                	mv	s7,s2
      state = 0;
 7c2:	4981                	li	s3,0
        i += 1;
 7c4:	b72d                	j	6ee <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7c6:	06400793          	li	a5,100
 7ca:	02f60763          	beq	a2,a5,7f8 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7ce:	07500793          	li	a5,117
 7d2:	06f60963          	beq	a2,a5,844 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7d6:	07800793          	li	a5,120
 7da:	faf61ee3          	bne	a2,a5,796 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7de:	008b8913          	addi	s2,s7,8
 7e2:	4681                	li	a3,0
 7e4:	4641                	li	a2,16
 7e6:	000ba583          	lw	a1,0(s7)
 7ea:	855a                	mv	a0,s6
 7ec:	e11ff0ef          	jal	5fc <printint>
        i += 2;
 7f0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7f2:	8bca                	mv	s7,s2
      state = 0;
 7f4:	4981                	li	s3,0
        i += 2;
 7f6:	bde5                	j	6ee <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7f8:	008b8913          	addi	s2,s7,8
 7fc:	4685                	li	a3,1
 7fe:	4629                	li	a2,10
 800:	000ba583          	lw	a1,0(s7)
 804:	855a                	mv	a0,s6
 806:	df7ff0ef          	jal	5fc <printint>
        i += 2;
 80a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 80c:	8bca                	mv	s7,s2
      state = 0;
 80e:	4981                	li	s3,0
        i += 2;
 810:	bdf9                	j	6ee <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 812:	008b8913          	addi	s2,s7,8
 816:	4681                	li	a3,0
 818:	4629                	li	a2,10
 81a:	000ba583          	lw	a1,0(s7)
 81e:	855a                	mv	a0,s6
 820:	dddff0ef          	jal	5fc <printint>
 824:	8bca                	mv	s7,s2
      state = 0;
 826:	4981                	li	s3,0
 828:	b5d9                	j	6ee <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 82a:	008b8913          	addi	s2,s7,8
 82e:	4681                	li	a3,0
 830:	4629                	li	a2,10
 832:	000ba583          	lw	a1,0(s7)
 836:	855a                	mv	a0,s6
 838:	dc5ff0ef          	jal	5fc <printint>
        i += 1;
 83c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 83e:	8bca                	mv	s7,s2
      state = 0;
 840:	4981                	li	s3,0
        i += 1;
 842:	b575                	j	6ee <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 844:	008b8913          	addi	s2,s7,8
 848:	4681                	li	a3,0
 84a:	4629                	li	a2,10
 84c:	000ba583          	lw	a1,0(s7)
 850:	855a                	mv	a0,s6
 852:	dabff0ef          	jal	5fc <printint>
        i += 2;
 856:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 858:	8bca                	mv	s7,s2
      state = 0;
 85a:	4981                	li	s3,0
        i += 2;
 85c:	bd49                	j	6ee <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 85e:	008b8913          	addi	s2,s7,8
 862:	4681                	li	a3,0
 864:	4641                	li	a2,16
 866:	000ba583          	lw	a1,0(s7)
 86a:	855a                	mv	a0,s6
 86c:	d91ff0ef          	jal	5fc <printint>
 870:	8bca                	mv	s7,s2
      state = 0;
 872:	4981                	li	s3,0
 874:	bdad                	j	6ee <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 876:	008b8913          	addi	s2,s7,8
 87a:	4681                	li	a3,0
 87c:	4641                	li	a2,16
 87e:	000ba583          	lw	a1,0(s7)
 882:	855a                	mv	a0,s6
 884:	d79ff0ef          	jal	5fc <printint>
        i += 1;
 888:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 88a:	8bca                	mv	s7,s2
      state = 0;
 88c:	4981                	li	s3,0
        i += 1;
 88e:	b585                	j	6ee <vprintf+0x4a>
 890:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 892:	008b8d13          	addi	s10,s7,8
 896:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 89a:	03000593          	li	a1,48
 89e:	855a                	mv	a0,s6
 8a0:	d3fff0ef          	jal	5de <putc>
  putc(fd, 'x');
 8a4:	07800593          	li	a1,120
 8a8:	855a                	mv	a0,s6
 8aa:	d35ff0ef          	jal	5de <putc>
 8ae:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8b0:	00000b97          	auipc	s7,0x0
 8b4:	2d8b8b93          	addi	s7,s7,728 # b88 <digits>
 8b8:	03c9d793          	srli	a5,s3,0x3c
 8bc:	97de                	add	a5,a5,s7
 8be:	0007c583          	lbu	a1,0(a5)
 8c2:	855a                	mv	a0,s6
 8c4:	d1bff0ef          	jal	5de <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8c8:	0992                	slli	s3,s3,0x4
 8ca:	397d                	addiw	s2,s2,-1
 8cc:	fe0916e3          	bnez	s2,8b8 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 8d0:	8bea                	mv	s7,s10
      state = 0;
 8d2:	4981                	li	s3,0
 8d4:	6d02                	ld	s10,0(sp)
 8d6:	bd21                	j	6ee <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8d8:	008b8993          	addi	s3,s7,8
 8dc:	000bb903          	ld	s2,0(s7)
 8e0:	00090f63          	beqz	s2,8fe <vprintf+0x25a>
        for(; *s; s++)
 8e4:	00094583          	lbu	a1,0(s2)
 8e8:	c195                	beqz	a1,90c <vprintf+0x268>
          putc(fd, *s);
 8ea:	855a                	mv	a0,s6
 8ec:	cf3ff0ef          	jal	5de <putc>
        for(; *s; s++)
 8f0:	0905                	addi	s2,s2,1
 8f2:	00094583          	lbu	a1,0(s2)
 8f6:	f9f5                	bnez	a1,8ea <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8f8:	8bce                	mv	s7,s3
      state = 0;
 8fa:	4981                	li	s3,0
 8fc:	bbcd                	j	6ee <vprintf+0x4a>
          s = "(null)";
 8fe:	00000917          	auipc	s2,0x0
 902:	28290913          	addi	s2,s2,642 # b80 <malloc+0x176>
        for(; *s; s++)
 906:	02800593          	li	a1,40
 90a:	b7c5                	j	8ea <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 90c:	8bce                	mv	s7,s3
      state = 0;
 90e:	4981                	li	s3,0
 910:	bbf9                	j	6ee <vprintf+0x4a>
 912:	64a6                	ld	s1,72(sp)
 914:	79e2                	ld	s3,56(sp)
 916:	7a42                	ld	s4,48(sp)
 918:	7aa2                	ld	s5,40(sp)
 91a:	7b02                	ld	s6,32(sp)
 91c:	6be2                	ld	s7,24(sp)
 91e:	6c42                	ld	s8,16(sp)
 920:	6ca2                	ld	s9,8(sp)
    }
  }
}
 922:	60e6                	ld	ra,88(sp)
 924:	6446                	ld	s0,80(sp)
 926:	6906                	ld	s2,64(sp)
 928:	6125                	addi	sp,sp,96
 92a:	8082                	ret

000000000000092c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 92c:	715d                	addi	sp,sp,-80
 92e:	ec06                	sd	ra,24(sp)
 930:	e822                	sd	s0,16(sp)
 932:	1000                	addi	s0,sp,32
 934:	e010                	sd	a2,0(s0)
 936:	e414                	sd	a3,8(s0)
 938:	e818                	sd	a4,16(s0)
 93a:	ec1c                	sd	a5,24(s0)
 93c:	03043023          	sd	a6,32(s0)
 940:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 944:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 948:	8622                	mv	a2,s0
 94a:	d5bff0ef          	jal	6a4 <vprintf>
}
 94e:	60e2                	ld	ra,24(sp)
 950:	6442                	ld	s0,16(sp)
 952:	6161                	addi	sp,sp,80
 954:	8082                	ret

0000000000000956 <printf>:

void
printf(const char *fmt, ...)
{
 956:	711d                	addi	sp,sp,-96
 958:	ec06                	sd	ra,24(sp)
 95a:	e822                	sd	s0,16(sp)
 95c:	1000                	addi	s0,sp,32
 95e:	e40c                	sd	a1,8(s0)
 960:	e810                	sd	a2,16(s0)
 962:	ec14                	sd	a3,24(s0)
 964:	f018                	sd	a4,32(s0)
 966:	f41c                	sd	a5,40(s0)
 968:	03043823          	sd	a6,48(s0)
 96c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 970:	00840613          	addi	a2,s0,8
 974:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 978:	85aa                	mv	a1,a0
 97a:	4505                	li	a0,1
 97c:	d29ff0ef          	jal	6a4 <vprintf>
}
 980:	60e2                	ld	ra,24(sp)
 982:	6442                	ld	s0,16(sp)
 984:	6125                	addi	sp,sp,96
 986:	8082                	ret

0000000000000988 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 988:	1141                	addi	sp,sp,-16
 98a:	e422                	sd	s0,8(sp)
 98c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 98e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 992:	00001797          	auipc	a5,0x1
 996:	66e7b783          	ld	a5,1646(a5) # 2000 <freep>
 99a:	a02d                	j	9c4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 99c:	4618                	lw	a4,8(a2)
 99e:	9f2d                	addw	a4,a4,a1
 9a0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9a4:	6398                	ld	a4,0(a5)
 9a6:	6310                	ld	a2,0(a4)
 9a8:	a83d                	j	9e6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9aa:	ff852703          	lw	a4,-8(a0)
 9ae:	9f31                	addw	a4,a4,a2
 9b0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9b2:	ff053683          	ld	a3,-16(a0)
 9b6:	a091                	j	9fa <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9b8:	6398                	ld	a4,0(a5)
 9ba:	00e7e463          	bltu	a5,a4,9c2 <free+0x3a>
 9be:	00e6ea63          	bltu	a3,a4,9d2 <free+0x4a>
{
 9c2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9c4:	fed7fae3          	bgeu	a5,a3,9b8 <free+0x30>
 9c8:	6398                	ld	a4,0(a5)
 9ca:	00e6e463          	bltu	a3,a4,9d2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ce:	fee7eae3          	bltu	a5,a4,9c2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9d2:	ff852583          	lw	a1,-8(a0)
 9d6:	6390                	ld	a2,0(a5)
 9d8:	02059813          	slli	a6,a1,0x20
 9dc:	01c85713          	srli	a4,a6,0x1c
 9e0:	9736                	add	a4,a4,a3
 9e2:	fae60de3          	beq	a2,a4,99c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9e6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9ea:	4790                	lw	a2,8(a5)
 9ec:	02061593          	slli	a1,a2,0x20
 9f0:	01c5d713          	srli	a4,a1,0x1c
 9f4:	973e                	add	a4,a4,a5
 9f6:	fae68ae3          	beq	a3,a4,9aa <free+0x22>
    p->s.ptr = bp->s.ptr;
 9fa:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9fc:	00001717          	auipc	a4,0x1
 a00:	60f73223          	sd	a5,1540(a4) # 2000 <freep>
}
 a04:	6422                	ld	s0,8(sp)
 a06:	0141                	addi	sp,sp,16
 a08:	8082                	ret

0000000000000a0a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a0a:	7139                	addi	sp,sp,-64
 a0c:	fc06                	sd	ra,56(sp)
 a0e:	f822                	sd	s0,48(sp)
 a10:	f426                	sd	s1,40(sp)
 a12:	ec4e                	sd	s3,24(sp)
 a14:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a16:	02051493          	slli	s1,a0,0x20
 a1a:	9081                	srli	s1,s1,0x20
 a1c:	04bd                	addi	s1,s1,15
 a1e:	8091                	srli	s1,s1,0x4
 a20:	0014899b          	addiw	s3,s1,1
 a24:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a26:	00001517          	auipc	a0,0x1
 a2a:	5da53503          	ld	a0,1498(a0) # 2000 <freep>
 a2e:	c915                	beqz	a0,a62 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a30:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a32:	4798                	lw	a4,8(a5)
 a34:	08977a63          	bgeu	a4,s1,ac8 <malloc+0xbe>
 a38:	f04a                	sd	s2,32(sp)
 a3a:	e852                	sd	s4,16(sp)
 a3c:	e456                	sd	s5,8(sp)
 a3e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a40:	8a4e                	mv	s4,s3
 a42:	0009871b          	sext.w	a4,s3
 a46:	6685                	lui	a3,0x1
 a48:	00d77363          	bgeu	a4,a3,a4e <malloc+0x44>
 a4c:	6a05                	lui	s4,0x1
 a4e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a52:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a56:	00001917          	auipc	s2,0x1
 a5a:	5aa90913          	addi	s2,s2,1450 # 2000 <freep>
  if(p == (char*)-1)
 a5e:	5afd                	li	s5,-1
 a60:	a081                	j	aa0 <malloc+0x96>
 a62:	f04a                	sd	s2,32(sp)
 a64:	e852                	sd	s4,16(sp)
 a66:	e456                	sd	s5,8(sp)
 a68:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a6a:	00001797          	auipc	a5,0x1
 a6e:	7a678793          	addi	a5,a5,1958 # 2210 <base>
 a72:	00001717          	auipc	a4,0x1
 a76:	58f73723          	sd	a5,1422(a4) # 2000 <freep>
 a7a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a7c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a80:	b7c1                	j	a40 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a82:	6398                	ld	a4,0(a5)
 a84:	e118                	sd	a4,0(a0)
 a86:	a8a9                	j	ae0 <malloc+0xd6>
  hp->s.size = nu;
 a88:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a8c:	0541                	addi	a0,a0,16
 a8e:	efbff0ef          	jal	988 <free>
  return freep;
 a92:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a96:	c12d                	beqz	a0,af8 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a98:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a9a:	4798                	lw	a4,8(a5)
 a9c:	02977263          	bgeu	a4,s1,ac0 <malloc+0xb6>
    if(p == freep)
 aa0:	00093703          	ld	a4,0(s2)
 aa4:	853e                	mv	a0,a5
 aa6:	fef719e3          	bne	a4,a5,a98 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 aaa:	8552                	mv	a0,s4
 aac:	ad3ff0ef          	jal	57e <sbrk>
  if(p == (char*)-1)
 ab0:	fd551ce3          	bne	a0,s5,a88 <malloc+0x7e>
        return 0;
 ab4:	4501                	li	a0,0
 ab6:	7902                	ld	s2,32(sp)
 ab8:	6a42                	ld	s4,16(sp)
 aba:	6aa2                	ld	s5,8(sp)
 abc:	6b02                	ld	s6,0(sp)
 abe:	a03d                	j	aec <malloc+0xe2>
 ac0:	7902                	ld	s2,32(sp)
 ac2:	6a42                	ld	s4,16(sp)
 ac4:	6aa2                	ld	s5,8(sp)
 ac6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 ac8:	fae48de3          	beq	s1,a4,a82 <malloc+0x78>
        p->s.size -= nunits;
 acc:	4137073b          	subw	a4,a4,s3
 ad0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ad2:	02071693          	slli	a3,a4,0x20
 ad6:	01c6d713          	srli	a4,a3,0x1c
 ada:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 adc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ae0:	00001717          	auipc	a4,0x1
 ae4:	52a73023          	sd	a0,1312(a4) # 2000 <freep>
      return (void*)(p + 1);
 ae8:	01078513          	addi	a0,a5,16
  }
}
 aec:	70e2                	ld	ra,56(sp)
 aee:	7442                	ld	s0,48(sp)
 af0:	74a2                	ld	s1,40(sp)
 af2:	69e2                	ld	s3,24(sp)
 af4:	6121                	addi	sp,sp,64
 af6:	8082                	ret
 af8:	7902                	ld	s2,32(sp)
 afa:	6a42                	ld	s4,16(sp)
 afc:	6aa2                	ld	s5,8(sp)
 afe:	6b02                	ld	s6,0(sp)
 b00:	b7f5                	j	aec <malloc+0xe2>
