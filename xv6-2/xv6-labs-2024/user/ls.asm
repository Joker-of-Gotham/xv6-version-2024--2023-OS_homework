
user/_ls：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	2ec000ef          	jal	2f8 <strlen>
  10:	02051793          	slli	a5,a0,0x20
  14:	9381                	srli	a5,a5,0x20
  16:	97a6                	add	a5,a5,s1
  18:	02f00693          	li	a3,47
  1c:	0097e963          	bltu	a5,s1,2e <fmtname+0x2e>
  20:	0007c703          	lbu	a4,0(a5)
  24:	00d70563          	beq	a4,a3,2e <fmtname+0x2e>
  28:	17fd                	addi	a5,a5,-1
  2a:	fe97fbe3          	bgeu	a5,s1,20 <fmtname+0x20>
    ;
  p++;
  2e:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  32:	8526                	mv	a0,s1
  34:	2c4000ef          	jal	2f8 <strlen>
  38:	2501                	sext.w	a0,a0
  3a:	47b5                	li	a5,13
  3c:	00a7f863          	bgeu	a5,a0,4c <fmtname+0x4c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  40:	8526                	mv	a0,s1
  42:	70a2                	ld	ra,40(sp)
  44:	7402                	ld	s0,32(sp)
  46:	64e2                	ld	s1,24(sp)
  48:	6145                	addi	sp,sp,48
  4a:	8082                	ret
  4c:	e84a                	sd	s2,16(sp)
  4e:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  50:	8526                	mv	a0,s1
  52:	2a6000ef          	jal	2f8 <strlen>
  56:	00002997          	auipc	s3,0x2
  5a:	fba98993          	addi	s3,s3,-70 # 2010 <buf.0>
  5e:	0005061b          	sext.w	a2,a0
  62:	85a6                	mv	a1,s1
  64:	854e                	mv	a0,s3
  66:	3f4000ef          	jal	45a <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6a:	8526                	mv	a0,s1
  6c:	28c000ef          	jal	2f8 <strlen>
  70:	0005091b          	sext.w	s2,a0
  74:	8526                	mv	a0,s1
  76:	282000ef          	jal	2f8 <strlen>
  7a:	1902                	slli	s2,s2,0x20
  7c:	02095913          	srli	s2,s2,0x20
  80:	4639                	li	a2,14
  82:	9e09                	subw	a2,a2,a0
  84:	02000593          	li	a1,32
  88:	01298533          	add	a0,s3,s2
  8c:	296000ef          	jal	322 <memset>
  return buf;
  90:	84ce                	mv	s1,s3
  92:	6942                	ld	s2,16(sp)
  94:	69a2                	ld	s3,8(sp)
  96:	b76d                	j	40 <fmtname+0x40>

0000000000000098 <ls>:

void
ls(char *path)
{
  98:	d9010113          	addi	sp,sp,-624
  9c:	26113423          	sd	ra,616(sp)
  a0:	26813023          	sd	s0,608(sp)
  a4:	25213823          	sd	s2,592(sp)
  a8:	1c80                	addi	s0,sp,624
  aa:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  ac:	4581                	li	a1,0
  ae:	594000ef          	jal	642 <open>
  b2:	06054363          	bltz	a0,118 <ls+0x80>
  b6:	24913c23          	sd	s1,600(sp)
  ba:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  bc:	d9840593          	addi	a1,s0,-616
  c0:	59a000ef          	jal	65a <fstat>
  c4:	06054363          	bltz	a0,12a <ls+0x92>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  c8:	da041783          	lh	a5,-608(s0)
  cc:	4705                	li	a4,1
  ce:	06e78c63          	beq	a5,a4,146 <ls+0xae>
  d2:	37f9                	addiw	a5,a5,-2
  d4:	17c2                	slli	a5,a5,0x30
  d6:	93c1                	srli	a5,a5,0x30
  d8:	02f76263          	bltu	a4,a5,fc <ls+0x64>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  dc:	854a                	mv	a0,s2
  de:	f23ff0ef          	jal	0 <fmtname>
  e2:	85aa                	mv	a1,a0
  e4:	da842703          	lw	a4,-600(s0)
  e8:	d9c42683          	lw	a3,-612(s0)
  ec:	da041603          	lh	a2,-608(s0)
  f0:	00001517          	auipc	a0,0x1
  f4:	b5050513          	addi	a0,a0,-1200 # c40 <malloc+0x12a>
  f8:	16b000ef          	jal	a62 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
  fc:	8526                	mv	a0,s1
  fe:	52c000ef          	jal	62a <close>
 102:	25813483          	ld	s1,600(sp)
}
 106:	26813083          	ld	ra,616(sp)
 10a:	26013403          	ld	s0,608(sp)
 10e:	25013903          	ld	s2,592(sp)
 112:	27010113          	addi	sp,sp,624
 116:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 118:	864a                	mv	a2,s2
 11a:	00001597          	auipc	a1,0x1
 11e:	af658593          	addi	a1,a1,-1290 # c10 <malloc+0xfa>
 122:	4509                	li	a0,2
 124:	115000ef          	jal	a38 <fprintf>
    return;
 128:	bff9                	j	106 <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
 12a:	864a                	mv	a2,s2
 12c:	00001597          	auipc	a1,0x1
 130:	afc58593          	addi	a1,a1,-1284 # c28 <malloc+0x112>
 134:	4509                	li	a0,2
 136:	103000ef          	jal	a38 <fprintf>
    close(fd);
 13a:	8526                	mv	a0,s1
 13c:	4ee000ef          	jal	62a <close>
    return;
 140:	25813483          	ld	s1,600(sp)
 144:	b7c9                	j	106 <ls+0x6e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 146:	854a                	mv	a0,s2
 148:	1b0000ef          	jal	2f8 <strlen>
 14c:	2541                	addiw	a0,a0,16
 14e:	20000793          	li	a5,512
 152:	00a7f963          	bgeu	a5,a0,164 <ls+0xcc>
      printf("ls: path too long\n");
 156:	00001517          	auipc	a0,0x1
 15a:	afa50513          	addi	a0,a0,-1286 # c50 <malloc+0x13a>
 15e:	105000ef          	jal	a62 <printf>
      break;
 162:	bf69                	j	fc <ls+0x64>
 164:	25313423          	sd	s3,584(sp)
 168:	25413023          	sd	s4,576(sp)
 16c:	23513c23          	sd	s5,568(sp)
    strcpy(buf, path);
 170:	85ca                	mv	a1,s2
 172:	dc040513          	addi	a0,s0,-576
 176:	104000ef          	jal	27a <strcpy>
    p = buf+strlen(buf);
 17a:	dc040513          	addi	a0,s0,-576
 17e:	17a000ef          	jal	2f8 <strlen>
 182:	1502                	slli	a0,a0,0x20
 184:	9101                	srli	a0,a0,0x20
 186:	dc040793          	addi	a5,s0,-576
 18a:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 18e:	00190993          	addi	s3,s2,1
 192:	02f00793          	li	a5,47
 196:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 19a:	00001a17          	auipc	s4,0x1
 19e:	aa6a0a13          	addi	s4,s4,-1370 # c40 <malloc+0x12a>
        printf("ls: cannot stat %s\n", buf);
 1a2:	00001a97          	auipc	s5,0x1
 1a6:	a86a8a93          	addi	s5,s5,-1402 # c28 <malloc+0x112>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1aa:	a031                	j	1b6 <ls+0x11e>
        printf("ls: cannot stat %s\n", buf);
 1ac:	dc040593          	addi	a1,s0,-576
 1b0:	8556                	mv	a0,s5
 1b2:	0b1000ef          	jal	a62 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1b6:	4641                	li	a2,16
 1b8:	db040593          	addi	a1,s0,-592
 1bc:	8526                	mv	a0,s1
 1be:	45c000ef          	jal	61a <read>
 1c2:	47c1                	li	a5,16
 1c4:	04f51463          	bne	a0,a5,20c <ls+0x174>
      if(de.inum == 0)
 1c8:	db045783          	lhu	a5,-592(s0)
 1cc:	d7ed                	beqz	a5,1b6 <ls+0x11e>
      memmove(p, de.name, DIRSIZ);
 1ce:	4639                	li	a2,14
 1d0:	db240593          	addi	a1,s0,-590
 1d4:	854e                	mv	a0,s3
 1d6:	284000ef          	jal	45a <memmove>
      p[DIRSIZ] = 0;
 1da:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 1de:	d9840593          	addi	a1,s0,-616
 1e2:	dc040513          	addi	a0,s0,-576
 1e6:	1f2000ef          	jal	3d8 <stat>
 1ea:	fc0541e3          	bltz	a0,1ac <ls+0x114>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1ee:	dc040513          	addi	a0,s0,-576
 1f2:	e0fff0ef          	jal	0 <fmtname>
 1f6:	85aa                	mv	a1,a0
 1f8:	da842703          	lw	a4,-600(s0)
 1fc:	d9c42683          	lw	a3,-612(s0)
 200:	da041603          	lh	a2,-608(s0)
 204:	8552                	mv	a0,s4
 206:	05d000ef          	jal	a62 <printf>
 20a:	b775                	j	1b6 <ls+0x11e>
 20c:	24813983          	ld	s3,584(sp)
 210:	24013a03          	ld	s4,576(sp)
 214:	23813a83          	ld	s5,568(sp)
 218:	b5d5                	j	fc <ls+0x64>

