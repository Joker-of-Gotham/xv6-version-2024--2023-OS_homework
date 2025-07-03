
user/_find：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user.h"
#include "/home/liuzhh268/Operating_System_Homework/xv6/xv6-labs-2024/kernel/fs.h"    // 包含 struct dirent 定义和 DIRSIZ

// 函数：格式化文件名，去除路径前缀，只留下文件名部分
// 例如：输入 "a/b/c"，返回指向 "c" 的指针
char* fmtname(char *path) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
    static char buf[DIRSIZ+1]; // 静态缓冲区存储文件名
    char *p;

    // 从路径末尾向前查找第一个 '/'
    for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	2c4000ef          	jal	2d0 <strlen>
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
    p++; // p 指向最后一个 '/' 之后或路径开头
  2e:	00178493          	addi	s1,a5,1

    // 如果文件名太长，则直接返回 p （指向原始路径中的文件名部分）
    if(strlen(p) >= DIRSIZ)
  32:	8526                	mv	a0,s1
  34:	29c000ef          	jal	2d0 <strlen>
  38:	2501                	sext.w	a0,a0
  3a:	47b5                	li	a5,13
  3c:	00a7f863          	bgeu	a5,a0,4c <fmtname+0x4c>
        return p;
    // 否则，将文件名复制到静态缓冲区 buf 中
    memmove(buf, p, strlen(p));
    buf[strlen(p)] = 0; // 添加 null 终止符
    return buf; // 返回指向 buf 的指针
}
  40:	8526                	mv	a0,s1
  42:	60e2                	ld	ra,24(sp)
  44:	6442                	ld	s0,16(sp)
  46:	64a2                	ld	s1,8(sp)
  48:	6105                	addi	sp,sp,32
  4a:	8082                	ret
  4c:	e04a                	sd	s2,0(sp)
    memmove(buf, p, strlen(p));
  4e:	8526                	mv	a0,s1
  50:	280000ef          	jal	2d0 <strlen>
  54:	00001917          	auipc	s2,0x1
  58:	fbc90913          	addi	s2,s2,-68 # 1010 <buf.0>
  5c:	0005061b          	sext.w	a2,a0
  60:	85a6                	mv	a1,s1
  62:	854a                	mv	a0,s2
  64:	3ce000ef          	jal	432 <memmove>
    buf[strlen(p)] = 0; // 添加 null 终止符
  68:	8526                	mv	a0,s1
  6a:	266000ef          	jal	2d0 <strlen>
  6e:	02051793          	slli	a5,a0,0x20
  72:	9381                	srli	a5,a5,0x20
  74:	97ca                	add	a5,a5,s2
  76:	00078023          	sb	zero,0(a5)
    return buf; // 返回指向 buf 的指针
  7a:	84ca                	mv	s1,s2
  7c:	6902                	ld	s2,0(sp)
  7e:	b7c9                	j	40 <fmtname+0x40>

0000000000000080 <find>:

// 函数：递归查找
// path: 当前要搜索的目录路径
// filename: 要查找的目标文件名
void find(char *path, char *filename) {
  80:	d9010113          	addi	sp,sp,-624
  84:	26113423          	sd	ra,616(sp)
  88:	26813023          	sd	s0,608(sp)
  8c:	25213823          	sd	s2,592(sp)
  90:	25313423          	sd	s3,584(sp)
  94:	1c80                	addi	s0,sp,624
  96:	892a                	mv	s2,a0
  98:	89ae                	mv	s3,a1
    int fd;             // 文件描述符
    struct dirent de;   // 目录项结构体
    struct stat st;     // 文件状态结构体

    // 尝试打开当前路径对应的目录
    if((fd = open(path, 0)) < 0){
  9a:	4581                	li	a1,0
  9c:	484000ef          	jal	520 <open>
  a0:	04054863          	bltz	a0,f0 <find+0x70>
  a4:	24913c23          	sd	s1,600(sp)
  a8:	84aa                	mv	s1,a0
        fprintf(2, "find: cannot open %s\n", path);
        return; // 打开失败，直接返回
    }

    // 获取当前路径的文件状态
    if(fstat(fd, &st) < 0){
  aa:	d9840593          	addi	a1,s0,-616
  ae:	48a000ef          	jal	538 <fstat>
  b2:	04054863          	bltz	a0,102 <find+0x82>
        close(fd);
        return; // 获取状态失败，关闭文件描述符后返回
    }

    // 检查当前路径是否确实是一个目录
    if (st.type != T_DIR) {
  b6:	da041703          	lh	a4,-608(s0)
  ba:	4785                	li	a5,1
  bc:	06f70163          	beq	a4,a5,11e <find+0x9e>
         fprintf(2, "find: %s is not a directory\n", path);
  c0:	864a                	mv	a2,s2
  c2:	00001597          	auipc	a1,0x1
  c6:	a2e58593          	addi	a1,a1,-1490 # af0 <malloc+0x12c>
  ca:	4509                	li	a0,2
  cc:	01b000ef          	jal	8e6 <fprintf>
         close(fd);
  d0:	8526                	mv	a0,s1
  d2:	436000ef          	jal	508 <close>
         return; // 不是目录，关闭文件描述符后返回
  d6:	25813483          	ld	s1,600(sp)
        }
    }

    // 关闭当前目录的文件描述符
    close(fd);
}
  da:	26813083          	ld	ra,616(sp)
  de:	26013403          	ld	s0,608(sp)
  e2:	25013903          	ld	s2,592(sp)
  e6:	24813983          	ld	s3,584(sp)
  ea:	27010113          	addi	sp,sp,624
  ee:	8082                	ret
        fprintf(2, "find: cannot open %s\n", path);
  f0:	864a                	mv	a2,s2
  f2:	00001597          	auipc	a1,0x1
  f6:	9ce58593          	addi	a1,a1,-1586 # ac0 <malloc+0xfc>
  fa:	4509                	li	a0,2
  fc:	7ea000ef          	jal	8e6 <fprintf>
        return; // 打开失败，直接返回
 100:	bfe9                	j	da <find+0x5a>
        fprintf(2, "find: cannot stat %s\n", path);
 102:	864a                	mv	a2,s2
 104:	00001597          	auipc	a1,0x1
 108:	9d458593          	addi	a1,a1,-1580 # ad8 <malloc+0x114>
 10c:	4509                	li	a0,2
 10e:	7d8000ef          	jal	8e6 <fprintf>
        close(fd);
 112:	8526                	mv	a0,s1
 114:	3f4000ef          	jal	508 <close>
        return; // 获取状态失败，关闭文件描述符后返回
 118:	25813483          	ld	s1,600(sp)
 11c:	bf7d                	j	da <find+0x5a>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 11e:	854a                	mv	a0,s2
 120:	1b0000ef          	jal	2d0 <strlen>
 124:	2541                	addiw	a0,a0,16
 126:	20000793          	li	a5,512
 12a:	0ca7e463          	bltu	a5,a0,1f2 <find+0x172>
 12e:	25413023          	sd	s4,576(sp)
 132:	23513c23          	sd	s5,568(sp)
 136:	23613823          	sd	s6,560(sp)
    strcpy(buf, path); // 将当前路径复制到缓冲区
 13a:	85ca                	mv	a1,s2
 13c:	dc040513          	addi	a0,s0,-576
 140:	148000ef          	jal	288 <strcpy>
    p = buf+strlen(buf); // p 指向路径末尾
 144:	dc040513          	addi	a0,s0,-576
 148:	188000ef          	jal	2d0 <strlen>
 14c:	1502                	slli	a0,a0,0x20
 14e:	9101                	srli	a0,a0,0x20
 150:	dc040793          	addi	a5,s0,-576
 154:	00a78933          	add	s2,a5,a0
    *p++ = '/'; // 在路径末尾添加 '/'，并将 p 后移
 158:	00190b13          	addi	s6,s2,1
 15c:	02f00793          	li	a5,47
 160:	00f90023          	sb	a5,0(s2)
        if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
 164:	00001a17          	auipc	s4,0x1
 168:	9c4a0a13          	addi	s4,s4,-1596 # b28 <malloc+0x164>
 16c:	00001a97          	auipc	s5,0x1
 170:	9c4a8a93          	addi	s5,s5,-1596 # b30 <malloc+0x16c>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 174:	4641                	li	a2,16
 176:	db040593          	addi	a1,s0,-592
 17a:	8526                	mv	a0,s1
 17c:	37c000ef          	jal	4f8 <read>
 180:	47c1                	li	a5,16
 182:	0af51563          	bne	a0,a5,22c <find+0x1ac>
        if(de.inum == 0)
 186:	db045783          	lhu	a5,-592(s0)
 18a:	d7ed                	beqz	a5,174 <find+0xf4>
        if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
 18c:	85d2                	mv	a1,s4
 18e:	db240513          	addi	a0,s0,-590
 192:	112000ef          	jal	2a4 <strcmp>
 196:	dd79                	beqz	a0,174 <find+0xf4>
 198:	85d6                	mv	a1,s5
 19a:	db240513          	addi	a0,s0,-590
 19e:	106000ef          	jal	2a4 <strcmp>
 1a2:	d969                	beqz	a0,174 <find+0xf4>
        memmove(p, de.name, DIRSIZ); // 将目录项名称复制到路径末尾
 1a4:	4639                	li	a2,14
 1a6:	db240593          	addi	a1,s0,-590
 1aa:	855a                	mv	a0,s6
 1ac:	286000ef          	jal	432 <memmove>
        p[DIRSIZ] = 0; // 确保字符串结束 (虽然 de.name 可能不满 DIRSIZ)
 1b0:	000907a3          	sb	zero,15(s2)
        if(stat(buf, &st) < 0){
 1b4:	d9840593          	addi	a1,s0,-616
 1b8:	dc040513          	addi	a0,s0,-576
 1bc:	1f4000ef          	jal	3b0 <stat>
 1c0:	04054663          	bltz	a0,20c <find+0x18c>
        switch(st.type){
 1c4:	da041783          	lh	a5,-608(s0)
 1c8:	4705                	li	a4,1
 1ca:	04e78b63          	beq	a5,a4,220 <find+0x1a0>
 1ce:	4709                	li	a4,2
 1d0:	fae792e3          	bne	a5,a4,174 <find+0xf4>
            if (strcmp(de.name, filename) == 0) {
 1d4:	85ce                	mv	a1,s3
 1d6:	db240513          	addi	a0,s0,-590
 1da:	0ca000ef          	jal	2a4 <strcmp>
 1de:	f959                	bnez	a0,174 <find+0xf4>
                printf("%s\n", buf);
 1e0:	dc040593          	addi	a1,s0,-576
 1e4:	00001517          	auipc	a0,0x1
 1e8:	95450513          	addi	a0,a0,-1708 # b38 <malloc+0x174>
 1ec:	724000ef          	jal	910 <printf>
 1f0:	b751                	j	174 <find+0xf4>
        fprintf(2, "find: path too long\n");
 1f2:	00001597          	auipc	a1,0x1
 1f6:	91e58593          	addi	a1,a1,-1762 # b10 <malloc+0x14c>
 1fa:	4509                	li	a0,2
 1fc:	6ea000ef          	jal	8e6 <fprintf>
        close(fd);
 200:	8526                	mv	a0,s1
 202:	306000ef          	jal	508 <close>
        return; // 路径可能过长，关闭文件描述符后返回
 206:	25813483          	ld	s1,600(sp)
 20a:	bdc1                	j	da <find+0x5a>
            fprintf(2, "find: cannot stat %s\n", buf);
 20c:	dc040613          	addi	a2,s0,-576
 210:	00001597          	auipc	a1,0x1
 214:	8c858593          	addi	a1,a1,-1848 # ad8 <malloc+0x114>
 218:	4509                	li	a0,2
 21a:	6cc000ef          	jal	8e6 <fprintf>
            continue; // 获取状态失败，继续下一个目录项
 21e:	bf99                	j	174 <find+0xf4>
            find(buf, filename);
 220:	85ce                	mv	a1,s3
 222:	dc040513          	addi	a0,s0,-576
 226:	e5bff0ef          	jal	80 <find>
            break;
 22a:	b7a9                	j	174 <find+0xf4>
    close(fd);
 22c:	8526                	mv	a0,s1
 22e:	2da000ef          	jal	508 <close>
 232:	25813483          	ld	s1,600(sp)
 236:	24013a03          	ld	s4,576(sp)
 23a:	23813a83          	ld	s5,568(sp)
 23e:	23013b03          	ld	s6,560(sp)
 242:	bd61                	j	da <find+0x5a>

0000000000000244 <main>:

// 主函数
int main(int argc, char *argv[]) {
 244:	1141                	addi	sp,sp,-16
 246:	e406                	sd	ra,8(sp)
 248:	e022                	sd	s0,0(sp)
 24a:	0800                	addi	s0,sp,16
    // 检查命令行参数数量是否正确 (程序名 + 路径 + 文件名)
    if(argc != 3){
 24c:	470d                	li	a4,3
 24e:	00e50c63          	beq	a0,a4,266 <main+0x22>
        fprintf(2, "用法: find <目录路径> <文件名>\n");
 252:	00001597          	auipc	a1,0x1
 256:	8ee58593          	addi	a1,a1,-1810 # b40 <malloc+0x17c>
 25a:	4509                	li	a0,2
 25c:	68a000ef          	jal	8e6 <fprintf>
        exit(1); // 参数错误，退出
 260:	4505                	li	a0,1
 262:	27e000ef          	jal	4e0 <exit>
 266:	87ae                	mv	a5,a1
    }

    // 调用递归查找函数
    find(argv[1], argv[2]);
 268:	698c                	ld	a1,16(a1)
 26a:	6788                	ld	a0,8(a5)
 26c:	e15ff0ef          	jal	80 <find>

    // 程序正常结束
    exit(0);
 270:	4501                	li	a0,0
 272:	26e000ef          	jal	4e0 <exit>

0000000000000276 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 276:	1141                	addi	sp,sp,-16
 278:	e406                	sd	ra,8(sp)
 27a:	e022                	sd	s0,0(sp)
 27c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 27e:	fc7ff0ef          	jal	244 <main>
  exit(0);
 282:	4501                	li	a0,0
 284:	25c000ef          	jal	4e0 <exit>

0000000000000288 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e422                	sd	s0,8(sp)
 28c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 28e:	87aa                	mv	a5,a0
 290:	0585                	addi	a1,a1,1
 292:	0785                	addi	a5,a5,1
 294:	fff5c703          	lbu	a4,-1(a1)
 298:	fee78fa3          	sb	a4,-1(a5)
 29c:	fb75                	bnez	a4,290 <strcpy+0x8>
    ;
  return os;
}
 29e:	6422                	ld	s0,8(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret

00000000000002a4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e422                	sd	s0,8(sp)
 2a8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2aa:	00054783          	lbu	a5,0(a0)
 2ae:	cb91                	beqz	a5,2c2 <strcmp+0x1e>
 2b0:	0005c703          	lbu	a4,0(a1)
 2b4:	00f71763          	bne	a4,a5,2c2 <strcmp+0x1e>
    p++, q++;
 2b8:	0505                	addi	a0,a0,1
 2ba:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2bc:	00054783          	lbu	a5,0(a0)
 2c0:	fbe5                	bnez	a5,2b0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2c2:	0005c503          	lbu	a0,0(a1)
}
 2c6:	40a7853b          	subw	a0,a5,a0
 2ca:	6422                	ld	s0,8(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret

00000000000002d0 <strlen>:

uint
strlen(const char *s)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e422                	sd	s0,8(sp)
 2d4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2d6:	00054783          	lbu	a5,0(a0)
 2da:	cf91                	beqz	a5,2f6 <strlen+0x26>
 2dc:	0505                	addi	a0,a0,1
 2de:	87aa                	mv	a5,a0
 2e0:	86be                	mv	a3,a5
 2e2:	0785                	addi	a5,a5,1
 2e4:	fff7c703          	lbu	a4,-1(a5)
 2e8:	ff65                	bnez	a4,2e0 <strlen+0x10>
 2ea:	40a6853b          	subw	a0,a3,a0
 2ee:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2f0:	6422                	ld	s0,8(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
  for(n = 0; s[n]; n++)
 2f6:	4501                	li	a0,0
 2f8:	bfe5                	j	2f0 <strlen+0x20>

00000000000002fa <memset>:

void*
memset(void *dst, int c, uint n)
{
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e422                	sd	s0,8(sp)
 2fe:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 300:	ca19                	beqz	a2,316 <memset+0x1c>
 302:	87aa                	mv	a5,a0
 304:	1602                	slli	a2,a2,0x20
 306:	9201                	srli	a2,a2,0x20
 308:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 30c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 310:	0785                	addi	a5,a5,1
 312:	fee79de3          	bne	a5,a4,30c <memset+0x12>
  }
  return dst;
}
 316:	6422                	ld	s0,8(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret

000000000000031c <strchr>:

char*
strchr(const char *s, char c)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	addi	s0,sp,16
  for(; *s; s++)
 322:	00054783          	lbu	a5,0(a0)
 326:	cb99                	beqz	a5,33c <strchr+0x20>
    if(*s == c)
 328:	00f58763          	beq	a1,a5,336 <strchr+0x1a>
  for(; *s; s++)
 32c:	0505                	addi	a0,a0,1
 32e:	00054783          	lbu	a5,0(a0)
 332:	fbfd                	bnez	a5,328 <strchr+0xc>
      return (char*)s;
  return 0;
 334:	4501                	li	a0,0
}
 336:	6422                	ld	s0,8(sp)
 338:	0141                	addi	sp,sp,16
 33a:	8082                	ret
  return 0;
 33c:	4501                	li	a0,0
 33e:	bfe5                	j	336 <strchr+0x1a>

0000000000000340 <gets>:

char*
gets(char *buf, int max)
{
 340:	711d                	addi	sp,sp,-96
 342:	ec86                	sd	ra,88(sp)
 344:	e8a2                	sd	s0,80(sp)
 346:	e4a6                	sd	s1,72(sp)
 348:	e0ca                	sd	s2,64(sp)
 34a:	fc4e                	sd	s3,56(sp)
 34c:	f852                	sd	s4,48(sp)
 34e:	f456                	sd	s5,40(sp)
 350:	f05a                	sd	s6,32(sp)
 352:	ec5e                	sd	s7,24(sp)
 354:	1080                	addi	s0,sp,96
 356:	8baa                	mv	s7,a0
 358:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 35a:	892a                	mv	s2,a0
 35c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 35e:	4aa9                	li	s5,10
 360:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 362:	89a6                	mv	s3,s1
 364:	2485                	addiw	s1,s1,1
 366:	0344d663          	bge	s1,s4,392 <gets+0x52>
    cc = read(0, &c, 1);
 36a:	4605                	li	a2,1
 36c:	faf40593          	addi	a1,s0,-81
 370:	4501                	li	a0,0
 372:	186000ef          	jal	4f8 <read>
    if(cc < 1)
 376:	00a05e63          	blez	a0,392 <gets+0x52>
    buf[i++] = c;
 37a:	faf44783          	lbu	a5,-81(s0)
 37e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 382:	01578763          	beq	a5,s5,390 <gets+0x50>
 386:	0905                	addi	s2,s2,1
 388:	fd679de3          	bne	a5,s6,362 <gets+0x22>
    buf[i++] = c;
 38c:	89a6                	mv	s3,s1
 38e:	a011                	j	392 <gets+0x52>
 390:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 392:	99de                	add	s3,s3,s7
 394:	00098023          	sb	zero,0(s3)
  return buf;
}
 398:	855e                	mv	a0,s7
 39a:	60e6                	ld	ra,88(sp)
 39c:	6446                	ld	s0,80(sp)
 39e:	64a6                	ld	s1,72(sp)
 3a0:	6906                	ld	s2,64(sp)
 3a2:	79e2                	ld	s3,56(sp)
 3a4:	7a42                	ld	s4,48(sp)
 3a6:	7aa2                	ld	s5,40(sp)
 3a8:	7b02                	ld	s6,32(sp)
 3aa:	6be2                	ld	s7,24(sp)
 3ac:	6125                	addi	sp,sp,96
 3ae:	8082                	ret

00000000000003b0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3b0:	1101                	addi	sp,sp,-32
 3b2:	ec06                	sd	ra,24(sp)
 3b4:	e822                	sd	s0,16(sp)
 3b6:	e04a                	sd	s2,0(sp)
 3b8:	1000                	addi	s0,sp,32
 3ba:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3bc:	4581                	li	a1,0
 3be:	162000ef          	jal	520 <open>
  if(fd < 0)
 3c2:	02054263          	bltz	a0,3e6 <stat+0x36>
 3c6:	e426                	sd	s1,8(sp)
 3c8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3ca:	85ca                	mv	a1,s2
 3cc:	16c000ef          	jal	538 <fstat>
 3d0:	892a                	mv	s2,a0
  close(fd);
 3d2:	8526                	mv	a0,s1
 3d4:	134000ef          	jal	508 <close>
  return r;
 3d8:	64a2                	ld	s1,8(sp)
}
 3da:	854a                	mv	a0,s2
 3dc:	60e2                	ld	ra,24(sp)
 3de:	6442                	ld	s0,16(sp)
 3e0:	6902                	ld	s2,0(sp)
 3e2:	6105                	addi	sp,sp,32
 3e4:	8082                	ret
    return -1;
 3e6:	597d                	li	s2,-1
 3e8:	bfcd                	j	3da <stat+0x2a>

00000000000003ea <atoi>:

int
atoi(const char *s)
{
 3ea:	1141                	addi	sp,sp,-16
 3ec:	e422                	sd	s0,8(sp)
 3ee:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3f0:	00054683          	lbu	a3,0(a0)
 3f4:	fd06879b          	addiw	a5,a3,-48
 3f8:	0ff7f793          	zext.b	a5,a5
 3fc:	4625                	li	a2,9
 3fe:	02f66863          	bltu	a2,a5,42e <atoi+0x44>
 402:	872a                	mv	a4,a0
  n = 0;
 404:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 406:	0705                	addi	a4,a4,1
 408:	0025179b          	slliw	a5,a0,0x2
 40c:	9fa9                	addw	a5,a5,a0
 40e:	0017979b          	slliw	a5,a5,0x1
 412:	9fb5                	addw	a5,a5,a3
 414:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 418:	00074683          	lbu	a3,0(a4)
 41c:	fd06879b          	addiw	a5,a3,-48
 420:	0ff7f793          	zext.b	a5,a5
 424:	fef671e3          	bgeu	a2,a5,406 <atoi+0x1c>
  return n;
}
 428:	6422                	ld	s0,8(sp)
 42a:	0141                	addi	sp,sp,16
 42c:	8082                	ret
  n = 0;
 42e:	4501                	li	a0,0
 430:	bfe5                	j	428 <atoi+0x3e>

0000000000000432 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 432:	1141                	addi	sp,sp,-16
 434:	e422                	sd	s0,8(sp)
 436:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 438:	02b57463          	bgeu	a0,a1,460 <memmove+0x2e>
    while(n-- > 0)
 43c:	00c05f63          	blez	a2,45a <memmove+0x28>
 440:	1602                	slli	a2,a2,0x20
 442:	9201                	srli	a2,a2,0x20
 444:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 448:	872a                	mv	a4,a0
      *dst++ = *src++;
 44a:	0585                	addi	a1,a1,1
 44c:	0705                	addi	a4,a4,1
 44e:	fff5c683          	lbu	a3,-1(a1)
 452:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 456:	fef71ae3          	bne	a4,a5,44a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 45a:	6422                	ld	s0,8(sp)
 45c:	0141                	addi	sp,sp,16
 45e:	8082                	ret
    dst += n;
 460:	00c50733          	add	a4,a0,a2
    src += n;
 464:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 466:	fec05ae3          	blez	a2,45a <memmove+0x28>
 46a:	fff6079b          	addiw	a5,a2,-1
 46e:	1782                	slli	a5,a5,0x20
 470:	9381                	srli	a5,a5,0x20
 472:	fff7c793          	not	a5,a5
 476:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 478:	15fd                	addi	a1,a1,-1
 47a:	177d                	addi	a4,a4,-1
 47c:	0005c683          	lbu	a3,0(a1)
 480:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 484:	fee79ae3          	bne	a5,a4,478 <memmove+0x46>
 488:	bfc9                	j	45a <memmove+0x28>

000000000000048a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 48a:	1141                	addi	sp,sp,-16
 48c:	e422                	sd	s0,8(sp)
 48e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 490:	ca05                	beqz	a2,4c0 <memcmp+0x36>
 492:	fff6069b          	addiw	a3,a2,-1
 496:	1682                	slli	a3,a3,0x20
 498:	9281                	srli	a3,a3,0x20
 49a:	0685                	addi	a3,a3,1
 49c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 49e:	00054783          	lbu	a5,0(a0)
 4a2:	0005c703          	lbu	a4,0(a1)
 4a6:	00e79863          	bne	a5,a4,4b6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4aa:	0505                	addi	a0,a0,1
    p2++;
 4ac:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4ae:	fed518e3          	bne	a0,a3,49e <memcmp+0x14>
  }
  return 0;
 4b2:	4501                	li	a0,0
 4b4:	a019                	j	4ba <memcmp+0x30>
      return *p1 - *p2;
 4b6:	40e7853b          	subw	a0,a5,a4
}
 4ba:	6422                	ld	s0,8(sp)
 4bc:	0141                	addi	sp,sp,16
 4be:	8082                	ret
  return 0;
 4c0:	4501                	li	a0,0
 4c2:	bfe5                	j	4ba <memcmp+0x30>

00000000000004c4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4c4:	1141                	addi	sp,sp,-16
 4c6:	e406                	sd	ra,8(sp)
 4c8:	e022                	sd	s0,0(sp)
 4ca:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4cc:	f67ff0ef          	jal	432 <memmove>
}
 4d0:	60a2                	ld	ra,8(sp)
 4d2:	6402                	ld	s0,0(sp)
 4d4:	0141                	addi	sp,sp,16
 4d6:	8082                	ret

