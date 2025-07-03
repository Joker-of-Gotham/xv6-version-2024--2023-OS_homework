
user/_alarmtest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <periodic>:

volatile static int count;

void
periodic()
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  count = count + 1;
   8:	00002797          	auipc	a5,0x2
   c:	ff87a783          	lw	a5,-8(a5) # 2000 <count>
  10:	2785                	addiw	a5,a5,1
  12:	00002717          	auipc	a4,0x2
  16:	fef72723          	sw	a5,-18(a4) # 2000 <count>
  printf("alarm!\n");
  1a:	00001517          	auipc	a0,0x1
  1e:	be650513          	addi	a0,a0,-1050 # c00 <malloc+0xf8>
  22:	233000ef          	jal	a54 <printf>
  sigreturn();
  26:	6ae000ef          	jal	6d4 <sigreturn>
}
  2a:	60a2                	ld	ra,8(sp)
  2c:	6402                	ld	s0,0(sp)
  2e:	0141                	addi	sp,sp,16
  30:	8082                	ret

0000000000000032 <slow_handler>:
  }
}

void
slow_handler()
{
  32:	1101                	addi	sp,sp,-32
  34:	ec06                	sd	ra,24(sp)
  36:	e822                	sd	s0,16(sp)
  38:	e426                	sd	s1,8(sp)
  3a:	1000                	addi	s0,sp,32
  count++;
  3c:	00002497          	auipc	s1,0x2
  40:	fc448493          	addi	s1,s1,-60 # 2000 <count>
  44:	00002797          	auipc	a5,0x2
  48:	fbc7a783          	lw	a5,-68(a5) # 2000 <count>
  4c:	2785                	addiw	a5,a5,1
  4e:	c09c                	sw	a5,0(s1)
  printf("alarm!\n");
  50:	00001517          	auipc	a0,0x1
  54:	bb050513          	addi	a0,a0,-1104 # c00 <malloc+0xf8>
  58:	1fd000ef          	jal	a54 <printf>
  if (count > 1) {
  5c:	4098                	lw	a4,0(s1)
  5e:	2701                	sext.w	a4,a4
  60:	4685                	li	a3,1
  62:	1dcd67b7          	lui	a5,0x1dcd6
  66:	50078793          	addi	a5,a5,1280 # 1dcd6500 <base+0x1dcd44f0>
  6a:	02e6c063          	blt	a3,a4,8a <slow_handler+0x58>
    printf("test2 failed: alarm handler called more than once\n");
    exit(1);
  }
  for (int i = 0; i < 1000*500000; i++) {
    asm volatile("nop"); // avoid compiler optimizing away loop
  6e:	0001                	nop
  for (int i = 0; i < 1000*500000; i++) {
  70:	37fd                	addiw	a5,a5,-1
  72:	fff5                	bnez	a5,6e <slow_handler+0x3c>
  }
  sigalarm(0, 0);
  74:	4581                	li	a1,0
  76:	4501                	li	a0,0
  78:	654000ef          	jal	6cc <sigalarm>
  sigreturn();
  7c:	658000ef          	jal	6d4 <sigreturn>
}
  80:	60e2                	ld	ra,24(sp)
  82:	6442                	ld	s0,16(sp)
  84:	64a2                	ld	s1,8(sp)
  86:	6105                	addi	sp,sp,32
  88:	8082                	ret
    printf("test2 failed: alarm handler called more than once\n");
  8a:	00001517          	auipc	a0,0x1
  8e:	b7e50513          	addi	a0,a0,-1154 # c08 <malloc+0x100>
  92:	1c3000ef          	jal	a54 <printf>
    exit(1);
  96:	4505                	li	a0,1
  98:	58c000ef          	jal	624 <exit>

000000000000009c <dummy_handler>:
//
// dummy alarm handler; after running immediately uninstall
// itself and finish signal handling
void
dummy_handler()
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e406                	sd	ra,8(sp)
  a0:	e022                	sd	s0,0(sp)
  a2:	0800                	addi	s0,sp,16
  sigalarm(0, 0);
  a4:	4581                	li	a1,0
  a6:	4501                	li	a0,0
  a8:	624000ef          	jal	6cc <sigalarm>
  sigreturn();
  ac:	628000ef          	jal	6d4 <sigreturn>
}
  b0:	60a2                	ld	ra,8(sp)
  b2:	6402                	ld	s0,0(sp)
  b4:	0141                	addi	sp,sp,16
  b6:	8082                	ret