000000000000021a <main>:

int
main(int argc, char *argv[])
{
 21a:	1101                	addi	sp,sp,-32
 21c:	ec06                	sd	ra,24(sp)
 21e:	e822                	sd	s0,16(sp)
 220:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 222:	4785                	li	a5,1
 224:	02a7d763          	bge	a5,a0,252 <main+0x38>
 228:	e426                	sd	s1,8(sp)
 22a:	e04a                	sd	s2,0(sp)
 22c:	00858493          	addi	s1,a1,8
 230:	ffe5091b          	addiw	s2,a0,-2
 234:	02091793          	slli	a5,s2,0x20
 238:	01d7d913          	srli	s2,a5,0x1d
 23c:	05c1                	addi	a1,a1,16
 23e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 240:	6088                	ld	a0,0(s1)
 242:	e57ff0ef          	jal	98 <ls>
  for(i=1; i<argc; i++)
 246:	04a1                	addi	s1,s1,8
 248:	ff249ce3          	bne	s1,s2,240 <main+0x26>
  exit(0);
 24c:	4501                	li	a0,0
 24e:	3b4000ef          	jal	602 <exit>
 252:	e426                	sd	s1,8(sp)
 254:	e04a                	sd	s2,0(sp)
    ls(".");
 256:	00001517          	auipc	a0,0x1
 25a:	a1250513          	addi	a0,a0,-1518 # c68 <malloc+0x152>
 25e:	e3bff0ef          	jal	98 <ls>
    exit(0);
 262:	4501                	li	a0,0
 264:	39e000ef          	jal	602 <exit>

0000000000000268 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 268:	1141                	addi	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 270:	fabff0ef          	jal	21a <main>
  exit(0);
 274:	4501                	li	a0,0
 276:	38c000ef          	jal	602 <exit>

000000000000027a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 280:	87aa                	mv	a5,a0
 282:	0585                	addi	a1,a1,1
 284:	0785                	addi	a5,a5,1
 286:	fff5c703          	lbu	a4,-1(a1)
 28a:	fee78fa3          	sb	a4,-1(a5)
 28e:	fb75                	bnez	a4,282 <strcpy+0x8>
    ;
  return os;
}
 290:	6422                	ld	s0,8(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret

0000000000000296 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 296:	1141                	addi	sp,sp,-16
 298:	e422                	sd	s0,8(sp)
 29a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 29c:	00054783          	lbu	a5,0(a0)
 2a0:	cb91                	beqz	a5,2b4 <strcmp+0x1e>
 2a2:	0005c703          	lbu	a4,0(a1)
 2a6:	00f71763          	bne	a4,a5,2b4 <strcmp+0x1e>
    p++, q++;
 2aa:	0505                	addi	a0,a0,1
 2ac:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2ae:	00054783          	lbu	a5,0(a0)
 2b2:	fbe5                	bnez	a5,2a2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2b4:	0005c503          	lbu	a0,0(a1)
}
 2b8:	40a7853b          	subw	a0,a5,a0
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret

00000000000002c2 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e422                	sd	s0,8(sp)
 2c6:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q) {
 2c8:	ce11                	beqz	a2,2e4 <strncmp+0x22>
 2ca:	00054783          	lbu	a5,0(a0)
 2ce:	cf89                	beqz	a5,2e8 <strncmp+0x26>
 2d0:	0005c703          	lbu	a4,0(a1)
 2d4:	00f71a63          	bne	a4,a5,2e8 <strncmp+0x26>
    n--;
 2d8:	367d                	addiw	a2,a2,-1
    p++;
 2da:	0505                	addi	a0,a0,1
    q++;
 2dc:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q) {
 2de:	f675                	bnez	a2,2ca <strncmp+0x8>
  }
  if(n == 0)
    return 0;
 2e0:	4501                	li	a0,0
 2e2:	a801                	j	2f2 <strncmp+0x30>
 2e4:	4501                	li	a0,0
 2e6:	a031                	j	2f2 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
 2e8:	00054503          	lbu	a0,0(a0)
 2ec:	0005c783          	lbu	a5,0(a1)
 2f0:	9d1d                	subw	a0,a0,a5
}
 2f2:	6422                	ld	s0,8(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret

00000000000002f8 <strlen>:

uint
strlen(const char *s)
{
 2f8:	1141                	addi	sp,sp,-16
 2fa:	e422                	sd	s0,8(sp)
 2fc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2fe:	00054783          	lbu	a5,0(a0)
 302:	cf91                	beqz	a5,31e <strlen+0x26>
 304:	0505                	addi	a0,a0,1
 306:	87aa                	mv	a5,a0
 308:	86be                	mv	a3,a5
 30a:	0785                	addi	a5,a5,1
 30c:	fff7c703          	lbu	a4,-1(a5)
 310:	ff65                	bnez	a4,308 <strlen+0x10>
 312:	40a6853b          	subw	a0,a3,a0
 316:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 318:	6422                	ld	s0,8(sp)
 31a:	0141                	addi	sp,sp,16
 31c:	8082                	ret
  for(n = 0; s[n]; n++)
 31e:	4501                	li	a0,0
 320:	bfe5                	j	318 <strlen+0x20>

0000000000000322 <memset>:

void*
memset(void *dst, int c, uint n)
{
 322:	1141                	addi	sp,sp,-16
 324:	e422                	sd	s0,8(sp)
 326:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 328:	ca19                	beqz	a2,33e <memset+0x1c>
 32a:	87aa                	mv	a5,a0
 32c:	1602                	slli	a2,a2,0x20
 32e:	9201                	srli	a2,a2,0x20
 330:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 334:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 338:	0785                	addi	a5,a5,1
 33a:	fee79de3          	bne	a5,a4,334 <memset+0x12>
  }
  return dst;
}
 33e:	6422                	ld	s0,8(sp)
 340:	0141                	addi	sp,sp,16
 342:	8082                	ret

0000000000000344 <strchr>:

char*
strchr(const char *s, char c)
{
 344:	1141                	addi	sp,sp,-16
 346:	e422                	sd	s0,8(sp)
 348:	0800                	addi	s0,sp,16
  for(; *s; s++)
 34a:	00054783          	lbu	a5,0(a0)
 34e:	cb99                	beqz	a5,364 <strchr+0x20>
    if(*s == c)
 350:	00f58763          	beq	a1,a5,35e <strchr+0x1a>
  for(; *s; s++)
 354:	0505                	addi	a0,a0,1
 356:	00054783          	lbu	a5,0(a0)
 35a:	fbfd                	bnez	a5,350 <strchr+0xc>
      return (char*)s;
  return 0;
 35c:	4501                	li	a0,0
}
 35e:	6422                	ld	s0,8(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret
  return 0;
 364:	4501                	li	a0,0
 366:	bfe5                	j	35e <strchr+0x1a>

0000000000000368 <gets>:

char*
gets(char *buf, int max)
{
 368:	711d                	addi	sp,sp,-96
 36a:	ec86                	sd	ra,88(sp)
 36c:	e8a2                	sd	s0,80(sp)
 36e:	e4a6                	sd	s1,72(sp)
 370:	e0ca                	sd	s2,64(sp)
 372:	fc4e                	sd	s3,56(sp)
 374:	f852                	sd	s4,48(sp)
 376:	f456                	sd	s5,40(sp)
 378:	f05a                	sd	s6,32(sp)
 37a:	ec5e                	sd	s7,24(sp)
 37c:	1080                	addi	s0,sp,96
 37e:	8baa                	mv	s7,a0
 380:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 382:	892a                	mv	s2,a0
 384:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 386:	4aa9                	li	s5,10
 388:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 38a:	89a6                	mv	s3,s1
 38c:	2485                	addiw	s1,s1,1
 38e:	0344d663          	bge	s1,s4,3ba <gets+0x52>
    cc = read(0, &c, 1);
 392:	4605                	li	a2,1
 394:	faf40593          	addi	a1,s0,-81
 398:	4501                	li	a0,0
 39a:	280000ef          	jal	61a <read>
    if(cc < 1)
 39e:	00a05e63          	blez	a0,3ba <gets+0x52>
    buf[i++] = c;
 3a2:	faf44783          	lbu	a5,-81(s0)
 3a6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3aa:	01578763          	beq	a5,s5,3b8 <gets+0x50>
 3ae:	0905                	addi	s2,s2,1
 3b0:	fd679de3          	bne	a5,s6,38a <gets+0x22>
    buf[i++] = c;
 3b4:	89a6                	mv	s3,s1
 3b6:	a011                	j	3ba <gets+0x52>
 3b8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3ba:	99de                	add	s3,s3,s7
 3bc:	00098023          	sb	zero,0(s3)
  return buf;
}
 3c0:	855e                	mv	a0,s7
 3c2:	60e6                	ld	ra,88(sp)
 3c4:	6446                	ld	s0,80(sp)
 3c6:	64a6                	ld	s1,72(sp)
 3c8:	6906                	ld	s2,64(sp)
 3ca:	79e2                	ld	s3,56(sp)
 3cc:	7a42                	ld	s4,48(sp)
 3ce:	7aa2                	ld	s5,40(sp)
 3d0:	7b02                	ld	s6,32(sp)
 3d2:	6be2                	ld	s7,24(sp)
 3d4:	6125                	addi	sp,sp,96
 3d6:	8082                	ret

00000000000003d8 <stat>:

int
stat(const char *n, struct stat *st)
{
 3d8:	1101                	addi	sp,sp,-32
 3da:	ec06                	sd	ra,24(sp)
 3dc:	e822                	sd	s0,16(sp)
 3de:	e04a                	sd	s2,0(sp)
 3e0:	1000                	addi	s0,sp,32
 3e2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3e4:	4581                	li	a1,0
 3e6:	25c000ef          	jal	642 <open>
  if(fd < 0)
 3ea:	02054263          	bltz	a0,40e <stat+0x36>
 3ee:	e426                	sd	s1,8(sp)
 3f0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3f2:	85ca                	mv	a1,s2
 3f4:	266000ef          	jal	65a <fstat>
 3f8:	892a                	mv	s2,a0
  close(fd);
 3fa:	8526                	mv	a0,s1
 3fc:	22e000ef          	jal	62a <close>
  return r;
 400:	64a2                	ld	s1,8(sp)
}
 402:	854a                	mv	a0,s2
 404:	60e2                	ld	ra,24(sp)
 406:	6442                	ld	s0,16(sp)
 408:	6902                	ld	s2,0(sp)
 40a:	6105                	addi	sp,sp,32
 40c:	8082                	ret
    return -1;
 40e:	597d                	li	s2,-1
 410:	bfcd                	j	402 <stat+0x2a>

0000000000000412 <atoi>:

int
atoi(const char *s)
{
 412:	1141                	addi	sp,sp,-16
 414:	e422                	sd	s0,8(sp)
 416:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 418:	00054683          	lbu	a3,0(a0)
 41c:	fd06879b          	addiw	a5,a3,-48
 420:	0ff7f793          	zext.b	a5,a5
 424:	4625                	li	a2,9
 426:	02f66863          	bltu	a2,a5,456 <atoi+0x44>
 42a:	872a                	mv	a4,a0
  n = 0;
 42c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 42e:	0705                	addi	a4,a4,1
 430:	0025179b          	slliw	a5,a0,0x2
 434:	9fa9                	addw	a5,a5,a0
 436:	0017979b          	slliw	a5,a5,0x1
 43a:	9fb5                	addw	a5,a5,a3
 43c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 440:	00074683          	lbu	a3,0(a4)
 444:	fd06879b          	addiw	a5,a3,-48
 448:	0ff7f793          	zext.b	a5,a5
 44c:	fef671e3          	bgeu	a2,a5,42e <atoi+0x1c>
  return n;
}
 450:	6422                	ld	s0,8(sp)
 452:	0141                	addi	sp,sp,16
 454:	8082                	ret
  n = 0;
 456:	4501                	li	a0,0
 458:	bfe5                	j	450 <atoi+0x3e>

000000000000045a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 45a:	1141                	addi	sp,sp,-16
 45c:	e422                	sd	s0,8(sp)
 45e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 460:	02b57463          	bgeu	a0,a1,488 <memmove+0x2e>
    while(n-- > 0)
 464:	00c05f63          	blez	a2,482 <memmove+0x28>
 468:	1602                	slli	a2,a2,0x20
 46a:	9201                	srli	a2,a2,0x20
 46c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 470:	872a                	mv	a4,a0
      *dst++ = *src++;
 472:	0585                	addi	a1,a1,1
 474:	0705                	addi	a4,a4,1
 476:	fff5c683          	lbu	a3,-1(a1)
 47a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 47e:	fef71ae3          	bne	a4,a5,472 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 482:	6422                	ld	s0,8(sp)
 484:	0141                	addi	sp,sp,16
 486:	8082                	ret
    dst += n;
 488:	00c50733          	add	a4,a0,a2
    src += n;
 48c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 48e:	fec05ae3          	blez	a2,482 <memmove+0x28>
 492:	fff6079b          	addiw	a5,a2,-1
 496:	1782                	slli	a5,a5,0x20
 498:	9381                	srli	a5,a5,0x20
 49a:	fff7c793          	not	a5,a5
 49e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4a0:	15fd                	addi	a1,a1,-1
 4a2:	177d                	addi	a4,a4,-1
 4a4:	0005c683          	lbu	a3,0(a1)
 4a8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4ac:	fee79ae3          	bne	a5,a4,4a0 <memmove+0x46>
 4b0:	bfc9                	j	482 <memmove+0x28>

00000000000004b2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4b2:	1141                	addi	sp,sp,-16
 4b4:	e422                	sd	s0,8(sp)
 4b6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4b8:	ca05                	beqz	a2,4e8 <memcmp+0x36>
 4ba:	fff6069b          	addiw	a3,a2,-1
 4be:	1682                	slli	a3,a3,0x20
 4c0:	9281                	srli	a3,a3,0x20
 4c2:	0685                	addi	a3,a3,1
 4c4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4c6:	00054783          	lbu	a5,0(a0)
 4ca:	0005c703          	lbu	a4,0(a1)
 4ce:	00e79863          	bne	a5,a4,4de <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4d2:	0505                	addi	a0,a0,1
    p2++;
 4d4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4d6:	fed518e3          	bne	a0,a3,4c6 <memcmp+0x14>
  }
  return 0;
 4da:	4501                	li	a0,0
 4dc:	a019                	j	4e2 <memcmp+0x30>
      return *p1 - *p2;
 4de:	40e7853b          	subw	a0,a5,a4
}
 4e2:	6422                	ld	s0,8(sp)
 4e4:	0141                	addi	sp,sp,16
 4e6:	8082                	ret
  return 0;
 4e8:	4501                	li	a0,0
 4ea:	bfe5                	j	4e2 <memcmp+0x30>