00000000000004d8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4d8:	4885                	li	a7,1
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4e0:	4889                	li	a7,2
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4e8:	488d                	li	a7,3
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4f0:	4891                	li	a7,4
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <read>:
.global read
read:
 li a7, SYS_read
 4f8:	4895                	li	a7,5
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <write>:
.global write
write:
 li a7, SYS_write
 500:	48c1                	li	a7,16
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <close>:
.global close
close:
 li a7, SYS_close
 508:	48d5                	li	a7,21
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <kill>:
.global kill
kill:
 li a7, SYS_kill
 510:	4899                	li	a7,6
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <exec>:
.global exec
exec:
 li a7, SYS_exec
 518:	489d                	li	a7,7
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <open>:
.global open
open:
 li a7, SYS_open
 520:	48bd                	li	a7,15
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 528:	48c5                	li	a7,17
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 530:	48c9                	li	a7,18
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 538:	48a1                	li	a7,8
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <link>:
.global link
link:
 li a7, SYS_link
 540:	48cd                	li	a7,19
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 548:	48d1                	li	a7,20
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 550:	48a5                	li	a7,9
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <dup>:
.global dup
dup:
 li a7, SYS_dup
 558:	48a9                	li	a7,10
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 560:	48ad                	li	a7,11
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 568:	48b1                	li	a7,12
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 570:	48b5                	li	a7,13
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 578:	48b9                	li	a7,14
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <trace>:
.global trace
trace:
 li a7, SYS_trace
 580:	48d9                	li	a7,22
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 588:	48dd                	li	a7,23
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 590:	48e1                	li	a7,24
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 598:	1101                	addi	sp,sp,-32
 59a:	ec06                	sd	ra,24(sp)
 59c:	e822                	sd	s0,16(sp)
 59e:	1000                	addi	s0,sp,32
 5a0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5a4:	4605                	li	a2,1
 5a6:	fef40593          	addi	a1,s0,-17
 5aa:	f57ff0ef          	jal	500 <write>
}
 5ae:	60e2                	ld	ra,24(sp)
 5b0:	6442                	ld	s0,16(sp)
 5b2:	6105                	addi	sp,sp,32
 5b4:	8082                	ret

