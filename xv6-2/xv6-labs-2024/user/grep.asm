
user/_grep：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	02c000ef          	jal	4a <matchhere>
  22:	e919                	bnez	a0,38 <matchstar+0x38>
  }while(*text!='\0' && (*text++==c || c=='.'));
  24:	0004c783          	lbu	a5,0(s1)
  28:	cb89                	beqz	a5,3a <matchstar+0x3a>
  2a:	0485                	addi	s1,s1,1
  2c:	2781                	sext.w	a5,a5
  2e:	ff2786e3          	beq	a5,s2,1a <matchstar+0x1a>
  32:	ff4904e3          	beq	s2,s4,1a <matchstar+0x1a>
  36:	a011                	j	3a <matchstar+0x3a>
      return 1;
  38:	4505                	li	a0,1
  return 0;
}
  3a:	70a2                	ld	ra,40(sp)
  3c:	7402                	ld	s0,32(sp)
  3e:	64e2                	ld	s1,24(sp)
  40:	6942                	ld	s2,16(sp)
  42:	69a2                	ld	s3,8(sp)
  44:	6a02                	ld	s4,0(sp)
  46:	6145                	addi	sp,sp,48
  48:	8082                	ret

000000000000004a <matchhere>:
  if(re[0] == '\0')
  4a:	00054703          	lbu	a4,0(a0)
  4e:	c73d                	beqz	a4,bc <matchhere+0x72>
{
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  58:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5a:	00154683          	lbu	a3,1(a0)
  5e:	02a00613          	li	a2,42
  62:	02c68563          	beq	a3,a2,8c <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  66:	02400613          	li	a2,36
  6a:	02c70863          	beq	a4,a2,9a <matchhere+0x50>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  6e:	0005c683          	lbu	a3,0(a1)
  return 0;
  72:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  74:	ca81                	beqz	a3,84 <matchhere+0x3a>
  76:	02e00613          	li	a2,46
  7a:	02c70b63          	beq	a4,a2,b0 <matchhere+0x66>
  return 0;
  7e:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  80:	02d70863          	beq	a4,a3,b0 <matchhere+0x66>
}
  84:	60a2                	ld	ra,8(sp)
  86:	6402                	ld	s0,0(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret
    return matchstar(re[0], re+2, text);
  8c:	862e                	mv	a2,a1
  8e:	00250593          	addi	a1,a0,2
  92:	853a                	mv	a0,a4
  94:	f6dff0ef          	jal	0 <matchstar>
  98:	b7f5                	j	84 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  9a:	c691                	beqz	a3,a6 <matchhere+0x5c>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  9c:	0005c683          	lbu	a3,0(a1)
  a0:	fef9                	bnez	a3,7e <matchhere+0x34>
  return 0;
  a2:	4501                	li	a0,0
  a4:	b7c5                	j	84 <matchhere+0x3a>
    return *text == '\0';
  a6:	0005c503          	lbu	a0,0(a1)
  aa:	00153513          	seqz	a0,a0
  ae:	bfd9                	j	84 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b0:	0585                	addi	a1,a1,1
  b2:	00178513          	addi	a0,a5,1
  b6:	f95ff0ef          	jal	4a <matchhere>
  ba:	b7e9                	j	84 <matchhere+0x3a>
    return 1;
  bc:	4505                	li	a0,1
}
  be:	8082                	ret

00000000000000c0 <match>:
{
  c0:	1101                	addi	sp,sp,-32
  c2:	ec06                	sd	ra,24(sp)
  c4:	e822                	sd	s0,16(sp)
  c6:	e426                	sd	s1,8(sp)
  c8:	e04a                	sd	s2,0(sp)
  ca:	1000                	addi	s0,sp,32
  cc:	892a                	mv	s2,a0
  ce:	84ae                	mv	s1,a1
  if(re[0] == '^')
  d0:	00054703          	lbu	a4,0(a0)
  d4:	05e00793          	li	a5,94
  d8:	00f70c63          	beq	a4,a5,f0 <match+0x30>
    if(matchhere(re, text))
  dc:	85a6                	mv	a1,s1
  de:	854a                	mv	a0,s2
  e0:	f6bff0ef          	jal	4a <matchhere>
  e4:	e911                	bnez	a0,f8 <match+0x38>
  }while(*text++ != '\0');
  e6:	0485                	addi	s1,s1,1
  e8:	fff4c783          	lbu	a5,-1(s1)
  ec:	fbe5                	bnez	a5,dc <match+0x1c>
  ee:	a031                	j	fa <match+0x3a>
    return matchhere(re+1, text);
  f0:	0505                	addi	a0,a0,1
  f2:	f59ff0ef          	jal	4a <matchhere>
  f6:	a011                	j	fa <match+0x3a>
      return 1;
  f8:	4505                	li	a0,1
}
  fa:	60e2                	ld	ra,24(sp)
  fc:	6442                	ld	s0,16(sp)
  fe:	64a2                	ld	s1,8(sp)
 100:	6902                	ld	s2,0(sp)
 102:	6105                	addi	sp,sp,32
 104:	8082                	ret

