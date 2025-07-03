
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
   c:	2fa000ef          	jal	306 <strlen>
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
  34:	2d2000ef          	jal	306 <strlen>
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
  50:	2b6000ef          	jal	306 <strlen>
  54:	00002917          	auipc	s2,0x2
  58:	fbc90913          	addi	s2,s2,-68 # 2010 <buf.0>
  5c:	0005061b          	sext.w	a2,a0
  60:	85a6                	mv	a1,s1
  62:	854a                	mv	a0,s2
  64:	404000ef          	jal	468 <memmove>
    buf[strlen(p)] = 0; // 添加 null 终止符
  68:	8526                	mv	a0,s1
  6a:	29c000ef          	jal	306 <strlen>
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
  9c:	5b4000ef          	jal	650 <open>
  a0:	04054863          	bltz	a0,f0 <find+0x70>
  a4:	24913c23          	sd	s1,600(sp)
  a8:	84aa                	mv	s1,a0
        fprintf(2, "find: cannot open %s\n", path);
        return; // 打开失败，直接返回
    }

    // 获取当前路径的文件状态
    if(fstat(fd, &st) < 0){
  aa:	d9840593          	addi	a1,s0,-616
  ae:	5ba000ef          	jal	668 <fstat>
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
  c6:	b8e58593          	addi	a1,a1,-1138 # c50 <malloc+0x12c>
  ca:	4509                	li	a0,2
  cc:	17b000ef          	jal	a46 <fprintf>
         close(fd);
  d0:	8526                	mv	a0,s1
  d2:	566000ef          	jal	638 <close>
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
  f6:	b2e58593          	addi	a1,a1,-1234 # c20 <malloc+0xfc>
  fa:	4509                	li	a0,2
  fc:	14b000ef          	jal	a46 <fprintf>
        return; // 打开失败，直接返回
 100:	bfe9                	j	da <find+0x5a>
        fprintf(2, "find: cannot stat %s\n", path);
 102:	864a                	mv	a2,s2
 104:	00001597          	auipc	a1,0x1
 108:	b3458593          	addi	a1,a1,-1228 # c38 <malloc+0x114>
 10c:	4509                	li	a0,2
 10e:	139000ef          	jal	a46 <fprintf>
        close(fd);
 112:	8526                	mv	a0,s1
 114:	524000ef          	jal	638 <close>
        return; // 获取状态失败，关闭文件描述符后返回
 118:	25813483          	ld	s1,600(sp)
 11c:	bf7d                	j	da <find+0x5a>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 11e:	854a                	mv	a0,s2
 120:	1e6000ef          	jal	306 <strlen>
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
 148:	1be000ef          	jal	306 <strlen>
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
 168:	b24a0a13          	addi	s4,s4,-1244 # c88 <malloc+0x164>
 16c:	00001a97          	auipc	s5,0x1
 170:	b24a8a93          	addi	s5,s5,-1244 # c90 <malloc+0x16c>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 174:	4641                	li	a2,16
 176:	db040593          	addi	a1,s0,-592
 17a:	8526                	mv	a0,s1
 17c:	4ac000ef          	jal	628 <read>
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
 1ac:	2bc000ef          	jal	468 <memmove>
        p[DIRSIZ] = 0; // 确保字符串结束 (虽然 de.name 可能不满 DIRSIZ)
 1b0:	000907a3          	sb	zero,15(s2)
        if(stat(buf, &st) < 0){
 1b4:	d9840593          	addi	a1,s0,-616
 1b8:	dc040513          	addi	a0,s0,-576
 1bc:	22a000ef          	jal	3e6 <stat>
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
 1e8:	ab450513          	addi	a0,a0,-1356 # c98 <malloc+0x174>
 1ec:	085000ef          	jal	a70 <printf>
 1f0:	b751                	j	174 <find+0xf4>
        fprintf(2, "find: path too long\n");
 1f2:	00001597          	auipc	a1,0x1
 1f6:	a7e58593          	addi	a1,a1,-1410 # c70 <malloc+0x14c>
 1fa:	4509                	li	a0,2
 1fc:	04b000ef          	jal	a46 <fprintf>
        close(fd);
 200:	8526                	mv	a0,s1
 202:	436000ef          	jal	638 <close>
        return; // 路径可能过长，关闭文件描述符后返回
 206:	25813483          	ld	s1,600(sp)
 20a:	bdc1                	j	da <find+0x5a>
            fprintf(2, "find: cannot stat %s\n", buf);
 20c:	dc040613          	addi	a2,s0,-576
 210:	00001597          	auipc	a1,0x1
 214:	a2858593          	addi	a1,a1,-1496 # c38 <malloc+0x114>
 218:	4509                	li	a0,2
 21a:	02d000ef          	jal	a46 <fprintf>
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
 22e:	40a000ef          	jal	638 <close>
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
 256:	a4e58593          	addi	a1,a1,-1458 # ca0 <malloc+0x17c>
 25a:	4509                	li	a0,2
 25c:	7ea000ef          	jal	a46 <fprintf>
        exit(1); // 参数错误，退出
 260:	4505                	li	a0,1
 262:	3ae000ef          	jal	610 <exit>
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
 272:	39e000ef          	jal	610 <exit>

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
 284:	38c000ef          	jal	610 <exit>

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

00000000000002d0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e422                	sd	s0,8(sp)
 2d4:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q) {
 2d6:	ce11                	beqz	a2,2f2 <strncmp+0x22>
 2d8:	00054783          	lbu	a5,0(a0)
 2dc:	cf89                	beqz	a5,2f6 <strncmp+0x26>
 2de:	0005c703          	lbu	a4,0(a1)
 2e2:	00f71a63          	bne	a4,a5,2f6 <strncmp+0x26>
    n--;
 2e6:	367d                	addiw	a2,a2,-1
    p++;
 2e8:	0505                	addi	a0,a0,1
    q++;
 2ea:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q) {
 2ec:	f675                	bnez	a2,2d8 <strncmp+0x8>
  }
  if(n == 0)
    return 0;
 2ee:	4501                	li	a0,0
 2f0:	a801                	j	300 <strncmp+0x30>
 2f2:	4501                	li	a0,0
 2f4:	a031                	j	300 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
 2f6:	00054503          	lbu	a0,0(a0)
 2fa:	0005c783          	lbu	a5,0(a1)
 2fe:	9d1d                	subw	a0,a0,a5
}
 300:	6422                	ld	s0,8(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret

0000000000000306 <strlen>:

uint
strlen(const char *s)
{
 306:	1141                	addi	sp,sp,-16
 308:	e422                	sd	s0,8(sp)
 30a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 30c:	00054783          	lbu	a5,0(a0)
 310:	cf91                	beqz	a5,32c <strlen+0x26>
 312:	0505                	addi	a0,a0,1
 314:	87aa                	mv	a5,a0
 316:	86be                	mv	a3,a5
 318:	0785                	addi	a5,a5,1
 31a:	fff7c703          	lbu	a4,-1(a5)
 31e:	ff65                	bnez	a4,316 <strlen+0x10>
 320:	40a6853b          	subw	a0,a3,a0
 324:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 326:	6422                	ld	s0,8(sp)
 328:	0141                	addi	sp,sp,16
 32a:	8082                	ret
  for(n = 0; s[n]; n++)
 32c:	4501                	li	a0,0
 32e:	bfe5                	j	326 <strlen+0x20>

0000000000000330 <memset>:

void*
memset(void *dst, int c, uint n)
{
 330:	1141                	addi	sp,sp,-16
 332:	e422                	sd	s0,8(sp)
 334:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 336:	ca19                	beqz	a2,34c <memset+0x1c>
 338:	87aa                	mv	a5,a0
 33a:	1602                	slli	a2,a2,0x20
 33c:	9201                	srli	a2,a2,0x20
 33e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 342:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 346:	0785                	addi	a5,a5,1
 348:	fee79de3          	bne	a5,a4,342 <memset+0x12>
  }
  return dst;
}
 34c:	6422                	ld	s0,8(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret

0000000000000352 <strchr>:

char*
strchr(const char *s, char c)
{
 352:	1141                	addi	sp,sp,-16
 354:	e422                	sd	s0,8(sp)
 356:	0800                	addi	s0,sp,16
  for(; *s; s++)
 358:	00054783          	lbu	a5,0(a0)
 35c:	cb99                	beqz	a5,372 <strchr+0x20>
    if(*s == c)
 35e:	00f58763          	beq	a1,a5,36c <strchr+0x1a>
  for(; *s; s++)
 362:	0505                	addi	a0,a0,1
 364:	00054783          	lbu	a5,0(a0)
 368:	fbfd                	bnez	a5,35e <strchr+0xc>
      return (char*)s;
  return 0;
 36a:	4501                	li	a0,0
}
 36c:	6422                	ld	s0,8(sp)
 36e:	0141                	addi	sp,sp,16
 370:	8082                	ret
  return 0;
 372:	4501                	li	a0,0
 374:	bfe5                	j	36c <strchr+0x1a>

0000000000000376 <gets>:

char*
gets(char *buf, int max)
{
 376:	711d                	addi	sp,sp,-96
 378:	ec86                	sd	ra,88(sp)
 37a:	e8a2                	sd	s0,80(sp)
 37c:	e4a6                	sd	s1,72(sp)
 37e:	e0ca                	sd	s2,64(sp)
 380:	fc4e                	sd	s3,56(sp)
 382:	f852                	sd	s4,48(sp)
 384:	f456                	sd	s5,40(sp)
 386:	f05a                	sd	s6,32(sp)
 388:	ec5e                	sd	s7,24(sp)
 38a:	1080                	addi	s0,sp,96
 38c:	8baa                	mv	s7,a0
 38e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 390:	892a                	mv	s2,a0
 392:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 394:	4aa9                	li	s5,10
 396:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 398:	89a6                	mv	s3,s1
 39a:	2485                	addiw	s1,s1,1
 39c:	0344d663          	bge	s1,s4,3c8 <gets+0x52>
    cc = read(0, &c, 1);
 3a0:	4605                	li	a2,1
 3a2:	faf40593          	addi	a1,s0,-81
 3a6:	4501                	li	a0,0
 3a8:	280000ef          	jal	628 <read>
    if(cc < 1)
 3ac:	00a05e63          	blez	a0,3c8 <gets+0x52>
    buf[i++] = c;
 3b0:	faf44783          	lbu	a5,-81(s0)
 3b4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3b8:	01578763          	beq	a5,s5,3c6 <gets+0x50>
 3bc:	0905                	addi	s2,s2,1
 3be:	fd679de3          	bne	a5,s6,398 <gets+0x22>
    buf[i++] = c;
 3c2:	89a6                	mv	s3,s1
 3c4:	a011                	j	3c8 <gets+0x52>
 3c6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3c8:	99de                	add	s3,s3,s7
 3ca:	00098023          	sb	zero,0(s3)
  return buf;
}
 3ce:	855e                	mv	a0,s7
 3d0:	60e6                	ld	ra,88(sp)
 3d2:	6446                	ld	s0,80(sp)
 3d4:	64a6                	ld	s1,72(sp)
 3d6:	6906                	ld	s2,64(sp)
 3d8:	79e2                	ld	s3,56(sp)
 3da:	7a42                	ld	s4,48(sp)
 3dc:	7aa2                	ld	s5,40(sp)
 3de:	7b02                	ld	s6,32(sp)
 3e0:	6be2                	ld	s7,24(sp)
 3e2:	6125                	addi	sp,sp,96
 3e4:	8082                	ret

00000000000003e6 <stat>:

int
stat(const char *n, struct stat *st)
{
 3e6:	1101                	addi	sp,sp,-32
 3e8:	ec06                	sd	ra,24(sp)
 3ea:	e822                	sd	s0,16(sp)
 3ec:	e04a                	sd	s2,0(sp)
 3ee:	1000                	addi	s0,sp,32
 3f0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3f2:	4581                	li	a1,0
 3f4:	25c000ef          	jal	650 <open>
  if(fd < 0)
 3f8:	02054263          	bltz	a0,41c <stat+0x36>
 3fc:	e426                	sd	s1,8(sp)
 3fe:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 400:	85ca                	mv	a1,s2
 402:	266000ef          	jal	668 <fstat>
 406:	892a                	mv	s2,a0
  close(fd);
 408:	8526                	mv	a0,s1
 40a:	22e000ef          	jal	638 <close>
  return r;
 40e:	64a2                	ld	s1,8(sp)
}
 410:	854a                	mv	a0,s2
 412:	60e2                	ld	ra,24(sp)
 414:	6442                	ld	s0,16(sp)
 416:	6902                	ld	s2,0(sp)
 418:	6105                	addi	sp,sp,32
 41a:	8082                	ret
    return -1;
 41c:	597d                	li	s2,-1
 41e:	bfcd                	j	410 <stat+0x2a>

0000000000000420 <atoi>:

int
atoi(const char *s)
{
 420:	1141                	addi	sp,sp,-16
 422:	e422                	sd	s0,8(sp)
 424:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 426:	00054683          	lbu	a3,0(a0)
 42a:	fd06879b          	addiw	a5,a3,-48
 42e:	0ff7f793          	zext.b	a5,a5
 432:	4625                	li	a2,9
 434:	02f66863          	bltu	a2,a5,464 <atoi+0x44>
 438:	872a                	mv	a4,a0
  n = 0;
 43a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 43c:	0705                	addi	a4,a4,1
 43e:	0025179b          	slliw	a5,a0,0x2
 442:	9fa9                	addw	a5,a5,a0
 444:	0017979b          	slliw	a5,a5,0x1
 448:	9fb5                	addw	a5,a5,a3
 44a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 44e:	00074683          	lbu	a3,0(a4)
 452:	fd06879b          	addiw	a5,a3,-48
 456:	0ff7f793          	zext.b	a5,a5
 45a:	fef671e3          	bgeu	a2,a5,43c <atoi+0x1c>
  return n;
}
 45e:	6422                	ld	s0,8(sp)
 460:	0141                	addi	sp,sp,16
 462:	8082                	ret
  n = 0;
 464:	4501                	li	a0,0
 466:	bfe5                	j	45e <atoi+0x3e>

0000000000000468 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 468:	1141                	addi	sp,sp,-16
 46a:	e422                	sd	s0,8(sp)
 46c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 46e:	02b57463          	bgeu	a0,a1,496 <memmove+0x2e>
    while(n-- > 0)
 472:	00c05f63          	blez	a2,490 <memmove+0x28>
 476:	1602                	slli	a2,a2,0x20
 478:	9201                	srli	a2,a2,0x20
 47a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 47e:	872a                	mv	a4,a0
      *dst++ = *src++;
 480:	0585                	addi	a1,a1,1
 482:	0705                	addi	a4,a4,1
 484:	fff5c683          	lbu	a3,-1(a1)
 488:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 48c:	fef71ae3          	bne	a4,a5,480 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 490:	6422                	ld	s0,8(sp)
 492:	0141                	addi	sp,sp,16
 494:	8082                	ret
    dst += n;
 496:	00c50733          	add	a4,a0,a2
    src += n;
 49a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 49c:	fec05ae3          	blez	a2,490 <memmove+0x28>
 4a0:	fff6079b          	addiw	a5,a2,-1
 4a4:	1782                	slli	a5,a5,0x20
 4a6:	9381                	srli	a5,a5,0x20
 4a8:	fff7c793          	not	a5,a5
 4ac:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4ae:	15fd                	addi	a1,a1,-1
 4b0:	177d                	addi	a4,a4,-1
 4b2:	0005c683          	lbu	a3,0(a1)
 4b6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4ba:	fee79ae3          	bne	a5,a4,4ae <memmove+0x46>
 4be:	bfc9                	j	490 <memmove+0x28>

00000000000004c0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4c0:	1141                	addi	sp,sp,-16
 4c2:	e422                	sd	s0,8(sp)
 4c4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4c6:	ca05                	beqz	a2,4f6 <memcmp+0x36>
 4c8:	fff6069b          	addiw	a3,a2,-1
 4cc:	1682                	slli	a3,a3,0x20
 4ce:	9281                	srli	a3,a3,0x20
 4d0:	0685                	addi	a3,a3,1
 4d2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4d4:	00054783          	lbu	a5,0(a0)
 4d8:	0005c703          	lbu	a4,0(a1)
 4dc:	00e79863          	bne	a5,a4,4ec <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4e0:	0505                	addi	a0,a0,1
    p2++;
 4e2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4e4:	fed518e3          	bne	a0,a3,4d4 <memcmp+0x14>
  }
  return 0;
 4e8:	4501                	li	a0,0
 4ea:	a019                	j	4f0 <memcmp+0x30>
      return *p1 - *p2;
 4ec:	40e7853b          	subw	a0,a5,a4
}
 4f0:	6422                	ld	s0,8(sp)
 4f2:	0141                	addi	sp,sp,16
 4f4:	8082                	ret
  return 0;
 4f6:	4501                	li	a0,0
 4f8:	bfe5                	j	4f0 <memcmp+0x30>