00000000000005b6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5b6:	7139                	addi	sp,sp,-64
 5b8:	fc06                	sd	ra,56(sp)
 5ba:	f822                	sd	s0,48(sp)
 5bc:	f426                	sd	s1,40(sp)
 5be:	0080                	addi	s0,sp,64
 5c0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5c2:	c299                	beqz	a3,5c8 <printint+0x12>
 5c4:	0805c963          	bltz	a1,656 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5c8:	2581                	sext.w	a1,a1
  neg = 0;
 5ca:	4881                	li	a7,0
 5cc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5d0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5d2:	2601                	sext.w	a2,a2
 5d4:	00000517          	auipc	a0,0x0
 5d8:	5a450513          	addi	a0,a0,1444 # b78 <digits>
 5dc:	883a                	mv	a6,a4
 5de:	2705                	addiw	a4,a4,1
 5e0:	02c5f7bb          	remuw	a5,a1,a2
 5e4:	1782                	slli	a5,a5,0x20
 5e6:	9381                	srli	a5,a5,0x20
 5e8:	97aa                	add	a5,a5,a0
 5ea:	0007c783          	lbu	a5,0(a5)
 5ee:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5f2:	0005879b          	sext.w	a5,a1
 5f6:	02c5d5bb          	divuw	a1,a1,a2
 5fa:	0685                	addi	a3,a3,1
 5fc:	fec7f0e3          	bgeu	a5,a2,5dc <printint+0x26>
  if(neg)
 600:	00088c63          	beqz	a7,618 <printint+0x62>
    buf[i++] = '-';
 604:	fd070793          	addi	a5,a4,-48
 608:	00878733          	add	a4,a5,s0
 60c:	02d00793          	li	a5,45
 610:	fef70823          	sb	a5,-16(a4)
 614:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 618:	02e05a63          	blez	a4,64c <printint+0x96>
 61c:	f04a                	sd	s2,32(sp)
 61e:	ec4e                	sd	s3,24(sp)
 620:	fc040793          	addi	a5,s0,-64
 624:	00e78933          	add	s2,a5,a4
 628:	fff78993          	addi	s3,a5,-1
 62c:	99ba                	add	s3,s3,a4
 62e:	377d                	addiw	a4,a4,-1
 630:	1702                	slli	a4,a4,0x20
 632:	9301                	srli	a4,a4,0x20
 634:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 638:	fff94583          	lbu	a1,-1(s2)
 63c:	8526                	mv	a0,s1
 63e:	f5bff0ef          	jal	598 <putc>
  while(--i >= 0)
 642:	197d                	addi	s2,s2,-1
 644:	ff391ae3          	bne	s2,s3,638 <printint+0x82>
 648:	7902                	ld	s2,32(sp)
 64a:	69e2                	ld	s3,24(sp)
}
 64c:	70e2                	ld	ra,56(sp)
 64e:	7442                	ld	s0,48(sp)
 650:	74a2                	ld	s1,40(sp)
 652:	6121                	addi	sp,sp,64
 654:	8082                	ret
    x = -xx;
 656:	40b005bb          	negw	a1,a1
    neg = 1;
 65a:	4885                	li	a7,1
    x = -xx;
 65c:	bf85                	j	5cc <printint+0x16>

