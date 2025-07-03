
user/_pingpong：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "/home/liuzhh268/Operating_System_Homework/xv6/xv6-labs-2024/kernel/types.h"
#include "user.h"

int main(int argc, char *argv[]) {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
    int c_to_p[2]; // 管道：子进程 -> 父进程 [0]读 [1]写
    char buf[1];   // 用于传递字节的缓冲区
    int pid;

    // 创建第一个管道 (父 -> 子)
    if (pipe(p_to_c) < 0) {
   8:	fe840513          	addi	a0,s0,-24
   c:	470000ef          	jal	47c <pipe>
  10:	06054263          	bltz	a0,74 <main+0x74>
        fprintf(2, "pingpong: pipe 创建失败\n");
        exit(1);
    }

    // 创建第二个管道 (子 -> 父)
    if (pipe(c_to_p) < 0) {
  14:	fe040513          	addi	a0,s0,-32
  18:	464000ef          	jal	47c <pipe>
  1c:	06054663          	bltz	a0,88 <main+0x88>
        close(p_to_c[1]);
        exit(1);
    }

    // 创建子进程
    pid = fork();
  20:	444000ef          	jal	464 <fork>

    if (pid < 0) {
  24:	08054463          	bltz	a0,ac <main+0xac>
        close(c_to_p[0]);
        close(c_to_p[1]);
        exit(1);
    }

    if (pid == 0) {
  28:	10051c63          	bnez	a0,140 <main+0x140>
        // --- 子进程 ---
        // 关闭不需要的管道端口：父写端(p_to_c[1]) 和 子读端(c_to_p[0])
        close(p_to_c[1]);
  2c:	fec42503          	lw	a0,-20(s0)
  30:	464000ef          	jal	494 <close>
        close(c_to_p[0]);
  34:	fe042503          	lw	a0,-32(s0)
  38:	45c000ef          	jal	494 <close>

        // 从 父->子 管道读取一个字节
        if (read(p_to_c[0], buf, 1) != 1) {
  3c:	4605                	li	a2,1
  3e:	fd840593          	addi	a1,s0,-40
  42:	fe842503          	lw	a0,-24(s0)
  46:	43e000ef          	jal	484 <read>
  4a:	4785                	li	a5,1
  4c:	08f50a63          	beq	a0,a5,e0 <main+0xe0>
            fprintf(2, "pingpong: 子进程 read 失败\n");
  50:	00001597          	auipc	a1,0x1
  54:	a4058593          	addi	a1,a1,-1472 # a90 <malloc+0x140>
  58:	4509                	li	a0,2
  5a:	019000ef          	jal	872 <fprintf>
            close(p_to_c[0]); // 关闭剩余端口
  5e:	fe842503          	lw	a0,-24(s0)
  62:	432000ef          	jal	494 <close>
            close(c_to_p[1]);
  66:	fe442503          	lw	a0,-28(s0)
  6a:	42a000ef          	jal	494 <close>
            exit(1);
  6e:	4505                	li	a0,1
  70:	3fc000ef          	jal	46c <exit>
        fprintf(2, "pingpong: pipe 创建失败\n");
  74:	00001597          	auipc	a1,0x1
  78:	9dc58593          	addi	a1,a1,-1572 # a50 <malloc+0x100>
  7c:	4509                	li	a0,2
  7e:	7f4000ef          	jal	872 <fprintf>
        exit(1);
  82:	4505                	li	a0,1
  84:	3e8000ef          	jal	46c <exit>
        fprintf(2, "pingpong: pipe 创建失败\n");
  88:	00001597          	auipc	a1,0x1
  8c:	9c858593          	addi	a1,a1,-1592 # a50 <malloc+0x100>
  90:	4509                	li	a0,2
  92:	7e0000ef          	jal	872 <fprintf>
        close(p_to_c[0]);
  96:	fe842503          	lw	a0,-24(s0)
  9a:	3fa000ef          	jal	494 <close>
        close(p_to_c[1]);
  9e:	fec42503          	lw	a0,-20(s0)
  a2:	3f2000ef          	jal	494 <close>
        exit(1);
  a6:	4505                	li	a0,1
  a8:	3c4000ef          	jal	46c <exit>
        fprintf(2, "pingpong: fork 失败\n");
  ac:	00001597          	auipc	a1,0x1
  b0:	9cc58593          	addi	a1,a1,-1588 # a78 <malloc+0x128>
  b4:	4509                	li	a0,2
  b6:	7bc000ef          	jal	872 <fprintf>
        close(p_to_c[0]);
  ba:	fe842503          	lw	a0,-24(s0)
  be:	3d6000ef          	jal	494 <close>
        close(p_to_c[1]);
  c2:	fec42503          	lw	a0,-20(s0)
  c6:	3ce000ef          	jal	494 <close>
        close(c_to_p[0]);
  ca:	fe042503          	lw	a0,-32(s0)
  ce:	3c6000ef          	jal	494 <close>
        close(c_to_p[1]);
  d2:	fe442503          	lw	a0,-28(s0)
  d6:	3be000ef          	jal	494 <close>
        exit(1);
  da:	4505                	li	a0,1
  dc:	390000ef          	jal	46c <exit>
        }

        // 打印 "received ping" 消息
        printf("%d: received ping\n", getpid());
  e0:	40c000ef          	jal	4ec <getpid>
  e4:	85aa                	mv	a1,a0
  e6:	00001517          	auipc	a0,0x1
  ea:	9d250513          	addi	a0,a0,-1582 # ab8 <malloc+0x168>
  ee:	7ae000ef          	jal	89c <printf>

        // 将接收到的字节写回 子->父 管道
        if (write(c_to_p[1], buf, 1) != 1) {
  f2:	4605                	li	a2,1
  f4:	fd840593          	addi	a1,s0,-40
  f8:	fe442503          	lw	a0,-28(s0)
  fc:	390000ef          	jal	48c <write>
 100:	4785                	li	a5,1
 102:	02f50463          	beq	a0,a5,12a <main+0x12a>
            fprintf(2, "pingpong: 子进程 write 失败\n");
 106:	00001597          	auipc	a1,0x1
 10a:	9ca58593          	addi	a1,a1,-1590 # ad0 <malloc+0x180>
 10e:	4509                	li	a0,2
 110:	762000ef          	jal	872 <fprintf>
            close(p_to_c[0]); // 关闭剩余端口
 114:	fe842503          	lw	a0,-24(s0)
 118:	37c000ef          	jal	494 <close>
            close(c_to_p[1]);
 11c:	fe442503          	lw	a0,-28(s0)
 120:	374000ef          	jal	494 <close>
            exit(1);
 124:	4505                	li	a0,1
 126:	346000ef          	jal	46c <exit>
        }

        // 关闭使用完毕的端口
        close(p_to_c[0]);
 12a:	fe842503          	lw	a0,-24(s0)
 12e:	366000ef          	jal	494 <close>
        close(c_to_p[1]);
 132:	fe442503          	lw	a0,-28(s0)
 136:	35e000ef          	jal	494 <close>

        // 子进程正常退出
        exit(0);
 13a:	4501                	li	a0,0
 13c:	330000ef          	jal	46c <exit>

    } else {
        // --- 父进程 ---
        // 关闭不需要的管道端口：子读端(p_to_c[0]) 和 父写端(c_to_p[1])
        close(p_to_c[0]);
 140:	fe842503          	lw	a0,-24(s0)
 144:	350000ef          	jal	494 <close>
        close(c_to_p[1]);
 148:	fe442503          	lw	a0,-28(s0)
 14c:	348000ef          	jal	494 <close>

        // 向 父->子 管道写入一个字节 (内容不重要，任意字符即可)
        buf[0] = 'X'; // 可以是任意字节
 150:	05800793          	li	a5,88
 154:	fcf40c23          	sb	a5,-40(s0)
        if (write(p_to_c[1], buf, 1) != 1) {
 158:	4605                	li	a2,1
 15a:	fd840593          	addi	a1,s0,-40
 15e:	fec42503          	lw	a0,-20(s0)
 162:	32a000ef          	jal	48c <write>
 166:	4785                	li	a5,1
 168:	02f50763          	beq	a0,a5,196 <main+0x196>
            fprintf(2, "pingpong: 父进程 write 失败\n");
 16c:	00001597          	auipc	a1,0x1
 170:	98c58593          	addi	a1,a1,-1652 # af8 <malloc+0x1a8>
 174:	4509                	li	a0,2
 176:	6fc000ef          	jal	872 <fprintf>
            close(p_to_c[1]); // 关闭剩余端口
 17a:	fec42503          	lw	a0,-20(s0)
 17e:	316000ef          	jal	494 <close>
            close(c_to_p[0]);
 182:	fe042503          	lw	a0,-32(s0)
 186:	30e000ef          	jal	494 <close>
            wait(0); // 等待子进程结束（即使失败也尝试等待）
 18a:	4501                	li	a0,0
 18c:	2e8000ef          	jal	474 <wait>
            exit(1);
 190:	4505                	li	a0,1
 192:	2da000ef          	jal	46c <exit>
        }

        // 从 子->父 管道读取一个字节
        if (read(c_to_p[0], buf, 1) != 1) {
 196:	4605                	li	a2,1
 198:	fd840593          	addi	a1,s0,-40
 19c:	fe042503          	lw	a0,-32(s0)
 1a0:	2e4000ef          	jal	484 <read>
 1a4:	4785                	li	a5,1
 1a6:	02f50763          	beq	a0,a5,1d4 <main+0x1d4>
            fprintf(2, "pingpong: 父进程 read 失败\n");
 1aa:	00001597          	auipc	a1,0x1
 1ae:	97658593          	addi	a1,a1,-1674 # b20 <malloc+0x1d0>
 1b2:	4509                	li	a0,2
 1b4:	6be000ef          	jal	872 <fprintf>
            close(p_to_c[1]); // 关闭剩余端口
 1b8:	fec42503          	lw	a0,-20(s0)
 1bc:	2d8000ef          	jal	494 <close>
            close(c_to_p[0]);
 1c0:	fe042503          	lw	a0,-32(s0)
 1c4:	2d0000ef          	jal	494 <close>
            wait(0); // 等待子进程结束
 1c8:	4501                	li	a0,0
 1ca:	2aa000ef          	jal	474 <wait>
            exit(1);
 1ce:	4505                	li	a0,1
 1d0:	29c000ef          	jal	46c <exit>
        }

        // 打印 "received pong" 消息
        printf("%d: received pong\n", getpid());
 1d4:	318000ef          	jal	4ec <getpid>
 1d8:	85aa                	mv	a1,a0
 1da:	00001517          	auipc	a0,0x1
 1de:	96e50513          	addi	a0,a0,-1682 # b48 <malloc+0x1f8>
 1e2:	6ba000ef          	jal	89c <printf>

        // 关闭使用完毕的端口
        close(p_to_c[1]);
 1e6:	fec42503          	lw	a0,-20(s0)
 1ea:	2aa000ef          	jal	494 <close>
        close(c_to_p[0]);
 1ee:	fe042503          	lw	a0,-32(s0)
 1f2:	2a2000ef          	jal	494 <close>

        // (可选) 等待子进程完全退出，确保资源回收
        wait(0);
 1f6:	4501                	li	a0,0
 1f8:	27c000ef          	jal	474 <wait>

        // 父进程正常退出
        exit(0);
 1fc:	4501                	li	a0,0
 1fe:	26e000ef          	jal	46c <exit>

0000000000000202 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 202:	1141                	addi	sp,sp,-16
 204:	e406                	sd	ra,8(sp)
 206:	e022                	sd	s0,0(sp)
 208:	0800                	addi	s0,sp,16
  extern int main();
  main();
 20a:	df7ff0ef          	jal	0 <main>
  exit(0);
 20e:	4501                	li	a0,0
 210:	25c000ef          	jal	46c <exit>

0000000000000214 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 214:	1141                	addi	sp,sp,-16
 216:	e422                	sd	s0,8(sp)
 218:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 21a:	87aa                	mv	a5,a0
 21c:	0585                	addi	a1,a1,1
 21e:	0785                	addi	a5,a5,1
 220:	fff5c703          	lbu	a4,-1(a1)
 224:	fee78fa3          	sb	a4,-1(a5)
 228:	fb75                	bnez	a4,21c <strcpy+0x8>
    ;
  return os;
}
 22a:	6422                	ld	s0,8(sp)
 22c:	0141                	addi	sp,sp,16
 22e:	8082                	ret

0000000000000230 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 230:	1141                	addi	sp,sp,-16
 232:	e422                	sd	s0,8(sp)
 234:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 236:	00054783          	lbu	a5,0(a0)
 23a:	cb91                	beqz	a5,24e <strcmp+0x1e>
 23c:	0005c703          	lbu	a4,0(a1)
 240:	00f71763          	bne	a4,a5,24e <strcmp+0x1e>
    p++, q++;
 244:	0505                	addi	a0,a0,1
 246:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 248:	00054783          	lbu	a5,0(a0)
 24c:	fbe5                	bnez	a5,23c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 24e:	0005c503          	lbu	a0,0(a1)
}
 252:	40a7853b          	subw	a0,a5,a0
 256:	6422                	ld	s0,8(sp)
 258:	0141                	addi	sp,sp,16
 25a:	8082                	ret

