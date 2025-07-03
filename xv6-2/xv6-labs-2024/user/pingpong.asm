
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
   c:	5a0000ef          	jal	5ac <pipe>
  10:	06054263          	bltz	a0,74 <main+0x74>
        fprintf(2, "pingpong: pipe 创建失败\n");
        exit(1);
    }

    // 创建第二个管道 (子 -> 父)
    if (pipe(c_to_p) < 0) {
  14:	fe040513          	addi	a0,s0,-32
  18:	594000ef          	jal	5ac <pipe>
  1c:	06054663          	bltz	a0,88 <main+0x88>
        close(p_to_c[1]);
        exit(1);
    }

    // 创建子进程
    pid = fork();
  20:	574000ef          	jal	594 <fork>

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
  30:	594000ef          	jal	5c4 <close>
        close(c_to_p[0]);
  34:	fe042503          	lw	a0,-32(s0)
  38:	58c000ef          	jal	5c4 <close>

        // 从 父->子 管道读取一个字节
        if (read(p_to_c[0], buf, 1) != 1) {
  3c:	4605                	li	a2,1
  3e:	fd840593          	addi	a1,s0,-40
  42:	fe842503          	lw	a0,-24(s0)
  46:	56e000ef          	jal	5b4 <read>
  4a:	4785                	li	a5,1
  4c:	08f50a63          	beq	a0,a5,e0 <main+0xe0>
            fprintf(2, "pingpong: 子进程 read 失败\n");
  50:	00001597          	auipc	a1,0x1
  54:	ba058593          	addi	a1,a1,-1120 # bf0 <malloc+0x140>
  58:	4509                	li	a0,2
  5a:	179000ef          	jal	9d2 <fprintf>
            close(p_to_c[0]); // 关闭剩余端口
  5e:	fe842503          	lw	a0,-24(s0)
  62:	562000ef          	jal	5c4 <close>
            close(c_to_p[1]);
  66:	fe442503          	lw	a0,-28(s0)
  6a:	55a000ef          	jal	5c4 <close>
            exit(1);
  6e:	4505                	li	a0,1
  70:	52c000ef          	jal	59c <exit>
        fprintf(2, "pingpong: pipe 创建失败\n");
  74:	00001597          	auipc	a1,0x1
  78:	b3c58593          	addi	a1,a1,-1220 # bb0 <malloc+0x100>
  7c:	4509                	li	a0,2
  7e:	155000ef          	jal	9d2 <fprintf>
        exit(1);
  82:	4505                	li	a0,1
  84:	518000ef          	jal	59c <exit>
        fprintf(2, "pingpong: pipe 创建失败\n");
  88:	00001597          	auipc	a1,0x1
  8c:	b2858593          	addi	a1,a1,-1240 # bb0 <malloc+0x100>
  90:	4509                	li	a0,2
  92:	141000ef          	jal	9d2 <fprintf>
        close(p_to_c[0]);
  96:	fe842503          	lw	a0,-24(s0)
  9a:	52a000ef          	jal	5c4 <close>
        close(p_to_c[1]);
  9e:	fec42503          	lw	a0,-20(s0)
  a2:	522000ef          	jal	5c4 <close>
        exit(1);
  a6:	4505                	li	a0,1
  a8:	4f4000ef          	jal	59c <exit>
        fprintf(2, "pingpong: fork 失败\n");
  ac:	00001597          	auipc	a1,0x1
  b0:	b2c58593          	addi	a1,a1,-1236 # bd8 <malloc+0x128>
  b4:	4509                	li	a0,2
  b6:	11d000ef          	jal	9d2 <fprintf>
        close(p_to_c[0]);
  ba:	fe842503          	lw	a0,-24(s0)
  be:	506000ef          	jal	5c4 <close>
        close(p_to_c[1]);
  c2:	fec42503          	lw	a0,-20(s0)
  c6:	4fe000ef          	jal	5c4 <close>
        close(c_to_p[0]);
  ca:	fe042503          	lw	a0,-32(s0)
  ce:	4f6000ef          	jal	5c4 <close>
        close(c_to_p[1]);
  d2:	fe442503          	lw	a0,-28(s0)
  d6:	4ee000ef          	jal	5c4 <close>
        exit(1);
  da:	4505                	li	a0,1
  dc:	4c0000ef          	jal	59c <exit>
        }

        // 打印 "received ping" 消息
        printf("%d: received ping\n", getpid());
  e0:	53c000ef          	jal	61c <getpid>
  e4:	85aa                	mv	a1,a0
  e6:	00001517          	auipc	a0,0x1
  ea:	b3250513          	addi	a0,a0,-1230 # c18 <malloc+0x168>
  ee:	10f000ef          	jal	9fc <printf>

        // 将接收到的字节写回 子->父 管道
        if (write(c_to_p[1], buf, 1) != 1) {
  f2:	4605                	li	a2,1
  f4:	fd840593          	addi	a1,s0,-40
  f8:	fe442503          	lw	a0,-28(s0)
  fc:	4c0000ef          	jal	5bc <write>
 100:	4785                	li	a5,1
 102:	02f50463          	beq	a0,a5,12a <main+0x12a>
            fprintf(2, "pingpong: 子进程 write 失败\n");
 106:	00001597          	auipc	a1,0x1
 10a:	b2a58593          	addi	a1,a1,-1238 # c30 <malloc+0x180>
 10e:	4509                	li	a0,2
 110:	0c3000ef          	jal	9d2 <fprintf>
            close(p_to_c[0]); // 关闭剩余端口
 114:	fe842503          	lw	a0,-24(s0)
 118:	4ac000ef          	jal	5c4 <close>
            close(c_to_p[1]);
 11c:	fe442503          	lw	a0,-28(s0)
 120:	4a4000ef          	jal	5c4 <close>
            exit(1);
 124:	4505                	li	a0,1
 126:	476000ef          	jal	59c <exit>
        }

        // 关闭使用完毕的端口
        close(p_to_c[0]);
 12a:	fe842503          	lw	a0,-24(s0)
 12e:	496000ef          	jal	5c4 <close>
        close(c_to_p[1]);
 132:	fe442503          	lw	a0,-28(s0)
 136:	48e000ef          	jal	5c4 <close>

        // 子进程正常退出
        exit(0);
 13a:	4501                	li	a0,0
 13c:	460000ef          	jal	59c <exit>

    } else {
        // --- 父进程 ---
        // 关闭不需要的管道端口：子读端(p_to_c[0]) 和 父写端(c_to_p[1])
        close(p_to_c[0]);
 140:	fe842503          	lw	a0,-24(s0)
 144:	480000ef          	jal	5c4 <close>
        close(c_to_p[1]);
 148:	fe442503          	lw	a0,-28(s0)
 14c:	478000ef          	jal	5c4 <close>

        // 向 父->子 管道写入一个字节 (内容不重要，任意字符即可)
        buf[0] = 'X'; // 可以是任意字节
 150:	05800793          	li	a5,88
 154:	fcf40c23          	sb	a5,-40(s0)
        if (write(p_to_c[1], buf, 1) != 1) {
 158:	4605                	li	a2,1
 15a:	fd840593          	addi	a1,s0,-40
 15e:	fec42503          	lw	a0,-20(s0)
 162:	45a000ef          	jal	5bc <write>
 166:	4785                	li	a5,1
 168:	02f50763          	beq	a0,a5,196 <main+0x196>
            fprintf(2, "pingpong: 父进程 write 失败\n");
 16c:	00001597          	auipc	a1,0x1
 170:	aec58593          	addi	a1,a1,-1300 # c58 <malloc+0x1a8>
 174:	4509                	li	a0,2
 176:	05d000ef          	jal	9d2 <fprintf>
            close(p_to_c[1]); // 关闭剩余端口
 17a:	fec42503          	lw	a0,-20(s0)
 17e:	446000ef          	jal	5c4 <close>
            close(c_to_p[0]);
 182:	fe042503          	lw	a0,-32(s0)
 186:	43e000ef          	jal	5c4 <close>
            wait(0); // 等待子进程结束（即使失败也尝试等待）
 18a:	4501                	li	a0,0
 18c:	418000ef          	jal	5a4 <wait>
            exit(1);
 190:	4505                	li	a0,1
 192:	40a000ef          	jal	59c <exit>
        }

        // 从 子->父 管道读取一个字节
        if (read(c_to_p[0], buf, 1) != 1) {
 196:	4605                	li	a2,1
 198:	fd840593          	addi	a1,s0,-40
 19c:	fe042503          	lw	a0,-32(s0)
 1a0:	414000ef          	jal	5b4 <read>
 1a4:	4785                	li	a5,1
 1a6:	02f50763          	beq	a0,a5,1d4 <main+0x1d4>
            fprintf(2, "pingpong: 父进程 read 失败\n");
 1aa:	00001597          	auipc	a1,0x1
 1ae:	ad658593          	addi	a1,a1,-1322 # c80 <malloc+0x1d0>
 1b2:	4509                	li	a0,2
 1b4:	01f000ef          	jal	9d2 <fprintf>
            close(p_to_c[1]); // 关闭剩余端口
 1b8:	fec42503          	lw	a0,-20(s0)
 1bc:	408000ef          	jal	5c4 <close>
            close(c_to_p[0]);
 1c0:	fe042503          	lw	a0,-32(s0)
 1c4:	400000ef          	jal	5c4 <close>
            wait(0); // 等待子进程结束
 1c8:	4501                	li	a0,0
 1ca:	3da000ef          	jal	5a4 <wait>
            exit(1);
 1ce:	4505                	li	a0,1
 1d0:	3cc000ef          	jal	59c <exit>
        }

        // 打印 "received pong" 消息
        printf("%d: received pong\n", getpid());
 1d4:	448000ef          	jal	61c <getpid>
 1d8:	85aa                	mv	a1,a0
 1da:	00001517          	auipc	a0,0x1
 1de:	ace50513          	addi	a0,a0,-1330 # ca8 <malloc+0x1f8>
 1e2:	01b000ef          	jal	9fc <printf>

        // 关闭使用完毕的端口
        close(p_to_c[1]);
 1e6:	fec42503          	lw	a0,-20(s0)
 1ea:	3da000ef          	jal	5c4 <close>
        close(c_to_p[0]);
 1ee:	fe042503          	lw	a0,-32(s0)
 1f2:	3d2000ef          	jal	5c4 <close>

        // (可选) 等待子进程完全退出，确保资源回收
        wait(0);
 1f6:	4501                	li	a0,0
 1f8:	3ac000ef          	jal	5a4 <wait>

        // 父进程正常退出
        exit(0);
 1fc:	4501                	li	a0,0
 1fe:	39e000ef          	jal	59c <exit>

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
 210:	38c000ef          	jal	59c <exit>

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

000000000000025c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e422                	sd	s0,8(sp)
 260:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q) {
 262:	ce11                	beqz	a2,27e <strncmp+0x22>
 264:	00054783          	lbu	a5,0(a0)
 268:	cf89                	beqz	a5,282 <strncmp+0x26>
 26a:	0005c703          	lbu	a4,0(a1)
 26e:	00f71a63          	bne	a4,a5,282 <strncmp+0x26>
    n--;
 272:	367d                	addiw	a2,a2,-1
    p++;
 274:	0505                	addi	a0,a0,1
    q++;
 276:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q) {
 278:	f675                	bnez	a2,264 <strncmp+0x8>
  }
  if(n == 0)
    return 0;
 27a:	4501                	li	a0,0
 27c:	a801                	j	28c <strncmp+0x30>
 27e:	4501                	li	a0,0
 280:	a031                	j	28c <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
 282:	00054503          	lbu	a0,0(a0)
 286:	0005c783          	lbu	a5,0(a1)
 28a:	9d1d                	subw	a0,a0,a5
}
 28c:	6422                	ld	s0,8(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret

0000000000000292 <strlen>:

uint
strlen(const char *s)
{
 292:	1141                	addi	sp,sp,-16
 294:	e422                	sd	s0,8(sp)
 296:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 298:	00054783          	lbu	a5,0(a0)
 29c:	cf91                	beqz	a5,2b8 <strlen+0x26>
 29e:	0505                	addi	a0,a0,1
 2a0:	87aa                	mv	a5,a0
 2a2:	86be                	mv	a3,a5
 2a4:	0785                	addi	a5,a5,1
 2a6:	fff7c703          	lbu	a4,-1(a5)
 2aa:	ff65                	bnez	a4,2a2 <strlen+0x10>
 2ac:	40a6853b          	subw	a0,a3,a0
 2b0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2b2:	6422                	ld	s0,8(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret
  for(n = 0; s[n]; n++)
 2b8:	4501                	li	a0,0
 2ba:	bfe5                	j	2b2 <strlen+0x20>

00000000000002bc <memset>:

void*
memset(void *dst, int c, uint n)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e422                	sd	s0,8(sp)
 2c0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2c2:	ca19                	beqz	a2,2d8 <memset+0x1c>
 2c4:	87aa                	mv	a5,a0
 2c6:	1602                	slli	a2,a2,0x20
 2c8:	9201                	srli	a2,a2,0x20
 2ca:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2ce:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2d2:	0785                	addi	a5,a5,1
 2d4:	fee79de3          	bne	a5,a4,2ce <memset+0x12>
  }
  return dst;
}
 2d8:	6422                	ld	s0,8(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret

00000000000002de <strchr>:

char*
strchr(const char *s, char c)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e422                	sd	s0,8(sp)
 2e2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2e4:	00054783          	lbu	a5,0(a0)
 2e8:	cb99                	beqz	a5,2fe <strchr+0x20>
    if(*s == c)
 2ea:	00f58763          	beq	a1,a5,2f8 <strchr+0x1a>
  for(; *s; s++)
 2ee:	0505                	addi	a0,a0,1
 2f0:	00054783          	lbu	a5,0(a0)
 2f4:	fbfd                	bnez	a5,2ea <strchr+0xc>
      return (char*)s;
  return 0;
 2f6:	4501                	li	a0,0
}
 2f8:	6422                	ld	s0,8(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret
  return 0;
 2fe:	4501                	li	a0,0
 300:	bfe5                	j	2f8 <strchr+0x1a>

0000000000000302 <gets>:

char*
gets(char *buf, int max)
{
 302:	711d                	addi	sp,sp,-96
 304:	ec86                	sd	ra,88(sp)
 306:	e8a2                	sd	s0,80(sp)
 308:	e4a6                	sd	s1,72(sp)
 30a:	e0ca                	sd	s2,64(sp)
 30c:	fc4e                	sd	s3,56(sp)
 30e:	f852                	sd	s4,48(sp)
 310:	f456                	sd	s5,40(sp)
 312:	f05a                	sd	s6,32(sp)
 314:	ec5e                	sd	s7,24(sp)
 316:	1080                	addi	s0,sp,96
 318:	8baa                	mv	s7,a0
 31a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 31c:	892a                	mv	s2,a0
 31e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 320:	4aa9                	li	s5,10
 322:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 324:	89a6                	mv	s3,s1
 326:	2485                	addiw	s1,s1,1
 328:	0344d663          	bge	s1,s4,354 <gets+0x52>
    cc = read(0, &c, 1);
 32c:	4605                	li	a2,1
 32e:	faf40593          	addi	a1,s0,-81
 332:	4501                	li	a0,0
 334:	280000ef          	jal	5b4 <read>
    if(cc < 1)
 338:	00a05e63          	blez	a0,354 <gets+0x52>
    buf[i++] = c;
 33c:	faf44783          	lbu	a5,-81(s0)
 340:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 344:	01578763          	beq	a5,s5,352 <gets+0x50>
 348:	0905                	addi	s2,s2,1
 34a:	fd679de3          	bne	a5,s6,324 <gets+0x22>
    buf[i++] = c;
 34e:	89a6                	mv	s3,s1
 350:	a011                	j	354 <gets+0x52>
 352:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 354:	99de                	add	s3,s3,s7
 356:	00098023          	sb	zero,0(s3)
  return buf;
}
 35a:	855e                	mv	a0,s7
 35c:	60e6                	ld	ra,88(sp)
 35e:	6446                	ld	s0,80(sp)
 360:	64a6                	ld	s1,72(sp)
 362:	6906                	ld	s2,64(sp)
 364:	79e2                	ld	s3,56(sp)
 366:	7a42                	ld	s4,48(sp)
 368:	7aa2                	ld	s5,40(sp)
 36a:	7b02                	ld	s6,32(sp)
 36c:	6be2                	ld	s7,24(sp)
 36e:	6125                	addi	sp,sp,96
 370:	8082                	ret

0000000000000372 <stat>:

int
stat(const char *n, struct stat *st)
{
 372:	1101                	addi	sp,sp,-32
 374:	ec06                	sd	ra,24(sp)
 376:	e822                	sd	s0,16(sp)
 378:	e04a                	sd	s2,0(sp)
 37a:	1000                	addi	s0,sp,32
 37c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 37e:	4581                	li	a1,0
 380:	25c000ef          	jal	5dc <open>
  if(fd < 0)
 384:	02054263          	bltz	a0,3a8 <stat+0x36>
 388:	e426                	sd	s1,8(sp)
 38a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 38c:	85ca                	mv	a1,s2
 38e:	266000ef          	jal	5f4 <fstat>
 392:	892a                	mv	s2,a0
  close(fd);
 394:	8526                	mv	a0,s1
 396:	22e000ef          	jal	5c4 <close>
  return r;
 39a:	64a2                	ld	s1,8(sp)
}
 39c:	854a                	mv	a0,s2
 39e:	60e2                	ld	ra,24(sp)
 3a0:	6442                	ld	s0,16(sp)
 3a2:	6902                	ld	s2,0(sp)
 3a4:	6105                	addi	sp,sp,32
 3a6:	8082                	ret
    return -1;
 3a8:	597d                	li	s2,-1
 3aa:	bfcd                	j	39c <stat+0x2a>

00000000000003ac <atoi>:

int
atoi(const char *s)
{
 3ac:	1141                	addi	sp,sp,-16
 3ae:	e422                	sd	s0,8(sp)
 3b0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3b2:	00054683          	lbu	a3,0(a0)
 3b6:	fd06879b          	addiw	a5,a3,-48
 3ba:	0ff7f793          	zext.b	a5,a5
 3be:	4625                	li	a2,9
 3c0:	02f66863          	bltu	a2,a5,3f0 <atoi+0x44>
 3c4:	872a                	mv	a4,a0
  n = 0;
 3c6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3c8:	0705                	addi	a4,a4,1
 3ca:	0025179b          	slliw	a5,a0,0x2
 3ce:	9fa9                	addw	a5,a5,a0
 3d0:	0017979b          	slliw	a5,a5,0x1
 3d4:	9fb5                	addw	a5,a5,a3
 3d6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3da:	00074683          	lbu	a3,0(a4)
 3de:	fd06879b          	addiw	a5,a3,-48
 3e2:	0ff7f793          	zext.b	a5,a5
 3e6:	fef671e3          	bgeu	a2,a5,3c8 <atoi+0x1c>
  return n;
}
 3ea:	6422                	ld	s0,8(sp)
 3ec:	0141                	addi	sp,sp,16
 3ee:	8082                	ret
  n = 0;
 3f0:	4501                	li	a0,0
 3f2:	bfe5                	j	3ea <atoi+0x3e>

00000000000003f4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3f4:	1141                	addi	sp,sp,-16
 3f6:	e422                	sd	s0,8(sp)
 3f8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3fa:	02b57463          	bgeu	a0,a1,422 <memmove+0x2e>
    while(n-- > 0)
 3fe:	00c05f63          	blez	a2,41c <memmove+0x28>
 402:	1602                	slli	a2,a2,0x20
 404:	9201                	srli	a2,a2,0x20
 406:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 40a:	872a                	mv	a4,a0
      *dst++ = *src++;
 40c:	0585                	addi	a1,a1,1
 40e:	0705                	addi	a4,a4,1
 410:	fff5c683          	lbu	a3,-1(a1)
 414:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 418:	fef71ae3          	bne	a4,a5,40c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 41c:	6422                	ld	s0,8(sp)
 41e:	0141                	addi	sp,sp,16
 420:	8082                	ret
    dst += n;
 422:	00c50733          	add	a4,a0,a2
    src += n;
 426:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 428:	fec05ae3          	blez	a2,41c <memmove+0x28>
 42c:	fff6079b          	addiw	a5,a2,-1
 430:	1782                	slli	a5,a5,0x20
 432:	9381                	srli	a5,a5,0x20
 434:	fff7c793          	not	a5,a5
 438:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 43a:	15fd                	addi	a1,a1,-1
 43c:	177d                	addi	a4,a4,-1
 43e:	0005c683          	lbu	a3,0(a1)
 442:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 446:	fee79ae3          	bne	a5,a4,43a <memmove+0x46>
 44a:	bfc9                	j	41c <memmove+0x28>

000000000000044c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 44c:	1141                	addi	sp,sp,-16
 44e:	e422                	sd	s0,8(sp)
 450:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 452:	ca05                	beqz	a2,482 <memcmp+0x36>
 454:	fff6069b          	addiw	a3,a2,-1
 458:	1682                	slli	a3,a3,0x20
 45a:	9281                	srli	a3,a3,0x20
 45c:	0685                	addi	a3,a3,1
 45e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 460:	00054783          	lbu	a5,0(a0)
 464:	0005c703          	lbu	a4,0(a1)
 468:	00e79863          	bne	a5,a4,478 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 46c:	0505                	addi	a0,a0,1
    p2++;
 46e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 470:	fed518e3          	bne	a0,a3,460 <memcmp+0x14>
  }
  return 0;
 474:	4501                	li	a0,0
 476:	a019                	j	47c <memcmp+0x30>
      return *p1 - *p2;
 478:	40e7853b          	subw	a0,a5,a4
}
 47c:	6422                	ld	s0,8(sp)
 47e:	0141                	addi	sp,sp,16
 480:	8082                	ret
  return 0;
 482:	4501                	li	a0,0
 484:	bfe5                	j	47c <memcmp+0x30>