0000000000000106 <grep>:
{
 106:	715d                	addi	sp,sp,-80
 108:	e486                	sd	ra,72(sp)
 10a:	e0a2                	sd	s0,64(sp)
 10c:	fc26                	sd	s1,56(sp)
 10e:	f84a                	sd	s2,48(sp)
 110:	f44e                	sd	s3,40(sp)
 112:	f052                	sd	s4,32(sp)
 114:	ec56                	sd	s5,24(sp)
 116:	e85a                	sd	s6,16(sp)
 118:	e45e                	sd	s7,8(sp)
 11a:	e062                	sd	s8,0(sp)
 11c:	0880                	addi	s0,sp,80
 11e:	89aa                	mv	s3,a0
 120:	8b2e                	mv	s6,a1
  m = 0;
 122:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 124:	3ff00b93          	li	s7,1023
 128:	00002a97          	auipc	s5,0x2
 12c:	ee8a8a93          	addi	s5,s5,-280 # 2010 <buf>
 130:	a835                	j	16c <grep+0x66>
      p = q+1;
 132:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 136:	45a9                	li	a1,10
 138:	854a                	mv	a0,s2
 13a:	1fc000ef          	jal	336 <strchr>
 13e:	84aa                	mv	s1,a0
 140:	c505                	beqz	a0,168 <grep+0x62>
      *q = 0;
 142:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 146:	85ca                	mv	a1,s2
 148:	854e                	mv	a0,s3
 14a:	f77ff0ef          	jal	c0 <match>
 14e:	d175                	beqz	a0,132 <grep+0x2c>
        *q = '\n';
 150:	47a9                	li	a5,10
 152:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 156:	00148613          	addi	a2,s1,1
 15a:	4126063b          	subw	a2,a2,s2
 15e:	85ca                	mv	a1,s2
 160:	4505                	li	a0,1
 162:	4b2000ef          	jal	614 <write>
 166:	b7f1                	j	132 <grep+0x2c>
    if(m > 0){
 168:	03404563          	bgtz	s4,192 <grep+0x8c>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 16c:	414b863b          	subw	a2,s7,s4
 170:	014a85b3          	add	a1,s5,s4
 174:	855a                	mv	a0,s6
 176:	496000ef          	jal	60c <read>
 17a:	02a05963          	blez	a0,1ac <grep+0xa6>
    m += n;
 17e:	00aa0c3b          	addw	s8,s4,a0
 182:	000c0a1b          	sext.w	s4,s8
    buf[m] = '\0';
 186:	014a87b3          	add	a5,s5,s4
 18a:	00078023          	sb	zero,0(a5)
    p = buf;
 18e:	8956                	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
 190:	b75d                	j	136 <grep+0x30>
      m -= p - buf;
 192:	00002517          	auipc	a0,0x2
 196:	e7e50513          	addi	a0,a0,-386 # 2010 <buf>
 19a:	40a90a33          	sub	s4,s2,a0
 19e:	414c0a3b          	subw	s4,s8,s4
      memmove(buf, p, m);
 1a2:	8652                	mv	a2,s4
 1a4:	85ca                	mv	a1,s2
 1a6:	2a6000ef          	jal	44c <memmove>
 1aa:	b7c9                	j	16c <grep+0x66>
}
 1ac:	60a6                	ld	ra,72(sp)
 1ae:	6406                	ld	s0,64(sp)
 1b0:	74e2                	ld	s1,56(sp)
 1b2:	7942                	ld	s2,48(sp)
 1b4:	79a2                	ld	s3,40(sp)
 1b6:	7a02                	ld	s4,32(sp)
 1b8:	6ae2                	ld	s5,24(sp)
 1ba:	6b42                	ld	s6,16(sp)
 1bc:	6ba2                	ld	s7,8(sp)
 1be:	6c02                	ld	s8,0(sp)
 1c0:	6161                	addi	sp,sp,80
 1c2:	8082                	ret

00000000000001c4 <main>:
{
 1c4:	7179                	addi	sp,sp,-48
 1c6:	f406                	sd	ra,40(sp)
 1c8:	f022                	sd	s0,32(sp)
 1ca:	ec26                	sd	s1,24(sp)
 1cc:	e84a                	sd	s2,16(sp)
 1ce:	e44e                	sd	s3,8(sp)
 1d0:	e052                	sd	s4,0(sp)
 1d2:	1800                	addi	s0,sp,48
  if(argc <= 1){
 1d4:	4785                	li	a5,1
 1d6:	04a7d663          	bge	a5,a0,222 <main+0x5e>
  pattern = argv[1];
 1da:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 1de:	4789                	li	a5,2
 1e0:	04a7db63          	bge	a5,a0,236 <main+0x72>
 1e4:	01058913          	addi	s2,a1,16
 1e8:	ffd5099b          	addiw	s3,a0,-3
 1ec:	02099793          	slli	a5,s3,0x20
 1f0:	01d7d993          	srli	s3,a5,0x1d
 1f4:	05e1                	addi	a1,a1,24
 1f6:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], O_RDONLY)) < 0){
 1f8:	4581                	li	a1,0
 1fa:	00093503          	ld	a0,0(s2)
 1fe:	436000ef          	jal	634 <open>
 202:	84aa                	mv	s1,a0
 204:	04054063          	bltz	a0,244 <main+0x80>
    grep(pattern, fd);
 208:	85aa                	mv	a1,a0
 20a:	8552                	mv	a0,s4
 20c:	efbff0ef          	jal	106 <grep>
    close(fd);
 210:	8526                	mv	a0,s1
 212:	40a000ef          	jal	61c <close>
  for(i = 2; i < argc; i++){
 216:	0921                	addi	s2,s2,8
 218:	ff3910e3          	bne	s2,s3,1f8 <main+0x34>
  exit(0);
 21c:	4501                	li	a0,0
 21e:	3d6000ef          	jal	5f4 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 222:	00001597          	auipc	a1,0x1
 226:	9de58593          	addi	a1,a1,-1570 # c00 <malloc+0xf8>
 22a:	4509                	li	a0,2
 22c:	7fe000ef          	jal	a2a <fprintf>
    exit(1);
 230:	4505                	li	a0,1
 232:	3c2000ef          	jal	5f4 <exit>
    grep(pattern, 0);
 236:	4581                	li	a1,0
 238:	8552                	mv	a0,s4
 23a:	ecdff0ef          	jal	106 <grep>
    exit(0);
 23e:	4501                	li	a0,0
 240:	3b4000ef          	jal	5f4 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 244:	00093583          	ld	a1,0(s2)
 248:	00001517          	auipc	a0,0x1
 24c:	9d850513          	addi	a0,a0,-1576 # c20 <malloc+0x118>
 250:	005000ef          	jal	a54 <printf>
      exit(1);
 254:	4505                	li	a0,1
 256:	39e000ef          	jal	5f4 <exit>

000000000000025a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 25a:	1141                	addi	sp,sp,-16
 25c:	e406                	sd	ra,8(sp)
 25e:	e022                	sd	s0,0(sp)
 260:	0800                	addi	s0,sp,16
  extern int main();
  main();
 262:	f63ff0ef          	jal	1c4 <main>
  exit(0);
 266:	4501                	li	a0,0
 268:	38c000ef          	jal	5f4 <exit>

000000000000026c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 272:	87aa                	mv	a5,a0
 274:	0585                	addi	a1,a1,1
 276:	0785                	addi	a5,a5,1
 278:	fff5c703          	lbu	a4,-1(a1)
 27c:	fee78fa3          	sb	a4,-1(a5)
 280:	fb75                	bnez	a4,274 <strcpy+0x8>
    ;
  return os;
}
 282:	6422                	ld	s0,8(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret

0000000000000288 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e422                	sd	s0,8(sp)
 28c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 28e:	00054783          	lbu	a5,0(a0)
 292:	cb91                	beqz	a5,2a6 <strcmp+0x1e>
 294:	0005c703          	lbu	a4,0(a1)
 298:	00f71763          	bne	a4,a5,2a6 <strcmp+0x1e>
    p++, q++;
 29c:	0505                	addi	a0,a0,1
 29e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	fbe5                	bnez	a5,294 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2a6:	0005c503          	lbu	a0,0(a1)
}
 2aa:	40a7853b          	subw	a0,a5,a0
 2ae:	6422                	ld	s0,8(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret

00000000000002b4 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e422                	sd	s0,8(sp)
 2b8:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q) {
 2ba:	ce11                	beqz	a2,2d6 <strncmp+0x22>
 2bc:	00054783          	lbu	a5,0(a0)
 2c0:	cf89                	beqz	a5,2da <strncmp+0x26>
 2c2:	0005c703          	lbu	a4,0(a1)
 2c6:	00f71a63          	bne	a4,a5,2da <strncmp+0x26>
    n--;
 2ca:	367d                	addiw	a2,a2,-1
    p++;
 2cc:	0505                	addi	a0,a0,1
    q++;
 2ce:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q) {
 2d0:	f675                	bnez	a2,2bc <strncmp+0x8>
  }
  if(n == 0)
    return 0;
 2d2:	4501                	li	a0,0
 2d4:	a801                	j	2e4 <strncmp+0x30>
 2d6:	4501                	li	a0,0
 2d8:	a031                	j	2e4 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
 2da:	00054503          	lbu	a0,0(a0)
 2de:	0005c783          	lbu	a5,0(a1)
 2e2:	9d1d                	subw	a0,a0,a5
}
 2e4:	6422                	ld	s0,8(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <strlen>:

uint
strlen(const char *s)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e422                	sd	s0,8(sp)
 2ee:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2f0:	00054783          	lbu	a5,0(a0)
 2f4:	cf91                	beqz	a5,310 <strlen+0x26>
 2f6:	0505                	addi	a0,a0,1
 2f8:	87aa                	mv	a5,a0
 2fa:	86be                	mv	a3,a5
 2fc:	0785                	addi	a5,a5,1
 2fe:	fff7c703          	lbu	a4,-1(a5)
 302:	ff65                	bnez	a4,2fa <strlen+0x10>
 304:	40a6853b          	subw	a0,a3,a0
 308:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 30a:	6422                	ld	s0,8(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret
  for(n = 0; s[n]; n++)
 310:	4501                	li	a0,0
 312:	bfe5                	j	30a <strlen+0x20>

0000000000000314 <memset>:

void*
memset(void *dst, int c, uint n)
{
 314:	1141                	addi	sp,sp,-16
 316:	e422                	sd	s0,8(sp)
 318:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 31a:	ca19                	beqz	a2,330 <memset+0x1c>
 31c:	87aa                	mv	a5,a0
 31e:	1602                	slli	a2,a2,0x20
 320:	9201                	srli	a2,a2,0x20
 322:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 326:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 32a:	0785                	addi	a5,a5,1
 32c:	fee79de3          	bne	a5,a4,326 <memset+0x12>
  }
  return dst;
}
 330:	6422                	ld	s0,8(sp)
 332:	0141                	addi	sp,sp,16
 334:	8082                	ret

0000000000000336 <strchr>:

char*
strchr(const char *s, char c)
{
 336:	1141                	addi	sp,sp,-16
 338:	e422                	sd	s0,8(sp)
 33a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 33c:	00054783          	lbu	a5,0(a0)
 340:	cb99                	beqz	a5,356 <strchr+0x20>
    if(*s == c)
 342:	00f58763          	beq	a1,a5,350 <strchr+0x1a>
  for(; *s; s++)
 346:	0505                	addi	a0,a0,1
 348:	00054783          	lbu	a5,0(a0)
 34c:	fbfd                	bnez	a5,342 <strchr+0xc>
      return (char*)s;
  return 0;
 34e:	4501                	li	a0,0
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret
  return 0;
 356:	4501                	li	a0,0
 358:	bfe5                	j	350 <strchr+0x1a>

000000000000035a <gets>:

char*
gets(char *buf, int max)
{
 35a:	711d                	addi	sp,sp,-96
 35c:	ec86                	sd	ra,88(sp)
 35e:	e8a2                	sd	s0,80(sp)
 360:	e4a6                	sd	s1,72(sp)
 362:	e0ca                	sd	s2,64(sp)
 364:	fc4e                	sd	s3,56(sp)
 366:	f852                	sd	s4,48(sp)
 368:	f456                	sd	s5,40(sp)
 36a:	f05a                	sd	s6,32(sp)
 36c:	ec5e                	sd	s7,24(sp)
 36e:	1080                	addi	s0,sp,96
 370:	8baa                	mv	s7,a0
 372:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 374:	892a                	mv	s2,a0
 376:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 378:	4aa9                	li	s5,10
 37a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 37c:	89a6                	mv	s3,s1
 37e:	2485                	addiw	s1,s1,1
 380:	0344d663          	bge	s1,s4,3ac <gets+0x52>
    cc = read(0, &c, 1);
 384:	4605                	li	a2,1
 386:	faf40593          	addi	a1,s0,-81
 38a:	4501                	li	a0,0
 38c:	280000ef          	jal	60c <read>
    if(cc < 1)
 390:	00a05e63          	blez	a0,3ac <gets+0x52>
    buf[i++] = c;
 394:	faf44783          	lbu	a5,-81(s0)
 398:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 39c:	01578763          	beq	a5,s5,3aa <gets+0x50>
 3a0:	0905                	addi	s2,s2,1
 3a2:	fd679de3          	bne	a5,s6,37c <gets+0x22>
    buf[i++] = c;
 3a6:	89a6                	mv	s3,s1
 3a8:	a011                	j	3ac <gets+0x52>
 3aa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3ac:	99de                	add	s3,s3,s7
 3ae:	00098023          	sb	zero,0(s3)
  return buf;
}
 3b2:	855e                	mv	a0,s7
 3b4:	60e6                	ld	ra,88(sp)
 3b6:	6446                	ld	s0,80(sp)
 3b8:	64a6                	ld	s1,72(sp)
 3ba:	6906                	ld	s2,64(sp)
 3bc:	79e2                	ld	s3,56(sp)
 3be:	7a42                	ld	s4,48(sp)
 3c0:	7aa2                	ld	s5,40(sp)
 3c2:	7b02                	ld	s6,32(sp)
 3c4:	6be2                	ld	s7,24(sp)
 3c6:	6125                	addi	sp,sp,96
 3c8:	8082                	ret

00000000000003ca <stat>:

int
stat(const char *n, struct stat *st)
{
 3ca:	1101                	addi	sp,sp,-32
 3cc:	ec06                	sd	ra,24(sp)
 3ce:	e822                	sd	s0,16(sp)
 3d0:	e04a                	sd	s2,0(sp)
 3d2:	1000                	addi	s0,sp,32
 3d4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3d6:	4581                	li	a1,0
 3d8:	25c000ef          	jal	634 <open>
  if(fd < 0)
 3dc:	02054263          	bltz	a0,400 <stat+0x36>
 3e0:	e426                	sd	s1,8(sp)
 3e2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3e4:	85ca                	mv	a1,s2
 3e6:	266000ef          	jal	64c <fstat>
 3ea:	892a                	mv	s2,a0
  close(fd);
 3ec:	8526                	mv	a0,s1
 3ee:	22e000ef          	jal	61c <close>
  return r;
 3f2:	64a2                	ld	s1,8(sp)
}
 3f4:	854a                	mv	a0,s2
 3f6:	60e2                	ld	ra,24(sp)
 3f8:	6442                	ld	s0,16(sp)
 3fa:	6902                	ld	s2,0(sp)
 3fc:	6105                	addi	sp,sp,32
 3fe:	8082                	ret
    return -1;
 400:	597d                	li	s2,-1
 402:	bfcd                	j	3f4 <stat+0x2a>

0000000000000404 <atoi>:

int
atoi(const char *s)
{
 404:	1141                	addi	sp,sp,-16
 406:	e422                	sd	s0,8(sp)
 408:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 40a:	00054683          	lbu	a3,0(a0)
 40e:	fd06879b          	addiw	a5,a3,-48
 412:	0ff7f793          	zext.b	a5,a5
 416:	4625                	li	a2,9
 418:	02f66863          	bltu	a2,a5,448 <atoi+0x44>
 41c:	872a                	mv	a4,a0
  n = 0;
 41e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 420:	0705                	addi	a4,a4,1
 422:	0025179b          	slliw	a5,a0,0x2
 426:	9fa9                	addw	a5,a5,a0
 428:	0017979b          	slliw	a5,a5,0x1
 42c:	9fb5                	addw	a5,a5,a3
 42e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 432:	00074683          	lbu	a3,0(a4)
 436:	fd06879b          	addiw	a5,a3,-48
 43a:	0ff7f793          	zext.b	a5,a5
 43e:	fef671e3          	bgeu	a2,a5,420 <atoi+0x1c>
  return n;
}
 442:	6422                	ld	s0,8(sp)
 444:	0141                	addi	sp,sp,16
 446:	8082                	ret
  n = 0;
 448:	4501                	li	a0,0
 44a:	bfe5                	j	442 <atoi+0x3e>

000000000000044c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 44c:	1141                	addi	sp,sp,-16
 44e:	e422                	sd	s0,8(sp)
 450:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 452:	02b57463          	bgeu	a0,a1,47a <memmove+0x2e>
    while(n-- > 0)
 456:	00c05f63          	blez	a2,474 <memmove+0x28>
 45a:	1602                	slli	a2,a2,0x20
 45c:	9201                	srli	a2,a2,0x20
 45e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 462:	872a                	mv	a4,a0
      *dst++ = *src++;
 464:	0585                	addi	a1,a1,1
 466:	0705                	addi	a4,a4,1
 468:	fff5c683          	lbu	a3,-1(a1)
 46c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 470:	fef71ae3          	bne	a4,a5,464 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 474:	6422                	ld	s0,8(sp)
 476:	0141                	addi	sp,sp,16
 478:	8082                	ret
    dst += n;
 47a:	00c50733          	add	a4,a0,a2
    src += n;
 47e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 480:	fec05ae3          	blez	a2,474 <memmove+0x28>
 484:	fff6079b          	addiw	a5,a2,-1
 488:	1782                	slli	a5,a5,0x20
 48a:	9381                	srli	a5,a5,0x20
 48c:	fff7c793          	not	a5,a5
 490:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 492:	15fd                	addi	a1,a1,-1
 494:	177d                	addi	a4,a4,-1
 496:	0005c683          	lbu	a3,0(a1)
 49a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 49e:	fee79ae3          	bne	a5,a4,492 <memmove+0x46>
 4a2:	bfc9                	j	474 <memmove+0x28>

00000000000004a4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4a4:	1141                	addi	sp,sp,-16
 4a6:	e422                	sd	s0,8(sp)
 4a8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4aa:	ca05                	beqz	a2,4da <memcmp+0x36>
 4ac:	fff6069b          	addiw	a3,a2,-1
 4b0:	1682                	slli	a3,a3,0x20
 4b2:	9281                	srli	a3,a3,0x20
 4b4:	0685                	addi	a3,a3,1
 4b6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4b8:	00054783          	lbu	a5,0(a0)
 4bc:	0005c703          	lbu	a4,0(a1)
 4c0:	00e79863          	bne	a5,a4,4d0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4c4:	0505                	addi	a0,a0,1
    p2++;
 4c6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4c8:	fed518e3          	bne	a0,a3,4b8 <memcmp+0x14>
  }
  return 0;
 4cc:	4501                	li	a0,0
 4ce:	a019                	j	4d4 <memcmp+0x30>
      return *p1 - *p2;
 4d0:	40e7853b          	subw	a0,a5,a4
}
 4d4:	6422                	ld	s0,8(sp)
 4d6:	0141                	addi	sp,sp,16
 4d8:	8082                	ret
  return 0;
 4da:	4501                	li	a0,0
 4dc:	bfe5                	j	4d4 <memcmp+0x30>