00000000000004ec <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4ec:	1141                	addi	sp,sp,-16
 4ee:	e406                	sd	ra,8(sp)
 4f0:	e022                	sd	s0,0(sp)
 4f2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4f4:	f67ff0ef          	jal	45a <memmove>
}
 4f8:	60a2                	ld	ra,8(sp)
 4fa:	6402                	ld	s0,0(sp)
 4fc:	0141                	addi	sp,sp,16
 4fe:	8082                	ret

0000000000000500 <simplesort>:

void
simplesort(void *base, uint nmemb, uint size, int (*compar)(const void *, const void *))
{
 500:	7119                	addi	sp,sp,-128
 502:	fc86                	sd	ra,120(sp)
 504:	f8a2                	sd	s0,112(sp)
 506:	0100                	addi	s0,sp,128
 508:	f8b43423          	sd	a1,-120(s0)
  char *arr = (char *)base; // Treat array as char array for byte-level manipulation
  char *temp;               // Temporary storage for an element

  if (nmemb <= 1 || size == 0) {
 50c:	4785                	li	a5,1
 50e:	00b7fc63          	bgeu	a5,a1,526 <simplesort+0x26>
 512:	e8d2                	sd	s4,80(sp)
 514:	e4d6                	sd	s5,72(sp)
 516:	f466                	sd	s9,40(sp)
 518:	8aaa                	mv	s5,a0
 51a:	8a32                	mv	s4,a2
 51c:	8cb6                	mv	s9,a3
 51e:	ea01                	bnez	a2,52e <simplesort+0x2e>
 520:	6a46                	ld	s4,80(sp)
 522:	6aa6                	ld	s5,72(sp)
 524:	7ca2                	ld	s9,40(sp)
    // Place temp at its correct position
    memmove(arr + j * size, temp, size);
  }

  free(temp); // Free temporary space
 526:	70e6                	ld	ra,120(sp)
 528:	7446                	ld	s0,112(sp)
 52a:	6109                	addi	sp,sp,128
 52c:	8082                	ret
 52e:	fc5e                	sd	s7,56(sp)
 530:	f862                	sd	s8,48(sp)
 532:	f06a                	sd	s10,32(sp)
 534:	ec6e                	sd	s11,24(sp)
  temp = malloc(size); // Allocate temporary space for one element
 536:	8532                	mv	a0,a2
 538:	5de000ef          	jal	b16 <malloc>
 53c:	8baa                	mv	s7,a0
  if (temp == 0) {
 53e:	4d81                	li	s11,0
  for (uint i = 1; i < nmemb; i++) {
 540:	4d05                	li	s10,1
    memmove(temp, arr + i * size, size);
 542:	000a0c1b          	sext.w	s8,s4
  if (temp == 0) {
 546:	c511                	beqz	a0,552 <simplesort+0x52>
 548:	f4a6                	sd	s1,104(sp)
 54a:	f0ca                	sd	s2,96(sp)
 54c:	ecce                	sd	s3,88(sp)
 54e:	e0da                	sd	s6,64(sp)
 550:	a82d                	j	58a <simplesort+0x8a>
    printf("simplesort: malloc failed, cannot sort\n");
 552:	00000517          	auipc	a0,0x0
 556:	71e50513          	addi	a0,a0,1822 # c70 <malloc+0x15a>
 55a:	508000ef          	jal	a62 <printf>
    return;
 55e:	6a46                	ld	s4,80(sp)
 560:	6aa6                	ld	s5,72(sp)
 562:	7be2                	ld	s7,56(sp)
 564:	7c42                	ld	s8,48(sp)
 566:	7ca2                	ld	s9,40(sp)
 568:	7d02                	ld	s10,32(sp)
 56a:	6de2                	ld	s11,24(sp)
 56c:	bf6d                	j	526 <simplesort+0x26>
    memmove(arr + j * size, temp, size);
 56e:	036a053b          	mulw	a0,s4,s6
 572:	1502                	slli	a0,a0,0x20
 574:	9101                	srli	a0,a0,0x20
 576:	8662                	mv	a2,s8
 578:	85de                	mv	a1,s7
 57a:	9556                	add	a0,a0,s5
 57c:	edfff0ef          	jal	45a <memmove>
  for (uint i = 1; i < nmemb; i++) {
 580:	2d05                	addiw	s10,s10,1
 582:	f8843783          	ld	a5,-120(s0)
 586:	05a78b63          	beq	a5,s10,5dc <simplesort+0xdc>
    memmove(temp, arr + i * size, size);
 58a:	000d899b          	sext.w	s3,s11
 58e:	01ba05bb          	addw	a1,s4,s11
 592:	00058d9b          	sext.w	s11,a1
 596:	1582                	slli	a1,a1,0x20
 598:	9181                	srli	a1,a1,0x20
 59a:	8662                	mv	a2,s8
 59c:	95d6                	add	a1,a1,s5
 59e:	855e                	mv	a0,s7
 5a0:	ebbff0ef          	jal	45a <memmove>
    uint j = i;
 5a4:	896a                	mv	s2,s10
 5a6:	00090b1b          	sext.w	s6,s2
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 5aa:	397d                	addiw	s2,s2,-1
 5ac:	02099493          	slli	s1,s3,0x20
 5b0:	9081                	srli	s1,s1,0x20
 5b2:	94d6                	add	s1,s1,s5
 5b4:	85de                	mv	a1,s7
 5b6:	8526                	mv	a0,s1
 5b8:	9c82                	jalr	s9
 5ba:	faa05ae3          	blez	a0,56e <simplesort+0x6e>
      memmove(arr + j * size, arr + (j - 1) * size, size); // Shift element
 5be:	0149853b          	addw	a0,s3,s4
 5c2:	1502                	slli	a0,a0,0x20
 5c4:	9101                	srli	a0,a0,0x20
 5c6:	8662                	mv	a2,s8
 5c8:	85a6                	mv	a1,s1
 5ca:	9556                	add	a0,a0,s5
 5cc:	e8fff0ef          	jal	45a <memmove>
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 5d0:	414989bb          	subw	s3,s3,s4
 5d4:	fc0919e3          	bnez	s2,5a6 <simplesort+0xa6>
 5d8:	8b4a                	mv	s6,s2
 5da:	bf51                	j	56e <simplesort+0x6e>
  free(temp); // Free temporary space
 5dc:	855e                	mv	a0,s7
 5de:	4b6000ef          	jal	a94 <free>
 5e2:	74a6                	ld	s1,104(sp)
 5e4:	7906                	ld	s2,96(sp)
 5e6:	69e6                	ld	s3,88(sp)
 5e8:	6a46                	ld	s4,80(sp)
 5ea:	6aa6                	ld	s5,72(sp)
 5ec:	6b06                	ld	s6,64(sp)
 5ee:	7be2                	ld	s7,56(sp)
 5f0:	7c42                	ld	s8,48(sp)
 5f2:	7ca2                	ld	s9,40(sp)
 5f4:	7d02                	ld	s10,32(sp)
 5f6:	6de2                	ld	s11,24(sp)
 5f8:	b73d                	j	526 <simplesort+0x26>

00000000000005fa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5fa:	4885                	li	a7,1
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <exit>:
.global exit
exit:
 li a7, SYS_exit
 602:	4889                	li	a7,2
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <wait>:
.global wait
wait:
 li a7, SYS_wait
 60a:	488d                	li	a7,3
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 612:	4891                	li	a7,4
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <read>:
.global read
read:
 li a7, SYS_read
 61a:	4895                	li	a7,5
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <write>:
.global write
write:
 li a7, SYS_write
 622:	48c1                	li	a7,16
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <close>:
.global close
close:
 li a7, SYS_close
 62a:	48d5                	li	a7,21
 ecall
 62c:	00000073          	ecall
 ret
 630:	8082                	ret

0000000000000632 <kill>:
.global kill
kill:
 li a7, SYS_kill
 632:	4899                	li	a7,6
 ecall
 634:	00000073          	ecall
 ret
 638:	8082                	ret

000000000000063a <exec>:
.global exec
exec:
 li a7, SYS_exec
 63a:	489d                	li	a7,7
 ecall
 63c:	00000073          	ecall
 ret
 640:	8082                	ret

0000000000000642 <open>:
.global open
open:
 li a7, SYS_open
 642:	48bd                	li	a7,15
 ecall
 644:	00000073          	ecall
 ret
 648:	8082                	ret

000000000000064a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 64a:	48c5                	li	a7,17
 ecall
 64c:	00000073          	ecall
 ret
 650:	8082                	ret

0000000000000652 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 652:	48c9                	li	a7,18
 ecall
 654:	00000073          	ecall
 ret
 658:	8082                	ret

000000000000065a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 65a:	48a1                	li	a7,8
 ecall
 65c:	00000073          	ecall
 ret
 660:	8082                	ret

0000000000000662 <link>:
.global link
link:
 li a7, SYS_link
 662:	48cd                	li	a7,19
 ecall
 664:	00000073          	ecall
 ret
 668:	8082                	ret

000000000000066a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 66a:	48d1                	li	a7,20
 ecall
 66c:	00000073          	ecall
 ret
 670:	8082                	ret

0000000000000672 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 672:	48a5                	li	a7,9
 ecall
 674:	00000073          	ecall
 ret
 678:	8082                	ret

000000000000067a <dup>:
.global dup
dup:
 li a7, SYS_dup
 67a:	48a9                	li	a7,10
 ecall
 67c:	00000073          	ecall
 ret
 680:	8082                	ret

0000000000000682 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 682:	48ad                	li	a7,11
 ecall
 684:	00000073          	ecall
 ret
 688:	8082                	ret

000000000000068a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 68a:	48b1                	li	a7,12
 ecall
 68c:	00000073          	ecall
 ret
 690:	8082                	ret

0000000000000692 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 692:	48b5                	li	a7,13
 ecall
 694:	00000073          	ecall
 ret
 698:	8082                	ret

000000000000069a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 69a:	48b9                	li	a7,14
 ecall
 69c:	00000073          	ecall
 ret
 6a0:	8082                	ret

00000000000006a2 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 6a2:	48dd                	li	a7,23
 ecall
 6a4:	00000073          	ecall
 ret
 6a8:	8082                	ret

00000000000006aa <statistics>:
.global statistics
statistics:
 li a7, SYS_statistics
 6aa:	48e1                	li	a7,24
 ecall
 6ac:	00000073          	ecall
 ret
 6b0:	8082                	ret

00000000000006b2 <reset_stats>:
.global reset_stats
reset_stats:
 li a7, SYS_reset_stats
 6b2:	48e5                	li	a7,25
 ecall
 6b4:	00000073          	ecall
 ret
 6b8:	8082                	ret

00000000000006ba <resetlockstats>:
.global resetlockstats
resetlockstats:
 li a7, SYS_resetlockstats
 6ba:	48e9                	li	a7,26
 ecall
 6bc:	00000073          	ecall
 ret
 6c0:	8082                	ret

00000000000006c2 <getlockstats>:
.global getlockstats
getlockstats:
 li a7, SYS_getlockstats
 6c2:	48ed                	li	a7,27
 ecall
 6c4:	00000073          	ecall
 ret
 6c8:	8082                	ret

00000000000006ca <trace>:
.global trace
trace:
 li a7, SYS_trace
 6ca:	48d9                	li	a7,22
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	8082                	ret

00000000000006d2 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 6d2:	48f1                	li	a7,28
 ecall
 6d4:	00000073          	ecall
 ret
 6d8:	8082                	ret

00000000000006da <ugetpid>:
.global ugetpid
ugetpid:
 li a7, SYS_ugetpid
 6da:	48f5                	li	a7,29
 ecall
 6dc:	00000073          	ecall
 ret
 6e0:	8082                	ret

00000000000006e2 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 6e2:	48f9                	li	a7,30
 ecall
 6e4:	00000073          	ecall
 ret
 6e8:	8082                	ret

00000000000006ea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6ea:	1101                	addi	sp,sp,-32
 6ec:	ec06                	sd	ra,24(sp)
 6ee:	e822                	sd	s0,16(sp)
 6f0:	1000                	addi	s0,sp,32
 6f2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6f6:	4605                	li	a2,1
 6f8:	fef40593          	addi	a1,s0,-17
 6fc:	f27ff0ef          	jal	622 <write>
}
 700:	60e2                	ld	ra,24(sp)
 702:	6442                	ld	s0,16(sp)
 704:	6105                	addi	sp,sp,32
 706:	8082                	ret

0000000000000708 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 708:	7139                	addi	sp,sp,-64
 70a:	fc06                	sd	ra,56(sp)
 70c:	f822                	sd	s0,48(sp)
 70e:	f426                	sd	s1,40(sp)
 710:	0080                	addi	s0,sp,64
 712:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 714:	c299                	beqz	a3,71a <printint+0x12>
 716:	0805c963          	bltz	a1,7a8 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 71a:	2581                	sext.w	a1,a1
  neg = 0;
 71c:	4881                	li	a7,0
 71e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 722:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 724:	2601                	sext.w	a2,a2
 726:	00000517          	auipc	a0,0x0
 72a:	57a50513          	addi	a0,a0,1402 # ca0 <digits>
 72e:	883a                	mv	a6,a4
 730:	2705                	addiw	a4,a4,1
 732:	02c5f7bb          	remuw	a5,a1,a2
 736:	1782                	slli	a5,a5,0x20
 738:	9381                	srli	a5,a5,0x20
 73a:	97aa                	add	a5,a5,a0
 73c:	0007c783          	lbu	a5,0(a5)
 740:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 744:	0005879b          	sext.w	a5,a1
 748:	02c5d5bb          	divuw	a1,a1,a2
 74c:	0685                	addi	a3,a3,1
 74e:	fec7f0e3          	bgeu	a5,a2,72e <printint+0x26>
  if(neg)
 752:	00088c63          	beqz	a7,76a <printint+0x62>
    buf[i++] = '-';
 756:	fd070793          	addi	a5,a4,-48
 75a:	00878733          	add	a4,a5,s0
 75e:	02d00793          	li	a5,45
 762:	fef70823          	sb	a5,-16(a4)
 766:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 76a:	02e05a63          	blez	a4,79e <printint+0x96>
 76e:	f04a                	sd	s2,32(sp)
 770:	ec4e                	sd	s3,24(sp)
 772:	fc040793          	addi	a5,s0,-64
 776:	00e78933          	add	s2,a5,a4
 77a:	fff78993          	addi	s3,a5,-1
 77e:	99ba                	add	s3,s3,a4
 780:	377d                	addiw	a4,a4,-1
 782:	1702                	slli	a4,a4,0x20
 784:	9301                	srli	a4,a4,0x20
 786:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 78a:	fff94583          	lbu	a1,-1(s2)
 78e:	8526                	mv	a0,s1
 790:	f5bff0ef          	jal	6ea <putc>
  while(--i >= 0)
 794:	197d                	addi	s2,s2,-1
 796:	ff391ae3          	bne	s2,s3,78a <printint+0x82>
 79a:	7902                	ld	s2,32(sp)
 79c:	69e2                	ld	s3,24(sp)
}
 79e:	70e2                	ld	ra,56(sp)
 7a0:	7442                	ld	s0,48(sp)
 7a2:	74a2                	ld	s1,40(sp)
 7a4:	6121                	addi	sp,sp,64
 7a6:	8082                	ret
    x = -xx;
 7a8:	40b005bb          	negw	a1,a1
    neg = 1;
 7ac:	4885                	li	a7,1
    x = -xx;
 7ae:	bf85                	j	71e <printint+0x16>

00000000000007b0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7b0:	711d                	addi	sp,sp,-96
 7b2:	ec86                	sd	ra,88(sp)
 7b4:	e8a2                	sd	s0,80(sp)
 7b6:	e0ca                	sd	s2,64(sp)
 7b8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7ba:	0005c903          	lbu	s2,0(a1)
 7be:	26090863          	beqz	s2,a2e <vprintf+0x27e>
 7c2:	e4a6                	sd	s1,72(sp)
 7c4:	fc4e                	sd	s3,56(sp)
 7c6:	f852                	sd	s4,48(sp)
 7c8:	f456                	sd	s5,40(sp)
 7ca:	f05a                	sd	s6,32(sp)
 7cc:	ec5e                	sd	s7,24(sp)
 7ce:	e862                	sd	s8,16(sp)
 7d0:	e466                	sd	s9,8(sp)
 7d2:	8b2a                	mv	s6,a0
 7d4:	8a2e                	mv	s4,a1
 7d6:	8bb2                	mv	s7,a2
  state = 0;
 7d8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 7da:	4481                	li	s1,0
 7dc:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 7de:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 7e2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 7e6:	06c00c93          	li	s9,108
 7ea:	a005                	j	80a <vprintf+0x5a>
        putc(fd, c0);
 7ec:	85ca                	mv	a1,s2
 7ee:	855a                	mv	a0,s6
 7f0:	efbff0ef          	jal	6ea <putc>
 7f4:	a019                	j	7fa <vprintf+0x4a>
    } else if(state == '%'){
 7f6:	03598263          	beq	s3,s5,81a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 7fa:	2485                	addiw	s1,s1,1
 7fc:	8726                	mv	a4,s1
 7fe:	009a07b3          	add	a5,s4,s1
 802:	0007c903          	lbu	s2,0(a5)
 806:	20090c63          	beqz	s2,a1e <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 80a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 80e:	fe0994e3          	bnez	s3,7f6 <vprintf+0x46>
      if(c0 == '%'){
 812:	fd579de3          	bne	a5,s5,7ec <vprintf+0x3c>
        state = '%';
 816:	89be                	mv	s3,a5
 818:	b7cd                	j	7fa <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 81a:	00ea06b3          	add	a3,s4,a4
 81e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 822:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 824:	c681                	beqz	a3,82c <vprintf+0x7c>
 826:	9752                	add	a4,a4,s4
 828:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 82c:	03878f63          	beq	a5,s8,86a <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 830:	05978963          	beq	a5,s9,882 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 834:	07500713          	li	a4,117
 838:	0ee78363          	beq	a5,a4,91e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 83c:	07800713          	li	a4,120
 840:	12e78563          	beq	a5,a4,96a <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 844:	07000713          	li	a4,112
 848:	14e78a63          	beq	a5,a4,99c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 84c:	07300713          	li	a4,115
 850:	18e78a63          	beq	a5,a4,9e4 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 854:	02500713          	li	a4,37
 858:	04e79563          	bne	a5,a4,8a2 <vprintf+0xf2>
        putc(fd, '%');
 85c:	02500593          	li	a1,37
 860:	855a                	mv	a0,s6
 862:	e89ff0ef          	jal	6ea <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 866:	4981                	li	s3,0
 868:	bf49                	j	7fa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 86a:	008b8913          	addi	s2,s7,8
 86e:	4685                	li	a3,1
 870:	4629                	li	a2,10
 872:	000ba583          	lw	a1,0(s7)
 876:	855a                	mv	a0,s6
 878:	e91ff0ef          	jal	708 <printint>
 87c:	8bca                	mv	s7,s2
      state = 0;
 87e:	4981                	li	s3,0
 880:	bfad                	j	7fa <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 882:	06400793          	li	a5,100
 886:	02f68963          	beq	a3,a5,8b8 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 88a:	06c00793          	li	a5,108
 88e:	04f68263          	beq	a3,a5,8d2 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 892:	07500793          	li	a5,117
 896:	0af68063          	beq	a3,a5,936 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 89a:	07800793          	li	a5,120
 89e:	0ef68263          	beq	a3,a5,982 <vprintf+0x1d2>
        putc(fd, '%');
 8a2:	02500593          	li	a1,37
 8a6:	855a                	mv	a0,s6
 8a8:	e43ff0ef          	jal	6ea <putc>
        putc(fd, c0);
 8ac:	85ca                	mv	a1,s2
 8ae:	855a                	mv	a0,s6
 8b0:	e3bff0ef          	jal	6ea <putc>
      state = 0;
 8b4:	4981                	li	s3,0
 8b6:	b791                	j	7fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8b8:	008b8913          	addi	s2,s7,8
 8bc:	4685                	li	a3,1
 8be:	4629                	li	a2,10
 8c0:	000ba583          	lw	a1,0(s7)
 8c4:	855a                	mv	a0,s6
 8c6:	e43ff0ef          	jal	708 <printint>
        i += 1;
 8ca:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 8cc:	8bca                	mv	s7,s2
      state = 0;
 8ce:	4981                	li	s3,0
        i += 1;
 8d0:	b72d                	j	7fa <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8d2:	06400793          	li	a5,100
 8d6:	02f60763          	beq	a2,a5,904 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8da:	07500793          	li	a5,117
 8de:	06f60963          	beq	a2,a5,950 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 8e2:	07800793          	li	a5,120
 8e6:	faf61ee3          	bne	a2,a5,8a2 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8ea:	008b8913          	addi	s2,s7,8
 8ee:	4681                	li	a3,0
 8f0:	4641                	li	a2,16
 8f2:	000ba583          	lw	a1,0(s7)
 8f6:	855a                	mv	a0,s6
 8f8:	e11ff0ef          	jal	708 <printint>
        i += 2;
 8fc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 8fe:	8bca                	mv	s7,s2
      state = 0;
 900:	4981                	li	s3,0
        i += 2;
 902:	bde5                	j	7fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 904:	008b8913          	addi	s2,s7,8
 908:	4685                	li	a3,1
 90a:	4629                	li	a2,10
 90c:	000ba583          	lw	a1,0(s7)
 910:	855a                	mv	a0,s6
 912:	df7ff0ef          	jal	708 <printint>
        i += 2;
 916:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 918:	8bca                	mv	s7,s2
      state = 0;
 91a:	4981                	li	s3,0
        i += 2;
 91c:	bdf9                	j	7fa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 91e:	008b8913          	addi	s2,s7,8
 922:	4681                	li	a3,0
 924:	4629                	li	a2,10
 926:	000ba583          	lw	a1,0(s7)
 92a:	855a                	mv	a0,s6
 92c:	dddff0ef          	jal	708 <printint>
 930:	8bca                	mv	s7,s2
      state = 0;
 932:	4981                	li	s3,0
 934:	b5d9                	j	7fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 936:	008b8913          	addi	s2,s7,8
 93a:	4681                	li	a3,0
 93c:	4629                	li	a2,10
 93e:	000ba583          	lw	a1,0(s7)
 942:	855a                	mv	a0,s6
 944:	dc5ff0ef          	jal	708 <printint>
        i += 1;
 948:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 94a:	8bca                	mv	s7,s2
      state = 0;
 94c:	4981                	li	s3,0
        i += 1;
 94e:	b575                	j	7fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 950:	008b8913          	addi	s2,s7,8
 954:	4681                	li	a3,0
 956:	4629                	li	a2,10
 958:	000ba583          	lw	a1,0(s7)
 95c:	855a                	mv	a0,s6
 95e:	dabff0ef          	jal	708 <printint>
        i += 2;
 962:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 964:	8bca                	mv	s7,s2
      state = 0;
 966:	4981                	li	s3,0
        i += 2;
 968:	bd49                	j	7fa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 96a:	008b8913          	addi	s2,s7,8
 96e:	4681                	li	a3,0
 970:	4641                	li	a2,16
 972:	000ba583          	lw	a1,0(s7)
 976:	855a                	mv	a0,s6
 978:	d91ff0ef          	jal	708 <printint>
 97c:	8bca                	mv	s7,s2
      state = 0;
 97e:	4981                	li	s3,0
 980:	bdad                	j	7fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 982:	008b8913          	addi	s2,s7,8
 986:	4681                	li	a3,0
 988:	4641                	li	a2,16
 98a:	000ba583          	lw	a1,0(s7)
 98e:	855a                	mv	a0,s6
 990:	d79ff0ef          	jal	708 <printint>
        i += 1;
 994:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 996:	8bca                	mv	s7,s2
      state = 0;
 998:	4981                	li	s3,0
        i += 1;
 99a:	b585                	j	7fa <vprintf+0x4a>
 99c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 99e:	008b8d13          	addi	s10,s7,8
 9a2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 9a6:	03000593          	li	a1,48
 9aa:	855a                	mv	a0,s6
 9ac:	d3fff0ef          	jal	6ea <putc>
  putc(fd, 'x');
 9b0:	07800593          	li	a1,120
 9b4:	855a                	mv	a0,s6
 9b6:	d35ff0ef          	jal	6ea <putc>
 9ba:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9bc:	00000b97          	auipc	s7,0x0
 9c0:	2e4b8b93          	addi	s7,s7,740 # ca0 <digits>
 9c4:	03c9d793          	srli	a5,s3,0x3c
 9c8:	97de                	add	a5,a5,s7
 9ca:	0007c583          	lbu	a1,0(a5)
 9ce:	855a                	mv	a0,s6
 9d0:	d1bff0ef          	jal	6ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9d4:	0992                	slli	s3,s3,0x4
 9d6:	397d                	addiw	s2,s2,-1
 9d8:	fe0916e3          	bnez	s2,9c4 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 9dc:	8bea                	mv	s7,s10
      state = 0;
 9de:	4981                	li	s3,0
 9e0:	6d02                	ld	s10,0(sp)
 9e2:	bd21                	j	7fa <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 9e4:	008b8993          	addi	s3,s7,8
 9e8:	000bb903          	ld	s2,0(s7)
 9ec:	00090f63          	beqz	s2,a0a <vprintf+0x25a>
        for(; *s; s++)
 9f0:	00094583          	lbu	a1,0(s2)
 9f4:	c195                	beqz	a1,a18 <vprintf+0x268>
          putc(fd, *s);
 9f6:	855a                	mv	a0,s6
 9f8:	cf3ff0ef          	jal	6ea <putc>
        for(; *s; s++)
 9fc:	0905                	addi	s2,s2,1
 9fe:	00094583          	lbu	a1,0(s2)
 a02:	f9f5                	bnez	a1,9f6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 a04:	8bce                	mv	s7,s3
      state = 0;
 a06:	4981                	li	s3,0
 a08:	bbcd                	j	7fa <vprintf+0x4a>
          s = "(null)";
 a0a:	00000917          	auipc	s2,0x0
 a0e:	28e90913          	addi	s2,s2,654 # c98 <malloc+0x182>
        for(; *s; s++)
 a12:	02800593          	li	a1,40
 a16:	b7c5                	j	9f6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 a18:	8bce                	mv	s7,s3
      state = 0;
 a1a:	4981                	li	s3,0
 a1c:	bbf9                	j	7fa <vprintf+0x4a>
 a1e:	64a6                	ld	s1,72(sp)
 a20:	79e2                	ld	s3,56(sp)
 a22:	7a42                	ld	s4,48(sp)
 a24:	7aa2                	ld	s5,40(sp)
 a26:	7b02                	ld	s6,32(sp)
 a28:	6be2                	ld	s7,24(sp)
 a2a:	6c42                	ld	s8,16(sp)
 a2c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 a2e:	60e6                	ld	ra,88(sp)
 a30:	6446                	ld	s0,80(sp)
 a32:	6906                	ld	s2,64(sp)
 a34:	6125                	addi	sp,sp,96
 a36:	8082                	ret

0000000000000a38 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a38:	715d                	addi	sp,sp,-80
 a3a:	ec06                	sd	ra,24(sp)
 a3c:	e822                	sd	s0,16(sp)
 a3e:	1000                	addi	s0,sp,32
 a40:	e010                	sd	a2,0(s0)
 a42:	e414                	sd	a3,8(s0)
 a44:	e818                	sd	a4,16(s0)
 a46:	ec1c                	sd	a5,24(s0)
 a48:	03043023          	sd	a6,32(s0)
 a4c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a50:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a54:	8622                	mv	a2,s0
 a56:	d5bff0ef          	jal	7b0 <vprintf>
}
 a5a:	60e2                	ld	ra,24(sp)
 a5c:	6442                	ld	s0,16(sp)
 a5e:	6161                	addi	sp,sp,80
 a60:	8082                	ret

0000000000000a62 <printf>:

void
printf(const char *fmt, ...)
{
 a62:	711d                	addi	sp,sp,-96
 a64:	ec06                	sd	ra,24(sp)
 a66:	e822                	sd	s0,16(sp)
 a68:	1000                	addi	s0,sp,32
 a6a:	e40c                	sd	a1,8(s0)
 a6c:	e810                	sd	a2,16(s0)
 a6e:	ec14                	sd	a3,24(s0)
 a70:	f018                	sd	a4,32(s0)
 a72:	f41c                	sd	a5,40(s0)
 a74:	03043823          	sd	a6,48(s0)
 a78:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a7c:	00840613          	addi	a2,s0,8
 a80:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a84:	85aa                	mv	a1,a0
 a86:	4505                	li	a0,1
 a88:	d29ff0ef          	jal	7b0 <vprintf>
}
 a8c:	60e2                	ld	ra,24(sp)
 a8e:	6442                	ld	s0,16(sp)
 a90:	6125                	addi	sp,sp,96
 a92:	8082                	ret

0000000000000a94 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a94:	1141                	addi	sp,sp,-16
 a96:	e422                	sd	s0,8(sp)
 a98:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a9a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a9e:	00001797          	auipc	a5,0x1
 aa2:	5627b783          	ld	a5,1378(a5) # 2000 <freep>
 aa6:	a02d                	j	ad0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 aa8:	4618                	lw	a4,8(a2)
 aaa:	9f2d                	addw	a4,a4,a1
 aac:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 ab0:	6398                	ld	a4,0(a5)
 ab2:	6310                	ld	a2,0(a4)
 ab4:	a83d                	j	af2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ab6:	ff852703          	lw	a4,-8(a0)
 aba:	9f31                	addw	a4,a4,a2
 abc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 abe:	ff053683          	ld	a3,-16(a0)
 ac2:	a091                	j	b06 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ac4:	6398                	ld	a4,0(a5)
 ac6:	00e7e463          	bltu	a5,a4,ace <free+0x3a>
 aca:	00e6ea63          	bltu	a3,a4,ade <free+0x4a>
{
 ace:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ad0:	fed7fae3          	bgeu	a5,a3,ac4 <free+0x30>
 ad4:	6398                	ld	a4,0(a5)
 ad6:	00e6e463          	bltu	a3,a4,ade <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ada:	fee7eae3          	bltu	a5,a4,ace <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 ade:	ff852583          	lw	a1,-8(a0)
 ae2:	6390                	ld	a2,0(a5)
 ae4:	02059813          	slli	a6,a1,0x20
 ae8:	01c85713          	srli	a4,a6,0x1c
 aec:	9736                	add	a4,a4,a3
 aee:	fae60de3          	beq	a2,a4,aa8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 af2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 af6:	4790                	lw	a2,8(a5)
 af8:	02061593          	slli	a1,a2,0x20
 afc:	01c5d713          	srli	a4,a1,0x1c
 b00:	973e                	add	a4,a4,a5
 b02:	fae68ae3          	beq	a3,a4,ab6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 b06:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b08:	00001717          	auipc	a4,0x1
 b0c:	4ef73c23          	sd	a5,1272(a4) # 2000 <freep>
}
 b10:	6422                	ld	s0,8(sp)
 b12:	0141                	addi	sp,sp,16
 b14:	8082                	ret

0000000000000b16 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b16:	7139                	addi	sp,sp,-64
 b18:	fc06                	sd	ra,56(sp)
 b1a:	f822                	sd	s0,48(sp)
 b1c:	f426                	sd	s1,40(sp)
 b1e:	ec4e                	sd	s3,24(sp)
 b20:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b22:	02051493          	slli	s1,a0,0x20
 b26:	9081                	srli	s1,s1,0x20
 b28:	04bd                	addi	s1,s1,15
 b2a:	8091                	srli	s1,s1,0x4
 b2c:	0014899b          	addiw	s3,s1,1
 b30:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b32:	00001517          	auipc	a0,0x1
 b36:	4ce53503          	ld	a0,1230(a0) # 2000 <freep>
 b3a:	c915                	beqz	a0,b6e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b3c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b3e:	4798                	lw	a4,8(a5)
 b40:	08977a63          	bgeu	a4,s1,bd4 <malloc+0xbe>
 b44:	f04a                	sd	s2,32(sp)
 b46:	e852                	sd	s4,16(sp)
 b48:	e456                	sd	s5,8(sp)
 b4a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 b4c:	8a4e                	mv	s4,s3
 b4e:	0009871b          	sext.w	a4,s3
 b52:	6685                	lui	a3,0x1
 b54:	00d77363          	bgeu	a4,a3,b5a <malloc+0x44>
 b58:	6a05                	lui	s4,0x1
 b5a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b5e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b62:	00001917          	auipc	s2,0x1
 b66:	49e90913          	addi	s2,s2,1182 # 2000 <freep>
  if(p == (char*)-1)
 b6a:	5afd                	li	s5,-1
 b6c:	a081                	j	bac <malloc+0x96>
 b6e:	f04a                	sd	s2,32(sp)
 b70:	e852                	sd	s4,16(sp)
 b72:	e456                	sd	s5,8(sp)
 b74:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b76:	00001797          	auipc	a5,0x1
 b7a:	4aa78793          	addi	a5,a5,1194 # 2020 <base>
 b7e:	00001717          	auipc	a4,0x1
 b82:	48f73123          	sd	a5,1154(a4) # 2000 <freep>
 b86:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b88:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b8c:	b7c1                	j	b4c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 b8e:	6398                	ld	a4,0(a5)
 b90:	e118                	sd	a4,0(a0)
 b92:	a8a9                	j	bec <malloc+0xd6>
  hp->s.size = nu;
 b94:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b98:	0541                	addi	a0,a0,16
 b9a:	efbff0ef          	jal	a94 <free>
  return freep;
 b9e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 ba2:	c12d                	beqz	a0,c04 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ba4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ba6:	4798                	lw	a4,8(a5)
 ba8:	02977263          	bgeu	a4,s1,bcc <malloc+0xb6>
    if(p == freep)
 bac:	00093703          	ld	a4,0(s2)
 bb0:	853e                	mv	a0,a5
 bb2:	fef719e3          	bne	a4,a5,ba4 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 bb6:	8552                	mv	a0,s4
 bb8:	ad3ff0ef          	jal	68a <sbrk>
  if(p == (char*)-1)
 bbc:	fd551ce3          	bne	a0,s5,b94 <malloc+0x7e>
        return 0;
 bc0:	4501                	li	a0,0
 bc2:	7902                	ld	s2,32(sp)
 bc4:	6a42                	ld	s4,16(sp)
 bc6:	6aa2                	ld	s5,8(sp)
 bc8:	6b02                	ld	s6,0(sp)
 bca:	a03d                	j	bf8 <malloc+0xe2>
 bcc:	7902                	ld	s2,32(sp)
 bce:	6a42                	ld	s4,16(sp)
 bd0:	6aa2                	ld	s5,8(sp)
 bd2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 bd4:	fae48de3          	beq	s1,a4,b8e <malloc+0x78>
        p->s.size -= nunits;
 bd8:	4137073b          	subw	a4,a4,s3
 bdc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 bde:	02071693          	slli	a3,a4,0x20
 be2:	01c6d713          	srli	a4,a3,0x1c
 be6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 be8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bec:	00001717          	auipc	a4,0x1
 bf0:	40a73a23          	sd	a0,1044(a4) # 2000 <freep>
      return (void*)(p + 1);
 bf4:	01078513          	addi	a0,a5,16
  }
}
 bf8:	70e2                	ld	ra,56(sp)
 bfa:	7442                	ld	s0,48(sp)
 bfc:	74a2                	ld	s1,40(sp)
 bfe:	69e2                	ld	s3,24(sp)
 c00:	6121                	addi	sp,sp,64
 c02:	8082                	ret
 c04:	7902                	ld	s2,32(sp)
 c06:	6a42                	ld	s4,16(sp)
 c08:	6aa2                	ld	s5,8(sp)
 c0a:	6b02                	ld	s6,0(sp)
 c0c:	b7f5                	j	bf8 <malloc+0xe2>