0000000000000486 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 486:	1141                	addi	sp,sp,-16
 488:	e406                	sd	ra,8(sp)
 48a:	e022                	sd	s0,0(sp)
 48c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 48e:	f67ff0ef          	jal	3f4 <memmove>
}
 492:	60a2                	ld	ra,8(sp)
 494:	6402                	ld	s0,0(sp)
 496:	0141                	addi	sp,sp,16
 498:	8082                	ret

000000000000049a <simplesort>:

void
simplesort(void *base, uint nmemb, uint size, int (*compar)(const void *, const void *))
{
 49a:	7119                	addi	sp,sp,-128
 49c:	fc86                	sd	ra,120(sp)
 49e:	f8a2                	sd	s0,112(sp)
 4a0:	0100                	addi	s0,sp,128
 4a2:	f8b43423          	sd	a1,-120(s0)
  char *arr = (char *)base; // Treat array as char array for byte-level manipulation
  char *temp;               // Temporary storage for an element

  if (nmemb <= 1 || size == 0) {
 4a6:	4785                	li	a5,1
 4a8:	00b7fc63          	bgeu	a5,a1,4c0 <simplesort+0x26>
 4ac:	e8d2                	sd	s4,80(sp)
 4ae:	e4d6                	sd	s5,72(sp)
 4b0:	f466                	sd	s9,40(sp)
 4b2:	8aaa                	mv	s5,a0
 4b4:	8a32                	mv	s4,a2
 4b6:	8cb6                	mv	s9,a3
 4b8:	ea01                	bnez	a2,4c8 <simplesort+0x2e>
 4ba:	6a46                	ld	s4,80(sp)
 4bc:	6aa6                	ld	s5,72(sp)
 4be:	7ca2                	ld	s9,40(sp)
    // Place temp at its correct position
    memmove(arr + j * size, temp, size);
  }

  free(temp); // Free temporary space
 4c0:	70e6                	ld	ra,120(sp)
 4c2:	7446                	ld	s0,112(sp)
 4c4:	6109                	addi	sp,sp,128
 4c6:	8082                	ret
 4c8:	fc5e                	sd	s7,56(sp)
 4ca:	f862                	sd	s8,48(sp)
 4cc:	f06a                	sd	s10,32(sp)
 4ce:	ec6e                	sd	s11,24(sp)
  temp = malloc(size); // Allocate temporary space for one element
 4d0:	8532                	mv	a0,a2
 4d2:	5de000ef          	jal	ab0 <malloc>
 4d6:	8baa                	mv	s7,a0
  if (temp == 0) {
 4d8:	4d81                	li	s11,0
  for (uint i = 1; i < nmemb; i++) {
 4da:	4d05                	li	s10,1
    memmove(temp, arr + i * size, size);
 4dc:	000a0c1b          	sext.w	s8,s4
  if (temp == 0) {
 4e0:	c511                	beqz	a0,4ec <simplesort+0x52>
 4e2:	f4a6                	sd	s1,104(sp)
 4e4:	f0ca                	sd	s2,96(sp)
 4e6:	ecce                	sd	s3,88(sp)
 4e8:	e0da                	sd	s6,64(sp)
 4ea:	a82d                	j	524 <simplesort+0x8a>
    printf("simplesort: malloc failed, cannot sort\n");
 4ec:	00000517          	auipc	a0,0x0
 4f0:	7d450513          	addi	a0,a0,2004 # cc0 <malloc+0x210>
 4f4:	508000ef          	jal	9fc <printf>
    return;
 4f8:	6a46                	ld	s4,80(sp)
 4fa:	6aa6                	ld	s5,72(sp)
 4fc:	7be2                	ld	s7,56(sp)
 4fe:	7c42                	ld	s8,48(sp)
 500:	7ca2                	ld	s9,40(sp)
 502:	7d02                	ld	s10,32(sp)
 504:	6de2                	ld	s11,24(sp)
 506:	bf6d                	j	4c0 <simplesort+0x26>
    memmove(arr + j * size, temp, size);
 508:	036a053b          	mulw	a0,s4,s6
 50c:	1502                	slli	a0,a0,0x20
 50e:	9101                	srli	a0,a0,0x20
 510:	8662                	mv	a2,s8
 512:	85de                	mv	a1,s7
 514:	9556                	add	a0,a0,s5
 516:	edfff0ef          	jal	3f4 <memmove>
  for (uint i = 1; i < nmemb; i++) {
 51a:	2d05                	addiw	s10,s10,1
 51c:	f8843783          	ld	a5,-120(s0)
 520:	05a78b63          	beq	a5,s10,576 <simplesort+0xdc>
    memmove(temp, arr + i * size, size);
 524:	000d899b          	sext.w	s3,s11
 528:	01ba05bb          	addw	a1,s4,s11
 52c:	00058d9b          	sext.w	s11,a1
 530:	1582                	slli	a1,a1,0x20
 532:	9181                	srli	a1,a1,0x20
 534:	8662                	mv	a2,s8
 536:	95d6                	add	a1,a1,s5
 538:	855e                	mv	a0,s7
 53a:	ebbff0ef          	jal	3f4 <memmove>
    uint j = i;
 53e:	896a                	mv	s2,s10
 540:	00090b1b          	sext.w	s6,s2
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 544:	397d                	addiw	s2,s2,-1
 546:	02099493          	slli	s1,s3,0x20
 54a:	9081                	srli	s1,s1,0x20
 54c:	94d6                	add	s1,s1,s5
 54e:	85de                	mv	a1,s7
 550:	8526                	mv	a0,s1
 552:	9c82                	jalr	s9
 554:	faa05ae3          	blez	a0,508 <simplesort+0x6e>
      memmove(arr + j * size, arr + (j - 1) * size, size); // Shift element
 558:	0149853b          	addw	a0,s3,s4
 55c:	1502                	slli	a0,a0,0x20
 55e:	9101                	srli	a0,a0,0x20
 560:	8662                	mv	a2,s8
 562:	85a6                	mv	a1,s1
 564:	9556                	add	a0,a0,s5
 566:	e8fff0ef          	jal	3f4 <memmove>
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 56a:	414989bb          	subw	s3,s3,s4
 56e:	fc0919e3          	bnez	s2,540 <simplesort+0xa6>
 572:	8b4a                	mv	s6,s2
 574:	bf51                	j	508 <simplesort+0x6e>
  free(temp); // Free temporary space
 576:	855e                	mv	a0,s7
 578:	4b6000ef          	jal	a2e <free>
 57c:	74a6                	ld	s1,104(sp)
 57e:	7906                	ld	s2,96(sp)
 580:	69e6                	ld	s3,88(sp)
 582:	6a46                	ld	s4,80(sp)
 584:	6aa6                	ld	s5,72(sp)
 586:	6b06                	ld	s6,64(sp)
 588:	7be2                	ld	s7,56(sp)
 58a:	7c42                	ld	s8,48(sp)
 58c:	7ca2                	ld	s9,40(sp)
 58e:	7d02                	ld	s10,32(sp)
 590:	6de2                	ld	s11,24(sp)
 592:	b73d                	j	4c0 <simplesort+0x26>

0000000000000594 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 594:	4885                	li	a7,1
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <exit>:
.global exit
exit:
 li a7, SYS_exit
 59c:	4889                	li	a7,2
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5a4:	488d                	li	a7,3
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5ac:	4891                	li	a7,4
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <read>:
.global read
read:
 li a7, SYS_read
 5b4:	4895                	li	a7,5
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <write>:
.global write
write:
 li a7, SYS_write
 5bc:	48c1                	li	a7,16
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <close>:
.global close
close:
 li a7, SYS_close
 5c4:	48d5                	li	a7,21
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <kill>:
.global kill
kill:
 li a7, SYS_kill
 5cc:	4899                	li	a7,6
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5d4:	489d                	li	a7,7
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <open>:
.global open
open:
 li a7, SYS_open
 5dc:	48bd                	li	a7,15
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5e4:	48c5                	li	a7,17
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5ec:	48c9                	li	a7,18
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5f4:	48a1                	li	a7,8
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <link>:
.global link
link:
 li a7, SYS_link
 5fc:	48cd                	li	a7,19
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 604:	48d1                	li	a7,20
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 60c:	48a5                	li	a7,9
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <dup>:
.global dup
dup:
 li a7, SYS_dup
 614:	48a9                	li	a7,10
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 61c:	48ad                	li	a7,11
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 624:	48b1                	li	a7,12
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 62c:	48b5                	li	a7,13
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 634:	48b9                	li	a7,14
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 63c:	48dd                	li	a7,23
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <statistics>:
.global statistics
statistics:
 li a7, SYS_statistics
 644:	48e1                	li	a7,24
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <reset_stats>:
.global reset_stats
reset_stats:
 li a7, SYS_reset_stats
 64c:	48e5                	li	a7,25
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <resetlockstats>:
.global resetlockstats
resetlockstats:
 li a7, SYS_resetlockstats
 654:	48e9                	li	a7,26
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <getlockstats>:
.global getlockstats
getlockstats:
 li a7, SYS_getlockstats
 65c:	48ed                	li	a7,27
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <trace>:
.global trace
trace:
 li a7, SYS_trace
 664:	48d9                	li	a7,22
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 66c:	48f1                	li	a7,28
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <ugetpid>:
.global ugetpid
ugetpid:
 li a7, SYS_ugetpid
 674:	48f5                	li	a7,29
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 67c:	48f9                	li	a7,30
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 684:	1101                	addi	sp,sp,-32
 686:	ec06                	sd	ra,24(sp)
 688:	e822                	sd	s0,16(sp)
 68a:	1000                	addi	s0,sp,32
 68c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 690:	4605                	li	a2,1
 692:	fef40593          	addi	a1,s0,-17
 696:	f27ff0ef          	jal	5bc <write>
}
 69a:	60e2                	ld	ra,24(sp)
 69c:	6442                	ld	s0,16(sp)
 69e:	6105                	addi	sp,sp,32
 6a0:	8082                	ret

00000000000006a2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6a2:	7139                	addi	sp,sp,-64
 6a4:	fc06                	sd	ra,56(sp)
 6a6:	f822                	sd	s0,48(sp)
 6a8:	f426                	sd	s1,40(sp)
 6aa:	0080                	addi	s0,sp,64
 6ac:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6ae:	c299                	beqz	a3,6b4 <printint+0x12>
 6b0:	0805c963          	bltz	a1,742 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6b4:	2581                	sext.w	a1,a1
  neg = 0;
 6b6:	4881                	li	a7,0
 6b8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 6bc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 6be:	2601                	sext.w	a2,a2
 6c0:	00000517          	auipc	a0,0x0
 6c4:	63050513          	addi	a0,a0,1584 # cf0 <digits>
 6c8:	883a                	mv	a6,a4
 6ca:	2705                	addiw	a4,a4,1
 6cc:	02c5f7bb          	remuw	a5,a1,a2
 6d0:	1782                	slli	a5,a5,0x20
 6d2:	9381                	srli	a5,a5,0x20
 6d4:	97aa                	add	a5,a5,a0
 6d6:	0007c783          	lbu	a5,0(a5)
 6da:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6de:	0005879b          	sext.w	a5,a1
 6e2:	02c5d5bb          	divuw	a1,a1,a2
 6e6:	0685                	addi	a3,a3,1
 6e8:	fec7f0e3          	bgeu	a5,a2,6c8 <printint+0x26>
  if(neg)
 6ec:	00088c63          	beqz	a7,704 <printint+0x62>
    buf[i++] = '-';
 6f0:	fd070793          	addi	a5,a4,-48
 6f4:	00878733          	add	a4,a5,s0
 6f8:	02d00793          	li	a5,45
 6fc:	fef70823          	sb	a5,-16(a4)
 700:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 704:	02e05a63          	blez	a4,738 <printint+0x96>
 708:	f04a                	sd	s2,32(sp)
 70a:	ec4e                	sd	s3,24(sp)
 70c:	fc040793          	addi	a5,s0,-64
 710:	00e78933          	add	s2,a5,a4
 714:	fff78993          	addi	s3,a5,-1
 718:	99ba                	add	s3,s3,a4
 71a:	377d                	addiw	a4,a4,-1
 71c:	1702                	slli	a4,a4,0x20
 71e:	9301                	srli	a4,a4,0x20
 720:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 724:	fff94583          	lbu	a1,-1(s2)
 728:	8526                	mv	a0,s1
 72a:	f5bff0ef          	jal	684 <putc>
  while(--i >= 0)
 72e:	197d                	addi	s2,s2,-1
 730:	ff391ae3          	bne	s2,s3,724 <printint+0x82>
 734:	7902                	ld	s2,32(sp)
 736:	69e2                	ld	s3,24(sp)
}
 738:	70e2                	ld	ra,56(sp)
 73a:	7442                	ld	s0,48(sp)
 73c:	74a2                	ld	s1,40(sp)
 73e:	6121                	addi	sp,sp,64
 740:	8082                	ret
    x = -xx;
 742:	40b005bb          	negw	a1,a1
    neg = 1;
 746:	4885                	li	a7,1
    x = -xx;
 748:	bf85                	j	6b8 <printint+0x16>

000000000000074a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 74a:	711d                	addi	sp,sp,-96
 74c:	ec86                	sd	ra,88(sp)
 74e:	e8a2                	sd	s0,80(sp)
 750:	e0ca                	sd	s2,64(sp)
 752:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 754:	0005c903          	lbu	s2,0(a1)
 758:	26090863          	beqz	s2,9c8 <vprintf+0x27e>
 75c:	e4a6                	sd	s1,72(sp)
 75e:	fc4e                	sd	s3,56(sp)
 760:	f852                	sd	s4,48(sp)
 762:	f456                	sd	s5,40(sp)
 764:	f05a                	sd	s6,32(sp)
 766:	ec5e                	sd	s7,24(sp)
 768:	e862                	sd	s8,16(sp)
 76a:	e466                	sd	s9,8(sp)
 76c:	8b2a                	mv	s6,a0
 76e:	8a2e                	mv	s4,a1
 770:	8bb2                	mv	s7,a2
  state = 0;
 772:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 774:	4481                	li	s1,0
 776:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 778:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 77c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 780:	06c00c93          	li	s9,108
 784:	a005                	j	7a4 <vprintf+0x5a>
        putc(fd, c0);
 786:	85ca                	mv	a1,s2
 788:	855a                	mv	a0,s6
 78a:	efbff0ef          	jal	684 <putc>
 78e:	a019                	j	794 <vprintf+0x4a>
    } else if(state == '%'){
 790:	03598263          	beq	s3,s5,7b4 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 794:	2485                	addiw	s1,s1,1
 796:	8726                	mv	a4,s1
 798:	009a07b3          	add	a5,s4,s1
 79c:	0007c903          	lbu	s2,0(a5)
 7a0:	20090c63          	beqz	s2,9b8 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 7a4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 7a8:	fe0994e3          	bnez	s3,790 <vprintf+0x46>
      if(c0 == '%'){
 7ac:	fd579de3          	bne	a5,s5,786 <vprintf+0x3c>
        state = '%';
 7b0:	89be                	mv	s3,a5
 7b2:	b7cd                	j	794 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 7b4:	00ea06b3          	add	a3,s4,a4
 7b8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 7bc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 7be:	c681                	beqz	a3,7c6 <vprintf+0x7c>
 7c0:	9752                	add	a4,a4,s4
 7c2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 7c6:	03878f63          	beq	a5,s8,804 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 7ca:	05978963          	beq	a5,s9,81c <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 7ce:	07500713          	li	a4,117
 7d2:	0ee78363          	beq	a5,a4,8b8 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 7d6:	07800713          	li	a4,120
 7da:	12e78563          	beq	a5,a4,904 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 7de:	07000713          	li	a4,112
 7e2:	14e78a63          	beq	a5,a4,936 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 7e6:	07300713          	li	a4,115
 7ea:	18e78a63          	beq	a5,a4,97e <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 7ee:	02500713          	li	a4,37
 7f2:	04e79563          	bne	a5,a4,83c <vprintf+0xf2>
        putc(fd, '%');
 7f6:	02500593          	li	a1,37
 7fa:	855a                	mv	a0,s6
 7fc:	e89ff0ef          	jal	684 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 800:	4981                	li	s3,0
 802:	bf49                	j	794 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 804:	008b8913          	addi	s2,s7,8
 808:	4685                	li	a3,1
 80a:	4629                	li	a2,10
 80c:	000ba583          	lw	a1,0(s7)
 810:	855a                	mv	a0,s6
 812:	e91ff0ef          	jal	6a2 <printint>
 816:	8bca                	mv	s7,s2
      state = 0;
 818:	4981                	li	s3,0
 81a:	bfad                	j	794 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 81c:	06400793          	li	a5,100
 820:	02f68963          	beq	a3,a5,852 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 824:	06c00793          	li	a5,108
 828:	04f68263          	beq	a3,a5,86c <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 82c:	07500793          	li	a5,117
 830:	0af68063          	beq	a3,a5,8d0 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 834:	07800793          	li	a5,120
 838:	0ef68263          	beq	a3,a5,91c <vprintf+0x1d2>
        putc(fd, '%');
 83c:	02500593          	li	a1,37
 840:	855a                	mv	a0,s6
 842:	e43ff0ef          	jal	684 <putc>
        putc(fd, c0);
 846:	85ca                	mv	a1,s2
 848:	855a                	mv	a0,s6
 84a:	e3bff0ef          	jal	684 <putc>
      state = 0;
 84e:	4981                	li	s3,0
 850:	b791                	j	794 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 852:	008b8913          	addi	s2,s7,8
 856:	4685                	li	a3,1
 858:	4629                	li	a2,10
 85a:	000ba583          	lw	a1,0(s7)
 85e:	855a                	mv	a0,s6
 860:	e43ff0ef          	jal	6a2 <printint>
        i += 1;
 864:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 866:	8bca                	mv	s7,s2
      state = 0;
 868:	4981                	li	s3,0
        i += 1;
 86a:	b72d                	j	794 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 86c:	06400793          	li	a5,100
 870:	02f60763          	beq	a2,a5,89e <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 874:	07500793          	li	a5,117
 878:	06f60963          	beq	a2,a5,8ea <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 87c:	07800793          	li	a5,120
 880:	faf61ee3          	bne	a2,a5,83c <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 884:	008b8913          	addi	s2,s7,8
 888:	4681                	li	a3,0
 88a:	4641                	li	a2,16
 88c:	000ba583          	lw	a1,0(s7)
 890:	855a                	mv	a0,s6
 892:	e11ff0ef          	jal	6a2 <printint>
        i += 2;
 896:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 898:	8bca                	mv	s7,s2
      state = 0;
 89a:	4981                	li	s3,0
        i += 2;
 89c:	bde5                	j	794 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 89e:	008b8913          	addi	s2,s7,8
 8a2:	4685                	li	a3,1
 8a4:	4629                	li	a2,10
 8a6:	000ba583          	lw	a1,0(s7)
 8aa:	855a                	mv	a0,s6
 8ac:	df7ff0ef          	jal	6a2 <printint>
        i += 2;
 8b0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 8b2:	8bca                	mv	s7,s2
      state = 0;
 8b4:	4981                	li	s3,0
        i += 2;
 8b6:	bdf9                	j	794 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 8b8:	008b8913          	addi	s2,s7,8
 8bc:	4681                	li	a3,0
 8be:	4629                	li	a2,10
 8c0:	000ba583          	lw	a1,0(s7)
 8c4:	855a                	mv	a0,s6
 8c6:	dddff0ef          	jal	6a2 <printint>
 8ca:	8bca                	mv	s7,s2
      state = 0;
 8cc:	4981                	li	s3,0
 8ce:	b5d9                	j	794 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8d0:	008b8913          	addi	s2,s7,8
 8d4:	4681                	li	a3,0
 8d6:	4629                	li	a2,10
 8d8:	000ba583          	lw	a1,0(s7)
 8dc:	855a                	mv	a0,s6
 8de:	dc5ff0ef          	jal	6a2 <printint>
        i += 1;
 8e2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 8e4:	8bca                	mv	s7,s2
      state = 0;
 8e6:	4981                	li	s3,0
        i += 1;
 8e8:	b575                	j	794 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8ea:	008b8913          	addi	s2,s7,8
 8ee:	4681                	li	a3,0
 8f0:	4629                	li	a2,10
 8f2:	000ba583          	lw	a1,0(s7)
 8f6:	855a                	mv	a0,s6
 8f8:	dabff0ef          	jal	6a2 <printint>
        i += 2;
 8fc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8fe:	8bca                	mv	s7,s2
      state = 0;
 900:	4981                	li	s3,0
        i += 2;
 902:	bd49                	j	794 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 904:	008b8913          	addi	s2,s7,8
 908:	4681                	li	a3,0
 90a:	4641                	li	a2,16
 90c:	000ba583          	lw	a1,0(s7)
 910:	855a                	mv	a0,s6
 912:	d91ff0ef          	jal	6a2 <printint>
 916:	8bca                	mv	s7,s2
      state = 0;
 918:	4981                	li	s3,0
 91a:	bdad                	j	794 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 91c:	008b8913          	addi	s2,s7,8
 920:	4681                	li	a3,0
 922:	4641                	li	a2,16
 924:	000ba583          	lw	a1,0(s7)
 928:	855a                	mv	a0,s6
 92a:	d79ff0ef          	jal	6a2 <printint>
        i += 1;
 92e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 930:	8bca                	mv	s7,s2
      state = 0;
 932:	4981                	li	s3,0
        i += 1;
 934:	b585                	j	794 <vprintf+0x4a>
 936:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 938:	008b8d13          	addi	s10,s7,8
 93c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 940:	03000593          	li	a1,48
 944:	855a                	mv	a0,s6
 946:	d3fff0ef          	jal	684 <putc>
  putc(fd, 'x');
 94a:	07800593          	li	a1,120
 94e:	855a                	mv	a0,s6
 950:	d35ff0ef          	jal	684 <putc>
 954:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 956:	00000b97          	auipc	s7,0x0
 95a:	39ab8b93          	addi	s7,s7,922 # cf0 <digits>
 95e:	03c9d793          	srli	a5,s3,0x3c
 962:	97de                	add	a5,a5,s7
 964:	0007c583          	lbu	a1,0(a5)
 968:	855a                	mv	a0,s6
 96a:	d1bff0ef          	jal	684 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 96e:	0992                	slli	s3,s3,0x4
 970:	397d                	addiw	s2,s2,-1
 972:	fe0916e3          	bnez	s2,95e <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 976:	8bea                	mv	s7,s10
      state = 0;
 978:	4981                	li	s3,0
 97a:	6d02                	ld	s10,0(sp)
 97c:	bd21                	j	794 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 97e:	008b8993          	addi	s3,s7,8
 982:	000bb903          	ld	s2,0(s7)
 986:	00090f63          	beqz	s2,9a4 <vprintf+0x25a>
        for(; *s; s++)
 98a:	00094583          	lbu	a1,0(s2)
 98e:	c195                	beqz	a1,9b2 <vprintf+0x268>
          putc(fd, *s);
 990:	855a                	mv	a0,s6
 992:	cf3ff0ef          	jal	684 <putc>
        for(; *s; s++)
 996:	0905                	addi	s2,s2,1
 998:	00094583          	lbu	a1,0(s2)
 99c:	f9f5                	bnez	a1,990 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 99e:	8bce                	mv	s7,s3
      state = 0;
 9a0:	4981                	li	s3,0
 9a2:	bbcd                	j	794 <vprintf+0x4a>
          s = "(null)";
 9a4:	00000917          	auipc	s2,0x0
 9a8:	34490913          	addi	s2,s2,836 # ce8 <malloc+0x238>
        for(; *s; s++)
 9ac:	02800593          	li	a1,40
 9b0:	b7c5                	j	990 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 9b2:	8bce                	mv	s7,s3
      state = 0;
 9b4:	4981                	li	s3,0
 9b6:	bbf9                	j	794 <vprintf+0x4a>
 9b8:	64a6                	ld	s1,72(sp)
 9ba:	79e2                	ld	s3,56(sp)
 9bc:	7a42                	ld	s4,48(sp)
 9be:	7aa2                	ld	s5,40(sp)
 9c0:	7b02                	ld	s6,32(sp)
 9c2:	6be2                	ld	s7,24(sp)
 9c4:	6c42                	ld	s8,16(sp)
 9c6:	6ca2                	ld	s9,8(sp)
    }
  }
}
 9c8:	60e6                	ld	ra,88(sp)
 9ca:	6446                	ld	s0,80(sp)
 9cc:	6906                	ld	s2,64(sp)
 9ce:	6125                	addi	sp,sp,96
 9d0:	8082                	ret

00000000000009d2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9d2:	715d                	addi	sp,sp,-80
 9d4:	ec06                	sd	ra,24(sp)
 9d6:	e822                	sd	s0,16(sp)
 9d8:	1000                	addi	s0,sp,32
 9da:	e010                	sd	a2,0(s0)
 9dc:	e414                	sd	a3,8(s0)
 9de:	e818                	sd	a4,16(s0)
 9e0:	ec1c                	sd	a5,24(s0)
 9e2:	03043023          	sd	a6,32(s0)
 9e6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9ea:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9ee:	8622                	mv	a2,s0
 9f0:	d5bff0ef          	jal	74a <vprintf>
}
 9f4:	60e2                	ld	ra,24(sp)
 9f6:	6442                	ld	s0,16(sp)
 9f8:	6161                	addi	sp,sp,80
 9fa:	8082                	ret