000000000000025c <strlen>:

uint
strlen(const char *s)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e422                	sd	s0,8(sp)
 260:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 262:	00054783          	lbu	a5,0(a0)
 266:	cf91                	beqz	a5,282 <strlen+0x26>
 268:	0505                	addi	a0,a0,1
 26a:	87aa                	mv	a5,a0
 26c:	86be                	mv	a3,a5
 26e:	0785                	addi	a5,a5,1
 270:	fff7c703          	lbu	a4,-1(a5)
 274:	ff65                	bnez	a4,26c <strlen+0x10>
 276:	40a6853b          	subw	a0,a3,a0
 27a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 27c:	6422                	ld	s0,8(sp)
 27e:	0141                	addi	sp,sp,16
 280:	8082                	ret
  for(n = 0; s[n]; n++)
 282:	4501                	li	a0,0
 284:	bfe5                	j	27c <strlen+0x20>

0000000000000286 <memset>:

void*
memset(void *dst, int c, uint n)
{
 286:	1141                	addi	sp,sp,-16
 288:	e422                	sd	s0,8(sp)
 28a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 28c:	ca19                	beqz	a2,2a2 <memset+0x1c>
 28e:	87aa                	mv	a5,a0
 290:	1602                	slli	a2,a2,0x20
 292:	9201                	srli	a2,a2,0x20
 294:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 298:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 29c:	0785                	addi	a5,a5,1
 29e:	fee79de3          	bne	a5,a4,298 <memset+0x12>
  }
  return dst;
}
 2a2:	6422                	ld	s0,8(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret

00000000000002a8 <strchr>:

char*
strchr(const char *s, char c)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e422                	sd	s0,8(sp)
 2ac:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2ae:	00054783          	lbu	a5,0(a0)
 2b2:	cb99                	beqz	a5,2c8 <strchr+0x20>
    if(*s == c)
 2b4:	00f58763          	beq	a1,a5,2c2 <strchr+0x1a>
  for(; *s; s++)
 2b8:	0505                	addi	a0,a0,1
 2ba:	00054783          	lbu	a5,0(a0)
 2be:	fbfd                	bnez	a5,2b4 <strchr+0xc>
      return (char*)s;
  return 0;
 2c0:	4501                	li	a0,0
}
 2c2:	6422                	ld	s0,8(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret
  return 0;
 2c8:	4501                	li	a0,0
 2ca:	bfe5                	j	2c2 <strchr+0x1a>

00000000000002cc <gets>:

char*
gets(char *buf, int max)
{
 2cc:	711d                	addi	sp,sp,-96
 2ce:	ec86                	sd	ra,88(sp)
 2d0:	e8a2                	sd	s0,80(sp)
 2d2:	e4a6                	sd	s1,72(sp)
 2d4:	e0ca                	sd	s2,64(sp)
 2d6:	fc4e                	sd	s3,56(sp)
 2d8:	f852                	sd	s4,48(sp)
 2da:	f456                	sd	s5,40(sp)
 2dc:	f05a                	sd	s6,32(sp)
 2de:	ec5e                	sd	s7,24(sp)
 2e0:	1080                	addi	s0,sp,96
 2e2:	8baa                	mv	s7,a0
 2e4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2e6:	892a                	mv	s2,a0
 2e8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2ea:	4aa9                	li	s5,10
 2ec:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2ee:	89a6                	mv	s3,s1
 2f0:	2485                	addiw	s1,s1,1
 2f2:	0344d663          	bge	s1,s4,31e <gets+0x52>
    cc = read(0, &c, 1);
 2f6:	4605                	li	a2,1
 2f8:	faf40593          	addi	a1,s0,-81
 2fc:	4501                	li	a0,0
 2fe:	186000ef          	jal	484 <read>
    if(cc < 1)
 302:	00a05e63          	blez	a0,31e <gets+0x52>
    buf[i++] = c;
 306:	faf44783          	lbu	a5,-81(s0)
 30a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 30e:	01578763          	beq	a5,s5,31c <gets+0x50>
 312:	0905                	addi	s2,s2,1
 314:	fd679de3          	bne	a5,s6,2ee <gets+0x22>
    buf[i++] = c;
 318:	89a6                	mv	s3,s1
 31a:	a011                	j	31e <gets+0x52>
 31c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 31e:	99de                	add	s3,s3,s7
 320:	00098023          	sb	zero,0(s3)
  return buf;
}
 324:	855e                	mv	a0,s7
 326:	60e6                	ld	ra,88(sp)
 328:	6446                	ld	s0,80(sp)
 32a:	64a6                	ld	s1,72(sp)
 32c:	6906                	ld	s2,64(sp)
 32e:	79e2                	ld	s3,56(sp)
 330:	7a42                	ld	s4,48(sp)
 332:	7aa2                	ld	s5,40(sp)
 334:	7b02                	ld	s6,32(sp)
 336:	6be2                	ld	s7,24(sp)
 338:	6125                	addi	sp,sp,96
 33a:	8082                	ret

000000000000033c <stat>:

int
stat(const char *n, struct stat *st)
{
 33c:	1101                	addi	sp,sp,-32
 33e:	ec06                	sd	ra,24(sp)
 340:	e822                	sd	s0,16(sp)
 342:	e04a                	sd	s2,0(sp)
 344:	1000                	addi	s0,sp,32
 346:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 348:	4581                	li	a1,0
 34a:	162000ef          	jal	4ac <open>
  if(fd < 0)
 34e:	02054263          	bltz	a0,372 <stat+0x36>
 352:	e426                	sd	s1,8(sp)
 354:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 356:	85ca                	mv	a1,s2
 358:	16c000ef          	jal	4c4 <fstat>
 35c:	892a                	mv	s2,a0
  close(fd);
 35e:	8526                	mv	a0,s1
 360:	134000ef          	jal	494 <close>
  return r;
 364:	64a2                	ld	s1,8(sp)
}
 366:	854a                	mv	a0,s2
 368:	60e2                	ld	ra,24(sp)
 36a:	6442                	ld	s0,16(sp)
 36c:	6902                	ld	s2,0(sp)
 36e:	6105                	addi	sp,sp,32
 370:	8082                	ret
    return -1;
 372:	597d                	li	s2,-1
 374:	bfcd                	j	366 <stat+0x2a>

0000000000000376 <atoi>:

int
atoi(const char *s)
{
 376:	1141                	addi	sp,sp,-16
 378:	e422                	sd	s0,8(sp)
 37a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 37c:	00054683          	lbu	a3,0(a0)
 380:	fd06879b          	addiw	a5,a3,-48
 384:	0ff7f793          	zext.b	a5,a5
 388:	4625                	li	a2,9
 38a:	02f66863          	bltu	a2,a5,3ba <atoi+0x44>
 38e:	872a                	mv	a4,a0
  n = 0;
 390:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 392:	0705                	addi	a4,a4,1
 394:	0025179b          	slliw	a5,a0,0x2
 398:	9fa9                	addw	a5,a5,a0
 39a:	0017979b          	slliw	a5,a5,0x1
 39e:	9fb5                	addw	a5,a5,a3
 3a0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3a4:	00074683          	lbu	a3,0(a4)
 3a8:	fd06879b          	addiw	a5,a3,-48
 3ac:	0ff7f793          	zext.b	a5,a5
 3b0:	fef671e3          	bgeu	a2,a5,392 <atoi+0x1c>
  return n;
}
 3b4:	6422                	ld	s0,8(sp)
 3b6:	0141                	addi	sp,sp,16
 3b8:	8082                	ret
  n = 0;
 3ba:	4501                	li	a0,0
 3bc:	bfe5                	j	3b4 <atoi+0x3e>

00000000000003be <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3be:	1141                	addi	sp,sp,-16
 3c0:	e422                	sd	s0,8(sp)
 3c2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3c4:	02b57463          	bgeu	a0,a1,3ec <memmove+0x2e>
    while(n-- > 0)
 3c8:	00c05f63          	blez	a2,3e6 <memmove+0x28>
 3cc:	1602                	slli	a2,a2,0x20
 3ce:	9201                	srli	a2,a2,0x20
 3d0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3d4:	872a                	mv	a4,a0
      *dst++ = *src++;
 3d6:	0585                	addi	a1,a1,1
 3d8:	0705                	addi	a4,a4,1
 3da:	fff5c683          	lbu	a3,-1(a1)
 3de:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3e2:	fef71ae3          	bne	a4,a5,3d6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3e6:	6422                	ld	s0,8(sp)
 3e8:	0141                	addi	sp,sp,16
 3ea:	8082                	ret
    dst += n;
 3ec:	00c50733          	add	a4,a0,a2
    src += n;
 3f0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3f2:	fec05ae3          	blez	a2,3e6 <memmove+0x28>
 3f6:	fff6079b          	addiw	a5,a2,-1
 3fa:	1782                	slli	a5,a5,0x20
 3fc:	9381                	srli	a5,a5,0x20
 3fe:	fff7c793          	not	a5,a5
 402:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 404:	15fd                	addi	a1,a1,-1
 406:	177d                	addi	a4,a4,-1
 408:	0005c683          	lbu	a3,0(a1)
 40c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 410:	fee79ae3          	bne	a5,a4,404 <memmove+0x46>
 414:	bfc9                	j	3e6 <memmove+0x28>

0000000000000416 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 416:	1141                	addi	sp,sp,-16
 418:	e422                	sd	s0,8(sp)
 41a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 41c:	ca05                	beqz	a2,44c <memcmp+0x36>
 41e:	fff6069b          	addiw	a3,a2,-1
 422:	1682                	slli	a3,a3,0x20
 424:	9281                	srli	a3,a3,0x20
 426:	0685                	addi	a3,a3,1
 428:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 42a:	00054783          	lbu	a5,0(a0)
 42e:	0005c703          	lbu	a4,0(a1)
 432:	00e79863          	bne	a5,a4,442 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 436:	0505                	addi	a0,a0,1
    p2++;
 438:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 43a:	fed518e3          	bne	a0,a3,42a <memcmp+0x14>
  }
  return 0;
 43e:	4501                	li	a0,0
 440:	a019                	j	446 <memcmp+0x30>
      return *p1 - *p2;
 442:	40e7853b          	subw	a0,a5,a4
}
 446:	6422                	ld	s0,8(sp)
 448:	0141                	addi	sp,sp,16
 44a:	8082                	ret
  return 0;
 44c:	4501                	li	a0,0
 44e:	bfe5                	j	446 <memcmp+0x30>