00000000000004fa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4fa:	1141                	addi	sp,sp,-16
 4fc:	e406                	sd	ra,8(sp)
 4fe:	e022                	sd	s0,0(sp)
 500:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 502:	f67ff0ef          	jal	468 <memmove>
}
 506:	60a2                	ld	ra,8(sp)
 508:	6402                	ld	s0,0(sp)
 50a:	0141                	addi	sp,sp,16
 50c:	8082                	ret

000000000000050e <simplesort>:

void
simplesort(void *base, uint nmemb, uint size, int (*compar)(const void *, const void *))
{
 50e:	7119                	addi	sp,sp,-128
 510:	fc86                	sd	ra,120(sp)
 512:	f8a2                	sd	s0,112(sp)
 514:	0100                	addi	s0,sp,128
 516:	f8b43423          	sd	a1,-120(s0)
  char *arr = (char *)base; // Treat array as char array for byte-level manipulation
  char *temp;               // Temporary storage for an element

  if (nmemb <= 1 || size == 0) {
 51a:	4785                	li	a5,1
 51c:	00b7fc63          	bgeu	a5,a1,534 <simplesort+0x26>
 520:	e8d2                	sd	s4,80(sp)
 522:	e4d6                	sd	s5,72(sp)
 524:	f466                	sd	s9,40(sp)
 526:	8aaa                	mv	s5,a0
 528:	8a32                	mv	s4,a2
 52a:	8cb6                	mv	s9,a3
 52c:	ea01                	bnez	a2,53c <simplesort+0x2e>
 52e:	6a46                	ld	s4,80(sp)
 530:	6aa6                	ld	s5,72(sp)
 532:	7ca2                	ld	s9,40(sp)
    // Place temp at its correct position
    memmove(arr + j * size, temp, size);
  }

  free(temp); // Free temporary space
 534:	70e6                	ld	ra,120(sp)
 536:	7446                	ld	s0,112(sp)
 538:	6109                	addi	sp,sp,128
 53a:	8082                	ret
 53c:	fc5e                	sd	s7,56(sp)
 53e:	f862                	sd	s8,48(sp)
 540:	f06a                	sd	s10,32(sp)
 542:	ec6e                	sd	s11,24(sp)
  temp = malloc(size); // Allocate temporary space for one element
 544:	8532                	mv	a0,a2
 546:	5de000ef          	jal	b24 <malloc>
 54a:	8baa                	mv	s7,a0
  if (temp == 0) {
 54c:	4d81                	li	s11,0
  for (uint i = 1; i < nmemb; i++) {
 54e:	4d05                	li	s10,1
    memmove(temp, arr + i * size, size);
 550:	000a0c1b          	sext.w	s8,s4
  if (temp == 0) {
 554:	c511                	beqz	a0,560 <simplesort+0x52>
 556:	f4a6                	sd	s1,104(sp)
 558:	f0ca                	sd	s2,96(sp)
 55a:	ecce                	sd	s3,88(sp)
 55c:	e0da                	sd	s6,64(sp)
 55e:	a82d                	j	598 <simplesort+0x8a>
    printf("simplesort: malloc failed, cannot sort\n");
 560:	00000517          	auipc	a0,0x0
 564:	77050513          	addi	a0,a0,1904 # cd0 <malloc+0x1ac>
 568:	508000ef          	jal	a70 <printf>
    return;
 56c:	6a46                	ld	s4,80(sp)
 56e:	6aa6                	ld	s5,72(sp)
 570:	7be2                	ld	s7,56(sp)
 572:	7c42                	ld	s8,48(sp)
 574:	7ca2                	ld	s9,40(sp)
 576:	7d02                	ld	s10,32(sp)
 578:	6de2                	ld	s11,24(sp)
 57a:	bf6d                	j	534 <simplesort+0x26>
    memmove(arr + j * size, temp, size);
 57c:	036a053b          	mulw	a0,s4,s6
 580:	1502                	slli	a0,a0,0x20
 582:	9101                	srli	a0,a0,0x20
 584:	8662                	mv	a2,s8
 586:	85de                	mv	a1,s7
 588:	9556                	add	a0,a0,s5
 58a:	edfff0ef          	jal	468 <memmove>
  for (uint i = 1; i < nmemb; i++) {
 58e:	2d05                	addiw	s10,s10,1
 590:	f8843783          	ld	a5,-120(s0)
 594:	05a78b63          	beq	a5,s10,5ea <simplesort+0xdc>
    memmove(temp, arr + i * size, size);
 598:	000d899b          	sext.w	s3,s11
 59c:	01ba05bb          	addw	a1,s4,s11
 5a0:	00058d9b          	sext.w	s11,a1
 5a4:	1582                	slli	a1,a1,0x20
 5a6:	9181                	srli	a1,a1,0x20
 5a8:	8662                	mv	a2,s8
 5aa:	95d6                	add	a1,a1,s5
 5ac:	855e                	mv	a0,s7
 5ae:	ebbff0ef          	jal	468 <memmove>
    uint j = i;
 5b2:	896a                	mv	s2,s10
 5b4:	00090b1b          	sext.w	s6,s2
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 5b8:	397d                	addiw	s2,s2,-1
 5ba:	02099493          	slli	s1,s3,0x20
 5be:	9081                	srli	s1,s1,0x20
 5c0:	94d6                	add	s1,s1,s5
 5c2:	85de                	mv	a1,s7
 5c4:	8526                	mv	a0,s1
 5c6:	9c82                	jalr	s9
 5c8:	faa05ae3          	blez	a0,57c <simplesort+0x6e>
      memmove(arr + j * size, arr + (j - 1) * size, size); // Shift element
 5cc:	0149853b          	addw	a0,s3,s4
 5d0:	1502                	slli	a0,a0,0x20
 5d2:	9101                	srli	a0,a0,0x20
 5d4:	8662                	mv	a2,s8
 5d6:	85a6                	mv	a1,s1
 5d8:	9556                	add	a0,a0,s5
 5da:	e8fff0ef          	jal	468 <memmove>
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 5de:	414989bb          	subw	s3,s3,s4
 5e2:	fc0919e3          	bnez	s2,5b4 <simplesort+0xa6>
 5e6:	8b4a                	mv	s6,s2
 5e8:	bf51                	j	57c <simplesort+0x6e>
  free(temp); // Free temporary space
 5ea:	855e                	mv	a0,s7
 5ec:	4b6000ef          	jal	aa2 <free>
 5f0:	74a6                	ld	s1,104(sp)
 5f2:	7906                	ld	s2,96(sp)
 5f4:	69e6                	ld	s3,88(sp)
 5f6:	6a46                	ld	s4,80(sp)
 5f8:	6aa6                	ld	s5,72(sp)
 5fa:	6b06                	ld	s6,64(sp)
 5fc:	7be2                	ld	s7,56(sp)
 5fe:	7c42                	ld	s8,48(sp)
 600:	7ca2                	ld	s9,40(sp)
 602:	7d02                	ld	s10,32(sp)
 604:	6de2                	ld	s11,24(sp)
 606:	b73d                	j	534 <simplesort+0x26>

0000000000000608 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 608:	4885                	li	a7,1
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <exit>:
.global exit
exit:
 li a7, SYS_exit
 610:	4889                	li	a7,2
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <wait>:
.global wait
wait:
 li a7, SYS_wait
 618:	488d                	li	a7,3
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 620:	4891                	li	a7,4
 ecall
 622:	00000073          	ecall
 ret
 626:	8082                	ret

0000000000000628 <read>:
.global read
read:
 li a7, SYS_read
 628:	4895                	li	a7,5
 ecall
 62a:	00000073          	ecall
 ret
 62e:	8082                	ret

0000000000000630 <write>:
.global write
write:
 li a7, SYS_write
 630:	48c1                	li	a7,16
 ecall
 632:	00000073          	ecall
 ret
 636:	8082                	ret

0000000000000638 <close>:
.global close
close:
 li a7, SYS_close
 638:	48d5                	li	a7,21
 ecall
 63a:	00000073          	ecall
 ret
 63e:	8082                	ret

0000000000000640 <kill>:
.global kill
kill:
 li a7, SYS_kill
 640:	4899                	li	a7,6
 ecall
 642:	00000073          	ecall
 ret
 646:	8082                	ret

0000000000000648 <exec>:
.global exec
exec:
 li a7, SYS_exec
 648:	489d                	li	a7,7
 ecall
 64a:	00000073          	ecall
 ret
 64e:	8082                	ret

0000000000000650 <open>:
.global open
open:
 li a7, SYS_open
 650:	48bd                	li	a7,15
 ecall
 652:	00000073          	ecall
 ret
 656:	8082                	ret

0000000000000658 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 658:	48c5                	li	a7,17
 ecall
 65a:	00000073          	ecall
 ret
 65e:	8082                	ret

0000000000000660 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 660:	48c9                	li	a7,18
 ecall
 662:	00000073          	ecall
 ret
 666:	8082                	ret

0000000000000668 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 668:	48a1                	li	a7,8
 ecall
 66a:	00000073          	ecall
 ret
 66e:	8082                	ret

0000000000000670 <link>:
.global link
link:
 li a7, SYS_link
 670:	48cd                	li	a7,19
 ecall
 672:	00000073          	ecall
 ret
 676:	8082                	ret

0000000000000678 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 678:	48d1                	li	a7,20
 ecall
 67a:	00000073          	ecall
 ret
 67e:	8082                	ret

0000000000000680 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 680:	48a5                	li	a7,9
 ecall
 682:	00000073          	ecall
 ret
 686:	8082                	ret

0000000000000688 <dup>:
.global dup
dup:
 li a7, SYS_dup
 688:	48a9                	li	a7,10
 ecall
 68a:	00000073          	ecall
 ret
 68e:	8082                	ret

0000000000000690 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 690:	48ad                	li	a7,11
 ecall
 692:	00000073          	ecall
 ret
 696:	8082                	ret

0000000000000698 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 698:	48b1                	li	a7,12
 ecall
 69a:	00000073          	ecall
 ret
 69e:	8082                	ret

00000000000006a0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6a0:	48b5                	li	a7,13
 ecall
 6a2:	00000073          	ecall
 ret
 6a6:	8082                	ret

00000000000006a8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6a8:	48b9                	li	a7,14
 ecall
 6aa:	00000073          	ecall
 ret
 6ae:	8082                	ret

00000000000006b0 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 6b0:	48dd                	li	a7,23
 ecall
 6b2:	00000073          	ecall
 ret
 6b6:	8082                	ret

00000000000006b8 <statistics>:
.global statistics
statistics:
 li a7, SYS_statistics
 6b8:	48e1                	li	a7,24
 ecall
 6ba:	00000073          	ecall
 ret
 6be:	8082                	ret

00000000000006c0 <reset_stats>:
.global reset_stats
reset_stats:
 li a7, SYS_reset_stats
 6c0:	48e5                	li	a7,25
 ecall
 6c2:	00000073          	ecall
 ret
 6c6:	8082                	ret

00000000000006c8 <resetlockstats>:
.global resetlockstats
resetlockstats:
 li a7, SYS_resetlockstats
 6c8:	48e9                	li	a7,26
 ecall
 6ca:	00000073          	ecall
 ret
 6ce:	8082                	ret

00000000000006d0 <getlockstats>:
.global getlockstats
getlockstats:
 li a7, SYS_getlockstats
 6d0:	48ed                	li	a7,27
 ecall
 6d2:	00000073          	ecall
 ret
 6d6:	8082                	ret

00000000000006d8 <trace>:
.global trace
trace:
 li a7, SYS_trace
 6d8:	48d9                	li	a7,22
 ecall
 6da:	00000073          	ecall
 ret
 6de:	8082                	ret

00000000000006e0 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 6e0:	48f1                	li	a7,28
 ecall
 6e2:	00000073          	ecall
 ret
 6e6:	8082                	ret

00000000000006e8 <ugetpid>:
.global ugetpid
ugetpid:
 li a7, SYS_ugetpid
 6e8:	48f5                	li	a7,29
 ecall
 6ea:	00000073          	ecall
 ret
 6ee:	8082                	ret

00000000000006f0 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 6f0:	48f9                	li	a7,30
 ecall
 6f2:	00000073          	ecall
 ret
 6f6:	8082                	ret

00000000000006f8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6f8:	1101                	addi	sp,sp,-32
 6fa:	ec06                	sd	ra,24(sp)
 6fc:	e822                	sd	s0,16(sp)
 6fe:	1000                	addi	s0,sp,32
 700:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 704:	4605                	li	a2,1
 706:	fef40593          	addi	a1,s0,-17
 70a:	f27ff0ef          	jal	630 <write>
}
 70e:	60e2                	ld	ra,24(sp)
 710:	6442                	ld	s0,16(sp)
 712:	6105                	addi	sp,sp,32
 714:	8082                	ret

0000000000000716 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 716:	7139                	addi	sp,sp,-64
 718:	fc06                	sd	ra,56(sp)
 71a:	f822                	sd	s0,48(sp)
 71c:	f426                	sd	s1,40(sp)
 71e:	0080                	addi	s0,sp,64
 720:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 722:	c299                	beqz	a3,728 <printint+0x12>
 724:	0805c963          	bltz	a1,7b6 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 728:	2581                	sext.w	a1,a1
  neg = 0;
 72a:	4881                	li	a7,0
 72c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 730:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 732:	2601                	sext.w	a2,a2
 734:	00000517          	auipc	a0,0x0
 738:	5cc50513          	addi	a0,a0,1484 # d00 <digits>
 73c:	883a                	mv	a6,a4
 73e:	2705                	addiw	a4,a4,1
 740:	02c5f7bb          	remuw	a5,a1,a2
 744:	1782                	slli	a5,a5,0x20
 746:	9381                	srli	a5,a5,0x20
 748:	97aa                	add	a5,a5,a0
 74a:	0007c783          	lbu	a5,0(a5)
 74e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 752:	0005879b          	sext.w	a5,a1
 756:	02c5d5bb          	divuw	a1,a1,a2
 75a:	0685                	addi	a3,a3,1
 75c:	fec7f0e3          	bgeu	a5,a2,73c <printint+0x26>
  if(neg)
 760:	00088c63          	beqz	a7,778 <printint+0x62>
    buf[i++] = '-';
 764:	fd070793          	addi	a5,a4,-48
 768:	00878733          	add	a4,a5,s0
 76c:	02d00793          	li	a5,45
 770:	fef70823          	sb	a5,-16(a4)
 774:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 778:	02e05a63          	blez	a4,7ac <printint+0x96>
 77c:	f04a                	sd	s2,32(sp)
 77e:	ec4e                	sd	s3,24(sp)
 780:	fc040793          	addi	a5,s0,-64
 784:	00e78933          	add	s2,a5,a4
 788:	fff78993          	addi	s3,a5,-1
 78c:	99ba                	add	s3,s3,a4
 78e:	377d                	addiw	a4,a4,-1
 790:	1702                	slli	a4,a4,0x20
 792:	9301                	srli	a4,a4,0x20
 794:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 798:	fff94583          	lbu	a1,-1(s2)
 79c:	8526                	mv	a0,s1
 79e:	f5bff0ef          	jal	6f8 <putc>
  while(--i >= 0)
 7a2:	197d                	addi	s2,s2,-1
 7a4:	ff391ae3          	bne	s2,s3,798 <printint+0x82>
 7a8:	7902                	ld	s2,32(sp)
 7aa:	69e2                	ld	s3,24(sp)
}
 7ac:	70e2                	ld	ra,56(sp)
 7ae:	7442                	ld	s0,48(sp)
 7b0:	74a2                	ld	s1,40(sp)
 7b2:	6121                	addi	sp,sp,64
 7b4:	8082                	ret
    x = -xx;
 7b6:	40b005bb          	negw	a1,a1
    neg = 1;
 7ba:	4885                	li	a7,1
    x = -xx;
 7bc:	bf85                	j	72c <printint+0x16>

00000000000007be <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7be:	711d                	addi	sp,sp,-96
 7c0:	ec86                	sd	ra,88(sp)
 7c2:	e8a2                	sd	s0,80(sp)
 7c4:	e0ca                	sd	s2,64(sp)
 7c6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7c8:	0005c903          	lbu	s2,0(a1)
 7cc:	26090863          	beqz	s2,a3c <vprintf+0x27e>
 7d0:	e4a6                	sd	s1,72(sp)
 7d2:	fc4e                	sd	s3,56(sp)
 7d4:	f852                	sd	s4,48(sp)
 7d6:	f456                	sd	s5,40(sp)
 7d8:	f05a                	sd	s6,32(sp)
 7da:	ec5e                	sd	s7,24(sp)
 7dc:	e862                	sd	s8,16(sp)
 7de:	e466                	sd	s9,8(sp)
 7e0:	8b2a                	mv	s6,a0
 7e2:	8a2e                	mv	s4,a1
 7e4:	8bb2                	mv	s7,a2
  state = 0;
 7e6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 7e8:	4481                	li	s1,0
 7ea:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 7ec:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 7f0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 7f4:	06c00c93          	li	s9,108
 7f8:	a005                	j	818 <vprintf+0x5a>
        putc(fd, c0);
 7fa:	85ca                	mv	a1,s2
 7fc:	855a                	mv	a0,s6
 7fe:	efbff0ef          	jal	6f8 <putc>
 802:	a019                	j	808 <vprintf+0x4a>
    } else if(state == '%'){
 804:	03598263          	beq	s3,s5,828 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 808:	2485                	addiw	s1,s1,1
 80a:	8726                	mv	a4,s1
 80c:	009a07b3          	add	a5,s4,s1
 810:	0007c903          	lbu	s2,0(a5)
 814:	20090c63          	beqz	s2,a2c <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 818:	0009079b          	sext.w	a5,s2
    if(state == 0){
 81c:	fe0994e3          	bnez	s3,804 <vprintf+0x46>
      if(c0 == '%'){
 820:	fd579de3          	bne	a5,s5,7fa <vprintf+0x3c>
        state = '%';
 824:	89be                	mv	s3,a5
 826:	b7cd                	j	808 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 828:	00ea06b3          	add	a3,s4,a4
 82c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 830:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 832:	c681                	beqz	a3,83a <vprintf+0x7c>
 834:	9752                	add	a4,a4,s4
 836:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 83a:	03878f63          	beq	a5,s8,878 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 83e:	05978963          	beq	a5,s9,890 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 842:	07500713          	li	a4,117
 846:	0ee78363          	beq	a5,a4,92c <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 84a:	07800713          	li	a4,120
 84e:	12e78563          	beq	a5,a4,978 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 852:	07000713          	li	a4,112
 856:	14e78a63          	beq	a5,a4,9aa <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 85a:	07300713          	li	a4,115
 85e:	18e78a63          	beq	a5,a4,9f2 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 862:	02500713          	li	a4,37
 866:	04e79563          	bne	a5,a4,8b0 <vprintf+0xf2>
        putc(fd, '%');
 86a:	02500593          	li	a1,37
 86e:	855a                	mv	a0,s6
 870:	e89ff0ef          	jal	6f8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 874:	4981                	li	s3,0
 876:	bf49                	j	808 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 878:	008b8913          	addi	s2,s7,8
 87c:	4685                	li	a3,1
 87e:	4629                	li	a2,10
 880:	000ba583          	lw	a1,0(s7)
 884:	855a                	mv	a0,s6
 886:	e91ff0ef          	jal	716 <printint>
 88a:	8bca                	mv	s7,s2
      state = 0;
 88c:	4981                	li	s3,0
 88e:	bfad                	j	808 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 890:	06400793          	li	a5,100
 894:	02f68963          	beq	a3,a5,8c6 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 898:	06c00793          	li	a5,108
 89c:	04f68263          	beq	a3,a5,8e0 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 8a0:	07500793          	li	a5,117
 8a4:	0af68063          	beq	a3,a5,944 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 8a8:	07800793          	li	a5,120
 8ac:	0ef68263          	beq	a3,a5,990 <vprintf+0x1d2>
        putc(fd, '%');
 8b0:	02500593          	li	a1,37
 8b4:	855a                	mv	a0,s6
 8b6:	e43ff0ef          	jal	6f8 <putc>
        putc(fd, c0);
 8ba:	85ca                	mv	a1,s2
 8bc:	855a                	mv	a0,s6
 8be:	e3bff0ef          	jal	6f8 <putc>
      state = 0;
 8c2:	4981                	li	s3,0
 8c4:	b791                	j	808 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8c6:	008b8913          	addi	s2,s7,8
 8ca:	4685                	li	a3,1
 8cc:	4629                	li	a2,10
 8ce:	000ba583          	lw	a1,0(s7)
 8d2:	855a                	mv	a0,s6
 8d4:	e43ff0ef          	jal	716 <printint>
        i += 1;
 8d8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 8da:	8bca                	mv	s7,s2
      state = 0;
 8dc:	4981                	li	s3,0
        i += 1;
 8de:	b72d                	j	808 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8e0:	06400793          	li	a5,100
 8e4:	02f60763          	beq	a2,a5,912 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8e8:	07500793          	li	a5,117
 8ec:	06f60963          	beq	a2,a5,95e <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 8f0:	07800793          	li	a5,120
 8f4:	faf61ee3          	bne	a2,a5,8b0 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8f8:	008b8913          	addi	s2,s7,8
 8fc:	4681                	li	a3,0
 8fe:	4641                	li	a2,16
 900:	000ba583          	lw	a1,0(s7)
 904:	855a                	mv	a0,s6
 906:	e11ff0ef          	jal	716 <printint>
        i += 2;
 90a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 90c:	8bca                	mv	s7,s2
      state = 0;
 90e:	4981                	li	s3,0
        i += 2;
 910:	bde5                	j	808 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 912:	008b8913          	addi	s2,s7,8
 916:	4685                	li	a3,1
 918:	4629                	li	a2,10
 91a:	000ba583          	lw	a1,0(s7)
 91e:	855a                	mv	a0,s6
 920:	df7ff0ef          	jal	716 <printint>
        i += 2;
 924:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 926:	8bca                	mv	s7,s2
      state = 0;
 928:	4981                	li	s3,0
        i += 2;
 92a:	bdf9                	j	808 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 92c:	008b8913          	addi	s2,s7,8
 930:	4681                	li	a3,0
 932:	4629                	li	a2,10
 934:	000ba583          	lw	a1,0(s7)
 938:	855a                	mv	a0,s6
 93a:	dddff0ef          	jal	716 <printint>
 93e:	8bca                	mv	s7,s2
      state = 0;
 940:	4981                	li	s3,0
 942:	b5d9                	j	808 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 944:	008b8913          	addi	s2,s7,8
 948:	4681                	li	a3,0
 94a:	4629                	li	a2,10
 94c:	000ba583          	lw	a1,0(s7)
 950:	855a                	mv	a0,s6
 952:	dc5ff0ef          	jal	716 <printint>
        i += 1;
 956:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 958:	8bca                	mv	s7,s2
      state = 0;
 95a:	4981                	li	s3,0
        i += 1;
 95c:	b575                	j	808 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 95e:	008b8913          	addi	s2,s7,8
 962:	4681                	li	a3,0
 964:	4629                	li	a2,10
 966:	000ba583          	lw	a1,0(s7)
 96a:	855a                	mv	a0,s6
 96c:	dabff0ef          	jal	716 <printint>
        i += 2;
 970:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 972:	8bca                	mv	s7,s2
      state = 0;
 974:	4981                	li	s3,0
        i += 2;
 976:	bd49                	j	808 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 978:	008b8913          	addi	s2,s7,8
 97c:	4681                	li	a3,0
 97e:	4641                	li	a2,16
 980:	000ba583          	lw	a1,0(s7)
 984:	855a                	mv	a0,s6
 986:	d91ff0ef          	jal	716 <printint>
 98a:	8bca                	mv	s7,s2
      state = 0;
 98c:	4981                	li	s3,0
 98e:	bdad                	j	808 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 990:	008b8913          	addi	s2,s7,8
 994:	4681                	li	a3,0
 996:	4641                	li	a2,16
 998:	000ba583          	lw	a1,0(s7)
 99c:	855a                	mv	a0,s6
 99e:	d79ff0ef          	jal	716 <printint>
        i += 1;
 9a2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 9a4:	8bca                	mv	s7,s2
      state = 0;
 9a6:	4981                	li	s3,0
        i += 1;
 9a8:	b585                	j	808 <vprintf+0x4a>
 9aa:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 9ac:	008b8d13          	addi	s10,s7,8
 9b0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 9b4:	03000593          	li	a1,48
 9b8:	855a                	mv	a0,s6
 9ba:	d3fff0ef          	jal	6f8 <putc>
  putc(fd, 'x');
 9be:	07800593          	li	a1,120
 9c2:	855a                	mv	a0,s6
 9c4:	d35ff0ef          	jal	6f8 <putc>
 9c8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9ca:	00000b97          	auipc	s7,0x0
 9ce:	336b8b93          	addi	s7,s7,822 # d00 <digits>
 9d2:	03c9d793          	srli	a5,s3,0x3c
 9d6:	97de                	add	a5,a5,s7
 9d8:	0007c583          	lbu	a1,0(a5)
 9dc:	855a                	mv	a0,s6
 9de:	d1bff0ef          	jal	6f8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9e2:	0992                	slli	s3,s3,0x4
 9e4:	397d                	addiw	s2,s2,-1
 9e6:	fe0916e3          	bnez	s2,9d2 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 9ea:	8bea                	mv	s7,s10
      state = 0;
 9ec:	4981                	li	s3,0
 9ee:	6d02                	ld	s10,0(sp)
 9f0:	bd21                	j	808 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 9f2:	008b8993          	addi	s3,s7,8
 9f6:	000bb903          	ld	s2,0(s7)
 9fa:	00090f63          	beqz	s2,a18 <vprintf+0x25a>
        for(; *s; s++)
 9fe:	00094583          	lbu	a1,0(s2)
 a02:	c195                	beqz	a1,a26 <vprintf+0x268>
          putc(fd, *s);
 a04:	855a                	mv	a0,s6
 a06:	cf3ff0ef          	jal	6f8 <putc>
        for(; *s; s++)
 a0a:	0905                	addi	s2,s2,1
 a0c:	00094583          	lbu	a1,0(s2)
 a10:	f9f5                	bnez	a1,a04 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 a12:	8bce                	mv	s7,s3
      state = 0;
 a14:	4981                	li	s3,0
 a16:	bbcd                	j	808 <vprintf+0x4a>
          s = "(null)";
 a18:	00000917          	auipc	s2,0x0
 a1c:	2e090913          	addi	s2,s2,736 # cf8 <malloc+0x1d4>
        for(; *s; s++)
 a20:	02800593          	li	a1,40
 a24:	b7c5                	j	a04 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 a26:	8bce                	mv	s7,s3
      state = 0;
 a28:	4981                	li	s3,0
 a2a:	bbf9                	j	808 <vprintf+0x4a>
 a2c:	64a6                	ld	s1,72(sp)
 a2e:	79e2                	ld	s3,56(sp)
 a30:	7a42                	ld	s4,48(sp)
 a32:	7aa2                	ld	s5,40(sp)
 a34:	7b02                	ld	s6,32(sp)
 a36:	6be2                	ld	s7,24(sp)
 a38:	6c42                	ld	s8,16(sp)
 a3a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 a3c:	60e6                	ld	ra,88(sp)
 a3e:	6446                	ld	s0,80(sp)
 a40:	6906                	ld	s2,64(sp)
 a42:	6125                	addi	sp,sp,96
 a44:	8082                	ret

0000000000000a46 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a46:	715d                	addi	sp,sp,-80
 a48:	ec06                	sd	ra,24(sp)
 a4a:	e822                	sd	s0,16(sp)
 a4c:	1000                	addi	s0,sp,32
 a4e:	e010                	sd	a2,0(s0)
 a50:	e414                	sd	a3,8(s0)
 a52:	e818                	sd	a4,16(s0)
 a54:	ec1c                	sd	a5,24(s0)
 a56:	03043023          	sd	a6,32(s0)
 a5a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a5e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a62:	8622                	mv	a2,s0
 a64:	d5bff0ef          	jal	7be <vprintf>
}
 a68:	60e2                	ld	ra,24(sp)
 a6a:	6442                	ld	s0,16(sp)
 a6c:	6161                	addi	sp,sp,80
 a6e:	8082                	ret

0000000000000a70 <printf>:

void
printf(const char *fmt, ...)
{
 a70:	711d                	addi	sp,sp,-96
 a72:	ec06                	sd	ra,24(sp)
 a74:	e822                	sd	s0,16(sp)
 a76:	1000                	addi	s0,sp,32
 a78:	e40c                	sd	a1,8(s0)
 a7a:	e810                	sd	a2,16(s0)
 a7c:	ec14                	sd	a3,24(s0)
 a7e:	f018                	sd	a4,32(s0)
 a80:	f41c                	sd	a5,40(s0)
 a82:	03043823          	sd	a6,48(s0)
 a86:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a8a:	00840613          	addi	a2,s0,8
 a8e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a92:	85aa                	mv	a1,a0
 a94:	4505                	li	a0,1
 a96:	d29ff0ef          	jal	7be <vprintf>
}
 a9a:	60e2                	ld	ra,24(sp)
 a9c:	6442                	ld	s0,16(sp)
 a9e:	6125                	addi	sp,sp,96
 aa0:	8082                	ret

0000000000000aa2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 aa2:	1141                	addi	sp,sp,-16
 aa4:	e422                	sd	s0,8(sp)
 aa6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 aa8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aac:	00001797          	auipc	a5,0x1
 ab0:	5547b783          	ld	a5,1364(a5) # 2000 <freep>
 ab4:	a02d                	j	ade <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 ab6:	4618                	lw	a4,8(a2)
 ab8:	9f2d                	addw	a4,a4,a1
 aba:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 abe:	6398                	ld	a4,0(a5)
 ac0:	6310                	ld	a2,0(a4)
 ac2:	a83d                	j	b00 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ac4:	ff852703          	lw	a4,-8(a0)
 ac8:	9f31                	addw	a4,a4,a2
 aca:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 acc:	ff053683          	ld	a3,-16(a0)
 ad0:	a091                	j	b14 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ad2:	6398                	ld	a4,0(a5)
 ad4:	00e7e463          	bltu	a5,a4,adc <free+0x3a>
 ad8:	00e6ea63          	bltu	a3,a4,aec <free+0x4a>
{
 adc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ade:	fed7fae3          	bgeu	a5,a3,ad2 <free+0x30>
 ae2:	6398                	ld	a4,0(a5)
 ae4:	00e6e463          	bltu	a3,a4,aec <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ae8:	fee7eae3          	bltu	a5,a4,adc <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 aec:	ff852583          	lw	a1,-8(a0)
 af0:	6390                	ld	a2,0(a5)
 af2:	02059813          	slli	a6,a1,0x20
 af6:	01c85713          	srli	a4,a6,0x1c
 afa:	9736                	add	a4,a4,a3
 afc:	fae60de3          	beq	a2,a4,ab6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 b00:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b04:	4790                	lw	a2,8(a5)
 b06:	02061593          	slli	a1,a2,0x20
 b0a:	01c5d713          	srli	a4,a1,0x1c
 b0e:	973e                	add	a4,a4,a5
 b10:	fae68ae3          	beq	a3,a4,ac4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 b14:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b16:	00001717          	auipc	a4,0x1
 b1a:	4ef73523          	sd	a5,1258(a4) # 2000 <freep>
}
 b1e:	6422                	ld	s0,8(sp)
 b20:	0141                	addi	sp,sp,16
 b22:	8082                	ret

0000000000000b24 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b24:	7139                	addi	sp,sp,-64
 b26:	fc06                	sd	ra,56(sp)
 b28:	f822                	sd	s0,48(sp)
 b2a:	f426                	sd	s1,40(sp)
 b2c:	ec4e                	sd	s3,24(sp)
 b2e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b30:	02051493          	slli	s1,a0,0x20
 b34:	9081                	srli	s1,s1,0x20
 b36:	04bd                	addi	s1,s1,15
 b38:	8091                	srli	s1,s1,0x4
 b3a:	0014899b          	addiw	s3,s1,1
 b3e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b40:	00001517          	auipc	a0,0x1
 b44:	4c053503          	ld	a0,1216(a0) # 2000 <freep>
 b48:	c915                	beqz	a0,b7c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b4a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b4c:	4798                	lw	a4,8(a5)
 b4e:	08977a63          	bgeu	a4,s1,be2 <malloc+0xbe>
 b52:	f04a                	sd	s2,32(sp)
 b54:	e852                	sd	s4,16(sp)
 b56:	e456                	sd	s5,8(sp)
 b58:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 b5a:	8a4e                	mv	s4,s3
 b5c:	0009871b          	sext.w	a4,s3
 b60:	6685                	lui	a3,0x1
 b62:	00d77363          	bgeu	a4,a3,b68 <malloc+0x44>
 b66:	6a05                	lui	s4,0x1
 b68:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b6c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b70:	00001917          	auipc	s2,0x1
 b74:	49090913          	addi	s2,s2,1168 # 2000 <freep>
  if(p == (char*)-1)
 b78:	5afd                	li	s5,-1
 b7a:	a081                	j	bba <malloc+0x96>
 b7c:	f04a                	sd	s2,32(sp)
 b7e:	e852                	sd	s4,16(sp)
 b80:	e456                	sd	s5,8(sp)
 b82:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b84:	00001797          	auipc	a5,0x1
 b88:	49c78793          	addi	a5,a5,1180 # 2020 <base>
 b8c:	00001717          	auipc	a4,0x1
 b90:	46f73a23          	sd	a5,1140(a4) # 2000 <freep>
 b94:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b96:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b9a:	b7c1                	j	b5a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 b9c:	6398                	ld	a4,0(a5)
 b9e:	e118                	sd	a4,0(a0)
 ba0:	a8a9                	j	bfa <malloc+0xd6>
  hp->s.size = nu;
 ba2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 ba6:	0541                	addi	a0,a0,16
 ba8:	efbff0ef          	jal	aa2 <free>
  return freep;
 bac:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bb0:	c12d                	beqz	a0,c12 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bb2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bb4:	4798                	lw	a4,8(a5)
 bb6:	02977263          	bgeu	a4,s1,bda <malloc+0xb6>
    if(p == freep)
 bba:	00093703          	ld	a4,0(s2)
 bbe:	853e                	mv	a0,a5
 bc0:	fef719e3          	bne	a4,a5,bb2 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 bc4:	8552                	mv	a0,s4
 bc6:	ad3ff0ef          	jal	698 <sbrk>
  if(p == (char*)-1)
 bca:	fd551ce3          	bne	a0,s5,ba2 <malloc+0x7e>
        return 0;
 bce:	4501                	li	a0,0
 bd0:	7902                	ld	s2,32(sp)
 bd2:	6a42                	ld	s4,16(sp)
 bd4:	6aa2                	ld	s5,8(sp)
 bd6:	6b02                	ld	s6,0(sp)
 bd8:	a03d                	j	c06 <malloc+0xe2>
 bda:	7902                	ld	s2,32(sp)
 bdc:	6a42                	ld	s4,16(sp)
 bde:	6aa2                	ld	s5,8(sp)
 be0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 be2:	fae48de3          	beq	s1,a4,b9c <malloc+0x78>
        p->s.size -= nunits;
 be6:	4137073b          	subw	a4,a4,s3
 bea:	c798                	sw	a4,8(a5)
        p += p->s.size;
 bec:	02071693          	slli	a3,a4,0x20
 bf0:	01c6d713          	srli	a4,a3,0x1c
 bf4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 bf6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bfa:	00001717          	auipc	a4,0x1
 bfe:	40a73323          	sd	a0,1030(a4) # 2000 <freep>
      return (void*)(p + 1);
 c02:	01078513          	addi	a0,a5,16
  }
}
 c06:	70e2                	ld	ra,56(sp)
 c08:	7442                	ld	s0,48(sp)
 c0a:	74a2                	ld	s1,40(sp)
 c0c:	69e2                	ld	s3,24(sp)
 c0e:	6121                	addi	sp,sp,64
 c10:	8082                	ret
 c12:	7902                	ld	s2,32(sp)
 c14:	6a42                	ld	s4,16(sp)
 c16:	6aa2                	ld	s5,8(sp)
 c18:	6b02                	ld	s6,0(sp)
 c1a:	b7f5                	j	c06 <malloc+0xe2>