000000000000065e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 65e:	711d                	addi	sp,sp,-96
 660:	ec86                	sd	ra,88(sp)
 662:	e8a2                	sd	s0,80(sp)
 664:	e0ca                	sd	s2,64(sp)
 666:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 668:	0005c903          	lbu	s2,0(a1)
 66c:	26090863          	beqz	s2,8dc <vprintf+0x27e>
 670:	e4a6                	sd	s1,72(sp)
 672:	fc4e                	sd	s3,56(sp)
 674:	f852                	sd	s4,48(sp)
 676:	f456                	sd	s5,40(sp)
 678:	f05a                	sd	s6,32(sp)
 67a:	ec5e                	sd	s7,24(sp)
 67c:	e862                	sd	s8,16(sp)
 67e:	e466                	sd	s9,8(sp)
 680:	8b2a                	mv	s6,a0
 682:	8a2e                	mv	s4,a1
 684:	8bb2                	mv	s7,a2
  state = 0;
 686:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 688:	4481                	li	s1,0
 68a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 68c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 690:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 694:	06c00c93          	li	s9,108
 698:	a005                	j	6b8 <vprintf+0x5a>
        putc(fd, c0);
 69a:	85ca                	mv	a1,s2
 69c:	855a                	mv	a0,s6
 69e:	efbff0ef          	jal	598 <putc>
 6a2:	a019                	j	6a8 <vprintf+0x4a>
    } else if(state == '%'){
 6a4:	03598263          	beq	s3,s5,6c8 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 6a8:	2485                	addiw	s1,s1,1
 6aa:	8726                	mv	a4,s1
 6ac:	009a07b3          	add	a5,s4,s1
 6b0:	0007c903          	lbu	s2,0(a5)
 6b4:	20090c63          	beqz	s2,8cc <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 6b8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6bc:	fe0994e3          	bnez	s3,6a4 <vprintf+0x46>
      if(c0 == '%'){
 6c0:	fd579de3          	bne	a5,s5,69a <vprintf+0x3c>
        state = '%';
 6c4:	89be                	mv	s3,a5
 6c6:	b7cd                	j	6a8 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6c8:	00ea06b3          	add	a3,s4,a4
 6cc:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6d0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6d2:	c681                	beqz	a3,6da <vprintf+0x7c>
 6d4:	9752                	add	a4,a4,s4
 6d6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6da:	03878f63          	beq	a5,s8,718 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 6de:	05978963          	beq	a5,s9,730 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6e2:	07500713          	li	a4,117
 6e6:	0ee78363          	beq	a5,a4,7cc <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6ea:	07800713          	li	a4,120
 6ee:	12e78563          	beq	a5,a4,818 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6f2:	07000713          	li	a4,112
 6f6:	14e78a63          	beq	a5,a4,84a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6fa:	07300713          	li	a4,115
 6fe:	18e78a63          	beq	a5,a4,892 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 702:	02500713          	li	a4,37
 706:	04e79563          	bne	a5,a4,750 <vprintf+0xf2>
        putc(fd, '%');
 70a:	02500593          	li	a1,37
 70e:	855a                	mv	a0,s6
 710:	e89ff0ef          	jal	598 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 714:	4981                	li	s3,0
 716:	bf49                	j	6a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 718:	008b8913          	addi	s2,s7,8
 71c:	4685                	li	a3,1
 71e:	4629                	li	a2,10
 720:	000ba583          	lw	a1,0(s7)
 724:	855a                	mv	a0,s6
 726:	e91ff0ef          	jal	5b6 <printint>
 72a:	8bca                	mv	s7,s2
      state = 0;
 72c:	4981                	li	s3,0
 72e:	bfad                	j	6a8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 730:	06400793          	li	a5,100
 734:	02f68963          	beq	a3,a5,766 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 738:	06c00793          	li	a5,108
 73c:	04f68263          	beq	a3,a5,780 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 740:	07500793          	li	a5,117
 744:	0af68063          	beq	a3,a5,7e4 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 748:	07800793          	li	a5,120
 74c:	0ef68263          	beq	a3,a5,830 <vprintf+0x1d2>
        putc(fd, '%');
 750:	02500593          	li	a1,37
 754:	855a                	mv	a0,s6
 756:	e43ff0ef          	jal	598 <putc>
        putc(fd, c0);
 75a:	85ca                	mv	a1,s2
 75c:	855a                	mv	a0,s6
 75e:	e3bff0ef          	jal	598 <putc>
      state = 0;
 762:	4981                	li	s3,0
 764:	b791                	j	6a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 766:	008b8913          	addi	s2,s7,8
 76a:	4685                	li	a3,1
 76c:	4629                	li	a2,10
 76e:	000ba583          	lw	a1,0(s7)
 772:	855a                	mv	a0,s6
 774:	e43ff0ef          	jal	5b6 <printint>
        i += 1;
 778:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 77a:	8bca                	mv	s7,s2
      state = 0;
 77c:	4981                	li	s3,0
        i += 1;
 77e:	b72d                	j	6a8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 780:	06400793          	li	a5,100
 784:	02f60763          	beq	a2,a5,7b2 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 788:	07500793          	li	a5,117
 78c:	06f60963          	beq	a2,a5,7fe <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 790:	07800793          	li	a5,120
 794:	faf61ee3          	bne	a2,a5,750 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 798:	008b8913          	addi	s2,s7,8
 79c:	4681                	li	a3,0
 79e:	4641                	li	a2,16
 7a0:	000ba583          	lw	a1,0(s7)
 7a4:	855a                	mv	a0,s6
 7a6:	e11ff0ef          	jal	5b6 <printint>
        i += 2;
 7aa:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ac:	8bca                	mv	s7,s2
      state = 0;
 7ae:	4981                	li	s3,0
        i += 2;
 7b0:	bde5                	j	6a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7b2:	008b8913          	addi	s2,s7,8
 7b6:	4685                	li	a3,1
 7b8:	4629                	li	a2,10
 7ba:	000ba583          	lw	a1,0(s7)
 7be:	855a                	mv	a0,s6
 7c0:	df7ff0ef          	jal	5b6 <printint>
        i += 2;
 7c4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c6:	8bca                	mv	s7,s2
      state = 0;
 7c8:	4981                	li	s3,0
        i += 2;
 7ca:	bdf9                	j	6a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7cc:	008b8913          	addi	s2,s7,8
 7d0:	4681                	li	a3,0
 7d2:	4629                	li	a2,10
 7d4:	000ba583          	lw	a1,0(s7)
 7d8:	855a                	mv	a0,s6
 7da:	dddff0ef          	jal	5b6 <printint>
 7de:	8bca                	mv	s7,s2
      state = 0;
 7e0:	4981                	li	s3,0
 7e2:	b5d9                	j	6a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e4:	008b8913          	addi	s2,s7,8
 7e8:	4681                	li	a3,0
 7ea:	4629                	li	a2,10
 7ec:	000ba583          	lw	a1,0(s7)
 7f0:	855a                	mv	a0,s6
 7f2:	dc5ff0ef          	jal	5b6 <printint>
        i += 1;
 7f6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f8:	8bca                	mv	s7,s2
      state = 0;
 7fa:	4981                	li	s3,0
        i += 1;
 7fc:	b575                	j	6a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7fe:	008b8913          	addi	s2,s7,8
 802:	4681                	li	a3,0
 804:	4629                	li	a2,10
 806:	000ba583          	lw	a1,0(s7)
 80a:	855a                	mv	a0,s6
 80c:	dabff0ef          	jal	5b6 <printint>
        i += 2;
 810:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 812:	8bca                	mv	s7,s2
      state = 0;
 814:	4981                	li	s3,0
        i += 2;
 816:	bd49                	j	6a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 818:	008b8913          	addi	s2,s7,8
 81c:	4681                	li	a3,0
 81e:	4641                	li	a2,16
 820:	000ba583          	lw	a1,0(s7)
 824:	855a                	mv	a0,s6
 826:	d91ff0ef          	jal	5b6 <printint>
 82a:	8bca                	mv	s7,s2
      state = 0;
 82c:	4981                	li	s3,0
 82e:	bdad                	j	6a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 830:	008b8913          	addi	s2,s7,8
 834:	4681                	li	a3,0
 836:	4641                	li	a2,16
 838:	000ba583          	lw	a1,0(s7)
 83c:	855a                	mv	a0,s6
 83e:	d79ff0ef          	jal	5b6 <printint>
        i += 1;
 842:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 844:	8bca                	mv	s7,s2
      state = 0;
 846:	4981                	li	s3,0
        i += 1;
 848:	b585                	j	6a8 <vprintf+0x4a>
 84a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 84c:	008b8d13          	addi	s10,s7,8
 850:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 854:	03000593          	li	a1,48
 858:	855a                	mv	a0,s6
 85a:	d3fff0ef          	jal	598 <putc>
  putc(fd, 'x');
 85e:	07800593          	li	a1,120
 862:	855a                	mv	a0,s6
 864:	d35ff0ef          	jal	598 <putc>
 868:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 86a:	00000b97          	auipc	s7,0x0
 86e:	30eb8b93          	addi	s7,s7,782 # b78 <digits>
 872:	03c9d793          	srli	a5,s3,0x3c
 876:	97de                	add	a5,a5,s7
 878:	0007c583          	lbu	a1,0(a5)
 87c:	855a                	mv	a0,s6
 87e:	d1bff0ef          	jal	598 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 882:	0992                	slli	s3,s3,0x4
 884:	397d                	addiw	s2,s2,-1
 886:	fe0916e3          	bnez	s2,872 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 88a:	8bea                	mv	s7,s10
      state = 0;
 88c:	4981                	li	s3,0
 88e:	6d02                	ld	s10,0(sp)
 890:	bd21                	j	6a8 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 892:	008b8993          	addi	s3,s7,8
 896:	000bb903          	ld	s2,0(s7)
 89a:	00090f63          	beqz	s2,8b8 <vprintf+0x25a>
        for(; *s; s++)
 89e:	00094583          	lbu	a1,0(s2)
 8a2:	c195                	beqz	a1,8c6 <vprintf+0x268>
          putc(fd, *s);
 8a4:	855a                	mv	a0,s6
 8a6:	cf3ff0ef          	jal	598 <putc>
        for(; *s; s++)
 8aa:	0905                	addi	s2,s2,1
 8ac:	00094583          	lbu	a1,0(s2)
 8b0:	f9f5                	bnez	a1,8a4 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8b2:	8bce                	mv	s7,s3
      state = 0;
 8b4:	4981                	li	s3,0
 8b6:	bbcd                	j	6a8 <vprintf+0x4a>
          s = "(null)";
 8b8:	00000917          	auipc	s2,0x0
 8bc:	2b890913          	addi	s2,s2,696 # b70 <malloc+0x1ac>
        for(; *s; s++)
 8c0:	02800593          	li	a1,40
 8c4:	b7c5                	j	8a4 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8c6:	8bce                	mv	s7,s3
      state = 0;
 8c8:	4981                	li	s3,0
 8ca:	bbf9                	j	6a8 <vprintf+0x4a>
 8cc:	64a6                	ld	s1,72(sp)
 8ce:	79e2                	ld	s3,56(sp)
 8d0:	7a42                	ld	s4,48(sp)
 8d2:	7aa2                	ld	s5,40(sp)
 8d4:	7b02                	ld	s6,32(sp)
 8d6:	6be2                	ld	s7,24(sp)
 8d8:	6c42                	ld	s8,16(sp)
 8da:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8dc:	60e6                	ld	ra,88(sp)
 8de:	6446                	ld	s0,80(sp)
 8e0:	6906                	ld	s2,64(sp)
 8e2:	6125                	addi	sp,sp,96
 8e4:	8082                	ret

00000000000008e6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8e6:	715d                	addi	sp,sp,-80
 8e8:	ec06                	sd	ra,24(sp)
 8ea:	e822                	sd	s0,16(sp)
 8ec:	1000                	addi	s0,sp,32
 8ee:	e010                	sd	a2,0(s0)
 8f0:	e414                	sd	a3,8(s0)
 8f2:	e818                	sd	a4,16(s0)
 8f4:	ec1c                	sd	a5,24(s0)
 8f6:	03043023          	sd	a6,32(s0)
 8fa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8fe:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 902:	8622                	mv	a2,s0
 904:	d5bff0ef          	jal	65e <vprintf>
}
 908:	60e2                	ld	ra,24(sp)
 90a:	6442                	ld	s0,16(sp)
 90c:	6161                	addi	sp,sp,80
 90e:	8082                	ret

0000000000000910 <printf>:

void
printf(const char *fmt, ...)
{
 910:	711d                	addi	sp,sp,-96
 912:	ec06                	sd	ra,24(sp)
 914:	e822                	sd	s0,16(sp)
 916:	1000                	addi	s0,sp,32
 918:	e40c                	sd	a1,8(s0)
 91a:	e810                	sd	a2,16(s0)
 91c:	ec14                	sd	a3,24(s0)
 91e:	f018                	sd	a4,32(s0)
 920:	f41c                	sd	a5,40(s0)
 922:	03043823          	sd	a6,48(s0)
 926:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 92a:	00840613          	addi	a2,s0,8
 92e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 932:	85aa                	mv	a1,a0
 934:	4505                	li	a0,1
 936:	d29ff0ef          	jal	65e <vprintf>
}
 93a:	60e2                	ld	ra,24(sp)
 93c:	6442                	ld	s0,16(sp)
 93e:	6125                	addi	sp,sp,96
 940:	8082                	ret

0000000000000942 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 942:	1141                	addi	sp,sp,-16
 944:	e422                	sd	s0,8(sp)
 946:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 948:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 94c:	00000797          	auipc	a5,0x0
 950:	6b47b783          	ld	a5,1716(a5) # 1000 <freep>
 954:	a02d                	j	97e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 956:	4618                	lw	a4,8(a2)
 958:	9f2d                	addw	a4,a4,a1
 95a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 95e:	6398                	ld	a4,0(a5)
 960:	6310                	ld	a2,0(a4)
 962:	a83d                	j	9a0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 964:	ff852703          	lw	a4,-8(a0)
 968:	9f31                	addw	a4,a4,a2
 96a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 96c:	ff053683          	ld	a3,-16(a0)
 970:	a091                	j	9b4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 972:	6398                	ld	a4,0(a5)
 974:	00e7e463          	bltu	a5,a4,97c <free+0x3a>
 978:	00e6ea63          	bltu	a3,a4,98c <free+0x4a>
{
 97c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 97e:	fed7fae3          	bgeu	a5,a3,972 <free+0x30>
 982:	6398                	ld	a4,0(a5)
 984:	00e6e463          	bltu	a3,a4,98c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 988:	fee7eae3          	bltu	a5,a4,97c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 98c:	ff852583          	lw	a1,-8(a0)
 990:	6390                	ld	a2,0(a5)
 992:	02059813          	slli	a6,a1,0x20
 996:	01c85713          	srli	a4,a6,0x1c
 99a:	9736                	add	a4,a4,a3
 99c:	fae60de3          	beq	a2,a4,956 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9a0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9a4:	4790                	lw	a2,8(a5)
 9a6:	02061593          	slli	a1,a2,0x20
 9aa:	01c5d713          	srli	a4,a1,0x1c
 9ae:	973e                	add	a4,a4,a5
 9b0:	fae68ae3          	beq	a3,a4,964 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9b4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9b6:	00000717          	auipc	a4,0x0
 9ba:	64f73523          	sd	a5,1610(a4) # 1000 <freep>
}
 9be:	6422                	ld	s0,8(sp)
 9c0:	0141                	addi	sp,sp,16
 9c2:	8082                	ret

00000000000009c4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9c4:	7139                	addi	sp,sp,-64
 9c6:	fc06                	sd	ra,56(sp)
 9c8:	f822                	sd	s0,48(sp)
 9ca:	f426                	sd	s1,40(sp)
 9cc:	ec4e                	sd	s3,24(sp)
 9ce:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d0:	02051493          	slli	s1,a0,0x20
 9d4:	9081                	srli	s1,s1,0x20
 9d6:	04bd                	addi	s1,s1,15
 9d8:	8091                	srli	s1,s1,0x4
 9da:	0014899b          	addiw	s3,s1,1
 9de:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9e0:	00000517          	auipc	a0,0x0
 9e4:	62053503          	ld	a0,1568(a0) # 1000 <freep>
 9e8:	c915                	beqz	a0,a1c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ea:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ec:	4798                	lw	a4,8(a5)
 9ee:	08977a63          	bgeu	a4,s1,a82 <malloc+0xbe>
 9f2:	f04a                	sd	s2,32(sp)
 9f4:	e852                	sd	s4,16(sp)
 9f6:	e456                	sd	s5,8(sp)
 9f8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9fa:	8a4e                	mv	s4,s3
 9fc:	0009871b          	sext.w	a4,s3
 a00:	6685                	lui	a3,0x1
 a02:	00d77363          	bgeu	a4,a3,a08 <malloc+0x44>
 a06:	6a05                	lui	s4,0x1
 a08:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a0c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a10:	00000917          	auipc	s2,0x0
 a14:	5f090913          	addi	s2,s2,1520 # 1000 <freep>
  if(p == (char*)-1)
 a18:	5afd                	li	s5,-1
 a1a:	a081                	j	a5a <malloc+0x96>
 a1c:	f04a                	sd	s2,32(sp)
 a1e:	e852                	sd	s4,16(sp)
 a20:	e456                	sd	s5,8(sp)
 a22:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a24:	00000797          	auipc	a5,0x0
 a28:	5fc78793          	addi	a5,a5,1532 # 1020 <base>
 a2c:	00000717          	auipc	a4,0x0
 a30:	5cf73a23          	sd	a5,1492(a4) # 1000 <freep>
 a34:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a36:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a3a:	b7c1                	j	9fa <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a3c:	6398                	ld	a4,0(a5)
 a3e:	e118                	sd	a4,0(a0)
 a40:	a8a9                	j	a9a <malloc+0xd6>
  hp->s.size = nu;
 a42:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a46:	0541                	addi	a0,a0,16
 a48:	efbff0ef          	jal	942 <free>
  return freep;
 a4c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a50:	c12d                	beqz	a0,ab2 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a52:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a54:	4798                	lw	a4,8(a5)
 a56:	02977263          	bgeu	a4,s1,a7a <malloc+0xb6>
    if(p == freep)
 a5a:	00093703          	ld	a4,0(s2)
 a5e:	853e                	mv	a0,a5
 a60:	fef719e3          	bne	a4,a5,a52 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a64:	8552                	mv	a0,s4
 a66:	b03ff0ef          	jal	568 <sbrk>
  if(p == (char*)-1)
 a6a:	fd551ce3          	bne	a0,s5,a42 <malloc+0x7e>
        return 0;
 a6e:	4501                	li	a0,0
 a70:	7902                	ld	s2,32(sp)
 a72:	6a42                	ld	s4,16(sp)
 a74:	6aa2                	ld	s5,8(sp)
 a76:	6b02                	ld	s6,0(sp)
 a78:	a03d                	j	aa6 <malloc+0xe2>
 a7a:	7902                	ld	s2,32(sp)
 a7c:	6a42                	ld	s4,16(sp)
 a7e:	6aa2                	ld	s5,8(sp)
 a80:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a82:	fae48de3          	beq	s1,a4,a3c <malloc+0x78>
        p->s.size -= nunits;
 a86:	4137073b          	subw	a4,a4,s3
 a8a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a8c:	02071693          	slli	a3,a4,0x20
 a90:	01c6d713          	srli	a4,a3,0x1c
 a94:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a96:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a9a:	00000717          	auipc	a4,0x0
 a9e:	56a73323          	sd	a0,1382(a4) # 1000 <freep>
      return (void*)(p + 1);
 aa2:	01078513          	addi	a0,a5,16
  }
}
 aa6:	70e2                	ld	ra,56(sp)
 aa8:	7442                	ld	s0,48(sp)
 aaa:	74a2                	ld	s1,40(sp)
 aac:	69e2                	ld	s3,24(sp)
 aae:	6121                	addi	sp,sp,64
 ab0:	8082                	ret
 ab2:	7902                	ld	s2,32(sp)
 ab4:	6a42                	ld	s4,16(sp)
 ab6:	6aa2                	ld	s5,8(sp)
 ab8:	6b02                	ld	s6,0(sp)
 aba:	b7f5                	j	aa6 <malloc+0xe2>