0000000000000450 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 450:	1141                	addi	sp,sp,-16
 452:	e406                	sd	ra,8(sp)
 454:	e022                	sd	s0,0(sp)
 456:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 458:	f67ff0ef          	jal	3be <memmove>
}
 45c:	60a2                	ld	ra,8(sp)
 45e:	6402                	ld	s0,0(sp)
 460:	0141                	addi	sp,sp,16
 462:	8082                	ret

0000000000000464 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 464:	4885                	li	a7,1
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <exit>:
.global exit
exit:
 li a7, SYS_exit
 46c:	4889                	li	a7,2
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <wait>:
.global wait
wait:
 li a7, SYS_wait
 474:	488d                	li	a7,3
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 47c:	4891                	li	a7,4
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <read>:
.global read
read:
 li a7, SYS_read
 484:	4895                	li	a7,5
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <write>:
.global write
write:
 li a7, SYS_write
 48c:	48c1                	li	a7,16
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <close>:
.global close
close:
 li a7, SYS_close
 494:	48d5                	li	a7,21
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <kill>:
.global kill
kill:
 li a7, SYS_kill
 49c:	4899                	li	a7,6
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4a4:	489d                	li	a7,7
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <open>:
.global open
open:
 li a7, SYS_open
 4ac:	48bd                	li	a7,15
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4b4:	48c5                	li	a7,17
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4bc:	48c9                	li	a7,18
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4c4:	48a1                	li	a7,8
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <link>:
.global link
link:
 li a7, SYS_link
 4cc:	48cd                	li	a7,19
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4d4:	48d1                	li	a7,20
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4dc:	48a5                	li	a7,9
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4e4:	48a9                	li	a7,10
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4ec:	48ad                	li	a7,11
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4f4:	48b1                	li	a7,12
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4fc:	48b5                	li	a7,13
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 504:	48b9                	li	a7,14
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <trace>:
.global trace
trace:
 li a7, SYS_trace
 50c:	48d9                	li	a7,22
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 514:	48dd                	li	a7,23
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 51c:	48e1                	li	a7,24
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 524:	1101                	addi	sp,sp,-32
 526:	ec06                	sd	ra,24(sp)
 528:	e822                	sd	s0,16(sp)
 52a:	1000                	addi	s0,sp,32
 52c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 530:	4605                	li	a2,1
 532:	fef40593          	addi	a1,s0,-17
 536:	f57ff0ef          	jal	48c <write>
}
 53a:	60e2                	ld	ra,24(sp)
 53c:	6442                	ld	s0,16(sp)
 53e:	6105                	addi	sp,sp,32
 540:	8082                	ret