00000000000009fc <printf>:

void
printf(const char *fmt, ...)
{
 9fc:	711d                	addi	sp,sp,-96
 9fe:	ec06                	sd	ra,24(sp)
 a00:	e822                	sd	s0,16(sp)
 a02:	1000                	addi	s0,sp,32
 a04:	e40c                	sd	a1,8(s0)
 a06:	e810                	sd	a2,16(s0)
 a08:	ec14                	sd	a3,24(s0)
 a0a:	f018                	sd	a4,32(s0)
 a0c:	f41c                	sd	a5,40(s0)
 a0e:	03043823          	sd	a6,48(s0)
 a12:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a16:	00840613          	addi	a2,s0,8
 a1a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a1e:	85aa                	mv	a1,a0
 a20:	4505                	li	a0,1
 a22:	d29ff0ef          	jal	74a <vprintf>
}
 a26:	60e2                	ld	ra,24(sp)
 a28:	6442                	ld	s0,16(sp)
 a2a:	6125                	addi	sp,sp,96
 a2c:	8082                	ret

0000000000000a2e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a2e:	1141                	addi	sp,sp,-16
 a30:	e422                	sd	s0,8(sp)
 a32:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a34:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a38:	00001797          	auipc	a5,0x1
 a3c:	5c87b783          	ld	a5,1480(a5) # 2000 <freep>
 a40:	a02d                	j	a6a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a42:	4618                	lw	a4,8(a2)
 a44:	9f2d                	addw	a4,a4,a1
 a46:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a4a:	6398                	ld	a4,0(a5)
 a4c:	6310                	ld	a2,0(a4)
 a4e:	a83d                	j	a8c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a50:	ff852703          	lw	a4,-8(a0)
 a54:	9f31                	addw	a4,a4,a2
 a56:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a58:	ff053683          	ld	a3,-16(a0)
 a5c:	a091                	j	aa0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a5e:	6398                	ld	a4,0(a5)
 a60:	00e7e463          	bltu	a5,a4,a68 <free+0x3a>
 a64:	00e6ea63          	bltu	a3,a4,a78 <free+0x4a>
{
 a68:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a6a:	fed7fae3          	bgeu	a5,a3,a5e <free+0x30>
 a6e:	6398                	ld	a4,0(a5)
 a70:	00e6e463          	bltu	a3,a4,a78 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a74:	fee7eae3          	bltu	a5,a4,a68 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 a78:	ff852583          	lw	a1,-8(a0)
 a7c:	6390                	ld	a2,0(a5)
 a7e:	02059813          	slli	a6,a1,0x20
 a82:	01c85713          	srli	a4,a6,0x1c
 a86:	9736                	add	a4,a4,a3
 a88:	fae60de3          	beq	a2,a4,a42 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 a8c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a90:	4790                	lw	a2,8(a5)
 a92:	02061593          	slli	a1,a2,0x20
 a96:	01c5d713          	srli	a4,a1,0x1c
 a9a:	973e                	add	a4,a4,a5
 a9c:	fae68ae3          	beq	a3,a4,a50 <free+0x22>
    p->s.ptr = bp->s.ptr;
 aa0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 aa2:	00001717          	auipc	a4,0x1
 aa6:	54f73f23          	sd	a5,1374(a4) # 2000 <freep>
}
 aaa:	6422                	ld	s0,8(sp)
 aac:	0141                	addi	sp,sp,16
 aae:	8082                	ret

