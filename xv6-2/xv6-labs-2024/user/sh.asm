
user/_sh：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	32e58593          	addi	a1,a1,814 # 1340 <malloc+0x100>
      1a:	4509                	li	a0,2
      1c:	531000ef          	jal	d4c <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	227000ef          	jal	a4c <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	265000ef          	jal	a92 <gets>
  if(buf[0] == 0) // EOF
      32:	0004c503          	lbu	a0,0(s1)
      36:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      3a:	40a00533          	neg	a0,a0
      3e:	60e2                	ld	ra,24(sp)
      40:	6442                	ld	s0,16(sp)
      42:	64a2                	ld	s1,8(sp)
      44:	6902                	ld	s2,0(sp)
      46:	6105                	addi	sp,sp,32
      48:	8082                	ret

000000000000004a <panic>:
  exit(0);
}

void
panic(char *s)
{
      4a:	1141                	addi	sp,sp,-16
      4c:	e406                	sd	ra,8(sp)
      4e:	e022                	sd	s0,0(sp)
      50:	0800                	addi	s0,sp,16
      52:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      54:	00001597          	auipc	a1,0x1
      58:	2fc58593          	addi	a1,a1,764 # 1350 <malloc+0x110>
      5c:	4509                	li	a0,2
      5e:	104010ef          	jal	1162 <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	4c9000ef          	jal	d2c <exit>

0000000000000068 <fork1>:
}

int
fork1(void)
{
      68:	1141                	addi	sp,sp,-16
      6a:	e406                	sd	ra,8(sp)
      6c:	e022                	sd	s0,0(sp)
      6e:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      70:	4b5000ef          	jal	d24 <fork>
  if(pid == -1)
      74:	57fd                	li	a5,-1
      76:	00f50663          	beq	a0,a5,82 <fork1+0x1a>
    panic("fork");
  return pid;
}
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
    panic("fork");
      82:	00001517          	auipc	a0,0x1
      86:	2d650513          	addi	a0,a0,726 # 1358 <malloc+0x118>
      8a:	fc1ff0ef          	jal	4a <panic>