0000000000000542 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 542:	7139                	addi	sp,sp,-64
 544:	fc06                	sd	ra,56(sp)
 546:	f822                	sd	s0,48(sp)
 548:	f426                	sd	s1,40(sp)
 54a:	0080                	addi	s0,sp,64
 54c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 54e:	c299                	beqz	a3,554 <printint+0x12>
 550:	0805c963          	bltz	a1,5e2 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 554:	2581                	sext.w	a1,a1
  neg = 0;
 556:	4881                	li	a7,0
 558:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 55c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 55e:	2601                	sext.w	a2,a2
 560:	00000517          	auipc	a0,0x0
 564:	60850513          	addi	a0,a0,1544 # b68 <digits>
 568:	883a                	mv	a6,a4
 56a:	2705                	addiw	a4,a4,1
 56c:	02c5f7bb          	remuw	a5,a1,a2
 570:	1782                	slli	a5,a5,0x20
 572:	9381                	srli	a5,a5,0x20
 574:	97aa                	add	a5,a5,a0
 576:	0007c783          	lbu	a5,0(a5)
 57a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 57e:	0005879b          	sext.w	a5,a1
 582:	02c5d5bb          	divuw	a1,a1,a2
 586:	0685                	addi	a3,a3,1
 588:	fec7f0e3          	bgeu	a5,a2,568 <printint+0x26>
  if(neg)
 58c:	00088c63          	beqz	a7,5a4 <printint+0x62>
    buf[i++] = '-';
 590:	fd070793          	addi	a5,a4,-48
 594:	00878733          	add	a4,a5,s0
 598:	02d00793          	li	a5,45
 59c:	fef70823          	sb	a5,-16(a4)
 5a0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5a4:	02e05a63          	blez	a4,5d8 <printint+0x96>
 5a8:	f04a                	sd	s2,32(sp)
 5aa:	ec4e                	sd	s3,24(sp)
 5ac:	fc040793          	addi	a5,s0,-64
 5b0:	00e78933          	add	s2,a5,a4
 5b4:	fff78993          	addi	s3,a5,-1
 5b8:	99ba                	add	s3,s3,a4
 5ba:	377d                	addiw	a4,a4,-1
 5bc:	1702                	slli	a4,a4,0x20
 5be:	9301                	srli	a4,a4,0x20
 5c0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5c4:	fff94583          	lbu	a1,-1(s2)
 5c8:	8526                	mv	a0,s1
 5ca:	f5bff0ef          	jal	524 <putc>
  while(--i >= 0)
 5ce:	197d                	addi	s2,s2,-1
 5d0:	ff391ae3          	bne	s2,s3,5c4 <printint+0x82>
 5d4:	7902                	ld	s2,32(sp)
 5d6:	69e2                	ld	s3,24(sp)
}
 5d8:	70e2                	ld	ra,56(sp)
 5da:	7442                	ld	s0,48(sp)
 5dc:	74a2                	ld	s1,40(sp)
 5de:	6121                	addi	sp,sp,64
 5e0:	8082                	ret
    x = -xx;
 5e2:	40b005bb          	negw	a1,a1
    neg = 1;
 5e6:	4885                	li	a7,1
    x = -xx;
 5e8:	bf85                	j	558 <printint+0x16>