0000000000000ab0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ab0:	7139                	addi	sp,sp,-64
 ab2:	fc06                	sd	ra,56(sp)
 ab4:	f822                	sd	s0,48(sp)
 ab6:	f426                	sd	s1,40(sp)
 ab8:	ec4e                	sd	s3,24(sp)
 aba:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 abc:	02051493          	slli	s1,a0,0x20
 ac0:	9081                	srli	s1,s1,0x20
 ac2:	04bd                	addi	s1,s1,15
 ac4:	8091                	srli	s1,s1,0x4
 ac6:	0014899b          	addiw	s3,s1,1
 aca:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 acc:	00001517          	auipc	a0,0x1
 ad0:	53453503          	ld	a0,1332(a0) # 2000 <freep>
 ad4:	c915                	beqz	a0,b08 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ad6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ad8:	4798                	lw	a4,8(a5)
 ada:	08977a63          	bgeu	a4,s1,b6e <malloc+0xbe>
 ade:	f04a                	sd	s2,32(sp)
 ae0:	e852                	sd	s4,16(sp)
 ae2:	e456                	sd	s5,8(sp)
 ae4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 ae6:	8a4e                	mv	s4,s3
 ae8:	0009871b          	sext.w	a4,s3
 aec:	6685                	lui	a3,0x1
 aee:	00d77363          	bgeu	a4,a3,af4 <malloc+0x44>
 af2:	6a05                	lui	s4,0x1
 af4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 af8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 afc:	00001917          	auipc	s2,0x1
 b00:	50490913          	addi	s2,s2,1284 # 2000 <freep>
  if(p == (char*)-1)
 b04:	5afd                	li	s5,-1
 b06:	a081                	j	b46 <malloc+0x96>
 b08:	f04a                	sd	s2,32(sp)
 b0a:	e852                	sd	s4,16(sp)
 b0c:	e456                	sd	s5,8(sp)
 b0e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b10:	00001797          	auipc	a5,0x1
 b14:	50078793          	addi	a5,a5,1280 # 2010 <base>
 b18:	00001717          	auipc	a4,0x1
 b1c:	4ef73423          	sd	a5,1256(a4) # 2000 <freep>
 b20:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b22:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b26:	b7c1                	j	ae6 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 b28:	6398                	ld	a4,0(a5)
 b2a:	e118                	sd	a4,0(a0)
 b2c:	a8a9                	j	b86 <malloc+0xd6>
  hp->s.size = nu;
 b2e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b32:	0541                	addi	a0,a0,16
 b34:	efbff0ef          	jal	a2e <free>
  return freep;
 b38:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b3c:	c12d                	beqz	a0,b9e <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b3e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b40:	4798                	lw	a4,8(a5)
 b42:	02977263          	bgeu	a4,s1,b66 <malloc+0xb6>
    if(p == freep)
 b46:	00093703          	ld	a4,0(s2)
 b4a:	853e                	mv	a0,a5
 b4c:	fef719e3          	bne	a4,a5,b3e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 b50:	8552                	mv	a0,s4
 b52:	ad3ff0ef          	jal	624 <sbrk>
  if(p == (char*)-1)
 b56:	fd551ce3          	bne	a0,s5,b2e <malloc+0x7e>
        return 0;
 b5a:	4501                	li	a0,0
 b5c:	7902                	ld	s2,32(sp)
 b5e:	6a42                	ld	s4,16(sp)
 b60:	6aa2                	ld	s5,8(sp)
 b62:	6b02                	ld	s6,0(sp)
 b64:	a03d                	j	b92 <malloc+0xe2>
 b66:	7902                	ld	s2,32(sp)
 b68:	6a42                	ld	s4,16(sp)
 b6a:	6aa2                	ld	s5,8(sp)
 b6c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b6e:	fae48de3          	beq	s1,a4,b28 <malloc+0x78>
        p->s.size -= nunits;
 b72:	4137073b          	subw	a4,a4,s3
 b76:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b78:	02071693          	slli	a3,a4,0x20
 b7c:	01c6d713          	srli	a4,a3,0x1c
 b80:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b82:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b86:	00001717          	auipc	a4,0x1
 b8a:	46a73d23          	sd	a0,1146(a4) # 2000 <freep>
      return (void*)(p + 1);
 b8e:	01078513          	addi	a0,a5,16
  }
}
 b92:	70e2                	ld	ra,56(sp)
 b94:	7442                	ld	s0,48(sp)
 b96:	74a2                	ld	s1,40(sp)
 b98:	69e2                	ld	s3,24(sp)
 b9a:	6121                	addi	sp,sp,64
 b9c:	8082                	ret
 b9e:	7902                	ld	s2,32(sp)
 ba0:	6a42                	ld	s4,16(sp)
 ba2:	6aa2                	ld	s5,8(sp)
 ba4:	6b02                	ld	s6,0(sp)
 ba6:	b7f5                	j	b92 <malloc+0xe2>