000000000000008e <runcmd>:
{
      8e:	7179                	addi	sp,sp,-48
      90:	f406                	sd	ra,40(sp)
      92:	f022                	sd	s0,32(sp)
      94:	1800                	addi	s0,sp,48
  if(cmd == 0)
      96:	c115                	beqz	a0,ba <runcmd+0x2c>
      98:	ec26                	sd	s1,24(sp)
      9a:	84aa                	mv	s1,a0
  switch(cmd->type){
      9c:	4118                	lw	a4,0(a0)
      9e:	4795                	li	a5,5
      a0:	02e7e163          	bltu	a5,a4,c2 <runcmd+0x34>
      a4:	00056783          	lwu	a5,0(a0)
      a8:	078a                	slli	a5,a5,0x2
      aa:	00001717          	auipc	a4,0x1
      ae:	3d670713          	addi	a4,a4,982 # 1480 <malloc+0x240>
      b2:	97ba                	add	a5,a5,a4
      b4:	439c                	lw	a5,0(a5)
      b6:	97ba                	add	a5,a5,a4
      b8:	8782                	jr	a5
      ba:	ec26                	sd	s1,24(sp)
    exit(1);
      bc:	4505                	li	a0,1
      be:	46f000ef          	jal	d2c <exit>
    panic("runcmd");
      c2:	00001517          	auipc	a0,0x1
      c6:	29e50513          	addi	a0,a0,670 # 1360 <malloc+0x120>
      ca:	f81ff0ef          	jal	4a <panic>
    if(ecmd->argv[0] == 0)
      ce:	6508                	ld	a0,8(a0)
      d0:	c105                	beqz	a0,f0 <runcmd+0x62>
    exec(ecmd->argv[0], ecmd->argv);
      d2:	00848593          	addi	a1,s1,8
      d6:	48f000ef          	jal	d64 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      da:	6490                	ld	a2,8(s1)
      dc:	00001597          	auipc	a1,0x1
      e0:	28c58593          	addi	a1,a1,652 # 1368 <malloc+0x128>
      e4:	4509                	li	a0,2
      e6:	07c010ef          	jal	1162 <fprintf>
  exit(0);
      ea:	4501                	li	a0,0
      ec:	441000ef          	jal	d2c <exit>
      exit(1);
      f0:	4505                	li	a0,1
      f2:	43b000ef          	jal	d2c <exit>
    close(rcmd->fd);
      f6:	5148                	lw	a0,36(a0)
      f8:	45d000ef          	jal	d54 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      fc:	508c                	lw	a1,32(s1)
      fe:	6888                	ld	a0,16(s1)
     100:	46d000ef          	jal	d6c <open>
     104:	00054563          	bltz	a0,10e <runcmd+0x80>
    runcmd(rcmd->cmd);
     108:	6488                	ld	a0,8(s1)
     10a:	f85ff0ef          	jal	8e <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     10e:	6890                	ld	a2,16(s1)
     110:	00001597          	auipc	a1,0x1
     114:	26858593          	addi	a1,a1,616 # 1378 <malloc+0x138>
     118:	4509                	li	a0,2
     11a:	048010ef          	jal	1162 <fprintf>
      exit(1);
     11e:	4505                	li	a0,1
     120:	40d000ef          	jal	d2c <exit>
    if(fork1() == 0)
     124:	f45ff0ef          	jal	68 <fork1>
     128:	e501                	bnez	a0,130 <runcmd+0xa2>
      runcmd(lcmd->left);
     12a:	6488                	ld	a0,8(s1)
     12c:	f63ff0ef          	jal	8e <runcmd>
    wait(0);
     130:	4501                	li	a0,0
     132:	403000ef          	jal	d34 <wait>
    runcmd(lcmd->right);
     136:	6888                	ld	a0,16(s1)
     138:	f57ff0ef          	jal	8e <runcmd>
    if(pipe(p) < 0)
     13c:	fd840513          	addi	a0,s0,-40
     140:	3fd000ef          	jal	d3c <pipe>
     144:	02054763          	bltz	a0,172 <runcmd+0xe4>
    if(fork1() == 0){
     148:	f21ff0ef          	jal	68 <fork1>
     14c:	e90d                	bnez	a0,17e <runcmd+0xf0>
      close(1);
     14e:	4505                	li	a0,1
     150:	405000ef          	jal	d54 <close>
      dup(p[1]);
     154:	fdc42503          	lw	a0,-36(s0)
     158:	44d000ef          	jal	da4 <dup>
      close(p[0]);
     15c:	fd842503          	lw	a0,-40(s0)
     160:	3f5000ef          	jal	d54 <close>
      close(p[1]);
     164:	fdc42503          	lw	a0,-36(s0)
     168:	3ed000ef          	jal	d54 <close>
      runcmd(pcmd->left);
     16c:	6488                	ld	a0,8(s1)
     16e:	f21ff0ef          	jal	8e <runcmd>
      panic("pipe");
     172:	00001517          	auipc	a0,0x1
     176:	21650513          	addi	a0,a0,534 # 1388 <malloc+0x148>
     17a:	ed1ff0ef          	jal	4a <panic>
    if(fork1() == 0){
     17e:	eebff0ef          	jal	68 <fork1>
     182:	e115                	bnez	a0,1a6 <runcmd+0x118>
      close(0);
     184:	3d1000ef          	jal	d54 <close>
      dup(p[0]);
     188:	fd842503          	lw	a0,-40(s0)
     18c:	419000ef          	jal	da4 <dup>
      close(p[0]);
     190:	fd842503          	lw	a0,-40(s0)
     194:	3c1000ef          	jal	d54 <close>
      close(p[1]);
     198:	fdc42503          	lw	a0,-36(s0)
     19c:	3b9000ef          	jal	d54 <close>
      runcmd(pcmd->right);
     1a0:	6888                	ld	a0,16(s1)
     1a2:	eedff0ef          	jal	8e <runcmd>
    close(p[0]);
     1a6:	fd842503          	lw	a0,-40(s0)
     1aa:	3ab000ef          	jal	d54 <close>
    close(p[1]);
     1ae:	fdc42503          	lw	a0,-36(s0)
     1b2:	3a3000ef          	jal	d54 <close>
    wait(0);
     1b6:	4501                	li	a0,0
     1b8:	37d000ef          	jal	d34 <wait>
    wait(0);
     1bc:	4501                	li	a0,0
     1be:	377000ef          	jal	d34 <wait>
    break;
     1c2:	b725                	j	ea <runcmd+0x5c>
    if(fork1() == 0)
     1c4:	ea5ff0ef          	jal	68 <fork1>
     1c8:	f20511e3          	bnez	a0,ea <runcmd+0x5c>
      runcmd(bcmd->cmd);
     1cc:	6488                	ld	a0,8(s1)
     1ce:	ec1ff0ef          	jal	8e <runcmd>

00000000000001d2 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     1d2:	1101                	addi	sp,sp,-32
     1d4:	ec06                	sd	ra,24(sp)
     1d6:	e822                	sd	s0,16(sp)
     1d8:	e426                	sd	s1,8(sp)
     1da:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     1dc:	0a800513          	li	a0,168
     1e0:	060010ef          	jal	1240 <malloc>
     1e4:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     1e6:	0a800613          	li	a2,168
     1ea:	4581                	li	a1,0
     1ec:	061000ef          	jal	a4c <memset>
  cmd->type = EXEC;
     1f0:	4785                	li	a5,1
     1f2:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     1f4:	8526                	mv	a0,s1
     1f6:	60e2                	ld	ra,24(sp)
     1f8:	6442                	ld	s0,16(sp)
     1fa:	64a2                	ld	s1,8(sp)
     1fc:	6105                	addi	sp,sp,32
     1fe:	8082                	ret

0000000000000200 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     200:	7139                	addi	sp,sp,-64
     202:	fc06                	sd	ra,56(sp)
     204:	f822                	sd	s0,48(sp)
     206:	f426                	sd	s1,40(sp)
     208:	f04a                	sd	s2,32(sp)
     20a:	ec4e                	sd	s3,24(sp)
     20c:	e852                	sd	s4,16(sp)
     20e:	e456                	sd	s5,8(sp)
     210:	e05a                	sd	s6,0(sp)
     212:	0080                	addi	s0,sp,64
     214:	8b2a                	mv	s6,a0
     216:	8aae                	mv	s5,a1
     218:	8a32                	mv	s4,a2
     21a:	89b6                	mv	s3,a3
     21c:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     21e:	02800513          	li	a0,40
     222:	01e010ef          	jal	1240 <malloc>
     226:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     228:	02800613          	li	a2,40
     22c:	4581                	li	a1,0
     22e:	01f000ef          	jal	a4c <memset>
  cmd->type = REDIR;
     232:	4789                	li	a5,2
     234:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     236:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     23a:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     23e:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     242:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     246:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     24a:	8526                	mv	a0,s1
     24c:	70e2                	ld	ra,56(sp)
     24e:	7442                	ld	s0,48(sp)
     250:	74a2                	ld	s1,40(sp)
     252:	7902                	ld	s2,32(sp)
     254:	69e2                	ld	s3,24(sp)
     256:	6a42                	ld	s4,16(sp)
     258:	6aa2                	ld	s5,8(sp)
     25a:	6b02                	ld	s6,0(sp)
     25c:	6121                	addi	sp,sp,64
     25e:	8082                	ret

0000000000000260 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     260:	7179                	addi	sp,sp,-48
     262:	f406                	sd	ra,40(sp)
     264:	f022                	sd	s0,32(sp)
     266:	ec26                	sd	s1,24(sp)
     268:	e84a                	sd	s2,16(sp)
     26a:	e44e                	sd	s3,8(sp)
     26c:	1800                	addi	s0,sp,48
     26e:	89aa                	mv	s3,a0
     270:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     272:	4561                	li	a0,24
     274:	7cd000ef          	jal	1240 <malloc>
     278:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     27a:	4661                	li	a2,24
     27c:	4581                	li	a1,0
     27e:	7ce000ef          	jal	a4c <memset>
  cmd->type = PIPE;
     282:	478d                	li	a5,3
     284:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     286:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     28a:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     28e:	8526                	mv	a0,s1
     290:	70a2                	ld	ra,40(sp)
     292:	7402                	ld	s0,32(sp)
     294:	64e2                	ld	s1,24(sp)
     296:	6942                	ld	s2,16(sp)
     298:	69a2                	ld	s3,8(sp)
     29a:	6145                	addi	sp,sp,48
     29c:	8082                	ret

000000000000029e <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     29e:	7179                	addi	sp,sp,-48
     2a0:	f406                	sd	ra,40(sp)
     2a2:	f022                	sd	s0,32(sp)
     2a4:	ec26                	sd	s1,24(sp)
     2a6:	e84a                	sd	s2,16(sp)
     2a8:	e44e                	sd	s3,8(sp)
     2aa:	1800                	addi	s0,sp,48
     2ac:	89aa                	mv	s3,a0
     2ae:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2b0:	4561                	li	a0,24
     2b2:	78f000ef          	jal	1240 <malloc>
     2b6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2b8:	4661                	li	a2,24
     2ba:	4581                	li	a1,0
     2bc:	790000ef          	jal	a4c <memset>
  cmd->type = LIST;
     2c0:	4791                	li	a5,4
     2c2:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     2c4:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     2c8:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     2cc:	8526                	mv	a0,s1
     2ce:	70a2                	ld	ra,40(sp)
     2d0:	7402                	ld	s0,32(sp)
     2d2:	64e2                	ld	s1,24(sp)
     2d4:	6942                	ld	s2,16(sp)
     2d6:	69a2                	ld	s3,8(sp)
     2d8:	6145                	addi	sp,sp,48
     2da:	8082                	ret

00000000000002dc <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     2dc:	1101                	addi	sp,sp,-32
     2de:	ec06                	sd	ra,24(sp)
     2e0:	e822                	sd	s0,16(sp)
     2e2:	e426                	sd	s1,8(sp)
     2e4:	e04a                	sd	s2,0(sp)
     2e6:	1000                	addi	s0,sp,32
     2e8:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ea:	4541                	li	a0,16
     2ec:	755000ef          	jal	1240 <malloc>
     2f0:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2f2:	4641                	li	a2,16
     2f4:	4581                	li	a1,0
     2f6:	756000ef          	jal	a4c <memset>
  cmd->type = BACK;
     2fa:	4795                	li	a5,5
     2fc:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2fe:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     302:	8526                	mv	a0,s1
     304:	60e2                	ld	ra,24(sp)
     306:	6442                	ld	s0,16(sp)
     308:	64a2                	ld	s1,8(sp)
     30a:	6902                	ld	s2,0(sp)
     30c:	6105                	addi	sp,sp,32
     30e:	8082                	ret

0000000000000310 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     310:	7139                	addi	sp,sp,-64
     312:	fc06                	sd	ra,56(sp)
     314:	f822                	sd	s0,48(sp)
     316:	f426                	sd	s1,40(sp)
     318:	f04a                	sd	s2,32(sp)
     31a:	ec4e                	sd	s3,24(sp)
     31c:	e852                	sd	s4,16(sp)
     31e:	e456                	sd	s5,8(sp)
     320:	e05a                	sd	s6,0(sp)
     322:	0080                	addi	s0,sp,64
     324:	8a2a                	mv	s4,a0
     326:	892e                	mv	s2,a1
     328:	8ab2                	mv	s5,a2
     32a:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     32c:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     32e:	00002997          	auipc	s3,0x2
     332:	cda98993          	addi	s3,s3,-806 # 2008 <whitespace>
     336:	00b4fc63          	bgeu	s1,a1,34e <gettoken+0x3e>
     33a:	0004c583          	lbu	a1,0(s1)
     33e:	854e                	mv	a0,s3
     340:	72e000ef          	jal	a6e <strchr>
     344:	c509                	beqz	a0,34e <gettoken+0x3e>
    s++;
     346:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     348:	fe9919e3          	bne	s2,s1,33a <gettoken+0x2a>
     34c:	84ca                	mv	s1,s2
  if(q)
     34e:	000a8463          	beqz	s5,356 <gettoken+0x46>
    *q = s;
     352:	009ab023          	sd	s1,0(s5)
  ret = *s;
     356:	0004c783          	lbu	a5,0(s1)
     35a:	00078a9b          	sext.w	s5,a5
  switch(*s){
     35e:	03c00713          	li	a4,60
     362:	06f76463          	bltu	a4,a5,3ca <gettoken+0xba>
     366:	03a00713          	li	a4,58
     36a:	00f76e63          	bltu	a4,a5,386 <gettoken+0x76>
     36e:	cf89                	beqz	a5,388 <gettoken+0x78>
     370:	02600713          	li	a4,38
     374:	00e78963          	beq	a5,a4,386 <gettoken+0x76>
     378:	fd87879b          	addiw	a5,a5,-40
     37c:	0ff7f793          	zext.b	a5,a5
     380:	4705                	li	a4,1
     382:	06f76b63          	bltu	a4,a5,3f8 <gettoken+0xe8>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     386:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     388:	000b0463          	beqz	s6,390 <gettoken+0x80>
    *eq = s;
     38c:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     390:	00002997          	auipc	s3,0x2
     394:	c7898993          	addi	s3,s3,-904 # 2008 <whitespace>
     398:	0124fc63          	bgeu	s1,s2,3b0 <gettoken+0xa0>
     39c:	0004c583          	lbu	a1,0(s1)
     3a0:	854e                	mv	a0,s3
     3a2:	6cc000ef          	jal	a6e <strchr>
     3a6:	c509                	beqz	a0,3b0 <gettoken+0xa0>
    s++;
     3a8:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     3aa:	fe9919e3          	bne	s2,s1,39c <gettoken+0x8c>
     3ae:	84ca                	mv	s1,s2
  *ps = s;
     3b0:	009a3023          	sd	s1,0(s4)
  return ret;
}
     3b4:	8556                	mv	a0,s5
     3b6:	70e2                	ld	ra,56(sp)
     3b8:	7442                	ld	s0,48(sp)
     3ba:	74a2                	ld	s1,40(sp)
     3bc:	7902                	ld	s2,32(sp)
     3be:	69e2                	ld	s3,24(sp)
     3c0:	6a42                	ld	s4,16(sp)
     3c2:	6aa2                	ld	s5,8(sp)
     3c4:	6b02                	ld	s6,0(sp)
     3c6:	6121                	addi	sp,sp,64
     3c8:	8082                	ret
  switch(*s){
     3ca:	03e00713          	li	a4,62
     3ce:	02e79163          	bne	a5,a4,3f0 <gettoken+0xe0>
    s++;
     3d2:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     3d6:	0014c703          	lbu	a4,1(s1)
     3da:	03e00793          	li	a5,62
      s++;
     3de:	0489                	addi	s1,s1,2
      ret = '+';
     3e0:	02b00a93          	li	s5,43
    if(*s == '>'){
     3e4:	faf702e3          	beq	a4,a5,388 <gettoken+0x78>
    s++;
     3e8:	84b6                	mv	s1,a3
  ret = *s;
     3ea:	03e00a93          	li	s5,62
     3ee:	bf69                	j	388 <gettoken+0x78>
  switch(*s){
     3f0:	07c00713          	li	a4,124
     3f4:	f8e789e3          	beq	a5,a4,386 <gettoken+0x76>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     3f8:	00002997          	auipc	s3,0x2
     3fc:	c1098993          	addi	s3,s3,-1008 # 2008 <whitespace>
     400:	00002a97          	auipc	s5,0x2
     404:	c00a8a93          	addi	s5,s5,-1024 # 2000 <symbols>
     408:	0324fd63          	bgeu	s1,s2,442 <gettoken+0x132>
     40c:	0004c583          	lbu	a1,0(s1)
     410:	854e                	mv	a0,s3
     412:	65c000ef          	jal	a6e <strchr>
     416:	e11d                	bnez	a0,43c <gettoken+0x12c>
     418:	0004c583          	lbu	a1,0(s1)
     41c:	8556                	mv	a0,s5
     41e:	650000ef          	jal	a6e <strchr>
     422:	e911                	bnez	a0,436 <gettoken+0x126>
      s++;
     424:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     426:	fe9913e3          	bne	s2,s1,40c <gettoken+0xfc>
  if(eq)
     42a:	84ca                	mv	s1,s2
    ret = 'a';
     42c:	06100a93          	li	s5,97
  if(eq)
     430:	f40b1ee3          	bnez	s6,38c <gettoken+0x7c>
     434:	bfb5                	j	3b0 <gettoken+0xa0>
    ret = 'a';
     436:	06100a93          	li	s5,97
     43a:	b7b9                	j	388 <gettoken+0x78>
     43c:	06100a93          	li	s5,97
     440:	b7a1                	j	388 <gettoken+0x78>
     442:	06100a93          	li	s5,97
  if(eq)
     446:	f40b13e3          	bnez	s6,38c <gettoken+0x7c>
     44a:	b79d                	j	3b0 <gettoken+0xa0>

000000000000044c <peek>:

int
peek(char **ps, char *es, char *toks)
{
     44c:	7139                	addi	sp,sp,-64
     44e:	fc06                	sd	ra,56(sp)
     450:	f822                	sd	s0,48(sp)
     452:	f426                	sd	s1,40(sp)
     454:	f04a                	sd	s2,32(sp)
     456:	ec4e                	sd	s3,24(sp)
     458:	e852                	sd	s4,16(sp)
     45a:	e456                	sd	s5,8(sp)
     45c:	0080                	addi	s0,sp,64
     45e:	8a2a                	mv	s4,a0
     460:	892e                	mv	s2,a1
     462:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     464:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     466:	00002997          	auipc	s3,0x2
     46a:	ba298993          	addi	s3,s3,-1118 # 2008 <whitespace>
     46e:	00b4fc63          	bgeu	s1,a1,486 <peek+0x3a>
     472:	0004c583          	lbu	a1,0(s1)
     476:	854e                	mv	a0,s3
     478:	5f6000ef          	jal	a6e <strchr>
     47c:	c509                	beqz	a0,486 <peek+0x3a>
    s++;
     47e:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     480:	fe9919e3          	bne	s2,s1,472 <peek+0x26>
     484:	84ca                	mv	s1,s2
  *ps = s;
     486:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     48a:	0004c583          	lbu	a1,0(s1)
     48e:	4501                	li	a0,0
     490:	e991                	bnez	a1,4a4 <peek+0x58>
}
     492:	70e2                	ld	ra,56(sp)
     494:	7442                	ld	s0,48(sp)
     496:	74a2                	ld	s1,40(sp)
     498:	7902                	ld	s2,32(sp)
     49a:	69e2                	ld	s3,24(sp)
     49c:	6a42                	ld	s4,16(sp)
     49e:	6aa2                	ld	s5,8(sp)
     4a0:	6121                	addi	sp,sp,64
     4a2:	8082                	ret
  return *s && strchr(toks, *s);
     4a4:	8556                	mv	a0,s5
     4a6:	5c8000ef          	jal	a6e <strchr>
     4aa:	00a03533          	snez	a0,a0
     4ae:	b7d5                	j	492 <peek+0x46>

00000000000004b0 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     4b0:	711d                	addi	sp,sp,-96
     4b2:	ec86                	sd	ra,88(sp)
     4b4:	e8a2                	sd	s0,80(sp)
     4b6:	e4a6                	sd	s1,72(sp)
     4b8:	e0ca                	sd	s2,64(sp)
     4ba:	fc4e                	sd	s3,56(sp)
     4bc:	f852                	sd	s4,48(sp)
     4be:	f456                	sd	s5,40(sp)
     4c0:	f05a                	sd	s6,32(sp)
     4c2:	ec5e                	sd	s7,24(sp)
     4c4:	1080                	addi	s0,sp,96
     4c6:	8a2a                	mv	s4,a0
     4c8:	89ae                	mv	s3,a1
     4ca:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     4cc:	00001a97          	auipc	s5,0x1
     4d0:	ee4a8a93          	addi	s5,s5,-284 # 13b0 <malloc+0x170>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     4d4:	06100b13          	li	s6,97
      panic("missing file for redirection");
    switch(tok){
     4d8:	03c00b93          	li	s7,60
  while(peek(ps, es, "<>")){
     4dc:	a00d                	j	4fe <parseredirs+0x4e>
      panic("missing file for redirection");
     4de:	00001517          	auipc	a0,0x1
     4e2:	eb250513          	addi	a0,a0,-334 # 1390 <malloc+0x150>
     4e6:	b65ff0ef          	jal	4a <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4ea:	4701                	li	a4,0
     4ec:	4681                	li	a3,0
     4ee:	fa043603          	ld	a2,-96(s0)
     4f2:	fa843583          	ld	a1,-88(s0)
     4f6:	8552                	mv	a0,s4
     4f8:	d09ff0ef          	jal	200 <redircmd>
     4fc:	8a2a                	mv	s4,a0
  while(peek(ps, es, "<>")){
     4fe:	8656                	mv	a2,s5
     500:	85ca                	mv	a1,s2
     502:	854e                	mv	a0,s3
     504:	f49ff0ef          	jal	44c <peek>
     508:	c525                	beqz	a0,570 <parseredirs+0xc0>
    tok = gettoken(ps, es, 0, 0);
     50a:	4681                	li	a3,0
     50c:	4601                	li	a2,0
     50e:	85ca                	mv	a1,s2
     510:	854e                	mv	a0,s3
     512:	dffff0ef          	jal	310 <gettoken>
     516:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     518:	fa040693          	addi	a3,s0,-96
     51c:	fa840613          	addi	a2,s0,-88
     520:	85ca                	mv	a1,s2
     522:	854e                	mv	a0,s3
     524:	dedff0ef          	jal	310 <gettoken>
     528:	fb651be3          	bne	a0,s6,4de <parseredirs+0x2e>
    switch(tok){
     52c:	fb748fe3          	beq	s1,s7,4ea <parseredirs+0x3a>
     530:	03e00793          	li	a5,62
     534:	02f48263          	beq	s1,a5,558 <parseredirs+0xa8>
     538:	02b00793          	li	a5,43
     53c:	fcf491e3          	bne	s1,a5,4fe <parseredirs+0x4e>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     540:	4705                	li	a4,1
     542:	20100693          	li	a3,513
     546:	fa043603          	ld	a2,-96(s0)
     54a:	fa843583          	ld	a1,-88(s0)
     54e:	8552                	mv	a0,s4
     550:	cb1ff0ef          	jal	200 <redircmd>
     554:	8a2a                	mv	s4,a0
      break;
     556:	b765                	j	4fe <parseredirs+0x4e>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     558:	4705                	li	a4,1
     55a:	60100693          	li	a3,1537
     55e:	fa043603          	ld	a2,-96(s0)
     562:	fa843583          	ld	a1,-88(s0)
     566:	8552                	mv	a0,s4
     568:	c99ff0ef          	jal	200 <redircmd>
     56c:	8a2a                	mv	s4,a0
      break;
     56e:	bf41                	j	4fe <parseredirs+0x4e>
    }
  }
  return cmd;
}
     570:	8552                	mv	a0,s4
     572:	60e6                	ld	ra,88(sp)
     574:	6446                	ld	s0,80(sp)
     576:	64a6                	ld	s1,72(sp)
     578:	6906                	ld	s2,64(sp)
     57a:	79e2                	ld	s3,56(sp)
     57c:	7a42                	ld	s4,48(sp)
     57e:	7aa2                	ld	s5,40(sp)
     580:	7b02                	ld	s6,32(sp)
     582:	6be2                	ld	s7,24(sp)
     584:	6125                	addi	sp,sp,96
     586:	8082                	ret

0000000000000588 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     588:	7159                	addi	sp,sp,-112
     58a:	f486                	sd	ra,104(sp)
     58c:	f0a2                	sd	s0,96(sp)
     58e:	eca6                	sd	s1,88(sp)
     590:	e0d2                	sd	s4,64(sp)
     592:	fc56                	sd	s5,56(sp)
     594:	1880                	addi	s0,sp,112
     596:	8a2a                	mv	s4,a0
     598:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     59a:	00001617          	auipc	a2,0x1
     59e:	e1e60613          	addi	a2,a2,-482 # 13b8 <malloc+0x178>
     5a2:	eabff0ef          	jal	44c <peek>
     5a6:	e915                	bnez	a0,5da <parseexec+0x52>
     5a8:	e8ca                	sd	s2,80(sp)
     5aa:	e4ce                	sd	s3,72(sp)
     5ac:	f85a                	sd	s6,48(sp)
     5ae:	f45e                	sd	s7,40(sp)
     5b0:	f062                	sd	s8,32(sp)
     5b2:	ec66                	sd	s9,24(sp)
     5b4:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     5b6:	c1dff0ef          	jal	1d2 <execcmd>
     5ba:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5bc:	8656                	mv	a2,s5
     5be:	85d2                	mv	a1,s4
     5c0:	ef1ff0ef          	jal	4b0 <parseredirs>
     5c4:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     5c6:	008c0913          	addi	s2,s8,8
     5ca:	00001b17          	auipc	s6,0x1
     5ce:	e0eb0b13          	addi	s6,s6,-498 # 13d8 <malloc+0x198>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     5d2:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     5d6:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     5d8:	a815                	j	60c <parseexec+0x84>
    return parseblock(ps, es);
     5da:	85d6                	mv	a1,s5
     5dc:	8552                	mv	a0,s4
     5de:	170000ef          	jal	74e <parseblock>
     5e2:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     5e4:	8526                	mv	a0,s1
     5e6:	70a6                	ld	ra,104(sp)
     5e8:	7406                	ld	s0,96(sp)
     5ea:	64e6                	ld	s1,88(sp)
     5ec:	6a06                	ld	s4,64(sp)
     5ee:	7ae2                	ld	s5,56(sp)
     5f0:	6165                	addi	sp,sp,112
     5f2:	8082                	ret
      panic("syntax");
     5f4:	00001517          	auipc	a0,0x1
     5f8:	dcc50513          	addi	a0,a0,-564 # 13c0 <malloc+0x180>
     5fc:	a4fff0ef          	jal	4a <panic>
    ret = parseredirs(ret, ps, es);
     600:	8656                	mv	a2,s5
     602:	85d2                	mv	a1,s4
     604:	8526                	mv	a0,s1
     606:	eabff0ef          	jal	4b0 <parseredirs>
     60a:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     60c:	865a                	mv	a2,s6
     60e:	85d6                	mv	a1,s5
     610:	8552                	mv	a0,s4
     612:	e3bff0ef          	jal	44c <peek>
     616:	ed15                	bnez	a0,652 <parseexec+0xca>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     618:	f9040693          	addi	a3,s0,-112
     61c:	f9840613          	addi	a2,s0,-104
     620:	85d6                	mv	a1,s5
     622:	8552                	mv	a0,s4
     624:	cedff0ef          	jal	310 <gettoken>
     628:	c50d                	beqz	a0,652 <parseexec+0xca>
    if(tok != 'a')
     62a:	fd9515e3          	bne	a0,s9,5f4 <parseexec+0x6c>
    cmd->argv[argc] = q;
     62e:	f9843783          	ld	a5,-104(s0)
     632:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     636:	f9043783          	ld	a5,-112(s0)
     63a:	04f93823          	sd	a5,80(s2)
    argc++;
     63e:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     640:	0921                	addi	s2,s2,8
     642:	fb799fe3          	bne	s3,s7,600 <parseexec+0x78>
      panic("too many args");
     646:	00001517          	auipc	a0,0x1
     64a:	d8250513          	addi	a0,a0,-638 # 13c8 <malloc+0x188>
     64e:	9fdff0ef          	jal	4a <panic>
  cmd->argv[argc] = 0;
     652:	098e                	slli	s3,s3,0x3
     654:	9c4e                	add	s8,s8,s3
     656:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     65a:	040c3c23          	sd	zero,88(s8)
     65e:	6946                	ld	s2,80(sp)
     660:	69a6                	ld	s3,72(sp)
     662:	7b42                	ld	s6,48(sp)
     664:	7ba2                	ld	s7,40(sp)
     666:	7c02                	ld	s8,32(sp)
     668:	6ce2                	ld	s9,24(sp)
  return ret;
     66a:	bfad                	j	5e4 <parseexec+0x5c>

000000000000066c <parsepipe>:
{
     66c:	7179                	addi	sp,sp,-48
     66e:	f406                	sd	ra,40(sp)
     670:	f022                	sd	s0,32(sp)
     672:	ec26                	sd	s1,24(sp)
     674:	e84a                	sd	s2,16(sp)
     676:	e44e                	sd	s3,8(sp)
     678:	1800                	addi	s0,sp,48
     67a:	892a                	mv	s2,a0
     67c:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     67e:	f0bff0ef          	jal	588 <parseexec>
     682:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     684:	00001617          	auipc	a2,0x1
     688:	d5c60613          	addi	a2,a2,-676 # 13e0 <malloc+0x1a0>
     68c:	85ce                	mv	a1,s3
     68e:	854a                	mv	a0,s2
     690:	dbdff0ef          	jal	44c <peek>
     694:	e909                	bnez	a0,6a6 <parsepipe+0x3a>
}
     696:	8526                	mv	a0,s1
     698:	70a2                	ld	ra,40(sp)
     69a:	7402                	ld	s0,32(sp)
     69c:	64e2                	ld	s1,24(sp)
     69e:	6942                	ld	s2,16(sp)
     6a0:	69a2                	ld	s3,8(sp)
     6a2:	6145                	addi	sp,sp,48
     6a4:	8082                	ret
    gettoken(ps, es, 0, 0);
     6a6:	4681                	li	a3,0
     6a8:	4601                	li	a2,0
     6aa:	85ce                	mv	a1,s3
     6ac:	854a                	mv	a0,s2
     6ae:	c63ff0ef          	jal	310 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6b2:	85ce                	mv	a1,s3
     6b4:	854a                	mv	a0,s2
     6b6:	fb7ff0ef          	jal	66c <parsepipe>
     6ba:	85aa                	mv	a1,a0
     6bc:	8526                	mv	a0,s1
     6be:	ba3ff0ef          	jal	260 <pipecmd>
     6c2:	84aa                	mv	s1,a0
  return cmd;
     6c4:	bfc9                	j	696 <parsepipe+0x2a>

00000000000006c6 <parseline>:
{
     6c6:	7179                	addi	sp,sp,-48
     6c8:	f406                	sd	ra,40(sp)
     6ca:	f022                	sd	s0,32(sp)
     6cc:	ec26                	sd	s1,24(sp)
     6ce:	e84a                	sd	s2,16(sp)
     6d0:	e44e                	sd	s3,8(sp)
     6d2:	e052                	sd	s4,0(sp)
     6d4:	1800                	addi	s0,sp,48
     6d6:	892a                	mv	s2,a0
     6d8:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     6da:	f93ff0ef          	jal	66c <parsepipe>
     6de:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     6e0:	00001a17          	auipc	s4,0x1
     6e4:	d08a0a13          	addi	s4,s4,-760 # 13e8 <malloc+0x1a8>
     6e8:	a819                	j	6fe <parseline+0x38>
    gettoken(ps, es, 0, 0);
     6ea:	4681                	li	a3,0
     6ec:	4601                	li	a2,0
     6ee:	85ce                	mv	a1,s3
     6f0:	854a                	mv	a0,s2
     6f2:	c1fff0ef          	jal	310 <gettoken>
    cmd = backcmd(cmd);
     6f6:	8526                	mv	a0,s1
     6f8:	be5ff0ef          	jal	2dc <backcmd>
     6fc:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     6fe:	8652                	mv	a2,s4
     700:	85ce                	mv	a1,s3
     702:	854a                	mv	a0,s2
     704:	d49ff0ef          	jal	44c <peek>
     708:	f16d                	bnez	a0,6ea <parseline+0x24>
  if(peek(ps, es, ";")){
     70a:	00001617          	auipc	a2,0x1
     70e:	ce660613          	addi	a2,a2,-794 # 13f0 <malloc+0x1b0>
     712:	85ce                	mv	a1,s3
     714:	854a                	mv	a0,s2
     716:	d37ff0ef          	jal	44c <peek>
     71a:	e911                	bnez	a0,72e <parseline+0x68>
}
     71c:	8526                	mv	a0,s1
     71e:	70a2                	ld	ra,40(sp)
     720:	7402                	ld	s0,32(sp)
     722:	64e2                	ld	s1,24(sp)
     724:	6942                	ld	s2,16(sp)
     726:	69a2                	ld	s3,8(sp)
     728:	6a02                	ld	s4,0(sp)
     72a:	6145                	addi	sp,sp,48
     72c:	8082                	ret
    gettoken(ps, es, 0, 0);
     72e:	4681                	li	a3,0
     730:	4601                	li	a2,0
     732:	85ce                	mv	a1,s3
     734:	854a                	mv	a0,s2
     736:	bdbff0ef          	jal	310 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     73a:	85ce                	mv	a1,s3
     73c:	854a                	mv	a0,s2
     73e:	f89ff0ef          	jal	6c6 <parseline>
     742:	85aa                	mv	a1,a0
     744:	8526                	mv	a0,s1
     746:	b59ff0ef          	jal	29e <listcmd>
     74a:	84aa                	mv	s1,a0
  return cmd;
     74c:	bfc1                	j	71c <parseline+0x56>

000000000000074e <parseblock>:
{
     74e:	7179                	addi	sp,sp,-48
     750:	f406                	sd	ra,40(sp)
     752:	f022                	sd	s0,32(sp)
     754:	ec26                	sd	s1,24(sp)
     756:	e84a                	sd	s2,16(sp)
     758:	e44e                	sd	s3,8(sp)
     75a:	1800                	addi	s0,sp,48
     75c:	84aa                	mv	s1,a0
     75e:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     760:	00001617          	auipc	a2,0x1
     764:	c5860613          	addi	a2,a2,-936 # 13b8 <malloc+0x178>
     768:	ce5ff0ef          	jal	44c <peek>
     76c:	c539                	beqz	a0,7ba <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     76e:	4681                	li	a3,0
     770:	4601                	li	a2,0
     772:	85ca                	mv	a1,s2
     774:	8526                	mv	a0,s1
     776:	b9bff0ef          	jal	310 <gettoken>
  cmd = parseline(ps, es);
     77a:	85ca                	mv	a1,s2
     77c:	8526                	mv	a0,s1
     77e:	f49ff0ef          	jal	6c6 <parseline>
     782:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     784:	00001617          	auipc	a2,0x1
     788:	c8460613          	addi	a2,a2,-892 # 1408 <malloc+0x1c8>
     78c:	85ca                	mv	a1,s2
     78e:	8526                	mv	a0,s1
     790:	cbdff0ef          	jal	44c <peek>
     794:	c90d                	beqz	a0,7c6 <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     796:	4681                	li	a3,0
     798:	4601                	li	a2,0
     79a:	85ca                	mv	a1,s2
     79c:	8526                	mv	a0,s1
     79e:	b73ff0ef          	jal	310 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     7a2:	864a                	mv	a2,s2
     7a4:	85a6                	mv	a1,s1
     7a6:	854e                	mv	a0,s3
     7a8:	d09ff0ef          	jal	4b0 <parseredirs>
}
     7ac:	70a2                	ld	ra,40(sp)
     7ae:	7402                	ld	s0,32(sp)
     7b0:	64e2                	ld	s1,24(sp)
     7b2:	6942                	ld	s2,16(sp)
     7b4:	69a2                	ld	s3,8(sp)
     7b6:	6145                	addi	sp,sp,48
     7b8:	8082                	ret
    panic("parseblock");
     7ba:	00001517          	auipc	a0,0x1
     7be:	c3e50513          	addi	a0,a0,-962 # 13f8 <malloc+0x1b8>
     7c2:	889ff0ef          	jal	4a <panic>
    panic("syntax - missing )");
     7c6:	00001517          	auipc	a0,0x1
     7ca:	c4a50513          	addi	a0,a0,-950 # 1410 <malloc+0x1d0>
     7ce:	87dff0ef          	jal	4a <panic>

00000000000007d2 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     7d2:	1101                	addi	sp,sp,-32
     7d4:	ec06                	sd	ra,24(sp)
     7d6:	e822                	sd	s0,16(sp)
     7d8:	e426                	sd	s1,8(sp)
     7da:	1000                	addi	s0,sp,32
     7dc:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     7de:	c131                	beqz	a0,822 <nulterminate+0x50>
    return 0;

  switch(cmd->type){
     7e0:	4118                	lw	a4,0(a0)
     7e2:	4795                	li	a5,5
     7e4:	02e7ef63          	bltu	a5,a4,822 <nulterminate+0x50>
     7e8:	00056783          	lwu	a5,0(a0)
     7ec:	078a                	slli	a5,a5,0x2
     7ee:	00001717          	auipc	a4,0x1
     7f2:	caa70713          	addi	a4,a4,-854 # 1498 <malloc+0x258>
     7f6:	97ba                	add	a5,a5,a4
     7f8:	439c                	lw	a5,0(a5)
     7fa:	97ba                	add	a5,a5,a4
     7fc:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     7fe:	651c                	ld	a5,8(a0)
     800:	c38d                	beqz	a5,822 <nulterminate+0x50>
     802:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     806:	67b8                	ld	a4,72(a5)
     808:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     80c:	07a1                	addi	a5,a5,8
     80e:	ff87b703          	ld	a4,-8(a5)
     812:	fb75                	bnez	a4,806 <nulterminate+0x34>
     814:	a039                	j	822 <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     816:	6508                	ld	a0,8(a0)
     818:	fbbff0ef          	jal	7d2 <nulterminate>
    *rcmd->efile = 0;
     81c:	6c9c                	ld	a5,24(s1)
     81e:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     822:	8526                	mv	a0,s1
     824:	60e2                	ld	ra,24(sp)
     826:	6442                	ld	s0,16(sp)
     828:	64a2                	ld	s1,8(sp)
     82a:	6105                	addi	sp,sp,32
     82c:	8082                	ret
    nulterminate(pcmd->left);
     82e:	6508                	ld	a0,8(a0)
     830:	fa3ff0ef          	jal	7d2 <nulterminate>
    nulterminate(pcmd->right);
     834:	6888                	ld	a0,16(s1)
     836:	f9dff0ef          	jal	7d2 <nulterminate>
    break;
     83a:	b7e5                	j	822 <nulterminate+0x50>
    nulterminate(lcmd->left);
     83c:	6508                	ld	a0,8(a0)
     83e:	f95ff0ef          	jal	7d2 <nulterminate>
    nulterminate(lcmd->right);
     842:	6888                	ld	a0,16(s1)
     844:	f8fff0ef          	jal	7d2 <nulterminate>
    break;
     848:	bfe9                	j	822 <nulterminate+0x50>
    nulterminate(bcmd->cmd);
     84a:	6508                	ld	a0,8(a0)
     84c:	f87ff0ef          	jal	7d2 <nulterminate>
    break;
     850:	bfc9                	j	822 <nulterminate+0x50>

0000000000000852 <parsecmd>:
{
     852:	7179                	addi	sp,sp,-48
     854:	f406                	sd	ra,40(sp)
     856:	f022                	sd	s0,32(sp)
     858:	ec26                	sd	s1,24(sp)
     85a:	e84a                	sd	s2,16(sp)
     85c:	1800                	addi	s0,sp,48
     85e:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     862:	84aa                	mv	s1,a0
     864:	1be000ef          	jal	a22 <strlen>
     868:	1502                	slli	a0,a0,0x20
     86a:	9101                	srli	a0,a0,0x20
     86c:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     86e:	85a6                	mv	a1,s1
     870:	fd840513          	addi	a0,s0,-40
     874:	e53ff0ef          	jal	6c6 <parseline>
     878:	892a                	mv	s2,a0
  peek(&s, es, "");
     87a:	00001617          	auipc	a2,0x1
     87e:	ace60613          	addi	a2,a2,-1330 # 1348 <malloc+0x108>
     882:	85a6                	mv	a1,s1
     884:	fd840513          	addi	a0,s0,-40
     888:	bc5ff0ef          	jal	44c <peek>
  if(s != es){
     88c:	fd843603          	ld	a2,-40(s0)
     890:	00961c63          	bne	a2,s1,8a8 <parsecmd+0x56>
  nulterminate(cmd);
     894:	854a                	mv	a0,s2
     896:	f3dff0ef          	jal	7d2 <nulterminate>
}
     89a:	854a                	mv	a0,s2
     89c:	70a2                	ld	ra,40(sp)
     89e:	7402                	ld	s0,32(sp)
     8a0:	64e2                	ld	s1,24(sp)
     8a2:	6942                	ld	s2,16(sp)
     8a4:	6145                	addi	sp,sp,48
     8a6:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     8a8:	00001597          	auipc	a1,0x1
     8ac:	b8058593          	addi	a1,a1,-1152 # 1428 <malloc+0x1e8>
     8b0:	4509                	li	a0,2
     8b2:	0b1000ef          	jal	1162 <fprintf>
    panic("syntax");
     8b6:	00001517          	auipc	a0,0x1
     8ba:	b0a50513          	addi	a0,a0,-1270 # 13c0 <malloc+0x180>
     8be:	f8cff0ef          	jal	4a <panic>

00000000000008c2 <main>:
{
     8c2:	7179                	addi	sp,sp,-48
     8c4:	f406                	sd	ra,40(sp)
     8c6:	f022                	sd	s0,32(sp)
     8c8:	ec26                	sd	s1,24(sp)
     8ca:	e84a                	sd	s2,16(sp)
     8cc:	e44e                	sd	s3,8(sp)
     8ce:	e052                	sd	s4,0(sp)
     8d0:	1800                	addi	s0,sp,48
  while((fd = open("console", O_RDWR)) >= 0){
     8d2:	00001497          	auipc	s1,0x1
     8d6:	b6648493          	addi	s1,s1,-1178 # 1438 <malloc+0x1f8>
     8da:	4589                	li	a1,2
     8dc:	8526                	mv	a0,s1
     8de:	48e000ef          	jal	d6c <open>
     8e2:	00054763          	bltz	a0,8f0 <main+0x2e>
    if(fd >= 3){
     8e6:	4789                	li	a5,2
     8e8:	fea7d9e3          	bge	a5,a0,8da <main+0x18>
      close(fd);
     8ec:	468000ef          	jal	d54 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     8f0:	00001497          	auipc	s1,0x1
     8f4:	73048493          	addi	s1,s1,1840 # 2020 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     8f8:	06300913          	li	s2,99
     8fc:	02000993          	li	s3,32
     900:	a039                	j	90e <main+0x4c>
    if(fork1() == 0)
     902:	f66ff0ef          	jal	68 <fork1>
     906:	c93d                	beqz	a0,97c <main+0xba>
    wait(0);
     908:	4501                	li	a0,0
     90a:	42a000ef          	jal	d34 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     90e:	06400593          	li	a1,100
     912:	8526                	mv	a0,s1
     914:	eecff0ef          	jal	0 <getcmd>
     918:	06054a63          	bltz	a0,98c <main+0xca>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     91c:	0004c783          	lbu	a5,0(s1)
     920:	ff2791e3          	bne	a5,s2,902 <main+0x40>
     924:	0014c703          	lbu	a4,1(s1)
     928:	06400793          	li	a5,100
     92c:	fcf71be3          	bne	a4,a5,902 <main+0x40>
     930:	0024c783          	lbu	a5,2(s1)
     934:	fd3797e3          	bne	a5,s3,902 <main+0x40>
      buf[strlen(buf)-1] = 0;  // chop \n
     938:	00001a17          	auipc	s4,0x1
     93c:	6e8a0a13          	addi	s4,s4,1768 # 2020 <buf.0>
     940:	8552                	mv	a0,s4
     942:	0e0000ef          	jal	a22 <strlen>
     946:	fff5079b          	addiw	a5,a0,-1
     94a:	1782                	slli	a5,a5,0x20
     94c:	9381                	srli	a5,a5,0x20
     94e:	9a3e                	add	s4,s4,a5
     950:	000a0023          	sb	zero,0(s4)
      if(chdir(buf+3) < 0)
     954:	00001517          	auipc	a0,0x1
     958:	6cf50513          	addi	a0,a0,1743 # 2023 <buf.0+0x3>
     95c:	440000ef          	jal	d9c <chdir>
     960:	fa0557e3          	bgez	a0,90e <main+0x4c>
        fprintf(2, "cannot cd %s\n", buf+3);
     964:	00001617          	auipc	a2,0x1
     968:	6bf60613          	addi	a2,a2,1727 # 2023 <buf.0+0x3>
     96c:	00001597          	auipc	a1,0x1
     970:	ad458593          	addi	a1,a1,-1324 # 1440 <malloc+0x200>
     974:	4509                	li	a0,2
     976:	7ec000ef          	jal	1162 <fprintf>
     97a:	bf51                	j	90e <main+0x4c>
      runcmd(parsecmd(buf));
     97c:	00001517          	auipc	a0,0x1
     980:	6a450513          	addi	a0,a0,1700 # 2020 <buf.0>
     984:	ecfff0ef          	jal	852 <parsecmd>
     988:	f06ff0ef          	jal	8e <runcmd>
  exit(0);
     98c:	4501                	li	a0,0
     98e:	39e000ef          	jal	d2c <exit>

0000000000000992 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     992:	1141                	addi	sp,sp,-16
     994:	e406                	sd	ra,8(sp)
     996:	e022                	sd	s0,0(sp)
     998:	0800                	addi	s0,sp,16
  extern int main();
  main();
     99a:	f29ff0ef          	jal	8c2 <main>
  exit(0);
     99e:	4501                	li	a0,0
     9a0:	38c000ef          	jal	d2c <exit>

00000000000009a4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     9a4:	1141                	addi	sp,sp,-16
     9a6:	e422                	sd	s0,8(sp)
     9a8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     9aa:	87aa                	mv	a5,a0
     9ac:	0585                	addi	a1,a1,1
     9ae:	0785                	addi	a5,a5,1
     9b0:	fff5c703          	lbu	a4,-1(a1)
     9b4:	fee78fa3          	sb	a4,-1(a5)
     9b8:	fb75                	bnez	a4,9ac <strcpy+0x8>
    ;
  return os;
}
     9ba:	6422                	ld	s0,8(sp)
     9bc:	0141                	addi	sp,sp,16
     9be:	8082                	ret

00000000000009c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9c0:	1141                	addi	sp,sp,-16
     9c2:	e422                	sd	s0,8(sp)
     9c4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     9c6:	00054783          	lbu	a5,0(a0)
     9ca:	cb91                	beqz	a5,9de <strcmp+0x1e>
     9cc:	0005c703          	lbu	a4,0(a1)
     9d0:	00f71763          	bne	a4,a5,9de <strcmp+0x1e>
    p++, q++;
     9d4:	0505                	addi	a0,a0,1
     9d6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     9d8:	00054783          	lbu	a5,0(a0)
     9dc:	fbe5                	bnez	a5,9cc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     9de:	0005c503          	lbu	a0,0(a1)
}
     9e2:	40a7853b          	subw	a0,a5,a0
     9e6:	6422                	ld	s0,8(sp)
     9e8:	0141                	addi	sp,sp,16
     9ea:	8082                	ret

00000000000009ec <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
     9ec:	1141                	addi	sp,sp,-16
     9ee:	e422                	sd	s0,8(sp)
     9f0:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q) {
     9f2:	ce11                	beqz	a2,a0e <strncmp+0x22>
     9f4:	00054783          	lbu	a5,0(a0)
     9f8:	cf89                	beqz	a5,a12 <strncmp+0x26>
     9fa:	0005c703          	lbu	a4,0(a1)
     9fe:	00f71a63          	bne	a4,a5,a12 <strncmp+0x26>
    n--;
     a02:	367d                	addiw	a2,a2,-1
    p++;
     a04:	0505                	addi	a0,a0,1
    q++;
     a06:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q) {
     a08:	f675                	bnez	a2,9f4 <strncmp+0x8>
  }
  if(n == 0)
    return 0;
     a0a:	4501                	li	a0,0
     a0c:	a801                	j	a1c <strncmp+0x30>
     a0e:	4501                	li	a0,0
     a10:	a031                	j	a1c <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
     a12:	00054503          	lbu	a0,0(a0)
     a16:	0005c783          	lbu	a5,0(a1)
     a1a:	9d1d                	subw	a0,a0,a5
}
     a1c:	6422                	ld	s0,8(sp)
     a1e:	0141                	addi	sp,sp,16
     a20:	8082                	ret

0000000000000a22 <strlen>:

uint
strlen(const char *s)
{
     a22:	1141                	addi	sp,sp,-16
     a24:	e422                	sd	s0,8(sp)
     a26:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     a28:	00054783          	lbu	a5,0(a0)
     a2c:	cf91                	beqz	a5,a48 <strlen+0x26>
     a2e:	0505                	addi	a0,a0,1
     a30:	87aa                	mv	a5,a0
     a32:	86be                	mv	a3,a5
     a34:	0785                	addi	a5,a5,1
     a36:	fff7c703          	lbu	a4,-1(a5)
     a3a:	ff65                	bnez	a4,a32 <strlen+0x10>
     a3c:	40a6853b          	subw	a0,a3,a0
     a40:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     a42:	6422                	ld	s0,8(sp)
     a44:	0141                	addi	sp,sp,16
     a46:	8082                	ret
  for(n = 0; s[n]; n++)
     a48:	4501                	li	a0,0
     a4a:	bfe5                	j	a42 <strlen+0x20>

0000000000000a4c <memset>:

void*
memset(void *dst, int c, uint n)
{
     a4c:	1141                	addi	sp,sp,-16
     a4e:	e422                	sd	s0,8(sp)
     a50:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a52:	ca19                	beqz	a2,a68 <memset+0x1c>
     a54:	87aa                	mv	a5,a0
     a56:	1602                	slli	a2,a2,0x20
     a58:	9201                	srli	a2,a2,0x20
     a5a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a5e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a62:	0785                	addi	a5,a5,1
     a64:	fee79de3          	bne	a5,a4,a5e <memset+0x12>
  }
  return dst;
}
     a68:	6422                	ld	s0,8(sp)
     a6a:	0141                	addi	sp,sp,16
     a6c:	8082                	ret

0000000000000a6e <strchr>:

char*
strchr(const char *s, char c)
{
     a6e:	1141                	addi	sp,sp,-16
     a70:	e422                	sd	s0,8(sp)
     a72:	0800                	addi	s0,sp,16
  for(; *s; s++)
     a74:	00054783          	lbu	a5,0(a0)
     a78:	cb99                	beqz	a5,a8e <strchr+0x20>
    if(*s == c)
     a7a:	00f58763          	beq	a1,a5,a88 <strchr+0x1a>
  for(; *s; s++)
     a7e:	0505                	addi	a0,a0,1
     a80:	00054783          	lbu	a5,0(a0)
     a84:	fbfd                	bnez	a5,a7a <strchr+0xc>
      return (char*)s;
  return 0;
     a86:	4501                	li	a0,0
}
     a88:	6422                	ld	s0,8(sp)
     a8a:	0141                	addi	sp,sp,16
     a8c:	8082                	ret
  return 0;
     a8e:	4501                	li	a0,0
     a90:	bfe5                	j	a88 <strchr+0x1a>

0000000000000a92 <gets>:

char*
gets(char *buf, int max)
{
     a92:	711d                	addi	sp,sp,-96
     a94:	ec86                	sd	ra,88(sp)
     a96:	e8a2                	sd	s0,80(sp)
     a98:	e4a6                	sd	s1,72(sp)
     a9a:	e0ca                	sd	s2,64(sp)
     a9c:	fc4e                	sd	s3,56(sp)
     a9e:	f852                	sd	s4,48(sp)
     aa0:	f456                	sd	s5,40(sp)
     aa2:	f05a                	sd	s6,32(sp)
     aa4:	ec5e                	sd	s7,24(sp)
     aa6:	1080                	addi	s0,sp,96
     aa8:	8baa                	mv	s7,a0
     aaa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     aac:	892a                	mv	s2,a0
     aae:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     ab0:	4aa9                	li	s5,10
     ab2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     ab4:	89a6                	mv	s3,s1
     ab6:	2485                	addiw	s1,s1,1
     ab8:	0344d663          	bge	s1,s4,ae4 <gets+0x52>
    cc = read(0, &c, 1);
     abc:	4605                	li	a2,1
     abe:	faf40593          	addi	a1,s0,-81
     ac2:	4501                	li	a0,0
     ac4:	280000ef          	jal	d44 <read>
    if(cc < 1)
     ac8:	00a05e63          	blez	a0,ae4 <gets+0x52>
    buf[i++] = c;
     acc:	faf44783          	lbu	a5,-81(s0)
     ad0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     ad4:	01578763          	beq	a5,s5,ae2 <gets+0x50>
     ad8:	0905                	addi	s2,s2,1
     ada:	fd679de3          	bne	a5,s6,ab4 <gets+0x22>
    buf[i++] = c;
     ade:	89a6                	mv	s3,s1
     ae0:	a011                	j	ae4 <gets+0x52>
     ae2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     ae4:	99de                	add	s3,s3,s7
     ae6:	00098023          	sb	zero,0(s3)
  return buf;
}
     aea:	855e                	mv	a0,s7
     aec:	60e6                	ld	ra,88(sp)
     aee:	6446                	ld	s0,80(sp)
     af0:	64a6                	ld	s1,72(sp)
     af2:	6906                	ld	s2,64(sp)
     af4:	79e2                	ld	s3,56(sp)
     af6:	7a42                	ld	s4,48(sp)
     af8:	7aa2                	ld	s5,40(sp)
     afa:	7b02                	ld	s6,32(sp)
     afc:	6be2                	ld	s7,24(sp)
     afe:	6125                	addi	sp,sp,96
     b00:	8082                	ret

0000000000000b02 <stat>:

int
stat(const char *n, struct stat *st)
{
     b02:	1101                	addi	sp,sp,-32
     b04:	ec06                	sd	ra,24(sp)
     b06:	e822                	sd	s0,16(sp)
     b08:	e04a                	sd	s2,0(sp)
     b0a:	1000                	addi	s0,sp,32
     b0c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     b0e:	4581                	li	a1,0
     b10:	25c000ef          	jal	d6c <open>
  if(fd < 0)
     b14:	02054263          	bltz	a0,b38 <stat+0x36>
     b18:	e426                	sd	s1,8(sp)
     b1a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     b1c:	85ca                	mv	a1,s2
     b1e:	266000ef          	jal	d84 <fstat>
     b22:	892a                	mv	s2,a0
  close(fd);
     b24:	8526                	mv	a0,s1
     b26:	22e000ef          	jal	d54 <close>
  return r;
     b2a:	64a2                	ld	s1,8(sp)
}
     b2c:	854a                	mv	a0,s2
     b2e:	60e2                	ld	ra,24(sp)
     b30:	6442                	ld	s0,16(sp)
     b32:	6902                	ld	s2,0(sp)
     b34:	6105                	addi	sp,sp,32
     b36:	8082                	ret
    return -1;
     b38:	597d                	li	s2,-1
     b3a:	bfcd                	j	b2c <stat+0x2a>

0000000000000b3c <atoi>:

int
atoi(const char *s)
{
     b3c:	1141                	addi	sp,sp,-16
     b3e:	e422                	sd	s0,8(sp)
     b40:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b42:	00054683          	lbu	a3,0(a0)
     b46:	fd06879b          	addiw	a5,a3,-48
     b4a:	0ff7f793          	zext.b	a5,a5
     b4e:	4625                	li	a2,9
     b50:	02f66863          	bltu	a2,a5,b80 <atoi+0x44>
     b54:	872a                	mv	a4,a0
  n = 0;
     b56:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     b58:	0705                	addi	a4,a4,1
     b5a:	0025179b          	slliw	a5,a0,0x2
     b5e:	9fa9                	addw	a5,a5,a0
     b60:	0017979b          	slliw	a5,a5,0x1
     b64:	9fb5                	addw	a5,a5,a3
     b66:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b6a:	00074683          	lbu	a3,0(a4)
     b6e:	fd06879b          	addiw	a5,a3,-48
     b72:	0ff7f793          	zext.b	a5,a5
     b76:	fef671e3          	bgeu	a2,a5,b58 <atoi+0x1c>
  return n;
}
     b7a:	6422                	ld	s0,8(sp)
     b7c:	0141                	addi	sp,sp,16
     b7e:	8082                	ret
  n = 0;
     b80:	4501                	li	a0,0
     b82:	bfe5                	j	b7a <atoi+0x3e>

0000000000000b84 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b84:	1141                	addi	sp,sp,-16
     b86:	e422                	sd	s0,8(sp)
     b88:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b8a:	02b57463          	bgeu	a0,a1,bb2 <memmove+0x2e>
    while(n-- > 0)
     b8e:	00c05f63          	blez	a2,bac <memmove+0x28>
     b92:	1602                	slli	a2,a2,0x20
     b94:	9201                	srli	a2,a2,0x20
     b96:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     b9a:	872a                	mv	a4,a0
      *dst++ = *src++;
     b9c:	0585                	addi	a1,a1,1
     b9e:	0705                	addi	a4,a4,1
     ba0:	fff5c683          	lbu	a3,-1(a1)
     ba4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     ba8:	fef71ae3          	bne	a4,a5,b9c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     bac:	6422                	ld	s0,8(sp)
     bae:	0141                	addi	sp,sp,16
     bb0:	8082                	ret
    dst += n;
     bb2:	00c50733          	add	a4,a0,a2
    src += n;
     bb6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     bb8:	fec05ae3          	blez	a2,bac <memmove+0x28>
     bbc:	fff6079b          	addiw	a5,a2,-1
     bc0:	1782                	slli	a5,a5,0x20
     bc2:	9381                	srli	a5,a5,0x20
     bc4:	fff7c793          	not	a5,a5
     bc8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     bca:	15fd                	addi	a1,a1,-1
     bcc:	177d                	addi	a4,a4,-1
     bce:	0005c683          	lbu	a3,0(a1)
     bd2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     bd6:	fee79ae3          	bne	a5,a4,bca <memmove+0x46>
     bda:	bfc9                	j	bac <memmove+0x28>

0000000000000bdc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     bdc:	1141                	addi	sp,sp,-16
     bde:	e422                	sd	s0,8(sp)
     be0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     be2:	ca05                	beqz	a2,c12 <memcmp+0x36>
     be4:	fff6069b          	addiw	a3,a2,-1
     be8:	1682                	slli	a3,a3,0x20
     bea:	9281                	srli	a3,a3,0x20
     bec:	0685                	addi	a3,a3,1
     bee:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     bf0:	00054783          	lbu	a5,0(a0)
     bf4:	0005c703          	lbu	a4,0(a1)
     bf8:	00e79863          	bne	a5,a4,c08 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     bfc:	0505                	addi	a0,a0,1
    p2++;
     bfe:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     c00:	fed518e3          	bne	a0,a3,bf0 <memcmp+0x14>
  }
  return 0;
     c04:	4501                	li	a0,0
     c06:	a019                	j	c0c <memcmp+0x30>
      return *p1 - *p2;
     c08:	40e7853b          	subw	a0,a5,a4
}
     c0c:	6422                	ld	s0,8(sp)
     c0e:	0141                	addi	sp,sp,16
     c10:	8082                	ret
  return 0;
     c12:	4501                	li	a0,0
     c14:	bfe5                	j	c0c <memcmp+0x30>

0000000000000c16 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     c16:	1141                	addi	sp,sp,-16
     c18:	e406                	sd	ra,8(sp)
     c1a:	e022                	sd	s0,0(sp)
     c1c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     c1e:	f67ff0ef          	jal	b84 <memmove>
}
     c22:	60a2                	ld	ra,8(sp)
     c24:	6402                	ld	s0,0(sp)
     c26:	0141                	addi	sp,sp,16
     c28:	8082                	ret

0000000000000c2a <simplesort>:

void
simplesort(void *base, uint nmemb, uint size, int (*compar)(const void *, const void *))
{
     c2a:	7119                	addi	sp,sp,-128
     c2c:	fc86                	sd	ra,120(sp)
     c2e:	f8a2                	sd	s0,112(sp)
     c30:	0100                	addi	s0,sp,128
     c32:	f8b43423          	sd	a1,-120(s0)
  char *arr = (char *)base; // Treat array as char array for byte-level manipulation
  char *temp;               // Temporary storage for an element

  if (nmemb <= 1 || size == 0) {
     c36:	4785                	li	a5,1
     c38:	00b7fc63          	bgeu	a5,a1,c50 <simplesort+0x26>
     c3c:	e8d2                	sd	s4,80(sp)
     c3e:	e4d6                	sd	s5,72(sp)
     c40:	f466                	sd	s9,40(sp)
     c42:	8aaa                	mv	s5,a0
     c44:	8a32                	mv	s4,a2
     c46:	8cb6                	mv	s9,a3
     c48:	ea01                	bnez	a2,c58 <simplesort+0x2e>
     c4a:	6a46                	ld	s4,80(sp)
     c4c:	6aa6                	ld	s5,72(sp)
     c4e:	7ca2                	ld	s9,40(sp)
    // Place temp at its correct position
    memmove(arr + j * size, temp, size);
  }

  free(temp); // Free temporary space
     c50:	70e6                	ld	ra,120(sp)
     c52:	7446                	ld	s0,112(sp)
     c54:	6109                	addi	sp,sp,128
     c56:	8082                	ret
     c58:	fc5e                	sd	s7,56(sp)
     c5a:	f862                	sd	s8,48(sp)
     c5c:	f06a                	sd	s10,32(sp)
     c5e:	ec6e                	sd	s11,24(sp)
  temp = malloc(size); // Allocate temporary space for one element
     c60:	8532                	mv	a0,a2
     c62:	5de000ef          	jal	1240 <malloc>
     c66:	8baa                	mv	s7,a0
  if (temp == 0) {
     c68:	4d81                	li	s11,0
  for (uint i = 1; i < nmemb; i++) {
     c6a:	4d05                	li	s10,1
    memmove(temp, arr + i * size, size);
     c6c:	000a0c1b          	sext.w	s8,s4
  if (temp == 0) {
     c70:	c511                	beqz	a0,c7c <simplesort+0x52>
     c72:	f4a6                	sd	s1,104(sp)
     c74:	f0ca                	sd	s2,96(sp)
     c76:	ecce                	sd	s3,88(sp)
     c78:	e0da                	sd	s6,64(sp)
     c7a:	a82d                	j	cb4 <simplesort+0x8a>
    printf("simplesort: malloc failed, cannot sort\n");
     c7c:	00000517          	auipc	a0,0x0
     c80:	7d450513          	addi	a0,a0,2004 # 1450 <malloc+0x210>
     c84:	508000ef          	jal	118c <printf>
    return;
     c88:	6a46                	ld	s4,80(sp)
     c8a:	6aa6                	ld	s5,72(sp)
     c8c:	7be2                	ld	s7,56(sp)
     c8e:	7c42                	ld	s8,48(sp)
     c90:	7ca2                	ld	s9,40(sp)
     c92:	7d02                	ld	s10,32(sp)
     c94:	6de2                	ld	s11,24(sp)
     c96:	bf6d                	j	c50 <simplesort+0x26>
    memmove(arr + j * size, temp, size);
     c98:	036a053b          	mulw	a0,s4,s6
     c9c:	1502                	slli	a0,a0,0x20
     c9e:	9101                	srli	a0,a0,0x20
     ca0:	8662                	mv	a2,s8
     ca2:	85de                	mv	a1,s7
     ca4:	9556                	add	a0,a0,s5
     ca6:	edfff0ef          	jal	b84 <memmove>
  for (uint i = 1; i < nmemb; i++) {
     caa:	2d05                	addiw	s10,s10,1
     cac:	f8843783          	ld	a5,-120(s0)
     cb0:	05a78b63          	beq	a5,s10,d06 <simplesort+0xdc>
    memmove(temp, arr + i * size, size);
     cb4:	000d899b          	sext.w	s3,s11
     cb8:	01ba05bb          	addw	a1,s4,s11
     cbc:	00058d9b          	sext.w	s11,a1
     cc0:	1582                	slli	a1,a1,0x20
     cc2:	9181                	srli	a1,a1,0x20
     cc4:	8662                	mv	a2,s8
     cc6:	95d6                	add	a1,a1,s5
     cc8:	855e                	mv	a0,s7
     cca:	ebbff0ef          	jal	b84 <memmove>
    uint j = i;
     cce:	896a                	mv	s2,s10
     cd0:	00090b1b          	sext.w	s6,s2
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
     cd4:	397d                	addiw	s2,s2,-1
     cd6:	02099493          	slli	s1,s3,0x20
     cda:	9081                	srli	s1,s1,0x20
     cdc:	94d6                	add	s1,s1,s5
     cde:	85de                	mv	a1,s7
     ce0:	8526                	mv	a0,s1
     ce2:	9c82                	jalr	s9
     ce4:	faa05ae3          	blez	a0,c98 <simplesort+0x6e>
      memmove(arr + j * size, arr + (j - 1) * size, size); // Shift element
     ce8:	0149853b          	addw	a0,s3,s4
     cec:	1502                	slli	a0,a0,0x20
     cee:	9101                	srli	a0,a0,0x20
     cf0:	8662                	mv	a2,s8
     cf2:	85a6                	mv	a1,s1
     cf4:	9556                	add	a0,a0,s5
     cf6:	e8fff0ef          	jal	b84 <memmove>
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
     cfa:	414989bb          	subw	s3,s3,s4
     cfe:	fc0919e3          	bnez	s2,cd0 <simplesort+0xa6>
     d02:	8b4a                	mv	s6,s2
     d04:	bf51                	j	c98 <simplesort+0x6e>
  free(temp); // Free temporary space
     d06:	855e                	mv	a0,s7
     d08:	4b6000ef          	jal	11be <free>
     d0c:	74a6                	ld	s1,104(sp)
     d0e:	7906                	ld	s2,96(sp)
     d10:	69e6                	ld	s3,88(sp)
     d12:	6a46                	ld	s4,80(sp)
     d14:	6aa6                	ld	s5,72(sp)
     d16:	6b06                	ld	s6,64(sp)
     d18:	7be2                	ld	s7,56(sp)
     d1a:	7c42                	ld	s8,48(sp)
     d1c:	7ca2                	ld	s9,40(sp)
     d1e:	7d02                	ld	s10,32(sp)
     d20:	6de2                	ld	s11,24(sp)
     d22:	b73d                	j	c50 <simplesort+0x26>

0000000000000d24 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     d24:	4885                	li	a7,1
 ecall
     d26:	00000073          	ecall
 ret
     d2a:	8082                	ret

0000000000000d2c <exit>:
.global exit
exit:
 li a7, SYS_exit
     d2c:	4889                	li	a7,2
 ecall
     d2e:	00000073          	ecall
 ret
     d32:	8082                	ret

0000000000000d34 <wait>:
.global wait
wait:
 li a7, SYS_wait
     d34:	488d                	li	a7,3
 ecall
     d36:	00000073          	ecall
 ret
     d3a:	8082                	ret

0000000000000d3c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     d3c:	4891                	li	a7,4
 ecall
     d3e:	00000073          	ecall
 ret
     d42:	8082                	ret

0000000000000d44 <read>:
.global read
read:
 li a7, SYS_read
     d44:	4895                	li	a7,5
 ecall
     d46:	00000073          	ecall
 ret
     d4a:	8082                	ret

0000000000000d4c <write>:
.global write
write:
 li a7, SYS_write
     d4c:	48c1                	li	a7,16
 ecall
     d4e:	00000073          	ecall
 ret
     d52:	8082                	ret

0000000000000d54 <close>:
.global close
close:
 li a7, SYS_close
     d54:	48d5                	li	a7,21
 ecall
     d56:	00000073          	ecall
 ret
     d5a:	8082                	ret

0000000000000d5c <kill>:
.global kill
kill:
 li a7, SYS_kill
     d5c:	4899                	li	a7,6
 ecall
     d5e:	00000073          	ecall
 ret
     d62:	8082                	ret

0000000000000d64 <exec>:
.global exec
exec:
 li a7, SYS_exec
     d64:	489d                	li	a7,7
 ecall
     d66:	00000073          	ecall
 ret
     d6a:	8082                	ret

0000000000000d6c <open>:
.global open
open:
 li a7, SYS_open
     d6c:	48bd                	li	a7,15
 ecall
     d6e:	00000073          	ecall
 ret
     d72:	8082                	ret

0000000000000d74 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     d74:	48c5                	li	a7,17
 ecall
     d76:	00000073          	ecall
 ret
     d7a:	8082                	ret

0000000000000d7c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     d7c:	48c9                	li	a7,18
 ecall
     d7e:	00000073          	ecall
 ret
     d82:	8082                	ret

0000000000000d84 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     d84:	48a1                	li	a7,8
 ecall
     d86:	00000073          	ecall
 ret
     d8a:	8082                	ret

0000000000000d8c <link>:
.global link
link:
 li a7, SYS_link
     d8c:	48cd                	li	a7,19
 ecall
     d8e:	00000073          	ecall
 ret
     d92:	8082                	ret

0000000000000d94 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     d94:	48d1                	li	a7,20
 ecall
     d96:	00000073          	ecall
 ret
     d9a:	8082                	ret

0000000000000d9c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     d9c:	48a5                	li	a7,9
 ecall
     d9e:	00000073          	ecall
 ret
     da2:	8082                	ret

0000000000000da4 <dup>:
.global dup
dup:
 li a7, SYS_dup
     da4:	48a9                	li	a7,10
 ecall
     da6:	00000073          	ecall
 ret
     daa:	8082                	ret

0000000000000dac <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     dac:	48ad                	li	a7,11
 ecall
     dae:	00000073          	ecall
 ret
     db2:	8082                	ret

0000000000000db4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     db4:	48b1                	li	a7,12
 ecall
     db6:	00000073          	ecall
 ret
     dba:	8082                	ret

0000000000000dbc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     dbc:	48b5                	li	a7,13
 ecall
     dbe:	00000073          	ecall
 ret
     dc2:	8082                	ret

0000000000000dc4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     dc4:	48b9                	li	a7,14
 ecall
     dc6:	00000073          	ecall
 ret
     dca:	8082                	ret

0000000000000dcc <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
     dcc:	48dd                	li	a7,23
 ecall
     dce:	00000073          	ecall
 ret
     dd2:	8082                	ret

0000000000000dd4 <statistics>:
.global statistics
statistics:
 li a7, SYS_statistics
     dd4:	48e1                	li	a7,24
 ecall
     dd6:	00000073          	ecall
 ret
     dda:	8082                	ret

0000000000000ddc <reset_stats>:
.global reset_stats
reset_stats:
 li a7, SYS_reset_stats
     ddc:	48e5                	li	a7,25
 ecall
     dde:	00000073          	ecall
 ret
     de2:	8082                	ret

0000000000000de4 <resetlockstats>:
.global resetlockstats
resetlockstats:
 li a7, SYS_resetlockstats
     de4:	48e9                	li	a7,26
 ecall
     de6:	00000073          	ecall
 ret
     dea:	8082                	ret

0000000000000dec <getlockstats>:
.global getlockstats
getlockstats:
 li a7, SYS_getlockstats
     dec:	48ed                	li	a7,27
 ecall
     dee:	00000073          	ecall
 ret
     df2:	8082                	ret

0000000000000df4 <trace>:
.global trace
trace:
 li a7, SYS_trace
     df4:	48d9                	li	a7,22
 ecall
     df6:	00000073          	ecall
 ret
     dfa:	8082                	ret

0000000000000dfc <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
     dfc:	48f1                	li	a7,28
 ecall
     dfe:	00000073          	ecall
 ret
     e02:	8082                	ret

0000000000000e04 <ugetpid>:
.global ugetpid
ugetpid:
 li a7, SYS_ugetpid
     e04:	48f5                	li	a7,29
 ecall
     e06:	00000073          	ecall
 ret
     e0a:	8082                	ret

0000000000000e0c <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
     e0c:	48f9                	li	a7,30
 ecall
     e0e:	00000073          	ecall
 ret
     e12:	8082                	ret

0000000000000e14 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     e14:	1101                	addi	sp,sp,-32
     e16:	ec06                	sd	ra,24(sp)
     e18:	e822                	sd	s0,16(sp)
     e1a:	1000                	addi	s0,sp,32
     e1c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     e20:	4605                	li	a2,1
     e22:	fef40593          	addi	a1,s0,-17
     e26:	f27ff0ef          	jal	d4c <write>
}
     e2a:	60e2                	ld	ra,24(sp)
     e2c:	6442                	ld	s0,16(sp)
     e2e:	6105                	addi	sp,sp,32
     e30:	8082                	ret

0000000000000e32 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     e32:	7139                	addi	sp,sp,-64
     e34:	fc06                	sd	ra,56(sp)
     e36:	f822                	sd	s0,48(sp)
     e38:	f426                	sd	s1,40(sp)
     e3a:	0080                	addi	s0,sp,64
     e3c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     e3e:	c299                	beqz	a3,e44 <printint+0x12>
     e40:	0805c963          	bltz	a1,ed2 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     e44:	2581                	sext.w	a1,a1
  neg = 0;
     e46:	4881                	li	a7,0
     e48:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     e4c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     e4e:	2601                	sext.w	a2,a2
     e50:	00000517          	auipc	a0,0x0
     e54:	66050513          	addi	a0,a0,1632 # 14b0 <digits>
     e58:	883a                	mv	a6,a4
     e5a:	2705                	addiw	a4,a4,1
     e5c:	02c5f7bb          	remuw	a5,a1,a2
     e60:	1782                	slli	a5,a5,0x20
     e62:	9381                	srli	a5,a5,0x20
     e64:	97aa                	add	a5,a5,a0
     e66:	0007c783          	lbu	a5,0(a5)
     e6a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     e6e:	0005879b          	sext.w	a5,a1
     e72:	02c5d5bb          	divuw	a1,a1,a2
     e76:	0685                	addi	a3,a3,1
     e78:	fec7f0e3          	bgeu	a5,a2,e58 <printint+0x26>
  if(neg)
     e7c:	00088c63          	beqz	a7,e94 <printint+0x62>
    buf[i++] = '-';
     e80:	fd070793          	addi	a5,a4,-48
     e84:	00878733          	add	a4,a5,s0
     e88:	02d00793          	li	a5,45
     e8c:	fef70823          	sb	a5,-16(a4)
     e90:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     e94:	02e05a63          	blez	a4,ec8 <printint+0x96>
     e98:	f04a                	sd	s2,32(sp)
     e9a:	ec4e                	sd	s3,24(sp)
     e9c:	fc040793          	addi	a5,s0,-64
     ea0:	00e78933          	add	s2,a5,a4
     ea4:	fff78993          	addi	s3,a5,-1
     ea8:	99ba                	add	s3,s3,a4
     eaa:	377d                	addiw	a4,a4,-1
     eac:	1702                	slli	a4,a4,0x20
     eae:	9301                	srli	a4,a4,0x20
     eb0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     eb4:	fff94583          	lbu	a1,-1(s2)
     eb8:	8526                	mv	a0,s1
     eba:	f5bff0ef          	jal	e14 <putc>
  while(--i >= 0)
     ebe:	197d                	addi	s2,s2,-1
     ec0:	ff391ae3          	bne	s2,s3,eb4 <printint+0x82>
     ec4:	7902                	ld	s2,32(sp)
     ec6:	69e2                	ld	s3,24(sp)
}
     ec8:	70e2                	ld	ra,56(sp)
     eca:	7442                	ld	s0,48(sp)
     ecc:	74a2                	ld	s1,40(sp)
     ece:	6121                	addi	sp,sp,64
     ed0:	8082                	ret
    x = -xx;
     ed2:	40b005bb          	negw	a1,a1
    neg = 1;
     ed6:	4885                	li	a7,1
    x = -xx;
     ed8:	bf85                	j	e48 <printint+0x16>

0000000000000eda <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     eda:	711d                	addi	sp,sp,-96
     edc:	ec86                	sd	ra,88(sp)
     ede:	e8a2                	sd	s0,80(sp)
     ee0:	e0ca                	sd	s2,64(sp)
     ee2:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     ee4:	0005c903          	lbu	s2,0(a1)
     ee8:	26090863          	beqz	s2,1158 <vprintf+0x27e>
     eec:	e4a6                	sd	s1,72(sp)
     eee:	fc4e                	sd	s3,56(sp)
     ef0:	f852                	sd	s4,48(sp)
     ef2:	f456                	sd	s5,40(sp)
     ef4:	f05a                	sd	s6,32(sp)
     ef6:	ec5e                	sd	s7,24(sp)
     ef8:	e862                	sd	s8,16(sp)
     efa:	e466                	sd	s9,8(sp)
     efc:	8b2a                	mv	s6,a0
     efe:	8a2e                	mv	s4,a1
     f00:	8bb2                	mv	s7,a2
  state = 0;
     f02:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     f04:	4481                	li	s1,0
     f06:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     f08:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     f0c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     f10:	06c00c93          	li	s9,108
     f14:	a005                	j	f34 <vprintf+0x5a>
        putc(fd, c0);
     f16:	85ca                	mv	a1,s2
     f18:	855a                	mv	a0,s6
     f1a:	efbff0ef          	jal	e14 <putc>
     f1e:	a019                	j	f24 <vprintf+0x4a>
    } else if(state == '%'){
     f20:	03598263          	beq	s3,s5,f44 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
     f24:	2485                	addiw	s1,s1,1
     f26:	8726                	mv	a4,s1
     f28:	009a07b3          	add	a5,s4,s1
     f2c:	0007c903          	lbu	s2,0(a5)
     f30:	20090c63          	beqz	s2,1148 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
     f34:	0009079b          	sext.w	a5,s2
    if(state == 0){
     f38:	fe0994e3          	bnez	s3,f20 <vprintf+0x46>
      if(c0 == '%'){
     f3c:	fd579de3          	bne	a5,s5,f16 <vprintf+0x3c>
        state = '%';
     f40:	89be                	mv	s3,a5
     f42:	b7cd                	j	f24 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     f44:	00ea06b3          	add	a3,s4,a4
     f48:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     f4c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     f4e:	c681                	beqz	a3,f56 <vprintf+0x7c>
     f50:	9752                	add	a4,a4,s4
     f52:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     f56:	03878f63          	beq	a5,s8,f94 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
     f5a:	05978963          	beq	a5,s9,fac <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     f5e:	07500713          	li	a4,117
     f62:	0ee78363          	beq	a5,a4,1048 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     f66:	07800713          	li	a4,120
     f6a:	12e78563          	beq	a5,a4,1094 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     f6e:	07000713          	li	a4,112
     f72:	14e78a63          	beq	a5,a4,10c6 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
     f76:	07300713          	li	a4,115
     f7a:	18e78a63          	beq	a5,a4,110e <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     f7e:	02500713          	li	a4,37
     f82:	04e79563          	bne	a5,a4,fcc <vprintf+0xf2>
        putc(fd, '%');
     f86:	02500593          	li	a1,37
     f8a:	855a                	mv	a0,s6
     f8c:	e89ff0ef          	jal	e14 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     f90:	4981                	li	s3,0
     f92:	bf49                	j	f24 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     f94:	008b8913          	addi	s2,s7,8
     f98:	4685                	li	a3,1
     f9a:	4629                	li	a2,10
     f9c:	000ba583          	lw	a1,0(s7)
     fa0:	855a                	mv	a0,s6
     fa2:	e91ff0ef          	jal	e32 <printint>
     fa6:	8bca                	mv	s7,s2
      state = 0;
     fa8:	4981                	li	s3,0
     faa:	bfad                	j	f24 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
     fac:	06400793          	li	a5,100
     fb0:	02f68963          	beq	a3,a5,fe2 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     fb4:	06c00793          	li	a5,108
     fb8:	04f68263          	beq	a3,a5,ffc <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
     fbc:	07500793          	li	a5,117
     fc0:	0af68063          	beq	a3,a5,1060 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
     fc4:	07800793          	li	a5,120
     fc8:	0ef68263          	beq	a3,a5,10ac <vprintf+0x1d2>
        putc(fd, '%');
     fcc:	02500593          	li	a1,37
     fd0:	855a                	mv	a0,s6
     fd2:	e43ff0ef          	jal	e14 <putc>
        putc(fd, c0);
     fd6:	85ca                	mv	a1,s2
     fd8:	855a                	mv	a0,s6
     fda:	e3bff0ef          	jal	e14 <putc>
      state = 0;
     fde:	4981                	li	s3,0
     fe0:	b791                	j	f24 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     fe2:	008b8913          	addi	s2,s7,8
     fe6:	4685                	li	a3,1
     fe8:	4629                	li	a2,10
     fea:	000ba583          	lw	a1,0(s7)
     fee:	855a                	mv	a0,s6
     ff0:	e43ff0ef          	jal	e32 <printint>
        i += 1;
     ff4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     ff6:	8bca                	mv	s7,s2
      state = 0;
     ff8:	4981                	li	s3,0
        i += 1;
     ffa:	b72d                	j	f24 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     ffc:	06400793          	li	a5,100
    1000:	02f60763          	beq	a2,a5,102e <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    1004:	07500793          	li	a5,117
    1008:	06f60963          	beq	a2,a5,107a <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    100c:	07800793          	li	a5,120
    1010:	faf61ee3          	bne	a2,a5,fcc <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1014:	008b8913          	addi	s2,s7,8
    1018:	4681                	li	a3,0
    101a:	4641                	li	a2,16
    101c:	000ba583          	lw	a1,0(s7)
    1020:	855a                	mv	a0,s6
    1022:	e11ff0ef          	jal	e32 <printint>
        i += 2;
    1026:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    1028:	8bca                	mv	s7,s2
      state = 0;
    102a:	4981                	li	s3,0
        i += 2;
    102c:	bde5                	j	f24 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    102e:	008b8913          	addi	s2,s7,8
    1032:	4685                	li	a3,1
    1034:	4629                	li	a2,10
    1036:	000ba583          	lw	a1,0(s7)
    103a:	855a                	mv	a0,s6
    103c:	df7ff0ef          	jal	e32 <printint>
        i += 2;
    1040:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    1042:	8bca                	mv	s7,s2
      state = 0;
    1044:	4981                	li	s3,0
        i += 2;
    1046:	bdf9                	j	f24 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    1048:	008b8913          	addi	s2,s7,8
    104c:	4681                	li	a3,0
    104e:	4629                	li	a2,10
    1050:	000ba583          	lw	a1,0(s7)
    1054:	855a                	mv	a0,s6
    1056:	dddff0ef          	jal	e32 <printint>
    105a:	8bca                	mv	s7,s2
      state = 0;
    105c:	4981                	li	s3,0
    105e:	b5d9                	j	f24 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1060:	008b8913          	addi	s2,s7,8
    1064:	4681                	li	a3,0
    1066:	4629                	li	a2,10
    1068:	000ba583          	lw	a1,0(s7)
    106c:	855a                	mv	a0,s6
    106e:	dc5ff0ef          	jal	e32 <printint>
        i += 1;
    1072:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    1074:	8bca                	mv	s7,s2
      state = 0;
    1076:	4981                	li	s3,0
        i += 1;
    1078:	b575                	j	f24 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    107a:	008b8913          	addi	s2,s7,8
    107e:	4681                	li	a3,0
    1080:	4629                	li	a2,10
    1082:	000ba583          	lw	a1,0(s7)
    1086:	855a                	mv	a0,s6
    1088:	dabff0ef          	jal	e32 <printint>
        i += 2;
    108c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    108e:	8bca                	mv	s7,s2
      state = 0;
    1090:	4981                	li	s3,0
        i += 2;
    1092:	bd49                	j	f24 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    1094:	008b8913          	addi	s2,s7,8
    1098:	4681                	li	a3,0
    109a:	4641                	li	a2,16
    109c:	000ba583          	lw	a1,0(s7)
    10a0:	855a                	mv	a0,s6
    10a2:	d91ff0ef          	jal	e32 <printint>
    10a6:	8bca                	mv	s7,s2
      state = 0;
    10a8:	4981                	li	s3,0
    10aa:	bdad                	j	f24 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    10ac:	008b8913          	addi	s2,s7,8
    10b0:	4681                	li	a3,0
    10b2:	4641                	li	a2,16
    10b4:	000ba583          	lw	a1,0(s7)
    10b8:	855a                	mv	a0,s6
    10ba:	d79ff0ef          	jal	e32 <printint>
        i += 1;
    10be:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    10c0:	8bca                	mv	s7,s2
      state = 0;
    10c2:	4981                	li	s3,0
        i += 1;
    10c4:	b585                	j	f24 <vprintf+0x4a>
    10c6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    10c8:	008b8d13          	addi	s10,s7,8
    10cc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    10d0:	03000593          	li	a1,48
    10d4:	855a                	mv	a0,s6
    10d6:	d3fff0ef          	jal	e14 <putc>
  putc(fd, 'x');
    10da:	07800593          	li	a1,120
    10de:	855a                	mv	a0,s6
    10e0:	d35ff0ef          	jal	e14 <putc>
    10e4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    10e6:	00000b97          	auipc	s7,0x0
    10ea:	3cab8b93          	addi	s7,s7,970 # 14b0 <digits>
    10ee:	03c9d793          	srli	a5,s3,0x3c
    10f2:	97de                	add	a5,a5,s7
    10f4:	0007c583          	lbu	a1,0(a5)
    10f8:	855a                	mv	a0,s6
    10fa:	d1bff0ef          	jal	e14 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    10fe:	0992                	slli	s3,s3,0x4
    1100:	397d                	addiw	s2,s2,-1
    1102:	fe0916e3          	bnez	s2,10ee <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    1106:	8bea                	mv	s7,s10
      state = 0;
    1108:	4981                	li	s3,0
    110a:	6d02                	ld	s10,0(sp)
    110c:	bd21                	j	f24 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    110e:	008b8993          	addi	s3,s7,8
    1112:	000bb903          	ld	s2,0(s7)
    1116:	00090f63          	beqz	s2,1134 <vprintf+0x25a>
        for(; *s; s++)
    111a:	00094583          	lbu	a1,0(s2)
    111e:	c195                	beqz	a1,1142 <vprintf+0x268>
          putc(fd, *s);
    1120:	855a                	mv	a0,s6
    1122:	cf3ff0ef          	jal	e14 <putc>
        for(; *s; s++)
    1126:	0905                	addi	s2,s2,1
    1128:	00094583          	lbu	a1,0(s2)
    112c:	f9f5                	bnez	a1,1120 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    112e:	8bce                	mv	s7,s3
      state = 0;
    1130:	4981                	li	s3,0
    1132:	bbcd                	j	f24 <vprintf+0x4a>
          s = "(null)";
    1134:	00000917          	auipc	s2,0x0
    1138:	34490913          	addi	s2,s2,836 # 1478 <malloc+0x238>
        for(; *s; s++)
    113c:	02800593          	li	a1,40
    1140:	b7c5                	j	1120 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    1142:	8bce                	mv	s7,s3
      state = 0;
    1144:	4981                	li	s3,0
    1146:	bbf9                	j	f24 <vprintf+0x4a>
    1148:	64a6                	ld	s1,72(sp)
    114a:	79e2                	ld	s3,56(sp)
    114c:	7a42                	ld	s4,48(sp)
    114e:	7aa2                	ld	s5,40(sp)
    1150:	7b02                	ld	s6,32(sp)
    1152:	6be2                	ld	s7,24(sp)
    1154:	6c42                	ld	s8,16(sp)
    1156:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1158:	60e6                	ld	ra,88(sp)
    115a:	6446                	ld	s0,80(sp)
    115c:	6906                	ld	s2,64(sp)
    115e:	6125                	addi	sp,sp,96
    1160:	8082                	ret

0000000000001162 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1162:	715d                	addi	sp,sp,-80
    1164:	ec06                	sd	ra,24(sp)
    1166:	e822                	sd	s0,16(sp)
    1168:	1000                	addi	s0,sp,32
    116a:	e010                	sd	a2,0(s0)
    116c:	e414                	sd	a3,8(s0)
    116e:	e818                	sd	a4,16(s0)
    1170:	ec1c                	sd	a5,24(s0)
    1172:	03043023          	sd	a6,32(s0)
    1176:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    117a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    117e:	8622                	mv	a2,s0
    1180:	d5bff0ef          	jal	eda <vprintf>
}
    1184:	60e2                	ld	ra,24(sp)
    1186:	6442                	ld	s0,16(sp)
    1188:	6161                	addi	sp,sp,80
    118a:	8082                	ret

000000000000118c <printf>:

void
printf(const char *fmt, ...)
{
    118c:	711d                	addi	sp,sp,-96
    118e:	ec06                	sd	ra,24(sp)
    1190:	e822                	sd	s0,16(sp)
    1192:	1000                	addi	s0,sp,32
    1194:	e40c                	sd	a1,8(s0)
    1196:	e810                	sd	a2,16(s0)
    1198:	ec14                	sd	a3,24(s0)
    119a:	f018                	sd	a4,32(s0)
    119c:	f41c                	sd	a5,40(s0)
    119e:	03043823          	sd	a6,48(s0)
    11a2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    11a6:	00840613          	addi	a2,s0,8
    11aa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    11ae:	85aa                	mv	a1,a0
    11b0:	4505                	li	a0,1
    11b2:	d29ff0ef          	jal	eda <vprintf>
}
    11b6:	60e2                	ld	ra,24(sp)
    11b8:	6442                	ld	s0,16(sp)
    11ba:	6125                	addi	sp,sp,96
    11bc:	8082                	ret

00000000000011be <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11be:	1141                	addi	sp,sp,-16
    11c0:	e422                	sd	s0,8(sp)
    11c2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11c4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11c8:	00001797          	auipc	a5,0x1
    11cc:	e487b783          	ld	a5,-440(a5) # 2010 <freep>
    11d0:	a02d                	j	11fa <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    11d2:	4618                	lw	a4,8(a2)
    11d4:	9f2d                	addw	a4,a4,a1
    11d6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    11da:	6398                	ld	a4,0(a5)
    11dc:	6310                	ld	a2,0(a4)
    11de:	a83d                	j	121c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    11e0:	ff852703          	lw	a4,-8(a0)
    11e4:	9f31                	addw	a4,a4,a2
    11e6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    11e8:	ff053683          	ld	a3,-16(a0)
    11ec:	a091                	j	1230 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11ee:	6398                	ld	a4,0(a5)
    11f0:	00e7e463          	bltu	a5,a4,11f8 <free+0x3a>
    11f4:	00e6ea63          	bltu	a3,a4,1208 <free+0x4a>
{
    11f8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11fa:	fed7fae3          	bgeu	a5,a3,11ee <free+0x30>
    11fe:	6398                	ld	a4,0(a5)
    1200:	00e6e463          	bltu	a3,a4,1208 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1204:	fee7eae3          	bltu	a5,a4,11f8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1208:	ff852583          	lw	a1,-8(a0)
    120c:	6390                	ld	a2,0(a5)
    120e:	02059813          	slli	a6,a1,0x20
    1212:	01c85713          	srli	a4,a6,0x1c
    1216:	9736                	add	a4,a4,a3
    1218:	fae60de3          	beq	a2,a4,11d2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    121c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1220:	4790                	lw	a2,8(a5)
    1222:	02061593          	slli	a1,a2,0x20
    1226:	01c5d713          	srli	a4,a1,0x1c
    122a:	973e                	add	a4,a4,a5
    122c:	fae68ae3          	beq	a3,a4,11e0 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1230:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1232:	00001717          	auipc	a4,0x1
    1236:	dcf73f23          	sd	a5,-546(a4) # 2010 <freep>
}
    123a:	6422                	ld	s0,8(sp)
    123c:	0141                	addi	sp,sp,16
    123e:	8082                	ret

0000000000001240 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1240:	7139                	addi	sp,sp,-64
    1242:	fc06                	sd	ra,56(sp)
    1244:	f822                	sd	s0,48(sp)
    1246:	f426                	sd	s1,40(sp)
    1248:	ec4e                	sd	s3,24(sp)
    124a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    124c:	02051493          	slli	s1,a0,0x20
    1250:	9081                	srli	s1,s1,0x20
    1252:	04bd                	addi	s1,s1,15
    1254:	8091                	srli	s1,s1,0x4
    1256:	0014899b          	addiw	s3,s1,1
    125a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    125c:	00001517          	auipc	a0,0x1
    1260:	db453503          	ld	a0,-588(a0) # 2010 <freep>
    1264:	c915                	beqz	a0,1298 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1266:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1268:	4798                	lw	a4,8(a5)
    126a:	08977a63          	bgeu	a4,s1,12fe <malloc+0xbe>
    126e:	f04a                	sd	s2,32(sp)
    1270:	e852                	sd	s4,16(sp)
    1272:	e456                	sd	s5,8(sp)
    1274:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1276:	8a4e                	mv	s4,s3
    1278:	0009871b          	sext.w	a4,s3
    127c:	6685                	lui	a3,0x1
    127e:	00d77363          	bgeu	a4,a3,1284 <malloc+0x44>
    1282:	6a05                	lui	s4,0x1
    1284:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1288:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    128c:	00001917          	auipc	s2,0x1
    1290:	d8490913          	addi	s2,s2,-636 # 2010 <freep>
  if(p == (char*)-1)
    1294:	5afd                	li	s5,-1
    1296:	a081                	j	12d6 <malloc+0x96>
    1298:	f04a                	sd	s2,32(sp)
    129a:	e852                	sd	s4,16(sp)
    129c:	e456                	sd	s5,8(sp)
    129e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    12a0:	00001797          	auipc	a5,0x1
    12a4:	de878793          	addi	a5,a5,-536 # 2088 <base>
    12a8:	00001717          	auipc	a4,0x1
    12ac:	d6f73423          	sd	a5,-664(a4) # 2010 <freep>
    12b0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    12b2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    12b6:	b7c1                	j	1276 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    12b8:	6398                	ld	a4,0(a5)
    12ba:	e118                	sd	a4,0(a0)
    12bc:	a8a9                	j	1316 <malloc+0xd6>
  hp->s.size = nu;
    12be:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    12c2:	0541                	addi	a0,a0,16
    12c4:	efbff0ef          	jal	11be <free>
  return freep;
    12c8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    12cc:	c12d                	beqz	a0,132e <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12d0:	4798                	lw	a4,8(a5)
    12d2:	02977263          	bgeu	a4,s1,12f6 <malloc+0xb6>
    if(p == freep)
    12d6:	00093703          	ld	a4,0(s2)
    12da:	853e                	mv	a0,a5
    12dc:	fef719e3          	bne	a4,a5,12ce <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    12e0:	8552                	mv	a0,s4
    12e2:	ad3ff0ef          	jal	db4 <sbrk>
  if(p == (char*)-1)
    12e6:	fd551ce3          	bne	a0,s5,12be <malloc+0x7e>
        return 0;
    12ea:	4501                	li	a0,0
    12ec:	7902                	ld	s2,32(sp)
    12ee:	6a42                	ld	s4,16(sp)
    12f0:	6aa2                	ld	s5,8(sp)
    12f2:	6b02                	ld	s6,0(sp)
    12f4:	a03d                	j	1322 <malloc+0xe2>
    12f6:	7902                	ld	s2,32(sp)
    12f8:	6a42                	ld	s4,16(sp)
    12fa:	6aa2                	ld	s5,8(sp)
    12fc:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    12fe:	fae48de3          	beq	s1,a4,12b8 <malloc+0x78>
        p->s.size -= nunits;
    1302:	4137073b          	subw	a4,a4,s3
    1306:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1308:	02071693          	slli	a3,a4,0x20
    130c:	01c6d713          	srli	a4,a3,0x1c
    1310:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1312:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1316:	00001717          	auipc	a4,0x1
    131a:	cea73d23          	sd	a0,-774(a4) # 2010 <freep>
      return (void*)(p + 1);
    131e:	01078513          	addi	a0,a5,16
  }
}
    1322:	70e2                	ld	ra,56(sp)
    1324:	7442                	ld	s0,48(sp)
    1326:	74a2                	ld	s1,40(sp)
    1328:	69e2                	ld	s3,24(sp)
    132a:	6121                	addi	sp,sp,64
    132c:	8082                	ret
    132e:	7902                	ld	s2,32(sp)
    1330:	6a42                	ld	s4,16(sp)
    1332:	6aa2                	ld	s5,8(sp)
    1334:	6b02                	ld	s6,0(sp)
    1336:	b7f5                	j	1322 <malloc+0xe2>