00000000000005ea <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5ea:	711d                	addi	sp,sp,-96
 5ec:	ec86                	sd	ra,88(sp)
 5ee:	e8a2                	sd	s0,80(sp)
 5f0:	e0ca                	sd	s2,64(sp)
 5f2:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5f4:	0005c903          	lbu	s2,0(a1)
 5f8:	26090863          	beqz	s2,868 <vprintf+0x27e>
 5fc:	e4a6                	sd	s1,72(sp)
 5fe:	fc4e                	sd	s3,56(sp)
 600:	f852                	sd	s4,48(sp)
 602:	f456                	sd	s5,40(sp)
 604:	f05a                	sd	s6,32(sp)
 606:	ec5e                	sd	s7,24(sp)
 608:	e862                	sd	s8,16(sp)
 60a:	e466                	sd	s9,8(sp)
 60c:	8b2a                	mv	s6,a0
 60e:	8a2e                	mv	s4,a1
 610:	8bb2                	mv	s7,a2
  state = 0;
 612:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 614:	4481                	li	s1,0
 616:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 618:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 61c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 620:	06c00c93          	li	s9,108
 624:	a005                	j	644 <vprintf+0x5a>
        putc(fd, c0);
 626:	85ca                	mv	a1,s2
 628:	855a                	mv	a0,s6
 62a:	efbff0ef          	jal	524 <putc>
 62e:	a019                	j	634 <vprintf+0x4a>
    } else if(state == '%'){
 630:	03598263          	beq	s3,s5,654 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 634:	2485                	addiw	s1,s1,1
 636:	8726                	mv	a4,s1
 638:	009a07b3          	add	a5,s4,s1
 63c:	0007c903          	lbu	s2,0(a5)
 640:	20090c63          	beqz	s2,858 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 644:	0009079b          	sext.w	a5,s2
    if(state == 0){
 648:	fe0994e3          	bnez	s3,630 <vprintf+0x46>
      if(c0 == '%'){
 64c:	fd579de3          	bne	a5,s5,626 <vprintf+0x3c>
        state = '%';
 650:	89be                	mv	s3,a5
 652:	b7cd                	j	634 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 654:	00ea06b3          	add	a3,s4,a4
 658:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 65c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 65e:	c681                	beqz	a3,666 <vprintf+0x7c>
 660:	9752                	add	a4,a4,s4
 662:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 666:	03878f63          	beq	a5,s8,6a4 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 66a:	05978963          	beq	a5,s9,6bc <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 66e:	07500713          	li	a4,117
 672:	0ee78363          	beq	a5,a4,758 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 676:	07800713          	li	a4,120
 67a:	12e78563          	beq	a5,a4,7a4 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 67e:	07000713          	li	a4,112
 682:	14e78a63          	beq	a5,a4,7d6 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 686:	07300713          	li	a4,115
 68a:	18e78a63          	beq	a5,a4,81e <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 68e:	02500713          	li	a4,37
 692:	04e79563          	bne	a5,a4,6dc <vprintf+0xf2>
        putc(fd, '%');
 696:	02500593          	li	a1,37
 69a:	855a                	mv	a0,s6
 69c:	e89ff0ef          	jal	524 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	bf49                	j	634 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6a4:	008b8913          	addi	s2,s7,8
 6a8:	4685                	li	a3,1
 6aa:	4629                	li	a2,10
 6ac:	000ba583          	lw	a1,0(s7)
 6b0:	855a                	mv	a0,s6
 6b2:	e91ff0ef          	jal	542 <printint>
 6b6:	8bca                	mv	s7,s2
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	bfad                	j	634 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6bc:	06400793          	li	a5,100
 6c0:	02f68963          	beq	a3,a5,6f2 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6c4:	06c00793          	li	a5,108
 6c8:	04f68263          	beq	a3,a5,70c <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 6cc:	07500793          	li	a5,117
 6d0:	0af68063          	beq	a3,a5,770 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 6d4:	07800793          	li	a5,120
 6d8:	0ef68263          	beq	a3,a5,7bc <vprintf+0x1d2>
        putc(fd, '%');
 6dc:	02500593          	li	a1,37
 6e0:	855a                	mv	a0,s6
 6e2:	e43ff0ef          	jal	524 <putc>
        putc(fd, c0);
 6e6:	85ca                	mv	a1,s2
 6e8:	855a                	mv	a0,s6
 6ea:	e3bff0ef          	jal	524 <putc>
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	b791                	j	634 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f2:	008b8913          	addi	s2,s7,8
 6f6:	4685                	li	a3,1
 6f8:	4629                	li	a2,10
 6fa:	000ba583          	lw	a1,0(s7)
 6fe:	855a                	mv	a0,s6
 700:	e43ff0ef          	jal	542 <printint>
        i += 1;
 704:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 706:	8bca                	mv	s7,s2
      state = 0;
 708:	4981                	li	s3,0
        i += 1;
 70a:	b72d                	j	634 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 70c:	06400793          	li	a5,100
 710:	02f60763          	beq	a2,a5,73e <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 714:	07500793          	li	a5,117
 718:	06f60963          	beq	a2,a5,78a <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 71c:	07800793          	li	a5,120
 720:	faf61ee3          	bne	a2,a5,6dc <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 724:	008b8913          	addi	s2,s7,8
 728:	4681                	li	a3,0
 72a:	4641                	li	a2,16
 72c:	000ba583          	lw	a1,0(s7)
 730:	855a                	mv	a0,s6
 732:	e11ff0ef          	jal	542 <printint>
        i += 2;
 736:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 738:	8bca                	mv	s7,s2
      state = 0;
 73a:	4981                	li	s3,0
        i += 2;
 73c:	bde5                	j	634 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 73e:	008b8913          	addi	s2,s7,8
 742:	4685                	li	a3,1
 744:	4629                	li	a2,10
 746:	000ba583          	lw	a1,0(s7)
 74a:	855a                	mv	a0,s6
 74c:	df7ff0ef          	jal	542 <printint>
        i += 2;
 750:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 752:	8bca                	mv	s7,s2
      state = 0;
 754:	4981                	li	s3,0
        i += 2;
 756:	bdf9                	j	634 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 758:	008b8913          	addi	s2,s7,8
 75c:	4681                	li	a3,0
 75e:	4629                	li	a2,10
 760:	000ba583          	lw	a1,0(s7)
 764:	855a                	mv	a0,s6
 766:	dddff0ef          	jal	542 <printint>
 76a:	8bca                	mv	s7,s2
      state = 0;
 76c:	4981                	li	s3,0
 76e:	b5d9                	j	634 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 770:	008b8913          	addi	s2,s7,8
 774:	4681                	li	a3,0
 776:	4629                	li	a2,10
 778:	000ba583          	lw	a1,0(s7)
 77c:	855a                	mv	a0,s6
 77e:	dc5ff0ef          	jal	542 <printint>
        i += 1;
 782:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 784:	8bca                	mv	s7,s2
      state = 0;
 786:	4981                	li	s3,0
        i += 1;
 788:	b575                	j	634 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 78a:	008b8913          	addi	s2,s7,8
 78e:	4681                	li	a3,0
 790:	4629                	li	a2,10
 792:	000ba583          	lw	a1,0(s7)
 796:	855a                	mv	a0,s6
 798:	dabff0ef          	jal	542 <printint>
        i += 2;
 79c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 79e:	8bca                	mv	s7,s2
      state = 0;
 7a0:	4981                	li	s3,0
        i += 2;
 7a2:	bd49                	j	634 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7a4:	008b8913          	addi	s2,s7,8
 7a8:	4681                	li	a3,0
 7aa:	4641                	li	a2,16
 7ac:	000ba583          	lw	a1,0(s7)
 7b0:	855a                	mv	a0,s6
 7b2:	d91ff0ef          	jal	542 <printint>
 7b6:	8bca                	mv	s7,s2
      state = 0;
 7b8:	4981                	li	s3,0
 7ba:	bdad                	j	634 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7bc:	008b8913          	addi	s2,s7,8
 7c0:	4681                	li	a3,0
 7c2:	4641                	li	a2,16
 7c4:	000ba583          	lw	a1,0(s7)
 7c8:	855a                	mv	a0,s6
 7ca:	d79ff0ef          	jal	542 <printint>
        i += 1;
 7ce:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d0:	8bca                	mv	s7,s2
      state = 0;
 7d2:	4981                	li	s3,0
        i += 1;
 7d4:	b585                	j	634 <vprintf+0x4a>
 7d6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7d8:	008b8d13          	addi	s10,s7,8
 7dc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7e0:	03000593          	li	a1,48
 7e4:	855a                	mv	a0,s6
 7e6:	d3fff0ef          	jal	524 <putc>
  putc(fd, 'x');
 7ea:	07800593          	li	a1,120
 7ee:	855a                	mv	a0,s6
 7f0:	d35ff0ef          	jal	524 <putc>
 7f4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7f6:	00000b97          	auipc	s7,0x0
 7fa:	372b8b93          	addi	s7,s7,882 # b68 <digits>
 7fe:	03c9d793          	srli	a5,s3,0x3c
 802:	97de                	add	a5,a5,s7
 804:	0007c583          	lbu	a1,0(a5)
 808:	855a                	mv	a0,s6
 80a:	d1bff0ef          	jal	524 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 80e:	0992                	slli	s3,s3,0x4
 810:	397d                	addiw	s2,s2,-1
 812:	fe0916e3          	bnez	s2,7fe <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 816:	8bea                	mv	s7,s10
      state = 0;
 818:	4981                	li	s3,0
 81a:	6d02                	ld	s10,0(sp)
 81c:	bd21                	j	634 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 81e:	008b8993          	addi	s3,s7,8
 822:	000bb903          	ld	s2,0(s7)
 826:	00090f63          	beqz	s2,844 <vprintf+0x25a>
        for(; *s; s++)
 82a:	00094583          	lbu	a1,0(s2)
 82e:	c195                	beqz	a1,852 <vprintf+0x268>
          putc(fd, *s);
 830:	855a                	mv	a0,s6
 832:	cf3ff0ef          	jal	524 <putc>
        for(; *s; s++)
 836:	0905                	addi	s2,s2,1
 838:	00094583          	lbu	a1,0(s2)
 83c:	f9f5                	bnez	a1,830 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 83e:	8bce                	mv	s7,s3
      state = 0;
 840:	4981                	li	s3,0
 842:	bbcd                	j	634 <vprintf+0x4a>
          s = "(null)";
 844:	00000917          	auipc	s2,0x0
 848:	31c90913          	addi	s2,s2,796 # b60 <malloc+0x210>
        for(; *s; s++)
 84c:	02800593          	li	a1,40
 850:	b7c5                	j	830 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 852:	8bce                	mv	s7,s3
      state = 0;
 854:	4981                	li	s3,0
 856:	bbf9                	j	634 <vprintf+0x4a>
 858:	64a6                	ld	s1,72(sp)
 85a:	79e2                	ld	s3,56(sp)
 85c:	7a42                	ld	s4,48(sp)
 85e:	7aa2                	ld	s5,40(sp)
 860:	7b02                	ld	s6,32(sp)
 862:	6be2                	ld	s7,24(sp)
 864:	6c42                	ld	s8,16(sp)
 866:	6ca2                	ld	s9,8(sp)
    }
  }
}
 868:	60e6                	ld	ra,88(sp)
 86a:	6446                	ld	s0,80(sp)
 86c:	6906                	ld	s2,64(sp)
 86e:	6125                	addi	sp,sp,96
 870:	8082                	ret

