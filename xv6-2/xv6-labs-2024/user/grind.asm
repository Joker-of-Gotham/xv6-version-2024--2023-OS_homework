
user/_grind：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <base+0x1d9f>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00002517          	auipc	a0,0x2
      64:	fa050513          	addi	a0,a0,-96 # 2000 <rand_next>
      68:	f99ff0ef          	jal	0 <do_rand>
}
      6c:	60a2                	ld	ra,8(sp)
      6e:	6402                	ld	s0,0(sp)
      70:	0141                	addi	sp,sp,16
      72:	8082                	ret

0000000000000074 <go>:

void
go(int which_child)
{
      74:	7119                	addi	sp,sp,-128
      76:	fc86                	sd	ra,120(sp)
      78:	f8a2                	sd	s0,112(sp)
      7a:	f4a6                	sd	s1,104(sp)
      7c:	e4d6                	sd	s5,72(sp)
      7e:	0100                	addi	s0,sp,128
      80:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      82:	4501                	li	a0,0
      84:	483000ef          	jal	d06 <sbrk>
      88:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      8a:	00001517          	auipc	a0,0x1
      8e:	20650513          	addi	a0,a0,518 # 1290 <malloc+0xfe>
      92:	455000ef          	jal	ce6 <mkdir>
  if(chdir("grindir") != 0){
      96:	00001517          	auipc	a0,0x1
      9a:	1fa50513          	addi	a0,a0,506 # 1290 <malloc+0xfe>
      9e:	451000ef          	jal	cee <chdir>
      a2:	cd19                	beqz	a0,c0 <go+0x4c>
      a4:	f0ca                	sd	s2,96(sp)
      a6:	ecce                	sd	s3,88(sp)
      a8:	e8d2                	sd	s4,80(sp)
      aa:	e0da                	sd	s6,64(sp)
      ac:	fc5e                	sd	s7,56(sp)
    printf("grind: chdir grindir failed\n");
      ae:	00001517          	auipc	a0,0x1
      b2:	1ea50513          	addi	a0,a0,490 # 1298 <malloc+0x106>
      b6:	028010ef          	jal	10de <printf>
    exit(1);
      ba:	4505                	li	a0,1
      bc:	3c3000ef          	jal	c7e <exit>
      c0:	f0ca                	sd	s2,96(sp)
      c2:	ecce                	sd	s3,88(sp)
      c4:	e8d2                	sd	s4,80(sp)
      c6:	e0da                	sd	s6,64(sp)
      c8:	fc5e                	sd	s7,56(sp)
  }
  chdir("/");
      ca:	00001517          	auipc	a0,0x1
      ce:	1f650513          	addi	a0,a0,502 # 12c0 <malloc+0x12e>
      d2:	41d000ef          	jal	cee <chdir>
      d6:	00001997          	auipc	s3,0x1
      da:	1fa98993          	addi	s3,s3,506 # 12d0 <malloc+0x13e>
      de:	c489                	beqz	s1,e8 <go+0x74>
      e0:	00001997          	auipc	s3,0x1
      e4:	1e898993          	addi	s3,s3,488 # 12c8 <malloc+0x136>
  uint64 iters = 0;
      e8:	4481                	li	s1,0
  int fd = -1;
      ea:	5a7d                	li	s4,-1
      ec:	00001917          	auipc	s2,0x1
      f0:	4dc90913          	addi	s2,s2,1244 # 15c8 <malloc+0x436>
      f4:	a819                	j	10a <go+0x96>
    iters++;
    if((iters % 500) == 0)
      write(1, which_child?"B":"A", 1);
    int what = rand() % 23;
    if(what == 1){
      close(open("grindir/../a", O_CREATE|O_RDWR));
      f6:	20200593          	li	a1,514
      fa:	00001517          	auipc	a0,0x1
      fe:	1de50513          	addi	a0,a0,478 # 12d8 <malloc+0x146>
     102:	3bd000ef          	jal	cbe <open>
     106:	3a1000ef          	jal	ca6 <close>
    iters++;
     10a:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     10c:	1f400793          	li	a5,500
     110:	02f4f7b3          	remu	a5,s1,a5
     114:	e791                	bnez	a5,120 <go+0xac>
      write(1, which_child?"B":"A", 1);
     116:	4605                	li	a2,1
     118:	85ce                	mv	a1,s3
     11a:	4505                	li	a0,1
     11c:	383000ef          	jal	c9e <write>
    int what = rand() % 23;
     120:	f39ff0ef          	jal	58 <rand>
     124:	47dd                	li	a5,23
     126:	02f5653b          	remw	a0,a0,a5
     12a:	0005071b          	sext.w	a4,a0
     12e:	47d9                	li	a5,22
     130:	fce7ede3          	bltu	a5,a4,10a <go+0x96>
     134:	02051793          	slli	a5,a0,0x20
     138:	01e7d513          	srli	a0,a5,0x1e
     13c:	954a                	add	a0,a0,s2
     13e:	411c                	lw	a5,0(a0)
     140:	97ca                	add	a5,a5,s2
     142:	8782                	jr	a5
    } else if(what == 2){
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     144:	20200593          	li	a1,514
     148:	00001517          	auipc	a0,0x1
     14c:	1a050513          	addi	a0,a0,416 # 12e8 <malloc+0x156>
     150:	36f000ef          	jal	cbe <open>
     154:	353000ef          	jal	ca6 <close>
     158:	bf4d                	j	10a <go+0x96>
    } else if(what == 3){
      unlink("grindir/../a");
     15a:	00001517          	auipc	a0,0x1
     15e:	17e50513          	addi	a0,a0,382 # 12d8 <malloc+0x146>
     162:	36d000ef          	jal	cce <unlink>
     166:	b755                	j	10a <go+0x96>
    } else if(what == 4){
      if(chdir("grindir") != 0){
     168:	00001517          	auipc	a0,0x1
     16c:	12850513          	addi	a0,a0,296 # 1290 <malloc+0xfe>
     170:	37f000ef          	jal	cee <chdir>
     174:	ed11                	bnez	a0,190 <go+0x11c>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     176:	00001517          	auipc	a0,0x1
     17a:	18a50513          	addi	a0,a0,394 # 1300 <malloc+0x16e>
     17e:	351000ef          	jal	cce <unlink>
      chdir("/");
     182:	00001517          	auipc	a0,0x1
     186:	13e50513          	addi	a0,a0,318 # 12c0 <malloc+0x12e>
     18a:	365000ef          	jal	cee <chdir>
     18e:	bfb5                	j	10a <go+0x96>
        printf("grind: chdir grindir failed\n");
     190:	00001517          	auipc	a0,0x1
     194:	10850513          	addi	a0,a0,264 # 1298 <malloc+0x106>
     198:	747000ef          	jal	10de <printf>
        exit(1);
     19c:	4505                	li	a0,1
     19e:	2e1000ef          	jal	c7e <exit>
    } else if(what == 5){
      close(fd);
     1a2:	8552                	mv	a0,s4
     1a4:	303000ef          	jal	ca6 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     1a8:	20200593          	li	a1,514
     1ac:	00001517          	auipc	a0,0x1
     1b0:	15c50513          	addi	a0,a0,348 # 1308 <malloc+0x176>
     1b4:	30b000ef          	jal	cbe <open>
     1b8:	8a2a                	mv	s4,a0
     1ba:	bf81                	j	10a <go+0x96>
    } else if(what == 6){
      close(fd);
     1bc:	8552                	mv	a0,s4
     1be:	2e9000ef          	jal	ca6 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     1c2:	20200593          	li	a1,514
     1c6:	00001517          	auipc	a0,0x1
     1ca:	15250513          	addi	a0,a0,338 # 1318 <malloc+0x186>
     1ce:	2f1000ef          	jal	cbe <open>
     1d2:	8a2a                	mv	s4,a0
     1d4:	bf1d                	j	10a <go+0x96>
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
     1d6:	3e700613          	li	a2,999
     1da:	00002597          	auipc	a1,0x2
     1de:	e4658593          	addi	a1,a1,-442 # 2020 <buf.0>
     1e2:	8552                	mv	a0,s4
     1e4:	2bb000ef          	jal	c9e <write>
     1e8:	b70d                	j	10a <go+0x96>
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     1ea:	3e700613          	li	a2,999
     1ee:	00002597          	auipc	a1,0x2
     1f2:	e3258593          	addi	a1,a1,-462 # 2020 <buf.0>
     1f6:	8552                	mv	a0,s4
     1f8:	29f000ef          	jal	c96 <read>
     1fc:	b739                	j	10a <go+0x96>
    } else if(what == 9){
      mkdir("grindir/../a");
     1fe:	00001517          	auipc	a0,0x1
     202:	0da50513          	addi	a0,a0,218 # 12d8 <malloc+0x146>
     206:	2e1000ef          	jal	ce6 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     20a:	20200593          	li	a1,514
     20e:	00001517          	auipc	a0,0x1
     212:	12250513          	addi	a0,a0,290 # 1330 <malloc+0x19e>
     216:	2a9000ef          	jal	cbe <open>
     21a:	28d000ef          	jal	ca6 <close>
      unlink("a/a");
     21e:	00001517          	auipc	a0,0x1
     222:	12250513          	addi	a0,a0,290 # 1340 <malloc+0x1ae>
     226:	2a9000ef          	jal	cce <unlink>
     22a:	b5c5                	j	10a <go+0x96>
    } else if(what == 10){
      mkdir("/../b");
     22c:	00001517          	auipc	a0,0x1
     230:	11c50513          	addi	a0,a0,284 # 1348 <malloc+0x1b6>
     234:	2b3000ef          	jal	ce6 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     238:	20200593          	li	a1,514
     23c:	00001517          	auipc	a0,0x1
     240:	11450513          	addi	a0,a0,276 # 1350 <malloc+0x1be>
     244:	27b000ef          	jal	cbe <open>
     248:	25f000ef          	jal	ca6 <close>
      unlink("b/b");
     24c:	00001517          	auipc	a0,0x1
     250:	11450513          	addi	a0,a0,276 # 1360 <malloc+0x1ce>
     254:	27b000ef          	jal	cce <unlink>
     258:	bd4d                	j	10a <go+0x96>
    } else if(what == 11){
      unlink("b");
     25a:	00001517          	auipc	a0,0x1
     25e:	10e50513          	addi	a0,a0,270 # 1368 <malloc+0x1d6>
     262:	26d000ef          	jal	cce <unlink>
      link("../grindir/./../a", "../b");
     266:	00001597          	auipc	a1,0x1
     26a:	09a58593          	addi	a1,a1,154 # 1300 <malloc+0x16e>
     26e:	00001517          	auipc	a0,0x1
     272:	10250513          	addi	a0,a0,258 # 1370 <malloc+0x1de>
     276:	269000ef          	jal	cde <link>
     27a:	bd41                	j	10a <go+0x96>
    } else if(what == 12){
      unlink("../grindir/../a");
     27c:	00001517          	auipc	a0,0x1
     280:	10c50513          	addi	a0,a0,268 # 1388 <malloc+0x1f6>
     284:	24b000ef          	jal	cce <unlink>
      link(".././b", "/grindir/../a");
     288:	00001597          	auipc	a1,0x1
     28c:	08058593          	addi	a1,a1,128 # 1308 <malloc+0x176>
     290:	00001517          	auipc	a0,0x1
     294:	10850513          	addi	a0,a0,264 # 1398 <malloc+0x206>
     298:	247000ef          	jal	cde <link>
     29c:	b5bd                	j	10a <go+0x96>
    } else if(what == 13){
      int pid = fork();
     29e:	1d9000ef          	jal	c76 <fork>
      if(pid == 0){
     2a2:	c519                	beqz	a0,2b0 <go+0x23c>
        exit(0);
      } else if(pid < 0){
     2a4:	00054863          	bltz	a0,2b4 <go+0x240>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     2a8:	4501                	li	a0,0
     2aa:	1dd000ef          	jal	c86 <wait>
     2ae:	bdb1                	j	10a <go+0x96>
        exit(0);
     2b0:	1cf000ef          	jal	c7e <exit>
        printf("grind: fork failed\n");
     2b4:	00001517          	auipc	a0,0x1
     2b8:	0ec50513          	addi	a0,a0,236 # 13a0 <malloc+0x20e>
     2bc:	623000ef          	jal	10de <printf>
        exit(1);
     2c0:	4505                	li	a0,1
     2c2:	1bd000ef          	jal	c7e <exit>
    } else if(what == 14){
      int pid = fork();
     2c6:	1b1000ef          	jal	c76 <fork>
      if(pid == 0){
     2ca:	c519                	beqz	a0,2d8 <go+0x264>
        fork();
        fork();
        exit(0);
      } else if(pid < 0){
     2cc:	00054d63          	bltz	a0,2e6 <go+0x272>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     2d0:	4501                	li	a0,0
     2d2:	1b5000ef          	jal	c86 <wait>
     2d6:	bd15                	j	10a <go+0x96>
        fork();
     2d8:	19f000ef          	jal	c76 <fork>
        fork();
     2dc:	19b000ef          	jal	c76 <fork>
        exit(0);
     2e0:	4501                	li	a0,0
     2e2:	19d000ef          	jal	c7e <exit>
        printf("grind: fork failed\n");
     2e6:	00001517          	auipc	a0,0x1
     2ea:	0ba50513          	addi	a0,a0,186 # 13a0 <malloc+0x20e>
     2ee:	5f1000ef          	jal	10de <printf>
        exit(1);
     2f2:	4505                	li	a0,1
     2f4:	18b000ef          	jal	c7e <exit>
    } else if(what == 15){
      sbrk(6011);
     2f8:	6505                	lui	a0,0x1
     2fa:	77b50513          	addi	a0,a0,1915 # 177b <digits+0x153>
     2fe:	209000ef          	jal	d06 <sbrk>
     302:	b521                	j	10a <go+0x96>
    } else if(what == 16){
      if(sbrk(0) > break0)
     304:	4501                	li	a0,0
     306:	201000ef          	jal	d06 <sbrk>
     30a:	e0aaf0e3          	bgeu	s5,a0,10a <go+0x96>
        sbrk(-(sbrk(0) - break0));
     30e:	4501                	li	a0,0
     310:	1f7000ef          	jal	d06 <sbrk>
     314:	40aa853b          	subw	a0,s5,a0
     318:	1ef000ef          	jal	d06 <sbrk>
     31c:	b3fd                	j	10a <go+0x96>
    } else if(what == 17){
      int pid = fork();
     31e:	159000ef          	jal	c76 <fork>
     322:	8b2a                	mv	s6,a0
      if(pid == 0){
     324:	c10d                	beqz	a0,346 <go+0x2d2>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
     326:	02054d63          	bltz	a0,360 <go+0x2ec>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
     32a:	00001517          	auipc	a0,0x1
     32e:	09650513          	addi	a0,a0,150 # 13c0 <malloc+0x22e>
     332:	1bd000ef          	jal	cee <chdir>
     336:	ed15                	bnez	a0,372 <go+0x2fe>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     338:	855a                	mv	a0,s6
     33a:	175000ef          	jal	cae <kill>
      wait(0);
     33e:	4501                	li	a0,0
     340:	147000ef          	jal	c86 <wait>
     344:	b3d9                	j	10a <go+0x96>
        close(open("a", O_CREATE|O_RDWR));
     346:	20200593          	li	a1,514
     34a:	00001517          	auipc	a0,0x1
     34e:	06e50513          	addi	a0,a0,110 # 13b8 <malloc+0x226>
     352:	16d000ef          	jal	cbe <open>
     356:	151000ef          	jal	ca6 <close>
        exit(0);
     35a:	4501                	li	a0,0
     35c:	123000ef          	jal	c7e <exit>
        printf("grind: fork failed\n");
     360:	00001517          	auipc	a0,0x1
     364:	04050513          	addi	a0,a0,64 # 13a0 <malloc+0x20e>
     368:	577000ef          	jal	10de <printf>
        exit(1);
     36c:	4505                	li	a0,1
     36e:	111000ef          	jal	c7e <exit>
        printf("grind: chdir failed\n");
     372:	00001517          	auipc	a0,0x1
     376:	05e50513          	addi	a0,a0,94 # 13d0 <malloc+0x23e>
     37a:	565000ef          	jal	10de <printf>
        exit(1);
     37e:	4505                	li	a0,1
     380:	0ff000ef          	jal	c7e <exit>
    } else if(what == 18){
      int pid = fork();
     384:	0f3000ef          	jal	c76 <fork>
      if(pid == 0){
     388:	c519                	beqz	a0,396 <go+0x322>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
     38a:	00054d63          	bltz	a0,3a4 <go+0x330>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     38e:	4501                	li	a0,0
     390:	0f7000ef          	jal	c86 <wait>
     394:	bb9d                	j	10a <go+0x96>
        kill(getpid());
     396:	169000ef          	jal	cfe <getpid>
     39a:	115000ef          	jal	cae <kill>
        exit(0);
     39e:	4501                	li	a0,0
     3a0:	0df000ef          	jal	c7e <exit>
        printf("grind: fork failed\n");
     3a4:	00001517          	auipc	a0,0x1
     3a8:	ffc50513          	addi	a0,a0,-4 # 13a0 <malloc+0x20e>
     3ac:	533000ef          	jal	10de <printf>
        exit(1);
     3b0:	4505                	li	a0,1
     3b2:	0cd000ef          	jal	c7e <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     3b6:	f9840513          	addi	a0,s0,-104
     3ba:	0d5000ef          	jal	c8e <pipe>
     3be:	02054363          	bltz	a0,3e4 <go+0x370>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     3c2:	0b5000ef          	jal	c76 <fork>
      if(pid == 0){
     3c6:	c905                	beqz	a0,3f6 <go+0x382>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
     3c8:	08054263          	bltz	a0,44c <go+0x3d8>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     3cc:	f9842503          	lw	a0,-104(s0)
     3d0:	0d7000ef          	jal	ca6 <close>
      close(fds[1]);
     3d4:	f9c42503          	lw	a0,-100(s0)
     3d8:	0cf000ef          	jal	ca6 <close>
      wait(0);
     3dc:	4501                	li	a0,0
     3de:	0a9000ef          	jal	c86 <wait>
     3e2:	b325                	j	10a <go+0x96>
        printf("grind: pipe failed\n");
     3e4:	00001517          	auipc	a0,0x1
     3e8:	00450513          	addi	a0,a0,4 # 13e8 <malloc+0x256>
     3ec:	4f3000ef          	jal	10de <printf>
        exit(1);
     3f0:	4505                	li	a0,1
     3f2:	08d000ef          	jal	c7e <exit>
        fork();
     3f6:	081000ef          	jal	c76 <fork>
        fork();
     3fa:	07d000ef          	jal	c76 <fork>
        if(write(fds[1], "x", 1) != 1)
     3fe:	4605                	li	a2,1
     400:	00001597          	auipc	a1,0x1
     404:	00058593          	mv	a1,a1
     408:	f9c42503          	lw	a0,-100(s0)
     40c:	093000ef          	jal	c9e <write>
     410:	4785                	li	a5,1
     412:	00f51f63          	bne	a0,a5,430 <go+0x3bc>
        if(read(fds[0], &c, 1) != 1)
     416:	4605                	li	a2,1
     418:	f9040593          	addi	a1,s0,-112
     41c:	f9842503          	lw	a0,-104(s0)
     420:	077000ef          	jal	c96 <read>
     424:	4785                	li	a5,1
     426:	00f51c63          	bne	a0,a5,43e <go+0x3ca>
        exit(0);
     42a:	4501                	li	a0,0
     42c:	053000ef          	jal	c7e <exit>
          printf("grind: pipe write failed\n");
     430:	00001517          	auipc	a0,0x1
     434:	fd850513          	addi	a0,a0,-40 # 1408 <malloc+0x276>
     438:	4a7000ef          	jal	10de <printf>
     43c:	bfe9                	j	416 <go+0x3a2>
          printf("grind: pipe read failed\n");
     43e:	00001517          	auipc	a0,0x1
     442:	fea50513          	addi	a0,a0,-22 # 1428 <malloc+0x296>
     446:	499000ef          	jal	10de <printf>
     44a:	b7c5                	j	42a <go+0x3b6>
        printf("grind: fork failed\n");
     44c:	00001517          	auipc	a0,0x1
     450:	f5450513          	addi	a0,a0,-172 # 13a0 <malloc+0x20e>
     454:	48b000ef          	jal	10de <printf>
        exit(1);
     458:	4505                	li	a0,1
     45a:	025000ef          	jal	c7e <exit>
    } else if(what == 20){
      int pid = fork();
     45e:	019000ef          	jal	c76 <fork>
      if(pid == 0){
     462:	c519                	beqz	a0,470 <go+0x3fc>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
     464:	04054f63          	bltz	a0,4c2 <go+0x44e>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     468:	4501                	li	a0,0
     46a:	01d000ef          	jal	c86 <wait>
     46e:	b971                	j	10a <go+0x96>
        unlink("a");
     470:	00001517          	auipc	a0,0x1
     474:	f4850513          	addi	a0,a0,-184 # 13b8 <malloc+0x226>
     478:	057000ef          	jal	cce <unlink>
        mkdir("a");
     47c:	00001517          	auipc	a0,0x1
     480:	f3c50513          	addi	a0,a0,-196 # 13b8 <malloc+0x226>
     484:	063000ef          	jal	ce6 <mkdir>
        chdir("a");
     488:	00001517          	auipc	a0,0x1
     48c:	f3050513          	addi	a0,a0,-208 # 13b8 <malloc+0x226>
     490:	05f000ef          	jal	cee <chdir>
        unlink("../a");
     494:	00001517          	auipc	a0,0x1
     498:	fb450513          	addi	a0,a0,-76 # 1448 <malloc+0x2b6>
     49c:	033000ef          	jal	cce <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     4a0:	20200593          	li	a1,514
     4a4:	00001517          	auipc	a0,0x1
     4a8:	f5c50513          	addi	a0,a0,-164 # 1400 <malloc+0x26e>
     4ac:	013000ef          	jal	cbe <open>
        unlink("x");
     4b0:	00001517          	auipc	a0,0x1
     4b4:	f5050513          	addi	a0,a0,-176 # 1400 <malloc+0x26e>
     4b8:	017000ef          	jal	cce <unlink>
        exit(0);
     4bc:	4501                	li	a0,0
     4be:	7c0000ef          	jal	c7e <exit>
        printf("grind: fork failed\n");
     4c2:	00001517          	auipc	a0,0x1
     4c6:	ede50513          	addi	a0,a0,-290 # 13a0 <malloc+0x20e>
     4ca:	415000ef          	jal	10de <printf>
        exit(1);
     4ce:	4505                	li	a0,1
     4d0:	7ae000ef          	jal	c7e <exit>
    } else if(what == 21){
      unlink("c");
     4d4:	00001517          	auipc	a0,0x1
     4d8:	f7c50513          	addi	a0,a0,-132 # 1450 <malloc+0x2be>
     4dc:	7f2000ef          	jal	cce <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
     4e0:	20200593          	li	a1,514
     4e4:	00001517          	auipc	a0,0x1
     4e8:	f6c50513          	addi	a0,a0,-148 # 1450 <malloc+0x2be>
     4ec:	7d2000ef          	jal	cbe <open>
     4f0:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     4f2:	04054763          	bltz	a0,540 <go+0x4cc>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     4f6:	4605                	li	a2,1
     4f8:	00001597          	auipc	a1,0x1
     4fc:	f0858593          	addi	a1,a1,-248 # 1400 <malloc+0x26e>
     500:	79e000ef          	jal	c9e <write>
     504:	4785                	li	a5,1
     506:	04f51663          	bne	a0,a5,552 <go+0x4de>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     50a:	f9840593          	addi	a1,s0,-104
     50e:	855a                	mv	a0,s6
     510:	7c6000ef          	jal	cd6 <fstat>
     514:	e921                	bnez	a0,564 <go+0x4f0>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
     516:	fa843583          	ld	a1,-88(s0)
     51a:	4785                	li	a5,1
     51c:	04f59d63          	bne	a1,a5,576 <go+0x502>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
     520:	f9c42583          	lw	a1,-100(s0)
     524:	0c800793          	li	a5,200
     528:	06b7e163          	bltu	a5,a1,58a <go+0x516>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     52c:	855a                	mv	a0,s6
     52e:	778000ef          	jal	ca6 <close>
      unlink("c");
     532:	00001517          	auipc	a0,0x1
     536:	f1e50513          	addi	a0,a0,-226 # 1450 <malloc+0x2be>
     53a:	794000ef          	jal	cce <unlink>
     53e:	b6f1                	j	10a <go+0x96>
        printf("grind: create c failed\n");
     540:	00001517          	auipc	a0,0x1
     544:	f1850513          	addi	a0,a0,-232 # 1458 <malloc+0x2c6>
     548:	397000ef          	jal	10de <printf>
        exit(1);
     54c:	4505                	li	a0,1
     54e:	730000ef          	jal	c7e <exit>
        printf("grind: write c failed\n");
     552:	00001517          	auipc	a0,0x1
     556:	f1e50513          	addi	a0,a0,-226 # 1470 <malloc+0x2de>
     55a:	385000ef          	jal	10de <printf>
        exit(1);
     55e:	4505                	li	a0,1
     560:	71e000ef          	jal	c7e <exit>
        printf("grind: fstat failed\n");
     564:	00001517          	auipc	a0,0x1
     568:	f2450513          	addi	a0,a0,-220 # 1488 <malloc+0x2f6>
     56c:	373000ef          	jal	10de <printf>
        exit(1);
     570:	4505                	li	a0,1
     572:	70c000ef          	jal	c7e <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     576:	2581                	sext.w	a1,a1
     578:	00001517          	auipc	a0,0x1
     57c:	f2850513          	addi	a0,a0,-216 # 14a0 <malloc+0x30e>
     580:	35f000ef          	jal	10de <printf>
        exit(1);
     584:	4505                	li	a0,1
     586:	6f8000ef          	jal	c7e <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     58a:	00001517          	auipc	a0,0x1
     58e:	f3e50513          	addi	a0,a0,-194 # 14c8 <malloc+0x336>
     592:	34d000ef          	jal	10de <printf>
        exit(1);
     596:	4505                	li	a0,1
     598:	6e6000ef          	jal	c7e <exit>
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     59c:	f8840513          	addi	a0,s0,-120
     5a0:	6ee000ef          	jal	c8e <pipe>
     5a4:	0a054563          	bltz	a0,64e <go+0x5da>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     5a8:	f9040513          	addi	a0,s0,-112
     5ac:	6e2000ef          	jal	c8e <pipe>
     5b0:	0a054963          	bltz	a0,662 <go+0x5ee>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     5b4:	6c2000ef          	jal	c76 <fork>
      if(pid1 == 0){
     5b8:	cd5d                	beqz	a0,676 <go+0x602>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     5ba:	14054263          	bltz	a0,6fe <go+0x68a>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     5be:	6b8000ef          	jal	c76 <fork>
      if(pid2 == 0){
     5c2:	14050863          	beqz	a0,712 <go+0x69e>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     5c6:	1e054663          	bltz	a0,7b2 <go+0x73e>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     5ca:	f8842503          	lw	a0,-120(s0)
     5ce:	6d8000ef          	jal	ca6 <close>
      close(aa[1]);
     5d2:	f8c42503          	lw	a0,-116(s0)
     5d6:	6d0000ef          	jal	ca6 <close>
      close(bb[1]);
     5da:	f9442503          	lw	a0,-108(s0)
     5de:	6c8000ef          	jal	ca6 <close>
      char buf[4] = { 0, 0, 0, 0 };
     5e2:	f8042023          	sw	zero,-128(s0)
      read(bb[0], buf+0, 1);
     5e6:	4605                	li	a2,1
     5e8:	f8040593          	addi	a1,s0,-128
     5ec:	f9042503          	lw	a0,-112(s0)
     5f0:	6a6000ef          	jal	c96 <read>
      read(bb[0], buf+1, 1);
     5f4:	4605                	li	a2,1
     5f6:	f8140593          	addi	a1,s0,-127
     5fa:	f9042503          	lw	a0,-112(s0)
     5fe:	698000ef          	jal	c96 <read>
      read(bb[0], buf+2, 1);
     602:	4605                	li	a2,1
     604:	f8240593          	addi	a1,s0,-126
     608:	f9042503          	lw	a0,-112(s0)
     60c:	68a000ef          	jal	c96 <read>
      close(bb[0]);
     610:	f9042503          	lw	a0,-112(s0)
     614:	692000ef          	jal	ca6 <close>
      int st1, st2;
      wait(&st1);
     618:	f8440513          	addi	a0,s0,-124
     61c:	66a000ef          	jal	c86 <wait>
      wait(&st2);
     620:	f9840513          	addi	a0,s0,-104
     624:	662000ef          	jal	c86 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     628:	f8442783          	lw	a5,-124(s0)
     62c:	f9842b83          	lw	s7,-104(s0)
     630:	0177eb33          	or	s6,a5,s7
     634:	180b1963          	bnez	s6,7c6 <go+0x752>
     638:	00001597          	auipc	a1,0x1
     63c:	f3058593          	addi	a1,a1,-208 # 1568 <malloc+0x3d6>
     640:	f8040513          	addi	a0,s0,-128
     644:	2ce000ef          	jal	912 <strcmp>
     648:	ac0501e3          	beqz	a0,10a <go+0x96>
     64c:	aab5                	j	7c8 <go+0x754>
        fprintf(2, "grind: pipe failed\n");
     64e:	00001597          	auipc	a1,0x1
     652:	d9a58593          	addi	a1,a1,-614 # 13e8 <malloc+0x256>
     656:	4509                	li	a0,2
     658:	25d000ef          	jal	10b4 <fprintf>
        exit(1);
     65c:	4505                	li	a0,1
     65e:	620000ef          	jal	c7e <exit>
        fprintf(2, "grind: pipe failed\n");
     662:	00001597          	auipc	a1,0x1
     666:	d8658593          	addi	a1,a1,-634 # 13e8 <malloc+0x256>
     66a:	4509                	li	a0,2
     66c:	249000ef          	jal	10b4 <fprintf>
        exit(1);
     670:	4505                	li	a0,1
     672:	60c000ef          	jal	c7e <exit>
        close(bb[0]);
     676:	f9042503          	lw	a0,-112(s0)
     67a:	62c000ef          	jal	ca6 <close>
        close(bb[1]);
     67e:	f9442503          	lw	a0,-108(s0)
     682:	624000ef          	jal	ca6 <close>
        close(aa[0]);
     686:	f8842503          	lw	a0,-120(s0)
     68a:	61c000ef          	jal	ca6 <close>
        close(1);
     68e:	4505                	li	a0,1
     690:	616000ef          	jal	ca6 <close>
        if(dup(aa[1]) != 1){
     694:	f8c42503          	lw	a0,-116(s0)
     698:	65e000ef          	jal	cf6 <dup>
     69c:	4785                	li	a5,1
     69e:	00f50c63          	beq	a0,a5,6b6 <go+0x642>
          fprintf(2, "grind: dup failed\n");
     6a2:	00001597          	auipc	a1,0x1
     6a6:	e4e58593          	addi	a1,a1,-434 # 14f0 <malloc+0x35e>
     6aa:	4509                	li	a0,2
     6ac:	209000ef          	jal	10b4 <fprintf>
          exit(1);
     6b0:	4505                	li	a0,1
     6b2:	5cc000ef          	jal	c7e <exit>
        close(aa[1]);
     6b6:	f8c42503          	lw	a0,-116(s0)
     6ba:	5ec000ef          	jal	ca6 <close>
        char *args[3] = { "echo", "hi", 0 };
     6be:	00001797          	auipc	a5,0x1
     6c2:	e4a78793          	addi	a5,a5,-438 # 1508 <malloc+0x376>
     6c6:	f8f43c23          	sd	a5,-104(s0)
     6ca:	00001797          	auipc	a5,0x1
     6ce:	e4678793          	addi	a5,a5,-442 # 1510 <malloc+0x37e>
     6d2:	faf43023          	sd	a5,-96(s0)
     6d6:	fa043423          	sd	zero,-88(s0)
        exec("grindir/../echo", args);
     6da:	f9840593          	addi	a1,s0,-104
     6de:	00001517          	auipc	a0,0x1
     6e2:	e3a50513          	addi	a0,a0,-454 # 1518 <malloc+0x386>
     6e6:	5d0000ef          	jal	cb6 <exec>
        fprintf(2, "grind: echo: not found\n");
     6ea:	00001597          	auipc	a1,0x1
     6ee:	e3e58593          	addi	a1,a1,-450 # 1528 <malloc+0x396>
     6f2:	4509                	li	a0,2
     6f4:	1c1000ef          	jal	10b4 <fprintf>
        exit(2);
     6f8:	4509                	li	a0,2
     6fa:	584000ef          	jal	c7e <exit>
        fprintf(2, "grind: fork failed\n");
     6fe:	00001597          	auipc	a1,0x1
     702:	ca258593          	addi	a1,a1,-862 # 13a0 <malloc+0x20e>
     706:	4509                	li	a0,2
     708:	1ad000ef          	jal	10b4 <fprintf>
        exit(3);
     70c:	450d                	li	a0,3
     70e:	570000ef          	jal	c7e <exit>
        close(aa[1]);
     712:	f8c42503          	lw	a0,-116(s0)
     716:	590000ef          	jal	ca6 <close>
        close(bb[0]);
     71a:	f9042503          	lw	a0,-112(s0)
     71e:	588000ef          	jal	ca6 <close>
        close(0);
     722:	4501                	li	a0,0
     724:	582000ef          	jal	ca6 <close>
        if(dup(aa[0]) != 0){
     728:	f8842503          	lw	a0,-120(s0)
     72c:	5ca000ef          	jal	cf6 <dup>
     730:	c919                	beqz	a0,746 <go+0x6d2>
          fprintf(2, "grind: dup failed\n");
     732:	00001597          	auipc	a1,0x1
     736:	dbe58593          	addi	a1,a1,-578 # 14f0 <malloc+0x35e>
     73a:	4509                	li	a0,2
     73c:	179000ef          	jal	10b4 <fprintf>
          exit(4);
     740:	4511                	li	a0,4
     742:	53c000ef          	jal	c7e <exit>
        close(aa[0]);
     746:	f8842503          	lw	a0,-120(s0)
     74a:	55c000ef          	jal	ca6 <close>
        close(1);
     74e:	4505                	li	a0,1
     750:	556000ef          	jal	ca6 <close>
        if(dup(bb[1]) != 1){
     754:	f9442503          	lw	a0,-108(s0)
     758:	59e000ef          	jal	cf6 <dup>
     75c:	4785                	li	a5,1
     75e:	00f50c63          	beq	a0,a5,776 <go+0x702>
          fprintf(2, "grind: dup failed\n");
     762:	00001597          	auipc	a1,0x1
     766:	d8e58593          	addi	a1,a1,-626 # 14f0 <malloc+0x35e>
     76a:	4509                	li	a0,2
     76c:	149000ef          	jal	10b4 <fprintf>
          exit(5);
     770:	4515                	li	a0,5
     772:	50c000ef          	jal	c7e <exit>
        close(bb[1]);
     776:	f9442503          	lw	a0,-108(s0)
     77a:	52c000ef          	jal	ca6 <close>
        char *args[2] = { "cat", 0 };
     77e:	00001797          	auipc	a5,0x1
     782:	dc278793          	addi	a5,a5,-574 # 1540 <malloc+0x3ae>
     786:	f8f43c23          	sd	a5,-104(s0)
     78a:	fa043023          	sd	zero,-96(s0)
        exec("/cat", args);
     78e:	f9840593          	addi	a1,s0,-104
     792:	00001517          	auipc	a0,0x1
     796:	db650513          	addi	a0,a0,-586 # 1548 <malloc+0x3b6>
     79a:	51c000ef          	jal	cb6 <exec>
        fprintf(2, "grind: cat: not found\n");
     79e:	00001597          	auipc	a1,0x1
     7a2:	db258593          	addi	a1,a1,-590 # 1550 <malloc+0x3be>
     7a6:	4509                	li	a0,2
     7a8:	10d000ef          	jal	10b4 <fprintf>
        exit(6);
     7ac:	4519                	li	a0,6
     7ae:	4d0000ef          	jal	c7e <exit>
        fprintf(2, "grind: fork failed\n");
     7b2:	00001597          	auipc	a1,0x1
     7b6:	bee58593          	addi	a1,a1,-1042 # 13a0 <malloc+0x20e>
     7ba:	4509                	li	a0,2
     7bc:	0f9000ef          	jal	10b4 <fprintf>
        exit(7);
     7c0:	451d                	li	a0,7
     7c2:	4bc000ef          	jal	c7e <exit>
     7c6:	8b3e                	mv	s6,a5
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     7c8:	f8040693          	addi	a3,s0,-128
     7cc:	865e                	mv	a2,s7
     7ce:	85da                	mv	a1,s6
     7d0:	00001517          	auipc	a0,0x1
     7d4:	da050513          	addi	a0,a0,-608 # 1570 <malloc+0x3de>
     7d8:	107000ef          	jal	10de <printf>
        exit(1);
     7dc:	4505                	li	a0,1
     7de:	4a0000ef          	jal	c7e <exit>

00000000000007e2 <iter>:
  }
}

void
iter()
{
     7e2:	7179                	addi	sp,sp,-48
     7e4:	f406                	sd	ra,40(sp)
     7e6:	f022                	sd	s0,32(sp)
     7e8:	1800                	addi	s0,sp,48
  unlink("a");
     7ea:	00001517          	auipc	a0,0x1
     7ee:	bce50513          	addi	a0,a0,-1074 # 13b8 <malloc+0x226>
     7f2:	4dc000ef          	jal	cce <unlink>
  unlink("b");
     7f6:	00001517          	auipc	a0,0x1
     7fa:	b7250513          	addi	a0,a0,-1166 # 1368 <malloc+0x1d6>
     7fe:	4d0000ef          	jal	cce <unlink>
  
  int pid1 = fork();
     802:	474000ef          	jal	c76 <fork>
  if(pid1 < 0){
     806:	02054163          	bltz	a0,828 <iter+0x46>
     80a:	ec26                	sd	s1,24(sp)
     80c:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     80e:	e905                	bnez	a0,83e <iter+0x5c>
     810:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     812:	00001717          	auipc	a4,0x1
     816:	7ee70713          	addi	a4,a4,2030 # 2000 <rand_next>
     81a:	631c                	ld	a5,0(a4)
     81c:	01f7c793          	xori	a5,a5,31
     820:	e31c                	sd	a5,0(a4)
    go(0);
     822:	4501                	li	a0,0
     824:	851ff0ef          	jal	74 <go>
     828:	ec26                	sd	s1,24(sp)
     82a:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     82c:	00001517          	auipc	a0,0x1
     830:	b7450513          	addi	a0,a0,-1164 # 13a0 <malloc+0x20e>
     834:	0ab000ef          	jal	10de <printf>
    exit(1);
     838:	4505                	li	a0,1
     83a:	444000ef          	jal	c7e <exit>
     83e:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     840:	436000ef          	jal	c76 <fork>
     844:	892a                	mv	s2,a0
  if(pid2 < 0){
     846:	02054063          	bltz	a0,866 <iter+0x84>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     84a:	e51d                	bnez	a0,878 <iter+0x96>
    rand_next ^= 7177;
     84c:	00001697          	auipc	a3,0x1
     850:	7b468693          	addi	a3,a3,1972 # 2000 <rand_next>
     854:	629c                	ld	a5,0(a3)
     856:	6709                	lui	a4,0x2
     858:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x5e1>
     85c:	8fb9                	xor	a5,a5,a4
     85e:	e29c                	sd	a5,0(a3)
    go(1);
     860:	4505                	li	a0,1
     862:	813ff0ef          	jal	74 <go>
    printf("grind: fork failed\n");
     866:	00001517          	auipc	a0,0x1
     86a:	b3a50513          	addi	a0,a0,-1222 # 13a0 <malloc+0x20e>
     86e:	071000ef          	jal	10de <printf>
    exit(1);
     872:	4505                	li	a0,1
     874:	40a000ef          	jal	c7e <exit>
    exit(0);
  }

  int st1 = -1;
     878:	57fd                	li	a5,-1
     87a:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     87e:	fdc40513          	addi	a0,s0,-36
     882:	404000ef          	jal	c86 <wait>
  if(st1 != 0){
     886:	fdc42783          	lw	a5,-36(s0)
     88a:	eb99                	bnez	a5,8a0 <iter+0xbe>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     88c:	57fd                	li	a5,-1
     88e:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     892:	fd840513          	addi	a0,s0,-40
     896:	3f0000ef          	jal	c86 <wait>

  exit(0);
     89a:	4501                	li	a0,0
     89c:	3e2000ef          	jal	c7e <exit>
    kill(pid1);
     8a0:	8526                	mv	a0,s1
     8a2:	40c000ef          	jal	cae <kill>
    kill(pid2);
     8a6:	854a                	mv	a0,s2
     8a8:	406000ef          	jal	cae <kill>
     8ac:	b7c5                	j	88c <iter+0xaa>

00000000000008ae <main>:
}

int
main()
{
     8ae:	1101                	addi	sp,sp,-32
     8b0:	ec06                	sd	ra,24(sp)
     8b2:	e822                	sd	s0,16(sp)
     8b4:	e426                	sd	s1,8(sp)
     8b6:	1000                	addi	s0,sp,32
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
    rand_next += 1;
     8b8:	00001497          	auipc	s1,0x1
     8bc:	74848493          	addi	s1,s1,1864 # 2000 <rand_next>
     8c0:	a809                	j	8d2 <main+0x24>
      iter();
     8c2:	f21ff0ef          	jal	7e2 <iter>
    sleep(20);
     8c6:	4551                	li	a0,20
     8c8:	446000ef          	jal	d0e <sleep>
    rand_next += 1;
     8cc:	609c                	ld	a5,0(s1)
     8ce:	0785                	addi	a5,a5,1
     8d0:	e09c                	sd	a5,0(s1)
    int pid = fork();
     8d2:	3a4000ef          	jal	c76 <fork>
    if(pid == 0){
     8d6:	d575                	beqz	a0,8c2 <main+0x14>
    if(pid > 0){
     8d8:	fea057e3          	blez	a0,8c6 <main+0x18>
      wait(0);
     8dc:	4501                	li	a0,0
     8de:	3a8000ef          	jal	c86 <wait>
     8e2:	b7d5                	j	8c6 <main+0x18>

00000000000008e4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     8e4:	1141                	addi	sp,sp,-16
     8e6:	e406                	sd	ra,8(sp)
     8e8:	e022                	sd	s0,0(sp)
     8ea:	0800                	addi	s0,sp,16
  extern int main();
  main();
     8ec:	fc3ff0ef          	jal	8ae <main>
  exit(0);
     8f0:	4501                	li	a0,0
     8f2:	38c000ef          	jal	c7e <exit>

00000000000008f6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     8f6:	1141                	addi	sp,sp,-16
     8f8:	e422                	sd	s0,8(sp)
     8fa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     8fc:	87aa                	mv	a5,a0
     8fe:	0585                	addi	a1,a1,1
     900:	0785                	addi	a5,a5,1
     902:	fff5c703          	lbu	a4,-1(a1)
     906:	fee78fa3          	sb	a4,-1(a5)
     90a:	fb75                	bnez	a4,8fe <strcpy+0x8>
    ;
  return os;
}
     90c:	6422                	ld	s0,8(sp)
     90e:	0141                	addi	sp,sp,16
     910:	8082                	ret

0000000000000912 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     912:	1141                	addi	sp,sp,-16
     914:	e422                	sd	s0,8(sp)
     916:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     918:	00054783          	lbu	a5,0(a0)
     91c:	cb91                	beqz	a5,930 <strcmp+0x1e>
     91e:	0005c703          	lbu	a4,0(a1)
     922:	00f71763          	bne	a4,a5,930 <strcmp+0x1e>
    p++, q++;
     926:	0505                	addi	a0,a0,1
     928:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     92a:	00054783          	lbu	a5,0(a0)
     92e:	fbe5                	bnez	a5,91e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     930:	0005c503          	lbu	a0,0(a1)
}
     934:	40a7853b          	subw	a0,a5,a0
     938:	6422                	ld	s0,8(sp)
     93a:	0141                	addi	sp,sp,16
     93c:	8082                	ret

000000000000093e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
     93e:	1141                	addi	sp,sp,-16
     940:	e422                	sd	s0,8(sp)
     942:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q) {
     944:	ce11                	beqz	a2,960 <strncmp+0x22>
     946:	00054783          	lbu	a5,0(a0)
     94a:	cf89                	beqz	a5,964 <strncmp+0x26>
     94c:	0005c703          	lbu	a4,0(a1)
     950:	00f71a63          	bne	a4,a5,964 <strncmp+0x26>
    n--;
     954:	367d                	addiw	a2,a2,-1
    p++;
     956:	0505                	addi	a0,a0,1
    q++;
     958:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q) {
     95a:	f675                	bnez	a2,946 <strncmp+0x8>
  }
  if(n == 0)
    return 0;
     95c:	4501                	li	a0,0
     95e:	a801                	j	96e <strncmp+0x30>
     960:	4501                	li	a0,0
     962:	a031                	j	96e <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
     964:	00054503          	lbu	a0,0(a0)
     968:	0005c783          	lbu	a5,0(a1)
     96c:	9d1d                	subw	a0,a0,a5
}
     96e:	6422                	ld	s0,8(sp)
     970:	0141                	addi	sp,sp,16
     972:	8082                	ret

0000000000000974 <strlen>:

uint
strlen(const char *s)
{
     974:	1141                	addi	sp,sp,-16
     976:	e422                	sd	s0,8(sp)
     978:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     97a:	00054783          	lbu	a5,0(a0)
     97e:	cf91                	beqz	a5,99a <strlen+0x26>
     980:	0505                	addi	a0,a0,1
     982:	87aa                	mv	a5,a0
     984:	86be                	mv	a3,a5
     986:	0785                	addi	a5,a5,1
     988:	fff7c703          	lbu	a4,-1(a5)
     98c:	ff65                	bnez	a4,984 <strlen+0x10>
     98e:	40a6853b          	subw	a0,a3,a0
     992:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     994:	6422                	ld	s0,8(sp)
     996:	0141                	addi	sp,sp,16
     998:	8082                	ret
  for(n = 0; s[n]; n++)
     99a:	4501                	li	a0,0
     99c:	bfe5                	j	994 <strlen+0x20>

000000000000099e <memset>:

void*
memset(void *dst, int c, uint n)
{
     99e:	1141                	addi	sp,sp,-16
     9a0:	e422                	sd	s0,8(sp)
     9a2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     9a4:	ca19                	beqz	a2,9ba <memset+0x1c>
     9a6:	87aa                	mv	a5,a0
     9a8:	1602                	slli	a2,a2,0x20
     9aa:	9201                	srli	a2,a2,0x20
     9ac:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     9b0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     9b4:	0785                	addi	a5,a5,1
     9b6:	fee79de3          	bne	a5,a4,9b0 <memset+0x12>
  }
  return dst;
}
     9ba:	6422                	ld	s0,8(sp)
     9bc:	0141                	addi	sp,sp,16
     9be:	8082                	ret

00000000000009c0 <strchr>:

char*
strchr(const char *s, char c)
{
     9c0:	1141                	addi	sp,sp,-16
     9c2:	e422                	sd	s0,8(sp)
     9c4:	0800                	addi	s0,sp,16
  for(; *s; s++)
     9c6:	00054783          	lbu	a5,0(a0)
     9ca:	cb99                	beqz	a5,9e0 <strchr+0x20>
    if(*s == c)
     9cc:	00f58763          	beq	a1,a5,9da <strchr+0x1a>
  for(; *s; s++)
     9d0:	0505                	addi	a0,a0,1
     9d2:	00054783          	lbu	a5,0(a0)
     9d6:	fbfd                	bnez	a5,9cc <strchr+0xc>
      return (char*)s;
  return 0;
     9d8:	4501                	li	a0,0
}
     9da:	6422                	ld	s0,8(sp)
     9dc:	0141                	addi	sp,sp,16
     9de:	8082                	ret
  return 0;
     9e0:	4501                	li	a0,0
     9e2:	bfe5                	j	9da <strchr+0x1a>

00000000000009e4 <gets>:

char*
gets(char *buf, int max)
{
     9e4:	711d                	addi	sp,sp,-96
     9e6:	ec86                	sd	ra,88(sp)
     9e8:	e8a2                	sd	s0,80(sp)
     9ea:	e4a6                	sd	s1,72(sp)
     9ec:	e0ca                	sd	s2,64(sp)
     9ee:	fc4e                	sd	s3,56(sp)
     9f0:	f852                	sd	s4,48(sp)
     9f2:	f456                	sd	s5,40(sp)
     9f4:	f05a                	sd	s6,32(sp)
     9f6:	ec5e                	sd	s7,24(sp)
     9f8:	1080                	addi	s0,sp,96
     9fa:	8baa                	mv	s7,a0
     9fc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     9fe:	892a                	mv	s2,a0
     a00:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     a02:	4aa9                	li	s5,10
     a04:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     a06:	89a6                	mv	s3,s1
     a08:	2485                	addiw	s1,s1,1
     a0a:	0344d663          	bge	s1,s4,a36 <gets+0x52>
    cc = read(0, &c, 1);
     a0e:	4605                	li	a2,1
     a10:	faf40593          	addi	a1,s0,-81
     a14:	4501                	li	a0,0
     a16:	280000ef          	jal	c96 <read>
    if(cc < 1)
     a1a:	00a05e63          	blez	a0,a36 <gets+0x52>
    buf[i++] = c;
     a1e:	faf44783          	lbu	a5,-81(s0)
     a22:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     a26:	01578763          	beq	a5,s5,a34 <gets+0x50>
     a2a:	0905                	addi	s2,s2,1
     a2c:	fd679de3          	bne	a5,s6,a06 <gets+0x22>
    buf[i++] = c;
     a30:	89a6                	mv	s3,s1
     a32:	a011                	j	a36 <gets+0x52>
     a34:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     a36:	99de                	add	s3,s3,s7
     a38:	00098023          	sb	zero,0(s3)
  return buf;
}
     a3c:	855e                	mv	a0,s7
     a3e:	60e6                	ld	ra,88(sp)
     a40:	6446                	ld	s0,80(sp)
     a42:	64a6                	ld	s1,72(sp)
     a44:	6906                	ld	s2,64(sp)
     a46:	79e2                	ld	s3,56(sp)
     a48:	7a42                	ld	s4,48(sp)
     a4a:	7aa2                	ld	s5,40(sp)
     a4c:	7b02                	ld	s6,32(sp)
     a4e:	6be2                	ld	s7,24(sp)
     a50:	6125                	addi	sp,sp,96
     a52:	8082                	ret

0000000000000a54 <stat>:

int
stat(const char *n, struct stat *st)
{
     a54:	1101                	addi	sp,sp,-32
     a56:	ec06                	sd	ra,24(sp)
     a58:	e822                	sd	s0,16(sp)
     a5a:	e04a                	sd	s2,0(sp)
     a5c:	1000                	addi	s0,sp,32
     a5e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a60:	4581                	li	a1,0
     a62:	25c000ef          	jal	cbe <open>
  if(fd < 0)
     a66:	02054263          	bltz	a0,a8a <stat+0x36>
     a6a:	e426                	sd	s1,8(sp)
     a6c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a6e:	85ca                	mv	a1,s2
     a70:	266000ef          	jal	cd6 <fstat>
     a74:	892a                	mv	s2,a0
  close(fd);
     a76:	8526                	mv	a0,s1
     a78:	22e000ef          	jal	ca6 <close>
  return r;
     a7c:	64a2                	ld	s1,8(sp)
}
     a7e:	854a                	mv	a0,s2
     a80:	60e2                	ld	ra,24(sp)
     a82:	6442                	ld	s0,16(sp)
     a84:	6902                	ld	s2,0(sp)
     a86:	6105                	addi	sp,sp,32
     a88:	8082                	ret
    return -1;
     a8a:	597d                	li	s2,-1
     a8c:	bfcd                	j	a7e <stat+0x2a>

0000000000000a8e <atoi>:

int
atoi(const char *s)
{
     a8e:	1141                	addi	sp,sp,-16
     a90:	e422                	sd	s0,8(sp)
     a92:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     a94:	00054683          	lbu	a3,0(a0)
     a98:	fd06879b          	addiw	a5,a3,-48
     a9c:	0ff7f793          	zext.b	a5,a5
     aa0:	4625                	li	a2,9
     aa2:	02f66863          	bltu	a2,a5,ad2 <atoi+0x44>
     aa6:	872a                	mv	a4,a0
  n = 0;
     aa8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     aaa:	0705                	addi	a4,a4,1
     aac:	0025179b          	slliw	a5,a0,0x2
     ab0:	9fa9                	addw	a5,a5,a0
     ab2:	0017979b          	slliw	a5,a5,0x1
     ab6:	9fb5                	addw	a5,a5,a3
     ab8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     abc:	00074683          	lbu	a3,0(a4)
     ac0:	fd06879b          	addiw	a5,a3,-48
     ac4:	0ff7f793          	zext.b	a5,a5
     ac8:	fef671e3          	bgeu	a2,a5,aaa <atoi+0x1c>
  return n;
}
     acc:	6422                	ld	s0,8(sp)
     ace:	0141                	addi	sp,sp,16
     ad0:	8082                	ret
  n = 0;
     ad2:	4501                	li	a0,0
     ad4:	bfe5                	j	acc <atoi+0x3e>

0000000000000ad6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     ad6:	1141                	addi	sp,sp,-16
     ad8:	e422                	sd	s0,8(sp)
     ada:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     adc:	02b57463          	bgeu	a0,a1,b04 <memmove+0x2e>
    while(n-- > 0)
     ae0:	00c05f63          	blez	a2,afe <memmove+0x28>
     ae4:	1602                	slli	a2,a2,0x20
     ae6:	9201                	srli	a2,a2,0x20
     ae8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     aec:	872a                	mv	a4,a0
      *dst++ = *src++;
     aee:	0585                	addi	a1,a1,1
     af0:	0705                	addi	a4,a4,1
     af2:	fff5c683          	lbu	a3,-1(a1)
     af6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     afa:	fef71ae3          	bne	a4,a5,aee <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     afe:	6422                	ld	s0,8(sp)
     b00:	0141                	addi	sp,sp,16
     b02:	8082                	ret
    dst += n;
     b04:	00c50733          	add	a4,a0,a2
    src += n;
     b08:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     b0a:	fec05ae3          	blez	a2,afe <memmove+0x28>
     b0e:	fff6079b          	addiw	a5,a2,-1
     b12:	1782                	slli	a5,a5,0x20
     b14:	9381                	srli	a5,a5,0x20
     b16:	fff7c793          	not	a5,a5
     b1a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     b1c:	15fd                	addi	a1,a1,-1
     b1e:	177d                	addi	a4,a4,-1
     b20:	0005c683          	lbu	a3,0(a1)
     b24:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     b28:	fee79ae3          	bne	a5,a4,b1c <memmove+0x46>
     b2c:	bfc9                	j	afe <memmove+0x28>

0000000000000b2e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     b2e:	1141                	addi	sp,sp,-16
     b30:	e422                	sd	s0,8(sp)
     b32:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     b34:	ca05                	beqz	a2,b64 <memcmp+0x36>
     b36:	fff6069b          	addiw	a3,a2,-1
     b3a:	1682                	slli	a3,a3,0x20
     b3c:	9281                	srli	a3,a3,0x20
     b3e:	0685                	addi	a3,a3,1
     b40:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     b42:	00054783          	lbu	a5,0(a0)
     b46:	0005c703          	lbu	a4,0(a1)
     b4a:	00e79863          	bne	a5,a4,b5a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     b4e:	0505                	addi	a0,a0,1
    p2++;
     b50:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b52:	fed518e3          	bne	a0,a3,b42 <memcmp+0x14>
  }
  return 0;
     b56:	4501                	li	a0,0
     b58:	a019                	j	b5e <memcmp+0x30>
      return *p1 - *p2;
     b5a:	40e7853b          	subw	a0,a5,a4
}
     b5e:	6422                	ld	s0,8(sp)
     b60:	0141                	addi	sp,sp,16
     b62:	8082                	ret
  return 0;
     b64:	4501                	li	a0,0
     b66:	bfe5                	j	b5e <memcmp+0x30>

0000000000000b68 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b68:	1141                	addi	sp,sp,-16
     b6a:	e406                	sd	ra,8(sp)
     b6c:	e022                	sd	s0,0(sp)
     b6e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b70:	f67ff0ef          	jal	ad6 <memmove>
}
     b74:	60a2                	ld	ra,8(sp)
     b76:	6402                	ld	s0,0(sp)
     b78:	0141                	addi	sp,sp,16
     b7a:	8082                	ret

0000000000000b7c <simplesort>:

void
simplesort(void *base, uint nmemb, uint size, int (*compar)(const void *, const void *))
{
     b7c:	7119                	addi	sp,sp,-128
     b7e:	fc86                	sd	ra,120(sp)
     b80:	f8a2                	sd	s0,112(sp)
     b82:	0100                	addi	s0,sp,128
     b84:	f8b43423          	sd	a1,-120(s0)
  char *arr = (char *)base; // Treat array as char array for byte-level manipulation
  char *temp;               // Temporary storage for an element

  if (nmemb <= 1 || size == 0) {
     b88:	4785                	li	a5,1
     b8a:	00b7fc63          	bgeu	a5,a1,ba2 <simplesort+0x26>
     b8e:	e8d2                	sd	s4,80(sp)
     b90:	e4d6                	sd	s5,72(sp)
     b92:	f466                	sd	s9,40(sp)
     b94:	8aaa                	mv	s5,a0
     b96:	8a32                	mv	s4,a2
     b98:	8cb6                	mv	s9,a3
     b9a:	ea01                	bnez	a2,baa <simplesort+0x2e>
     b9c:	6a46                	ld	s4,80(sp)
     b9e:	6aa6                	ld	s5,72(sp)
     ba0:	7ca2                	ld	s9,40(sp)
    // Place temp at its correct position
    memmove(arr + j * size, temp, size);
  }

  free(temp); // Free temporary space
     ba2:	70e6                	ld	ra,120(sp)
     ba4:	7446                	ld	s0,112(sp)
     ba6:	6109                	addi	sp,sp,128
     ba8:	8082                	ret
     baa:	fc5e                	sd	s7,56(sp)
     bac:	f862                	sd	s8,48(sp)
     bae:	f06a                	sd	s10,32(sp)
     bb0:	ec6e                	sd	s11,24(sp)
  temp = malloc(size); // Allocate temporary space for one element
     bb2:	8532                	mv	a0,a2
     bb4:	5de000ef          	jal	1192 <malloc>
     bb8:	8baa                	mv	s7,a0
  if (temp == 0) {
     bba:	4d81                	li	s11,0
  for (uint i = 1; i < nmemb; i++) {
     bbc:	4d05                	li	s10,1
    memmove(temp, arr + i * size, size);
     bbe:	000a0c1b          	sext.w	s8,s4
  if (temp == 0) {
     bc2:	c511                	beqz	a0,bce <simplesort+0x52>
     bc4:	f4a6                	sd	s1,104(sp)
     bc6:	f0ca                	sd	s2,96(sp)
     bc8:	ecce                	sd	s3,88(sp)
     bca:	e0da                	sd	s6,64(sp)
     bcc:	a82d                	j	c06 <simplesort+0x8a>
    printf("simplesort: malloc failed, cannot sort\n");
     bce:	00001517          	auipc	a0,0x1
     bd2:	9ca50513          	addi	a0,a0,-1590 # 1598 <malloc+0x406>
     bd6:	508000ef          	jal	10de <printf>
    return;
     bda:	6a46                	ld	s4,80(sp)
     bdc:	6aa6                	ld	s5,72(sp)
     bde:	7be2                	ld	s7,56(sp)
     be0:	7c42                	ld	s8,48(sp)
     be2:	7ca2                	ld	s9,40(sp)
     be4:	7d02                	ld	s10,32(sp)
     be6:	6de2                	ld	s11,24(sp)
     be8:	bf6d                	j	ba2 <simplesort+0x26>
    memmove(arr + j * size, temp, size);
     bea:	036a053b          	mulw	a0,s4,s6
     bee:	1502                	slli	a0,a0,0x20
     bf0:	9101                	srli	a0,a0,0x20
     bf2:	8662                	mv	a2,s8
     bf4:	85de                	mv	a1,s7
     bf6:	9556                	add	a0,a0,s5
     bf8:	edfff0ef          	jal	ad6 <memmove>
  for (uint i = 1; i < nmemb; i++) {
     bfc:	2d05                	addiw	s10,s10,1
     bfe:	f8843783          	ld	a5,-120(s0)
     c02:	05a78b63          	beq	a5,s10,c58 <simplesort+0xdc>
    memmove(temp, arr + i * size, size);
     c06:	000d899b          	sext.w	s3,s11
     c0a:	01ba05bb          	addw	a1,s4,s11
     c0e:	00058d9b          	sext.w	s11,a1
     c12:	1582                	slli	a1,a1,0x20
     c14:	9181                	srli	a1,a1,0x20
     c16:	8662                	mv	a2,s8
     c18:	95d6                	add	a1,a1,s5
     c1a:	855e                	mv	a0,s7
     c1c:	ebbff0ef          	jal	ad6 <memmove>
    uint j = i;
     c20:	896a                	mv	s2,s10
     c22:	00090b1b          	sext.w	s6,s2
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
     c26:	397d                	addiw	s2,s2,-1
     c28:	02099493          	slli	s1,s3,0x20
     c2c:	9081                	srli	s1,s1,0x20
     c2e:	94d6                	add	s1,s1,s5
     c30:	85de                	mv	a1,s7
     c32:	8526                	mv	a0,s1
     c34:	9c82                	jalr	s9
     c36:	faa05ae3          	blez	a0,bea <simplesort+0x6e>
      memmove(arr + j * size, arr + (j - 1) * size, size); // Shift element
     c3a:	0149853b          	addw	a0,s3,s4
     c3e:	1502                	slli	a0,a0,0x20
     c40:	9101                	srli	a0,a0,0x20
     c42:	8662                	mv	a2,s8
     c44:	85a6                	mv	a1,s1
     c46:	9556                	add	a0,a0,s5
     c48:	e8fff0ef          	jal	ad6 <memmove>
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
     c4c:	414989bb          	subw	s3,s3,s4
     c50:	fc0919e3          	bnez	s2,c22 <simplesort+0xa6>
     c54:	8b4a                	mv	s6,s2
     c56:	bf51                	j	bea <simplesort+0x6e>
  free(temp); // Free temporary space
     c58:	855e                	mv	a0,s7
     c5a:	4b6000ef          	jal	1110 <free>
     c5e:	74a6                	ld	s1,104(sp)
     c60:	7906                	ld	s2,96(sp)
     c62:	69e6                	ld	s3,88(sp)
     c64:	6a46                	ld	s4,80(sp)
     c66:	6aa6                	ld	s5,72(sp)
     c68:	6b06                	ld	s6,64(sp)
     c6a:	7be2                	ld	s7,56(sp)
     c6c:	7c42                	ld	s8,48(sp)
     c6e:	7ca2                	ld	s9,40(sp)
     c70:	7d02                	ld	s10,32(sp)
     c72:	6de2                	ld	s11,24(sp)
     c74:	b73d                	j	ba2 <simplesort+0x26>

0000000000000c76 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c76:	4885                	li	a7,1
 ecall
     c78:	00000073          	ecall
 ret
     c7c:	8082                	ret

0000000000000c7e <exit>:
.global exit
exit:
 li a7, SYS_exit
     c7e:	4889                	li	a7,2
 ecall
     c80:	00000073          	ecall
 ret
     c84:	8082                	ret

0000000000000c86 <wait>:
.global wait
wait:
 li a7, SYS_wait
     c86:	488d                	li	a7,3
 ecall
     c88:	00000073          	ecall
 ret
     c8c:	8082                	ret

0000000000000c8e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c8e:	4891                	li	a7,4
 ecall
     c90:	00000073          	ecall
 ret
     c94:	8082                	ret

0000000000000c96 <read>:
.global read
read:
 li a7, SYS_read
     c96:	4895                	li	a7,5
 ecall
     c98:	00000073          	ecall
 ret
     c9c:	8082                	ret

0000000000000c9e <write>:
.global write
write:
 li a7, SYS_write
     c9e:	48c1                	li	a7,16
 ecall
     ca0:	00000073          	ecall
 ret
     ca4:	8082                	ret

0000000000000ca6 <close>:
.global close
close:
 li a7, SYS_close
     ca6:	48d5                	li	a7,21
 ecall
     ca8:	00000073          	ecall
 ret
     cac:	8082                	ret

0000000000000cae <kill>:
.global kill
kill:
 li a7, SYS_kill
     cae:	4899                	li	a7,6
 ecall
     cb0:	00000073          	ecall
 ret
     cb4:	8082                	ret

0000000000000cb6 <exec>:
.global exec
exec:
 li a7, SYS_exec
     cb6:	489d                	li	a7,7
 ecall
     cb8:	00000073          	ecall
 ret
     cbc:	8082                	ret

0000000000000cbe <open>:
.global open
open:
 li a7, SYS_open
     cbe:	48bd                	li	a7,15
 ecall
     cc0:	00000073          	ecall
 ret
     cc4:	8082                	ret

0000000000000cc6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     cc6:	48c5                	li	a7,17
 ecall
     cc8:	00000073          	ecall
 ret
     ccc:	8082                	ret

0000000000000cce <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     cce:	48c9                	li	a7,18
 ecall
     cd0:	00000073          	ecall
 ret
     cd4:	8082                	ret

0000000000000cd6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     cd6:	48a1                	li	a7,8
 ecall
     cd8:	00000073          	ecall
 ret
     cdc:	8082                	ret

0000000000000cde <link>:
.global link
link:
 li a7, SYS_link
     cde:	48cd                	li	a7,19
 ecall
     ce0:	00000073          	ecall
 ret
     ce4:	8082                	ret

0000000000000ce6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     ce6:	48d1                	li	a7,20
 ecall
     ce8:	00000073          	ecall
 ret
     cec:	8082                	ret

0000000000000cee <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     cee:	48a5                	li	a7,9
 ecall
     cf0:	00000073          	ecall
 ret
     cf4:	8082                	ret

0000000000000cf6 <dup>:
.global dup
dup:
 li a7, SYS_dup
     cf6:	48a9                	li	a7,10
 ecall
     cf8:	00000073          	ecall
 ret
     cfc:	8082                	ret

0000000000000cfe <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     cfe:	48ad                	li	a7,11
 ecall
     d00:	00000073          	ecall
 ret
     d04:	8082                	ret

0000000000000d06 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     d06:	48b1                	li	a7,12
 ecall
     d08:	00000073          	ecall
 ret
     d0c:	8082                	ret

0000000000000d0e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     d0e:	48b5                	li	a7,13
 ecall
     d10:	00000073          	ecall
 ret
     d14:	8082                	ret

0000000000000d16 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     d16:	48b9                	li	a7,14
 ecall
     d18:	00000073          	ecall
 ret
     d1c:	8082                	ret

0000000000000d1e <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
     d1e:	48dd                	li	a7,23
 ecall
     d20:	00000073          	ecall
 ret
     d24:	8082                	ret

0000000000000d26 <statistics>:
.global statistics
statistics:
 li a7, SYS_statistics
     d26:	48e1                	li	a7,24
 ecall
     d28:	00000073          	ecall
 ret
     d2c:	8082                	ret

0000000000000d2e <reset_stats>:
.global reset_stats
reset_stats:
 li a7, SYS_reset_stats
     d2e:	48e5                	li	a7,25
 ecall
     d30:	00000073          	ecall
 ret
     d34:	8082                	ret

0000000000000d36 <resetlockstats>:
.global resetlockstats
resetlockstats:
 li a7, SYS_resetlockstats
     d36:	48e9                	li	a7,26
 ecall
     d38:	00000073          	ecall
 ret
     d3c:	8082                	ret

0000000000000d3e <getlockstats>:
.global getlockstats
getlockstats:
 li a7, SYS_getlockstats
     d3e:	48ed                	li	a7,27
 ecall
     d40:	00000073          	ecall
 ret
     d44:	8082                	ret

0000000000000d46 <trace>:
.global trace
trace:
 li a7, SYS_trace
     d46:	48d9                	li	a7,22
 ecall
     d48:	00000073          	ecall
 ret
     d4c:	8082                	ret

0000000000000d4e <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
     d4e:	48f1                	li	a7,28
 ecall
     d50:	00000073          	ecall
 ret
     d54:	8082                	ret

0000000000000d56 <ugetpid>:
.global ugetpid
ugetpid:
 li a7, SYS_ugetpid
     d56:	48f5                	li	a7,29
 ecall
     d58:	00000073          	ecall
 ret
     d5c:	8082                	ret

0000000000000d5e <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
     d5e:	48f9                	li	a7,30
 ecall
     d60:	00000073          	ecall
 ret
     d64:	8082                	ret

0000000000000d66 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     d66:	1101                	addi	sp,sp,-32
     d68:	ec06                	sd	ra,24(sp)
     d6a:	e822                	sd	s0,16(sp)
     d6c:	1000                	addi	s0,sp,32
     d6e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     d72:	4605                	li	a2,1
     d74:	fef40593          	addi	a1,s0,-17
     d78:	f27ff0ef          	jal	c9e <write>
}
     d7c:	60e2                	ld	ra,24(sp)
     d7e:	6442                	ld	s0,16(sp)
     d80:	6105                	addi	sp,sp,32
     d82:	8082                	ret

0000000000000d84 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     d84:	7139                	addi	sp,sp,-64
     d86:	fc06                	sd	ra,56(sp)
     d88:	f822                	sd	s0,48(sp)
     d8a:	f426                	sd	s1,40(sp)
     d8c:	0080                	addi	s0,sp,64
     d8e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     d90:	c299                	beqz	a3,d96 <printint+0x12>
     d92:	0805c963          	bltz	a1,e24 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     d96:	2581                	sext.w	a1,a1
  neg = 0;
     d98:	4881                	li	a7,0
     d9a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     d9e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     da0:	2601                	sext.w	a2,a2
     da2:	00001517          	auipc	a0,0x1
     da6:	88650513          	addi	a0,a0,-1914 # 1628 <digits>
     daa:	883a                	mv	a6,a4
     dac:	2705                	addiw	a4,a4,1
     dae:	02c5f7bb          	remuw	a5,a1,a2
     db2:	1782                	slli	a5,a5,0x20
     db4:	9381                	srli	a5,a5,0x20
     db6:	97aa                	add	a5,a5,a0
     db8:	0007c783          	lbu	a5,0(a5)
     dbc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     dc0:	0005879b          	sext.w	a5,a1
     dc4:	02c5d5bb          	divuw	a1,a1,a2
     dc8:	0685                	addi	a3,a3,1
     dca:	fec7f0e3          	bgeu	a5,a2,daa <printint+0x26>
  if(neg)
     dce:	00088c63          	beqz	a7,de6 <printint+0x62>
    buf[i++] = '-';
     dd2:	fd070793          	addi	a5,a4,-48
     dd6:	00878733          	add	a4,a5,s0
     dda:	02d00793          	li	a5,45
     dde:	fef70823          	sb	a5,-16(a4)
     de2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     de6:	02e05a63          	blez	a4,e1a <printint+0x96>
     dea:	f04a                	sd	s2,32(sp)
     dec:	ec4e                	sd	s3,24(sp)
     dee:	fc040793          	addi	a5,s0,-64
     df2:	00e78933          	add	s2,a5,a4
     df6:	fff78993          	addi	s3,a5,-1
     dfa:	99ba                	add	s3,s3,a4
     dfc:	377d                	addiw	a4,a4,-1
     dfe:	1702                	slli	a4,a4,0x20
     e00:	9301                	srli	a4,a4,0x20
     e02:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     e06:	fff94583          	lbu	a1,-1(s2)
     e0a:	8526                	mv	a0,s1
     e0c:	f5bff0ef          	jal	d66 <putc>
  while(--i >= 0)
     e10:	197d                	addi	s2,s2,-1
     e12:	ff391ae3          	bne	s2,s3,e06 <printint+0x82>
     e16:	7902                	ld	s2,32(sp)
     e18:	69e2                	ld	s3,24(sp)
}
     e1a:	70e2                	ld	ra,56(sp)
     e1c:	7442                	ld	s0,48(sp)
     e1e:	74a2                	ld	s1,40(sp)
     e20:	6121                	addi	sp,sp,64
     e22:	8082                	ret
    x = -xx;
     e24:	40b005bb          	negw	a1,a1
    neg = 1;
     e28:	4885                	li	a7,1
    x = -xx;
     e2a:	bf85                	j	d9a <printint+0x16>

0000000000000e2c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     e2c:	711d                	addi	sp,sp,-96
     e2e:	ec86                	sd	ra,88(sp)
     e30:	e8a2                	sd	s0,80(sp)
     e32:	e0ca                	sd	s2,64(sp)
     e34:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     e36:	0005c903          	lbu	s2,0(a1)
     e3a:	26090863          	beqz	s2,10aa <vprintf+0x27e>
     e3e:	e4a6                	sd	s1,72(sp)
     e40:	fc4e                	sd	s3,56(sp)
     e42:	f852                	sd	s4,48(sp)
     e44:	f456                	sd	s5,40(sp)
     e46:	f05a                	sd	s6,32(sp)
     e48:	ec5e                	sd	s7,24(sp)
     e4a:	e862                	sd	s8,16(sp)
     e4c:	e466                	sd	s9,8(sp)
     e4e:	8b2a                	mv	s6,a0
     e50:	8a2e                	mv	s4,a1
     e52:	8bb2                	mv	s7,a2
  state = 0;
     e54:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     e56:	4481                	li	s1,0
     e58:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     e5a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     e5e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     e62:	06c00c93          	li	s9,108
     e66:	a005                	j	e86 <vprintf+0x5a>
        putc(fd, c0);
     e68:	85ca                	mv	a1,s2
     e6a:	855a                	mv	a0,s6
     e6c:	efbff0ef          	jal	d66 <putc>
     e70:	a019                	j	e76 <vprintf+0x4a>
    } else if(state == '%'){
     e72:	03598263          	beq	s3,s5,e96 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
     e76:	2485                	addiw	s1,s1,1
     e78:	8726                	mv	a4,s1
     e7a:	009a07b3          	add	a5,s4,s1
     e7e:	0007c903          	lbu	s2,0(a5)
     e82:	20090c63          	beqz	s2,109a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
     e86:	0009079b          	sext.w	a5,s2
    if(state == 0){
     e8a:	fe0994e3          	bnez	s3,e72 <vprintf+0x46>
      if(c0 == '%'){
     e8e:	fd579de3          	bne	a5,s5,e68 <vprintf+0x3c>
        state = '%';
     e92:	89be                	mv	s3,a5
     e94:	b7cd                	j	e76 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     e96:	00ea06b3          	add	a3,s4,a4
     e9a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     e9e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     ea0:	c681                	beqz	a3,ea8 <vprintf+0x7c>
     ea2:	9752                	add	a4,a4,s4
     ea4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     ea8:	03878f63          	beq	a5,s8,ee6 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
     eac:	05978963          	beq	a5,s9,efe <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     eb0:	07500713          	li	a4,117
     eb4:	0ee78363          	beq	a5,a4,f9a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     eb8:	07800713          	li	a4,120
     ebc:	12e78563          	beq	a5,a4,fe6 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     ec0:	07000713          	li	a4,112
     ec4:	14e78a63          	beq	a5,a4,1018 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
     ec8:	07300713          	li	a4,115
     ecc:	18e78a63          	beq	a5,a4,1060 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     ed0:	02500713          	li	a4,37
     ed4:	04e79563          	bne	a5,a4,f1e <vprintf+0xf2>
        putc(fd, '%');
     ed8:	02500593          	li	a1,37
     edc:	855a                	mv	a0,s6
     ede:	e89ff0ef          	jal	d66 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     ee2:	4981                	li	s3,0
     ee4:	bf49                	j	e76 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     ee6:	008b8913          	addi	s2,s7,8
     eea:	4685                	li	a3,1
     eec:	4629                	li	a2,10
     eee:	000ba583          	lw	a1,0(s7)
     ef2:	855a                	mv	a0,s6
     ef4:	e91ff0ef          	jal	d84 <printint>
     ef8:	8bca                	mv	s7,s2
      state = 0;
     efa:	4981                	li	s3,0
     efc:	bfad                	j	e76 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
     efe:	06400793          	li	a5,100
     f02:	02f68963          	beq	a3,a5,f34 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     f06:	06c00793          	li	a5,108
     f0a:	04f68263          	beq	a3,a5,f4e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
     f0e:	07500793          	li	a5,117
     f12:	0af68063          	beq	a3,a5,fb2 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
     f16:	07800793          	li	a5,120
     f1a:	0ef68263          	beq	a3,a5,ffe <vprintf+0x1d2>
        putc(fd, '%');
     f1e:	02500593          	li	a1,37
     f22:	855a                	mv	a0,s6
     f24:	e43ff0ef          	jal	d66 <putc>
        putc(fd, c0);
     f28:	85ca                	mv	a1,s2
     f2a:	855a                	mv	a0,s6
     f2c:	e3bff0ef          	jal	d66 <putc>
      state = 0;
     f30:	4981                	li	s3,0
     f32:	b791                	j	e76 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     f34:	008b8913          	addi	s2,s7,8
     f38:	4685                	li	a3,1
     f3a:	4629                	li	a2,10
     f3c:	000ba583          	lw	a1,0(s7)
     f40:	855a                	mv	a0,s6
     f42:	e43ff0ef          	jal	d84 <printint>
        i += 1;
     f46:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     f48:	8bca                	mv	s7,s2
      state = 0;
     f4a:	4981                	li	s3,0
        i += 1;
     f4c:	b72d                	j	e76 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     f4e:	06400793          	li	a5,100
     f52:	02f60763          	beq	a2,a5,f80 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     f56:	07500793          	li	a5,117
     f5a:	06f60963          	beq	a2,a5,fcc <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     f5e:	07800793          	li	a5,120
     f62:	faf61ee3          	bne	a2,a5,f1e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f66:	008b8913          	addi	s2,s7,8
     f6a:	4681                	li	a3,0
     f6c:	4641                	li	a2,16
     f6e:	000ba583          	lw	a1,0(s7)
     f72:	855a                	mv	a0,s6
     f74:	e11ff0ef          	jal	d84 <printint>
        i += 2;
     f78:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     f7a:	8bca                	mv	s7,s2
      state = 0;
     f7c:	4981                	li	s3,0
        i += 2;
     f7e:	bde5                	j	e76 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     f80:	008b8913          	addi	s2,s7,8
     f84:	4685                	li	a3,1
     f86:	4629                	li	a2,10
     f88:	000ba583          	lw	a1,0(s7)
     f8c:	855a                	mv	a0,s6
     f8e:	df7ff0ef          	jal	d84 <printint>
        i += 2;
     f92:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     f94:	8bca                	mv	s7,s2
      state = 0;
     f96:	4981                	li	s3,0
        i += 2;
     f98:	bdf9                	j	e76 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
     f9a:	008b8913          	addi	s2,s7,8
     f9e:	4681                	li	a3,0
     fa0:	4629                	li	a2,10
     fa2:	000ba583          	lw	a1,0(s7)
     fa6:	855a                	mv	a0,s6
     fa8:	dddff0ef          	jal	d84 <printint>
     fac:	8bca                	mv	s7,s2
      state = 0;
     fae:	4981                	li	s3,0
     fb0:	b5d9                	j	e76 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     fb2:	008b8913          	addi	s2,s7,8
     fb6:	4681                	li	a3,0
     fb8:	4629                	li	a2,10
     fba:	000ba583          	lw	a1,0(s7)
     fbe:	855a                	mv	a0,s6
     fc0:	dc5ff0ef          	jal	d84 <printint>
        i += 1;
     fc4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     fc6:	8bca                	mv	s7,s2
      state = 0;
     fc8:	4981                	li	s3,0
        i += 1;
     fca:	b575                	j	e76 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     fcc:	008b8913          	addi	s2,s7,8
     fd0:	4681                	li	a3,0
     fd2:	4629                	li	a2,10
     fd4:	000ba583          	lw	a1,0(s7)
     fd8:	855a                	mv	a0,s6
     fda:	dabff0ef          	jal	d84 <printint>
        i += 2;
     fde:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     fe0:	8bca                	mv	s7,s2
      state = 0;
     fe2:	4981                	li	s3,0
        i += 2;
     fe4:	bd49                	j	e76 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
     fe6:	008b8913          	addi	s2,s7,8
     fea:	4681                	li	a3,0
     fec:	4641                	li	a2,16
     fee:	000ba583          	lw	a1,0(s7)
     ff2:	855a                	mv	a0,s6
     ff4:	d91ff0ef          	jal	d84 <printint>
     ff8:	8bca                	mv	s7,s2
      state = 0;
     ffa:	4981                	li	s3,0
     ffc:	bdad                	j	e76 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     ffe:	008b8913          	addi	s2,s7,8
    1002:	4681                	li	a3,0
    1004:	4641                	li	a2,16
    1006:	000ba583          	lw	a1,0(s7)
    100a:	855a                	mv	a0,s6
    100c:	d79ff0ef          	jal	d84 <printint>
        i += 1;
    1010:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    1012:	8bca                	mv	s7,s2
      state = 0;
    1014:	4981                	li	s3,0
        i += 1;
    1016:	b585                	j	e76 <vprintf+0x4a>
    1018:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    101a:	008b8d13          	addi	s10,s7,8
    101e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1022:	03000593          	li	a1,48
    1026:	855a                	mv	a0,s6
    1028:	d3fff0ef          	jal	d66 <putc>
  putc(fd, 'x');
    102c:	07800593          	li	a1,120
    1030:	855a                	mv	a0,s6
    1032:	d35ff0ef          	jal	d66 <putc>
    1036:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1038:	00000b97          	auipc	s7,0x0
    103c:	5f0b8b93          	addi	s7,s7,1520 # 1628 <digits>
    1040:	03c9d793          	srli	a5,s3,0x3c
    1044:	97de                	add	a5,a5,s7
    1046:	0007c583          	lbu	a1,0(a5)
    104a:	855a                	mv	a0,s6
    104c:	d1bff0ef          	jal	d66 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1050:	0992                	slli	s3,s3,0x4
    1052:	397d                	addiw	s2,s2,-1
    1054:	fe0916e3          	bnez	s2,1040 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    1058:	8bea                	mv	s7,s10
      state = 0;
    105a:	4981                	li	s3,0
    105c:	6d02                	ld	s10,0(sp)
    105e:	bd21                	j	e76 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    1060:	008b8993          	addi	s3,s7,8
    1064:	000bb903          	ld	s2,0(s7)
    1068:	00090f63          	beqz	s2,1086 <vprintf+0x25a>
        for(; *s; s++)
    106c:	00094583          	lbu	a1,0(s2)
    1070:	c195                	beqz	a1,1094 <vprintf+0x268>
          putc(fd, *s);
    1072:	855a                	mv	a0,s6
    1074:	cf3ff0ef          	jal	d66 <putc>
        for(; *s; s++)
    1078:	0905                	addi	s2,s2,1
    107a:	00094583          	lbu	a1,0(s2)
    107e:	f9f5                	bnez	a1,1072 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    1080:	8bce                	mv	s7,s3
      state = 0;
    1082:	4981                	li	s3,0
    1084:	bbcd                	j	e76 <vprintf+0x4a>
          s = "(null)";
    1086:	00000917          	auipc	s2,0x0
    108a:	53a90913          	addi	s2,s2,1338 # 15c0 <malloc+0x42e>
        for(; *s; s++)
    108e:	02800593          	li	a1,40
    1092:	b7c5                	j	1072 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    1094:	8bce                	mv	s7,s3
      state = 0;
    1096:	4981                	li	s3,0
    1098:	bbf9                	j	e76 <vprintf+0x4a>
    109a:	64a6                	ld	s1,72(sp)
    109c:	79e2                	ld	s3,56(sp)
    109e:	7a42                	ld	s4,48(sp)
    10a0:	7aa2                	ld	s5,40(sp)
    10a2:	7b02                	ld	s6,32(sp)
    10a4:	6be2                	ld	s7,24(sp)
    10a6:	6c42                	ld	s8,16(sp)
    10a8:	6ca2                	ld	s9,8(sp)
    }
  }
}
    10aa:	60e6                	ld	ra,88(sp)
    10ac:	6446                	ld	s0,80(sp)
    10ae:	6906                	ld	s2,64(sp)
    10b0:	6125                	addi	sp,sp,96
    10b2:	8082                	ret

00000000000010b4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    10b4:	715d                	addi	sp,sp,-80
    10b6:	ec06                	sd	ra,24(sp)
    10b8:	e822                	sd	s0,16(sp)
    10ba:	1000                	addi	s0,sp,32
    10bc:	e010                	sd	a2,0(s0)
    10be:	e414                	sd	a3,8(s0)
    10c0:	e818                	sd	a4,16(s0)
    10c2:	ec1c                	sd	a5,24(s0)
    10c4:	03043023          	sd	a6,32(s0)
    10c8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    10cc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    10d0:	8622                	mv	a2,s0
    10d2:	d5bff0ef          	jal	e2c <vprintf>
}
    10d6:	60e2                	ld	ra,24(sp)
    10d8:	6442                	ld	s0,16(sp)
    10da:	6161                	addi	sp,sp,80
    10dc:	8082                	ret

00000000000010de <printf>:

void
printf(const char *fmt, ...)
{
    10de:	711d                	addi	sp,sp,-96
    10e0:	ec06                	sd	ra,24(sp)
    10e2:	e822                	sd	s0,16(sp)
    10e4:	1000                	addi	s0,sp,32
    10e6:	e40c                	sd	a1,8(s0)
    10e8:	e810                	sd	a2,16(s0)
    10ea:	ec14                	sd	a3,24(s0)
    10ec:	f018                	sd	a4,32(s0)
    10ee:	f41c                	sd	a5,40(s0)
    10f0:	03043823          	sd	a6,48(s0)
    10f4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    10f8:	00840613          	addi	a2,s0,8
    10fc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1100:	85aa                	mv	a1,a0
    1102:	4505                	li	a0,1
    1104:	d29ff0ef          	jal	e2c <vprintf>
}
    1108:	60e2                	ld	ra,24(sp)
    110a:	6442                	ld	s0,16(sp)
    110c:	6125                	addi	sp,sp,96
    110e:	8082                	ret

0000000000001110 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1110:	1141                	addi	sp,sp,-16
    1112:	e422                	sd	s0,8(sp)
    1114:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1116:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    111a:	00001797          	auipc	a5,0x1
    111e:	ef67b783          	ld	a5,-266(a5) # 2010 <freep>
    1122:	a02d                	j	114c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1124:	4618                	lw	a4,8(a2)
    1126:	9f2d                	addw	a4,a4,a1
    1128:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    112c:	6398                	ld	a4,0(a5)
    112e:	6310                	ld	a2,0(a4)
    1130:	a83d                	j	116e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1132:	ff852703          	lw	a4,-8(a0)
    1136:	9f31                	addw	a4,a4,a2
    1138:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    113a:	ff053683          	ld	a3,-16(a0)
    113e:	a091                	j	1182 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1140:	6398                	ld	a4,0(a5)
    1142:	00e7e463          	bltu	a5,a4,114a <free+0x3a>
    1146:	00e6ea63          	bltu	a3,a4,115a <free+0x4a>
{
    114a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    114c:	fed7fae3          	bgeu	a5,a3,1140 <free+0x30>
    1150:	6398                	ld	a4,0(a5)
    1152:	00e6e463          	bltu	a3,a4,115a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1156:	fee7eae3          	bltu	a5,a4,114a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    115a:	ff852583          	lw	a1,-8(a0)
    115e:	6390                	ld	a2,0(a5)
    1160:	02059813          	slli	a6,a1,0x20
    1164:	01c85713          	srli	a4,a6,0x1c
    1168:	9736                	add	a4,a4,a3
    116a:	fae60de3          	beq	a2,a4,1124 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    116e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1172:	4790                	lw	a2,8(a5)
    1174:	02061593          	slli	a1,a2,0x20
    1178:	01c5d713          	srli	a4,a1,0x1c
    117c:	973e                	add	a4,a4,a5
    117e:	fae68ae3          	beq	a3,a4,1132 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1182:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1184:	00001717          	auipc	a4,0x1
    1188:	e8f73623          	sd	a5,-372(a4) # 2010 <freep>
}
    118c:	6422                	ld	s0,8(sp)
    118e:	0141                	addi	sp,sp,16
    1190:	8082                	ret

0000000000001192 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1192:	7139                	addi	sp,sp,-64
    1194:	fc06                	sd	ra,56(sp)
    1196:	f822                	sd	s0,48(sp)
    1198:	f426                	sd	s1,40(sp)
    119a:	ec4e                	sd	s3,24(sp)
    119c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    119e:	02051493          	slli	s1,a0,0x20
    11a2:	9081                	srli	s1,s1,0x20
    11a4:	04bd                	addi	s1,s1,15
    11a6:	8091                	srli	s1,s1,0x4
    11a8:	0014899b          	addiw	s3,s1,1
    11ac:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    11ae:	00001517          	auipc	a0,0x1
    11b2:	e6253503          	ld	a0,-414(a0) # 2010 <freep>
    11b6:	c915                	beqz	a0,11ea <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11b8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    11ba:	4798                	lw	a4,8(a5)
    11bc:	08977a63          	bgeu	a4,s1,1250 <malloc+0xbe>
    11c0:	f04a                	sd	s2,32(sp)
    11c2:	e852                	sd	s4,16(sp)
    11c4:	e456                	sd	s5,8(sp)
    11c6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    11c8:	8a4e                	mv	s4,s3
    11ca:	0009871b          	sext.w	a4,s3
    11ce:	6685                	lui	a3,0x1
    11d0:	00d77363          	bgeu	a4,a3,11d6 <malloc+0x44>
    11d4:	6a05                	lui	s4,0x1
    11d6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    11da:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    11de:	00001917          	auipc	s2,0x1
    11e2:	e3290913          	addi	s2,s2,-462 # 2010 <freep>
  if(p == (char*)-1)
    11e6:	5afd                	li	s5,-1
    11e8:	a081                	j	1228 <malloc+0x96>
    11ea:	f04a                	sd	s2,32(sp)
    11ec:	e852                	sd	s4,16(sp)
    11ee:	e456                	sd	s5,8(sp)
    11f0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    11f2:	00001797          	auipc	a5,0x1
    11f6:	21678793          	addi	a5,a5,534 # 2408 <base>
    11fa:	00001717          	auipc	a4,0x1
    11fe:	e0f73b23          	sd	a5,-490(a4) # 2010 <freep>
    1202:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1204:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1208:	b7c1                	j	11c8 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    120a:	6398                	ld	a4,0(a5)
    120c:	e118                	sd	a4,0(a0)
    120e:	a8a9                	j	1268 <malloc+0xd6>
  hp->s.size = nu;
    1210:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1214:	0541                	addi	a0,a0,16
    1216:	efbff0ef          	jal	1110 <free>
  return freep;
    121a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    121e:	c12d                	beqz	a0,1280 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1220:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1222:	4798                	lw	a4,8(a5)
    1224:	02977263          	bgeu	a4,s1,1248 <malloc+0xb6>
    if(p == freep)
    1228:	00093703          	ld	a4,0(s2)
    122c:	853e                	mv	a0,a5
    122e:	fef719e3          	bne	a4,a5,1220 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    1232:	8552                	mv	a0,s4
    1234:	ad3ff0ef          	jal	d06 <sbrk>
  if(p == (char*)-1)
    1238:	fd551ce3          	bne	a0,s5,1210 <malloc+0x7e>
        return 0;
    123c:	4501                	li	a0,0
    123e:	7902                	ld	s2,32(sp)
    1240:	6a42                	ld	s4,16(sp)
    1242:	6aa2                	ld	s5,8(sp)
    1244:	6b02                	ld	s6,0(sp)
    1246:	a03d                	j	1274 <malloc+0xe2>
    1248:	7902                	ld	s2,32(sp)
    124a:	6a42                	ld	s4,16(sp)
    124c:	6aa2                	ld	s5,8(sp)
    124e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1250:	fae48de3          	beq	s1,a4,120a <malloc+0x78>
        p->s.size -= nunits;
    1254:	4137073b          	subw	a4,a4,s3
    1258:	c798                	sw	a4,8(a5)
        p += p->s.size;
    125a:	02071693          	slli	a3,a4,0x20
    125e:	01c6d713          	srli	a4,a3,0x1c
    1262:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1264:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1268:	00001717          	auipc	a4,0x1
    126c:	daa73423          	sd	a0,-600(a4) # 2010 <freep>
      return (void*)(p + 1);
    1270:	01078513          	addi	a0,a5,16
  }
}
    1274:	70e2                	ld	ra,56(sp)
    1276:	7442                	ld	s0,48(sp)
    1278:	74a2                	ld	s1,40(sp)
    127a:	69e2                	ld	s3,24(sp)
    127c:	6121                	addi	sp,sp,64
    127e:	8082                	ret
    1280:	7902                	ld	s2,32(sp)
    1282:	6a42                	ld	s4,16(sp)
    1284:	6aa2                	ld	s5,8(sp)
    1286:	6b02                	ld	s6,0(sp)
    1288:	b7f5                	j	1274 <malloc+0xe2>