00000000000000b8 <test0>:
{
  b8:	7139                	addi	sp,sp,-64
  ba:	fc06                	sd	ra,56(sp)
  bc:	f822                	sd	s0,48(sp)
  be:	f426                	sd	s1,40(sp)
  c0:	f04a                	sd	s2,32(sp)
  c2:	ec4e                	sd	s3,24(sp)
  c4:	e852                	sd	s4,16(sp)
  c6:	e456                	sd	s5,8(sp)
  c8:	0080                	addi	s0,sp,64
  printf("test0 start\n");
  ca:	00001517          	auipc	a0,0x1
  ce:	b7650513          	addi	a0,a0,-1162 # c40 <malloc+0x138>
  d2:	183000ef          	jal	a54 <printf>
  count = 0;
  d6:	00002797          	auipc	a5,0x2
  da:	f207a523          	sw	zero,-214(a5) # 2000 <count>
  sigalarm(2, periodic);
  de:	00000597          	auipc	a1,0x0
  e2:	f2258593          	addi	a1,a1,-222 # 0 <periodic>
  e6:	4509                	li	a0,2
  e8:	5e4000ef          	jal	6cc <sigalarm>
  for(i = 0; i < 1000*500000; i++){
  ec:	4481                	li	s1,0
    if((i % 1000000) == 0)
  ee:	000f4937          	lui	s2,0xf4
  f2:	2409091b          	addiw	s2,s2,576 # f4240 <base+0xf2230>
      write(2, ".", 1);
  f6:	00001a97          	auipc	s5,0x1
  fa:	b5aa8a93          	addi	s5,s5,-1190 # c50 <malloc+0x148>
    if(count > 0)
  fe:	00002a17          	auipc	s4,0x2
 102:	f02a0a13          	addi	s4,s4,-254 # 2000 <count>
  for(i = 0; i < 1000*500000; i++){
 106:	1dcd69b7          	lui	s3,0x1dcd6
 10a:	50098993          	addi	s3,s3,1280 # 1dcd6500 <base+0x1dcd44f0>
 10e:	a809                	j	120 <test0+0x68>
    if(count > 0)
 110:	000a2783          	lw	a5,0(s4)
 114:	2781                	sext.w	a5,a5
 116:	00f04e63          	bgtz	a5,132 <test0+0x7a>
  for(i = 0; i < 1000*500000; i++){
 11a:	2485                	addiw	s1,s1,1
 11c:	01348b63          	beq	s1,s3,132 <test0+0x7a>
    if((i % 1000000) == 0)
 120:	0324e7bb          	remw	a5,s1,s2
 124:	f7f5                	bnez	a5,110 <test0+0x58>
      write(2, ".", 1);
 126:	4605                	li	a2,1
 128:	85d6                	mv	a1,s5
 12a:	4509                	li	a0,2
 12c:	518000ef          	jal	644 <write>
 130:	b7c5                	j	110 <test0+0x58>
  sigalarm(0, 0);
 132:	4581                	li	a1,0
 134:	4501                	li	a0,0
 136:	596000ef          	jal	6cc <sigalarm>
  if(count > 0){
 13a:	00002797          	auipc	a5,0x2
 13e:	ec67a783          	lw	a5,-314(a5) # 2000 <count>
 142:	02f05163          	blez	a5,164 <test0+0xac>
    printf("test0 passed\n");
 146:	00001517          	auipc	a0,0x1
 14a:	b1250513          	addi	a0,a0,-1262 # c58 <malloc+0x150>
 14e:	107000ef          	jal	a54 <printf>
}
 152:	70e2                	ld	ra,56(sp)
 154:	7442                	ld	s0,48(sp)
 156:	74a2                	ld	s1,40(sp)
 158:	7902                	ld	s2,32(sp)
 15a:	69e2                	ld	s3,24(sp)
 15c:	6a42                	ld	s4,16(sp)
 15e:	6aa2                	ld	s5,8(sp)
 160:	6121                	addi	sp,sp,64
 162:	8082                	ret
    printf("\ntest0 failed: the kernel never called the alarm handler\n");
 164:	00001517          	auipc	a0,0x1
 168:	b0450513          	addi	a0,a0,-1276 # c68 <malloc+0x160>
 16c:	0e9000ef          	jal	a54 <printf>
}
 170:	b7cd                	j	152 <test0+0x9a>

0000000000000172 <foo>:
void __attribute__ ((noinline)) foo(int i, int *j) {
 172:	1101                	addi	sp,sp,-32
 174:	ec06                	sd	ra,24(sp)
 176:	e822                	sd	s0,16(sp)
 178:	e426                	sd	s1,8(sp)
 17a:	1000                	addi	s0,sp,32
 17c:	84ae                	mv	s1,a1
  if((i % 2500000) == 0) {
 17e:	002627b7          	lui	a5,0x262
 182:	5a07879b          	addiw	a5,a5,1440 # 2625a0 <base+0x260590>
 186:	02f5653b          	remw	a0,a0,a5
 18a:	c909                	beqz	a0,19c <foo+0x2a>
  *j += 1;
 18c:	409c                	lw	a5,0(s1)
 18e:	2785                	addiw	a5,a5,1
 190:	c09c                	sw	a5,0(s1)
}
 192:	60e2                	ld	ra,24(sp)
 194:	6442                	ld	s0,16(sp)
 196:	64a2                	ld	s1,8(sp)
 198:	6105                	addi	sp,sp,32
 19a:	8082                	ret
    write(2, ".", 1);
 19c:	4605                	li	a2,1
 19e:	00001597          	auipc	a1,0x1
 1a2:	ab258593          	addi	a1,a1,-1358 # c50 <malloc+0x148>
 1a6:	4509                	li	a0,2
 1a8:	49c000ef          	jal	644 <write>
 1ac:	b7c5                	j	18c <foo+0x1a>

00000000000001ae <test1>:
{
 1ae:	7139                	addi	sp,sp,-64
 1b0:	fc06                	sd	ra,56(sp)
 1b2:	f822                	sd	s0,48(sp)
 1b4:	f426                	sd	s1,40(sp)
 1b6:	f04a                	sd	s2,32(sp)
 1b8:	ec4e                	sd	s3,24(sp)
 1ba:	e852                	sd	s4,16(sp)
 1bc:	0080                	addi	s0,sp,64
  printf("test1 start\n");
 1be:	00001517          	auipc	a0,0x1
 1c2:	aea50513          	addi	a0,a0,-1302 # ca8 <malloc+0x1a0>
 1c6:	08f000ef          	jal	a54 <printf>
  count = 0;
 1ca:	00002797          	auipc	a5,0x2
 1ce:	e207ab23          	sw	zero,-458(a5) # 2000 <count>
  j = 0;
 1d2:	fc042623          	sw	zero,-52(s0)
  sigalarm(2, periodic);
 1d6:	00000597          	auipc	a1,0x0
 1da:	e2a58593          	addi	a1,a1,-470 # 0 <periodic>
 1de:	4509                	li	a0,2
 1e0:	4ec000ef          	jal	6cc <sigalarm>
  for(i = 0; i < 500000000; i++){
 1e4:	4481                	li	s1,0
    if(count >= 10)
 1e6:	00002a17          	auipc	s4,0x2
 1ea:	e1aa0a13          	addi	s4,s4,-486 # 2000 <count>
 1ee:	49a5                	li	s3,9
  for(i = 0; i < 500000000; i++){
 1f0:	1dcd6937          	lui	s2,0x1dcd6
 1f4:	50090913          	addi	s2,s2,1280 # 1dcd6500 <base+0x1dcd44f0>
    if(count >= 10)
 1f8:	000a2783          	lw	a5,0(s4)
 1fc:	2781                	sext.w	a5,a5
 1fe:	00f9ca63          	blt	s3,a5,212 <test1+0x64>
    foo(i, &j);
 202:	fcc40593          	addi	a1,s0,-52
 206:	8526                	mv	a0,s1
 208:	f6bff0ef          	jal	172 <foo>
  for(i = 0; i < 500000000; i++){
 20c:	2485                	addiw	s1,s1,1
 20e:	ff2495e3          	bne	s1,s2,1f8 <test1+0x4a>
  if(count < 10){
 212:	00002717          	auipc	a4,0x2
 216:	dee72703          	lw	a4,-530(a4) # 2000 <count>
 21a:	47a5                	li	a5,9
 21c:	02e7d463          	bge	a5,a4,244 <test1+0x96>
  } else if(i != j){
 220:	fcc42783          	lw	a5,-52(s0)
 224:	02978763          	beq	a5,s1,252 <test1+0xa4>
    printf("\ntest1 failed: foo() executed fewer times than it was called\n");
 228:	00001517          	auipc	a0,0x1
 22c:	ac050513          	addi	a0,a0,-1344 # ce8 <malloc+0x1e0>
 230:	025000ef          	jal	a54 <printf>
}
 234:	70e2                	ld	ra,56(sp)
 236:	7442                	ld	s0,48(sp)
 238:	74a2                	ld	s1,40(sp)
 23a:	7902                	ld	s2,32(sp)
 23c:	69e2                	ld	s3,24(sp)
 23e:	6a42                	ld	s4,16(sp)
 240:	6121                	addi	sp,sp,64
 242:	8082                	ret
    printf("\ntest1 failed: too few calls to the handler\n");
 244:	00001517          	auipc	a0,0x1
 248:	a7450513          	addi	a0,a0,-1420 # cb8 <malloc+0x1b0>
 24c:	009000ef          	jal	a54 <printf>
 250:	b7d5                	j	234 <test1+0x86>
    printf("test1 passed\n");
 252:	00001517          	auipc	a0,0x1
 256:	ad650513          	addi	a0,a0,-1322 # d28 <malloc+0x220>
 25a:	7fa000ef          	jal	a54 <printf>
}
 25e:	bfd9                	j	234 <test1+0x86>

0000000000000260 <test2>:
{
 260:	715d                	addi	sp,sp,-80
 262:	e486                	sd	ra,72(sp)
 264:	e0a2                	sd	s0,64(sp)
 266:	0880                	addi	s0,sp,80
  printf("test2 start\n");
 268:	00001517          	auipc	a0,0x1
 26c:	ad050513          	addi	a0,a0,-1328 # d38 <malloc+0x230>
 270:	7e4000ef          	jal	a54 <printf>
  if ((pid = fork()) < 0) {
 274:	3a8000ef          	jal	61c <fork>
 278:	04054563          	bltz	a0,2c2 <test2+0x62>
 27c:	fc26                	sd	s1,56(sp)
 27e:	84aa                	mv	s1,a0
  if (pid == 0) {
 280:	e545                	bnez	a0,328 <test2+0xc8>
 282:	f84a                	sd	s2,48(sp)
 284:	f44e                	sd	s3,40(sp)
 286:	f052                	sd	s4,32(sp)
 288:	ec56                	sd	s5,24(sp)
    count = 0;
 28a:	00002797          	auipc	a5,0x2
 28e:	d607ab23          	sw	zero,-650(a5) # 2000 <count>
    sigalarm(2, slow_handler);
 292:	00000597          	auipc	a1,0x0
 296:	da058593          	addi	a1,a1,-608 # 32 <slow_handler>
 29a:	4509                	li	a0,2
 29c:	430000ef          	jal	6cc <sigalarm>
      if((i % 1000000) == 0)
 2a0:	000f4937          	lui	s2,0xf4
 2a4:	2409091b          	addiw	s2,s2,576 # f4240 <base+0xf2230>
        write(2, ".", 1);
 2a8:	00001a97          	auipc	s5,0x1
 2ac:	9a8a8a93          	addi	s5,s5,-1624 # c50 <malloc+0x148>
      if(count > 0)
 2b0:	00002a17          	auipc	s4,0x2
 2b4:	d50a0a13          	addi	s4,s4,-688 # 2000 <count>
    for(i = 0; i < 1000*500000; i++){
 2b8:	1dcd69b7          	lui	s3,0x1dcd6
 2bc:	50098993          	addi	s3,s3,1280 # 1dcd6500 <base+0x1dcd44f0>
 2c0:	a815                	j	2f4 <test2+0x94>
    printf("test2: fork failed\n");
 2c2:	00001517          	auipc	a0,0x1
 2c6:	a8650513          	addi	a0,a0,-1402 # d48 <malloc+0x240>
 2ca:	78a000ef          	jal	a54 <printf>
  wait(&status);
 2ce:	fbc40513          	addi	a0,s0,-68
 2d2:	35a000ef          	jal	62c <wait>
  if (status == 0) {
 2d6:	fbc42783          	lw	a5,-68(s0)
 2da:	cba9                	beqz	a5,32c <test2+0xcc>
}
 2dc:	60a6                	ld	ra,72(sp)
 2de:	6406                	ld	s0,64(sp)
 2e0:	6161                	addi	sp,sp,80
 2e2:	8082                	ret
      if(count > 0)
 2e4:	000a2783          	lw	a5,0(s4)
 2e8:	2781                	sext.w	a5,a5
 2ea:	00f04e63          	bgtz	a5,306 <test2+0xa6>
    for(i = 0; i < 1000*500000; i++){
 2ee:	2485                	addiw	s1,s1,1
 2f0:	01348b63          	beq	s1,s3,306 <test2+0xa6>
      if((i % 1000000) == 0)
 2f4:	0324e7bb          	remw	a5,s1,s2
 2f8:	f7f5                	bnez	a5,2e4 <test2+0x84>
        write(2, ".", 1);
 2fa:	4605                	li	a2,1
 2fc:	85d6                	mv	a1,s5
 2fe:	4509                	li	a0,2
 300:	344000ef          	jal	644 <write>
 304:	b7c5                	j	2e4 <test2+0x84>
    if (count == 0) {
 306:	00002797          	auipc	a5,0x2
 30a:	cfa7a783          	lw	a5,-774(a5) # 2000 <count>
 30e:	eb91                	bnez	a5,322 <test2+0xc2>
      printf("\ntest2 failed: alarm not called\n");
 310:	00001517          	auipc	a0,0x1
 314:	a5050513          	addi	a0,a0,-1456 # d60 <malloc+0x258>
 318:	73c000ef          	jal	a54 <printf>
      exit(1);
 31c:	4505                	li	a0,1
 31e:	306000ef          	jal	624 <exit>
    exit(0);
 322:	4501                	li	a0,0
 324:	300000ef          	jal	624 <exit>
 328:	74e2                	ld	s1,56(sp)
 32a:	b755                	j	2ce <test2+0x6e>
    printf("test2 passed\n");
 32c:	00001517          	auipc	a0,0x1
 330:	a5c50513          	addi	a0,a0,-1444 # d88 <malloc+0x280>
 334:	720000ef          	jal	a54 <printf>
}
 338:	b755                	j	2dc <test2+0x7c>

000000000000033a <test3>:
//
// tests that the return from sys_sigreturn() does not
// modify the a0 register
void
test3()
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e406                	sd	ra,8(sp)
 33e:	e022                	sd	s0,0(sp)
 340:	0800                	addi	s0,sp,16
  uint64 a0;

  sigalarm(1, dummy_handler);
 342:	00000597          	auipc	a1,0x0
 346:	d5a58593          	addi	a1,a1,-678 # 9c <dummy_handler>
 34a:	4505                	li	a0,1
 34c:	380000ef          	jal	6cc <sigalarm>
  printf("test3 start\n");
 350:	00001517          	auipc	a0,0x1
 354:	a4850513          	addi	a0,a0,-1464 # d98 <malloc+0x290>
 358:	6fc000ef          	jal	a54 <printf>

  asm volatile("lui a5, 0");
 35c:	000007b7          	lui	a5,0x0
  asm volatile("addi a0, a5, 0xac" : : : "a0");
 360:	0ac78513          	addi	a0,a5,172 # ac <dummy_handler+0x10>
 364:	1dcd67b7          	lui	a5,0x1dcd6
 368:	50078793          	addi	a5,a5,1280 # 1dcd6500 <base+0x1dcd44f0>
  for(int i = 0; i < 500000000; i++)
 36c:	37fd                	addiw	a5,a5,-1
 36e:	fffd                	bnez	a5,36c <test3+0x32>
    ;
  asm volatile("mv %0, a0" : "=r" (a0) );
 370:	872a                	mv	a4,a0

  if(a0 != 0xac)
 372:	0ac00793          	li	a5,172
 376:	00f70c63          	beq	a4,a5,38e <test3+0x54>
    printf("test3 failed: register a0 changed\n");
 37a:	00001517          	auipc	a0,0x1
 37e:	a2e50513          	addi	a0,a0,-1490 # da8 <malloc+0x2a0>
 382:	6d2000ef          	jal	a54 <printf>
  else
    printf("test3 passed\n");
 386:	60a2                	ld	ra,8(sp)
 388:	6402                	ld	s0,0(sp)
 38a:	0141                	addi	sp,sp,16
 38c:	8082                	ret
    printf("test3 passed\n");
 38e:	00001517          	auipc	a0,0x1
 392:	a4250513          	addi	a0,a0,-1470 # dd0 <malloc+0x2c8>
 396:	6be000ef          	jal	a54 <printf>
 39a:	b7f5                	j	386 <test3+0x4c>

000000000000039c <main>:
{
 39c:	1141                	addi	sp,sp,-16
 39e:	e406                	sd	ra,8(sp)
 3a0:	e022                	sd	s0,0(sp)
 3a2:	0800                	addi	s0,sp,16
  test0();
 3a4:	d15ff0ef          	jal	b8 <test0>
  test1();
 3a8:	e07ff0ef          	jal	1ae <test1>
  test2();
 3ac:	eb5ff0ef          	jal	260 <test2>
  test3();
 3b0:	f8bff0ef          	jal	33a <test3>
  exit(0);
 3b4:	4501                	li	a0,0
 3b6:	26e000ef          	jal	624 <exit>

00000000000003ba <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 3ba:	1141                	addi	sp,sp,-16
 3bc:	e406                	sd	ra,8(sp)
 3be:	e022                	sd	s0,0(sp)
 3c0:	0800                	addi	s0,sp,16
  extern int main();
  main();
 3c2:	fdbff0ef          	jal	39c <main>
  exit(0);
 3c6:	4501                	li	a0,0
 3c8:	25c000ef          	jal	624 <exit>

00000000000003cc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 3cc:	1141                	addi	sp,sp,-16
 3ce:	e422                	sd	s0,8(sp)
 3d0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3d2:	87aa                	mv	a5,a0
 3d4:	0585                	addi	a1,a1,1
 3d6:	0785                	addi	a5,a5,1
 3d8:	fff5c703          	lbu	a4,-1(a1)
 3dc:	fee78fa3          	sb	a4,-1(a5)
 3e0:	fb75                	bnez	a4,3d4 <strcpy+0x8>
    ;
  return os;
}
 3e2:	6422                	ld	s0,8(sp)
 3e4:	0141                	addi	sp,sp,16
 3e6:	8082                	ret

00000000000003e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3e8:	1141                	addi	sp,sp,-16
 3ea:	e422                	sd	s0,8(sp)
 3ec:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3ee:	00054783          	lbu	a5,0(a0)
 3f2:	cb91                	beqz	a5,406 <strcmp+0x1e>
 3f4:	0005c703          	lbu	a4,0(a1)
 3f8:	00f71763          	bne	a4,a5,406 <strcmp+0x1e>
    p++, q++;
 3fc:	0505                	addi	a0,a0,1
 3fe:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 400:	00054783          	lbu	a5,0(a0)
 404:	fbe5                	bnez	a5,3f4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 406:	0005c503          	lbu	a0,0(a1)
}
 40a:	40a7853b          	subw	a0,a5,a0
 40e:	6422                	ld	s0,8(sp)
 410:	0141                	addi	sp,sp,16
 412:	8082                	ret

0000000000000414 <strlen>:

uint
strlen(const char *s)
{
 414:	1141                	addi	sp,sp,-16
 416:	e422                	sd	s0,8(sp)
 418:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 41a:	00054783          	lbu	a5,0(a0)
 41e:	cf91                	beqz	a5,43a <strlen+0x26>
 420:	0505                	addi	a0,a0,1
 422:	87aa                	mv	a5,a0
 424:	86be                	mv	a3,a5
 426:	0785                	addi	a5,a5,1
 428:	fff7c703          	lbu	a4,-1(a5)
 42c:	ff65                	bnez	a4,424 <strlen+0x10>
 42e:	40a6853b          	subw	a0,a3,a0
 432:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 434:	6422                	ld	s0,8(sp)
 436:	0141                	addi	sp,sp,16
 438:	8082                	ret
  for(n = 0; s[n]; n++)
 43a:	4501                	li	a0,0
 43c:	bfe5                	j	434 <strlen+0x20>

000000000000043e <memset>:

void*
memset(void *dst, int c, uint n)
{
 43e:	1141                	addi	sp,sp,-16
 440:	e422                	sd	s0,8(sp)
 442:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 444:	ca19                	beqz	a2,45a <memset+0x1c>
 446:	87aa                	mv	a5,a0
 448:	1602                	slli	a2,a2,0x20
 44a:	9201                	srli	a2,a2,0x20
 44c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 450:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 454:	0785                	addi	a5,a5,1
 456:	fee79de3          	bne	a5,a4,450 <memset+0x12>
  }
  return dst;
}
 45a:	6422                	ld	s0,8(sp)
 45c:	0141                	addi	sp,sp,16
 45e:	8082                	ret

0000000000000460 <strchr>:

char*
strchr(const char *s, char c)
{
 460:	1141                	addi	sp,sp,-16
 462:	e422                	sd	s0,8(sp)
 464:	0800                	addi	s0,sp,16
  for(; *s; s++)
 466:	00054783          	lbu	a5,0(a0)
 46a:	cb99                	beqz	a5,480 <strchr+0x20>
    if(*s == c)
 46c:	00f58763          	beq	a1,a5,47a <strchr+0x1a>
  for(; *s; s++)
 470:	0505                	addi	a0,a0,1
 472:	00054783          	lbu	a5,0(a0)
 476:	fbfd                	bnez	a5,46c <strchr+0xc>
      return (char*)s;
  return 0;
 478:	4501                	li	a0,0
}
 47a:	6422                	ld	s0,8(sp)
 47c:	0141                	addi	sp,sp,16
 47e:	8082                	ret
  return 0;
 480:	4501                	li	a0,0
 482:	bfe5                	j	47a <strchr+0x1a>

0000000000000484 <gets>:

char*
gets(char *buf, int max)
{
 484:	711d                	addi	sp,sp,-96
 486:	ec86                	sd	ra,88(sp)
 488:	e8a2                	sd	s0,80(sp)
 48a:	e4a6                	sd	s1,72(sp)
 48c:	e0ca                	sd	s2,64(sp)
 48e:	fc4e                	sd	s3,56(sp)
 490:	f852                	sd	s4,48(sp)
 492:	f456                	sd	s5,40(sp)
 494:	f05a                	sd	s6,32(sp)
 496:	ec5e                	sd	s7,24(sp)
 498:	1080                	addi	s0,sp,96
 49a:	8baa                	mv	s7,a0
 49c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 49e:	892a                	mv	s2,a0
 4a0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4a2:	4aa9                	li	s5,10
 4a4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4a6:	89a6                	mv	s3,s1
 4a8:	2485                	addiw	s1,s1,1
 4aa:	0344d663          	bge	s1,s4,4d6 <gets+0x52>
    cc = read(0, &c, 1);
 4ae:	4605                	li	a2,1
 4b0:	faf40593          	addi	a1,s0,-81
 4b4:	4501                	li	a0,0
 4b6:	186000ef          	jal	63c <read>
    if(cc < 1)
 4ba:	00a05e63          	blez	a0,4d6 <gets+0x52>
    buf[i++] = c;
 4be:	faf44783          	lbu	a5,-81(s0)
 4c2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4c6:	01578763          	beq	a5,s5,4d4 <gets+0x50>
 4ca:	0905                	addi	s2,s2,1
 4cc:	fd679de3          	bne	a5,s6,4a6 <gets+0x22>
    buf[i++] = c;
 4d0:	89a6                	mv	s3,s1
 4d2:	a011                	j	4d6 <gets+0x52>
 4d4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4d6:	99de                	add	s3,s3,s7
 4d8:	00098023          	sb	zero,0(s3)
  return buf;
}
 4dc:	855e                	mv	a0,s7
 4de:	60e6                	ld	ra,88(sp)
 4e0:	6446                	ld	s0,80(sp)
 4e2:	64a6                	ld	s1,72(sp)
 4e4:	6906                	ld	s2,64(sp)
 4e6:	79e2                	ld	s3,56(sp)
 4e8:	7a42                	ld	s4,48(sp)
 4ea:	7aa2                	ld	s5,40(sp)
 4ec:	7b02                	ld	s6,32(sp)
 4ee:	6be2                	ld	s7,24(sp)
 4f0:	6125                	addi	sp,sp,96
 4f2:	8082                	ret

00000000000004f4 <stat>:

int
stat(const char *n, struct stat *st)
{
 4f4:	1101                	addi	sp,sp,-32
 4f6:	ec06                	sd	ra,24(sp)
 4f8:	e822                	sd	s0,16(sp)
 4fa:	e04a                	sd	s2,0(sp)
 4fc:	1000                	addi	s0,sp,32
 4fe:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 500:	4581                	li	a1,0
 502:	162000ef          	jal	664 <open>
  if(fd < 0)
 506:	02054263          	bltz	a0,52a <stat+0x36>
 50a:	e426                	sd	s1,8(sp)
 50c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 50e:	85ca                	mv	a1,s2
 510:	16c000ef          	jal	67c <fstat>
 514:	892a                	mv	s2,a0
  close(fd);
 516:	8526                	mv	a0,s1
 518:	134000ef          	jal	64c <close>
  return r;
 51c:	64a2                	ld	s1,8(sp)
}
 51e:	854a                	mv	a0,s2
 520:	60e2                	ld	ra,24(sp)
 522:	6442                	ld	s0,16(sp)
 524:	6902                	ld	s2,0(sp)
 526:	6105                	addi	sp,sp,32
 528:	8082                	ret
    return -1;
 52a:	597d                	li	s2,-1
 52c:	bfcd                	j	51e <stat+0x2a>

000000000000052e <atoi>:

int
atoi(const char *s)
{
 52e:	1141                	addi	sp,sp,-16
 530:	e422                	sd	s0,8(sp)
 532:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 534:	00054683          	lbu	a3,0(a0)
 538:	fd06879b          	addiw	a5,a3,-48
 53c:	0ff7f793          	zext.b	a5,a5
 540:	4625                	li	a2,9
 542:	02f66863          	bltu	a2,a5,572 <atoi+0x44>
 546:	872a                	mv	a4,a0
  n = 0;
 548:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 54a:	0705                	addi	a4,a4,1
 54c:	0025179b          	slliw	a5,a0,0x2
 550:	9fa9                	addw	a5,a5,a0
 552:	0017979b          	slliw	a5,a5,0x1
 556:	9fb5                	addw	a5,a5,a3
 558:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 55c:	00074683          	lbu	a3,0(a4)
 560:	fd06879b          	addiw	a5,a3,-48
 564:	0ff7f793          	zext.b	a5,a5
 568:	fef671e3          	bgeu	a2,a5,54a <atoi+0x1c>
  return n;
}
 56c:	6422                	ld	s0,8(sp)
 56e:	0141                	addi	sp,sp,16
 570:	8082                	ret
  n = 0;
 572:	4501                	li	a0,0
 574:	bfe5                	j	56c <atoi+0x3e>

0000000000000576 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 576:	1141                	addi	sp,sp,-16
 578:	e422                	sd	s0,8(sp)
 57a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 57c:	02b57463          	bgeu	a0,a1,5a4 <memmove+0x2e>
    while(n-- > 0)
 580:	00c05f63          	blez	a2,59e <memmove+0x28>
 584:	1602                	slli	a2,a2,0x20
 586:	9201                	srli	a2,a2,0x20
 588:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 58c:	872a                	mv	a4,a0
      *dst++ = *src++;
 58e:	0585                	addi	a1,a1,1
 590:	0705                	addi	a4,a4,1
 592:	fff5c683          	lbu	a3,-1(a1)
 596:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 59a:	fef71ae3          	bne	a4,a5,58e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 59e:	6422                	ld	s0,8(sp)
 5a0:	0141                	addi	sp,sp,16
 5a2:	8082                	ret
    dst += n;
 5a4:	00c50733          	add	a4,a0,a2
    src += n;
 5a8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5aa:	fec05ae3          	blez	a2,59e <memmove+0x28>
 5ae:	fff6079b          	addiw	a5,a2,-1
 5b2:	1782                	slli	a5,a5,0x20
 5b4:	9381                	srli	a5,a5,0x20
 5b6:	fff7c793          	not	a5,a5
 5ba:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5bc:	15fd                	addi	a1,a1,-1
 5be:	177d                	addi	a4,a4,-1
 5c0:	0005c683          	lbu	a3,0(a1)
 5c4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5c8:	fee79ae3          	bne	a5,a4,5bc <memmove+0x46>
 5cc:	bfc9                	j	59e <memmove+0x28>

00000000000005ce <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5ce:	1141                	addi	sp,sp,-16
 5d0:	e422                	sd	s0,8(sp)
 5d2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5d4:	ca05                	beqz	a2,604 <memcmp+0x36>
 5d6:	fff6069b          	addiw	a3,a2,-1
 5da:	1682                	slli	a3,a3,0x20
 5dc:	9281                	srli	a3,a3,0x20
 5de:	0685                	addi	a3,a3,1
 5e0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 5e2:	00054783          	lbu	a5,0(a0)
 5e6:	0005c703          	lbu	a4,0(a1)
 5ea:	00e79863          	bne	a5,a4,5fa <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 5ee:	0505                	addi	a0,a0,1
    p2++;
 5f0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 5f2:	fed518e3          	bne	a0,a3,5e2 <memcmp+0x14>
  }
  return 0;
 5f6:	4501                	li	a0,0
 5f8:	a019                	j	5fe <memcmp+0x30>
      return *p1 - *p2;
 5fa:	40e7853b          	subw	a0,a5,a4
}
 5fe:	6422                	ld	s0,8(sp)
 600:	0141                	addi	sp,sp,16
 602:	8082                	ret
  return 0;
 604:	4501                	li	a0,0
 606:	bfe5                	j	5fe <memcmp+0x30>

0000000000000608 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 608:	1141                	addi	sp,sp,-16
 60a:	e406                	sd	ra,8(sp)
 60c:	e022                	sd	s0,0(sp)
 60e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 610:	f67ff0ef          	jal	576 <memmove>
}
 614:	60a2                	ld	ra,8(sp)
 616:	6402                	ld	s0,0(sp)
 618:	0141                	addi	sp,sp,16
 61a:	8082                	ret

000000000000061c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 61c:	4885                	li	a7,1
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <exit>:
.global exit
exit:
 li a7, SYS_exit
 624:	4889                	li	a7,2
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <wait>:
.global wait
wait:
 li a7, SYS_wait
 62c:	488d                	li	a7,3
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 634:	4891                	li	a7,4
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <read>:
.global read
read:
 li a7, SYS_read
 63c:	4895                	li	a7,5
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <write>:
.global write
write:
 li a7, SYS_write
 644:	48c1                	li	a7,16
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <close>:
.global close
close:
 li a7, SYS_close
 64c:	48d5                	li	a7,21
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <kill>:
.global kill
kill:
 li a7, SYS_kill
 654:	4899                	li	a7,6
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <exec>:
.global exec
exec:
 li a7, SYS_exec
 65c:	489d                	li	a7,7
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <open>:
.global open
open:
 li a7, SYS_open
 664:	48bd                	li	a7,15
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 66c:	48c5                	li	a7,17
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 674:	48c9                	li	a7,18
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 67c:	48a1                	li	a7,8
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <link>:
.global link
link:
 li a7, SYS_link
 684:	48cd                	li	a7,19
 ecall
 686:	00000073          	ecall
 ret
 68a:	8082                	ret

000000000000068c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 68c:	48d1                	li	a7,20
 ecall
 68e:	00000073          	ecall
 ret
 692:	8082                	ret

0000000000000694 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 694:	48a5                	li	a7,9
 ecall
 696:	00000073          	ecall
 ret
 69a:	8082                	ret

000000000000069c <dup>:
.global dup
dup:
 li a7, SYS_dup
 69c:	48a9                	li	a7,10
 ecall
 69e:	00000073          	ecall
 ret
 6a2:	8082                	ret

00000000000006a4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6a4:	48ad                	li	a7,11
 ecall
 6a6:	00000073          	ecall
 ret
 6aa:	8082                	ret

00000000000006ac <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6ac:	48b1                	li	a7,12
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6b4:	48b5                	li	a7,13
 ecall
 6b6:	00000073          	ecall
 ret
 6ba:	8082                	ret

00000000000006bc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6bc:	48b9                	li	a7,14
 ecall
 6be:	00000073          	ecall
 ret
 6c2:	8082                	ret

00000000000006c4 <trace>:
.global trace
trace:
 li a7, SYS_trace
 6c4:	48d9                	li	a7,22
 ecall
 6c6:	00000073          	ecall
 ret
 6ca:	8082                	ret

00000000000006cc <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 6cc:	48dd                	li	a7,23
 ecall
 6ce:	00000073          	ecall
 ret
 6d2:	8082                	ret

00000000000006d4 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 6d4:	48e1                	li	a7,24
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
 6ee:	f57ff0ef          	jal	644 <write>
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
 71c:	6d050513          	addi	a0,a0,1744 # de8 <digits>
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
 9b2:	43ab8b93          	addi	s7,s7,1082 # de8 <digits>
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
 a00:	3e490913          	addi	s2,s2,996 # de0 <malloc+0x2d8>
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
 a94:	5787b783          	ld	a5,1400(a5) # 2008 <freep>
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
 afe:	50f73723          	sd	a5,1294(a4) # 2008 <freep>
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
 b28:	4e453503          	ld	a0,1252(a0) # 2008 <freep>
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
 b58:	4b490913          	addi	s2,s2,1204 # 2008 <freep>
  if(p == (char*)-1)
 b5c:	5afd                	li	s5,-1
 b5e:	a081                	j	b9e <malloc+0x96>
 b60:	f04a                	sd	s2,32(sp)
 b62:	e852                	sd	s4,16(sp)
 b64:	e456                	sd	s5,8(sp)
 b66:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b68:	00001797          	auipc	a5,0x1
 b6c:	4a878793          	addi	a5,a5,1192 # 2010 <base>
 b70:	00001717          	auipc	a4,0x1
 b74:	48f73c23          	sd	a5,1176(a4) # 2008 <freep>
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
 baa:	b03ff0ef          	jal	6ac <sbrk>
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
 be2:	42a73523          	sd	a0,1066(a4) # 2008 <freep>
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