0000000000000872 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 872:	715d                	addi	sp,sp,-80
 874:	ec06                	sd	ra,24(sp)
 876:	e822                	sd	s0,16(sp)
 878:	1000                	addi	s0,sp,32
 87a:	e010                	sd	a2,0(s0)
 87c:	e414                	sd	a3,8(s0)
 87e:	e818                	sd	a4,16(s0)
 880:	ec1c                	sd	a5,24(s0)
 882:	03043023          	sd	a6,32(s0)
 886:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 88a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 88e:	8622                	mv	a2,s0
 890:	d5bff0ef          	jal	5ea <vprintf>
}
 894:	60e2                	ld	ra,24(sp)
 896:	6442                	ld	s0,16(sp)
 898:	6161                	addi	sp,sp,80
 89a:	8082                	ret

000000000000089c <printf>:

void
printf(const char *fmt, ...)
{
 89c:	711d                	addi	sp,sp,-96
 89e:	ec06                	sd	ra,24(sp)
 8a0:	e822                	sd	s0,16(sp)
 8a2:	1000                	addi	s0,sp,32
 8a4:	e40c                	sd	a1,8(s0)
 8a6:	e810                	sd	a2,16(s0)
 8a8:	ec14                	sd	a3,24(s0)
 8aa:	f018                	sd	a4,32(s0)
 8ac:	f41c                	sd	a5,40(s0)
 8ae:	03043823          	sd	a6,48(s0)
 8b2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8b6:	00840613          	addi	a2,s0,8
 8ba:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8be:	85aa                	mv	a1,a0
 8c0:	4505                	li	a0,1
 8c2:	d29ff0ef          	jal	5ea <vprintf>
}
 8c6:	60e2                	ld	ra,24(sp)
 8c8:	6442                	ld	s0,16(sp)
 8ca:	6125                	addi	sp,sp,96
 8cc:	8082                	ret