00000000000004de <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4de:	1141                	addi	sp,sp,-16
 4e0:	e406                	sd	ra,8(sp)
 4e2:	e022                	sd	s0,0(sp)
 4e4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4e6:	f67ff0ef          	jal	44c <memmove>
}
 4ea:	60a2                	ld	ra,8(sp)
 4ec:	6402                	ld	s0,0(sp)
 4ee:	0141                	addi	sp,sp,16
 4f0:	8082                	ret

00000000000004f2 <simplesort>:

void
simplesort(void *base, uint nmemb, uint size, int (*compar)(const void *, const void *))
{
 4f2:	7119                	addi	sp,sp,-128
 4f4:	fc86                	sd	ra,120(sp)
 4f6:	f8a2                	sd	s0,112(sp)
 4f8:	0100                	addi	s0,sp,128
 4fa:	f8b43423          	sd	a1,-120(s0)
  char *arr = (char *)base; // Treat array as char array for byte-level manipulation
  char *temp;               // Temporary storage for an element

  if (nmemb <= 1 || size == 0) {
 4fe:	4785                	li	a5,1
 500:	00b7fc63          	bgeu	a5,a1,518 <simplesort+0x26>
 504:	e8d2                	sd	s4,80(sp)
 506:	e4d6                	sd	s5,72(sp)
 508:	f466                	sd	s9,40(sp)
 50a:	8aaa                	mv	s5,a0
 50c:	8a32                	mv	s4,a2
 50e:	8cb6                	mv	s9,a3
 510:	ea01                	bnez	a2,520 <simplesort+0x2e>
 512:	6a46                	ld	s4,80(sp)
 514:	6aa6                	ld	s5,72(sp)
 516:	7ca2                	ld	s9,40(sp)
    // Place temp at its correct position
    memmove(arr + j * size, temp, size);
  }

  free(temp); // Free temporary space
 518:	70e6                	ld	ra,120(sp)
 51a:	7446                	ld	s0,112(sp)
 51c:	6109                	addi	sp,sp,128
 51e:	8082                	ret
 520:	fc5e                	sd	s7,56(sp)
 522:	f862                	sd	s8,48(sp)
 524:	f06a                	sd	s10,32(sp)
 526:	ec6e                	sd	s11,24(sp)
  temp = malloc(size); // Allocate temporary space for one element
 528:	8532                	mv	a0,a2
 52a:	5de000ef          	jal	b08 <malloc>
 52e:	8baa                	mv	s7,a0
  if (temp == 0) {
 530:	4d81                	li	s11,0
  for (uint i = 1; i < nmemb; i++) {
 532:	4d05                	li	s10,1
    memmove(temp, arr + i * size, size);
 534:	000a0c1b          	sext.w	s8,s4
  if (temp == 0) {
 538:	c511                	beqz	a0,544 <simplesort+0x52>
 53a:	f4a6                	sd	s1,104(sp)
 53c:	f0ca                	sd	s2,96(sp)
 53e:	ecce                	sd	s3,88(sp)
 540:	e0da                	sd	s6,64(sp)
 542:	a82d                	j	57c <simplesort+0x8a>
    printf("simplesort: malloc failed, cannot sort\n");
 544:	00000517          	auipc	a0,0x0
 548:	6f450513          	addi	a0,a0,1780 # c38 <malloc+0x130>
 54c:	508000ef          	jal	a54 <printf>
    return;
 550:	6a46                	ld	s4,80(sp)
 552:	6aa6                	ld	s5,72(sp)
 554:	7be2                	ld	s7,56(sp)
 556:	7c42                	ld	s8,48(sp)
 558:	7ca2                	ld	s9,40(sp)
 55a:	7d02                	ld	s10,32(sp)
 55c:	6de2                	ld	s11,24(sp)
 55e:	bf6d                	j	518 <simplesort+0x26>
    memmove(arr + j * size, temp, size);
 560:	036a053b          	mulw	a0,s4,s6
 564:	1502                	slli	a0,a0,0x20
 566:	9101                	srli	a0,a0,0x20
 568:	8662                	mv	a2,s8
 56a:	85de                	mv	a1,s7
 56c:	9556                	add	a0,a0,s5
 56e:	edfff0ef          	jal	44c <memmove>
  for (uint i = 1; i < nmemb; i++) {
 572:	2d05                	addiw	s10,s10,1
 574:	f8843783          	ld	a5,-120(s0)
 578:	05a78b63          	beq	a5,s10,5ce <simplesort+0xdc>
    memmove(temp, arr + i * size, size);
 57c:	000d899b          	sext.w	s3,s11
 580:	01ba05bb          	addw	a1,s4,s11
 584:	00058d9b          	sext.w	s11,a1
 588:	1582                	slli	a1,a1,0x20
 58a:	9181                	srli	a1,a1,0x20
 58c:	8662                	mv	a2,s8
 58e:	95d6                	add	a1,a1,s5
 590:	855e                	mv	a0,s7
 592:	ebbff0ef          	jal	44c <memmove>
    uint j = i;
 596:	896a                	mv	s2,s10
 598:	00090b1b          	sext.w	s6,s2
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 59c:	397d                	addiw	s2,s2,-1
 59e:	02099493          	slli	s1,s3,0x20
 5a2:	9081                	srli	s1,s1,0x20
 5a4:	94d6                	add	s1,s1,s5
 5a6:	85de                	mv	a1,s7
 5a8:	8526                	mv	a0,s1
 5aa:	9c82                	jalr	s9
 5ac:	faa05ae3          	blez	a0,560 <simplesort+0x6e>
      memmove(arr + j * size, arr + (j - 1) * size, size); // Shift element
 5b0:	0149853b          	addw	a0,s3,s4
 5b4:	1502                	slli	a0,a0,0x20
 5b6:	9101                	srli	a0,a0,0x20
 5b8:	8662                	mv	a2,s8
 5ba:	85a6                	mv	a1,s1
 5bc:	9556                	add	a0,a0,s5
 5be:	e8fff0ef          	jal	44c <memmove>
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 5c2:	414989bb          	subw	s3,s3,s4
 5c6:	fc0919e3          	bnez	s2,598 <simplesort+0xa6>
 5ca:	8b4a                	mv	s6,s2
 5cc:	bf51                	j	560 <simplesort+0x6e>
  free(temp); // Free temporary space
 5ce:	855e                	mv	a0,s7
 5d0:	4b6000ef          	jal	a86 <free>
 5d4:	74a6                	ld	s1,104(sp)
 5d6:	7906                	ld	s2,96(sp)
 5d8:	69e6                	ld	s3,88(sp)
 5da:	6a46                	ld	s4,80(sp)
 5dc:	6aa6                	ld	s5,72(sp)
 5de:	6b06                	ld	s6,64(sp)
 5e0:	7be2                	ld	s7,56(sp)
 5e2:	7c42                	ld	s8,48(sp)
 5e4:	7ca2                	ld	s9,40(sp)
 5e6:	7d02                	ld	s10,32(sp)
 5e8:	6de2                	ld	s11,24(sp)
 5ea:	b73d                	j	518 <simplesort+0x26>

00000000000005ec <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5ec:	4885                	li	a7,1
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5f4:	4889                	li	a7,2
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <wait>:
.global wait
wait:
 li a7, SYS_wait
 5fc:	488d                	li	a7,3
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 604:	4891                	li	a7,4
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <read>:
.global read
read:
 li a7, SYS_read
 60c:	4895                	li	a7,5
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <write>:
.global write
write:
 li a7, SYS_write
 614:	48c1                	li	a7,16
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <close>:
.global close
close:
 li a7, SYS_close
 61c:	48d5                	li	a7,21
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <kill>:
.global kill
kill:
 li a7, SYS_kill
 624:	4899                	li	a7,6
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <exec>:
.global exec
exec:
 li a7, SYS_exec
 62c:	489d                	li	a7,7
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <open>:
.global open
open:
 li a7, SYS_open
 634:	48bd                	li	a7,15
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 63c:	48c5                	li	a7,17
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 644:	48c9                	li	a7,18
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 64c:	48a1                	li	a7,8
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <link>:
.global link
link:
 li a7, SYS_link
 654:	48cd                	li	a7,19
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 65c:	48d1                	li	a7,20
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 664:	48a5                	li	a7,9
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <dup>:
.global dup
dup:
 li a7, SYS_dup
 66c:	48a9                	li	a7,10
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 674:	48ad                	li	a7,11
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 67c:	48b1                	li	a7,12
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 684:	48b5                	li	a7,13
 ecall
 686:	00000073          	ecall
 ret
 68a:	8082                	ret

000000000000068c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 68c:	48b9                	li	a7,14
 ecall
 68e:	00000073          	ecall
 ret
 692:	8082                	ret

0000000000000694 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 694:	48dd                	li	a7,23
 ecall
 696:	00000073          	ecall
 ret
 69a:	8082                	ret

000000000000069c <statistics>:
.global statistics
statistics:
 li a7, SYS_statistics
 69c:	48e1                	li	a7,24
 ecall
 69e:	00000073          	ecall
 ret
 6a2:	8082                	ret

00000000000006a4 <reset_stats>:
.global reset_stats
reset_stats:
 li a7, SYS_reset_stats
 6a4:	48e5                	li	a7,25
 ecall
 6a6:	00000073          	ecall
 ret
 6aa:	8082                	ret

00000000000006ac <resetlockstats>:
.global resetlockstats
resetlockstats:
 li a7, SYS_resetlockstats
 6ac:	48e9                	li	a7,26
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <getlockstats>:
.global getlockstats
getlockstats:
 li a7, SYS_getlockstats
 6b4:	48ed                	li	a7,27
 ecall
 6b6:	00000073          	ecall
 ret
 6ba:	8082                	ret

00000000000006bc <trace>:
.global trace
trace:
 li a7, SYS_trace
 6bc:	48d9                	li	a7,22
 ecall
 6be:	00000073          	ecall
 ret
 6c2:	8082                	ret

00000000000006c4 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 6c4:	48f1                	li	a7,28
 ecall
 6c6:	00000073          	ecall
 ret
 6ca:	8082                	ret

00000000000006cc <ugetpid>:
.global ugetpid
ugetpid:
 li a7, SYS_ugetpid
 6cc:	48f5                	li	a7,29
 ecall
 6ce:	00000073          	ecall
 ret
 6d2:	8082                	ret

00000000000006d4 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 6d4:	48f9                	li	a7,30
 ecall
 6d6:	00000073          	ecall
 ret
 6da:	8082                	ret

00000000000006dc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6dc:	1101                	addi	sp,sp,-32
 6de:	ec06                	sd	ra,24(sp)
 6e0:	e822                	sd	s0,16(sp)
 6e2:	1000                	addi	s0,sp,32
 6e4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6e8:	4605                	li	a2,1
 6ea:	fef40593          	addi	a1,s0,-17
 6ee:	f27ff0ef          	jal	614 <write>
}
 6f2:	60e2                	ld	ra,24(sp)
 6f4:	6442                	ld	s0,16(sp)
 6f6:	6105                	addi	sp,sp,32
 6f8:	8082                	ret

00000000000006fa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6fa:	7139                	addi	sp,sp,-64
 6fc:	fc06                	sd	ra,56(sp)
 6fe:	f822                	sd	s0,48(sp)
 700:	f426                	sd	s1,40(sp)
 702:	0080                	addi	s0,sp,64
 704:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 706:	c299                	beqz	a3,70c <printint+0x12>
 708:	0805c963          	bltz	a1,79a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 70c:	2581                	sext.w	a1,a1
  neg = 0;
 70e:	4881                	li	a7,0
 710:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 714:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 716:	2601                	sext.w	a2,a2
 718:	00000517          	auipc	a0,0x0
 71c:	55050513          	addi	a0,a0,1360 # c68 <digits>
 720:	883a                	mv	a6,a4
 722:	2705                	addiw	a4,a4,1
 724:	02c5f7bb          	remuw	a5,a1,a2
 728:	1782                	slli	a5,a5,0x20
 72a:	9381                	srli	a5,a5,0x20
 72c:	97aa                	add	a5,a5,a0
 72e:	0007c783          	lbu	a5,0(a5)
 732:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 736:	0005879b          	sext.w	a5,a1
 73a:	02c5d5bb          	divuw	a1,a1,a2
 73e:	0685                	addi	a3,a3,1
 740:	fec7f0e3          	bgeu	a5,a2,720 <printint+0x26>
  if(neg)
 744:	00088c63          	beqz	a7,75c <printint+0x62>
    buf[i++] = '-';
 748:	fd070793          	addi	a5,a4,-48
 74c:	00878733          	add	a4,a5,s0
 750:	02d00793          	li	a5,45
 754:	fef70823          	sb	a5,-16(a4)
 758:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 75c:	02e05a63          	blez	a4,790 <printint+0x96>
 760:	f04a                	sd	s2,32(sp)
 762:	ec4e                	sd	s3,24(sp)
 764:	fc040793          	addi	a5,s0,-64
 768:	00e78933          	add	s2,a5,a4
 76c:	fff78993          	addi	s3,a5,-1
 770:	99ba                	add	s3,s3,a4
 772:	377d                	addiw	a4,a4,-1
 774:	1702                	slli	a4,a4,0x20
 776:	9301                	srli	a4,a4,0x20
 778:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 77c:	fff94583          	lbu	a1,-1(s2)
 780:	8526                	mv	a0,s1
 782:	f5bff0ef          	jal	6dc <putc>
  while(--i >= 0)
 786:	197d                	addi	s2,s2,-1
 788:	ff391ae3          	bne	s2,s3,77c <printint+0x82>
 78c:	7902                	ld	s2,32(sp)
 78e:	69e2                	ld	s3,24(sp)
}
 790:	70e2                	ld	ra,56(sp)
 792:	7442                	ld	s0,48(sp)
 794:	74a2                	ld	s1,40(sp)
 796:	6121                	addi	sp,sp,64
 798:	8082                	ret
    x = -xx;
 79a:	40b005bb          	negw	a1,a1
    neg = 1;
 79e:	4885                	li	a7,1
    x = -xx;
 7a0:	bf85                	j	710 <printint+0x16>

00000000000007a2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7a2:	711d                	addi	sp,sp,-96
 7a4:	ec86                	sd	ra,88(sp)
 7a6:	e8a2                	sd	s0,80(sp)
 7a8:	e0ca                	sd	s2,64(sp)
 7aa:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7ac:	0005c903          	lbu	s2,0(a1)
 7b0:	26090863          	beqz	s2,a20 <vprintf+0x27e>
 7b4:	e4a6                	sd	s1,72(sp)
 7b6:	fc4e                	sd	s3,56(sp)
 7b8:	f852                	sd	s4,48(sp)
 7ba:	f456                	sd	s5,40(sp)
 7bc:	f05a                	sd	s6,32(sp)
 7be:	ec5e                	sd	s7,24(sp)
 7c0:	e862                	sd	s8,16(sp)
 7c2:	e466                	sd	s9,8(sp)
 7c4:	8b2a                	mv	s6,a0
 7c6:	8a2e                	mv	s4,a1
 7c8:	8bb2                	mv	s7,a2
  state = 0;
 7ca:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 7cc:	4481                	li	s1,0
 7ce:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 7d0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 7d4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 7d8:	06c00c93          	li	s9,108
 7dc:	a005                	j	7fc <vprintf+0x5a>
        putc(fd, c0);
 7de:	85ca                	mv	a1,s2
 7e0:	855a                	mv	a0,s6
 7e2:	efbff0ef          	jal	6dc <putc>
 7e6:	a019                	j	7ec <vprintf+0x4a>
    } else if(state == '%'){
 7e8:	03598263          	beq	s3,s5,80c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 7ec:	2485                	addiw	s1,s1,1
 7ee:	8726                	mv	a4,s1
 7f0:	009a07b3          	add	a5,s4,s1
 7f4:	0007c903          	lbu	s2,0(a5)
 7f8:	20090c63          	beqz	s2,a10 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 7fc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 800:	fe0994e3          	bnez	s3,7e8 <vprintf+0x46>
      if(c0 == '%'){
 804:	fd579de3          	bne	a5,s5,7de <vprintf+0x3c>
        state = '%';
 808:	89be                	mv	s3,a5
 80a:	b7cd                	j	7ec <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 80c:	00ea06b3          	add	a3,s4,a4
 810:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 814:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 816:	c681                	beqz	a3,81e <vprintf+0x7c>
 818:	9752                	add	a4,a4,s4
 81a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 81e:	03878f63          	beq	a5,s8,85c <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 822:	05978963          	beq	a5,s9,874 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 826:	07500713          	li	a4,117
 82a:	0ee78363          	beq	a5,a4,910 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 82e:	07800713          	li	a4,120
 832:	12e78563          	beq	a5,a4,95c <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 836:	07000713          	li	a4,112
 83a:	14e78a63          	beq	a5,a4,98e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 83e:	07300713          	li	a4,115
 842:	18e78a63          	beq	a5,a4,9d6 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 846:	02500713          	li	a4,37
 84a:	04e79563          	bne	a5,a4,894 <vprintf+0xf2>
        putc(fd, '%');
 84e:	02500593          	li	a1,37
 852:	855a                	mv	a0,s6
 854:	e89ff0ef          	jal	6dc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 858:	4981                	li	s3,0
 85a:	bf49                	j	7ec <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 85c:	008b8913          	addi	s2,s7,8
 860:	4685                	li	a3,1
 862:	4629                	li	a2,10
 864:	000ba583          	lw	a1,0(s7)
 868:	855a                	mv	a0,s6
 86a:	e91ff0ef          	jal	6fa <printint>
 86e:	8bca                	mv	s7,s2
      state = 0;
 870:	4981                	li	s3,0
 872:	bfad                	j	7ec <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 874:	06400793          	li	a5,100
 878:	02f68963          	beq	a3,a5,8aa <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 87c:	06c00793          	li	a5,108
 880:	04f68263          	beq	a3,a5,8c4 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 884:	07500793          	li	a5,117
 888:	0af68063          	beq	a3,a5,928 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 88c:	07800793          	li	a5,120
 890:	0ef68263          	beq	a3,a5,974 <vprintf+0x1d2>
        putc(fd, '%');
 894:	02500593          	li	a1,37
 898:	855a                	mv	a0,s6
 89a:	e43ff0ef          	jal	6dc <putc>
        putc(fd, c0);
 89e:	85ca                	mv	a1,s2
 8a0:	855a                	mv	a0,s6
 8a2:	e3bff0ef          	jal	6dc <putc>
      state = 0;
 8a6:	4981                	li	s3,0
 8a8:	b791                	j	7ec <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8aa:	008b8913          	addi	s2,s7,8
 8ae:	4685                	li	a3,1
 8b0:	4629                	li	a2,10
 8b2:	000ba583          	lw	a1,0(s7)
 8b6:	855a                	mv	a0,s6
 8b8:	e43ff0ef          	jal	6fa <printint>
        i += 1;
 8bc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 8be:	8bca                	mv	s7,s2
      state = 0;
 8c0:	4981                	li	s3,0
        i += 1;
 8c2:	b72d                	j	7ec <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8c4:	06400793          	li	a5,100
 8c8:	02f60763          	beq	a2,a5,8f6 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8cc:	07500793          	li	a5,117
 8d0:	06f60963          	beq	a2,a5,942 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 8d4:	07800793          	li	a5,120
 8d8:	faf61ee3          	bne	a2,a5,894 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8dc:	008b8913          	addi	s2,s7,8
 8e0:	4681                	li	a3,0
 8e2:	4641                	li	a2,16
 8e4:	000ba583          	lw	a1,0(s7)
 8e8:	855a                	mv	a0,s6
 8ea:	e11ff0ef          	jal	6fa <printint>
        i += 2;
 8ee:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 8f0:	8bca                	mv	s7,s2
      state = 0;
 8f2:	4981                	li	s3,0
        i += 2;
 8f4:	bde5                	j	7ec <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8f6:	008b8913          	addi	s2,s7,8
 8fa:	4685                	li	a3,1
 8fc:	4629                	li	a2,10
 8fe:	000ba583          	lw	a1,0(s7)
 902:	855a                	mv	a0,s6
 904:	df7ff0ef          	jal	6fa <printint>
        i += 2;
 908:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 90a:	8bca                	mv	s7,s2
      state = 0;
 90c:	4981                	li	s3,0
        i += 2;
 90e:	bdf9                	j	7ec <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 910:	008b8913          	addi	s2,s7,8
 914:	4681                	li	a3,0
 916:	4629                	li	a2,10
 918:	000ba583          	lw	a1,0(s7)
 91c:	855a                	mv	a0,s6
 91e:	dddff0ef          	jal	6fa <printint>
 922:	8bca                	mv	s7,s2
      state = 0;
 924:	4981                	li	s3,0
 926:	b5d9                	j	7ec <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 928:	008b8913          	addi	s2,s7,8
 92c:	4681                	li	a3,0
 92e:	4629                	li	a2,10
 930:	000ba583          	lw	a1,0(s7)
 934:	855a                	mv	a0,s6
 936:	dc5ff0ef          	jal	6fa <printint>
        i += 1;
 93a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 93c:	8bca                	mv	s7,s2
      state = 0;
 93e:	4981                	li	s3,0
        i += 1;
 940:	b575                	j	7ec <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 942:	008b8913          	addi	s2,s7,8
 946:	4681                	li	a3,0
 948:	4629                	li	a2,10
 94a:	000ba583          	lw	a1,0(s7)
 94e:	855a                	mv	a0,s6
 950:	dabff0ef          	jal	6fa <printint>
        i += 2;
 954:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 956:	8bca                	mv	s7,s2
      state = 0;
 958:	4981                	li	s3,0
        i += 2;
 95a:	bd49                	j	7ec <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 95c:	008b8913          	addi	s2,s7,8
 960:	4681                	li	a3,0
 962:	4641                	li	a2,16
 964:	000ba583          	lw	a1,0(s7)
 968:	855a                	mv	a0,s6
 96a:	d91ff0ef          	jal	6fa <printint>
 96e:	8bca                	mv	s7,s2
      state = 0;
 970:	4981                	li	s3,0
 972:	bdad                	j	7ec <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 974:	008b8913          	addi	s2,s7,8
 978:	4681                	li	a3,0
 97a:	4641                	li	a2,16
 97c:	000ba583          	lw	a1,0(s7)
 980:	855a                	mv	a0,s6
 982:	d79ff0ef          	jal	6fa <printint>
        i += 1;
 986:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 988:	8bca                	mv	s7,s2
      state = 0;
 98a:	4981                	li	s3,0
        i += 1;
 98c:	b585                	j	7ec <vprintf+0x4a>
 98e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 990:	008b8d13          	addi	s10,s7,8
 994:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 998:	03000593          	li	a1,48
 99c:	855a                	mv	a0,s6
 99e:	d3fff0ef          	jal	6dc <putc>
  putc(fd, 'x');
 9a2:	07800593          	li	a1,120
 9a6:	855a                	mv	a0,s6
 9a8:	d35ff0ef          	jal	6dc <putc>
 9ac:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9ae:	00000b97          	auipc	s7,0x0
 9b2:	2bab8b93          	addi	s7,s7,698 # c68 <digits>
 9b6:	03c9d793          	srli	a5,s3,0x3c
 9ba:	97de                	add	a5,a5,s7
 9bc:	0007c583          	lbu	a1,0(a5)
 9c0:	855a                	mv	a0,s6
 9c2:	d1bff0ef          	jal	6dc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9c6:	0992                	slli	s3,s3,0x4
 9c8:	397d                	addiw	s2,s2,-1
 9ca:	fe0916e3          	bnez	s2,9b6 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 9ce:	8bea                	mv	s7,s10
      state = 0;
 9d0:	4981                	li	s3,0
 9d2:	6d02                	ld	s10,0(sp)
 9d4:	bd21                	j	7ec <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 9d6:	008b8993          	addi	s3,s7,8
 9da:	000bb903          	ld	s2,0(s7)
 9de:	00090f63          	beqz	s2,9fc <vprintf+0x25a>
        for(; *s; s++)
 9e2:	00094583          	lbu	a1,0(s2)
 9e6:	c195                	beqz	a1,a0a <vprintf+0x268>
          putc(fd, *s);
 9e8:	855a                	mv	a0,s6
 9ea:	cf3ff0ef          	jal	6dc <putc>
        for(; *s; s++)
 9ee:	0905                	addi	s2,s2,1
 9f0:	00094583          	lbu	a1,0(s2)
 9f4:	f9f5                	bnez	a1,9e8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 9f6:	8bce                	mv	s7,s3
      state = 0;
 9f8:	4981                	li	s3,0
 9fa:	bbcd                	j	7ec <vprintf+0x4a>
          s = "(null)";
 9fc:	00000917          	auipc	s2,0x0
 a00:	26490913          	addi	s2,s2,612 # c60 <malloc+0x158>
        for(; *s; s++)
 a04:	02800593          	li	a1,40
 a08:	b7c5                	j	9e8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 a0a:	8bce                	mv	s7,s3
      state = 0;
 a0c:	4981                	li	s3,0
 a0e:	bbf9                	j	7ec <vprintf+0x4a>
 a10:	64a6                	ld	s1,72(sp)
 a12:	79e2                	ld	s3,56(sp)
 a14:	7a42                	ld	s4,48(sp)
 a16:	7aa2                	ld	s5,40(sp)
 a18:	7b02                	ld	s6,32(sp)
 a1a:	6be2                	ld	s7,24(sp)
 a1c:	6c42                	ld	s8,16(sp)
 a1e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 a20:	60e6                	ld	ra,88(sp)
 a22:	6446                	ld	s0,80(sp)
 a24:	6906                	ld	s2,64(sp)
 a26:	6125                	addi	sp,sp,96
 a28:	8082                	ret

0000000000000a2a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a2a:	715d                	addi	sp,sp,-80
 a2c:	ec06                	sd	ra,24(sp)
 a2e:	e822                	sd	s0,16(sp)
 a30:	1000                	addi	s0,sp,32
 a32:	e010                	sd	a2,0(s0)
 a34:	e414                	sd	a3,8(s0)
 a36:	e818                	sd	a4,16(s0)
 a38:	ec1c                	sd	a5,24(s0)
 a3a:	03043023          	sd	a6,32(s0)
 a3e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a42:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a46:	8622                	mv	a2,s0
 a48:	d5bff0ef          	jal	7a2 <vprintf>
}
 a4c:	60e2                	ld	ra,24(sp)
 a4e:	6442                	ld	s0,16(sp)
 a50:	6161                	addi	sp,sp,80
 a52:	8082                	ret

0000000000000a54 <printf>:

void
printf(const char *fmt, ...)
{
 a54:	711d                	addi	sp,sp,-96
 a56:	ec06                	sd	ra,24(sp)
 a58:	e822                	sd	s0,16(sp)
 a5a:	1000                	addi	s0,sp,32
 a5c:	e40c                	sd	a1,8(s0)
 a5e:	e810                	sd	a2,16(s0)
 a60:	ec14                	sd	a3,24(s0)
 a62:	f018                	sd	a4,32(s0)
 a64:	f41c                	sd	a5,40(s0)
 a66:	03043823          	sd	a6,48(s0)
 a6a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a6e:	00840613          	addi	a2,s0,8
 a72:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a76:	85aa                	mv	a1,a0
 a78:	4505                	li	a0,1
 a7a:	d29ff0ef          	jal	7a2 <vprintf>
}
 a7e:	60e2                	ld	ra,24(sp)
 a80:	6442                	ld	s0,16(sp)
 a82:	6125                	addi	sp,sp,96
 a84:	8082                	ret

0000000000000a86 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a86:	1141                	addi	sp,sp,-16
 a88:	e422                	sd	s0,8(sp)
 a8a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a8c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a90:	00001797          	auipc	a5,0x1
 a94:	5707b783          	ld	a5,1392(a5) # 2000 <freep>
 a98:	a02d                	j	ac2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a9a:	4618                	lw	a4,8(a2)
 a9c:	9f2d                	addw	a4,a4,a1
 a9e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 aa2:	6398                	ld	a4,0(a5)
 aa4:	6310                	ld	a2,0(a4)
 aa6:	a83d                	j	ae4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 aa8:	ff852703          	lw	a4,-8(a0)
 aac:	9f31                	addw	a4,a4,a2
 aae:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 ab0:	ff053683          	ld	a3,-16(a0)
 ab4:	a091                	j	af8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ab6:	6398                	ld	a4,0(a5)
 ab8:	00e7e463          	bltu	a5,a4,ac0 <free+0x3a>
 abc:	00e6ea63          	bltu	a3,a4,ad0 <free+0x4a>
{
 ac0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ac2:	fed7fae3          	bgeu	a5,a3,ab6 <free+0x30>
 ac6:	6398                	ld	a4,0(a5)
 ac8:	00e6e463          	bltu	a3,a4,ad0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 acc:	fee7eae3          	bltu	a5,a4,ac0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 ad0:	ff852583          	lw	a1,-8(a0)
 ad4:	6390                	ld	a2,0(a5)
 ad6:	02059813          	slli	a6,a1,0x20
 ada:	01c85713          	srli	a4,a6,0x1c
 ade:	9736                	add	a4,a4,a3
 ae0:	fae60de3          	beq	a2,a4,a9a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 ae4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 ae8:	4790                	lw	a2,8(a5)
 aea:	02061593          	slli	a1,a2,0x20
 aee:	01c5d713          	srli	a4,a1,0x1c
 af2:	973e                	add	a4,a4,a5
 af4:	fae68ae3          	beq	a3,a4,aa8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 af8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 afa:	00001717          	auipc	a4,0x1
 afe:	50f73323          	sd	a5,1286(a4) # 2000 <freep>
}
 b02:	6422                	ld	s0,8(sp)
 b04:	0141                	addi	sp,sp,16
 b06:	8082                	ret

0000000000000b08 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b08:	7139                	addi	sp,sp,-64
 b0a:	fc06                	sd	ra,56(sp)
 b0c:	f822                	sd	s0,48(sp)
 b0e:	f426                	sd	s1,40(sp)
 b10:	ec4e                	sd	s3,24(sp)
 b12:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b14:	02051493          	slli	s1,a0,0x20
 b18:	9081                	srli	s1,s1,0x20
 b1a:	04bd                	addi	s1,s1,15
 b1c:	8091                	srli	s1,s1,0x4
 b1e:	0014899b          	addiw	s3,s1,1
 b22:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b24:	00001517          	auipc	a0,0x1
 b28:	4dc53503          	ld	a0,1244(a0) # 2000 <freep>
 b2c:	c915                	beqz	a0,b60 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b2e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b30:	4798                	lw	a4,8(a5)
 b32:	08977a63          	bgeu	a4,s1,bc6 <malloc+0xbe>
 b36:	f04a                	sd	s2,32(sp)
 b38:	e852                	sd	s4,16(sp)
 b3a:	e456                	sd	s5,8(sp)
 b3c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 b3e:	8a4e                	mv	s4,s3
 b40:	0009871b          	sext.w	a4,s3
 b44:	6685                	lui	a3,0x1
 b46:	00d77363          	bgeu	a4,a3,b4c <malloc+0x44>
 b4a:	6a05                	lui	s4,0x1
 b4c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b50:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b54:	00001917          	auipc	s2,0x1
 b58:	4ac90913          	addi	s2,s2,1196 # 2000 <freep>
  if(p == (char*)-1)
 b5c:	5afd                	li	s5,-1
 b5e:	a081                	j	b9e <malloc+0x96>
 b60:	f04a                	sd	s2,32(sp)
 b62:	e852                	sd	s4,16(sp)
 b64:	e456                	sd	s5,8(sp)
 b66:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b68:	00002797          	auipc	a5,0x2
 b6c:	8a878793          	addi	a5,a5,-1880 # 2410 <base>
 b70:	00001717          	auipc	a4,0x1
 b74:	48f73823          	sd	a5,1168(a4) # 2000 <freep>
 b78:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b7a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b7e:	b7c1                	j	b3e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 b80:	6398                	ld	a4,0(a5)
 b82:	e118                	sd	a4,0(a0)
 b84:	a8a9                	j	bde <malloc+0xd6>
  hp->s.size = nu;
 b86:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b8a:	0541                	addi	a0,a0,16
 b8c:	efbff0ef          	jal	a86 <free>
  return freep;
 b90:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b94:	c12d                	beqz	a0,bf6 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b96:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b98:	4798                	lw	a4,8(a5)
 b9a:	02977263          	bgeu	a4,s1,bbe <malloc+0xb6>
    if(p == freep)
 b9e:	00093703          	ld	a4,0(s2)
 ba2:	853e                	mv	a0,a5
 ba4:	fef719e3          	bne	a4,a5,b96 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 ba8:	8552                	mv	a0,s4
 baa:	ad3ff0ef          	jal	67c <sbrk>
  if(p == (char*)-1)
 bae:	fd551ce3          	bne	a0,s5,b86 <malloc+0x7e>
        return 0;
 bb2:	4501                	li	a0,0
 bb4:	7902                	ld	s2,32(sp)
 bb6:	6a42                	ld	s4,16(sp)
 bb8:	6aa2                	ld	s5,8(sp)
 bba:	6b02                	ld	s6,0(sp)
 bbc:	a03d                	j	bea <malloc+0xe2>
 bbe:	7902                	ld	s2,32(sp)
 bc0:	6a42                	ld	s4,16(sp)
 bc2:	6aa2                	ld	s5,8(sp)
 bc4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 bc6:	fae48de3          	beq	s1,a4,b80 <malloc+0x78>
        p->s.size -= nunits;
 bca:	4137073b          	subw	a4,a4,s3
 bce:	c798                	sw	a4,8(a5)
        p += p->s.size;
 bd0:	02071693          	slli	a3,a4,0x20
 bd4:	01c6d713          	srli	a4,a3,0x1c
 bd8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 bda:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bde:	00001717          	auipc	a4,0x1
 be2:	42a73123          	sd	a0,1058(a4) # 2000 <freep>
      return (void*)(p + 1);
 be6:	01078513          	addi	a0,a5,16
  }
}
 bea:	70e2                	ld	ra,56(sp)
 bec:	7442                	ld	s0,48(sp)
 bee:	74a2                	ld	s1,40(sp)
 bf0:	69e2                	ld	s3,24(sp)
 bf2:	6121                	addi	sp,sp,64
 bf4:	8082                	ret
 bf6:	7902                	ld	s2,32(sp)
 bf8:	6a42                	ld	s4,16(sp)
 bfa:	6aa2                	ld	s5,8(sp)
 bfc:	6b02                	ld	s6,0(sp)
 bfe:	b7f5                	j	bea <malloc+0xe2>
