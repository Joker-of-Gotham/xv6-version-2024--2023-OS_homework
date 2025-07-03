
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	45013103          	ld	sp,1104(sp) # 8000a450 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	659040ef          	jal	80004e6e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00028797          	auipc	a5,0x28
    80000034:	7a078793          	addi	a5,a5,1952 # 800287d0 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	106000ef          	jal	8000014e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	0000a917          	auipc	s2,0xa
    80000050:	45490913          	addi	s2,s2,1108 # 8000a4a0 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	07b050ef          	jal	800058d0 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	103050ef          	jal	80005968 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80007000 <etext>
    8000007e:	524050ef          	jal	800055a2 <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008c:	6785                	lui	a5,0x1
    8000008e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000092:	00e504b3          	add	s1,a0,a4
    80000096:	777d                	lui	a4,0xfffff
    80000098:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009a:	94be                	add	s1,s1,a5
    8000009c:	0295e263          	bltu	a1,s1,800000c0 <freerange+0x3e>
    800000a0:	e84a                	sd	s2,16(sp)
    800000a2:	e44e                	sd	s3,8(sp)
    800000a4:	e052                	sd	s4,0(sp)
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	6985                	lui	s3,0x1
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b4:	94ce                	add	s1,s1,s3
    800000b6:	fe997be3          	bgeu	s2,s1,800000ac <freerange+0x2a>
    800000ba:	6942                	ld	s2,16(sp)
    800000bc:	69a2                	ld	s3,8(sp)
    800000be:	6a02                	ld	s4,0(sp)
}
    800000c0:	70a2                	ld	ra,40(sp)
    800000c2:	7402                	ld	s0,32(sp)
    800000c4:	64e2                	ld	s1,24(sp)
    800000c6:	6145                	addi	sp,sp,48
    800000c8:	8082                	ret

00000000800000ca <kinit>:
{
    800000ca:	1141                	addi	sp,sp,-16
    800000cc:	e406                	sd	ra,8(sp)
    800000ce:	e022                	sd	s0,0(sp)
    800000d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d2:	00007597          	auipc	a1,0x7
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80007010 <etext+0x10>
    800000da:	0000a517          	auipc	a0,0xa
    800000de:	3c650513          	addi	a0,a0,966 # 8000a4a0 <kmem>
    800000e2:	76e050ef          	jal	80005850 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00028517          	auipc	a0,0x28
    800000ee:	6e650513          	addi	a0,a0,1766 # 800287d0 <end>
    800000f2:	f91ff0ef          	jal	80000082 <freerange>
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fe:	1101                	addi	sp,sp,-32
    80000100:	ec06                	sd	ra,24(sp)
    80000102:	e822                	sd	s0,16(sp)
    80000104:	e426                	sd	s1,8(sp)
    80000106:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000108:	0000a497          	auipc	s1,0xa
    8000010c:	39848493          	addi	s1,s1,920 # 8000a4a0 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	7be050ef          	jal	800058d0 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	38450513          	addi	a0,a0,900 # 8000a4a0 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	043050ef          	jal	80005968 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	01e000ef          	jal	8000014e <memset>
  return (void*)r;
}
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	0000a517          	auipc	a0,0xa
    80000144:	36050513          	addi	a0,a0,864 # 8000a4a0 <kmem>
    80000148:	021050ef          	jal	80005968 <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000014e:	1141                	addi	sp,sp,-16
    80000150:	e422                	sd	s0,8(sp)
    80000152:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000154:	ca19                	beqz	a2,8000016a <memset+0x1c>
    80000156:	87aa                	mv	a5,a0
    80000158:	1602                	slli	a2,a2,0x20
    8000015a:	9201                	srli	a2,a2,0x20
    8000015c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000160:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000164:	0785                	addi	a5,a5,1
    80000166:	fee79de3          	bne	a5,a4,80000160 <memset+0x12>
  }
  return dst;
}
    8000016a:	6422                	ld	s0,8(sp)
    8000016c:	0141                	addi	sp,sp,16
    8000016e:	8082                	ret

0000000080000170 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000170:	1141                	addi	sp,sp,-16
    80000172:	e422                	sd	s0,8(sp)
    80000174:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000176:	ca05                	beqz	a2,800001a6 <memcmp+0x36>
    80000178:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    8000017c:	1682                	slli	a3,a3,0x20
    8000017e:	9281                	srli	a3,a3,0x20
    80000180:	0685                	addi	a3,a3,1
    80000182:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000184:	00054783          	lbu	a5,0(a0)
    80000188:	0005c703          	lbu	a4,0(a1)
    8000018c:	00e79863          	bne	a5,a4,8000019c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000190:	0505                	addi	a0,a0,1
    80000192:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000194:	fed518e3          	bne	a0,a3,80000184 <memcmp+0x14>
  }

  return 0;
    80000198:	4501                	li	a0,0
    8000019a:	a019                	j	800001a0 <memcmp+0x30>
      return *s1 - *s2;
    8000019c:	40e7853b          	subw	a0,a5,a4
}
    800001a0:	6422                	ld	s0,8(sp)
    800001a2:	0141                	addi	sp,sp,16
    800001a4:	8082                	ret
  return 0;
    800001a6:	4501                	li	a0,0
    800001a8:	bfe5                	j	800001a0 <memcmp+0x30>

00000000800001aa <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001aa:	1141                	addi	sp,sp,-16
    800001ac:	e422                	sd	s0,8(sp)
    800001ae:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001b0:	c205                	beqz	a2,800001d0 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001b2:	02a5e263          	bltu	a1,a0,800001d6 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001b6:	1602                	slli	a2,a2,0x20
    800001b8:	9201                	srli	a2,a2,0x20
    800001ba:	00c587b3          	add	a5,a1,a2
{
    800001be:	872a                	mv	a4,a0
      *d++ = *s++;
    800001c0:	0585                	addi	a1,a1,1
    800001c2:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd6831>
    800001c4:	fff5c683          	lbu	a3,-1(a1)
    800001c8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001cc:	feb79ae3          	bne	a5,a1,800001c0 <memmove+0x16>

  return dst;
}
    800001d0:	6422                	ld	s0,8(sp)
    800001d2:	0141                	addi	sp,sp,16
    800001d4:	8082                	ret
  if(s < d && s + n > d){
    800001d6:	02061693          	slli	a3,a2,0x20
    800001da:	9281                	srli	a3,a3,0x20
    800001dc:	00d58733          	add	a4,a1,a3
    800001e0:	fce57be3          	bgeu	a0,a4,800001b6 <memmove+0xc>
    d += n;
    800001e4:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001e6:	fff6079b          	addiw	a5,a2,-1
    800001ea:	1782                	slli	a5,a5,0x20
    800001ec:	9381                	srli	a5,a5,0x20
    800001ee:	fff7c793          	not	a5,a5
    800001f2:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001f4:	177d                	addi	a4,a4,-1
    800001f6:	16fd                	addi	a3,a3,-1
    800001f8:	00074603          	lbu	a2,0(a4)
    800001fc:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000200:	fef71ae3          	bne	a4,a5,800001f4 <memmove+0x4a>
    80000204:	b7f1                	j	800001d0 <memmove+0x26>

0000000080000206 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000206:	1141                	addi	sp,sp,-16
    80000208:	e406                	sd	ra,8(sp)
    8000020a:	e022                	sd	s0,0(sp)
    8000020c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000020e:	f9dff0ef          	jal	800001aa <memmove>
}
    80000212:	60a2                	ld	ra,8(sp)
    80000214:	6402                	ld	s0,0(sp)
    80000216:	0141                	addi	sp,sp,16
    80000218:	8082                	ret

000000008000021a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000021a:	1141                	addi	sp,sp,-16
    8000021c:	e422                	sd	s0,8(sp)
    8000021e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000220:	ce11                	beqz	a2,8000023c <strncmp+0x22>
    80000222:	00054783          	lbu	a5,0(a0)
    80000226:	cf89                	beqz	a5,80000240 <strncmp+0x26>
    80000228:	0005c703          	lbu	a4,0(a1)
    8000022c:	00f71a63          	bne	a4,a5,80000240 <strncmp+0x26>
    n--, p++, q++;
    80000230:	367d                	addiw	a2,a2,-1
    80000232:	0505                	addi	a0,a0,1
    80000234:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000236:	f675                	bnez	a2,80000222 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000238:	4501                	li	a0,0
    8000023a:	a801                	j	8000024a <strncmp+0x30>
    8000023c:	4501                	li	a0,0
    8000023e:	a031                	j	8000024a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000240:	00054503          	lbu	a0,0(a0)
    80000244:	0005c783          	lbu	a5,0(a1)
    80000248:	9d1d                	subw	a0,a0,a5
}
    8000024a:	6422                	ld	s0,8(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000256:	87aa                	mv	a5,a0
    80000258:	86b2                	mv	a3,a2
    8000025a:	367d                	addiw	a2,a2,-1
    8000025c:	02d05563          	blez	a3,80000286 <strncpy+0x36>
    80000260:	0785                	addi	a5,a5,1
    80000262:	0005c703          	lbu	a4,0(a1)
    80000266:	fee78fa3          	sb	a4,-1(a5)
    8000026a:	0585                	addi	a1,a1,1
    8000026c:	f775                	bnez	a4,80000258 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000026e:	873e                	mv	a4,a5
    80000270:	9fb5                	addw	a5,a5,a3
    80000272:	37fd                	addiw	a5,a5,-1
    80000274:	00c05963          	blez	a2,80000286 <strncpy+0x36>
    *s++ = 0;
    80000278:	0705                	addi	a4,a4,1
    8000027a:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    8000027e:	40e786bb          	subw	a3,a5,a4
    80000282:	fed04be3          	bgtz	a3,80000278 <strncpy+0x28>
  return os;
}
    80000286:	6422                	ld	s0,8(sp)
    80000288:	0141                	addi	sp,sp,16
    8000028a:	8082                	ret

000000008000028c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000292:	02c05363          	blez	a2,800002b8 <safestrcpy+0x2c>
    80000296:	fff6069b          	addiw	a3,a2,-1
    8000029a:	1682                	slli	a3,a3,0x20
    8000029c:	9281                	srli	a3,a3,0x20
    8000029e:	96ae                	add	a3,a3,a1
    800002a0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002a2:	00d58963          	beq	a1,a3,800002b4 <safestrcpy+0x28>
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	0785                	addi	a5,a5,1
    800002aa:	fff5c703          	lbu	a4,-1(a1)
    800002ae:	fee78fa3          	sb	a4,-1(a5)
    800002b2:	fb65                	bnez	a4,800002a2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002b4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002b8:	6422                	ld	s0,8(sp)
    800002ba:	0141                	addi	sp,sp,16
    800002bc:	8082                	ret

00000000800002be <strlen>:

int
strlen(const char *s)
{
    800002be:	1141                	addi	sp,sp,-16
    800002c0:	e422                	sd	s0,8(sp)
    800002c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002c4:	00054783          	lbu	a5,0(a0)
    800002c8:	cf91                	beqz	a5,800002e4 <strlen+0x26>
    800002ca:	0505                	addi	a0,a0,1
    800002cc:	87aa                	mv	a5,a0
    800002ce:	86be                	mv	a3,a5
    800002d0:	0785                	addi	a5,a5,1
    800002d2:	fff7c703          	lbu	a4,-1(a5)
    800002d6:	ff65                	bnez	a4,800002ce <strlen+0x10>
    800002d8:	40a6853b          	subw	a0,a3,a0
    800002dc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002de:	6422                	ld	s0,8(sp)
    800002e0:	0141                	addi	sp,sp,16
    800002e2:	8082                	ret
  for(n = 0; s[n]; n++)
    800002e4:	4501                	li	a0,0
    800002e6:	bfe5                	j	800002de <strlen+0x20>

00000000800002e8 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002e8:	1141                	addi	sp,sp,-16
    800002ea:	e406                	sd	ra,8(sp)
    800002ec:	e022                	sd	s0,0(sp)
    800002ee:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800002f0:	23f000ef          	jal	80000d2e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800002f4:	0000a717          	auipc	a4,0xa
    800002f8:	17c70713          	addi	a4,a4,380 # 8000a470 <started>
  if(cpuid() == 0){
    800002fc:	c51d                	beqz	a0,8000032a <main+0x42>
    while(started == 0)
    800002fe:	431c                	lw	a5,0(a4)
    80000300:	2781                	sext.w	a5,a5
    80000302:	dff5                	beqz	a5,800002fe <main+0x16>
      ;
    __sync_synchronize();
    80000304:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000308:	227000ef          	jal	80000d2e <cpuid>
    8000030c:	85aa                	mv	a1,a0
    8000030e:	00007517          	auipc	a0,0x7
    80000312:	d2a50513          	addi	a0,a0,-726 # 80007038 <etext+0x38>
    80000316:	7bb040ef          	jal	800052d0 <printf>
    kvminithart();    // turn on paging
    8000031a:	080000ef          	jal	8000039a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000031e:	57c010ef          	jal	8000189a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000322:	566040ef          	jal	80004888 <plicinithart>
  }

  scheduler();        
    80000326:	681000ef          	jal	800011a6 <scheduler>
    consoleinit();
    8000032a:	6d1040ef          	jal	800051fa <consoleinit>
    printfinit();
    8000032e:	2ae050ef          	jal	800055dc <printfinit>
    printf("\n");
    80000332:	00007517          	auipc	a0,0x7
    80000336:	ce650513          	addi	a0,a0,-794 # 80007018 <etext+0x18>
    8000033a:	797040ef          	jal	800052d0 <printf>
    printf("xv6 kernel is booting\n");
    8000033e:	00007517          	auipc	a0,0x7
    80000342:	ce250513          	addi	a0,a0,-798 # 80007020 <etext+0x20>
    80000346:	78b040ef          	jal	800052d0 <printf>
    printf("\n");
    8000034a:	00007517          	auipc	a0,0x7
    8000034e:	cce50513          	addi	a0,a0,-818 # 80007018 <etext+0x18>
    80000352:	77f040ef          	jal	800052d0 <printf>
    kinit();         // physical page allocator
    80000356:	d75ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    8000035a:	2ca000ef          	jal	80000624 <kvminit>
    kvminithart();   // turn on paging
    8000035e:	03c000ef          	jal	8000039a <kvminithart>
    procinit();      // process table
    80000362:	11d000ef          	jal	80000c7e <procinit>
    trapinit();      // trap vectors
    80000366:	510010ef          	jal	80001876 <trapinit>
    trapinithart();  // install kernel trap vector
    8000036a:	530010ef          	jal	8000189a <trapinithart>
    plicinit();      // set up interrupt controller
    8000036e:	500040ef          	jal	8000486e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000372:	516040ef          	jal	80004888 <plicinithart>
    binit();         // buffer cache
    80000376:	4c5010ef          	jal	8000203a <binit>
    iinit();         // inode table
    8000037a:	2b6020ef          	jal	80002630 <iinit>
    fileinit();      // file table
    8000037e:	062030ef          	jal	800033e0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000382:	5f6040ef          	jal	80004978 <virtio_disk_init>
    userinit();      // first user process
    80000386:	44d000ef          	jal	80000fd2 <userinit>
    __sync_synchronize();
    8000038a:	0330000f          	fence	rw,rw
    started = 1;
    8000038e:	4785                	li	a5,1
    80000390:	0000a717          	auipc	a4,0xa
    80000394:	0ef72023          	sw	a5,224(a4) # 8000a470 <started>
    80000398:	b779                	j	80000326 <main+0x3e>

000000008000039a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000039a:	1141                	addi	sp,sp,-16
    8000039c:	e422                	sd	s0,8(sp)
    8000039e:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003a0:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003a4:	0000a797          	auipc	a5,0xa
    800003a8:	0d47b783          	ld	a5,212(a5) # 8000a478 <kernel_pagetable>
    800003ac:	83b1                	srli	a5,a5,0xc
    800003ae:	577d                	li	a4,-1
    800003b0:	177e                	slli	a4,a4,0x3f
    800003b2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003b4:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003b8:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003bc:	6422                	ld	s0,8(sp)
    800003be:	0141                	addi	sp,sp,16
    800003c0:	8082                	ret

00000000800003c2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003c2:	7139                	addi	sp,sp,-64
    800003c4:	fc06                	sd	ra,56(sp)
    800003c6:	f822                	sd	s0,48(sp)
    800003c8:	f426                	sd	s1,40(sp)
    800003ca:	f04a                	sd	s2,32(sp)
    800003cc:	ec4e                	sd	s3,24(sp)
    800003ce:	e852                	sd	s4,16(sp)
    800003d0:	e456                	sd	s5,8(sp)
    800003d2:	e05a                	sd	s6,0(sp)
    800003d4:	0080                	addi	s0,sp,64
    800003d6:	84aa                	mv	s1,a0
    800003d8:	89ae                	mv	s3,a1
    800003da:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003dc:	57fd                	li	a5,-1
    800003de:	83e9                	srli	a5,a5,0x1a
    800003e0:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800003e2:	4b31                	li	s6,12
  if(va >= MAXVA)
    800003e4:	02b7fc63          	bgeu	a5,a1,8000041c <walk+0x5a>
    panic("walk");
    800003e8:	00007517          	auipc	a0,0x7
    800003ec:	c6850513          	addi	a0,a0,-920 # 80007050 <etext+0x50>
    800003f0:	1b2050ef          	jal	800055a2 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800003f4:	060a8263          	beqz	s5,80000458 <walk+0x96>
    800003f8:	d07ff0ef          	jal	800000fe <kalloc>
    800003fc:	84aa                	mv	s1,a0
    800003fe:	c139                	beqz	a0,80000444 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000400:	6605                	lui	a2,0x1
    80000402:	4581                	li	a1,0
    80000404:	d4bff0ef          	jal	8000014e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000408:	00c4d793          	srli	a5,s1,0xc
    8000040c:	07aa                	slli	a5,a5,0xa
    8000040e:	0017e793          	ori	a5,a5,1
    80000412:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000416:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd6827>
    80000418:	036a0063          	beq	s4,s6,80000438 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    8000041c:	0149d933          	srl	s2,s3,s4
    80000420:	1ff97913          	andi	s2,s2,511
    80000424:	090e                	slli	s2,s2,0x3
    80000426:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000428:	00093483          	ld	s1,0(s2)
    8000042c:	0014f793          	andi	a5,s1,1
    80000430:	d3f1                	beqz	a5,800003f4 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000432:	80a9                	srli	s1,s1,0xa
    80000434:	04b2                	slli	s1,s1,0xc
    80000436:	b7c5                	j	80000416 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000438:	00c9d513          	srli	a0,s3,0xc
    8000043c:	1ff57513          	andi	a0,a0,511
    80000440:	050e                	slli	a0,a0,0x3
    80000442:	9526                	add	a0,a0,s1
}
    80000444:	70e2                	ld	ra,56(sp)
    80000446:	7442                	ld	s0,48(sp)
    80000448:	74a2                	ld	s1,40(sp)
    8000044a:	7902                	ld	s2,32(sp)
    8000044c:	69e2                	ld	s3,24(sp)
    8000044e:	6a42                	ld	s4,16(sp)
    80000450:	6aa2                	ld	s5,8(sp)
    80000452:	6b02                	ld	s6,0(sp)
    80000454:	6121                	addi	sp,sp,64
    80000456:	8082                	ret
        return 0;
    80000458:	4501                	li	a0,0
    8000045a:	b7ed                	j	80000444 <walk+0x82>

000000008000045c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000045c:	57fd                	li	a5,-1
    8000045e:	83e9                	srli	a5,a5,0x1a
    80000460:	00b7f463          	bgeu	a5,a1,80000468 <walkaddr+0xc>
    return 0;
    80000464:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000466:	8082                	ret
{
    80000468:	1141                	addi	sp,sp,-16
    8000046a:	e406                	sd	ra,8(sp)
    8000046c:	e022                	sd	s0,0(sp)
    8000046e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000470:	4601                	li	a2,0
    80000472:	f51ff0ef          	jal	800003c2 <walk>
  if(pte == 0)
    80000476:	c105                	beqz	a0,80000496 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000478:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000047a:	0117f693          	andi	a3,a5,17
    8000047e:	4745                	li	a4,17
    return 0;
    80000480:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000482:	00e68663          	beq	a3,a4,8000048e <walkaddr+0x32>
}
    80000486:	60a2                	ld	ra,8(sp)
    80000488:	6402                	ld	s0,0(sp)
    8000048a:	0141                	addi	sp,sp,16
    8000048c:	8082                	ret
  pa = PTE2PA(*pte);
    8000048e:	83a9                	srli	a5,a5,0xa
    80000490:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000494:	bfcd                	j	80000486 <walkaddr+0x2a>
    return 0;
    80000496:	4501                	li	a0,0
    80000498:	b7fd                	j	80000486 <walkaddr+0x2a>

000000008000049a <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000049a:	715d                	addi	sp,sp,-80
    8000049c:	e486                	sd	ra,72(sp)
    8000049e:	e0a2                	sd	s0,64(sp)
    800004a0:	fc26                	sd	s1,56(sp)
    800004a2:	f84a                	sd	s2,48(sp)
    800004a4:	f44e                	sd	s3,40(sp)
    800004a6:	f052                	sd	s4,32(sp)
    800004a8:	ec56                	sd	s5,24(sp)
    800004aa:	e85a                	sd	s6,16(sp)
    800004ac:	e45e                	sd	s7,8(sp)
    800004ae:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004b0:	03459793          	slli	a5,a1,0x34
    800004b4:	e7a9                	bnez	a5,800004fe <mappages+0x64>
    800004b6:	8aaa                	mv	s5,a0
    800004b8:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004ba:	03461793          	slli	a5,a2,0x34
    800004be:	e7b1                	bnez	a5,8000050a <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    800004c0:	ca39                	beqz	a2,80000516 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004c2:	77fd                	lui	a5,0xfffff
    800004c4:	963e                	add	a2,a2,a5
    800004c6:	00b609b3          	add	s3,a2,a1
  a = va;
    800004ca:	892e                	mv	s2,a1
    800004cc:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004d0:	6b85                	lui	s7,0x1
    800004d2:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004d6:	4605                	li	a2,1
    800004d8:	85ca                	mv	a1,s2
    800004da:	8556                	mv	a0,s5
    800004dc:	ee7ff0ef          	jal	800003c2 <walk>
    800004e0:	c539                	beqz	a0,8000052e <mappages+0x94>
    if(*pte & PTE_V)
    800004e2:	611c                	ld	a5,0(a0)
    800004e4:	8b85                	andi	a5,a5,1
    800004e6:	ef95                	bnez	a5,80000522 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800004e8:	80b1                	srli	s1,s1,0xc
    800004ea:	04aa                	slli	s1,s1,0xa
    800004ec:	0164e4b3          	or	s1,s1,s6
    800004f0:	0014e493          	ori	s1,s1,1
    800004f4:	e104                	sd	s1,0(a0)
    if(a == last)
    800004f6:	05390863          	beq	s2,s3,80000546 <mappages+0xac>
    a += PGSIZE;
    800004fa:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800004fc:	bfd9                	j	800004d2 <mappages+0x38>
    panic("mappages: va not aligned");
    800004fe:	00007517          	auipc	a0,0x7
    80000502:	b5a50513          	addi	a0,a0,-1190 # 80007058 <etext+0x58>
    80000506:	09c050ef          	jal	800055a2 <panic>
    panic("mappages: size not aligned");
    8000050a:	00007517          	auipc	a0,0x7
    8000050e:	b6e50513          	addi	a0,a0,-1170 # 80007078 <etext+0x78>
    80000512:	090050ef          	jal	800055a2 <panic>
    panic("mappages: size");
    80000516:	00007517          	auipc	a0,0x7
    8000051a:	b8250513          	addi	a0,a0,-1150 # 80007098 <etext+0x98>
    8000051e:	084050ef          	jal	800055a2 <panic>
      panic("mappages: remap");
    80000522:	00007517          	auipc	a0,0x7
    80000526:	b8650513          	addi	a0,a0,-1146 # 800070a8 <etext+0xa8>
    8000052a:	078050ef          	jal	800055a2 <panic>
      return -1;
    8000052e:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000530:	60a6                	ld	ra,72(sp)
    80000532:	6406                	ld	s0,64(sp)
    80000534:	74e2                	ld	s1,56(sp)
    80000536:	7942                	ld	s2,48(sp)
    80000538:	79a2                	ld	s3,40(sp)
    8000053a:	7a02                	ld	s4,32(sp)
    8000053c:	6ae2                	ld	s5,24(sp)
    8000053e:	6b42                	ld	s6,16(sp)
    80000540:	6ba2                	ld	s7,8(sp)
    80000542:	6161                	addi	sp,sp,80
    80000544:	8082                	ret
  return 0;
    80000546:	4501                	li	a0,0
    80000548:	b7e5                	j	80000530 <mappages+0x96>

000000008000054a <kvmmap>:
{
    8000054a:	1141                	addi	sp,sp,-16
    8000054c:	e406                	sd	ra,8(sp)
    8000054e:	e022                	sd	s0,0(sp)
    80000550:	0800                	addi	s0,sp,16
    80000552:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000554:	86b2                	mv	a3,a2
    80000556:	863e                	mv	a2,a5
    80000558:	f43ff0ef          	jal	8000049a <mappages>
    8000055c:	e509                	bnez	a0,80000566 <kvmmap+0x1c>
}
    8000055e:	60a2                	ld	ra,8(sp)
    80000560:	6402                	ld	s0,0(sp)
    80000562:	0141                	addi	sp,sp,16
    80000564:	8082                	ret
    panic("kvmmap");
    80000566:	00007517          	auipc	a0,0x7
    8000056a:	b5250513          	addi	a0,a0,-1198 # 800070b8 <etext+0xb8>
    8000056e:	034050ef          	jal	800055a2 <panic>

0000000080000572 <kvmmake>:
{
    80000572:	1101                	addi	sp,sp,-32
    80000574:	ec06                	sd	ra,24(sp)
    80000576:	e822                	sd	s0,16(sp)
    80000578:	e426                	sd	s1,8(sp)
    8000057a:	e04a                	sd	s2,0(sp)
    8000057c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000057e:	b81ff0ef          	jal	800000fe <kalloc>
    80000582:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000584:	6605                	lui	a2,0x1
    80000586:	4581                	li	a1,0
    80000588:	bc7ff0ef          	jal	8000014e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000058c:	4719                	li	a4,6
    8000058e:	6685                	lui	a3,0x1
    80000590:	10000637          	lui	a2,0x10000
    80000594:	100005b7          	lui	a1,0x10000
    80000598:	8526                	mv	a0,s1
    8000059a:	fb1ff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000059e:	4719                	li	a4,6
    800005a0:	6685                	lui	a3,0x1
    800005a2:	10001637          	lui	a2,0x10001
    800005a6:	100015b7          	lui	a1,0x10001
    800005aa:	8526                	mv	a0,s1
    800005ac:	f9fff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005b0:	4719                	li	a4,6
    800005b2:	040006b7          	lui	a3,0x4000
    800005b6:	0c000637          	lui	a2,0xc000
    800005ba:	0c0005b7          	lui	a1,0xc000
    800005be:	8526                	mv	a0,s1
    800005c0:	f8bff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005c4:	00007917          	auipc	s2,0x7
    800005c8:	a3c90913          	addi	s2,s2,-1476 # 80007000 <etext>
    800005cc:	4729                	li	a4,10
    800005ce:	80007697          	auipc	a3,0x80007
    800005d2:	a3268693          	addi	a3,a3,-1486 # 7000 <_entry-0x7fff9000>
    800005d6:	4605                	li	a2,1
    800005d8:	067e                	slli	a2,a2,0x1f
    800005da:	85b2                	mv	a1,a2
    800005dc:	8526                	mv	a0,s1
    800005de:	f6dff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800005e2:	46c5                	li	a3,17
    800005e4:	06ee                	slli	a3,a3,0x1b
    800005e6:	4719                	li	a4,6
    800005e8:	412686b3          	sub	a3,a3,s2
    800005ec:	864a                	mv	a2,s2
    800005ee:	85ca                	mv	a1,s2
    800005f0:	8526                	mv	a0,s1
    800005f2:	f59ff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800005f6:	4729                	li	a4,10
    800005f8:	6685                	lui	a3,0x1
    800005fa:	00006617          	auipc	a2,0x6
    800005fe:	a0660613          	addi	a2,a2,-1530 # 80006000 <_trampoline>
    80000602:	040005b7          	lui	a1,0x4000
    80000606:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000608:	05b2                	slli	a1,a1,0xc
    8000060a:	8526                	mv	a0,s1
    8000060c:	f3fff0ef          	jal	8000054a <kvmmap>
  proc_mapstacks(kpgtbl);
    80000610:	8526                	mv	a0,s1
    80000612:	5da000ef          	jal	80000bec <proc_mapstacks>
}
    80000616:	8526                	mv	a0,s1
    80000618:	60e2                	ld	ra,24(sp)
    8000061a:	6442                	ld	s0,16(sp)
    8000061c:	64a2                	ld	s1,8(sp)
    8000061e:	6902                	ld	s2,0(sp)
    80000620:	6105                	addi	sp,sp,32
    80000622:	8082                	ret

0000000080000624 <kvminit>:
{
    80000624:	1141                	addi	sp,sp,-16
    80000626:	e406                	sd	ra,8(sp)
    80000628:	e022                	sd	s0,0(sp)
    8000062a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000062c:	f47ff0ef          	jal	80000572 <kvmmake>
    80000630:	0000a797          	auipc	a5,0xa
    80000634:	e4a7b423          	sd	a0,-440(a5) # 8000a478 <kernel_pagetable>
}
    80000638:	60a2                	ld	ra,8(sp)
    8000063a:	6402                	ld	s0,0(sp)
    8000063c:	0141                	addi	sp,sp,16
    8000063e:	8082                	ret

0000000080000640 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000640:	715d                	addi	sp,sp,-80
    80000642:	e486                	sd	ra,72(sp)
    80000644:	e0a2                	sd	s0,64(sp)
    80000646:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000648:	03459793          	slli	a5,a1,0x34
    8000064c:	e39d                	bnez	a5,80000672 <uvmunmap+0x32>
    8000064e:	f84a                	sd	s2,48(sp)
    80000650:	f44e                	sd	s3,40(sp)
    80000652:	f052                	sd	s4,32(sp)
    80000654:	ec56                	sd	s5,24(sp)
    80000656:	e85a                	sd	s6,16(sp)
    80000658:	e45e                	sd	s7,8(sp)
    8000065a:	8a2a                	mv	s4,a0
    8000065c:	892e                	mv	s2,a1
    8000065e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000660:	0632                	slli	a2,a2,0xc
    80000662:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000666:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000668:	6b05                	lui	s6,0x1
    8000066a:	0735ff63          	bgeu	a1,s3,800006e8 <uvmunmap+0xa8>
    8000066e:	fc26                	sd	s1,56(sp)
    80000670:	a0a9                	j	800006ba <uvmunmap+0x7a>
    80000672:	fc26                	sd	s1,56(sp)
    80000674:	f84a                	sd	s2,48(sp)
    80000676:	f44e                	sd	s3,40(sp)
    80000678:	f052                	sd	s4,32(sp)
    8000067a:	ec56                	sd	s5,24(sp)
    8000067c:	e85a                	sd	s6,16(sp)
    8000067e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000680:	00007517          	auipc	a0,0x7
    80000684:	a4050513          	addi	a0,a0,-1472 # 800070c0 <etext+0xc0>
    80000688:	71b040ef          	jal	800055a2 <panic>
      panic("uvmunmap: walk");
    8000068c:	00007517          	auipc	a0,0x7
    80000690:	a4c50513          	addi	a0,a0,-1460 # 800070d8 <etext+0xd8>
    80000694:	70f040ef          	jal	800055a2 <panic>
      panic("uvmunmap: not mapped");
    80000698:	00007517          	auipc	a0,0x7
    8000069c:	a5050513          	addi	a0,a0,-1456 # 800070e8 <etext+0xe8>
    800006a0:	703040ef          	jal	800055a2 <panic>
      panic("uvmunmap: not a leaf");
    800006a4:	00007517          	auipc	a0,0x7
    800006a8:	a5c50513          	addi	a0,a0,-1444 # 80007100 <etext+0x100>
    800006ac:	6f7040ef          	jal	800055a2 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006b0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006b4:	995a                	add	s2,s2,s6
    800006b6:	03397863          	bgeu	s2,s3,800006e6 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006ba:	4601                	li	a2,0
    800006bc:	85ca                	mv	a1,s2
    800006be:	8552                	mv	a0,s4
    800006c0:	d03ff0ef          	jal	800003c2 <walk>
    800006c4:	84aa                	mv	s1,a0
    800006c6:	d179                	beqz	a0,8000068c <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    800006c8:	6108                	ld	a0,0(a0)
    800006ca:	00157793          	andi	a5,a0,1
    800006ce:	d7e9                	beqz	a5,80000698 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006d0:	3ff57793          	andi	a5,a0,1023
    800006d4:	fd7788e3          	beq	a5,s7,800006a4 <uvmunmap+0x64>
    if(do_free){
    800006d8:	fc0a8ce3          	beqz	s5,800006b0 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    800006dc:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800006de:	0532                	slli	a0,a0,0xc
    800006e0:	93dff0ef          	jal	8000001c <kfree>
    800006e4:	b7f1                	j	800006b0 <uvmunmap+0x70>
    800006e6:	74e2                	ld	s1,56(sp)
    800006e8:	7942                	ld	s2,48(sp)
    800006ea:	79a2                	ld	s3,40(sp)
    800006ec:	7a02                	ld	s4,32(sp)
    800006ee:	6ae2                	ld	s5,24(sp)
    800006f0:	6b42                	ld	s6,16(sp)
    800006f2:	6ba2                	ld	s7,8(sp)
  }
}
    800006f4:	60a6                	ld	ra,72(sp)
    800006f6:	6406                	ld	s0,64(sp)
    800006f8:	6161                	addi	sp,sp,80
    800006fa:	8082                	ret

00000000800006fc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800006fc:	1101                	addi	sp,sp,-32
    800006fe:	ec06                	sd	ra,24(sp)
    80000700:	e822                	sd	s0,16(sp)
    80000702:	e426                	sd	s1,8(sp)
    80000704:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000706:	9f9ff0ef          	jal	800000fe <kalloc>
    8000070a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000070c:	c509                	beqz	a0,80000716 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000070e:	6605                	lui	a2,0x1
    80000710:	4581                	li	a1,0
    80000712:	a3dff0ef          	jal	8000014e <memset>
  return pagetable;
}
    80000716:	8526                	mv	a0,s1
    80000718:	60e2                	ld	ra,24(sp)
    8000071a:	6442                	ld	s0,16(sp)
    8000071c:	64a2                	ld	s1,8(sp)
    8000071e:	6105                	addi	sp,sp,32
    80000720:	8082                	ret

0000000080000722 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000722:	7179                	addi	sp,sp,-48
    80000724:	f406                	sd	ra,40(sp)
    80000726:	f022                	sd	s0,32(sp)
    80000728:	ec26                	sd	s1,24(sp)
    8000072a:	e84a                	sd	s2,16(sp)
    8000072c:	e44e                	sd	s3,8(sp)
    8000072e:	e052                	sd	s4,0(sp)
    80000730:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000732:	6785                	lui	a5,0x1
    80000734:	04f67063          	bgeu	a2,a5,80000774 <uvmfirst+0x52>
    80000738:	8a2a                	mv	s4,a0
    8000073a:	89ae                	mv	s3,a1
    8000073c:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000073e:	9c1ff0ef          	jal	800000fe <kalloc>
    80000742:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000744:	6605                	lui	a2,0x1
    80000746:	4581                	li	a1,0
    80000748:	a07ff0ef          	jal	8000014e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000074c:	4779                	li	a4,30
    8000074e:	86ca                	mv	a3,s2
    80000750:	6605                	lui	a2,0x1
    80000752:	4581                	li	a1,0
    80000754:	8552                	mv	a0,s4
    80000756:	d45ff0ef          	jal	8000049a <mappages>
  memmove(mem, src, sz);
    8000075a:	8626                	mv	a2,s1
    8000075c:	85ce                	mv	a1,s3
    8000075e:	854a                	mv	a0,s2
    80000760:	a4bff0ef          	jal	800001aa <memmove>
}
    80000764:	70a2                	ld	ra,40(sp)
    80000766:	7402                	ld	s0,32(sp)
    80000768:	64e2                	ld	s1,24(sp)
    8000076a:	6942                	ld	s2,16(sp)
    8000076c:	69a2                	ld	s3,8(sp)
    8000076e:	6a02                	ld	s4,0(sp)
    80000770:	6145                	addi	sp,sp,48
    80000772:	8082                	ret
    panic("uvmfirst: more than a page");
    80000774:	00007517          	auipc	a0,0x7
    80000778:	9a450513          	addi	a0,a0,-1628 # 80007118 <etext+0x118>
    8000077c:	627040ef          	jal	800055a2 <panic>

0000000080000780 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000780:	1101                	addi	sp,sp,-32
    80000782:	ec06                	sd	ra,24(sp)
    80000784:	e822                	sd	s0,16(sp)
    80000786:	e426                	sd	s1,8(sp)
    80000788:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000078a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000078c:	00b67d63          	bgeu	a2,a1,800007a6 <uvmdealloc+0x26>
    80000790:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000792:	6785                	lui	a5,0x1
    80000794:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000796:	00f60733          	add	a4,a2,a5
    8000079a:	76fd                	lui	a3,0xfffff
    8000079c:	8f75                	and	a4,a4,a3
    8000079e:	97ae                	add	a5,a5,a1
    800007a0:	8ff5                	and	a5,a5,a3
    800007a2:	00f76863          	bltu	a4,a5,800007b2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800007a6:	8526                	mv	a0,s1
    800007a8:	60e2                	ld	ra,24(sp)
    800007aa:	6442                	ld	s0,16(sp)
    800007ac:	64a2                	ld	s1,8(sp)
    800007ae:	6105                	addi	sp,sp,32
    800007b0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007b2:	8f99                	sub	a5,a5,a4
    800007b4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007b6:	4685                	li	a3,1
    800007b8:	0007861b          	sext.w	a2,a5
    800007bc:	85ba                	mv	a1,a4
    800007be:	e83ff0ef          	jal	80000640 <uvmunmap>
    800007c2:	b7d5                	j	800007a6 <uvmdealloc+0x26>

00000000800007c4 <uvmalloc>:
  if(newsz < oldsz)
    800007c4:	08b66f63          	bltu	a2,a1,80000862 <uvmalloc+0x9e>
{
    800007c8:	7139                	addi	sp,sp,-64
    800007ca:	fc06                	sd	ra,56(sp)
    800007cc:	f822                	sd	s0,48(sp)
    800007ce:	ec4e                	sd	s3,24(sp)
    800007d0:	e852                	sd	s4,16(sp)
    800007d2:	e456                	sd	s5,8(sp)
    800007d4:	0080                	addi	s0,sp,64
    800007d6:	8aaa                	mv	s5,a0
    800007d8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800007da:	6785                	lui	a5,0x1
    800007dc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007de:	95be                	add	a1,a1,a5
    800007e0:	77fd                	lui	a5,0xfffff
    800007e2:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800007e6:	08c9f063          	bgeu	s3,a2,80000866 <uvmalloc+0xa2>
    800007ea:	f426                	sd	s1,40(sp)
    800007ec:	f04a                	sd	s2,32(sp)
    800007ee:	e05a                	sd	s6,0(sp)
    800007f0:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007f2:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800007f6:	909ff0ef          	jal	800000fe <kalloc>
    800007fa:	84aa                	mv	s1,a0
    if(mem == 0){
    800007fc:	c515                	beqz	a0,80000828 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800007fe:	6605                	lui	a2,0x1
    80000800:	4581                	li	a1,0
    80000802:	94dff0ef          	jal	8000014e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000806:	875a                	mv	a4,s6
    80000808:	86a6                	mv	a3,s1
    8000080a:	6605                	lui	a2,0x1
    8000080c:	85ca                	mv	a1,s2
    8000080e:	8556                	mv	a0,s5
    80000810:	c8bff0ef          	jal	8000049a <mappages>
    80000814:	e915                	bnez	a0,80000848 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000816:	6785                	lui	a5,0x1
    80000818:	993e                	add	s2,s2,a5
    8000081a:	fd496ee3          	bltu	s2,s4,800007f6 <uvmalloc+0x32>
  return newsz;
    8000081e:	8552                	mv	a0,s4
    80000820:	74a2                	ld	s1,40(sp)
    80000822:	7902                	ld	s2,32(sp)
    80000824:	6b02                	ld	s6,0(sp)
    80000826:	a811                	j	8000083a <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    80000828:	864e                	mv	a2,s3
    8000082a:	85ca                	mv	a1,s2
    8000082c:	8556                	mv	a0,s5
    8000082e:	f53ff0ef          	jal	80000780 <uvmdealloc>
      return 0;
    80000832:	4501                	li	a0,0
    80000834:	74a2                	ld	s1,40(sp)
    80000836:	7902                	ld	s2,32(sp)
    80000838:	6b02                	ld	s6,0(sp)
}
    8000083a:	70e2                	ld	ra,56(sp)
    8000083c:	7442                	ld	s0,48(sp)
    8000083e:	69e2                	ld	s3,24(sp)
    80000840:	6a42                	ld	s4,16(sp)
    80000842:	6aa2                	ld	s5,8(sp)
    80000844:	6121                	addi	sp,sp,64
    80000846:	8082                	ret
      kfree(mem);
    80000848:	8526                	mv	a0,s1
    8000084a:	fd2ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000084e:	864e                	mv	a2,s3
    80000850:	85ca                	mv	a1,s2
    80000852:	8556                	mv	a0,s5
    80000854:	f2dff0ef          	jal	80000780 <uvmdealloc>
      return 0;
    80000858:	4501                	li	a0,0
    8000085a:	74a2                	ld	s1,40(sp)
    8000085c:	7902                	ld	s2,32(sp)
    8000085e:	6b02                	ld	s6,0(sp)
    80000860:	bfe9                	j	8000083a <uvmalloc+0x76>
    return oldsz;
    80000862:	852e                	mv	a0,a1
}
    80000864:	8082                	ret
  return newsz;
    80000866:	8532                	mv	a0,a2
    80000868:	bfc9                	j	8000083a <uvmalloc+0x76>

000000008000086a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000086a:	7179                	addi	sp,sp,-48
    8000086c:	f406                	sd	ra,40(sp)
    8000086e:	f022                	sd	s0,32(sp)
    80000870:	ec26                	sd	s1,24(sp)
    80000872:	e84a                	sd	s2,16(sp)
    80000874:	e44e                	sd	s3,8(sp)
    80000876:	e052                	sd	s4,0(sp)
    80000878:	1800                	addi	s0,sp,48
    8000087a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000087c:	84aa                	mv	s1,a0
    8000087e:	6905                	lui	s2,0x1
    80000880:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000882:	4985                	li	s3,1
    80000884:	a819                	j	8000089a <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000886:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000888:	00c79513          	slli	a0,a5,0xc
    8000088c:	fdfff0ef          	jal	8000086a <freewalk>
      pagetable[i] = 0;
    80000890:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000894:	04a1                	addi	s1,s1,8
    80000896:	01248f63          	beq	s1,s2,800008b4 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    8000089a:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000089c:	00f7f713          	andi	a4,a5,15
    800008a0:	ff3703e3          	beq	a4,s3,80000886 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800008a4:	8b85                	andi	a5,a5,1
    800008a6:	d7fd                	beqz	a5,80000894 <freewalk+0x2a>
      panic("freewalk: leaf");
    800008a8:	00007517          	auipc	a0,0x7
    800008ac:	89050513          	addi	a0,a0,-1904 # 80007138 <etext+0x138>
    800008b0:	4f3040ef          	jal	800055a2 <panic>
    }
  }
  kfree((void*)pagetable);
    800008b4:	8552                	mv	a0,s4
    800008b6:	f66ff0ef          	jal	8000001c <kfree>
}
    800008ba:	70a2                	ld	ra,40(sp)
    800008bc:	7402                	ld	s0,32(sp)
    800008be:	64e2                	ld	s1,24(sp)
    800008c0:	6942                	ld	s2,16(sp)
    800008c2:	69a2                	ld	s3,8(sp)
    800008c4:	6a02                	ld	s4,0(sp)
    800008c6:	6145                	addi	sp,sp,48
    800008c8:	8082                	ret

00000000800008ca <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008ca:	1101                	addi	sp,sp,-32
    800008cc:	ec06                	sd	ra,24(sp)
    800008ce:	e822                	sd	s0,16(sp)
    800008d0:	e426                	sd	s1,8(sp)
    800008d2:	1000                	addi	s0,sp,32
    800008d4:	84aa                	mv	s1,a0
  if(sz > 0)
    800008d6:	e989                	bnez	a1,800008e8 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800008d8:	8526                	mv	a0,s1
    800008da:	f91ff0ef          	jal	8000086a <freewalk>
}
    800008de:	60e2                	ld	ra,24(sp)
    800008e0:	6442                	ld	s0,16(sp)
    800008e2:	64a2                	ld	s1,8(sp)
    800008e4:	6105                	addi	sp,sp,32
    800008e6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800008e8:	6785                	lui	a5,0x1
    800008ea:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008ec:	95be                	add	a1,a1,a5
    800008ee:	4685                	li	a3,1
    800008f0:	00c5d613          	srli	a2,a1,0xc
    800008f4:	4581                	li	a1,0
    800008f6:	d4bff0ef          	jal	80000640 <uvmunmap>
    800008fa:	bff9                	j	800008d8 <uvmfree+0xe>

00000000800008fc <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800008fc:	c65d                	beqz	a2,800009aa <uvmcopy+0xae>
{
    800008fe:	715d                	addi	sp,sp,-80
    80000900:	e486                	sd	ra,72(sp)
    80000902:	e0a2                	sd	s0,64(sp)
    80000904:	fc26                	sd	s1,56(sp)
    80000906:	f84a                	sd	s2,48(sp)
    80000908:	f44e                	sd	s3,40(sp)
    8000090a:	f052                	sd	s4,32(sp)
    8000090c:	ec56                	sd	s5,24(sp)
    8000090e:	e85a                	sd	s6,16(sp)
    80000910:	e45e                	sd	s7,8(sp)
    80000912:	0880                	addi	s0,sp,80
    80000914:	8b2a                	mv	s6,a0
    80000916:	8aae                	mv	s5,a1
    80000918:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000091a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000091c:	4601                	li	a2,0
    8000091e:	85ce                	mv	a1,s3
    80000920:	855a                	mv	a0,s6
    80000922:	aa1ff0ef          	jal	800003c2 <walk>
    80000926:	c121                	beqz	a0,80000966 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000928:	6118                	ld	a4,0(a0)
    8000092a:	00177793          	andi	a5,a4,1
    8000092e:	c3b1                	beqz	a5,80000972 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000930:	00a75593          	srli	a1,a4,0xa
    80000934:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000938:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000093c:	fc2ff0ef          	jal	800000fe <kalloc>
    80000940:	892a                	mv	s2,a0
    80000942:	c129                	beqz	a0,80000984 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000944:	6605                	lui	a2,0x1
    80000946:	85de                	mv	a1,s7
    80000948:	863ff0ef          	jal	800001aa <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000094c:	8726                	mv	a4,s1
    8000094e:	86ca                	mv	a3,s2
    80000950:	6605                	lui	a2,0x1
    80000952:	85ce                	mv	a1,s3
    80000954:	8556                	mv	a0,s5
    80000956:	b45ff0ef          	jal	8000049a <mappages>
    8000095a:	e115                	bnez	a0,8000097e <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    8000095c:	6785                	lui	a5,0x1
    8000095e:	99be                	add	s3,s3,a5
    80000960:	fb49eee3          	bltu	s3,s4,8000091c <uvmcopy+0x20>
    80000964:	a805                	j	80000994 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80000966:	00006517          	auipc	a0,0x6
    8000096a:	7e250513          	addi	a0,a0,2018 # 80007148 <etext+0x148>
    8000096e:	435040ef          	jal	800055a2 <panic>
      panic("uvmcopy: page not present");
    80000972:	00006517          	auipc	a0,0x6
    80000976:	7f650513          	addi	a0,a0,2038 # 80007168 <etext+0x168>
    8000097a:	429040ef          	jal	800055a2 <panic>
      kfree(mem);
    8000097e:	854a                	mv	a0,s2
    80000980:	e9cff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000984:	4685                	li	a3,1
    80000986:	00c9d613          	srli	a2,s3,0xc
    8000098a:	4581                	li	a1,0
    8000098c:	8556                	mv	a0,s5
    8000098e:	cb3ff0ef          	jal	80000640 <uvmunmap>
  return -1;
    80000992:	557d                	li	a0,-1
}
    80000994:	60a6                	ld	ra,72(sp)
    80000996:	6406                	ld	s0,64(sp)
    80000998:	74e2                	ld	s1,56(sp)
    8000099a:	7942                	ld	s2,48(sp)
    8000099c:	79a2                	ld	s3,40(sp)
    8000099e:	7a02                	ld	s4,32(sp)
    800009a0:	6ae2                	ld	s5,24(sp)
    800009a2:	6b42                	ld	s6,16(sp)
    800009a4:	6ba2                	ld	s7,8(sp)
    800009a6:	6161                	addi	sp,sp,80
    800009a8:	8082                	ret
  return 0;
    800009aa:	4501                	li	a0,0
}
    800009ac:	8082                	ret

00000000800009ae <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800009ae:	1141                	addi	sp,sp,-16
    800009b0:	e406                	sd	ra,8(sp)
    800009b2:	e022                	sd	s0,0(sp)
    800009b4:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009b6:	4601                	li	a2,0
    800009b8:	a0bff0ef          	jal	800003c2 <walk>
  if(pte == 0)
    800009bc:	c901                	beqz	a0,800009cc <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800009be:	611c                	ld	a5,0(a0)
    800009c0:	9bbd                	andi	a5,a5,-17
    800009c2:	e11c                	sd	a5,0(a0)
}
    800009c4:	60a2                	ld	ra,8(sp)
    800009c6:	6402                	ld	s0,0(sp)
    800009c8:	0141                	addi	sp,sp,16
    800009ca:	8082                	ret
    panic("uvmclear");
    800009cc:	00006517          	auipc	a0,0x6
    800009d0:	7bc50513          	addi	a0,a0,1980 # 80007188 <etext+0x188>
    800009d4:	3cf040ef          	jal	800055a2 <panic>

00000000800009d8 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    800009d8:	cad1                	beqz	a3,80000a6c <copyout+0x94>
{
    800009da:	711d                	addi	sp,sp,-96
    800009dc:	ec86                	sd	ra,88(sp)
    800009de:	e8a2                	sd	s0,80(sp)
    800009e0:	e4a6                	sd	s1,72(sp)
    800009e2:	fc4e                	sd	s3,56(sp)
    800009e4:	f456                	sd	s5,40(sp)
    800009e6:	f05a                	sd	s6,32(sp)
    800009e8:	ec5e                	sd	s7,24(sp)
    800009ea:	1080                	addi	s0,sp,96
    800009ec:	8baa                	mv	s7,a0
    800009ee:	8aae                	mv	s5,a1
    800009f0:	8b32                	mv	s6,a2
    800009f2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800009f4:	74fd                	lui	s1,0xfffff
    800009f6:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    800009f8:	57fd                	li	a5,-1
    800009fa:	83e9                	srli	a5,a5,0x1a
    800009fc:	0697ea63          	bltu	a5,s1,80000a70 <copyout+0x98>
    80000a00:	e0ca                	sd	s2,64(sp)
    80000a02:	f852                	sd	s4,48(sp)
    80000a04:	e862                	sd	s8,16(sp)
    80000a06:	e466                	sd	s9,8(sp)
    80000a08:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a0a:	4cd5                	li	s9,21
    80000a0c:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000a0e:	8c3e                	mv	s8,a5
    80000a10:	a025                	j	80000a38 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000a12:	83a9                	srli	a5,a5,0xa
    80000a14:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a16:	409a8533          	sub	a0,s5,s1
    80000a1a:	0009061b          	sext.w	a2,s2
    80000a1e:	85da                	mv	a1,s6
    80000a20:	953e                	add	a0,a0,a5
    80000a22:	f88ff0ef          	jal	800001aa <memmove>

    len -= n;
    80000a26:	412989b3          	sub	s3,s3,s2
    src += n;
    80000a2a:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000a2c:	02098963          	beqz	s3,80000a5e <copyout+0x86>
    if(va0 >= MAXVA)
    80000a30:	054c6263          	bltu	s8,s4,80000a74 <copyout+0x9c>
    80000a34:	84d2                	mv	s1,s4
    80000a36:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000a38:	4601                	li	a2,0
    80000a3a:	85a6                	mv	a1,s1
    80000a3c:	855e                	mv	a0,s7
    80000a3e:	985ff0ef          	jal	800003c2 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a42:	c121                	beqz	a0,80000a82 <copyout+0xaa>
    80000a44:	611c                	ld	a5,0(a0)
    80000a46:	0157f713          	andi	a4,a5,21
    80000a4a:	05971b63          	bne	a4,s9,80000aa0 <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    80000a4e:	01a48a33          	add	s4,s1,s10
    80000a52:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000a56:	fb29fee3          	bgeu	s3,s2,80000a12 <copyout+0x3a>
    80000a5a:	894e                	mv	s2,s3
    80000a5c:	bf5d                	j	80000a12 <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000a5e:	4501                	li	a0,0
    80000a60:	6906                	ld	s2,64(sp)
    80000a62:	7a42                	ld	s4,48(sp)
    80000a64:	6c42                	ld	s8,16(sp)
    80000a66:	6ca2                	ld	s9,8(sp)
    80000a68:	6d02                	ld	s10,0(sp)
    80000a6a:	a015                	j	80000a8e <copyout+0xb6>
    80000a6c:	4501                	li	a0,0
}
    80000a6e:	8082                	ret
      return -1;
    80000a70:	557d                	li	a0,-1
    80000a72:	a831                	j	80000a8e <copyout+0xb6>
    80000a74:	557d                	li	a0,-1
    80000a76:	6906                	ld	s2,64(sp)
    80000a78:	7a42                	ld	s4,48(sp)
    80000a7a:	6c42                	ld	s8,16(sp)
    80000a7c:	6ca2                	ld	s9,8(sp)
    80000a7e:	6d02                	ld	s10,0(sp)
    80000a80:	a039                	j	80000a8e <copyout+0xb6>
      return -1;
    80000a82:	557d                	li	a0,-1
    80000a84:	6906                	ld	s2,64(sp)
    80000a86:	7a42                	ld	s4,48(sp)
    80000a88:	6c42                	ld	s8,16(sp)
    80000a8a:	6ca2                	ld	s9,8(sp)
    80000a8c:	6d02                	ld	s10,0(sp)
}
    80000a8e:	60e6                	ld	ra,88(sp)
    80000a90:	6446                	ld	s0,80(sp)
    80000a92:	64a6                	ld	s1,72(sp)
    80000a94:	79e2                	ld	s3,56(sp)
    80000a96:	7aa2                	ld	s5,40(sp)
    80000a98:	7b02                	ld	s6,32(sp)
    80000a9a:	6be2                	ld	s7,24(sp)
    80000a9c:	6125                	addi	sp,sp,96
    80000a9e:	8082                	ret
      return -1;
    80000aa0:	557d                	li	a0,-1
    80000aa2:	6906                	ld	s2,64(sp)
    80000aa4:	7a42                	ld	s4,48(sp)
    80000aa6:	6c42                	ld	s8,16(sp)
    80000aa8:	6ca2                	ld	s9,8(sp)
    80000aaa:	6d02                	ld	s10,0(sp)
    80000aac:	b7cd                	j	80000a8e <copyout+0xb6>

0000000080000aae <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000aae:	c6a5                	beqz	a3,80000b16 <copyin+0x68>
{
    80000ab0:	715d                	addi	sp,sp,-80
    80000ab2:	e486                	sd	ra,72(sp)
    80000ab4:	e0a2                	sd	s0,64(sp)
    80000ab6:	fc26                	sd	s1,56(sp)
    80000ab8:	f84a                	sd	s2,48(sp)
    80000aba:	f44e                	sd	s3,40(sp)
    80000abc:	f052                	sd	s4,32(sp)
    80000abe:	ec56                	sd	s5,24(sp)
    80000ac0:	e85a                	sd	s6,16(sp)
    80000ac2:	e45e                	sd	s7,8(sp)
    80000ac4:	e062                	sd	s8,0(sp)
    80000ac6:	0880                	addi	s0,sp,80
    80000ac8:	8b2a                	mv	s6,a0
    80000aca:	8a2e                	mv	s4,a1
    80000acc:	8c32                	mv	s8,a2
    80000ace:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000ad0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ad2:	6a85                	lui	s5,0x1
    80000ad4:	a00d                	j	80000af6 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ad6:	018505b3          	add	a1,a0,s8
    80000ada:	0004861b          	sext.w	a2,s1
    80000ade:	412585b3          	sub	a1,a1,s2
    80000ae2:	8552                	mv	a0,s4
    80000ae4:	ec6ff0ef          	jal	800001aa <memmove>

    len -= n;
    80000ae8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000aec:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000aee:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000af2:	02098063          	beqz	s3,80000b12 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000af6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000afa:	85ca                	mv	a1,s2
    80000afc:	855a                	mv	a0,s6
    80000afe:	95fff0ef          	jal	8000045c <walkaddr>
    if(pa0 == 0)
    80000b02:	cd01                	beqz	a0,80000b1a <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000b04:	418904b3          	sub	s1,s2,s8
    80000b08:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b0a:	fc99f6e3          	bgeu	s3,s1,80000ad6 <copyin+0x28>
    80000b0e:	84ce                	mv	s1,s3
    80000b10:	b7d9                	j	80000ad6 <copyin+0x28>
  }
  return 0;
    80000b12:	4501                	li	a0,0
    80000b14:	a021                	j	80000b1c <copyin+0x6e>
    80000b16:	4501                	li	a0,0
}
    80000b18:	8082                	ret
      return -1;
    80000b1a:	557d                	li	a0,-1
}
    80000b1c:	60a6                	ld	ra,72(sp)
    80000b1e:	6406                	ld	s0,64(sp)
    80000b20:	74e2                	ld	s1,56(sp)
    80000b22:	7942                	ld	s2,48(sp)
    80000b24:	79a2                	ld	s3,40(sp)
    80000b26:	7a02                	ld	s4,32(sp)
    80000b28:	6ae2                	ld	s5,24(sp)
    80000b2a:	6b42                	ld	s6,16(sp)
    80000b2c:	6ba2                	ld	s7,8(sp)
    80000b2e:	6c02                	ld	s8,0(sp)
    80000b30:	6161                	addi	sp,sp,80
    80000b32:	8082                	ret

0000000080000b34 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000b34:	c6dd                	beqz	a3,80000be2 <copyinstr+0xae>
{
    80000b36:	715d                	addi	sp,sp,-80
    80000b38:	e486                	sd	ra,72(sp)
    80000b3a:	e0a2                	sd	s0,64(sp)
    80000b3c:	fc26                	sd	s1,56(sp)
    80000b3e:	f84a                	sd	s2,48(sp)
    80000b40:	f44e                	sd	s3,40(sp)
    80000b42:	f052                	sd	s4,32(sp)
    80000b44:	ec56                	sd	s5,24(sp)
    80000b46:	e85a                	sd	s6,16(sp)
    80000b48:	e45e                	sd	s7,8(sp)
    80000b4a:	0880                	addi	s0,sp,80
    80000b4c:	8a2a                	mv	s4,a0
    80000b4e:	8b2e                	mv	s6,a1
    80000b50:	8bb2                	mv	s7,a2
    80000b52:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000b54:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b56:	6985                	lui	s3,0x1
    80000b58:	a825                	j	80000b90 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b5a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000b5e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b60:	37fd                	addiw	a5,a5,-1
    80000b62:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b66:	60a6                	ld	ra,72(sp)
    80000b68:	6406                	ld	s0,64(sp)
    80000b6a:	74e2                	ld	s1,56(sp)
    80000b6c:	7942                	ld	s2,48(sp)
    80000b6e:	79a2                	ld	s3,40(sp)
    80000b70:	7a02                	ld	s4,32(sp)
    80000b72:	6ae2                	ld	s5,24(sp)
    80000b74:	6b42                	ld	s6,16(sp)
    80000b76:	6ba2                	ld	s7,8(sp)
    80000b78:	6161                	addi	sp,sp,80
    80000b7a:	8082                	ret
    80000b7c:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000b80:	9742                	add	a4,a4,a6
      --max;
    80000b82:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000b86:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000b8a:	04e58463          	beq	a1,a4,80000bd2 <copyinstr+0x9e>
{
    80000b8e:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000b90:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000b94:	85a6                	mv	a1,s1
    80000b96:	8552                	mv	a0,s4
    80000b98:	8c5ff0ef          	jal	8000045c <walkaddr>
    if(pa0 == 0)
    80000b9c:	cd0d                	beqz	a0,80000bd6 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000b9e:	417486b3          	sub	a3,s1,s7
    80000ba2:	96ce                	add	a3,a3,s3
    if(n > max)
    80000ba4:	00d97363          	bgeu	s2,a3,80000baa <copyinstr+0x76>
    80000ba8:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000baa:	955e                	add	a0,a0,s7
    80000bac:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000bae:	c695                	beqz	a3,80000bda <copyinstr+0xa6>
    80000bb0:	87da                	mv	a5,s6
    80000bb2:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000bb4:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000bb8:	96da                	add	a3,a3,s6
    80000bba:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000bbc:	00f60733          	add	a4,a2,a5
    80000bc0:	00074703          	lbu	a4,0(a4)
    80000bc4:	db59                	beqz	a4,80000b5a <copyinstr+0x26>
        *dst = *p;
    80000bc6:	00e78023          	sb	a4,0(a5)
      dst++;
    80000bca:	0785                	addi	a5,a5,1
    while(n > 0){
    80000bcc:	fed797e3          	bne	a5,a3,80000bba <copyinstr+0x86>
    80000bd0:	b775                	j	80000b7c <copyinstr+0x48>
    80000bd2:	4781                	li	a5,0
    80000bd4:	b771                	j	80000b60 <copyinstr+0x2c>
      return -1;
    80000bd6:	557d                	li	a0,-1
    80000bd8:	b779                	j	80000b66 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000bda:	6b85                	lui	s7,0x1
    80000bdc:	9ba6                	add	s7,s7,s1
    80000bde:	87da                	mv	a5,s6
    80000be0:	b77d                	j	80000b8e <copyinstr+0x5a>
  int got_null = 0;
    80000be2:	4781                	li	a5,0
  if(got_null){
    80000be4:	37fd                	addiw	a5,a5,-1
    80000be6:	0007851b          	sext.w	a0,a5
}
    80000bea:	8082                	ret

0000000080000bec <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000bec:	7139                	addi	sp,sp,-64
    80000bee:	fc06                	sd	ra,56(sp)
    80000bf0:	f822                	sd	s0,48(sp)
    80000bf2:	f426                	sd	s1,40(sp)
    80000bf4:	f04a                	sd	s2,32(sp)
    80000bf6:	ec4e                	sd	s3,24(sp)
    80000bf8:	e852                	sd	s4,16(sp)
    80000bfa:	e456                	sd	s5,8(sp)
    80000bfc:	e05a                	sd	s6,0(sp)
    80000bfe:	0080                	addi	s0,sp,64
    80000c00:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c02:	0000a497          	auipc	s1,0xa
    80000c06:	cee48493          	addi	s1,s1,-786 # 8000a8f0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c0a:	8b26                	mv	s6,s1
    80000c0c:	fcfd0937          	lui	s2,0xfcfd0
    80000c10:	cfd90913          	addi	s2,s2,-771 # fffffffffcfcfcfd <end+0xffffffff7cfa752d>
    80000c14:	0942                	slli	s2,s2,0x10
    80000c16:	cfd90913          	addi	s2,s2,-771
    80000c1a:	0942                	slli	s2,s2,0x10
    80000c1c:	cfd90913          	addi	s2,s2,-771
    80000c20:	040009b7          	lui	s3,0x4000
    80000c24:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c26:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c28:	00014a97          	auipc	s5,0x14
    80000c2c:	6c8a8a93          	addi	s5,s5,1736 # 800152f0 <tickslock>
    char *pa = kalloc();
    80000c30:	cceff0ef          	jal	800000fe <kalloc>
    80000c34:	862a                	mv	a2,a0
    if(pa == 0)
    80000c36:	cd15                	beqz	a0,80000c72 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000c38:	416485b3          	sub	a1,s1,s6
    80000c3c:	858d                	srai	a1,a1,0x3
    80000c3e:	032585b3          	mul	a1,a1,s2
    80000c42:	2585                	addiw	a1,a1,1
    80000c44:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c48:	4719                	li	a4,6
    80000c4a:	6685                	lui	a3,0x1
    80000c4c:	40b985b3          	sub	a1,s3,a1
    80000c50:	8552                	mv	a0,s4
    80000c52:	8f9ff0ef          	jal	8000054a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c56:	2a848493          	addi	s1,s1,680
    80000c5a:	fd549be3          	bne	s1,s5,80000c30 <proc_mapstacks+0x44>
  }
}
    80000c5e:	70e2                	ld	ra,56(sp)
    80000c60:	7442                	ld	s0,48(sp)
    80000c62:	74a2                	ld	s1,40(sp)
    80000c64:	7902                	ld	s2,32(sp)
    80000c66:	69e2                	ld	s3,24(sp)
    80000c68:	6a42                	ld	s4,16(sp)
    80000c6a:	6aa2                	ld	s5,8(sp)
    80000c6c:	6b02                	ld	s6,0(sp)
    80000c6e:	6121                	addi	sp,sp,64
    80000c70:	8082                	ret
      panic("kalloc");
    80000c72:	00006517          	auipc	a0,0x6
    80000c76:	52650513          	addi	a0,a0,1318 # 80007198 <etext+0x198>
    80000c7a:	129040ef          	jal	800055a2 <panic>

0000000080000c7e <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000c7e:	7139                	addi	sp,sp,-64
    80000c80:	fc06                	sd	ra,56(sp)
    80000c82:	f822                	sd	s0,48(sp)
    80000c84:	f426                	sd	s1,40(sp)
    80000c86:	f04a                	sd	s2,32(sp)
    80000c88:	ec4e                	sd	s3,24(sp)
    80000c8a:	e852                	sd	s4,16(sp)
    80000c8c:	e456                	sd	s5,8(sp)
    80000c8e:	e05a                	sd	s6,0(sp)
    80000c90:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000c92:	00006597          	auipc	a1,0x6
    80000c96:	50e58593          	addi	a1,a1,1294 # 800071a0 <etext+0x1a0>
    80000c9a:	0000a517          	auipc	a0,0xa
    80000c9e:	82650513          	addi	a0,a0,-2010 # 8000a4c0 <pid_lock>
    80000ca2:	3af040ef          	jal	80005850 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ca6:	00006597          	auipc	a1,0x6
    80000caa:	50258593          	addi	a1,a1,1282 # 800071a8 <etext+0x1a8>
    80000cae:	0000a517          	auipc	a0,0xa
    80000cb2:	82a50513          	addi	a0,a0,-2006 # 8000a4d8 <wait_lock>
    80000cb6:	39b040ef          	jal	80005850 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cba:	0000a497          	auipc	s1,0xa
    80000cbe:	c3648493          	addi	s1,s1,-970 # 8000a8f0 <proc>
      initlock(&p->lock, "proc");
    80000cc2:	00006b17          	auipc	s6,0x6
    80000cc6:	4f6b0b13          	addi	s6,s6,1270 # 800071b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cca:	8aa6                	mv	s5,s1
    80000ccc:	fcfd0937          	lui	s2,0xfcfd0
    80000cd0:	cfd90913          	addi	s2,s2,-771 # fffffffffcfcfcfd <end+0xffffffff7cfa752d>
    80000cd4:	0942                	slli	s2,s2,0x10
    80000cd6:	cfd90913          	addi	s2,s2,-771
    80000cda:	0942                	slli	s2,s2,0x10
    80000cdc:	cfd90913          	addi	s2,s2,-771
    80000ce0:	040009b7          	lui	s3,0x4000
    80000ce4:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000ce6:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce8:	00014a17          	auipc	s4,0x14
    80000cec:	608a0a13          	addi	s4,s4,1544 # 800152f0 <tickslock>
      initlock(&p->lock, "proc");
    80000cf0:	85da                	mv	a1,s6
    80000cf2:	8526                	mv	a0,s1
    80000cf4:	35d040ef          	jal	80005850 <initlock>
      p->state = UNUSED;
    80000cf8:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000cfc:	415487b3          	sub	a5,s1,s5
    80000d00:	878d                	srai	a5,a5,0x3
    80000d02:	032787b3          	mul	a5,a5,s2
    80000d06:	2785                	addiw	a5,a5,1
    80000d08:	00d7979b          	slliw	a5,a5,0xd
    80000d0c:	40f987b3          	sub	a5,s3,a5
    80000d10:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d12:	2a848493          	addi	s1,s1,680
    80000d16:	fd449de3          	bne	s1,s4,80000cf0 <procinit+0x72>
  }
}
    80000d1a:	70e2                	ld	ra,56(sp)
    80000d1c:	7442                	ld	s0,48(sp)
    80000d1e:	74a2                	ld	s1,40(sp)
    80000d20:	7902                	ld	s2,32(sp)
    80000d22:	69e2                	ld	s3,24(sp)
    80000d24:	6a42                	ld	s4,16(sp)
    80000d26:	6aa2                	ld	s5,8(sp)
    80000d28:	6b02                	ld	s6,0(sp)
    80000d2a:	6121                	addi	sp,sp,64
    80000d2c:	8082                	ret

0000000080000d2e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d2e:	1141                	addi	sp,sp,-16
    80000d30:	e422                	sd	s0,8(sp)
    80000d32:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d34:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d36:	2501                	sext.w	a0,a0
    80000d38:	6422                	ld	s0,8(sp)
    80000d3a:	0141                	addi	sp,sp,16
    80000d3c:	8082                	ret

0000000080000d3e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d3e:	1141                	addi	sp,sp,-16
    80000d40:	e422                	sd	s0,8(sp)
    80000d42:	0800                	addi	s0,sp,16
    80000d44:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d46:	2781                	sext.w	a5,a5
    80000d48:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d4a:	00009517          	auipc	a0,0x9
    80000d4e:	7a650513          	addi	a0,a0,1958 # 8000a4f0 <cpus>
    80000d52:	953e                	add	a0,a0,a5
    80000d54:	6422                	ld	s0,8(sp)
    80000d56:	0141                	addi	sp,sp,16
    80000d58:	8082                	ret

0000000080000d5a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d5a:	1101                	addi	sp,sp,-32
    80000d5c:	ec06                	sd	ra,24(sp)
    80000d5e:	e822                	sd	s0,16(sp)
    80000d60:	e426                	sd	s1,8(sp)
    80000d62:	1000                	addi	s0,sp,32
  push_off();
    80000d64:	32d040ef          	jal	80005890 <push_off>
    80000d68:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d6a:	2781                	sext.w	a5,a5
    80000d6c:	079e                	slli	a5,a5,0x7
    80000d6e:	00009717          	auipc	a4,0x9
    80000d72:	75270713          	addi	a4,a4,1874 # 8000a4c0 <pid_lock>
    80000d76:	97ba                	add	a5,a5,a4
    80000d78:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d7a:	39b040ef          	jal	80005914 <pop_off>
  return p;
}
    80000d7e:	8526                	mv	a0,s1
    80000d80:	60e2                	ld	ra,24(sp)
    80000d82:	6442                	ld	s0,16(sp)
    80000d84:	64a2                	ld	s1,8(sp)
    80000d86:	6105                	addi	sp,sp,32
    80000d88:	8082                	ret

0000000080000d8a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000d8a:	1141                	addi	sp,sp,-16
    80000d8c:	e406                	sd	ra,8(sp)
    80000d8e:	e022                	sd	s0,0(sp)
    80000d90:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000d92:	fc9ff0ef          	jal	80000d5a <myproc>
    80000d96:	3d3040ef          	jal	80005968 <release>

  if (first) {
    80000d9a:	00009797          	auipc	a5,0x9
    80000d9e:	6667a783          	lw	a5,1638(a5) # 8000a400 <first.1>
    80000da2:	e799                	bnez	a5,80000db0 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000da4:	30f000ef          	jal	800018b2 <usertrapret>
}
    80000da8:	60a2                	ld	ra,8(sp)
    80000daa:	6402                	ld	s0,0(sp)
    80000dac:	0141                	addi	sp,sp,16
    80000dae:	8082                	ret
    fsinit(ROOTDEV);
    80000db0:	4505                	li	a0,1
    80000db2:	013010ef          	jal	800025c4 <fsinit>
    first = 0;
    80000db6:	00009797          	auipc	a5,0x9
    80000dba:	6407a523          	sw	zero,1610(a5) # 8000a400 <first.1>
    __sync_synchronize();
    80000dbe:	0330000f          	fence	rw,rw
    80000dc2:	b7cd                	j	80000da4 <forkret+0x1a>

0000000080000dc4 <allocpid>:
{
    80000dc4:	1101                	addi	sp,sp,-32
    80000dc6:	ec06                	sd	ra,24(sp)
    80000dc8:	e822                	sd	s0,16(sp)
    80000dca:	e426                	sd	s1,8(sp)
    80000dcc:	e04a                	sd	s2,0(sp)
    80000dce:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000dd0:	00009917          	auipc	s2,0x9
    80000dd4:	6f090913          	addi	s2,s2,1776 # 8000a4c0 <pid_lock>
    80000dd8:	854a                	mv	a0,s2
    80000dda:	2f7040ef          	jal	800058d0 <acquire>
  pid = nextpid;
    80000dde:	00009797          	auipc	a5,0x9
    80000de2:	62678793          	addi	a5,a5,1574 # 8000a404 <nextpid>
    80000de6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000de8:	0014871b          	addiw	a4,s1,1
    80000dec:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000dee:	854a                	mv	a0,s2
    80000df0:	379040ef          	jal	80005968 <release>
}
    80000df4:	8526                	mv	a0,s1
    80000df6:	60e2                	ld	ra,24(sp)
    80000df8:	6442                	ld	s0,16(sp)
    80000dfa:	64a2                	ld	s1,8(sp)
    80000dfc:	6902                	ld	s2,0(sp)
    80000dfe:	6105                	addi	sp,sp,32
    80000e00:	8082                	ret

0000000080000e02 <proc_pagetable>:
{
    80000e02:	1101                	addi	sp,sp,-32
    80000e04:	ec06                	sd	ra,24(sp)
    80000e06:	e822                	sd	s0,16(sp)
    80000e08:	e426                	sd	s1,8(sp)
    80000e0a:	e04a                	sd	s2,0(sp)
    80000e0c:	1000                	addi	s0,sp,32
    80000e0e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e10:	8edff0ef          	jal	800006fc <uvmcreate>
    80000e14:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e16:	cd05                	beqz	a0,80000e4e <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e18:	4729                	li	a4,10
    80000e1a:	00005697          	auipc	a3,0x5
    80000e1e:	1e668693          	addi	a3,a3,486 # 80006000 <_trampoline>
    80000e22:	6605                	lui	a2,0x1
    80000e24:	040005b7          	lui	a1,0x4000
    80000e28:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e2a:	05b2                	slli	a1,a1,0xc
    80000e2c:	e6eff0ef          	jal	8000049a <mappages>
    80000e30:	02054663          	bltz	a0,80000e5c <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e34:	4719                	li	a4,6
    80000e36:	05893683          	ld	a3,88(s2)
    80000e3a:	6605                	lui	a2,0x1
    80000e3c:	020005b7          	lui	a1,0x2000
    80000e40:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000e42:	05b6                	slli	a1,a1,0xd
    80000e44:	8526                	mv	a0,s1
    80000e46:	e54ff0ef          	jal	8000049a <mappages>
    80000e4a:	00054f63          	bltz	a0,80000e68 <proc_pagetable+0x66>
}
    80000e4e:	8526                	mv	a0,s1
    80000e50:	60e2                	ld	ra,24(sp)
    80000e52:	6442                	ld	s0,16(sp)
    80000e54:	64a2                	ld	s1,8(sp)
    80000e56:	6902                	ld	s2,0(sp)
    80000e58:	6105                	addi	sp,sp,32
    80000e5a:	8082                	ret
    uvmfree(pagetable, 0);
    80000e5c:	4581                	li	a1,0
    80000e5e:	8526                	mv	a0,s1
    80000e60:	a6bff0ef          	jal	800008ca <uvmfree>
    return 0;
    80000e64:	4481                	li	s1,0
    80000e66:	b7e5                	j	80000e4e <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e68:	4681                	li	a3,0
    80000e6a:	4605                	li	a2,1
    80000e6c:	040005b7          	lui	a1,0x4000
    80000e70:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e72:	05b2                	slli	a1,a1,0xc
    80000e74:	8526                	mv	a0,s1
    80000e76:	fcaff0ef          	jal	80000640 <uvmunmap>
    uvmfree(pagetable, 0);
    80000e7a:	4581                	li	a1,0
    80000e7c:	8526                	mv	a0,s1
    80000e7e:	a4dff0ef          	jal	800008ca <uvmfree>
    return 0;
    80000e82:	4481                	li	s1,0
    80000e84:	b7e9                	j	80000e4e <proc_pagetable+0x4c>

0000000080000e86 <proc_freepagetable>:
{
    80000e86:	1101                	addi	sp,sp,-32
    80000e88:	ec06                	sd	ra,24(sp)
    80000e8a:	e822                	sd	s0,16(sp)
    80000e8c:	e426                	sd	s1,8(sp)
    80000e8e:	e04a                	sd	s2,0(sp)
    80000e90:	1000                	addi	s0,sp,32
    80000e92:	84aa                	mv	s1,a0
    80000e94:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e96:	4681                	li	a3,0
    80000e98:	4605                	li	a2,1
    80000e9a:	040005b7          	lui	a1,0x4000
    80000e9e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ea0:	05b2                	slli	a1,a1,0xc
    80000ea2:	f9eff0ef          	jal	80000640 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ea6:	4681                	li	a3,0
    80000ea8:	4605                	li	a2,1
    80000eaa:	020005b7          	lui	a1,0x2000
    80000eae:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000eb0:	05b6                	slli	a1,a1,0xd
    80000eb2:	8526                	mv	a0,s1
    80000eb4:	f8cff0ef          	jal	80000640 <uvmunmap>
  uvmfree(pagetable, sz);
    80000eb8:	85ca                	mv	a1,s2
    80000eba:	8526                	mv	a0,s1
    80000ebc:	a0fff0ef          	jal	800008ca <uvmfree>
}
    80000ec0:	60e2                	ld	ra,24(sp)
    80000ec2:	6442                	ld	s0,16(sp)
    80000ec4:	64a2                	ld	s1,8(sp)
    80000ec6:	6902                	ld	s2,0(sp)
    80000ec8:	6105                	addi	sp,sp,32
    80000eca:	8082                	ret

0000000080000ecc <freeproc>:
{
    80000ecc:	1101                	addi	sp,sp,-32
    80000ece:	ec06                	sd	ra,24(sp)
    80000ed0:	e822                	sd	s0,16(sp)
    80000ed2:	e426                	sd	s1,8(sp)
    80000ed4:	1000                	addi	s0,sp,32
    80000ed6:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000ed8:	6d28                	ld	a0,88(a0)
    80000eda:	c119                	beqz	a0,80000ee0 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000edc:	940ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000ee0:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000ee4:	68a8                	ld	a0,80(s1)
    80000ee6:	c501                	beqz	a0,80000eee <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000ee8:	64ac                	ld	a1,72(s1)
    80000eea:	f9dff0ef          	jal	80000e86 <proc_freepagetable>
  p->pagetable = 0;
    80000eee:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000ef2:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000ef6:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000efa:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000efe:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f02:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f06:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f0a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f0e:	0004ac23          	sw	zero,24(s1)
}
    80000f12:	60e2                	ld	ra,24(sp)
    80000f14:	6442                	ld	s0,16(sp)
    80000f16:	64a2                	ld	s1,8(sp)
    80000f18:	6105                	addi	sp,sp,32
    80000f1a:	8082                	ret

0000000080000f1c <allocproc>:
{
    80000f1c:	1101                	addi	sp,sp,-32
    80000f1e:	ec06                	sd	ra,24(sp)
    80000f20:	e822                	sd	s0,16(sp)
    80000f22:	e426                	sd	s1,8(sp)
    80000f24:	e04a                	sd	s2,0(sp)
    80000f26:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f28:	0000a497          	auipc	s1,0xa
    80000f2c:	9c848493          	addi	s1,s1,-1592 # 8000a8f0 <proc>
    80000f30:	00014917          	auipc	s2,0x14
    80000f34:	3c090913          	addi	s2,s2,960 # 800152f0 <tickslock>
    acquire(&p->lock);
    80000f38:	8526                	mv	a0,s1
    80000f3a:	197040ef          	jal	800058d0 <acquire>
    if(p->state == UNUSED) {
    80000f3e:	4c9c                	lw	a5,24(s1)
    80000f40:	cb91                	beqz	a5,80000f54 <allocproc+0x38>
      release(&p->lock);
    80000f42:	8526                	mv	a0,s1
    80000f44:	225040ef          	jal	80005968 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f48:	2a848493          	addi	s1,s1,680
    80000f4c:	ff2496e3          	bne	s1,s2,80000f38 <allocproc+0x1c>
  return 0;
    80000f50:	4481                	li	s1,0
    80000f52:	a889                	j	80000fa4 <allocproc+0x88>
  p->pid = allocpid();
    80000f54:	e71ff0ef          	jal	80000dc4 <allocpid>
    80000f58:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000f5a:	4785                	li	a5,1
    80000f5c:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000f5e:	9a0ff0ef          	jal	800000fe <kalloc>
    80000f62:	892a                	mv	s2,a0
    80000f64:	eca8                	sd	a0,88(s1)
    80000f66:	c531                	beqz	a0,80000fb2 <allocproc+0x96>
  p->pagetable = proc_pagetable(p);
    80000f68:	8526                	mv	a0,s1
    80000f6a:	e99ff0ef          	jal	80000e02 <proc_pagetable>
    80000f6e:	892a                	mv	s2,a0
    80000f70:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000f72:	c921                	beqz	a0,80000fc2 <allocproc+0xa6>
  memset(&p->context, 0, sizeof(p->context));
    80000f74:	07000613          	li	a2,112
    80000f78:	4581                	li	a1,0
    80000f7a:	06048513          	addi	a0,s1,96
    80000f7e:	9d0ff0ef          	jal	8000014e <memset>
  p->context.ra = (uint64)forkret;
    80000f82:	00000797          	auipc	a5,0x0
    80000f86:	e0878793          	addi	a5,a5,-504 # 80000d8a <forkret>
    80000f8a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000f8c:	60bc                	ld	a5,64(s1)
    80000f8e:	6705                	lui	a4,0x1
    80000f90:	97ba                	add	a5,a5,a4
    80000f92:	f4bc                	sd	a5,104(s1)
  p->alarmticks = 0;
    80000f94:	1604a623          	sw	zero,364(s1)
  p->curticks = 0;
    80000f98:	1604a823          	sw	zero,368(s1)
  p->user_alarm_handler_va = 0;
    80000f9c:	1604bc23          	sd	zero,376(s1)
  p->handling_alarm = 0;
    80000fa0:	2a04a023          	sw	zero,672(s1)
}
    80000fa4:	8526                	mv	a0,s1
    80000fa6:	60e2                	ld	ra,24(sp)
    80000fa8:	6442                	ld	s0,16(sp)
    80000faa:	64a2                	ld	s1,8(sp)
    80000fac:	6902                	ld	s2,0(sp)
    80000fae:	6105                	addi	sp,sp,32
    80000fb0:	8082                	ret
    freeproc(p); // Clears most fields and sets state to UNUSED
    80000fb2:	8526                	mv	a0,s1
    80000fb4:	f19ff0ef          	jal	80000ecc <freeproc>
    release(&p->lock);
    80000fb8:	8526                	mv	a0,s1
    80000fba:	1af040ef          	jal	80005968 <release>
    return 0;
    80000fbe:	84ca                	mv	s1,s2
    80000fc0:	b7d5                	j	80000fa4 <allocproc+0x88>
    freeproc(p);
    80000fc2:	8526                	mv	a0,s1
    80000fc4:	f09ff0ef          	jal	80000ecc <freeproc>
    release(&p->lock);
    80000fc8:	8526                	mv	a0,s1
    80000fca:	19f040ef          	jal	80005968 <release>
    return 0;
    80000fce:	84ca                	mv	s1,s2
    80000fd0:	bfd1                	j	80000fa4 <allocproc+0x88>

0000000080000fd2 <userinit>:
{
    80000fd2:	1101                	addi	sp,sp,-32
    80000fd4:	ec06                	sd	ra,24(sp)
    80000fd6:	e822                	sd	s0,16(sp)
    80000fd8:	e426                	sd	s1,8(sp)
    80000fda:	1000                	addi	s0,sp,32
  p = allocproc();
    80000fdc:	f41ff0ef          	jal	80000f1c <allocproc>
    80000fe0:	84aa                	mv	s1,a0
  initproc = p;
    80000fe2:	00009797          	auipc	a5,0x9
    80000fe6:	48a7bf23          	sd	a0,1182(a5) # 8000a480 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80000fea:	03400613          	li	a2,52
    80000fee:	00009597          	auipc	a1,0x9
    80000ff2:	42258593          	addi	a1,a1,1058 # 8000a410 <initcode>
    80000ff6:	6928                	ld	a0,80(a0)
    80000ff8:	f2aff0ef          	jal	80000722 <uvmfirst>
  p->sz = PGSIZE;
    80000ffc:	6785                	lui	a5,0x1
    80000ffe:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001000:	6cb8                	ld	a4,88(s1)
    80001002:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001006:	6cb8                	ld	a4,88(s1)
    80001008:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000100a:	4641                	li	a2,16
    8000100c:	00006597          	auipc	a1,0x6
    80001010:	1b458593          	addi	a1,a1,436 # 800071c0 <etext+0x1c0>
    80001014:	15848513          	addi	a0,s1,344
    80001018:	a74ff0ef          	jal	8000028c <safestrcpy>
  p->cwd = namei("/");
    8000101c:	00006517          	auipc	a0,0x6
    80001020:	1b450513          	addi	a0,a0,436 # 800071d0 <etext+0x1d0>
    80001024:	6af010ef          	jal	80002ed2 <namei>
    80001028:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000102c:	478d                	li	a5,3
    8000102e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001030:	8526                	mv	a0,s1
    80001032:	137040ef          	jal	80005968 <release>
}
    80001036:	60e2                	ld	ra,24(sp)
    80001038:	6442                	ld	s0,16(sp)
    8000103a:	64a2                	ld	s1,8(sp)
    8000103c:	6105                	addi	sp,sp,32
    8000103e:	8082                	ret

0000000080001040 <growproc>:
{
    80001040:	1101                	addi	sp,sp,-32
    80001042:	ec06                	sd	ra,24(sp)
    80001044:	e822                	sd	s0,16(sp)
    80001046:	e426                	sd	s1,8(sp)
    80001048:	e04a                	sd	s2,0(sp)
    8000104a:	1000                	addi	s0,sp,32
    8000104c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000104e:	d0dff0ef          	jal	80000d5a <myproc>
    80001052:	84aa                	mv	s1,a0
  sz = p->sz;
    80001054:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001056:	01204c63          	bgtz	s2,8000106e <growproc+0x2e>
  } else if(n < 0){
    8000105a:	02094463          	bltz	s2,80001082 <growproc+0x42>
  p->sz = sz;
    8000105e:	e4ac                	sd	a1,72(s1)
  return 0;
    80001060:	4501                	li	a0,0
}
    80001062:	60e2                	ld	ra,24(sp)
    80001064:	6442                	ld	s0,16(sp)
    80001066:	64a2                	ld	s1,8(sp)
    80001068:	6902                	ld	s2,0(sp)
    8000106a:	6105                	addi	sp,sp,32
    8000106c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000106e:	4691                	li	a3,4
    80001070:	00b90633          	add	a2,s2,a1
    80001074:	6928                	ld	a0,80(a0)
    80001076:	f4eff0ef          	jal	800007c4 <uvmalloc>
    8000107a:	85aa                	mv	a1,a0
    8000107c:	f16d                	bnez	a0,8000105e <growproc+0x1e>
      return -1;
    8000107e:	557d                	li	a0,-1
    80001080:	b7cd                	j	80001062 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001082:	00b90633          	add	a2,s2,a1
    80001086:	6928                	ld	a0,80(a0)
    80001088:	ef8ff0ef          	jal	80000780 <uvmdealloc>
    8000108c:	85aa                	mv	a1,a0
    8000108e:	bfc1                	j	8000105e <growproc+0x1e>

0000000080001090 <fork>:
{
    80001090:	7139                	addi	sp,sp,-64
    80001092:	fc06                	sd	ra,56(sp)
    80001094:	f822                	sd	s0,48(sp)
    80001096:	f04a                	sd	s2,32(sp)
    80001098:	e456                	sd	s5,8(sp)
    8000109a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000109c:	cbfff0ef          	jal	80000d5a <myproc>
    800010a0:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800010a2:	e7bff0ef          	jal	80000f1c <allocproc>
    800010a6:	0e050e63          	beqz	a0,800011a2 <fork+0x112>
    800010aa:	ec4e                	sd	s3,24(sp)
    800010ac:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010ae:	048ab603          	ld	a2,72(s5)
    800010b2:	692c                	ld	a1,80(a0)
    800010b4:	050ab503          	ld	a0,80(s5)
    800010b8:	845ff0ef          	jal	800008fc <uvmcopy>
    800010bc:	04054a63          	bltz	a0,80001110 <fork+0x80>
    800010c0:	f426                	sd	s1,40(sp)
    800010c2:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    800010c4:	048ab783          	ld	a5,72(s5)
    800010c8:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800010cc:	058ab683          	ld	a3,88(s5)
    800010d0:	87b6                	mv	a5,a3
    800010d2:	0589b703          	ld	a4,88(s3)
    800010d6:	12068693          	addi	a3,a3,288
    800010da:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800010de:	6788                	ld	a0,8(a5)
    800010e0:	6b8c                	ld	a1,16(a5)
    800010e2:	6f90                	ld	a2,24(a5)
    800010e4:	01073023          	sd	a6,0(a4)
    800010e8:	e708                	sd	a0,8(a4)
    800010ea:	eb0c                	sd	a1,16(a4)
    800010ec:	ef10                	sd	a2,24(a4)
    800010ee:	02078793          	addi	a5,a5,32
    800010f2:	02070713          	addi	a4,a4,32
    800010f6:	fed792e3          	bne	a5,a3,800010da <fork+0x4a>
  np->trapframe->a0 = 0;
    800010fa:	0589b783          	ld	a5,88(s3)
    800010fe:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001102:	0d0a8493          	addi	s1,s5,208
    80001106:	0d098913          	addi	s2,s3,208
    8000110a:	150a8a13          	addi	s4,s5,336
    8000110e:	a831                	j	8000112a <fork+0x9a>
    freeproc(np);
    80001110:	854e                	mv	a0,s3
    80001112:	dbbff0ef          	jal	80000ecc <freeproc>
    release(&np->lock);
    80001116:	854e                	mv	a0,s3
    80001118:	051040ef          	jal	80005968 <release>
    return -1;
    8000111c:	597d                	li	s2,-1
    8000111e:	69e2                	ld	s3,24(sp)
    80001120:	a895                	j	80001194 <fork+0x104>
  for(i = 0; i < NOFILE; i++)
    80001122:	04a1                	addi	s1,s1,8
    80001124:	0921                	addi	s2,s2,8
    80001126:	01448963          	beq	s1,s4,80001138 <fork+0xa8>
    if(p->ofile[i])
    8000112a:	6088                	ld	a0,0(s1)
    8000112c:	d97d                	beqz	a0,80001122 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    8000112e:	334020ef          	jal	80003462 <filedup>
    80001132:	00a93023          	sd	a0,0(s2)
    80001136:	b7f5                	j	80001122 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001138:	150ab503          	ld	a0,336(s5)
    8000113c:	686010ef          	jal	800027c2 <idup>
    80001140:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001144:	4641                	li	a2,16
    80001146:	158a8593          	addi	a1,s5,344
    8000114a:	15898513          	addi	a0,s3,344
    8000114e:	93eff0ef          	jal	8000028c <safestrcpy>
  np->tracemask = p->tracemask; // <--- 添加的行
    80001152:	168aa783          	lw	a5,360(s5)
    80001156:	16f9a423          	sw	a5,360(s3)
  pid = np->pid;
    8000115a:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    8000115e:	854e                	mv	a0,s3
    80001160:	009040ef          	jal	80005968 <release>
  acquire(&wait_lock);
    80001164:	00009497          	auipc	s1,0x9
    80001168:	37448493          	addi	s1,s1,884 # 8000a4d8 <wait_lock>
    8000116c:	8526                	mv	a0,s1
    8000116e:	762040ef          	jal	800058d0 <acquire>
  np->parent = p;
    80001172:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001176:	8526                	mv	a0,s1
    80001178:	7f0040ef          	jal	80005968 <release>
  acquire(&np->lock);
    8000117c:	854e                	mv	a0,s3
    8000117e:	752040ef          	jal	800058d0 <acquire>
  np->state = RUNNABLE;
    80001182:	478d                	li	a5,3
    80001184:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001188:	854e                	mv	a0,s3
    8000118a:	7de040ef          	jal	80005968 <release>
  return pid;
    8000118e:	74a2                	ld	s1,40(sp)
    80001190:	69e2                	ld	s3,24(sp)
    80001192:	6a42                	ld	s4,16(sp)
}
    80001194:	854a                	mv	a0,s2
    80001196:	70e2                	ld	ra,56(sp)
    80001198:	7442                	ld	s0,48(sp)
    8000119a:	7902                	ld	s2,32(sp)
    8000119c:	6aa2                	ld	s5,8(sp)
    8000119e:	6121                	addi	sp,sp,64
    800011a0:	8082                	ret
    return -1;
    800011a2:	597d                	li	s2,-1
    800011a4:	bfc5                	j	80001194 <fork+0x104>

00000000800011a6 <scheduler>:
{
    800011a6:	715d                	addi	sp,sp,-80
    800011a8:	e486                	sd	ra,72(sp)
    800011aa:	e0a2                	sd	s0,64(sp)
    800011ac:	fc26                	sd	s1,56(sp)
    800011ae:	f84a                	sd	s2,48(sp)
    800011b0:	f44e                	sd	s3,40(sp)
    800011b2:	f052                	sd	s4,32(sp)
    800011b4:	ec56                	sd	s5,24(sp)
    800011b6:	e85a                	sd	s6,16(sp)
    800011b8:	e45e                	sd	s7,8(sp)
    800011ba:	e062                	sd	s8,0(sp)
    800011bc:	0880                	addi	s0,sp,80
    800011be:	8792                	mv	a5,tp
  int id = r_tp();
    800011c0:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011c2:	00779b13          	slli	s6,a5,0x7
    800011c6:	00009717          	auipc	a4,0x9
    800011ca:	2fa70713          	addi	a4,a4,762 # 8000a4c0 <pid_lock>
    800011ce:	975a                	add	a4,a4,s6
    800011d0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011d4:	00009717          	auipc	a4,0x9
    800011d8:	32470713          	addi	a4,a4,804 # 8000a4f8 <cpus+0x8>
    800011dc:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800011de:	4c11                	li	s8,4
        c->proc = p;
    800011e0:	079e                	slli	a5,a5,0x7
    800011e2:	00009a17          	auipc	s4,0x9
    800011e6:	2dea0a13          	addi	s4,s4,734 # 8000a4c0 <pid_lock>
    800011ea:	9a3e                	add	s4,s4,a5
        found = 1;
    800011ec:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    800011ee:	00014997          	auipc	s3,0x14
    800011f2:	10298993          	addi	s3,s3,258 # 800152f0 <tickslock>
    800011f6:	a0a9                	j	80001240 <scheduler+0x9a>
      release(&p->lock);
    800011f8:	8526                	mv	a0,s1
    800011fa:	76e040ef          	jal	80005968 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800011fe:	2a848493          	addi	s1,s1,680
    80001202:	03348563          	beq	s1,s3,8000122c <scheduler+0x86>
      acquire(&p->lock);
    80001206:	8526                	mv	a0,s1
    80001208:	6c8040ef          	jal	800058d0 <acquire>
      if(p->state == RUNNABLE) {
    8000120c:	4c9c                	lw	a5,24(s1)
    8000120e:	ff2795e3          	bne	a5,s2,800011f8 <scheduler+0x52>
        p->state = RUNNING;
    80001212:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001216:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000121a:	06048593          	addi	a1,s1,96
    8000121e:	855a                	mv	a0,s6
    80001220:	5ec000ef          	jal	8000180c <swtch>
        c->proc = 0;
    80001224:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001228:	8ade                	mv	s5,s7
    8000122a:	b7f9                	j	800011f8 <scheduler+0x52>
    if(found == 0) {
    8000122c:	000a9a63          	bnez	s5,80001240 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001230:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001234:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001238:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    8000123c:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001240:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001244:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001248:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000124c:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    8000124e:	00009497          	auipc	s1,0x9
    80001252:	6a248493          	addi	s1,s1,1698 # 8000a8f0 <proc>
      if(p->state == RUNNABLE) {
    80001256:	490d                	li	s2,3
    80001258:	b77d                	j	80001206 <scheduler+0x60>

000000008000125a <sched>:
{
    8000125a:	7179                	addi	sp,sp,-48
    8000125c:	f406                	sd	ra,40(sp)
    8000125e:	f022                	sd	s0,32(sp)
    80001260:	ec26                	sd	s1,24(sp)
    80001262:	e84a                	sd	s2,16(sp)
    80001264:	e44e                	sd	s3,8(sp)
    80001266:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001268:	af3ff0ef          	jal	80000d5a <myproc>
    8000126c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000126e:	5f8040ef          	jal	80005866 <holding>
    80001272:	c92d                	beqz	a0,800012e4 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001274:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001276:	2781                	sext.w	a5,a5
    80001278:	079e                	slli	a5,a5,0x7
    8000127a:	00009717          	auipc	a4,0x9
    8000127e:	24670713          	addi	a4,a4,582 # 8000a4c0 <pid_lock>
    80001282:	97ba                	add	a5,a5,a4
    80001284:	0a87a703          	lw	a4,168(a5)
    80001288:	4785                	li	a5,1
    8000128a:	06f71363          	bne	a4,a5,800012f0 <sched+0x96>
  if(p->state == RUNNING)
    8000128e:	4c98                	lw	a4,24(s1)
    80001290:	4791                	li	a5,4
    80001292:	06f70563          	beq	a4,a5,800012fc <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001296:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000129a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000129c:	e7b5                	bnez	a5,80001308 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000129e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800012a0:	00009917          	auipc	s2,0x9
    800012a4:	22090913          	addi	s2,s2,544 # 8000a4c0 <pid_lock>
    800012a8:	2781                	sext.w	a5,a5
    800012aa:	079e                	slli	a5,a5,0x7
    800012ac:	97ca                	add	a5,a5,s2
    800012ae:	0ac7a983          	lw	s3,172(a5)
    800012b2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012b4:	2781                	sext.w	a5,a5
    800012b6:	079e                	slli	a5,a5,0x7
    800012b8:	00009597          	auipc	a1,0x9
    800012bc:	24058593          	addi	a1,a1,576 # 8000a4f8 <cpus+0x8>
    800012c0:	95be                	add	a1,a1,a5
    800012c2:	06048513          	addi	a0,s1,96
    800012c6:	546000ef          	jal	8000180c <swtch>
    800012ca:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800012cc:	2781                	sext.w	a5,a5
    800012ce:	079e                	slli	a5,a5,0x7
    800012d0:	993e                	add	s2,s2,a5
    800012d2:	0b392623          	sw	s3,172(s2)
}
    800012d6:	70a2                	ld	ra,40(sp)
    800012d8:	7402                	ld	s0,32(sp)
    800012da:	64e2                	ld	s1,24(sp)
    800012dc:	6942                	ld	s2,16(sp)
    800012de:	69a2                	ld	s3,8(sp)
    800012e0:	6145                	addi	sp,sp,48
    800012e2:	8082                	ret
    panic("sched p->lock");
    800012e4:	00006517          	auipc	a0,0x6
    800012e8:	ef450513          	addi	a0,a0,-268 # 800071d8 <etext+0x1d8>
    800012ec:	2b6040ef          	jal	800055a2 <panic>
    panic("sched locks");
    800012f0:	00006517          	auipc	a0,0x6
    800012f4:	ef850513          	addi	a0,a0,-264 # 800071e8 <etext+0x1e8>
    800012f8:	2aa040ef          	jal	800055a2 <panic>
    panic("sched running");
    800012fc:	00006517          	auipc	a0,0x6
    80001300:	efc50513          	addi	a0,a0,-260 # 800071f8 <etext+0x1f8>
    80001304:	29e040ef          	jal	800055a2 <panic>
    panic("sched interruptible");
    80001308:	00006517          	auipc	a0,0x6
    8000130c:	f0050513          	addi	a0,a0,-256 # 80007208 <etext+0x208>
    80001310:	292040ef          	jal	800055a2 <panic>

0000000080001314 <yield>:
{
    80001314:	1101                	addi	sp,sp,-32
    80001316:	ec06                	sd	ra,24(sp)
    80001318:	e822                	sd	s0,16(sp)
    8000131a:	e426                	sd	s1,8(sp)
    8000131c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000131e:	a3dff0ef          	jal	80000d5a <myproc>
    80001322:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001324:	5ac040ef          	jal	800058d0 <acquire>
  p->state = RUNNABLE;
    80001328:	478d                	li	a5,3
    8000132a:	cc9c                	sw	a5,24(s1)
  sched();
    8000132c:	f2fff0ef          	jal	8000125a <sched>
  release(&p->lock);
    80001330:	8526                	mv	a0,s1
    80001332:	636040ef          	jal	80005968 <release>
}
    80001336:	60e2                	ld	ra,24(sp)
    80001338:	6442                	ld	s0,16(sp)
    8000133a:	64a2                	ld	s1,8(sp)
    8000133c:	6105                	addi	sp,sp,32
    8000133e:	8082                	ret

0000000080001340 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001340:	7179                	addi	sp,sp,-48
    80001342:	f406                	sd	ra,40(sp)
    80001344:	f022                	sd	s0,32(sp)
    80001346:	ec26                	sd	s1,24(sp)
    80001348:	e84a                	sd	s2,16(sp)
    8000134a:	e44e                	sd	s3,8(sp)
    8000134c:	1800                	addi	s0,sp,48
    8000134e:	89aa                	mv	s3,a0
    80001350:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001352:	a09ff0ef          	jal	80000d5a <myproc>
    80001356:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001358:	578040ef          	jal	800058d0 <acquire>
  release(lk);
    8000135c:	854a                	mv	a0,s2
    8000135e:	60a040ef          	jal	80005968 <release>

  // Go to sleep.
  p->chan = chan;
    80001362:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001366:	4789                	li	a5,2
    80001368:	cc9c                	sw	a5,24(s1)

  sched();
    8000136a:	ef1ff0ef          	jal	8000125a <sched>

  // Tidy up.
  p->chan = 0;
    8000136e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001372:	8526                	mv	a0,s1
    80001374:	5f4040ef          	jal	80005968 <release>
  acquire(lk);
    80001378:	854a                	mv	a0,s2
    8000137a:	556040ef          	jal	800058d0 <acquire>
}
    8000137e:	70a2                	ld	ra,40(sp)
    80001380:	7402                	ld	s0,32(sp)
    80001382:	64e2                	ld	s1,24(sp)
    80001384:	6942                	ld	s2,16(sp)
    80001386:	69a2                	ld	s3,8(sp)
    80001388:	6145                	addi	sp,sp,48
    8000138a:	8082                	ret

000000008000138c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000138c:	7139                	addi	sp,sp,-64
    8000138e:	fc06                	sd	ra,56(sp)
    80001390:	f822                	sd	s0,48(sp)
    80001392:	f426                	sd	s1,40(sp)
    80001394:	f04a                	sd	s2,32(sp)
    80001396:	ec4e                	sd	s3,24(sp)
    80001398:	e852                	sd	s4,16(sp)
    8000139a:	e456                	sd	s5,8(sp)
    8000139c:	0080                	addi	s0,sp,64
    8000139e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800013a0:	00009497          	auipc	s1,0x9
    800013a4:	55048493          	addi	s1,s1,1360 # 8000a8f0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800013a8:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013aa:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013ac:	00014917          	auipc	s2,0x14
    800013b0:	f4490913          	addi	s2,s2,-188 # 800152f0 <tickslock>
    800013b4:	a801                	j	800013c4 <wakeup+0x38>
      }
      release(&p->lock);
    800013b6:	8526                	mv	a0,s1
    800013b8:	5b0040ef          	jal	80005968 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013bc:	2a848493          	addi	s1,s1,680
    800013c0:	03248263          	beq	s1,s2,800013e4 <wakeup+0x58>
    if(p != myproc()){
    800013c4:	997ff0ef          	jal	80000d5a <myproc>
    800013c8:	fea48ae3          	beq	s1,a0,800013bc <wakeup+0x30>
      acquire(&p->lock);
    800013cc:	8526                	mv	a0,s1
    800013ce:	502040ef          	jal	800058d0 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800013d2:	4c9c                	lw	a5,24(s1)
    800013d4:	ff3791e3          	bne	a5,s3,800013b6 <wakeup+0x2a>
    800013d8:	709c                	ld	a5,32(s1)
    800013da:	fd479ee3          	bne	a5,s4,800013b6 <wakeup+0x2a>
        p->state = RUNNABLE;
    800013de:	0154ac23          	sw	s5,24(s1)
    800013e2:	bfd1                	j	800013b6 <wakeup+0x2a>
    }
  }
}
    800013e4:	70e2                	ld	ra,56(sp)
    800013e6:	7442                	ld	s0,48(sp)
    800013e8:	74a2                	ld	s1,40(sp)
    800013ea:	7902                	ld	s2,32(sp)
    800013ec:	69e2                	ld	s3,24(sp)
    800013ee:	6a42                	ld	s4,16(sp)
    800013f0:	6aa2                	ld	s5,8(sp)
    800013f2:	6121                	addi	sp,sp,64
    800013f4:	8082                	ret

00000000800013f6 <reparent>:
{
    800013f6:	7179                	addi	sp,sp,-48
    800013f8:	f406                	sd	ra,40(sp)
    800013fa:	f022                	sd	s0,32(sp)
    800013fc:	ec26                	sd	s1,24(sp)
    800013fe:	e84a                	sd	s2,16(sp)
    80001400:	e44e                	sd	s3,8(sp)
    80001402:	e052                	sd	s4,0(sp)
    80001404:	1800                	addi	s0,sp,48
    80001406:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001408:	00009497          	auipc	s1,0x9
    8000140c:	4e848493          	addi	s1,s1,1256 # 8000a8f0 <proc>
      pp->parent = initproc;
    80001410:	00009a17          	auipc	s4,0x9
    80001414:	070a0a13          	addi	s4,s4,112 # 8000a480 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001418:	00014997          	auipc	s3,0x14
    8000141c:	ed898993          	addi	s3,s3,-296 # 800152f0 <tickslock>
    80001420:	a029                	j	8000142a <reparent+0x34>
    80001422:	2a848493          	addi	s1,s1,680
    80001426:	01348b63          	beq	s1,s3,8000143c <reparent+0x46>
    if(pp->parent == p){
    8000142a:	7c9c                	ld	a5,56(s1)
    8000142c:	ff279be3          	bne	a5,s2,80001422 <reparent+0x2c>
      pp->parent = initproc;
    80001430:	000a3503          	ld	a0,0(s4)
    80001434:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001436:	f57ff0ef          	jal	8000138c <wakeup>
    8000143a:	b7e5                	j	80001422 <reparent+0x2c>
}
    8000143c:	70a2                	ld	ra,40(sp)
    8000143e:	7402                	ld	s0,32(sp)
    80001440:	64e2                	ld	s1,24(sp)
    80001442:	6942                	ld	s2,16(sp)
    80001444:	69a2                	ld	s3,8(sp)
    80001446:	6a02                	ld	s4,0(sp)
    80001448:	6145                	addi	sp,sp,48
    8000144a:	8082                	ret

000000008000144c <exit>:
{
    8000144c:	7179                	addi	sp,sp,-48
    8000144e:	f406                	sd	ra,40(sp)
    80001450:	f022                	sd	s0,32(sp)
    80001452:	ec26                	sd	s1,24(sp)
    80001454:	e84a                	sd	s2,16(sp)
    80001456:	e44e                	sd	s3,8(sp)
    80001458:	e052                	sd	s4,0(sp)
    8000145a:	1800                	addi	s0,sp,48
    8000145c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000145e:	8fdff0ef          	jal	80000d5a <myproc>
    80001462:	89aa                	mv	s3,a0
  if(p == initproc)
    80001464:	00009797          	auipc	a5,0x9
    80001468:	01c7b783          	ld	a5,28(a5) # 8000a480 <initproc>
    8000146c:	0d050493          	addi	s1,a0,208
    80001470:	15050913          	addi	s2,a0,336
    80001474:	00a79f63          	bne	a5,a0,80001492 <exit+0x46>
    panic("init exiting");
    80001478:	00006517          	auipc	a0,0x6
    8000147c:	da850513          	addi	a0,a0,-600 # 80007220 <etext+0x220>
    80001480:	122040ef          	jal	800055a2 <panic>
      fileclose(f);
    80001484:	024020ef          	jal	800034a8 <fileclose>
      p->ofile[fd] = 0;
    80001488:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000148c:	04a1                	addi	s1,s1,8
    8000148e:	01248563          	beq	s1,s2,80001498 <exit+0x4c>
    if(p->ofile[fd]){
    80001492:	6088                	ld	a0,0(s1)
    80001494:	f965                	bnez	a0,80001484 <exit+0x38>
    80001496:	bfdd                	j	8000148c <exit+0x40>
  begin_op();
    80001498:	3f7010ef          	jal	8000308e <begin_op>
  iput(p->cwd);
    8000149c:	1509b503          	ld	a0,336(s3)
    800014a0:	4da010ef          	jal	8000297a <iput>
  end_op();
    800014a4:	455010ef          	jal	800030f8 <end_op>
  p->cwd = 0;
    800014a8:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800014ac:	00009497          	auipc	s1,0x9
    800014b0:	02c48493          	addi	s1,s1,44 # 8000a4d8 <wait_lock>
    800014b4:	8526                	mv	a0,s1
    800014b6:	41a040ef          	jal	800058d0 <acquire>
  reparent(p);
    800014ba:	854e                	mv	a0,s3
    800014bc:	f3bff0ef          	jal	800013f6 <reparent>
  wakeup(p->parent);
    800014c0:	0389b503          	ld	a0,56(s3)
    800014c4:	ec9ff0ef          	jal	8000138c <wakeup>
  acquire(&p->lock);
    800014c8:	854e                	mv	a0,s3
    800014ca:	406040ef          	jal	800058d0 <acquire>
  p->xstate = status;
    800014ce:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014d2:	4795                	li	a5,5
    800014d4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014d8:	8526                	mv	a0,s1
    800014da:	48e040ef          	jal	80005968 <release>
  sched();
    800014de:	d7dff0ef          	jal	8000125a <sched>
  panic("zombie exit");
    800014e2:	00006517          	auipc	a0,0x6
    800014e6:	d4e50513          	addi	a0,a0,-690 # 80007230 <etext+0x230>
    800014ea:	0b8040ef          	jal	800055a2 <panic>

00000000800014ee <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800014ee:	7179                	addi	sp,sp,-48
    800014f0:	f406                	sd	ra,40(sp)
    800014f2:	f022                	sd	s0,32(sp)
    800014f4:	ec26                	sd	s1,24(sp)
    800014f6:	e84a                	sd	s2,16(sp)
    800014f8:	e44e                	sd	s3,8(sp)
    800014fa:	1800                	addi	s0,sp,48
    800014fc:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800014fe:	00009497          	auipc	s1,0x9
    80001502:	3f248493          	addi	s1,s1,1010 # 8000a8f0 <proc>
    80001506:	00014997          	auipc	s3,0x14
    8000150a:	dea98993          	addi	s3,s3,-534 # 800152f0 <tickslock>
    acquire(&p->lock);
    8000150e:	8526                	mv	a0,s1
    80001510:	3c0040ef          	jal	800058d0 <acquire>
    if(p->pid == pid){
    80001514:	589c                	lw	a5,48(s1)
    80001516:	01278b63          	beq	a5,s2,8000152c <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000151a:	8526                	mv	a0,s1
    8000151c:	44c040ef          	jal	80005968 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001520:	2a848493          	addi	s1,s1,680
    80001524:	ff3495e3          	bne	s1,s3,8000150e <kill+0x20>
  }
  return -1;
    80001528:	557d                	li	a0,-1
    8000152a:	a819                	j	80001540 <kill+0x52>
      p->killed = 1;
    8000152c:	4785                	li	a5,1
    8000152e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001530:	4c98                	lw	a4,24(s1)
    80001532:	4789                	li	a5,2
    80001534:	00f70d63          	beq	a4,a5,8000154e <kill+0x60>
      release(&p->lock);
    80001538:	8526                	mv	a0,s1
    8000153a:	42e040ef          	jal	80005968 <release>
      return 0;
    8000153e:	4501                	li	a0,0
}
    80001540:	70a2                	ld	ra,40(sp)
    80001542:	7402                	ld	s0,32(sp)
    80001544:	64e2                	ld	s1,24(sp)
    80001546:	6942                	ld	s2,16(sp)
    80001548:	69a2                	ld	s3,8(sp)
    8000154a:	6145                	addi	sp,sp,48
    8000154c:	8082                	ret
        p->state = RUNNABLE;
    8000154e:	478d                	li	a5,3
    80001550:	cc9c                	sw	a5,24(s1)
    80001552:	b7dd                	j	80001538 <kill+0x4a>

0000000080001554 <setkilled>:

void
setkilled(struct proc *p)
{
    80001554:	1101                	addi	sp,sp,-32
    80001556:	ec06                	sd	ra,24(sp)
    80001558:	e822                	sd	s0,16(sp)
    8000155a:	e426                	sd	s1,8(sp)
    8000155c:	1000                	addi	s0,sp,32
    8000155e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001560:	370040ef          	jal	800058d0 <acquire>
  p->killed = 1;
    80001564:	4785                	li	a5,1
    80001566:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001568:	8526                	mv	a0,s1
    8000156a:	3fe040ef          	jal	80005968 <release>
}
    8000156e:	60e2                	ld	ra,24(sp)
    80001570:	6442                	ld	s0,16(sp)
    80001572:	64a2                	ld	s1,8(sp)
    80001574:	6105                	addi	sp,sp,32
    80001576:	8082                	ret

0000000080001578 <killed>:

int
killed(struct proc *p)
{
    80001578:	1101                	addi	sp,sp,-32
    8000157a:	ec06                	sd	ra,24(sp)
    8000157c:	e822                	sd	s0,16(sp)
    8000157e:	e426                	sd	s1,8(sp)
    80001580:	e04a                	sd	s2,0(sp)
    80001582:	1000                	addi	s0,sp,32
    80001584:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001586:	34a040ef          	jal	800058d0 <acquire>
  k = p->killed;
    8000158a:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000158e:	8526                	mv	a0,s1
    80001590:	3d8040ef          	jal	80005968 <release>
  return k;
}
    80001594:	854a                	mv	a0,s2
    80001596:	60e2                	ld	ra,24(sp)
    80001598:	6442                	ld	s0,16(sp)
    8000159a:	64a2                	ld	s1,8(sp)
    8000159c:	6902                	ld	s2,0(sp)
    8000159e:	6105                	addi	sp,sp,32
    800015a0:	8082                	ret

00000000800015a2 <wait>:
{
    800015a2:	715d                	addi	sp,sp,-80
    800015a4:	e486                	sd	ra,72(sp)
    800015a6:	e0a2                	sd	s0,64(sp)
    800015a8:	fc26                	sd	s1,56(sp)
    800015aa:	f84a                	sd	s2,48(sp)
    800015ac:	f44e                	sd	s3,40(sp)
    800015ae:	f052                	sd	s4,32(sp)
    800015b0:	ec56                	sd	s5,24(sp)
    800015b2:	e85a                	sd	s6,16(sp)
    800015b4:	e45e                	sd	s7,8(sp)
    800015b6:	e062                	sd	s8,0(sp)
    800015b8:	0880                	addi	s0,sp,80
    800015ba:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015bc:	f9eff0ef          	jal	80000d5a <myproc>
    800015c0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015c2:	00009517          	auipc	a0,0x9
    800015c6:	f1650513          	addi	a0,a0,-234 # 8000a4d8 <wait_lock>
    800015ca:	306040ef          	jal	800058d0 <acquire>
    havekids = 0;
    800015ce:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800015d0:	4a15                	li	s4,5
        havekids = 1;
    800015d2:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015d4:	00014997          	auipc	s3,0x14
    800015d8:	d1c98993          	addi	s3,s3,-740 # 800152f0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015dc:	00009c17          	auipc	s8,0x9
    800015e0:	efcc0c13          	addi	s8,s8,-260 # 8000a4d8 <wait_lock>
    800015e4:	a871                	j	80001680 <wait+0xde>
          pid = pp->pid;
    800015e6:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800015ea:	000b0c63          	beqz	s6,80001602 <wait+0x60>
    800015ee:	4691                	li	a3,4
    800015f0:	02c48613          	addi	a2,s1,44
    800015f4:	85da                	mv	a1,s6
    800015f6:	05093503          	ld	a0,80(s2)
    800015fa:	bdeff0ef          	jal	800009d8 <copyout>
    800015fe:	02054b63          	bltz	a0,80001634 <wait+0x92>
          freeproc(pp);
    80001602:	8526                	mv	a0,s1
    80001604:	8c9ff0ef          	jal	80000ecc <freeproc>
          release(&pp->lock);
    80001608:	8526                	mv	a0,s1
    8000160a:	35e040ef          	jal	80005968 <release>
          release(&wait_lock);
    8000160e:	00009517          	auipc	a0,0x9
    80001612:	eca50513          	addi	a0,a0,-310 # 8000a4d8 <wait_lock>
    80001616:	352040ef          	jal	80005968 <release>
}
    8000161a:	854e                	mv	a0,s3
    8000161c:	60a6                	ld	ra,72(sp)
    8000161e:	6406                	ld	s0,64(sp)
    80001620:	74e2                	ld	s1,56(sp)
    80001622:	7942                	ld	s2,48(sp)
    80001624:	79a2                	ld	s3,40(sp)
    80001626:	7a02                	ld	s4,32(sp)
    80001628:	6ae2                	ld	s5,24(sp)
    8000162a:	6b42                	ld	s6,16(sp)
    8000162c:	6ba2                	ld	s7,8(sp)
    8000162e:	6c02                	ld	s8,0(sp)
    80001630:	6161                	addi	sp,sp,80
    80001632:	8082                	ret
            release(&pp->lock);
    80001634:	8526                	mv	a0,s1
    80001636:	332040ef          	jal	80005968 <release>
            release(&wait_lock);
    8000163a:	00009517          	auipc	a0,0x9
    8000163e:	e9e50513          	addi	a0,a0,-354 # 8000a4d8 <wait_lock>
    80001642:	326040ef          	jal	80005968 <release>
            return -1;
    80001646:	59fd                	li	s3,-1
    80001648:	bfc9                	j	8000161a <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000164a:	2a848493          	addi	s1,s1,680
    8000164e:	03348063          	beq	s1,s3,8000166e <wait+0xcc>
      if(pp->parent == p){
    80001652:	7c9c                	ld	a5,56(s1)
    80001654:	ff279be3          	bne	a5,s2,8000164a <wait+0xa8>
        acquire(&pp->lock);
    80001658:	8526                	mv	a0,s1
    8000165a:	276040ef          	jal	800058d0 <acquire>
        if(pp->state == ZOMBIE){
    8000165e:	4c9c                	lw	a5,24(s1)
    80001660:	f94783e3          	beq	a5,s4,800015e6 <wait+0x44>
        release(&pp->lock);
    80001664:	8526                	mv	a0,s1
    80001666:	302040ef          	jal	80005968 <release>
        havekids = 1;
    8000166a:	8756                	mv	a4,s5
    8000166c:	bff9                	j	8000164a <wait+0xa8>
    if(!havekids || killed(p)){
    8000166e:	cf19                	beqz	a4,8000168c <wait+0xea>
    80001670:	854a                	mv	a0,s2
    80001672:	f07ff0ef          	jal	80001578 <killed>
    80001676:	e919                	bnez	a0,8000168c <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001678:	85e2                	mv	a1,s8
    8000167a:	854a                	mv	a0,s2
    8000167c:	cc5ff0ef          	jal	80001340 <sleep>
    havekids = 0;
    80001680:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001682:	00009497          	auipc	s1,0x9
    80001686:	26e48493          	addi	s1,s1,622 # 8000a8f0 <proc>
    8000168a:	b7e1                	j	80001652 <wait+0xb0>
      release(&wait_lock);
    8000168c:	00009517          	auipc	a0,0x9
    80001690:	e4c50513          	addi	a0,a0,-436 # 8000a4d8 <wait_lock>
    80001694:	2d4040ef          	jal	80005968 <release>
      return -1;
    80001698:	59fd                	li	s3,-1
    8000169a:	b741                	j	8000161a <wait+0x78>

000000008000169c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000169c:	7179                	addi	sp,sp,-48
    8000169e:	f406                	sd	ra,40(sp)
    800016a0:	f022                	sd	s0,32(sp)
    800016a2:	ec26                	sd	s1,24(sp)
    800016a4:	e84a                	sd	s2,16(sp)
    800016a6:	e44e                	sd	s3,8(sp)
    800016a8:	e052                	sd	s4,0(sp)
    800016aa:	1800                	addi	s0,sp,48
    800016ac:	84aa                	mv	s1,a0
    800016ae:	892e                	mv	s2,a1
    800016b0:	89b2                	mv	s3,a2
    800016b2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016b4:	ea6ff0ef          	jal	80000d5a <myproc>
  if(user_dst){
    800016b8:	cc99                	beqz	s1,800016d6 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800016ba:	86d2                	mv	a3,s4
    800016bc:	864e                	mv	a2,s3
    800016be:	85ca                	mv	a1,s2
    800016c0:	6928                	ld	a0,80(a0)
    800016c2:	b16ff0ef          	jal	800009d8 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800016c6:	70a2                	ld	ra,40(sp)
    800016c8:	7402                	ld	s0,32(sp)
    800016ca:	64e2                	ld	s1,24(sp)
    800016cc:	6942                	ld	s2,16(sp)
    800016ce:	69a2                	ld	s3,8(sp)
    800016d0:	6a02                	ld	s4,0(sp)
    800016d2:	6145                	addi	sp,sp,48
    800016d4:	8082                	ret
    memmove((char *)dst, src, len);
    800016d6:	000a061b          	sext.w	a2,s4
    800016da:	85ce                	mv	a1,s3
    800016dc:	854a                	mv	a0,s2
    800016de:	acdfe0ef          	jal	800001aa <memmove>
    return 0;
    800016e2:	8526                	mv	a0,s1
    800016e4:	b7cd                	j	800016c6 <either_copyout+0x2a>

00000000800016e6 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800016e6:	7179                	addi	sp,sp,-48
    800016e8:	f406                	sd	ra,40(sp)
    800016ea:	f022                	sd	s0,32(sp)
    800016ec:	ec26                	sd	s1,24(sp)
    800016ee:	e84a                	sd	s2,16(sp)
    800016f0:	e44e                	sd	s3,8(sp)
    800016f2:	e052                	sd	s4,0(sp)
    800016f4:	1800                	addi	s0,sp,48
    800016f6:	892a                	mv	s2,a0
    800016f8:	84ae                	mv	s1,a1
    800016fa:	89b2                	mv	s3,a2
    800016fc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016fe:	e5cff0ef          	jal	80000d5a <myproc>
  if(user_src){
    80001702:	cc99                	beqz	s1,80001720 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001704:	86d2                	mv	a3,s4
    80001706:	864e                	mv	a2,s3
    80001708:	85ca                	mv	a1,s2
    8000170a:	6928                	ld	a0,80(a0)
    8000170c:	ba2ff0ef          	jal	80000aae <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001710:	70a2                	ld	ra,40(sp)
    80001712:	7402                	ld	s0,32(sp)
    80001714:	64e2                	ld	s1,24(sp)
    80001716:	6942                	ld	s2,16(sp)
    80001718:	69a2                	ld	s3,8(sp)
    8000171a:	6a02                	ld	s4,0(sp)
    8000171c:	6145                	addi	sp,sp,48
    8000171e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001720:	000a061b          	sext.w	a2,s4
    80001724:	85ce                	mv	a1,s3
    80001726:	854a                	mv	a0,s2
    80001728:	a83fe0ef          	jal	800001aa <memmove>
    return 0;
    8000172c:	8526                	mv	a0,s1
    8000172e:	b7cd                	j	80001710 <either_copyin+0x2a>

0000000080001730 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001730:	711d                	addi	sp,sp,-96
    80001732:	ec86                	sd	ra,88(sp)
    80001734:	e8a2                	sd	s0,80(sp)
    80001736:	e4a6                	sd	s1,72(sp)
    80001738:	e0ca                	sd	s2,64(sp)
    8000173a:	fc4e                	sd	s3,56(sp)
    8000173c:	f852                	sd	s4,48(sp)
    8000173e:	f456                	sd	s5,40(sp)
    80001740:	f05a                	sd	s6,32(sp)
    80001742:	ec5e                	sd	s7,24(sp)
    80001744:	e862                	sd	s8,16(sp)
    80001746:	e466                	sd	s9,8(sp)
    80001748:	e06a                	sd	s10,0(sp)
    8000174a:	1080                	addi	s0,sp,96
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000174c:	00006517          	auipc	a0,0x6
    80001750:	8cc50513          	addi	a0,a0,-1844 # 80007018 <etext+0x18>
    80001754:	37d030ef          	jal	800052d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001758:	00009917          	auipc	s2,0x9
    8000175c:	2f090913          	addi	s2,s2,752 # 8000aa48 <proc+0x158>
    80001760:	00014997          	auipc	s3,0x14
    80001764:	ce898993          	addi	s3,s3,-792 # 80015448 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001768:	4c95                	li	s9,5
      state = states[p->state];
    else
      state = "???";
    8000176a:	00006a17          	auipc	s4,0x6
    8000176e:	ad6a0a13          	addi	s4,s4,-1322 # 80007240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001772:	00006c17          	auipc	s8,0x6
    80001776:	ad6c0c13          	addi	s8,s8,-1322 # 80007248 <etext+0x248>
    printf("\t sz=%ld kstack=%ld k_ra=%ld k_sp=%ld u_epc=%ld",
    8000177a:	4b81                	li	s7,0
    8000177c:	00006b17          	auipc	s6,0x6
    80001780:	adcb0b13          	addi	s6,s6,-1316 # 80007258 <etext+0x258>
      p->sz, p->kstack, p->context.ra, p->context.sp,
      p->trapframe ? p->trapframe->epc : 0);
    printf("\n");
    80001784:	00006a97          	auipc	s5,0x6
    80001788:	894a8a93          	addi	s5,s5,-1900 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000178c:	00006d17          	auipc	s10,0x6
    80001790:	0ecd0d13          	addi	s10,s10,236 # 80007878 <states.0>
    80001794:	a835                	j	800017d0 <procdump+0xa0>
    printf("%d %s %s", p->pid, state, p->name);
    80001796:	86a6                	mv	a3,s1
    80001798:	ed84a583          	lw	a1,-296(s1)
    8000179c:	8562                	mv	a0,s8
    8000179e:	333030ef          	jal	800052d0 <printf>
    printf("\t sz=%ld kstack=%ld k_ra=%ld k_sp=%ld u_epc=%ld",
    800017a2:	ef04b583          	ld	a1,-272(s1)
    800017a6:	ee84b603          	ld	a2,-280(s1)
    800017aa:	f084b683          	ld	a3,-248(s1)
    800017ae:	f104b703          	ld	a4,-240(s1)
      p->trapframe ? p->trapframe->epc : 0);
    800017b2:	f004b503          	ld	a0,-256(s1)
    printf("\t sz=%ld kstack=%ld k_ra=%ld k_sp=%ld u_epc=%ld",
    800017b6:	87de                	mv	a5,s7
    800017b8:	c111                	beqz	a0,800017bc <procdump+0x8c>
    800017ba:	6d1c                	ld	a5,24(a0)
    800017bc:	855a                	mv	a0,s6
    800017be:	313030ef          	jal	800052d0 <printf>
    printf("\n");
    800017c2:	8556                	mv	a0,s5
    800017c4:	30d030ef          	jal	800052d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017c8:	2a890913          	addi	s2,s2,680
    800017cc:	03390263          	beq	s2,s3,800017f0 <procdump+0xc0>
    if(p->state == UNUSED)
    800017d0:	84ca                	mv	s1,s2
    800017d2:	ec092783          	lw	a5,-320(s2)
    800017d6:	dbed                	beqz	a5,800017c8 <procdump+0x98>
      state = "???";
    800017d8:	8652                	mv	a2,s4
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017da:	fafceee3          	bltu	s9,a5,80001796 <procdump+0x66>
    800017de:	02079713          	slli	a4,a5,0x20
    800017e2:	01d75793          	srli	a5,a4,0x1d
    800017e6:	97ea                	add	a5,a5,s10
    800017e8:	6390                	ld	a2,0(a5)
    800017ea:	f655                	bnez	a2,80001796 <procdump+0x66>
      state = "???";
    800017ec:	8652                	mv	a2,s4
    800017ee:	b765                	j	80001796 <procdump+0x66>
  }
}
    800017f0:	60e6                	ld	ra,88(sp)
    800017f2:	6446                	ld	s0,80(sp)
    800017f4:	64a6                	ld	s1,72(sp)
    800017f6:	6906                	ld	s2,64(sp)
    800017f8:	79e2                	ld	s3,56(sp)
    800017fa:	7a42                	ld	s4,48(sp)
    800017fc:	7aa2                	ld	s5,40(sp)
    800017fe:	7b02                	ld	s6,32(sp)
    80001800:	6be2                	ld	s7,24(sp)
    80001802:	6c42                	ld	s8,16(sp)
    80001804:	6ca2                	ld	s9,8(sp)
    80001806:	6d02                	ld	s10,0(sp)
    80001808:	6125                	addi	sp,sp,96
    8000180a:	8082                	ret

000000008000180c <swtch>:
    8000180c:	00153023          	sd	ra,0(a0)
    80001810:	00253423          	sd	sp,8(a0)
    80001814:	e900                	sd	s0,16(a0)
    80001816:	ed04                	sd	s1,24(a0)
    80001818:	03253023          	sd	s2,32(a0)
    8000181c:	03353423          	sd	s3,40(a0)
    80001820:	03453823          	sd	s4,48(a0)
    80001824:	03553c23          	sd	s5,56(a0)
    80001828:	05653023          	sd	s6,64(a0)
    8000182c:	05753423          	sd	s7,72(a0)
    80001830:	05853823          	sd	s8,80(a0)
    80001834:	05953c23          	sd	s9,88(a0)
    80001838:	07a53023          	sd	s10,96(a0)
    8000183c:	07b53423          	sd	s11,104(a0)
    80001840:	0005b083          	ld	ra,0(a1)
    80001844:	0085b103          	ld	sp,8(a1)
    80001848:	6980                	ld	s0,16(a1)
    8000184a:	6d84                	ld	s1,24(a1)
    8000184c:	0205b903          	ld	s2,32(a1)
    80001850:	0285b983          	ld	s3,40(a1)
    80001854:	0305ba03          	ld	s4,48(a1)
    80001858:	0385ba83          	ld	s5,56(a1)
    8000185c:	0405bb03          	ld	s6,64(a1)
    80001860:	0485bb83          	ld	s7,72(a1)
    80001864:	0505bc03          	ld	s8,80(a1)
    80001868:	0585bc83          	ld	s9,88(a1)
    8000186c:	0605bd03          	ld	s10,96(a1)
    80001870:	0685bd83          	ld	s11,104(a1)
    80001874:	8082                	ret

0000000080001876 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001876:	1141                	addi	sp,sp,-16
    80001878:	e406                	sd	ra,8(sp)
    8000187a:	e022                	sd	s0,0(sp)
    8000187c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000187e:	00006597          	auipc	a1,0x6
    80001882:	a3a58593          	addi	a1,a1,-1478 # 800072b8 <etext+0x2b8>
    80001886:	00014517          	auipc	a0,0x14
    8000188a:	a6a50513          	addi	a0,a0,-1430 # 800152f0 <tickslock>
    8000188e:	7c3030ef          	jal	80005850 <initlock>
}
    80001892:	60a2                	ld	ra,8(sp)
    80001894:	6402                	ld	s0,0(sp)
    80001896:	0141                	addi	sp,sp,16
    80001898:	8082                	ret

000000008000189a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000189a:	1141                	addi	sp,sp,-16
    8000189c:	e422                	sd	s0,8(sp)
    8000189e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018a0:	00003797          	auipc	a5,0x3
    800018a4:	f7078793          	addi	a5,a5,-144 # 80004810 <kernelvec>
    800018a8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800018ac:	6422                	ld	s0,8(sp)
    800018ae:	0141                	addi	sp,sp,16
    800018b0:	8082                	ret

00000000800018b2 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800018b2:	1141                	addi	sp,sp,-16
    800018b4:	e406                	sd	ra,8(sp)
    800018b6:	e022                	sd	s0,0(sp)
    800018b8:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800018ba:	ca0ff0ef          	jal	80000d5a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018be:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800018c2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018c4:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800018c8:	00004697          	auipc	a3,0x4
    800018cc:	73868693          	addi	a3,a3,1848 # 80006000 <_trampoline>
    800018d0:	00004717          	auipc	a4,0x4
    800018d4:	73070713          	addi	a4,a4,1840 # 80006000 <_trampoline>
    800018d8:	8f15                	sub	a4,a4,a3
    800018da:	040007b7          	lui	a5,0x4000
    800018de:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800018e0:	07b2                	slli	a5,a5,0xc
    800018e2:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018e4:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800018e8:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800018ea:	18002673          	csrr	a2,satp
    800018ee:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800018f0:	6d30                	ld	a2,88(a0)
    800018f2:	6138                	ld	a4,64(a0)
    800018f4:	6585                	lui	a1,0x1
    800018f6:	972e                	add	a4,a4,a1
    800018f8:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800018fa:	6d38                	ld	a4,88(a0)
    800018fc:	00000617          	auipc	a2,0x0
    80001900:	11060613          	addi	a2,a2,272 # 80001a0c <usertrap>
    80001904:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001906:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001908:	8612                	mv	a2,tp
    8000190a:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000190c:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001910:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001914:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001918:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000191c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000191e:	6f18                	ld	a4,24(a4)
    80001920:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001924:	6928                	ld	a0,80(a0)
    80001926:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001928:	00004717          	auipc	a4,0x4
    8000192c:	77470713          	addi	a4,a4,1908 # 8000609c <userret>
    80001930:	8f15                	sub	a4,a4,a3
    80001932:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001934:	577d                	li	a4,-1
    80001936:	177e                	slli	a4,a4,0x3f
    80001938:	8d59                	or	a0,a0,a4
    8000193a:	9782                	jalr	a5
}
    8000193c:	60a2                	ld	ra,8(sp)
    8000193e:	6402                	ld	s0,0(sp)
    80001940:	0141                	addi	sp,sp,16
    80001942:	8082                	ret

0000000080001944 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001944:	1101                	addi	sp,sp,-32
    80001946:	ec06                	sd	ra,24(sp)
    80001948:	e822                	sd	s0,16(sp)
    8000194a:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000194c:	be2ff0ef          	jal	80000d2e <cpuid>
    80001950:	cd11                	beqz	a0,8000196c <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001952:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001956:	000f4737          	lui	a4,0xf4
    8000195a:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000195e:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001960:	14d79073          	csrw	stimecmp,a5
}
    80001964:	60e2                	ld	ra,24(sp)
    80001966:	6442                	ld	s0,16(sp)
    80001968:	6105                	addi	sp,sp,32
    8000196a:	8082                	ret
    8000196c:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    8000196e:	00014497          	auipc	s1,0x14
    80001972:	98248493          	addi	s1,s1,-1662 # 800152f0 <tickslock>
    80001976:	8526                	mv	a0,s1
    80001978:	759030ef          	jal	800058d0 <acquire>
    ticks++;
    8000197c:	00009517          	auipc	a0,0x9
    80001980:	b0c50513          	addi	a0,a0,-1268 # 8000a488 <ticks>
    80001984:	411c                	lw	a5,0(a0)
    80001986:	2785                	addiw	a5,a5,1
    80001988:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    8000198a:	a03ff0ef          	jal	8000138c <wakeup>
    release(&tickslock);
    8000198e:	8526                	mv	a0,s1
    80001990:	7d9030ef          	jal	80005968 <release>
    80001994:	64a2                	ld	s1,8(sp)
    80001996:	bf75                	j	80001952 <clockintr+0xe>

0000000080001998 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001998:	1101                	addi	sp,sp,-32
    8000199a:	ec06                	sd	ra,24(sp)
    8000199c:	e822                	sd	s0,16(sp)
    8000199e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019a0:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800019a4:	57fd                	li	a5,-1
    800019a6:	17fe                	slli	a5,a5,0x3f
    800019a8:	07a5                	addi	a5,a5,9
    800019aa:	00f70c63          	beq	a4,a5,800019c2 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800019ae:	57fd                	li	a5,-1
    800019b0:	17fe                	slli	a5,a5,0x3f
    800019b2:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800019b4:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800019b6:	04f70763          	beq	a4,a5,80001a04 <devintr+0x6c>
  }
}
    800019ba:	60e2                	ld	ra,24(sp)
    800019bc:	6442                	ld	s0,16(sp)
    800019be:	6105                	addi	sp,sp,32
    800019c0:	8082                	ret
    800019c2:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800019c4:	6f9020ef          	jal	800048bc <plic_claim>
    800019c8:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800019ca:	47a9                	li	a5,10
    800019cc:	00f50963          	beq	a0,a5,800019de <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800019d0:	4785                	li	a5,1
    800019d2:	00f50963          	beq	a0,a5,800019e4 <devintr+0x4c>
    return 1;
    800019d6:	4505                	li	a0,1
    } else if(irq){
    800019d8:	e889                	bnez	s1,800019ea <devintr+0x52>
    800019da:	64a2                	ld	s1,8(sp)
    800019dc:	bff9                	j	800019ba <devintr+0x22>
      uartintr();
    800019de:	637030ef          	jal	80005814 <uartintr>
    if(irq)
    800019e2:	a819                	j	800019f8 <devintr+0x60>
      virtio_disk_intr();
    800019e4:	39e030ef          	jal	80004d82 <virtio_disk_intr>
    if(irq)
    800019e8:	a801                	j	800019f8 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800019ea:	85a6                	mv	a1,s1
    800019ec:	00006517          	auipc	a0,0x6
    800019f0:	8d450513          	addi	a0,a0,-1836 # 800072c0 <etext+0x2c0>
    800019f4:	0dd030ef          	jal	800052d0 <printf>
      plic_complete(irq);
    800019f8:	8526                	mv	a0,s1
    800019fa:	6e3020ef          	jal	800048dc <plic_complete>
    return 1;
    800019fe:	4505                	li	a0,1
    80001a00:	64a2                	ld	s1,8(sp)
    80001a02:	bf65                	j	800019ba <devintr+0x22>
    clockintr();
    80001a04:	f41ff0ef          	jal	80001944 <clockintr>
    return 2;
    80001a08:	4509                	li	a0,2
    80001a0a:	bf45                	j	800019ba <devintr+0x22>

0000000080001a0c <usertrap>:
{
    80001a0c:	1101                	addi	sp,sp,-32
    80001a0e:	ec06                	sd	ra,24(sp)
    80001a10:	e822                	sd	s0,16(sp)
    80001a12:	e426                	sd	s1,8(sp)
    80001a14:	e04a                	sd	s2,0(sp)
    80001a16:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a18:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a1c:	1007f793          	andi	a5,a5,256
    80001a20:	ef85                	bnez	a5,80001a58 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a22:	00003797          	auipc	a5,0x3
    80001a26:	dee78793          	addi	a5,a5,-530 # 80004810 <kernelvec>
    80001a2a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a2e:	b2cff0ef          	jal	80000d5a <myproc>
    80001a32:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a34:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a36:	14102773          	csrr	a4,sepc
    80001a3a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a3c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a40:	47a1                	li	a5,8
    80001a42:	02f70163          	beq	a4,a5,80001a64 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80001a46:	f53ff0ef          	jal	80001998 <devintr>
    80001a4a:	892a                	mv	s2,a0
    80001a4c:	c135                	beqz	a0,80001ab0 <usertrap+0xa4>
  if(killed(p))
    80001a4e:	8526                	mv	a0,s1
    80001a50:	b29ff0ef          	jal	80001578 <killed>
    80001a54:	cd1d                	beqz	a0,80001a92 <usertrap+0x86>
    80001a56:	a81d                	j	80001a8c <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001a58:	00006517          	auipc	a0,0x6
    80001a5c:	88850513          	addi	a0,a0,-1912 # 800072e0 <etext+0x2e0>
    80001a60:	343030ef          	jal	800055a2 <panic>
    if(killed(p))
    80001a64:	b15ff0ef          	jal	80001578 <killed>
    80001a68:	e121                	bnez	a0,80001aa8 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001a6a:	6cb8                	ld	a4,88(s1)
    80001a6c:	6f1c                	ld	a5,24(a4)
    80001a6e:	0791                	addi	a5,a5,4
    80001a70:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a72:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a76:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a7a:	10079073          	csrw	sstatus,a5
    syscall();
    80001a7e:	298000ef          	jal	80001d16 <syscall>
  if(killed(p))
    80001a82:	8526                	mv	a0,s1
    80001a84:	af5ff0ef          	jal	80001578 <killed>
    80001a88:	c901                	beqz	a0,80001a98 <usertrap+0x8c>
    80001a8a:	4901                	li	s2,0
    exit(-1);
    80001a8c:	557d                	li	a0,-1
    80001a8e:	9bfff0ef          	jal	8000144c <exit>
  if(which_dev == 2) { // Timer interrupt from user mode
    80001a92:	4789                	li	a5,2
    80001a94:	04f90563          	beq	s2,a5,80001ade <usertrap+0xd2>
  usertrapret();
    80001a98:	e1bff0ef          	jal	800018b2 <usertrapret>
}
    80001a9c:	60e2                	ld	ra,24(sp)
    80001a9e:	6442                	ld	s0,16(sp)
    80001aa0:	64a2                	ld	s1,8(sp)
    80001aa2:	6902                	ld	s2,0(sp)
    80001aa4:	6105                	addi	sp,sp,32
    80001aa6:	8082                	ret
      exit(-1);
    80001aa8:	557d                	li	a0,-1
    80001aaa:	9a3ff0ef          	jal	8000144c <exit>
    80001aae:	bf75                	j	80001a6a <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ab0:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001ab4:	5890                	lw	a2,48(s1)
    80001ab6:	00006517          	auipc	a0,0x6
    80001aba:	84a50513          	addi	a0,a0,-1974 # 80007300 <etext+0x300>
    80001abe:	013030ef          	jal	800052d0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ac2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ac6:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001aca:	00006517          	auipc	a0,0x6
    80001ace:	86650513          	addi	a0,a0,-1946 # 80007330 <etext+0x330>
    80001ad2:	7fe030ef          	jal	800052d0 <printf>
    setkilled(p);
    80001ad6:	8526                	mv	a0,s1
    80001ad8:	a7dff0ef          	jal	80001554 <setkilled>
    80001adc:	b75d                	j	80001a82 <usertrap+0x76>
    acquire(&p->lock); // Acquire lock to safely access/modify process's alarm state
    80001ade:	8526                	mv	a0,s1
    80001ae0:	5f1030ef          	jal	800058d0 <acquire>
    if (p->alarmticks > 0) {
    80001ae4:	16c4a783          	lw	a5,364(s1)
    80001ae8:	00f05e63          	blez	a5,80001b04 <usertrap+0xf8>
      if (p->handling_alarm == 0) {
    80001aec:	2a04a703          	lw	a4,672(s1)
    80001af0:	eb11                	bnez	a4,80001b04 <usertrap+0xf8>
        p->curticks++; // Increment the count of ticks elapsed since the last alarm
    80001af2:	1704a703          	lw	a4,368(s1)
    80001af6:	2705                	addiw	a4,a4,1
    80001af8:	0007069b          	sext.w	a3,a4
        if (p->curticks >= p->alarmticks) {
    80001afc:	00f6da63          	bge	a3,a5,80001b10 <usertrap+0x104>
        p->curticks++; // Increment the count of ticks elapsed since the last alarm
    80001b00:	16e4a823          	sw	a4,368(s1)
    release(&p->lock); // Release the process lock
    80001b04:	8526                	mv	a0,s1
    80001b06:	663030ef          	jal	80005968 <release>
    yield();           // Yield the CPU, as is standard for timer interrupts from user mode
    80001b0a:	80bff0ef          	jal	80001314 <yield>
    80001b0e:	b769                	j	80001a98 <usertrap+0x8c>
          p->curticks = 0; // Reset the tick counter for the next interval
    80001b10:	1604a823          	sw	zero,368(s1)
          p->handling_alarm = 1; // Set the flag to indicate we are now in the alarm delivery phase
    80001b14:	4785                	li	a5,1
    80001b16:	2af4a023          	sw	a5,672(s1)
          memmove(&p->alarm_trapframe_backup, p->trapframe, sizeof(struct trapframe));
    80001b1a:	12000613          	li	a2,288
    80001b1e:	6cac                	ld	a1,88(s1)
    80001b20:	18048513          	addi	a0,s1,384
    80001b24:	e86fe0ef          	jal	800001aa <memmove>
          p->trapframe->epc = p->user_alarm_handler_va;
    80001b28:	6cbc                	ld	a5,88(s1)
    80001b2a:	1784b703          	ld	a4,376(s1)
    80001b2e:	ef98                	sd	a4,24(a5)
    80001b30:	bfd1                	j	80001b04 <usertrap+0xf8>

0000000080001b32 <kerneltrap>:
{
    80001b32:	7179                	addi	sp,sp,-48
    80001b34:	f406                	sd	ra,40(sp)
    80001b36:	f022                	sd	s0,32(sp)
    80001b38:	ec26                	sd	s1,24(sp)
    80001b3a:	e84a                	sd	s2,16(sp)
    80001b3c:	e44e                	sd	s3,8(sp)
    80001b3e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b40:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b44:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b48:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001b4c:	1004f793          	andi	a5,s1,256
    80001b50:	c795                	beqz	a5,80001b7c <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b52:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b56:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b58:	eb85                	bnez	a5,80001b88 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001b5a:	e3fff0ef          	jal	80001998 <devintr>
    80001b5e:	c91d                	beqz	a0,80001b94 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001b60:	4789                	li	a5,2
    80001b62:	04f50a63          	beq	a0,a5,80001bb6 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b66:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b6a:	10049073          	csrw	sstatus,s1
}
    80001b6e:	70a2                	ld	ra,40(sp)
    80001b70:	7402                	ld	s0,32(sp)
    80001b72:	64e2                	ld	s1,24(sp)
    80001b74:	6942                	ld	s2,16(sp)
    80001b76:	69a2                	ld	s3,8(sp)
    80001b78:	6145                	addi	sp,sp,48
    80001b7a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001b7c:	00005517          	auipc	a0,0x5
    80001b80:	7dc50513          	addi	a0,a0,2012 # 80007358 <etext+0x358>
    80001b84:	21f030ef          	jal	800055a2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001b88:	00005517          	auipc	a0,0x5
    80001b8c:	7f850513          	addi	a0,a0,2040 # 80007380 <etext+0x380>
    80001b90:	213030ef          	jal	800055a2 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b94:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b98:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b9c:	85ce                	mv	a1,s3
    80001b9e:	00006517          	auipc	a0,0x6
    80001ba2:	80250513          	addi	a0,a0,-2046 # 800073a0 <etext+0x3a0>
    80001ba6:	72a030ef          	jal	800052d0 <printf>
    panic("kerneltrap");
    80001baa:	00006517          	auipc	a0,0x6
    80001bae:	81e50513          	addi	a0,a0,-2018 # 800073c8 <etext+0x3c8>
    80001bb2:	1f1030ef          	jal	800055a2 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001bb6:	9a4ff0ef          	jal	80000d5a <myproc>
    80001bba:	d555                	beqz	a0,80001b66 <kerneltrap+0x34>
    yield();
    80001bbc:	f58ff0ef          	jal	80001314 <yield>
    80001bc0:	b75d                	j	80001b66 <kerneltrap+0x34>

0000000080001bc2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001bc2:	1101                	addi	sp,sp,-32
    80001bc4:	ec06                	sd	ra,24(sp)
    80001bc6:	e822                	sd	s0,16(sp)
    80001bc8:	e426                	sd	s1,8(sp)
    80001bca:	1000                	addi	s0,sp,32
    80001bcc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001bce:	98cff0ef          	jal	80000d5a <myproc>
  switch (n) {
    80001bd2:	4795                	li	a5,5
    80001bd4:	0497e163          	bltu	a5,s1,80001c16 <argraw+0x54>
    80001bd8:	048a                	slli	s1,s1,0x2
    80001bda:	00006717          	auipc	a4,0x6
    80001bde:	cce70713          	addi	a4,a4,-818 # 800078a8 <states.0+0x30>
    80001be2:	94ba                	add	s1,s1,a4
    80001be4:	409c                	lw	a5,0(s1)
    80001be6:	97ba                	add	a5,a5,a4
    80001be8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001bea:	6d3c                	ld	a5,88(a0)
    80001bec:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001bee:	60e2                	ld	ra,24(sp)
    80001bf0:	6442                	ld	s0,16(sp)
    80001bf2:	64a2                	ld	s1,8(sp)
    80001bf4:	6105                	addi	sp,sp,32
    80001bf6:	8082                	ret
    return p->trapframe->a1;
    80001bf8:	6d3c                	ld	a5,88(a0)
    80001bfa:	7fa8                	ld	a0,120(a5)
    80001bfc:	bfcd                	j	80001bee <argraw+0x2c>
    return p->trapframe->a2;
    80001bfe:	6d3c                	ld	a5,88(a0)
    80001c00:	63c8                	ld	a0,128(a5)
    80001c02:	b7f5                	j	80001bee <argraw+0x2c>
    return p->trapframe->a3;
    80001c04:	6d3c                	ld	a5,88(a0)
    80001c06:	67c8                	ld	a0,136(a5)
    80001c08:	b7dd                	j	80001bee <argraw+0x2c>
    return p->trapframe->a4;
    80001c0a:	6d3c                	ld	a5,88(a0)
    80001c0c:	6bc8                	ld	a0,144(a5)
    80001c0e:	b7c5                	j	80001bee <argraw+0x2c>
    return p->trapframe->a5;
    80001c10:	6d3c                	ld	a5,88(a0)
    80001c12:	6fc8                	ld	a0,152(a5)
    80001c14:	bfe9                	j	80001bee <argraw+0x2c>
  panic("argraw");
    80001c16:	00005517          	auipc	a0,0x5
    80001c1a:	7c250513          	addi	a0,a0,1986 # 800073d8 <etext+0x3d8>
    80001c1e:	185030ef          	jal	800055a2 <panic>

0000000080001c22 <fetchaddr>:
{
    80001c22:	1101                	addi	sp,sp,-32
    80001c24:	ec06                	sd	ra,24(sp)
    80001c26:	e822                	sd	s0,16(sp)
    80001c28:	e426                	sd	s1,8(sp)
    80001c2a:	e04a                	sd	s2,0(sp)
    80001c2c:	1000                	addi	s0,sp,32
    80001c2e:	84aa                	mv	s1,a0
    80001c30:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c32:	928ff0ef          	jal	80000d5a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c36:	653c                	ld	a5,72(a0)
    80001c38:	02f4f663          	bgeu	s1,a5,80001c64 <fetchaddr+0x42>
    80001c3c:	00848713          	addi	a4,s1,8
    80001c40:	02e7e463          	bltu	a5,a4,80001c68 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c44:	46a1                	li	a3,8
    80001c46:	8626                	mv	a2,s1
    80001c48:	85ca                	mv	a1,s2
    80001c4a:	6928                	ld	a0,80(a0)
    80001c4c:	e63fe0ef          	jal	80000aae <copyin>
    80001c50:	00a03533          	snez	a0,a0
    80001c54:	40a00533          	neg	a0,a0
}
    80001c58:	60e2                	ld	ra,24(sp)
    80001c5a:	6442                	ld	s0,16(sp)
    80001c5c:	64a2                	ld	s1,8(sp)
    80001c5e:	6902                	ld	s2,0(sp)
    80001c60:	6105                	addi	sp,sp,32
    80001c62:	8082                	ret
    return -1;
    80001c64:	557d                	li	a0,-1
    80001c66:	bfcd                	j	80001c58 <fetchaddr+0x36>
    80001c68:	557d                	li	a0,-1
    80001c6a:	b7fd                	j	80001c58 <fetchaddr+0x36>

0000000080001c6c <fetchstr>:
{
    80001c6c:	7179                	addi	sp,sp,-48
    80001c6e:	f406                	sd	ra,40(sp)
    80001c70:	f022                	sd	s0,32(sp)
    80001c72:	ec26                	sd	s1,24(sp)
    80001c74:	e84a                	sd	s2,16(sp)
    80001c76:	e44e                	sd	s3,8(sp)
    80001c78:	1800                	addi	s0,sp,48
    80001c7a:	892a                	mv	s2,a0
    80001c7c:	84ae                	mv	s1,a1
    80001c7e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001c80:	8daff0ef          	jal	80000d5a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001c84:	86ce                	mv	a3,s3
    80001c86:	864a                	mv	a2,s2
    80001c88:	85a6                	mv	a1,s1
    80001c8a:	6928                	ld	a0,80(a0)
    80001c8c:	ea9fe0ef          	jal	80000b34 <copyinstr>
    80001c90:	00054c63          	bltz	a0,80001ca8 <fetchstr+0x3c>
  return strlen(buf);
    80001c94:	8526                	mv	a0,s1
    80001c96:	e28fe0ef          	jal	800002be <strlen>
}
    80001c9a:	70a2                	ld	ra,40(sp)
    80001c9c:	7402                	ld	s0,32(sp)
    80001c9e:	64e2                	ld	s1,24(sp)
    80001ca0:	6942                	ld	s2,16(sp)
    80001ca2:	69a2                	ld	s3,8(sp)
    80001ca4:	6145                	addi	sp,sp,48
    80001ca6:	8082                	ret
    return -1;
    80001ca8:	557d                	li	a0,-1
    80001caa:	bfc5                	j	80001c9a <fetchstr+0x2e>

0000000080001cac <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001cac:	1101                	addi	sp,sp,-32
    80001cae:	ec06                	sd	ra,24(sp)
    80001cb0:	e822                	sd	s0,16(sp)
    80001cb2:	e426                	sd	s1,8(sp)
    80001cb4:	1000                	addi	s0,sp,32
    80001cb6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cb8:	f0bff0ef          	jal	80001bc2 <argraw>
    80001cbc:	c088                	sw	a0,0(s1)

  return 0; // <--- 添加这行，明确返回 0 表示成功
}
    80001cbe:	4501                	li	a0,0
    80001cc0:	60e2                	ld	ra,24(sp)
    80001cc2:	6442                	ld	s0,16(sp)
    80001cc4:	64a2                	ld	s1,8(sp)
    80001cc6:	6105                	addi	sp,sp,32
    80001cc8:	8082                	ret

0000000080001cca <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001cca:	1101                	addi	sp,sp,-32
    80001ccc:	ec06                	sd	ra,24(sp)
    80001cce:	e822                	sd	s0,16(sp)
    80001cd0:	e426                	sd	s1,8(sp)
    80001cd2:	1000                	addi	s0,sp,32
    80001cd4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cd6:	eedff0ef          	jal	80001bc2 <argraw>
    80001cda:	e088                	sd	a0,0(s1)
}
    80001cdc:	60e2                	ld	ra,24(sp)
    80001cde:	6442                	ld	s0,16(sp)
    80001ce0:	64a2                	ld	s1,8(sp)
    80001ce2:	6105                	addi	sp,sp,32
    80001ce4:	8082                	ret

0000000080001ce6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001ce6:	7179                	addi	sp,sp,-48
    80001ce8:	f406                	sd	ra,40(sp)
    80001cea:	f022                	sd	s0,32(sp)
    80001cec:	ec26                	sd	s1,24(sp)
    80001cee:	e84a                	sd	s2,16(sp)
    80001cf0:	1800                	addi	s0,sp,48
    80001cf2:	84ae                	mv	s1,a1
    80001cf4:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001cf6:	fd840593          	addi	a1,s0,-40
    80001cfa:	fd1ff0ef          	jal	80001cca <argaddr>
  return fetchstr(addr, buf, max);
    80001cfe:	864a                	mv	a2,s2
    80001d00:	85a6                	mv	a1,s1
    80001d02:	fd843503          	ld	a0,-40(s0)
    80001d06:	f67ff0ef          	jal	80001c6c <fetchstr>
}
    80001d0a:	70a2                	ld	ra,40(sp)
    80001d0c:	7402                	ld	s0,32(sp)
    80001d0e:	64e2                	ld	s1,24(sp)
    80001d10:	6942                	ld	s2,16(sp)
    80001d12:	6145                	addi	sp,sp,48
    80001d14:	8082                	ret

0000000080001d16 <syscall>:
  [SYS_sigreturn] "sigreturn", // <<< CORRECT: string literal
  };

void
syscall(void)
{
    80001d16:	7179                	addi	sp,sp,-48
    80001d18:	f406                	sd	ra,40(sp)
    80001d1a:	f022                	sd	s0,32(sp)
    80001d1c:	ec26                	sd	s1,24(sp)
    80001d1e:	e84a                	sd	s2,16(sp)
    80001d20:	e44e                	sd	s3,8(sp)
    80001d22:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80001d24:	836ff0ef          	jal	80000d5a <myproc>
    80001d28:	84aa                	mv	s1,a0

  //start test
  // printf("NELEM(syscalls) = %lu\n", NELEM(syscalls)); // <--- 将 %d 改为 %lu

  num = p->trapframe->a7;
    80001d2a:	05853903          	ld	s2,88(a0)
    80001d2e:	0a893783          	ld	a5,168(s2)
    80001d32:	0007899b          	sext.w	s3,a5
  // printf("syscalls[SYS_exec]: %p\n", syscalls[SYS_exec]);
  // printf("syscalls[SYS_write]: %p\n", syscalls[SYS_write]);
  // printf("syscalls[SYS_trace]: %p\n", syscalls[SYS_trace]); // 打印地址用 %p
  // end test

  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001d36:	37fd                	addiw	a5,a5,-1
    80001d38:	475d                	li	a4,23
    80001d3a:	04f76663          	bltu	a4,a5,80001d86 <syscall+0x70>
    80001d3e:	00399713          	slli	a4,s3,0x3
    80001d42:	00006797          	auipc	a5,0x6
    80001d46:	b7e78793          	addi	a5,a5,-1154 # 800078c0 <syscalls>
    80001d4a:	97ba                	add	a5,a5,a4
    80001d4c:	639c                	ld	a5,0(a5)
    80001d4e:	cf85                	beqz	a5,80001d86 <syscall+0x70>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001d50:	9782                	jalr	a5
    80001d52:	06a93823          	sd	a0,112(s2)

    // ---- 添加追踪逻辑 ----
    // 检查当前进程的 tracemask 中是否设置了对应系统调用号的位
    // (1 << num) 创建一个只有第 num 位为 1 的掩码
    if ((p->tracemask & (1 << num))) {
    80001d56:	1684a783          	lw	a5,360(s1)
    80001d5a:	4137d7bb          	sraw	a5,a5,s3
    80001d5e:	8b85                	andi	a5,a5,1
    80001d60:	c3a1                	beqz	a5,80001da0 <syscall+0x8a>
         // 检查 syscall_names 数组是否有效，避免越界或访问空指针
         if (num > 0 && num < NELEM(syscall_names) && syscall_names[num]) {
    80001d62:	098e                	slli	s3,s3,0x3
    80001d64:	00006797          	auipc	a5,0x6
    80001d68:	b5c78793          	addi	a5,a5,-1188 # 800078c0 <syscalls>
    80001d6c:	97ce                	add	a5,a5,s3
    80001d6e:	67f0                	ld	a2,200(a5)
    80001d70:	ca05                	beqz	a2,80001da0 <syscall+0x8a>
              // 在 syscall() 函数的追踪逻辑部分
              printf("%d: syscall %s -> %lu\n", p->pid, syscall_names[num], p->trapframe->a0);
    80001d72:	6cbc                	ld	a5,88(s1)
    80001d74:	7bb4                	ld	a3,112(a5)
    80001d76:	588c                	lw	a1,48(s1)
    80001d78:	00005517          	auipc	a0,0x5
    80001d7c:	66850513          	addi	a0,a0,1640 # 800073e0 <etext+0x3e0>
    80001d80:	550030ef          	jal	800052d0 <printf>
    80001d84:	a831                	j	80001da0 <syscall+0x8a>
         }
    // ---- 追踪逻辑结束 ----
  }
  } else {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80001d86:	86ce                	mv	a3,s3
    80001d88:	15848613          	addi	a2,s1,344
    80001d8c:	588c                	lw	a1,48(s1)
    80001d8e:	00005517          	auipc	a0,0x5
    80001d92:	66a50513          	addi	a0,a0,1642 # 800073f8 <etext+0x3f8>
    80001d96:	53a030ef          	jal	800052d0 <printf>
    p->trapframe->a0 = -1;
    80001d9a:	6cbc                	ld	a5,88(s1)
    80001d9c:	577d                	li	a4,-1
    80001d9e:	fbb8                	sd	a4,112(a5)
  }
    80001da0:	70a2                	ld	ra,40(sp)
    80001da2:	7402                	ld	s0,32(sp)
    80001da4:	64e2                	ld	s1,24(sp)
    80001da6:	6942                	ld	s2,16(sp)
    80001da8:	69a2                	ld	s3,8(sp)
    80001daa:	6145                	addi	sp,sp,48
    80001dac:	8082                	ret

0000000080001dae <sys_exit>:
#include "proc.h"
#include "syscall.h" // 确保包含 syscall.h 以便使用 SYS_ 定义// ... (其他 sys_ 函数) ...

uint64
sys_exit(void)
{
    80001dae:	1101                	addi	sp,sp,-32
    80001db0:	ec06                	sd	ra,24(sp)
    80001db2:	e822                	sd	s0,16(sp)
    80001db4:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001db6:	fec40593          	addi	a1,s0,-20
    80001dba:	4501                	li	a0,0
    80001dbc:	ef1ff0ef          	jal	80001cac <argint>
  exit(n);
    80001dc0:	fec42503          	lw	a0,-20(s0)
    80001dc4:	e88ff0ef          	jal	8000144c <exit>
  return 0;  // not reached
}
    80001dc8:	4501                	li	a0,0
    80001dca:	60e2                	ld	ra,24(sp)
    80001dcc:	6442                	ld	s0,16(sp)
    80001dce:	6105                	addi	sp,sp,32
    80001dd0:	8082                	ret

0000000080001dd2 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001dd2:	1141                	addi	sp,sp,-16
    80001dd4:	e406                	sd	ra,8(sp)
    80001dd6:	e022                	sd	s0,0(sp)
    80001dd8:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001dda:	f81fe0ef          	jal	80000d5a <myproc>
}
    80001dde:	5908                	lw	a0,48(a0)
    80001de0:	60a2                	ld	ra,8(sp)
    80001de2:	6402                	ld	s0,0(sp)
    80001de4:	0141                	addi	sp,sp,16
    80001de6:	8082                	ret

0000000080001de8 <sys_fork>:

uint64
sys_fork(void)
{
    80001de8:	1141                	addi	sp,sp,-16
    80001dea:	e406                	sd	ra,8(sp)
    80001dec:	e022                	sd	s0,0(sp)
    80001dee:	0800                	addi	s0,sp,16
  return fork();
    80001df0:	aa0ff0ef          	jal	80001090 <fork>
}
    80001df4:	60a2                	ld	ra,8(sp)
    80001df6:	6402                	ld	s0,0(sp)
    80001df8:	0141                	addi	sp,sp,16
    80001dfa:	8082                	ret

0000000080001dfc <sys_wait>:

uint64
sys_wait(void)
{
    80001dfc:	1101                	addi	sp,sp,-32
    80001dfe:	ec06                	sd	ra,24(sp)
    80001e00:	e822                	sd	s0,16(sp)
    80001e02:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001e04:	fe840593          	addi	a1,s0,-24
    80001e08:	4501                	li	a0,0
    80001e0a:	ec1ff0ef          	jal	80001cca <argaddr>
  return wait(p);
    80001e0e:	fe843503          	ld	a0,-24(s0)
    80001e12:	f90ff0ef          	jal	800015a2 <wait>
}
    80001e16:	60e2                	ld	ra,24(sp)
    80001e18:	6442                	ld	s0,16(sp)
    80001e1a:	6105                	addi	sp,sp,32
    80001e1c:	8082                	ret

0000000080001e1e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001e1e:	7179                	addi	sp,sp,-48
    80001e20:	f406                	sd	ra,40(sp)
    80001e22:	f022                	sd	s0,32(sp)
    80001e24:	ec26                	sd	s1,24(sp)
    80001e26:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001e28:	fdc40593          	addi	a1,s0,-36
    80001e2c:	4501                	li	a0,0
    80001e2e:	e7fff0ef          	jal	80001cac <argint>
  addr = myproc()->sz;
    80001e32:	f29fe0ef          	jal	80000d5a <myproc>
    80001e36:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001e38:	fdc42503          	lw	a0,-36(s0)
    80001e3c:	a04ff0ef          	jal	80001040 <growproc>
    80001e40:	00054863          	bltz	a0,80001e50 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001e44:	8526                	mv	a0,s1
    80001e46:	70a2                	ld	ra,40(sp)
    80001e48:	7402                	ld	s0,32(sp)
    80001e4a:	64e2                	ld	s1,24(sp)
    80001e4c:	6145                	addi	sp,sp,48
    80001e4e:	8082                	ret
    return -1;
    80001e50:	54fd                	li	s1,-1
    80001e52:	bfcd                	j	80001e44 <sys_sbrk+0x26>

0000000080001e54 <sys_sleep>:

uint64
sys_sleep(void)
{
    80001e54:	7139                	addi	sp,sp,-64
    80001e56:	fc06                	sd	ra,56(sp)
    80001e58:	f822                	sd	s0,48(sp)
    80001e5a:	f04a                	sd	s2,32(sp)
    80001e5c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001e5e:	fcc40593          	addi	a1,s0,-52
    80001e62:	4501                	li	a0,0
    80001e64:	e49ff0ef          	jal	80001cac <argint>
  if(n < 0)
    80001e68:	fcc42783          	lw	a5,-52(s0)
    80001e6c:	0607c763          	bltz	a5,80001eda <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001e70:	00013517          	auipc	a0,0x13
    80001e74:	48050513          	addi	a0,a0,1152 # 800152f0 <tickslock>
    80001e78:	259030ef          	jal	800058d0 <acquire>
  ticks0 = ticks;
    80001e7c:	00008917          	auipc	s2,0x8
    80001e80:	60c92903          	lw	s2,1548(s2) # 8000a488 <ticks>
  while(ticks - ticks0 < n){
    80001e84:	fcc42783          	lw	a5,-52(s0)
    80001e88:	cf8d                	beqz	a5,80001ec2 <sys_sleep+0x6e>
    80001e8a:	f426                	sd	s1,40(sp)
    80001e8c:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001e8e:	00013997          	auipc	s3,0x13
    80001e92:	46298993          	addi	s3,s3,1122 # 800152f0 <tickslock>
    80001e96:	00008497          	auipc	s1,0x8
    80001e9a:	5f248493          	addi	s1,s1,1522 # 8000a488 <ticks>
    if(killed(myproc())){
    80001e9e:	ebdfe0ef          	jal	80000d5a <myproc>
    80001ea2:	ed6ff0ef          	jal	80001578 <killed>
    80001ea6:	ed0d                	bnez	a0,80001ee0 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001ea8:	85ce                	mv	a1,s3
    80001eaa:	8526                	mv	a0,s1
    80001eac:	c94ff0ef          	jal	80001340 <sleep>
  while(ticks - ticks0 < n){
    80001eb0:	409c                	lw	a5,0(s1)
    80001eb2:	412787bb          	subw	a5,a5,s2
    80001eb6:	fcc42703          	lw	a4,-52(s0)
    80001eba:	fee7e2e3          	bltu	a5,a4,80001e9e <sys_sleep+0x4a>
    80001ebe:	74a2                	ld	s1,40(sp)
    80001ec0:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001ec2:	00013517          	auipc	a0,0x13
    80001ec6:	42e50513          	addi	a0,a0,1070 # 800152f0 <tickslock>
    80001eca:	29f030ef          	jal	80005968 <release>
  return 0;
    80001ece:	4501                	li	a0,0
}
    80001ed0:	70e2                	ld	ra,56(sp)
    80001ed2:	7442                	ld	s0,48(sp)
    80001ed4:	7902                	ld	s2,32(sp)
    80001ed6:	6121                	addi	sp,sp,64
    80001ed8:	8082                	ret
    n = 0;
    80001eda:	fc042623          	sw	zero,-52(s0)
    80001ede:	bf49                	j	80001e70 <sys_sleep+0x1c>
      release(&tickslock);
    80001ee0:	00013517          	auipc	a0,0x13
    80001ee4:	41050513          	addi	a0,a0,1040 # 800152f0 <tickslock>
    80001ee8:	281030ef          	jal	80005968 <release>
      return -1;
    80001eec:	557d                	li	a0,-1
    80001eee:	74a2                	ld	s1,40(sp)
    80001ef0:	69e2                	ld	s3,24(sp)
    80001ef2:	bff9                	j	80001ed0 <sys_sleep+0x7c>

0000000080001ef4 <sys_kill>:

uint64
sys_kill(void)
{
    80001ef4:	1101                	addi	sp,sp,-32
    80001ef6:	ec06                	sd	ra,24(sp)
    80001ef8:	e822                	sd	s0,16(sp)
    80001efa:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001efc:	fec40593          	addi	a1,s0,-20
    80001f00:	4501                	li	a0,0
    80001f02:	dabff0ef          	jal	80001cac <argint>
  return kill(pid);
    80001f06:	fec42503          	lw	a0,-20(s0)
    80001f0a:	de4ff0ef          	jal	800014ee <kill>
}
    80001f0e:	60e2                	ld	ra,24(sp)
    80001f10:	6442                	ld	s0,16(sp)
    80001f12:	6105                	addi	sp,sp,32
    80001f14:	8082                	ret

0000000080001f16 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001f16:	1101                	addi	sp,sp,-32
    80001f18:	ec06                	sd	ra,24(sp)
    80001f1a:	e822                	sd	s0,16(sp)
    80001f1c:	e426                	sd	s1,8(sp)
    80001f1e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001f20:	00013517          	auipc	a0,0x13
    80001f24:	3d050513          	addi	a0,a0,976 # 800152f0 <tickslock>
    80001f28:	1a9030ef          	jal	800058d0 <acquire>
  xticks = ticks;
    80001f2c:	00008497          	auipc	s1,0x8
    80001f30:	55c4a483          	lw	s1,1372(s1) # 8000a488 <ticks>
  release(&tickslock);
    80001f34:	00013517          	auipc	a0,0x13
    80001f38:	3bc50513          	addi	a0,a0,956 # 800152f0 <tickslock>
    80001f3c:	22d030ef          	jal	80005968 <release>
  return xticks;
}
    80001f40:	02049513          	slli	a0,s1,0x20
    80001f44:	9101                	srli	a0,a0,0x20
    80001f46:	60e2                	ld	ra,24(sp)
    80001f48:	6442                	ld	s0,16(sp)
    80001f4a:	64a2                	ld	s1,8(sp)
    80001f4c:	6105                	addi	sp,sp,32
    80001f4e:	8082                	ret

0000000080001f50 <sys_trace>:

// Implementation for the trace system call
uint64
sys_trace(void)
{
    80001f50:	7179                	addi	sp,sp,-48
    80001f52:	f406                	sd	ra,40(sp)
    80001f54:	f022                	sd	s0,32(sp)
    80001f56:	ec26                	sd	s1,24(sp)
    80001f58:	1800                	addi	s0,sp,48
  int mask; // 用于存储从用户空间获取的 mask 参数
  struct proc *p = myproc(); // 获取当前进程的 proc 结构体指针
    80001f5a:	e01fe0ef          	jal	80000d5a <myproc>
    80001f5e:	84aa                	mv	s1,a0

  // 从系统调用参数中获取第一个整数参数 (index 0)
  // 并将其存储在局部变量 mask 中
  if(argint(0, &mask) < 0) {
    80001f60:	fdc40593          	addi	a1,s0,-36
    80001f64:	4501                	li	a0,0
    80001f66:	d47ff0ef          	jal	80001cac <argint>
    80001f6a:	00054c63          	bltz	a0,80001f82 <sys_trace+0x32>
    // 如果获取参数失败，返回 -1 表示错误
    return -1;
  }

  // 将获取到的 mask 存储到当前进程的 tracemask 字段中
  p->tracemask = mask;
    80001f6e:	fdc42783          	lw	a5,-36(s0)
    80001f72:	16f4a423          	sw	a5,360(s1)

  // 系统调用成功，返回 0
  return 0;
    80001f76:	4501                	li	a0,0
}
    80001f78:	70a2                	ld	ra,40(sp)
    80001f7a:	7402                	ld	s0,32(sp)
    80001f7c:	64e2                	ld	s1,24(sp)
    80001f7e:	6145                	addi	sp,sp,48
    80001f80:	8082                	ret
    return -1;
    80001f82:	557d                	li	a0,-1
    80001f84:	bfd5                	j	80001f78 <sys_trace+0x28>

0000000080001f86 <sys_sigalarm>:

uint64
sys_sigalarm(void) // <--- 重命名为 sys_sigalarm
{
    80001f86:	7179                	addi	sp,sp,-48
    80001f88:	f406                	sd	ra,40(sp)
    80001f8a:	f022                	sd	s0,32(sp)
    80001f8c:	ec26                	sd	s1,24(sp)
    80001f8e:	1800                	addi	s0,sp,48
  int ticks_from_user_arg;
  uint64 handler_va_from_user_arg;
  struct proc *p = myproc();
    80001f90:	dcbfe0ef          	jal	80000d5a <myproc>
    80001f94:	84aa                	mv	s1,a0

  if(argint(0, &ticks_from_user_arg) < 0) {
    80001f96:	fdc40593          	addi	a1,s0,-36
    80001f9a:	4501                	li	a0,0
    80001f9c:	d11ff0ef          	jal	80001cac <argint>
    return -1;
    80001fa0:	57fd                	li	a5,-1
  if(argint(0, &ticks_from_user_arg) < 0) {
    80001fa2:	02054a63          	bltz	a0,80001fd6 <sys_sigalarm+0x50>
  }
  argaddr(1, &handler_va_from_user_arg);
    80001fa6:	fd040593          	addi	a1,s0,-48
    80001faa:	4505                	li	a0,1
    80001fac:	d1fff0ef          	jal	80001cca <argaddr>

  acquire(&p->lock);
    80001fb0:	8526                	mv	a0,s1
    80001fb2:	11f030ef          	jal	800058d0 <acquire>
  p->alarmticks = ticks_from_user_arg;
    80001fb6:	fdc42783          	lw	a5,-36(s0)
    80001fba:	16f4a623          	sw	a5,364(s1)
  p->user_alarm_handler_va = handler_va_from_user_arg;
    80001fbe:	fd043703          	ld	a4,-48(s0)
    80001fc2:	16e4bc23          	sd	a4,376(s1)

  if (ticks_from_user_arg > 0) {
    80001fc6:	00f05e63          	blez	a5,80001fe2 <sys_sigalarm+0x5c>
    p->curticks = 0;
    80001fca:	1604a823          	sw	zero,368(s1)
  } else {
    p->alarmticks = 0;
    p->curticks = 0;
  }
  release(&p->lock);
    80001fce:	8526                	mv	a0,s1
    80001fd0:	199030ef          	jal	80005968 <release>

  return 0;
    80001fd4:	4781                	li	a5,0
}
    80001fd6:	853e                	mv	a0,a5
    80001fd8:	70a2                	ld	ra,40(sp)
    80001fda:	7402                	ld	s0,32(sp)
    80001fdc:	64e2                	ld	s1,24(sp)
    80001fde:	6145                	addi	sp,sp,48
    80001fe0:	8082                	ret
    p->alarmticks = 0;
    80001fe2:	1604a623          	sw	zero,364(s1)
    p->curticks = 0;
    80001fe6:	b7d5                	j	80001fca <sys_sigalarm+0x44>

0000000080001fe8 <sys_sigreturn>:

// sys_sigreturn 也需要确保 proc.h 中的字段名被正确使用
uint64
sys_sigreturn(void) {
    80001fe8:	1101                	addi	sp,sp,-32
    80001fea:	ec06                	sd	ra,24(sp)
    80001fec:	e822                	sd	s0,16(sp)
    80001fee:	e426                	sd	s1,8(sp)
    80001ff0:	e04a                	sd	s2,0(sp)
    80001ff2:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80001ff4:	d67fe0ef          	jal	80000d5a <myproc>
    80001ff8:	84aa                	mv	s1,a0
    uint64 original_a0_val;

    acquire(&p->lock);
    80001ffa:	0d7030ef          	jal	800058d0 <acquire>
    if (p->handling_alarm == 0) { // 使用 proc.h 中的 handling_alarm
    80001ffe:	2a04a783          	lw	a5,672(s1)
    80002002:	c79d                	beqz	a5,80002030 <sys_sigreturn+0x48>
        release(&p->lock);
        return -1;
    }

    // 使用 proc.h 中的 alarm_trapframe_backup
    memmove(p->trapframe, &p->alarm_trapframe_backup, sizeof(struct trapframe));
    80002004:	12000613          	li	a2,288
    80002008:	18048593          	addi	a1,s1,384
    8000200c:	6ca8                	ld	a0,88(s1)
    8000200e:	99cfe0ef          	jal	800001aa <memmove>
    original_a0_val = p->trapframe->a0;
    80002012:	6cbc                	ld	a5,88(s1)
    80002014:	0707b903          	ld	s2,112(a5)
    p->handling_alarm = 0;
    80002018:	2a04a023          	sw	zero,672(s1)
    // curticks 在 trap.c 中当闹钟触发时已经重置
    release(&p->lock);
    8000201c:	8526                	mv	a0,s1
    8000201e:	14b030ef          	jal	80005968 <release>
    return original_a0_val;
    80002022:	854a                	mv	a0,s2
    80002024:	60e2                	ld	ra,24(sp)
    80002026:	6442                	ld	s0,16(sp)
    80002028:	64a2                	ld	s1,8(sp)
    8000202a:	6902                	ld	s2,0(sp)
    8000202c:	6105                	addi	sp,sp,32
    8000202e:	8082                	ret
        release(&p->lock);
    80002030:	8526                	mv	a0,s1
    80002032:	137030ef          	jal	80005968 <release>
        return -1;
    80002036:	597d                	li	s2,-1
    80002038:	b7ed                	j	80002022 <sys_sigreturn+0x3a>

000000008000203a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000203a:	7179                	addi	sp,sp,-48
    8000203c:	f406                	sd	ra,40(sp)
    8000203e:	f022                	sd	s0,32(sp)
    80002040:	ec26                	sd	s1,24(sp)
    80002042:	e84a                	sd	s2,16(sp)
    80002044:	e44e                	sd	s3,8(sp)
    80002046:	e052                	sd	s4,0(sp)
    80002048:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000204a:	00005597          	auipc	a1,0x5
    8000204e:	49658593          	addi	a1,a1,1174 # 800074e0 <etext+0x4e0>
    80002052:	00013517          	auipc	a0,0x13
    80002056:	2b650513          	addi	a0,a0,694 # 80015308 <bcache>
    8000205a:	7f6030ef          	jal	80005850 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000205e:	0001b797          	auipc	a5,0x1b
    80002062:	2aa78793          	addi	a5,a5,682 # 8001d308 <bcache+0x8000>
    80002066:	0001b717          	auipc	a4,0x1b
    8000206a:	50a70713          	addi	a4,a4,1290 # 8001d570 <bcache+0x8268>
    8000206e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002072:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002076:	00013497          	auipc	s1,0x13
    8000207a:	2aa48493          	addi	s1,s1,682 # 80015320 <bcache+0x18>
    b->next = bcache.head.next;
    8000207e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002080:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002082:	00005a17          	auipc	s4,0x5
    80002086:	466a0a13          	addi	s4,s4,1126 # 800074e8 <etext+0x4e8>
    b->next = bcache.head.next;
    8000208a:	2b893783          	ld	a5,696(s2)
    8000208e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002090:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002094:	85d2                	mv	a1,s4
    80002096:	01048513          	addi	a0,s1,16
    8000209a:	248010ef          	jal	800032e2 <initsleeplock>
    bcache.head.next->prev = b;
    8000209e:	2b893783          	ld	a5,696(s2)
    800020a2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800020a4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800020a8:	45848493          	addi	s1,s1,1112
    800020ac:	fd349fe3          	bne	s1,s3,8000208a <binit+0x50>
  }
}
    800020b0:	70a2                	ld	ra,40(sp)
    800020b2:	7402                	ld	s0,32(sp)
    800020b4:	64e2                	ld	s1,24(sp)
    800020b6:	6942                	ld	s2,16(sp)
    800020b8:	69a2                	ld	s3,8(sp)
    800020ba:	6a02                	ld	s4,0(sp)
    800020bc:	6145                	addi	sp,sp,48
    800020be:	8082                	ret

00000000800020c0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800020c0:	7179                	addi	sp,sp,-48
    800020c2:	f406                	sd	ra,40(sp)
    800020c4:	f022                	sd	s0,32(sp)
    800020c6:	ec26                	sd	s1,24(sp)
    800020c8:	e84a                	sd	s2,16(sp)
    800020ca:	e44e                	sd	s3,8(sp)
    800020cc:	1800                	addi	s0,sp,48
    800020ce:	892a                	mv	s2,a0
    800020d0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800020d2:	00013517          	auipc	a0,0x13
    800020d6:	23650513          	addi	a0,a0,566 # 80015308 <bcache>
    800020da:	7f6030ef          	jal	800058d0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800020de:	0001b497          	auipc	s1,0x1b
    800020e2:	4e24b483          	ld	s1,1250(s1) # 8001d5c0 <bcache+0x82b8>
    800020e6:	0001b797          	auipc	a5,0x1b
    800020ea:	48a78793          	addi	a5,a5,1162 # 8001d570 <bcache+0x8268>
    800020ee:	02f48b63          	beq	s1,a5,80002124 <bread+0x64>
    800020f2:	873e                	mv	a4,a5
    800020f4:	a021                	j	800020fc <bread+0x3c>
    800020f6:	68a4                	ld	s1,80(s1)
    800020f8:	02e48663          	beq	s1,a4,80002124 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    800020fc:	449c                	lw	a5,8(s1)
    800020fe:	ff279ce3          	bne	a5,s2,800020f6 <bread+0x36>
    80002102:	44dc                	lw	a5,12(s1)
    80002104:	ff3799e3          	bne	a5,s3,800020f6 <bread+0x36>
      b->refcnt++;
    80002108:	40bc                	lw	a5,64(s1)
    8000210a:	2785                	addiw	a5,a5,1
    8000210c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000210e:	00013517          	auipc	a0,0x13
    80002112:	1fa50513          	addi	a0,a0,506 # 80015308 <bcache>
    80002116:	053030ef          	jal	80005968 <release>
      acquiresleep(&b->lock);
    8000211a:	01048513          	addi	a0,s1,16
    8000211e:	1fa010ef          	jal	80003318 <acquiresleep>
      return b;
    80002122:	a889                	j	80002174 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002124:	0001b497          	auipc	s1,0x1b
    80002128:	4944b483          	ld	s1,1172(s1) # 8001d5b8 <bcache+0x82b0>
    8000212c:	0001b797          	auipc	a5,0x1b
    80002130:	44478793          	addi	a5,a5,1092 # 8001d570 <bcache+0x8268>
    80002134:	00f48863          	beq	s1,a5,80002144 <bread+0x84>
    80002138:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000213a:	40bc                	lw	a5,64(s1)
    8000213c:	cb91                	beqz	a5,80002150 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000213e:	64a4                	ld	s1,72(s1)
    80002140:	fee49de3          	bne	s1,a4,8000213a <bread+0x7a>
  panic("bget: no buffers");
    80002144:	00005517          	auipc	a0,0x5
    80002148:	3ac50513          	addi	a0,a0,940 # 800074f0 <etext+0x4f0>
    8000214c:	456030ef          	jal	800055a2 <panic>
      b->dev = dev;
    80002150:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002154:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002158:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000215c:	4785                	li	a5,1
    8000215e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002160:	00013517          	auipc	a0,0x13
    80002164:	1a850513          	addi	a0,a0,424 # 80015308 <bcache>
    80002168:	001030ef          	jal	80005968 <release>
      acquiresleep(&b->lock);
    8000216c:	01048513          	addi	a0,s1,16
    80002170:	1a8010ef          	jal	80003318 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002174:	409c                	lw	a5,0(s1)
    80002176:	cb89                	beqz	a5,80002188 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002178:	8526                	mv	a0,s1
    8000217a:	70a2                	ld	ra,40(sp)
    8000217c:	7402                	ld	s0,32(sp)
    8000217e:	64e2                	ld	s1,24(sp)
    80002180:	6942                	ld	s2,16(sp)
    80002182:	69a2                	ld	s3,8(sp)
    80002184:	6145                	addi	sp,sp,48
    80002186:	8082                	ret
    virtio_disk_rw(b, 0);
    80002188:	4581                	li	a1,0
    8000218a:	8526                	mv	a0,s1
    8000218c:	1e5020ef          	jal	80004b70 <virtio_disk_rw>
    b->valid = 1;
    80002190:	4785                	li	a5,1
    80002192:	c09c                	sw	a5,0(s1)
  return b;
    80002194:	b7d5                	j	80002178 <bread+0xb8>

0000000080002196 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002196:	1101                	addi	sp,sp,-32
    80002198:	ec06                	sd	ra,24(sp)
    8000219a:	e822                	sd	s0,16(sp)
    8000219c:	e426                	sd	s1,8(sp)
    8000219e:	1000                	addi	s0,sp,32
    800021a0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800021a2:	0541                	addi	a0,a0,16
    800021a4:	1f2010ef          	jal	80003396 <holdingsleep>
    800021a8:	c911                	beqz	a0,800021bc <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800021aa:	4585                	li	a1,1
    800021ac:	8526                	mv	a0,s1
    800021ae:	1c3020ef          	jal	80004b70 <virtio_disk_rw>
}
    800021b2:	60e2                	ld	ra,24(sp)
    800021b4:	6442                	ld	s0,16(sp)
    800021b6:	64a2                	ld	s1,8(sp)
    800021b8:	6105                	addi	sp,sp,32
    800021ba:	8082                	ret
    panic("bwrite");
    800021bc:	00005517          	auipc	a0,0x5
    800021c0:	34c50513          	addi	a0,a0,844 # 80007508 <etext+0x508>
    800021c4:	3de030ef          	jal	800055a2 <panic>

00000000800021c8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800021c8:	1101                	addi	sp,sp,-32
    800021ca:	ec06                	sd	ra,24(sp)
    800021cc:	e822                	sd	s0,16(sp)
    800021ce:	e426                	sd	s1,8(sp)
    800021d0:	e04a                	sd	s2,0(sp)
    800021d2:	1000                	addi	s0,sp,32
    800021d4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800021d6:	01050913          	addi	s2,a0,16
    800021da:	854a                	mv	a0,s2
    800021dc:	1ba010ef          	jal	80003396 <holdingsleep>
    800021e0:	c135                	beqz	a0,80002244 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    800021e2:	854a                	mv	a0,s2
    800021e4:	17a010ef          	jal	8000335e <releasesleep>

  acquire(&bcache.lock);
    800021e8:	00013517          	auipc	a0,0x13
    800021ec:	12050513          	addi	a0,a0,288 # 80015308 <bcache>
    800021f0:	6e0030ef          	jal	800058d0 <acquire>
  b->refcnt--;
    800021f4:	40bc                	lw	a5,64(s1)
    800021f6:	37fd                	addiw	a5,a5,-1
    800021f8:	0007871b          	sext.w	a4,a5
    800021fc:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800021fe:	e71d                	bnez	a4,8000222c <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002200:	68b8                	ld	a4,80(s1)
    80002202:	64bc                	ld	a5,72(s1)
    80002204:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002206:	68b8                	ld	a4,80(s1)
    80002208:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000220a:	0001b797          	auipc	a5,0x1b
    8000220e:	0fe78793          	addi	a5,a5,254 # 8001d308 <bcache+0x8000>
    80002212:	2b87b703          	ld	a4,696(a5)
    80002216:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002218:	0001b717          	auipc	a4,0x1b
    8000221c:	35870713          	addi	a4,a4,856 # 8001d570 <bcache+0x8268>
    80002220:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002222:	2b87b703          	ld	a4,696(a5)
    80002226:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002228:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000222c:	00013517          	auipc	a0,0x13
    80002230:	0dc50513          	addi	a0,a0,220 # 80015308 <bcache>
    80002234:	734030ef          	jal	80005968 <release>
}
    80002238:	60e2                	ld	ra,24(sp)
    8000223a:	6442                	ld	s0,16(sp)
    8000223c:	64a2                	ld	s1,8(sp)
    8000223e:	6902                	ld	s2,0(sp)
    80002240:	6105                	addi	sp,sp,32
    80002242:	8082                	ret
    panic("brelse");
    80002244:	00005517          	auipc	a0,0x5
    80002248:	2cc50513          	addi	a0,a0,716 # 80007510 <etext+0x510>
    8000224c:	356030ef          	jal	800055a2 <panic>

0000000080002250 <bpin>:

void
bpin(struct buf *b) {
    80002250:	1101                	addi	sp,sp,-32
    80002252:	ec06                	sd	ra,24(sp)
    80002254:	e822                	sd	s0,16(sp)
    80002256:	e426                	sd	s1,8(sp)
    80002258:	1000                	addi	s0,sp,32
    8000225a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000225c:	00013517          	auipc	a0,0x13
    80002260:	0ac50513          	addi	a0,a0,172 # 80015308 <bcache>
    80002264:	66c030ef          	jal	800058d0 <acquire>
  b->refcnt++;
    80002268:	40bc                	lw	a5,64(s1)
    8000226a:	2785                	addiw	a5,a5,1
    8000226c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000226e:	00013517          	auipc	a0,0x13
    80002272:	09a50513          	addi	a0,a0,154 # 80015308 <bcache>
    80002276:	6f2030ef          	jal	80005968 <release>
}
    8000227a:	60e2                	ld	ra,24(sp)
    8000227c:	6442                	ld	s0,16(sp)
    8000227e:	64a2                	ld	s1,8(sp)
    80002280:	6105                	addi	sp,sp,32
    80002282:	8082                	ret

0000000080002284 <bunpin>:

void
bunpin(struct buf *b) {
    80002284:	1101                	addi	sp,sp,-32
    80002286:	ec06                	sd	ra,24(sp)
    80002288:	e822                	sd	s0,16(sp)
    8000228a:	e426                	sd	s1,8(sp)
    8000228c:	1000                	addi	s0,sp,32
    8000228e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002290:	00013517          	auipc	a0,0x13
    80002294:	07850513          	addi	a0,a0,120 # 80015308 <bcache>
    80002298:	638030ef          	jal	800058d0 <acquire>
  b->refcnt--;
    8000229c:	40bc                	lw	a5,64(s1)
    8000229e:	37fd                	addiw	a5,a5,-1
    800022a0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800022a2:	00013517          	auipc	a0,0x13
    800022a6:	06650513          	addi	a0,a0,102 # 80015308 <bcache>
    800022aa:	6be030ef          	jal	80005968 <release>
}
    800022ae:	60e2                	ld	ra,24(sp)
    800022b0:	6442                	ld	s0,16(sp)
    800022b2:	64a2                	ld	s1,8(sp)
    800022b4:	6105                	addi	sp,sp,32
    800022b6:	8082                	ret

00000000800022b8 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800022b8:	1101                	addi	sp,sp,-32
    800022ba:	ec06                	sd	ra,24(sp)
    800022bc:	e822                	sd	s0,16(sp)
    800022be:	e426                	sd	s1,8(sp)
    800022c0:	e04a                	sd	s2,0(sp)
    800022c2:	1000                	addi	s0,sp,32
    800022c4:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800022c6:	00d5d59b          	srliw	a1,a1,0xd
    800022ca:	0001b797          	auipc	a5,0x1b
    800022ce:	71a7a783          	lw	a5,1818(a5) # 8001d9e4 <sb+0x1c>
    800022d2:	9dbd                	addw	a1,a1,a5
    800022d4:	dedff0ef          	jal	800020c0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800022d8:	0074f713          	andi	a4,s1,7
    800022dc:	4785                	li	a5,1
    800022de:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800022e2:	14ce                	slli	s1,s1,0x33
    800022e4:	90d9                	srli	s1,s1,0x36
    800022e6:	00950733          	add	a4,a0,s1
    800022ea:	05874703          	lbu	a4,88(a4)
    800022ee:	00e7f6b3          	and	a3,a5,a4
    800022f2:	c29d                	beqz	a3,80002318 <bfree+0x60>
    800022f4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800022f6:	94aa                	add	s1,s1,a0
    800022f8:	fff7c793          	not	a5,a5
    800022fc:	8f7d                	and	a4,a4,a5
    800022fe:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002302:	711000ef          	jal	80003212 <log_write>
  brelse(bp);
    80002306:	854a                	mv	a0,s2
    80002308:	ec1ff0ef          	jal	800021c8 <brelse>
}
    8000230c:	60e2                	ld	ra,24(sp)
    8000230e:	6442                	ld	s0,16(sp)
    80002310:	64a2                	ld	s1,8(sp)
    80002312:	6902                	ld	s2,0(sp)
    80002314:	6105                	addi	sp,sp,32
    80002316:	8082                	ret
    panic("freeing free block");
    80002318:	00005517          	auipc	a0,0x5
    8000231c:	20050513          	addi	a0,a0,512 # 80007518 <etext+0x518>
    80002320:	282030ef          	jal	800055a2 <panic>

0000000080002324 <balloc>:
{
    80002324:	711d                	addi	sp,sp,-96
    80002326:	ec86                	sd	ra,88(sp)
    80002328:	e8a2                	sd	s0,80(sp)
    8000232a:	e4a6                	sd	s1,72(sp)
    8000232c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000232e:	0001b797          	auipc	a5,0x1b
    80002332:	69e7a783          	lw	a5,1694(a5) # 8001d9cc <sb+0x4>
    80002336:	0e078f63          	beqz	a5,80002434 <balloc+0x110>
    8000233a:	e0ca                	sd	s2,64(sp)
    8000233c:	fc4e                	sd	s3,56(sp)
    8000233e:	f852                	sd	s4,48(sp)
    80002340:	f456                	sd	s5,40(sp)
    80002342:	f05a                	sd	s6,32(sp)
    80002344:	ec5e                	sd	s7,24(sp)
    80002346:	e862                	sd	s8,16(sp)
    80002348:	e466                	sd	s9,8(sp)
    8000234a:	8baa                	mv	s7,a0
    8000234c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000234e:	0001bb17          	auipc	s6,0x1b
    80002352:	67ab0b13          	addi	s6,s6,1658 # 8001d9c8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002356:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002358:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000235a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000235c:	6c89                	lui	s9,0x2
    8000235e:	a0b5                	j	800023ca <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002360:	97ca                	add	a5,a5,s2
    80002362:	8e55                	or	a2,a2,a3
    80002364:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002368:	854a                	mv	a0,s2
    8000236a:	6a9000ef          	jal	80003212 <log_write>
        brelse(bp);
    8000236e:	854a                	mv	a0,s2
    80002370:	e59ff0ef          	jal	800021c8 <brelse>
  bp = bread(dev, bno);
    80002374:	85a6                	mv	a1,s1
    80002376:	855e                	mv	a0,s7
    80002378:	d49ff0ef          	jal	800020c0 <bread>
    8000237c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000237e:	40000613          	li	a2,1024
    80002382:	4581                	li	a1,0
    80002384:	05850513          	addi	a0,a0,88
    80002388:	dc7fd0ef          	jal	8000014e <memset>
  log_write(bp);
    8000238c:	854a                	mv	a0,s2
    8000238e:	685000ef          	jal	80003212 <log_write>
  brelse(bp);
    80002392:	854a                	mv	a0,s2
    80002394:	e35ff0ef          	jal	800021c8 <brelse>
}
    80002398:	6906                	ld	s2,64(sp)
    8000239a:	79e2                	ld	s3,56(sp)
    8000239c:	7a42                	ld	s4,48(sp)
    8000239e:	7aa2                	ld	s5,40(sp)
    800023a0:	7b02                	ld	s6,32(sp)
    800023a2:	6be2                	ld	s7,24(sp)
    800023a4:	6c42                	ld	s8,16(sp)
    800023a6:	6ca2                	ld	s9,8(sp)
}
    800023a8:	8526                	mv	a0,s1
    800023aa:	60e6                	ld	ra,88(sp)
    800023ac:	6446                	ld	s0,80(sp)
    800023ae:	64a6                	ld	s1,72(sp)
    800023b0:	6125                	addi	sp,sp,96
    800023b2:	8082                	ret
    brelse(bp);
    800023b4:	854a                	mv	a0,s2
    800023b6:	e13ff0ef          	jal	800021c8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800023ba:	015c87bb          	addw	a5,s9,s5
    800023be:	00078a9b          	sext.w	s5,a5
    800023c2:	004b2703          	lw	a4,4(s6)
    800023c6:	04eaff63          	bgeu	s5,a4,80002424 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    800023ca:	41fad79b          	sraiw	a5,s5,0x1f
    800023ce:	0137d79b          	srliw	a5,a5,0x13
    800023d2:	015787bb          	addw	a5,a5,s5
    800023d6:	40d7d79b          	sraiw	a5,a5,0xd
    800023da:	01cb2583          	lw	a1,28(s6)
    800023de:	9dbd                	addw	a1,a1,a5
    800023e0:	855e                	mv	a0,s7
    800023e2:	cdfff0ef          	jal	800020c0 <bread>
    800023e6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800023e8:	004b2503          	lw	a0,4(s6)
    800023ec:	000a849b          	sext.w	s1,s5
    800023f0:	8762                	mv	a4,s8
    800023f2:	fca4f1e3          	bgeu	s1,a0,800023b4 <balloc+0x90>
      m = 1 << (bi % 8);
    800023f6:	00777693          	andi	a3,a4,7
    800023fa:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800023fe:	41f7579b          	sraiw	a5,a4,0x1f
    80002402:	01d7d79b          	srliw	a5,a5,0x1d
    80002406:	9fb9                	addw	a5,a5,a4
    80002408:	4037d79b          	sraiw	a5,a5,0x3
    8000240c:	00f90633          	add	a2,s2,a5
    80002410:	05864603          	lbu	a2,88(a2)
    80002414:	00c6f5b3          	and	a1,a3,a2
    80002418:	d5a1                	beqz	a1,80002360 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000241a:	2705                	addiw	a4,a4,1
    8000241c:	2485                	addiw	s1,s1,1
    8000241e:	fd471ae3          	bne	a4,s4,800023f2 <balloc+0xce>
    80002422:	bf49                	j	800023b4 <balloc+0x90>
    80002424:	6906                	ld	s2,64(sp)
    80002426:	79e2                	ld	s3,56(sp)
    80002428:	7a42                	ld	s4,48(sp)
    8000242a:	7aa2                	ld	s5,40(sp)
    8000242c:	7b02                	ld	s6,32(sp)
    8000242e:	6be2                	ld	s7,24(sp)
    80002430:	6c42                	ld	s8,16(sp)
    80002432:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002434:	00005517          	auipc	a0,0x5
    80002438:	0fc50513          	addi	a0,a0,252 # 80007530 <etext+0x530>
    8000243c:	695020ef          	jal	800052d0 <printf>
  return 0;
    80002440:	4481                	li	s1,0
    80002442:	b79d                	j	800023a8 <balloc+0x84>

0000000080002444 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002444:	7179                	addi	sp,sp,-48
    80002446:	f406                	sd	ra,40(sp)
    80002448:	f022                	sd	s0,32(sp)
    8000244a:	ec26                	sd	s1,24(sp)
    8000244c:	e84a                	sd	s2,16(sp)
    8000244e:	e44e                	sd	s3,8(sp)
    80002450:	1800                	addi	s0,sp,48
    80002452:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002454:	47ad                	li	a5,11
    80002456:	02b7e663          	bltu	a5,a1,80002482 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    8000245a:	02059793          	slli	a5,a1,0x20
    8000245e:	01e7d593          	srli	a1,a5,0x1e
    80002462:	00b504b3          	add	s1,a0,a1
    80002466:	0504a903          	lw	s2,80(s1)
    8000246a:	06091a63          	bnez	s2,800024de <bmap+0x9a>
      addr = balloc(ip->dev);
    8000246e:	4108                	lw	a0,0(a0)
    80002470:	eb5ff0ef          	jal	80002324 <balloc>
    80002474:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002478:	06090363          	beqz	s2,800024de <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    8000247c:	0524a823          	sw	s2,80(s1)
    80002480:	a8b9                	j	800024de <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002482:	ff45849b          	addiw	s1,a1,-12
    80002486:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000248a:	0ff00793          	li	a5,255
    8000248e:	06e7ee63          	bltu	a5,a4,8000250a <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002492:	08052903          	lw	s2,128(a0)
    80002496:	00091d63          	bnez	s2,800024b0 <bmap+0x6c>
      addr = balloc(ip->dev);
    8000249a:	4108                	lw	a0,0(a0)
    8000249c:	e89ff0ef          	jal	80002324 <balloc>
    800024a0:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800024a4:	02090d63          	beqz	s2,800024de <bmap+0x9a>
    800024a8:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800024aa:	0929a023          	sw	s2,128(s3)
    800024ae:	a011                	j	800024b2 <bmap+0x6e>
    800024b0:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800024b2:	85ca                	mv	a1,s2
    800024b4:	0009a503          	lw	a0,0(s3)
    800024b8:	c09ff0ef          	jal	800020c0 <bread>
    800024bc:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800024be:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800024c2:	02049713          	slli	a4,s1,0x20
    800024c6:	01e75593          	srli	a1,a4,0x1e
    800024ca:	00b784b3          	add	s1,a5,a1
    800024ce:	0004a903          	lw	s2,0(s1)
    800024d2:	00090e63          	beqz	s2,800024ee <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800024d6:	8552                	mv	a0,s4
    800024d8:	cf1ff0ef          	jal	800021c8 <brelse>
    return addr;
    800024dc:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800024de:	854a                	mv	a0,s2
    800024e0:	70a2                	ld	ra,40(sp)
    800024e2:	7402                	ld	s0,32(sp)
    800024e4:	64e2                	ld	s1,24(sp)
    800024e6:	6942                	ld	s2,16(sp)
    800024e8:	69a2                	ld	s3,8(sp)
    800024ea:	6145                	addi	sp,sp,48
    800024ec:	8082                	ret
      addr = balloc(ip->dev);
    800024ee:	0009a503          	lw	a0,0(s3)
    800024f2:	e33ff0ef          	jal	80002324 <balloc>
    800024f6:	0005091b          	sext.w	s2,a0
      if(addr){
    800024fa:	fc090ee3          	beqz	s2,800024d6 <bmap+0x92>
        a[bn] = addr;
    800024fe:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002502:	8552                	mv	a0,s4
    80002504:	50f000ef          	jal	80003212 <log_write>
    80002508:	b7f9                	j	800024d6 <bmap+0x92>
    8000250a:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000250c:	00005517          	auipc	a0,0x5
    80002510:	03c50513          	addi	a0,a0,60 # 80007548 <etext+0x548>
    80002514:	08e030ef          	jal	800055a2 <panic>

0000000080002518 <iget>:
{
    80002518:	7179                	addi	sp,sp,-48
    8000251a:	f406                	sd	ra,40(sp)
    8000251c:	f022                	sd	s0,32(sp)
    8000251e:	ec26                	sd	s1,24(sp)
    80002520:	e84a                	sd	s2,16(sp)
    80002522:	e44e                	sd	s3,8(sp)
    80002524:	e052                	sd	s4,0(sp)
    80002526:	1800                	addi	s0,sp,48
    80002528:	89aa                	mv	s3,a0
    8000252a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000252c:	0001b517          	auipc	a0,0x1b
    80002530:	4bc50513          	addi	a0,a0,1212 # 8001d9e8 <itable>
    80002534:	39c030ef          	jal	800058d0 <acquire>
  empty = 0;
    80002538:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000253a:	0001b497          	auipc	s1,0x1b
    8000253e:	4c648493          	addi	s1,s1,1222 # 8001da00 <itable+0x18>
    80002542:	0001d697          	auipc	a3,0x1d
    80002546:	f4e68693          	addi	a3,a3,-178 # 8001f490 <log>
    8000254a:	a039                	j	80002558 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000254c:	02090963          	beqz	s2,8000257e <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002550:	08848493          	addi	s1,s1,136
    80002554:	02d48863          	beq	s1,a3,80002584 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002558:	449c                	lw	a5,8(s1)
    8000255a:	fef059e3          	blez	a5,8000254c <iget+0x34>
    8000255e:	4098                	lw	a4,0(s1)
    80002560:	ff3716e3          	bne	a4,s3,8000254c <iget+0x34>
    80002564:	40d8                	lw	a4,4(s1)
    80002566:	ff4713e3          	bne	a4,s4,8000254c <iget+0x34>
      ip->ref++;
    8000256a:	2785                	addiw	a5,a5,1
    8000256c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000256e:	0001b517          	auipc	a0,0x1b
    80002572:	47a50513          	addi	a0,a0,1146 # 8001d9e8 <itable>
    80002576:	3f2030ef          	jal	80005968 <release>
      return ip;
    8000257a:	8926                	mv	s2,s1
    8000257c:	a02d                	j	800025a6 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000257e:	fbe9                	bnez	a5,80002550 <iget+0x38>
      empty = ip;
    80002580:	8926                	mv	s2,s1
    80002582:	b7f9                	j	80002550 <iget+0x38>
  if(empty == 0)
    80002584:	02090a63          	beqz	s2,800025b8 <iget+0xa0>
  ip->dev = dev;
    80002588:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000258c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002590:	4785                	li	a5,1
    80002592:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002596:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000259a:	0001b517          	auipc	a0,0x1b
    8000259e:	44e50513          	addi	a0,a0,1102 # 8001d9e8 <itable>
    800025a2:	3c6030ef          	jal	80005968 <release>
}
    800025a6:	854a                	mv	a0,s2
    800025a8:	70a2                	ld	ra,40(sp)
    800025aa:	7402                	ld	s0,32(sp)
    800025ac:	64e2                	ld	s1,24(sp)
    800025ae:	6942                	ld	s2,16(sp)
    800025b0:	69a2                	ld	s3,8(sp)
    800025b2:	6a02                	ld	s4,0(sp)
    800025b4:	6145                	addi	sp,sp,48
    800025b6:	8082                	ret
    panic("iget: no inodes");
    800025b8:	00005517          	auipc	a0,0x5
    800025bc:	fa850513          	addi	a0,a0,-88 # 80007560 <etext+0x560>
    800025c0:	7e3020ef          	jal	800055a2 <panic>

00000000800025c4 <fsinit>:
fsinit(int dev) {
    800025c4:	7179                	addi	sp,sp,-48
    800025c6:	f406                	sd	ra,40(sp)
    800025c8:	f022                	sd	s0,32(sp)
    800025ca:	ec26                	sd	s1,24(sp)
    800025cc:	e84a                	sd	s2,16(sp)
    800025ce:	e44e                	sd	s3,8(sp)
    800025d0:	1800                	addi	s0,sp,48
    800025d2:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800025d4:	4585                	li	a1,1
    800025d6:	aebff0ef          	jal	800020c0 <bread>
    800025da:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800025dc:	0001b997          	auipc	s3,0x1b
    800025e0:	3ec98993          	addi	s3,s3,1004 # 8001d9c8 <sb>
    800025e4:	02000613          	li	a2,32
    800025e8:	05850593          	addi	a1,a0,88
    800025ec:	854e                	mv	a0,s3
    800025ee:	bbdfd0ef          	jal	800001aa <memmove>
  brelse(bp);
    800025f2:	8526                	mv	a0,s1
    800025f4:	bd5ff0ef          	jal	800021c8 <brelse>
  if(sb.magic != FSMAGIC)
    800025f8:	0009a703          	lw	a4,0(s3)
    800025fc:	102037b7          	lui	a5,0x10203
    80002600:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002604:	02f71063          	bne	a4,a5,80002624 <fsinit+0x60>
  initlog(dev, &sb);
    80002608:	0001b597          	auipc	a1,0x1b
    8000260c:	3c058593          	addi	a1,a1,960 # 8001d9c8 <sb>
    80002610:	854a                	mv	a0,s2
    80002612:	1f9000ef          	jal	8000300a <initlog>
}
    80002616:	70a2                	ld	ra,40(sp)
    80002618:	7402                	ld	s0,32(sp)
    8000261a:	64e2                	ld	s1,24(sp)
    8000261c:	6942                	ld	s2,16(sp)
    8000261e:	69a2                	ld	s3,8(sp)
    80002620:	6145                	addi	sp,sp,48
    80002622:	8082                	ret
    panic("invalid file system");
    80002624:	00005517          	auipc	a0,0x5
    80002628:	f4c50513          	addi	a0,a0,-180 # 80007570 <etext+0x570>
    8000262c:	777020ef          	jal	800055a2 <panic>

0000000080002630 <iinit>:
{
    80002630:	7179                	addi	sp,sp,-48
    80002632:	f406                	sd	ra,40(sp)
    80002634:	f022                	sd	s0,32(sp)
    80002636:	ec26                	sd	s1,24(sp)
    80002638:	e84a                	sd	s2,16(sp)
    8000263a:	e44e                	sd	s3,8(sp)
    8000263c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000263e:	00005597          	auipc	a1,0x5
    80002642:	f4a58593          	addi	a1,a1,-182 # 80007588 <etext+0x588>
    80002646:	0001b517          	auipc	a0,0x1b
    8000264a:	3a250513          	addi	a0,a0,930 # 8001d9e8 <itable>
    8000264e:	202030ef          	jal	80005850 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002652:	0001b497          	auipc	s1,0x1b
    80002656:	3be48493          	addi	s1,s1,958 # 8001da10 <itable+0x28>
    8000265a:	0001d997          	auipc	s3,0x1d
    8000265e:	e4698993          	addi	s3,s3,-442 # 8001f4a0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002662:	00005917          	auipc	s2,0x5
    80002666:	f2e90913          	addi	s2,s2,-210 # 80007590 <etext+0x590>
    8000266a:	85ca                	mv	a1,s2
    8000266c:	8526                	mv	a0,s1
    8000266e:	475000ef          	jal	800032e2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002672:	08848493          	addi	s1,s1,136
    80002676:	ff349ae3          	bne	s1,s3,8000266a <iinit+0x3a>
}
    8000267a:	70a2                	ld	ra,40(sp)
    8000267c:	7402                	ld	s0,32(sp)
    8000267e:	64e2                	ld	s1,24(sp)
    80002680:	6942                	ld	s2,16(sp)
    80002682:	69a2                	ld	s3,8(sp)
    80002684:	6145                	addi	sp,sp,48
    80002686:	8082                	ret

0000000080002688 <ialloc>:
{
    80002688:	7139                	addi	sp,sp,-64
    8000268a:	fc06                	sd	ra,56(sp)
    8000268c:	f822                	sd	s0,48(sp)
    8000268e:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002690:	0001b717          	auipc	a4,0x1b
    80002694:	34472703          	lw	a4,836(a4) # 8001d9d4 <sb+0xc>
    80002698:	4785                	li	a5,1
    8000269a:	06e7f063          	bgeu	a5,a4,800026fa <ialloc+0x72>
    8000269e:	f426                	sd	s1,40(sp)
    800026a0:	f04a                	sd	s2,32(sp)
    800026a2:	ec4e                	sd	s3,24(sp)
    800026a4:	e852                	sd	s4,16(sp)
    800026a6:	e456                	sd	s5,8(sp)
    800026a8:	e05a                	sd	s6,0(sp)
    800026aa:	8aaa                	mv	s5,a0
    800026ac:	8b2e                	mv	s6,a1
    800026ae:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800026b0:	0001ba17          	auipc	s4,0x1b
    800026b4:	318a0a13          	addi	s4,s4,792 # 8001d9c8 <sb>
    800026b8:	00495593          	srli	a1,s2,0x4
    800026bc:	018a2783          	lw	a5,24(s4)
    800026c0:	9dbd                	addw	a1,a1,a5
    800026c2:	8556                	mv	a0,s5
    800026c4:	9fdff0ef          	jal	800020c0 <bread>
    800026c8:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800026ca:	05850993          	addi	s3,a0,88
    800026ce:	00f97793          	andi	a5,s2,15
    800026d2:	079a                	slli	a5,a5,0x6
    800026d4:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800026d6:	00099783          	lh	a5,0(s3)
    800026da:	cb9d                	beqz	a5,80002710 <ialloc+0x88>
    brelse(bp);
    800026dc:	aedff0ef          	jal	800021c8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800026e0:	0905                	addi	s2,s2,1
    800026e2:	00ca2703          	lw	a4,12(s4)
    800026e6:	0009079b          	sext.w	a5,s2
    800026ea:	fce7e7e3          	bltu	a5,a4,800026b8 <ialloc+0x30>
    800026ee:	74a2                	ld	s1,40(sp)
    800026f0:	7902                	ld	s2,32(sp)
    800026f2:	69e2                	ld	s3,24(sp)
    800026f4:	6a42                	ld	s4,16(sp)
    800026f6:	6aa2                	ld	s5,8(sp)
    800026f8:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800026fa:	00005517          	auipc	a0,0x5
    800026fe:	e9e50513          	addi	a0,a0,-354 # 80007598 <etext+0x598>
    80002702:	3cf020ef          	jal	800052d0 <printf>
  return 0;
    80002706:	4501                	li	a0,0
}
    80002708:	70e2                	ld	ra,56(sp)
    8000270a:	7442                	ld	s0,48(sp)
    8000270c:	6121                	addi	sp,sp,64
    8000270e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002710:	04000613          	li	a2,64
    80002714:	4581                	li	a1,0
    80002716:	854e                	mv	a0,s3
    80002718:	a37fd0ef          	jal	8000014e <memset>
      dip->type = type;
    8000271c:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002720:	8526                	mv	a0,s1
    80002722:	2f1000ef          	jal	80003212 <log_write>
      brelse(bp);
    80002726:	8526                	mv	a0,s1
    80002728:	aa1ff0ef          	jal	800021c8 <brelse>
      return iget(dev, inum);
    8000272c:	0009059b          	sext.w	a1,s2
    80002730:	8556                	mv	a0,s5
    80002732:	de7ff0ef          	jal	80002518 <iget>
    80002736:	74a2                	ld	s1,40(sp)
    80002738:	7902                	ld	s2,32(sp)
    8000273a:	69e2                	ld	s3,24(sp)
    8000273c:	6a42                	ld	s4,16(sp)
    8000273e:	6aa2                	ld	s5,8(sp)
    80002740:	6b02                	ld	s6,0(sp)
    80002742:	b7d9                	j	80002708 <ialloc+0x80>

0000000080002744 <iupdate>:
{
    80002744:	1101                	addi	sp,sp,-32
    80002746:	ec06                	sd	ra,24(sp)
    80002748:	e822                	sd	s0,16(sp)
    8000274a:	e426                	sd	s1,8(sp)
    8000274c:	e04a                	sd	s2,0(sp)
    8000274e:	1000                	addi	s0,sp,32
    80002750:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002752:	415c                	lw	a5,4(a0)
    80002754:	0047d79b          	srliw	a5,a5,0x4
    80002758:	0001b597          	auipc	a1,0x1b
    8000275c:	2885a583          	lw	a1,648(a1) # 8001d9e0 <sb+0x18>
    80002760:	9dbd                	addw	a1,a1,a5
    80002762:	4108                	lw	a0,0(a0)
    80002764:	95dff0ef          	jal	800020c0 <bread>
    80002768:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000276a:	05850793          	addi	a5,a0,88
    8000276e:	40d8                	lw	a4,4(s1)
    80002770:	8b3d                	andi	a4,a4,15
    80002772:	071a                	slli	a4,a4,0x6
    80002774:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002776:	04449703          	lh	a4,68(s1)
    8000277a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000277e:	04649703          	lh	a4,70(s1)
    80002782:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002786:	04849703          	lh	a4,72(s1)
    8000278a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000278e:	04a49703          	lh	a4,74(s1)
    80002792:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002796:	44f8                	lw	a4,76(s1)
    80002798:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000279a:	03400613          	li	a2,52
    8000279e:	05048593          	addi	a1,s1,80
    800027a2:	00c78513          	addi	a0,a5,12
    800027a6:	a05fd0ef          	jal	800001aa <memmove>
  log_write(bp);
    800027aa:	854a                	mv	a0,s2
    800027ac:	267000ef          	jal	80003212 <log_write>
  brelse(bp);
    800027b0:	854a                	mv	a0,s2
    800027b2:	a17ff0ef          	jal	800021c8 <brelse>
}
    800027b6:	60e2                	ld	ra,24(sp)
    800027b8:	6442                	ld	s0,16(sp)
    800027ba:	64a2                	ld	s1,8(sp)
    800027bc:	6902                	ld	s2,0(sp)
    800027be:	6105                	addi	sp,sp,32
    800027c0:	8082                	ret

00000000800027c2 <idup>:
{
    800027c2:	1101                	addi	sp,sp,-32
    800027c4:	ec06                	sd	ra,24(sp)
    800027c6:	e822                	sd	s0,16(sp)
    800027c8:	e426                	sd	s1,8(sp)
    800027ca:	1000                	addi	s0,sp,32
    800027cc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800027ce:	0001b517          	auipc	a0,0x1b
    800027d2:	21a50513          	addi	a0,a0,538 # 8001d9e8 <itable>
    800027d6:	0fa030ef          	jal	800058d0 <acquire>
  ip->ref++;
    800027da:	449c                	lw	a5,8(s1)
    800027dc:	2785                	addiw	a5,a5,1
    800027de:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800027e0:	0001b517          	auipc	a0,0x1b
    800027e4:	20850513          	addi	a0,a0,520 # 8001d9e8 <itable>
    800027e8:	180030ef          	jal	80005968 <release>
}
    800027ec:	8526                	mv	a0,s1
    800027ee:	60e2                	ld	ra,24(sp)
    800027f0:	6442                	ld	s0,16(sp)
    800027f2:	64a2                	ld	s1,8(sp)
    800027f4:	6105                	addi	sp,sp,32
    800027f6:	8082                	ret

00000000800027f8 <ilock>:
{
    800027f8:	1101                	addi	sp,sp,-32
    800027fa:	ec06                	sd	ra,24(sp)
    800027fc:	e822                	sd	s0,16(sp)
    800027fe:	e426                	sd	s1,8(sp)
    80002800:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002802:	cd19                	beqz	a0,80002820 <ilock+0x28>
    80002804:	84aa                	mv	s1,a0
    80002806:	451c                	lw	a5,8(a0)
    80002808:	00f05c63          	blez	a5,80002820 <ilock+0x28>
  acquiresleep(&ip->lock);
    8000280c:	0541                	addi	a0,a0,16
    8000280e:	30b000ef          	jal	80003318 <acquiresleep>
  if(ip->valid == 0){
    80002812:	40bc                	lw	a5,64(s1)
    80002814:	cf89                	beqz	a5,8000282e <ilock+0x36>
}
    80002816:	60e2                	ld	ra,24(sp)
    80002818:	6442                	ld	s0,16(sp)
    8000281a:	64a2                	ld	s1,8(sp)
    8000281c:	6105                	addi	sp,sp,32
    8000281e:	8082                	ret
    80002820:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002822:	00005517          	auipc	a0,0x5
    80002826:	d8e50513          	addi	a0,a0,-626 # 800075b0 <etext+0x5b0>
    8000282a:	579020ef          	jal	800055a2 <panic>
    8000282e:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002830:	40dc                	lw	a5,4(s1)
    80002832:	0047d79b          	srliw	a5,a5,0x4
    80002836:	0001b597          	auipc	a1,0x1b
    8000283a:	1aa5a583          	lw	a1,426(a1) # 8001d9e0 <sb+0x18>
    8000283e:	9dbd                	addw	a1,a1,a5
    80002840:	4088                	lw	a0,0(s1)
    80002842:	87fff0ef          	jal	800020c0 <bread>
    80002846:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002848:	05850593          	addi	a1,a0,88
    8000284c:	40dc                	lw	a5,4(s1)
    8000284e:	8bbd                	andi	a5,a5,15
    80002850:	079a                	slli	a5,a5,0x6
    80002852:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002854:	00059783          	lh	a5,0(a1)
    80002858:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000285c:	00259783          	lh	a5,2(a1)
    80002860:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002864:	00459783          	lh	a5,4(a1)
    80002868:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000286c:	00659783          	lh	a5,6(a1)
    80002870:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002874:	459c                	lw	a5,8(a1)
    80002876:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002878:	03400613          	li	a2,52
    8000287c:	05b1                	addi	a1,a1,12
    8000287e:	05048513          	addi	a0,s1,80
    80002882:	929fd0ef          	jal	800001aa <memmove>
    brelse(bp);
    80002886:	854a                	mv	a0,s2
    80002888:	941ff0ef          	jal	800021c8 <brelse>
    ip->valid = 1;
    8000288c:	4785                	li	a5,1
    8000288e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002890:	04449783          	lh	a5,68(s1)
    80002894:	c399                	beqz	a5,8000289a <ilock+0xa2>
    80002896:	6902                	ld	s2,0(sp)
    80002898:	bfbd                	j	80002816 <ilock+0x1e>
      panic("ilock: no type");
    8000289a:	00005517          	auipc	a0,0x5
    8000289e:	d1e50513          	addi	a0,a0,-738 # 800075b8 <etext+0x5b8>
    800028a2:	501020ef          	jal	800055a2 <panic>

00000000800028a6 <iunlock>:
{
    800028a6:	1101                	addi	sp,sp,-32
    800028a8:	ec06                	sd	ra,24(sp)
    800028aa:	e822                	sd	s0,16(sp)
    800028ac:	e426                	sd	s1,8(sp)
    800028ae:	e04a                	sd	s2,0(sp)
    800028b0:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800028b2:	c505                	beqz	a0,800028da <iunlock+0x34>
    800028b4:	84aa                	mv	s1,a0
    800028b6:	01050913          	addi	s2,a0,16
    800028ba:	854a                	mv	a0,s2
    800028bc:	2db000ef          	jal	80003396 <holdingsleep>
    800028c0:	cd09                	beqz	a0,800028da <iunlock+0x34>
    800028c2:	449c                	lw	a5,8(s1)
    800028c4:	00f05b63          	blez	a5,800028da <iunlock+0x34>
  releasesleep(&ip->lock);
    800028c8:	854a                	mv	a0,s2
    800028ca:	295000ef          	jal	8000335e <releasesleep>
}
    800028ce:	60e2                	ld	ra,24(sp)
    800028d0:	6442                	ld	s0,16(sp)
    800028d2:	64a2                	ld	s1,8(sp)
    800028d4:	6902                	ld	s2,0(sp)
    800028d6:	6105                	addi	sp,sp,32
    800028d8:	8082                	ret
    panic("iunlock");
    800028da:	00005517          	auipc	a0,0x5
    800028de:	cee50513          	addi	a0,a0,-786 # 800075c8 <etext+0x5c8>
    800028e2:	4c1020ef          	jal	800055a2 <panic>

00000000800028e6 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800028e6:	7179                	addi	sp,sp,-48
    800028e8:	f406                	sd	ra,40(sp)
    800028ea:	f022                	sd	s0,32(sp)
    800028ec:	ec26                	sd	s1,24(sp)
    800028ee:	e84a                	sd	s2,16(sp)
    800028f0:	e44e                	sd	s3,8(sp)
    800028f2:	1800                	addi	s0,sp,48
    800028f4:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800028f6:	05050493          	addi	s1,a0,80
    800028fa:	08050913          	addi	s2,a0,128
    800028fe:	a021                	j	80002906 <itrunc+0x20>
    80002900:	0491                	addi	s1,s1,4
    80002902:	01248b63          	beq	s1,s2,80002918 <itrunc+0x32>
    if(ip->addrs[i]){
    80002906:	408c                	lw	a1,0(s1)
    80002908:	dde5                	beqz	a1,80002900 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000290a:	0009a503          	lw	a0,0(s3)
    8000290e:	9abff0ef          	jal	800022b8 <bfree>
      ip->addrs[i] = 0;
    80002912:	0004a023          	sw	zero,0(s1)
    80002916:	b7ed                	j	80002900 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002918:	0809a583          	lw	a1,128(s3)
    8000291c:	ed89                	bnez	a1,80002936 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000291e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002922:	854e                	mv	a0,s3
    80002924:	e21ff0ef          	jal	80002744 <iupdate>
}
    80002928:	70a2                	ld	ra,40(sp)
    8000292a:	7402                	ld	s0,32(sp)
    8000292c:	64e2                	ld	s1,24(sp)
    8000292e:	6942                	ld	s2,16(sp)
    80002930:	69a2                	ld	s3,8(sp)
    80002932:	6145                	addi	sp,sp,48
    80002934:	8082                	ret
    80002936:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002938:	0009a503          	lw	a0,0(s3)
    8000293c:	f84ff0ef          	jal	800020c0 <bread>
    80002940:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002942:	05850493          	addi	s1,a0,88
    80002946:	45850913          	addi	s2,a0,1112
    8000294a:	a021                	j	80002952 <itrunc+0x6c>
    8000294c:	0491                	addi	s1,s1,4
    8000294e:	01248963          	beq	s1,s2,80002960 <itrunc+0x7a>
      if(a[j])
    80002952:	408c                	lw	a1,0(s1)
    80002954:	dde5                	beqz	a1,8000294c <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002956:	0009a503          	lw	a0,0(s3)
    8000295a:	95fff0ef          	jal	800022b8 <bfree>
    8000295e:	b7fd                	j	8000294c <itrunc+0x66>
    brelse(bp);
    80002960:	8552                	mv	a0,s4
    80002962:	867ff0ef          	jal	800021c8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002966:	0809a583          	lw	a1,128(s3)
    8000296a:	0009a503          	lw	a0,0(s3)
    8000296e:	94bff0ef          	jal	800022b8 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002972:	0809a023          	sw	zero,128(s3)
    80002976:	6a02                	ld	s4,0(sp)
    80002978:	b75d                	j	8000291e <itrunc+0x38>

000000008000297a <iput>:
{
    8000297a:	1101                	addi	sp,sp,-32
    8000297c:	ec06                	sd	ra,24(sp)
    8000297e:	e822                	sd	s0,16(sp)
    80002980:	e426                	sd	s1,8(sp)
    80002982:	1000                	addi	s0,sp,32
    80002984:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002986:	0001b517          	auipc	a0,0x1b
    8000298a:	06250513          	addi	a0,a0,98 # 8001d9e8 <itable>
    8000298e:	743020ef          	jal	800058d0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002992:	4498                	lw	a4,8(s1)
    80002994:	4785                	li	a5,1
    80002996:	02f70063          	beq	a4,a5,800029b6 <iput+0x3c>
  ip->ref--;
    8000299a:	449c                	lw	a5,8(s1)
    8000299c:	37fd                	addiw	a5,a5,-1
    8000299e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800029a0:	0001b517          	auipc	a0,0x1b
    800029a4:	04850513          	addi	a0,a0,72 # 8001d9e8 <itable>
    800029a8:	7c1020ef          	jal	80005968 <release>
}
    800029ac:	60e2                	ld	ra,24(sp)
    800029ae:	6442                	ld	s0,16(sp)
    800029b0:	64a2                	ld	s1,8(sp)
    800029b2:	6105                	addi	sp,sp,32
    800029b4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800029b6:	40bc                	lw	a5,64(s1)
    800029b8:	d3ed                	beqz	a5,8000299a <iput+0x20>
    800029ba:	04a49783          	lh	a5,74(s1)
    800029be:	fff1                	bnez	a5,8000299a <iput+0x20>
    800029c0:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800029c2:	01048913          	addi	s2,s1,16
    800029c6:	854a                	mv	a0,s2
    800029c8:	151000ef          	jal	80003318 <acquiresleep>
    release(&itable.lock);
    800029cc:	0001b517          	auipc	a0,0x1b
    800029d0:	01c50513          	addi	a0,a0,28 # 8001d9e8 <itable>
    800029d4:	795020ef          	jal	80005968 <release>
    itrunc(ip);
    800029d8:	8526                	mv	a0,s1
    800029da:	f0dff0ef          	jal	800028e6 <itrunc>
    ip->type = 0;
    800029de:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800029e2:	8526                	mv	a0,s1
    800029e4:	d61ff0ef          	jal	80002744 <iupdate>
    ip->valid = 0;
    800029e8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800029ec:	854a                	mv	a0,s2
    800029ee:	171000ef          	jal	8000335e <releasesleep>
    acquire(&itable.lock);
    800029f2:	0001b517          	auipc	a0,0x1b
    800029f6:	ff650513          	addi	a0,a0,-10 # 8001d9e8 <itable>
    800029fa:	6d7020ef          	jal	800058d0 <acquire>
    800029fe:	6902                	ld	s2,0(sp)
    80002a00:	bf69                	j	8000299a <iput+0x20>

0000000080002a02 <iunlockput>:
{
    80002a02:	1101                	addi	sp,sp,-32
    80002a04:	ec06                	sd	ra,24(sp)
    80002a06:	e822                	sd	s0,16(sp)
    80002a08:	e426                	sd	s1,8(sp)
    80002a0a:	1000                	addi	s0,sp,32
    80002a0c:	84aa                	mv	s1,a0
  iunlock(ip);
    80002a0e:	e99ff0ef          	jal	800028a6 <iunlock>
  iput(ip);
    80002a12:	8526                	mv	a0,s1
    80002a14:	f67ff0ef          	jal	8000297a <iput>
}
    80002a18:	60e2                	ld	ra,24(sp)
    80002a1a:	6442                	ld	s0,16(sp)
    80002a1c:	64a2                	ld	s1,8(sp)
    80002a1e:	6105                	addi	sp,sp,32
    80002a20:	8082                	ret

0000000080002a22 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002a22:	1141                	addi	sp,sp,-16
    80002a24:	e422                	sd	s0,8(sp)
    80002a26:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002a28:	411c                	lw	a5,0(a0)
    80002a2a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002a2c:	415c                	lw	a5,4(a0)
    80002a2e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002a30:	04451783          	lh	a5,68(a0)
    80002a34:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002a38:	04a51783          	lh	a5,74(a0)
    80002a3c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002a40:	04c56783          	lwu	a5,76(a0)
    80002a44:	e99c                	sd	a5,16(a1)
}
    80002a46:	6422                	ld	s0,8(sp)
    80002a48:	0141                	addi	sp,sp,16
    80002a4a:	8082                	ret

0000000080002a4c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a4c:	457c                	lw	a5,76(a0)
    80002a4e:	0ed7eb63          	bltu	a5,a3,80002b44 <readi+0xf8>
{
    80002a52:	7159                	addi	sp,sp,-112
    80002a54:	f486                	sd	ra,104(sp)
    80002a56:	f0a2                	sd	s0,96(sp)
    80002a58:	eca6                	sd	s1,88(sp)
    80002a5a:	e0d2                	sd	s4,64(sp)
    80002a5c:	fc56                	sd	s5,56(sp)
    80002a5e:	f85a                	sd	s6,48(sp)
    80002a60:	f45e                	sd	s7,40(sp)
    80002a62:	1880                	addi	s0,sp,112
    80002a64:	8b2a                	mv	s6,a0
    80002a66:	8bae                	mv	s7,a1
    80002a68:	8a32                	mv	s4,a2
    80002a6a:	84b6                	mv	s1,a3
    80002a6c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002a6e:	9f35                	addw	a4,a4,a3
    return 0;
    80002a70:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002a72:	0cd76063          	bltu	a4,a3,80002b32 <readi+0xe6>
    80002a76:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002a78:	00e7f463          	bgeu	a5,a4,80002a80 <readi+0x34>
    n = ip->size - off;
    80002a7c:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a80:	080a8f63          	beqz	s5,80002b1e <readi+0xd2>
    80002a84:	e8ca                	sd	s2,80(sp)
    80002a86:	f062                	sd	s8,32(sp)
    80002a88:	ec66                	sd	s9,24(sp)
    80002a8a:	e86a                	sd	s10,16(sp)
    80002a8c:	e46e                	sd	s11,8(sp)
    80002a8e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a90:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002a94:	5c7d                	li	s8,-1
    80002a96:	a80d                	j	80002ac8 <readi+0x7c>
    80002a98:	020d1d93          	slli	s11,s10,0x20
    80002a9c:	020ddd93          	srli	s11,s11,0x20
    80002aa0:	05890613          	addi	a2,s2,88
    80002aa4:	86ee                	mv	a3,s11
    80002aa6:	963a                	add	a2,a2,a4
    80002aa8:	85d2                	mv	a1,s4
    80002aaa:	855e                	mv	a0,s7
    80002aac:	bf1fe0ef          	jal	8000169c <either_copyout>
    80002ab0:	05850763          	beq	a0,s8,80002afe <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ab4:	854a                	mv	a0,s2
    80002ab6:	f12ff0ef          	jal	800021c8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002aba:	013d09bb          	addw	s3,s10,s3
    80002abe:	009d04bb          	addw	s1,s10,s1
    80002ac2:	9a6e                	add	s4,s4,s11
    80002ac4:	0559f763          	bgeu	s3,s5,80002b12 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002ac8:	00a4d59b          	srliw	a1,s1,0xa
    80002acc:	855a                	mv	a0,s6
    80002ace:	977ff0ef          	jal	80002444 <bmap>
    80002ad2:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002ad6:	c5b1                	beqz	a1,80002b22 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002ad8:	000b2503          	lw	a0,0(s6)
    80002adc:	de4ff0ef          	jal	800020c0 <bread>
    80002ae0:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ae2:	3ff4f713          	andi	a4,s1,1023
    80002ae6:	40ec87bb          	subw	a5,s9,a4
    80002aea:	413a86bb          	subw	a3,s5,s3
    80002aee:	8d3e                	mv	s10,a5
    80002af0:	2781                	sext.w	a5,a5
    80002af2:	0006861b          	sext.w	a2,a3
    80002af6:	faf671e3          	bgeu	a2,a5,80002a98 <readi+0x4c>
    80002afa:	8d36                	mv	s10,a3
    80002afc:	bf71                	j	80002a98 <readi+0x4c>
      brelse(bp);
    80002afe:	854a                	mv	a0,s2
    80002b00:	ec8ff0ef          	jal	800021c8 <brelse>
      tot = -1;
    80002b04:	59fd                	li	s3,-1
      break;
    80002b06:	6946                	ld	s2,80(sp)
    80002b08:	7c02                	ld	s8,32(sp)
    80002b0a:	6ce2                	ld	s9,24(sp)
    80002b0c:	6d42                	ld	s10,16(sp)
    80002b0e:	6da2                	ld	s11,8(sp)
    80002b10:	a831                	j	80002b2c <readi+0xe0>
    80002b12:	6946                	ld	s2,80(sp)
    80002b14:	7c02                	ld	s8,32(sp)
    80002b16:	6ce2                	ld	s9,24(sp)
    80002b18:	6d42                	ld	s10,16(sp)
    80002b1a:	6da2                	ld	s11,8(sp)
    80002b1c:	a801                	j	80002b2c <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b1e:	89d6                	mv	s3,s5
    80002b20:	a031                	j	80002b2c <readi+0xe0>
    80002b22:	6946                	ld	s2,80(sp)
    80002b24:	7c02                	ld	s8,32(sp)
    80002b26:	6ce2                	ld	s9,24(sp)
    80002b28:	6d42                	ld	s10,16(sp)
    80002b2a:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002b2c:	0009851b          	sext.w	a0,s3
    80002b30:	69a6                	ld	s3,72(sp)
}
    80002b32:	70a6                	ld	ra,104(sp)
    80002b34:	7406                	ld	s0,96(sp)
    80002b36:	64e6                	ld	s1,88(sp)
    80002b38:	6a06                	ld	s4,64(sp)
    80002b3a:	7ae2                	ld	s5,56(sp)
    80002b3c:	7b42                	ld	s6,48(sp)
    80002b3e:	7ba2                	ld	s7,40(sp)
    80002b40:	6165                	addi	sp,sp,112
    80002b42:	8082                	ret
    return 0;
    80002b44:	4501                	li	a0,0
}
    80002b46:	8082                	ret

0000000080002b48 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002b48:	457c                	lw	a5,76(a0)
    80002b4a:	10d7e063          	bltu	a5,a3,80002c4a <writei+0x102>
{
    80002b4e:	7159                	addi	sp,sp,-112
    80002b50:	f486                	sd	ra,104(sp)
    80002b52:	f0a2                	sd	s0,96(sp)
    80002b54:	e8ca                	sd	s2,80(sp)
    80002b56:	e0d2                	sd	s4,64(sp)
    80002b58:	fc56                	sd	s5,56(sp)
    80002b5a:	f85a                	sd	s6,48(sp)
    80002b5c:	f45e                	sd	s7,40(sp)
    80002b5e:	1880                	addi	s0,sp,112
    80002b60:	8aaa                	mv	s5,a0
    80002b62:	8bae                	mv	s7,a1
    80002b64:	8a32                	mv	s4,a2
    80002b66:	8936                	mv	s2,a3
    80002b68:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002b6a:	00e687bb          	addw	a5,a3,a4
    80002b6e:	0ed7e063          	bltu	a5,a3,80002c4e <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002b72:	00043737          	lui	a4,0x43
    80002b76:	0cf76e63          	bltu	a4,a5,80002c52 <writei+0x10a>
    80002b7a:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b7c:	0a0b0f63          	beqz	s6,80002c3a <writei+0xf2>
    80002b80:	eca6                	sd	s1,88(sp)
    80002b82:	f062                	sd	s8,32(sp)
    80002b84:	ec66                	sd	s9,24(sp)
    80002b86:	e86a                	sd	s10,16(sp)
    80002b88:	e46e                	sd	s11,8(sp)
    80002b8a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b8c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002b90:	5c7d                	li	s8,-1
    80002b92:	a825                	j	80002bca <writei+0x82>
    80002b94:	020d1d93          	slli	s11,s10,0x20
    80002b98:	020ddd93          	srli	s11,s11,0x20
    80002b9c:	05848513          	addi	a0,s1,88
    80002ba0:	86ee                	mv	a3,s11
    80002ba2:	8652                	mv	a2,s4
    80002ba4:	85de                	mv	a1,s7
    80002ba6:	953a                	add	a0,a0,a4
    80002ba8:	b3ffe0ef          	jal	800016e6 <either_copyin>
    80002bac:	05850a63          	beq	a0,s8,80002c00 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002bb0:	8526                	mv	a0,s1
    80002bb2:	660000ef          	jal	80003212 <log_write>
    brelse(bp);
    80002bb6:	8526                	mv	a0,s1
    80002bb8:	e10ff0ef          	jal	800021c8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002bbc:	013d09bb          	addw	s3,s10,s3
    80002bc0:	012d093b          	addw	s2,s10,s2
    80002bc4:	9a6e                	add	s4,s4,s11
    80002bc6:	0569f063          	bgeu	s3,s6,80002c06 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002bca:	00a9559b          	srliw	a1,s2,0xa
    80002bce:	8556                	mv	a0,s5
    80002bd0:	875ff0ef          	jal	80002444 <bmap>
    80002bd4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002bd8:	c59d                	beqz	a1,80002c06 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002bda:	000aa503          	lw	a0,0(s5)
    80002bde:	ce2ff0ef          	jal	800020c0 <bread>
    80002be2:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002be4:	3ff97713          	andi	a4,s2,1023
    80002be8:	40ec87bb          	subw	a5,s9,a4
    80002bec:	413b06bb          	subw	a3,s6,s3
    80002bf0:	8d3e                	mv	s10,a5
    80002bf2:	2781                	sext.w	a5,a5
    80002bf4:	0006861b          	sext.w	a2,a3
    80002bf8:	f8f67ee3          	bgeu	a2,a5,80002b94 <writei+0x4c>
    80002bfc:	8d36                	mv	s10,a3
    80002bfe:	bf59                	j	80002b94 <writei+0x4c>
      brelse(bp);
    80002c00:	8526                	mv	a0,s1
    80002c02:	dc6ff0ef          	jal	800021c8 <brelse>
  }

  if(off > ip->size)
    80002c06:	04caa783          	lw	a5,76(s5)
    80002c0a:	0327fa63          	bgeu	a5,s2,80002c3e <writei+0xf6>
    ip->size = off;
    80002c0e:	052aa623          	sw	s2,76(s5)
    80002c12:	64e6                	ld	s1,88(sp)
    80002c14:	7c02                	ld	s8,32(sp)
    80002c16:	6ce2                	ld	s9,24(sp)
    80002c18:	6d42                	ld	s10,16(sp)
    80002c1a:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002c1c:	8556                	mv	a0,s5
    80002c1e:	b27ff0ef          	jal	80002744 <iupdate>

  return tot;
    80002c22:	0009851b          	sext.w	a0,s3
    80002c26:	69a6                	ld	s3,72(sp)
}
    80002c28:	70a6                	ld	ra,104(sp)
    80002c2a:	7406                	ld	s0,96(sp)
    80002c2c:	6946                	ld	s2,80(sp)
    80002c2e:	6a06                	ld	s4,64(sp)
    80002c30:	7ae2                	ld	s5,56(sp)
    80002c32:	7b42                	ld	s6,48(sp)
    80002c34:	7ba2                	ld	s7,40(sp)
    80002c36:	6165                	addi	sp,sp,112
    80002c38:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c3a:	89da                	mv	s3,s6
    80002c3c:	b7c5                	j	80002c1c <writei+0xd4>
    80002c3e:	64e6                	ld	s1,88(sp)
    80002c40:	7c02                	ld	s8,32(sp)
    80002c42:	6ce2                	ld	s9,24(sp)
    80002c44:	6d42                	ld	s10,16(sp)
    80002c46:	6da2                	ld	s11,8(sp)
    80002c48:	bfd1                	j	80002c1c <writei+0xd4>
    return -1;
    80002c4a:	557d                	li	a0,-1
}
    80002c4c:	8082                	ret
    return -1;
    80002c4e:	557d                	li	a0,-1
    80002c50:	bfe1                	j	80002c28 <writei+0xe0>
    return -1;
    80002c52:	557d                	li	a0,-1
    80002c54:	bfd1                	j	80002c28 <writei+0xe0>

0000000080002c56 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002c56:	1141                	addi	sp,sp,-16
    80002c58:	e406                	sd	ra,8(sp)
    80002c5a:	e022                	sd	s0,0(sp)
    80002c5c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002c5e:	4639                	li	a2,14
    80002c60:	dbafd0ef          	jal	8000021a <strncmp>
}
    80002c64:	60a2                	ld	ra,8(sp)
    80002c66:	6402                	ld	s0,0(sp)
    80002c68:	0141                	addi	sp,sp,16
    80002c6a:	8082                	ret

0000000080002c6c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002c6c:	7139                	addi	sp,sp,-64
    80002c6e:	fc06                	sd	ra,56(sp)
    80002c70:	f822                	sd	s0,48(sp)
    80002c72:	f426                	sd	s1,40(sp)
    80002c74:	f04a                	sd	s2,32(sp)
    80002c76:	ec4e                	sd	s3,24(sp)
    80002c78:	e852                	sd	s4,16(sp)
    80002c7a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002c7c:	04451703          	lh	a4,68(a0)
    80002c80:	4785                	li	a5,1
    80002c82:	00f71a63          	bne	a4,a5,80002c96 <dirlookup+0x2a>
    80002c86:	892a                	mv	s2,a0
    80002c88:	89ae                	mv	s3,a1
    80002c8a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c8c:	457c                	lw	a5,76(a0)
    80002c8e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002c90:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c92:	e39d                	bnez	a5,80002cb8 <dirlookup+0x4c>
    80002c94:	a095                	j	80002cf8 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002c96:	00005517          	auipc	a0,0x5
    80002c9a:	93a50513          	addi	a0,a0,-1734 # 800075d0 <etext+0x5d0>
    80002c9e:	105020ef          	jal	800055a2 <panic>
      panic("dirlookup read");
    80002ca2:	00005517          	auipc	a0,0x5
    80002ca6:	94650513          	addi	a0,a0,-1722 # 800075e8 <etext+0x5e8>
    80002caa:	0f9020ef          	jal	800055a2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cae:	24c1                	addiw	s1,s1,16
    80002cb0:	04c92783          	lw	a5,76(s2)
    80002cb4:	04f4f163          	bgeu	s1,a5,80002cf6 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002cb8:	4741                	li	a4,16
    80002cba:	86a6                	mv	a3,s1
    80002cbc:	fc040613          	addi	a2,s0,-64
    80002cc0:	4581                	li	a1,0
    80002cc2:	854a                	mv	a0,s2
    80002cc4:	d89ff0ef          	jal	80002a4c <readi>
    80002cc8:	47c1                	li	a5,16
    80002cca:	fcf51ce3          	bne	a0,a5,80002ca2 <dirlookup+0x36>
    if(de.inum == 0)
    80002cce:	fc045783          	lhu	a5,-64(s0)
    80002cd2:	dff1                	beqz	a5,80002cae <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002cd4:	fc240593          	addi	a1,s0,-62
    80002cd8:	854e                	mv	a0,s3
    80002cda:	f7dff0ef          	jal	80002c56 <namecmp>
    80002cde:	f961                	bnez	a0,80002cae <dirlookup+0x42>
      if(poff)
    80002ce0:	000a0463          	beqz	s4,80002ce8 <dirlookup+0x7c>
        *poff = off;
    80002ce4:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002ce8:	fc045583          	lhu	a1,-64(s0)
    80002cec:	00092503          	lw	a0,0(s2)
    80002cf0:	829ff0ef          	jal	80002518 <iget>
    80002cf4:	a011                	j	80002cf8 <dirlookup+0x8c>
  return 0;
    80002cf6:	4501                	li	a0,0
}
    80002cf8:	70e2                	ld	ra,56(sp)
    80002cfa:	7442                	ld	s0,48(sp)
    80002cfc:	74a2                	ld	s1,40(sp)
    80002cfe:	7902                	ld	s2,32(sp)
    80002d00:	69e2                	ld	s3,24(sp)
    80002d02:	6a42                	ld	s4,16(sp)
    80002d04:	6121                	addi	sp,sp,64
    80002d06:	8082                	ret

0000000080002d08 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002d08:	711d                	addi	sp,sp,-96
    80002d0a:	ec86                	sd	ra,88(sp)
    80002d0c:	e8a2                	sd	s0,80(sp)
    80002d0e:	e4a6                	sd	s1,72(sp)
    80002d10:	e0ca                	sd	s2,64(sp)
    80002d12:	fc4e                	sd	s3,56(sp)
    80002d14:	f852                	sd	s4,48(sp)
    80002d16:	f456                	sd	s5,40(sp)
    80002d18:	f05a                	sd	s6,32(sp)
    80002d1a:	ec5e                	sd	s7,24(sp)
    80002d1c:	e862                	sd	s8,16(sp)
    80002d1e:	e466                	sd	s9,8(sp)
    80002d20:	1080                	addi	s0,sp,96
    80002d22:	84aa                	mv	s1,a0
    80002d24:	8b2e                	mv	s6,a1
    80002d26:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002d28:	00054703          	lbu	a4,0(a0)
    80002d2c:	02f00793          	li	a5,47
    80002d30:	00f70e63          	beq	a4,a5,80002d4c <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002d34:	826fe0ef          	jal	80000d5a <myproc>
    80002d38:	15053503          	ld	a0,336(a0)
    80002d3c:	a87ff0ef          	jal	800027c2 <idup>
    80002d40:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002d42:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002d46:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002d48:	4b85                	li	s7,1
    80002d4a:	a871                	j	80002de6 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002d4c:	4585                	li	a1,1
    80002d4e:	4505                	li	a0,1
    80002d50:	fc8ff0ef          	jal	80002518 <iget>
    80002d54:	8a2a                	mv	s4,a0
    80002d56:	b7f5                	j	80002d42 <namex+0x3a>
      iunlockput(ip);
    80002d58:	8552                	mv	a0,s4
    80002d5a:	ca9ff0ef          	jal	80002a02 <iunlockput>
      return 0;
    80002d5e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002d60:	8552                	mv	a0,s4
    80002d62:	60e6                	ld	ra,88(sp)
    80002d64:	6446                	ld	s0,80(sp)
    80002d66:	64a6                	ld	s1,72(sp)
    80002d68:	6906                	ld	s2,64(sp)
    80002d6a:	79e2                	ld	s3,56(sp)
    80002d6c:	7a42                	ld	s4,48(sp)
    80002d6e:	7aa2                	ld	s5,40(sp)
    80002d70:	7b02                	ld	s6,32(sp)
    80002d72:	6be2                	ld	s7,24(sp)
    80002d74:	6c42                	ld	s8,16(sp)
    80002d76:	6ca2                	ld	s9,8(sp)
    80002d78:	6125                	addi	sp,sp,96
    80002d7a:	8082                	ret
      iunlock(ip);
    80002d7c:	8552                	mv	a0,s4
    80002d7e:	b29ff0ef          	jal	800028a6 <iunlock>
      return ip;
    80002d82:	bff9                	j	80002d60 <namex+0x58>
      iunlockput(ip);
    80002d84:	8552                	mv	a0,s4
    80002d86:	c7dff0ef          	jal	80002a02 <iunlockput>
      return 0;
    80002d8a:	8a4e                	mv	s4,s3
    80002d8c:	bfd1                	j	80002d60 <namex+0x58>
  len = path - s;
    80002d8e:	40998633          	sub	a2,s3,s1
    80002d92:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002d96:	099c5063          	bge	s8,s9,80002e16 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002d9a:	4639                	li	a2,14
    80002d9c:	85a6                	mv	a1,s1
    80002d9e:	8556                	mv	a0,s5
    80002da0:	c0afd0ef          	jal	800001aa <memmove>
    80002da4:	84ce                	mv	s1,s3
  while(*path == '/')
    80002da6:	0004c783          	lbu	a5,0(s1)
    80002daa:	01279763          	bne	a5,s2,80002db8 <namex+0xb0>
    path++;
    80002dae:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002db0:	0004c783          	lbu	a5,0(s1)
    80002db4:	ff278de3          	beq	a5,s2,80002dae <namex+0xa6>
    ilock(ip);
    80002db8:	8552                	mv	a0,s4
    80002dba:	a3fff0ef          	jal	800027f8 <ilock>
    if(ip->type != T_DIR){
    80002dbe:	044a1783          	lh	a5,68(s4)
    80002dc2:	f9779be3          	bne	a5,s7,80002d58 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002dc6:	000b0563          	beqz	s6,80002dd0 <namex+0xc8>
    80002dca:	0004c783          	lbu	a5,0(s1)
    80002dce:	d7dd                	beqz	a5,80002d7c <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002dd0:	4601                	li	a2,0
    80002dd2:	85d6                	mv	a1,s5
    80002dd4:	8552                	mv	a0,s4
    80002dd6:	e97ff0ef          	jal	80002c6c <dirlookup>
    80002dda:	89aa                	mv	s3,a0
    80002ddc:	d545                	beqz	a0,80002d84 <namex+0x7c>
    iunlockput(ip);
    80002dde:	8552                	mv	a0,s4
    80002de0:	c23ff0ef          	jal	80002a02 <iunlockput>
    ip = next;
    80002de4:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002de6:	0004c783          	lbu	a5,0(s1)
    80002dea:	01279763          	bne	a5,s2,80002df8 <namex+0xf0>
    path++;
    80002dee:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002df0:	0004c783          	lbu	a5,0(s1)
    80002df4:	ff278de3          	beq	a5,s2,80002dee <namex+0xe6>
  if(*path == 0)
    80002df8:	cb8d                	beqz	a5,80002e2a <namex+0x122>
  while(*path != '/' && *path != 0)
    80002dfa:	0004c783          	lbu	a5,0(s1)
    80002dfe:	89a6                	mv	s3,s1
  len = path - s;
    80002e00:	4c81                	li	s9,0
    80002e02:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002e04:	01278963          	beq	a5,s2,80002e16 <namex+0x10e>
    80002e08:	d3d9                	beqz	a5,80002d8e <namex+0x86>
    path++;
    80002e0a:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002e0c:	0009c783          	lbu	a5,0(s3)
    80002e10:	ff279ce3          	bne	a5,s2,80002e08 <namex+0x100>
    80002e14:	bfad                	j	80002d8e <namex+0x86>
    memmove(name, s, len);
    80002e16:	2601                	sext.w	a2,a2
    80002e18:	85a6                	mv	a1,s1
    80002e1a:	8556                	mv	a0,s5
    80002e1c:	b8efd0ef          	jal	800001aa <memmove>
    name[len] = 0;
    80002e20:	9cd6                	add	s9,s9,s5
    80002e22:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002e26:	84ce                	mv	s1,s3
    80002e28:	bfbd                	j	80002da6 <namex+0x9e>
  if(nameiparent){
    80002e2a:	f20b0be3          	beqz	s6,80002d60 <namex+0x58>
    iput(ip);
    80002e2e:	8552                	mv	a0,s4
    80002e30:	b4bff0ef          	jal	8000297a <iput>
    return 0;
    80002e34:	4a01                	li	s4,0
    80002e36:	b72d                	j	80002d60 <namex+0x58>

0000000080002e38 <dirlink>:
{
    80002e38:	7139                	addi	sp,sp,-64
    80002e3a:	fc06                	sd	ra,56(sp)
    80002e3c:	f822                	sd	s0,48(sp)
    80002e3e:	f04a                	sd	s2,32(sp)
    80002e40:	ec4e                	sd	s3,24(sp)
    80002e42:	e852                	sd	s4,16(sp)
    80002e44:	0080                	addi	s0,sp,64
    80002e46:	892a                	mv	s2,a0
    80002e48:	8a2e                	mv	s4,a1
    80002e4a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002e4c:	4601                	li	a2,0
    80002e4e:	e1fff0ef          	jal	80002c6c <dirlookup>
    80002e52:	e535                	bnez	a0,80002ebe <dirlink+0x86>
    80002e54:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e56:	04c92483          	lw	s1,76(s2)
    80002e5a:	c48d                	beqz	s1,80002e84 <dirlink+0x4c>
    80002e5c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e5e:	4741                	li	a4,16
    80002e60:	86a6                	mv	a3,s1
    80002e62:	fc040613          	addi	a2,s0,-64
    80002e66:	4581                	li	a1,0
    80002e68:	854a                	mv	a0,s2
    80002e6a:	be3ff0ef          	jal	80002a4c <readi>
    80002e6e:	47c1                	li	a5,16
    80002e70:	04f51b63          	bne	a0,a5,80002ec6 <dirlink+0x8e>
    if(de.inum == 0)
    80002e74:	fc045783          	lhu	a5,-64(s0)
    80002e78:	c791                	beqz	a5,80002e84 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e7a:	24c1                	addiw	s1,s1,16
    80002e7c:	04c92783          	lw	a5,76(s2)
    80002e80:	fcf4efe3          	bltu	s1,a5,80002e5e <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002e84:	4639                	li	a2,14
    80002e86:	85d2                	mv	a1,s4
    80002e88:	fc240513          	addi	a0,s0,-62
    80002e8c:	bc4fd0ef          	jal	80000250 <strncpy>
  de.inum = inum;
    80002e90:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e94:	4741                	li	a4,16
    80002e96:	86a6                	mv	a3,s1
    80002e98:	fc040613          	addi	a2,s0,-64
    80002e9c:	4581                	li	a1,0
    80002e9e:	854a                	mv	a0,s2
    80002ea0:	ca9ff0ef          	jal	80002b48 <writei>
    80002ea4:	1541                	addi	a0,a0,-16
    80002ea6:	00a03533          	snez	a0,a0
    80002eaa:	40a00533          	neg	a0,a0
    80002eae:	74a2                	ld	s1,40(sp)
}
    80002eb0:	70e2                	ld	ra,56(sp)
    80002eb2:	7442                	ld	s0,48(sp)
    80002eb4:	7902                	ld	s2,32(sp)
    80002eb6:	69e2                	ld	s3,24(sp)
    80002eb8:	6a42                	ld	s4,16(sp)
    80002eba:	6121                	addi	sp,sp,64
    80002ebc:	8082                	ret
    iput(ip);
    80002ebe:	abdff0ef          	jal	8000297a <iput>
    return -1;
    80002ec2:	557d                	li	a0,-1
    80002ec4:	b7f5                	j	80002eb0 <dirlink+0x78>
      panic("dirlink read");
    80002ec6:	00004517          	auipc	a0,0x4
    80002eca:	73250513          	addi	a0,a0,1842 # 800075f8 <etext+0x5f8>
    80002ece:	6d4020ef          	jal	800055a2 <panic>

0000000080002ed2 <namei>:

struct inode*
namei(char *path)
{
    80002ed2:	1101                	addi	sp,sp,-32
    80002ed4:	ec06                	sd	ra,24(sp)
    80002ed6:	e822                	sd	s0,16(sp)
    80002ed8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002eda:	fe040613          	addi	a2,s0,-32
    80002ede:	4581                	li	a1,0
    80002ee0:	e29ff0ef          	jal	80002d08 <namex>
}
    80002ee4:	60e2                	ld	ra,24(sp)
    80002ee6:	6442                	ld	s0,16(sp)
    80002ee8:	6105                	addi	sp,sp,32
    80002eea:	8082                	ret

0000000080002eec <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002eec:	1141                	addi	sp,sp,-16
    80002eee:	e406                	sd	ra,8(sp)
    80002ef0:	e022                	sd	s0,0(sp)
    80002ef2:	0800                	addi	s0,sp,16
    80002ef4:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002ef6:	4585                	li	a1,1
    80002ef8:	e11ff0ef          	jal	80002d08 <namex>
}
    80002efc:	60a2                	ld	ra,8(sp)
    80002efe:	6402                	ld	s0,0(sp)
    80002f00:	0141                	addi	sp,sp,16
    80002f02:	8082                	ret

0000000080002f04 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002f04:	1101                	addi	sp,sp,-32
    80002f06:	ec06                	sd	ra,24(sp)
    80002f08:	e822                	sd	s0,16(sp)
    80002f0a:	e426                	sd	s1,8(sp)
    80002f0c:	e04a                	sd	s2,0(sp)
    80002f0e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002f10:	0001c917          	auipc	s2,0x1c
    80002f14:	58090913          	addi	s2,s2,1408 # 8001f490 <log>
    80002f18:	01892583          	lw	a1,24(s2)
    80002f1c:	02892503          	lw	a0,40(s2)
    80002f20:	9a0ff0ef          	jal	800020c0 <bread>
    80002f24:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002f26:	02c92603          	lw	a2,44(s2)
    80002f2a:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002f2c:	00c05f63          	blez	a2,80002f4a <write_head+0x46>
    80002f30:	0001c717          	auipc	a4,0x1c
    80002f34:	59070713          	addi	a4,a4,1424 # 8001f4c0 <log+0x30>
    80002f38:	87aa                	mv	a5,a0
    80002f3a:	060a                	slli	a2,a2,0x2
    80002f3c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002f3e:	4314                	lw	a3,0(a4)
    80002f40:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002f42:	0711                	addi	a4,a4,4
    80002f44:	0791                	addi	a5,a5,4
    80002f46:	fec79ce3          	bne	a5,a2,80002f3e <write_head+0x3a>
  }
  bwrite(buf);
    80002f4a:	8526                	mv	a0,s1
    80002f4c:	a4aff0ef          	jal	80002196 <bwrite>
  brelse(buf);
    80002f50:	8526                	mv	a0,s1
    80002f52:	a76ff0ef          	jal	800021c8 <brelse>
}
    80002f56:	60e2                	ld	ra,24(sp)
    80002f58:	6442                	ld	s0,16(sp)
    80002f5a:	64a2                	ld	s1,8(sp)
    80002f5c:	6902                	ld	s2,0(sp)
    80002f5e:	6105                	addi	sp,sp,32
    80002f60:	8082                	ret

0000000080002f62 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f62:	0001c797          	auipc	a5,0x1c
    80002f66:	55a7a783          	lw	a5,1370(a5) # 8001f4bc <log+0x2c>
    80002f6a:	08f05f63          	blez	a5,80003008 <install_trans+0xa6>
{
    80002f6e:	7139                	addi	sp,sp,-64
    80002f70:	fc06                	sd	ra,56(sp)
    80002f72:	f822                	sd	s0,48(sp)
    80002f74:	f426                	sd	s1,40(sp)
    80002f76:	f04a                	sd	s2,32(sp)
    80002f78:	ec4e                	sd	s3,24(sp)
    80002f7a:	e852                	sd	s4,16(sp)
    80002f7c:	e456                	sd	s5,8(sp)
    80002f7e:	e05a                	sd	s6,0(sp)
    80002f80:	0080                	addi	s0,sp,64
    80002f82:	8b2a                	mv	s6,a0
    80002f84:	0001ca97          	auipc	s5,0x1c
    80002f88:	53ca8a93          	addi	s5,s5,1340 # 8001f4c0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f8c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f8e:	0001c997          	auipc	s3,0x1c
    80002f92:	50298993          	addi	s3,s3,1282 # 8001f490 <log>
    80002f96:	a829                	j	80002fb0 <install_trans+0x4e>
    brelse(lbuf);
    80002f98:	854a                	mv	a0,s2
    80002f9a:	a2eff0ef          	jal	800021c8 <brelse>
    brelse(dbuf);
    80002f9e:	8526                	mv	a0,s1
    80002fa0:	a28ff0ef          	jal	800021c8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fa4:	2a05                	addiw	s4,s4,1
    80002fa6:	0a91                	addi	s5,s5,4
    80002fa8:	02c9a783          	lw	a5,44(s3)
    80002fac:	04fa5463          	bge	s4,a5,80002ff4 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002fb0:	0189a583          	lw	a1,24(s3)
    80002fb4:	014585bb          	addw	a1,a1,s4
    80002fb8:	2585                	addiw	a1,a1,1
    80002fba:	0289a503          	lw	a0,40(s3)
    80002fbe:	902ff0ef          	jal	800020c0 <bread>
    80002fc2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002fc4:	000aa583          	lw	a1,0(s5)
    80002fc8:	0289a503          	lw	a0,40(s3)
    80002fcc:	8f4ff0ef          	jal	800020c0 <bread>
    80002fd0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002fd2:	40000613          	li	a2,1024
    80002fd6:	05890593          	addi	a1,s2,88
    80002fda:	05850513          	addi	a0,a0,88
    80002fde:	9ccfd0ef          	jal	800001aa <memmove>
    bwrite(dbuf);  // write dst to disk
    80002fe2:	8526                	mv	a0,s1
    80002fe4:	9b2ff0ef          	jal	80002196 <bwrite>
    if(recovering == 0)
    80002fe8:	fa0b18e3          	bnez	s6,80002f98 <install_trans+0x36>
      bunpin(dbuf);
    80002fec:	8526                	mv	a0,s1
    80002fee:	a96ff0ef          	jal	80002284 <bunpin>
    80002ff2:	b75d                	j	80002f98 <install_trans+0x36>
}
    80002ff4:	70e2                	ld	ra,56(sp)
    80002ff6:	7442                	ld	s0,48(sp)
    80002ff8:	74a2                	ld	s1,40(sp)
    80002ffa:	7902                	ld	s2,32(sp)
    80002ffc:	69e2                	ld	s3,24(sp)
    80002ffe:	6a42                	ld	s4,16(sp)
    80003000:	6aa2                	ld	s5,8(sp)
    80003002:	6b02                	ld	s6,0(sp)
    80003004:	6121                	addi	sp,sp,64
    80003006:	8082                	ret
    80003008:	8082                	ret

000000008000300a <initlog>:
{
    8000300a:	7179                	addi	sp,sp,-48
    8000300c:	f406                	sd	ra,40(sp)
    8000300e:	f022                	sd	s0,32(sp)
    80003010:	ec26                	sd	s1,24(sp)
    80003012:	e84a                	sd	s2,16(sp)
    80003014:	e44e                	sd	s3,8(sp)
    80003016:	1800                	addi	s0,sp,48
    80003018:	892a                	mv	s2,a0
    8000301a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000301c:	0001c497          	auipc	s1,0x1c
    80003020:	47448493          	addi	s1,s1,1140 # 8001f490 <log>
    80003024:	00004597          	auipc	a1,0x4
    80003028:	5e458593          	addi	a1,a1,1508 # 80007608 <etext+0x608>
    8000302c:	8526                	mv	a0,s1
    8000302e:	023020ef          	jal	80005850 <initlock>
  log.start = sb->logstart;
    80003032:	0149a583          	lw	a1,20(s3)
    80003036:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003038:	0109a783          	lw	a5,16(s3)
    8000303c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000303e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003042:	854a                	mv	a0,s2
    80003044:	87cff0ef          	jal	800020c0 <bread>
  log.lh.n = lh->n;
    80003048:	4d30                	lw	a2,88(a0)
    8000304a:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000304c:	00c05f63          	blez	a2,8000306a <initlog+0x60>
    80003050:	87aa                	mv	a5,a0
    80003052:	0001c717          	auipc	a4,0x1c
    80003056:	46e70713          	addi	a4,a4,1134 # 8001f4c0 <log+0x30>
    8000305a:	060a                	slli	a2,a2,0x2
    8000305c:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000305e:	4ff4                	lw	a3,92(a5)
    80003060:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003062:	0791                	addi	a5,a5,4
    80003064:	0711                	addi	a4,a4,4
    80003066:	fec79ce3          	bne	a5,a2,8000305e <initlog+0x54>
  brelse(buf);
    8000306a:	95eff0ef          	jal	800021c8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000306e:	4505                	li	a0,1
    80003070:	ef3ff0ef          	jal	80002f62 <install_trans>
  log.lh.n = 0;
    80003074:	0001c797          	auipc	a5,0x1c
    80003078:	4407a423          	sw	zero,1096(a5) # 8001f4bc <log+0x2c>
  write_head(); // clear the log
    8000307c:	e89ff0ef          	jal	80002f04 <write_head>
}
    80003080:	70a2                	ld	ra,40(sp)
    80003082:	7402                	ld	s0,32(sp)
    80003084:	64e2                	ld	s1,24(sp)
    80003086:	6942                	ld	s2,16(sp)
    80003088:	69a2                	ld	s3,8(sp)
    8000308a:	6145                	addi	sp,sp,48
    8000308c:	8082                	ret

000000008000308e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000308e:	1101                	addi	sp,sp,-32
    80003090:	ec06                	sd	ra,24(sp)
    80003092:	e822                	sd	s0,16(sp)
    80003094:	e426                	sd	s1,8(sp)
    80003096:	e04a                	sd	s2,0(sp)
    80003098:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000309a:	0001c517          	auipc	a0,0x1c
    8000309e:	3f650513          	addi	a0,a0,1014 # 8001f490 <log>
    800030a2:	02f020ef          	jal	800058d0 <acquire>
  while(1){
    if(log.committing){
    800030a6:	0001c497          	auipc	s1,0x1c
    800030aa:	3ea48493          	addi	s1,s1,1002 # 8001f490 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800030ae:	4979                	li	s2,30
    800030b0:	a029                	j	800030ba <begin_op+0x2c>
      sleep(&log, &log.lock);
    800030b2:	85a6                	mv	a1,s1
    800030b4:	8526                	mv	a0,s1
    800030b6:	a8afe0ef          	jal	80001340 <sleep>
    if(log.committing){
    800030ba:	50dc                	lw	a5,36(s1)
    800030bc:	fbfd                	bnez	a5,800030b2 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800030be:	5098                	lw	a4,32(s1)
    800030c0:	2705                	addiw	a4,a4,1
    800030c2:	0027179b          	slliw	a5,a4,0x2
    800030c6:	9fb9                	addw	a5,a5,a4
    800030c8:	0017979b          	slliw	a5,a5,0x1
    800030cc:	54d4                	lw	a3,44(s1)
    800030ce:	9fb5                	addw	a5,a5,a3
    800030d0:	00f95763          	bge	s2,a5,800030de <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800030d4:	85a6                	mv	a1,s1
    800030d6:	8526                	mv	a0,s1
    800030d8:	a68fe0ef          	jal	80001340 <sleep>
    800030dc:	bff9                	j	800030ba <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800030de:	0001c517          	auipc	a0,0x1c
    800030e2:	3b250513          	addi	a0,a0,946 # 8001f490 <log>
    800030e6:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800030e8:	081020ef          	jal	80005968 <release>
      break;
    }
  }
}
    800030ec:	60e2                	ld	ra,24(sp)
    800030ee:	6442                	ld	s0,16(sp)
    800030f0:	64a2                	ld	s1,8(sp)
    800030f2:	6902                	ld	s2,0(sp)
    800030f4:	6105                	addi	sp,sp,32
    800030f6:	8082                	ret

00000000800030f8 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800030f8:	7139                	addi	sp,sp,-64
    800030fa:	fc06                	sd	ra,56(sp)
    800030fc:	f822                	sd	s0,48(sp)
    800030fe:	f426                	sd	s1,40(sp)
    80003100:	f04a                	sd	s2,32(sp)
    80003102:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003104:	0001c497          	auipc	s1,0x1c
    80003108:	38c48493          	addi	s1,s1,908 # 8001f490 <log>
    8000310c:	8526                	mv	a0,s1
    8000310e:	7c2020ef          	jal	800058d0 <acquire>
  log.outstanding -= 1;
    80003112:	509c                	lw	a5,32(s1)
    80003114:	37fd                	addiw	a5,a5,-1
    80003116:	0007891b          	sext.w	s2,a5
    8000311a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000311c:	50dc                	lw	a5,36(s1)
    8000311e:	ef9d                	bnez	a5,8000315c <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003120:	04091763          	bnez	s2,8000316e <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003124:	0001c497          	auipc	s1,0x1c
    80003128:	36c48493          	addi	s1,s1,876 # 8001f490 <log>
    8000312c:	4785                	li	a5,1
    8000312e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003130:	8526                	mv	a0,s1
    80003132:	037020ef          	jal	80005968 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003136:	54dc                	lw	a5,44(s1)
    80003138:	04f04b63          	bgtz	a5,8000318e <end_op+0x96>
    acquire(&log.lock);
    8000313c:	0001c497          	auipc	s1,0x1c
    80003140:	35448493          	addi	s1,s1,852 # 8001f490 <log>
    80003144:	8526                	mv	a0,s1
    80003146:	78a020ef          	jal	800058d0 <acquire>
    log.committing = 0;
    8000314a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000314e:	8526                	mv	a0,s1
    80003150:	a3cfe0ef          	jal	8000138c <wakeup>
    release(&log.lock);
    80003154:	8526                	mv	a0,s1
    80003156:	013020ef          	jal	80005968 <release>
}
    8000315a:	a025                	j	80003182 <end_op+0x8a>
    8000315c:	ec4e                	sd	s3,24(sp)
    8000315e:	e852                	sd	s4,16(sp)
    80003160:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003162:	00004517          	auipc	a0,0x4
    80003166:	4ae50513          	addi	a0,a0,1198 # 80007610 <etext+0x610>
    8000316a:	438020ef          	jal	800055a2 <panic>
    wakeup(&log);
    8000316e:	0001c497          	auipc	s1,0x1c
    80003172:	32248493          	addi	s1,s1,802 # 8001f490 <log>
    80003176:	8526                	mv	a0,s1
    80003178:	a14fe0ef          	jal	8000138c <wakeup>
  release(&log.lock);
    8000317c:	8526                	mv	a0,s1
    8000317e:	7ea020ef          	jal	80005968 <release>
}
    80003182:	70e2                	ld	ra,56(sp)
    80003184:	7442                	ld	s0,48(sp)
    80003186:	74a2                	ld	s1,40(sp)
    80003188:	7902                	ld	s2,32(sp)
    8000318a:	6121                	addi	sp,sp,64
    8000318c:	8082                	ret
    8000318e:	ec4e                	sd	s3,24(sp)
    80003190:	e852                	sd	s4,16(sp)
    80003192:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003194:	0001ca97          	auipc	s5,0x1c
    80003198:	32ca8a93          	addi	s5,s5,812 # 8001f4c0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000319c:	0001ca17          	auipc	s4,0x1c
    800031a0:	2f4a0a13          	addi	s4,s4,756 # 8001f490 <log>
    800031a4:	018a2583          	lw	a1,24(s4)
    800031a8:	012585bb          	addw	a1,a1,s2
    800031ac:	2585                	addiw	a1,a1,1
    800031ae:	028a2503          	lw	a0,40(s4)
    800031b2:	f0ffe0ef          	jal	800020c0 <bread>
    800031b6:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800031b8:	000aa583          	lw	a1,0(s5)
    800031bc:	028a2503          	lw	a0,40(s4)
    800031c0:	f01fe0ef          	jal	800020c0 <bread>
    800031c4:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800031c6:	40000613          	li	a2,1024
    800031ca:	05850593          	addi	a1,a0,88
    800031ce:	05848513          	addi	a0,s1,88
    800031d2:	fd9fc0ef          	jal	800001aa <memmove>
    bwrite(to);  // write the log
    800031d6:	8526                	mv	a0,s1
    800031d8:	fbffe0ef          	jal	80002196 <bwrite>
    brelse(from);
    800031dc:	854e                	mv	a0,s3
    800031de:	febfe0ef          	jal	800021c8 <brelse>
    brelse(to);
    800031e2:	8526                	mv	a0,s1
    800031e4:	fe5fe0ef          	jal	800021c8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800031e8:	2905                	addiw	s2,s2,1
    800031ea:	0a91                	addi	s5,s5,4
    800031ec:	02ca2783          	lw	a5,44(s4)
    800031f0:	faf94ae3          	blt	s2,a5,800031a4 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800031f4:	d11ff0ef          	jal	80002f04 <write_head>
    install_trans(0); // Now install writes to home locations
    800031f8:	4501                	li	a0,0
    800031fa:	d69ff0ef          	jal	80002f62 <install_trans>
    log.lh.n = 0;
    800031fe:	0001c797          	auipc	a5,0x1c
    80003202:	2a07af23          	sw	zero,702(a5) # 8001f4bc <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003206:	cffff0ef          	jal	80002f04 <write_head>
    8000320a:	69e2                	ld	s3,24(sp)
    8000320c:	6a42                	ld	s4,16(sp)
    8000320e:	6aa2                	ld	s5,8(sp)
    80003210:	b735                	j	8000313c <end_op+0x44>

0000000080003212 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003212:	1101                	addi	sp,sp,-32
    80003214:	ec06                	sd	ra,24(sp)
    80003216:	e822                	sd	s0,16(sp)
    80003218:	e426                	sd	s1,8(sp)
    8000321a:	e04a                	sd	s2,0(sp)
    8000321c:	1000                	addi	s0,sp,32
    8000321e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003220:	0001c917          	auipc	s2,0x1c
    80003224:	27090913          	addi	s2,s2,624 # 8001f490 <log>
    80003228:	854a                	mv	a0,s2
    8000322a:	6a6020ef          	jal	800058d0 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000322e:	02c92603          	lw	a2,44(s2)
    80003232:	47f5                	li	a5,29
    80003234:	06c7c363          	blt	a5,a2,8000329a <log_write+0x88>
    80003238:	0001c797          	auipc	a5,0x1c
    8000323c:	2747a783          	lw	a5,628(a5) # 8001f4ac <log+0x1c>
    80003240:	37fd                	addiw	a5,a5,-1
    80003242:	04f65c63          	bge	a2,a5,8000329a <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003246:	0001c797          	auipc	a5,0x1c
    8000324a:	26a7a783          	lw	a5,618(a5) # 8001f4b0 <log+0x20>
    8000324e:	04f05c63          	blez	a5,800032a6 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003252:	4781                	li	a5,0
    80003254:	04c05f63          	blez	a2,800032b2 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003258:	44cc                	lw	a1,12(s1)
    8000325a:	0001c717          	auipc	a4,0x1c
    8000325e:	26670713          	addi	a4,a4,614 # 8001f4c0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003262:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003264:	4314                	lw	a3,0(a4)
    80003266:	04b68663          	beq	a3,a1,800032b2 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    8000326a:	2785                	addiw	a5,a5,1
    8000326c:	0711                	addi	a4,a4,4
    8000326e:	fef61be3          	bne	a2,a5,80003264 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003272:	0621                	addi	a2,a2,8
    80003274:	060a                	slli	a2,a2,0x2
    80003276:	0001c797          	auipc	a5,0x1c
    8000327a:	21a78793          	addi	a5,a5,538 # 8001f490 <log>
    8000327e:	97b2                	add	a5,a5,a2
    80003280:	44d8                	lw	a4,12(s1)
    80003282:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003284:	8526                	mv	a0,s1
    80003286:	fcbfe0ef          	jal	80002250 <bpin>
    log.lh.n++;
    8000328a:	0001c717          	auipc	a4,0x1c
    8000328e:	20670713          	addi	a4,a4,518 # 8001f490 <log>
    80003292:	575c                	lw	a5,44(a4)
    80003294:	2785                	addiw	a5,a5,1
    80003296:	d75c                	sw	a5,44(a4)
    80003298:	a80d                	j	800032ca <log_write+0xb8>
    panic("too big a transaction");
    8000329a:	00004517          	auipc	a0,0x4
    8000329e:	38650513          	addi	a0,a0,902 # 80007620 <etext+0x620>
    800032a2:	300020ef          	jal	800055a2 <panic>
    panic("log_write outside of trans");
    800032a6:	00004517          	auipc	a0,0x4
    800032aa:	39250513          	addi	a0,a0,914 # 80007638 <etext+0x638>
    800032ae:	2f4020ef          	jal	800055a2 <panic>
  log.lh.block[i] = b->blockno;
    800032b2:	00878693          	addi	a3,a5,8
    800032b6:	068a                	slli	a3,a3,0x2
    800032b8:	0001c717          	auipc	a4,0x1c
    800032bc:	1d870713          	addi	a4,a4,472 # 8001f490 <log>
    800032c0:	9736                	add	a4,a4,a3
    800032c2:	44d4                	lw	a3,12(s1)
    800032c4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800032c6:	faf60fe3          	beq	a2,a5,80003284 <log_write+0x72>
  }
  release(&log.lock);
    800032ca:	0001c517          	auipc	a0,0x1c
    800032ce:	1c650513          	addi	a0,a0,454 # 8001f490 <log>
    800032d2:	696020ef          	jal	80005968 <release>
}
    800032d6:	60e2                	ld	ra,24(sp)
    800032d8:	6442                	ld	s0,16(sp)
    800032da:	64a2                	ld	s1,8(sp)
    800032dc:	6902                	ld	s2,0(sp)
    800032de:	6105                	addi	sp,sp,32
    800032e0:	8082                	ret

00000000800032e2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800032e2:	1101                	addi	sp,sp,-32
    800032e4:	ec06                	sd	ra,24(sp)
    800032e6:	e822                	sd	s0,16(sp)
    800032e8:	e426                	sd	s1,8(sp)
    800032ea:	e04a                	sd	s2,0(sp)
    800032ec:	1000                	addi	s0,sp,32
    800032ee:	84aa                	mv	s1,a0
    800032f0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800032f2:	00004597          	auipc	a1,0x4
    800032f6:	36658593          	addi	a1,a1,870 # 80007658 <etext+0x658>
    800032fa:	0521                	addi	a0,a0,8
    800032fc:	554020ef          	jal	80005850 <initlock>
  lk->name = name;
    80003300:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003304:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003308:	0204a423          	sw	zero,40(s1)
}
    8000330c:	60e2                	ld	ra,24(sp)
    8000330e:	6442                	ld	s0,16(sp)
    80003310:	64a2                	ld	s1,8(sp)
    80003312:	6902                	ld	s2,0(sp)
    80003314:	6105                	addi	sp,sp,32
    80003316:	8082                	ret

0000000080003318 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003318:	1101                	addi	sp,sp,-32
    8000331a:	ec06                	sd	ra,24(sp)
    8000331c:	e822                	sd	s0,16(sp)
    8000331e:	e426                	sd	s1,8(sp)
    80003320:	e04a                	sd	s2,0(sp)
    80003322:	1000                	addi	s0,sp,32
    80003324:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003326:	00850913          	addi	s2,a0,8
    8000332a:	854a                	mv	a0,s2
    8000332c:	5a4020ef          	jal	800058d0 <acquire>
  while (lk->locked) {
    80003330:	409c                	lw	a5,0(s1)
    80003332:	c799                	beqz	a5,80003340 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003334:	85ca                	mv	a1,s2
    80003336:	8526                	mv	a0,s1
    80003338:	808fe0ef          	jal	80001340 <sleep>
  while (lk->locked) {
    8000333c:	409c                	lw	a5,0(s1)
    8000333e:	fbfd                	bnez	a5,80003334 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003340:	4785                	li	a5,1
    80003342:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003344:	a17fd0ef          	jal	80000d5a <myproc>
    80003348:	591c                	lw	a5,48(a0)
    8000334a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000334c:	854a                	mv	a0,s2
    8000334e:	61a020ef          	jal	80005968 <release>
}
    80003352:	60e2                	ld	ra,24(sp)
    80003354:	6442                	ld	s0,16(sp)
    80003356:	64a2                	ld	s1,8(sp)
    80003358:	6902                	ld	s2,0(sp)
    8000335a:	6105                	addi	sp,sp,32
    8000335c:	8082                	ret

000000008000335e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000335e:	1101                	addi	sp,sp,-32
    80003360:	ec06                	sd	ra,24(sp)
    80003362:	e822                	sd	s0,16(sp)
    80003364:	e426                	sd	s1,8(sp)
    80003366:	e04a                	sd	s2,0(sp)
    80003368:	1000                	addi	s0,sp,32
    8000336a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000336c:	00850913          	addi	s2,a0,8
    80003370:	854a                	mv	a0,s2
    80003372:	55e020ef          	jal	800058d0 <acquire>
  lk->locked = 0;
    80003376:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000337a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000337e:	8526                	mv	a0,s1
    80003380:	80cfe0ef          	jal	8000138c <wakeup>
  release(&lk->lk);
    80003384:	854a                	mv	a0,s2
    80003386:	5e2020ef          	jal	80005968 <release>
}
    8000338a:	60e2                	ld	ra,24(sp)
    8000338c:	6442                	ld	s0,16(sp)
    8000338e:	64a2                	ld	s1,8(sp)
    80003390:	6902                	ld	s2,0(sp)
    80003392:	6105                	addi	sp,sp,32
    80003394:	8082                	ret

0000000080003396 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003396:	7179                	addi	sp,sp,-48
    80003398:	f406                	sd	ra,40(sp)
    8000339a:	f022                	sd	s0,32(sp)
    8000339c:	ec26                	sd	s1,24(sp)
    8000339e:	e84a                	sd	s2,16(sp)
    800033a0:	1800                	addi	s0,sp,48
    800033a2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800033a4:	00850913          	addi	s2,a0,8
    800033a8:	854a                	mv	a0,s2
    800033aa:	526020ef          	jal	800058d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800033ae:	409c                	lw	a5,0(s1)
    800033b0:	ef81                	bnez	a5,800033c8 <holdingsleep+0x32>
    800033b2:	4481                	li	s1,0
  release(&lk->lk);
    800033b4:	854a                	mv	a0,s2
    800033b6:	5b2020ef          	jal	80005968 <release>
  return r;
}
    800033ba:	8526                	mv	a0,s1
    800033bc:	70a2                	ld	ra,40(sp)
    800033be:	7402                	ld	s0,32(sp)
    800033c0:	64e2                	ld	s1,24(sp)
    800033c2:	6942                	ld	s2,16(sp)
    800033c4:	6145                	addi	sp,sp,48
    800033c6:	8082                	ret
    800033c8:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800033ca:	0284a983          	lw	s3,40(s1)
    800033ce:	98dfd0ef          	jal	80000d5a <myproc>
    800033d2:	5904                	lw	s1,48(a0)
    800033d4:	413484b3          	sub	s1,s1,s3
    800033d8:	0014b493          	seqz	s1,s1
    800033dc:	69a2                	ld	s3,8(sp)
    800033de:	bfd9                	j	800033b4 <holdingsleep+0x1e>

00000000800033e0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800033e0:	1141                	addi	sp,sp,-16
    800033e2:	e406                	sd	ra,8(sp)
    800033e4:	e022                	sd	s0,0(sp)
    800033e6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800033e8:	00004597          	auipc	a1,0x4
    800033ec:	28058593          	addi	a1,a1,640 # 80007668 <etext+0x668>
    800033f0:	0001c517          	auipc	a0,0x1c
    800033f4:	1e850513          	addi	a0,a0,488 # 8001f5d8 <ftable>
    800033f8:	458020ef          	jal	80005850 <initlock>
}
    800033fc:	60a2                	ld	ra,8(sp)
    800033fe:	6402                	ld	s0,0(sp)
    80003400:	0141                	addi	sp,sp,16
    80003402:	8082                	ret

0000000080003404 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003404:	1101                	addi	sp,sp,-32
    80003406:	ec06                	sd	ra,24(sp)
    80003408:	e822                	sd	s0,16(sp)
    8000340a:	e426                	sd	s1,8(sp)
    8000340c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000340e:	0001c517          	auipc	a0,0x1c
    80003412:	1ca50513          	addi	a0,a0,458 # 8001f5d8 <ftable>
    80003416:	4ba020ef          	jal	800058d0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000341a:	0001c497          	auipc	s1,0x1c
    8000341e:	1d648493          	addi	s1,s1,470 # 8001f5f0 <ftable+0x18>
    80003422:	0001d717          	auipc	a4,0x1d
    80003426:	16e70713          	addi	a4,a4,366 # 80020590 <disk>
    if(f->ref == 0){
    8000342a:	40dc                	lw	a5,4(s1)
    8000342c:	cf89                	beqz	a5,80003446 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000342e:	02848493          	addi	s1,s1,40
    80003432:	fee49ce3          	bne	s1,a4,8000342a <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003436:	0001c517          	auipc	a0,0x1c
    8000343a:	1a250513          	addi	a0,a0,418 # 8001f5d8 <ftable>
    8000343e:	52a020ef          	jal	80005968 <release>
  return 0;
    80003442:	4481                	li	s1,0
    80003444:	a809                	j	80003456 <filealloc+0x52>
      f->ref = 1;
    80003446:	4785                	li	a5,1
    80003448:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000344a:	0001c517          	auipc	a0,0x1c
    8000344e:	18e50513          	addi	a0,a0,398 # 8001f5d8 <ftable>
    80003452:	516020ef          	jal	80005968 <release>
}
    80003456:	8526                	mv	a0,s1
    80003458:	60e2                	ld	ra,24(sp)
    8000345a:	6442                	ld	s0,16(sp)
    8000345c:	64a2                	ld	s1,8(sp)
    8000345e:	6105                	addi	sp,sp,32
    80003460:	8082                	ret

0000000080003462 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003462:	1101                	addi	sp,sp,-32
    80003464:	ec06                	sd	ra,24(sp)
    80003466:	e822                	sd	s0,16(sp)
    80003468:	e426                	sd	s1,8(sp)
    8000346a:	1000                	addi	s0,sp,32
    8000346c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000346e:	0001c517          	auipc	a0,0x1c
    80003472:	16a50513          	addi	a0,a0,362 # 8001f5d8 <ftable>
    80003476:	45a020ef          	jal	800058d0 <acquire>
  if(f->ref < 1)
    8000347a:	40dc                	lw	a5,4(s1)
    8000347c:	02f05063          	blez	a5,8000349c <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003480:	2785                	addiw	a5,a5,1
    80003482:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003484:	0001c517          	auipc	a0,0x1c
    80003488:	15450513          	addi	a0,a0,340 # 8001f5d8 <ftable>
    8000348c:	4dc020ef          	jal	80005968 <release>
  return f;
}
    80003490:	8526                	mv	a0,s1
    80003492:	60e2                	ld	ra,24(sp)
    80003494:	6442                	ld	s0,16(sp)
    80003496:	64a2                	ld	s1,8(sp)
    80003498:	6105                	addi	sp,sp,32
    8000349a:	8082                	ret
    panic("filedup");
    8000349c:	00004517          	auipc	a0,0x4
    800034a0:	1d450513          	addi	a0,a0,468 # 80007670 <etext+0x670>
    800034a4:	0fe020ef          	jal	800055a2 <panic>

00000000800034a8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800034a8:	7139                	addi	sp,sp,-64
    800034aa:	fc06                	sd	ra,56(sp)
    800034ac:	f822                	sd	s0,48(sp)
    800034ae:	f426                	sd	s1,40(sp)
    800034b0:	0080                	addi	s0,sp,64
    800034b2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800034b4:	0001c517          	auipc	a0,0x1c
    800034b8:	12450513          	addi	a0,a0,292 # 8001f5d8 <ftable>
    800034bc:	414020ef          	jal	800058d0 <acquire>
  if(f->ref < 1)
    800034c0:	40dc                	lw	a5,4(s1)
    800034c2:	04f05a63          	blez	a5,80003516 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800034c6:	37fd                	addiw	a5,a5,-1
    800034c8:	0007871b          	sext.w	a4,a5
    800034cc:	c0dc                	sw	a5,4(s1)
    800034ce:	04e04e63          	bgtz	a4,8000352a <fileclose+0x82>
    800034d2:	f04a                	sd	s2,32(sp)
    800034d4:	ec4e                	sd	s3,24(sp)
    800034d6:	e852                	sd	s4,16(sp)
    800034d8:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800034da:	0004a903          	lw	s2,0(s1)
    800034de:	0094ca83          	lbu	s5,9(s1)
    800034e2:	0104ba03          	ld	s4,16(s1)
    800034e6:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800034ea:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800034ee:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800034f2:	0001c517          	auipc	a0,0x1c
    800034f6:	0e650513          	addi	a0,a0,230 # 8001f5d8 <ftable>
    800034fa:	46e020ef          	jal	80005968 <release>

  if(ff.type == FD_PIPE){
    800034fe:	4785                	li	a5,1
    80003500:	04f90063          	beq	s2,a5,80003540 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003504:	3979                	addiw	s2,s2,-2
    80003506:	4785                	li	a5,1
    80003508:	0527f563          	bgeu	a5,s2,80003552 <fileclose+0xaa>
    8000350c:	7902                	ld	s2,32(sp)
    8000350e:	69e2                	ld	s3,24(sp)
    80003510:	6a42                	ld	s4,16(sp)
    80003512:	6aa2                	ld	s5,8(sp)
    80003514:	a00d                	j	80003536 <fileclose+0x8e>
    80003516:	f04a                	sd	s2,32(sp)
    80003518:	ec4e                	sd	s3,24(sp)
    8000351a:	e852                	sd	s4,16(sp)
    8000351c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000351e:	00004517          	auipc	a0,0x4
    80003522:	15a50513          	addi	a0,a0,346 # 80007678 <etext+0x678>
    80003526:	07c020ef          	jal	800055a2 <panic>
    release(&ftable.lock);
    8000352a:	0001c517          	auipc	a0,0x1c
    8000352e:	0ae50513          	addi	a0,a0,174 # 8001f5d8 <ftable>
    80003532:	436020ef          	jal	80005968 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003536:	70e2                	ld	ra,56(sp)
    80003538:	7442                	ld	s0,48(sp)
    8000353a:	74a2                	ld	s1,40(sp)
    8000353c:	6121                	addi	sp,sp,64
    8000353e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003540:	85d6                	mv	a1,s5
    80003542:	8552                	mv	a0,s4
    80003544:	336000ef          	jal	8000387a <pipeclose>
    80003548:	7902                	ld	s2,32(sp)
    8000354a:	69e2                	ld	s3,24(sp)
    8000354c:	6a42                	ld	s4,16(sp)
    8000354e:	6aa2                	ld	s5,8(sp)
    80003550:	b7dd                	j	80003536 <fileclose+0x8e>
    begin_op();
    80003552:	b3dff0ef          	jal	8000308e <begin_op>
    iput(ff.ip);
    80003556:	854e                	mv	a0,s3
    80003558:	c22ff0ef          	jal	8000297a <iput>
    end_op();
    8000355c:	b9dff0ef          	jal	800030f8 <end_op>
    80003560:	7902                	ld	s2,32(sp)
    80003562:	69e2                	ld	s3,24(sp)
    80003564:	6a42                	ld	s4,16(sp)
    80003566:	6aa2                	ld	s5,8(sp)
    80003568:	b7f9                	j	80003536 <fileclose+0x8e>

000000008000356a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000356a:	715d                	addi	sp,sp,-80
    8000356c:	e486                	sd	ra,72(sp)
    8000356e:	e0a2                	sd	s0,64(sp)
    80003570:	fc26                	sd	s1,56(sp)
    80003572:	f44e                	sd	s3,40(sp)
    80003574:	0880                	addi	s0,sp,80
    80003576:	84aa                	mv	s1,a0
    80003578:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000357a:	fe0fd0ef          	jal	80000d5a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000357e:	409c                	lw	a5,0(s1)
    80003580:	37f9                	addiw	a5,a5,-2
    80003582:	4705                	li	a4,1
    80003584:	04f76063          	bltu	a4,a5,800035c4 <filestat+0x5a>
    80003588:	f84a                	sd	s2,48(sp)
    8000358a:	892a                	mv	s2,a0
    ilock(f->ip);
    8000358c:	6c88                	ld	a0,24(s1)
    8000358e:	a6aff0ef          	jal	800027f8 <ilock>
    stati(f->ip, &st);
    80003592:	fb840593          	addi	a1,s0,-72
    80003596:	6c88                	ld	a0,24(s1)
    80003598:	c8aff0ef          	jal	80002a22 <stati>
    iunlock(f->ip);
    8000359c:	6c88                	ld	a0,24(s1)
    8000359e:	b08ff0ef          	jal	800028a6 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800035a2:	46e1                	li	a3,24
    800035a4:	fb840613          	addi	a2,s0,-72
    800035a8:	85ce                	mv	a1,s3
    800035aa:	05093503          	ld	a0,80(s2)
    800035ae:	c2afd0ef          	jal	800009d8 <copyout>
    800035b2:	41f5551b          	sraiw	a0,a0,0x1f
    800035b6:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800035b8:	60a6                	ld	ra,72(sp)
    800035ba:	6406                	ld	s0,64(sp)
    800035bc:	74e2                	ld	s1,56(sp)
    800035be:	79a2                	ld	s3,40(sp)
    800035c0:	6161                	addi	sp,sp,80
    800035c2:	8082                	ret
  return -1;
    800035c4:	557d                	li	a0,-1
    800035c6:	bfcd                	j	800035b8 <filestat+0x4e>

00000000800035c8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800035c8:	7179                	addi	sp,sp,-48
    800035ca:	f406                	sd	ra,40(sp)
    800035cc:	f022                	sd	s0,32(sp)
    800035ce:	e84a                	sd	s2,16(sp)
    800035d0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800035d2:	00854783          	lbu	a5,8(a0)
    800035d6:	cfd1                	beqz	a5,80003672 <fileread+0xaa>
    800035d8:	ec26                	sd	s1,24(sp)
    800035da:	e44e                	sd	s3,8(sp)
    800035dc:	84aa                	mv	s1,a0
    800035de:	89ae                	mv	s3,a1
    800035e0:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800035e2:	411c                	lw	a5,0(a0)
    800035e4:	4705                	li	a4,1
    800035e6:	04e78363          	beq	a5,a4,8000362c <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800035ea:	470d                	li	a4,3
    800035ec:	04e78763          	beq	a5,a4,8000363a <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800035f0:	4709                	li	a4,2
    800035f2:	06e79a63          	bne	a5,a4,80003666 <fileread+0x9e>
    ilock(f->ip);
    800035f6:	6d08                	ld	a0,24(a0)
    800035f8:	a00ff0ef          	jal	800027f8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800035fc:	874a                	mv	a4,s2
    800035fe:	5094                	lw	a3,32(s1)
    80003600:	864e                	mv	a2,s3
    80003602:	4585                	li	a1,1
    80003604:	6c88                	ld	a0,24(s1)
    80003606:	c46ff0ef          	jal	80002a4c <readi>
    8000360a:	892a                	mv	s2,a0
    8000360c:	00a05563          	blez	a0,80003616 <fileread+0x4e>
      f->off += r;
    80003610:	509c                	lw	a5,32(s1)
    80003612:	9fa9                	addw	a5,a5,a0
    80003614:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003616:	6c88                	ld	a0,24(s1)
    80003618:	a8eff0ef          	jal	800028a6 <iunlock>
    8000361c:	64e2                	ld	s1,24(sp)
    8000361e:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003620:	854a                	mv	a0,s2
    80003622:	70a2                	ld	ra,40(sp)
    80003624:	7402                	ld	s0,32(sp)
    80003626:	6942                	ld	s2,16(sp)
    80003628:	6145                	addi	sp,sp,48
    8000362a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000362c:	6908                	ld	a0,16(a0)
    8000362e:	388000ef          	jal	800039b6 <piperead>
    80003632:	892a                	mv	s2,a0
    80003634:	64e2                	ld	s1,24(sp)
    80003636:	69a2                	ld	s3,8(sp)
    80003638:	b7e5                	j	80003620 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000363a:	02451783          	lh	a5,36(a0)
    8000363e:	03079693          	slli	a3,a5,0x30
    80003642:	92c1                	srli	a3,a3,0x30
    80003644:	4725                	li	a4,9
    80003646:	02d76863          	bltu	a4,a3,80003676 <fileread+0xae>
    8000364a:	0792                	slli	a5,a5,0x4
    8000364c:	0001c717          	auipc	a4,0x1c
    80003650:	eec70713          	addi	a4,a4,-276 # 8001f538 <devsw>
    80003654:	97ba                	add	a5,a5,a4
    80003656:	639c                	ld	a5,0(a5)
    80003658:	c39d                	beqz	a5,8000367e <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    8000365a:	4505                	li	a0,1
    8000365c:	9782                	jalr	a5
    8000365e:	892a                	mv	s2,a0
    80003660:	64e2                	ld	s1,24(sp)
    80003662:	69a2                	ld	s3,8(sp)
    80003664:	bf75                	j	80003620 <fileread+0x58>
    panic("fileread");
    80003666:	00004517          	auipc	a0,0x4
    8000366a:	02250513          	addi	a0,a0,34 # 80007688 <etext+0x688>
    8000366e:	735010ef          	jal	800055a2 <panic>
    return -1;
    80003672:	597d                	li	s2,-1
    80003674:	b775                	j	80003620 <fileread+0x58>
      return -1;
    80003676:	597d                	li	s2,-1
    80003678:	64e2                	ld	s1,24(sp)
    8000367a:	69a2                	ld	s3,8(sp)
    8000367c:	b755                	j	80003620 <fileread+0x58>
    8000367e:	597d                	li	s2,-1
    80003680:	64e2                	ld	s1,24(sp)
    80003682:	69a2                	ld	s3,8(sp)
    80003684:	bf71                	j	80003620 <fileread+0x58>

0000000080003686 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003686:	00954783          	lbu	a5,9(a0)
    8000368a:	10078b63          	beqz	a5,800037a0 <filewrite+0x11a>
{
    8000368e:	715d                	addi	sp,sp,-80
    80003690:	e486                	sd	ra,72(sp)
    80003692:	e0a2                	sd	s0,64(sp)
    80003694:	f84a                	sd	s2,48(sp)
    80003696:	f052                	sd	s4,32(sp)
    80003698:	e85a                	sd	s6,16(sp)
    8000369a:	0880                	addi	s0,sp,80
    8000369c:	892a                	mv	s2,a0
    8000369e:	8b2e                	mv	s6,a1
    800036a0:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800036a2:	411c                	lw	a5,0(a0)
    800036a4:	4705                	li	a4,1
    800036a6:	02e78763          	beq	a5,a4,800036d4 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800036aa:	470d                	li	a4,3
    800036ac:	02e78863          	beq	a5,a4,800036dc <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800036b0:	4709                	li	a4,2
    800036b2:	0ce79c63          	bne	a5,a4,8000378a <filewrite+0x104>
    800036b6:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800036b8:	0ac05863          	blez	a2,80003768 <filewrite+0xe2>
    800036bc:	fc26                	sd	s1,56(sp)
    800036be:	ec56                	sd	s5,24(sp)
    800036c0:	e45e                	sd	s7,8(sp)
    800036c2:	e062                	sd	s8,0(sp)
    int i = 0;
    800036c4:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800036c6:	6b85                	lui	s7,0x1
    800036c8:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800036cc:	6c05                	lui	s8,0x1
    800036ce:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800036d2:	a8b5                	j	8000374e <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800036d4:	6908                	ld	a0,16(a0)
    800036d6:	1fc000ef          	jal	800038d2 <pipewrite>
    800036da:	a04d                	j	8000377c <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800036dc:	02451783          	lh	a5,36(a0)
    800036e0:	03079693          	slli	a3,a5,0x30
    800036e4:	92c1                	srli	a3,a3,0x30
    800036e6:	4725                	li	a4,9
    800036e8:	0ad76e63          	bltu	a4,a3,800037a4 <filewrite+0x11e>
    800036ec:	0792                	slli	a5,a5,0x4
    800036ee:	0001c717          	auipc	a4,0x1c
    800036f2:	e4a70713          	addi	a4,a4,-438 # 8001f538 <devsw>
    800036f6:	97ba                	add	a5,a5,a4
    800036f8:	679c                	ld	a5,8(a5)
    800036fa:	c7dd                	beqz	a5,800037a8 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800036fc:	4505                	li	a0,1
    800036fe:	9782                	jalr	a5
    80003700:	a8b5                	j	8000377c <filewrite+0xf6>
      if(n1 > max)
    80003702:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003706:	989ff0ef          	jal	8000308e <begin_op>
      ilock(f->ip);
    8000370a:	01893503          	ld	a0,24(s2)
    8000370e:	8eaff0ef          	jal	800027f8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003712:	8756                	mv	a4,s5
    80003714:	02092683          	lw	a3,32(s2)
    80003718:	01698633          	add	a2,s3,s6
    8000371c:	4585                	li	a1,1
    8000371e:	01893503          	ld	a0,24(s2)
    80003722:	c26ff0ef          	jal	80002b48 <writei>
    80003726:	84aa                	mv	s1,a0
    80003728:	00a05763          	blez	a0,80003736 <filewrite+0xb0>
        f->off += r;
    8000372c:	02092783          	lw	a5,32(s2)
    80003730:	9fa9                	addw	a5,a5,a0
    80003732:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003736:	01893503          	ld	a0,24(s2)
    8000373a:	96cff0ef          	jal	800028a6 <iunlock>
      end_op();
    8000373e:	9bbff0ef          	jal	800030f8 <end_op>

      if(r != n1){
    80003742:	029a9563          	bne	s5,s1,8000376c <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80003746:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000374a:	0149da63          	bge	s3,s4,8000375e <filewrite+0xd8>
      int n1 = n - i;
    8000374e:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003752:	0004879b          	sext.w	a5,s1
    80003756:	fafbd6e3          	bge	s7,a5,80003702 <filewrite+0x7c>
    8000375a:	84e2                	mv	s1,s8
    8000375c:	b75d                	j	80003702 <filewrite+0x7c>
    8000375e:	74e2                	ld	s1,56(sp)
    80003760:	6ae2                	ld	s5,24(sp)
    80003762:	6ba2                	ld	s7,8(sp)
    80003764:	6c02                	ld	s8,0(sp)
    80003766:	a039                	j	80003774 <filewrite+0xee>
    int i = 0;
    80003768:	4981                	li	s3,0
    8000376a:	a029                	j	80003774 <filewrite+0xee>
    8000376c:	74e2                	ld	s1,56(sp)
    8000376e:	6ae2                	ld	s5,24(sp)
    80003770:	6ba2                	ld	s7,8(sp)
    80003772:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003774:	033a1c63          	bne	s4,s3,800037ac <filewrite+0x126>
    80003778:	8552                	mv	a0,s4
    8000377a:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000377c:	60a6                	ld	ra,72(sp)
    8000377e:	6406                	ld	s0,64(sp)
    80003780:	7942                	ld	s2,48(sp)
    80003782:	7a02                	ld	s4,32(sp)
    80003784:	6b42                	ld	s6,16(sp)
    80003786:	6161                	addi	sp,sp,80
    80003788:	8082                	ret
    8000378a:	fc26                	sd	s1,56(sp)
    8000378c:	f44e                	sd	s3,40(sp)
    8000378e:	ec56                	sd	s5,24(sp)
    80003790:	e45e                	sd	s7,8(sp)
    80003792:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003794:	00004517          	auipc	a0,0x4
    80003798:	f0450513          	addi	a0,a0,-252 # 80007698 <etext+0x698>
    8000379c:	607010ef          	jal	800055a2 <panic>
    return -1;
    800037a0:	557d                	li	a0,-1
}
    800037a2:	8082                	ret
      return -1;
    800037a4:	557d                	li	a0,-1
    800037a6:	bfd9                	j	8000377c <filewrite+0xf6>
    800037a8:	557d                	li	a0,-1
    800037aa:	bfc9                	j	8000377c <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800037ac:	557d                	li	a0,-1
    800037ae:	79a2                	ld	s3,40(sp)
    800037b0:	b7f1                	j	8000377c <filewrite+0xf6>

00000000800037b2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800037b2:	7179                	addi	sp,sp,-48
    800037b4:	f406                	sd	ra,40(sp)
    800037b6:	f022                	sd	s0,32(sp)
    800037b8:	ec26                	sd	s1,24(sp)
    800037ba:	e052                	sd	s4,0(sp)
    800037bc:	1800                	addi	s0,sp,48
    800037be:	84aa                	mv	s1,a0
    800037c0:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800037c2:	0005b023          	sd	zero,0(a1)
    800037c6:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800037ca:	c3bff0ef          	jal	80003404 <filealloc>
    800037ce:	e088                	sd	a0,0(s1)
    800037d0:	c549                	beqz	a0,8000385a <pipealloc+0xa8>
    800037d2:	c33ff0ef          	jal	80003404 <filealloc>
    800037d6:	00aa3023          	sd	a0,0(s4)
    800037da:	cd25                	beqz	a0,80003852 <pipealloc+0xa0>
    800037dc:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800037de:	921fc0ef          	jal	800000fe <kalloc>
    800037e2:	892a                	mv	s2,a0
    800037e4:	c12d                	beqz	a0,80003846 <pipealloc+0x94>
    800037e6:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800037e8:	4985                	li	s3,1
    800037ea:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800037ee:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800037f2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800037f6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800037fa:	00004597          	auipc	a1,0x4
    800037fe:	c3658593          	addi	a1,a1,-970 # 80007430 <etext+0x430>
    80003802:	04e020ef          	jal	80005850 <initlock>
  (*f0)->type = FD_PIPE;
    80003806:	609c                	ld	a5,0(s1)
    80003808:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000380c:	609c                	ld	a5,0(s1)
    8000380e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003812:	609c                	ld	a5,0(s1)
    80003814:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003818:	609c                	ld	a5,0(s1)
    8000381a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000381e:	000a3783          	ld	a5,0(s4)
    80003822:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003826:	000a3783          	ld	a5,0(s4)
    8000382a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000382e:	000a3783          	ld	a5,0(s4)
    80003832:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003836:	000a3783          	ld	a5,0(s4)
    8000383a:	0127b823          	sd	s2,16(a5)
  return 0;
    8000383e:	4501                	li	a0,0
    80003840:	6942                	ld	s2,16(sp)
    80003842:	69a2                	ld	s3,8(sp)
    80003844:	a01d                	j	8000386a <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003846:	6088                	ld	a0,0(s1)
    80003848:	c119                	beqz	a0,8000384e <pipealloc+0x9c>
    8000384a:	6942                	ld	s2,16(sp)
    8000384c:	a029                	j	80003856 <pipealloc+0xa4>
    8000384e:	6942                	ld	s2,16(sp)
    80003850:	a029                	j	8000385a <pipealloc+0xa8>
    80003852:	6088                	ld	a0,0(s1)
    80003854:	c10d                	beqz	a0,80003876 <pipealloc+0xc4>
    fileclose(*f0);
    80003856:	c53ff0ef          	jal	800034a8 <fileclose>
  if(*f1)
    8000385a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000385e:	557d                	li	a0,-1
  if(*f1)
    80003860:	c789                	beqz	a5,8000386a <pipealloc+0xb8>
    fileclose(*f1);
    80003862:	853e                	mv	a0,a5
    80003864:	c45ff0ef          	jal	800034a8 <fileclose>
  return -1;
    80003868:	557d                	li	a0,-1
}
    8000386a:	70a2                	ld	ra,40(sp)
    8000386c:	7402                	ld	s0,32(sp)
    8000386e:	64e2                	ld	s1,24(sp)
    80003870:	6a02                	ld	s4,0(sp)
    80003872:	6145                	addi	sp,sp,48
    80003874:	8082                	ret
  return -1;
    80003876:	557d                	li	a0,-1
    80003878:	bfcd                	j	8000386a <pipealloc+0xb8>

000000008000387a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000387a:	1101                	addi	sp,sp,-32
    8000387c:	ec06                	sd	ra,24(sp)
    8000387e:	e822                	sd	s0,16(sp)
    80003880:	e426                	sd	s1,8(sp)
    80003882:	e04a                	sd	s2,0(sp)
    80003884:	1000                	addi	s0,sp,32
    80003886:	84aa                	mv	s1,a0
    80003888:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000388a:	046020ef          	jal	800058d0 <acquire>
  if(writable){
    8000388e:	02090763          	beqz	s2,800038bc <pipeclose+0x42>
    pi->writeopen = 0;
    80003892:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003896:	21848513          	addi	a0,s1,536
    8000389a:	af3fd0ef          	jal	8000138c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000389e:	2204b783          	ld	a5,544(s1)
    800038a2:	e785                	bnez	a5,800038ca <pipeclose+0x50>
    release(&pi->lock);
    800038a4:	8526                	mv	a0,s1
    800038a6:	0c2020ef          	jal	80005968 <release>
    kfree((char*)pi);
    800038aa:	8526                	mv	a0,s1
    800038ac:	f70fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    800038b0:	60e2                	ld	ra,24(sp)
    800038b2:	6442                	ld	s0,16(sp)
    800038b4:	64a2                	ld	s1,8(sp)
    800038b6:	6902                	ld	s2,0(sp)
    800038b8:	6105                	addi	sp,sp,32
    800038ba:	8082                	ret
    pi->readopen = 0;
    800038bc:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800038c0:	21c48513          	addi	a0,s1,540
    800038c4:	ac9fd0ef          	jal	8000138c <wakeup>
    800038c8:	bfd9                	j	8000389e <pipeclose+0x24>
    release(&pi->lock);
    800038ca:	8526                	mv	a0,s1
    800038cc:	09c020ef          	jal	80005968 <release>
}
    800038d0:	b7c5                	j	800038b0 <pipeclose+0x36>

00000000800038d2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800038d2:	711d                	addi	sp,sp,-96
    800038d4:	ec86                	sd	ra,88(sp)
    800038d6:	e8a2                	sd	s0,80(sp)
    800038d8:	e4a6                	sd	s1,72(sp)
    800038da:	e0ca                	sd	s2,64(sp)
    800038dc:	fc4e                	sd	s3,56(sp)
    800038de:	f852                	sd	s4,48(sp)
    800038e0:	f456                	sd	s5,40(sp)
    800038e2:	1080                	addi	s0,sp,96
    800038e4:	84aa                	mv	s1,a0
    800038e6:	8aae                	mv	s5,a1
    800038e8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800038ea:	c70fd0ef          	jal	80000d5a <myproc>
    800038ee:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800038f0:	8526                	mv	a0,s1
    800038f2:	7df010ef          	jal	800058d0 <acquire>
  while(i < n){
    800038f6:	0b405a63          	blez	s4,800039aa <pipewrite+0xd8>
    800038fa:	f05a                	sd	s6,32(sp)
    800038fc:	ec5e                	sd	s7,24(sp)
    800038fe:	e862                	sd	s8,16(sp)
  int i = 0;
    80003900:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003902:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003904:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003908:	21c48b93          	addi	s7,s1,540
    8000390c:	a81d                	j	80003942 <pipewrite+0x70>
      release(&pi->lock);
    8000390e:	8526                	mv	a0,s1
    80003910:	058020ef          	jal	80005968 <release>
      return -1;
    80003914:	597d                	li	s2,-1
    80003916:	7b02                	ld	s6,32(sp)
    80003918:	6be2                	ld	s7,24(sp)
    8000391a:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000391c:	854a                	mv	a0,s2
    8000391e:	60e6                	ld	ra,88(sp)
    80003920:	6446                	ld	s0,80(sp)
    80003922:	64a6                	ld	s1,72(sp)
    80003924:	6906                	ld	s2,64(sp)
    80003926:	79e2                	ld	s3,56(sp)
    80003928:	7a42                	ld	s4,48(sp)
    8000392a:	7aa2                	ld	s5,40(sp)
    8000392c:	6125                	addi	sp,sp,96
    8000392e:	8082                	ret
      wakeup(&pi->nread);
    80003930:	8562                	mv	a0,s8
    80003932:	a5bfd0ef          	jal	8000138c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003936:	85a6                	mv	a1,s1
    80003938:	855e                	mv	a0,s7
    8000393a:	a07fd0ef          	jal	80001340 <sleep>
  while(i < n){
    8000393e:	05495b63          	bge	s2,s4,80003994 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80003942:	2204a783          	lw	a5,544(s1)
    80003946:	d7e1                	beqz	a5,8000390e <pipewrite+0x3c>
    80003948:	854e                	mv	a0,s3
    8000394a:	c2ffd0ef          	jal	80001578 <killed>
    8000394e:	f161                	bnez	a0,8000390e <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003950:	2184a783          	lw	a5,536(s1)
    80003954:	21c4a703          	lw	a4,540(s1)
    80003958:	2007879b          	addiw	a5,a5,512
    8000395c:	fcf70ae3          	beq	a4,a5,80003930 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003960:	4685                	li	a3,1
    80003962:	01590633          	add	a2,s2,s5
    80003966:	faf40593          	addi	a1,s0,-81
    8000396a:	0509b503          	ld	a0,80(s3)
    8000396e:	940fd0ef          	jal	80000aae <copyin>
    80003972:	03650e63          	beq	a0,s6,800039ae <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003976:	21c4a783          	lw	a5,540(s1)
    8000397a:	0017871b          	addiw	a4,a5,1
    8000397e:	20e4ae23          	sw	a4,540(s1)
    80003982:	1ff7f793          	andi	a5,a5,511
    80003986:	97a6                	add	a5,a5,s1
    80003988:	faf44703          	lbu	a4,-81(s0)
    8000398c:	00e78c23          	sb	a4,24(a5)
      i++;
    80003990:	2905                	addiw	s2,s2,1
    80003992:	b775                	j	8000393e <pipewrite+0x6c>
    80003994:	7b02                	ld	s6,32(sp)
    80003996:	6be2                	ld	s7,24(sp)
    80003998:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000399a:	21848513          	addi	a0,s1,536
    8000399e:	9effd0ef          	jal	8000138c <wakeup>
  release(&pi->lock);
    800039a2:	8526                	mv	a0,s1
    800039a4:	7c5010ef          	jal	80005968 <release>
  return i;
    800039a8:	bf95                	j	8000391c <pipewrite+0x4a>
  int i = 0;
    800039aa:	4901                	li	s2,0
    800039ac:	b7fd                	j	8000399a <pipewrite+0xc8>
    800039ae:	7b02                	ld	s6,32(sp)
    800039b0:	6be2                	ld	s7,24(sp)
    800039b2:	6c42                	ld	s8,16(sp)
    800039b4:	b7dd                	j	8000399a <pipewrite+0xc8>

00000000800039b6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800039b6:	715d                	addi	sp,sp,-80
    800039b8:	e486                	sd	ra,72(sp)
    800039ba:	e0a2                	sd	s0,64(sp)
    800039bc:	fc26                	sd	s1,56(sp)
    800039be:	f84a                	sd	s2,48(sp)
    800039c0:	f44e                	sd	s3,40(sp)
    800039c2:	f052                	sd	s4,32(sp)
    800039c4:	ec56                	sd	s5,24(sp)
    800039c6:	0880                	addi	s0,sp,80
    800039c8:	84aa                	mv	s1,a0
    800039ca:	892e                	mv	s2,a1
    800039cc:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800039ce:	b8cfd0ef          	jal	80000d5a <myproc>
    800039d2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800039d4:	8526                	mv	a0,s1
    800039d6:	6fb010ef          	jal	800058d0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039da:	2184a703          	lw	a4,536(s1)
    800039de:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800039e2:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039e6:	02f71563          	bne	a4,a5,80003a10 <piperead+0x5a>
    800039ea:	2244a783          	lw	a5,548(s1)
    800039ee:	cb85                	beqz	a5,80003a1e <piperead+0x68>
    if(killed(pr)){
    800039f0:	8552                	mv	a0,s4
    800039f2:	b87fd0ef          	jal	80001578 <killed>
    800039f6:	ed19                	bnez	a0,80003a14 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800039f8:	85a6                	mv	a1,s1
    800039fa:	854e                	mv	a0,s3
    800039fc:	945fd0ef          	jal	80001340 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a00:	2184a703          	lw	a4,536(s1)
    80003a04:	21c4a783          	lw	a5,540(s1)
    80003a08:	fef701e3          	beq	a4,a5,800039ea <piperead+0x34>
    80003a0c:	e85a                	sd	s6,16(sp)
    80003a0e:	a809                	j	80003a20 <piperead+0x6a>
    80003a10:	e85a                	sd	s6,16(sp)
    80003a12:	a039                	j	80003a20 <piperead+0x6a>
      release(&pi->lock);
    80003a14:	8526                	mv	a0,s1
    80003a16:	753010ef          	jal	80005968 <release>
      return -1;
    80003a1a:	59fd                	li	s3,-1
    80003a1c:	a8b1                	j	80003a78 <piperead+0xc2>
    80003a1e:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a20:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a22:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a24:	05505263          	blez	s5,80003a68 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003a28:	2184a783          	lw	a5,536(s1)
    80003a2c:	21c4a703          	lw	a4,540(s1)
    80003a30:	02f70c63          	beq	a4,a5,80003a68 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003a34:	0017871b          	addiw	a4,a5,1
    80003a38:	20e4ac23          	sw	a4,536(s1)
    80003a3c:	1ff7f793          	andi	a5,a5,511
    80003a40:	97a6                	add	a5,a5,s1
    80003a42:	0187c783          	lbu	a5,24(a5)
    80003a46:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a4a:	4685                	li	a3,1
    80003a4c:	fbf40613          	addi	a2,s0,-65
    80003a50:	85ca                	mv	a1,s2
    80003a52:	050a3503          	ld	a0,80(s4)
    80003a56:	f83fc0ef          	jal	800009d8 <copyout>
    80003a5a:	01650763          	beq	a0,s6,80003a68 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a5e:	2985                	addiw	s3,s3,1
    80003a60:	0905                	addi	s2,s2,1
    80003a62:	fd3a93e3          	bne	s5,s3,80003a28 <piperead+0x72>
    80003a66:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003a68:	21c48513          	addi	a0,s1,540
    80003a6c:	921fd0ef          	jal	8000138c <wakeup>
  release(&pi->lock);
    80003a70:	8526                	mv	a0,s1
    80003a72:	6f7010ef          	jal	80005968 <release>
    80003a76:	6b42                	ld	s6,16(sp)
  return i;
}
    80003a78:	854e                	mv	a0,s3
    80003a7a:	60a6                	ld	ra,72(sp)
    80003a7c:	6406                	ld	s0,64(sp)
    80003a7e:	74e2                	ld	s1,56(sp)
    80003a80:	7942                	ld	s2,48(sp)
    80003a82:	79a2                	ld	s3,40(sp)
    80003a84:	7a02                	ld	s4,32(sp)
    80003a86:	6ae2                	ld	s5,24(sp)
    80003a88:	6161                	addi	sp,sp,80
    80003a8a:	8082                	ret

0000000080003a8c <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003a8c:	1141                	addi	sp,sp,-16
    80003a8e:	e422                	sd	s0,8(sp)
    80003a90:	0800                	addi	s0,sp,16
    80003a92:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003a94:	8905                	andi	a0,a0,1
    80003a96:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003a98:	8b89                	andi	a5,a5,2
    80003a9a:	c399                	beqz	a5,80003aa0 <flags2perm+0x14>
      perm |= PTE_W;
    80003a9c:	00456513          	ori	a0,a0,4
    return perm;
}
    80003aa0:	6422                	ld	s0,8(sp)
    80003aa2:	0141                	addi	sp,sp,16
    80003aa4:	8082                	ret

0000000080003aa6 <exec>:

int
exec(char *path, char **argv)
{
    80003aa6:	df010113          	addi	sp,sp,-528
    80003aaa:	20113423          	sd	ra,520(sp)
    80003aae:	20813023          	sd	s0,512(sp)
    80003ab2:	ffa6                	sd	s1,504(sp)
    80003ab4:	fbca                	sd	s2,496(sp)
    80003ab6:	0c00                	addi	s0,sp,528
    80003ab8:	892a                	mv	s2,a0
    80003aba:	dea43c23          	sd	a0,-520(s0)
    80003abe:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003ac2:	a98fd0ef          	jal	80000d5a <myproc>
    80003ac6:	84aa                	mv	s1,a0

  begin_op();
    80003ac8:	dc6ff0ef          	jal	8000308e <begin_op>

  if((ip = namei(path)) == 0){
    80003acc:	854a                	mv	a0,s2
    80003ace:	c04ff0ef          	jal	80002ed2 <namei>
    80003ad2:	c931                	beqz	a0,80003b26 <exec+0x80>
    80003ad4:	f3d2                	sd	s4,480(sp)
    80003ad6:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003ad8:	d21fe0ef          	jal	800027f8 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003adc:	04000713          	li	a4,64
    80003ae0:	4681                	li	a3,0
    80003ae2:	e5040613          	addi	a2,s0,-432
    80003ae6:	4581                	li	a1,0
    80003ae8:	8552                	mv	a0,s4
    80003aea:	f63fe0ef          	jal	80002a4c <readi>
    80003aee:	04000793          	li	a5,64
    80003af2:	00f51a63          	bne	a0,a5,80003b06 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003af6:	e5042703          	lw	a4,-432(s0)
    80003afa:	464c47b7          	lui	a5,0x464c4
    80003afe:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003b02:	02f70663          	beq	a4,a5,80003b2e <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003b06:	8552                	mv	a0,s4
    80003b08:	efbfe0ef          	jal	80002a02 <iunlockput>
    end_op();
    80003b0c:	decff0ef          	jal	800030f8 <end_op>
  }
  return -1;
    80003b10:	557d                	li	a0,-1
    80003b12:	7a1e                	ld	s4,480(sp)
}
    80003b14:	20813083          	ld	ra,520(sp)
    80003b18:	20013403          	ld	s0,512(sp)
    80003b1c:	74fe                	ld	s1,504(sp)
    80003b1e:	795e                	ld	s2,496(sp)
    80003b20:	21010113          	addi	sp,sp,528
    80003b24:	8082                	ret
    end_op();
    80003b26:	dd2ff0ef          	jal	800030f8 <end_op>
    return -1;
    80003b2a:	557d                	li	a0,-1
    80003b2c:	b7e5                	j	80003b14 <exec+0x6e>
    80003b2e:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003b30:	8526                	mv	a0,s1
    80003b32:	ad0fd0ef          	jal	80000e02 <proc_pagetable>
    80003b36:	8b2a                	mv	s6,a0
    80003b38:	2c050b63          	beqz	a0,80003e0e <exec+0x368>
    80003b3c:	f7ce                	sd	s3,488(sp)
    80003b3e:	efd6                	sd	s5,472(sp)
    80003b40:	e7de                	sd	s7,456(sp)
    80003b42:	e3e2                	sd	s8,448(sp)
    80003b44:	ff66                	sd	s9,440(sp)
    80003b46:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b48:	e7042d03          	lw	s10,-400(s0)
    80003b4c:	e8845783          	lhu	a5,-376(s0)
    80003b50:	12078963          	beqz	a5,80003c82 <exec+0x1dc>
    80003b54:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b56:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b58:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003b5a:	6c85                	lui	s9,0x1
    80003b5c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003b60:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003b64:	6a85                	lui	s5,0x1
    80003b66:	a085                	j	80003bc6 <exec+0x120>
      panic("loadseg: address should exist");
    80003b68:	00004517          	auipc	a0,0x4
    80003b6c:	b4050513          	addi	a0,a0,-1216 # 800076a8 <etext+0x6a8>
    80003b70:	233010ef          	jal	800055a2 <panic>
    if(sz - i < PGSIZE)
    80003b74:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003b76:	8726                	mv	a4,s1
    80003b78:	012c06bb          	addw	a3,s8,s2
    80003b7c:	4581                	li	a1,0
    80003b7e:	8552                	mv	a0,s4
    80003b80:	ecdfe0ef          	jal	80002a4c <readi>
    80003b84:	2501                	sext.w	a0,a0
    80003b86:	24a49a63          	bne	s1,a0,80003dda <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003b8a:	012a893b          	addw	s2,s5,s2
    80003b8e:	03397363          	bgeu	s2,s3,80003bb4 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003b92:	02091593          	slli	a1,s2,0x20
    80003b96:	9181                	srli	a1,a1,0x20
    80003b98:	95de                	add	a1,a1,s7
    80003b9a:	855a                	mv	a0,s6
    80003b9c:	8c1fc0ef          	jal	8000045c <walkaddr>
    80003ba0:	862a                	mv	a2,a0
    if(pa == 0)
    80003ba2:	d179                	beqz	a0,80003b68 <exec+0xc2>
    if(sz - i < PGSIZE)
    80003ba4:	412984bb          	subw	s1,s3,s2
    80003ba8:	0004879b          	sext.w	a5,s1
    80003bac:	fcfcf4e3          	bgeu	s9,a5,80003b74 <exec+0xce>
    80003bb0:	84d6                	mv	s1,s5
    80003bb2:	b7c9                	j	80003b74 <exec+0xce>
    sz = sz1;
    80003bb4:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003bb8:	2d85                	addiw	s11,s11,1
    80003bba:	038d0d1b          	addiw	s10,s10,56
    80003bbe:	e8845783          	lhu	a5,-376(s0)
    80003bc2:	08fdd063          	bge	s11,a5,80003c42 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003bc6:	2d01                	sext.w	s10,s10
    80003bc8:	03800713          	li	a4,56
    80003bcc:	86ea                	mv	a3,s10
    80003bce:	e1840613          	addi	a2,s0,-488
    80003bd2:	4581                	li	a1,0
    80003bd4:	8552                	mv	a0,s4
    80003bd6:	e77fe0ef          	jal	80002a4c <readi>
    80003bda:	03800793          	li	a5,56
    80003bde:	1cf51663          	bne	a0,a5,80003daa <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003be2:	e1842783          	lw	a5,-488(s0)
    80003be6:	4705                	li	a4,1
    80003be8:	fce798e3          	bne	a5,a4,80003bb8 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003bec:	e4043483          	ld	s1,-448(s0)
    80003bf0:	e3843783          	ld	a5,-456(s0)
    80003bf4:	1af4ef63          	bltu	s1,a5,80003db2 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003bf8:	e2843783          	ld	a5,-472(s0)
    80003bfc:	94be                	add	s1,s1,a5
    80003bfe:	1af4ee63          	bltu	s1,a5,80003dba <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003c02:	df043703          	ld	a4,-528(s0)
    80003c06:	8ff9                	and	a5,a5,a4
    80003c08:	1a079d63          	bnez	a5,80003dc2 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003c0c:	e1c42503          	lw	a0,-484(s0)
    80003c10:	e7dff0ef          	jal	80003a8c <flags2perm>
    80003c14:	86aa                	mv	a3,a0
    80003c16:	8626                	mv	a2,s1
    80003c18:	85ca                	mv	a1,s2
    80003c1a:	855a                	mv	a0,s6
    80003c1c:	ba9fc0ef          	jal	800007c4 <uvmalloc>
    80003c20:	e0a43423          	sd	a0,-504(s0)
    80003c24:	1a050363          	beqz	a0,80003dca <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003c28:	e2843b83          	ld	s7,-472(s0)
    80003c2c:	e2042c03          	lw	s8,-480(s0)
    80003c30:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003c34:	00098463          	beqz	s3,80003c3c <exec+0x196>
    80003c38:	4901                	li	s2,0
    80003c3a:	bfa1                	j	80003b92 <exec+0xec>
    sz = sz1;
    80003c3c:	e0843903          	ld	s2,-504(s0)
    80003c40:	bfa5                	j	80003bb8 <exec+0x112>
    80003c42:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003c44:	8552                	mv	a0,s4
    80003c46:	dbdfe0ef          	jal	80002a02 <iunlockput>
  end_op();
    80003c4a:	caeff0ef          	jal	800030f8 <end_op>
  p = myproc();
    80003c4e:	90cfd0ef          	jal	80000d5a <myproc>
    80003c52:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003c54:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003c58:	6985                	lui	s3,0x1
    80003c5a:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003c5c:	99ca                	add	s3,s3,s2
    80003c5e:	77fd                	lui	a5,0xfffff
    80003c60:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003c64:	4691                	li	a3,4
    80003c66:	660d                	lui	a2,0x3
    80003c68:	964e                	add	a2,a2,s3
    80003c6a:	85ce                	mv	a1,s3
    80003c6c:	855a                	mv	a0,s6
    80003c6e:	b57fc0ef          	jal	800007c4 <uvmalloc>
    80003c72:	892a                	mv	s2,a0
    80003c74:	e0a43423          	sd	a0,-504(s0)
    80003c78:	e519                	bnez	a0,80003c86 <exec+0x1e0>
  if(pagetable)
    80003c7a:	e1343423          	sd	s3,-504(s0)
    80003c7e:	4a01                	li	s4,0
    80003c80:	aab1                	j	80003ddc <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003c82:	4901                	li	s2,0
    80003c84:	b7c1                	j	80003c44 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003c86:	75f5                	lui	a1,0xffffd
    80003c88:	95aa                	add	a1,a1,a0
    80003c8a:	855a                	mv	a0,s6
    80003c8c:	d23fc0ef          	jal	800009ae <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003c90:	7bf9                	lui	s7,0xffffe
    80003c92:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003c94:	e0043783          	ld	a5,-512(s0)
    80003c98:	6388                	ld	a0,0(a5)
    80003c9a:	cd39                	beqz	a0,80003cf8 <exec+0x252>
    80003c9c:	e9040993          	addi	s3,s0,-368
    80003ca0:	f9040c13          	addi	s8,s0,-112
    80003ca4:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003ca6:	e18fc0ef          	jal	800002be <strlen>
    80003caa:	0015079b          	addiw	a5,a0,1
    80003cae:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003cb2:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003cb6:	11796e63          	bltu	s2,s7,80003dd2 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003cba:	e0043d03          	ld	s10,-512(s0)
    80003cbe:	000d3a03          	ld	s4,0(s10)
    80003cc2:	8552                	mv	a0,s4
    80003cc4:	dfafc0ef          	jal	800002be <strlen>
    80003cc8:	0015069b          	addiw	a3,a0,1
    80003ccc:	8652                	mv	a2,s4
    80003cce:	85ca                	mv	a1,s2
    80003cd0:	855a                	mv	a0,s6
    80003cd2:	d07fc0ef          	jal	800009d8 <copyout>
    80003cd6:	10054063          	bltz	a0,80003dd6 <exec+0x330>
    ustack[argc] = sp;
    80003cda:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003cde:	0485                	addi	s1,s1,1
    80003ce0:	008d0793          	addi	a5,s10,8
    80003ce4:	e0f43023          	sd	a5,-512(s0)
    80003ce8:	008d3503          	ld	a0,8(s10)
    80003cec:	c909                	beqz	a0,80003cfe <exec+0x258>
    if(argc >= MAXARG)
    80003cee:	09a1                	addi	s3,s3,8
    80003cf0:	fb899be3          	bne	s3,s8,80003ca6 <exec+0x200>
  ip = 0;
    80003cf4:	4a01                	li	s4,0
    80003cf6:	a0dd                	j	80003ddc <exec+0x336>
  sp = sz;
    80003cf8:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003cfc:	4481                	li	s1,0
  ustack[argc] = 0;
    80003cfe:	00349793          	slli	a5,s1,0x3
    80003d02:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd67c0>
    80003d06:	97a2                	add	a5,a5,s0
    80003d08:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003d0c:	00148693          	addi	a3,s1,1
    80003d10:	068e                	slli	a3,a3,0x3
    80003d12:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003d16:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003d1a:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003d1e:	f5796ee3          	bltu	s2,s7,80003c7a <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003d22:	e9040613          	addi	a2,s0,-368
    80003d26:	85ca                	mv	a1,s2
    80003d28:	855a                	mv	a0,s6
    80003d2a:	caffc0ef          	jal	800009d8 <copyout>
    80003d2e:	0e054263          	bltz	a0,80003e12 <exec+0x36c>
  p->trapframe->a1 = sp;
    80003d32:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003d36:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003d3a:	df843783          	ld	a5,-520(s0)
    80003d3e:	0007c703          	lbu	a4,0(a5)
    80003d42:	cf11                	beqz	a4,80003d5e <exec+0x2b8>
    80003d44:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003d46:	02f00693          	li	a3,47
    80003d4a:	a039                	j	80003d58 <exec+0x2b2>
      last = s+1;
    80003d4c:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003d50:	0785                	addi	a5,a5,1
    80003d52:	fff7c703          	lbu	a4,-1(a5)
    80003d56:	c701                	beqz	a4,80003d5e <exec+0x2b8>
    if(*s == '/')
    80003d58:	fed71ce3          	bne	a4,a3,80003d50 <exec+0x2aa>
    80003d5c:	bfc5                	j	80003d4c <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003d5e:	4641                	li	a2,16
    80003d60:	df843583          	ld	a1,-520(s0)
    80003d64:	158a8513          	addi	a0,s5,344
    80003d68:	d24fc0ef          	jal	8000028c <safestrcpy>
  oldpagetable = p->pagetable;
    80003d6c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003d70:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003d74:	e0843783          	ld	a5,-504(s0)
    80003d78:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003d7c:	058ab783          	ld	a5,88(s5)
    80003d80:	e6843703          	ld	a4,-408(s0)
    80003d84:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003d86:	058ab783          	ld	a5,88(s5)
    80003d8a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003d8e:	85e6                	mv	a1,s9
    80003d90:	8f6fd0ef          	jal	80000e86 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003d94:	0004851b          	sext.w	a0,s1
    80003d98:	79be                	ld	s3,488(sp)
    80003d9a:	7a1e                	ld	s4,480(sp)
    80003d9c:	6afe                	ld	s5,472(sp)
    80003d9e:	6b5e                	ld	s6,464(sp)
    80003da0:	6bbe                	ld	s7,456(sp)
    80003da2:	6c1e                	ld	s8,448(sp)
    80003da4:	7cfa                	ld	s9,440(sp)
    80003da6:	7d5a                	ld	s10,432(sp)
    80003da8:	b3b5                	j	80003b14 <exec+0x6e>
    80003daa:	e1243423          	sd	s2,-504(s0)
    80003dae:	7dba                	ld	s11,424(sp)
    80003db0:	a035                	j	80003ddc <exec+0x336>
    80003db2:	e1243423          	sd	s2,-504(s0)
    80003db6:	7dba                	ld	s11,424(sp)
    80003db8:	a015                	j	80003ddc <exec+0x336>
    80003dba:	e1243423          	sd	s2,-504(s0)
    80003dbe:	7dba                	ld	s11,424(sp)
    80003dc0:	a831                	j	80003ddc <exec+0x336>
    80003dc2:	e1243423          	sd	s2,-504(s0)
    80003dc6:	7dba                	ld	s11,424(sp)
    80003dc8:	a811                	j	80003ddc <exec+0x336>
    80003dca:	e1243423          	sd	s2,-504(s0)
    80003dce:	7dba                	ld	s11,424(sp)
    80003dd0:	a031                	j	80003ddc <exec+0x336>
  ip = 0;
    80003dd2:	4a01                	li	s4,0
    80003dd4:	a021                	j	80003ddc <exec+0x336>
    80003dd6:	4a01                	li	s4,0
  if(pagetable)
    80003dd8:	a011                	j	80003ddc <exec+0x336>
    80003dda:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003ddc:	e0843583          	ld	a1,-504(s0)
    80003de0:	855a                	mv	a0,s6
    80003de2:	8a4fd0ef          	jal	80000e86 <proc_freepagetable>
  return -1;
    80003de6:	557d                	li	a0,-1
  if(ip){
    80003de8:	000a1b63          	bnez	s4,80003dfe <exec+0x358>
    80003dec:	79be                	ld	s3,488(sp)
    80003dee:	7a1e                	ld	s4,480(sp)
    80003df0:	6afe                	ld	s5,472(sp)
    80003df2:	6b5e                	ld	s6,464(sp)
    80003df4:	6bbe                	ld	s7,456(sp)
    80003df6:	6c1e                	ld	s8,448(sp)
    80003df8:	7cfa                	ld	s9,440(sp)
    80003dfa:	7d5a                	ld	s10,432(sp)
    80003dfc:	bb21                	j	80003b14 <exec+0x6e>
    80003dfe:	79be                	ld	s3,488(sp)
    80003e00:	6afe                	ld	s5,472(sp)
    80003e02:	6b5e                	ld	s6,464(sp)
    80003e04:	6bbe                	ld	s7,456(sp)
    80003e06:	6c1e                	ld	s8,448(sp)
    80003e08:	7cfa                	ld	s9,440(sp)
    80003e0a:	7d5a                	ld	s10,432(sp)
    80003e0c:	b9ed                	j	80003b06 <exec+0x60>
    80003e0e:	6b5e                	ld	s6,464(sp)
    80003e10:	b9dd                	j	80003b06 <exec+0x60>
  sz = sz1;
    80003e12:	e0843983          	ld	s3,-504(s0)
    80003e16:	b595                	j	80003c7a <exec+0x1d4>

0000000080003e18 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003e18:	7179                	addi	sp,sp,-48
    80003e1a:	f406                	sd	ra,40(sp)
    80003e1c:	f022                	sd	s0,32(sp)
    80003e1e:	ec26                	sd	s1,24(sp)
    80003e20:	e84a                	sd	s2,16(sp)
    80003e22:	1800                	addi	s0,sp,48
    80003e24:	892e                	mv	s2,a1
    80003e26:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003e28:	fdc40593          	addi	a1,s0,-36
    80003e2c:	e81fd0ef          	jal	80001cac <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003e30:	fdc42703          	lw	a4,-36(s0)
    80003e34:	47bd                	li	a5,15
    80003e36:	02e7e963          	bltu	a5,a4,80003e68 <argfd+0x50>
    80003e3a:	f21fc0ef          	jal	80000d5a <myproc>
    80003e3e:	fdc42703          	lw	a4,-36(s0)
    80003e42:	01a70793          	addi	a5,a4,26
    80003e46:	078e                	slli	a5,a5,0x3
    80003e48:	953e                	add	a0,a0,a5
    80003e4a:	611c                	ld	a5,0(a0)
    80003e4c:	c385                	beqz	a5,80003e6c <argfd+0x54>
    return -1;
  if(pfd)
    80003e4e:	00090463          	beqz	s2,80003e56 <argfd+0x3e>
    *pfd = fd;
    80003e52:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003e56:	4501                	li	a0,0
  if(pf)
    80003e58:	c091                	beqz	s1,80003e5c <argfd+0x44>
    *pf = f;
    80003e5a:	e09c                	sd	a5,0(s1)
}
    80003e5c:	70a2                	ld	ra,40(sp)
    80003e5e:	7402                	ld	s0,32(sp)
    80003e60:	64e2                	ld	s1,24(sp)
    80003e62:	6942                	ld	s2,16(sp)
    80003e64:	6145                	addi	sp,sp,48
    80003e66:	8082                	ret
    return -1;
    80003e68:	557d                	li	a0,-1
    80003e6a:	bfcd                	j	80003e5c <argfd+0x44>
    80003e6c:	557d                	li	a0,-1
    80003e6e:	b7fd                	j	80003e5c <argfd+0x44>

0000000080003e70 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003e70:	1101                	addi	sp,sp,-32
    80003e72:	ec06                	sd	ra,24(sp)
    80003e74:	e822                	sd	s0,16(sp)
    80003e76:	e426                	sd	s1,8(sp)
    80003e78:	1000                	addi	s0,sp,32
    80003e7a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003e7c:	edffc0ef          	jal	80000d5a <myproc>
    80003e80:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003e82:	0d050793          	addi	a5,a0,208
    80003e86:	4501                	li	a0,0
    80003e88:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003e8a:	6398                	ld	a4,0(a5)
    80003e8c:	cb19                	beqz	a4,80003ea2 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003e8e:	2505                	addiw	a0,a0,1
    80003e90:	07a1                	addi	a5,a5,8
    80003e92:	fed51ce3          	bne	a0,a3,80003e8a <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003e96:	557d                	li	a0,-1
}
    80003e98:	60e2                	ld	ra,24(sp)
    80003e9a:	6442                	ld	s0,16(sp)
    80003e9c:	64a2                	ld	s1,8(sp)
    80003e9e:	6105                	addi	sp,sp,32
    80003ea0:	8082                	ret
      p->ofile[fd] = f;
    80003ea2:	01a50793          	addi	a5,a0,26
    80003ea6:	078e                	slli	a5,a5,0x3
    80003ea8:	963e                	add	a2,a2,a5
    80003eaa:	e204                	sd	s1,0(a2)
      return fd;
    80003eac:	b7f5                	j	80003e98 <fdalloc+0x28>

0000000080003eae <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003eae:	715d                	addi	sp,sp,-80
    80003eb0:	e486                	sd	ra,72(sp)
    80003eb2:	e0a2                	sd	s0,64(sp)
    80003eb4:	fc26                	sd	s1,56(sp)
    80003eb6:	f84a                	sd	s2,48(sp)
    80003eb8:	f44e                	sd	s3,40(sp)
    80003eba:	ec56                	sd	s5,24(sp)
    80003ebc:	e85a                	sd	s6,16(sp)
    80003ebe:	0880                	addi	s0,sp,80
    80003ec0:	8b2e                	mv	s6,a1
    80003ec2:	89b2                	mv	s3,a2
    80003ec4:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003ec6:	fb040593          	addi	a1,s0,-80
    80003eca:	822ff0ef          	jal	80002eec <nameiparent>
    80003ece:	84aa                	mv	s1,a0
    80003ed0:	10050a63          	beqz	a0,80003fe4 <create+0x136>
    return 0;

  ilock(dp);
    80003ed4:	925fe0ef          	jal	800027f8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003ed8:	4601                	li	a2,0
    80003eda:	fb040593          	addi	a1,s0,-80
    80003ede:	8526                	mv	a0,s1
    80003ee0:	d8dfe0ef          	jal	80002c6c <dirlookup>
    80003ee4:	8aaa                	mv	s5,a0
    80003ee6:	c129                	beqz	a0,80003f28 <create+0x7a>
    iunlockput(dp);
    80003ee8:	8526                	mv	a0,s1
    80003eea:	b19fe0ef          	jal	80002a02 <iunlockput>
    ilock(ip);
    80003eee:	8556                	mv	a0,s5
    80003ef0:	909fe0ef          	jal	800027f8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003ef4:	4789                	li	a5,2
    80003ef6:	02fb1463          	bne	s6,a5,80003f1e <create+0x70>
    80003efa:	044ad783          	lhu	a5,68(s5)
    80003efe:	37f9                	addiw	a5,a5,-2
    80003f00:	17c2                	slli	a5,a5,0x30
    80003f02:	93c1                	srli	a5,a5,0x30
    80003f04:	4705                	li	a4,1
    80003f06:	00f76c63          	bltu	a4,a5,80003f1e <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003f0a:	8556                	mv	a0,s5
    80003f0c:	60a6                	ld	ra,72(sp)
    80003f0e:	6406                	ld	s0,64(sp)
    80003f10:	74e2                	ld	s1,56(sp)
    80003f12:	7942                	ld	s2,48(sp)
    80003f14:	79a2                	ld	s3,40(sp)
    80003f16:	6ae2                	ld	s5,24(sp)
    80003f18:	6b42                	ld	s6,16(sp)
    80003f1a:	6161                	addi	sp,sp,80
    80003f1c:	8082                	ret
    iunlockput(ip);
    80003f1e:	8556                	mv	a0,s5
    80003f20:	ae3fe0ef          	jal	80002a02 <iunlockput>
    return 0;
    80003f24:	4a81                	li	s5,0
    80003f26:	b7d5                	j	80003f0a <create+0x5c>
    80003f28:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003f2a:	85da                	mv	a1,s6
    80003f2c:	4088                	lw	a0,0(s1)
    80003f2e:	f5afe0ef          	jal	80002688 <ialloc>
    80003f32:	8a2a                	mv	s4,a0
    80003f34:	cd15                	beqz	a0,80003f70 <create+0xc2>
  ilock(ip);
    80003f36:	8c3fe0ef          	jal	800027f8 <ilock>
  ip->major = major;
    80003f3a:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003f3e:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003f42:	4905                	li	s2,1
    80003f44:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003f48:	8552                	mv	a0,s4
    80003f4a:	ffafe0ef          	jal	80002744 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003f4e:	032b0763          	beq	s6,s2,80003f7c <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f52:	004a2603          	lw	a2,4(s4)
    80003f56:	fb040593          	addi	a1,s0,-80
    80003f5a:	8526                	mv	a0,s1
    80003f5c:	eddfe0ef          	jal	80002e38 <dirlink>
    80003f60:	06054563          	bltz	a0,80003fca <create+0x11c>
  iunlockput(dp);
    80003f64:	8526                	mv	a0,s1
    80003f66:	a9dfe0ef          	jal	80002a02 <iunlockput>
  return ip;
    80003f6a:	8ad2                	mv	s5,s4
    80003f6c:	7a02                	ld	s4,32(sp)
    80003f6e:	bf71                	j	80003f0a <create+0x5c>
    iunlockput(dp);
    80003f70:	8526                	mv	a0,s1
    80003f72:	a91fe0ef          	jal	80002a02 <iunlockput>
    return 0;
    80003f76:	8ad2                	mv	s5,s4
    80003f78:	7a02                	ld	s4,32(sp)
    80003f7a:	bf41                	j	80003f0a <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003f7c:	004a2603          	lw	a2,4(s4)
    80003f80:	00003597          	auipc	a1,0x3
    80003f84:	74858593          	addi	a1,a1,1864 # 800076c8 <etext+0x6c8>
    80003f88:	8552                	mv	a0,s4
    80003f8a:	eaffe0ef          	jal	80002e38 <dirlink>
    80003f8e:	02054e63          	bltz	a0,80003fca <create+0x11c>
    80003f92:	40d0                	lw	a2,4(s1)
    80003f94:	00003597          	auipc	a1,0x3
    80003f98:	73c58593          	addi	a1,a1,1852 # 800076d0 <etext+0x6d0>
    80003f9c:	8552                	mv	a0,s4
    80003f9e:	e9bfe0ef          	jal	80002e38 <dirlink>
    80003fa2:	02054463          	bltz	a0,80003fca <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003fa6:	004a2603          	lw	a2,4(s4)
    80003faa:	fb040593          	addi	a1,s0,-80
    80003fae:	8526                	mv	a0,s1
    80003fb0:	e89fe0ef          	jal	80002e38 <dirlink>
    80003fb4:	00054b63          	bltz	a0,80003fca <create+0x11c>
    dp->nlink++;  // for ".."
    80003fb8:	04a4d783          	lhu	a5,74(s1)
    80003fbc:	2785                	addiw	a5,a5,1
    80003fbe:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003fc2:	8526                	mv	a0,s1
    80003fc4:	f80fe0ef          	jal	80002744 <iupdate>
    80003fc8:	bf71                	j	80003f64 <create+0xb6>
  ip->nlink = 0;
    80003fca:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003fce:	8552                	mv	a0,s4
    80003fd0:	f74fe0ef          	jal	80002744 <iupdate>
  iunlockput(ip);
    80003fd4:	8552                	mv	a0,s4
    80003fd6:	a2dfe0ef          	jal	80002a02 <iunlockput>
  iunlockput(dp);
    80003fda:	8526                	mv	a0,s1
    80003fdc:	a27fe0ef          	jal	80002a02 <iunlockput>
  return 0;
    80003fe0:	7a02                	ld	s4,32(sp)
    80003fe2:	b725                	j	80003f0a <create+0x5c>
    return 0;
    80003fe4:	8aaa                	mv	s5,a0
    80003fe6:	b715                	j	80003f0a <create+0x5c>

0000000080003fe8 <sys_dup>:
{
    80003fe8:	7179                	addi	sp,sp,-48
    80003fea:	f406                	sd	ra,40(sp)
    80003fec:	f022                	sd	s0,32(sp)
    80003fee:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003ff0:	fd840613          	addi	a2,s0,-40
    80003ff4:	4581                	li	a1,0
    80003ff6:	4501                	li	a0,0
    80003ff8:	e21ff0ef          	jal	80003e18 <argfd>
    return -1;
    80003ffc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003ffe:	02054363          	bltz	a0,80004024 <sys_dup+0x3c>
    80004002:	ec26                	sd	s1,24(sp)
    80004004:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004006:	fd843903          	ld	s2,-40(s0)
    8000400a:	854a                	mv	a0,s2
    8000400c:	e65ff0ef          	jal	80003e70 <fdalloc>
    80004010:	84aa                	mv	s1,a0
    return -1;
    80004012:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004014:	00054d63          	bltz	a0,8000402e <sys_dup+0x46>
  filedup(f);
    80004018:	854a                	mv	a0,s2
    8000401a:	c48ff0ef          	jal	80003462 <filedup>
  return fd;
    8000401e:	87a6                	mv	a5,s1
    80004020:	64e2                	ld	s1,24(sp)
    80004022:	6942                	ld	s2,16(sp)
}
    80004024:	853e                	mv	a0,a5
    80004026:	70a2                	ld	ra,40(sp)
    80004028:	7402                	ld	s0,32(sp)
    8000402a:	6145                	addi	sp,sp,48
    8000402c:	8082                	ret
    8000402e:	64e2                	ld	s1,24(sp)
    80004030:	6942                	ld	s2,16(sp)
    80004032:	bfcd                	j	80004024 <sys_dup+0x3c>

0000000080004034 <sys_read>:
{
    80004034:	7179                	addi	sp,sp,-48
    80004036:	f406                	sd	ra,40(sp)
    80004038:	f022                	sd	s0,32(sp)
    8000403a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000403c:	fd840593          	addi	a1,s0,-40
    80004040:	4505                	li	a0,1
    80004042:	c89fd0ef          	jal	80001cca <argaddr>
  argint(2, &n);
    80004046:	fe440593          	addi	a1,s0,-28
    8000404a:	4509                	li	a0,2
    8000404c:	c61fd0ef          	jal	80001cac <argint>
  if(argfd(0, 0, &f) < 0)
    80004050:	fe840613          	addi	a2,s0,-24
    80004054:	4581                	li	a1,0
    80004056:	4501                	li	a0,0
    80004058:	dc1ff0ef          	jal	80003e18 <argfd>
    8000405c:	87aa                	mv	a5,a0
    return -1;
    8000405e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004060:	0007ca63          	bltz	a5,80004074 <sys_read+0x40>
  return fileread(f, p, n);
    80004064:	fe442603          	lw	a2,-28(s0)
    80004068:	fd843583          	ld	a1,-40(s0)
    8000406c:	fe843503          	ld	a0,-24(s0)
    80004070:	d58ff0ef          	jal	800035c8 <fileread>
}
    80004074:	70a2                	ld	ra,40(sp)
    80004076:	7402                	ld	s0,32(sp)
    80004078:	6145                	addi	sp,sp,48
    8000407a:	8082                	ret

000000008000407c <sys_write>:
{
    8000407c:	7179                	addi	sp,sp,-48
    8000407e:	f406                	sd	ra,40(sp)
    80004080:	f022                	sd	s0,32(sp)
    80004082:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004084:	fd840593          	addi	a1,s0,-40
    80004088:	4505                	li	a0,1
    8000408a:	c41fd0ef          	jal	80001cca <argaddr>
  argint(2, &n);
    8000408e:	fe440593          	addi	a1,s0,-28
    80004092:	4509                	li	a0,2
    80004094:	c19fd0ef          	jal	80001cac <argint>
  if(argfd(0, 0, &f) < 0)
    80004098:	fe840613          	addi	a2,s0,-24
    8000409c:	4581                	li	a1,0
    8000409e:	4501                	li	a0,0
    800040a0:	d79ff0ef          	jal	80003e18 <argfd>
    800040a4:	87aa                	mv	a5,a0
    return -1;
    800040a6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800040a8:	0007ca63          	bltz	a5,800040bc <sys_write+0x40>
  return filewrite(f, p, n);
    800040ac:	fe442603          	lw	a2,-28(s0)
    800040b0:	fd843583          	ld	a1,-40(s0)
    800040b4:	fe843503          	ld	a0,-24(s0)
    800040b8:	dceff0ef          	jal	80003686 <filewrite>
}
    800040bc:	70a2                	ld	ra,40(sp)
    800040be:	7402                	ld	s0,32(sp)
    800040c0:	6145                	addi	sp,sp,48
    800040c2:	8082                	ret

00000000800040c4 <sys_close>:
{
    800040c4:	1101                	addi	sp,sp,-32
    800040c6:	ec06                	sd	ra,24(sp)
    800040c8:	e822                	sd	s0,16(sp)
    800040ca:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800040cc:	fe040613          	addi	a2,s0,-32
    800040d0:	fec40593          	addi	a1,s0,-20
    800040d4:	4501                	li	a0,0
    800040d6:	d43ff0ef          	jal	80003e18 <argfd>
    return -1;
    800040da:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800040dc:	02054063          	bltz	a0,800040fc <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    800040e0:	c7bfc0ef          	jal	80000d5a <myproc>
    800040e4:	fec42783          	lw	a5,-20(s0)
    800040e8:	07e9                	addi	a5,a5,26
    800040ea:	078e                	slli	a5,a5,0x3
    800040ec:	953e                	add	a0,a0,a5
    800040ee:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800040f2:	fe043503          	ld	a0,-32(s0)
    800040f6:	bb2ff0ef          	jal	800034a8 <fileclose>
  return 0;
    800040fa:	4781                	li	a5,0
}
    800040fc:	853e                	mv	a0,a5
    800040fe:	60e2                	ld	ra,24(sp)
    80004100:	6442                	ld	s0,16(sp)
    80004102:	6105                	addi	sp,sp,32
    80004104:	8082                	ret

0000000080004106 <sys_fstat>:
{
    80004106:	1101                	addi	sp,sp,-32
    80004108:	ec06                	sd	ra,24(sp)
    8000410a:	e822                	sd	s0,16(sp)
    8000410c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000410e:	fe040593          	addi	a1,s0,-32
    80004112:	4505                	li	a0,1
    80004114:	bb7fd0ef          	jal	80001cca <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004118:	fe840613          	addi	a2,s0,-24
    8000411c:	4581                	li	a1,0
    8000411e:	4501                	li	a0,0
    80004120:	cf9ff0ef          	jal	80003e18 <argfd>
    80004124:	87aa                	mv	a5,a0
    return -1;
    80004126:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004128:	0007c863          	bltz	a5,80004138 <sys_fstat+0x32>
  return filestat(f, st);
    8000412c:	fe043583          	ld	a1,-32(s0)
    80004130:	fe843503          	ld	a0,-24(s0)
    80004134:	c36ff0ef          	jal	8000356a <filestat>
}
    80004138:	60e2                	ld	ra,24(sp)
    8000413a:	6442                	ld	s0,16(sp)
    8000413c:	6105                	addi	sp,sp,32
    8000413e:	8082                	ret

0000000080004140 <sys_link>:
{
    80004140:	7169                	addi	sp,sp,-304
    80004142:	f606                	sd	ra,296(sp)
    80004144:	f222                	sd	s0,288(sp)
    80004146:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004148:	08000613          	li	a2,128
    8000414c:	ed040593          	addi	a1,s0,-304
    80004150:	4501                	li	a0,0
    80004152:	b95fd0ef          	jal	80001ce6 <argstr>
    return -1;
    80004156:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004158:	0c054e63          	bltz	a0,80004234 <sys_link+0xf4>
    8000415c:	08000613          	li	a2,128
    80004160:	f5040593          	addi	a1,s0,-176
    80004164:	4505                	li	a0,1
    80004166:	b81fd0ef          	jal	80001ce6 <argstr>
    return -1;
    8000416a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000416c:	0c054463          	bltz	a0,80004234 <sys_link+0xf4>
    80004170:	ee26                	sd	s1,280(sp)
  begin_op();
    80004172:	f1dfe0ef          	jal	8000308e <begin_op>
  if((ip = namei(old)) == 0){
    80004176:	ed040513          	addi	a0,s0,-304
    8000417a:	d59fe0ef          	jal	80002ed2 <namei>
    8000417e:	84aa                	mv	s1,a0
    80004180:	c53d                	beqz	a0,800041ee <sys_link+0xae>
  ilock(ip);
    80004182:	e76fe0ef          	jal	800027f8 <ilock>
  if(ip->type == T_DIR){
    80004186:	04449703          	lh	a4,68(s1)
    8000418a:	4785                	li	a5,1
    8000418c:	06f70663          	beq	a4,a5,800041f8 <sys_link+0xb8>
    80004190:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004192:	04a4d783          	lhu	a5,74(s1)
    80004196:	2785                	addiw	a5,a5,1
    80004198:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000419c:	8526                	mv	a0,s1
    8000419e:	da6fe0ef          	jal	80002744 <iupdate>
  iunlock(ip);
    800041a2:	8526                	mv	a0,s1
    800041a4:	f02fe0ef          	jal	800028a6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800041a8:	fd040593          	addi	a1,s0,-48
    800041ac:	f5040513          	addi	a0,s0,-176
    800041b0:	d3dfe0ef          	jal	80002eec <nameiparent>
    800041b4:	892a                	mv	s2,a0
    800041b6:	cd21                	beqz	a0,8000420e <sys_link+0xce>
  ilock(dp);
    800041b8:	e40fe0ef          	jal	800027f8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800041bc:	00092703          	lw	a4,0(s2)
    800041c0:	409c                	lw	a5,0(s1)
    800041c2:	04f71363          	bne	a4,a5,80004208 <sys_link+0xc8>
    800041c6:	40d0                	lw	a2,4(s1)
    800041c8:	fd040593          	addi	a1,s0,-48
    800041cc:	854a                	mv	a0,s2
    800041ce:	c6bfe0ef          	jal	80002e38 <dirlink>
    800041d2:	02054b63          	bltz	a0,80004208 <sys_link+0xc8>
  iunlockput(dp);
    800041d6:	854a                	mv	a0,s2
    800041d8:	82bfe0ef          	jal	80002a02 <iunlockput>
  iput(ip);
    800041dc:	8526                	mv	a0,s1
    800041de:	f9cfe0ef          	jal	8000297a <iput>
  end_op();
    800041e2:	f17fe0ef          	jal	800030f8 <end_op>
  return 0;
    800041e6:	4781                	li	a5,0
    800041e8:	64f2                	ld	s1,280(sp)
    800041ea:	6952                	ld	s2,272(sp)
    800041ec:	a0a1                	j	80004234 <sys_link+0xf4>
    end_op();
    800041ee:	f0bfe0ef          	jal	800030f8 <end_op>
    return -1;
    800041f2:	57fd                	li	a5,-1
    800041f4:	64f2                	ld	s1,280(sp)
    800041f6:	a83d                	j	80004234 <sys_link+0xf4>
    iunlockput(ip);
    800041f8:	8526                	mv	a0,s1
    800041fa:	809fe0ef          	jal	80002a02 <iunlockput>
    end_op();
    800041fe:	efbfe0ef          	jal	800030f8 <end_op>
    return -1;
    80004202:	57fd                	li	a5,-1
    80004204:	64f2                	ld	s1,280(sp)
    80004206:	a03d                	j	80004234 <sys_link+0xf4>
    iunlockput(dp);
    80004208:	854a                	mv	a0,s2
    8000420a:	ff8fe0ef          	jal	80002a02 <iunlockput>
  ilock(ip);
    8000420e:	8526                	mv	a0,s1
    80004210:	de8fe0ef          	jal	800027f8 <ilock>
  ip->nlink--;
    80004214:	04a4d783          	lhu	a5,74(s1)
    80004218:	37fd                	addiw	a5,a5,-1
    8000421a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000421e:	8526                	mv	a0,s1
    80004220:	d24fe0ef          	jal	80002744 <iupdate>
  iunlockput(ip);
    80004224:	8526                	mv	a0,s1
    80004226:	fdcfe0ef          	jal	80002a02 <iunlockput>
  end_op();
    8000422a:	ecffe0ef          	jal	800030f8 <end_op>
  return -1;
    8000422e:	57fd                	li	a5,-1
    80004230:	64f2                	ld	s1,280(sp)
    80004232:	6952                	ld	s2,272(sp)
}
    80004234:	853e                	mv	a0,a5
    80004236:	70b2                	ld	ra,296(sp)
    80004238:	7412                	ld	s0,288(sp)
    8000423a:	6155                	addi	sp,sp,304
    8000423c:	8082                	ret

000000008000423e <sys_unlink>:
{
    8000423e:	7151                	addi	sp,sp,-240
    80004240:	f586                	sd	ra,232(sp)
    80004242:	f1a2                	sd	s0,224(sp)
    80004244:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004246:	08000613          	li	a2,128
    8000424a:	f3040593          	addi	a1,s0,-208
    8000424e:	4501                	li	a0,0
    80004250:	a97fd0ef          	jal	80001ce6 <argstr>
    80004254:	16054063          	bltz	a0,800043b4 <sys_unlink+0x176>
    80004258:	eda6                	sd	s1,216(sp)
  begin_op();
    8000425a:	e35fe0ef          	jal	8000308e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000425e:	fb040593          	addi	a1,s0,-80
    80004262:	f3040513          	addi	a0,s0,-208
    80004266:	c87fe0ef          	jal	80002eec <nameiparent>
    8000426a:	84aa                	mv	s1,a0
    8000426c:	c945                	beqz	a0,8000431c <sys_unlink+0xde>
  ilock(dp);
    8000426e:	d8afe0ef          	jal	800027f8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004272:	00003597          	auipc	a1,0x3
    80004276:	45658593          	addi	a1,a1,1110 # 800076c8 <etext+0x6c8>
    8000427a:	fb040513          	addi	a0,s0,-80
    8000427e:	9d9fe0ef          	jal	80002c56 <namecmp>
    80004282:	10050e63          	beqz	a0,8000439e <sys_unlink+0x160>
    80004286:	00003597          	auipc	a1,0x3
    8000428a:	44a58593          	addi	a1,a1,1098 # 800076d0 <etext+0x6d0>
    8000428e:	fb040513          	addi	a0,s0,-80
    80004292:	9c5fe0ef          	jal	80002c56 <namecmp>
    80004296:	10050463          	beqz	a0,8000439e <sys_unlink+0x160>
    8000429a:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000429c:	f2c40613          	addi	a2,s0,-212
    800042a0:	fb040593          	addi	a1,s0,-80
    800042a4:	8526                	mv	a0,s1
    800042a6:	9c7fe0ef          	jal	80002c6c <dirlookup>
    800042aa:	892a                	mv	s2,a0
    800042ac:	0e050863          	beqz	a0,8000439c <sys_unlink+0x15e>
  ilock(ip);
    800042b0:	d48fe0ef          	jal	800027f8 <ilock>
  if(ip->nlink < 1)
    800042b4:	04a91783          	lh	a5,74(s2)
    800042b8:	06f05763          	blez	a5,80004326 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800042bc:	04491703          	lh	a4,68(s2)
    800042c0:	4785                	li	a5,1
    800042c2:	06f70963          	beq	a4,a5,80004334 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800042c6:	4641                	li	a2,16
    800042c8:	4581                	li	a1,0
    800042ca:	fc040513          	addi	a0,s0,-64
    800042ce:	e81fb0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042d2:	4741                	li	a4,16
    800042d4:	f2c42683          	lw	a3,-212(s0)
    800042d8:	fc040613          	addi	a2,s0,-64
    800042dc:	4581                	li	a1,0
    800042de:	8526                	mv	a0,s1
    800042e0:	869fe0ef          	jal	80002b48 <writei>
    800042e4:	47c1                	li	a5,16
    800042e6:	08f51b63          	bne	a0,a5,8000437c <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    800042ea:	04491703          	lh	a4,68(s2)
    800042ee:	4785                	li	a5,1
    800042f0:	08f70d63          	beq	a4,a5,8000438a <sys_unlink+0x14c>
  iunlockput(dp);
    800042f4:	8526                	mv	a0,s1
    800042f6:	f0cfe0ef          	jal	80002a02 <iunlockput>
  ip->nlink--;
    800042fa:	04a95783          	lhu	a5,74(s2)
    800042fe:	37fd                	addiw	a5,a5,-1
    80004300:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004304:	854a                	mv	a0,s2
    80004306:	c3efe0ef          	jal	80002744 <iupdate>
  iunlockput(ip);
    8000430a:	854a                	mv	a0,s2
    8000430c:	ef6fe0ef          	jal	80002a02 <iunlockput>
  end_op();
    80004310:	de9fe0ef          	jal	800030f8 <end_op>
  return 0;
    80004314:	4501                	li	a0,0
    80004316:	64ee                	ld	s1,216(sp)
    80004318:	694e                	ld	s2,208(sp)
    8000431a:	a849                	j	800043ac <sys_unlink+0x16e>
    end_op();
    8000431c:	dddfe0ef          	jal	800030f8 <end_op>
    return -1;
    80004320:	557d                	li	a0,-1
    80004322:	64ee                	ld	s1,216(sp)
    80004324:	a061                	j	800043ac <sys_unlink+0x16e>
    80004326:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004328:	00003517          	auipc	a0,0x3
    8000432c:	3b050513          	addi	a0,a0,944 # 800076d8 <etext+0x6d8>
    80004330:	272010ef          	jal	800055a2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004334:	04c92703          	lw	a4,76(s2)
    80004338:	02000793          	li	a5,32
    8000433c:	f8e7f5e3          	bgeu	a5,a4,800042c6 <sys_unlink+0x88>
    80004340:	e5ce                	sd	s3,200(sp)
    80004342:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004346:	4741                	li	a4,16
    80004348:	86ce                	mv	a3,s3
    8000434a:	f1840613          	addi	a2,s0,-232
    8000434e:	4581                	li	a1,0
    80004350:	854a                	mv	a0,s2
    80004352:	efafe0ef          	jal	80002a4c <readi>
    80004356:	47c1                	li	a5,16
    80004358:	00f51c63          	bne	a0,a5,80004370 <sys_unlink+0x132>
    if(de.inum != 0)
    8000435c:	f1845783          	lhu	a5,-232(s0)
    80004360:	efa1                	bnez	a5,800043b8 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004362:	29c1                	addiw	s3,s3,16
    80004364:	04c92783          	lw	a5,76(s2)
    80004368:	fcf9efe3          	bltu	s3,a5,80004346 <sys_unlink+0x108>
    8000436c:	69ae                	ld	s3,200(sp)
    8000436e:	bfa1                	j	800042c6 <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004370:	00003517          	auipc	a0,0x3
    80004374:	38050513          	addi	a0,a0,896 # 800076f0 <etext+0x6f0>
    80004378:	22a010ef          	jal	800055a2 <panic>
    8000437c:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    8000437e:	00003517          	auipc	a0,0x3
    80004382:	38a50513          	addi	a0,a0,906 # 80007708 <etext+0x708>
    80004386:	21c010ef          	jal	800055a2 <panic>
    dp->nlink--;
    8000438a:	04a4d783          	lhu	a5,74(s1)
    8000438e:	37fd                	addiw	a5,a5,-1
    80004390:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004394:	8526                	mv	a0,s1
    80004396:	baefe0ef          	jal	80002744 <iupdate>
    8000439a:	bfa9                	j	800042f4 <sys_unlink+0xb6>
    8000439c:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    8000439e:	8526                	mv	a0,s1
    800043a0:	e62fe0ef          	jal	80002a02 <iunlockput>
  end_op();
    800043a4:	d55fe0ef          	jal	800030f8 <end_op>
  return -1;
    800043a8:	557d                	li	a0,-1
    800043aa:	64ee                	ld	s1,216(sp)
}
    800043ac:	70ae                	ld	ra,232(sp)
    800043ae:	740e                	ld	s0,224(sp)
    800043b0:	616d                	addi	sp,sp,240
    800043b2:	8082                	ret
    return -1;
    800043b4:	557d                	li	a0,-1
    800043b6:	bfdd                	j	800043ac <sys_unlink+0x16e>
    iunlockput(ip);
    800043b8:	854a                	mv	a0,s2
    800043ba:	e48fe0ef          	jal	80002a02 <iunlockput>
    goto bad;
    800043be:	694e                	ld	s2,208(sp)
    800043c0:	69ae                	ld	s3,200(sp)
    800043c2:	bff1                	j	8000439e <sys_unlink+0x160>

00000000800043c4 <sys_open>:

uint64
sys_open(void)
{
    800043c4:	7131                	addi	sp,sp,-192
    800043c6:	fd06                	sd	ra,184(sp)
    800043c8:	f922                	sd	s0,176(sp)
    800043ca:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800043cc:	f4c40593          	addi	a1,s0,-180
    800043d0:	4505                	li	a0,1
    800043d2:	8dbfd0ef          	jal	80001cac <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800043d6:	08000613          	li	a2,128
    800043da:	f5040593          	addi	a1,s0,-176
    800043de:	4501                	li	a0,0
    800043e0:	907fd0ef          	jal	80001ce6 <argstr>
    800043e4:	87aa                	mv	a5,a0
    return -1;
    800043e6:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800043e8:	0a07c263          	bltz	a5,8000448c <sys_open+0xc8>
    800043ec:	f526                	sd	s1,168(sp)

  begin_op();
    800043ee:	ca1fe0ef          	jal	8000308e <begin_op>

  if(omode & O_CREATE){
    800043f2:	f4c42783          	lw	a5,-180(s0)
    800043f6:	2007f793          	andi	a5,a5,512
    800043fa:	c3d5                	beqz	a5,8000449e <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    800043fc:	4681                	li	a3,0
    800043fe:	4601                	li	a2,0
    80004400:	4589                	li	a1,2
    80004402:	f5040513          	addi	a0,s0,-176
    80004406:	aa9ff0ef          	jal	80003eae <create>
    8000440a:	84aa                	mv	s1,a0
    if(ip == 0){
    8000440c:	c541                	beqz	a0,80004494 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000440e:	04449703          	lh	a4,68(s1)
    80004412:	478d                	li	a5,3
    80004414:	00f71763          	bne	a4,a5,80004422 <sys_open+0x5e>
    80004418:	0464d703          	lhu	a4,70(s1)
    8000441c:	47a5                	li	a5,9
    8000441e:	0ae7ed63          	bltu	a5,a4,800044d8 <sys_open+0x114>
    80004422:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004424:	fe1fe0ef          	jal	80003404 <filealloc>
    80004428:	892a                	mv	s2,a0
    8000442a:	c179                	beqz	a0,800044f0 <sys_open+0x12c>
    8000442c:	ed4e                	sd	s3,152(sp)
    8000442e:	a43ff0ef          	jal	80003e70 <fdalloc>
    80004432:	89aa                	mv	s3,a0
    80004434:	0a054a63          	bltz	a0,800044e8 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004438:	04449703          	lh	a4,68(s1)
    8000443c:	478d                	li	a5,3
    8000443e:	0cf70263          	beq	a4,a5,80004502 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004442:	4789                	li	a5,2
    80004444:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004448:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000444c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004450:	f4c42783          	lw	a5,-180(s0)
    80004454:	0017c713          	xori	a4,a5,1
    80004458:	8b05                	andi	a4,a4,1
    8000445a:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000445e:	0037f713          	andi	a4,a5,3
    80004462:	00e03733          	snez	a4,a4
    80004466:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000446a:	4007f793          	andi	a5,a5,1024
    8000446e:	c791                	beqz	a5,8000447a <sys_open+0xb6>
    80004470:	04449703          	lh	a4,68(s1)
    80004474:	4789                	li	a5,2
    80004476:	08f70d63          	beq	a4,a5,80004510 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    8000447a:	8526                	mv	a0,s1
    8000447c:	c2afe0ef          	jal	800028a6 <iunlock>
  end_op();
    80004480:	c79fe0ef          	jal	800030f8 <end_op>

  return fd;
    80004484:	854e                	mv	a0,s3
    80004486:	74aa                	ld	s1,168(sp)
    80004488:	790a                	ld	s2,160(sp)
    8000448a:	69ea                	ld	s3,152(sp)
}
    8000448c:	70ea                	ld	ra,184(sp)
    8000448e:	744a                	ld	s0,176(sp)
    80004490:	6129                	addi	sp,sp,192
    80004492:	8082                	ret
      end_op();
    80004494:	c65fe0ef          	jal	800030f8 <end_op>
      return -1;
    80004498:	557d                	li	a0,-1
    8000449a:	74aa                	ld	s1,168(sp)
    8000449c:	bfc5                	j	8000448c <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    8000449e:	f5040513          	addi	a0,s0,-176
    800044a2:	a31fe0ef          	jal	80002ed2 <namei>
    800044a6:	84aa                	mv	s1,a0
    800044a8:	c11d                	beqz	a0,800044ce <sys_open+0x10a>
    ilock(ip);
    800044aa:	b4efe0ef          	jal	800027f8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800044ae:	04449703          	lh	a4,68(s1)
    800044b2:	4785                	li	a5,1
    800044b4:	f4f71de3          	bne	a4,a5,8000440e <sys_open+0x4a>
    800044b8:	f4c42783          	lw	a5,-180(s0)
    800044bc:	d3bd                	beqz	a5,80004422 <sys_open+0x5e>
      iunlockput(ip);
    800044be:	8526                	mv	a0,s1
    800044c0:	d42fe0ef          	jal	80002a02 <iunlockput>
      end_op();
    800044c4:	c35fe0ef          	jal	800030f8 <end_op>
      return -1;
    800044c8:	557d                	li	a0,-1
    800044ca:	74aa                	ld	s1,168(sp)
    800044cc:	b7c1                	j	8000448c <sys_open+0xc8>
      end_op();
    800044ce:	c2bfe0ef          	jal	800030f8 <end_op>
      return -1;
    800044d2:	557d                	li	a0,-1
    800044d4:	74aa                	ld	s1,168(sp)
    800044d6:	bf5d                	j	8000448c <sys_open+0xc8>
    iunlockput(ip);
    800044d8:	8526                	mv	a0,s1
    800044da:	d28fe0ef          	jal	80002a02 <iunlockput>
    end_op();
    800044de:	c1bfe0ef          	jal	800030f8 <end_op>
    return -1;
    800044e2:	557d                	li	a0,-1
    800044e4:	74aa                	ld	s1,168(sp)
    800044e6:	b75d                	j	8000448c <sys_open+0xc8>
      fileclose(f);
    800044e8:	854a                	mv	a0,s2
    800044ea:	fbffe0ef          	jal	800034a8 <fileclose>
    800044ee:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800044f0:	8526                	mv	a0,s1
    800044f2:	d10fe0ef          	jal	80002a02 <iunlockput>
    end_op();
    800044f6:	c03fe0ef          	jal	800030f8 <end_op>
    return -1;
    800044fa:	557d                	li	a0,-1
    800044fc:	74aa                	ld	s1,168(sp)
    800044fe:	790a                	ld	s2,160(sp)
    80004500:	b771                	j	8000448c <sys_open+0xc8>
    f->type = FD_DEVICE;
    80004502:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004506:	04649783          	lh	a5,70(s1)
    8000450a:	02f91223          	sh	a5,36(s2)
    8000450e:	bf3d                	j	8000444c <sys_open+0x88>
    itrunc(ip);
    80004510:	8526                	mv	a0,s1
    80004512:	bd4fe0ef          	jal	800028e6 <itrunc>
    80004516:	b795                	j	8000447a <sys_open+0xb6>

0000000080004518 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004518:	7175                	addi	sp,sp,-144
    8000451a:	e506                	sd	ra,136(sp)
    8000451c:	e122                	sd	s0,128(sp)
    8000451e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004520:	b6ffe0ef          	jal	8000308e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004524:	08000613          	li	a2,128
    80004528:	f7040593          	addi	a1,s0,-144
    8000452c:	4501                	li	a0,0
    8000452e:	fb8fd0ef          	jal	80001ce6 <argstr>
    80004532:	02054363          	bltz	a0,80004558 <sys_mkdir+0x40>
    80004536:	4681                	li	a3,0
    80004538:	4601                	li	a2,0
    8000453a:	4585                	li	a1,1
    8000453c:	f7040513          	addi	a0,s0,-144
    80004540:	96fff0ef          	jal	80003eae <create>
    80004544:	c911                	beqz	a0,80004558 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004546:	cbcfe0ef          	jal	80002a02 <iunlockput>
  end_op();
    8000454a:	baffe0ef          	jal	800030f8 <end_op>
  return 0;
    8000454e:	4501                	li	a0,0
}
    80004550:	60aa                	ld	ra,136(sp)
    80004552:	640a                	ld	s0,128(sp)
    80004554:	6149                	addi	sp,sp,144
    80004556:	8082                	ret
    end_op();
    80004558:	ba1fe0ef          	jal	800030f8 <end_op>
    return -1;
    8000455c:	557d                	li	a0,-1
    8000455e:	bfcd                	j	80004550 <sys_mkdir+0x38>

0000000080004560 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004560:	7135                	addi	sp,sp,-160
    80004562:	ed06                	sd	ra,152(sp)
    80004564:	e922                	sd	s0,144(sp)
    80004566:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004568:	b27fe0ef          	jal	8000308e <begin_op>
  argint(1, &major);
    8000456c:	f6c40593          	addi	a1,s0,-148
    80004570:	4505                	li	a0,1
    80004572:	f3afd0ef          	jal	80001cac <argint>
  argint(2, &minor);
    80004576:	f6840593          	addi	a1,s0,-152
    8000457a:	4509                	li	a0,2
    8000457c:	f30fd0ef          	jal	80001cac <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004580:	08000613          	li	a2,128
    80004584:	f7040593          	addi	a1,s0,-144
    80004588:	4501                	li	a0,0
    8000458a:	f5cfd0ef          	jal	80001ce6 <argstr>
    8000458e:	02054563          	bltz	a0,800045b8 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004592:	f6841683          	lh	a3,-152(s0)
    80004596:	f6c41603          	lh	a2,-148(s0)
    8000459a:	458d                	li	a1,3
    8000459c:	f7040513          	addi	a0,s0,-144
    800045a0:	90fff0ef          	jal	80003eae <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800045a4:	c911                	beqz	a0,800045b8 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800045a6:	c5cfe0ef          	jal	80002a02 <iunlockput>
  end_op();
    800045aa:	b4ffe0ef          	jal	800030f8 <end_op>
  return 0;
    800045ae:	4501                	li	a0,0
}
    800045b0:	60ea                	ld	ra,152(sp)
    800045b2:	644a                	ld	s0,144(sp)
    800045b4:	610d                	addi	sp,sp,160
    800045b6:	8082                	ret
    end_op();
    800045b8:	b41fe0ef          	jal	800030f8 <end_op>
    return -1;
    800045bc:	557d                	li	a0,-1
    800045be:	bfcd                	j	800045b0 <sys_mknod+0x50>

00000000800045c0 <sys_chdir>:

uint64
sys_chdir(void)
{
    800045c0:	7135                	addi	sp,sp,-160
    800045c2:	ed06                	sd	ra,152(sp)
    800045c4:	e922                	sd	s0,144(sp)
    800045c6:	e14a                	sd	s2,128(sp)
    800045c8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800045ca:	f90fc0ef          	jal	80000d5a <myproc>
    800045ce:	892a                	mv	s2,a0
  
  begin_op();
    800045d0:	abffe0ef          	jal	8000308e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800045d4:	08000613          	li	a2,128
    800045d8:	f6040593          	addi	a1,s0,-160
    800045dc:	4501                	li	a0,0
    800045de:	f08fd0ef          	jal	80001ce6 <argstr>
    800045e2:	04054363          	bltz	a0,80004628 <sys_chdir+0x68>
    800045e6:	e526                	sd	s1,136(sp)
    800045e8:	f6040513          	addi	a0,s0,-160
    800045ec:	8e7fe0ef          	jal	80002ed2 <namei>
    800045f0:	84aa                	mv	s1,a0
    800045f2:	c915                	beqz	a0,80004626 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800045f4:	a04fe0ef          	jal	800027f8 <ilock>
  if(ip->type != T_DIR){
    800045f8:	04449703          	lh	a4,68(s1)
    800045fc:	4785                	li	a5,1
    800045fe:	02f71963          	bne	a4,a5,80004630 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004602:	8526                	mv	a0,s1
    80004604:	aa2fe0ef          	jal	800028a6 <iunlock>
  iput(p->cwd);
    80004608:	15093503          	ld	a0,336(s2)
    8000460c:	b6efe0ef          	jal	8000297a <iput>
  end_op();
    80004610:	ae9fe0ef          	jal	800030f8 <end_op>
  p->cwd = ip;
    80004614:	14993823          	sd	s1,336(s2)
  return 0;
    80004618:	4501                	li	a0,0
    8000461a:	64aa                	ld	s1,136(sp)
}
    8000461c:	60ea                	ld	ra,152(sp)
    8000461e:	644a                	ld	s0,144(sp)
    80004620:	690a                	ld	s2,128(sp)
    80004622:	610d                	addi	sp,sp,160
    80004624:	8082                	ret
    80004626:	64aa                	ld	s1,136(sp)
    end_op();
    80004628:	ad1fe0ef          	jal	800030f8 <end_op>
    return -1;
    8000462c:	557d                	li	a0,-1
    8000462e:	b7fd                	j	8000461c <sys_chdir+0x5c>
    iunlockput(ip);
    80004630:	8526                	mv	a0,s1
    80004632:	bd0fe0ef          	jal	80002a02 <iunlockput>
    end_op();
    80004636:	ac3fe0ef          	jal	800030f8 <end_op>
    return -1;
    8000463a:	557d                	li	a0,-1
    8000463c:	64aa                	ld	s1,136(sp)
    8000463e:	bff9                	j	8000461c <sys_chdir+0x5c>

0000000080004640 <sys_exec>:

uint64
sys_exec(void)
{
    80004640:	7121                	addi	sp,sp,-448
    80004642:	ff06                	sd	ra,440(sp)
    80004644:	fb22                	sd	s0,432(sp)
    80004646:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004648:	e4840593          	addi	a1,s0,-440
    8000464c:	4505                	li	a0,1
    8000464e:	e7cfd0ef          	jal	80001cca <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004652:	08000613          	li	a2,128
    80004656:	f5040593          	addi	a1,s0,-176
    8000465a:	4501                	li	a0,0
    8000465c:	e8afd0ef          	jal	80001ce6 <argstr>
    80004660:	87aa                	mv	a5,a0
    return -1;
    80004662:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004664:	0c07c463          	bltz	a5,8000472c <sys_exec+0xec>
    80004668:	f726                	sd	s1,424(sp)
    8000466a:	f34a                	sd	s2,416(sp)
    8000466c:	ef4e                	sd	s3,408(sp)
    8000466e:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004670:	10000613          	li	a2,256
    80004674:	4581                	li	a1,0
    80004676:	e5040513          	addi	a0,s0,-432
    8000467a:	ad5fb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000467e:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004682:	89a6                	mv	s3,s1
    80004684:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004686:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000468a:	00391513          	slli	a0,s2,0x3
    8000468e:	e4040593          	addi	a1,s0,-448
    80004692:	e4843783          	ld	a5,-440(s0)
    80004696:	953e                	add	a0,a0,a5
    80004698:	d8afd0ef          	jal	80001c22 <fetchaddr>
    8000469c:	02054663          	bltz	a0,800046c8 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800046a0:	e4043783          	ld	a5,-448(s0)
    800046a4:	c3a9                	beqz	a5,800046e6 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800046a6:	a59fb0ef          	jal	800000fe <kalloc>
    800046aa:	85aa                	mv	a1,a0
    800046ac:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800046b0:	cd01                	beqz	a0,800046c8 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800046b2:	6605                	lui	a2,0x1
    800046b4:	e4043503          	ld	a0,-448(s0)
    800046b8:	db4fd0ef          	jal	80001c6c <fetchstr>
    800046bc:	00054663          	bltz	a0,800046c8 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800046c0:	0905                	addi	s2,s2,1
    800046c2:	09a1                	addi	s3,s3,8
    800046c4:	fd4913e3          	bne	s2,s4,8000468a <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046c8:	f5040913          	addi	s2,s0,-176
    800046cc:	6088                	ld	a0,0(s1)
    800046ce:	c931                	beqz	a0,80004722 <sys_exec+0xe2>
    kfree(argv[i]);
    800046d0:	94dfb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046d4:	04a1                	addi	s1,s1,8
    800046d6:	ff249be3          	bne	s1,s2,800046cc <sys_exec+0x8c>
  return -1;
    800046da:	557d                	li	a0,-1
    800046dc:	74ba                	ld	s1,424(sp)
    800046de:	791a                	ld	s2,416(sp)
    800046e0:	69fa                	ld	s3,408(sp)
    800046e2:	6a5a                	ld	s4,400(sp)
    800046e4:	a0a1                	j	8000472c <sys_exec+0xec>
      argv[i] = 0;
    800046e6:	0009079b          	sext.w	a5,s2
    800046ea:	078e                	slli	a5,a5,0x3
    800046ec:	fd078793          	addi	a5,a5,-48
    800046f0:	97a2                	add	a5,a5,s0
    800046f2:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800046f6:	e5040593          	addi	a1,s0,-432
    800046fa:	f5040513          	addi	a0,s0,-176
    800046fe:	ba8ff0ef          	jal	80003aa6 <exec>
    80004702:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004704:	f5040993          	addi	s3,s0,-176
    80004708:	6088                	ld	a0,0(s1)
    8000470a:	c511                	beqz	a0,80004716 <sys_exec+0xd6>
    kfree(argv[i]);
    8000470c:	911fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004710:	04a1                	addi	s1,s1,8
    80004712:	ff349be3          	bne	s1,s3,80004708 <sys_exec+0xc8>
  return ret;
    80004716:	854a                	mv	a0,s2
    80004718:	74ba                	ld	s1,424(sp)
    8000471a:	791a                	ld	s2,416(sp)
    8000471c:	69fa                	ld	s3,408(sp)
    8000471e:	6a5a                	ld	s4,400(sp)
    80004720:	a031                	j	8000472c <sys_exec+0xec>
  return -1;
    80004722:	557d                	li	a0,-1
    80004724:	74ba                	ld	s1,424(sp)
    80004726:	791a                	ld	s2,416(sp)
    80004728:	69fa                	ld	s3,408(sp)
    8000472a:	6a5a                	ld	s4,400(sp)
}
    8000472c:	70fa                	ld	ra,440(sp)
    8000472e:	745a                	ld	s0,432(sp)
    80004730:	6139                	addi	sp,sp,448
    80004732:	8082                	ret

0000000080004734 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004734:	7139                	addi	sp,sp,-64
    80004736:	fc06                	sd	ra,56(sp)
    80004738:	f822                	sd	s0,48(sp)
    8000473a:	f426                	sd	s1,40(sp)
    8000473c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000473e:	e1cfc0ef          	jal	80000d5a <myproc>
    80004742:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004744:	fd840593          	addi	a1,s0,-40
    80004748:	4501                	li	a0,0
    8000474a:	d80fd0ef          	jal	80001cca <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000474e:	fc840593          	addi	a1,s0,-56
    80004752:	fd040513          	addi	a0,s0,-48
    80004756:	85cff0ef          	jal	800037b2 <pipealloc>
    return -1;
    8000475a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000475c:	0a054463          	bltz	a0,80004804 <sys_pipe+0xd0>
  fd0 = -1;
    80004760:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004764:	fd043503          	ld	a0,-48(s0)
    80004768:	f08ff0ef          	jal	80003e70 <fdalloc>
    8000476c:	fca42223          	sw	a0,-60(s0)
    80004770:	08054163          	bltz	a0,800047f2 <sys_pipe+0xbe>
    80004774:	fc843503          	ld	a0,-56(s0)
    80004778:	ef8ff0ef          	jal	80003e70 <fdalloc>
    8000477c:	fca42023          	sw	a0,-64(s0)
    80004780:	06054063          	bltz	a0,800047e0 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004784:	4691                	li	a3,4
    80004786:	fc440613          	addi	a2,s0,-60
    8000478a:	fd843583          	ld	a1,-40(s0)
    8000478e:	68a8                	ld	a0,80(s1)
    80004790:	a48fc0ef          	jal	800009d8 <copyout>
    80004794:	00054e63          	bltz	a0,800047b0 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004798:	4691                	li	a3,4
    8000479a:	fc040613          	addi	a2,s0,-64
    8000479e:	fd843583          	ld	a1,-40(s0)
    800047a2:	0591                	addi	a1,a1,4
    800047a4:	68a8                	ld	a0,80(s1)
    800047a6:	a32fc0ef          	jal	800009d8 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800047aa:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800047ac:	04055c63          	bgez	a0,80004804 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800047b0:	fc442783          	lw	a5,-60(s0)
    800047b4:	07e9                	addi	a5,a5,26
    800047b6:	078e                	slli	a5,a5,0x3
    800047b8:	97a6                	add	a5,a5,s1
    800047ba:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800047be:	fc042783          	lw	a5,-64(s0)
    800047c2:	07e9                	addi	a5,a5,26
    800047c4:	078e                	slli	a5,a5,0x3
    800047c6:	94be                	add	s1,s1,a5
    800047c8:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800047cc:	fd043503          	ld	a0,-48(s0)
    800047d0:	cd9fe0ef          	jal	800034a8 <fileclose>
    fileclose(wf);
    800047d4:	fc843503          	ld	a0,-56(s0)
    800047d8:	cd1fe0ef          	jal	800034a8 <fileclose>
    return -1;
    800047dc:	57fd                	li	a5,-1
    800047de:	a01d                	j	80004804 <sys_pipe+0xd0>
    if(fd0 >= 0)
    800047e0:	fc442783          	lw	a5,-60(s0)
    800047e4:	0007c763          	bltz	a5,800047f2 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800047e8:	07e9                	addi	a5,a5,26
    800047ea:	078e                	slli	a5,a5,0x3
    800047ec:	97a6                	add	a5,a5,s1
    800047ee:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800047f2:	fd043503          	ld	a0,-48(s0)
    800047f6:	cb3fe0ef          	jal	800034a8 <fileclose>
    fileclose(wf);
    800047fa:	fc843503          	ld	a0,-56(s0)
    800047fe:	cabfe0ef          	jal	800034a8 <fileclose>
    return -1;
    80004802:	57fd                	li	a5,-1
}
    80004804:	853e                	mv	a0,a5
    80004806:	70e2                	ld	ra,56(sp)
    80004808:	7442                	ld	s0,48(sp)
    8000480a:	74a2                	ld	s1,40(sp)
    8000480c:	6121                	addi	sp,sp,64
    8000480e:	8082                	ret

0000000080004810 <kernelvec>:
    80004810:	7111                	addi	sp,sp,-256
    80004812:	e006                	sd	ra,0(sp)
    80004814:	e40a                	sd	sp,8(sp)
    80004816:	e80e                	sd	gp,16(sp)
    80004818:	ec12                	sd	tp,24(sp)
    8000481a:	f016                	sd	t0,32(sp)
    8000481c:	f41a                	sd	t1,40(sp)
    8000481e:	f81e                	sd	t2,48(sp)
    80004820:	e4aa                	sd	a0,72(sp)
    80004822:	e8ae                	sd	a1,80(sp)
    80004824:	ecb2                	sd	a2,88(sp)
    80004826:	f0b6                	sd	a3,96(sp)
    80004828:	f4ba                	sd	a4,104(sp)
    8000482a:	f8be                	sd	a5,112(sp)
    8000482c:	fcc2                	sd	a6,120(sp)
    8000482e:	e146                	sd	a7,128(sp)
    80004830:	edf2                	sd	t3,216(sp)
    80004832:	f1f6                	sd	t4,224(sp)
    80004834:	f5fa                	sd	t5,232(sp)
    80004836:	f9fe                	sd	t6,240(sp)
    80004838:	afafd0ef          	jal	80001b32 <kerneltrap>
    8000483c:	6082                	ld	ra,0(sp)
    8000483e:	6122                	ld	sp,8(sp)
    80004840:	61c2                	ld	gp,16(sp)
    80004842:	7282                	ld	t0,32(sp)
    80004844:	7322                	ld	t1,40(sp)
    80004846:	73c2                	ld	t2,48(sp)
    80004848:	6526                	ld	a0,72(sp)
    8000484a:	65c6                	ld	a1,80(sp)
    8000484c:	6666                	ld	a2,88(sp)
    8000484e:	7686                	ld	a3,96(sp)
    80004850:	7726                	ld	a4,104(sp)
    80004852:	77c6                	ld	a5,112(sp)
    80004854:	7866                	ld	a6,120(sp)
    80004856:	688a                	ld	a7,128(sp)
    80004858:	6e6e                	ld	t3,216(sp)
    8000485a:	7e8e                	ld	t4,224(sp)
    8000485c:	7f2e                	ld	t5,232(sp)
    8000485e:	7fce                	ld	t6,240(sp)
    80004860:	6111                	addi	sp,sp,256
    80004862:	10200073          	sret
	...

000000008000486e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000486e:	1141                	addi	sp,sp,-16
    80004870:	e422                	sd	s0,8(sp)
    80004872:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004874:	0c0007b7          	lui	a5,0xc000
    80004878:	4705                	li	a4,1
    8000487a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000487c:	0c0007b7          	lui	a5,0xc000
    80004880:	c3d8                	sw	a4,4(a5)
}
    80004882:	6422                	ld	s0,8(sp)
    80004884:	0141                	addi	sp,sp,16
    80004886:	8082                	ret

0000000080004888 <plicinithart>:

void
plicinithart(void)
{
    80004888:	1141                	addi	sp,sp,-16
    8000488a:	e406                	sd	ra,8(sp)
    8000488c:	e022                	sd	s0,0(sp)
    8000488e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004890:	c9efc0ef          	jal	80000d2e <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004894:	0085171b          	slliw	a4,a0,0x8
    80004898:	0c0027b7          	lui	a5,0xc002
    8000489c:	97ba                	add	a5,a5,a4
    8000489e:	40200713          	li	a4,1026
    800048a2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800048a6:	00d5151b          	slliw	a0,a0,0xd
    800048aa:	0c2017b7          	lui	a5,0xc201
    800048ae:	97aa                	add	a5,a5,a0
    800048b0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800048b4:	60a2                	ld	ra,8(sp)
    800048b6:	6402                	ld	s0,0(sp)
    800048b8:	0141                	addi	sp,sp,16
    800048ba:	8082                	ret

00000000800048bc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800048bc:	1141                	addi	sp,sp,-16
    800048be:	e406                	sd	ra,8(sp)
    800048c0:	e022                	sd	s0,0(sp)
    800048c2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800048c4:	c6afc0ef          	jal	80000d2e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800048c8:	00d5151b          	slliw	a0,a0,0xd
    800048cc:	0c2017b7          	lui	a5,0xc201
    800048d0:	97aa                	add	a5,a5,a0
  return irq;
}
    800048d2:	43c8                	lw	a0,4(a5)
    800048d4:	60a2                	ld	ra,8(sp)
    800048d6:	6402                	ld	s0,0(sp)
    800048d8:	0141                	addi	sp,sp,16
    800048da:	8082                	ret

00000000800048dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800048dc:	1101                	addi	sp,sp,-32
    800048de:	ec06                	sd	ra,24(sp)
    800048e0:	e822                	sd	s0,16(sp)
    800048e2:	e426                	sd	s1,8(sp)
    800048e4:	1000                	addi	s0,sp,32
    800048e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800048e8:	c46fc0ef          	jal	80000d2e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800048ec:	00d5151b          	slliw	a0,a0,0xd
    800048f0:	0c2017b7          	lui	a5,0xc201
    800048f4:	97aa                	add	a5,a5,a0
    800048f6:	c3c4                	sw	s1,4(a5)
}
    800048f8:	60e2                	ld	ra,24(sp)
    800048fa:	6442                	ld	s0,16(sp)
    800048fc:	64a2                	ld	s1,8(sp)
    800048fe:	6105                	addi	sp,sp,32
    80004900:	8082                	ret

0000000080004902 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004902:	1141                	addi	sp,sp,-16
    80004904:	e406                	sd	ra,8(sp)
    80004906:	e022                	sd	s0,0(sp)
    80004908:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000490a:	479d                	li	a5,7
    8000490c:	04a7ca63          	blt	a5,a0,80004960 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004910:	0001c797          	auipc	a5,0x1c
    80004914:	c8078793          	addi	a5,a5,-896 # 80020590 <disk>
    80004918:	97aa                	add	a5,a5,a0
    8000491a:	0187c783          	lbu	a5,24(a5)
    8000491e:	e7b9                	bnez	a5,8000496c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004920:	00451693          	slli	a3,a0,0x4
    80004924:	0001c797          	auipc	a5,0x1c
    80004928:	c6c78793          	addi	a5,a5,-916 # 80020590 <disk>
    8000492c:	6398                	ld	a4,0(a5)
    8000492e:	9736                	add	a4,a4,a3
    80004930:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004934:	6398                	ld	a4,0(a5)
    80004936:	9736                	add	a4,a4,a3
    80004938:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000493c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004940:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004944:	97aa                	add	a5,a5,a0
    80004946:	4705                	li	a4,1
    80004948:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000494c:	0001c517          	auipc	a0,0x1c
    80004950:	c5c50513          	addi	a0,a0,-932 # 800205a8 <disk+0x18>
    80004954:	a39fc0ef          	jal	8000138c <wakeup>
}
    80004958:	60a2                	ld	ra,8(sp)
    8000495a:	6402                	ld	s0,0(sp)
    8000495c:	0141                	addi	sp,sp,16
    8000495e:	8082                	ret
    panic("free_desc 1");
    80004960:	00003517          	auipc	a0,0x3
    80004964:	db850513          	addi	a0,a0,-584 # 80007718 <etext+0x718>
    80004968:	43b000ef          	jal	800055a2 <panic>
    panic("free_desc 2");
    8000496c:	00003517          	auipc	a0,0x3
    80004970:	dbc50513          	addi	a0,a0,-580 # 80007728 <etext+0x728>
    80004974:	42f000ef          	jal	800055a2 <panic>

0000000080004978 <virtio_disk_init>:
{
    80004978:	1101                	addi	sp,sp,-32
    8000497a:	ec06                	sd	ra,24(sp)
    8000497c:	e822                	sd	s0,16(sp)
    8000497e:	e426                	sd	s1,8(sp)
    80004980:	e04a                	sd	s2,0(sp)
    80004982:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004984:	00003597          	auipc	a1,0x3
    80004988:	db458593          	addi	a1,a1,-588 # 80007738 <etext+0x738>
    8000498c:	0001c517          	auipc	a0,0x1c
    80004990:	d2c50513          	addi	a0,a0,-724 # 800206b8 <disk+0x128>
    80004994:	6bd000ef          	jal	80005850 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004998:	100017b7          	lui	a5,0x10001
    8000499c:	4398                	lw	a4,0(a5)
    8000499e:	2701                	sext.w	a4,a4
    800049a0:	747277b7          	lui	a5,0x74727
    800049a4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800049a8:	18f71063          	bne	a4,a5,80004b28 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800049ac:	100017b7          	lui	a5,0x10001
    800049b0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800049b2:	439c                	lw	a5,0(a5)
    800049b4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800049b6:	4709                	li	a4,2
    800049b8:	16e79863          	bne	a5,a4,80004b28 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800049bc:	100017b7          	lui	a5,0x10001
    800049c0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800049c2:	439c                	lw	a5,0(a5)
    800049c4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800049c6:	16e79163          	bne	a5,a4,80004b28 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800049ca:	100017b7          	lui	a5,0x10001
    800049ce:	47d8                	lw	a4,12(a5)
    800049d0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800049d2:	554d47b7          	lui	a5,0x554d4
    800049d6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800049da:	14f71763          	bne	a4,a5,80004b28 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    800049de:	100017b7          	lui	a5,0x10001
    800049e2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800049e6:	4705                	li	a4,1
    800049e8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800049ea:	470d                	li	a4,3
    800049ec:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800049ee:	10001737          	lui	a4,0x10001
    800049f2:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800049f4:	c7ffe737          	lui	a4,0xc7ffe
    800049f8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd5f8f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800049fc:	8ef9                	and	a3,a3,a4
    800049fe:	10001737          	lui	a4,0x10001
    80004a02:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a04:	472d                	li	a4,11
    80004a06:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a08:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004a0c:	439c                	lw	a5,0(a5)
    80004a0e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004a12:	8ba1                	andi	a5,a5,8
    80004a14:	12078063          	beqz	a5,80004b34 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004a18:	100017b7          	lui	a5,0x10001
    80004a1c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004a20:	100017b7          	lui	a5,0x10001
    80004a24:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004a28:	439c                	lw	a5,0(a5)
    80004a2a:	2781                	sext.w	a5,a5
    80004a2c:	10079a63          	bnez	a5,80004b40 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004a30:	100017b7          	lui	a5,0x10001
    80004a34:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004a38:	439c                	lw	a5,0(a5)
    80004a3a:	2781                	sext.w	a5,a5
  if(max == 0)
    80004a3c:	10078863          	beqz	a5,80004b4c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004a40:	471d                	li	a4,7
    80004a42:	10f77b63          	bgeu	a4,a5,80004b58 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004a46:	eb8fb0ef          	jal	800000fe <kalloc>
    80004a4a:	0001c497          	auipc	s1,0x1c
    80004a4e:	b4648493          	addi	s1,s1,-1210 # 80020590 <disk>
    80004a52:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004a54:	eaafb0ef          	jal	800000fe <kalloc>
    80004a58:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004a5a:	ea4fb0ef          	jal	800000fe <kalloc>
    80004a5e:	87aa                	mv	a5,a0
    80004a60:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004a62:	6088                	ld	a0,0(s1)
    80004a64:	10050063          	beqz	a0,80004b64 <virtio_disk_init+0x1ec>
    80004a68:	0001c717          	auipc	a4,0x1c
    80004a6c:	b3073703          	ld	a4,-1232(a4) # 80020598 <disk+0x8>
    80004a70:	0e070a63          	beqz	a4,80004b64 <virtio_disk_init+0x1ec>
    80004a74:	0e078863          	beqz	a5,80004b64 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004a78:	6605                	lui	a2,0x1
    80004a7a:	4581                	li	a1,0
    80004a7c:	ed2fb0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004a80:	0001c497          	auipc	s1,0x1c
    80004a84:	b1048493          	addi	s1,s1,-1264 # 80020590 <disk>
    80004a88:	6605                	lui	a2,0x1
    80004a8a:	4581                	li	a1,0
    80004a8c:	6488                	ld	a0,8(s1)
    80004a8e:	ec0fb0ef          	jal	8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    80004a92:	6605                	lui	a2,0x1
    80004a94:	4581                	li	a1,0
    80004a96:	6888                	ld	a0,16(s1)
    80004a98:	eb6fb0ef          	jal	8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004a9c:	100017b7          	lui	a5,0x10001
    80004aa0:	4721                	li	a4,8
    80004aa2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004aa4:	4098                	lw	a4,0(s1)
    80004aa6:	100017b7          	lui	a5,0x10001
    80004aaa:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004aae:	40d8                	lw	a4,4(s1)
    80004ab0:	100017b7          	lui	a5,0x10001
    80004ab4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004ab8:	649c                	ld	a5,8(s1)
    80004aba:	0007869b          	sext.w	a3,a5
    80004abe:	10001737          	lui	a4,0x10001
    80004ac2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004ac6:	9781                	srai	a5,a5,0x20
    80004ac8:	10001737          	lui	a4,0x10001
    80004acc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004ad0:	689c                	ld	a5,16(s1)
    80004ad2:	0007869b          	sext.w	a3,a5
    80004ad6:	10001737          	lui	a4,0x10001
    80004ada:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004ade:	9781                	srai	a5,a5,0x20
    80004ae0:	10001737          	lui	a4,0x10001
    80004ae4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004ae8:	10001737          	lui	a4,0x10001
    80004aec:	4785                	li	a5,1
    80004aee:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004af0:	00f48c23          	sb	a5,24(s1)
    80004af4:	00f48ca3          	sb	a5,25(s1)
    80004af8:	00f48d23          	sb	a5,26(s1)
    80004afc:	00f48da3          	sb	a5,27(s1)
    80004b00:	00f48e23          	sb	a5,28(s1)
    80004b04:	00f48ea3          	sb	a5,29(s1)
    80004b08:	00f48f23          	sb	a5,30(s1)
    80004b0c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004b10:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b14:	100017b7          	lui	a5,0x10001
    80004b18:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004b1c:	60e2                	ld	ra,24(sp)
    80004b1e:	6442                	ld	s0,16(sp)
    80004b20:	64a2                	ld	s1,8(sp)
    80004b22:	6902                	ld	s2,0(sp)
    80004b24:	6105                	addi	sp,sp,32
    80004b26:	8082                	ret
    panic("could not find virtio disk");
    80004b28:	00003517          	auipc	a0,0x3
    80004b2c:	c2050513          	addi	a0,a0,-992 # 80007748 <etext+0x748>
    80004b30:	273000ef          	jal	800055a2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004b34:	00003517          	auipc	a0,0x3
    80004b38:	c3450513          	addi	a0,a0,-972 # 80007768 <etext+0x768>
    80004b3c:	267000ef          	jal	800055a2 <panic>
    panic("virtio disk should not be ready");
    80004b40:	00003517          	auipc	a0,0x3
    80004b44:	c4850513          	addi	a0,a0,-952 # 80007788 <etext+0x788>
    80004b48:	25b000ef          	jal	800055a2 <panic>
    panic("virtio disk has no queue 0");
    80004b4c:	00003517          	auipc	a0,0x3
    80004b50:	c5c50513          	addi	a0,a0,-932 # 800077a8 <etext+0x7a8>
    80004b54:	24f000ef          	jal	800055a2 <panic>
    panic("virtio disk max queue too short");
    80004b58:	00003517          	auipc	a0,0x3
    80004b5c:	c7050513          	addi	a0,a0,-912 # 800077c8 <etext+0x7c8>
    80004b60:	243000ef          	jal	800055a2 <panic>
    panic("virtio disk kalloc");
    80004b64:	00003517          	auipc	a0,0x3
    80004b68:	c8450513          	addi	a0,a0,-892 # 800077e8 <etext+0x7e8>
    80004b6c:	237000ef          	jal	800055a2 <panic>

0000000080004b70 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004b70:	7159                	addi	sp,sp,-112
    80004b72:	f486                	sd	ra,104(sp)
    80004b74:	f0a2                	sd	s0,96(sp)
    80004b76:	eca6                	sd	s1,88(sp)
    80004b78:	e8ca                	sd	s2,80(sp)
    80004b7a:	e4ce                	sd	s3,72(sp)
    80004b7c:	e0d2                	sd	s4,64(sp)
    80004b7e:	fc56                	sd	s5,56(sp)
    80004b80:	f85a                	sd	s6,48(sp)
    80004b82:	f45e                	sd	s7,40(sp)
    80004b84:	f062                	sd	s8,32(sp)
    80004b86:	ec66                	sd	s9,24(sp)
    80004b88:	1880                	addi	s0,sp,112
    80004b8a:	8a2a                	mv	s4,a0
    80004b8c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004b8e:	00c52c83          	lw	s9,12(a0)
    80004b92:	001c9c9b          	slliw	s9,s9,0x1
    80004b96:	1c82                	slli	s9,s9,0x20
    80004b98:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004b9c:	0001c517          	auipc	a0,0x1c
    80004ba0:	b1c50513          	addi	a0,a0,-1252 # 800206b8 <disk+0x128>
    80004ba4:	52d000ef          	jal	800058d0 <acquire>
  for(int i = 0; i < 3; i++){
    80004ba8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004baa:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004bac:	0001cb17          	auipc	s6,0x1c
    80004bb0:	9e4b0b13          	addi	s6,s6,-1564 # 80020590 <disk>
  for(int i = 0; i < 3; i++){
    80004bb4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004bb6:	0001cc17          	auipc	s8,0x1c
    80004bba:	b02c0c13          	addi	s8,s8,-1278 # 800206b8 <disk+0x128>
    80004bbe:	a8b9                	j	80004c1c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004bc0:	00fb0733          	add	a4,s6,a5
    80004bc4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004bc8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004bca:	0207c563          	bltz	a5,80004bf4 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004bce:	2905                	addiw	s2,s2,1
    80004bd0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004bd2:	05590963          	beq	s2,s5,80004c24 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004bd6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004bd8:	0001c717          	auipc	a4,0x1c
    80004bdc:	9b870713          	addi	a4,a4,-1608 # 80020590 <disk>
    80004be0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004be2:	01874683          	lbu	a3,24(a4)
    80004be6:	fee9                	bnez	a3,80004bc0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004be8:	2785                	addiw	a5,a5,1
    80004bea:	0705                	addi	a4,a4,1
    80004bec:	fe979be3          	bne	a5,s1,80004be2 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004bf0:	57fd                	li	a5,-1
    80004bf2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004bf4:	01205d63          	blez	s2,80004c0e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004bf8:	f9042503          	lw	a0,-112(s0)
    80004bfc:	d07ff0ef          	jal	80004902 <free_desc>
      for(int j = 0; j < i; j++)
    80004c00:	4785                	li	a5,1
    80004c02:	0127d663          	bge	a5,s2,80004c0e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004c06:	f9442503          	lw	a0,-108(s0)
    80004c0a:	cf9ff0ef          	jal	80004902 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004c0e:	85e2                	mv	a1,s8
    80004c10:	0001c517          	auipc	a0,0x1c
    80004c14:	99850513          	addi	a0,a0,-1640 # 800205a8 <disk+0x18>
    80004c18:	f28fc0ef          	jal	80001340 <sleep>
  for(int i = 0; i < 3; i++){
    80004c1c:	f9040613          	addi	a2,s0,-112
    80004c20:	894e                	mv	s2,s3
    80004c22:	bf55                	j	80004bd6 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c24:	f9042503          	lw	a0,-112(s0)
    80004c28:	00451693          	slli	a3,a0,0x4

  if(write)
    80004c2c:	0001c797          	auipc	a5,0x1c
    80004c30:	96478793          	addi	a5,a5,-1692 # 80020590 <disk>
    80004c34:	00a50713          	addi	a4,a0,10
    80004c38:	0712                	slli	a4,a4,0x4
    80004c3a:	973e                	add	a4,a4,a5
    80004c3c:	01703633          	snez	a2,s7
    80004c40:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004c42:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004c46:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004c4a:	6398                	ld	a4,0(a5)
    80004c4c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c4e:	0a868613          	addi	a2,a3,168
    80004c52:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004c54:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004c56:	6390                	ld	a2,0(a5)
    80004c58:	00d605b3          	add	a1,a2,a3
    80004c5c:	4741                	li	a4,16
    80004c5e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004c60:	4805                	li	a6,1
    80004c62:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004c66:	f9442703          	lw	a4,-108(s0)
    80004c6a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004c6e:	0712                	slli	a4,a4,0x4
    80004c70:	963a                	add	a2,a2,a4
    80004c72:	058a0593          	addi	a1,s4,88
    80004c76:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004c78:	0007b883          	ld	a7,0(a5)
    80004c7c:	9746                	add	a4,a4,a7
    80004c7e:	40000613          	li	a2,1024
    80004c82:	c710                	sw	a2,8(a4)
  if(write)
    80004c84:	001bb613          	seqz	a2,s7
    80004c88:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004c8c:	00166613          	ori	a2,a2,1
    80004c90:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004c94:	f9842583          	lw	a1,-104(s0)
    80004c98:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004c9c:	00250613          	addi	a2,a0,2
    80004ca0:	0612                	slli	a2,a2,0x4
    80004ca2:	963e                	add	a2,a2,a5
    80004ca4:	577d                	li	a4,-1
    80004ca6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004caa:	0592                	slli	a1,a1,0x4
    80004cac:	98ae                	add	a7,a7,a1
    80004cae:	03068713          	addi	a4,a3,48
    80004cb2:	973e                	add	a4,a4,a5
    80004cb4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004cb8:	6398                	ld	a4,0(a5)
    80004cba:	972e                	add	a4,a4,a1
    80004cbc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004cc0:	4689                	li	a3,2
    80004cc2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004cc6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004cca:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004cce:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004cd2:	6794                	ld	a3,8(a5)
    80004cd4:	0026d703          	lhu	a4,2(a3)
    80004cd8:	8b1d                	andi	a4,a4,7
    80004cda:	0706                	slli	a4,a4,0x1
    80004cdc:	96ba                	add	a3,a3,a4
    80004cde:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004ce2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004ce6:	6798                	ld	a4,8(a5)
    80004ce8:	00275783          	lhu	a5,2(a4)
    80004cec:	2785                	addiw	a5,a5,1
    80004cee:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004cf2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004cf6:	100017b7          	lui	a5,0x10001
    80004cfa:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004cfe:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004d02:	0001c917          	auipc	s2,0x1c
    80004d06:	9b690913          	addi	s2,s2,-1610 # 800206b8 <disk+0x128>
  while(b->disk == 1) {
    80004d0a:	4485                	li	s1,1
    80004d0c:	01079a63          	bne	a5,a6,80004d20 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004d10:	85ca                	mv	a1,s2
    80004d12:	8552                	mv	a0,s4
    80004d14:	e2cfc0ef          	jal	80001340 <sleep>
  while(b->disk == 1) {
    80004d18:	004a2783          	lw	a5,4(s4)
    80004d1c:	fe978ae3          	beq	a5,s1,80004d10 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004d20:	f9042903          	lw	s2,-112(s0)
    80004d24:	00290713          	addi	a4,s2,2
    80004d28:	0712                	slli	a4,a4,0x4
    80004d2a:	0001c797          	auipc	a5,0x1c
    80004d2e:	86678793          	addi	a5,a5,-1946 # 80020590 <disk>
    80004d32:	97ba                	add	a5,a5,a4
    80004d34:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004d38:	0001c997          	auipc	s3,0x1c
    80004d3c:	85898993          	addi	s3,s3,-1960 # 80020590 <disk>
    80004d40:	00491713          	slli	a4,s2,0x4
    80004d44:	0009b783          	ld	a5,0(s3)
    80004d48:	97ba                	add	a5,a5,a4
    80004d4a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004d4e:	854a                	mv	a0,s2
    80004d50:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004d54:	bafff0ef          	jal	80004902 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004d58:	8885                	andi	s1,s1,1
    80004d5a:	f0fd                	bnez	s1,80004d40 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004d5c:	0001c517          	auipc	a0,0x1c
    80004d60:	95c50513          	addi	a0,a0,-1700 # 800206b8 <disk+0x128>
    80004d64:	405000ef          	jal	80005968 <release>
}
    80004d68:	70a6                	ld	ra,104(sp)
    80004d6a:	7406                	ld	s0,96(sp)
    80004d6c:	64e6                	ld	s1,88(sp)
    80004d6e:	6946                	ld	s2,80(sp)
    80004d70:	69a6                	ld	s3,72(sp)
    80004d72:	6a06                	ld	s4,64(sp)
    80004d74:	7ae2                	ld	s5,56(sp)
    80004d76:	7b42                	ld	s6,48(sp)
    80004d78:	7ba2                	ld	s7,40(sp)
    80004d7a:	7c02                	ld	s8,32(sp)
    80004d7c:	6ce2                	ld	s9,24(sp)
    80004d7e:	6165                	addi	sp,sp,112
    80004d80:	8082                	ret

0000000080004d82 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004d82:	1101                	addi	sp,sp,-32
    80004d84:	ec06                	sd	ra,24(sp)
    80004d86:	e822                	sd	s0,16(sp)
    80004d88:	e426                	sd	s1,8(sp)
    80004d8a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004d8c:	0001c497          	auipc	s1,0x1c
    80004d90:	80448493          	addi	s1,s1,-2044 # 80020590 <disk>
    80004d94:	0001c517          	auipc	a0,0x1c
    80004d98:	92450513          	addi	a0,a0,-1756 # 800206b8 <disk+0x128>
    80004d9c:	335000ef          	jal	800058d0 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004da0:	100017b7          	lui	a5,0x10001
    80004da4:	53b8                	lw	a4,96(a5)
    80004da6:	8b0d                	andi	a4,a4,3
    80004da8:	100017b7          	lui	a5,0x10001
    80004dac:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004dae:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004db2:	689c                	ld	a5,16(s1)
    80004db4:	0204d703          	lhu	a4,32(s1)
    80004db8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004dbc:	04f70663          	beq	a4,a5,80004e08 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004dc0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004dc4:	6898                	ld	a4,16(s1)
    80004dc6:	0204d783          	lhu	a5,32(s1)
    80004dca:	8b9d                	andi	a5,a5,7
    80004dcc:	078e                	slli	a5,a5,0x3
    80004dce:	97ba                	add	a5,a5,a4
    80004dd0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004dd2:	00278713          	addi	a4,a5,2
    80004dd6:	0712                	slli	a4,a4,0x4
    80004dd8:	9726                	add	a4,a4,s1
    80004dda:	01074703          	lbu	a4,16(a4)
    80004dde:	e321                	bnez	a4,80004e1e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004de0:	0789                	addi	a5,a5,2
    80004de2:	0792                	slli	a5,a5,0x4
    80004de4:	97a6                	add	a5,a5,s1
    80004de6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004de8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004dec:	da0fc0ef          	jal	8000138c <wakeup>

    disk.used_idx += 1;
    80004df0:	0204d783          	lhu	a5,32(s1)
    80004df4:	2785                	addiw	a5,a5,1
    80004df6:	17c2                	slli	a5,a5,0x30
    80004df8:	93c1                	srli	a5,a5,0x30
    80004dfa:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004dfe:	6898                	ld	a4,16(s1)
    80004e00:	00275703          	lhu	a4,2(a4)
    80004e04:	faf71ee3          	bne	a4,a5,80004dc0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004e08:	0001c517          	auipc	a0,0x1c
    80004e0c:	8b050513          	addi	a0,a0,-1872 # 800206b8 <disk+0x128>
    80004e10:	359000ef          	jal	80005968 <release>
}
    80004e14:	60e2                	ld	ra,24(sp)
    80004e16:	6442                	ld	s0,16(sp)
    80004e18:	64a2                	ld	s1,8(sp)
    80004e1a:	6105                	addi	sp,sp,32
    80004e1c:	8082                	ret
      panic("virtio_disk_intr status");
    80004e1e:	00003517          	auipc	a0,0x3
    80004e22:	9e250513          	addi	a0,a0,-1566 # 80007800 <etext+0x800>
    80004e26:	77c000ef          	jal	800055a2 <panic>

0000000080004e2a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004e2a:	1141                	addi	sp,sp,-16
    80004e2c:	e422                	sd	s0,8(sp)
    80004e2e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004e30:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004e34:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004e38:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004e3c:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004e40:	577d                	li	a4,-1
    80004e42:	177e                	slli	a4,a4,0x3f
    80004e44:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004e46:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004e4a:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004e4e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004e52:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004e56:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004e5a:	000f4737          	lui	a4,0xf4
    80004e5e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004e62:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004e64:	14d79073          	csrw	stimecmp,a5
}
    80004e68:	6422                	ld	s0,8(sp)
    80004e6a:	0141                	addi	sp,sp,16
    80004e6c:	8082                	ret

0000000080004e6e <start>:
{
    80004e6e:	1141                	addi	sp,sp,-16
    80004e70:	e406                	sd	ra,8(sp)
    80004e72:	e022                	sd	s0,0(sp)
    80004e74:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004e76:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004e7a:	7779                	lui	a4,0xffffe
    80004e7c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd602f>
    80004e80:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004e82:	6705                	lui	a4,0x1
    80004e84:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004e88:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004e8a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004e8e:	ffffb797          	auipc	a5,0xffffb
    80004e92:	45a78793          	addi	a5,a5,1114 # 800002e8 <main>
    80004e96:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004e9a:	4781                	li	a5,0
    80004e9c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004ea0:	67c1                	lui	a5,0x10
    80004ea2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004ea4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004ea8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004eac:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004eb0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004eb4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004eb8:	57fd                	li	a5,-1
    80004eba:	83a9                	srli	a5,a5,0xa
    80004ebc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004ec0:	47bd                	li	a5,15
    80004ec2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004ec6:	f65ff0ef          	jal	80004e2a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004eca:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004ece:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004ed0:	823e                	mv	tp,a5
  asm volatile("mret");
    80004ed2:	30200073          	mret
}
    80004ed6:	60a2                	ld	ra,8(sp)
    80004ed8:	6402                	ld	s0,0(sp)
    80004eda:	0141                	addi	sp,sp,16
    80004edc:	8082                	ret

0000000080004ede <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004ede:	715d                	addi	sp,sp,-80
    80004ee0:	e486                	sd	ra,72(sp)
    80004ee2:	e0a2                	sd	s0,64(sp)
    80004ee4:	f84a                	sd	s2,48(sp)
    80004ee6:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80004ee8:	04c05263          	blez	a2,80004f2c <consolewrite+0x4e>
    80004eec:	fc26                	sd	s1,56(sp)
    80004eee:	f44e                	sd	s3,40(sp)
    80004ef0:	f052                	sd	s4,32(sp)
    80004ef2:	ec56                	sd	s5,24(sp)
    80004ef4:	8a2a                	mv	s4,a0
    80004ef6:	84ae                	mv	s1,a1
    80004ef8:	89b2                	mv	s3,a2
    80004efa:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004efc:	5afd                	li	s5,-1
    80004efe:	4685                	li	a3,1
    80004f00:	8626                	mv	a2,s1
    80004f02:	85d2                	mv	a1,s4
    80004f04:	fbf40513          	addi	a0,s0,-65
    80004f08:	fdefc0ef          	jal	800016e6 <either_copyin>
    80004f0c:	03550263          	beq	a0,s5,80004f30 <consolewrite+0x52>
      break;
    uartputc(c);
    80004f10:	fbf44503          	lbu	a0,-65(s0)
    80004f14:	035000ef          	jal	80005748 <uartputc>
  for(i = 0; i < n; i++){
    80004f18:	2905                	addiw	s2,s2,1
    80004f1a:	0485                	addi	s1,s1,1
    80004f1c:	ff2991e3          	bne	s3,s2,80004efe <consolewrite+0x20>
    80004f20:	894e                	mv	s2,s3
    80004f22:	74e2                	ld	s1,56(sp)
    80004f24:	79a2                	ld	s3,40(sp)
    80004f26:	7a02                	ld	s4,32(sp)
    80004f28:	6ae2                	ld	s5,24(sp)
    80004f2a:	a039                	j	80004f38 <consolewrite+0x5a>
    80004f2c:	4901                	li	s2,0
    80004f2e:	a029                	j	80004f38 <consolewrite+0x5a>
    80004f30:	74e2                	ld	s1,56(sp)
    80004f32:	79a2                	ld	s3,40(sp)
    80004f34:	7a02                	ld	s4,32(sp)
    80004f36:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80004f38:	854a                	mv	a0,s2
    80004f3a:	60a6                	ld	ra,72(sp)
    80004f3c:	6406                	ld	s0,64(sp)
    80004f3e:	7942                	ld	s2,48(sp)
    80004f40:	6161                	addi	sp,sp,80
    80004f42:	8082                	ret

0000000080004f44 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004f44:	711d                	addi	sp,sp,-96
    80004f46:	ec86                	sd	ra,88(sp)
    80004f48:	e8a2                	sd	s0,80(sp)
    80004f4a:	e4a6                	sd	s1,72(sp)
    80004f4c:	e0ca                	sd	s2,64(sp)
    80004f4e:	fc4e                	sd	s3,56(sp)
    80004f50:	f852                	sd	s4,48(sp)
    80004f52:	f456                	sd	s5,40(sp)
    80004f54:	f05a                	sd	s6,32(sp)
    80004f56:	1080                	addi	s0,sp,96
    80004f58:	8aaa                	mv	s5,a0
    80004f5a:	8a2e                	mv	s4,a1
    80004f5c:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004f5e:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80004f62:	00023517          	auipc	a0,0x23
    80004f66:	76e50513          	addi	a0,a0,1902 # 800286d0 <cons>
    80004f6a:	167000ef          	jal	800058d0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004f6e:	00023497          	auipc	s1,0x23
    80004f72:	76248493          	addi	s1,s1,1890 # 800286d0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004f76:	00023917          	auipc	s2,0x23
    80004f7a:	7f290913          	addi	s2,s2,2034 # 80028768 <cons+0x98>
  while(n > 0){
    80004f7e:	0b305d63          	blez	s3,80005038 <consoleread+0xf4>
    while(cons.r == cons.w){
    80004f82:	0984a783          	lw	a5,152(s1)
    80004f86:	09c4a703          	lw	a4,156(s1)
    80004f8a:	0af71263          	bne	a4,a5,8000502e <consoleread+0xea>
      if(killed(myproc())){
    80004f8e:	dcdfb0ef          	jal	80000d5a <myproc>
    80004f92:	de6fc0ef          	jal	80001578 <killed>
    80004f96:	e12d                	bnez	a0,80004ff8 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80004f98:	85a6                	mv	a1,s1
    80004f9a:	854a                	mv	a0,s2
    80004f9c:	ba4fc0ef          	jal	80001340 <sleep>
    while(cons.r == cons.w){
    80004fa0:	0984a783          	lw	a5,152(s1)
    80004fa4:	09c4a703          	lw	a4,156(s1)
    80004fa8:	fef703e3          	beq	a4,a5,80004f8e <consoleread+0x4a>
    80004fac:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004fae:	00023717          	auipc	a4,0x23
    80004fb2:	72270713          	addi	a4,a4,1826 # 800286d0 <cons>
    80004fb6:	0017869b          	addiw	a3,a5,1
    80004fba:	08d72c23          	sw	a3,152(a4)
    80004fbe:	07f7f693          	andi	a3,a5,127
    80004fc2:	9736                	add	a4,a4,a3
    80004fc4:	01874703          	lbu	a4,24(a4)
    80004fc8:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004fcc:	4691                	li	a3,4
    80004fce:	04db8663          	beq	s7,a3,8000501a <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80004fd2:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004fd6:	4685                	li	a3,1
    80004fd8:	faf40613          	addi	a2,s0,-81
    80004fdc:	85d2                	mv	a1,s4
    80004fde:	8556                	mv	a0,s5
    80004fe0:	ebcfc0ef          	jal	8000169c <either_copyout>
    80004fe4:	57fd                	li	a5,-1
    80004fe6:	04f50863          	beq	a0,a5,80005036 <consoleread+0xf2>
      break;

    dst++;
    80004fea:	0a05                	addi	s4,s4,1
    --n;
    80004fec:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80004fee:	47a9                	li	a5,10
    80004ff0:	04fb8d63          	beq	s7,a5,8000504a <consoleread+0x106>
    80004ff4:	6be2                	ld	s7,24(sp)
    80004ff6:	b761                	j	80004f7e <consoleread+0x3a>
        release(&cons.lock);
    80004ff8:	00023517          	auipc	a0,0x23
    80004ffc:	6d850513          	addi	a0,a0,1752 # 800286d0 <cons>
    80005000:	169000ef          	jal	80005968 <release>
        return -1;
    80005004:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005006:	60e6                	ld	ra,88(sp)
    80005008:	6446                	ld	s0,80(sp)
    8000500a:	64a6                	ld	s1,72(sp)
    8000500c:	6906                	ld	s2,64(sp)
    8000500e:	79e2                	ld	s3,56(sp)
    80005010:	7a42                	ld	s4,48(sp)
    80005012:	7aa2                	ld	s5,40(sp)
    80005014:	7b02                	ld	s6,32(sp)
    80005016:	6125                	addi	sp,sp,96
    80005018:	8082                	ret
      if(n < target){
    8000501a:	0009871b          	sext.w	a4,s3
    8000501e:	01677a63          	bgeu	a4,s6,80005032 <consoleread+0xee>
        cons.r--;
    80005022:	00023717          	auipc	a4,0x23
    80005026:	74f72323          	sw	a5,1862(a4) # 80028768 <cons+0x98>
    8000502a:	6be2                	ld	s7,24(sp)
    8000502c:	a031                	j	80005038 <consoleread+0xf4>
    8000502e:	ec5e                	sd	s7,24(sp)
    80005030:	bfbd                	j	80004fae <consoleread+0x6a>
    80005032:	6be2                	ld	s7,24(sp)
    80005034:	a011                	j	80005038 <consoleread+0xf4>
    80005036:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005038:	00023517          	auipc	a0,0x23
    8000503c:	69850513          	addi	a0,a0,1688 # 800286d0 <cons>
    80005040:	129000ef          	jal	80005968 <release>
  return target - n;
    80005044:	413b053b          	subw	a0,s6,s3
    80005048:	bf7d                	j	80005006 <consoleread+0xc2>
    8000504a:	6be2                	ld	s7,24(sp)
    8000504c:	b7f5                	j	80005038 <consoleread+0xf4>

000000008000504e <consputc>:
{
    8000504e:	1141                	addi	sp,sp,-16
    80005050:	e406                	sd	ra,8(sp)
    80005052:	e022                	sd	s0,0(sp)
    80005054:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005056:	10000793          	li	a5,256
    8000505a:	00f50863          	beq	a0,a5,8000506a <consputc+0x1c>
    uartputc_sync(c);
    8000505e:	604000ef          	jal	80005662 <uartputc_sync>
}
    80005062:	60a2                	ld	ra,8(sp)
    80005064:	6402                	ld	s0,0(sp)
    80005066:	0141                	addi	sp,sp,16
    80005068:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000506a:	4521                	li	a0,8
    8000506c:	5f6000ef          	jal	80005662 <uartputc_sync>
    80005070:	02000513          	li	a0,32
    80005074:	5ee000ef          	jal	80005662 <uartputc_sync>
    80005078:	4521                	li	a0,8
    8000507a:	5e8000ef          	jal	80005662 <uartputc_sync>
    8000507e:	b7d5                	j	80005062 <consputc+0x14>

0000000080005080 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005080:	1101                	addi	sp,sp,-32
    80005082:	ec06                	sd	ra,24(sp)
    80005084:	e822                	sd	s0,16(sp)
    80005086:	e426                	sd	s1,8(sp)
    80005088:	1000                	addi	s0,sp,32
    8000508a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000508c:	00023517          	auipc	a0,0x23
    80005090:	64450513          	addi	a0,a0,1604 # 800286d0 <cons>
    80005094:	03d000ef          	jal	800058d0 <acquire>

  switch(c){
    80005098:	47d5                	li	a5,21
    8000509a:	08f48f63          	beq	s1,a5,80005138 <consoleintr+0xb8>
    8000509e:	0297c563          	blt	a5,s1,800050c8 <consoleintr+0x48>
    800050a2:	47a1                	li	a5,8
    800050a4:	0ef48463          	beq	s1,a5,8000518c <consoleintr+0x10c>
    800050a8:	47c1                	li	a5,16
    800050aa:	10f49563          	bne	s1,a5,800051b4 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    800050ae:	e82fc0ef          	jal	80001730 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800050b2:	00023517          	auipc	a0,0x23
    800050b6:	61e50513          	addi	a0,a0,1566 # 800286d0 <cons>
    800050ba:	0af000ef          	jal	80005968 <release>
}
    800050be:	60e2                	ld	ra,24(sp)
    800050c0:	6442                	ld	s0,16(sp)
    800050c2:	64a2                	ld	s1,8(sp)
    800050c4:	6105                	addi	sp,sp,32
    800050c6:	8082                	ret
  switch(c){
    800050c8:	07f00793          	li	a5,127
    800050cc:	0cf48063          	beq	s1,a5,8000518c <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800050d0:	00023717          	auipc	a4,0x23
    800050d4:	60070713          	addi	a4,a4,1536 # 800286d0 <cons>
    800050d8:	0a072783          	lw	a5,160(a4)
    800050dc:	09872703          	lw	a4,152(a4)
    800050e0:	9f99                	subw	a5,a5,a4
    800050e2:	07f00713          	li	a4,127
    800050e6:	fcf766e3          	bltu	a4,a5,800050b2 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800050ea:	47b5                	li	a5,13
    800050ec:	0cf48763          	beq	s1,a5,800051ba <consoleintr+0x13a>
      consputc(c);
    800050f0:	8526                	mv	a0,s1
    800050f2:	f5dff0ef          	jal	8000504e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800050f6:	00023797          	auipc	a5,0x23
    800050fa:	5da78793          	addi	a5,a5,1498 # 800286d0 <cons>
    800050fe:	0a07a683          	lw	a3,160(a5)
    80005102:	0016871b          	addiw	a4,a3,1
    80005106:	0007061b          	sext.w	a2,a4
    8000510a:	0ae7a023          	sw	a4,160(a5)
    8000510e:	07f6f693          	andi	a3,a3,127
    80005112:	97b6                	add	a5,a5,a3
    80005114:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005118:	47a9                	li	a5,10
    8000511a:	0cf48563          	beq	s1,a5,800051e4 <consoleintr+0x164>
    8000511e:	4791                	li	a5,4
    80005120:	0cf48263          	beq	s1,a5,800051e4 <consoleintr+0x164>
    80005124:	00023797          	auipc	a5,0x23
    80005128:	6447a783          	lw	a5,1604(a5) # 80028768 <cons+0x98>
    8000512c:	9f1d                	subw	a4,a4,a5
    8000512e:	08000793          	li	a5,128
    80005132:	f8f710e3          	bne	a4,a5,800050b2 <consoleintr+0x32>
    80005136:	a07d                	j	800051e4 <consoleintr+0x164>
    80005138:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000513a:	00023717          	auipc	a4,0x23
    8000513e:	59670713          	addi	a4,a4,1430 # 800286d0 <cons>
    80005142:	0a072783          	lw	a5,160(a4)
    80005146:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000514a:	00023497          	auipc	s1,0x23
    8000514e:	58648493          	addi	s1,s1,1414 # 800286d0 <cons>
    while(cons.e != cons.w &&
    80005152:	4929                	li	s2,10
    80005154:	02f70863          	beq	a4,a5,80005184 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005158:	37fd                	addiw	a5,a5,-1
    8000515a:	07f7f713          	andi	a4,a5,127
    8000515e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005160:	01874703          	lbu	a4,24(a4)
    80005164:	03270263          	beq	a4,s2,80005188 <consoleintr+0x108>
      cons.e--;
    80005168:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000516c:	10000513          	li	a0,256
    80005170:	edfff0ef          	jal	8000504e <consputc>
    while(cons.e != cons.w &&
    80005174:	0a04a783          	lw	a5,160(s1)
    80005178:	09c4a703          	lw	a4,156(s1)
    8000517c:	fcf71ee3          	bne	a4,a5,80005158 <consoleintr+0xd8>
    80005180:	6902                	ld	s2,0(sp)
    80005182:	bf05                	j	800050b2 <consoleintr+0x32>
    80005184:	6902                	ld	s2,0(sp)
    80005186:	b735                	j	800050b2 <consoleintr+0x32>
    80005188:	6902                	ld	s2,0(sp)
    8000518a:	b725                	j	800050b2 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000518c:	00023717          	auipc	a4,0x23
    80005190:	54470713          	addi	a4,a4,1348 # 800286d0 <cons>
    80005194:	0a072783          	lw	a5,160(a4)
    80005198:	09c72703          	lw	a4,156(a4)
    8000519c:	f0f70be3          	beq	a4,a5,800050b2 <consoleintr+0x32>
      cons.e--;
    800051a0:	37fd                	addiw	a5,a5,-1
    800051a2:	00023717          	auipc	a4,0x23
    800051a6:	5cf72723          	sw	a5,1486(a4) # 80028770 <cons+0xa0>
      consputc(BACKSPACE);
    800051aa:	10000513          	li	a0,256
    800051ae:	ea1ff0ef          	jal	8000504e <consputc>
    800051b2:	b701                	j	800050b2 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800051b4:	ee048fe3          	beqz	s1,800050b2 <consoleintr+0x32>
    800051b8:	bf21                	j	800050d0 <consoleintr+0x50>
      consputc(c);
    800051ba:	4529                	li	a0,10
    800051bc:	e93ff0ef          	jal	8000504e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800051c0:	00023797          	auipc	a5,0x23
    800051c4:	51078793          	addi	a5,a5,1296 # 800286d0 <cons>
    800051c8:	0a07a703          	lw	a4,160(a5)
    800051cc:	0017069b          	addiw	a3,a4,1
    800051d0:	0006861b          	sext.w	a2,a3
    800051d4:	0ad7a023          	sw	a3,160(a5)
    800051d8:	07f77713          	andi	a4,a4,127
    800051dc:	97ba                	add	a5,a5,a4
    800051de:	4729                	li	a4,10
    800051e0:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800051e4:	00023797          	auipc	a5,0x23
    800051e8:	58c7a423          	sw	a2,1416(a5) # 8002876c <cons+0x9c>
        wakeup(&cons.r);
    800051ec:	00023517          	auipc	a0,0x23
    800051f0:	57c50513          	addi	a0,a0,1404 # 80028768 <cons+0x98>
    800051f4:	998fc0ef          	jal	8000138c <wakeup>
    800051f8:	bd6d                	j	800050b2 <consoleintr+0x32>

00000000800051fa <consoleinit>:

void
consoleinit(void)
{
    800051fa:	1141                	addi	sp,sp,-16
    800051fc:	e406                	sd	ra,8(sp)
    800051fe:	e022                	sd	s0,0(sp)
    80005200:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005202:	00002597          	auipc	a1,0x2
    80005206:	61658593          	addi	a1,a1,1558 # 80007818 <etext+0x818>
    8000520a:	00023517          	auipc	a0,0x23
    8000520e:	4c650513          	addi	a0,a0,1222 # 800286d0 <cons>
    80005212:	63e000ef          	jal	80005850 <initlock>

  uartinit();
    80005216:	3f4000ef          	jal	8000560a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000521a:	0001a797          	auipc	a5,0x1a
    8000521e:	31e78793          	addi	a5,a5,798 # 8001f538 <devsw>
    80005222:	00000717          	auipc	a4,0x0
    80005226:	d2270713          	addi	a4,a4,-734 # 80004f44 <consoleread>
    8000522a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000522c:	00000717          	auipc	a4,0x0
    80005230:	cb270713          	addi	a4,a4,-846 # 80004ede <consolewrite>
    80005234:	ef98                	sd	a4,24(a5)
}
    80005236:	60a2                	ld	ra,8(sp)
    80005238:	6402                	ld	s0,0(sp)
    8000523a:	0141                	addi	sp,sp,16
    8000523c:	8082                	ret

000000008000523e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000523e:	7179                	addi	sp,sp,-48
    80005240:	f406                	sd	ra,40(sp)
    80005242:	f022                	sd	s0,32(sp)
    80005244:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005246:	c219                	beqz	a2,8000524c <printint+0xe>
    80005248:	08054063          	bltz	a0,800052c8 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000524c:	4881                	li	a7,0
    8000524e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005252:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005254:	00002617          	auipc	a2,0x2
    80005258:	7fc60613          	addi	a2,a2,2044 # 80007a50 <digits>
    8000525c:	883e                	mv	a6,a5
    8000525e:	2785                	addiw	a5,a5,1
    80005260:	02b57733          	remu	a4,a0,a1
    80005264:	9732                	add	a4,a4,a2
    80005266:	00074703          	lbu	a4,0(a4)
    8000526a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000526e:	872a                	mv	a4,a0
    80005270:	02b55533          	divu	a0,a0,a1
    80005274:	0685                	addi	a3,a3,1
    80005276:	feb773e3          	bgeu	a4,a1,8000525c <printint+0x1e>

  if(sign)
    8000527a:	00088a63          	beqz	a7,8000528e <printint+0x50>
    buf[i++] = '-';
    8000527e:	1781                	addi	a5,a5,-32
    80005280:	97a2                	add	a5,a5,s0
    80005282:	02d00713          	li	a4,45
    80005286:	fee78823          	sb	a4,-16(a5)
    8000528a:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    8000528e:	02f05963          	blez	a5,800052c0 <printint+0x82>
    80005292:	ec26                	sd	s1,24(sp)
    80005294:	e84a                	sd	s2,16(sp)
    80005296:	fd040713          	addi	a4,s0,-48
    8000529a:	00f704b3          	add	s1,a4,a5
    8000529e:	fff70913          	addi	s2,a4,-1
    800052a2:	993e                	add	s2,s2,a5
    800052a4:	37fd                	addiw	a5,a5,-1
    800052a6:	1782                	slli	a5,a5,0x20
    800052a8:	9381                	srli	a5,a5,0x20
    800052aa:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800052ae:	fff4c503          	lbu	a0,-1(s1)
    800052b2:	d9dff0ef          	jal	8000504e <consputc>
  while(--i >= 0)
    800052b6:	14fd                	addi	s1,s1,-1
    800052b8:	ff249be3          	bne	s1,s2,800052ae <printint+0x70>
    800052bc:	64e2                	ld	s1,24(sp)
    800052be:	6942                	ld	s2,16(sp)
}
    800052c0:	70a2                	ld	ra,40(sp)
    800052c2:	7402                	ld	s0,32(sp)
    800052c4:	6145                	addi	sp,sp,48
    800052c6:	8082                	ret
    x = -xx;
    800052c8:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800052cc:	4885                	li	a7,1
    x = -xx;
    800052ce:	b741                	j	8000524e <printint+0x10>

00000000800052d0 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800052d0:	7155                	addi	sp,sp,-208
    800052d2:	e506                	sd	ra,136(sp)
    800052d4:	e122                	sd	s0,128(sp)
    800052d6:	f0d2                	sd	s4,96(sp)
    800052d8:	0900                	addi	s0,sp,144
    800052da:	8a2a                	mv	s4,a0
    800052dc:	e40c                	sd	a1,8(s0)
    800052de:	e810                	sd	a2,16(s0)
    800052e0:	ec14                	sd	a3,24(s0)
    800052e2:	f018                	sd	a4,32(s0)
    800052e4:	f41c                	sd	a5,40(s0)
    800052e6:	03043823          	sd	a6,48(s0)
    800052ea:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800052ee:	00023797          	auipc	a5,0x23
    800052f2:	4a27a783          	lw	a5,1186(a5) # 80028790 <pr+0x18>
    800052f6:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800052fa:	e3a1                	bnez	a5,8000533a <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800052fc:	00840793          	addi	a5,s0,8
    80005300:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005304:	00054503          	lbu	a0,0(a0)
    80005308:	26050763          	beqz	a0,80005576 <printf+0x2a6>
    8000530c:	fca6                	sd	s1,120(sp)
    8000530e:	f8ca                	sd	s2,112(sp)
    80005310:	f4ce                	sd	s3,104(sp)
    80005312:	ecd6                	sd	s5,88(sp)
    80005314:	e8da                	sd	s6,80(sp)
    80005316:	e0e2                	sd	s8,64(sp)
    80005318:	fc66                	sd	s9,56(sp)
    8000531a:	f86a                	sd	s10,48(sp)
    8000531c:	f46e                	sd	s11,40(sp)
    8000531e:	4981                	li	s3,0
    if(cx != '%'){
    80005320:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005324:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005328:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000532c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005330:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005334:	07000d93          	li	s11,112
    80005338:	a815                	j	8000536c <printf+0x9c>
    acquire(&pr.lock);
    8000533a:	00023517          	auipc	a0,0x23
    8000533e:	43e50513          	addi	a0,a0,1086 # 80028778 <pr>
    80005342:	58e000ef          	jal	800058d0 <acquire>
  va_start(ap, fmt);
    80005346:	00840793          	addi	a5,s0,8
    8000534a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000534e:	000a4503          	lbu	a0,0(s4)
    80005352:	fd4d                	bnez	a0,8000530c <printf+0x3c>
    80005354:	a481                	j	80005594 <printf+0x2c4>
      consputc(cx);
    80005356:	cf9ff0ef          	jal	8000504e <consputc>
      continue;
    8000535a:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000535c:	0014899b          	addiw	s3,s1,1
    80005360:	013a07b3          	add	a5,s4,s3
    80005364:	0007c503          	lbu	a0,0(a5)
    80005368:	1e050b63          	beqz	a0,8000555e <printf+0x28e>
    if(cx != '%'){
    8000536c:	ff5515e3          	bne	a0,s5,80005356 <printf+0x86>
    i++;
    80005370:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80005374:	009a07b3          	add	a5,s4,s1
    80005378:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000537c:	1e090163          	beqz	s2,8000555e <printf+0x28e>
    80005380:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80005384:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80005386:	c789                	beqz	a5,80005390 <printf+0xc0>
    80005388:	009a0733          	add	a4,s4,s1
    8000538c:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80005390:	03690763          	beq	s2,s6,800053be <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80005394:	05890163          	beq	s2,s8,800053d6 <printf+0x106>
    } else if(c0 == 'u'){
    80005398:	0d990b63          	beq	s2,s9,8000546e <printf+0x19e>
    } else if(c0 == 'x'){
    8000539c:	13a90163          	beq	s2,s10,800054be <printf+0x1ee>
    } else if(c0 == 'p'){
    800053a0:	13b90b63          	beq	s2,s11,800054d6 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800053a4:	07300793          	li	a5,115
    800053a8:	16f90a63          	beq	s2,a5,8000551c <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800053ac:	1b590463          	beq	s2,s5,80005554 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800053b0:	8556                	mv	a0,s5
    800053b2:	c9dff0ef          	jal	8000504e <consputc>
      consputc(c0);
    800053b6:	854a                	mv	a0,s2
    800053b8:	c97ff0ef          	jal	8000504e <consputc>
    800053bc:	b745                	j	8000535c <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800053be:	f8843783          	ld	a5,-120(s0)
    800053c2:	00878713          	addi	a4,a5,8
    800053c6:	f8e43423          	sd	a4,-120(s0)
    800053ca:	4605                	li	a2,1
    800053cc:	45a9                	li	a1,10
    800053ce:	4388                	lw	a0,0(a5)
    800053d0:	e6fff0ef          	jal	8000523e <printint>
    800053d4:	b761                	j	8000535c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800053d6:	03678663          	beq	a5,s6,80005402 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800053da:	05878263          	beq	a5,s8,8000541e <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    800053de:	0b978463          	beq	a5,s9,80005486 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    800053e2:	fda797e3          	bne	a5,s10,800053b0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800053e6:	f8843783          	ld	a5,-120(s0)
    800053ea:	00878713          	addi	a4,a5,8
    800053ee:	f8e43423          	sd	a4,-120(s0)
    800053f2:	4601                	li	a2,0
    800053f4:	45c1                	li	a1,16
    800053f6:	6388                	ld	a0,0(a5)
    800053f8:	e47ff0ef          	jal	8000523e <printint>
      i += 1;
    800053fc:	0029849b          	addiw	s1,s3,2
    80005400:	bfb1                	j	8000535c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005402:	f8843783          	ld	a5,-120(s0)
    80005406:	00878713          	addi	a4,a5,8
    8000540a:	f8e43423          	sd	a4,-120(s0)
    8000540e:	4605                	li	a2,1
    80005410:	45a9                	li	a1,10
    80005412:	6388                	ld	a0,0(a5)
    80005414:	e2bff0ef          	jal	8000523e <printint>
      i += 1;
    80005418:	0029849b          	addiw	s1,s3,2
    8000541c:	b781                	j	8000535c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000541e:	06400793          	li	a5,100
    80005422:	02f68863          	beq	a3,a5,80005452 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005426:	07500793          	li	a5,117
    8000542a:	06f68c63          	beq	a3,a5,800054a2 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000542e:	07800793          	li	a5,120
    80005432:	f6f69fe3          	bne	a3,a5,800053b0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005436:	f8843783          	ld	a5,-120(s0)
    8000543a:	00878713          	addi	a4,a5,8
    8000543e:	f8e43423          	sd	a4,-120(s0)
    80005442:	4601                	li	a2,0
    80005444:	45c1                	li	a1,16
    80005446:	6388                	ld	a0,0(a5)
    80005448:	df7ff0ef          	jal	8000523e <printint>
      i += 2;
    8000544c:	0039849b          	addiw	s1,s3,3
    80005450:	b731                	j	8000535c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005452:	f8843783          	ld	a5,-120(s0)
    80005456:	00878713          	addi	a4,a5,8
    8000545a:	f8e43423          	sd	a4,-120(s0)
    8000545e:	4605                	li	a2,1
    80005460:	45a9                	li	a1,10
    80005462:	6388                	ld	a0,0(a5)
    80005464:	ddbff0ef          	jal	8000523e <printint>
      i += 2;
    80005468:	0039849b          	addiw	s1,s3,3
    8000546c:	bdc5                	j	8000535c <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    8000546e:	f8843783          	ld	a5,-120(s0)
    80005472:	00878713          	addi	a4,a5,8
    80005476:	f8e43423          	sd	a4,-120(s0)
    8000547a:	4601                	li	a2,0
    8000547c:	45a9                	li	a1,10
    8000547e:	4388                	lw	a0,0(a5)
    80005480:	dbfff0ef          	jal	8000523e <printint>
    80005484:	bde1                	j	8000535c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005486:	f8843783          	ld	a5,-120(s0)
    8000548a:	00878713          	addi	a4,a5,8
    8000548e:	f8e43423          	sd	a4,-120(s0)
    80005492:	4601                	li	a2,0
    80005494:	45a9                	li	a1,10
    80005496:	6388                	ld	a0,0(a5)
    80005498:	da7ff0ef          	jal	8000523e <printint>
      i += 1;
    8000549c:	0029849b          	addiw	s1,s3,2
    800054a0:	bd75                	j	8000535c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800054a2:	f8843783          	ld	a5,-120(s0)
    800054a6:	00878713          	addi	a4,a5,8
    800054aa:	f8e43423          	sd	a4,-120(s0)
    800054ae:	4601                	li	a2,0
    800054b0:	45a9                	li	a1,10
    800054b2:	6388                	ld	a0,0(a5)
    800054b4:	d8bff0ef          	jal	8000523e <printint>
      i += 2;
    800054b8:	0039849b          	addiw	s1,s3,3
    800054bc:	b545                	j	8000535c <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800054be:	f8843783          	ld	a5,-120(s0)
    800054c2:	00878713          	addi	a4,a5,8
    800054c6:	f8e43423          	sd	a4,-120(s0)
    800054ca:	4601                	li	a2,0
    800054cc:	45c1                	li	a1,16
    800054ce:	4388                	lw	a0,0(a5)
    800054d0:	d6fff0ef          	jal	8000523e <printint>
    800054d4:	b561                	j	8000535c <printf+0x8c>
    800054d6:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800054d8:	f8843783          	ld	a5,-120(s0)
    800054dc:	00878713          	addi	a4,a5,8
    800054e0:	f8e43423          	sd	a4,-120(s0)
    800054e4:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800054e8:	03000513          	li	a0,48
    800054ec:	b63ff0ef          	jal	8000504e <consputc>
  consputc('x');
    800054f0:	07800513          	li	a0,120
    800054f4:	b5bff0ef          	jal	8000504e <consputc>
    800054f8:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800054fa:	00002b97          	auipc	s7,0x2
    800054fe:	556b8b93          	addi	s7,s7,1366 # 80007a50 <digits>
    80005502:	03c9d793          	srli	a5,s3,0x3c
    80005506:	97de                	add	a5,a5,s7
    80005508:	0007c503          	lbu	a0,0(a5)
    8000550c:	b43ff0ef          	jal	8000504e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005510:	0992                	slli	s3,s3,0x4
    80005512:	397d                	addiw	s2,s2,-1
    80005514:	fe0917e3          	bnez	s2,80005502 <printf+0x232>
    80005518:	6ba6                	ld	s7,72(sp)
    8000551a:	b589                	j	8000535c <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000551c:	f8843783          	ld	a5,-120(s0)
    80005520:	00878713          	addi	a4,a5,8
    80005524:	f8e43423          	sd	a4,-120(s0)
    80005528:	0007b903          	ld	s2,0(a5)
    8000552c:	00090d63          	beqz	s2,80005546 <printf+0x276>
      for(; *s; s++)
    80005530:	00094503          	lbu	a0,0(s2)
    80005534:	e20504e3          	beqz	a0,8000535c <printf+0x8c>
        consputc(*s);
    80005538:	b17ff0ef          	jal	8000504e <consputc>
      for(; *s; s++)
    8000553c:	0905                	addi	s2,s2,1
    8000553e:	00094503          	lbu	a0,0(s2)
    80005542:	f97d                	bnez	a0,80005538 <printf+0x268>
    80005544:	bd21                	j	8000535c <printf+0x8c>
        s = "(null)";
    80005546:	00002917          	auipc	s2,0x2
    8000554a:	2da90913          	addi	s2,s2,730 # 80007820 <etext+0x820>
      for(; *s; s++)
    8000554e:	02800513          	li	a0,40
    80005552:	b7dd                	j	80005538 <printf+0x268>
      consputc('%');
    80005554:	02500513          	li	a0,37
    80005558:	af7ff0ef          	jal	8000504e <consputc>
    8000555c:	b501                	j	8000535c <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    8000555e:	f7843783          	ld	a5,-136(s0)
    80005562:	e385                	bnez	a5,80005582 <printf+0x2b2>
    80005564:	74e6                	ld	s1,120(sp)
    80005566:	7946                	ld	s2,112(sp)
    80005568:	79a6                	ld	s3,104(sp)
    8000556a:	6ae6                	ld	s5,88(sp)
    8000556c:	6b46                	ld	s6,80(sp)
    8000556e:	6c06                	ld	s8,64(sp)
    80005570:	7ce2                	ld	s9,56(sp)
    80005572:	7d42                	ld	s10,48(sp)
    80005574:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80005576:	4501                	li	a0,0
    80005578:	60aa                	ld	ra,136(sp)
    8000557a:	640a                	ld	s0,128(sp)
    8000557c:	7a06                	ld	s4,96(sp)
    8000557e:	6169                	addi	sp,sp,208
    80005580:	8082                	ret
    80005582:	74e6                	ld	s1,120(sp)
    80005584:	7946                	ld	s2,112(sp)
    80005586:	79a6                	ld	s3,104(sp)
    80005588:	6ae6                	ld	s5,88(sp)
    8000558a:	6b46                	ld	s6,80(sp)
    8000558c:	6c06                	ld	s8,64(sp)
    8000558e:	7ce2                	ld	s9,56(sp)
    80005590:	7d42                	ld	s10,48(sp)
    80005592:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005594:	00023517          	auipc	a0,0x23
    80005598:	1e450513          	addi	a0,a0,484 # 80028778 <pr>
    8000559c:	3cc000ef          	jal	80005968 <release>
    800055a0:	bfd9                	j	80005576 <printf+0x2a6>

00000000800055a2 <panic>:

void
panic(char *s)
{
    800055a2:	1101                	addi	sp,sp,-32
    800055a4:	ec06                	sd	ra,24(sp)
    800055a6:	e822                	sd	s0,16(sp)
    800055a8:	e426                	sd	s1,8(sp)
    800055aa:	1000                	addi	s0,sp,32
    800055ac:	84aa                	mv	s1,a0
  pr.locking = 0;
    800055ae:	00023797          	auipc	a5,0x23
    800055b2:	1e07a123          	sw	zero,482(a5) # 80028790 <pr+0x18>
  printf("panic: ");
    800055b6:	00002517          	auipc	a0,0x2
    800055ba:	27250513          	addi	a0,a0,626 # 80007828 <etext+0x828>
    800055be:	d13ff0ef          	jal	800052d0 <printf>
  printf("%s\n", s);
    800055c2:	85a6                	mv	a1,s1
    800055c4:	00002517          	auipc	a0,0x2
    800055c8:	26c50513          	addi	a0,a0,620 # 80007830 <etext+0x830>
    800055cc:	d05ff0ef          	jal	800052d0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800055d0:	4785                	li	a5,1
    800055d2:	00005717          	auipc	a4,0x5
    800055d6:	eaf72d23          	sw	a5,-326(a4) # 8000a48c <panicked>
  for(;;)
    800055da:	a001                	j	800055da <panic+0x38>

00000000800055dc <printfinit>:
    ;
}

void
printfinit(void)
{
    800055dc:	1101                	addi	sp,sp,-32
    800055de:	ec06                	sd	ra,24(sp)
    800055e0:	e822                	sd	s0,16(sp)
    800055e2:	e426                	sd	s1,8(sp)
    800055e4:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800055e6:	00023497          	auipc	s1,0x23
    800055ea:	19248493          	addi	s1,s1,402 # 80028778 <pr>
    800055ee:	00002597          	auipc	a1,0x2
    800055f2:	24a58593          	addi	a1,a1,586 # 80007838 <etext+0x838>
    800055f6:	8526                	mv	a0,s1
    800055f8:	258000ef          	jal	80005850 <initlock>
  pr.locking = 1;
    800055fc:	4785                	li	a5,1
    800055fe:	cc9c                	sw	a5,24(s1)
}
    80005600:	60e2                	ld	ra,24(sp)
    80005602:	6442                	ld	s0,16(sp)
    80005604:	64a2                	ld	s1,8(sp)
    80005606:	6105                	addi	sp,sp,32
    80005608:	8082                	ret

000000008000560a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000560a:	1141                	addi	sp,sp,-16
    8000560c:	e406                	sd	ra,8(sp)
    8000560e:	e022                	sd	s0,0(sp)
    80005610:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005612:	100007b7          	lui	a5,0x10000
    80005616:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000561a:	10000737          	lui	a4,0x10000
    8000561e:	f8000693          	li	a3,-128
    80005622:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005626:	468d                	li	a3,3
    80005628:	10000637          	lui	a2,0x10000
    8000562c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005630:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005634:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005638:	10000737          	lui	a4,0x10000
    8000563c:	461d                	li	a2,7
    8000563e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005642:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005646:	00002597          	auipc	a1,0x2
    8000564a:	1fa58593          	addi	a1,a1,506 # 80007840 <etext+0x840>
    8000564e:	00023517          	auipc	a0,0x23
    80005652:	14a50513          	addi	a0,a0,330 # 80028798 <uart_tx_lock>
    80005656:	1fa000ef          	jal	80005850 <initlock>
}
    8000565a:	60a2                	ld	ra,8(sp)
    8000565c:	6402                	ld	s0,0(sp)
    8000565e:	0141                	addi	sp,sp,16
    80005660:	8082                	ret

0000000080005662 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005662:	1101                	addi	sp,sp,-32
    80005664:	ec06                	sd	ra,24(sp)
    80005666:	e822                	sd	s0,16(sp)
    80005668:	e426                	sd	s1,8(sp)
    8000566a:	1000                	addi	s0,sp,32
    8000566c:	84aa                	mv	s1,a0
  push_off();
    8000566e:	222000ef          	jal	80005890 <push_off>

  if(panicked){
    80005672:	00005797          	auipc	a5,0x5
    80005676:	e1a7a783          	lw	a5,-486(a5) # 8000a48c <panicked>
    8000567a:	e795                	bnez	a5,800056a6 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000567c:	10000737          	lui	a4,0x10000
    80005680:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005682:	00074783          	lbu	a5,0(a4)
    80005686:	0207f793          	andi	a5,a5,32
    8000568a:	dfe5                	beqz	a5,80005682 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000568c:	0ff4f513          	zext.b	a0,s1
    80005690:	100007b7          	lui	a5,0x10000
    80005694:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005698:	27c000ef          	jal	80005914 <pop_off>
}
    8000569c:	60e2                	ld	ra,24(sp)
    8000569e:	6442                	ld	s0,16(sp)
    800056a0:	64a2                	ld	s1,8(sp)
    800056a2:	6105                	addi	sp,sp,32
    800056a4:	8082                	ret
    for(;;)
    800056a6:	a001                	j	800056a6 <uartputc_sync+0x44>

00000000800056a8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800056a8:	00005797          	auipc	a5,0x5
    800056ac:	de87b783          	ld	a5,-536(a5) # 8000a490 <uart_tx_r>
    800056b0:	00005717          	auipc	a4,0x5
    800056b4:	de873703          	ld	a4,-536(a4) # 8000a498 <uart_tx_w>
    800056b8:	08f70263          	beq	a4,a5,8000573c <uartstart+0x94>
{
    800056bc:	7139                	addi	sp,sp,-64
    800056be:	fc06                	sd	ra,56(sp)
    800056c0:	f822                	sd	s0,48(sp)
    800056c2:	f426                	sd	s1,40(sp)
    800056c4:	f04a                	sd	s2,32(sp)
    800056c6:	ec4e                	sd	s3,24(sp)
    800056c8:	e852                	sd	s4,16(sp)
    800056ca:	e456                	sd	s5,8(sp)
    800056cc:	e05a                	sd	s6,0(sp)
    800056ce:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800056d0:	10000937          	lui	s2,0x10000
    800056d4:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800056d6:	00023a97          	auipc	s5,0x23
    800056da:	0c2a8a93          	addi	s5,s5,194 # 80028798 <uart_tx_lock>
    uart_tx_r += 1;
    800056de:	00005497          	auipc	s1,0x5
    800056e2:	db248493          	addi	s1,s1,-590 # 8000a490 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800056e6:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800056ea:	00005997          	auipc	s3,0x5
    800056ee:	dae98993          	addi	s3,s3,-594 # 8000a498 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800056f2:	00094703          	lbu	a4,0(s2)
    800056f6:	02077713          	andi	a4,a4,32
    800056fa:	c71d                	beqz	a4,80005728 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800056fc:	01f7f713          	andi	a4,a5,31
    80005700:	9756                	add	a4,a4,s5
    80005702:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005706:	0785                	addi	a5,a5,1
    80005708:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000570a:	8526                	mv	a0,s1
    8000570c:	c81fb0ef          	jal	8000138c <wakeup>
    WriteReg(THR, c);
    80005710:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005714:	609c                	ld	a5,0(s1)
    80005716:	0009b703          	ld	a4,0(s3)
    8000571a:	fcf71ce3          	bne	a4,a5,800056f2 <uartstart+0x4a>
      ReadReg(ISR);
    8000571e:	100007b7          	lui	a5,0x10000
    80005722:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005724:	0007c783          	lbu	a5,0(a5)
  }
}
    80005728:	70e2                	ld	ra,56(sp)
    8000572a:	7442                	ld	s0,48(sp)
    8000572c:	74a2                	ld	s1,40(sp)
    8000572e:	7902                	ld	s2,32(sp)
    80005730:	69e2                	ld	s3,24(sp)
    80005732:	6a42                	ld	s4,16(sp)
    80005734:	6aa2                	ld	s5,8(sp)
    80005736:	6b02                	ld	s6,0(sp)
    80005738:	6121                	addi	sp,sp,64
    8000573a:	8082                	ret
      ReadReg(ISR);
    8000573c:	100007b7          	lui	a5,0x10000
    80005740:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005742:	0007c783          	lbu	a5,0(a5)
      return;
    80005746:	8082                	ret

0000000080005748 <uartputc>:
{
    80005748:	7179                	addi	sp,sp,-48
    8000574a:	f406                	sd	ra,40(sp)
    8000574c:	f022                	sd	s0,32(sp)
    8000574e:	ec26                	sd	s1,24(sp)
    80005750:	e84a                	sd	s2,16(sp)
    80005752:	e44e                	sd	s3,8(sp)
    80005754:	e052                	sd	s4,0(sp)
    80005756:	1800                	addi	s0,sp,48
    80005758:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000575a:	00023517          	auipc	a0,0x23
    8000575e:	03e50513          	addi	a0,a0,62 # 80028798 <uart_tx_lock>
    80005762:	16e000ef          	jal	800058d0 <acquire>
  if(panicked){
    80005766:	00005797          	auipc	a5,0x5
    8000576a:	d267a783          	lw	a5,-730(a5) # 8000a48c <panicked>
    8000576e:	efbd                	bnez	a5,800057ec <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005770:	00005717          	auipc	a4,0x5
    80005774:	d2873703          	ld	a4,-728(a4) # 8000a498 <uart_tx_w>
    80005778:	00005797          	auipc	a5,0x5
    8000577c:	d187b783          	ld	a5,-744(a5) # 8000a490 <uart_tx_r>
    80005780:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005784:	00023997          	auipc	s3,0x23
    80005788:	01498993          	addi	s3,s3,20 # 80028798 <uart_tx_lock>
    8000578c:	00005497          	auipc	s1,0x5
    80005790:	d0448493          	addi	s1,s1,-764 # 8000a490 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005794:	00005917          	auipc	s2,0x5
    80005798:	d0490913          	addi	s2,s2,-764 # 8000a498 <uart_tx_w>
    8000579c:	00e79d63          	bne	a5,a4,800057b6 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800057a0:	85ce                	mv	a1,s3
    800057a2:	8526                	mv	a0,s1
    800057a4:	b9dfb0ef          	jal	80001340 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800057a8:	00093703          	ld	a4,0(s2)
    800057ac:	609c                	ld	a5,0(s1)
    800057ae:	02078793          	addi	a5,a5,32
    800057b2:	fee787e3          	beq	a5,a4,800057a0 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800057b6:	00023497          	auipc	s1,0x23
    800057ba:	fe248493          	addi	s1,s1,-30 # 80028798 <uart_tx_lock>
    800057be:	01f77793          	andi	a5,a4,31
    800057c2:	97a6                	add	a5,a5,s1
    800057c4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800057c8:	0705                	addi	a4,a4,1
    800057ca:	00005797          	auipc	a5,0x5
    800057ce:	cce7b723          	sd	a4,-818(a5) # 8000a498 <uart_tx_w>
  uartstart();
    800057d2:	ed7ff0ef          	jal	800056a8 <uartstart>
  release(&uart_tx_lock);
    800057d6:	8526                	mv	a0,s1
    800057d8:	190000ef          	jal	80005968 <release>
}
    800057dc:	70a2                	ld	ra,40(sp)
    800057de:	7402                	ld	s0,32(sp)
    800057e0:	64e2                	ld	s1,24(sp)
    800057e2:	6942                	ld	s2,16(sp)
    800057e4:	69a2                	ld	s3,8(sp)
    800057e6:	6a02                	ld	s4,0(sp)
    800057e8:	6145                	addi	sp,sp,48
    800057ea:	8082                	ret
    for(;;)
    800057ec:	a001                	j	800057ec <uartputc+0xa4>

00000000800057ee <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800057ee:	1141                	addi	sp,sp,-16
    800057f0:	e422                	sd	s0,8(sp)
    800057f2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800057f4:	100007b7          	lui	a5,0x10000
    800057f8:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800057fa:	0007c783          	lbu	a5,0(a5)
    800057fe:	8b85                	andi	a5,a5,1
    80005800:	cb81                	beqz	a5,80005810 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005802:	100007b7          	lui	a5,0x10000
    80005806:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000580a:	6422                	ld	s0,8(sp)
    8000580c:	0141                	addi	sp,sp,16
    8000580e:	8082                	ret
    return -1;
    80005810:	557d                	li	a0,-1
    80005812:	bfe5                	j	8000580a <uartgetc+0x1c>

0000000080005814 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005814:	1101                	addi	sp,sp,-32
    80005816:	ec06                	sd	ra,24(sp)
    80005818:	e822                	sd	s0,16(sp)
    8000581a:	e426                	sd	s1,8(sp)
    8000581c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000581e:	54fd                	li	s1,-1
    80005820:	a019                	j	80005826 <uartintr+0x12>
      break;
    consoleintr(c);
    80005822:	85fff0ef          	jal	80005080 <consoleintr>
    int c = uartgetc();
    80005826:	fc9ff0ef          	jal	800057ee <uartgetc>
    if(c == -1)
    8000582a:	fe951ce3          	bne	a0,s1,80005822 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000582e:	00023497          	auipc	s1,0x23
    80005832:	f6a48493          	addi	s1,s1,-150 # 80028798 <uart_tx_lock>
    80005836:	8526                	mv	a0,s1
    80005838:	098000ef          	jal	800058d0 <acquire>
  uartstart();
    8000583c:	e6dff0ef          	jal	800056a8 <uartstart>
  release(&uart_tx_lock);
    80005840:	8526                	mv	a0,s1
    80005842:	126000ef          	jal	80005968 <release>
}
    80005846:	60e2                	ld	ra,24(sp)
    80005848:	6442                	ld	s0,16(sp)
    8000584a:	64a2                	ld	s1,8(sp)
    8000584c:	6105                	addi	sp,sp,32
    8000584e:	8082                	ret

0000000080005850 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005850:	1141                	addi	sp,sp,-16
    80005852:	e422                	sd	s0,8(sp)
    80005854:	0800                	addi	s0,sp,16
  lk->name = name;
    80005856:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005858:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000585c:	00053823          	sd	zero,16(a0)
}
    80005860:	6422                	ld	s0,8(sp)
    80005862:	0141                	addi	sp,sp,16
    80005864:	8082                	ret

0000000080005866 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005866:	411c                	lw	a5,0(a0)
    80005868:	e399                	bnez	a5,8000586e <holding+0x8>
    8000586a:	4501                	li	a0,0
  return r;
}
    8000586c:	8082                	ret
{
    8000586e:	1101                	addi	sp,sp,-32
    80005870:	ec06                	sd	ra,24(sp)
    80005872:	e822                	sd	s0,16(sp)
    80005874:	e426                	sd	s1,8(sp)
    80005876:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005878:	6904                	ld	s1,16(a0)
    8000587a:	cc4fb0ef          	jal	80000d3e <mycpu>
    8000587e:	40a48533          	sub	a0,s1,a0
    80005882:	00153513          	seqz	a0,a0
}
    80005886:	60e2                	ld	ra,24(sp)
    80005888:	6442                	ld	s0,16(sp)
    8000588a:	64a2                	ld	s1,8(sp)
    8000588c:	6105                	addi	sp,sp,32
    8000588e:	8082                	ret

0000000080005890 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005890:	1101                	addi	sp,sp,-32
    80005892:	ec06                	sd	ra,24(sp)
    80005894:	e822                	sd	s0,16(sp)
    80005896:	e426                	sd	s1,8(sp)
    80005898:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000589a:	100024f3          	csrr	s1,sstatus
    8000589e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800058a2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800058a4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800058a8:	c96fb0ef          	jal	80000d3e <mycpu>
    800058ac:	5d3c                	lw	a5,120(a0)
    800058ae:	cb99                	beqz	a5,800058c4 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800058b0:	c8efb0ef          	jal	80000d3e <mycpu>
    800058b4:	5d3c                	lw	a5,120(a0)
    800058b6:	2785                	addiw	a5,a5,1
    800058b8:	dd3c                	sw	a5,120(a0)
}
    800058ba:	60e2                	ld	ra,24(sp)
    800058bc:	6442                	ld	s0,16(sp)
    800058be:	64a2                	ld	s1,8(sp)
    800058c0:	6105                	addi	sp,sp,32
    800058c2:	8082                	ret
    mycpu()->intena = old;
    800058c4:	c7afb0ef          	jal	80000d3e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800058c8:	8085                	srli	s1,s1,0x1
    800058ca:	8885                	andi	s1,s1,1
    800058cc:	dd64                	sw	s1,124(a0)
    800058ce:	b7cd                	j	800058b0 <push_off+0x20>

00000000800058d0 <acquire>:
{
    800058d0:	1101                	addi	sp,sp,-32
    800058d2:	ec06                	sd	ra,24(sp)
    800058d4:	e822                	sd	s0,16(sp)
    800058d6:	e426                	sd	s1,8(sp)
    800058d8:	1000                	addi	s0,sp,32
    800058da:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800058dc:	fb5ff0ef          	jal	80005890 <push_off>
  if(holding(lk))
    800058e0:	8526                	mv	a0,s1
    800058e2:	f85ff0ef          	jal	80005866 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800058e6:	4705                	li	a4,1
  if(holding(lk))
    800058e8:	e105                	bnez	a0,80005908 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800058ea:	87ba                	mv	a5,a4
    800058ec:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800058f0:	2781                	sext.w	a5,a5
    800058f2:	ffe5                	bnez	a5,800058ea <acquire+0x1a>
  __sync_synchronize();
    800058f4:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800058f8:	c46fb0ef          	jal	80000d3e <mycpu>
    800058fc:	e888                	sd	a0,16(s1)
}
    800058fe:	60e2                	ld	ra,24(sp)
    80005900:	6442                	ld	s0,16(sp)
    80005902:	64a2                	ld	s1,8(sp)
    80005904:	6105                	addi	sp,sp,32
    80005906:	8082                	ret
    panic("acquire");
    80005908:	00002517          	auipc	a0,0x2
    8000590c:	f4050513          	addi	a0,a0,-192 # 80007848 <etext+0x848>
    80005910:	c93ff0ef          	jal	800055a2 <panic>

0000000080005914 <pop_off>:

void
pop_off(void)
{
    80005914:	1141                	addi	sp,sp,-16
    80005916:	e406                	sd	ra,8(sp)
    80005918:	e022                	sd	s0,0(sp)
    8000591a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000591c:	c22fb0ef          	jal	80000d3e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005920:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005924:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005926:	e78d                	bnez	a5,80005950 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005928:	5d3c                	lw	a5,120(a0)
    8000592a:	02f05963          	blez	a5,8000595c <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    8000592e:	37fd                	addiw	a5,a5,-1
    80005930:	0007871b          	sext.w	a4,a5
    80005934:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005936:	eb09                	bnez	a4,80005948 <pop_off+0x34>
    80005938:	5d7c                	lw	a5,124(a0)
    8000593a:	c799                	beqz	a5,80005948 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000593c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005940:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005944:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005948:	60a2                	ld	ra,8(sp)
    8000594a:	6402                	ld	s0,0(sp)
    8000594c:	0141                	addi	sp,sp,16
    8000594e:	8082                	ret
    panic("pop_off - interruptible");
    80005950:	00002517          	auipc	a0,0x2
    80005954:	f0050513          	addi	a0,a0,-256 # 80007850 <etext+0x850>
    80005958:	c4bff0ef          	jal	800055a2 <panic>
    panic("pop_off");
    8000595c:	00002517          	auipc	a0,0x2
    80005960:	f0c50513          	addi	a0,a0,-244 # 80007868 <etext+0x868>
    80005964:	c3fff0ef          	jal	800055a2 <panic>

0000000080005968 <release>:
{
    80005968:	1101                	addi	sp,sp,-32
    8000596a:	ec06                	sd	ra,24(sp)
    8000596c:	e822                	sd	s0,16(sp)
    8000596e:	e426                	sd	s1,8(sp)
    80005970:	1000                	addi	s0,sp,32
    80005972:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005974:	ef3ff0ef          	jal	80005866 <holding>
    80005978:	c105                	beqz	a0,80005998 <release+0x30>
  lk->cpu = 0;
    8000597a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000597e:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005982:	0310000f          	fence	rw,w
    80005986:	0004a023          	sw	zero,0(s1)
  pop_off();
    8000598a:	f8bff0ef          	jal	80005914 <pop_off>
}
    8000598e:	60e2                	ld	ra,24(sp)
    80005990:	6442                	ld	s0,16(sp)
    80005992:	64a2                	ld	s1,8(sp)
    80005994:	6105                	addi	sp,sp,32
    80005996:	8082                	ret
    panic("release");
    80005998:	00002517          	auipc	a0,0x2
    8000599c:	ed850513          	addi	a0,a0,-296 # 80007870 <etext+0x870>
    800059a0:	c03ff0ef          	jal	800055a2 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