00000000000008ce <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8ce:	1141                	addi	sp,sp,-16
 8d0:	e422                	sd	s0,8(sp)
 8d2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8d4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d8:	00000797          	auipc	a5,0x0
 8dc:	7287b783          	ld	a5,1832(a5) # 1000 <freep>
 8e0:	a02d                	j	90a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8e2:	4618                	lw	a4,8(a2)
 8e4:	9f2d                	addw	a4,a4,a1
 8e6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ea:	6398                	ld	a4,0(a5)
 8ec:	6310                	ld	a2,0(a4)
 8ee:	a83d                	j	92c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8f0:	ff852703          	lw	a4,-8(a0)
 8f4:	9f31                	addw	a4,a4,a2
 8f6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8f8:	ff053683          	ld	a3,-16(a0)
 8fc:	a091                	j	940 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8fe:	6398                	ld	a4,0(a5)
 900:	00e7e463          	bltu	a5,a4,908 <free+0x3a>
 904:	00e6ea63          	bltu	a3,a4,918 <free+0x4a>
{
 908:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90a:	fed7fae3          	bgeu	a5,a3,8fe <free+0x30>
 90e:	6398                	ld	a4,0(a5)
 910:	00e6e463          	bltu	a3,a4,918 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 914:	fee7eae3          	bltu	a5,a4,908 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 918:	ff852583          	lw	a1,-8(a0)
 91c:	6390                	ld	a2,0(a5)
 91e:	02059813          	slli	a6,a1,0x20
 922:	01c85713          	srli	a4,a6,0x1c
 926:	9736                	add	a4,a4,a3
 928:	fae60de3          	beq	a2,a4,8e2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 92c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 930:	4790                	lw	a2,8(a5)
 932:	02061593          	slli	a1,a2,0x20
 936:	01c5d713          	srli	a4,a1,0x1c
 93a:	973e                	add	a4,a4,a5
 93c:	fae68ae3          	beq	a3,a4,8f0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 940:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 942:	00000717          	auipc	a4,0x0
 946:	6af73f23          	sd	a5,1726(a4) # 1000 <freep>
}
 94a:	6422                	ld	s0,8(sp)
 94c:	0141                	addi	sp,sp,16
 94e:	8082                	ret

0000000000000950 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 950:	7139                	addi	sp,sp,-64
 952:	fc06                	sd	ra,56(sp)
 954:	f822                	sd	s0,48(sp)
 956:	f426                	sd	s1,40(sp)
 958:	ec4e                	sd	s3,24(sp)
 95a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 95c:	02051493          	slli	s1,a0,0x20
 960:	9081                	srli	s1,s1,0x20
 962:	04bd                	addi	s1,s1,15
 964:	8091                	srli	s1,s1,0x4
 966:	0014899b          	addiw	s3,s1,1
 96a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 96c:	00000517          	auipc	a0,0x0
 970:	69453503          	ld	a0,1684(a0) # 1000 <freep>
 974:	c915                	beqz	a0,9a8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 976:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 978:	4798                	lw	a4,8(a5)
 97a:	08977a63          	bgeu	a4,s1,a0e <malloc+0xbe>
 97e:	f04a                	sd	s2,32(sp)
 980:	e852                	sd	s4,16(sp)
 982:	e456                	sd	s5,8(sp)
 984:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 986:	8a4e                	mv	s4,s3
 988:	0009871b          	sext.w	a4,s3
 98c:	6685                	lui	a3,0x1
 98e:	00d77363          	bgeu	a4,a3,994 <malloc+0x44>
 992:	6a05                	lui	s4,0x1
 994:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 998:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 99c:	00000917          	auipc	s2,0x0
 9a0:	66490913          	addi	s2,s2,1636 # 1000 <freep>
  if(p == (char*)-1)
 9a4:	5afd                	li	s5,-1
 9a6:	a081                	j	9e6 <malloc+0x96>
 9a8:	f04a                	sd	s2,32(sp)
 9aa:	e852                	sd	s4,16(sp)
 9ac:	e456                	sd	s5,8(sp)
 9ae:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9b0:	00000797          	auipc	a5,0x0
 9b4:	66078793          	addi	a5,a5,1632 # 1010 <base>
 9b8:	00000717          	auipc	a4,0x0
 9bc:	64f73423          	sd	a5,1608(a4) # 1000 <freep>
 9c0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9c2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9c6:	b7c1                	j	986 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9c8:	6398                	ld	a4,0(a5)
 9ca:	e118                	sd	a4,0(a0)
 9cc:	a8a9                	j	a26 <malloc+0xd6>
  hp->s.size = nu;
 9ce:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9d2:	0541                	addi	a0,a0,16
 9d4:	efbff0ef          	jal	8ce <free>
  return freep;
 9d8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9dc:	c12d                	beqz	a0,a3e <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9de:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e0:	4798                	lw	a4,8(a5)
 9e2:	02977263          	bgeu	a4,s1,a06 <malloc+0xb6>
    if(p == freep)
 9e6:	00093703          	ld	a4,0(s2)
 9ea:	853e                	mv	a0,a5
 9ec:	fef719e3          	bne	a4,a5,9de <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9f0:	8552                	mv	a0,s4
 9f2:	b03ff0ef          	jal	4f4 <sbrk>
  if(p == (char*)-1)
 9f6:	fd551ce3          	bne	a0,s5,9ce <malloc+0x7e>
        return 0;
 9fa:	4501                	li	a0,0
 9fc:	7902                	ld	s2,32(sp)
 9fe:	6a42                	ld	s4,16(sp)
 a00:	6aa2                	ld	s5,8(sp)
 a02:	6b02                	ld	s6,0(sp)
 a04:	a03d                	j	a32 <malloc+0xe2>
 a06:	7902                	ld	s2,32(sp)
 a08:	6a42                	ld	s4,16(sp)
 a0a:	6aa2                	ld	s5,8(sp)
 a0c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a0e:	fae48de3          	beq	s1,a4,9c8 <malloc+0x78>
        p->s.size -= nunits;
 a12:	4137073b          	subw	a4,a4,s3
 a16:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a18:	02071693          	slli	a3,a4,0x20
 a1c:	01c6d713          	srli	a4,a3,0x1c
 a20:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a22:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a26:	00000717          	auipc	a4,0x0
 a2a:	5ca73d23          	sd	a0,1498(a4) # 1000 <freep>
      return (void*)(p + 1);
 a2e:	01078513          	addi	a0,a5,16
  }
}
 a32:	70e2                	ld	ra,56(sp)
 a34:	7442                	ld	s0,48(sp)
 a36:	74a2                	ld	s1,40(sp)
 a38:	69e2                	ld	s3,24(sp)
 a3a:	6121                	addi	sp,sp,64
 a3c:	8082                	ret
 a3e:	7902                	ld	s2,32(sp)
 a40:	6a42                	ld	s4,16(sp)
 a42:	6aa2                	ld	s5,8(sp)
 a44:	6b02                	ld	s6,0(sp)
 a46:	b7f5                	j	a32 <malloc+0xe2>
