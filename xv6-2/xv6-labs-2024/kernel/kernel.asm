
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000c117          	auipc	sp,0xc
    80000004:	e9013103          	ld	sp,-368(sp) # 8000be90 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	459050ef          	jal	80005c6e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <freerange>:

// Add physical memory from pa_start to pa_end (exclusive of pa_end)
// to the 4KB page free list. pa_start and pa_end are page-aligned.
void
freerange(void *pa_start, void *pa_end)
{
    8000001c:	7139                	addi	sp,sp,-64
    8000001e:	fc06                	sd	ra,56(sp)
    80000020:	f822                	sd	s0,48(sp)
    80000022:	f426                	sd	s1,40(sp)
    80000024:	0080                	addi	s0,sp,64
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start); // Align pa_start up to a page boundary
    80000026:	6785                	lui	a5,0x1
    80000028:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    8000002c:	00e504b3          	add	s1,a0,a4
    80000030:	777d                	lui	a4,0xfffff
    80000032:	8cf9                	and	s1,s1,a4
  // Distribute initial pages somewhat evenly, or all to CPU 0.
  // For simplicity in xv6 init, often all given to CPU 0, and others steal.
  int bootstrap_cpu_id = 0; // Or r_mhartid() if kinit is called by each hart, but typically just once.
                            // If kinit is called once globally, bootstrap_cpu_id = 0 is fine.

  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000034:	94be                	add	s1,s1,a5
    80000036:	0495e463          	bltu	a1,s1,8000007e <freerange+0x62>
    8000003a:	f04a                	sd	s2,32(sp)
    8000003c:	ec4e                	sd	s3,24(sp)
    8000003e:	e852                	sd	s4,16(sp)
    80000040:	e456                	sd	s5,8(sp)
    80000042:	e05a                	sd	s6,0(sp)
    80000044:	8a2e                	mv	s4,a1
    80000046:	7b7d                	lui	s6,0xfffff
    // because pa_end for this freerange call is already adjusted
    // to not include the superpage pool.
    struct run *r = (struct run*)p;

    // Add page to the bootstrap CPU's freelist
    acquire(&kmems[bootstrap_cpu_id].lock);
    80000048:	0000c917          	auipc	s2,0xc
    8000004c:	eb890913          	addi	s2,s2,-328 # 8000bf00 <kmems>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000050:	6a85                	lui	s5,0x1
    80000052:	016489b3          	add	s3,s1,s6
    acquire(&kmems[bootstrap_cpu_id].lock);
    80000056:	854a                	mv	a0,s2
    80000058:	69e060ef          	jal	800066f6 <acquire>
    r->next = kmems[bootstrap_cpu_id].freelist;
    8000005c:	02093783          	ld	a5,32(s2)
    80000060:	00f9b023          	sd	a5,0(s3)
    kmems[bootstrap_cpu_id].freelist = r;
    80000064:	03393023          	sd	s3,32(s2)
    release(&kmems[bootstrap_cpu_id].lock);
    80000068:	854a                	mv	a0,s2
    8000006a:	758060ef          	jal	800067c2 <release>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    8000006e:	94d6                	add	s1,s1,s5
    80000070:	fe9a71e3          	bgeu	s4,s1,80000052 <freerange+0x36>
    80000074:	7902                	ld	s2,32(sp)
    80000076:	69e2                	ld	s3,24(sp)
    80000078:	6a42                	ld	s4,16(sp)
    8000007a:	6aa2                	ld	s5,8(sp)
    8000007c:	6b02                	ld	s6,0(sp)
  }
}
    8000007e:	70e2                	ld	ra,56(sp)
    80000080:	7442                	ld	s0,48(sp)
    80000082:	74a2                	ld	s1,40(sp)
    80000084:	6121                	addi	sp,sp,64
    80000086:	8082                	ret

0000000080000088 <kinit>:
{
    80000088:	715d                	addi	sp,sp,-80
    8000008a:	e486                	sd	ra,72(sp)
    8000008c:	e0a2                	sd	s0,64(sp)
    8000008e:	fc26                	sd	s1,56(sp)
    80000090:	f84a                	sd	s2,48(sp)
    80000092:	f44e                	sd	s3,40(sp)
    80000094:	f052                	sd	s4,32(sp)
    80000096:	ec56                	sd	s5,24(sp)
    80000098:	e85a                	sd	s6,16(sp)
    8000009a:	e45e                	sd	s7,8(sp)
    8000009c:	0880                	addi	s0,sp,80
  for (int i = 0; i < NCPU; i++) {
    8000009e:	0000c497          	auipc	s1,0xc
    800000a2:	e6248493          	addi	s1,s1,-414 # 8000bf00 <kmems>
{
    800000a6:	03000913          	li	s2,48
    kmems[i].name[0] = 'k'; kmems[i].name[1] = 'm'; kmems[i].name[2] = 'e'; kmems[i].name[3] = 'm';
    800000aa:	06b00b93          	li	s7,107
    800000ae:	06d00993          	li	s3,109
    800000b2:	06500b13          	li	s6,101
    kmems[i].name[4] = '_';
    800000b6:	05f00a93          	li	s5,95
  for (int i = 0; i < NCPU; i++) {
    800000ba:	03800a13          	li	s4,56
    kmems[i].name[0] = 'k'; kmems[i].name[1] = 'm'; kmems[i].name[2] = 'e'; kmems[i].name[3] = 'm';
    800000be:	03748423          	sb	s7,40(s1)
    800000c2:	033484a3          	sb	s3,41(s1)
    800000c6:	03648523          	sb	s6,42(s1)
    800000ca:	033485a3          	sb	s3,43(s1)
    kmems[i].name[4] = '_';
    800000ce:	03548623          	sb	s5,44(s1)
        kmems[i].name[5] = (char)('0' + i);
    800000d2:	032486a3          	sb	s2,45(s1)
        kmems[i].name[6] = '\0';
    800000d6:	02048723          	sb	zero,46(s1)
    initlock(&kmems[i].lock, kmems[i].name);
    800000da:	02848593          	addi	a1,s1,40
    800000de:	8526                	mv	a0,s1
    800000e0:	71e060ef          	jal	800067fe <initlock>
    kmems[i].freelist = 0; // Initialize freelist
    800000e4:	0204b023          	sd	zero,32(s1)
  for (int i = 0; i < NCPU; i++) {
    800000e8:	03848493          	addi	s1,s1,56
    800000ec:	2905                	addiw	s2,s2,1
    800000ee:	0ff97913          	zext.b	s2,s2
    800000f2:	fd4916e3          	bne	s2,s4,800000be <kinit+0x36>
  initlock(&superlock, "superkmem");
    800000f6:	00008597          	auipc	a1,0x8
    800000fa:	f0a58593          	addi	a1,a1,-246 # 80008000 <etext>
    800000fe:	0000c517          	auipc	a0,0xc
    80000102:	fc250513          	addi	a0,a0,-62 # 8000c0c0 <superlock>
    80000106:	6f8060ef          	jal	800067fe <initlock>
    superpages_status[i] = 0;
    8000010a:	0000c797          	auipc	a5,0xc
    8000010e:	db678793          	addi	a5,a5,-586 # 8000bec0 <superpages_status>
    80000112:	00078023          	sb	zero,0(a5)
    80000116:	000780a3          	sb	zero,1(a5)
    8000011a:	00078123          	sb	zero,2(a5)
    8000011e:	000781a3          	sb	zero,3(a5)
    80000122:	00078223          	sb	zero,4(a5)
    80000126:	000782a3          	sb	zero,5(a5)
    8000012a:	00078323          	sb	zero,6(a5)
    8000012e:	000783a3          	sb	zero,7(a5)
  if (PHYSTOP < (uint64)end + total_super_pool_size) { // Not enough memory even for kernel + superpages
    80000132:	00026617          	auipc	a2,0x26
    80000136:	dc660613          	addi	a2,a2,-570 # 80025ef8 <end>
    8000013a:	01026717          	auipc	a4,0x1026
    8000013e:	dbe70713          	addi	a4,a4,-578 # 81025ef8 <end+0x1000000>
    80000142:	47c5                	li	a5,17
    80000144:	07ee                	slli	a5,a5,0x1b
    80000146:	02e7e963          	bltu	a5,a4,80000178 <kinit+0xf0>
  } else if (potential_sp_start < (uint64)end) { // Overlaps with kernel
    8000014a:	08700793          	li	a5,135
    8000014e:	07e2                	slli	a5,a5,0x18
    80000150:	02c7fb63          	bgeu	a5,a2,80000186 <kinit+0xfe>
      printf("kalloc: Calculated superpage pool at 0x%lx overlaps kernel (ends at 0x%lx). Superpages disabled.\n",
    80000154:	85be                	mv	a1,a5
    80000156:	00008517          	auipc	a0,0x8
    8000015a:	f1250513          	addi	a0,a0,-238 # 80008068 <etext+0x68>
    8000015e:	773050ef          	jal	800060d0 <printf>
      superpages_physaddr_start = 0;
    80000162:	0000c797          	auipc	a5,0xc
    80000166:	d407bb23          	sd	zero,-682(a5) # 8000beb8 <superpages_physaddr_start>
      superpages_pool_active = 0;
    8000016a:	0000c797          	auipc	a5,0xc
    8000016e:	d407a323          	sw	zero,-698(a5) # 8000beb0 <superpages_pool_active>
    pa_4k_end = PHYSTOP; // No superpages, 4KB pages go up to PHYSTOP
    80000172:	45c5                	li	a1,17
    80000174:	05ee                	slli	a1,a1,0x1b
    80000176:	a0a1                	j	800001be <kinit+0x136>
      printf("kalloc: Not enough physical memory for kernel and superpage pool. Superpages disabled.\n");
    80000178:	00008517          	auipc	a0,0x8
    8000017c:	e9850513          	addi	a0,a0,-360 # 80008010 <etext+0x10>
    80000180:	751050ef          	jal	800060d0 <printf>
      superpages_pool_active = 0;
    80000184:	bff9                	j	80000162 <kinit+0xda>
      superpages_physaddr_start = potential_sp_start;
    80000186:	08700593          	li	a1,135
    8000018a:	05e2                	slli	a1,a1,0x18
    8000018c:	0000c797          	auipc	a5,0xc
    80000190:	d2b7b623          	sd	a1,-724(a5) # 8000beb8 <superpages_physaddr_start>
      superpages_pool_active = 1;
    80000194:	0000c497          	auipc	s1,0xc
    80000198:	d1c48493          	addi	s1,s1,-740 # 8000beb0 <superpages_pool_active>
    8000019c:	4785                	li	a5,1
    8000019e:	c09c                	sw	a5,0(s1)
      printf("kalloc: Superpage pool active: [0x%lx - 0x%lx), %d blocks.\n", 
    800001a0:	46a1                	li	a3,8
    800001a2:	4645                	li	a2,17
    800001a4:	066e                	slli	a2,a2,0x1b
    800001a6:	00008517          	auipc	a0,0x8
    800001aa:	f2a50513          	addi	a0,a0,-214 # 800080d0 <etext+0xd0>
    800001ae:	723050ef          	jal	800060d0 <printf>
  if (superpages_pool_active) {
    800001b2:	409c                	lw	a5,0(s1)
    800001b4:	c795                	beqz	a5,800001e0 <kinit+0x158>
    pa_4k_end = superpages_physaddr_start; // 4KB pages go up to where superpages begin
    800001b6:	0000c597          	auipc	a1,0xc
    800001ba:	d025b583          	ld	a1,-766(a1) # 8000beb8 <superpages_physaddr_start>
  freerange(end, (void*)pa_4k_end);
    800001be:	00026517          	auipc	a0,0x26
    800001c2:	d3a50513          	addi	a0,a0,-710 # 80025ef8 <end>
    800001c6:	e57ff0ef          	jal	8000001c <freerange>
}
    800001ca:	60a6                	ld	ra,72(sp)
    800001cc:	6406                	ld	s0,64(sp)
    800001ce:	74e2                	ld	s1,56(sp)
    800001d0:	7942                	ld	s2,48(sp)
    800001d2:	79a2                	ld	s3,40(sp)
    800001d4:	7a02                	ld	s4,32(sp)
    800001d6:	6ae2                	ld	s5,24(sp)
    800001d8:	6b42                	ld	s6,16(sp)
    800001da:	6ba2                	ld	s7,8(sp)
    800001dc:	6161                	addi	sp,sp,80
    800001de:	8082                	ret
    pa_4k_end = PHYSTOP; // No superpages, 4KB pages go up to PHYSTOP
    800001e0:	45c5                	li	a1,17
    800001e2:	05ee                	slli	a1,a1,0x1b
    800001e4:	bfe9                	j	800001be <kinit+0x136>

00000000800001e6 <kfree>:
// Free the 4KB physical page at pa,
// which is returned by kalloc().
// Adds the page to the current CPU's free list.
void
kfree(void *pa)
{
    800001e6:	7139                	addi	sp,sp,-64
    800001e8:	fc06                	sd	ra,56(sp)
    800001ea:	f822                	sd	s0,48(sp)
    800001ec:	f426                	sd	s1,40(sp)
    800001ee:	f04a                	sd	s2,32(sp)
    800001f0:	ec4e                	sd	s3,24(sp)
    800001f2:	e852                	sd	s4,16(sp)
    800001f4:	e456                	sd	s5,8(sp)
    800001f6:	0080                	addi	s0,sp,64
  struct run *r;
  int cid;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800001f8:	03451793          	slli	a5,a0,0x34
    800001fc:	e7d1                	bnez	a5,80000288 <kfree+0xa2>
    800001fe:	84aa                	mv	s1,a0
    80000200:	00026797          	auipc	a5,0x26
    80000204:	cf878793          	addi	a5,a5,-776 # 80025ef8 <end>
    80000208:	08f56063          	bltu	a0,a5,80000288 <kfree+0xa2>
    8000020c:	47c5                	li	a5,17
    8000020e:	07ee                	slli	a5,a5,0x1b
    80000210:	06f57c63          	bgeu	a0,a5,80000288 <kfree+0xa2>
    panic("kfree: freeing invalid physical address");
  
  // Check if trying to kfree a page within the active superpage pool.
  // This should not happen; superpages are freed by superfree.
  if (superpages_pool_active &&
    80000214:	0000c797          	auipc	a5,0xc
    80000218:	c9c7a783          	lw	a5,-868(a5) # 8000beb0 <superpages_pool_active>
    8000021c:	cf81                	beqz	a5,80000234 <kfree+0x4e>
      (uint64)pa >= superpages_physaddr_start &&
    8000021e:	0000c797          	auipc	a5,0xc
    80000222:	c9a7b783          	ld	a5,-870(a5) # 8000beb8 <superpages_physaddr_start>
  if (superpages_pool_active &&
    80000226:	00f56763          	bltu	a0,a5,80000234 <kfree+0x4e>
      (uint64)pa < superpages_physaddr_start + (uint64)NSUPERPG * SUPERPGSIZE)
    8000022a:	010006b7          	lui	a3,0x1000
    8000022e:	97b6                	add	a5,a5,a3
      (uint64)pa >= superpages_physaddr_start &&
    80000230:	06f56263          	bltu	a0,a5,80000294 <kfree+0xae>
  {
    panic("kfree: attempt to free a 4KB page within the superpage reserved area");
  }

  // Fill with junk to catch dangling references.
  memset(pa, 1, PGSIZE);
    80000234:	6605                	lui	a2,0x1
    80000236:	4585                	li	a1,1
    80000238:	8526                	mv	a0,s1
    8000023a:	274000ef          	jal	800004ae <memset>

  r = (struct run*)pa;

  push_off(); // Disable interrupts to safely get cpuid
    8000023e:	478060ef          	jal	800066b6 <push_off>
  cid = cpuid();
    80000242:	54a010ef          	jal	8000178c <cpuid>
    80000246:	8a2a                	mv	s4,a0
  pop_off();  // Re-enable interrupts
    80000248:	526060ef          	jal	8000676e <pop_off>
  
  acquire(&kmems[cid].lock);
    8000024c:	0000ca97          	auipc	s5,0xc
    80000250:	cb4a8a93          	addi	s5,s5,-844 # 8000bf00 <kmems>
    80000254:	003a1993          	slli	s3,s4,0x3
    80000258:	41498933          	sub	s2,s3,s4
    8000025c:	090e                	slli	s2,s2,0x3
    8000025e:	9956                	add	s2,s2,s5
    80000260:	854a                	mv	a0,s2
    80000262:	494060ef          	jal	800066f6 <acquire>
  r->next = kmems[cid].freelist;
    80000266:	02093783          	ld	a5,32(s2)
    8000026a:	e09c                	sd	a5,0(s1)
  kmems[cid].freelist = r;
    8000026c:	02993023          	sd	s1,32(s2)
  release(&kmems[cid].lock);
    80000270:	854a                	mv	a0,s2
    80000272:	550060ef          	jal	800067c2 <release>
}
    80000276:	70e2                	ld	ra,56(sp)
    80000278:	7442                	ld	s0,48(sp)
    8000027a:	74a2                	ld	s1,40(sp)
    8000027c:	7902                	ld	s2,32(sp)
    8000027e:	69e2                	ld	s3,24(sp)
    80000280:	6a42                	ld	s4,16(sp)
    80000282:	6aa2                	ld	s5,8(sp)
    80000284:	6121                	addi	sp,sp,64
    80000286:	8082                	ret
    panic("kfree: freeing invalid physical address");
    80000288:	00008517          	auipc	a0,0x8
    8000028c:	e8850513          	addi	a0,a0,-376 # 80008110 <etext+0x110>
    80000290:	112060ef          	jal	800063a2 <panic>
    panic("kfree: attempt to free a 4KB page within the superpage reserved area");
    80000294:	00008517          	auipc	a0,0x8
    80000298:	ea450513          	addi	a0,a0,-348 # 80008138 <etext+0x138>
    8000029c:	106060ef          	jal	800063a2 <panic>

00000000800002a0 <kalloc>:
// Allocate one 4KB physical page.
// Returns a pointer to the page, or 0 if out of memory.
// Tries local CPU list first, then steals from other CPUs.
void *
kalloc(void)
{
    800002a0:	7139                	addi	sp,sp,-64
    800002a2:	fc06                	sd	ra,56(sp)
    800002a4:	f822                	sd	s0,48(sp)
    800002a6:	f426                	sd	s1,40(sp)
    800002a8:	ec4e                	sd	s3,24(sp)
    800002aa:	e852                	sd	s4,16(sp)
    800002ac:	0080                	addi	s0,sp,64
  struct run *r;
  int my_cid;

  push_off();
    800002ae:	408060ef          	jal	800066b6 <push_off>
  my_cid = cpuid();
    800002b2:	4da010ef          	jal	8000178c <cpuid>
    800002b6:	89aa                	mv	s3,a0
  pop_off();
    800002b8:	4b6060ef          	jal	8000676e <pop_off>
  
  // 1. Try to allocate from the current CPU's local freelist
  acquire(&kmems[my_cid].lock);
    800002bc:	00399793          	slli	a5,s3,0x3
    800002c0:	413787b3          	sub	a5,a5,s3
    800002c4:	078e                	slli	a5,a5,0x3
    800002c6:	0000c497          	auipc	s1,0xc
    800002ca:	c3a48493          	addi	s1,s1,-966 # 8000bf00 <kmems>
    800002ce:	94be                	add	s1,s1,a5
    800002d0:	8526                	mv	a0,s1
    800002d2:	424060ef          	jal	800066f6 <acquire>
  r = kmems[my_cid].freelist;
    800002d6:	0204ba03          	ld	s4,32(s1)
  if(r){
    800002da:	020a0563          	beqz	s4,80000304 <kalloc+0x64>
    kmems[my_cid].freelist = r->next;
    800002de:	000a3683          	ld	a3,0(s4)
    800002e2:	f094                	sd	a3,32(s1)
    release(&kmems[my_cid].lock);
    800002e4:	8526                	mv	a0,s1
    800002e6:	4dc060ef          	jal	800067c2 <release>
    memset((char*)r, 5, PGSIZE); // fill with junk
    800002ea:	6605                	lui	a2,0x1
    800002ec:	4595                	li	a1,5
    800002ee:	8552                	mv	a0,s4
    800002f0:	1be000ef          	jal	800004ae <memset>
    release(&kmems[other_cid].lock);
  }
  
  // printf("kalloc: 4KB out of memory!\n"); // Optional: uncomment for debugging OOM
  return 0; // All CPUs' freelists are empty
}
    800002f4:	8552                	mv	a0,s4
    800002f6:	70e2                	ld	ra,56(sp)
    800002f8:	7442                	ld	s0,48(sp)
    800002fa:	74a2                	ld	s1,40(sp)
    800002fc:	69e2                	ld	s3,24(sp)
    800002fe:	6a42                	ld	s4,16(sp)
    80000300:	6121                	addi	sp,sp,64
    80000302:	8082                	ret
    80000304:	f04a                	sd	s2,32(sp)
    80000306:	e456                	sd	s5,8(sp)
    80000308:	e05a                	sd	s6,0(sp)
  release(&kmems[my_cid].lock); // Local list is empty, release its lock
    8000030a:	8526                	mv	a0,s1
    8000030c:	4b6060ef          	jal	800067c2 <release>
  for(int other_cid = 0; other_cid < NCPU; other_cid++){
    80000310:	0000c917          	auipc	s2,0xc
    80000314:	bf090913          	addi	s2,s2,-1040 # 8000bf00 <kmems>
    80000318:	4481                	li	s1,0
    8000031a:	4b21                	li	s6,8
    8000031c:	a83d                	j	8000035a <kalloc+0xba>
      kmems[other_cid].freelist = r->next; 
    8000031e:	000ab683          	ld	a3,0(s5)
    80000322:	00349793          	slli	a5,s1,0x3
    80000326:	8f85                	sub	a5,a5,s1
    80000328:	078e                	slli	a5,a5,0x3
    8000032a:	0000c717          	auipc	a4,0xc
    8000032e:	bd670713          	addi	a4,a4,-1066 # 8000bf00 <kmems>
    80000332:	97ba                	add	a5,a5,a4
    80000334:	f394                	sd	a3,32(a5)
      release(&kmems[other_cid].lock);
    80000336:	854a                	mv	a0,s2
    80000338:	48a060ef          	jal	800067c2 <release>
      memset((char*)r, 5, PGSIZE); // fill with junk
    8000033c:	6605                	lui	a2,0x1
    8000033e:	4595                	li	a1,5
    80000340:	8556                	mv	a0,s5
    80000342:	16c000ef          	jal	800004ae <memset>
      return (void*)r; 
    80000346:	8a56                	mv	s4,s5
    80000348:	7902                	ld	s2,32(sp)
    8000034a:	6aa2                	ld	s5,8(sp)
    8000034c:	6b02                	ld	s6,0(sp)
    8000034e:	b75d                	j	800002f4 <kalloc+0x54>
  for(int other_cid = 0; other_cid < NCPU; other_cid++){
    80000350:	2485                	addiw	s1,s1,1
    80000352:	03890913          	addi	s2,s2,56
    80000356:	01648f63          	beq	s1,s6,80000374 <kalloc+0xd4>
    if(other_cid == my_cid)
    8000035a:	fe998be3          	beq	s3,s1,80000350 <kalloc+0xb0>
    acquire(&kmems[other_cid].lock);
    8000035e:	854a                	mv	a0,s2
    80000360:	396060ef          	jal	800066f6 <acquire>
    r = kmems[other_cid].freelist;
    80000364:	02093a83          	ld	s5,32(s2)
    if(r){ // If the other CPU has a free page
    80000368:	fa0a9be3          	bnez	s5,8000031e <kalloc+0x7e>
    release(&kmems[other_cid].lock);
    8000036c:	854a                	mv	a0,s2
    8000036e:	454060ef          	jal	800067c2 <release>
    80000372:	bff9                	j	80000350 <kalloc+0xb0>
    80000374:	7902                	ld	s2,32(sp)
    80000376:	6aa2                	ld	s5,8(sp)
    80000378:	6b02                	ld	s6,0(sp)
    8000037a:	bfad                	j	800002f4 <kalloc+0x54>

000000008000037c <superalloc>:

// Allocate a 2MB-aligned physical superpage.
// Returns a pointer to the page if successful, 0 otherwise.
void*
superalloc(void)
{
    8000037c:	1101                	addi	sp,sp,-32
    8000037e:	ec06                	sd	ra,24(sp)
    80000380:	e822                	sd	s0,16(sp)
    80000382:	e426                	sd	s1,8(sp)
    80000384:	1000                	addi	s0,sp,32
  if (!superpages_pool_active) { // Check if pool was successfully initialized
    80000386:	0000c797          	auipc	a5,0xc
    8000038a:	b2a7a783          	lw	a5,-1238(a5) # 8000beb0 <superpages_pool_active>
    return 0; 
    8000038e:	4481                	li	s1,0
  if (!superpages_pool_active) { // Check if pool was successfully initialized
    80000390:	cb95                	beqz	a5,800003c4 <superalloc+0x48>
  }

  acquire(&superlock);
    80000392:	0000c517          	auipc	a0,0xc
    80000396:	d2e50513          	addi	a0,a0,-722 # 8000c0c0 <superlock>
    8000039a:	35c060ef          	jal	800066f6 <acquire>
  for (int i = 0; i < NSUPERPG; i++) {
    8000039e:	0000c797          	auipc	a5,0xc
    800003a2:	b2278793          	addi	a5,a5,-1246 # 8000bec0 <superpages_status>
    800003a6:	46a1                	li	a3,8
    if (superpages_status[i] == 0) { // If block 'i' is free
    800003a8:	0007c703          	lbu	a4,0(a5)
    800003ac:	c315                	beqz	a4,800003d0 <superalloc+0x54>
  for (int i = 0; i < NSUPERPG; i++) {
    800003ae:	2485                	addiw	s1,s1,1
    800003b0:	0785                	addi	a5,a5,1
    800003b2:	fed49be3          	bne	s1,a3,800003a8 <superalloc+0x2c>
      uint64 pa = superpages_physaddr_start + (uint64)i * SUPERPGSIZE;
      memset((void*)pa, 0, SUPERPGSIZE); // Zero out the superpage
      return (void*)pa;
    }
  }
  release(&superlock);
    800003b6:	0000c517          	auipc	a0,0xc
    800003ba:	d0a50513          	addi	a0,a0,-758 # 8000c0c0 <superlock>
    800003be:	404060ef          	jal	800067c2 <release>
  // printf("superalloc: out of superpages!\n"); // Optional: uncomment for debugging
  return 0; // No free superpages found
    800003c2:	4481                	li	s1,0
}
    800003c4:	8526                	mv	a0,s1
    800003c6:	60e2                	ld	ra,24(sp)
    800003c8:	6442                	ld	s0,16(sp)
    800003ca:	64a2                	ld	s1,8(sp)
    800003cc:	6105                	addi	sp,sp,32
    800003ce:	8082                	ret
      superpages_status[i] = 1;    // Mark as used
    800003d0:	0000c797          	auipc	a5,0xc
    800003d4:	af078793          	addi	a5,a5,-1296 # 8000bec0 <superpages_status>
    800003d8:	97a6                	add	a5,a5,s1
    800003da:	4705                	li	a4,1
    800003dc:	00e78023          	sb	a4,0(a5)
      release(&superlock);
    800003e0:	0000c517          	auipc	a0,0xc
    800003e4:	ce050513          	addi	a0,a0,-800 # 8000c0c0 <superlock>
    800003e8:	3da060ef          	jal	800067c2 <release>
      uint64 pa = superpages_physaddr_start + (uint64)i * SUPERPGSIZE;
    800003ec:	04d6                	slli	s1,s1,0x15
    800003ee:	0000c797          	auipc	a5,0xc
    800003f2:	aca7b783          	ld	a5,-1334(a5) # 8000beb8 <superpages_physaddr_start>
    800003f6:	94be                	add	s1,s1,a5
      memset((void*)pa, 0, SUPERPGSIZE); // Zero out the superpage
    800003f8:	00200637          	lui	a2,0x200
    800003fc:	4581                	li	a1,0
    800003fe:	8526                	mv	a0,s1
    80000400:	0ae000ef          	jal	800004ae <memset>
      return (void*)pa;
    80000404:	b7c1                	j	800003c4 <superalloc+0x48>

0000000080000406 <superfree>:

// Free a 2MB-aligned physical superpage.
// 'pa' must be a pointer previously returned by superalloc().
void
superfree(void *pa) 
{
    80000406:	1101                	addi	sp,sp,-32
    80000408:	ec06                	sd	ra,24(sp)
    8000040a:	e822                	sd	s0,16(sp)
    8000040c:	e426                	sd	s1,8(sp)
    8000040e:	1000                	addi	s0,sp,32
  if (!superpages_pool_active) { // Pool not active, something is wrong if we try to free
    80000410:	0000c797          	auipc	a5,0xc
    80000414:	aa07a783          	lw	a5,-1376(a5) # 8000beb0 <superpages_pool_active>
    80000418:	c3bd                	beqz	a5,8000047e <superfree+0x78>
    panic("superfree: called but superpage pool is not active"); 
  }
  // Validate that 'pa' is within the managed superpage pool range
  if ((uint64)pa < superpages_physaddr_start ||
    8000041a:	0000c717          	auipc	a4,0xc
    8000041e:	a9e73703          	ld	a4,-1378(a4) # 8000beb8 <superpages_physaddr_start>
    80000422:	06e56463          	bltu	a0,a4,8000048a <superfree+0x84>
      (uint64)pa >= superpages_physaddr_start + (uint64)NSUPERPG * SUPERPGSIZE)
    80000426:	010007b7          	lui	a5,0x1000
    8000042a:	97ba                	add	a5,a5,a4
  if ((uint64)pa < superpages_physaddr_start ||
    8000042c:	04f57f63          	bgeu	a0,a5,8000048a <superfree+0x84>
  {
    panic("superfree: physical address out of superpage pool range"); 
  }
  // Validate that 'pa' is aligned to a SUPERPGSIZE boundary
  if (((uint64)pa - superpages_physaddr_start) % SUPERPGSIZE != 0) {
    80000430:	8d19                	sub	a0,a0,a4
    80000432:	02b51793          	slli	a5,a0,0x2b
    80000436:	e3a5                	bnez	a5,80000496 <superfree+0x90>
    panic("superfree: physical address not superpage aligned"); 
  }

  int index = ((uint64)pa - superpages_physaddr_start) / SUPERPGSIZE;
    80000438:	8155                	srli	a0,a0,0x15
    8000043a:	0005049b          	sext.w	s1,a0

  acquire(&superlock);
    8000043e:	0000c517          	auipc	a0,0xc
    80000442:	c8250513          	addi	a0,a0,-894 # 8000c0c0 <superlock>
    80000446:	2b0060ef          	jal	800066f6 <acquire>
  if (superpages_status[index] == 0) { // Check if trying to free an already free page
    8000044a:	0000c797          	auipc	a5,0xc
    8000044e:	a7678793          	addi	a5,a5,-1418 # 8000bec0 <superpages_status>
    80000452:	97a6                	add	a5,a5,s1
    80000454:	0007c783          	lbu	a5,0(a5)
    80000458:	c7a9                	beqz	a5,800004a2 <superfree+0x9c>
    panic("superfree: freeing an already free superpage"); 
  }
  superpages_status[index] = 0; // Mark as free
    8000045a:	0000c797          	auipc	a5,0xc
    8000045e:	a6678793          	addi	a5,a5,-1434 # 8000bec0 <superpages_status>
    80000462:	97a6                	add	a5,a5,s1
    80000464:	00078023          	sb	zero,0(a5)
  // Optionally, could fill with junk like kfree does for 4KB pages, e.g., memset(pa, 2, SUPERPGSIZE);
  release(&superlock);
    80000468:	0000c517          	auipc	a0,0xc
    8000046c:	c5850513          	addi	a0,a0,-936 # 8000c0c0 <superlock>
    80000470:	352060ef          	jal	800067c2 <release>
}
    80000474:	60e2                	ld	ra,24(sp)
    80000476:	6442                	ld	s0,16(sp)
    80000478:	64a2                	ld	s1,8(sp)
    8000047a:	6105                	addi	sp,sp,32
    8000047c:	8082                	ret
    panic("superfree: called but superpage pool is not active"); 
    8000047e:	00008517          	auipc	a0,0x8
    80000482:	d0250513          	addi	a0,a0,-766 # 80008180 <etext+0x180>
    80000486:	71d050ef          	jal	800063a2 <panic>
    panic("superfree: physical address out of superpage pool range"); 
    8000048a:	00008517          	auipc	a0,0x8
    8000048e:	d2e50513          	addi	a0,a0,-722 # 800081b8 <etext+0x1b8>
    80000492:	711050ef          	jal	800063a2 <panic>
    panic("superfree: physical address not superpage aligned"); 
    80000496:	00008517          	auipc	a0,0x8
    8000049a:	d5a50513          	addi	a0,a0,-678 # 800081f0 <etext+0x1f0>
    8000049e:	705050ef          	jal	800063a2 <panic>
    panic("superfree: freeing an already free superpage"); 
    800004a2:	00008517          	auipc	a0,0x8
    800004a6:	d8650513          	addi	a0,a0,-634 # 80008228 <etext+0x228>
    800004aa:	6f9050ef          	jal	800063a2 <panic>

00000000800004ae <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800004ae:	1141                	addi	sp,sp,-16
    800004b0:	e422                	sd	s0,8(sp)
    800004b2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800004b4:	ca19                	beqz	a2,800004ca <memset+0x1c>
    800004b6:	87aa                	mv	a5,a0
    800004b8:	1602                	slli	a2,a2,0x20
    800004ba:	9201                	srli	a2,a2,0x20
    800004bc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800004c0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800004c4:	0785                	addi	a5,a5,1
    800004c6:	fee79de3          	bne	a5,a4,800004c0 <memset+0x12>
  }
  return dst;
}
    800004ca:	6422                	ld	s0,8(sp)
    800004cc:	0141                	addi	sp,sp,16
    800004ce:	8082                	ret

00000000800004d0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800004d0:	1141                	addi	sp,sp,-16
    800004d2:	e422                	sd	s0,8(sp)
    800004d4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800004d6:	ca05                	beqz	a2,80000506 <memcmp+0x36>
    800004d8:	fff6069b          	addiw	a3,a2,-1 # 1fffff <_entry-0x7fe00001>
    800004dc:	1682                	slli	a3,a3,0x20
    800004de:	9281                	srli	a3,a3,0x20
    800004e0:	0685                	addi	a3,a3,1 # 1000001 <_entry-0x7effffff>
    800004e2:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800004e4:	00054783          	lbu	a5,0(a0)
    800004e8:	0005c703          	lbu	a4,0(a1)
    800004ec:	00e79863          	bne	a5,a4,800004fc <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800004f0:	0505                	addi	a0,a0,1
    800004f2:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800004f4:	fed518e3          	bne	a0,a3,800004e4 <memcmp+0x14>
  }

  return 0;
    800004f8:	4501                	li	a0,0
    800004fa:	a019                	j	80000500 <memcmp+0x30>
      return *s1 - *s2;
    800004fc:	40e7853b          	subw	a0,a5,a4
}
    80000500:	6422                	ld	s0,8(sp)
    80000502:	0141                	addi	sp,sp,16
    80000504:	8082                	ret
  return 0;
    80000506:	4501                	li	a0,0
    80000508:	bfe5                	j	80000500 <memcmp+0x30>

000000008000050a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000050a:	1141                	addi	sp,sp,-16
    8000050c:	e422                	sd	s0,8(sp)
    8000050e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000510:	c205                	beqz	a2,80000530 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000512:	02a5e263          	bltu	a1,a0,80000536 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000516:	1602                	slli	a2,a2,0x20
    80000518:	9201                	srli	a2,a2,0x20
    8000051a:	00c587b3          	add	a5,a1,a2
{
    8000051e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000520:	0585                	addi	a1,a1,1
    80000522:	0705                	addi	a4,a4,1
    80000524:	fff5c683          	lbu	a3,-1(a1)
    80000528:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000052c:	feb79ae3          	bne	a5,a1,80000520 <memmove+0x16>

  return dst;
}
    80000530:	6422                	ld	s0,8(sp)
    80000532:	0141                	addi	sp,sp,16
    80000534:	8082                	ret
  if(s < d && s + n > d){
    80000536:	02061693          	slli	a3,a2,0x20
    8000053a:	9281                	srli	a3,a3,0x20
    8000053c:	00d58733          	add	a4,a1,a3
    80000540:	fce57be3          	bgeu	a0,a4,80000516 <memmove+0xc>
    d += n;
    80000544:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000546:	fff6079b          	addiw	a5,a2,-1
    8000054a:	1782                	slli	a5,a5,0x20
    8000054c:	9381                	srli	a5,a5,0x20
    8000054e:	fff7c793          	not	a5,a5
    80000552:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000554:	177d                	addi	a4,a4,-1
    80000556:	16fd                	addi	a3,a3,-1
    80000558:	00074603          	lbu	a2,0(a4)
    8000055c:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000560:	fef71ae3          	bne	a4,a5,80000554 <memmove+0x4a>
    80000564:	b7f1                	j	80000530 <memmove+0x26>

0000000080000566 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000566:	1141                	addi	sp,sp,-16
    80000568:	e406                	sd	ra,8(sp)
    8000056a:	e022                	sd	s0,0(sp)
    8000056c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000056e:	f9dff0ef          	jal	8000050a <memmove>
}
    80000572:	60a2                	ld	ra,8(sp)
    80000574:	6402                	ld	s0,0(sp)
    80000576:	0141                	addi	sp,sp,16
    80000578:	8082                	ret

000000008000057a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000057a:	1141                	addi	sp,sp,-16
    8000057c:	e422                	sd	s0,8(sp)
    8000057e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000580:	ce11                	beqz	a2,8000059c <strncmp+0x22>
    80000582:	00054783          	lbu	a5,0(a0)
    80000586:	cf89                	beqz	a5,800005a0 <strncmp+0x26>
    80000588:	0005c703          	lbu	a4,0(a1)
    8000058c:	00f71a63          	bne	a4,a5,800005a0 <strncmp+0x26>
    n--, p++, q++;
    80000590:	367d                	addiw	a2,a2,-1
    80000592:	0505                	addi	a0,a0,1
    80000594:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000596:	f675                	bnez	a2,80000582 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000598:	4501                	li	a0,0
    8000059a:	a801                	j	800005aa <strncmp+0x30>
    8000059c:	4501                	li	a0,0
    8000059e:	a031                	j	800005aa <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    800005a0:	00054503          	lbu	a0,0(a0)
    800005a4:	0005c783          	lbu	a5,0(a1)
    800005a8:	9d1d                	subw	a0,a0,a5
}
    800005aa:	6422                	ld	s0,8(sp)
    800005ac:	0141                	addi	sp,sp,16
    800005ae:	8082                	ret

00000000800005b0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800005b0:	1141                	addi	sp,sp,-16
    800005b2:	e422                	sd	s0,8(sp)
    800005b4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800005b6:	87aa                	mv	a5,a0
    800005b8:	86b2                	mv	a3,a2
    800005ba:	367d                	addiw	a2,a2,-1
    800005bc:	02d05563          	blez	a3,800005e6 <strncpy+0x36>
    800005c0:	0785                	addi	a5,a5,1
    800005c2:	0005c703          	lbu	a4,0(a1)
    800005c6:	fee78fa3          	sb	a4,-1(a5)
    800005ca:	0585                	addi	a1,a1,1
    800005cc:	f775                	bnez	a4,800005b8 <strncpy+0x8>
    ;
  while(n-- > 0)
    800005ce:	873e                	mv	a4,a5
    800005d0:	9fb5                	addw	a5,a5,a3
    800005d2:	37fd                	addiw	a5,a5,-1
    800005d4:	00c05963          	blez	a2,800005e6 <strncpy+0x36>
    *s++ = 0;
    800005d8:	0705                	addi	a4,a4,1
    800005da:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800005de:	40e786bb          	subw	a3,a5,a4
    800005e2:	fed04be3          	bgtz	a3,800005d8 <strncpy+0x28>
  return os;
}
    800005e6:	6422                	ld	s0,8(sp)
    800005e8:	0141                	addi	sp,sp,16
    800005ea:	8082                	ret

00000000800005ec <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800005ec:	1141                	addi	sp,sp,-16
    800005ee:	e422                	sd	s0,8(sp)
    800005f0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800005f2:	02c05363          	blez	a2,80000618 <safestrcpy+0x2c>
    800005f6:	fff6069b          	addiw	a3,a2,-1
    800005fa:	1682                	slli	a3,a3,0x20
    800005fc:	9281                	srli	a3,a3,0x20
    800005fe:	96ae                	add	a3,a3,a1
    80000600:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000602:	00d58963          	beq	a1,a3,80000614 <safestrcpy+0x28>
    80000606:	0585                	addi	a1,a1,1
    80000608:	0785                	addi	a5,a5,1
    8000060a:	fff5c703          	lbu	a4,-1(a1)
    8000060e:	fee78fa3          	sb	a4,-1(a5)
    80000612:	fb65                	bnez	a4,80000602 <safestrcpy+0x16>
    ;
  *s = 0;
    80000614:	00078023          	sb	zero,0(a5)
  return os;
}
    80000618:	6422                	ld	s0,8(sp)
    8000061a:	0141                	addi	sp,sp,16
    8000061c:	8082                	ret

000000008000061e <strlen>:

int
strlen(const char *s)
{
    8000061e:	1141                	addi	sp,sp,-16
    80000620:	e422                	sd	s0,8(sp)
    80000622:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000624:	00054783          	lbu	a5,0(a0)
    80000628:	cf91                	beqz	a5,80000644 <strlen+0x26>
    8000062a:	0505                	addi	a0,a0,1
    8000062c:	87aa                	mv	a5,a0
    8000062e:	86be                	mv	a3,a5
    80000630:	0785                	addi	a5,a5,1
    80000632:	fff7c703          	lbu	a4,-1(a5)
    80000636:	ff65                	bnez	a4,8000062e <strlen+0x10>
    80000638:	40a6853b          	subw	a0,a3,a0
    8000063c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    8000063e:	6422                	ld	s0,8(sp)
    80000640:	0141                	addi	sp,sp,16
    80000642:	8082                	ret
  for(n = 0; s[n]; n++)
    80000644:	4501                	li	a0,0
    80000646:	bfe5                	j	8000063e <strlen+0x20>

0000000080000648 <k_strrev>:

// 辅助函数，反转字符串
// s: 要反转的字符串
// len: 字符串的有效长度 (不包括末尾的 \0，如果已添加)
void k_strrev(char *s, int len) {
    80000648:	1141                	addi	sp,sp,-16
    8000064a:	e422                	sd	s0,8(sp)
    8000064c:	0800                	addi	s0,sp,16
  for (int i = 0; i < len / 2; i++) {
    8000064e:	01f5d81b          	srliw	a6,a1,0x1f
    80000652:	00b8083b          	addw	a6,a6,a1
    80000656:	4785                	li	a5,1
    80000658:	02b7d563          	bge	a5,a1,80000682 <k_strrev+0x3a>
    8000065c:	4018581b          	sraiw	a6,a6,0x1
    80000660:	87aa                	mv	a5,a0
    80000662:	15fd                	addi	a1,a1,-1
    80000664:	952e                	add	a0,a0,a1
    80000666:	4701                	li	a4,0
      char t = s[i];
    80000668:	0007c683          	lbu	a3,0(a5)
      s[i] = s[len - 1 - i];
    8000066c:	00054603          	lbu	a2,0(a0)
    80000670:	00c78023          	sb	a2,0(a5)
      s[len - 1 - i] = t;
    80000674:	00d50023          	sb	a3,0(a0)
  for (int i = 0; i < len / 2; i++) {
    80000678:	2705                	addiw	a4,a4,1
    8000067a:	0785                	addi	a5,a5,1
    8000067c:	157d                	addi	a0,a0,-1
    8000067e:	ff0745e3          	blt	a4,a6,80000668 <k_strrev+0x20>
  }
}
    80000682:	6422                	ld	s0,8(sp)
    80000684:	0141                	addi	sp,sp,16
    80000686:	8082                	ret

0000000080000688 <k_itoa>:
// 简化版 itoa (整数转ASCII字符串)
// n: 要转换的整数
// s: 存储结果的字符缓冲区
// base: 转换的基数 (通常是10)
// 返回转换后的字符串长度 (不包括末尾的 \0)
int k_itoa(long long val, char *s, int base) {
    80000688:	1101                	addi	sp,sp,-32
    8000068a:	ec06                	sd	ra,24(sp)
    8000068c:	e822                	sd	s0,16(sp)
    8000068e:	e426                	sd	s1,8(sp)
    80000690:	1000                	addi	s0,sp,32
    80000692:	872a                	mv	a4,a0
    80000694:	852e                	mv	a0,a1
  int i = 0;
  int sign = 0;
  unsigned long long n;

  if (val == 0) {
    80000696:	cb09                	beqz	a4,800006a8 <k_itoa+0x20>
      s[i++] = '0';
      s[i] = '\0';
      return 1;
  }

  if (val < 0 && base == 10) {
    80000698:	02074063          	bltz	a4,800006b8 <k_itoa+0x30>
  int sign = 0;
    8000069c:	4581                	li	a1,0
      n = -val;
  } else {
      n = val;
  }

  while (n != 0) {
    8000069e:	86aa                	mv	a3,a0
    800006a0:	4801                	li	a6,0
      int rem = n % base;
    800006a2:	8e32                	mv	t3,a2
      s[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
    800006a4:	4325                	li	t1,9
    800006a6:	a83d                	j	800006e4 <k_itoa+0x5c>
      s[i++] = '0';
    800006a8:	03000793          	li	a5,48
    800006ac:	00f58023          	sb	a5,0(a1)
      s[i] = '\0';
    800006b0:	000580a3          	sb	zero,1(a1)
      return 1;
    800006b4:	4485                	li	s1,1
    800006b6:	a08d                	j	80000718 <k_itoa+0x90>
  if (val < 0 && base == 10) {
    800006b8:	47a9                	li	a5,10
    800006ba:	fef611e3          	bne	a2,a5,8000069c <k_itoa+0x14>
      n = -val;
    800006be:	40e00733          	neg	a4,a4
      sign = 1;
    800006c2:	4585                	li	a1,1
      n = -val;
    800006c4:	bfe9                	j	8000069e <k_itoa+0x16>
      s[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
    800006c6:	0307879b          	addiw	a5,a5,48
    800006ca:	0ff7f793          	zext.b	a5,a5
    800006ce:	0018049b          	addiw	s1,a6,1
    800006d2:	00f68023          	sb	a5,0(a3)
      n = n / base;
    800006d6:	02c757b3          	divu	a5,a4,a2
  while (n != 0) {
    800006da:	0685                	addi	a3,a3,1
    800006dc:	01c76f63          	bltu	a4,t3,800006fa <k_itoa+0x72>
    800006e0:	873e                	mv	a4,a5
    800006e2:	8826                	mv	a6,s1
      int rem = n % base;
    800006e4:	02c777b3          	remu	a5,a4,a2
      s[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
    800006e8:	0007889b          	sext.w	a7,a5
    800006ec:	fd135de3          	bge	t1,a7,800006c6 <k_itoa+0x3e>
    800006f0:	0577879b          	addiw	a5,a5,87
    800006f4:	0ff7f793          	zext.b	a5,a5
    800006f8:	bfd9                	j	800006ce <k_itoa+0x46>
  }

  if (sign) {
    800006fa:	c981                	beqz	a1,8000070a <k_itoa+0x82>
      s[i++] = '-';
    800006fc:	94aa                	add	s1,s1,a0
    800006fe:	02d00793          	li	a5,45
    80000702:	00f48023          	sb	a5,0(s1)
    80000706:	0028049b          	addiw	s1,a6,2
  }
  s[i] = '\0'; // Null terminate
    8000070a:	009507b3          	add	a5,a0,s1
    8000070e:	00078023          	sb	zero,0(a5)
  k_strrev(s, i); // 反转字符串，因为数字是反向生成的
    80000712:	85a6                	mv	a1,s1
    80000714:	f35ff0ef          	jal	80000648 <k_strrev>
  return i;       // 返回长度
    80000718:	8526                	mv	a0,s1
    8000071a:	60e2                	ld	ra,24(sp)
    8000071c:	6442                	ld	s0,16(sp)
    8000071e:	64a2                	ld	s1,8(sp)
    80000720:	6105                	addi	sp,sp,32
    80000722:	8082                	ret

0000000080000724 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000724:	1141                	addi	sp,sp,-16
    80000726:	e406                	sd	ra,8(sp)
    80000728:	e022                	sd	s0,0(sp)
    8000072a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000072c:	060010ef          	jal	8000178c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000730:	0000b717          	auipc	a4,0xb
    80000734:	79870713          	addi	a4,a4,1944 # 8000bec8 <started>
  if(cpuid() == 0){
    80000738:	c51d                	beqz	a0,80000766 <main+0x42>
    while(started == 0)
    8000073a:	431c                	lw	a5,0(a4)
    8000073c:	2781                	sext.w	a5,a5
    8000073e:	dff5                	beqz	a5,8000073a <main+0x16>
      ;
    __sync_synchronize();
    80000740:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000744:	048010ef          	jal	8000178c <cpuid>
    80000748:	85aa                	mv	a1,a0
    8000074a:	00008517          	auipc	a0,0x8
    8000074e:	b2e50513          	addi	a0,a0,-1234 # 80008278 <etext+0x278>
    80000752:	17f050ef          	jal	800060d0 <printf>
    kvminithart();    // turn on paging
    80000756:	084000ef          	jal	800007da <kvminithart>
    trapinithart();   // install kernel trap vector
    8000075a:	45d010ef          	jal	800023b6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000075e:	72b040ef          	jal	80005688 <plicinithart>
  }

  scheduler();        
    80000762:	580010ef          	jal	80001ce2 <scheduler>
    consoleinit();
    80000766:	095050ef          	jal	80005ffa <consoleinit>
    printfinit();
    8000076a:	473050ef          	jal	800063dc <printfinit>
    printf("\n");
    8000076e:	00008517          	auipc	a0,0x8
    80000772:	aea50513          	addi	a0,a0,-1302 # 80008258 <etext+0x258>
    80000776:	15b050ef          	jal	800060d0 <printf>
    printf("xv6 kernel is booting\n");
    8000077a:	00008517          	auipc	a0,0x8
    8000077e:	ae650513          	addi	a0,a0,-1306 # 80008260 <etext+0x260>
    80000782:	14f050ef          	jal	800060d0 <printf>
    printf("\n");
    80000786:	00008517          	auipc	a0,0x8
    8000078a:	ad250513          	addi	a0,a0,-1326 # 80008258 <etext+0x258>
    8000078e:	143050ef          	jal	800060d0 <printf>
    lockstatsinit(); // Initialize lock statistics system <--- 添加这行
    80000792:	6bf050ef          	jal	80006650 <lockstatsinit>
    kinit();         // physical page allocator
    80000796:	8f3ff0ef          	jal	80000088 <kinit>
    kvminit();       // create kernel page table
    8000079a:	336000ef          	jal	80000ad0 <kvminit>
    kvminithart();   // turn on paging
    8000079e:	03c000ef          	jal	800007da <kvminithart>
    procinit();      // process table
    800007a2:	735000ef          	jal	800016d6 <procinit>
    trapinit();      // trap vectors
    800007a6:	3ed010ef          	jal	80002392 <trapinit>
    trapinithart();  // install kernel trap vector
    800007aa:	40d010ef          	jal	800023b6 <trapinithart>
    plicinit();      // set up interrupt controller
    800007ae:	6c1040ef          	jal	8000566e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800007b2:	6d7040ef          	jal	80005688 <plicinithart>
    binit();         // buffer cache
    800007b6:	658020ef          	jal	80002e0e <binit>
    iinit();         // inode table
    800007ba:	483020ef          	jal	8000343c <iinit>
    fileinit();      // file table
    800007be:	22f030ef          	jal	800041ec <fileinit>
    virtio_disk_init(); // emulated hard disk
    800007c2:	7b7040ef          	jal	80005778 <virtio_disk_init>
    userinit();      // first user process
    800007c6:	25a010ef          	jal	80001a20 <userinit>
    __sync_synchronize();
    800007ca:	0330000f          	fence	rw,rw
    started = 1;
    800007ce:	4785                	li	a5,1
    800007d0:	0000b717          	auipc	a4,0xb
    800007d4:	6ef72c23          	sw	a5,1784(a4) # 8000bec8 <started>
    800007d8:	b769                	j	80000762 <main+0x3e>

00000000800007da <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800007da:	1141                	addi	sp,sp,-16
    800007dc:	e422                	sd	s0,8(sp)
    800007de:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    800007e0:	0000b797          	auipc	a5,0xb
    800007e4:	6f07b783          	ld	a5,1776(a5) # 8000bed0 <kernel_pagetable>
    800007e8:	83b1                	srli	a5,a5,0xc
    800007ea:	577d                	li	a4,-1
    800007ec:	177e                	slli	a4,a4,0x3f
    800007ee:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    800007f0:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800007f4:	12000073          	sfence.vma
  sfence_vma();
}
    800007f8:	6422                	ld	s0,8(sp)
    800007fa:	0141                	addi	sp,sp,16
    800007fc:	8082                	ret

00000000800007fe <walk>:
// Return the address of the PTE in page table pagetable
// that corresponds to virtual address va.  If alloc!=0,
// create any required page-table pages.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800007fe:	7139                	addi	sp,sp,-64
    80000800:	fc06                	sd	ra,56(sp)
    80000802:	f822                	sd	s0,48(sp)
    80000804:	f426                	sd	s1,40(sp)
    80000806:	f04a                	sd	s2,32(sp)
    80000808:	ec4e                	sd	s3,24(sp)
    8000080a:	e852                	sd	s4,16(sp)
    8000080c:	e456                	sd	s5,8(sp)
    8000080e:	e05a                	sd	s6,0(sp)
    80000810:	0080                	addi	s0,sp,64
    80000812:	84aa                	mv	s1,a0
    80000814:	89ae                	mv	s3,a1
    80000816:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    80000818:	57fd                	li	a5,-1
    8000081a:	83e9                	srli	a5,a5,0x1a
    8000081c:	4af9                	li	s5,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000081e:	4a09                	li	s4,2
  if(va >= MAXVA)
    80000820:	00b7fe63          	bgeu	a5,a1,8000083c <walk+0x3e>
    panic("walk");
    80000824:	00008517          	auipc	a0,0x8
    80000828:	a6c50513          	addi	a0,a0,-1428 # 80008290 <etext+0x290>
    8000082c:	377050ef          	jal	800063a2 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      if(level == 1 && (*pte & (PTE_R|PTE_W|PTE_X))) {
        return pte;
      }
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000830:	80a9                	srli	s1,s1,0xa
    80000832:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000834:	3a7d                	addiw	s4,s4,-1
    80000836:	3add                	addiw	s5,s5,-9
    80000838:	040a0663          	beqz	s4,80000884 <walk+0x86>
    pte_t *pte = &pagetable[PX(level, va)];
    8000083c:	0159d933          	srl	s2,s3,s5
    80000840:	1ff97913          	andi	s2,s2,511
    80000844:	090e                	slli	s2,s2,0x3
    80000846:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000848:	00093483          	ld	s1,0(s2)
    8000084c:	0014f793          	andi	a5,s1,1
    80000850:	cb81                	beqz	a5,80000860 <walk+0x62>
      if(level == 1 && (*pte & (PTE_R|PTE_W|PTE_X))) {
    80000852:	4785                	li	a5,1
    80000854:	fcfa1ee3          	bne	s4,a5,80000830 <walk+0x32>
    80000858:	00e4f793          	andi	a5,s1,14
    8000085c:	dbf1                	beqz	a5,80000830 <walk+0x32>
    8000085e:	a815                	j	80000892 <walk+0x94>
    } else {
      if(!alloc || (pagetable = (pte_t*)kalloc()) == 0)
    80000860:	040b0463          	beqz	s6,800008a8 <walk+0xaa>
    80000864:	a3dff0ef          	jal	800002a0 <kalloc>
    80000868:	84aa                	mv	s1,a0
    8000086a:	c129                	beqz	a0,800008ac <walk+0xae>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000086c:	6605                	lui	a2,0x1
    8000086e:	4581                	li	a1,0
    80000870:	c3fff0ef          	jal	800004ae <memset>
      *pte = PA2PTE((uint64)pagetable) | PTE_V;
    80000874:	00c4d793          	srli	a5,s1,0xc
    80000878:	07aa                	slli	a5,a5,0xa
    8000087a:	0017e793          	ori	a5,a5,1
    8000087e:	00f93023          	sd	a5,0(s2)
    80000882:	bf4d                	j	80000834 <walk+0x36>
    }
  }
  return &pagetable[PX(0, va)];
    80000884:	00c9d993          	srli	s3,s3,0xc
    80000888:	1ff9f993          	andi	s3,s3,511
    8000088c:	098e                	slli	s3,s3,0x3
    8000088e:	01348933          	add	s2,s1,s3
}
    80000892:	854a                	mv	a0,s2
    80000894:	70e2                	ld	ra,56(sp)
    80000896:	7442                	ld	s0,48(sp)
    80000898:	74a2                	ld	s1,40(sp)
    8000089a:	7902                	ld	s2,32(sp)
    8000089c:	69e2                	ld	s3,24(sp)
    8000089e:	6a42                	ld	s4,16(sp)
    800008a0:	6aa2                	ld	s5,8(sp)
    800008a2:	6b02                	ld	s6,0(sp)
    800008a4:	6121                	addi	sp,sp,64
    800008a6:	8082                	ret
        return 0;
    800008a8:	4901                	li	s2,0
    800008aa:	b7e5                	j	80000892 <walk+0x94>
    800008ac:	892a                	mv	s2,a0
    800008ae:	b7d5                	j	80000892 <walk+0x94>

00000000800008b0 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800008b0:	57fd                	li	a5,-1
    800008b2:	83e9                	srli	a5,a5,0x1a
    800008b4:	00b7f463          	bgeu	a5,a1,800008bc <walkaddr+0xc>
    return 0;
    800008b8:	4501                	li	a0,0
      }
  }

  // It's a 4KB page
  return pa + (va & (PGSIZE - 1));
}
    800008ba:	8082                	ret
{
    800008bc:	1101                	addi	sp,sp,-32
    800008be:	ec06                	sd	ra,24(sp)
    800008c0:	e822                	sd	s0,16(sp)
    800008c2:	e426                	sd	s1,8(sp)
    800008c4:	e04a                	sd	s2,0(sp)
    800008c6:	1000                	addi	s0,sp,32
    800008c8:	892a                	mv	s2,a0
    800008ca:	84ae                	mv	s1,a1
  pte = walk(pagetable, va, 0);
    800008cc:	4601                	li	a2,0
    800008ce:	f31ff0ef          	jal	800007fe <walk>
    800008d2:	872a                	mv	a4,a0
  if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0)
    800008d4:	c135                	beqz	a0,80000938 <walkaddr+0x88>
    800008d6:	611c                	ld	a5,0(a0)
    800008d8:	0117f613          	andi	a2,a5,17
    800008dc:	46c5                	li	a3,17
    return 0;
    800008de:	4501                	li	a0,0
  if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0)
    800008e0:	02d61663          	bne	a2,a3,8000090c <walkaddr+0x5c>
  if((*pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008e4:	00e7f513          	andi	a0,a5,14
    800008e8:	c115                	beqz	a0,8000090c <walkaddr+0x5c>
  pa = PTE2PA(*pte);
    800008ea:	83a9                	srli	a5,a5,0xa
    800008ec:	07b2                	slli	a5,a5,0xc
  pte_t* l2_pte = &pagetable[PX(2, va)];
    800008ee:	01e4d693          	srli	a3,s1,0x1e
  if(!(*l2_pte & PTE_V) || (*l2_pte & (PTE_R|PTE_W|PTE_X))) {
    800008f2:	068e                	slli	a3,a3,0x3
    800008f4:	00d90533          	add	a0,s2,a3
    800008f8:	6114                	ld	a3,0(a0)
    800008fa:	00f6f593          	andi	a1,a3,15
    800008fe:	4605                	li	a2,1
    80000900:	00c58c63          	beq	a1,a2,80000918 <walkaddr+0x68>
  return pa + (va & (PGSIZE - 1));
    80000904:	14d2                	slli	s1,s1,0x34
    80000906:	90d1                	srli	s1,s1,0x34
    80000908:	00f48533          	add	a0,s1,a5
}
    8000090c:	60e2                	ld	ra,24(sp)
    8000090e:	6442                	ld	s0,16(sp)
    80000910:	64a2                	ld	s1,8(sp)
    80000912:	6902                	ld	s2,0(sp)
    80000914:	6105                	addi	sp,sp,32
    80000916:	8082                	ret
      pagetable_t l1_table = (pagetable_t)PTE2PA(*l2_pte);
    80000918:	82a9                	srli	a3,a3,0xa
    8000091a:	06b2                	slli	a3,a3,0xc
      if(&l1_table[PX(1, va)] == pte) { // It's an L1 PTE
    8000091c:	0154d613          	srli	a2,s1,0x15
    80000920:	1ff67613          	andi	a2,a2,511
    80000924:	060e                	slli	a2,a2,0x3
    80000926:	96b2                	add	a3,a3,a2
    80000928:	fcd71ee3          	bne	a4,a3,80000904 <walkaddr+0x54>
          return pa + (va & (SUPERPGSIZE - 1));
    8000092c:	02b49713          	slli	a4,s1,0x2b
    80000930:	932d                	srli	a4,a4,0x2b
    80000932:	00f70533          	add	a0,a4,a5
    80000936:	bfd9                	j	8000090c <walkaddr+0x5c>
    return 0;
    80000938:	4501                	li	a0,0
    8000093a:	bfc9                	j	8000090c <walkaddr+0x5c>

000000008000093c <mappages>:

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size MUST be page-aligned.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000093c:	715d                	addi	sp,sp,-80
    8000093e:	e486                	sd	ra,72(sp)
    80000940:	e0a2                	sd	s0,64(sp)
    80000942:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if (size == 0)
    80000944:	ce39                	beqz	a2,800009a2 <mappages+0x66>
    80000946:	ec56                	sd	s5,24(sp)
    80000948:	e85a                	sd	s6,16(sp)
    8000094a:	8aaa                	mv	s5,a0
    8000094c:	8b3a                	mv	s6,a4
    panic("mappages: size is 0");
  
  // 确保 va 和 size 都是页面大小的倍数。
  // 虽然调用者应该保证，但在这里检查更安全。
  if (va % PGSIZE != 0 || size % PGSIZE != 0)
    8000094e:	00b667b3          	or	a5,a2,a1
    80000952:	17d2                	slli	a5,a5,0x34
    80000954:	e7a5                	bnez	a5,800009bc <mappages+0x80>
    80000956:	f84a                	sd	s2,48(sp)
    80000958:	f44e                	sd	s3,40(sp)
    8000095a:	f052                	sd	s4,32(sp)
    8000095c:	e45e                	sd	s7,8(sp)
    panic("mappages: va or size not page-aligned");

  // 使用一个清晰的 for 循环，避免 off-by-one 错误
  for(a = va; a < va + size; a += PGSIZE, pa += PGSIZE){
    8000095e:	00b609b3          	add	s3,a2,a1
    80000962:	892e                	mv	s2,a1
    80000964:	40b68a33          	sub	s4,a3,a1
    80000968:	6b85                	lui	s7,0x1
    if(*pte & PTE_V)
      panic("mappages: remap"); // 尝试重新映射
    *pte = PA2PTE(pa) | perm | PTE_V;
  }

  return 0;
    8000096a:	4501                	li	a0,0
  for(a = va; a < va + size; a += PGSIZE, pa += PGSIZE){
    8000096c:	0735fb63          	bgeu	a1,s3,800009e2 <mappages+0xa6>
    80000970:	fc26                	sd	s1,56(sp)
    80000972:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000976:	4605                	li	a2,1
    80000978:	85ca                	mv	a1,s2
    8000097a:	8556                	mv	a0,s5
    8000097c:	e83ff0ef          	jal	800007fe <walk>
    80000980:	cd39                	beqz	a0,800009de <mappages+0xa2>
    if(*pte & PTE_V)
    80000982:	611c                	ld	a5,0(a0)
    80000984:	8b85                	andi	a5,a5,1
    80000986:	e7b1                	bnez	a5,800009d2 <mappages+0x96>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000988:	80b1                	srli	s1,s1,0xc
    8000098a:	04aa                	slli	s1,s1,0xa
    8000098c:	0164e4b3          	or	s1,s1,s6
    80000990:	0014e493          	ori	s1,s1,1
    80000994:	e104                	sd	s1,0(a0)
  for(a = va; a < va + size; a += PGSIZE, pa += PGSIZE){
    80000996:	995e                	add	s2,s2,s7
    80000998:	fd396de3          	bltu	s2,s3,80000972 <mappages+0x36>
  return 0;
    8000099c:	4501                	li	a0,0
    8000099e:	74e2                	ld	s1,56(sp)
    800009a0:	a089                	j	800009e2 <mappages+0xa6>
    800009a2:	fc26                	sd	s1,56(sp)
    800009a4:	f84a                	sd	s2,48(sp)
    800009a6:	f44e                	sd	s3,40(sp)
    800009a8:	f052                	sd	s4,32(sp)
    800009aa:	ec56                	sd	s5,24(sp)
    800009ac:	e85a                	sd	s6,16(sp)
    800009ae:	e45e                	sd	s7,8(sp)
    panic("mappages: size is 0");
    800009b0:	00008517          	auipc	a0,0x8
    800009b4:	8e850513          	addi	a0,a0,-1816 # 80008298 <etext+0x298>
    800009b8:	1eb050ef          	jal	800063a2 <panic>
    800009bc:	fc26                	sd	s1,56(sp)
    800009be:	f84a                	sd	s2,48(sp)
    800009c0:	f44e                	sd	s3,40(sp)
    800009c2:	f052                	sd	s4,32(sp)
    800009c4:	e45e                	sd	s7,8(sp)
    panic("mappages: va or size not page-aligned");
    800009c6:	00008517          	auipc	a0,0x8
    800009ca:	8ea50513          	addi	a0,a0,-1814 # 800082b0 <etext+0x2b0>
    800009ce:	1d5050ef          	jal	800063a2 <panic>
      panic("mappages: remap"); // 尝试重新映射
    800009d2:	00008517          	auipc	a0,0x8
    800009d6:	90650513          	addi	a0,a0,-1786 # 800082d8 <etext+0x2d8>
    800009da:	1c9050ef          	jal	800063a2 <panic>
      return -1; // kalloc 失败
    800009de:	557d                	li	a0,-1
    800009e0:	74e2                	ld	s1,56(sp)
}
    800009e2:	7942                	ld	s2,48(sp)
    800009e4:	79a2                	ld	s3,40(sp)
    800009e6:	7a02                	ld	s4,32(sp)
    800009e8:	6ae2                	ld	s5,24(sp)
    800009ea:	6b42                	ld	s6,16(sp)
    800009ec:	6ba2                	ld	s7,8(sp)
    800009ee:	60a6                	ld	ra,72(sp)
    800009f0:	6406                	ld	s0,64(sp)
    800009f2:	6161                	addi	sp,sp,80
    800009f4:	8082                	ret

00000000800009f6 <kvmmap>:
{
    800009f6:	1141                	addi	sp,sp,-16
    800009f8:	e406                	sd	ra,8(sp)
    800009fa:	e022                	sd	s0,0(sp)
    800009fc:	0800                	addi	s0,sp,16
    800009fe:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000a00:	86b2                	mv	a3,a2
    80000a02:	863e                	mv	a2,a5
    80000a04:	f39ff0ef          	jal	8000093c <mappages>
    80000a08:	e509                	bnez	a0,80000a12 <kvmmap+0x1c>
}
    80000a0a:	60a2                	ld	ra,8(sp)
    80000a0c:	6402                	ld	s0,0(sp)
    80000a0e:	0141                	addi	sp,sp,16
    80000a10:	8082                	ret
    panic("kvmmap");
    80000a12:	00008517          	auipc	a0,0x8
    80000a16:	8d650513          	addi	a0,a0,-1834 # 800082e8 <etext+0x2e8>
    80000a1a:	189050ef          	jal	800063a2 <panic>

0000000080000a1e <kvmmake>:
{
    80000a1e:	1101                	addi	sp,sp,-32
    80000a20:	ec06                	sd	ra,24(sp)
    80000a22:	e822                	sd	s0,16(sp)
    80000a24:	e426                	sd	s1,8(sp)
    80000a26:	e04a                	sd	s2,0(sp)
    80000a28:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000a2a:	877ff0ef          	jal	800002a0 <kalloc>
    80000a2e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000a30:	6605                	lui	a2,0x1
    80000a32:	4581                	li	a1,0
    80000a34:	a7bff0ef          	jal	800004ae <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000a38:	4719                	li	a4,6
    80000a3a:	6685                	lui	a3,0x1
    80000a3c:	10000637          	lui	a2,0x10000
    80000a40:	100005b7          	lui	a1,0x10000
    80000a44:	8526                	mv	a0,s1
    80000a46:	fb1ff0ef          	jal	800009f6 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000a4a:	4719                	li	a4,6
    80000a4c:	6685                	lui	a3,0x1
    80000a4e:	10001637          	lui	a2,0x10001
    80000a52:	100015b7          	lui	a1,0x10001
    80000a56:	8526                	mv	a0,s1
    80000a58:	f9fff0ef          	jal	800009f6 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000a5c:	4719                	li	a4,6
    80000a5e:	004006b7          	lui	a3,0x400
    80000a62:	0c000637          	lui	a2,0xc000
    80000a66:	0c0005b7          	lui	a1,0xc000
    80000a6a:	8526                	mv	a0,s1
    80000a6c:	f8bff0ef          	jal	800009f6 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000a70:	00007917          	auipc	s2,0x7
    80000a74:	59090913          	addi	s2,s2,1424 # 80008000 <etext>
    80000a78:	4729                	li	a4,10
    80000a7a:	80007697          	auipc	a3,0x80007
    80000a7e:	58668693          	addi	a3,a3,1414 # 8000 <_entry-0x7fff8000>
    80000a82:	4605                	li	a2,1
    80000a84:	067e                	slli	a2,a2,0x1f
    80000a86:	85b2                	mv	a1,a2
    80000a88:	8526                	mv	a0,s1
    80000a8a:	f6dff0ef          	jal	800009f6 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000a8e:	46c5                	li	a3,17
    80000a90:	06ee                	slli	a3,a3,0x1b
    80000a92:	4719                	li	a4,6
    80000a94:	412686b3          	sub	a3,a3,s2
    80000a98:	864a                	mv	a2,s2
    80000a9a:	85ca                	mv	a1,s2
    80000a9c:	8526                	mv	a0,s1
    80000a9e:	f59ff0ef          	jal	800009f6 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000aa2:	4729                	li	a4,10
    80000aa4:	6685                	lui	a3,0x1
    80000aa6:	00006617          	auipc	a2,0x6
    80000aaa:	55a60613          	addi	a2,a2,1370 # 80007000 <_trampoline>
    80000aae:	040005b7          	lui	a1,0x4000
    80000ab2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ab4:	05b2                	slli	a1,a1,0xc
    80000ab6:	8526                	mv	a0,s1
    80000ab8:	f3fff0ef          	jal	800009f6 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000abc:	8526                	mv	a0,s1
    80000abe:	381000ef          	jal	8000163e <proc_mapstacks>
}
    80000ac2:	8526                	mv	a0,s1
    80000ac4:	60e2                	ld	ra,24(sp)
    80000ac6:	6442                	ld	s0,16(sp)
    80000ac8:	64a2                	ld	s1,8(sp)
    80000aca:	6902                	ld	s2,0(sp)
    80000acc:	6105                	addi	sp,sp,32
    80000ace:	8082                	ret

0000000080000ad0 <kvminit>:
{
    80000ad0:	1141                	addi	sp,sp,-16
    80000ad2:	e406                	sd	ra,8(sp)
    80000ad4:	e022                	sd	s0,0(sp)
    80000ad6:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000ad8:	f47ff0ef          	jal	80000a1e <kvmmake>
    80000adc:	0000b797          	auipc	a5,0xb
    80000ae0:	3ea7ba23          	sd	a0,1012(a5) # 8000bed0 <kernel_pagetable>
}
    80000ae4:	60a2                	ld	ra,8(sp)
    80000ae6:	6402                	ld	s0,0(sp)
    80000ae8:	0141                	addi	sp,sp,16
    80000aea:	8082                	ret

0000000080000aec <uvmmap_super>:

// Map a 2MB superpage. va must be 2MB aligned. pa_super must be 2MB aligned.
int
uvmmap_super(pagetable_t pagetable, uint64 va, uint64 pa_super, int perm)
{
    80000aec:	7139                	addi	sp,sp,-64
    80000aee:	fc06                	sd	ra,56(sp)
    80000af0:	f822                	sd	s0,48(sp)
    80000af2:	f426                	sd	s1,40(sp)
    80000af4:	f04a                	sd	s2,32(sp)
    80000af6:	ec4e                	sd	s3,24(sp)
    80000af8:	e852                	sd	s4,16(sp)
    80000afa:	e456                	sd	s5,8(sp)
    80000afc:	0080                	addi	s0,sp,64
  if (va % SUPERPGSIZE != 0 || pa_super % SUPERPGSIZE != 0)
    80000afe:	00c5e7b3          	or	a5,a1,a2
    80000b02:	17ae                	slli	a5,a5,0x2b
    80000b04:	e7a5                	bnez	a5,80000b6c <uvmmap_super+0x80>
    80000b06:	84ae                	mv	s1,a1
    80000b08:	8932                	mv	s2,a2
    80000b0a:	8a36                	mv	s4,a3
    panic("uvmmap_super: unaligned va or pa_super");
  if (va >= MAXVA)
    80000b0c:	57fd                	li	a5,-1
    80000b0e:	83e9                	srli	a5,a5,0x1a
    80000b10:	06b7e463          	bltu	a5,a1,80000b78 <uvmmap_super+0x8c>
    panic("uvmmap_super: va out of bounds");
  
  pte_t *pte_l2 = &pagetable[PX(2, va)];
    80000b14:	01e5d793          	srli	a5,a1,0x1e
    80000b18:	078e                	slli	a5,a5,0x3
    80000b1a:	00f509b3          	add	s3,a0,a5
  pagetable_t l1_table;

  if (*pte_l2 & PTE_V) {
    80000b1e:	0009b503          	ld	a0,0(s3)
    80000b22:	00157793          	andi	a5,a0,1
    80000b26:	c7ad                	beqz	a5,80000b90 <uvmmap_super+0xa4>
    if (*pte_l2 & (PTE_R | PTE_W | PTE_X))
    80000b28:	00e57793          	andi	a5,a0,14
      panic("uvmmap_super: L2 entry is already a 1GB leaf page");
    l1_table = (pagetable_t)PTE2PA(*pte_l2);
    80000b2c:	8129                	srli	a0,a0,0xa
    80000b2e:	00c51a93          	slli	s5,a0,0xc
    if (*pte_l2 & (PTE_R | PTE_W | PTE_X))
    80000b32:	eba9                	bnez	a5,80000b84 <uvmmap_super+0x98>
    if ((l1_table = (pagetable_t)kalloc()) == 0) return -1;
    memset(l1_table, 0, PGSIZE);
    *pte_l2 = PA2PTE((uint64)l1_table) | PTE_V;
  }

  pte_t *l1_pte = &l1_table[PX(1, va)];
    80000b34:	80d5                	srli	s1,s1,0x15
    80000b36:	1ff4f493          	andi	s1,s1,511
    80000b3a:	048e                	slli	s1,s1,0x3
    80000b3c:	009a8533          	add	a0,s5,s1
  if (*l1_pte & PTE_V) panic("uvmmap_super: L1 PTE is already in use");
    80000b40:	611c                	ld	a5,0(a0)
    80000b42:	8b85                	andi	a5,a5,1
    80000b44:	e7b5                	bnez	a5,80000bb0 <uvmmap_super+0xc4>
  
  *l1_pte = PA2PTE(pa_super) | perm | PTE_V;
    80000b46:	00c95913          	srli	s2,s2,0xc
    80000b4a:	092a                	slli	s2,s2,0xa
    80000b4c:	01496933          	or	s2,s2,s4
    80000b50:	00196913          	ori	s2,s2,1
    80000b54:	01253023          	sd	s2,0(a0)
  return 0;
    80000b58:	4501                	li	a0,0
}
    80000b5a:	70e2                	ld	ra,56(sp)
    80000b5c:	7442                	ld	s0,48(sp)
    80000b5e:	74a2                	ld	s1,40(sp)
    80000b60:	7902                	ld	s2,32(sp)
    80000b62:	69e2                	ld	s3,24(sp)
    80000b64:	6a42                	ld	s4,16(sp)
    80000b66:	6aa2                	ld	s5,8(sp)
    80000b68:	6121                	addi	sp,sp,64
    80000b6a:	8082                	ret
    panic("uvmmap_super: unaligned va or pa_super");
    80000b6c:	00007517          	auipc	a0,0x7
    80000b70:	78450513          	addi	a0,a0,1924 # 800082f0 <etext+0x2f0>
    80000b74:	02f050ef          	jal	800063a2 <panic>
    panic("uvmmap_super: va out of bounds");
    80000b78:	00007517          	auipc	a0,0x7
    80000b7c:	7a050513          	addi	a0,a0,1952 # 80008318 <etext+0x318>
    80000b80:	023050ef          	jal	800063a2 <panic>
      panic("uvmmap_super: L2 entry is already a 1GB leaf page");
    80000b84:	00007517          	auipc	a0,0x7
    80000b88:	7b450513          	addi	a0,a0,1972 # 80008338 <etext+0x338>
    80000b8c:	017050ef          	jal	800063a2 <panic>
    if ((l1_table = (pagetable_t)kalloc()) == 0) return -1;
    80000b90:	f10ff0ef          	jal	800002a0 <kalloc>
    80000b94:	8aaa                	mv	s5,a0
    80000b96:	c11d                	beqz	a0,80000bbc <uvmmap_super+0xd0>
    memset(l1_table, 0, PGSIZE);
    80000b98:	6605                	lui	a2,0x1
    80000b9a:	4581                	li	a1,0
    80000b9c:	913ff0ef          	jal	800004ae <memset>
    *pte_l2 = PA2PTE((uint64)l1_table) | PTE_V;
    80000ba0:	00cad793          	srli	a5,s5,0xc
    80000ba4:	07aa                	slli	a5,a5,0xa
    80000ba6:	0017e793          	ori	a5,a5,1
    80000baa:	00f9b023          	sd	a5,0(s3)
    80000bae:	b759                	j	80000b34 <uvmmap_super+0x48>
  if (*l1_pte & PTE_V) panic("uvmmap_super: L1 PTE is already in use");
    80000bb0:	00007517          	auipc	a0,0x7
    80000bb4:	7c050513          	addi	a0,a0,1984 # 80008370 <etext+0x370>
    80000bb8:	7ea050ef          	jal	800063a2 <panic>
    if ((l1_table = (pagetable_t)kalloc()) == 0) return -1;
    80000bbc:	557d                	li	a0,-1
    80000bbe:	bf71                	j	80000b5a <uvmmap_super+0x6e>

0000000080000bc0 <uvmunmap>:
// Remove mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 size, int do_free)
{
    80000bc0:	715d                	addi	sp,sp,-80
    80000bc2:	e486                	sd	ra,72(sp)
    80000bc4:	e0a2                	sd	s0,64(sp)
    80000bc6:	0880                	addi	s0,sp,80
  if((va % PGSIZE) != 0) panic("uvmunmap: va not page-aligned");
    80000bc8:	03459793          	slli	a5,a1,0x34
    80000bcc:	efb9                	bnez	a5,80000c2a <uvmunmap+0x6a>
    80000bce:	fc26                	sd	s1,56(sp)
    80000bd0:	f44e                	sd	s3,40(sp)
    80000bd2:	f052                	sd	s4,32(sp)
    80000bd4:	89aa                	mv	s3,a0
    80000bd6:	84ae                	mv	s1,a1
    80000bd8:	8a36                	mv	s4,a3
  if(size == 0) return;
    80000bda:	c229                	beqz	a2,80000c1c <uvmunmap+0x5c>
    80000bdc:	f84a                	sd	s2,48(sp)
    
  uint64 end_va = va + size;
    80000bde:	00c58933          	add	s2,a1,a2

  for(uint64 a = va; a < end_va; ){
    80000be2:	1325f763          	bgeu	a1,s2,80000d10 <uvmunmap+0x150>
    80000be6:	ec56                	sd	s5,24(sp)
    80000be8:	e85a                	sd	s6,16(sp)
    80000bea:	e45e                	sd	s7,8(sp)
    pte_t *l2_pte = &pagetable[PX(2, a)];
    if(!(*l2_pte & PTE_V) || (*l2_pte & (PTE_R|PTE_W|PTE_X))) {
    80000bec:	4a85                	li	s5,1
      a = GIGAROUNDUP(a+1);
    80000bee:	40000bb7          	lui	s7,0x40000
    80000bf2:	c0000b37          	lui	s6,0xc0000
    pte_t *l2_pte = &pagetable[PX(2, a)];
    80000bf6:	01e4d793          	srli	a5,s1,0x1e
    80000bfa:	1ff7f793          	andi	a5,a5,511
    if(!(*l2_pte & PTE_V) || (*l2_pte & (PTE_R|PTE_W|PTE_X))) {
    80000bfe:	078e                	slli	a5,a5,0x3
    80000c00:	97ce                	add	a5,a5,s3
    80000c02:	639c                	ld	a5,0(a5)
    80000c04:	00f7f713          	andi	a4,a5,15
    80000c08:	03570f63          	beq	a4,s5,80000c46 <uvmunmap+0x86>
      a = GIGAROUNDUP(a+1);
    80000c0c:	94de                	add	s1,s1,s7
    80000c0e:	0164f4b3          	and	s1,s1,s6
      if (a == 0) break;
    80000c12:	ece1                	bnez	s1,80000cea <uvmunmap+0x12a>
    80000c14:	7942                	ld	s2,48(sp)
    80000c16:	6ae2                	ld	s5,24(sp)
    80000c18:	6b42                	ld	s6,16(sp)
    80000c1a:	6ba2                	ld	s7,8(sp)
    80000c1c:	74e2                	ld	s1,56(sp)
    80000c1e:	79a2                	ld	s3,40(sp)
    80000c20:	7a02                	ld	s4,32(sp)
        *pte = 0;
      }
      a += PGSIZE;
    }
  }
}
    80000c22:	60a6                	ld	ra,72(sp)
    80000c24:	6406                	ld	s0,64(sp)
    80000c26:	6161                	addi	sp,sp,80
    80000c28:	8082                	ret
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	e062                	sd	s8,0(sp)
  if((va % PGSIZE) != 0) panic("uvmunmap: va not page-aligned");
    80000c3a:	00007517          	auipc	a0,0x7
    80000c3e:	75e50513          	addi	a0,a0,1886 # 80008398 <etext+0x398>
    80000c42:	760050ef          	jal	800063a2 <panic>
    80000c46:	e062                	sd	s8,0(sp)
    pagetable_t l1_table = (pagetable_t)PTE2PA(*l2_pte);
    80000c48:	00a7dc13          	srli	s8,a5,0xa
    80000c4c:	0c32                	slli	s8,s8,0xc
    pte_t *l1_pte = &l1_table[PX(1, a)];
    80000c4e:	0154d793          	srli	a5,s1,0x15
    80000c52:	1ff7f793          	andi	a5,a5,511
    80000c56:	078e                	slli	a5,a5,0x3
    80000c58:	9c3e                	add	s8,s8,a5
    if(!(*l1_pte & PTE_V)) {
    80000c5a:	000c3503          	ld	a0,0(s8)
    80000c5e:	00157793          	andi	a5,a0,1
    80000c62:	e385                	bnez	a5,80000c82 <uvmunmap+0xc2>
      a = SUPERPGROUNDUP(a+1);
    80000c64:	002007b7          	lui	a5,0x200
    80000c68:	97a6                	add	a5,a5,s1
    80000c6a:	ffe004b7          	lui	s1,0xffe00
    80000c6e:	8cfd                	and	s1,s1,a5
      if (a == 0) break;
    80000c70:	e499                	bnez	s1,80000c7e <uvmunmap+0xbe>
    80000c72:	7942                	ld	s2,48(sp)
    80000c74:	6ae2                	ld	s5,24(sp)
    80000c76:	6b42                	ld	s6,16(sp)
    80000c78:	6ba2                	ld	s7,8(sp)
    80000c7a:	6c02                	ld	s8,0(sp)
    80000c7c:	b745                	j	80000c1c <uvmunmap+0x5c>
    80000c7e:	6c02                	ld	s8,0(sp)
    80000c80:	a0ad                	j	80000cea <uvmunmap+0x12a>
    if(*l1_pte & (PTE_R|PTE_W|PTE_X)) { // Superpage leaf
    80000c82:	00e57793          	andi	a5,a0,14
    80000c86:	cb85                	beqz	a5,80000cb6 <uvmunmap+0xf6>
      if (a % SUPERPGSIZE != 0) panic("uvmunmap: unaligned superpage unmap");
    80000c88:	02b49793          	slli	a5,s1,0x2b
    80000c8c:	eb91                	bnez	a5,80000ca0 <uvmunmap+0xe0>
      if (do_free) superfree((void*)PTE2PA(*l1_pte));
    80000c8e:	000a1f63          	bnez	s4,80000cac <uvmunmap+0xec>
      *l1_pte = 0;
    80000c92:	000c3023          	sd	zero,0(s8)
      a += SUPERPGSIZE;
    80000c96:	002007b7          	lui	a5,0x200
    80000c9a:	94be                	add	s1,s1,a5
    80000c9c:	6c02                	ld	s8,0(sp)
    80000c9e:	a0b1                	j	80000cea <uvmunmap+0x12a>
      if (a % SUPERPGSIZE != 0) panic("uvmunmap: unaligned superpage unmap");
    80000ca0:	00007517          	auipc	a0,0x7
    80000ca4:	71850513          	addi	a0,a0,1816 # 800083b8 <etext+0x3b8>
    80000ca8:	6fa050ef          	jal	800063a2 <panic>
      if (do_free) superfree((void*)PTE2PA(*l1_pte));
    80000cac:	8129                	srli	a0,a0,0xa
    80000cae:	0532                	slli	a0,a0,0xc
    80000cb0:	f56ff0ef          	jal	80000406 <superfree>
    80000cb4:	bff9                	j	80000c92 <uvmunmap+0xd2>
      pagetable_t l0_table = (pagetable_t)PTE2PA(*l1_pte);
    80000cb6:	00a55c13          	srli	s8,a0,0xa
    80000cba:	0c32                	slli	s8,s8,0xc
      pte_t *pte = &l0_table[PX(0, a)];
    80000cbc:	00c4d793          	srli	a5,s1,0xc
    80000cc0:	1ff7f793          	andi	a5,a5,511
    80000cc4:	078e                	slli	a5,a5,0x3
    80000cc6:	9c3e                	add	s8,s8,a5
      if(*pte & PTE_V) {
    80000cc8:	000c3783          	ld	a5,0(s8)
    80000ccc:	0017f713          	andi	a4,a5,1
    80000cd0:	cb11                	beqz	a4,80000ce4 <uvmunmap+0x124>
        if(PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: L0 pte is intermediate");
    80000cd2:	3ff7f713          	andi	a4,a5,1023
    80000cd6:	4685                	li	a3,1
    80000cd8:	02d70063          	beq	a4,a3,80000cf8 <uvmunmap+0x138>
        if(do_free) kfree((void*)PTE2PA(*pte));
    80000cdc:	020a1463          	bnez	s4,80000d04 <uvmunmap+0x144>
        *pte = 0;
    80000ce0:	000c3023          	sd	zero,0(s8)
      a += PGSIZE;
    80000ce4:	6785                	lui	a5,0x1
    80000ce6:	94be                	add	s1,s1,a5
    80000ce8:	6c02                	ld	s8,0(sp)
  for(uint64 a = va; a < end_va; ){
    80000cea:	f124e6e3          	bltu	s1,s2,80000bf6 <uvmunmap+0x36>
    80000cee:	7942                	ld	s2,48(sp)
    80000cf0:	6ae2                	ld	s5,24(sp)
    80000cf2:	6b42                	ld	s6,16(sp)
    80000cf4:	6ba2                	ld	s7,8(sp)
    80000cf6:	b71d                	j	80000c1c <uvmunmap+0x5c>
        if(PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: L0 pte is intermediate");
    80000cf8:	00007517          	auipc	a0,0x7
    80000cfc:	6e850513          	addi	a0,a0,1768 # 800083e0 <etext+0x3e0>
    80000d00:	6a2050ef          	jal	800063a2 <panic>
        if(do_free) kfree((void*)PTE2PA(*pte));
    80000d04:	83a9                	srli	a5,a5,0xa
    80000d06:	00c79513          	slli	a0,a5,0xc
    80000d0a:	cdcff0ef          	jal	800001e6 <kfree>
    80000d0e:	bfc9                	j	80000ce0 <uvmunmap+0x120>
    80000d10:	7942                	ld	s2,48(sp)
    80000d12:	b729                	j	80000c1c <uvmunmap+0x5c>

0000000080000d14 <uvmcreate>:

// create an empty user page table.
pagetable_t
uvmcreate()
{
    80000d14:	1101                	addi	sp,sp,-32
    80000d16:	ec06                	sd	ra,24(sp)
    80000d18:	e822                	sd	s0,16(sp)
    80000d1a:	e426                	sd	s1,8(sp)
    80000d1c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000d1e:	d82ff0ef          	jal	800002a0 <kalloc>
    80000d22:	84aa                	mv	s1,a0
  if(pagetable == 0) return 0;
    80000d24:	c509                	beqz	a0,80000d2e <uvmcreate+0x1a>
  memset(pagetable, 0, PGSIZE);
    80000d26:	6605                	lui	a2,0x1
    80000d28:	4581                	li	a1,0
    80000d2a:	f84ff0ef          	jal	800004ae <memset>
  return pagetable;
}
    80000d2e:	8526                	mv	a0,s1
    80000d30:	60e2                	ld	ra,24(sp)
    80000d32:	6442                	ld	s0,16(sp)
    80000d34:	64a2                	ld	s1,8(sp)
    80000d36:	6105                	addi	sp,sp,32
    80000d38:	8082                	ret

0000000080000d3a <uvmfirst>:

// Load the user initcode into address 0 of pagetable.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000d3a:	7179                	addi	sp,sp,-48
    80000d3c:	f406                	sd	ra,40(sp)
    80000d3e:	f022                	sd	s0,32(sp)
    80000d40:	ec26                	sd	s1,24(sp)
    80000d42:	e84a                	sd	s2,16(sp)
    80000d44:	e44e                	sd	s3,8(sp)
    80000d46:	e052                	sd	s4,0(sp)
    80000d48:	1800                	addi	s0,sp,48
  char *mem;
  if(sz >= PGSIZE) panic("uvmfirst: more than a page");
    80000d4a:	6785                	lui	a5,0x1
    80000d4c:	04f67063          	bgeu	a2,a5,80000d8c <uvmfirst+0x52>
    80000d50:	8a2a                	mv	s4,a0
    80000d52:	89ae                	mv	s3,a1
    80000d54:	84b2                	mv	s1,a2
  mem = kalloc();
    80000d56:	d4aff0ef          	jal	800002a0 <kalloc>
    80000d5a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000d5c:	6605                	lui	a2,0x1
    80000d5e:	4581                	li	a1,0
    80000d60:	f4eff0ef          	jal	800004ae <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000d64:	4779                	li	a4,30
    80000d66:	86ca                	mv	a3,s2
    80000d68:	6605                	lui	a2,0x1
    80000d6a:	4581                	li	a1,0
    80000d6c:	8552                	mv	a0,s4
    80000d6e:	bcfff0ef          	jal	8000093c <mappages>
  memmove(mem, src, sz);
    80000d72:	8626                	mv	a2,s1
    80000d74:	85ce                	mv	a1,s3
    80000d76:	854a                	mv	a0,s2
    80000d78:	f92ff0ef          	jal	8000050a <memmove>
}
    80000d7c:	70a2                	ld	ra,40(sp)
    80000d7e:	7402                	ld	s0,32(sp)
    80000d80:	64e2                	ld	s1,24(sp)
    80000d82:	6942                	ld	s2,16(sp)
    80000d84:	69a2                	ld	s3,8(sp)
    80000d86:	6a02                	ld	s4,0(sp)
    80000d88:	6145                	addi	sp,sp,48
    80000d8a:	8082                	ret
  if(sz >= PGSIZE) panic("uvmfirst: more than a page");
    80000d8c:	00007517          	auipc	a0,0x7
    80000d90:	67c50513          	addi	a0,a0,1660 # 80008408 <etext+0x408>
    80000d94:	60e050ef          	jal	800063a2 <panic>

0000000080000d98 <uvmdealloc>:
}

// Deallocate user pages to bring the process size from oldsz to newsz.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000d98:	872a                	mv	a4,a0
    80000d9a:	852e                	mv	a0,a1
  if(newsz >= oldsz) return oldsz;
    80000d9c:	00b66363          	bltu	a2,a1,80000da2 <uvmdealloc+0xa>
  uvmunmap(pagetable, PGROUNDUP(newsz), PGROUNDUP(oldsz) - PGROUNDUP(newsz), 1);
  return newsz;
}
    80000da0:	8082                	ret
{
    80000da2:	1101                	addi	sp,sp,-32
    80000da4:	ec06                	sd	ra,24(sp)
    80000da6:	e822                	sd	s0,16(sp)
    80000da8:	e426                	sd	s1,8(sp)
    80000daa:	1000                	addi	s0,sp,32
    80000dac:	84b2                	mv	s1,a2
  uvmunmap(pagetable, PGROUNDUP(newsz), PGROUNDUP(oldsz) - PGROUNDUP(newsz), 1);
    80000dae:	6785                	lui	a5,0x1
    80000db0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000db2:	00f605b3          	add	a1,a2,a5
    80000db6:	76fd                	lui	a3,0xfffff
    80000db8:	8df5                	and	a1,a1,a3
    80000dba:	97aa                	add	a5,a5,a0
    80000dbc:	8ff5                	and	a5,a5,a3
    80000dbe:	4685                	li	a3,1
    80000dc0:	40b78633          	sub	a2,a5,a1
    80000dc4:	853a                	mv	a0,a4
    80000dc6:	dfbff0ef          	jal	80000bc0 <uvmunmap>
  return newsz;
    80000dca:	8526                	mv	a0,s1
}
    80000dcc:	60e2                	ld	ra,24(sp)
    80000dce:	6442                	ld	s0,16(sp)
    80000dd0:	64a2                	ld	s1,8(sp)
    80000dd2:	6105                	addi	sp,sp,32
    80000dd4:	8082                	ret

0000000080000dd6 <uvmalloc>:
  if(newsz < oldsz) return oldsz;
    80000dd6:	08b66f63          	bltu	a2,a1,80000e74 <uvmalloc+0x9e>
{
    80000dda:	7139                	addi	sp,sp,-64
    80000ddc:	fc06                	sd	ra,56(sp)
    80000dde:	f822                	sd	s0,48(sp)
    80000de0:	ec4e                	sd	s3,24(sp)
    80000de2:	e852                	sd	s4,16(sp)
    80000de4:	e456                	sd	s5,8(sp)
    80000de6:	0080                	addi	s0,sp,64
    80000de8:	8aaa                	mv	s5,a0
    80000dea:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000dec:	6785                	lui	a5,0x1
    80000dee:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000df0:	95be                	add	a1,a1,a5
    80000df2:	77fd                	lui	a5,0xfffff
    80000df4:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000df8:	08c9f063          	bgeu	s3,a2,80000e78 <uvmalloc+0xa2>
    80000dfc:	f426                	sd	s1,40(sp)
    80000dfe:	f04a                	sd	s2,32(sp)
    80000e00:	e05a                	sd	s6,0(sp)
    80000e02:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000e04:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000e08:	c98ff0ef          	jal	800002a0 <kalloc>
    80000e0c:	84aa                	mv	s1,a0
    if(mem == 0){
    80000e0e:	c515                	beqz	a0,80000e3a <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000e10:	6605                	lui	a2,0x1
    80000e12:	4581                	li	a1,0
    80000e14:	e9aff0ef          	jal	800004ae <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000e18:	875a                	mv	a4,s6
    80000e1a:	86a6                	mv	a3,s1
    80000e1c:	6605                	lui	a2,0x1
    80000e1e:	85ca                	mv	a1,s2
    80000e20:	8556                	mv	a0,s5
    80000e22:	b1bff0ef          	jal	8000093c <mappages>
    80000e26:	e915                	bnez	a0,80000e5a <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000e28:	6785                	lui	a5,0x1
    80000e2a:	993e                	add	s2,s2,a5
    80000e2c:	fd496ee3          	bltu	s2,s4,80000e08 <uvmalloc+0x32>
  return newsz;
    80000e30:	8552                	mv	a0,s4
    80000e32:	74a2                	ld	s1,40(sp)
    80000e34:	7902                	ld	s2,32(sp)
    80000e36:	6b02                	ld	s6,0(sp)
    80000e38:	a811                	j	80000e4c <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    80000e3a:	864e                	mv	a2,s3
    80000e3c:	85ca                	mv	a1,s2
    80000e3e:	8556                	mv	a0,s5
    80000e40:	f59ff0ef          	jal	80000d98 <uvmdealloc>
      return 0;
    80000e44:	4501                	li	a0,0
    80000e46:	74a2                	ld	s1,40(sp)
    80000e48:	7902                	ld	s2,32(sp)
    80000e4a:	6b02                	ld	s6,0(sp)
}
    80000e4c:	70e2                	ld	ra,56(sp)
    80000e4e:	7442                	ld	s0,48(sp)
    80000e50:	69e2                	ld	s3,24(sp)
    80000e52:	6a42                	ld	s4,16(sp)
    80000e54:	6aa2                	ld	s5,8(sp)
    80000e56:	6121                	addi	sp,sp,64
    80000e58:	8082                	ret
      kfree(mem);
    80000e5a:	8526                	mv	a0,s1
    80000e5c:	b8aff0ef          	jal	800001e6 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000e60:	864e                	mv	a2,s3
    80000e62:	85ca                	mv	a1,s2
    80000e64:	8556                	mv	a0,s5
    80000e66:	f33ff0ef          	jal	80000d98 <uvmdealloc>
      return 0;
    80000e6a:	4501                	li	a0,0
    80000e6c:	74a2                	ld	s1,40(sp)
    80000e6e:	7902                	ld	s2,32(sp)
    80000e70:	6b02                	ld	s6,0(sp)
    80000e72:	bfe9                	j	80000e4c <uvmalloc+0x76>
  if(newsz < oldsz) return oldsz;
    80000e74:	852e                	mv	a0,a1
}
    80000e76:	8082                	ret
  return newsz;
    80000e78:	8532                	mv	a0,a2
    80000e7a:	bfc9                	j	80000e4c <uvmalloc+0x76>

0000000080000e7c <freewalk>:

// Recursively free page-table pages.
void
freewalk(pagetable_t pagetable)
{
    80000e7c:	7179                	addi	sp,sp,-48
    80000e7e:	f406                	sd	ra,40(sp)
    80000e80:	f022                	sd	s0,32(sp)
    80000e82:	ec26                	sd	s1,24(sp)
    80000e84:	e84a                	sd	s2,16(sp)
    80000e86:	e44e                	sd	s3,8(sp)
    80000e88:	e052                	sd	s4,0(sp)
    80000e8a:	1800                	addi	s0,sp,48
    80000e8c:	8a2a                	mv	s4,a0
  for(int i = 0; i < 512; i++){
    80000e8e:	84aa                	mv	s1,a0
    80000e90:	6905                	lui	s2,0x1
    80000e92:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000e94:	4985                	li	s3,1
    80000e96:	a819                	j	80000eac <freewalk+0x30>
      uint64 child = PTE2PA(pte);
    80000e98:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000e9a:	00c79513          	slli	a0,a5,0xc
    80000e9e:	fdfff0ef          	jal	80000e7c <freewalk>
      pagetable[i] = 0;
    80000ea2:	0004b023          	sd	zero,0(s1) # ffffffffffe00000 <end+0xffffffff7fdda108>
  for(int i = 0; i < 512; i++){
    80000ea6:	04a1                	addi	s1,s1,8
    80000ea8:	01248f63          	beq	s1,s2,80000ec6 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80000eac:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000eae:	00f7f713          	andi	a4,a5,15
    80000eb2:	ff3703e3          	beq	a4,s3,80000e98 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000eb6:	8b85                	andi	a5,a5,1
    80000eb8:	d7fd                	beqz	a5,80000ea6 <freewalk+0x2a>
      panic("freewalk: leaf found");
    80000eba:	00007517          	auipc	a0,0x7
    80000ebe:	56e50513          	addi	a0,a0,1390 # 80008428 <etext+0x428>
    80000ec2:	4e0050ef          	jal	800063a2 <panic>
    }
  }
  kfree((void*)pagetable);
    80000ec6:	8552                	mv	a0,s4
    80000ec8:	b1eff0ef          	jal	800001e6 <kfree>
}
    80000ecc:	70a2                	ld	ra,40(sp)
    80000ece:	7402                	ld	s0,32(sp)
    80000ed0:	64e2                	ld	s1,24(sp)
    80000ed2:	6942                	ld	s2,16(sp)
    80000ed4:	69a2                	ld	s3,8(sp)
    80000ed6:	6a02                	ld	s4,0(sp)
    80000ed8:	6145                	addi	sp,sp,48
    80000eda:	8082                	ret

0000000080000edc <uvmfree>:

// Free user memory pages, then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000edc:	7139                	addi	sp,sp,-64
    80000ede:	fc06                	sd	ra,56(sp)
    80000ee0:	f822                	sd	s0,48(sp)
    80000ee2:	f426                	sd	s1,40(sp)
    80000ee4:	f04a                	sd	s2,32(sp)
    80000ee6:	ec4e                	sd	s3,24(sp)
    80000ee8:	e852                	sd	s4,16(sp)
    80000eea:	e456                	sd	s5,8(sp)
    80000eec:	0080                	addi	s0,sp,64
    80000eee:	8aaa                	mv	s5,a0
  if(sz > 0)
    80000ef0:	e591                	bnez	a1,80000efc <uvmfree+0x20>
    uvmunmap(pagetable, 0, PGROUNDUP(sz), 1);
  
  for(int i=0; i<512; i++){
    80000ef2:	84d6                	mv	s1,s5
    80000ef4:	6985                	lui	s3,0x1
    80000ef6:	99d6                	add	s3,s3,s5
      pte_t pte = pagetable[i];
      if((pte & PTE_V) && !(pte & (PTE_R|PTE_W|PTE_X))){
    80000ef8:	4a05                	li	s4,1
    80000efa:	a025                	j	80000f22 <uvmfree+0x46>
    uvmunmap(pagetable, 0, PGROUNDUP(sz), 1);
    80000efc:	6785                	lui	a5,0x1
    80000efe:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000f00:	95be                	add	a1,a1,a5
    80000f02:	4685                	li	a3,1
    80000f04:	767d                	lui	a2,0xfffff
    80000f06:	8e6d                	and	a2,a2,a1
    80000f08:	4581                	li	a1,0
    80000f0a:	cb7ff0ef          	jal	80000bc0 <uvmunmap>
    80000f0e:	b7d5                	j	80000ef2 <uvmfree+0x16>
          freewalk((pagetable_t)PTE2PA(pte));
    80000f10:	8129                	srli	a0,a0,0xa
    80000f12:	0532                	slli	a0,a0,0xc
    80000f14:	f69ff0ef          	jal	80000e7c <freewalk>
      } else if (pte & PTE_V) {
          panic("uvmfree: L2 leaf found");
      }
      pagetable[i] = 0;
    80000f18:	00093023          	sd	zero,0(s2) # 1000 <_entry-0x7ffff000>
  for(int i=0; i<512; i++){
    80000f1c:	04a1                	addi	s1,s1,8
    80000f1e:	03348063          	beq	s1,s3,80000f3e <uvmfree+0x62>
      pte_t pte = pagetable[i];
    80000f22:	8926                	mv	s2,s1
    80000f24:	6088                	ld	a0,0(s1)
      if((pte & PTE_V) && !(pte & (PTE_R|PTE_W|PTE_X))){
    80000f26:	00f57793          	andi	a5,a0,15
    80000f2a:	ff4783e3          	beq	a5,s4,80000f10 <uvmfree+0x34>
      } else if (pte & PTE_V) {
    80000f2e:	8905                	andi	a0,a0,1
    80000f30:	d565                	beqz	a0,80000f18 <uvmfree+0x3c>
          panic("uvmfree: L2 leaf found");
    80000f32:	00007517          	auipc	a0,0x7
    80000f36:	50e50513          	addi	a0,a0,1294 # 80008440 <etext+0x440>
    80000f3a:	468050ef          	jal	800063a2 <panic>
  }
  kfree((void*)pagetable);
    80000f3e:	8556                	mv	a0,s5
    80000f40:	aa6ff0ef          	jal	800001e6 <kfree>
}
    80000f44:	70e2                	ld	ra,56(sp)
    80000f46:	7442                	ld	s0,48(sp)
    80000f48:	74a2                	ld	s1,40(sp)
    80000f4a:	7902                	ld	s2,32(sp)
    80000f4c:	69e2                	ld	s3,24(sp)
    80000f4e:	6a42                	ld	s4,16(sp)
    80000f50:	6aa2                	ld	s5,8(sp)
    80000f52:	6121                	addi	sp,sp,64
    80000f54:	8082                	ret

0000000080000f56 <uvmcopy>:
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; ){
    80000f56:	10060c63          	beqz	a2,8000106e <uvmcopy+0x118>
{
    80000f5a:	715d                	addi	sp,sp,-80
    80000f5c:	e486                	sd	ra,72(sp)
    80000f5e:	e0a2                	sd	s0,64(sp)
    80000f60:	fc26                	sd	s1,56(sp)
    80000f62:	f84a                	sd	s2,48(sp)
    80000f64:	f44e                	sd	s3,40(sp)
    80000f66:	f052                	sd	s4,32(sp)
    80000f68:	ec56                	sd	s5,24(sp)
    80000f6a:	e85a                	sd	s6,16(sp)
    80000f6c:	e45e                	sd	s7,8(sp)
    80000f6e:	0880                	addi	s0,sp,80
    80000f70:	8a2a                	mv	s4,a0
    80000f72:	8b2e                	mv	s6,a1
    80000f74:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; ){
    80000f76:	4481                	li	s1,0
    80000f78:	a899                	j	80000fce <uvmcopy+0x78>
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    80000f7a:	00007517          	auipc	a0,0x7
    80000f7e:	4de50513          	addi	a0,a0,1246 # 80008458 <etext+0x458>
    80000f82:	420050ef          	jal	800063a2 <panic>
    if((*pte & PTE_V) == 0)
      panic("uvmcopy: page not present");
    80000f86:	00007517          	auipc	a0,0x7
    80000f8a:	4f250513          	addi	a0,a0,1266 # 80008478 <etext+0x478>
    80000f8e:	414050ef          	jal	800063a2 <panic>
    flags = PTE_FLAGS(*pte);

    if(*pte & (PTE_R|PTE_W|PTE_X)) { // Leaf PTE
        // Check if it's a superpage by checking if the PTE is an L1 entry
        pte_t* l2_pte = &old[PX(2, i)];
        if(!(*l2_pte & PTE_V)) panic("uvmcopy: l2 pte invalid");
    80000f92:	00007517          	auipc	a0,0x7
    80000f96:	50650513          	addi	a0,a0,1286 # 80008498 <etext+0x498>
    80000f9a:	408050ef          	jal	800063a2 <panic>
        if(&l1_table[PX(1, i)] == pte) { // It's an L1 PTE (superpage)
            char* mem = superalloc();
            if(mem == 0) goto err;
            memmove(mem, (char*)pa, SUPERPGSIZE);
            if(uvmmap_super(new, i, (uint64)mem, flags) != 0){
                superfree(mem);
    80000f9e:	855e                	mv	a0,s7
    80000fa0:	c66ff0ef          	jal	80000406 <superfree>
                goto err;
    80000fa4:	a04d                	j	80001046 <uvmcopy+0xf0>
            continue;
        }
    }
    
    // It's a 4KB page
    char* mem = kalloc();
    80000fa6:	afaff0ef          	jal	800002a0 <kalloc>
    80000faa:	8baa                	mv	s7,a0
    if(mem == 0) goto err;
    80000fac:	cd49                	beqz	a0,80001046 <uvmcopy+0xf0>
    memmove(mem, (char*)pa, PGSIZE);
    80000fae:	6605                	lui	a2,0x1
    80000fb0:	85ca                	mv	a1,s2
    80000fb2:	d58ff0ef          	jal	8000050a <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000fb6:	874e                	mv	a4,s3
    80000fb8:	86de                	mv	a3,s7
    80000fba:	6605                	lui	a2,0x1
    80000fbc:	85a6                	mv	a1,s1
    80000fbe:	855a                	mv	a0,s6
    80000fc0:	97dff0ef          	jal	8000093c <mappages>
    80000fc4:	ed35                	bnez	a0,80001040 <uvmcopy+0xea>
      kfree(mem);
      goto err;
    }
    i += PGSIZE;
    80000fc6:	6785                	lui	a5,0x1
    80000fc8:	94be                	add	s1,s1,a5
  for(i = 0; i < sz; ){
    80000fca:	0b54f063          	bgeu	s1,s5,8000106a <uvmcopy+0x114>
    if((pte = walk(old, i, 0)) == 0)
    80000fce:	4601                	li	a2,0
    80000fd0:	85a6                	mv	a1,s1
    80000fd2:	8552                	mv	a0,s4
    80000fd4:	82bff0ef          	jal	800007fe <walk>
    80000fd8:	d14d                	beqz	a0,80000f7a <uvmcopy+0x24>
    if((*pte & PTE_V) == 0)
    80000fda:	611c                	ld	a5,0(a0)
    80000fdc:	0017f713          	andi	a4,a5,1
    80000fe0:	d35d                	beqz	a4,80000f86 <uvmcopy+0x30>
    pa = PTE2PA(*pte);
    80000fe2:	00a7d913          	srli	s2,a5,0xa
    80000fe6:	0932                	slli	s2,s2,0xc
    flags = PTE_FLAGS(*pte);
    80000fe8:	3ff7f993          	andi	s3,a5,1023
    if(*pte & (PTE_R|PTE_W|PTE_X)) { // Leaf PTE
    80000fec:	8bb9                	andi	a5,a5,14
    80000fee:	dfc5                	beqz	a5,80000fa6 <uvmcopy+0x50>
        pte_t* l2_pte = &old[PX(2, i)];
    80000ff0:	01e4d793          	srli	a5,s1,0x1e
    80000ff4:	1ff7f793          	andi	a5,a5,511
        if(!(*l2_pte & PTE_V)) panic("uvmcopy: l2 pte invalid");
    80000ff8:	078e                	slli	a5,a5,0x3
    80000ffa:	97d2                	add	a5,a5,s4
    80000ffc:	639c                	ld	a5,0(a5)
    80000ffe:	0017f713          	andi	a4,a5,1
    80001002:	db41                	beqz	a4,80000f92 <uvmcopy+0x3c>
        pagetable_t l1_table = (pagetable_t)PTE2PA(*l2_pte);
    80001004:	83a9                	srli	a5,a5,0xa
    80001006:	07b2                	slli	a5,a5,0xc
        if(&l1_table[PX(1, i)] == pte) { // It's an L1 PTE (superpage)
    80001008:	0154d713          	srli	a4,s1,0x15
    8000100c:	1ff77713          	andi	a4,a4,511
    80001010:	070e                	slli	a4,a4,0x3
    80001012:	97ba                	add	a5,a5,a4
    80001014:	f8f519e3          	bne	a0,a5,80000fa6 <uvmcopy+0x50>
            char* mem = superalloc();
    80001018:	b64ff0ef          	jal	8000037c <superalloc>
    8000101c:	8baa                	mv	s7,a0
            if(mem == 0) goto err;
    8000101e:	c505                	beqz	a0,80001046 <uvmcopy+0xf0>
            memmove(mem, (char*)pa, SUPERPGSIZE);
    80001020:	00200637          	lui	a2,0x200
    80001024:	85ca                	mv	a1,s2
    80001026:	ce4ff0ef          	jal	8000050a <memmove>
            if(uvmmap_super(new, i, (uint64)mem, flags) != 0){
    8000102a:	86ce                	mv	a3,s3
    8000102c:	865e                	mv	a2,s7
    8000102e:	85a6                	mv	a1,s1
    80001030:	855a                	mv	a0,s6
    80001032:	abbff0ef          	jal	80000aec <uvmmap_super>
    80001036:	f525                	bnez	a0,80000f9e <uvmcopy+0x48>
            i += SUPERPGSIZE;
    80001038:	002007b7          	lui	a5,0x200
    8000103c:	94be                	add	s1,s1,a5
            continue;
    8000103e:	b771                	j	80000fca <uvmcopy+0x74>
      kfree(mem);
    80001040:	855e                	mv	a0,s7
    80001042:	9a4ff0ef          	jal	800001e6 <kfree>
  }
  return 0;

 err:
  uvmunmap(new, 0, i, 1);
    80001046:	4685                	li	a3,1
    80001048:	8626                	mv	a2,s1
    8000104a:	4581                	li	a1,0
    8000104c:	855a                	mv	a0,s6
    8000104e:	b73ff0ef          	jal	80000bc0 <uvmunmap>
  return -1;
    80001052:	557d                	li	a0,-1
}
    80001054:	60a6                	ld	ra,72(sp)
    80001056:	6406                	ld	s0,64(sp)
    80001058:	74e2                	ld	s1,56(sp)
    8000105a:	7942                	ld	s2,48(sp)
    8000105c:	79a2                	ld	s3,40(sp)
    8000105e:	7a02                	ld	s4,32(sp)
    80001060:	6ae2                	ld	s5,24(sp)
    80001062:	6b42                	ld	s6,16(sp)
    80001064:	6ba2                	ld	s7,8(sp)
    80001066:	6161                	addi	sp,sp,80
    80001068:	8082                	ret
  return 0;
    8000106a:	4501                	li	a0,0
    8000106c:	b7e5                	j	80001054 <uvmcopy+0xfe>
    8000106e:	4501                	li	a0,0
}
    80001070:	8082                	ret

0000000080001072 <uvmclear>:

// mark a PTE invalid for user access.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001072:	1141                	addi	sp,sp,-16
    80001074:	e406                	sd	ra,8(sp)
    80001076:	e022                	sd	s0,0(sp)
    80001078:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    8000107a:	4601                	li	a2,0
    8000107c:	f82ff0ef          	jal	800007fe <walk>
  if(pte == 0) panic("uvmclear: walk failed");
    80001080:	c901                	beqz	a0,80001090 <uvmclear+0x1e>
  *pte &= ~PTE_U;
    80001082:	611c                	ld	a5,0(a0)
    80001084:	9bbd                	andi	a5,a5,-17
    80001086:	e11c                	sd	a5,0(a0)
}
    80001088:	60a2                	ld	ra,8(sp)
    8000108a:	6402                	ld	s0,0(sp)
    8000108c:	0141                	addi	sp,sp,16
    8000108e:	8082                	ret
  if(pte == 0) panic("uvmclear: walk failed");
    80001090:	00007517          	auipc	a0,0x7
    80001094:	42050513          	addi	a0,a0,1056 # 800084b0 <etext+0x4b0>
    80001098:	30a050ef          	jal	800063a2 <panic>

000000008000109c <copyout>:
{
  uint64 n_this_iter, va_current_page_base, phys_base_of_current_page;
  uint64 size_of_current_page;

  // Initial comprehensive check for dstva and len validity
  if (dstva >= MAXVA || dstva + len < dstva || dstva + len > MAXVA) {
    8000109c:	57fd                	li	a5,-1
    8000109e:	83e9                	srli	a5,a5,0x1a
    800010a0:	10b7e363          	bltu	a5,a1,800011a6 <copyout+0x10a>
{
    800010a4:	7159                	addi	sp,sp,-112
    800010a6:	f486                	sd	ra,104(sp)
    800010a8:	f0a2                	sd	s0,96(sp)
    800010aa:	e8ca                	sd	s2,80(sp)
    800010ac:	e4ce                	sd	s3,72(sp)
    800010ae:	e0d2                	sd	s4,64(sp)
    800010b0:	f85a                	sd	s6,48(sp)
    800010b2:	1880                	addi	s0,sp,112
    800010b4:	8b2a                	mv	s6,a0
    800010b6:	892e                	mv	s2,a1
    800010b8:	8a32                	mv	s4,a2
    800010ba:	89b6                	mv	s3,a3
  if (dstva >= MAXVA || dstva + len < dstva || dstva + len > MAXVA) {
    800010bc:	00d58733          	add	a4,a1,a3
    800010c0:	0eb76563          	bltu	a4,a1,800011aa <copyout+0x10e>
    800010c4:	4785                	li	a5,1
    800010c6:	179a                	slli	a5,a5,0x26
    800010c8:	0ee7e363          	bltu	a5,a4,800011ae <copyout+0x112>
      return -1;
  }

  while(len > 0){
    800010cc:	c285                	beqz	a3,800010ec <copyout+0x50>
    800010ce:	eca6                	sd	s1,88(sp)
    800010d0:	fc56                	sd	s5,56(sp)
    800010d2:	f45e                	sd	s7,40(sp)
    800010d4:	f062                	sd	s8,32(sp)
    800010d6:	ec66                	sd	s9,24(sp)
    800010d8:	e86a                	sd	s10,16(sp)
    800010da:	e46e                	sd	s11,8(sp)
    // If dstva hits MAXVA and len > 0, it's an error (should be caught by initial check mostly).
    if (dstva >= MAXVA) return -1; // Added safety check within loop for MAXVA boundary


    size_of_current_page = PGSIZE; // Default to 4KB
    va_current_page_base = PGROUNDDOWN(dstva);
    800010dc:	7cfd                	lui	s9,0xfffff

    pte_t *l2_pte = &pagetable[PX(2, dstva)];
    if(!(*l2_pte & PTE_V) || (*l2_pte & (PTE_R|PTE_W|PTE_X))) { // L2 not valid or is 1GB leaf (error for user)
    800010de:	4c05                	li	s8,1
        va_current_page_base = SUPERPGROUNDDOWN(dstva);
        phys_base_of_current_page = PTE2PA(*l1_pte);
    } else { // L1 PTE points to L0 table
    cout_try_4k_walk:; // Label for fallback to 4KB page walk
        pte_t* pte_l0 = walk(pagetable, dstva, 0); 
        if(pte_l0 == 0 || !(*pte_l0 & PTE_V) || !(*pte_l0 & PTE_U) || !(*pte_l0 & PTE_W)) return -1;
    800010e0:	4d55                	li	s10,21
        if(!(*l1_pte & PTE_U) || !(*l1_pte & PTE_W)) return -1; // Check user access AND writable
    800010e2:	4dd1                	li	s11,20
    if (dstva >= MAXVA) return -1; // Added safety check within loop for MAXVA boundary
    800010e4:	5bfd                	li	s7,-1
    800010e6:	01abdb93          	srli	s7,s7,0x1a
    800010ea:	a0b9                	j	80001138 <copyout+0x9c>

    len -= n_this_iter;
    src += n_this_iter;
    dstva += n_this_iter; // Correctly advance dstva by amount copied
  }
  return 0;
    800010ec:	4501                	li	a0,0
    800010ee:	a065                	j	80001196 <copyout+0xfa>
        pte_t* pte_l0 = walk(pagetable, dstva, 0); 
    800010f0:	4601                	li	a2,0
    800010f2:	85ca                	mv	a1,s2
    800010f4:	855a                	mv	a0,s6
    800010f6:	f08ff0ef          	jal	800007fe <walk>
        if(pte_l0 == 0 || !(*pte_l0 & PTE_V) || !(*pte_l0 & PTE_U) || !(*pte_l0 & PTE_W)) return -1;
    800010fa:	cd71                	beqz	a0,800011d6 <copyout+0x13a>
    800010fc:	6108                	ld	a0,0(a0)
    800010fe:	01557793          	andi	a5,a0,21
    80001102:	0fa79363          	bne	a5,s10,800011e8 <copyout+0x14c>
        phys_base_of_current_page = PTE2PA(*pte_l0);
    80001106:	8129                	srli	a0,a0,0xa
    80001108:	0532                	slli	a0,a0,0xc
    size_of_current_page = PGSIZE; // Default to 4KB
    8000110a:	6485                	lui	s1,0x1
    n_this_iter = size_of_current_page - (dstva - va_current_page_base); 
    8000110c:	94d6                	add	s1,s1,s5
    8000110e:	412484b3          	sub	s1,s1,s2
    if(n_this_iter > len)
    80001112:	0099f363          	bgeu	s3,s1,80001118 <copyout+0x7c>
    80001116:	84ce                	mv	s1,s3
    memmove((void *)(phys_base_of_current_page + (dstva - va_current_page_base)), src, n_this_iter);
    80001118:	954a                	add	a0,a0,s2
    8000111a:	0004861b          	sext.w	a2,s1
    8000111e:	85d2                	mv	a1,s4
    80001120:	41550533          	sub	a0,a0,s5
    80001124:	be6ff0ef          	jal	8000050a <memmove>
    len -= n_this_iter;
    80001128:	409989b3          	sub	s3,s3,s1
    src += n_this_iter;
    8000112c:	9a26                	add	s4,s4,s1
    dstva += n_this_iter; // Correctly advance dstva by amount copied
    8000112e:	9926                	add	s2,s2,s1
  while(len > 0){
    80001130:	04098b63          	beqz	s3,80001186 <copyout+0xea>
    if (dstva >= MAXVA) return -1; // Added safety check within loop for MAXVA boundary
    80001134:	072bef63          	bltu	s7,s2,800011b2 <copyout+0x116>
    va_current_page_base = PGROUNDDOWN(dstva);
    80001138:	01997ab3          	and	s5,s2,s9
    pte_t *l2_pte = &pagetable[PX(2, dstva)];
    8000113c:	01e95793          	srli	a5,s2,0x1e
    if(!(*l2_pte & PTE_V) || (*l2_pte & (PTE_R|PTE_W|PTE_X))) { // L2 not valid or is 1GB leaf (error for user)
    80001140:	078e                	slli	a5,a5,0x3
    80001142:	97da                	add	a5,a5,s6
    80001144:	639c                	ld	a5,0(a5)
    80001146:	00f7f713          	andi	a4,a5,15
    8000114a:	fb8713e3          	bne	a4,s8,800010f0 <copyout+0x54>
    pagetable_t l1_table = (pagetable_t)PTE2PA(*l2_pte);
    8000114e:	83a9                	srli	a5,a5,0xa
    80001150:	07b2                	slli	a5,a5,0xc
    pte_t *l1_pte = &l1_table[PX(1, dstva)];
    80001152:	01595713          	srli	a4,s2,0x15
    80001156:	1ff77713          	andi	a4,a4,511
    if(!(*l1_pte & PTE_V)) { // L1 entry not valid, try 4KB walk
    8000115a:	070e                	slli	a4,a4,0x3
    8000115c:	97ba                	add	a5,a5,a4
    8000115e:	6388                	ld	a0,0(a5)
    80001160:	00157793          	andi	a5,a0,1
    80001164:	d7d1                	beqz	a5,800010f0 <copyout+0x54>
    if(*l1_pte & (PTE_R|PTE_W|PTE_X)) { // L1 PTE is a Superpage leaf
    80001166:	00e57793          	andi	a5,a0,14
    8000116a:	d3d9                	beqz	a5,800010f0 <copyout+0x54>
        if(!(*l1_pte & PTE_U) || !(*l1_pte & PTE_W)) return -1; // Check user access AND writable
    8000116c:	01457793          	andi	a5,a0,20
    80001170:	05b79a63          	bne	a5,s11,800011c4 <copyout+0x128>
        va_current_page_base = SUPERPGROUNDDOWN(dstva);
    80001174:	ffe007b7          	lui	a5,0xffe00
    80001178:	00f97ab3          	and	s5,s2,a5
        phys_base_of_current_page = PTE2PA(*l1_pte);
    8000117c:	8129                	srli	a0,a0,0xa
    8000117e:	0532                	slli	a0,a0,0xc
        size_of_current_page = SUPERPGSIZE;
    80001180:	002004b7          	lui	s1,0x200
    80001184:	b761                	j	8000110c <copyout+0x70>
  return 0;
    80001186:	4501                	li	a0,0
    80001188:	64e6                	ld	s1,88(sp)
    8000118a:	7ae2                	ld	s5,56(sp)
    8000118c:	7ba2                	ld	s7,40(sp)
    8000118e:	7c02                	ld	s8,32(sp)
    80001190:	6ce2                	ld	s9,24(sp)
    80001192:	6d42                	ld	s10,16(sp)
    80001194:	6da2                	ld	s11,8(sp)
}
    80001196:	70a6                	ld	ra,104(sp)
    80001198:	7406                	ld	s0,96(sp)
    8000119a:	6946                	ld	s2,80(sp)
    8000119c:	69a6                	ld	s3,72(sp)
    8000119e:	6a06                	ld	s4,64(sp)
    800011a0:	7b42                	ld	s6,48(sp)
    800011a2:	6165                	addi	sp,sp,112
    800011a4:	8082                	ret
      return -1;
    800011a6:	557d                	li	a0,-1
}
    800011a8:	8082                	ret
      return -1;
    800011aa:	557d                	li	a0,-1
    800011ac:	b7ed                	j	80001196 <copyout+0xfa>
    800011ae:	557d                	li	a0,-1
    800011b0:	b7dd                	j	80001196 <copyout+0xfa>
    if (dstva >= MAXVA) return -1; // Added safety check within loop for MAXVA boundary
    800011b2:	557d                	li	a0,-1
    800011b4:	64e6                	ld	s1,88(sp)
    800011b6:	7ae2                	ld	s5,56(sp)
    800011b8:	7ba2                	ld	s7,40(sp)
    800011ba:	7c02                	ld	s8,32(sp)
    800011bc:	6ce2                	ld	s9,24(sp)
    800011be:	6d42                	ld	s10,16(sp)
    800011c0:	6da2                	ld	s11,8(sp)
    800011c2:	bfd1                	j	80001196 <copyout+0xfa>
        if(!(*l1_pte & PTE_U) || !(*l1_pte & PTE_W)) return -1; // Check user access AND writable
    800011c4:	557d                	li	a0,-1
    800011c6:	64e6                	ld	s1,88(sp)
    800011c8:	7ae2                	ld	s5,56(sp)
    800011ca:	7ba2                	ld	s7,40(sp)
    800011cc:	7c02                	ld	s8,32(sp)
    800011ce:	6ce2                	ld	s9,24(sp)
    800011d0:	6d42                	ld	s10,16(sp)
    800011d2:	6da2                	ld	s11,8(sp)
    800011d4:	b7c9                	j	80001196 <copyout+0xfa>
        if(pte_l0 == 0 || !(*pte_l0 & PTE_V) || !(*pte_l0 & PTE_U) || !(*pte_l0 & PTE_W)) return -1;
    800011d6:	557d                	li	a0,-1
    800011d8:	64e6                	ld	s1,88(sp)
    800011da:	7ae2                	ld	s5,56(sp)
    800011dc:	7ba2                	ld	s7,40(sp)
    800011de:	7c02                	ld	s8,32(sp)
    800011e0:	6ce2                	ld	s9,24(sp)
    800011e2:	6d42                	ld	s10,16(sp)
    800011e4:	6da2                	ld	s11,8(sp)
    800011e6:	bf45                	j	80001196 <copyout+0xfa>
    800011e8:	557d                	li	a0,-1
    800011ea:	64e6                	ld	s1,88(sp)
    800011ec:	7ae2                	ld	s5,56(sp)
    800011ee:	7ba2                	ld	s7,40(sp)
    800011f0:	7c02                	ld	s8,32(sp)
    800011f2:	6ce2                	ld	s9,24(sp)
    800011f4:	6d42                	ld	s10,16(sp)
    800011f6:	6da2                	ld	s11,8(sp)
    800011f8:	bf79                	j	80001196 <copyout+0xfa>

00000000800011fa <copyin>:
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n_this_iter, va_current_page_base, phys_base_of_current_page;
  uint64 size_of_current_page;

  if (srcva >= MAXVA || srcva + len < srcva || srcva + len > MAXVA) {
    800011fa:	57fd                	li	a5,-1
    800011fc:	83e9                	srli	a5,a5,0x1a
    800011fe:	10c7e163          	bltu	a5,a2,80001300 <copyin+0x106>
{
    80001202:	7159                	addi	sp,sp,-112
    80001204:	f486                	sd	ra,104(sp)
    80001206:	f0a2                	sd	s0,96(sp)
    80001208:	e8ca                	sd	s2,80(sp)
    8000120a:	e4ce                	sd	s3,72(sp)
    8000120c:	e0d2                	sd	s4,64(sp)
    8000120e:	f85a                	sd	s6,48(sp)
    80001210:	1880                	addi	s0,sp,112
    80001212:	8b2a                	mv	s6,a0
    80001214:	8a2e                	mv	s4,a1
    80001216:	8932                	mv	s2,a2
    80001218:	89b6                	mv	s3,a3
  if (srcva >= MAXVA || srcva + len < srcva || srcva + len > MAXVA) {
    8000121a:	00d60733          	add	a4,a2,a3
    8000121e:	0ec76363          	bltu	a4,a2,80001304 <copyin+0x10a>
    80001222:	4785                	li	a5,1
    80001224:	179a                	slli	a5,a5,0x26
    80001226:	0ee7e163          	bltu	a5,a4,80001308 <copyin+0x10e>
      return -1;
  }

  while(len > 0){
    8000122a:	c28d                	beqz	a3,8000124c <copyin+0x52>
    8000122c:	eca6                	sd	s1,88(sp)
    8000122e:	fc56                	sd	s5,56(sp)
    80001230:	f45e                	sd	s7,40(sp)
    80001232:	f062                	sd	s8,32(sp)
    80001234:	ec66                	sd	s9,24(sp)
    80001236:	e86a                	sd	s10,16(sp)
    80001238:	e46e                	sd	s11,8(sp)
    if (srcva >= MAXVA) return -1; // Added safety check within loop for MAXVA boundary

    size_of_current_page = PGSIZE; // Default to 4KB
    va_current_page_base = PGROUNDDOWN(srcva);
    8000123a:	7cfd                	lui	s9,0xfffff

    pte_t *l2_pte = &pagetable[PX(2, srcva)];
    if(!(*l2_pte & PTE_V) || (*l2_pte & (PTE_R|PTE_W|PTE_X))) { 
    8000123c:	4c05                	li	s8,1
        va_current_page_base = SUPERPGROUNDDOWN(srcva);
        phys_base_of_current_page = PTE2PA(*l1_pte);
    } else { // L1 PTE points to L0 table
    cin_try_4k_walk:;
        pte_t* pte_l0 = walk(pagetable, srcva, 0); 
        if(pte_l0 == 0 || !(*pte_l0 & PTE_V) || !(*pte_l0 & PTE_U)) return -1;
    8000123e:	4d45                	li	s10,17
        va_current_page_base = SUPERPGROUNDDOWN(srcva);
    80001240:	ffe00db7          	lui	s11,0xffe00
    if (srcva >= MAXVA) return -1; // Added safety check within loop for MAXVA boundary
    80001244:	5bfd                	li	s7,-1
    80001246:	01abdb93          	srli	s7,s7,0x1a
    8000124a:	a0b9                	j	80001298 <copyin+0x9e>

    len -= n_this_iter;
    dst += n_this_iter;
    srcva += n_this_iter; // Correctly advance srcva by amount copied
  }
  return 0;
    8000124c:	4501                	li	a0,0
    8000124e:	a04d                	j	800012f0 <copyin+0xf6>
        pte_t* pte_l0 = walk(pagetable, srcva, 0); 
    80001250:	4601                	li	a2,0
    80001252:	85ca                	mv	a1,s2
    80001254:	855a                	mv	a0,s6
    80001256:	da8ff0ef          	jal	800007fe <walk>
        if(pte_l0 == 0 || !(*pte_l0 & PTE_V) || !(*pte_l0 & PTE_U)) return -1;
    8000125a:	c979                	beqz	a0,80001330 <copyin+0x136>
    8000125c:	610c                	ld	a1,0(a0)
    8000125e:	0115f793          	andi	a5,a1,17
    80001262:	0fa79063          	bne	a5,s10,80001342 <copyin+0x148>
        phys_base_of_current_page = PTE2PA(*pte_l0);
    80001266:	81a9                	srli	a1,a1,0xa
    80001268:	05b2                	slli	a1,a1,0xc
    size_of_current_page = PGSIZE; // Default to 4KB
    8000126a:	6485                	lui	s1,0x1
    n_this_iter = size_of_current_page - (srcva - va_current_page_base); 
    8000126c:	94d6                	add	s1,s1,s5
    8000126e:	412484b3          	sub	s1,s1,s2
    if(n_this_iter > len)
    80001272:	0099f363          	bgeu	s3,s1,80001278 <copyin+0x7e>
    80001276:	84ce                	mv	s1,s3
    memmove(dst, (void *)(phys_base_of_current_page + (srcva - va_current_page_base)), n_this_iter);
    80001278:	95ca                	add	a1,a1,s2
    8000127a:	0004861b          	sext.w	a2,s1
    8000127e:	415585b3          	sub	a1,a1,s5
    80001282:	8552                	mv	a0,s4
    80001284:	a86ff0ef          	jal	8000050a <memmove>
    len -= n_this_iter;
    80001288:	409989b3          	sub	s3,s3,s1
    dst += n_this_iter;
    8000128c:	9a26                	add	s4,s4,s1
    srcva += n_this_iter; // Correctly advance srcva by amount copied
    8000128e:	9926                	add	s2,s2,s1
  while(len > 0){
    80001290:	04098863          	beqz	s3,800012e0 <copyin+0xe6>
    if (srcva >= MAXVA) return -1; // Added safety check within loop for MAXVA boundary
    80001294:	072bec63          	bltu	s7,s2,8000130c <copyin+0x112>
    va_current_page_base = PGROUNDDOWN(srcva);
    80001298:	01997ab3          	and	s5,s2,s9
    pte_t *l2_pte = &pagetable[PX(2, srcva)];
    8000129c:	01e95793          	srli	a5,s2,0x1e
    if(!(*l2_pte & PTE_V) || (*l2_pte & (PTE_R|PTE_W|PTE_X))) { 
    800012a0:	078e                	slli	a5,a5,0x3
    800012a2:	97da                	add	a5,a5,s6
    800012a4:	639c                	ld	a5,0(a5)
    800012a6:	00f7f713          	andi	a4,a5,15
    800012aa:	fb8713e3          	bne	a4,s8,80001250 <copyin+0x56>
    pagetable_t l1_table = (pagetable_t)PTE2PA(*l2_pte);
    800012ae:	83a9                	srli	a5,a5,0xa
    800012b0:	07b2                	slli	a5,a5,0xc
    pte_t *l1_pte = &l1_table[PX(1, srcva)];
    800012b2:	01595713          	srli	a4,s2,0x15
    800012b6:	1ff77713          	andi	a4,a4,511
    if(!(*l1_pte & PTE_V)) { 
    800012ba:	070e                	slli	a4,a4,0x3
    800012bc:	97ba                	add	a5,a5,a4
    800012be:	638c                	ld	a1,0(a5)
    800012c0:	0015f793          	andi	a5,a1,1
    800012c4:	d7d1                	beqz	a5,80001250 <copyin+0x56>
    if(*l1_pte & (PTE_R|PTE_W|PTE_X)) { // L1 PTE is a Superpage leaf
    800012c6:	00e5f793          	andi	a5,a1,14
    800012ca:	d3d9                	beqz	a5,80001250 <copyin+0x56>
        if(!(*l1_pte & PTE_U)) return -1; // Check user access
    800012cc:	0105f793          	andi	a5,a1,16
    800012d0:	c7b9                	beqz	a5,8000131e <copyin+0x124>
        va_current_page_base = SUPERPGROUNDDOWN(srcva);
    800012d2:	01b97ab3          	and	s5,s2,s11
        phys_base_of_current_page = PTE2PA(*l1_pte);
    800012d6:	81a9                	srli	a1,a1,0xa
    800012d8:	05b2                	slli	a1,a1,0xc
        size_of_current_page = SUPERPGSIZE;
    800012da:	002004b7          	lui	s1,0x200
    800012de:	b779                	j	8000126c <copyin+0x72>
  return 0;
    800012e0:	4501                	li	a0,0
    800012e2:	64e6                	ld	s1,88(sp)
    800012e4:	7ae2                	ld	s5,56(sp)
    800012e6:	7ba2                	ld	s7,40(sp)
    800012e8:	7c02                	ld	s8,32(sp)
    800012ea:	6ce2                	ld	s9,24(sp)
    800012ec:	6d42                	ld	s10,16(sp)
    800012ee:	6da2                	ld	s11,8(sp)
}
    800012f0:	70a6                	ld	ra,104(sp)
    800012f2:	7406                	ld	s0,96(sp)
    800012f4:	6946                	ld	s2,80(sp)
    800012f6:	69a6                	ld	s3,72(sp)
    800012f8:	6a06                	ld	s4,64(sp)
    800012fa:	7b42                	ld	s6,48(sp)
    800012fc:	6165                	addi	sp,sp,112
    800012fe:	8082                	ret
      return -1;
    80001300:	557d                	li	a0,-1
}
    80001302:	8082                	ret
      return -1;
    80001304:	557d                	li	a0,-1
    80001306:	b7ed                	j	800012f0 <copyin+0xf6>
    80001308:	557d                	li	a0,-1
    8000130a:	b7dd                	j	800012f0 <copyin+0xf6>
    if (srcva >= MAXVA) return -1; // Added safety check within loop for MAXVA boundary
    8000130c:	557d                	li	a0,-1
    8000130e:	64e6                	ld	s1,88(sp)
    80001310:	7ae2                	ld	s5,56(sp)
    80001312:	7ba2                	ld	s7,40(sp)
    80001314:	7c02                	ld	s8,32(sp)
    80001316:	6ce2                	ld	s9,24(sp)
    80001318:	6d42                	ld	s10,16(sp)
    8000131a:	6da2                	ld	s11,8(sp)
    8000131c:	bfd1                	j	800012f0 <copyin+0xf6>
        if(!(*l1_pte & PTE_U)) return -1; // Check user access
    8000131e:	557d                	li	a0,-1
    80001320:	64e6                	ld	s1,88(sp)
    80001322:	7ae2                	ld	s5,56(sp)
    80001324:	7ba2                	ld	s7,40(sp)
    80001326:	7c02                	ld	s8,32(sp)
    80001328:	6ce2                	ld	s9,24(sp)
    8000132a:	6d42                	ld	s10,16(sp)
    8000132c:	6da2                	ld	s11,8(sp)
    8000132e:	b7c9                	j	800012f0 <copyin+0xf6>
        if(pte_l0 == 0 || !(*pte_l0 & PTE_V) || !(*pte_l0 & PTE_U)) return -1;
    80001330:	557d                	li	a0,-1
    80001332:	64e6                	ld	s1,88(sp)
    80001334:	7ae2                	ld	s5,56(sp)
    80001336:	7ba2                	ld	s7,40(sp)
    80001338:	7c02                	ld	s8,32(sp)
    8000133a:	6ce2                	ld	s9,24(sp)
    8000133c:	6d42                	ld	s10,16(sp)
    8000133e:	6da2                	ld	s11,8(sp)
    80001340:	bf45                	j	800012f0 <copyin+0xf6>
    80001342:	557d                	li	a0,-1
    80001344:	64e6                	ld	s1,88(sp)
    80001346:	7ae2                	ld	s5,56(sp)
    80001348:	7ba2                	ld	s7,40(sp)
    8000134a:	7c02                	ld	s8,32(sp)
    8000134c:	6ce2                	ld	s9,24(sp)
    8000134e:	6d42                	ld	s10,16(sp)
    80001350:	6da2                	ld	s11,8(sp)
    80001352:	bf79                	j	800012f0 <copyin+0xf6>

0000000080001354 <copyinstr>:
  uint64 size_of_current_page;
  int got_null = 0;
  char current_char_val; // To store the character value
  
  // Initial comprehensive check for srcva and max_len_arg validity
  if (srcva >= MAXVA) {
    80001354:	57fd                	li	a5,-1
    80001356:	83e9                	srli	a5,a5,0x1a
    80001358:	10c7ec63          	bltu	a5,a2,80001470 <copyinstr+0x11c>
{
    8000135c:	7159                	addi	sp,sp,-112
    8000135e:	f486                	sd	ra,104(sp)
    80001360:	f0a2                	sd	s0,96(sp)
    80001362:	eca6                	sd	s1,88(sp)
    80001364:	e8ca                	sd	s2,80(sp)
    80001366:	e4ce                	sd	s3,72(sp)
    80001368:	fc56                	sd	s5,56(sp)
    8000136a:	1880                	addi	s0,sp,112
    8000136c:	8aaa                	mv	s5,a0
    8000136e:	84ae                	mv	s1,a1
    80001370:	8932                	mv	s2,a2
    80001372:	89b6                	mv	s3,a3
      return -1;
  }
  if (max_len_arg > 0) {
    80001374:	10068063          	beqz	a3,80001474 <copyinstr+0x120>
      if ((srcva + max_len_arg < srcva) || // Overflow
    80001378:	00d60733          	add	a4,a2,a3
    8000137c:	0ec76e63          	bltu	a4,a2,80001478 <copyinstr+0x124>
    80001380:	4785                	li	a5,1
    80001382:	179a                	slli	a5,a5,0x26
    80001384:	0ee7ec63          	bltu	a5,a4,8000147c <copyinstr+0x128>
    80001388:	e0d2                	sd	s4,64(sp)
    8000138a:	f85a                	sd	s6,48(sp)
    8000138c:	f45e                	sd	s7,40(sp)
    8000138e:	f062                	sd	s8,32(sp)
    80001390:	ec66                	sd	s9,24(sp)
    80001392:	e86a                	sd	s10,16(sp)
    80001394:	e46e                	sd	s11,8(sp)
    if (srcva >= MAXVA ) { // Added safety check within loop for MAXVA boundary
        return -1; 
    }

    size_of_current_page = PGSIZE; 
    va_current_page_base = PGROUNDDOWN(srcva);
    80001396:	7c7d                	lui	s8,0xfffff

    // --- Logic to determine phys_base_of_current_page and size_of_current_page ---
    pte_t *l2_pte = &pagetable[PX(2, srcva)];
    if(!(*l2_pte & PTE_V) || (*l2_pte & (PTE_R|PTE_W|PTE_X))) {
    80001398:	4b85                	li	s7,1
        va_current_page_base = SUPERPGROUNDDOWN(srcva);
        phys_base_of_current_page = PTE2PA(*l1_pte);
    } else { // 4KB page path
    cinstr_fallback_4k:;
        pte_t* pte_l0 = walk(pagetable, srcva, 0); 
        if(pte_l0 == 0 || !(*pte_l0 & PTE_V) || !(*pte_l0 & PTE_U)) return -1;
    8000139a:	4cc5                	li	s9,17
    size_of_current_page = PGSIZE; 
    8000139c:	6d05                	lui	s10,0x1
        va_current_page_base = SUPERPGROUNDDOWN(srcva);
    8000139e:	ffe00db7          	lui	s11,0xffe00
    if (srcva >= MAXVA ) { // Added safety check within loop for MAXVA boundary
    800013a2:	5b7d                	li	s6,-1
    800013a4:	01ab5b13          	srli	s6,s6,0x1a
    800013a8:	a8a9                	j	80001402 <copyinstr+0xae>
        pte_t* pte_l0 = walk(pagetable, srcva, 0); 
    800013aa:	4601                	li	a2,0
    800013ac:	85ca                	mv	a1,s2
    800013ae:	8556                	mv	a0,s5
    800013b0:	c4eff0ef          	jal	800007fe <walk>
        if(pte_l0 == 0 || !(*pte_l0 & PTE_V) || !(*pte_l0 & PTE_U)) return -1;
    800013b4:	c965                	beqz	a0,800014a4 <copyinstr+0x150>
    800013b6:	611c                	ld	a5,0(a0)
    800013b8:	0117f713          	andi	a4,a5,17
    800013bc:	0f971d63          	bne	a4,s9,800014b6 <copyinstr+0x162>
        phys_base_of_current_page = PTE2PA(*pte_l0);
    800013c0:	00a7d693          	srli	a3,a5,0xa
    800013c4:	06b2                	slli	a3,a3,0xc
    size_of_current_page = PGSIZE; 
    800013c6:	866a                	mv	a2,s10
        // size_of_current_page remains PGSIZE
        // va_current_page_base is PGROUNDDOWN(srcva)
    }
    // --- End of placeholder ---
    
    n_this_segment = size_of_current_page - (srcva - va_current_page_base);
    800013c8:	9652                	add	a2,a2,s4
    800013ca:	41260633          	sub	a2,a2,s2
    if(n_this_segment > max_len_arg) // Cap segment scan by remaining max_len_arg
    800013ce:	00c9f363          	bgeu	s3,a2,800013d4 <copyinstr+0x80>
    800013d2:	864e                	mv	a2,s3
      n_this_segment = max_len_arg;

    char *pa_char_ptr = (char *)(phys_base_of_current_page + (srcva - va_current_page_base));
    800013d4:	96ca                	add	a3,a3,s2
    800013d6:	414686b3          	sub	a3,a3,s4
    uint64 i; // Bytes to copy from this segment in this inner loop
    for(i = 0; i < n_this_segment; i++){
    800013da:	c605                	beqz	a2,80001402 <copyinstr+0xae>
    800013dc:	4781                	li	a5,0
      current_char_val = pa_char_ptr[i];
    800013de:	00f68733          	add	a4,a3,a5
    800013e2:	00074703          	lbu	a4,0(a4)
      *dst = current_char_val;
    800013e6:	00e48023          	sb	a4,0(s1) # 200000 <_entry-0x7fe00000>
      
      dst++; // Advance kernel destination buffer
    800013ea:	0485                	addi	s1,s1,1

      if(current_char_val == '\0'){
    800013ec:	cf39                	beqz	a4,8000144a <copyinstr+0xf6>
    for(i = 0; i < n_this_segment; i++){
    800013ee:	0785                	addi	a5,a5,1 # ffffffffffe00001 <end+0xffffffff7fdda109>
    800013f0:	fec797e3          	bne	a5,a2,800013de <copyinstr+0x8a>
        bytes_read_in_iter = i + 1; // Read 'i' chars + 1 null.
    } else {
        bytes_read_in_iter = i;     // Read 'i' (which is n_this_segment) non-null chars.
    }

    srcva += bytes_read_in_iter;
    800013f4:	9932                	add	s2,s2,a2
    max_len_arg -= bytes_read_in_iter;
    800013f6:	40c989b3          	sub	s3,s3,a2
  while(got_null == 0 && max_len_arg > 0){
    800013fa:	0c098763          	beqz	s3,800014c8 <copyinstr+0x174>
    if (srcva >= MAXVA ) { // Added safety check within loop for MAXVA boundary
    800013fe:	092b6163          	bltu	s6,s2,80001480 <copyinstr+0x12c>
    va_current_page_base = PGROUNDDOWN(srcva);
    80001402:	01897a33          	and	s4,s2,s8
    pte_t *l2_pte = &pagetable[PX(2, srcva)];
    80001406:	01e95793          	srli	a5,s2,0x1e
    if(!(*l2_pte & PTE_V) || (*l2_pte & (PTE_R|PTE_W|PTE_X))) {
    8000140a:	078e                	slli	a5,a5,0x3
    8000140c:	97d6                	add	a5,a5,s5
    8000140e:	639c                	ld	a5,0(a5)
    80001410:	00f7f713          	andi	a4,a5,15
    80001414:	f9771be3          	bne	a4,s7,800013aa <copyinstr+0x56>
    pagetable_t l1_table = (pagetable_t)PTE2PA(*l2_pte);
    80001418:	83a9                	srli	a5,a5,0xa
    8000141a:	07b2                	slli	a5,a5,0xc
    pte_t *l1_pte = &l1_table[PX(1, srcva)];
    8000141c:	01595713          	srli	a4,s2,0x15
    80001420:	1ff77713          	andi	a4,a4,511
    if(!(*l1_pte & PTE_V)) {
    80001424:	070e                	slli	a4,a4,0x3
    80001426:	97ba                	add	a5,a5,a4
    80001428:	6394                	ld	a3,0(a5)
    8000142a:	0016f793          	andi	a5,a3,1
    8000142e:	dfb5                	beqz	a5,800013aa <copyinstr+0x56>
    if(*l1_pte & (PTE_R|PTE_W|PTE_X)) { // Superpage
    80001430:	00e6f793          	andi	a5,a3,14
    80001434:	dbbd                	beqz	a5,800013aa <copyinstr+0x56>
        if(!(*l1_pte & PTE_U)) return -1;
    80001436:	0106f793          	andi	a5,a3,16
    8000143a:	cfa1                	beqz	a5,80001492 <copyinstr+0x13e>
        va_current_page_base = SUPERPGROUNDDOWN(srcva);
    8000143c:	01b97a33          	and	s4,s2,s11
        phys_base_of_current_page = PTE2PA(*l1_pte);
    80001440:	82a9                	srli	a3,a3,0xa
    80001442:	06b2                	slli	a3,a3,0xc
        size_of_current_page = SUPERPGSIZE;
    80001444:	00200637          	lui	a2,0x200
    80001448:	b741                	j	800013c8 <copyinstr+0x74>
    8000144a:	4785                	li	a5,1

  } // end while

  if(got_null){
    8000144c:	37fd                	addiw	a5,a5,-1
    8000144e:	0007851b          	sext.w	a0,a5
    80001452:	6a06                	ld	s4,64(sp)
    80001454:	7b42                	ld	s6,48(sp)
    80001456:	7ba2                	ld	s7,40(sp)
    80001458:	7c02                	ld	s8,32(sp)
    8000145a:	6ce2                	ld	s9,24(sp)
    8000145c:	6d42                	ld	s10,16(sp)
    8000145e:	6da2                	ld	s11,8(sp)
    return 0; // Success: null terminator found and copied within max_len_arg
  } else {
    // Failure: Either max_len_arg exhausted before null, or an invalid access occurred.
    return -1;
  }
}
    80001460:	70a6                	ld	ra,104(sp)
    80001462:	7406                	ld	s0,96(sp)
    80001464:	64e6                	ld	s1,88(sp)
    80001466:	6946                	ld	s2,80(sp)
    80001468:	69a6                	ld	s3,72(sp)
    8000146a:	7ae2                	ld	s5,56(sp)
    8000146c:	6165                	addi	sp,sp,112
    8000146e:	8082                	ret
      return -1;
    80001470:	557d                	li	a0,-1
}
    80001472:	8082                	ret
      return -1; 
    80001474:	557d                	li	a0,-1
    80001476:	b7ed                	j	80001460 <copyinstr+0x10c>
          return -1;
    80001478:	557d                	li	a0,-1
    8000147a:	b7dd                	j	80001460 <copyinstr+0x10c>
    8000147c:	557d                	li	a0,-1
    8000147e:	b7cd                	j	80001460 <copyinstr+0x10c>
        return -1; 
    80001480:	557d                	li	a0,-1
    80001482:	6a06                	ld	s4,64(sp)
    80001484:	7b42                	ld	s6,48(sp)
    80001486:	7ba2                	ld	s7,40(sp)
    80001488:	7c02                	ld	s8,32(sp)
    8000148a:	6ce2                	ld	s9,24(sp)
    8000148c:	6d42                	ld	s10,16(sp)
    8000148e:	6da2                	ld	s11,8(sp)
    80001490:	bfc1                	j	80001460 <copyinstr+0x10c>
        if(!(*l1_pte & PTE_U)) return -1;
    80001492:	557d                	li	a0,-1
    80001494:	6a06                	ld	s4,64(sp)
    80001496:	7b42                	ld	s6,48(sp)
    80001498:	7ba2                	ld	s7,40(sp)
    8000149a:	7c02                	ld	s8,32(sp)
    8000149c:	6ce2                	ld	s9,24(sp)
    8000149e:	6d42                	ld	s10,16(sp)
    800014a0:	6da2                	ld	s11,8(sp)
    800014a2:	bf7d                	j	80001460 <copyinstr+0x10c>
        if(pte_l0 == 0 || !(*pte_l0 & PTE_V) || !(*pte_l0 & PTE_U)) return -1;
    800014a4:	557d                	li	a0,-1
    800014a6:	6a06                	ld	s4,64(sp)
    800014a8:	7b42                	ld	s6,48(sp)
    800014aa:	7ba2                	ld	s7,40(sp)
    800014ac:	7c02                	ld	s8,32(sp)
    800014ae:	6ce2                	ld	s9,24(sp)
    800014b0:	6d42                	ld	s10,16(sp)
    800014b2:	6da2                	ld	s11,8(sp)
    800014b4:	b775                	j	80001460 <copyinstr+0x10c>
    800014b6:	557d                	li	a0,-1
    800014b8:	6a06                	ld	s4,64(sp)
    800014ba:	7b42                	ld	s6,48(sp)
    800014bc:	7ba2                	ld	s7,40(sp)
    800014be:	7c02                	ld	s8,32(sp)
    800014c0:	6ce2                	ld	s9,24(sp)
    800014c2:	6d42                	ld	s10,16(sp)
    800014c4:	6da2                	ld	s11,8(sp)
    800014c6:	bf69                	j	80001460 <copyinstr+0x10c>
    800014c8:	4781                	li	a5,0
    800014ca:	b749                	j	8000144c <copyinstr+0xf8>

00000000800014cc <vmprint_level>:

void
vmprint_level(pagetable_t pagetable, int level)
{
  // Sv39页表有三级，我们用level 0, 1, 2来代表L2, L1, L0。
  if (level > 2)
    800014cc:	4789                	li	a5,2
    800014ce:	12b7cb63          	blt	a5,a1,80001604 <vmprint_level+0x138>
{
    800014d2:	7119                	addi	sp,sp,-128
    800014d4:	fc86                	sd	ra,120(sp)
    800014d6:	f8a2                	sd	s0,112(sp)
    800014d8:	f4a6                	sd	s1,104(sp)
    800014da:	f0ca                	sd	s2,96(sp)
    800014dc:	ecce                	sd	s3,88(sp)
    800014de:	e8d2                	sd	s4,80(sp)
    800014e0:	e4d6                	sd	s5,72(sp)
    800014e2:	e0da                	sd	s6,64(sp)
    800014e4:	fc5e                	sd	s7,56(sp)
    800014e6:	f862                	sd	s8,48(sp)
    800014e8:	f466                	sd	s9,40(sp)
    800014ea:	f06a                	sd	s10,32(sp)
    800014ec:	ec6e                	sd	s11,24(sp)
    800014ee:	0100                	addi	s0,sp,128
    800014f0:	8aae                	mv	s5,a1
    800014f2:	89aa                	mv	s3,a0
    return;

  // 遍历当前页表中的512个PTE。
  for(int i = 0; i < 512; i++){
    800014f4:	4901                	li	s2,0
        printf(".. "); 
      }
      
      // 打印PTE的索引、PTE本身的值、以及它指向的物理地址。
      uint64 pa = PTE2PA(pte);
      printf("pte %d: pte %ld, pa %ld", i, pte, pa);
    800014f6:	00007b17          	auipc	s6,0x7
    800014fa:	fdab0b13          	addi	s6,s6,-38 # 800084d0 <etext+0x4d0>
        // 是中间PTE，换行并递归到下一级。
        printf("\n");
        vmprint_level((pagetable_t)pa, level + 1);
      } else {
        // 是叶子PTE，它映射一个物理页面。打印它的权限标志。
        printf(" -> flags:");
    800014fe:	00007c97          	auipc	s9,0x7
    80001502:	feac8c93          	addi	s9,s9,-22 # 800084e8 <etext+0x4e8>
        if(pte & PTE_V) printf(" V");
    80001506:	00007c17          	auipc	s8,0x7
    8000150a:	ff2c0c13          	addi	s8,s8,-14 # 800084f8 <etext+0x4f8>
        if(pte & PTE_R) printf(" R");
        if(pte & PTE_W) printf(" W");
        if(pte & PTE_X) printf(" X");
        if(pte & PTE_U) printf(" U");
        printf("\n");
    8000150e:	00007b97          	auipc	s7,0x7
    80001512:	d4ab8b93          	addi	s7,s7,-694 # 80008258 <etext+0x258>
        if(pte & PTE_U) printf(" U");
    80001516:	00007d97          	auipc	s11,0x7
    8000151a:	002d8d93          	addi	s11,s11,2 # 80008518 <etext+0x518>
        if(pte & PTE_X) printf(" X");
    8000151e:	00007d17          	auipc	s10,0x7
    80001522:	ff2d0d13          	addi	s10,s10,-14 # 80008510 <etext+0x510>
        vmprint_level((pagetable_t)pa, level + 1);
    80001526:	0015879b          	addiw	a5,a1,1
    8000152a:	f8f43423          	sd	a5,-120(s0)
    8000152e:	a81d                	j	80001564 <vmprint_level+0x98>
        printf(" -> flags:");
    80001530:	8566                	mv	a0,s9
    80001532:	39f040ef          	jal	800060d0 <printf>
        if(pte & PTE_V) printf(" V");
    80001536:	8562                	mv	a0,s8
    80001538:	399040ef          	jal	800060d0 <printf>
        if(pte & PTE_R) printf(" R");
    8000153c:	0024f793          	andi	a5,s1,2
    80001540:	efad                	bnez	a5,800015ba <vmprint_level+0xee>
        if(pte & PTE_W) printf(" W");
    80001542:	0044f793          	andi	a5,s1,4
    80001546:	e3c9                	bnez	a5,800015c8 <vmprint_level+0xfc>
        if(pte & PTE_X) printf(" X");
    80001548:	0084f793          	andi	a5,s1,8
    8000154c:	e7c9                	bnez	a5,800015d6 <vmprint_level+0x10a>
        if(pte & PTE_U) printf(" U");
    8000154e:	88c1                	andi	s1,s1,16
    80001550:	e4d9                	bnez	s1,800015de <vmprint_level+0x112>
        printf("\n");
    80001552:	855e                	mv	a0,s7
    80001554:	37d040ef          	jal	800060d0 <printf>
  for(int i = 0; i < 512; i++){
    80001558:	2905                	addiw	s2,s2,1
    8000155a:	09a1                	addi	s3,s3,8 # 1008 <_entry-0x7fffeff8>
    8000155c:	20000793          	li	a5,512
    80001560:	08f90363          	beq	s2,a5,800015e6 <vmprint_level+0x11a>
    pte_t pte = pagetable[i];
    80001564:	0009b483          	ld	s1,0(s3)
    if(pte & PTE_V){
    80001568:	0014f793          	andi	a5,s1,1
    8000156c:	d7f5                	beqz	a5,80001558 <vmprint_level+0x8c>
      for (int j = 0; j < level; j++) {
    8000156e:	03505163          	blez	s5,80001590 <vmprint_level+0xc4>
        printf(".. "); 
    80001572:	00007517          	auipc	a0,0x7
    80001576:	f5650513          	addi	a0,a0,-170 # 800084c8 <etext+0x4c8>
    8000157a:	357040ef          	jal	800060d0 <printf>
      for (int j = 0; j < level; j++) {
    8000157e:	4789                	li	a5,2
    80001580:	00fa9863          	bne	s5,a5,80001590 <vmprint_level+0xc4>
        printf(".. "); 
    80001584:	00007517          	auipc	a0,0x7
    80001588:	f4450513          	addi	a0,a0,-188 # 800084c8 <etext+0x4c8>
    8000158c:	345040ef          	jal	800060d0 <printf>
      uint64 pa = PTE2PA(pte);
    80001590:	00a4da13          	srli	s4,s1,0xa
    80001594:	0a32                	slli	s4,s4,0xc
      printf("pte %d: pte %ld, pa %ld", i, pte, pa);
    80001596:	86d2                	mv	a3,s4
    80001598:	8626                	mv	a2,s1
    8000159a:	85ca                	mv	a1,s2
    8000159c:	855a                	mv	a0,s6
    8000159e:	333040ef          	jal	800060d0 <printf>
      if((pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800015a2:	00e4f793          	andi	a5,s1,14
    800015a6:	f7c9                	bnez	a5,80001530 <vmprint_level+0x64>
        printf("\n");
    800015a8:	855e                	mv	a0,s7
    800015aa:	327040ef          	jal	800060d0 <printf>
        vmprint_level((pagetable_t)pa, level + 1);
    800015ae:	f8843583          	ld	a1,-120(s0)
    800015b2:	8552                	mv	a0,s4
    800015b4:	f19ff0ef          	jal	800014cc <vmprint_level>
    800015b8:	b745                	j	80001558 <vmprint_level+0x8c>
        if(pte & PTE_R) printf(" R");
    800015ba:	00007517          	auipc	a0,0x7
    800015be:	f4650513          	addi	a0,a0,-186 # 80008500 <etext+0x500>
    800015c2:	30f040ef          	jal	800060d0 <printf>
    800015c6:	bfb5                	j	80001542 <vmprint_level+0x76>
        if(pte & PTE_W) printf(" W");
    800015c8:	00007517          	auipc	a0,0x7
    800015cc:	f4050513          	addi	a0,a0,-192 # 80008508 <etext+0x508>
    800015d0:	301040ef          	jal	800060d0 <printf>
    800015d4:	bf95                	j	80001548 <vmprint_level+0x7c>
        if(pte & PTE_X) printf(" X");
    800015d6:	856a                	mv	a0,s10
    800015d8:	2f9040ef          	jal	800060d0 <printf>
    800015dc:	bf8d                	j	8000154e <vmprint_level+0x82>
        if(pte & PTE_U) printf(" U");
    800015de:	856e                	mv	a0,s11
    800015e0:	2f1040ef          	jal	800060d0 <printf>
    800015e4:	b7bd                	j	80001552 <vmprint_level+0x86>
      }
    }
  }
}
    800015e6:	70e6                	ld	ra,120(sp)
    800015e8:	7446                	ld	s0,112(sp)
    800015ea:	74a6                	ld	s1,104(sp)
    800015ec:	7906                	ld	s2,96(sp)
    800015ee:	69e6                	ld	s3,88(sp)
    800015f0:	6a46                	ld	s4,80(sp)
    800015f2:	6aa6                	ld	s5,72(sp)
    800015f4:	6b06                	ld	s6,64(sp)
    800015f6:	7be2                	ld	s7,56(sp)
    800015f8:	7c42                	ld	s8,48(sp)
    800015fa:	7ca2                	ld	s9,40(sp)
    800015fc:	7d02                	ld	s10,32(sp)
    800015fe:	6de2                	ld	s11,24(sp)
    80001600:	6109                	addi	sp,sp,128
    80001602:	8082                	ret
    80001604:	8082                	ret

0000000080001606 <vmprint>:

// 打印页表的主函数。
void
vmprint(pagetable_t pagetable)
{
    80001606:	1101                	addi	sp,sp,-32
    80001608:	ec06                	sd	ra,24(sp)
    8000160a:	e822                	sd	s0,16(sp)
    8000160c:	e426                	sd	s1,8(sp)
    8000160e:	1000                	addi	s0,sp,32
    80001610:	84aa                	mv	s1,a0
  printf("page table -------------------- 0x%p\n", pagetable);
    80001612:	85aa                	mv	a1,a0
    80001614:	00007517          	auipc	a0,0x7
    80001618:	f0c50513          	addi	a0,a0,-244 # 80008520 <etext+0x520>
    8000161c:	2b5040ef          	jal	800060d0 <printf>
  // 从level 0 (即L2根页表) 开始递归打印。
  vmprint_level(pagetable, 0);
    80001620:	4581                	li	a1,0
    80001622:	8526                	mv	a0,s1
    80001624:	ea9ff0ef          	jal	800014cc <vmprint_level>
  printf("--------------------------------\n");
    80001628:	00007517          	auipc	a0,0x7
    8000162c:	f2050513          	addi	a0,a0,-224 # 80008548 <etext+0x548>
    80001630:	2a1040ef          	jal	800060d0 <printf>
}
    80001634:	60e2                	ld	ra,24(sp)
    80001636:	6442                	ld	s0,16(sp)
    80001638:	64a2                	ld	s1,8(sp)
    8000163a:	6105                	addi	sp,sp,32
    8000163c:	8082                	ret

000000008000163e <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    8000163e:	7139                	addi	sp,sp,-64
    80001640:	fc06                	sd	ra,56(sp)
    80001642:	f822                	sd	s0,48(sp)
    80001644:	f426                	sd	s1,40(sp)
    80001646:	f04a                	sd	s2,32(sp)
    80001648:	ec4e                	sd	s3,24(sp)
    8000164a:	e852                	sd	s4,16(sp)
    8000164c:	e456                	sd	s5,8(sp)
    8000164e:	e05a                	sd	s6,0(sp)
    80001650:	0080                	addi	s0,sp,64
    80001652:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001654:	0000b497          	auipc	s1,0xb
    80001658:	ecc48493          	addi	s1,s1,-308 # 8000c520 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    8000165c:	8b26                	mv	s6,s1
    8000165e:	00a36937          	lui	s2,0xa36
    80001662:	77d90913          	addi	s2,s2,1917 # a3677d <_entry-0x7f5c9883>
    80001666:	0932                	slli	s2,s2,0xc
    80001668:	46d90913          	addi	s2,s2,1133
    8000166c:	0936                	slli	s2,s2,0xd
    8000166e:	df590913          	addi	s2,s2,-523
    80001672:	093a                	slli	s2,s2,0xe
    80001674:	6cf90913          	addi	s2,s2,1743
    80001678:	040009b7          	lui	s3,0x4000
    8000167c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000167e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001680:	00011a97          	auipc	s5,0x11
    80001684:	ca0a8a93          	addi	s5,s5,-864 # 80012320 <tickslock>
    char *pa = kalloc();
    80001688:	c19fe0ef          	jal	800002a0 <kalloc>
    8000168c:	862a                	mv	a2,a0
    if(pa == 0)
    8000168e:	cd15                	beqz	a0,800016ca <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80001690:	416485b3          	sub	a1,s1,s6
    80001694:	858d                	srai	a1,a1,0x3
    80001696:	032585b3          	mul	a1,a1,s2
    8000169a:	2585                	addiw	a1,a1,1
    8000169c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800016a0:	4719                	li	a4,6
    800016a2:	6685                	lui	a3,0x1
    800016a4:	40b985b3          	sub	a1,s3,a1
    800016a8:	8552                	mv	a0,s4
    800016aa:	b4cff0ef          	jal	800009f6 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016ae:	17848493          	addi	s1,s1,376
    800016b2:	fd549be3          	bne	s1,s5,80001688 <proc_mapstacks+0x4a>
  }
}
    800016b6:	70e2                	ld	ra,56(sp)
    800016b8:	7442                	ld	s0,48(sp)
    800016ba:	74a2                	ld	s1,40(sp)
    800016bc:	7902                	ld	s2,32(sp)
    800016be:	69e2                	ld	s3,24(sp)
    800016c0:	6a42                	ld	s4,16(sp)
    800016c2:	6aa2                	ld	s5,8(sp)
    800016c4:	6b02                	ld	s6,0(sp)
    800016c6:	6121                	addi	sp,sp,64
    800016c8:	8082                	ret
      panic("kalloc");
    800016ca:	00007517          	auipc	a0,0x7
    800016ce:	ea650513          	addi	a0,a0,-346 # 80008570 <etext+0x570>
    800016d2:	4d1040ef          	jal	800063a2 <panic>

00000000800016d6 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800016d6:	7139                	addi	sp,sp,-64
    800016d8:	fc06                	sd	ra,56(sp)
    800016da:	f822                	sd	s0,48(sp)
    800016dc:	f426                	sd	s1,40(sp)
    800016de:	f04a                	sd	s2,32(sp)
    800016e0:	ec4e                	sd	s3,24(sp)
    800016e2:	e852                	sd	s4,16(sp)
    800016e4:	e456                	sd	s5,8(sp)
    800016e6:	e05a                	sd	s6,0(sp)
    800016e8:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    800016ea:	00007597          	auipc	a1,0x7
    800016ee:	e8e58593          	addi	a1,a1,-370 # 80008578 <etext+0x578>
    800016f2:	0000b517          	auipc	a0,0xb
    800016f6:	9ee50513          	addi	a0,a0,-1554 # 8000c0e0 <pid_lock>
    800016fa:	104050ef          	jal	800067fe <initlock>
  initlock(&wait_lock, "wait_lock");
    800016fe:	00007597          	auipc	a1,0x7
    80001702:	e8258593          	addi	a1,a1,-382 # 80008580 <etext+0x580>
    80001706:	0000b517          	auipc	a0,0xb
    8000170a:	9fa50513          	addi	a0,a0,-1542 # 8000c100 <wait_lock>
    8000170e:	0f0050ef          	jal	800067fe <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001712:	0000b497          	auipc	s1,0xb
    80001716:	e0e48493          	addi	s1,s1,-498 # 8000c520 <proc>
      initlock(&p->lock, "proc");
    8000171a:	00007b17          	auipc	s6,0x7
    8000171e:	e76b0b13          	addi	s6,s6,-394 # 80008590 <etext+0x590>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001722:	8aa6                	mv	s5,s1
    80001724:	00a36937          	lui	s2,0xa36
    80001728:	77d90913          	addi	s2,s2,1917 # a3677d <_entry-0x7f5c9883>
    8000172c:	0932                	slli	s2,s2,0xc
    8000172e:	46d90913          	addi	s2,s2,1133
    80001732:	0936                	slli	s2,s2,0xd
    80001734:	df590913          	addi	s2,s2,-523
    80001738:	093a                	slli	s2,s2,0xe
    8000173a:	6cf90913          	addi	s2,s2,1743
    8000173e:	040009b7          	lui	s3,0x4000
    80001742:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001744:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001746:	00011a17          	auipc	s4,0x11
    8000174a:	bdaa0a13          	addi	s4,s4,-1062 # 80012320 <tickslock>
      initlock(&p->lock, "proc");
    8000174e:	85da                	mv	a1,s6
    80001750:	8526                	mv	a0,s1
    80001752:	0ac050ef          	jal	800067fe <initlock>
      p->state = UNUSED;
    80001756:	0204a023          	sw	zero,32(s1)
      p->kstack = KSTACK((int) (p - proc));
    8000175a:	415487b3          	sub	a5,s1,s5
    8000175e:	878d                	srai	a5,a5,0x3
    80001760:	032787b3          	mul	a5,a5,s2
    80001764:	2785                	addiw	a5,a5,1
    80001766:	00d7979b          	slliw	a5,a5,0xd
    8000176a:	40f987b3          	sub	a5,s3,a5
    8000176e:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001770:	17848493          	addi	s1,s1,376
    80001774:	fd449de3          	bne	s1,s4,8000174e <procinit+0x78>
  }
}
    80001778:	70e2                	ld	ra,56(sp)
    8000177a:	7442                	ld	s0,48(sp)
    8000177c:	74a2                	ld	s1,40(sp)
    8000177e:	7902                	ld	s2,32(sp)
    80001780:	69e2                	ld	s3,24(sp)
    80001782:	6a42                	ld	s4,16(sp)
    80001784:	6aa2                	ld	s5,8(sp)
    80001786:	6b02                	ld	s6,0(sp)
    80001788:	6121                	addi	sp,sp,64
    8000178a:	8082                	ret

000000008000178c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    8000178c:	1141                	addi	sp,sp,-16
    8000178e:	e422                	sd	s0,8(sp)
    80001790:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001792:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001794:	2501                	sext.w	a0,a0
    80001796:	6422                	ld	s0,8(sp)
    80001798:	0141                	addi	sp,sp,16
    8000179a:	8082                	ret

000000008000179c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    8000179c:	1141                	addi	sp,sp,-16
    8000179e:	e422                	sd	s0,8(sp)
    800017a0:	0800                	addi	s0,sp,16
    800017a2:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800017a4:	2781                	sext.w	a5,a5
    800017a6:	079e                	slli	a5,a5,0x7
  return c;
}
    800017a8:	0000b517          	auipc	a0,0xb
    800017ac:	97850513          	addi	a0,a0,-1672 # 8000c120 <cpus>
    800017b0:	953e                	add	a0,a0,a5
    800017b2:	6422                	ld	s0,8(sp)
    800017b4:	0141                	addi	sp,sp,16
    800017b6:	8082                	ret

00000000800017b8 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800017b8:	1101                	addi	sp,sp,-32
    800017ba:	ec06                	sd	ra,24(sp)
    800017bc:	e822                	sd	s0,16(sp)
    800017be:	e426                	sd	s1,8(sp)
    800017c0:	1000                	addi	s0,sp,32
  push_off();
    800017c2:	6f5040ef          	jal	800066b6 <push_off>
    800017c6:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800017c8:	2781                	sext.w	a5,a5
    800017ca:	079e                	slli	a5,a5,0x7
    800017cc:	0000b717          	auipc	a4,0xb
    800017d0:	91470713          	addi	a4,a4,-1772 # 8000c0e0 <pid_lock>
    800017d4:	97ba                	add	a5,a5,a4
    800017d6:	63a4                	ld	s1,64(a5)
  pop_off();
    800017d8:	797040ef          	jal	8000676e <pop_off>
  return p;
}
    800017dc:	8526                	mv	a0,s1
    800017de:	60e2                	ld	ra,24(sp)
    800017e0:	6442                	ld	s0,16(sp)
    800017e2:	64a2                	ld	s1,8(sp)
    800017e4:	6105                	addi	sp,sp,32
    800017e6:	8082                	ret

00000000800017e8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800017e8:	1141                	addi	sp,sp,-16
    800017ea:	e406                	sd	ra,8(sp)
    800017ec:	e022                	sd	s0,0(sp)
    800017ee:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800017f0:	fc9ff0ef          	jal	800017b8 <myproc>
    800017f4:	7cf040ef          	jal	800067c2 <release>

  if (first) {
    800017f8:	0000a797          	auipc	a5,0xa
    800017fc:	6487a783          	lw	a5,1608(a5) # 8000be40 <first.1>
    80001800:	e799                	bnez	a5,8000180e <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001802:	3cd000ef          	jal	800023ce <usertrapret>
}
    80001806:	60a2                	ld	ra,8(sp)
    80001808:	6402                	ld	s0,0(sp)
    8000180a:	0141                	addi	sp,sp,16
    8000180c:	8082                	ret
    fsinit(ROOTDEV);
    8000180e:	4505                	li	a0,1
    80001810:	389010ef          	jal	80003398 <fsinit>
    first = 0;
    80001814:	0000a797          	auipc	a5,0xa
    80001818:	6207a623          	sw	zero,1580(a5) # 8000be40 <first.1>
    __sync_synchronize();
    8000181c:	0330000f          	fence	rw,rw
    80001820:	b7cd                	j	80001802 <forkret+0x1a>

0000000080001822 <allocpid>:
{
    80001822:	1101                	addi	sp,sp,-32
    80001824:	ec06                	sd	ra,24(sp)
    80001826:	e822                	sd	s0,16(sp)
    80001828:	e426                	sd	s1,8(sp)
    8000182a:	e04a                	sd	s2,0(sp)
    8000182c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000182e:	0000b917          	auipc	s2,0xb
    80001832:	8b290913          	addi	s2,s2,-1870 # 8000c0e0 <pid_lock>
    80001836:	854a                	mv	a0,s2
    80001838:	6bf040ef          	jal	800066f6 <acquire>
  pid = nextpid;
    8000183c:	0000a797          	auipc	a5,0xa
    80001840:	60878793          	addi	a5,a5,1544 # 8000be44 <nextpid>
    80001844:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001846:	0014871b          	addiw	a4,s1,1
    8000184a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000184c:	854a                	mv	a0,s2
    8000184e:	775040ef          	jal	800067c2 <release>
}
    80001852:	8526                	mv	a0,s1
    80001854:	60e2                	ld	ra,24(sp)
    80001856:	6442                	ld	s0,16(sp)
    80001858:	64a2                	ld	s1,8(sp)
    8000185a:	6902                	ld	s2,0(sp)
    8000185c:	6105                	addi	sp,sp,32
    8000185e:	8082                	ret

0000000080001860 <proc_pagetable>:
{
    80001860:	1101                	addi	sp,sp,-32
    80001862:	ec06                	sd	ra,24(sp)
    80001864:	e822                	sd	s0,16(sp)
    80001866:	e426                	sd	s1,8(sp)
    80001868:	e04a                	sd	s2,0(sp)
    8000186a:	1000                	addi	s0,sp,32
    8000186c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000186e:	ca6ff0ef          	jal	80000d14 <uvmcreate>
    80001872:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001874:	cd05                	beqz	a0,800018ac <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001876:	4729                	li	a4,10
    80001878:	00005697          	auipc	a3,0x5
    8000187c:	78868693          	addi	a3,a3,1928 # 80007000 <_trampoline>
    80001880:	6605                	lui	a2,0x1
    80001882:	040005b7          	lui	a1,0x4000
    80001886:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001888:	05b2                	slli	a1,a1,0xc
    8000188a:	8b2ff0ef          	jal	8000093c <mappages>
    8000188e:	02054663          	bltz	a0,800018ba <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001892:	4719                	li	a4,6
    80001894:	06093683          	ld	a3,96(s2)
    80001898:	6605                	lui	a2,0x1
    8000189a:	020005b7          	lui	a1,0x2000
    8000189e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800018a0:	05b6                	slli	a1,a1,0xd
    800018a2:	8526                	mv	a0,s1
    800018a4:	898ff0ef          	jal	8000093c <mappages>
    800018a8:	00054f63          	bltz	a0,800018c6 <proc_pagetable+0x66>
}
    800018ac:	8526                	mv	a0,s1
    800018ae:	60e2                	ld	ra,24(sp)
    800018b0:	6442                	ld	s0,16(sp)
    800018b2:	64a2                	ld	s1,8(sp)
    800018b4:	6902                	ld	s2,0(sp)
    800018b6:	6105                	addi	sp,sp,32
    800018b8:	8082                	ret
    uvmfree(pagetable, 0);
    800018ba:	4581                	li	a1,0
    800018bc:	8526                	mv	a0,s1
    800018be:	e1eff0ef          	jal	80000edc <uvmfree>
    return 0;
    800018c2:	4481                	li	s1,0
    800018c4:	b7e5                	j	800018ac <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800018c6:	4681                	li	a3,0
    800018c8:	4605                	li	a2,1
    800018ca:	040005b7          	lui	a1,0x4000
    800018ce:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800018d0:	05b2                	slli	a1,a1,0xc
    800018d2:	8526                	mv	a0,s1
    800018d4:	aecff0ef          	jal	80000bc0 <uvmunmap>
    uvmfree(pagetable, 0);
    800018d8:	4581                	li	a1,0
    800018da:	8526                	mv	a0,s1
    800018dc:	e00ff0ef          	jal	80000edc <uvmfree>
    return 0;
    800018e0:	4481                	li	s1,0
    800018e2:	b7e9                	j	800018ac <proc_pagetable+0x4c>

00000000800018e4 <proc_freepagetable>:
{
    800018e4:	1101                	addi	sp,sp,-32
    800018e6:	ec06                	sd	ra,24(sp)
    800018e8:	e822                	sd	s0,16(sp)
    800018ea:	e426                	sd	s1,8(sp)
    800018ec:	e04a                	sd	s2,0(sp)
    800018ee:	1000                	addi	s0,sp,32
    800018f0:	84aa                	mv	s1,a0
    800018f2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, PGSIZE, 0);
    800018f4:	4681                	li	a3,0
    800018f6:	6605                	lui	a2,0x1
    800018f8:	040005b7          	lui	a1,0x4000
    800018fc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800018fe:	05b2                	slli	a1,a1,0xc
    80001900:	ac0ff0ef          	jal	80000bc0 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, PGSIZE, 0);
    80001904:	4681                	li	a3,0
    80001906:	6605                	lui	a2,0x1
    80001908:	020005b7          	lui	a1,0x2000
    8000190c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000190e:	05b6                	slli	a1,a1,0xd
    80001910:	8526                	mv	a0,s1
    80001912:	aaeff0ef          	jal	80000bc0 <uvmunmap>
  uvmfree(pagetable, sz); 
    80001916:	85ca                	mv	a1,s2
    80001918:	8526                	mv	a0,s1
    8000191a:	dc2ff0ef          	jal	80000edc <uvmfree>
}
    8000191e:	60e2                	ld	ra,24(sp)
    80001920:	6442                	ld	s0,16(sp)
    80001922:	64a2                	ld	s1,8(sp)
    80001924:	6902                	ld	s2,0(sp)
    80001926:	6105                	addi	sp,sp,32
    80001928:	8082                	ret

000000008000192a <freeproc>:
{
    8000192a:	1101                	addi	sp,sp,-32
    8000192c:	ec06                	sd	ra,24(sp)
    8000192e:	e822                	sd	s0,16(sp)
    80001930:	e426                	sd	s1,8(sp)
    80001932:	1000                	addi	s0,sp,32
    80001934:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001936:	7128                	ld	a0,96(a0)
    80001938:	c119                	beqz	a0,8000193e <freeproc+0x14>
    kfree((void*)p->trapframe);
    8000193a:	8adfe0ef          	jal	800001e6 <kfree>
  p->trapframe = 0;
    8000193e:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001942:	6ca8                	ld	a0,88(s1)
    80001944:	c501                	beqz	a0,8000194c <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001946:	68ac                	ld	a1,80(s1)
    80001948:	f9dff0ef          	jal	800018e4 <proc_freepagetable>
  p->pagetable = 0;
    8000194c:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001950:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001954:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001958:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    8000195c:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001960:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001964:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001968:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    8000196c:	0204a023          	sw	zero,32(s1)
}
    80001970:	60e2                	ld	ra,24(sp)
    80001972:	6442                	ld	s0,16(sp)
    80001974:	64a2                	ld	s1,8(sp)
    80001976:	6105                	addi	sp,sp,32
    80001978:	8082                	ret

000000008000197a <allocproc>:
{
    8000197a:	1101                	addi	sp,sp,-32
    8000197c:	ec06                	sd	ra,24(sp)
    8000197e:	e822                	sd	s0,16(sp)
    80001980:	e426                	sd	s1,8(sp)
    80001982:	e04a                	sd	s2,0(sp)
    80001984:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001986:	0000b497          	auipc	s1,0xb
    8000198a:	b9a48493          	addi	s1,s1,-1126 # 8000c520 <proc>
    8000198e:	00011917          	auipc	s2,0x11
    80001992:	99290913          	addi	s2,s2,-1646 # 80012320 <tickslock>
    acquire(&p->lock);
    80001996:	8526                	mv	a0,s1
    80001998:	55f040ef          	jal	800066f6 <acquire>
    if(p->state == UNUSED) {
    8000199c:	509c                	lw	a5,32(s1)
    8000199e:	cb91                	beqz	a5,800019b2 <allocproc+0x38>
      release(&p->lock);
    800019a0:	8526                	mv	a0,s1
    800019a2:	621040ef          	jal	800067c2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800019a6:	17848493          	addi	s1,s1,376
    800019aa:	ff2496e3          	bne	s1,s2,80001996 <allocproc+0x1c>
  return 0;
    800019ae:	4481                	li	s1,0
    800019b0:	a089                	j	800019f2 <allocproc+0x78>
  p->pid = allocpid();
    800019b2:	e71ff0ef          	jal	80001822 <allocpid>
    800019b6:	dc88                	sw	a0,56(s1)
  p->state = USED;
    800019b8:	4785                	li	a5,1
    800019ba:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800019bc:	8e5fe0ef          	jal	800002a0 <kalloc>
    800019c0:	892a                	mv	s2,a0
    800019c2:	f0a8                	sd	a0,96(s1)
    800019c4:	cd15                	beqz	a0,80001a00 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    800019c6:	8526                	mv	a0,s1
    800019c8:	e99ff0ef          	jal	80001860 <proc_pagetable>
    800019cc:	892a                	mv	s2,a0
    800019ce:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    800019d0:	c121                	beqz	a0,80001a10 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    800019d2:	07000613          	li	a2,112
    800019d6:	4581                	li	a1,0
    800019d8:	06848513          	addi	a0,s1,104
    800019dc:	ad3fe0ef          	jal	800004ae <memset>
  p->context.ra = (uint64)forkret;
    800019e0:	00000797          	auipc	a5,0x0
    800019e4:	e0878793          	addi	a5,a5,-504 # 800017e8 <forkret>
    800019e8:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    800019ea:	64bc                	ld	a5,72(s1)
    800019ec:	6705                	lui	a4,0x1
    800019ee:	97ba                	add	a5,a5,a4
    800019f0:	f8bc                	sd	a5,112(s1)
}
    800019f2:	8526                	mv	a0,s1
    800019f4:	60e2                	ld	ra,24(sp)
    800019f6:	6442                	ld	s0,16(sp)
    800019f8:	64a2                	ld	s1,8(sp)
    800019fa:	6902                	ld	s2,0(sp)
    800019fc:	6105                	addi	sp,sp,32
    800019fe:	8082                	ret
    freeproc(p);
    80001a00:	8526                	mv	a0,s1
    80001a02:	f29ff0ef          	jal	8000192a <freeproc>
    release(&p->lock);
    80001a06:	8526                	mv	a0,s1
    80001a08:	5bb040ef          	jal	800067c2 <release>
    return 0;
    80001a0c:	84ca                	mv	s1,s2
    80001a0e:	b7d5                	j	800019f2 <allocproc+0x78>
    freeproc(p);
    80001a10:	8526                	mv	a0,s1
    80001a12:	f19ff0ef          	jal	8000192a <freeproc>
    release(&p->lock);
    80001a16:	8526                	mv	a0,s1
    80001a18:	5ab040ef          	jal	800067c2 <release>
    return 0;
    80001a1c:	84ca                	mv	s1,s2
    80001a1e:	bfd1                	j	800019f2 <allocproc+0x78>

0000000080001a20 <userinit>:
{
    80001a20:	1101                	addi	sp,sp,-32
    80001a22:	ec06                	sd	ra,24(sp)
    80001a24:	e822                	sd	s0,16(sp)
    80001a26:	e426                	sd	s1,8(sp)
    80001a28:	1000                	addi	s0,sp,32
  p = allocproc();
    80001a2a:	f51ff0ef          	jal	8000197a <allocproc>
    80001a2e:	84aa                	mv	s1,a0
  initproc = p;
    80001a30:	0000a797          	auipc	a5,0xa
    80001a34:	4aa7b423          	sd	a0,1192(a5) # 8000bed8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001a38:	03400613          	li	a2,52
    80001a3c:	0000a597          	auipc	a1,0xa
    80001a40:	41458593          	addi	a1,a1,1044 # 8000be50 <initcode>
    80001a44:	6d28                	ld	a0,88(a0)
    80001a46:	af4ff0ef          	jal	80000d3a <uvmfirst>
  p->sz = PGSIZE;
    80001a4a:	6785                	lui	a5,0x1
    80001a4c:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    80001a4e:	70b8                	ld	a4,96(s1)
    80001a50:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001a54:	70b8                	ld	a4,96(s1)
    80001a56:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001a58:	4641                	li	a2,16
    80001a5a:	00007597          	auipc	a1,0x7
    80001a5e:	b3e58593          	addi	a1,a1,-1218 # 80008598 <etext+0x598>
    80001a62:	16048513          	addi	a0,s1,352
    80001a66:	b87fe0ef          	jal	800005ec <safestrcpy>
  p->cwd = namei("/");
    80001a6a:	00007517          	auipc	a0,0x7
    80001a6e:	b3e50513          	addi	a0,a0,-1218 # 800085a8 <etext+0x5a8>
    80001a72:	26c020ef          	jal	80003cde <namei>
    80001a76:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001a7a:	478d                	li	a5,3
    80001a7c:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    80001a7e:	8526                	mv	a0,s1
    80001a80:	543040ef          	jal	800067c2 <release>
}
    80001a84:	60e2                	ld	ra,24(sp)
    80001a86:	6442                	ld	s0,16(sp)
    80001a88:	64a2                	ld	s1,8(sp)
    80001a8a:	6105                	addi	sp,sp,32
    80001a8c:	8082                	ret

0000000080001a8e <growproc>:
{
    80001a8e:	7139                	addi	sp,sp,-64
    80001a90:	fc06                	sd	ra,56(sp)
    80001a92:	f822                	sd	s0,48(sp)
    80001a94:	f04a                	sd	s2,32(sp)
    80001a96:	ec4e                	sd	s3,24(sp)
    80001a98:	0080                	addi	s0,sp,64
    80001a9a:	89aa                	mv	s3,a0
  struct proc *p = myproc();
    80001a9c:	d1dff0ef          	jal	800017b8 <myproc>
    80001aa0:	892a                	mv	s2,a0
  if (n > 0) {
    80001aa2:	09305663          	blez	s3,80001b2e <growproc+0xa0>
    80001aa6:	f426                	sd	s1,40(sp)
    80001aa8:	e852                	sd	s4,16(sp)
    80001aaa:	e456                	sd	s5,8(sp)
    80001aac:	e05a                	sd	s6,0(sp)
    if ((target_newsz = p->sz + n) > MAXVA) return -1;
    80001aae:	05053b03          	ld	s6,80(a0)
    80001ab2:	99da                	add	s3,s3,s6
    80001ab4:	4785                	li	a5,1
    80001ab6:	179a                	slli	a5,a5,0x26
    80001ab8:	0f37ec63          	bltu	a5,s3,80001bb0 <growproc+0x122>
  uint64 next_sp_boundary = SUPERPGROUNDUP(p->sz);
    80001abc:	002007b7          	lui	a5,0x200
    80001ac0:	17fd                	addi	a5,a5,-1 # 1fffff <_entry-0x7fe00001>
    80001ac2:	97da                	add	a5,a5,s6
    80001ac4:	ffe00737          	lui	a4,0xffe00
    80001ac8:	8ff9                	and	a5,a5,a4
  if (next_sp_boundary > p->sz) {
    80001aca:	08fb6363          	bltu	s6,a5,80001b50 <growproc+0xc2>
  while (p->sz + SUPERPGSIZE <= target_newsz) {
    80001ace:	05093703          	ld	a4,80(s2)
    80001ad2:	002007b7          	lui	a5,0x200
    80001ad6:	97ba                	add	a5,a5,a4
    80001ad8:	02f9ec63          	bltu	s3,a5,80001b10 <growproc+0x82>
      p->sz += SUPERPGSIZE;
    80001adc:	00200ab7          	lui	s5,0x200
  while (p->sz + SUPERPGSIZE <= target_newsz) {
    80001ae0:	00400a37          	lui	s4,0x400
    void* pa = superalloc();
    80001ae4:	899fe0ef          	jal	8000037c <superalloc>
    80001ae8:	84aa                	mv	s1,a0
    if(pa) {
    80001aea:	c11d                	beqz	a0,80001b10 <growproc+0x82>
      if(uvmmap_super(p->pagetable, p->sz, (uint64)pa, PTE_U|PTE_R|PTE_W) != 0) {
    80001aec:	46d9                	li	a3,22
    80001aee:	862a                	mv	a2,a0
    80001af0:	05093583          	ld	a1,80(s2)
    80001af4:	05893503          	ld	a0,88(s2)
    80001af8:	ff5fe0ef          	jal	80000aec <uvmmap_super>
    80001afc:	e92d                	bnez	a0,80001b6e <growproc+0xe0>
      p->sz += SUPERPGSIZE;
    80001afe:	05093783          	ld	a5,80(s2)
    80001b02:	01578733          	add	a4,a5,s5
    80001b06:	04e93823          	sd	a4,80(s2)
  while (p->sz + SUPERPGSIZE <= target_newsz) {
    80001b0a:	97d2                	add	a5,a5,s4
    80001b0c:	fcf9fce3          	bgeu	s3,a5,80001ae4 <growproc+0x56>
  if (p->sz < target_newsz) {
    80001b10:	05093583          	ld	a1,80(s2)
  return 0;
    80001b14:	4501                	li	a0,0
  if (p->sz < target_newsz) {
    80001b16:	0735ee63          	bltu	a1,s3,80001b92 <growproc+0x104>
    80001b1a:	74a2                	ld	s1,40(sp)
    80001b1c:	6a42                	ld	s4,16(sp)
    80001b1e:	6aa2                	ld	s5,8(sp)
    80001b20:	6b02                	ld	s6,0(sp)
}
    80001b22:	70e2                	ld	ra,56(sp)
    80001b24:	7442                	ld	s0,48(sp)
    80001b26:	7902                	ld	s2,32(sp)
    80001b28:	69e2                	ld	s3,24(sp)
    80001b2a:	6121                	addi	sp,sp,64
    80001b2c:	8082                	ret
    return 0;
    80001b2e:	4501                	li	a0,0
  } else if (n < 0) {
    80001b30:	fe09d9e3          	bgez	s3,80001b22 <growproc+0x94>
    target_newsz = p->sz + n;
    80001b34:	05093583          	ld	a1,80(s2)
    80001b38:	00b98633          	add	a2,s3,a1
    if (target_newsz > p->sz) return -1; // overflow
    80001b3c:	08c5e063          	bltu	a1,a2,80001bbc <growproc+0x12e>
    p->sz = uvmdealloc(p->pagetable, p->sz, target_newsz);
    80001b40:	05893503          	ld	a0,88(s2)
    80001b44:	a54ff0ef          	jal	80000d98 <uvmdealloc>
    80001b48:	04a93823          	sd	a0,80(s2)
    return 0;
    80001b4c:	4501                	li	a0,0
    80001b4e:	bfd1                	j	80001b22 <growproc+0x94>
    uint64 alloc_until = (next_sp_boundary < target_newsz) ? next_sp_boundary : target_newsz;
    80001b50:	84ce                	mv	s1,s3
    80001b52:	0137f363          	bgeu	a5,s3,80001b58 <growproc+0xca>
    80001b56:	84be                	mv	s1,a5
    if (uvmalloc(p->pagetable, p->sz, alloc_until, PTE_W) == 0) {
    80001b58:	4691                	li	a3,4
    80001b5a:	8626                	mv	a2,s1
    80001b5c:	85da                	mv	a1,s6
    80001b5e:	05893503          	ld	a0,88(s2)
    80001b62:	a74ff0ef          	jal	80000dd6 <uvmalloc>
    80001b66:	cd29                	beqz	a0,80001bc0 <growproc+0x132>
    p->sz = alloc_until;
    80001b68:	04993823          	sd	s1,80(s2)
    80001b6c:	b78d                	j	80001ace <growproc+0x40>
        superfree(pa);
    80001b6e:	8526                	mv	a0,s1
    80001b70:	897fe0ef          	jal	80000406 <superfree>
  uvmdealloc(p->pagetable, p->sz, original_sz);
    80001b74:	865a                	mv	a2,s6
    80001b76:	05093583          	ld	a1,80(s2)
    80001b7a:	05893503          	ld	a0,88(s2)
    80001b7e:	a1aff0ef          	jal	80000d98 <uvmdealloc>
  p->sz = original_sz;
    80001b82:	05693823          	sd	s6,80(s2)
  return -1;
    80001b86:	557d                	li	a0,-1
    80001b88:	74a2                	ld	s1,40(sp)
    80001b8a:	6a42                	ld	s4,16(sp)
    80001b8c:	6aa2                	ld	s5,8(sp)
    80001b8e:	6b02                	ld	s6,0(sp)
    80001b90:	bf49                	j	80001b22 <growproc+0x94>
    if (uvmalloc(p->pagetable, p->sz, target_newsz, PTE_W) == 0) {
    80001b92:	4691                	li	a3,4
    80001b94:	864e                	mv	a2,s3
    80001b96:	05893503          	ld	a0,88(s2)
    80001b9a:	a3cff0ef          	jal	80000dd6 <uvmalloc>
    80001b9e:	d979                	beqz	a0,80001b74 <growproc+0xe6>
    p->sz = target_newsz;
    80001ba0:	05393823          	sd	s3,80(s2)
  return 0;
    80001ba4:	4501                	li	a0,0
    80001ba6:	74a2                	ld	s1,40(sp)
    80001ba8:	6a42                	ld	s4,16(sp)
    80001baa:	6aa2                	ld	s5,8(sp)
    80001bac:	6b02                	ld	s6,0(sp)
    80001bae:	bf95                	j	80001b22 <growproc+0x94>
    if ((target_newsz = p->sz + n) > MAXVA) return -1;
    80001bb0:	557d                	li	a0,-1
    80001bb2:	74a2                	ld	s1,40(sp)
    80001bb4:	6a42                	ld	s4,16(sp)
    80001bb6:	6aa2                	ld	s5,8(sp)
    80001bb8:	6b02                	ld	s6,0(sp)
    80001bba:	b7a5                	j	80001b22 <growproc+0x94>
    if (target_newsz > p->sz) return -1; // overflow
    80001bbc:	557d                	li	a0,-1
    80001bbe:	b795                	j	80001b22 <growproc+0x94>
      return -1;
    80001bc0:	557d                	li	a0,-1
    80001bc2:	74a2                	ld	s1,40(sp)
    80001bc4:	6a42                	ld	s4,16(sp)
    80001bc6:	6aa2                	ld	s5,8(sp)
    80001bc8:	6b02                	ld	s6,0(sp)
    80001bca:	bfa1                	j	80001b22 <growproc+0x94>

0000000080001bcc <fork>:
{
    80001bcc:	7139                	addi	sp,sp,-64
    80001bce:	fc06                	sd	ra,56(sp)
    80001bd0:	f822                	sd	s0,48(sp)
    80001bd2:	f04a                	sd	s2,32(sp)
    80001bd4:	e456                	sd	s5,8(sp)
    80001bd6:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001bd8:	be1ff0ef          	jal	800017b8 <myproc>
    80001bdc:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001bde:	d9dff0ef          	jal	8000197a <allocproc>
    80001be2:	0e050e63          	beqz	a0,80001cde <fork+0x112>
    80001be6:	ec4e                	sd	s3,24(sp)
    80001be8:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001bea:	050ab603          	ld	a2,80(s5) # 200050 <_entry-0x7fdfffb0>
    80001bee:	6d2c                	ld	a1,88(a0)
    80001bf0:	058ab503          	ld	a0,88(s5)
    80001bf4:	b62ff0ef          	jal	80000f56 <uvmcopy>
    80001bf8:	04054a63          	bltz	a0,80001c4c <fork+0x80>
    80001bfc:	f426                	sd	s1,40(sp)
    80001bfe:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001c00:	050ab783          	ld	a5,80(s5)
    80001c04:	04f9b823          	sd	a5,80(s3)
  *(np->trapframe) = *(p->trapframe);
    80001c08:	060ab683          	ld	a3,96(s5)
    80001c0c:	87b6                	mv	a5,a3
    80001c0e:	0609b703          	ld	a4,96(s3)
    80001c12:	12068693          	addi	a3,a3,288
    80001c16:	0007b803          	ld	a6,0(a5) # 200000 <_entry-0x7fe00000>
    80001c1a:	6788                	ld	a0,8(a5)
    80001c1c:	6b8c                	ld	a1,16(a5)
    80001c1e:	6f90                	ld	a2,24(a5)
    80001c20:	01073023          	sd	a6,0(a4) # ffffffffffe00000 <end+0xffffffff7fdda108>
    80001c24:	e708                	sd	a0,8(a4)
    80001c26:	eb0c                	sd	a1,16(a4)
    80001c28:	ef10                	sd	a2,24(a4)
    80001c2a:	02078793          	addi	a5,a5,32
    80001c2e:	02070713          	addi	a4,a4,32
    80001c32:	fed792e3          	bne	a5,a3,80001c16 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001c36:	0609b783          	ld	a5,96(s3)
    80001c3a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001c3e:	0d8a8493          	addi	s1,s5,216
    80001c42:	0d898913          	addi	s2,s3,216
    80001c46:	158a8a13          	addi	s4,s5,344
    80001c4a:	a831                	j	80001c66 <fork+0x9a>
    freeproc(np);
    80001c4c:	854e                	mv	a0,s3
    80001c4e:	cddff0ef          	jal	8000192a <freeproc>
    release(&np->lock);
    80001c52:	854e                	mv	a0,s3
    80001c54:	36f040ef          	jal	800067c2 <release>
    return -1;
    80001c58:	597d                	li	s2,-1
    80001c5a:	69e2                	ld	s3,24(sp)
    80001c5c:	a895                	j	80001cd0 <fork+0x104>
  for(i = 0; i < NOFILE; i++)
    80001c5e:	04a1                	addi	s1,s1,8
    80001c60:	0921                	addi	s2,s2,8
    80001c62:	01448963          	beq	s1,s4,80001c74 <fork+0xa8>
    if(p->ofile[i])
    80001c66:	6088                	ld	a0,0(s1)
    80001c68:	d97d                	beqz	a0,80001c5e <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001c6a:	604020ef          	jal	8000426e <filedup>
    80001c6e:	00a93023          	sd	a0,0(s2)
    80001c72:	b7f5                	j	80001c5e <fork+0x92>
  np->cwd = idup(p->cwd);
    80001c74:	158ab503          	ld	a0,344(s5)
    80001c78:	157010ef          	jal	800035ce <idup>
    80001c7c:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001c80:	4641                	li	a2,16
    80001c82:	160a8593          	addi	a1,s5,352
    80001c86:	16098513          	addi	a0,s3,352
    80001c8a:	963fe0ef          	jal	800005ec <safestrcpy>
  np->tracemask = p->tracemask; // <--- 添加的行
    80001c8e:	170aa783          	lw	a5,368(s5)
    80001c92:	16f9a823          	sw	a5,368(s3)
  pid = np->pid;
    80001c96:	0389a903          	lw	s2,56(s3)
  release(&np->lock);
    80001c9a:	854e                	mv	a0,s3
    80001c9c:	327040ef          	jal	800067c2 <release>
  acquire(&wait_lock);
    80001ca0:	0000a497          	auipc	s1,0xa
    80001ca4:	46048493          	addi	s1,s1,1120 # 8000c100 <wait_lock>
    80001ca8:	8526                	mv	a0,s1
    80001caa:	24d040ef          	jal	800066f6 <acquire>
  np->parent = p;
    80001cae:	0559b023          	sd	s5,64(s3)
  release(&wait_lock);
    80001cb2:	8526                	mv	a0,s1
    80001cb4:	30f040ef          	jal	800067c2 <release>
  acquire(&np->lock);
    80001cb8:	854e                	mv	a0,s3
    80001cba:	23d040ef          	jal	800066f6 <acquire>
  np->state = RUNNABLE;
    80001cbe:	478d                	li	a5,3
    80001cc0:	02f9a023          	sw	a5,32(s3)
  release(&np->lock);
    80001cc4:	854e                	mv	a0,s3
    80001cc6:	2fd040ef          	jal	800067c2 <release>
  return pid;
    80001cca:	74a2                	ld	s1,40(sp)
    80001ccc:	69e2                	ld	s3,24(sp)
    80001cce:	6a42                	ld	s4,16(sp)
}
    80001cd0:	854a                	mv	a0,s2
    80001cd2:	70e2                	ld	ra,56(sp)
    80001cd4:	7442                	ld	s0,48(sp)
    80001cd6:	7902                	ld	s2,32(sp)
    80001cd8:	6aa2                	ld	s5,8(sp)
    80001cda:	6121                	addi	sp,sp,64
    80001cdc:	8082                	ret
    return -1;
    80001cde:	597d                	li	s2,-1
    80001ce0:	bfc5                	j	80001cd0 <fork+0x104>

0000000080001ce2 <scheduler>:
{
    80001ce2:	7139                	addi	sp,sp,-64
    80001ce4:	fc06                	sd	ra,56(sp)
    80001ce6:	f822                	sd	s0,48(sp)
    80001ce8:	f426                	sd	s1,40(sp)
    80001cea:	f04a                	sd	s2,32(sp)
    80001cec:	ec4e                	sd	s3,24(sp)
    80001cee:	e852                	sd	s4,16(sp)
    80001cf0:	e456                	sd	s5,8(sp)
    80001cf2:	e05a                	sd	s6,0(sp)
    80001cf4:	0080                	addi	s0,sp,64
    80001cf6:	8792                	mv	a5,tp
  int id = r_tp();
    80001cf8:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001cfa:	00779a93          	slli	s5,a5,0x7
    80001cfe:	0000a717          	auipc	a4,0xa
    80001d02:	3e270713          	addi	a4,a4,994 # 8000c0e0 <pid_lock>
    80001d06:	9756                	add	a4,a4,s5
    80001d08:	04073023          	sd	zero,64(a4)
        swtch(&c->context, &p->context); // Context switch
    80001d0c:	0000a717          	auipc	a4,0xa
    80001d10:	41c70713          	addi	a4,a4,1052 # 8000c128 <cpus+0x8>
    80001d14:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001d16:	498d                	li	s3,3
        p->state = RUNNING;
    80001d18:	4b11                	li	s6,4
        c->proc = p;
    80001d1a:	079e                	slli	a5,a5,0x7
    80001d1c:	0000aa17          	auipc	s4,0xa
    80001d20:	3c4a0a13          	addi	s4,s4,964 # 8000c0e0 <pid_lock>
    80001d24:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d26:	00010917          	auipc	s2,0x10
    80001d2a:	5fa90913          	addi	s2,s2,1530 # 80012320 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d2e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d32:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d36:	10079073          	csrw	sstatus,a5
    80001d3a:	0000a497          	auipc	s1,0xa
    80001d3e:	7e648493          	addi	s1,s1,2022 # 8000c520 <proc>
    80001d42:	a801                	j	80001d52 <scheduler+0x70>
      release(&p->lock);
    80001d44:	8526                	mv	a0,s1
    80001d46:	27d040ef          	jal	800067c2 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d4a:	17848493          	addi	s1,s1,376
    80001d4e:	ff2480e3          	beq	s1,s2,80001d2e <scheduler+0x4c>
      acquire(&p->lock);
    80001d52:	8526                	mv	a0,s1
    80001d54:	1a3040ef          	jal	800066f6 <acquire>
      if(p->state == RUNNABLE) {
    80001d58:	509c                	lw	a5,32(s1)
    80001d5a:	ff3795e3          	bne	a5,s3,80001d44 <scheduler+0x62>
        p->state = RUNNING;
    80001d5e:	0364a023          	sw	s6,32(s1)
        c->proc = p;
    80001d62:	049a3023          	sd	s1,64(s4)
        swtch(&c->context, &p->context); // Context switch
    80001d66:	06848593          	addi	a1,s1,104
    80001d6a:	8556                	mv	a0,s5
    80001d6c:	5bc000ef          	jal	80002328 <swtch>
        c->proc = 0;
    80001d70:	040a3023          	sd	zero,64(s4)
    80001d74:	bfc1                	j	80001d44 <scheduler+0x62>

0000000080001d76 <sched>:
{
    80001d76:	7179                	addi	sp,sp,-48
    80001d78:	f406                	sd	ra,40(sp)
    80001d7a:	f022                	sd	s0,32(sp)
    80001d7c:	ec26                	sd	s1,24(sp)
    80001d7e:	e84a                	sd	s2,16(sp)
    80001d80:	e44e                	sd	s3,8(sp)
    80001d82:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001d84:	a35ff0ef          	jal	800017b8 <myproc>
    80001d88:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001d8a:	0fd040ef          	jal	80006686 <holding>
    80001d8e:	c92d                	beqz	a0,80001e00 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d90:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001d92:	2781                	sext.w	a5,a5
    80001d94:	079e                	slli	a5,a5,0x7
    80001d96:	0000a717          	auipc	a4,0xa
    80001d9a:	34a70713          	addi	a4,a4,842 # 8000c0e0 <pid_lock>
    80001d9e:	97ba                	add	a5,a5,a4
    80001da0:	0b87a703          	lw	a4,184(a5)
    80001da4:	4785                	li	a5,1
    80001da6:	06f71363          	bne	a4,a5,80001e0c <sched+0x96>
  if(p->state == RUNNING)
    80001daa:	5098                	lw	a4,32(s1)
    80001dac:	4791                	li	a5,4
    80001dae:	06f70563          	beq	a4,a5,80001e18 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001db6:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001db8:	e7b5                	bnez	a5,80001e24 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001dba:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001dbc:	0000a917          	auipc	s2,0xa
    80001dc0:	32490913          	addi	s2,s2,804 # 8000c0e0 <pid_lock>
    80001dc4:	2781                	sext.w	a5,a5
    80001dc6:	079e                	slli	a5,a5,0x7
    80001dc8:	97ca                	add	a5,a5,s2
    80001dca:	0bc7a983          	lw	s3,188(a5)
    80001dce:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001dd0:	2781                	sext.w	a5,a5
    80001dd2:	079e                	slli	a5,a5,0x7
    80001dd4:	0000a597          	auipc	a1,0xa
    80001dd8:	35458593          	addi	a1,a1,852 # 8000c128 <cpus+0x8>
    80001ddc:	95be                	add	a1,a1,a5
    80001dde:	06848513          	addi	a0,s1,104
    80001de2:	546000ef          	jal	80002328 <swtch>
    80001de6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001de8:	2781                	sext.w	a5,a5
    80001dea:	079e                	slli	a5,a5,0x7
    80001dec:	993e                	add	s2,s2,a5
    80001dee:	0b392e23          	sw	s3,188(s2)
}
    80001df2:	70a2                	ld	ra,40(sp)
    80001df4:	7402                	ld	s0,32(sp)
    80001df6:	64e2                	ld	s1,24(sp)
    80001df8:	6942                	ld	s2,16(sp)
    80001dfa:	69a2                	ld	s3,8(sp)
    80001dfc:	6145                	addi	sp,sp,48
    80001dfe:	8082                	ret
    panic("sched p->lock");
    80001e00:	00006517          	auipc	a0,0x6
    80001e04:	7b050513          	addi	a0,a0,1968 # 800085b0 <etext+0x5b0>
    80001e08:	59a040ef          	jal	800063a2 <panic>
    panic("sched locks");
    80001e0c:	00006517          	auipc	a0,0x6
    80001e10:	7b450513          	addi	a0,a0,1972 # 800085c0 <etext+0x5c0>
    80001e14:	58e040ef          	jal	800063a2 <panic>
    panic("sched running");
    80001e18:	00006517          	auipc	a0,0x6
    80001e1c:	7b850513          	addi	a0,a0,1976 # 800085d0 <etext+0x5d0>
    80001e20:	582040ef          	jal	800063a2 <panic>
    panic("sched interruptible");
    80001e24:	00006517          	auipc	a0,0x6
    80001e28:	7bc50513          	addi	a0,a0,1980 # 800085e0 <etext+0x5e0>
    80001e2c:	576040ef          	jal	800063a2 <panic>

0000000080001e30 <yield>:
{
    80001e30:	1101                	addi	sp,sp,-32
    80001e32:	ec06                	sd	ra,24(sp)
    80001e34:	e822                	sd	s0,16(sp)
    80001e36:	e426                	sd	s1,8(sp)
    80001e38:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001e3a:	97fff0ef          	jal	800017b8 <myproc>
    80001e3e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001e40:	0b7040ef          	jal	800066f6 <acquire>
  p->state = RUNNABLE;
    80001e44:	478d                	li	a5,3
    80001e46:	d09c                	sw	a5,32(s1)
  sched();
    80001e48:	f2fff0ef          	jal	80001d76 <sched>
  release(&p->lock);
    80001e4c:	8526                	mv	a0,s1
    80001e4e:	175040ef          	jal	800067c2 <release>
}
    80001e52:	60e2                	ld	ra,24(sp)
    80001e54:	6442                	ld	s0,16(sp)
    80001e56:	64a2                	ld	s1,8(sp)
    80001e58:	6105                	addi	sp,sp,32
    80001e5a:	8082                	ret

0000000080001e5c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001e5c:	7179                	addi	sp,sp,-48
    80001e5e:	f406                	sd	ra,40(sp)
    80001e60:	f022                	sd	s0,32(sp)
    80001e62:	ec26                	sd	s1,24(sp)
    80001e64:	e84a                	sd	s2,16(sp)
    80001e66:	e44e                	sd	s3,8(sp)
    80001e68:	1800                	addi	s0,sp,48
    80001e6a:	89aa                	mv	s3,a0
    80001e6c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e6e:	94bff0ef          	jal	800017b8 <myproc>
    80001e72:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001e74:	083040ef          	jal	800066f6 <acquire>
  release(lk);
    80001e78:	854a                	mv	a0,s2
    80001e7a:	149040ef          	jal	800067c2 <release>

  // Go to sleep.
  p->chan = chan;
    80001e7e:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    80001e82:	4789                	li	a5,2
    80001e84:	d09c                	sw	a5,32(s1)

  sched();
    80001e86:	ef1ff0ef          	jal	80001d76 <sched>

  // Tidy up.
  p->chan = 0;
    80001e8a:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001e8e:	8526                	mv	a0,s1
    80001e90:	133040ef          	jal	800067c2 <release>
  acquire(lk);
    80001e94:	854a                	mv	a0,s2
    80001e96:	061040ef          	jal	800066f6 <acquire>
}
    80001e9a:	70a2                	ld	ra,40(sp)
    80001e9c:	7402                	ld	s0,32(sp)
    80001e9e:	64e2                	ld	s1,24(sp)
    80001ea0:	6942                	ld	s2,16(sp)
    80001ea2:	69a2                	ld	s3,8(sp)
    80001ea4:	6145                	addi	sp,sp,48
    80001ea6:	8082                	ret

0000000080001ea8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001ea8:	7139                	addi	sp,sp,-64
    80001eaa:	fc06                	sd	ra,56(sp)
    80001eac:	f822                	sd	s0,48(sp)
    80001eae:	f426                	sd	s1,40(sp)
    80001eb0:	f04a                	sd	s2,32(sp)
    80001eb2:	ec4e                	sd	s3,24(sp)
    80001eb4:	e852                	sd	s4,16(sp)
    80001eb6:	e456                	sd	s5,8(sp)
    80001eb8:	0080                	addi	s0,sp,64
    80001eba:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001ebc:	0000a497          	auipc	s1,0xa
    80001ec0:	66448493          	addi	s1,s1,1636 # 8000c520 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001ec4:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001ec6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ec8:	00010917          	auipc	s2,0x10
    80001ecc:	45890913          	addi	s2,s2,1112 # 80012320 <tickslock>
    80001ed0:	a801                	j	80001ee0 <wakeup+0x38>
      }
      release(&p->lock);
    80001ed2:	8526                	mv	a0,s1
    80001ed4:	0ef040ef          	jal	800067c2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ed8:	17848493          	addi	s1,s1,376
    80001edc:	03248263          	beq	s1,s2,80001f00 <wakeup+0x58>
    if(p != myproc()){
    80001ee0:	8d9ff0ef          	jal	800017b8 <myproc>
    80001ee4:	fea48ae3          	beq	s1,a0,80001ed8 <wakeup+0x30>
      acquire(&p->lock);
    80001ee8:	8526                	mv	a0,s1
    80001eea:	00d040ef          	jal	800066f6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001eee:	509c                	lw	a5,32(s1)
    80001ef0:	ff3791e3          	bne	a5,s3,80001ed2 <wakeup+0x2a>
    80001ef4:	749c                	ld	a5,40(s1)
    80001ef6:	fd479ee3          	bne	a5,s4,80001ed2 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001efa:	0354a023          	sw	s5,32(s1)
    80001efe:	bfd1                	j	80001ed2 <wakeup+0x2a>
    }
  }
}
    80001f00:	70e2                	ld	ra,56(sp)
    80001f02:	7442                	ld	s0,48(sp)
    80001f04:	74a2                	ld	s1,40(sp)
    80001f06:	7902                	ld	s2,32(sp)
    80001f08:	69e2                	ld	s3,24(sp)
    80001f0a:	6a42                	ld	s4,16(sp)
    80001f0c:	6aa2                	ld	s5,8(sp)
    80001f0e:	6121                	addi	sp,sp,64
    80001f10:	8082                	ret

0000000080001f12 <reparent>:
{
    80001f12:	7179                	addi	sp,sp,-48
    80001f14:	f406                	sd	ra,40(sp)
    80001f16:	f022                	sd	s0,32(sp)
    80001f18:	ec26                	sd	s1,24(sp)
    80001f1a:	e84a                	sd	s2,16(sp)
    80001f1c:	e44e                	sd	s3,8(sp)
    80001f1e:	e052                	sd	s4,0(sp)
    80001f20:	1800                	addi	s0,sp,48
    80001f22:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f24:	0000a497          	auipc	s1,0xa
    80001f28:	5fc48493          	addi	s1,s1,1532 # 8000c520 <proc>
      pp->parent = initproc;
    80001f2c:	0000aa17          	auipc	s4,0xa
    80001f30:	faca0a13          	addi	s4,s4,-84 # 8000bed8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f34:	00010997          	auipc	s3,0x10
    80001f38:	3ec98993          	addi	s3,s3,1004 # 80012320 <tickslock>
    80001f3c:	a029                	j	80001f46 <reparent+0x34>
    80001f3e:	17848493          	addi	s1,s1,376
    80001f42:	01348b63          	beq	s1,s3,80001f58 <reparent+0x46>
    if(pp->parent == p){
    80001f46:	60bc                	ld	a5,64(s1)
    80001f48:	ff279be3          	bne	a5,s2,80001f3e <reparent+0x2c>
      pp->parent = initproc;
    80001f4c:	000a3503          	ld	a0,0(s4)
    80001f50:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    80001f52:	f57ff0ef          	jal	80001ea8 <wakeup>
    80001f56:	b7e5                	j	80001f3e <reparent+0x2c>
}
    80001f58:	70a2                	ld	ra,40(sp)
    80001f5a:	7402                	ld	s0,32(sp)
    80001f5c:	64e2                	ld	s1,24(sp)
    80001f5e:	6942                	ld	s2,16(sp)
    80001f60:	69a2                	ld	s3,8(sp)
    80001f62:	6a02                	ld	s4,0(sp)
    80001f64:	6145                	addi	sp,sp,48
    80001f66:	8082                	ret

0000000080001f68 <exit>:
{
    80001f68:	7179                	addi	sp,sp,-48
    80001f6a:	f406                	sd	ra,40(sp)
    80001f6c:	f022                	sd	s0,32(sp)
    80001f6e:	ec26                	sd	s1,24(sp)
    80001f70:	e84a                	sd	s2,16(sp)
    80001f72:	e44e                	sd	s3,8(sp)
    80001f74:	e052                	sd	s4,0(sp)
    80001f76:	1800                	addi	s0,sp,48
    80001f78:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001f7a:	83fff0ef          	jal	800017b8 <myproc>
    80001f7e:	89aa                	mv	s3,a0
  if(p == initproc)
    80001f80:	0000a797          	auipc	a5,0xa
    80001f84:	f587b783          	ld	a5,-168(a5) # 8000bed8 <initproc>
    80001f88:	0d850493          	addi	s1,a0,216
    80001f8c:	15850913          	addi	s2,a0,344
    80001f90:	00a79f63          	bne	a5,a0,80001fae <exit+0x46>
    panic("init exiting");
    80001f94:	00006517          	auipc	a0,0x6
    80001f98:	66450513          	addi	a0,a0,1636 # 800085f8 <etext+0x5f8>
    80001f9c:	406040ef          	jal	800063a2 <panic>
      fileclose(f);
    80001fa0:	314020ef          	jal	800042b4 <fileclose>
      p->ofile[fd] = 0;
    80001fa4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001fa8:	04a1                	addi	s1,s1,8
    80001faa:	01248563          	beq	s1,s2,80001fb4 <exit+0x4c>
    if(p->ofile[fd]){
    80001fae:	6088                	ld	a0,0(s1)
    80001fb0:	f965                	bnez	a0,80001fa0 <exit+0x38>
    80001fb2:	bfdd                	j	80001fa8 <exit+0x40>
  begin_op();
    80001fb4:	6e7010ef          	jal	80003e9a <begin_op>
  iput(p->cwd);
    80001fb8:	1589b503          	ld	a0,344(s3)
    80001fbc:	7ca010ef          	jal	80003786 <iput>
  end_op();
    80001fc0:	745010ef          	jal	80003f04 <end_op>
  p->cwd = 0;
    80001fc4:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001fc8:	0000a497          	auipc	s1,0xa
    80001fcc:	13848493          	addi	s1,s1,312 # 8000c100 <wait_lock>
    80001fd0:	8526                	mv	a0,s1
    80001fd2:	724040ef          	jal	800066f6 <acquire>
  reparent(p);
    80001fd6:	854e                	mv	a0,s3
    80001fd8:	f3bff0ef          	jal	80001f12 <reparent>
  wakeup(p->parent);
    80001fdc:	0409b503          	ld	a0,64(s3)
    80001fe0:	ec9ff0ef          	jal	80001ea8 <wakeup>
  acquire(&p->lock);
    80001fe4:	854e                	mv	a0,s3
    80001fe6:	710040ef          	jal	800066f6 <acquire>
  p->xstate = status;
    80001fea:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80001fee:	4795                	li	a5,5
    80001ff0:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    80001ff4:	8526                	mv	a0,s1
    80001ff6:	7cc040ef          	jal	800067c2 <release>
  sched();
    80001ffa:	d7dff0ef          	jal	80001d76 <sched>
  panic("zombie exit");
    80001ffe:	00006517          	auipc	a0,0x6
    80002002:	60a50513          	addi	a0,a0,1546 # 80008608 <etext+0x608>
    80002006:	39c040ef          	jal	800063a2 <panic>

000000008000200a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000200a:	7179                	addi	sp,sp,-48
    8000200c:	f406                	sd	ra,40(sp)
    8000200e:	f022                	sd	s0,32(sp)
    80002010:	ec26                	sd	s1,24(sp)
    80002012:	e84a                	sd	s2,16(sp)
    80002014:	e44e                	sd	s3,8(sp)
    80002016:	1800                	addi	s0,sp,48
    80002018:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000201a:	0000a497          	auipc	s1,0xa
    8000201e:	50648493          	addi	s1,s1,1286 # 8000c520 <proc>
    80002022:	00010997          	auipc	s3,0x10
    80002026:	2fe98993          	addi	s3,s3,766 # 80012320 <tickslock>
    acquire(&p->lock);
    8000202a:	8526                	mv	a0,s1
    8000202c:	6ca040ef          	jal	800066f6 <acquire>
    if(p->pid == pid){
    80002030:	5c9c                	lw	a5,56(s1)
    80002032:	01278b63          	beq	a5,s2,80002048 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002036:	8526                	mv	a0,s1
    80002038:	78a040ef          	jal	800067c2 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000203c:	17848493          	addi	s1,s1,376
    80002040:	ff3495e3          	bne	s1,s3,8000202a <kill+0x20>
  }
  return -1;
    80002044:	557d                	li	a0,-1
    80002046:	a819                	j	8000205c <kill+0x52>
      p->killed = 1;
    80002048:	4785                	li	a5,1
    8000204a:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    8000204c:	5098                	lw	a4,32(s1)
    8000204e:	4789                	li	a5,2
    80002050:	00f70d63          	beq	a4,a5,8000206a <kill+0x60>
      release(&p->lock);
    80002054:	8526                	mv	a0,s1
    80002056:	76c040ef          	jal	800067c2 <release>
      return 0;
    8000205a:	4501                	li	a0,0
}
    8000205c:	70a2                	ld	ra,40(sp)
    8000205e:	7402                	ld	s0,32(sp)
    80002060:	64e2                	ld	s1,24(sp)
    80002062:	6942                	ld	s2,16(sp)
    80002064:	69a2                	ld	s3,8(sp)
    80002066:	6145                	addi	sp,sp,48
    80002068:	8082                	ret
        p->state = RUNNABLE;
    8000206a:	478d                	li	a5,3
    8000206c:	d09c                	sw	a5,32(s1)
    8000206e:	b7dd                	j	80002054 <kill+0x4a>

0000000080002070 <setkilled>:

void
setkilled(struct proc *p)
{
    80002070:	1101                	addi	sp,sp,-32
    80002072:	ec06                	sd	ra,24(sp)
    80002074:	e822                	sd	s0,16(sp)
    80002076:	e426                	sd	s1,8(sp)
    80002078:	1000                	addi	s0,sp,32
    8000207a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000207c:	67a040ef          	jal	800066f6 <acquire>
  p->killed = 1;
    80002080:	4785                	li	a5,1
    80002082:	d89c                	sw	a5,48(s1)
  release(&p->lock);
    80002084:	8526                	mv	a0,s1
    80002086:	73c040ef          	jal	800067c2 <release>
}
    8000208a:	60e2                	ld	ra,24(sp)
    8000208c:	6442                	ld	s0,16(sp)
    8000208e:	64a2                	ld	s1,8(sp)
    80002090:	6105                	addi	sp,sp,32
    80002092:	8082                	ret

0000000080002094 <killed>:

int
killed(struct proc *p)
{
    80002094:	1101                	addi	sp,sp,-32
    80002096:	ec06                	sd	ra,24(sp)
    80002098:	e822                	sd	s0,16(sp)
    8000209a:	e426                	sd	s1,8(sp)
    8000209c:	e04a                	sd	s2,0(sp)
    8000209e:	1000                	addi	s0,sp,32
    800020a0:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800020a2:	654040ef          	jal	800066f6 <acquire>
  k = p->killed;
    800020a6:	0304a903          	lw	s2,48(s1)
  release(&p->lock);
    800020aa:	8526                	mv	a0,s1
    800020ac:	716040ef          	jal	800067c2 <release>
  return k;
}
    800020b0:	854a                	mv	a0,s2
    800020b2:	60e2                	ld	ra,24(sp)
    800020b4:	6442                	ld	s0,16(sp)
    800020b6:	64a2                	ld	s1,8(sp)
    800020b8:	6902                	ld	s2,0(sp)
    800020ba:	6105                	addi	sp,sp,32
    800020bc:	8082                	ret

00000000800020be <wait>:
{
    800020be:	715d                	addi	sp,sp,-80
    800020c0:	e486                	sd	ra,72(sp)
    800020c2:	e0a2                	sd	s0,64(sp)
    800020c4:	fc26                	sd	s1,56(sp)
    800020c6:	f84a                	sd	s2,48(sp)
    800020c8:	f44e                	sd	s3,40(sp)
    800020ca:	f052                	sd	s4,32(sp)
    800020cc:	ec56                	sd	s5,24(sp)
    800020ce:	e85a                	sd	s6,16(sp)
    800020d0:	e45e                	sd	s7,8(sp)
    800020d2:	e062                	sd	s8,0(sp)
    800020d4:	0880                	addi	s0,sp,80
    800020d6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800020d8:	ee0ff0ef          	jal	800017b8 <myproc>
    800020dc:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800020de:	0000a517          	auipc	a0,0xa
    800020e2:	02250513          	addi	a0,a0,34 # 8000c100 <wait_lock>
    800020e6:	610040ef          	jal	800066f6 <acquire>
    havekids = 0;
    800020ea:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800020ec:	4a15                	li	s4,5
        havekids = 1;
    800020ee:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800020f0:	00010997          	auipc	s3,0x10
    800020f4:	23098993          	addi	s3,s3,560 # 80012320 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800020f8:	0000ac17          	auipc	s8,0xa
    800020fc:	008c0c13          	addi	s8,s8,8 # 8000c100 <wait_lock>
    80002100:	a871                	j	8000219c <wait+0xde>
          pid = pp->pid;
    80002102:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002106:	000b0c63          	beqz	s6,8000211e <wait+0x60>
    8000210a:	4691                	li	a3,4
    8000210c:	03448613          	addi	a2,s1,52
    80002110:	85da                	mv	a1,s6
    80002112:	05893503          	ld	a0,88(s2)
    80002116:	f87fe0ef          	jal	8000109c <copyout>
    8000211a:	02054b63          	bltz	a0,80002150 <wait+0x92>
          freeproc(pp);
    8000211e:	8526                	mv	a0,s1
    80002120:	80bff0ef          	jal	8000192a <freeproc>
          release(&pp->lock);
    80002124:	8526                	mv	a0,s1
    80002126:	69c040ef          	jal	800067c2 <release>
          release(&wait_lock);
    8000212a:	0000a517          	auipc	a0,0xa
    8000212e:	fd650513          	addi	a0,a0,-42 # 8000c100 <wait_lock>
    80002132:	690040ef          	jal	800067c2 <release>
}
    80002136:	854e                	mv	a0,s3
    80002138:	60a6                	ld	ra,72(sp)
    8000213a:	6406                	ld	s0,64(sp)
    8000213c:	74e2                	ld	s1,56(sp)
    8000213e:	7942                	ld	s2,48(sp)
    80002140:	79a2                	ld	s3,40(sp)
    80002142:	7a02                	ld	s4,32(sp)
    80002144:	6ae2                	ld	s5,24(sp)
    80002146:	6b42                	ld	s6,16(sp)
    80002148:	6ba2                	ld	s7,8(sp)
    8000214a:	6c02                	ld	s8,0(sp)
    8000214c:	6161                	addi	sp,sp,80
    8000214e:	8082                	ret
            release(&pp->lock);
    80002150:	8526                	mv	a0,s1
    80002152:	670040ef          	jal	800067c2 <release>
            release(&wait_lock);
    80002156:	0000a517          	auipc	a0,0xa
    8000215a:	faa50513          	addi	a0,a0,-86 # 8000c100 <wait_lock>
    8000215e:	664040ef          	jal	800067c2 <release>
            return -1;
    80002162:	59fd                	li	s3,-1
    80002164:	bfc9                	j	80002136 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002166:	17848493          	addi	s1,s1,376
    8000216a:	03348063          	beq	s1,s3,8000218a <wait+0xcc>
      if(pp->parent == p){
    8000216e:	60bc                	ld	a5,64(s1)
    80002170:	ff279be3          	bne	a5,s2,80002166 <wait+0xa8>
        acquire(&pp->lock);
    80002174:	8526                	mv	a0,s1
    80002176:	580040ef          	jal	800066f6 <acquire>
        if(pp->state == ZOMBIE){
    8000217a:	509c                	lw	a5,32(s1)
    8000217c:	f94783e3          	beq	a5,s4,80002102 <wait+0x44>
        release(&pp->lock);
    80002180:	8526                	mv	a0,s1
    80002182:	640040ef          	jal	800067c2 <release>
        havekids = 1;
    80002186:	8756                	mv	a4,s5
    80002188:	bff9                	j	80002166 <wait+0xa8>
    if(!havekids || killed(p)){
    8000218a:	cf19                	beqz	a4,800021a8 <wait+0xea>
    8000218c:	854a                	mv	a0,s2
    8000218e:	f07ff0ef          	jal	80002094 <killed>
    80002192:	e919                	bnez	a0,800021a8 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002194:	85e2                	mv	a1,s8
    80002196:	854a                	mv	a0,s2
    80002198:	cc5ff0ef          	jal	80001e5c <sleep>
    havekids = 0;
    8000219c:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000219e:	0000a497          	auipc	s1,0xa
    800021a2:	38248493          	addi	s1,s1,898 # 8000c520 <proc>
    800021a6:	b7e1                	j	8000216e <wait+0xb0>
      release(&wait_lock);
    800021a8:	0000a517          	auipc	a0,0xa
    800021ac:	f5850513          	addi	a0,a0,-168 # 8000c100 <wait_lock>
    800021b0:	612040ef          	jal	800067c2 <release>
      return -1;
    800021b4:	59fd                	li	s3,-1
    800021b6:	b741                	j	80002136 <wait+0x78>

00000000800021b8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800021b8:	7179                	addi	sp,sp,-48
    800021ba:	f406                	sd	ra,40(sp)
    800021bc:	f022                	sd	s0,32(sp)
    800021be:	ec26                	sd	s1,24(sp)
    800021c0:	e84a                	sd	s2,16(sp)
    800021c2:	e44e                	sd	s3,8(sp)
    800021c4:	e052                	sd	s4,0(sp)
    800021c6:	1800                	addi	s0,sp,48
    800021c8:	84aa                	mv	s1,a0
    800021ca:	892e                	mv	s2,a1
    800021cc:	89b2                	mv	s3,a2
    800021ce:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800021d0:	de8ff0ef          	jal	800017b8 <myproc>
  if(user_dst){
    800021d4:	cc99                	beqz	s1,800021f2 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800021d6:	86d2                	mv	a3,s4
    800021d8:	864e                	mv	a2,s3
    800021da:	85ca                	mv	a1,s2
    800021dc:	6d28                	ld	a0,88(a0)
    800021de:	ebffe0ef          	jal	8000109c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800021e2:	70a2                	ld	ra,40(sp)
    800021e4:	7402                	ld	s0,32(sp)
    800021e6:	64e2                	ld	s1,24(sp)
    800021e8:	6942                	ld	s2,16(sp)
    800021ea:	69a2                	ld	s3,8(sp)
    800021ec:	6a02                	ld	s4,0(sp)
    800021ee:	6145                	addi	sp,sp,48
    800021f0:	8082                	ret
    memmove((char *)dst, src, len);
    800021f2:	000a061b          	sext.w	a2,s4
    800021f6:	85ce                	mv	a1,s3
    800021f8:	854a                	mv	a0,s2
    800021fa:	b10fe0ef          	jal	8000050a <memmove>
    return 0;
    800021fe:	8526                	mv	a0,s1
    80002200:	b7cd                	j	800021e2 <either_copyout+0x2a>

0000000080002202 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002202:	7179                	addi	sp,sp,-48
    80002204:	f406                	sd	ra,40(sp)
    80002206:	f022                	sd	s0,32(sp)
    80002208:	ec26                	sd	s1,24(sp)
    8000220a:	e84a                	sd	s2,16(sp)
    8000220c:	e44e                	sd	s3,8(sp)
    8000220e:	e052                	sd	s4,0(sp)
    80002210:	1800                	addi	s0,sp,48
    80002212:	892a                	mv	s2,a0
    80002214:	84ae                	mv	s1,a1
    80002216:	89b2                	mv	s3,a2
    80002218:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000221a:	d9eff0ef          	jal	800017b8 <myproc>
  if(user_src){
    8000221e:	cc99                	beqz	s1,8000223c <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002220:	86d2                	mv	a3,s4
    80002222:	864e                	mv	a2,s3
    80002224:	85ca                	mv	a1,s2
    80002226:	6d28                	ld	a0,88(a0)
    80002228:	fd3fe0ef          	jal	800011fa <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000222c:	70a2                	ld	ra,40(sp)
    8000222e:	7402                	ld	s0,32(sp)
    80002230:	64e2                	ld	s1,24(sp)
    80002232:	6942                	ld	s2,16(sp)
    80002234:	69a2                	ld	s3,8(sp)
    80002236:	6a02                	ld	s4,0(sp)
    80002238:	6145                	addi	sp,sp,48
    8000223a:	8082                	ret
    memmove(dst, (char*)src, len);
    8000223c:	000a061b          	sext.w	a2,s4
    80002240:	85ce                	mv	a1,s3
    80002242:	854a                	mv	a0,s2
    80002244:	ac6fe0ef          	jal	8000050a <memmove>
    return 0;
    80002248:	8526                	mv	a0,s1
    8000224a:	b7cd                	j	8000222c <either_copyin+0x2a>

000000008000224c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000224c:	711d                	addi	sp,sp,-96
    8000224e:	ec86                	sd	ra,88(sp)
    80002250:	e8a2                	sd	s0,80(sp)
    80002252:	e4a6                	sd	s1,72(sp)
    80002254:	e0ca                	sd	s2,64(sp)
    80002256:	fc4e                	sd	s3,56(sp)
    80002258:	f852                	sd	s4,48(sp)
    8000225a:	f456                	sd	s5,40(sp)
    8000225c:	f05a                	sd	s6,32(sp)
    8000225e:	ec5e                	sd	s7,24(sp)
    80002260:	e862                	sd	s8,16(sp)
    80002262:	e466                	sd	s9,8(sp)
    80002264:	e06a                	sd	s10,0(sp)
    80002266:	1080                	addi	s0,sp,96
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002268:	00006517          	auipc	a0,0x6
    8000226c:	ff050513          	addi	a0,a0,-16 # 80008258 <etext+0x258>
    80002270:	661030ef          	jal	800060d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002274:	0000a917          	auipc	s2,0xa
    80002278:	40c90913          	addi	s2,s2,1036 # 8000c680 <proc+0x160>
    8000227c:	00010997          	auipc	s3,0x10
    80002280:	20498993          	addi	s3,s3,516 # 80012480 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002284:	4c95                	li	s9,5
      state = states[p->state];
    else
      state = "???";
    80002286:	00006a17          	auipc	s4,0x6
    8000228a:	392a0a13          	addi	s4,s4,914 # 80008618 <etext+0x618>
    printf("%d %s %s", p->pid, state, p->name);
    8000228e:	00006c17          	auipc	s8,0x6
    80002292:	392c0c13          	addi	s8,s8,914 # 80008620 <etext+0x620>
    printf("\t sz=%ld kstack=%ld k_ra=%ld k_sp=%ld u_epc=%ld",
    80002296:	4b81                	li	s7,0
    80002298:	00006b17          	auipc	s6,0x6
    8000229c:	398b0b13          	addi	s6,s6,920 # 80008630 <etext+0x630>
      p->sz, p->kstack, p->context.ra, p->context.sp,
      p->trapframe ? p->trapframe->epc : 0);
    printf("\n");
    800022a0:	00006a97          	auipc	s5,0x6
    800022a4:	fb8a8a93          	addi	s5,s5,-72 # 80008258 <etext+0x258>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800022a8:	00007d17          	auipc	s10,0x7
    800022ac:	a50d0d13          	addi	s10,s10,-1456 # 80008cf8 <states.0>
    800022b0:	a835                	j	800022ec <procdump+0xa0>
    printf("%d %s %s", p->pid, state, p->name);
    800022b2:	86a6                	mv	a3,s1
    800022b4:	ed84a583          	lw	a1,-296(s1)
    800022b8:	8562                	mv	a0,s8
    800022ba:	617030ef          	jal	800060d0 <printf>
    printf("\t sz=%ld kstack=%ld k_ra=%ld k_sp=%ld u_epc=%ld",
    800022be:	ef04b583          	ld	a1,-272(s1)
    800022c2:	ee84b603          	ld	a2,-280(s1)
    800022c6:	f084b683          	ld	a3,-248(s1)
    800022ca:	f104b703          	ld	a4,-240(s1)
      p->trapframe ? p->trapframe->epc : 0);
    800022ce:	f004b503          	ld	a0,-256(s1)
    printf("\t sz=%ld kstack=%ld k_ra=%ld k_sp=%ld u_epc=%ld",
    800022d2:	87de                	mv	a5,s7
    800022d4:	c111                	beqz	a0,800022d8 <procdump+0x8c>
    800022d6:	6d1c                	ld	a5,24(a0)
    800022d8:	855a                	mv	a0,s6
    800022da:	5f7030ef          	jal	800060d0 <printf>
    printf("\n");
    800022de:	8556                	mv	a0,s5
    800022e0:	5f1030ef          	jal	800060d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800022e4:	17890913          	addi	s2,s2,376
    800022e8:	03390263          	beq	s2,s3,8000230c <procdump+0xc0>
    if(p->state == UNUSED)
    800022ec:	84ca                	mv	s1,s2
    800022ee:	ec092783          	lw	a5,-320(s2)
    800022f2:	dbed                	beqz	a5,800022e4 <procdump+0x98>
      state = "???";
    800022f4:	8652                	mv	a2,s4
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800022f6:	fafceee3          	bltu	s9,a5,800022b2 <procdump+0x66>
    800022fa:	02079713          	slli	a4,a5,0x20
    800022fe:	01d75793          	srli	a5,a4,0x1d
    80002302:	97ea                	add	a5,a5,s10
    80002304:	6390                	ld	a2,0(a5)
    80002306:	f655                	bnez	a2,800022b2 <procdump+0x66>
      state = "???";
    80002308:	8652                	mv	a2,s4
    8000230a:	b765                	j	800022b2 <procdump+0x66>
  }
}
    8000230c:	60e6                	ld	ra,88(sp)
    8000230e:	6446                	ld	s0,80(sp)
    80002310:	64a6                	ld	s1,72(sp)
    80002312:	6906                	ld	s2,64(sp)
    80002314:	79e2                	ld	s3,56(sp)
    80002316:	7a42                	ld	s4,48(sp)
    80002318:	7aa2                	ld	s5,40(sp)
    8000231a:	7b02                	ld	s6,32(sp)
    8000231c:	6be2                	ld	s7,24(sp)
    8000231e:	6c42                	ld	s8,16(sp)
    80002320:	6ca2                	ld	s9,8(sp)
    80002322:	6d02                	ld	s10,0(sp)
    80002324:	6125                	addi	sp,sp,96
    80002326:	8082                	ret

0000000080002328 <swtch>:
    80002328:	00153023          	sd	ra,0(a0)
    8000232c:	00253423          	sd	sp,8(a0)
    80002330:	e900                	sd	s0,16(a0)
    80002332:	ed04                	sd	s1,24(a0)
    80002334:	03253023          	sd	s2,32(a0)
    80002338:	03353423          	sd	s3,40(a0)
    8000233c:	03453823          	sd	s4,48(a0)
    80002340:	03553c23          	sd	s5,56(a0)
    80002344:	05653023          	sd	s6,64(a0)
    80002348:	05753423          	sd	s7,72(a0)
    8000234c:	05853823          	sd	s8,80(a0)
    80002350:	05953c23          	sd	s9,88(a0)
    80002354:	07a53023          	sd	s10,96(a0)
    80002358:	07b53423          	sd	s11,104(a0)
    8000235c:	0005b083          	ld	ra,0(a1)
    80002360:	0085b103          	ld	sp,8(a1)
    80002364:	6980                	ld	s0,16(a1)
    80002366:	6d84                	ld	s1,24(a1)
    80002368:	0205b903          	ld	s2,32(a1)
    8000236c:	0285b983          	ld	s3,40(a1)
    80002370:	0305ba03          	ld	s4,48(a1)
    80002374:	0385ba83          	ld	s5,56(a1)
    80002378:	0405bb03          	ld	s6,64(a1)
    8000237c:	0485bb83          	ld	s7,72(a1)
    80002380:	0505bc03          	ld	s8,80(a1)
    80002384:	0585bc83          	ld	s9,88(a1)
    80002388:	0605bd03          	ld	s10,96(a1)
    8000238c:	0685bd83          	ld	s11,104(a1)
    80002390:	8082                	ret

0000000080002392 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002392:	1141                	addi	sp,sp,-16
    80002394:	e406                	sd	ra,8(sp)
    80002396:	e022                	sd	s0,0(sp)
    80002398:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000239a:	00006597          	auipc	a1,0x6
    8000239e:	2f658593          	addi	a1,a1,758 # 80008690 <etext+0x690>
    800023a2:	00010517          	auipc	a0,0x10
    800023a6:	f7e50513          	addi	a0,a0,-130 # 80012320 <tickslock>
    800023aa:	454040ef          	jal	800067fe <initlock>
}
    800023ae:	60a2                	ld	ra,8(sp)
    800023b0:	6402                	ld	s0,0(sp)
    800023b2:	0141                	addi	sp,sp,16
    800023b4:	8082                	ret

00000000800023b6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800023b6:	1141                	addi	sp,sp,-16
    800023b8:	e422                	sd	s0,8(sp)
    800023ba:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800023bc:	00003797          	auipc	a5,0x3
    800023c0:	25478793          	addi	a5,a5,596 # 80005610 <kernelvec>
    800023c4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800023c8:	6422                	ld	s0,8(sp)
    800023ca:	0141                	addi	sp,sp,16
    800023cc:	8082                	ret

00000000800023ce <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800023ce:	1141                	addi	sp,sp,-16
    800023d0:	e406                	sd	ra,8(sp)
    800023d2:	e022                	sd	s0,0(sp)
    800023d4:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800023d6:	be2ff0ef          	jal	800017b8 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800023da:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800023de:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800023e0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800023e4:	00005697          	auipc	a3,0x5
    800023e8:	c1c68693          	addi	a3,a3,-996 # 80007000 <_trampoline>
    800023ec:	00005717          	auipc	a4,0x5
    800023f0:	c1470713          	addi	a4,a4,-1004 # 80007000 <_trampoline>
    800023f4:	8f15                	sub	a4,a4,a3
    800023f6:	040007b7          	lui	a5,0x4000
    800023fa:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800023fc:	07b2                	slli	a5,a5,0xc
    800023fe:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002400:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002404:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002406:	18002673          	csrr	a2,satp
    8000240a:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000240c:	7130                	ld	a2,96(a0)
    8000240e:	6538                	ld	a4,72(a0)
    80002410:	6585                	lui	a1,0x1
    80002412:	972e                	add	a4,a4,a1
    80002414:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002416:	7138                	ld	a4,96(a0)
    80002418:	00000617          	auipc	a2,0x0
    8000241c:	11060613          	addi	a2,a2,272 # 80002528 <usertrap>
    80002420:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002422:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002424:	8612                	mv	a2,tp
    80002426:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002428:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000242c:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002430:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002434:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002438:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000243a:	6f18                	ld	a4,24(a4)
    8000243c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002440:	6d28                	ld	a0,88(a0)
    80002442:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002444:	00005717          	auipc	a4,0x5
    80002448:	c5870713          	addi	a4,a4,-936 # 8000709c <userret>
    8000244c:	8f15                	sub	a4,a4,a3
    8000244e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002450:	577d                	li	a4,-1
    80002452:	177e                	slli	a4,a4,0x3f
    80002454:	8d59                	or	a0,a0,a4
    80002456:	9782                	jalr	a5
}
    80002458:	60a2                	ld	ra,8(sp)
    8000245a:	6402                	ld	s0,0(sp)
    8000245c:	0141                	addi	sp,sp,16
    8000245e:	8082                	ret

0000000080002460 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002460:	1101                	addi	sp,sp,-32
    80002462:	ec06                	sd	ra,24(sp)
    80002464:	e822                	sd	s0,16(sp)
    80002466:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80002468:	b24ff0ef          	jal	8000178c <cpuid>
    8000246c:	cd11                	beqz	a0,80002488 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000246e:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002472:	000f4737          	lui	a4,0xf4
    80002476:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000247a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000247c:	14d79073          	csrw	stimecmp,a5
}
    80002480:	60e2                	ld	ra,24(sp)
    80002482:	6442                	ld	s0,16(sp)
    80002484:	6105                	addi	sp,sp,32
    80002486:	8082                	ret
    80002488:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    8000248a:	00010497          	auipc	s1,0x10
    8000248e:	e9648493          	addi	s1,s1,-362 # 80012320 <tickslock>
    80002492:	8526                	mv	a0,s1
    80002494:	262040ef          	jal	800066f6 <acquire>
    ticks++;
    80002498:	0000a517          	auipc	a0,0xa
    8000249c:	a4850513          	addi	a0,a0,-1464 # 8000bee0 <ticks>
    800024a0:	411c                	lw	a5,0(a0)
    800024a2:	2785                	addiw	a5,a5,1
    800024a4:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800024a6:	a03ff0ef          	jal	80001ea8 <wakeup>
    release(&tickslock);
    800024aa:	8526                	mv	a0,s1
    800024ac:	316040ef          	jal	800067c2 <release>
    800024b0:	64a2                	ld	s1,8(sp)
    800024b2:	bf75                	j	8000246e <clockintr+0xe>

00000000800024b4 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800024b4:	1101                	addi	sp,sp,-32
    800024b6:	ec06                	sd	ra,24(sp)
    800024b8:	e822                	sd	s0,16(sp)
    800024ba:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800024bc:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800024c0:	57fd                	li	a5,-1
    800024c2:	17fe                	slli	a5,a5,0x3f
    800024c4:	07a5                	addi	a5,a5,9
    800024c6:	00f70c63          	beq	a4,a5,800024de <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800024ca:	57fd                	li	a5,-1
    800024cc:	17fe                	slli	a5,a5,0x3f
    800024ce:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800024d0:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800024d2:	04f70763          	beq	a4,a5,80002520 <devintr+0x6c>
  }
}
    800024d6:	60e2                	ld	ra,24(sp)
    800024d8:	6442                	ld	s0,16(sp)
    800024da:	6105                	addi	sp,sp,32
    800024dc:	8082                	ret
    800024de:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800024e0:	1dc030ef          	jal	800056bc <plic_claim>
    800024e4:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800024e6:	47a9                	li	a5,10
    800024e8:	00f50963          	beq	a0,a5,800024fa <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800024ec:	4785                	li	a5,1
    800024ee:	00f50963          	beq	a0,a5,80002500 <devintr+0x4c>
    return 1;
    800024f2:	4505                	li	a0,1
    } else if(irq){
    800024f4:	e889                	bnez	s1,80002506 <devintr+0x52>
    800024f6:	64a2                	ld	s1,8(sp)
    800024f8:	bff9                	j	800024d6 <devintr+0x22>
      uartintr();
    800024fa:	11a040ef          	jal	80006614 <uartintr>
    if(irq)
    800024fe:	a819                	j	80002514 <devintr+0x60>
      virtio_disk_intr();
    80002500:	682030ef          	jal	80005b82 <virtio_disk_intr>
    if(irq)
    80002504:	a801                	j	80002514 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80002506:	85a6                	mv	a1,s1
    80002508:	00006517          	auipc	a0,0x6
    8000250c:	19050513          	addi	a0,a0,400 # 80008698 <etext+0x698>
    80002510:	3c1030ef          	jal	800060d0 <printf>
      plic_complete(irq);
    80002514:	8526                	mv	a0,s1
    80002516:	1c6030ef          	jal	800056dc <plic_complete>
    return 1;
    8000251a:	4505                	li	a0,1
    8000251c:	64a2                	ld	s1,8(sp)
    8000251e:	bf65                	j	800024d6 <devintr+0x22>
    clockintr();
    80002520:	f41ff0ef          	jal	80002460 <clockintr>
    return 2;
    80002524:	4509                	li	a0,2
    80002526:	bf45                	j	800024d6 <devintr+0x22>

0000000080002528 <usertrap>:
{
    80002528:	1101                	addi	sp,sp,-32
    8000252a:	ec06                	sd	ra,24(sp)
    8000252c:	e822                	sd	s0,16(sp)
    8000252e:	e426                	sd	s1,8(sp)
    80002530:	e04a                	sd	s2,0(sp)
    80002532:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002534:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002538:	1007f793          	andi	a5,a5,256
    8000253c:	ef85                	bnez	a5,80002574 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000253e:	00003797          	auipc	a5,0x3
    80002542:	0d278793          	addi	a5,a5,210 # 80005610 <kernelvec>
    80002546:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000254a:	a6eff0ef          	jal	800017b8 <myproc>
    8000254e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002550:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002552:	14102773          	csrr	a4,sepc
    80002556:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002558:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8000255c:	47a1                	li	a5,8
    8000255e:	02f70163          	beq	a4,a5,80002580 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80002562:	f53ff0ef          	jal	800024b4 <devintr>
    80002566:	892a                	mv	s2,a0
    80002568:	c135                	beqz	a0,800025cc <usertrap+0xa4>
  if(killed(p)) // p is myproc()
    8000256a:	8526                	mv	a0,s1
    8000256c:	b29ff0ef          	jal	80002094 <killed>
    80002570:	cd1d                	beqz	a0,800025ae <usertrap+0x86>
    80002572:	a81d                	j	800025a8 <usertrap+0x80>
    panic("usertrap: not from user mode");
    80002574:	00006517          	auipc	a0,0x6
    80002578:	14450513          	addi	a0,a0,324 # 800086b8 <etext+0x6b8>
    8000257c:	627030ef          	jal	800063a2 <panic>
    if(killed(p))
    80002580:	b15ff0ef          	jal	80002094 <killed>
    80002584:	e121                	bnez	a0,800025c4 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80002586:	70b8                	ld	a4,96(s1)
    80002588:	6f1c                	ld	a5,24(a4)
    8000258a:	0791                	addi	a5,a5,4
    8000258c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000258e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002592:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002596:	10079073          	csrw	sstatus,a5
    syscall();
    8000259a:	24c000ef          	jal	800027e6 <syscall>
  if(killed(p)) // p is myproc()
    8000259e:	8526                	mv	a0,s1
    800025a0:	af5ff0ef          	jal	80002094 <killed>
    800025a4:	c901                	beqz	a0,800025b4 <usertrap+0x8c>
    800025a6:	4901                	li	s2,0
  exit(-1);
    800025a8:	557d                	li	a0,-1
    800025aa:	9bfff0ef          	jal	80001f68 <exit>
if(which_dev == 2) { // Timer interrupt
    800025ae:	4789                	li	a5,2
    800025b0:	04f90563          	beq	s2,a5,800025fa <usertrap+0xd2>
usertrapret();
    800025b4:	e1bff0ef          	jal	800023ce <usertrapret>
}
    800025b8:	60e2                	ld	ra,24(sp)
    800025ba:	6442                	ld	s0,16(sp)
    800025bc:	64a2                	ld	s1,8(sp)
    800025be:	6902                	ld	s2,0(sp)
    800025c0:	6105                	addi	sp,sp,32
    800025c2:	8082                	ret
      exit(-1);
    800025c4:	557d                	li	a0,-1
    800025c6:	9a3ff0ef          	jal	80001f68 <exit>
    800025ca:	bf75                	j	80002586 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800025cc:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    800025d0:	5c90                	lw	a2,56(s1)
    800025d2:	00006517          	auipc	a0,0x6
    800025d6:	10650513          	addi	a0,a0,262 # 800086d8 <etext+0x6d8>
    800025da:	2f7030ef          	jal	800060d0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800025de:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800025e2:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800025e6:	00006517          	auipc	a0,0x6
    800025ea:	12250513          	addi	a0,a0,290 # 80008708 <etext+0x708>
    800025ee:	2e3030ef          	jal	800060d0 <printf>
    setkilled(p);
    800025f2:	8526                	mv	a0,s1
    800025f4:	a7dff0ef          	jal	80002070 <setkilled>
    800025f8:	b75d                	j	8000259e <usertrap+0x76>
  yield(); // Always yield on timer interrupt from user
    800025fa:	837ff0ef          	jal	80001e30 <yield>
    800025fe:	bf5d                	j	800025b4 <usertrap+0x8c>

0000000080002600 <kerneltrap>:
{
    80002600:	7179                	addi	sp,sp,-48
    80002602:	f406                	sd	ra,40(sp)
    80002604:	f022                	sd	s0,32(sp)
    80002606:	ec26                	sd	s1,24(sp)
    80002608:	e84a                	sd	s2,16(sp)
    8000260a:	e44e                	sd	s3,8(sp)
    8000260c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000260e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002612:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002616:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    8000261a:	1004f793          	andi	a5,s1,256
    8000261e:	c795                	beqz	a5,8000264a <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002620:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002624:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002626:	eb85                	bnez	a5,80002656 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002628:	e8dff0ef          	jal	800024b4 <devintr>
    8000262c:	c91d                	beqz	a0,80002662 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    8000262e:	4789                	li	a5,2
    80002630:	04f50a63          	beq	a0,a5,80002684 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002634:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002638:	10049073          	csrw	sstatus,s1
}
    8000263c:	70a2                	ld	ra,40(sp)
    8000263e:	7402                	ld	s0,32(sp)
    80002640:	64e2                	ld	s1,24(sp)
    80002642:	6942                	ld	s2,16(sp)
    80002644:	69a2                	ld	s3,8(sp)
    80002646:	6145                	addi	sp,sp,48
    80002648:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000264a:	00006517          	auipc	a0,0x6
    8000264e:	0e650513          	addi	a0,a0,230 # 80008730 <etext+0x730>
    80002652:	551030ef          	jal	800063a2 <panic>
    panic("kerneltrap: interrupts enabled");
    80002656:	00006517          	auipc	a0,0x6
    8000265a:	10250513          	addi	a0,a0,258 # 80008758 <etext+0x758>
    8000265e:	545030ef          	jal	800063a2 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002662:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002666:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    8000266a:	85ce                	mv	a1,s3
    8000266c:	00006517          	auipc	a0,0x6
    80002670:	10c50513          	addi	a0,a0,268 # 80008778 <etext+0x778>
    80002674:	25d030ef          	jal	800060d0 <printf>
    panic("kerneltrap");
    80002678:	00006517          	auipc	a0,0x6
    8000267c:	12850513          	addi	a0,a0,296 # 800087a0 <etext+0x7a0>
    80002680:	523030ef          	jal	800063a2 <panic>
  if(which_dev == 2 && myproc() != 0)
    80002684:	934ff0ef          	jal	800017b8 <myproc>
    80002688:	d555                	beqz	a0,80002634 <kerneltrap+0x34>
    yield();
    8000268a:	fa6ff0ef          	jal	80001e30 <yield>
    8000268e:	b75d                	j	80002634 <kerneltrap+0x34>

0000000080002690 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002690:	1101                	addi	sp,sp,-32
    80002692:	ec06                	sd	ra,24(sp)
    80002694:	e822                	sd	s0,16(sp)
    80002696:	e426                	sd	s1,8(sp)
    80002698:	1000                	addi	s0,sp,32
    8000269a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000269c:	91cff0ef          	jal	800017b8 <myproc>
  switch (n) {
    800026a0:	4795                	li	a5,5
    800026a2:	0497e163          	bltu	a5,s1,800026e4 <argraw+0x54>
    800026a6:	048a                	slli	s1,s1,0x2
    800026a8:	00006717          	auipc	a4,0x6
    800026ac:	68070713          	addi	a4,a4,1664 # 80008d28 <states.0+0x30>
    800026b0:	94ba                	add	s1,s1,a4
    800026b2:	409c                	lw	a5,0(s1)
    800026b4:	97ba                	add	a5,a5,a4
    800026b6:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800026b8:	713c                	ld	a5,96(a0)
    800026ba:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800026bc:	60e2                	ld	ra,24(sp)
    800026be:	6442                	ld	s0,16(sp)
    800026c0:	64a2                	ld	s1,8(sp)
    800026c2:	6105                	addi	sp,sp,32
    800026c4:	8082                	ret
    return p->trapframe->a1;
    800026c6:	713c                	ld	a5,96(a0)
    800026c8:	7fa8                	ld	a0,120(a5)
    800026ca:	bfcd                	j	800026bc <argraw+0x2c>
    return p->trapframe->a2;
    800026cc:	713c                	ld	a5,96(a0)
    800026ce:	63c8                	ld	a0,128(a5)
    800026d0:	b7f5                	j	800026bc <argraw+0x2c>
    return p->trapframe->a3;
    800026d2:	713c                	ld	a5,96(a0)
    800026d4:	67c8                	ld	a0,136(a5)
    800026d6:	b7dd                	j	800026bc <argraw+0x2c>
    return p->trapframe->a4;
    800026d8:	713c                	ld	a5,96(a0)
    800026da:	6bc8                	ld	a0,144(a5)
    800026dc:	b7c5                	j	800026bc <argraw+0x2c>
    return p->trapframe->a5;
    800026de:	713c                	ld	a5,96(a0)
    800026e0:	6fc8                	ld	a0,152(a5)
    800026e2:	bfe9                	j	800026bc <argraw+0x2c>
  panic("argraw");
    800026e4:	00006517          	auipc	a0,0x6
    800026e8:	0cc50513          	addi	a0,a0,204 # 800087b0 <etext+0x7b0>
    800026ec:	4b7030ef          	jal	800063a2 <panic>

00000000800026f0 <fetchaddr>:
{
    800026f0:	1101                	addi	sp,sp,-32
    800026f2:	ec06                	sd	ra,24(sp)
    800026f4:	e822                	sd	s0,16(sp)
    800026f6:	e426                	sd	s1,8(sp)
    800026f8:	e04a                	sd	s2,0(sp)
    800026fa:	1000                	addi	s0,sp,32
    800026fc:	84aa                	mv	s1,a0
    800026fe:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002700:	8b8ff0ef          	jal	800017b8 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002704:	693c                	ld	a5,80(a0)
    80002706:	02f4f663          	bgeu	s1,a5,80002732 <fetchaddr+0x42>
    8000270a:	00848713          	addi	a4,s1,8
    8000270e:	02e7e463          	bltu	a5,a4,80002736 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002712:	46a1                	li	a3,8
    80002714:	8626                	mv	a2,s1
    80002716:	85ca                	mv	a1,s2
    80002718:	6d28                	ld	a0,88(a0)
    8000271a:	ae1fe0ef          	jal	800011fa <copyin>
    8000271e:	00a03533          	snez	a0,a0
    80002722:	40a00533          	neg	a0,a0
}
    80002726:	60e2                	ld	ra,24(sp)
    80002728:	6442                	ld	s0,16(sp)
    8000272a:	64a2                	ld	s1,8(sp)
    8000272c:	6902                	ld	s2,0(sp)
    8000272e:	6105                	addi	sp,sp,32
    80002730:	8082                	ret
    return -1;
    80002732:	557d                	li	a0,-1
    80002734:	bfcd                	j	80002726 <fetchaddr+0x36>
    80002736:	557d                	li	a0,-1
    80002738:	b7fd                	j	80002726 <fetchaddr+0x36>

000000008000273a <fetchstr>:
{
    8000273a:	7179                	addi	sp,sp,-48
    8000273c:	f406                	sd	ra,40(sp)
    8000273e:	f022                	sd	s0,32(sp)
    80002740:	ec26                	sd	s1,24(sp)
    80002742:	e84a                	sd	s2,16(sp)
    80002744:	e44e                	sd	s3,8(sp)
    80002746:	1800                	addi	s0,sp,48
    80002748:	892a                	mv	s2,a0
    8000274a:	84ae                	mv	s1,a1
    8000274c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000274e:	86aff0ef          	jal	800017b8 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002752:	86ce                	mv	a3,s3
    80002754:	864a                	mv	a2,s2
    80002756:	85a6                	mv	a1,s1
    80002758:	6d28                	ld	a0,88(a0)
    8000275a:	bfbfe0ef          	jal	80001354 <copyinstr>
    8000275e:	00054c63          	bltz	a0,80002776 <fetchstr+0x3c>
  return strlen(buf);
    80002762:	8526                	mv	a0,s1
    80002764:	ebbfd0ef          	jal	8000061e <strlen>
}
    80002768:	70a2                	ld	ra,40(sp)
    8000276a:	7402                	ld	s0,32(sp)
    8000276c:	64e2                	ld	s1,24(sp)
    8000276e:	6942                	ld	s2,16(sp)
    80002770:	69a2                	ld	s3,8(sp)
    80002772:	6145                	addi	sp,sp,48
    80002774:	8082                	ret
    return -1;
    80002776:	557d                	li	a0,-1
    80002778:	bfc5                	j	80002768 <fetchstr+0x2e>

000000008000277a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000277a:	1101                	addi	sp,sp,-32
    8000277c:	ec06                	sd	ra,24(sp)
    8000277e:	e822                	sd	s0,16(sp)
    80002780:	e426                	sd	s1,8(sp)
    80002782:	1000                	addi	s0,sp,32
    80002784:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002786:	f0bff0ef          	jal	80002690 <argraw>
    8000278a:	c088                	sw	a0,0(s1)

  return 0; // <--- 添加这行，明确返回 0 表示成功
}
    8000278c:	4501                	li	a0,0
    8000278e:	60e2                	ld	ra,24(sp)
    80002790:	6442                	ld	s0,16(sp)
    80002792:	64a2                	ld	s1,8(sp)
    80002794:	6105                	addi	sp,sp,32
    80002796:	8082                	ret

0000000080002798 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int // <--- 修改返回类型为 int
argaddr(int n, uint64 *ip)
{
    80002798:	1101                	addi	sp,sp,-32
    8000279a:	ec06                	sd	ra,24(sp)
    8000279c:	e822                	sd	s0,16(sp)
    8000279e:	e426                	sd	s1,8(sp)
    800027a0:	1000                	addi	s0,sp,32
    800027a2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800027a4:	eedff0ef          	jal	80002690 <argraw>
    800027a8:	e088                	sd	a0,0(s1)
  // 那么 argaddr 自身可能无法检测到很多错误。
  // 但为了与 if (argaddr(...) < 0) 的模式兼容，它应该返回 0。
  // 如果 argraw 失败会 panic，那么这个返回值其实不太会被检查到失败路径。
  // 但如果 argraw 将来可能返回错误，或者为了接口一致性，返回 int 是好的。
  return 0; // 表示成功获取了原始值
}
    800027aa:	4501                	li	a0,0
    800027ac:	60e2                	ld	ra,24(sp)
    800027ae:	6442                	ld	s0,16(sp)
    800027b0:	64a2                	ld	s1,8(sp)
    800027b2:	6105                	addi	sp,sp,32
    800027b4:	8082                	ret

00000000800027b6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800027b6:	7179                	addi	sp,sp,-48
    800027b8:	f406                	sd	ra,40(sp)
    800027ba:	f022                	sd	s0,32(sp)
    800027bc:	ec26                	sd	s1,24(sp)
    800027be:	e84a                	sd	s2,16(sp)
    800027c0:	1800                	addi	s0,sp,48
    800027c2:	84ae                	mv	s1,a1
    800027c4:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800027c6:	fd840593          	addi	a1,s0,-40
    800027ca:	fcfff0ef          	jal	80002798 <argaddr>
  return fetchstr(addr, buf, max);
    800027ce:	864a                	mv	a2,s2
    800027d0:	85a6                	mv	a1,s1
    800027d2:	fd843503          	ld	a0,-40(s0)
    800027d6:	f65ff0ef          	jal	8000273a <fetchstr>
}
    800027da:	70a2                	ld	ra,40(sp)
    800027dc:	7402                	ld	s0,32(sp)
    800027de:	64e2                	ld	s1,24(sp)
    800027e0:	6942                	ld	s2,16(sp)
    800027e2:	6145                	addi	sp,sp,48
    800027e4:	8082                	ret

00000000800027e6 <syscall>:
  [SYS_trace]   "trace", // <--- 添加 trace 的名称
  };

void
syscall(void)
{
    800027e6:	7179                	addi	sp,sp,-48
    800027e8:	f406                	sd	ra,40(sp)
    800027ea:	f022                	sd	s0,32(sp)
    800027ec:	ec26                	sd	s1,24(sp)
    800027ee:	e84a                	sd	s2,16(sp)
    800027f0:	e44e                	sd	s3,8(sp)
    800027f2:	e052                	sd	s4,0(sp)
    800027f4:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    800027f6:	fc3fe0ef          	jal	800017b8 <myproc>
    800027fa:	84aa                	mv	s1,a0

  //start test
  // printf("NELEM(syscalls) = %lu\n", NELEM(syscalls)); // <--- 将 %d 改为 %lu

  num = p->trapframe->a7;
    800027fc:	06053983          	ld	s3,96(a0)
    80002800:	0a89b783          	ld	a5,168(s3)
    80002804:	00078a1b          	sext.w	s4,a5
  // printf("syscalls[SYS_exec]: %p\n", syscalls[SYS_exec]);
  // printf("syscalls[SYS_write]: %p\n", syscalls[SYS_write]);
  // printf("syscalls[SYS_trace]: %p\n", syscalls[SYS_trace]); // 打印地址用 %p
  // end test

  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002808:	fff7891b          	addiw	s2,a5,-1
    8000280c:	47f5                	li	a5,29
    8000280e:	0527e963          	bltu	a5,s2,80002860 <syscall+0x7a>
    80002812:	003a1713          	slli	a4,s4,0x3
    80002816:	00006797          	auipc	a5,0x6
    8000281a:	52a78793          	addi	a5,a5,1322 # 80008d40 <syscalls>
    8000281e:	97ba                	add	a5,a5,a4
    80002820:	639c                	ld	a5,0(a5)
    80002822:	cf9d                	beqz	a5,80002860 <syscall+0x7a>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002824:	9782                	jalr	a5
    80002826:	06a9b823          	sd	a0,112(s3)

    // ---- 添加追踪逻辑 ----
    // 检查当前进程的 tracemask 中是否设置了对应系统调用号的位
    // (1 << num) 创建一个只有第 num 位为 1 的掩码
    if ((p->tracemask & (1 << num))) {
    8000282a:	1704a783          	lw	a5,368(s1)
    8000282e:	4147d7bb          	sraw	a5,a5,s4
    80002832:	8b85                	andi	a5,a5,1
    80002834:	c3b9                	beqz	a5,8000287a <syscall+0x94>
         // 检查 syscall_names 数组是否有效，避免越界或访问空指针
         if (num > 0 && num < NELEM(syscall_names) && syscall_names[num]) {
    80002836:	47d5                	li	a5,21
    80002838:	0527e163          	bltu	a5,s2,8000287a <syscall+0x94>
    8000283c:	0a0e                	slli	s4,s4,0x3
    8000283e:	00006797          	auipc	a5,0x6
    80002842:	50278793          	addi	a5,a5,1282 # 80008d40 <syscalls>
    80002846:	97d2                	add	a5,a5,s4
    80002848:	7ff0                	ld	a2,248(a5)
    8000284a:	ca05                	beqz	a2,8000287a <syscall+0x94>
              // 在 syscall() 函数的追踪逻辑部分
              printf("%d: syscall %s -> %lu\n", p->pid, syscall_names[num], p->trapframe->a0);
    8000284c:	70bc                	ld	a5,96(s1)
    8000284e:	7bb4                	ld	a3,112(a5)
    80002850:	5c8c                	lw	a1,56(s1)
    80002852:	00006517          	auipc	a0,0x6
    80002856:	f6650513          	addi	a0,a0,-154 # 800087b8 <etext+0x7b8>
    8000285a:	077030ef          	jal	800060d0 <printf>
    8000285e:	a831                	j	8000287a <syscall+0x94>
         }
    // ---- 追踪逻辑结束 ----
  }
  } else {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80002860:	86d2                	mv	a3,s4
    80002862:	16048613          	addi	a2,s1,352
    80002866:	5c8c                	lw	a1,56(s1)
    80002868:	00006517          	auipc	a0,0x6
    8000286c:	f6850513          	addi	a0,a0,-152 # 800087d0 <etext+0x7d0>
    80002870:	061030ef          	jal	800060d0 <printf>
    p->trapframe->a0 = -1;
    80002874:	70bc                	ld	a5,96(s1)
    80002876:	577d                	li	a4,-1
    80002878:	fbb8                	sd	a4,112(a5)
  }
    8000287a:	70a2                	ld	ra,40(sp)
    8000287c:	7402                	ld	s0,32(sp)
    8000287e:	64e2                	ld	s1,24(sp)
    80002880:	6942                	ld	s2,16(sp)
    80002882:	69a2                	ld	s3,8(sp)
    80002884:	6a02                	ld	s4,0(sp)
    80002886:	6145                	addi	sp,sp,48
    80002888:	8082                	ret

000000008000288a <sys_exit>:
#include "proc.h"
#include "syscall.h" // 确保包含 syscall.h 以便使用 SYS_ 定义// ... (其他 sys_ 函数) ...

uint64
sys_exit(void)
{
    8000288a:	1101                	addi	sp,sp,-32
    8000288c:	ec06                	sd	ra,24(sp)
    8000288e:	e822                	sd	s0,16(sp)
    80002890:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002892:	fec40593          	addi	a1,s0,-20
    80002896:	4501                	li	a0,0
    80002898:	ee3ff0ef          	jal	8000277a <argint>
  exit(n);
    8000289c:	fec42503          	lw	a0,-20(s0)
    800028a0:	ec8ff0ef          	jal	80001f68 <exit>
  return 0;  // not reached
}
    800028a4:	4501                	li	a0,0
    800028a6:	60e2                	ld	ra,24(sp)
    800028a8:	6442                	ld	s0,16(sp)
    800028aa:	6105                	addi	sp,sp,32
    800028ac:	8082                	ret

00000000800028ae <sys_getpid>:

uint64
sys_getpid(void)
{
    800028ae:	1141                	addi	sp,sp,-16
    800028b0:	e406                	sd	ra,8(sp)
    800028b2:	e022                	sd	s0,0(sp)
    800028b4:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800028b6:	f03fe0ef          	jal	800017b8 <myproc>
}
    800028ba:	5d08                	lw	a0,56(a0)
    800028bc:	60a2                	ld	ra,8(sp)
    800028be:	6402                	ld	s0,0(sp)
    800028c0:	0141                	addi	sp,sp,16
    800028c2:	8082                	ret

00000000800028c4 <sys_fork>:

uint64
sys_fork(void)
{
    800028c4:	1141                	addi	sp,sp,-16
    800028c6:	e406                	sd	ra,8(sp)
    800028c8:	e022                	sd	s0,0(sp)
    800028ca:	0800                	addi	s0,sp,16
  return fork();
    800028cc:	b00ff0ef          	jal	80001bcc <fork>
}
    800028d0:	60a2                	ld	ra,8(sp)
    800028d2:	6402                	ld	s0,0(sp)
    800028d4:	0141                	addi	sp,sp,16
    800028d6:	8082                	ret

00000000800028d8 <sys_wait>:

uint64
sys_wait(void)
{
    800028d8:	1101                	addi	sp,sp,-32
    800028da:	ec06                	sd	ra,24(sp)
    800028dc:	e822                	sd	s0,16(sp)
    800028de:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800028e0:	fe840593          	addi	a1,s0,-24
    800028e4:	4501                	li	a0,0
    800028e6:	eb3ff0ef          	jal	80002798 <argaddr>
  return wait(p);
    800028ea:	fe843503          	ld	a0,-24(s0)
    800028ee:	fd0ff0ef          	jal	800020be <wait>
}
    800028f2:	60e2                	ld	ra,24(sp)
    800028f4:	6442                	ld	s0,16(sp)
    800028f6:	6105                	addi	sp,sp,32
    800028f8:	8082                	ret

00000000800028fa <sys_sbrk>:
//   return addr;
// }

uint64
sys_sbrk(void)
{
    800028fa:	7179                	addi	sp,sp,-48
    800028fc:	f406                	sd	ra,40(sp)
    800028fe:	f022                	sd	s0,32(sp)
    80002900:	ec26                	sd	s1,24(sp)
    80002902:	e84a                	sd	s2,16(sp)
    80002904:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;
  struct proc *p = myproc();
    80002906:	eb3fe0ef          	jal	800017b8 <myproc>
    8000290a:	84aa                	mv	s1,a0

  if(argint(0, &n) < 0)
    8000290c:	fdc40593          	addi	a1,s0,-36
    80002910:	4501                	li	a0,0
    80002912:	e69ff0ef          	jal	8000277a <argint>
    return -1;
    80002916:	597d                	li	s2,-1
  if(argint(0, &n) < 0)
    80002918:	00054a63          	bltz	a0,8000292c <sys_sbrk+0x32>
  
  addr = p->sz; // sbrk returns old size
    8000291c:	0504b903          	ld	s2,80(s1)
  if(growproc(n) < 0) // growproc now returns new size on success, or -1 on error
    80002920:	fdc42503          	lw	a0,-36(s0)
    80002924:	96aff0ef          	jal	80001a8e <growproc>
    80002928:	00054963          	bltz	a0,8000293a <sys_sbrk+0x40>
    return -1;
  return addr;
}
    8000292c:	854a                	mv	a0,s2
    8000292e:	70a2                	ld	ra,40(sp)
    80002930:	7402                	ld	s0,32(sp)
    80002932:	64e2                	ld	s1,24(sp)
    80002934:	6942                	ld	s2,16(sp)
    80002936:	6145                	addi	sp,sp,48
    80002938:	8082                	ret
    return -1;
    8000293a:	597d                	li	s2,-1
    8000293c:	bfc5                	j	8000292c <sys_sbrk+0x32>

000000008000293e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000293e:	7139                	addi	sp,sp,-64
    80002940:	fc06                	sd	ra,56(sp)
    80002942:	f822                	sd	s0,48(sp)
    80002944:	f04a                	sd	s2,32(sp)
    80002946:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002948:	fcc40593          	addi	a1,s0,-52
    8000294c:	4501                	li	a0,0
    8000294e:	e2dff0ef          	jal	8000277a <argint>
  if(n < 0)
    80002952:	fcc42783          	lw	a5,-52(s0)
    80002956:	0607c763          	bltz	a5,800029c4 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    8000295a:	00010517          	auipc	a0,0x10
    8000295e:	9c650513          	addi	a0,a0,-1594 # 80012320 <tickslock>
    80002962:	595030ef          	jal	800066f6 <acquire>
  ticks0 = ticks;
    80002966:	00009917          	auipc	s2,0x9
    8000296a:	57a92903          	lw	s2,1402(s2) # 8000bee0 <ticks>
  while(ticks - ticks0 < n){
    8000296e:	fcc42783          	lw	a5,-52(s0)
    80002972:	cf8d                	beqz	a5,800029ac <sys_sleep+0x6e>
    80002974:	f426                	sd	s1,40(sp)
    80002976:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002978:	00010997          	auipc	s3,0x10
    8000297c:	9a898993          	addi	s3,s3,-1624 # 80012320 <tickslock>
    80002980:	00009497          	auipc	s1,0x9
    80002984:	56048493          	addi	s1,s1,1376 # 8000bee0 <ticks>
    if(killed(myproc())){
    80002988:	e31fe0ef          	jal	800017b8 <myproc>
    8000298c:	f08ff0ef          	jal	80002094 <killed>
    80002990:	ed0d                	bnez	a0,800029ca <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002992:	85ce                	mv	a1,s3
    80002994:	8526                	mv	a0,s1
    80002996:	cc6ff0ef          	jal	80001e5c <sleep>
  while(ticks - ticks0 < n){
    8000299a:	409c                	lw	a5,0(s1)
    8000299c:	412787bb          	subw	a5,a5,s2
    800029a0:	fcc42703          	lw	a4,-52(s0)
    800029a4:	fee7e2e3          	bltu	a5,a4,80002988 <sys_sleep+0x4a>
    800029a8:	74a2                	ld	s1,40(sp)
    800029aa:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800029ac:	00010517          	auipc	a0,0x10
    800029b0:	97450513          	addi	a0,a0,-1676 # 80012320 <tickslock>
    800029b4:	60f030ef          	jal	800067c2 <release>
  return 0;
    800029b8:	4501                	li	a0,0
}
    800029ba:	70e2                	ld	ra,56(sp)
    800029bc:	7442                	ld	s0,48(sp)
    800029be:	7902                	ld	s2,32(sp)
    800029c0:	6121                	addi	sp,sp,64
    800029c2:	8082                	ret
    n = 0;
    800029c4:	fc042623          	sw	zero,-52(s0)
    800029c8:	bf49                	j	8000295a <sys_sleep+0x1c>
      release(&tickslock);
    800029ca:	00010517          	auipc	a0,0x10
    800029ce:	95650513          	addi	a0,a0,-1706 # 80012320 <tickslock>
    800029d2:	5f1030ef          	jal	800067c2 <release>
      return -1;
    800029d6:	557d                	li	a0,-1
    800029d8:	74a2                	ld	s1,40(sp)
    800029da:	69e2                	ld	s3,24(sp)
    800029dc:	bff9                	j	800029ba <sys_sleep+0x7c>

00000000800029de <sys_kill>:

uint64
sys_kill(void)
{
    800029de:	1101                	addi	sp,sp,-32
    800029e0:	ec06                	sd	ra,24(sp)
    800029e2:	e822                	sd	s0,16(sp)
    800029e4:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800029e6:	fec40593          	addi	a1,s0,-20
    800029ea:	4501                	li	a0,0
    800029ec:	d8fff0ef          	jal	8000277a <argint>
  return kill(pid);
    800029f0:	fec42503          	lw	a0,-20(s0)
    800029f4:	e16ff0ef          	jal	8000200a <kill>
}
    800029f8:	60e2                	ld	ra,24(sp)
    800029fa:	6442                	ld	s0,16(sp)
    800029fc:	6105                	addi	sp,sp,32
    800029fe:	8082                	ret

0000000080002a00 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002a00:	1101                	addi	sp,sp,-32
    80002a02:	ec06                	sd	ra,24(sp)
    80002a04:	e822                	sd	s0,16(sp)
    80002a06:	e426                	sd	s1,8(sp)
    80002a08:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002a0a:	00010517          	auipc	a0,0x10
    80002a0e:	91650513          	addi	a0,a0,-1770 # 80012320 <tickslock>
    80002a12:	4e5030ef          	jal	800066f6 <acquire>
  xticks = ticks;
    80002a16:	00009497          	auipc	s1,0x9
    80002a1a:	4ca4a483          	lw	s1,1226(s1) # 8000bee0 <ticks>
  release(&tickslock);
    80002a1e:	00010517          	auipc	a0,0x10
    80002a22:	90250513          	addi	a0,a0,-1790 # 80012320 <tickslock>
    80002a26:	59d030ef          	jal	800067c2 <release>
  return xticks;
}
    80002a2a:	02049513          	slli	a0,s1,0x20
    80002a2e:	9101                	srli	a0,a0,0x20
    80002a30:	60e2                	ld	ra,24(sp)
    80002a32:	6442                	ld	s0,16(sp)
    80002a34:	64a2                	ld	s1,8(sp)
    80002a36:	6105                	addi	sp,sp,32
    80002a38:	8082                	ret

0000000080002a3a <sys_trace>:

// Implementation for the trace system call
uint64
sys_trace(void)
{
    80002a3a:	7179                	addi	sp,sp,-48
    80002a3c:	f406                	sd	ra,40(sp)
    80002a3e:	f022                	sd	s0,32(sp)
    80002a40:	ec26                	sd	s1,24(sp)
    80002a42:	1800                	addi	s0,sp,48
  int mask; // 用于存储从用户空间获取的 mask 参数
  struct proc *p = myproc(); // 获取当前进程的 proc 结构体指针
    80002a44:	d75fe0ef          	jal	800017b8 <myproc>
    80002a48:	84aa                	mv	s1,a0

  // 从系统调用参数中获取第一个整数参数 (index 0)
  // 并将其存储在局部变量 mask 中
  if(argint(0, &mask) < 0) {
    80002a4a:	fdc40593          	addi	a1,s0,-36
    80002a4e:	4501                	li	a0,0
    80002a50:	d2bff0ef          	jal	8000277a <argint>
    80002a54:	00054c63          	bltz	a0,80002a6c <sys_trace+0x32>
    // 如果获取参数失败，返回 -1 表示错误
    return -1;
  }

  // 将获取到的 mask 存储到当前进程的 tracemask 字段中
  p->tracemask = mask;
    80002a58:	fdc42783          	lw	a5,-36(s0)
    80002a5c:	16f4a823          	sw	a5,368(s1)

  // 系统调用成功，返回 0
  return 0;
    80002a60:	4501                	li	a0,0
}
    80002a62:	70a2                	ld	ra,40(sp)
    80002a64:	7402                	ld	s0,32(sp)
    80002a66:	64e2                	ld	s1,24(sp)
    80002a68:	6145                	addi	sp,sp,48
    80002a6a:	8082                	ret
    return -1;
    80002a6c:	557d                	li	a0,-1
    80002a6e:	bfd5                	j	80002a62 <sys_trace+0x28>

0000000080002a70 <sys_kpgtbl>:

// Implementation for the sys_kpgtbl
uint64
sys_kpgtbl(void)
{
    80002a70:	1141                	addi	sp,sp,-16
    80002a72:	e406                	sd	ra,8(sp)
    80002a74:	e022                	sd	s0,0(sp)
    80002a76:	0800                	addi	s0,sp,16
  struct proc *p = myproc(); // 获取当前进程
    80002a78:	d41fe0ef          	jal	800017b8 <myproc>
  if (p == 0 || p->pagetable == 0) { // 基本完整性检查
    80002a7c:	c911                	beqz	a0,80002a90 <sys_kpgtbl+0x20>
    80002a7e:	6d28                	ld	a0,88(a0)
    80002a80:	c911                	beqz	a0,80002a94 <sys_kpgtbl+0x24>
    return -1; // 错误
  }
  vmprint(p->pagetable); // 调用vmprint函数打印当前进程的页表
    80002a82:	b85fe0ef          	jal	80001606 <vmprint>
  return 0; // 成功
    80002a86:	4501                	li	a0,0
}
    80002a88:	60a2                	ld	ra,8(sp)
    80002a8a:	6402                	ld	s0,0(sp)
    80002a8c:	0141                	addi	sp,sp,16
    80002a8e:	8082                	ret
    return -1; // 错误
    80002a90:	557d                	li	a0,-1
    80002a92:	bfdd                	j	80002a88 <sys_kpgtbl+0x18>
    80002a94:	557d                	li	a0,-1
    80002a96:	bfcd                	j	80002a88 <sys_kpgtbl+0x18>

0000000080002a98 <sys_reset_stats>:
extern void reset_lock_stats(void); // 重置所有相关锁的统计
extern int  report_lock_stats(void);  // 报告kmem相关锁的竞争总数

uint64
sys_reset_stats(void)
{
    80002a98:	1141                	addi	sp,sp,-16
    80002a9a:	e406                	sd	ra,8(sp)
    80002a9c:	e022                	sd	s0,0(sp)
    80002a9e:	0800                	addi	s0,sp,16
  reset_all_lock_stats_kernel();
    80002aa0:	5f9030ef          	jal	80006898 <reset_all_lock_stats_kernel>
  return 0; // 成功
}
    80002aa4:	4501                	li	a0,0
    80002aa6:	60a2                	ld	ra,8(sp)
    80002aa8:	6402                	ld	s0,0(sp)
    80002aaa:	0141                	addi	sp,sp,16
    80002aac:	8082                	ret

0000000080002aae <sys_resetlockstats>:
extern struct spinlock all_locks_list_lock;

// 系统调用: 重置所有锁的统计数据
uint64
sys_resetlockstats(void) // kalloctest.c 会调用 resetlockstats()
{
    80002aae:	1141                	addi	sp,sp,-16
    80002ab0:	e406                	sd	ra,8(sp)
    80002ab2:	e022                	sd	s0,0(sp)
    80002ab4:	0800                	addi	s0,sp,16
  reset_all_lock_stats_kernel(); // 调用 spinlock.c 中的内核函数
    80002ab6:	5e3030ef          	jal	80006898 <reset_all_lock_stats_kernel>
  return 0;
}
    80002aba:	4501                	li	a0,0
    80002abc:	60a2                	ld	ra,8(sp)
    80002abe:	6402                	ld	s0,0(sp)
    80002ac0:	0141                	addi	sp,sp,16
    80002ac2:	8082                	ret

0000000080002ac4 <sys_statistics>:

// System call to get lock statistics as a formatted string
uint64
sys_statistics(void) // 对应 kalloctest.c 的 statistics(buf, sz)
{
    80002ac4:	7171                	addi	sp,sp,-176
    80002ac6:	f506                	sd	ra,168(sp)
    80002ac8:	f122                	sd	s0,160(sp)
    80002aca:	ed26                	sd	s1,152(sp)
    80002acc:	1900                	addi	s0,sp,176
  char kernel_buf[128]; // 内核临时缓冲区
  uint64 user_buf_addr;
  int user_buf_size;
  int len;
  struct proc *p = myproc();
    80002ace:	cebfe0ef          	jal	800017b8 <myproc>
    80002ad2:	84aa                	mv	s1,a0

  if(argaddr(0, &user_buf_addr) < 0 || argint(1, &user_buf_size) < 0) {
    80002ad4:	f5840593          	addi	a1,s0,-168
    80002ad8:	4501                	li	a0,0
    80002ada:	cbfff0ef          	jal	80002798 <argaddr>
    return -1;
    80002ade:	57fd                	li	a5,-1
  if(argaddr(0, &user_buf_addr) < 0 || argint(1, &user_buf_size) < 0) {
    80002ae0:	04054a63          	bltz	a0,80002b34 <sys_statistics+0x70>
    80002ae4:	f5440593          	addi	a1,s0,-172
    80002ae8:	4505                	li	a0,1
    80002aea:	c91ff0ef          	jal	8000277a <argint>
    80002aee:	04054963          	bltz	a0,80002b40 <sys_statistics+0x7c>
  }

  if(user_buf_size <= 0) { // 基本的无效大小检查
    80002af2:	f5442703          	lw	a4,-172(s0)
    return -1;
    80002af6:	57fd                	li	a5,-1
  if(user_buf_size <= 0) { // 基本的无效大小检查
    80002af8:	02e05e63          	blez	a4,80002b34 <sys_statistics+0x70>
    80002afc:	e94a                	sd	s2,144(sp)
  }
  // 确保内核缓冲区大小不会导致问题，但这里kernel_buf是固定的
  // 实际复制长度由 report_kmem_bcache_spins_formatted 返回

  len = report_kmem_bcache_spins_formatted(kernel_buf, sizeof(kernel_buf));
    80002afe:	08000593          	li	a1,128
    80002b02:	f6040513          	addi	a0,s0,-160
    80002b06:	5eb030ef          	jal	800068f0 <report_kmem_bcache_spins_formatted>
    80002b0a:	892a                	mv	s2,a0

  if (len < 0) { // 格式化出错或内部缓冲区不足
    80002b0c:	02054c63          	bltz	a0,80002b44 <sys_statistics+0x80>
    return -1;
  }
  if (len + 1 > user_buf_size) { // +1 for null terminator,检查用户缓冲区是否足够
    80002b10:	f5442703          	lw	a4,-172(s0)
    return -1; 
    80002b14:	57fd                	li	a5,-1
  if (len + 1 > user_buf_size) { // +1 for null terminator,检查用户缓冲区是否足够
    80002b16:	02e55d63          	bge	a0,a4,80002b50 <sys_statistics+0x8c>
  }

  if (copyout(p->pagetable, user_buf_addr, kernel_buf, len + 1) < 0) { // 复制 len+1 字节 (包括 \0)
    80002b1a:	0015069b          	addiw	a3,a0,1
    80002b1e:	f6040613          	addi	a2,s0,-160
    80002b22:	f5843583          	ld	a1,-168(s0)
    80002b26:	6ca8                	ld	a0,88(s1)
    80002b28:	d74fe0ef          	jal	8000109c <copyout>
    80002b2c:	00054f63          	bltz	a0,80002b4a <sys_statistics+0x86>
    return -1;
  }

  return len; // 返回实际写入用户缓冲区的字节数 (不包括 \0)
    80002b30:	87ca                	mv	a5,s2
    80002b32:	694a                	ld	s2,144(sp)
}
    80002b34:	853e                	mv	a0,a5
    80002b36:	70aa                	ld	ra,168(sp)
    80002b38:	740a                	ld	s0,160(sp)
    80002b3a:	64ea                	ld	s1,152(sp)
    80002b3c:	614d                	addi	sp,sp,176
    80002b3e:	8082                	ret
    return -1;
    80002b40:	57fd                	li	a5,-1
    80002b42:	bfcd                	j	80002b34 <sys_statistics+0x70>
    return -1;
    80002b44:	57fd                	li	a5,-1
    80002b46:	694a                	ld	s2,144(sp)
    80002b48:	b7f5                	j	80002b34 <sys_statistics+0x70>
    return -1;
    80002b4a:	57fd                	li	a5,-1
    80002b4c:	694a                	ld	s2,144(sp)
    80002b4e:	b7dd                	j	80002b34 <sys_statistics+0x70>
    80002b50:	694a                	ld	s2,144(sp)
    80002b52:	b7cd                	j	80002b34 <sys_statistics+0x70>

0000000080002b54 <sys_getlockstats>:
// 为了清晰，我们用 sys_getlockstats，并假设 kalloctest.c 会调用 getlockstats() 这个 stub。
// 如果 kalloctest.c 坚持调用 statistics() stub，那么你需要将此函数命名为 sys_statistics。
// 让我们假设 kalloctest.c 将调用 getlockstats() 这个存根。
uint64
sys_getlockstats(void)
{
    80002b54:	7119                	addi	sp,sp,-128
    80002b56:	fc86                	sd	ra,120(sp)
    80002b58:	f8a2                	sd	s0,112(sp)
    80002b5a:	e8d2                	sd	s4,80(sp)
    80002b5c:	e0da                	sd	s6,64(sp)
    80002b5e:	0100                	addi	s0,sp,128
  uint64 user_buf_addr;
  int max_user_entries;
  struct proc *p = myproc();
    80002b60:	c59fe0ef          	jal	800017b8 <myproc>
    80002b64:	8b2a                	mv	s6,a0
  int copied_count = 0;
  // struct lock_stat_entry_kernel k_entry_buf[MAX_LOCKS]; // <--- 不再在栈上分配大数组

  if (argaddr(0, &user_buf_addr) < 0 || argint(1, &max_user_entries) < 0) {
    80002b66:	fb840593          	addi	a1,s0,-72
    80002b6a:	4501                	li	a0,0
    80002b6c:	c2dff0ef          	jal	80002798 <argaddr>
    return -1;
    80002b70:	5a7d                	li	s4,-1
  if (argaddr(0, &user_buf_addr) < 0 || argint(1, &max_user_entries) < 0) {
    80002b72:	0e054163          	bltz	a0,80002c54 <sys_getlockstats+0x100>
    80002b76:	fb440593          	addi	a1,s0,-76
    80002b7a:	4505                	li	a0,1
    80002b7c:	bffff0ef          	jal	8000277a <argint>
    80002b80:	0e054863          	bltz	a0,80002c70 <sys_getlockstats+0x11c>
  }

  if (max_user_entries <= 0) {
    80002b84:	fb442783          	lw	a5,-76(s0)
    return 0;
    80002b88:	4a01                	li	s4,0
  if (max_user_entries <= 0) {
    80002b8a:	0cf05563          	blez	a5,80002c54 <sys_getlockstats+0x100>
  }

  acquire(&all_locks_list_meta_lock); // 保护全局锁列表
    80002b8e:	00023517          	auipc	a0,0x23
    80002b92:	f4a50513          	addi	a0,a0,-182 # 80025ad8 <all_locks_list_meta_lock>
    80002b96:	361030ef          	jal	800066f6 <acquire>

  for (int i = 0; i < num_registered_locks && copied_count < max_user_entries; i++) {
    80002b9a:	00009797          	auipc	a5,0x9
    80002b9e:	35e7a783          	lw	a5,862(a5) # 8000bef8 <num_registered_locks>
    80002ba2:	0cf05063          	blez	a5,80002c62 <sys_getlockstats+0x10e>
    80002ba6:	f4a6                	sd	s1,104(sp)
    80002ba8:	f0ca                	sd	s2,96(sp)
    80002baa:	ecce                	sd	s3,88(sp)
    80002bac:	e4d6                	sd	s5,72(sp)
    80002bae:	00023917          	auipc	s2,0x23
    80002bb2:	f4a90913          	addi	s2,s2,-182 # 80025af8 <all_registered_locks>
    80002bb6:	4981                	li	s3,0
    80002bb8:	00009a97          	auipc	s5,0x9
    80002bbc:	340a8a93          	addi	s5,s5,832 # 8000bef8 <num_registered_locks>
    80002bc0:	a01d                	j	80002be6 <sys_getlockstats+0x92>
                    user_buf_addr + copied_count * sizeof(struct lock_stat_entry_kernel), // 注意这里的类型大小
                    (char *)&current_kernel_entry,
                    sizeof(struct lock_stat_entry_kernel)) < 0) {
          // 如果 copyout 失败，可能用户地址无效或页表问题
          // 此时已经获取了 all_locks_list_meta_lock，需要释放它
          release(&all_locks_list_meta_lock);
    80002bc2:	00023517          	auipc	a0,0x23
    80002bc6:	f1650513          	addi	a0,a0,-234 # 80025ad8 <all_locks_list_meta_lock>
    80002bca:	3f9030ef          	jal	800067c2 <release>
          return -1; // 返回错误
    80002bce:	5a7d                	li	s4,-1
    80002bd0:	74a6                	ld	s1,104(sp)
    80002bd2:	7906                	ld	s2,96(sp)
    80002bd4:	69e6                	ld	s3,88(sp)
    80002bd6:	6aa6                	ld	s5,72(sp)
    80002bd8:	a8b5                	j	80002c54 <sys_getlockstats+0x100>
  for (int i = 0; i < num_registered_locks && copied_count < max_user_entries; i++) {
    80002bda:	2985                	addiw	s3,s3,1
    80002bdc:	0921                	addi	s2,s2,8
    80002bde:	000aa783          	lw	a5,0(s5)
    80002be2:	08f9d263          	bge	s3,a5,80002c66 <sys_getlockstats+0x112>
    80002be6:	fb442783          	lw	a5,-76(s0)
    80002bea:	04fa5b63          	bge	s4,a5,80002c40 <sys_getlockstats+0xec>
    struct spinlock *lk = all_registered_locks[i];
    80002bee:	00093483          	ld	s1,0(s2)
    if (lk != 0 && lk->name != 0 && strlen(lk->name) > 0) {
    80002bf2:	d4e5                	beqz	s1,80002bda <sys_getlockstats+0x86>
    80002bf4:	6488                	ld	a0,8(s1)
    80002bf6:	d175                	beqz	a0,80002bda <sys_getlockstats+0x86>
    80002bf8:	a27fd0ef          	jal	8000061e <strlen>
    80002bfc:	fca05fe3          	blez	a0,80002bda <sys_getlockstats+0x86>
        safestrcpy(current_kernel_entry.name, lk->name, LOCKNAME_MAX_LEN);
    80002c00:	02000613          	li	a2,32
    80002c04:	648c                	ld	a1,8(s1)
    80002c06:	f8840513          	addi	a0,s0,-120
    80002c0a:	9e3fd0ef          	jal	800005ec <safestrcpy>
        current_kernel_entry.acquire_count = lk->acquire_count;
    80002c0e:	4c9c                	lw	a5,24(s1)
    80002c10:	faf42423          	sw	a5,-88(s0)
        current_kernel_entry.tas_spins = lk->tas_spins;
    80002c14:	4cdc                	lw	a5,28(s1)
    80002c16:	faf42623          	sw	a5,-84(s0)
                    user_buf_addr + copied_count * sizeof(struct lock_stat_entry_kernel), // 注意这里的类型大小
    80002c1a:	002a1793          	slli	a5,s4,0x2
    80002c1e:	97d2                	add	a5,a5,s4
    80002c20:	078e                	slli	a5,a5,0x3
        if (copyout(p->pagetable,
    80002c22:	02800693          	li	a3,40
    80002c26:	f8840613          	addi	a2,s0,-120
    80002c2a:	fb843583          	ld	a1,-72(s0)
    80002c2e:	95be                	add	a1,a1,a5
    80002c30:	058b3503          	ld	a0,88(s6)
    80002c34:	c68fe0ef          	jal	8000109c <copyout>
    80002c38:	f80545e3          	bltz	a0,80002bc2 <sys_getlockstats+0x6e>
        }
        copied_count++; // 成功复制一个条目
    80002c3c:	2a05                	addiw	s4,s4,1
    80002c3e:	bf71                	j	80002bda <sys_getlockstats+0x86>
    80002c40:	74a6                	ld	s1,104(sp)
    80002c42:	7906                	ld	s2,96(sp)
    80002c44:	69e6                	ld	s3,88(sp)
    80002c46:	6aa6                	ld	s5,72(sp)
    }
  }
  release(&all_locks_list_meta_lock);
    80002c48:	00023517          	auipc	a0,0x23
    80002c4c:	e9050513          	addi	a0,a0,-368 # 80025ad8 <all_locks_list_meta_lock>
    80002c50:	373030ef          	jal	800067c2 <release>
  return copied_count; // 返回实际复制到用户空间的条目数量
}
    80002c54:	8552                	mv	a0,s4
    80002c56:	70e6                	ld	ra,120(sp)
    80002c58:	7446                	ld	s0,112(sp)
    80002c5a:	6a46                	ld	s4,80(sp)
    80002c5c:	6b06                	ld	s6,64(sp)
    80002c5e:	6109                	addi	sp,sp,128
    80002c60:	8082                	ret
  int copied_count = 0;
    80002c62:	4a01                	li	s4,0
    80002c64:	b7d5                	j	80002c48 <sys_getlockstats+0xf4>
    80002c66:	74a6                	ld	s1,104(sp)
    80002c68:	7906                	ld	s2,96(sp)
    80002c6a:	69e6                	ld	s3,88(sp)
    80002c6c:	6aa6                	ld	s5,72(sp)
    80002c6e:	bfe9                	j	80002c48 <sys_getlockstats+0xf4>
    return -1;
    80002c70:	5a7d                	li	s4,-1
    80002c72:	b7cd                	j	80002c54 <sys_getlockstats+0x100>

0000000080002c74 <sys_pgpte>:

uint64
sys_pgpte(void)
{
    80002c74:	7179                	addi	sp,sp,-48
    80002c76:	f406                	sd	ra,40(sp)
    80002c78:	f022                	sd	s0,32(sp)
    80002c7a:	ec26                	sd	s1,24(sp)
    80002c7c:	1800                	addi	s0,sp,48
  uint64 va;
  // pte_t *pte; // 原来可能是这样，或者你是用了 walk_info_t winfo;
  pte_t *pte_ptr; // <--- 将接收 walk 返回值的变量类型改为 pte_t*
  struct proc *p = myproc();
    80002c7e:	b3bfe0ef          	jal	800017b8 <myproc>
    80002c82:	84aa                	mv	s1,a0

  if (argaddr(0, &va) < 0)
    80002c84:	fd840593          	addi	a1,s0,-40
    80002c88:	4501                	li	a0,0
    80002c8a:	b0fff0ef          	jal	80002798 <argaddr>
    return 0; 
    80002c8e:	4781                	li	a5,0
  if (argaddr(0, &va) < 0)
    80002c90:	00054863          	bltz	a0,80002ca0 <sys_pgpte+0x2c>

  if (va >= MAXVA)
    80002c94:	fd843683          	ld	a3,-40(s0)
    80002c98:	577d                	li	a4,-1
    80002c9a:	8369                	srli	a4,a4,0x1a
    80002c9c:	00d77863          	bgeu	a4,a3,80002cac <sys_pgpte+0x38>

  if (pte_ptr == 0 || !(*pte_ptr & PTE_V)) // 检查指针是否为NULL以及PTE是否有效
    return 0; 

  return *pte_ptr; // 返回PTE的值
}
    80002ca0:	853e                	mv	a0,a5
    80002ca2:	70a2                	ld	ra,40(sp)
    80002ca4:	7402                	ld	s0,32(sp)
    80002ca6:	64e2                	ld	s1,24(sp)
    80002ca8:	6145                	addi	sp,sp,48
    80002caa:	8082                	ret
    80002cac:	e84a                	sd	s2,16(sp)
  acquire(&p->lock);
    80002cae:	8526                	mv	a0,s1
    80002cb0:	247030ef          	jal	800066f6 <acquire>
  pte_ptr = walk(p->pagetable, va, 0); // walk 现在返回 pte_t*
    80002cb4:	4601                	li	a2,0
    80002cb6:	fd843583          	ld	a1,-40(s0)
    80002cba:	6ca8                	ld	a0,88(s1)
    80002cbc:	b43fd0ef          	jal	800007fe <walk>
    80002cc0:	892a                	mv	s2,a0
  release(&p->lock);
    80002cc2:	8526                	mv	a0,s1
    80002cc4:	2ff030ef          	jal	800067c2 <release>
  if (pte_ptr == 0 || !(*pte_ptr & PTE_V)) // 检查指针是否为NULL以及PTE是否有效
    80002cc8:	00090a63          	beqz	s2,80002cdc <sys_pgpte+0x68>
    80002ccc:	00093703          	ld	a4,0(s2)
    80002cd0:	00177793          	andi	a5,a4,1
    80002cd4:	c799                	beqz	a5,80002ce2 <sys_pgpte+0x6e>
  return *pte_ptr; // 返回PTE的值
    80002cd6:	87ba                	mv	a5,a4
    80002cd8:	6942                	ld	s2,16(sp)
    80002cda:	b7d9                	j	80002ca0 <sys_pgpte+0x2c>
    return 0; 
    80002cdc:	4781                	li	a5,0
    80002cde:	6942                	ld	s2,16(sp)
    80002ce0:	b7c1                	j	80002ca0 <sys_pgpte+0x2c>
    80002ce2:	6942                	ld	s2,16(sp)
    80002ce4:	bf75                	j	80002ca0 <sys_pgpte+0x2c>

0000000080002ce6 <sys_ugetpid>:

uint64
sys_ugetpid(void)
{
    80002ce6:	1141                	addi	sp,sp,-16
    80002ce8:	e406                	sd	ra,8(sp)
    80002cea:	e022                	sd	s0,0(sp)
    80002cec:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002cee:	acbfe0ef          	jal	800017b8 <myproc>
  if (p == 0) // 基本检查，虽然myproc()在正常情况下不应返回0
    80002cf2:	c511                	beqz	a0,80002cfe <sys_ugetpid+0x18>
    return -1; // 或者panic，取决于错误处理策略
  return p->pid;
    80002cf4:	5d08                	lw	a0,56(a0)
}
    80002cf6:	60a2                	ld	ra,8(sp)
    80002cf8:	6402                	ld	s0,0(sp)
    80002cfa:	0141                	addi	sp,sp,16
    80002cfc:	8082                	ret
    return -1; // 或者panic，取决于错误处理策略
    80002cfe:	557d                	li	a0,-1
    80002d00:	bfdd                	j	80002cf6 <sys_ugetpid+0x10>

0000000080002d02 <sys_pgaccess>:

uint64
sys_pgaccess(void)
{
    80002d02:	7159                	addi	sp,sp,-112
    80002d04:	f486                	sd	ra,104(sp)
    80002d06:	f0a2                	sd	s0,96(sp)
    80002d08:	e4ce                	sd	s3,72(sp)
    80002d0a:	1880                	addi	s0,sp,112
  uint64 base_va; 
  int len;        
  uint64 mask_addr; 
  struct proc *p = myproc();
    80002d0c:	aadfe0ef          	jal	800017b8 <myproc>
    80002d10:	89aa                	mv	s3,a0
  unsigned int access_mask = 0;
    80002d12:	f8042a23          	sw	zero,-108(s0)
  int pte_a_was_cleared = 0; // 标志位，记录是否有PTE_A被清除

  if (argaddr(0, &base_va) < 0 || argint(1, &len) < 0 || argaddr(2, &mask_addr) < 0) {
    80002d16:	fa840593          	addi	a1,s0,-88
    80002d1a:	4501                	li	a0,0
    80002d1c:	a7dff0ef          	jal	80002798 <argaddr>
    return -1;
    80002d20:	57fd                	li	a5,-1
  if (argaddr(0, &base_va) < 0 || argint(1, &len) < 0 || argaddr(2, &mask_addr) < 0) {
    80002d22:	0c054763          	bltz	a0,80002df0 <sys_pgaccess+0xee>
    80002d26:	fa440593          	addi	a1,s0,-92
    80002d2a:	4505                	li	a0,1
    80002d2c:	a4fff0ef          	jal	8000277a <argint>
    return -1;
    80002d30:	57fd                	li	a5,-1
  if (argaddr(0, &base_va) < 0 || argint(1, &len) < 0 || argaddr(2, &mask_addr) < 0) {
    80002d32:	0a054f63          	bltz	a0,80002df0 <sys_pgaccess+0xee>
    80002d36:	f9840593          	addi	a1,s0,-104
    80002d3a:	4509                	li	a0,2
    80002d3c:	a5dff0ef          	jal	80002798 <argaddr>
    80002d40:	0c054563          	bltz	a0,80002e0a <sys_pgaccess+0x108>
  }

  if (len <= 0 || len > (sizeof(access_mask) * 8) ) { // 确保len不超过掩码的位数
    80002d44:	fa442703          	lw	a4,-92(s0)
    80002d48:	377d                	addiw	a4,a4,-1
    80002d4a:	46fd                	li	a3,31
      return -1;
    80002d4c:	57fd                	li	a5,-1
  if (len <= 0 || len > (sizeof(access_mask) * 8) ) { // 确保len不超过掩码的位数
    80002d4e:	0ae6e163          	bltu	a3,a4,80002df0 <sys_pgaccess+0xee>
  }
  // 进一步的VA范围检查可以添加在这里，确保 base_va + len*PGSIZE 不会溢出或超过MAXVA

  acquire(&p->lock);
    80002d52:	854e                	mv	a0,s3
    80002d54:	1a3030ef          	jal	800066f6 <acquire>

  for (int i = 0; i < len; i++) {
    80002d58:	fa442783          	lw	a5,-92(s0)
    80002d5c:	06f05c63          	blez	a5,80002dd4 <sys_pgaccess+0xd2>
    uint64 current_va = base_va + (uint64)i * PGSIZE;
    80002d60:	fa843583          	ld	a1,-88(s0)
    if (current_va >= MAXVA) { // 增加对current_va的边界检查
    80002d64:	57fd                	li	a5,-1
    80002d66:	83e9                	srli	a5,a5,0x1a
    80002d68:	06b7e663          	bltu	a5,a1,80002dd4 <sys_pgaccess+0xd2>
    80002d6c:	eca6                	sd	s1,88(sp)
    80002d6e:	e8ca                	sd	s2,80(sp)
    80002d70:	e0d2                	sd	s4,64(sp)
    80002d72:	fc56                	sd	s5,56(sp)
    80002d74:	f85a                	sd	s6,48(sp)
    80002d76:	f45e                	sd	s7,40(sp)
    80002d78:	6905                	lui	s2,0x1
  for (int i = 0; i < len; i++) {
    80002d7a:	4481                	li	s1,0

    // walk_info_t winfo = walk(p->pagetable, current_va, 0); // 旧的，错误的
    pte_t *pte_ptr = walk(p->pagetable, current_va, 0); // <--- 修改这里，接收 pte_t*

    // printf("sys_pgaccess: i=%d, va=0x%lx, pte_ptr=0x%p", i, current_va, pte_ptr); // DEBUG
    if (pte_ptr != 0 && (*pte_ptr & PTE_V) && (*pte_ptr & PTE_U)) {
    80002d7c:	4b45                	li	s6,17
      // printf(", pte_val=0x%lx", *pte_ptr); // DEBUG
      if (*pte_ptr & PTE_A) {
        // printf(", PTE_A is SET\n"); // DEBUG
        access_mask |= (1U << i); // 使用 1U 确保是无符号移位
    80002d7e:	4b85                	li	s7,1
    if (current_va >= MAXVA) { // 增加对current_va的边界检查
    80002d80:	6a85                	lui	s5,0x1
    80002d82:	8a3e                	mv	s4,a5
    80002d84:	a821                	j	80002d9c <sys_pgaccess+0x9a>
  for (int i = 0; i < len; i++) {
    80002d86:	2485                	addiw	s1,s1,1
    80002d88:	fa442783          	lw	a5,-92(s0)
    80002d8c:	02f4de63          	bge	s1,a5,80002dc8 <sys_pgaccess+0xc6>
    uint64 current_va = base_va + (uint64)i * PGSIZE;
    80002d90:	fa843583          	ld	a1,-88(s0)
    80002d94:	95ca                	add	a1,a1,s2
    if (current_va >= MAXVA) { // 增加对current_va的边界检查
    80002d96:	9956                	add	s2,s2,s5
    80002d98:	06ba6263          	bltu	s4,a1,80002dfc <sys_pgaccess+0xfa>
    pte_t *pte_ptr = walk(p->pagetable, current_va, 0); // <--- 修改这里，接收 pte_t*
    80002d9c:	4601                	li	a2,0
    80002d9e:	0589b503          	ld	a0,88(s3)
    80002da2:	a5dfd0ef          	jal	800007fe <walk>
    if (pte_ptr != 0 && (*pte_ptr & PTE_V) && (*pte_ptr & PTE_U)) {
    80002da6:	d165                	beqz	a0,80002d86 <sys_pgaccess+0x84>
    80002da8:	611c                	ld	a5,0(a0)
    80002daa:	0117f713          	andi	a4,a5,17
    80002dae:	fd671ce3          	bne	a4,s6,80002d86 <sys_pgaccess+0x84>
      if (*pte_ptr & PTE_A) {
    80002db2:	0407f793          	andi	a5,a5,64
    80002db6:	dbe1                	beqz	a5,80002d86 <sys_pgaccess+0x84>
        access_mask |= (1U << i); // 使用 1U 确保是无符号移位
    80002db8:	009b973b          	sllw	a4,s7,s1
    80002dbc:	f9442783          	lw	a5,-108(s0)
    80002dc0:	8fd9                	or	a5,a5,a4
    80002dc2:	f8f42a23          	sw	a5,-108(s0)
    80002dc6:	b7c1                	j	80002d86 <sys_pgaccess+0x84>
    80002dc8:	64e6                	ld	s1,88(sp)
    80002dca:	6946                	ld	s2,80(sp)
    80002dcc:	6a06                	ld	s4,64(sp)
    80002dce:	7ae2                	ld	s5,56(sp)
    80002dd0:	7b42                	ld	s6,48(sp)
    80002dd2:	7ba2                	ld	s7,40(sp)
  }

  if (pte_a_was_cleared) {
      sfence_vma(); // 如果清除了任何PTE_A位，刷新TLB
  }
  release(&p->lock);
    80002dd4:	854e                	mv	a0,s3
    80002dd6:	1ed030ef          	jal	800067c2 <release>

  // printf("sys_pgaccess: final access_mask (kernel) = 0x%x\n", access_mask); // DEBUG
  if (copyout(p->pagetable, mask_addr, (char *)&access_mask, sizeof(access_mask)) < 0) {
    80002dda:	4691                	li	a3,4
    80002ddc:	f9440613          	addi	a2,s0,-108
    80002de0:	f9843583          	ld	a1,-104(s0)
    80002de4:	0589b503          	ld	a0,88(s3)
    80002de8:	ab4fe0ef          	jal	8000109c <copyout>
    80002dec:	43f55793          	srai	a5,a0,0x3f
    // printf("sys_pgaccess: copyout failed!\n"); //DEBUG
    return -1;
  }

  return 0; // 成功
    80002df0:	853e                	mv	a0,a5
    80002df2:	70a6                	ld	ra,104(sp)
    80002df4:	7406                	ld	s0,96(sp)
    80002df6:	69a6                	ld	s3,72(sp)
    80002df8:	6165                	addi	sp,sp,112
    80002dfa:	8082                	ret
    80002dfc:	64e6                	ld	s1,88(sp)
    80002dfe:	6946                	ld	s2,80(sp)
    80002e00:	6a06                	ld	s4,64(sp)
    80002e02:	7ae2                	ld	s5,56(sp)
    80002e04:	7b42                	ld	s6,48(sp)
    80002e06:	7ba2                	ld	s7,40(sp)
    80002e08:	b7f1                	j	80002dd4 <sys_pgaccess+0xd2>
    return -1;
    80002e0a:	57fd                	li	a5,-1
    80002e0c:	b7d5                	j	80002df0 <sys_pgaccess+0xee>

0000000080002e0e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002e0e:	7179                	addi	sp,sp,-48
    80002e10:	f406                	sd	ra,40(sp)
    80002e12:	f022                	sd	s0,32(sp)
    80002e14:	ec26                	sd	s1,24(sp)
    80002e16:	e84a                	sd	s2,16(sp)
    80002e18:	e44e                	sd	s3,8(sp)
    80002e1a:	e052                	sd	s4,0(sp)
    80002e1c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002e1e:	00006597          	auipc	a1,0x6
    80002e22:	a7a58593          	addi	a1,a1,-1414 # 80008898 <etext+0x898>
    80002e26:	0000f517          	auipc	a0,0xf
    80002e2a:	51a50513          	addi	a0,a0,1306 # 80012340 <bcache>
    80002e2e:	1d1030ef          	jal	800067fe <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002e32:	00017797          	auipc	a5,0x17
    80002e36:	50e78793          	addi	a5,a5,1294 # 8001a340 <bcache+0x8000>
    80002e3a:	00018717          	auipc	a4,0x18
    80002e3e:	86670713          	addi	a4,a4,-1946 # 8001a6a0 <bcache+0x8360>
    80002e42:	3ae7b823          	sd	a4,944(a5)
  bcache.head.next = &bcache.head;
    80002e46:	3ae7bc23          	sd	a4,952(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002e4a:	0000f497          	auipc	s1,0xf
    80002e4e:	51648493          	addi	s1,s1,1302 # 80012360 <bcache+0x20>
    b->next = bcache.head.next;
    80002e52:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002e54:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002e56:	00006a17          	auipc	s4,0x6
    80002e5a:	a4aa0a13          	addi	s4,s4,-1462 # 800088a0 <etext+0x8a0>
    b->next = bcache.head.next;
    80002e5e:	3b893783          	ld	a5,952(s2) # 13b8 <_entry-0x7fffec48>
    80002e62:	ecbc                	sd	a5,88(s1)
    b->prev = &bcache.head;
    80002e64:	0534b823          	sd	s3,80(s1)
    initsleeplock(&b->lock, "buffer");
    80002e68:	85d2                	mv	a1,s4
    80002e6a:	01048513          	addi	a0,s1,16
    80002e6e:	280010ef          	jal	800040ee <initsleeplock>
    bcache.head.next->prev = b;
    80002e72:	3b893783          	ld	a5,952(s2)
    80002e76:	eba4                	sd	s1,80(a5)
    bcache.head.next = b;
    80002e78:	3a993c23          	sd	s1,952(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002e7c:	46048493          	addi	s1,s1,1120
    80002e80:	fd349fe3          	bne	s1,s3,80002e5e <binit+0x50>
  }
}
    80002e84:	70a2                	ld	ra,40(sp)
    80002e86:	7402                	ld	s0,32(sp)
    80002e88:	64e2                	ld	s1,24(sp)
    80002e8a:	6942                	ld	s2,16(sp)
    80002e8c:	69a2                	ld	s3,8(sp)
    80002e8e:	6a02                	ld	s4,0(sp)
    80002e90:	6145                	addi	sp,sp,48
    80002e92:	8082                	ret

0000000080002e94 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002e94:	7179                	addi	sp,sp,-48
    80002e96:	f406                	sd	ra,40(sp)
    80002e98:	f022                	sd	s0,32(sp)
    80002e9a:	ec26                	sd	s1,24(sp)
    80002e9c:	e84a                	sd	s2,16(sp)
    80002e9e:	e44e                	sd	s3,8(sp)
    80002ea0:	1800                	addi	s0,sp,48
    80002ea2:	892a                	mv	s2,a0
    80002ea4:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002ea6:	0000f517          	auipc	a0,0xf
    80002eaa:	49a50513          	addi	a0,a0,1178 # 80012340 <bcache>
    80002eae:	049030ef          	jal	800066f6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002eb2:	00018497          	auipc	s1,0x18
    80002eb6:	8464b483          	ld	s1,-1978(s1) # 8001a6f8 <bcache+0x83b8>
    80002eba:	00017797          	auipc	a5,0x17
    80002ebe:	7e678793          	addi	a5,a5,2022 # 8001a6a0 <bcache+0x8360>
    80002ec2:	02f48b63          	beq	s1,a5,80002ef8 <bread+0x64>
    80002ec6:	873e                	mv	a4,a5
    80002ec8:	a021                	j	80002ed0 <bread+0x3c>
    80002eca:	6ca4                	ld	s1,88(s1)
    80002ecc:	02e48663          	beq	s1,a4,80002ef8 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002ed0:	449c                	lw	a5,8(s1)
    80002ed2:	ff279ce3          	bne	a5,s2,80002eca <bread+0x36>
    80002ed6:	44dc                	lw	a5,12(s1)
    80002ed8:	ff3799e3          	bne	a5,s3,80002eca <bread+0x36>
      b->refcnt++;
    80002edc:	44bc                	lw	a5,72(s1)
    80002ede:	2785                	addiw	a5,a5,1
    80002ee0:	c4bc                	sw	a5,72(s1)
      release(&bcache.lock);
    80002ee2:	0000f517          	auipc	a0,0xf
    80002ee6:	45e50513          	addi	a0,a0,1118 # 80012340 <bcache>
    80002eea:	0d9030ef          	jal	800067c2 <release>
      acquiresleep(&b->lock);
    80002eee:	01048513          	addi	a0,s1,16
    80002ef2:	232010ef          	jal	80004124 <acquiresleep>
      return b;
    80002ef6:	a889                	j	80002f48 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002ef8:	00017497          	auipc	s1,0x17
    80002efc:	7f84b483          	ld	s1,2040(s1) # 8001a6f0 <bcache+0x83b0>
    80002f00:	00017797          	auipc	a5,0x17
    80002f04:	7a078793          	addi	a5,a5,1952 # 8001a6a0 <bcache+0x8360>
    80002f08:	00f48863          	beq	s1,a5,80002f18 <bread+0x84>
    80002f0c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002f0e:	44bc                	lw	a5,72(s1)
    80002f10:	cb91                	beqz	a5,80002f24 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f12:	68a4                	ld	s1,80(s1)
    80002f14:	fee49de3          	bne	s1,a4,80002f0e <bread+0x7a>
  panic("bget: no buffers");
    80002f18:	00006517          	auipc	a0,0x6
    80002f1c:	99050513          	addi	a0,a0,-1648 # 800088a8 <etext+0x8a8>
    80002f20:	482030ef          	jal	800063a2 <panic>
      b->dev = dev;
    80002f24:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002f28:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002f2c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002f30:	4785                	li	a5,1
    80002f32:	c4bc                	sw	a5,72(s1)
      release(&bcache.lock);
    80002f34:	0000f517          	auipc	a0,0xf
    80002f38:	40c50513          	addi	a0,a0,1036 # 80012340 <bcache>
    80002f3c:	087030ef          	jal	800067c2 <release>
      acquiresleep(&b->lock);
    80002f40:	01048513          	addi	a0,s1,16
    80002f44:	1e0010ef          	jal	80004124 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002f48:	409c                	lw	a5,0(s1)
    80002f4a:	cb89                	beqz	a5,80002f5c <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002f4c:	8526                	mv	a0,s1
    80002f4e:	70a2                	ld	ra,40(sp)
    80002f50:	7402                	ld	s0,32(sp)
    80002f52:	64e2                	ld	s1,24(sp)
    80002f54:	6942                	ld	s2,16(sp)
    80002f56:	69a2                	ld	s3,8(sp)
    80002f58:	6145                	addi	sp,sp,48
    80002f5a:	8082                	ret
    virtio_disk_rw(b, 0);
    80002f5c:	4581                	li	a1,0
    80002f5e:	8526                	mv	a0,s1
    80002f60:	211020ef          	jal	80005970 <virtio_disk_rw>
    b->valid = 1;
    80002f64:	4785                	li	a5,1
    80002f66:	c09c                	sw	a5,0(s1)
  return b;
    80002f68:	b7d5                	j	80002f4c <bread+0xb8>

0000000080002f6a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002f6a:	1101                	addi	sp,sp,-32
    80002f6c:	ec06                	sd	ra,24(sp)
    80002f6e:	e822                	sd	s0,16(sp)
    80002f70:	e426                	sd	s1,8(sp)
    80002f72:	1000                	addi	s0,sp,32
    80002f74:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002f76:	0541                	addi	a0,a0,16
    80002f78:	22a010ef          	jal	800041a2 <holdingsleep>
    80002f7c:	c911                	beqz	a0,80002f90 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002f7e:	4585                	li	a1,1
    80002f80:	8526                	mv	a0,s1
    80002f82:	1ef020ef          	jal	80005970 <virtio_disk_rw>
}
    80002f86:	60e2                	ld	ra,24(sp)
    80002f88:	6442                	ld	s0,16(sp)
    80002f8a:	64a2                	ld	s1,8(sp)
    80002f8c:	6105                	addi	sp,sp,32
    80002f8e:	8082                	ret
    panic("bwrite");
    80002f90:	00006517          	auipc	a0,0x6
    80002f94:	93050513          	addi	a0,a0,-1744 # 800088c0 <etext+0x8c0>
    80002f98:	40a030ef          	jal	800063a2 <panic>

0000000080002f9c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002f9c:	1101                	addi	sp,sp,-32
    80002f9e:	ec06                	sd	ra,24(sp)
    80002fa0:	e822                	sd	s0,16(sp)
    80002fa2:	e426                	sd	s1,8(sp)
    80002fa4:	e04a                	sd	s2,0(sp)
    80002fa6:	1000                	addi	s0,sp,32
    80002fa8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002faa:	01050913          	addi	s2,a0,16
    80002fae:	854a                	mv	a0,s2
    80002fb0:	1f2010ef          	jal	800041a2 <holdingsleep>
    80002fb4:	c135                	beqz	a0,80003018 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002fb6:	854a                	mv	a0,s2
    80002fb8:	1b2010ef          	jal	8000416a <releasesleep>

  acquire(&bcache.lock);
    80002fbc:	0000f517          	auipc	a0,0xf
    80002fc0:	38450513          	addi	a0,a0,900 # 80012340 <bcache>
    80002fc4:	732030ef          	jal	800066f6 <acquire>
  b->refcnt--;
    80002fc8:	44bc                	lw	a5,72(s1)
    80002fca:	37fd                	addiw	a5,a5,-1
    80002fcc:	0007871b          	sext.w	a4,a5
    80002fd0:	c4bc                	sw	a5,72(s1)
  if (b->refcnt == 0) {
    80002fd2:	e71d                	bnez	a4,80003000 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002fd4:	6cb8                	ld	a4,88(s1)
    80002fd6:	68bc                	ld	a5,80(s1)
    80002fd8:	eb3c                	sd	a5,80(a4)
    b->prev->next = b->next;
    80002fda:	6cb8                	ld	a4,88(s1)
    80002fdc:	efb8                	sd	a4,88(a5)
    b->next = bcache.head.next;
    80002fde:	00017797          	auipc	a5,0x17
    80002fe2:	36278793          	addi	a5,a5,866 # 8001a340 <bcache+0x8000>
    80002fe6:	3b87b703          	ld	a4,952(a5)
    80002fea:	ecb8                	sd	a4,88(s1)
    b->prev = &bcache.head;
    80002fec:	00017717          	auipc	a4,0x17
    80002ff0:	6b470713          	addi	a4,a4,1716 # 8001a6a0 <bcache+0x8360>
    80002ff4:	e8b8                	sd	a4,80(s1)
    bcache.head.next->prev = b;
    80002ff6:	3b87b703          	ld	a4,952(a5)
    80002ffa:	eb24                	sd	s1,80(a4)
    bcache.head.next = b;
    80002ffc:	3a97bc23          	sd	s1,952(a5)
  }
  
  release(&bcache.lock);
    80003000:	0000f517          	auipc	a0,0xf
    80003004:	34050513          	addi	a0,a0,832 # 80012340 <bcache>
    80003008:	7ba030ef          	jal	800067c2 <release>
}
    8000300c:	60e2                	ld	ra,24(sp)
    8000300e:	6442                	ld	s0,16(sp)
    80003010:	64a2                	ld	s1,8(sp)
    80003012:	6902                	ld	s2,0(sp)
    80003014:	6105                	addi	sp,sp,32
    80003016:	8082                	ret
    panic("brelse");
    80003018:	00006517          	auipc	a0,0x6
    8000301c:	8b050513          	addi	a0,a0,-1872 # 800088c8 <etext+0x8c8>
    80003020:	382030ef          	jal	800063a2 <panic>

0000000080003024 <bpin>:

void
bpin(struct buf *b) {
    80003024:	1101                	addi	sp,sp,-32
    80003026:	ec06                	sd	ra,24(sp)
    80003028:	e822                	sd	s0,16(sp)
    8000302a:	e426                	sd	s1,8(sp)
    8000302c:	1000                	addi	s0,sp,32
    8000302e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003030:	0000f517          	auipc	a0,0xf
    80003034:	31050513          	addi	a0,a0,784 # 80012340 <bcache>
    80003038:	6be030ef          	jal	800066f6 <acquire>
  b->refcnt++;
    8000303c:	44bc                	lw	a5,72(s1)
    8000303e:	2785                	addiw	a5,a5,1
    80003040:	c4bc                	sw	a5,72(s1)
  release(&bcache.lock);
    80003042:	0000f517          	auipc	a0,0xf
    80003046:	2fe50513          	addi	a0,a0,766 # 80012340 <bcache>
    8000304a:	778030ef          	jal	800067c2 <release>
}
    8000304e:	60e2                	ld	ra,24(sp)
    80003050:	6442                	ld	s0,16(sp)
    80003052:	64a2                	ld	s1,8(sp)
    80003054:	6105                	addi	sp,sp,32
    80003056:	8082                	ret

0000000080003058 <bunpin>:

void
bunpin(struct buf *b) {
    80003058:	1101                	addi	sp,sp,-32
    8000305a:	ec06                	sd	ra,24(sp)
    8000305c:	e822                	sd	s0,16(sp)
    8000305e:	e426                	sd	s1,8(sp)
    80003060:	1000                	addi	s0,sp,32
    80003062:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003064:	0000f517          	auipc	a0,0xf
    80003068:	2dc50513          	addi	a0,a0,732 # 80012340 <bcache>
    8000306c:	68a030ef          	jal	800066f6 <acquire>
  b->refcnt--;
    80003070:	44bc                	lw	a5,72(s1)
    80003072:	37fd                	addiw	a5,a5,-1
    80003074:	c4bc                	sw	a5,72(s1)
  release(&bcache.lock);
    80003076:	0000f517          	auipc	a0,0xf
    8000307a:	2ca50513          	addi	a0,a0,714 # 80012340 <bcache>
    8000307e:	744030ef          	jal	800067c2 <release>
}
    80003082:	60e2                	ld	ra,24(sp)
    80003084:	6442                	ld	s0,16(sp)
    80003086:	64a2                	ld	s1,8(sp)
    80003088:	6105                	addi	sp,sp,32
    8000308a:	8082                	ret

000000008000308c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000308c:	1101                	addi	sp,sp,-32
    8000308e:	ec06                	sd	ra,24(sp)
    80003090:	e822                	sd	s0,16(sp)
    80003092:	e426                	sd	s1,8(sp)
    80003094:	e04a                	sd	s2,0(sp)
    80003096:	1000                	addi	s0,sp,32
    80003098:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000309a:	00d5d59b          	srliw	a1,a1,0xd
    8000309e:	00018797          	auipc	a5,0x18
    800030a2:	a7e7a783          	lw	a5,-1410(a5) # 8001ab1c <sb+0x1c>
    800030a6:	9dbd                	addw	a1,a1,a5
    800030a8:	dedff0ef          	jal	80002e94 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800030ac:	0074f713          	andi	a4,s1,7
    800030b0:	4785                	li	a5,1
    800030b2:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800030b6:	14ce                	slli	s1,s1,0x33
    800030b8:	90d9                	srli	s1,s1,0x36
    800030ba:	00950733          	add	a4,a0,s1
    800030be:	06074703          	lbu	a4,96(a4)
    800030c2:	00e7f6b3          	and	a3,a5,a4
    800030c6:	c29d                	beqz	a3,800030ec <bfree+0x60>
    800030c8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800030ca:	94aa                	add	s1,s1,a0
    800030cc:	fff7c793          	not	a5,a5
    800030d0:	8f7d                	and	a4,a4,a5
    800030d2:	06e48023          	sb	a4,96(s1)
  log_write(bp);
    800030d6:	749000ef          	jal	8000401e <log_write>
  brelse(bp);
    800030da:	854a                	mv	a0,s2
    800030dc:	ec1ff0ef          	jal	80002f9c <brelse>
}
    800030e0:	60e2                	ld	ra,24(sp)
    800030e2:	6442                	ld	s0,16(sp)
    800030e4:	64a2                	ld	s1,8(sp)
    800030e6:	6902                	ld	s2,0(sp)
    800030e8:	6105                	addi	sp,sp,32
    800030ea:	8082                	ret
    panic("freeing free block");
    800030ec:	00005517          	auipc	a0,0x5
    800030f0:	7e450513          	addi	a0,a0,2020 # 800088d0 <etext+0x8d0>
    800030f4:	2ae030ef          	jal	800063a2 <panic>

00000000800030f8 <balloc>:
{
    800030f8:	711d                	addi	sp,sp,-96
    800030fa:	ec86                	sd	ra,88(sp)
    800030fc:	e8a2                	sd	s0,80(sp)
    800030fe:	e4a6                	sd	s1,72(sp)
    80003100:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003102:	00018797          	auipc	a5,0x18
    80003106:	a027a783          	lw	a5,-1534(a5) # 8001ab04 <sb+0x4>
    8000310a:	0e078f63          	beqz	a5,80003208 <balloc+0x110>
    8000310e:	e0ca                	sd	s2,64(sp)
    80003110:	fc4e                	sd	s3,56(sp)
    80003112:	f852                	sd	s4,48(sp)
    80003114:	f456                	sd	s5,40(sp)
    80003116:	f05a                	sd	s6,32(sp)
    80003118:	ec5e                	sd	s7,24(sp)
    8000311a:	e862                	sd	s8,16(sp)
    8000311c:	e466                	sd	s9,8(sp)
    8000311e:	8baa                	mv	s7,a0
    80003120:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003122:	00018b17          	auipc	s6,0x18
    80003126:	9deb0b13          	addi	s6,s6,-1570 # 8001ab00 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000312a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000312c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000312e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003130:	6c89                	lui	s9,0x2
    80003132:	a0b5                	j	8000319e <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003134:	97ca                	add	a5,a5,s2
    80003136:	8e55                	or	a2,a2,a3
    80003138:	06c78023          	sb	a2,96(a5)
        log_write(bp);
    8000313c:	854a                	mv	a0,s2
    8000313e:	6e1000ef          	jal	8000401e <log_write>
        brelse(bp);
    80003142:	854a                	mv	a0,s2
    80003144:	e59ff0ef          	jal	80002f9c <brelse>
  bp = bread(dev, bno);
    80003148:	85a6                	mv	a1,s1
    8000314a:	855e                	mv	a0,s7
    8000314c:	d49ff0ef          	jal	80002e94 <bread>
    80003150:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003152:	40000613          	li	a2,1024
    80003156:	4581                	li	a1,0
    80003158:	06050513          	addi	a0,a0,96
    8000315c:	b52fd0ef          	jal	800004ae <memset>
  log_write(bp);
    80003160:	854a                	mv	a0,s2
    80003162:	6bd000ef          	jal	8000401e <log_write>
  brelse(bp);
    80003166:	854a                	mv	a0,s2
    80003168:	e35ff0ef          	jal	80002f9c <brelse>
}
    8000316c:	6906                	ld	s2,64(sp)
    8000316e:	79e2                	ld	s3,56(sp)
    80003170:	7a42                	ld	s4,48(sp)
    80003172:	7aa2                	ld	s5,40(sp)
    80003174:	7b02                	ld	s6,32(sp)
    80003176:	6be2                	ld	s7,24(sp)
    80003178:	6c42                	ld	s8,16(sp)
    8000317a:	6ca2                	ld	s9,8(sp)
}
    8000317c:	8526                	mv	a0,s1
    8000317e:	60e6                	ld	ra,88(sp)
    80003180:	6446                	ld	s0,80(sp)
    80003182:	64a6                	ld	s1,72(sp)
    80003184:	6125                	addi	sp,sp,96
    80003186:	8082                	ret
    brelse(bp);
    80003188:	854a                	mv	a0,s2
    8000318a:	e13ff0ef          	jal	80002f9c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000318e:	015c87bb          	addw	a5,s9,s5
    80003192:	00078a9b          	sext.w	s5,a5
    80003196:	004b2703          	lw	a4,4(s6)
    8000319a:	04eaff63          	bgeu	s5,a4,800031f8 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    8000319e:	41fad79b          	sraiw	a5,s5,0x1f
    800031a2:	0137d79b          	srliw	a5,a5,0x13
    800031a6:	015787bb          	addw	a5,a5,s5
    800031aa:	40d7d79b          	sraiw	a5,a5,0xd
    800031ae:	01cb2583          	lw	a1,28(s6)
    800031b2:	9dbd                	addw	a1,a1,a5
    800031b4:	855e                	mv	a0,s7
    800031b6:	cdfff0ef          	jal	80002e94 <bread>
    800031ba:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031bc:	004b2503          	lw	a0,4(s6)
    800031c0:	000a849b          	sext.w	s1,s5
    800031c4:	8762                	mv	a4,s8
    800031c6:	fca4f1e3          	bgeu	s1,a0,80003188 <balloc+0x90>
      m = 1 << (bi % 8);
    800031ca:	00777693          	andi	a3,a4,7
    800031ce:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800031d2:	41f7579b          	sraiw	a5,a4,0x1f
    800031d6:	01d7d79b          	srliw	a5,a5,0x1d
    800031da:	9fb9                	addw	a5,a5,a4
    800031dc:	4037d79b          	sraiw	a5,a5,0x3
    800031e0:	00f90633          	add	a2,s2,a5
    800031e4:	06064603          	lbu	a2,96(a2)
    800031e8:	00c6f5b3          	and	a1,a3,a2
    800031ec:	d5a1                	beqz	a1,80003134 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031ee:	2705                	addiw	a4,a4,1
    800031f0:	2485                	addiw	s1,s1,1
    800031f2:	fd471ae3          	bne	a4,s4,800031c6 <balloc+0xce>
    800031f6:	bf49                	j	80003188 <balloc+0x90>
    800031f8:	6906                	ld	s2,64(sp)
    800031fa:	79e2                	ld	s3,56(sp)
    800031fc:	7a42                	ld	s4,48(sp)
    800031fe:	7aa2                	ld	s5,40(sp)
    80003200:	7b02                	ld	s6,32(sp)
    80003202:	6be2                	ld	s7,24(sp)
    80003204:	6c42                	ld	s8,16(sp)
    80003206:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80003208:	00005517          	auipc	a0,0x5
    8000320c:	6e050513          	addi	a0,a0,1760 # 800088e8 <etext+0x8e8>
    80003210:	6c1020ef          	jal	800060d0 <printf>
  return 0;
    80003214:	4481                	li	s1,0
    80003216:	b79d                	j	8000317c <balloc+0x84>

0000000080003218 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003218:	7179                	addi	sp,sp,-48
    8000321a:	f406                	sd	ra,40(sp)
    8000321c:	f022                	sd	s0,32(sp)
    8000321e:	ec26                	sd	s1,24(sp)
    80003220:	e84a                	sd	s2,16(sp)
    80003222:	e44e                	sd	s3,8(sp)
    80003224:	1800                	addi	s0,sp,48
    80003226:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003228:	47ad                	li	a5,11
    8000322a:	02b7e663          	bltu	a5,a1,80003256 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    8000322e:	02059793          	slli	a5,a1,0x20
    80003232:	01e7d593          	srli	a1,a5,0x1e
    80003236:	00b504b3          	add	s1,a0,a1
    8000323a:	0584a903          	lw	s2,88(s1)
    8000323e:	06091a63          	bnez	s2,800032b2 <bmap+0x9a>
      addr = balloc(ip->dev);
    80003242:	4108                	lw	a0,0(a0)
    80003244:	eb5ff0ef          	jal	800030f8 <balloc>
    80003248:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000324c:	06090363          	beqz	s2,800032b2 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80003250:	0524ac23          	sw	s2,88(s1)
    80003254:	a8b9                	j	800032b2 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003256:	ff45849b          	addiw	s1,a1,-12
    8000325a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000325e:	0ff00793          	li	a5,255
    80003262:	06e7ee63          	bltu	a5,a4,800032de <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003266:	08852903          	lw	s2,136(a0)
    8000326a:	00091d63          	bnez	s2,80003284 <bmap+0x6c>
      addr = balloc(ip->dev);
    8000326e:	4108                	lw	a0,0(a0)
    80003270:	e89ff0ef          	jal	800030f8 <balloc>
    80003274:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003278:	02090d63          	beqz	s2,800032b2 <bmap+0x9a>
    8000327c:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000327e:	0929a423          	sw	s2,136(s3)
    80003282:	a011                	j	80003286 <bmap+0x6e>
    80003284:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003286:	85ca                	mv	a1,s2
    80003288:	0009a503          	lw	a0,0(s3)
    8000328c:	c09ff0ef          	jal	80002e94 <bread>
    80003290:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003292:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    80003296:	02049713          	slli	a4,s1,0x20
    8000329a:	01e75593          	srli	a1,a4,0x1e
    8000329e:	00b784b3          	add	s1,a5,a1
    800032a2:	0004a903          	lw	s2,0(s1)
    800032a6:	00090e63          	beqz	s2,800032c2 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800032aa:	8552                	mv	a0,s4
    800032ac:	cf1ff0ef          	jal	80002f9c <brelse>
    return addr;
    800032b0:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800032b2:	854a                	mv	a0,s2
    800032b4:	70a2                	ld	ra,40(sp)
    800032b6:	7402                	ld	s0,32(sp)
    800032b8:	64e2                	ld	s1,24(sp)
    800032ba:	6942                	ld	s2,16(sp)
    800032bc:	69a2                	ld	s3,8(sp)
    800032be:	6145                	addi	sp,sp,48
    800032c0:	8082                	ret
      addr = balloc(ip->dev);
    800032c2:	0009a503          	lw	a0,0(s3)
    800032c6:	e33ff0ef          	jal	800030f8 <balloc>
    800032ca:	0005091b          	sext.w	s2,a0
      if(addr){
    800032ce:	fc090ee3          	beqz	s2,800032aa <bmap+0x92>
        a[bn] = addr;
    800032d2:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800032d6:	8552                	mv	a0,s4
    800032d8:	547000ef          	jal	8000401e <log_write>
    800032dc:	b7f9                	j	800032aa <bmap+0x92>
    800032de:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800032e0:	00005517          	auipc	a0,0x5
    800032e4:	62050513          	addi	a0,a0,1568 # 80008900 <etext+0x900>
    800032e8:	0ba030ef          	jal	800063a2 <panic>

00000000800032ec <iget>:
{
    800032ec:	7179                	addi	sp,sp,-48
    800032ee:	f406                	sd	ra,40(sp)
    800032f0:	f022                	sd	s0,32(sp)
    800032f2:	ec26                	sd	s1,24(sp)
    800032f4:	e84a                	sd	s2,16(sp)
    800032f6:	e44e                	sd	s3,8(sp)
    800032f8:	e052                	sd	s4,0(sp)
    800032fa:	1800                	addi	s0,sp,48
    800032fc:	89aa                	mv	s3,a0
    800032fe:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003300:	00018517          	auipc	a0,0x18
    80003304:	82050513          	addi	a0,a0,-2016 # 8001ab20 <itable>
    80003308:	3ee030ef          	jal	800066f6 <acquire>
  empty = 0;
    8000330c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000330e:	00018497          	auipc	s1,0x18
    80003312:	83248493          	addi	s1,s1,-1998 # 8001ab40 <itable+0x20>
    80003316:	00019697          	auipc	a3,0x19
    8000331a:	44a68693          	addi	a3,a3,1098 # 8001c760 <log>
    8000331e:	a039                	j	8000332c <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003320:	02090963          	beqz	s2,80003352 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003324:	09048493          	addi	s1,s1,144
    80003328:	02d48863          	beq	s1,a3,80003358 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000332c:	449c                	lw	a5,8(s1)
    8000332e:	fef059e3          	blez	a5,80003320 <iget+0x34>
    80003332:	4098                	lw	a4,0(s1)
    80003334:	ff3716e3          	bne	a4,s3,80003320 <iget+0x34>
    80003338:	40d8                	lw	a4,4(s1)
    8000333a:	ff4713e3          	bne	a4,s4,80003320 <iget+0x34>
      ip->ref++;
    8000333e:	2785                	addiw	a5,a5,1
    80003340:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003342:	00017517          	auipc	a0,0x17
    80003346:	7de50513          	addi	a0,a0,2014 # 8001ab20 <itable>
    8000334a:	478030ef          	jal	800067c2 <release>
      return ip;
    8000334e:	8926                	mv	s2,s1
    80003350:	a02d                	j	8000337a <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003352:	fbe9                	bnez	a5,80003324 <iget+0x38>
      empty = ip;
    80003354:	8926                	mv	s2,s1
    80003356:	b7f9                	j	80003324 <iget+0x38>
  if(empty == 0)
    80003358:	02090a63          	beqz	s2,8000338c <iget+0xa0>
  ip->dev = dev;
    8000335c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003360:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003364:	4785                	li	a5,1
    80003366:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000336a:	04092423          	sw	zero,72(s2)
  release(&itable.lock);
    8000336e:	00017517          	auipc	a0,0x17
    80003372:	7b250513          	addi	a0,a0,1970 # 8001ab20 <itable>
    80003376:	44c030ef          	jal	800067c2 <release>
}
    8000337a:	854a                	mv	a0,s2
    8000337c:	70a2                	ld	ra,40(sp)
    8000337e:	7402                	ld	s0,32(sp)
    80003380:	64e2                	ld	s1,24(sp)
    80003382:	6942                	ld	s2,16(sp)
    80003384:	69a2                	ld	s3,8(sp)
    80003386:	6a02                	ld	s4,0(sp)
    80003388:	6145                	addi	sp,sp,48
    8000338a:	8082                	ret
    panic("iget: no inodes");
    8000338c:	00005517          	auipc	a0,0x5
    80003390:	58c50513          	addi	a0,a0,1420 # 80008918 <etext+0x918>
    80003394:	00e030ef          	jal	800063a2 <panic>

0000000080003398 <fsinit>:
fsinit(int dev) {
    80003398:	7179                	addi	sp,sp,-48
    8000339a:	f406                	sd	ra,40(sp)
    8000339c:	f022                	sd	s0,32(sp)
    8000339e:	ec26                	sd	s1,24(sp)
    800033a0:	e84a                	sd	s2,16(sp)
    800033a2:	e44e                	sd	s3,8(sp)
    800033a4:	e052                	sd	s4,0(sp)
    800033a6:	1800                	addi	s0,sp,48
    800033a8:	89aa                	mv	s3,a0
  bp = bread(dev, 1);
    800033aa:	00050a1b          	sext.w	s4,a0
    800033ae:	4585                	li	a1,1
    800033b0:	8552                	mv	a0,s4
    800033b2:	ae3ff0ef          	jal	80002e94 <bread>
    800033b6:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    800033b8:	00017497          	auipc	s1,0x17
    800033bc:	74848493          	addi	s1,s1,1864 # 8001ab00 <sb>
    800033c0:	02000613          	li	a2,32
    800033c4:	06050593          	addi	a1,a0,96
    800033c8:	8526                	mv	a0,s1
    800033ca:	940fd0ef          	jal	8000050a <memmove>
  brelse(bp);
    800033ce:	854a                	mv	a0,s2
    800033d0:	bcdff0ef          	jal	80002f9c <brelse>
  b = bread(dev, 1); // Get buf for block 1 (Superblock)
    800033d4:	4585                	li	a1,1
    800033d6:	8552                	mv	a0,s4
    800033d8:	abdff0ef          	jal	80002e94 <bread>
    800033dc:	892a                	mv	s2,a0
  printf("fsinit: Superblock read. Magic: 0x%x, Size: %d\n", sb.magic, sb.size); // Verify content
    800033de:	40d0                	lw	a2,4(s1)
    800033e0:	408c                	lw	a1,0(s1)
    800033e2:	00005517          	auipc	a0,0x5
    800033e6:	54650513          	addi	a0,a0,1350 # 80008928 <etext+0x928>
    800033ea:	4e7020ef          	jal	800060d0 <printf>
  printf("fsinit: Superblock in cache physical address: 0x%lx\n", (uint64)b->data); // IMPORTANT: Print PA
    800033ee:	06090593          	addi	a1,s2,96
    800033f2:	00005517          	auipc	a0,0x5
    800033f6:	56650513          	addi	a0,a0,1382 # 80008958 <etext+0x958>
    800033fa:	4d7020ef          	jal	800060d0 <printf>
  brelse(b); // Release the buf
    800033fe:	854a                	mv	a0,s2
    80003400:	b9dff0ef          	jal	80002f9c <brelse>
  if(sb.magic != FSMAGIC)
    80003404:	4098                	lw	a4,0(s1)
    80003406:	102037b7          	lui	a5,0x10203
    8000340a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000340e:	02f71163          	bne	a4,a5,80003430 <fsinit+0x98>
  initlog(dev, &sb);
    80003412:	00017597          	auipc	a1,0x17
    80003416:	6ee58593          	addi	a1,a1,1774 # 8001ab00 <sb>
    8000341a:	854e                	mv	a0,s3
    8000341c:	1fb000ef          	jal	80003e16 <initlog>
}
    80003420:	70a2                	ld	ra,40(sp)
    80003422:	7402                	ld	s0,32(sp)
    80003424:	64e2                	ld	s1,24(sp)
    80003426:	6942                	ld	s2,16(sp)
    80003428:	69a2                	ld	s3,8(sp)
    8000342a:	6a02                	ld	s4,0(sp)
    8000342c:	6145                	addi	sp,sp,48
    8000342e:	8082                	ret
    panic("invalid file system");
    80003430:	00005517          	auipc	a0,0x5
    80003434:	56050513          	addi	a0,a0,1376 # 80008990 <etext+0x990>
    80003438:	76b020ef          	jal	800063a2 <panic>

000000008000343c <iinit>:
{
    8000343c:	7179                	addi	sp,sp,-48
    8000343e:	f406                	sd	ra,40(sp)
    80003440:	f022                	sd	s0,32(sp)
    80003442:	ec26                	sd	s1,24(sp)
    80003444:	e84a                	sd	s2,16(sp)
    80003446:	e44e                	sd	s3,8(sp)
    80003448:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000344a:	00005597          	auipc	a1,0x5
    8000344e:	55e58593          	addi	a1,a1,1374 # 800089a8 <etext+0x9a8>
    80003452:	00017517          	auipc	a0,0x17
    80003456:	6ce50513          	addi	a0,a0,1742 # 8001ab20 <itable>
    8000345a:	3a4030ef          	jal	800067fe <initlock>
  for(i = 0; i < NINODE; i++) {
    8000345e:	00017497          	auipc	s1,0x17
    80003462:	6f248493          	addi	s1,s1,1778 # 8001ab50 <itable+0x30>
    80003466:	00019997          	auipc	s3,0x19
    8000346a:	30a98993          	addi	s3,s3,778 # 8001c770 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000346e:	00005917          	auipc	s2,0x5
    80003472:	54290913          	addi	s2,s2,1346 # 800089b0 <etext+0x9b0>
    80003476:	85ca                	mv	a1,s2
    80003478:	8526                	mv	a0,s1
    8000347a:	475000ef          	jal	800040ee <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000347e:	09048493          	addi	s1,s1,144
    80003482:	ff349ae3          	bne	s1,s3,80003476 <iinit+0x3a>
}
    80003486:	70a2                	ld	ra,40(sp)
    80003488:	7402                	ld	s0,32(sp)
    8000348a:	64e2                	ld	s1,24(sp)
    8000348c:	6942                	ld	s2,16(sp)
    8000348e:	69a2                	ld	s3,8(sp)
    80003490:	6145                	addi	sp,sp,48
    80003492:	8082                	ret

0000000080003494 <ialloc>:
{
    80003494:	7139                	addi	sp,sp,-64
    80003496:	fc06                	sd	ra,56(sp)
    80003498:	f822                	sd	s0,48(sp)
    8000349a:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000349c:	00017717          	auipc	a4,0x17
    800034a0:	67072703          	lw	a4,1648(a4) # 8001ab0c <sb+0xc>
    800034a4:	4785                	li	a5,1
    800034a6:	06e7f063          	bgeu	a5,a4,80003506 <ialloc+0x72>
    800034aa:	f426                	sd	s1,40(sp)
    800034ac:	f04a                	sd	s2,32(sp)
    800034ae:	ec4e                	sd	s3,24(sp)
    800034b0:	e852                	sd	s4,16(sp)
    800034b2:	e456                	sd	s5,8(sp)
    800034b4:	e05a                	sd	s6,0(sp)
    800034b6:	8aaa                	mv	s5,a0
    800034b8:	8b2e                	mv	s6,a1
    800034ba:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800034bc:	00017a17          	auipc	s4,0x17
    800034c0:	644a0a13          	addi	s4,s4,1604 # 8001ab00 <sb>
    800034c4:	00495593          	srli	a1,s2,0x4
    800034c8:	018a2783          	lw	a5,24(s4)
    800034cc:	9dbd                	addw	a1,a1,a5
    800034ce:	8556                	mv	a0,s5
    800034d0:	9c5ff0ef          	jal	80002e94 <bread>
    800034d4:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800034d6:	06050993          	addi	s3,a0,96
    800034da:	00f97793          	andi	a5,s2,15
    800034de:	079a                	slli	a5,a5,0x6
    800034e0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800034e2:	00099783          	lh	a5,0(s3)
    800034e6:	cb9d                	beqz	a5,8000351c <ialloc+0x88>
    brelse(bp);
    800034e8:	ab5ff0ef          	jal	80002f9c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800034ec:	0905                	addi	s2,s2,1
    800034ee:	00ca2703          	lw	a4,12(s4)
    800034f2:	0009079b          	sext.w	a5,s2
    800034f6:	fce7e7e3          	bltu	a5,a4,800034c4 <ialloc+0x30>
    800034fa:	74a2                	ld	s1,40(sp)
    800034fc:	7902                	ld	s2,32(sp)
    800034fe:	69e2                	ld	s3,24(sp)
    80003500:	6a42                	ld	s4,16(sp)
    80003502:	6aa2                	ld	s5,8(sp)
    80003504:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003506:	00005517          	auipc	a0,0x5
    8000350a:	4b250513          	addi	a0,a0,1202 # 800089b8 <etext+0x9b8>
    8000350e:	3c3020ef          	jal	800060d0 <printf>
  return 0;
    80003512:	4501                	li	a0,0
}
    80003514:	70e2                	ld	ra,56(sp)
    80003516:	7442                	ld	s0,48(sp)
    80003518:	6121                	addi	sp,sp,64
    8000351a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000351c:	04000613          	li	a2,64
    80003520:	4581                	li	a1,0
    80003522:	854e                	mv	a0,s3
    80003524:	f8bfc0ef          	jal	800004ae <memset>
      dip->type = type;
    80003528:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000352c:	8526                	mv	a0,s1
    8000352e:	2f1000ef          	jal	8000401e <log_write>
      brelse(bp);
    80003532:	8526                	mv	a0,s1
    80003534:	a69ff0ef          	jal	80002f9c <brelse>
      return iget(dev, inum);
    80003538:	0009059b          	sext.w	a1,s2
    8000353c:	8556                	mv	a0,s5
    8000353e:	dafff0ef          	jal	800032ec <iget>
    80003542:	74a2                	ld	s1,40(sp)
    80003544:	7902                	ld	s2,32(sp)
    80003546:	69e2                	ld	s3,24(sp)
    80003548:	6a42                	ld	s4,16(sp)
    8000354a:	6aa2                	ld	s5,8(sp)
    8000354c:	6b02                	ld	s6,0(sp)
    8000354e:	b7d9                	j	80003514 <ialloc+0x80>

0000000080003550 <iupdate>:
{
    80003550:	1101                	addi	sp,sp,-32
    80003552:	ec06                	sd	ra,24(sp)
    80003554:	e822                	sd	s0,16(sp)
    80003556:	e426                	sd	s1,8(sp)
    80003558:	e04a                	sd	s2,0(sp)
    8000355a:	1000                	addi	s0,sp,32
    8000355c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000355e:	415c                	lw	a5,4(a0)
    80003560:	0047d79b          	srliw	a5,a5,0x4
    80003564:	00017597          	auipc	a1,0x17
    80003568:	5b45a583          	lw	a1,1460(a1) # 8001ab18 <sb+0x18>
    8000356c:	9dbd                	addw	a1,a1,a5
    8000356e:	4108                	lw	a0,0(a0)
    80003570:	925ff0ef          	jal	80002e94 <bread>
    80003574:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003576:	06050793          	addi	a5,a0,96
    8000357a:	40d8                	lw	a4,4(s1)
    8000357c:	8b3d                	andi	a4,a4,15
    8000357e:	071a                	slli	a4,a4,0x6
    80003580:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003582:	04c49703          	lh	a4,76(s1)
    80003586:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000358a:	04e49703          	lh	a4,78(s1)
    8000358e:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003592:	05049703          	lh	a4,80(s1)
    80003596:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000359a:	05249703          	lh	a4,82(s1)
    8000359e:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800035a2:	48f8                	lw	a4,84(s1)
    800035a4:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800035a6:	03400613          	li	a2,52
    800035aa:	05848593          	addi	a1,s1,88
    800035ae:	00c78513          	addi	a0,a5,12
    800035b2:	f59fc0ef          	jal	8000050a <memmove>
  log_write(bp);
    800035b6:	854a                	mv	a0,s2
    800035b8:	267000ef          	jal	8000401e <log_write>
  brelse(bp);
    800035bc:	854a                	mv	a0,s2
    800035be:	9dfff0ef          	jal	80002f9c <brelse>
}
    800035c2:	60e2                	ld	ra,24(sp)
    800035c4:	6442                	ld	s0,16(sp)
    800035c6:	64a2                	ld	s1,8(sp)
    800035c8:	6902                	ld	s2,0(sp)
    800035ca:	6105                	addi	sp,sp,32
    800035cc:	8082                	ret

00000000800035ce <idup>:
{
    800035ce:	1101                	addi	sp,sp,-32
    800035d0:	ec06                	sd	ra,24(sp)
    800035d2:	e822                	sd	s0,16(sp)
    800035d4:	e426                	sd	s1,8(sp)
    800035d6:	1000                	addi	s0,sp,32
    800035d8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800035da:	00017517          	auipc	a0,0x17
    800035de:	54650513          	addi	a0,a0,1350 # 8001ab20 <itable>
    800035e2:	114030ef          	jal	800066f6 <acquire>
  ip->ref++;
    800035e6:	449c                	lw	a5,8(s1)
    800035e8:	2785                	addiw	a5,a5,1
    800035ea:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800035ec:	00017517          	auipc	a0,0x17
    800035f0:	53450513          	addi	a0,a0,1332 # 8001ab20 <itable>
    800035f4:	1ce030ef          	jal	800067c2 <release>
}
    800035f8:	8526                	mv	a0,s1
    800035fa:	60e2                	ld	ra,24(sp)
    800035fc:	6442                	ld	s0,16(sp)
    800035fe:	64a2                	ld	s1,8(sp)
    80003600:	6105                	addi	sp,sp,32
    80003602:	8082                	ret

0000000080003604 <ilock>:
{
    80003604:	1101                	addi	sp,sp,-32
    80003606:	ec06                	sd	ra,24(sp)
    80003608:	e822                	sd	s0,16(sp)
    8000360a:	e426                	sd	s1,8(sp)
    8000360c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000360e:	cd19                	beqz	a0,8000362c <ilock+0x28>
    80003610:	84aa                	mv	s1,a0
    80003612:	451c                	lw	a5,8(a0)
    80003614:	00f05c63          	blez	a5,8000362c <ilock+0x28>
  acquiresleep(&ip->lock);
    80003618:	0541                	addi	a0,a0,16
    8000361a:	30b000ef          	jal	80004124 <acquiresleep>
  if(ip->valid == 0){
    8000361e:	44bc                	lw	a5,72(s1)
    80003620:	cf89                	beqz	a5,8000363a <ilock+0x36>
}
    80003622:	60e2                	ld	ra,24(sp)
    80003624:	6442                	ld	s0,16(sp)
    80003626:	64a2                	ld	s1,8(sp)
    80003628:	6105                	addi	sp,sp,32
    8000362a:	8082                	ret
    8000362c:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000362e:	00005517          	auipc	a0,0x5
    80003632:	3a250513          	addi	a0,a0,930 # 800089d0 <etext+0x9d0>
    80003636:	56d020ef          	jal	800063a2 <panic>
    8000363a:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000363c:	40dc                	lw	a5,4(s1)
    8000363e:	0047d79b          	srliw	a5,a5,0x4
    80003642:	00017597          	auipc	a1,0x17
    80003646:	4d65a583          	lw	a1,1238(a1) # 8001ab18 <sb+0x18>
    8000364a:	9dbd                	addw	a1,a1,a5
    8000364c:	4088                	lw	a0,0(s1)
    8000364e:	847ff0ef          	jal	80002e94 <bread>
    80003652:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003654:	06050593          	addi	a1,a0,96
    80003658:	40dc                	lw	a5,4(s1)
    8000365a:	8bbd                	andi	a5,a5,15
    8000365c:	079a                	slli	a5,a5,0x6
    8000365e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003660:	00059783          	lh	a5,0(a1)
    80003664:	04f49623          	sh	a5,76(s1)
    ip->major = dip->major;
    80003668:	00259783          	lh	a5,2(a1)
    8000366c:	04f49723          	sh	a5,78(s1)
    ip->minor = dip->minor;
    80003670:	00459783          	lh	a5,4(a1)
    80003674:	04f49823          	sh	a5,80(s1)
    ip->nlink = dip->nlink;
    80003678:	00659783          	lh	a5,6(a1)
    8000367c:	04f49923          	sh	a5,82(s1)
    ip->size = dip->size;
    80003680:	459c                	lw	a5,8(a1)
    80003682:	c8fc                	sw	a5,84(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003684:	03400613          	li	a2,52
    80003688:	05b1                	addi	a1,a1,12
    8000368a:	05848513          	addi	a0,s1,88
    8000368e:	e7dfc0ef          	jal	8000050a <memmove>
    brelse(bp);
    80003692:	854a                	mv	a0,s2
    80003694:	909ff0ef          	jal	80002f9c <brelse>
    ip->valid = 1;
    80003698:	4785                	li	a5,1
    8000369a:	c4bc                	sw	a5,72(s1)
    if(ip->type == 0)
    8000369c:	04c49783          	lh	a5,76(s1)
    800036a0:	c399                	beqz	a5,800036a6 <ilock+0xa2>
    800036a2:	6902                	ld	s2,0(sp)
    800036a4:	bfbd                	j	80003622 <ilock+0x1e>
      panic("ilock: no type");
    800036a6:	00005517          	auipc	a0,0x5
    800036aa:	33250513          	addi	a0,a0,818 # 800089d8 <etext+0x9d8>
    800036ae:	4f5020ef          	jal	800063a2 <panic>

00000000800036b2 <iunlock>:
{
    800036b2:	1101                	addi	sp,sp,-32
    800036b4:	ec06                	sd	ra,24(sp)
    800036b6:	e822                	sd	s0,16(sp)
    800036b8:	e426                	sd	s1,8(sp)
    800036ba:	e04a                	sd	s2,0(sp)
    800036bc:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800036be:	c505                	beqz	a0,800036e6 <iunlock+0x34>
    800036c0:	84aa                	mv	s1,a0
    800036c2:	01050913          	addi	s2,a0,16
    800036c6:	854a                	mv	a0,s2
    800036c8:	2db000ef          	jal	800041a2 <holdingsleep>
    800036cc:	cd09                	beqz	a0,800036e6 <iunlock+0x34>
    800036ce:	449c                	lw	a5,8(s1)
    800036d0:	00f05b63          	blez	a5,800036e6 <iunlock+0x34>
  releasesleep(&ip->lock);
    800036d4:	854a                	mv	a0,s2
    800036d6:	295000ef          	jal	8000416a <releasesleep>
}
    800036da:	60e2                	ld	ra,24(sp)
    800036dc:	6442                	ld	s0,16(sp)
    800036de:	64a2                	ld	s1,8(sp)
    800036e0:	6902                	ld	s2,0(sp)
    800036e2:	6105                	addi	sp,sp,32
    800036e4:	8082                	ret
    panic("iunlock");
    800036e6:	00005517          	auipc	a0,0x5
    800036ea:	30250513          	addi	a0,a0,770 # 800089e8 <etext+0x9e8>
    800036ee:	4b5020ef          	jal	800063a2 <panic>

00000000800036f2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800036f2:	7179                	addi	sp,sp,-48
    800036f4:	f406                	sd	ra,40(sp)
    800036f6:	f022                	sd	s0,32(sp)
    800036f8:	ec26                	sd	s1,24(sp)
    800036fa:	e84a                	sd	s2,16(sp)
    800036fc:	e44e                	sd	s3,8(sp)
    800036fe:	1800                	addi	s0,sp,48
    80003700:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003702:	05850493          	addi	s1,a0,88
    80003706:	08850913          	addi	s2,a0,136
    8000370a:	a021                	j	80003712 <itrunc+0x20>
    8000370c:	0491                	addi	s1,s1,4
    8000370e:	01248b63          	beq	s1,s2,80003724 <itrunc+0x32>
    if(ip->addrs[i]){
    80003712:	408c                	lw	a1,0(s1)
    80003714:	dde5                	beqz	a1,8000370c <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003716:	0009a503          	lw	a0,0(s3)
    8000371a:	973ff0ef          	jal	8000308c <bfree>
      ip->addrs[i] = 0;
    8000371e:	0004a023          	sw	zero,0(s1)
    80003722:	b7ed                	j	8000370c <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003724:	0889a583          	lw	a1,136(s3)
    80003728:	ed89                	bnez	a1,80003742 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000372a:	0409aa23          	sw	zero,84(s3)
  iupdate(ip);
    8000372e:	854e                	mv	a0,s3
    80003730:	e21ff0ef          	jal	80003550 <iupdate>
}
    80003734:	70a2                	ld	ra,40(sp)
    80003736:	7402                	ld	s0,32(sp)
    80003738:	64e2                	ld	s1,24(sp)
    8000373a:	6942                	ld	s2,16(sp)
    8000373c:	69a2                	ld	s3,8(sp)
    8000373e:	6145                	addi	sp,sp,48
    80003740:	8082                	ret
    80003742:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003744:	0009a503          	lw	a0,0(s3)
    80003748:	f4cff0ef          	jal	80002e94 <bread>
    8000374c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000374e:	06050493          	addi	s1,a0,96
    80003752:	46050913          	addi	s2,a0,1120
    80003756:	a021                	j	8000375e <itrunc+0x6c>
    80003758:	0491                	addi	s1,s1,4
    8000375a:	01248963          	beq	s1,s2,8000376c <itrunc+0x7a>
      if(a[j])
    8000375e:	408c                	lw	a1,0(s1)
    80003760:	dde5                	beqz	a1,80003758 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003762:	0009a503          	lw	a0,0(s3)
    80003766:	927ff0ef          	jal	8000308c <bfree>
    8000376a:	b7fd                	j	80003758 <itrunc+0x66>
    brelse(bp);
    8000376c:	8552                	mv	a0,s4
    8000376e:	82fff0ef          	jal	80002f9c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003772:	0889a583          	lw	a1,136(s3)
    80003776:	0009a503          	lw	a0,0(s3)
    8000377a:	913ff0ef          	jal	8000308c <bfree>
    ip->addrs[NDIRECT] = 0;
    8000377e:	0809a423          	sw	zero,136(s3)
    80003782:	6a02                	ld	s4,0(sp)
    80003784:	b75d                	j	8000372a <itrunc+0x38>

0000000080003786 <iput>:
{
    80003786:	1101                	addi	sp,sp,-32
    80003788:	ec06                	sd	ra,24(sp)
    8000378a:	e822                	sd	s0,16(sp)
    8000378c:	e426                	sd	s1,8(sp)
    8000378e:	1000                	addi	s0,sp,32
    80003790:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003792:	00017517          	auipc	a0,0x17
    80003796:	38e50513          	addi	a0,a0,910 # 8001ab20 <itable>
    8000379a:	75d020ef          	jal	800066f6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000379e:	4498                	lw	a4,8(s1)
    800037a0:	4785                	li	a5,1
    800037a2:	02f70063          	beq	a4,a5,800037c2 <iput+0x3c>
  ip->ref--;
    800037a6:	449c                	lw	a5,8(s1)
    800037a8:	37fd                	addiw	a5,a5,-1
    800037aa:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800037ac:	00017517          	auipc	a0,0x17
    800037b0:	37450513          	addi	a0,a0,884 # 8001ab20 <itable>
    800037b4:	00e030ef          	jal	800067c2 <release>
}
    800037b8:	60e2                	ld	ra,24(sp)
    800037ba:	6442                	ld	s0,16(sp)
    800037bc:	64a2                	ld	s1,8(sp)
    800037be:	6105                	addi	sp,sp,32
    800037c0:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800037c2:	44bc                	lw	a5,72(s1)
    800037c4:	d3ed                	beqz	a5,800037a6 <iput+0x20>
    800037c6:	05249783          	lh	a5,82(s1)
    800037ca:	fff1                	bnez	a5,800037a6 <iput+0x20>
    800037cc:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800037ce:	01048913          	addi	s2,s1,16
    800037d2:	854a                	mv	a0,s2
    800037d4:	151000ef          	jal	80004124 <acquiresleep>
    release(&itable.lock);
    800037d8:	00017517          	auipc	a0,0x17
    800037dc:	34850513          	addi	a0,a0,840 # 8001ab20 <itable>
    800037e0:	7e3020ef          	jal	800067c2 <release>
    itrunc(ip);
    800037e4:	8526                	mv	a0,s1
    800037e6:	f0dff0ef          	jal	800036f2 <itrunc>
    ip->type = 0;
    800037ea:	04049623          	sh	zero,76(s1)
    iupdate(ip);
    800037ee:	8526                	mv	a0,s1
    800037f0:	d61ff0ef          	jal	80003550 <iupdate>
    ip->valid = 0;
    800037f4:	0404a423          	sw	zero,72(s1)
    releasesleep(&ip->lock);
    800037f8:	854a                	mv	a0,s2
    800037fa:	171000ef          	jal	8000416a <releasesleep>
    acquire(&itable.lock);
    800037fe:	00017517          	auipc	a0,0x17
    80003802:	32250513          	addi	a0,a0,802 # 8001ab20 <itable>
    80003806:	6f1020ef          	jal	800066f6 <acquire>
    8000380a:	6902                	ld	s2,0(sp)
    8000380c:	bf69                	j	800037a6 <iput+0x20>

000000008000380e <iunlockput>:
{
    8000380e:	1101                	addi	sp,sp,-32
    80003810:	ec06                	sd	ra,24(sp)
    80003812:	e822                	sd	s0,16(sp)
    80003814:	e426                	sd	s1,8(sp)
    80003816:	1000                	addi	s0,sp,32
    80003818:	84aa                	mv	s1,a0
  iunlock(ip);
    8000381a:	e99ff0ef          	jal	800036b2 <iunlock>
  iput(ip);
    8000381e:	8526                	mv	a0,s1
    80003820:	f67ff0ef          	jal	80003786 <iput>
}
    80003824:	60e2                	ld	ra,24(sp)
    80003826:	6442                	ld	s0,16(sp)
    80003828:	64a2                	ld	s1,8(sp)
    8000382a:	6105                	addi	sp,sp,32
    8000382c:	8082                	ret

000000008000382e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000382e:	1141                	addi	sp,sp,-16
    80003830:	e422                	sd	s0,8(sp)
    80003832:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003834:	411c                	lw	a5,0(a0)
    80003836:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003838:	415c                	lw	a5,4(a0)
    8000383a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000383c:	04c51783          	lh	a5,76(a0)
    80003840:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003844:	05251783          	lh	a5,82(a0)
    80003848:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000384c:	05456783          	lwu	a5,84(a0)
    80003850:	e99c                	sd	a5,16(a1)
}
    80003852:	6422                	ld	s0,8(sp)
    80003854:	0141                	addi	sp,sp,16
    80003856:	8082                	ret

0000000080003858 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003858:	497c                	lw	a5,84(a0)
    8000385a:	0ed7eb63          	bltu	a5,a3,80003950 <readi+0xf8>
{
    8000385e:	7159                	addi	sp,sp,-112
    80003860:	f486                	sd	ra,104(sp)
    80003862:	f0a2                	sd	s0,96(sp)
    80003864:	eca6                	sd	s1,88(sp)
    80003866:	e0d2                	sd	s4,64(sp)
    80003868:	fc56                	sd	s5,56(sp)
    8000386a:	f85a                	sd	s6,48(sp)
    8000386c:	f45e                	sd	s7,40(sp)
    8000386e:	1880                	addi	s0,sp,112
    80003870:	8b2a                	mv	s6,a0
    80003872:	8bae                	mv	s7,a1
    80003874:	8a32                	mv	s4,a2
    80003876:	84b6                	mv	s1,a3
    80003878:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000387a:	9f35                	addw	a4,a4,a3
    return 0;
    8000387c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000387e:	0cd76063          	bltu	a4,a3,8000393e <readi+0xe6>
    80003882:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003884:	00e7f463          	bgeu	a5,a4,8000388c <readi+0x34>
    n = ip->size - off;
    80003888:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000388c:	080a8f63          	beqz	s5,8000392a <readi+0xd2>
    80003890:	e8ca                	sd	s2,80(sp)
    80003892:	f062                	sd	s8,32(sp)
    80003894:	ec66                	sd	s9,24(sp)
    80003896:	e86a                	sd	s10,16(sp)
    80003898:	e46e                	sd	s11,8(sp)
    8000389a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000389c:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800038a0:	5c7d                	li	s8,-1
    800038a2:	a80d                	j	800038d4 <readi+0x7c>
    800038a4:	020d1d93          	slli	s11,s10,0x20
    800038a8:	020ddd93          	srli	s11,s11,0x20
    800038ac:	06090613          	addi	a2,s2,96
    800038b0:	86ee                	mv	a3,s11
    800038b2:	963a                	add	a2,a2,a4
    800038b4:	85d2                	mv	a1,s4
    800038b6:	855e                	mv	a0,s7
    800038b8:	901fe0ef          	jal	800021b8 <either_copyout>
    800038bc:	05850763          	beq	a0,s8,8000390a <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800038c0:	854a                	mv	a0,s2
    800038c2:	edaff0ef          	jal	80002f9c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800038c6:	013d09bb          	addw	s3,s10,s3
    800038ca:	009d04bb          	addw	s1,s10,s1
    800038ce:	9a6e                	add	s4,s4,s11
    800038d0:	0559f763          	bgeu	s3,s5,8000391e <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    800038d4:	00a4d59b          	srliw	a1,s1,0xa
    800038d8:	855a                	mv	a0,s6
    800038da:	93fff0ef          	jal	80003218 <bmap>
    800038de:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800038e2:	c5b1                	beqz	a1,8000392e <readi+0xd6>
    bp = bread(ip->dev, addr);
    800038e4:	000b2503          	lw	a0,0(s6)
    800038e8:	dacff0ef          	jal	80002e94 <bread>
    800038ec:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800038ee:	3ff4f713          	andi	a4,s1,1023
    800038f2:	40ec87bb          	subw	a5,s9,a4
    800038f6:	413a86bb          	subw	a3,s5,s3
    800038fa:	8d3e                	mv	s10,a5
    800038fc:	2781                	sext.w	a5,a5
    800038fe:	0006861b          	sext.w	a2,a3
    80003902:	faf671e3          	bgeu	a2,a5,800038a4 <readi+0x4c>
    80003906:	8d36                	mv	s10,a3
    80003908:	bf71                	j	800038a4 <readi+0x4c>
      brelse(bp);
    8000390a:	854a                	mv	a0,s2
    8000390c:	e90ff0ef          	jal	80002f9c <brelse>
      tot = -1;
    80003910:	59fd                	li	s3,-1
      break;
    80003912:	6946                	ld	s2,80(sp)
    80003914:	7c02                	ld	s8,32(sp)
    80003916:	6ce2                	ld	s9,24(sp)
    80003918:	6d42                	ld	s10,16(sp)
    8000391a:	6da2                	ld	s11,8(sp)
    8000391c:	a831                	j	80003938 <readi+0xe0>
    8000391e:	6946                	ld	s2,80(sp)
    80003920:	7c02                	ld	s8,32(sp)
    80003922:	6ce2                	ld	s9,24(sp)
    80003924:	6d42                	ld	s10,16(sp)
    80003926:	6da2                	ld	s11,8(sp)
    80003928:	a801                	j	80003938 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000392a:	89d6                	mv	s3,s5
    8000392c:	a031                	j	80003938 <readi+0xe0>
    8000392e:	6946                	ld	s2,80(sp)
    80003930:	7c02                	ld	s8,32(sp)
    80003932:	6ce2                	ld	s9,24(sp)
    80003934:	6d42                	ld	s10,16(sp)
    80003936:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003938:	0009851b          	sext.w	a0,s3
    8000393c:	69a6                	ld	s3,72(sp)
}
    8000393e:	70a6                	ld	ra,104(sp)
    80003940:	7406                	ld	s0,96(sp)
    80003942:	64e6                	ld	s1,88(sp)
    80003944:	6a06                	ld	s4,64(sp)
    80003946:	7ae2                	ld	s5,56(sp)
    80003948:	7b42                	ld	s6,48(sp)
    8000394a:	7ba2                	ld	s7,40(sp)
    8000394c:	6165                	addi	sp,sp,112
    8000394e:	8082                	ret
    return 0;
    80003950:	4501                	li	a0,0
}
    80003952:	8082                	ret

0000000080003954 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003954:	497c                	lw	a5,84(a0)
    80003956:	10d7e063          	bltu	a5,a3,80003a56 <writei+0x102>
{
    8000395a:	7159                	addi	sp,sp,-112
    8000395c:	f486                	sd	ra,104(sp)
    8000395e:	f0a2                	sd	s0,96(sp)
    80003960:	e8ca                	sd	s2,80(sp)
    80003962:	e0d2                	sd	s4,64(sp)
    80003964:	fc56                	sd	s5,56(sp)
    80003966:	f85a                	sd	s6,48(sp)
    80003968:	f45e                	sd	s7,40(sp)
    8000396a:	1880                	addi	s0,sp,112
    8000396c:	8aaa                	mv	s5,a0
    8000396e:	8bae                	mv	s7,a1
    80003970:	8a32                	mv	s4,a2
    80003972:	8936                	mv	s2,a3
    80003974:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003976:	00e687bb          	addw	a5,a3,a4
    8000397a:	0ed7e063          	bltu	a5,a3,80003a5a <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000397e:	00043737          	lui	a4,0x43
    80003982:	0cf76e63          	bltu	a4,a5,80003a5e <writei+0x10a>
    80003986:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003988:	0a0b0f63          	beqz	s6,80003a46 <writei+0xf2>
    8000398c:	eca6                	sd	s1,88(sp)
    8000398e:	f062                	sd	s8,32(sp)
    80003990:	ec66                	sd	s9,24(sp)
    80003992:	e86a                	sd	s10,16(sp)
    80003994:	e46e                	sd	s11,8(sp)
    80003996:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003998:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000399c:	5c7d                	li	s8,-1
    8000399e:	a825                	j	800039d6 <writei+0x82>
    800039a0:	020d1d93          	slli	s11,s10,0x20
    800039a4:	020ddd93          	srli	s11,s11,0x20
    800039a8:	06048513          	addi	a0,s1,96
    800039ac:	86ee                	mv	a3,s11
    800039ae:	8652                	mv	a2,s4
    800039b0:	85de                	mv	a1,s7
    800039b2:	953a                	add	a0,a0,a4
    800039b4:	84ffe0ef          	jal	80002202 <either_copyin>
    800039b8:	05850a63          	beq	a0,s8,80003a0c <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    800039bc:	8526                	mv	a0,s1
    800039be:	660000ef          	jal	8000401e <log_write>
    brelse(bp);
    800039c2:	8526                	mv	a0,s1
    800039c4:	dd8ff0ef          	jal	80002f9c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800039c8:	013d09bb          	addw	s3,s10,s3
    800039cc:	012d093b          	addw	s2,s10,s2
    800039d0:	9a6e                	add	s4,s4,s11
    800039d2:	0569f063          	bgeu	s3,s6,80003a12 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800039d6:	00a9559b          	srliw	a1,s2,0xa
    800039da:	8556                	mv	a0,s5
    800039dc:	83dff0ef          	jal	80003218 <bmap>
    800039e0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800039e4:	c59d                	beqz	a1,80003a12 <writei+0xbe>
    bp = bread(ip->dev, addr);
    800039e6:	000aa503          	lw	a0,0(s5) # 1000 <_entry-0x7ffff000>
    800039ea:	caaff0ef          	jal	80002e94 <bread>
    800039ee:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800039f0:	3ff97713          	andi	a4,s2,1023
    800039f4:	40ec87bb          	subw	a5,s9,a4
    800039f8:	413b06bb          	subw	a3,s6,s3
    800039fc:	8d3e                	mv	s10,a5
    800039fe:	2781                	sext.w	a5,a5
    80003a00:	0006861b          	sext.w	a2,a3
    80003a04:	f8f67ee3          	bgeu	a2,a5,800039a0 <writei+0x4c>
    80003a08:	8d36                	mv	s10,a3
    80003a0a:	bf59                	j	800039a0 <writei+0x4c>
      brelse(bp);
    80003a0c:	8526                	mv	a0,s1
    80003a0e:	d8eff0ef          	jal	80002f9c <brelse>
  }

  if(off > ip->size)
    80003a12:	054aa783          	lw	a5,84(s5)
    80003a16:	0327fa63          	bgeu	a5,s2,80003a4a <writei+0xf6>
    ip->size = off;
    80003a1a:	052aaa23          	sw	s2,84(s5)
    80003a1e:	64e6                	ld	s1,88(sp)
    80003a20:	7c02                	ld	s8,32(sp)
    80003a22:	6ce2                	ld	s9,24(sp)
    80003a24:	6d42                	ld	s10,16(sp)
    80003a26:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003a28:	8556                	mv	a0,s5
    80003a2a:	b27ff0ef          	jal	80003550 <iupdate>

  return tot;
    80003a2e:	0009851b          	sext.w	a0,s3
    80003a32:	69a6                	ld	s3,72(sp)
}
    80003a34:	70a6                	ld	ra,104(sp)
    80003a36:	7406                	ld	s0,96(sp)
    80003a38:	6946                	ld	s2,80(sp)
    80003a3a:	6a06                	ld	s4,64(sp)
    80003a3c:	7ae2                	ld	s5,56(sp)
    80003a3e:	7b42                	ld	s6,48(sp)
    80003a40:	7ba2                	ld	s7,40(sp)
    80003a42:	6165                	addi	sp,sp,112
    80003a44:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003a46:	89da                	mv	s3,s6
    80003a48:	b7c5                	j	80003a28 <writei+0xd4>
    80003a4a:	64e6                	ld	s1,88(sp)
    80003a4c:	7c02                	ld	s8,32(sp)
    80003a4e:	6ce2                	ld	s9,24(sp)
    80003a50:	6d42                	ld	s10,16(sp)
    80003a52:	6da2                	ld	s11,8(sp)
    80003a54:	bfd1                	j	80003a28 <writei+0xd4>
    return -1;
    80003a56:	557d                	li	a0,-1
}
    80003a58:	8082                	ret
    return -1;
    80003a5a:	557d                	li	a0,-1
    80003a5c:	bfe1                	j	80003a34 <writei+0xe0>
    return -1;
    80003a5e:	557d                	li	a0,-1
    80003a60:	bfd1                	j	80003a34 <writei+0xe0>

0000000080003a62 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003a62:	1141                	addi	sp,sp,-16
    80003a64:	e406                	sd	ra,8(sp)
    80003a66:	e022                	sd	s0,0(sp)
    80003a68:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003a6a:	4639                	li	a2,14
    80003a6c:	b0ffc0ef          	jal	8000057a <strncmp>
}
    80003a70:	60a2                	ld	ra,8(sp)
    80003a72:	6402                	ld	s0,0(sp)
    80003a74:	0141                	addi	sp,sp,16
    80003a76:	8082                	ret

0000000080003a78 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003a78:	7139                	addi	sp,sp,-64
    80003a7a:	fc06                	sd	ra,56(sp)
    80003a7c:	f822                	sd	s0,48(sp)
    80003a7e:	f426                	sd	s1,40(sp)
    80003a80:	f04a                	sd	s2,32(sp)
    80003a82:	ec4e                	sd	s3,24(sp)
    80003a84:	e852                	sd	s4,16(sp)
    80003a86:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003a88:	04c51703          	lh	a4,76(a0)
    80003a8c:	4785                	li	a5,1
    80003a8e:	00f71a63          	bne	a4,a5,80003aa2 <dirlookup+0x2a>
    80003a92:	892a                	mv	s2,a0
    80003a94:	89ae                	mv	s3,a1
    80003a96:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a98:	497c                	lw	a5,84(a0)
    80003a9a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003a9c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a9e:	e39d                	bnez	a5,80003ac4 <dirlookup+0x4c>
    80003aa0:	a095                	j	80003b04 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003aa2:	00005517          	auipc	a0,0x5
    80003aa6:	f4e50513          	addi	a0,a0,-178 # 800089f0 <etext+0x9f0>
    80003aaa:	0f9020ef          	jal	800063a2 <panic>
      panic("dirlookup read");
    80003aae:	00005517          	auipc	a0,0x5
    80003ab2:	f5a50513          	addi	a0,a0,-166 # 80008a08 <etext+0xa08>
    80003ab6:	0ed020ef          	jal	800063a2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003aba:	24c1                	addiw	s1,s1,16
    80003abc:	05492783          	lw	a5,84(s2)
    80003ac0:	04f4f163          	bgeu	s1,a5,80003b02 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ac4:	4741                	li	a4,16
    80003ac6:	86a6                	mv	a3,s1
    80003ac8:	fc040613          	addi	a2,s0,-64
    80003acc:	4581                	li	a1,0
    80003ace:	854a                	mv	a0,s2
    80003ad0:	d89ff0ef          	jal	80003858 <readi>
    80003ad4:	47c1                	li	a5,16
    80003ad6:	fcf51ce3          	bne	a0,a5,80003aae <dirlookup+0x36>
    if(de.inum == 0)
    80003ada:	fc045783          	lhu	a5,-64(s0)
    80003ade:	dff1                	beqz	a5,80003aba <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003ae0:	fc240593          	addi	a1,s0,-62
    80003ae4:	854e                	mv	a0,s3
    80003ae6:	f7dff0ef          	jal	80003a62 <namecmp>
    80003aea:	f961                	bnez	a0,80003aba <dirlookup+0x42>
      if(poff)
    80003aec:	000a0463          	beqz	s4,80003af4 <dirlookup+0x7c>
        *poff = off;
    80003af0:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003af4:	fc045583          	lhu	a1,-64(s0)
    80003af8:	00092503          	lw	a0,0(s2)
    80003afc:	ff0ff0ef          	jal	800032ec <iget>
    80003b00:	a011                	j	80003b04 <dirlookup+0x8c>
  return 0;
    80003b02:	4501                	li	a0,0
}
    80003b04:	70e2                	ld	ra,56(sp)
    80003b06:	7442                	ld	s0,48(sp)
    80003b08:	74a2                	ld	s1,40(sp)
    80003b0a:	7902                	ld	s2,32(sp)
    80003b0c:	69e2                	ld	s3,24(sp)
    80003b0e:	6a42                	ld	s4,16(sp)
    80003b10:	6121                	addi	sp,sp,64
    80003b12:	8082                	ret

0000000080003b14 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003b14:	711d                	addi	sp,sp,-96
    80003b16:	ec86                	sd	ra,88(sp)
    80003b18:	e8a2                	sd	s0,80(sp)
    80003b1a:	e4a6                	sd	s1,72(sp)
    80003b1c:	e0ca                	sd	s2,64(sp)
    80003b1e:	fc4e                	sd	s3,56(sp)
    80003b20:	f852                	sd	s4,48(sp)
    80003b22:	f456                	sd	s5,40(sp)
    80003b24:	f05a                	sd	s6,32(sp)
    80003b26:	ec5e                	sd	s7,24(sp)
    80003b28:	e862                	sd	s8,16(sp)
    80003b2a:	e466                	sd	s9,8(sp)
    80003b2c:	1080                	addi	s0,sp,96
    80003b2e:	84aa                	mv	s1,a0
    80003b30:	8b2e                	mv	s6,a1
    80003b32:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003b34:	00054703          	lbu	a4,0(a0)
    80003b38:	02f00793          	li	a5,47
    80003b3c:	00f70e63          	beq	a4,a5,80003b58 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003b40:	c79fd0ef          	jal	800017b8 <myproc>
    80003b44:	15853503          	ld	a0,344(a0)
    80003b48:	a87ff0ef          	jal	800035ce <idup>
    80003b4c:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003b4e:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003b52:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003b54:	4b85                	li	s7,1
    80003b56:	a871                	j	80003bf2 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003b58:	4585                	li	a1,1
    80003b5a:	4505                	li	a0,1
    80003b5c:	f90ff0ef          	jal	800032ec <iget>
    80003b60:	8a2a                	mv	s4,a0
    80003b62:	b7f5                	j	80003b4e <namex+0x3a>
      iunlockput(ip);
    80003b64:	8552                	mv	a0,s4
    80003b66:	ca9ff0ef          	jal	8000380e <iunlockput>
      return 0;
    80003b6a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003b6c:	8552                	mv	a0,s4
    80003b6e:	60e6                	ld	ra,88(sp)
    80003b70:	6446                	ld	s0,80(sp)
    80003b72:	64a6                	ld	s1,72(sp)
    80003b74:	6906                	ld	s2,64(sp)
    80003b76:	79e2                	ld	s3,56(sp)
    80003b78:	7a42                	ld	s4,48(sp)
    80003b7a:	7aa2                	ld	s5,40(sp)
    80003b7c:	7b02                	ld	s6,32(sp)
    80003b7e:	6be2                	ld	s7,24(sp)
    80003b80:	6c42                	ld	s8,16(sp)
    80003b82:	6ca2                	ld	s9,8(sp)
    80003b84:	6125                	addi	sp,sp,96
    80003b86:	8082                	ret
      iunlock(ip);
    80003b88:	8552                	mv	a0,s4
    80003b8a:	b29ff0ef          	jal	800036b2 <iunlock>
      return ip;
    80003b8e:	bff9                	j	80003b6c <namex+0x58>
      iunlockput(ip);
    80003b90:	8552                	mv	a0,s4
    80003b92:	c7dff0ef          	jal	8000380e <iunlockput>
      return 0;
    80003b96:	8a4e                	mv	s4,s3
    80003b98:	bfd1                	j	80003b6c <namex+0x58>
  len = path - s;
    80003b9a:	40998633          	sub	a2,s3,s1
    80003b9e:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003ba2:	099c5063          	bge	s8,s9,80003c22 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003ba6:	4639                	li	a2,14
    80003ba8:	85a6                	mv	a1,s1
    80003baa:	8556                	mv	a0,s5
    80003bac:	95ffc0ef          	jal	8000050a <memmove>
    80003bb0:	84ce                	mv	s1,s3
  while(*path == '/')
    80003bb2:	0004c783          	lbu	a5,0(s1)
    80003bb6:	01279763          	bne	a5,s2,80003bc4 <namex+0xb0>
    path++;
    80003bba:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003bbc:	0004c783          	lbu	a5,0(s1)
    80003bc0:	ff278de3          	beq	a5,s2,80003bba <namex+0xa6>
    ilock(ip);
    80003bc4:	8552                	mv	a0,s4
    80003bc6:	a3fff0ef          	jal	80003604 <ilock>
    if(ip->type != T_DIR){
    80003bca:	04ca1783          	lh	a5,76(s4)
    80003bce:	f9779be3          	bne	a5,s7,80003b64 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003bd2:	000b0563          	beqz	s6,80003bdc <namex+0xc8>
    80003bd6:	0004c783          	lbu	a5,0(s1)
    80003bda:	d7dd                	beqz	a5,80003b88 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003bdc:	4601                	li	a2,0
    80003bde:	85d6                	mv	a1,s5
    80003be0:	8552                	mv	a0,s4
    80003be2:	e97ff0ef          	jal	80003a78 <dirlookup>
    80003be6:	89aa                	mv	s3,a0
    80003be8:	d545                	beqz	a0,80003b90 <namex+0x7c>
    iunlockput(ip);
    80003bea:	8552                	mv	a0,s4
    80003bec:	c23ff0ef          	jal	8000380e <iunlockput>
    ip = next;
    80003bf0:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003bf2:	0004c783          	lbu	a5,0(s1)
    80003bf6:	01279763          	bne	a5,s2,80003c04 <namex+0xf0>
    path++;
    80003bfa:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003bfc:	0004c783          	lbu	a5,0(s1)
    80003c00:	ff278de3          	beq	a5,s2,80003bfa <namex+0xe6>
  if(*path == 0)
    80003c04:	cb8d                	beqz	a5,80003c36 <namex+0x122>
  while(*path != '/' && *path != 0)
    80003c06:	0004c783          	lbu	a5,0(s1)
    80003c0a:	89a6                	mv	s3,s1
  len = path - s;
    80003c0c:	4c81                	li	s9,0
    80003c0e:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003c10:	01278963          	beq	a5,s2,80003c22 <namex+0x10e>
    80003c14:	d3d9                	beqz	a5,80003b9a <namex+0x86>
    path++;
    80003c16:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003c18:	0009c783          	lbu	a5,0(s3)
    80003c1c:	ff279ce3          	bne	a5,s2,80003c14 <namex+0x100>
    80003c20:	bfad                	j	80003b9a <namex+0x86>
    memmove(name, s, len);
    80003c22:	2601                	sext.w	a2,a2
    80003c24:	85a6                	mv	a1,s1
    80003c26:	8556                	mv	a0,s5
    80003c28:	8e3fc0ef          	jal	8000050a <memmove>
    name[len] = 0;
    80003c2c:	9cd6                	add	s9,s9,s5
    80003c2e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003c32:	84ce                	mv	s1,s3
    80003c34:	bfbd                	j	80003bb2 <namex+0x9e>
  if(nameiparent){
    80003c36:	f20b0be3          	beqz	s6,80003b6c <namex+0x58>
    iput(ip);
    80003c3a:	8552                	mv	a0,s4
    80003c3c:	b4bff0ef          	jal	80003786 <iput>
    return 0;
    80003c40:	4a01                	li	s4,0
    80003c42:	b72d                	j	80003b6c <namex+0x58>

0000000080003c44 <dirlink>:
{
    80003c44:	7139                	addi	sp,sp,-64
    80003c46:	fc06                	sd	ra,56(sp)
    80003c48:	f822                	sd	s0,48(sp)
    80003c4a:	f04a                	sd	s2,32(sp)
    80003c4c:	ec4e                	sd	s3,24(sp)
    80003c4e:	e852                	sd	s4,16(sp)
    80003c50:	0080                	addi	s0,sp,64
    80003c52:	892a                	mv	s2,a0
    80003c54:	8a2e                	mv	s4,a1
    80003c56:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003c58:	4601                	li	a2,0
    80003c5a:	e1fff0ef          	jal	80003a78 <dirlookup>
    80003c5e:	e535                	bnez	a0,80003cca <dirlink+0x86>
    80003c60:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c62:	05492483          	lw	s1,84(s2)
    80003c66:	c48d                	beqz	s1,80003c90 <dirlink+0x4c>
    80003c68:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c6a:	4741                	li	a4,16
    80003c6c:	86a6                	mv	a3,s1
    80003c6e:	fc040613          	addi	a2,s0,-64
    80003c72:	4581                	li	a1,0
    80003c74:	854a                	mv	a0,s2
    80003c76:	be3ff0ef          	jal	80003858 <readi>
    80003c7a:	47c1                	li	a5,16
    80003c7c:	04f51b63          	bne	a0,a5,80003cd2 <dirlink+0x8e>
    if(de.inum == 0)
    80003c80:	fc045783          	lhu	a5,-64(s0)
    80003c84:	c791                	beqz	a5,80003c90 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c86:	24c1                	addiw	s1,s1,16
    80003c88:	05492783          	lw	a5,84(s2)
    80003c8c:	fcf4efe3          	bltu	s1,a5,80003c6a <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003c90:	4639                	li	a2,14
    80003c92:	85d2                	mv	a1,s4
    80003c94:	fc240513          	addi	a0,s0,-62
    80003c98:	919fc0ef          	jal	800005b0 <strncpy>
  de.inum = inum;
    80003c9c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ca0:	4741                	li	a4,16
    80003ca2:	86a6                	mv	a3,s1
    80003ca4:	fc040613          	addi	a2,s0,-64
    80003ca8:	4581                	li	a1,0
    80003caa:	854a                	mv	a0,s2
    80003cac:	ca9ff0ef          	jal	80003954 <writei>
    80003cb0:	1541                	addi	a0,a0,-16
    80003cb2:	00a03533          	snez	a0,a0
    80003cb6:	40a00533          	neg	a0,a0
    80003cba:	74a2                	ld	s1,40(sp)
}
    80003cbc:	70e2                	ld	ra,56(sp)
    80003cbe:	7442                	ld	s0,48(sp)
    80003cc0:	7902                	ld	s2,32(sp)
    80003cc2:	69e2                	ld	s3,24(sp)
    80003cc4:	6a42                	ld	s4,16(sp)
    80003cc6:	6121                	addi	sp,sp,64
    80003cc8:	8082                	ret
    iput(ip);
    80003cca:	abdff0ef          	jal	80003786 <iput>
    return -1;
    80003cce:	557d                	li	a0,-1
    80003cd0:	b7f5                	j	80003cbc <dirlink+0x78>
      panic("dirlink read");
    80003cd2:	00005517          	auipc	a0,0x5
    80003cd6:	d4650513          	addi	a0,a0,-698 # 80008a18 <etext+0xa18>
    80003cda:	6c8020ef          	jal	800063a2 <panic>

0000000080003cde <namei>:

struct inode*
namei(char *path)
{
    80003cde:	1101                	addi	sp,sp,-32
    80003ce0:	ec06                	sd	ra,24(sp)
    80003ce2:	e822                	sd	s0,16(sp)
    80003ce4:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003ce6:	fe040613          	addi	a2,s0,-32
    80003cea:	4581                	li	a1,0
    80003cec:	e29ff0ef          	jal	80003b14 <namex>
}
    80003cf0:	60e2                	ld	ra,24(sp)
    80003cf2:	6442                	ld	s0,16(sp)
    80003cf4:	6105                	addi	sp,sp,32
    80003cf6:	8082                	ret

0000000080003cf8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003cf8:	1141                	addi	sp,sp,-16
    80003cfa:	e406                	sd	ra,8(sp)
    80003cfc:	e022                	sd	s0,0(sp)
    80003cfe:	0800                	addi	s0,sp,16
    80003d00:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003d02:	4585                	li	a1,1
    80003d04:	e11ff0ef          	jal	80003b14 <namex>
}
    80003d08:	60a2                	ld	ra,8(sp)
    80003d0a:	6402                	ld	s0,0(sp)
    80003d0c:	0141                	addi	sp,sp,16
    80003d0e:	8082                	ret

0000000080003d10 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003d10:	1101                	addi	sp,sp,-32
    80003d12:	ec06                	sd	ra,24(sp)
    80003d14:	e822                	sd	s0,16(sp)
    80003d16:	e426                	sd	s1,8(sp)
    80003d18:	e04a                	sd	s2,0(sp)
    80003d1a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003d1c:	00019917          	auipc	s2,0x19
    80003d20:	a4490913          	addi	s2,s2,-1468 # 8001c760 <log>
    80003d24:	02092583          	lw	a1,32(s2)
    80003d28:	03092503          	lw	a0,48(s2)
    80003d2c:	968ff0ef          	jal	80002e94 <bread>
    80003d30:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003d32:	03492603          	lw	a2,52(s2)
    80003d36:	d130                	sw	a2,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003d38:	00c05f63          	blez	a2,80003d56 <write_head+0x46>
    80003d3c:	00019717          	auipc	a4,0x19
    80003d40:	a5c70713          	addi	a4,a4,-1444 # 8001c798 <log+0x38>
    80003d44:	87aa                	mv	a5,a0
    80003d46:	060a                	slli	a2,a2,0x2
    80003d48:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003d4a:	4314                	lw	a3,0(a4)
    80003d4c:	d3f4                	sw	a3,100(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003d4e:	0711                	addi	a4,a4,4
    80003d50:	0791                	addi	a5,a5,4
    80003d52:	fec79ce3          	bne	a5,a2,80003d4a <write_head+0x3a>
  }
  bwrite(buf);
    80003d56:	8526                	mv	a0,s1
    80003d58:	a12ff0ef          	jal	80002f6a <bwrite>
  brelse(buf);
    80003d5c:	8526                	mv	a0,s1
    80003d5e:	a3eff0ef          	jal	80002f9c <brelse>
}
    80003d62:	60e2                	ld	ra,24(sp)
    80003d64:	6442                	ld	s0,16(sp)
    80003d66:	64a2                	ld	s1,8(sp)
    80003d68:	6902                	ld	s2,0(sp)
    80003d6a:	6105                	addi	sp,sp,32
    80003d6c:	8082                	ret

0000000080003d6e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d6e:	00019797          	auipc	a5,0x19
    80003d72:	a267a783          	lw	a5,-1498(a5) # 8001c794 <log+0x34>
    80003d76:	08f05f63          	blez	a5,80003e14 <install_trans+0xa6>
{
    80003d7a:	7139                	addi	sp,sp,-64
    80003d7c:	fc06                	sd	ra,56(sp)
    80003d7e:	f822                	sd	s0,48(sp)
    80003d80:	f426                	sd	s1,40(sp)
    80003d82:	f04a                	sd	s2,32(sp)
    80003d84:	ec4e                	sd	s3,24(sp)
    80003d86:	e852                	sd	s4,16(sp)
    80003d88:	e456                	sd	s5,8(sp)
    80003d8a:	e05a                	sd	s6,0(sp)
    80003d8c:	0080                	addi	s0,sp,64
    80003d8e:	8b2a                	mv	s6,a0
    80003d90:	00019a97          	auipc	s5,0x19
    80003d94:	a08a8a93          	addi	s5,s5,-1528 # 8001c798 <log+0x38>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d98:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003d9a:	00019997          	auipc	s3,0x19
    80003d9e:	9c698993          	addi	s3,s3,-1594 # 8001c760 <log>
    80003da2:	a829                	j	80003dbc <install_trans+0x4e>
    brelse(lbuf);
    80003da4:	854a                	mv	a0,s2
    80003da6:	9f6ff0ef          	jal	80002f9c <brelse>
    brelse(dbuf);
    80003daa:	8526                	mv	a0,s1
    80003dac:	9f0ff0ef          	jal	80002f9c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003db0:	2a05                	addiw	s4,s4,1
    80003db2:	0a91                	addi	s5,s5,4
    80003db4:	0349a783          	lw	a5,52(s3)
    80003db8:	04fa5463          	bge	s4,a5,80003e00 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003dbc:	0209a583          	lw	a1,32(s3)
    80003dc0:	014585bb          	addw	a1,a1,s4
    80003dc4:	2585                	addiw	a1,a1,1
    80003dc6:	0309a503          	lw	a0,48(s3)
    80003dca:	8caff0ef          	jal	80002e94 <bread>
    80003dce:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003dd0:	000aa583          	lw	a1,0(s5)
    80003dd4:	0309a503          	lw	a0,48(s3)
    80003dd8:	8bcff0ef          	jal	80002e94 <bread>
    80003ddc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003dde:	40000613          	li	a2,1024
    80003de2:	06090593          	addi	a1,s2,96
    80003de6:	06050513          	addi	a0,a0,96
    80003dea:	f20fc0ef          	jal	8000050a <memmove>
    bwrite(dbuf);  // write dst to disk
    80003dee:	8526                	mv	a0,s1
    80003df0:	97aff0ef          	jal	80002f6a <bwrite>
    if(recovering == 0)
    80003df4:	fa0b18e3          	bnez	s6,80003da4 <install_trans+0x36>
      bunpin(dbuf);
    80003df8:	8526                	mv	a0,s1
    80003dfa:	a5eff0ef          	jal	80003058 <bunpin>
    80003dfe:	b75d                	j	80003da4 <install_trans+0x36>
}
    80003e00:	70e2                	ld	ra,56(sp)
    80003e02:	7442                	ld	s0,48(sp)
    80003e04:	74a2                	ld	s1,40(sp)
    80003e06:	7902                	ld	s2,32(sp)
    80003e08:	69e2                	ld	s3,24(sp)
    80003e0a:	6a42                	ld	s4,16(sp)
    80003e0c:	6aa2                	ld	s5,8(sp)
    80003e0e:	6b02                	ld	s6,0(sp)
    80003e10:	6121                	addi	sp,sp,64
    80003e12:	8082                	ret
    80003e14:	8082                	ret

0000000080003e16 <initlog>:
{
    80003e16:	7179                	addi	sp,sp,-48
    80003e18:	f406                	sd	ra,40(sp)
    80003e1a:	f022                	sd	s0,32(sp)
    80003e1c:	ec26                	sd	s1,24(sp)
    80003e1e:	e84a                	sd	s2,16(sp)
    80003e20:	e44e                	sd	s3,8(sp)
    80003e22:	1800                	addi	s0,sp,48
    80003e24:	892a                	mv	s2,a0
    80003e26:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003e28:	00019497          	auipc	s1,0x19
    80003e2c:	93848493          	addi	s1,s1,-1736 # 8001c760 <log>
    80003e30:	00005597          	auipc	a1,0x5
    80003e34:	bf858593          	addi	a1,a1,-1032 # 80008a28 <etext+0xa28>
    80003e38:	8526                	mv	a0,s1
    80003e3a:	1c5020ef          	jal	800067fe <initlock>
  log.start = sb->logstart;
    80003e3e:	0149a583          	lw	a1,20(s3)
    80003e42:	d08c                	sw	a1,32(s1)
  log.size = sb->nlog;
    80003e44:	0109a783          	lw	a5,16(s3)
    80003e48:	d0dc                	sw	a5,36(s1)
  log.dev = dev;
    80003e4a:	0324a823          	sw	s2,48(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003e4e:	854a                	mv	a0,s2
    80003e50:	844ff0ef          	jal	80002e94 <bread>
  log.lh.n = lh->n;
    80003e54:	5130                	lw	a2,96(a0)
    80003e56:	d8d0                	sw	a2,52(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003e58:	00c05f63          	blez	a2,80003e76 <initlog+0x60>
    80003e5c:	87aa                	mv	a5,a0
    80003e5e:	00019717          	auipc	a4,0x19
    80003e62:	93a70713          	addi	a4,a4,-1734 # 8001c798 <log+0x38>
    80003e66:	060a                	slli	a2,a2,0x2
    80003e68:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003e6a:	53f4                	lw	a3,100(a5)
    80003e6c:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003e6e:	0791                	addi	a5,a5,4
    80003e70:	0711                	addi	a4,a4,4
    80003e72:	fec79ce3          	bne	a5,a2,80003e6a <initlog+0x54>
  brelse(buf);
    80003e76:	926ff0ef          	jal	80002f9c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003e7a:	4505                	li	a0,1
    80003e7c:	ef3ff0ef          	jal	80003d6e <install_trans>
  log.lh.n = 0;
    80003e80:	00019797          	auipc	a5,0x19
    80003e84:	9007aa23          	sw	zero,-1772(a5) # 8001c794 <log+0x34>
  write_head(); // clear the log
    80003e88:	e89ff0ef          	jal	80003d10 <write_head>
}
    80003e8c:	70a2                	ld	ra,40(sp)
    80003e8e:	7402                	ld	s0,32(sp)
    80003e90:	64e2                	ld	s1,24(sp)
    80003e92:	6942                	ld	s2,16(sp)
    80003e94:	69a2                	ld	s3,8(sp)
    80003e96:	6145                	addi	sp,sp,48
    80003e98:	8082                	ret

0000000080003e9a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003e9a:	1101                	addi	sp,sp,-32
    80003e9c:	ec06                	sd	ra,24(sp)
    80003e9e:	e822                	sd	s0,16(sp)
    80003ea0:	e426                	sd	s1,8(sp)
    80003ea2:	e04a                	sd	s2,0(sp)
    80003ea4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003ea6:	00019517          	auipc	a0,0x19
    80003eaa:	8ba50513          	addi	a0,a0,-1862 # 8001c760 <log>
    80003eae:	049020ef          	jal	800066f6 <acquire>
  while(1){
    if(log.committing){
    80003eb2:	00019497          	auipc	s1,0x19
    80003eb6:	8ae48493          	addi	s1,s1,-1874 # 8001c760 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003eba:	4979                	li	s2,30
    80003ebc:	a029                	j	80003ec6 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003ebe:	85a6                	mv	a1,s1
    80003ec0:	8526                	mv	a0,s1
    80003ec2:	f9bfd0ef          	jal	80001e5c <sleep>
    if(log.committing){
    80003ec6:	54dc                	lw	a5,44(s1)
    80003ec8:	fbfd                	bnez	a5,80003ebe <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003eca:	5498                	lw	a4,40(s1)
    80003ecc:	2705                	addiw	a4,a4,1
    80003ece:	0027179b          	slliw	a5,a4,0x2
    80003ed2:	9fb9                	addw	a5,a5,a4
    80003ed4:	0017979b          	slliw	a5,a5,0x1
    80003ed8:	58d4                	lw	a3,52(s1)
    80003eda:	9fb5                	addw	a5,a5,a3
    80003edc:	00f95763          	bge	s2,a5,80003eea <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003ee0:	85a6                	mv	a1,s1
    80003ee2:	8526                	mv	a0,s1
    80003ee4:	f79fd0ef          	jal	80001e5c <sleep>
    80003ee8:	bff9                	j	80003ec6 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003eea:	00019517          	auipc	a0,0x19
    80003eee:	87650513          	addi	a0,a0,-1930 # 8001c760 <log>
    80003ef2:	d518                	sw	a4,40(a0)
      release(&log.lock);
    80003ef4:	0cf020ef          	jal	800067c2 <release>
      break;
    }
  }
}
    80003ef8:	60e2                	ld	ra,24(sp)
    80003efa:	6442                	ld	s0,16(sp)
    80003efc:	64a2                	ld	s1,8(sp)
    80003efe:	6902                	ld	s2,0(sp)
    80003f00:	6105                	addi	sp,sp,32
    80003f02:	8082                	ret

0000000080003f04 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003f04:	7139                	addi	sp,sp,-64
    80003f06:	fc06                	sd	ra,56(sp)
    80003f08:	f822                	sd	s0,48(sp)
    80003f0a:	f426                	sd	s1,40(sp)
    80003f0c:	f04a                	sd	s2,32(sp)
    80003f0e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003f10:	00019497          	auipc	s1,0x19
    80003f14:	85048493          	addi	s1,s1,-1968 # 8001c760 <log>
    80003f18:	8526                	mv	a0,s1
    80003f1a:	7dc020ef          	jal	800066f6 <acquire>
  log.outstanding -= 1;
    80003f1e:	549c                	lw	a5,40(s1)
    80003f20:	37fd                	addiw	a5,a5,-1
    80003f22:	0007891b          	sext.w	s2,a5
    80003f26:	d49c                	sw	a5,40(s1)
  if(log.committing)
    80003f28:	54dc                	lw	a5,44(s1)
    80003f2a:	ef9d                	bnez	a5,80003f68 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003f2c:	04091763          	bnez	s2,80003f7a <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003f30:	00019497          	auipc	s1,0x19
    80003f34:	83048493          	addi	s1,s1,-2000 # 8001c760 <log>
    80003f38:	4785                	li	a5,1
    80003f3a:	d4dc                	sw	a5,44(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003f3c:	8526                	mv	a0,s1
    80003f3e:	085020ef          	jal	800067c2 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003f42:	58dc                	lw	a5,52(s1)
    80003f44:	04f04b63          	bgtz	a5,80003f9a <end_op+0x96>
    acquire(&log.lock);
    80003f48:	00019497          	auipc	s1,0x19
    80003f4c:	81848493          	addi	s1,s1,-2024 # 8001c760 <log>
    80003f50:	8526                	mv	a0,s1
    80003f52:	7a4020ef          	jal	800066f6 <acquire>
    log.committing = 0;
    80003f56:	0204a623          	sw	zero,44(s1)
    wakeup(&log);
    80003f5a:	8526                	mv	a0,s1
    80003f5c:	f4dfd0ef          	jal	80001ea8 <wakeup>
    release(&log.lock);
    80003f60:	8526                	mv	a0,s1
    80003f62:	061020ef          	jal	800067c2 <release>
}
    80003f66:	a025                	j	80003f8e <end_op+0x8a>
    80003f68:	ec4e                	sd	s3,24(sp)
    80003f6a:	e852                	sd	s4,16(sp)
    80003f6c:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003f6e:	00005517          	auipc	a0,0x5
    80003f72:	ac250513          	addi	a0,a0,-1342 # 80008a30 <etext+0xa30>
    80003f76:	42c020ef          	jal	800063a2 <panic>
    wakeup(&log);
    80003f7a:	00018497          	auipc	s1,0x18
    80003f7e:	7e648493          	addi	s1,s1,2022 # 8001c760 <log>
    80003f82:	8526                	mv	a0,s1
    80003f84:	f25fd0ef          	jal	80001ea8 <wakeup>
  release(&log.lock);
    80003f88:	8526                	mv	a0,s1
    80003f8a:	039020ef          	jal	800067c2 <release>
}
    80003f8e:	70e2                	ld	ra,56(sp)
    80003f90:	7442                	ld	s0,48(sp)
    80003f92:	74a2                	ld	s1,40(sp)
    80003f94:	7902                	ld	s2,32(sp)
    80003f96:	6121                	addi	sp,sp,64
    80003f98:	8082                	ret
    80003f9a:	ec4e                	sd	s3,24(sp)
    80003f9c:	e852                	sd	s4,16(sp)
    80003f9e:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fa0:	00018a97          	auipc	s5,0x18
    80003fa4:	7f8a8a93          	addi	s5,s5,2040 # 8001c798 <log+0x38>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003fa8:	00018a17          	auipc	s4,0x18
    80003fac:	7b8a0a13          	addi	s4,s4,1976 # 8001c760 <log>
    80003fb0:	020a2583          	lw	a1,32(s4)
    80003fb4:	012585bb          	addw	a1,a1,s2
    80003fb8:	2585                	addiw	a1,a1,1
    80003fba:	030a2503          	lw	a0,48(s4)
    80003fbe:	ed7fe0ef          	jal	80002e94 <bread>
    80003fc2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003fc4:	000aa583          	lw	a1,0(s5)
    80003fc8:	030a2503          	lw	a0,48(s4)
    80003fcc:	ec9fe0ef          	jal	80002e94 <bread>
    80003fd0:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003fd2:	40000613          	li	a2,1024
    80003fd6:	06050593          	addi	a1,a0,96
    80003fda:	06048513          	addi	a0,s1,96
    80003fde:	d2cfc0ef          	jal	8000050a <memmove>
    bwrite(to);  // write the log
    80003fe2:	8526                	mv	a0,s1
    80003fe4:	f87fe0ef          	jal	80002f6a <bwrite>
    brelse(from);
    80003fe8:	854e                	mv	a0,s3
    80003fea:	fb3fe0ef          	jal	80002f9c <brelse>
    brelse(to);
    80003fee:	8526                	mv	a0,s1
    80003ff0:	fadfe0ef          	jal	80002f9c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ff4:	2905                	addiw	s2,s2,1
    80003ff6:	0a91                	addi	s5,s5,4
    80003ff8:	034a2783          	lw	a5,52(s4)
    80003ffc:	faf94ae3          	blt	s2,a5,80003fb0 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004000:	d11ff0ef          	jal	80003d10 <write_head>
    install_trans(0); // Now install writes to home locations
    80004004:	4501                	li	a0,0
    80004006:	d69ff0ef          	jal	80003d6e <install_trans>
    log.lh.n = 0;
    8000400a:	00018797          	auipc	a5,0x18
    8000400e:	7807a523          	sw	zero,1930(a5) # 8001c794 <log+0x34>
    write_head();    // Erase the transaction from the log
    80004012:	cffff0ef          	jal	80003d10 <write_head>
    80004016:	69e2                	ld	s3,24(sp)
    80004018:	6a42                	ld	s4,16(sp)
    8000401a:	6aa2                	ld	s5,8(sp)
    8000401c:	b735                	j	80003f48 <end_op+0x44>

000000008000401e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000401e:	1101                	addi	sp,sp,-32
    80004020:	ec06                	sd	ra,24(sp)
    80004022:	e822                	sd	s0,16(sp)
    80004024:	e426                	sd	s1,8(sp)
    80004026:	e04a                	sd	s2,0(sp)
    80004028:	1000                	addi	s0,sp,32
    8000402a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000402c:	00018917          	auipc	s2,0x18
    80004030:	73490913          	addi	s2,s2,1844 # 8001c760 <log>
    80004034:	854a                	mv	a0,s2
    80004036:	6c0020ef          	jal	800066f6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000403a:	03492603          	lw	a2,52(s2)
    8000403e:	47f5                	li	a5,29
    80004040:	06c7c363          	blt	a5,a2,800040a6 <log_write+0x88>
    80004044:	00018797          	auipc	a5,0x18
    80004048:	7407a783          	lw	a5,1856(a5) # 8001c784 <log+0x24>
    8000404c:	37fd                	addiw	a5,a5,-1
    8000404e:	04f65c63          	bge	a2,a5,800040a6 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004052:	00018797          	auipc	a5,0x18
    80004056:	7367a783          	lw	a5,1846(a5) # 8001c788 <log+0x28>
    8000405a:	04f05c63          	blez	a5,800040b2 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000405e:	4781                	li	a5,0
    80004060:	04c05f63          	blez	a2,800040be <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004064:	44cc                	lw	a1,12(s1)
    80004066:	00018717          	auipc	a4,0x18
    8000406a:	73270713          	addi	a4,a4,1842 # 8001c798 <log+0x38>
  for (i = 0; i < log.lh.n; i++) {
    8000406e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004070:	4314                	lw	a3,0(a4)
    80004072:	04b68663          	beq	a3,a1,800040be <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80004076:	2785                	addiw	a5,a5,1
    80004078:	0711                	addi	a4,a4,4
    8000407a:	fef61be3          	bne	a2,a5,80004070 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000407e:	0631                	addi	a2,a2,12
    80004080:	060a                	slli	a2,a2,0x2
    80004082:	00018797          	auipc	a5,0x18
    80004086:	6de78793          	addi	a5,a5,1758 # 8001c760 <log>
    8000408a:	97b2                	add	a5,a5,a2
    8000408c:	44d8                	lw	a4,12(s1)
    8000408e:	c798                	sw	a4,8(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004090:	8526                	mv	a0,s1
    80004092:	f93fe0ef          	jal	80003024 <bpin>
    log.lh.n++;
    80004096:	00018717          	auipc	a4,0x18
    8000409a:	6ca70713          	addi	a4,a4,1738 # 8001c760 <log>
    8000409e:	5b5c                	lw	a5,52(a4)
    800040a0:	2785                	addiw	a5,a5,1
    800040a2:	db5c                	sw	a5,52(a4)
    800040a4:	a80d                	j	800040d6 <log_write+0xb8>
    panic("too big a transaction");
    800040a6:	00005517          	auipc	a0,0x5
    800040aa:	99a50513          	addi	a0,a0,-1638 # 80008a40 <etext+0xa40>
    800040ae:	2f4020ef          	jal	800063a2 <panic>
    panic("log_write outside of trans");
    800040b2:	00005517          	auipc	a0,0x5
    800040b6:	9a650513          	addi	a0,a0,-1626 # 80008a58 <etext+0xa58>
    800040ba:	2e8020ef          	jal	800063a2 <panic>
  log.lh.block[i] = b->blockno;
    800040be:	00c78693          	addi	a3,a5,12
    800040c2:	068a                	slli	a3,a3,0x2
    800040c4:	00018717          	auipc	a4,0x18
    800040c8:	69c70713          	addi	a4,a4,1692 # 8001c760 <log>
    800040cc:	9736                	add	a4,a4,a3
    800040ce:	44d4                	lw	a3,12(s1)
    800040d0:	c714                	sw	a3,8(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800040d2:	faf60fe3          	beq	a2,a5,80004090 <log_write+0x72>
  }
  release(&log.lock);
    800040d6:	00018517          	auipc	a0,0x18
    800040da:	68a50513          	addi	a0,a0,1674 # 8001c760 <log>
    800040de:	6e4020ef          	jal	800067c2 <release>
}
    800040e2:	60e2                	ld	ra,24(sp)
    800040e4:	6442                	ld	s0,16(sp)
    800040e6:	64a2                	ld	s1,8(sp)
    800040e8:	6902                	ld	s2,0(sp)
    800040ea:	6105                	addi	sp,sp,32
    800040ec:	8082                	ret

00000000800040ee <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800040ee:	1101                	addi	sp,sp,-32
    800040f0:	ec06                	sd	ra,24(sp)
    800040f2:	e822                	sd	s0,16(sp)
    800040f4:	e426                	sd	s1,8(sp)
    800040f6:	e04a                	sd	s2,0(sp)
    800040f8:	1000                	addi	s0,sp,32
    800040fa:	84aa                	mv	s1,a0
    800040fc:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800040fe:	00005597          	auipc	a1,0x5
    80004102:	97a58593          	addi	a1,a1,-1670 # 80008a78 <etext+0xa78>
    80004106:	0521                	addi	a0,a0,8
    80004108:	6f6020ef          	jal	800067fe <initlock>
  lk->name = name;
    8000410c:	0324b423          	sd	s2,40(s1)
  lk->locked = 0;
    80004110:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004114:	0204a823          	sw	zero,48(s1)
}
    80004118:	60e2                	ld	ra,24(sp)
    8000411a:	6442                	ld	s0,16(sp)
    8000411c:	64a2                	ld	s1,8(sp)
    8000411e:	6902                	ld	s2,0(sp)
    80004120:	6105                	addi	sp,sp,32
    80004122:	8082                	ret

0000000080004124 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004124:	1101                	addi	sp,sp,-32
    80004126:	ec06                	sd	ra,24(sp)
    80004128:	e822                	sd	s0,16(sp)
    8000412a:	e426                	sd	s1,8(sp)
    8000412c:	e04a                	sd	s2,0(sp)
    8000412e:	1000                	addi	s0,sp,32
    80004130:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004132:	00850913          	addi	s2,a0,8
    80004136:	854a                	mv	a0,s2
    80004138:	5be020ef          	jal	800066f6 <acquire>
  while (lk->locked) {
    8000413c:	409c                	lw	a5,0(s1)
    8000413e:	c799                	beqz	a5,8000414c <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80004140:	85ca                	mv	a1,s2
    80004142:	8526                	mv	a0,s1
    80004144:	d19fd0ef          	jal	80001e5c <sleep>
  while (lk->locked) {
    80004148:	409c                	lw	a5,0(s1)
    8000414a:	fbfd                	bnez	a5,80004140 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000414c:	4785                	li	a5,1
    8000414e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004150:	e68fd0ef          	jal	800017b8 <myproc>
    80004154:	5d1c                	lw	a5,56(a0)
    80004156:	d89c                	sw	a5,48(s1)
  release(&lk->lk);
    80004158:	854a                	mv	a0,s2
    8000415a:	668020ef          	jal	800067c2 <release>
}
    8000415e:	60e2                	ld	ra,24(sp)
    80004160:	6442                	ld	s0,16(sp)
    80004162:	64a2                	ld	s1,8(sp)
    80004164:	6902                	ld	s2,0(sp)
    80004166:	6105                	addi	sp,sp,32
    80004168:	8082                	ret

000000008000416a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000416a:	1101                	addi	sp,sp,-32
    8000416c:	ec06                	sd	ra,24(sp)
    8000416e:	e822                	sd	s0,16(sp)
    80004170:	e426                	sd	s1,8(sp)
    80004172:	e04a                	sd	s2,0(sp)
    80004174:	1000                	addi	s0,sp,32
    80004176:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004178:	00850913          	addi	s2,a0,8
    8000417c:	854a                	mv	a0,s2
    8000417e:	578020ef          	jal	800066f6 <acquire>
  lk->locked = 0;
    80004182:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004186:	0204a823          	sw	zero,48(s1)
  wakeup(lk);
    8000418a:	8526                	mv	a0,s1
    8000418c:	d1dfd0ef          	jal	80001ea8 <wakeup>
  release(&lk->lk);
    80004190:	854a                	mv	a0,s2
    80004192:	630020ef          	jal	800067c2 <release>
}
    80004196:	60e2                	ld	ra,24(sp)
    80004198:	6442                	ld	s0,16(sp)
    8000419a:	64a2                	ld	s1,8(sp)
    8000419c:	6902                	ld	s2,0(sp)
    8000419e:	6105                	addi	sp,sp,32
    800041a0:	8082                	ret

00000000800041a2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800041a2:	7179                	addi	sp,sp,-48
    800041a4:	f406                	sd	ra,40(sp)
    800041a6:	f022                	sd	s0,32(sp)
    800041a8:	ec26                	sd	s1,24(sp)
    800041aa:	e84a                	sd	s2,16(sp)
    800041ac:	1800                	addi	s0,sp,48
    800041ae:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800041b0:	00850913          	addi	s2,a0,8
    800041b4:	854a                	mv	a0,s2
    800041b6:	540020ef          	jal	800066f6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800041ba:	409c                	lw	a5,0(s1)
    800041bc:	ef81                	bnez	a5,800041d4 <holdingsleep+0x32>
    800041be:	4481                	li	s1,0
  release(&lk->lk);
    800041c0:	854a                	mv	a0,s2
    800041c2:	600020ef          	jal	800067c2 <release>
  return r;
}
    800041c6:	8526                	mv	a0,s1
    800041c8:	70a2                	ld	ra,40(sp)
    800041ca:	7402                	ld	s0,32(sp)
    800041cc:	64e2                	ld	s1,24(sp)
    800041ce:	6942                	ld	s2,16(sp)
    800041d0:	6145                	addi	sp,sp,48
    800041d2:	8082                	ret
    800041d4:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800041d6:	0304a983          	lw	s3,48(s1)
    800041da:	ddefd0ef          	jal	800017b8 <myproc>
    800041de:	5d04                	lw	s1,56(a0)
    800041e0:	413484b3          	sub	s1,s1,s3
    800041e4:	0014b493          	seqz	s1,s1
    800041e8:	69a2                	ld	s3,8(sp)
    800041ea:	bfd9                	j	800041c0 <holdingsleep+0x1e>

00000000800041ec <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800041ec:	1141                	addi	sp,sp,-16
    800041ee:	e406                	sd	ra,8(sp)
    800041f0:	e022                	sd	s0,0(sp)
    800041f2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800041f4:	00005597          	auipc	a1,0x5
    800041f8:	89458593          	addi	a1,a1,-1900 # 80008a88 <etext+0xa88>
    800041fc:	00018517          	auipc	a0,0x18
    80004200:	6b450513          	addi	a0,a0,1716 # 8001c8b0 <ftable>
    80004204:	5fa020ef          	jal	800067fe <initlock>
}
    80004208:	60a2                	ld	ra,8(sp)
    8000420a:	6402                	ld	s0,0(sp)
    8000420c:	0141                	addi	sp,sp,16
    8000420e:	8082                	ret

0000000080004210 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004210:	1101                	addi	sp,sp,-32
    80004212:	ec06                	sd	ra,24(sp)
    80004214:	e822                	sd	s0,16(sp)
    80004216:	e426                	sd	s1,8(sp)
    80004218:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000421a:	00018517          	auipc	a0,0x18
    8000421e:	69650513          	addi	a0,a0,1686 # 8001c8b0 <ftable>
    80004222:	4d4020ef          	jal	800066f6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004226:	00018497          	auipc	s1,0x18
    8000422a:	6aa48493          	addi	s1,s1,1706 # 8001c8d0 <ftable+0x20>
    8000422e:	00019717          	auipc	a4,0x19
    80004232:	64270713          	addi	a4,a4,1602 # 8001d870 <disk>
    if(f->ref == 0){
    80004236:	40dc                	lw	a5,4(s1)
    80004238:	cf89                	beqz	a5,80004252 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000423a:	02848493          	addi	s1,s1,40
    8000423e:	fee49ce3          	bne	s1,a4,80004236 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004242:	00018517          	auipc	a0,0x18
    80004246:	66e50513          	addi	a0,a0,1646 # 8001c8b0 <ftable>
    8000424a:	578020ef          	jal	800067c2 <release>
  return 0;
    8000424e:	4481                	li	s1,0
    80004250:	a809                	j	80004262 <filealloc+0x52>
      f->ref = 1;
    80004252:	4785                	li	a5,1
    80004254:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004256:	00018517          	auipc	a0,0x18
    8000425a:	65a50513          	addi	a0,a0,1626 # 8001c8b0 <ftable>
    8000425e:	564020ef          	jal	800067c2 <release>
}
    80004262:	8526                	mv	a0,s1
    80004264:	60e2                	ld	ra,24(sp)
    80004266:	6442                	ld	s0,16(sp)
    80004268:	64a2                	ld	s1,8(sp)
    8000426a:	6105                	addi	sp,sp,32
    8000426c:	8082                	ret

000000008000426e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000426e:	1101                	addi	sp,sp,-32
    80004270:	ec06                	sd	ra,24(sp)
    80004272:	e822                	sd	s0,16(sp)
    80004274:	e426                	sd	s1,8(sp)
    80004276:	1000                	addi	s0,sp,32
    80004278:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000427a:	00018517          	auipc	a0,0x18
    8000427e:	63650513          	addi	a0,a0,1590 # 8001c8b0 <ftable>
    80004282:	474020ef          	jal	800066f6 <acquire>
  if(f->ref < 1)
    80004286:	40dc                	lw	a5,4(s1)
    80004288:	02f05063          	blez	a5,800042a8 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000428c:	2785                	addiw	a5,a5,1
    8000428e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004290:	00018517          	auipc	a0,0x18
    80004294:	62050513          	addi	a0,a0,1568 # 8001c8b0 <ftable>
    80004298:	52a020ef          	jal	800067c2 <release>
  return f;
}
    8000429c:	8526                	mv	a0,s1
    8000429e:	60e2                	ld	ra,24(sp)
    800042a0:	6442                	ld	s0,16(sp)
    800042a2:	64a2                	ld	s1,8(sp)
    800042a4:	6105                	addi	sp,sp,32
    800042a6:	8082                	ret
    panic("filedup");
    800042a8:	00004517          	auipc	a0,0x4
    800042ac:	7e850513          	addi	a0,a0,2024 # 80008a90 <etext+0xa90>
    800042b0:	0f2020ef          	jal	800063a2 <panic>

00000000800042b4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800042b4:	7139                	addi	sp,sp,-64
    800042b6:	fc06                	sd	ra,56(sp)
    800042b8:	f822                	sd	s0,48(sp)
    800042ba:	f426                	sd	s1,40(sp)
    800042bc:	0080                	addi	s0,sp,64
    800042be:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800042c0:	00018517          	auipc	a0,0x18
    800042c4:	5f050513          	addi	a0,a0,1520 # 8001c8b0 <ftable>
    800042c8:	42e020ef          	jal	800066f6 <acquire>
  if(f->ref < 1)
    800042cc:	40dc                	lw	a5,4(s1)
    800042ce:	04f05a63          	blez	a5,80004322 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800042d2:	37fd                	addiw	a5,a5,-1
    800042d4:	0007871b          	sext.w	a4,a5
    800042d8:	c0dc                	sw	a5,4(s1)
    800042da:	04e04e63          	bgtz	a4,80004336 <fileclose+0x82>
    800042de:	f04a                	sd	s2,32(sp)
    800042e0:	ec4e                	sd	s3,24(sp)
    800042e2:	e852                	sd	s4,16(sp)
    800042e4:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800042e6:	0004a903          	lw	s2,0(s1)
    800042ea:	0094ca83          	lbu	s5,9(s1)
    800042ee:	0104ba03          	ld	s4,16(s1)
    800042f2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800042f6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800042fa:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800042fe:	00018517          	auipc	a0,0x18
    80004302:	5b250513          	addi	a0,a0,1458 # 8001c8b0 <ftable>
    80004306:	4bc020ef          	jal	800067c2 <release>

  if(ff.type == FD_PIPE){
    8000430a:	4785                	li	a5,1
    8000430c:	04f90063          	beq	s2,a5,8000434c <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004310:	3979                	addiw	s2,s2,-2
    80004312:	4785                	li	a5,1
    80004314:	0527f563          	bgeu	a5,s2,8000435e <fileclose+0xaa>
    80004318:	7902                	ld	s2,32(sp)
    8000431a:	69e2                	ld	s3,24(sp)
    8000431c:	6a42                	ld	s4,16(sp)
    8000431e:	6aa2                	ld	s5,8(sp)
    80004320:	a00d                	j	80004342 <fileclose+0x8e>
    80004322:	f04a                	sd	s2,32(sp)
    80004324:	ec4e                	sd	s3,24(sp)
    80004326:	e852                	sd	s4,16(sp)
    80004328:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000432a:	00004517          	auipc	a0,0x4
    8000432e:	76e50513          	addi	a0,a0,1902 # 80008a98 <etext+0xa98>
    80004332:	070020ef          	jal	800063a2 <panic>
    release(&ftable.lock);
    80004336:	00018517          	auipc	a0,0x18
    8000433a:	57a50513          	addi	a0,a0,1402 # 8001c8b0 <ftable>
    8000433e:	484020ef          	jal	800067c2 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004342:	70e2                	ld	ra,56(sp)
    80004344:	7442                	ld	s0,48(sp)
    80004346:	74a2                	ld	s1,40(sp)
    80004348:	6121                	addi	sp,sp,64
    8000434a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000434c:	85d6                	mv	a1,s5
    8000434e:	8552                	mv	a0,s4
    80004350:	336000ef          	jal	80004686 <pipeclose>
    80004354:	7902                	ld	s2,32(sp)
    80004356:	69e2                	ld	s3,24(sp)
    80004358:	6a42                	ld	s4,16(sp)
    8000435a:	6aa2                	ld	s5,8(sp)
    8000435c:	b7dd                	j	80004342 <fileclose+0x8e>
    begin_op();
    8000435e:	b3dff0ef          	jal	80003e9a <begin_op>
    iput(ff.ip);
    80004362:	854e                	mv	a0,s3
    80004364:	c22ff0ef          	jal	80003786 <iput>
    end_op();
    80004368:	b9dff0ef          	jal	80003f04 <end_op>
    8000436c:	7902                	ld	s2,32(sp)
    8000436e:	69e2                	ld	s3,24(sp)
    80004370:	6a42                	ld	s4,16(sp)
    80004372:	6aa2                	ld	s5,8(sp)
    80004374:	b7f9                	j	80004342 <fileclose+0x8e>

0000000080004376 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004376:	715d                	addi	sp,sp,-80
    80004378:	e486                	sd	ra,72(sp)
    8000437a:	e0a2                	sd	s0,64(sp)
    8000437c:	fc26                	sd	s1,56(sp)
    8000437e:	f44e                	sd	s3,40(sp)
    80004380:	0880                	addi	s0,sp,80
    80004382:	84aa                	mv	s1,a0
    80004384:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004386:	c32fd0ef          	jal	800017b8 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000438a:	409c                	lw	a5,0(s1)
    8000438c:	37f9                	addiw	a5,a5,-2
    8000438e:	4705                	li	a4,1
    80004390:	04f76063          	bltu	a4,a5,800043d0 <filestat+0x5a>
    80004394:	f84a                	sd	s2,48(sp)
    80004396:	892a                	mv	s2,a0
    ilock(f->ip);
    80004398:	6c88                	ld	a0,24(s1)
    8000439a:	a6aff0ef          	jal	80003604 <ilock>
    stati(f->ip, &st);
    8000439e:	fb840593          	addi	a1,s0,-72
    800043a2:	6c88                	ld	a0,24(s1)
    800043a4:	c8aff0ef          	jal	8000382e <stati>
    iunlock(f->ip);
    800043a8:	6c88                	ld	a0,24(s1)
    800043aa:	b08ff0ef          	jal	800036b2 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800043ae:	46e1                	li	a3,24
    800043b0:	fb840613          	addi	a2,s0,-72
    800043b4:	85ce                	mv	a1,s3
    800043b6:	05893503          	ld	a0,88(s2)
    800043ba:	ce3fc0ef          	jal	8000109c <copyout>
    800043be:	41f5551b          	sraiw	a0,a0,0x1f
    800043c2:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800043c4:	60a6                	ld	ra,72(sp)
    800043c6:	6406                	ld	s0,64(sp)
    800043c8:	74e2                	ld	s1,56(sp)
    800043ca:	79a2                	ld	s3,40(sp)
    800043cc:	6161                	addi	sp,sp,80
    800043ce:	8082                	ret
  return -1;
    800043d0:	557d                	li	a0,-1
    800043d2:	bfcd                	j	800043c4 <filestat+0x4e>

00000000800043d4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800043d4:	7179                	addi	sp,sp,-48
    800043d6:	f406                	sd	ra,40(sp)
    800043d8:	f022                	sd	s0,32(sp)
    800043da:	e84a                	sd	s2,16(sp)
    800043dc:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800043de:	00854783          	lbu	a5,8(a0)
    800043e2:	cfd1                	beqz	a5,8000447e <fileread+0xaa>
    800043e4:	ec26                	sd	s1,24(sp)
    800043e6:	e44e                	sd	s3,8(sp)
    800043e8:	84aa                	mv	s1,a0
    800043ea:	89ae                	mv	s3,a1
    800043ec:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800043ee:	411c                	lw	a5,0(a0)
    800043f0:	4705                	li	a4,1
    800043f2:	04e78363          	beq	a5,a4,80004438 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800043f6:	470d                	li	a4,3
    800043f8:	04e78763          	beq	a5,a4,80004446 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800043fc:	4709                	li	a4,2
    800043fe:	06e79a63          	bne	a5,a4,80004472 <fileread+0x9e>
    ilock(f->ip);
    80004402:	6d08                	ld	a0,24(a0)
    80004404:	a00ff0ef          	jal	80003604 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004408:	874a                	mv	a4,s2
    8000440a:	5094                	lw	a3,32(s1)
    8000440c:	864e                	mv	a2,s3
    8000440e:	4585                	li	a1,1
    80004410:	6c88                	ld	a0,24(s1)
    80004412:	c46ff0ef          	jal	80003858 <readi>
    80004416:	892a                	mv	s2,a0
    80004418:	00a05563          	blez	a0,80004422 <fileread+0x4e>
      f->off += r;
    8000441c:	509c                	lw	a5,32(s1)
    8000441e:	9fa9                	addw	a5,a5,a0
    80004420:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004422:	6c88                	ld	a0,24(s1)
    80004424:	a8eff0ef          	jal	800036b2 <iunlock>
    80004428:	64e2                	ld	s1,24(sp)
    8000442a:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000442c:	854a                	mv	a0,s2
    8000442e:	70a2                	ld	ra,40(sp)
    80004430:	7402                	ld	s0,32(sp)
    80004432:	6942                	ld	s2,16(sp)
    80004434:	6145                	addi	sp,sp,48
    80004436:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004438:	6908                	ld	a0,16(a0)
    8000443a:	388000ef          	jal	800047c2 <piperead>
    8000443e:	892a                	mv	s2,a0
    80004440:	64e2                	ld	s1,24(sp)
    80004442:	69a2                	ld	s3,8(sp)
    80004444:	b7e5                	j	8000442c <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004446:	02451783          	lh	a5,36(a0)
    8000444a:	03079693          	slli	a3,a5,0x30
    8000444e:	92c1                	srli	a3,a3,0x30
    80004450:	4725                	li	a4,9
    80004452:	02d76863          	bltu	a4,a3,80004482 <fileread+0xae>
    80004456:	0792                	slli	a5,a5,0x4
    80004458:	00018717          	auipc	a4,0x18
    8000445c:	3b870713          	addi	a4,a4,952 # 8001c810 <devsw>
    80004460:	97ba                	add	a5,a5,a4
    80004462:	639c                	ld	a5,0(a5)
    80004464:	c39d                	beqz	a5,8000448a <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80004466:	4505                	li	a0,1
    80004468:	9782                	jalr	a5
    8000446a:	892a                	mv	s2,a0
    8000446c:	64e2                	ld	s1,24(sp)
    8000446e:	69a2                	ld	s3,8(sp)
    80004470:	bf75                	j	8000442c <fileread+0x58>
    panic("fileread");
    80004472:	00004517          	auipc	a0,0x4
    80004476:	63650513          	addi	a0,a0,1590 # 80008aa8 <etext+0xaa8>
    8000447a:	729010ef          	jal	800063a2 <panic>
    return -1;
    8000447e:	597d                	li	s2,-1
    80004480:	b775                	j	8000442c <fileread+0x58>
      return -1;
    80004482:	597d                	li	s2,-1
    80004484:	64e2                	ld	s1,24(sp)
    80004486:	69a2                	ld	s3,8(sp)
    80004488:	b755                	j	8000442c <fileread+0x58>
    8000448a:	597d                	li	s2,-1
    8000448c:	64e2                	ld	s1,24(sp)
    8000448e:	69a2                	ld	s3,8(sp)
    80004490:	bf71                	j	8000442c <fileread+0x58>

0000000080004492 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004492:	00954783          	lbu	a5,9(a0)
    80004496:	10078b63          	beqz	a5,800045ac <filewrite+0x11a>
{
    8000449a:	715d                	addi	sp,sp,-80
    8000449c:	e486                	sd	ra,72(sp)
    8000449e:	e0a2                	sd	s0,64(sp)
    800044a0:	f84a                	sd	s2,48(sp)
    800044a2:	f052                	sd	s4,32(sp)
    800044a4:	e85a                	sd	s6,16(sp)
    800044a6:	0880                	addi	s0,sp,80
    800044a8:	892a                	mv	s2,a0
    800044aa:	8b2e                	mv	s6,a1
    800044ac:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800044ae:	411c                	lw	a5,0(a0)
    800044b0:	4705                	li	a4,1
    800044b2:	02e78763          	beq	a5,a4,800044e0 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800044b6:	470d                	li	a4,3
    800044b8:	02e78863          	beq	a5,a4,800044e8 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800044bc:	4709                	li	a4,2
    800044be:	0ce79c63          	bne	a5,a4,80004596 <filewrite+0x104>
    800044c2:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800044c4:	0ac05863          	blez	a2,80004574 <filewrite+0xe2>
    800044c8:	fc26                	sd	s1,56(sp)
    800044ca:	ec56                	sd	s5,24(sp)
    800044cc:	e45e                	sd	s7,8(sp)
    800044ce:	e062                	sd	s8,0(sp)
    int i = 0;
    800044d0:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800044d2:	6b85                	lui	s7,0x1
    800044d4:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800044d8:	6c05                	lui	s8,0x1
    800044da:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800044de:	a8b5                	j	8000455a <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800044e0:	6908                	ld	a0,16(a0)
    800044e2:	1fc000ef          	jal	800046de <pipewrite>
    800044e6:	a04d                	j	80004588 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800044e8:	02451783          	lh	a5,36(a0)
    800044ec:	03079693          	slli	a3,a5,0x30
    800044f0:	92c1                	srli	a3,a3,0x30
    800044f2:	4725                	li	a4,9
    800044f4:	0ad76e63          	bltu	a4,a3,800045b0 <filewrite+0x11e>
    800044f8:	0792                	slli	a5,a5,0x4
    800044fa:	00018717          	auipc	a4,0x18
    800044fe:	31670713          	addi	a4,a4,790 # 8001c810 <devsw>
    80004502:	97ba                	add	a5,a5,a4
    80004504:	679c                	ld	a5,8(a5)
    80004506:	c7dd                	beqz	a5,800045b4 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80004508:	4505                	li	a0,1
    8000450a:	9782                	jalr	a5
    8000450c:	a8b5                	j	80004588 <filewrite+0xf6>
      if(n1 > max)
    8000450e:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004512:	989ff0ef          	jal	80003e9a <begin_op>
      ilock(f->ip);
    80004516:	01893503          	ld	a0,24(s2)
    8000451a:	8eaff0ef          	jal	80003604 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000451e:	8756                	mv	a4,s5
    80004520:	02092683          	lw	a3,32(s2)
    80004524:	01698633          	add	a2,s3,s6
    80004528:	4585                	li	a1,1
    8000452a:	01893503          	ld	a0,24(s2)
    8000452e:	c26ff0ef          	jal	80003954 <writei>
    80004532:	84aa                	mv	s1,a0
    80004534:	00a05763          	blez	a0,80004542 <filewrite+0xb0>
        f->off += r;
    80004538:	02092783          	lw	a5,32(s2)
    8000453c:	9fa9                	addw	a5,a5,a0
    8000453e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004542:	01893503          	ld	a0,24(s2)
    80004546:	96cff0ef          	jal	800036b2 <iunlock>
      end_op();
    8000454a:	9bbff0ef          	jal	80003f04 <end_op>

      if(r != n1){
    8000454e:	029a9563          	bne	s5,s1,80004578 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80004552:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004556:	0149da63          	bge	s3,s4,8000456a <filewrite+0xd8>
      int n1 = n - i;
    8000455a:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000455e:	0004879b          	sext.w	a5,s1
    80004562:	fafbd6e3          	bge	s7,a5,8000450e <filewrite+0x7c>
    80004566:	84e2                	mv	s1,s8
    80004568:	b75d                	j	8000450e <filewrite+0x7c>
    8000456a:	74e2                	ld	s1,56(sp)
    8000456c:	6ae2                	ld	s5,24(sp)
    8000456e:	6ba2                	ld	s7,8(sp)
    80004570:	6c02                	ld	s8,0(sp)
    80004572:	a039                	j	80004580 <filewrite+0xee>
    int i = 0;
    80004574:	4981                	li	s3,0
    80004576:	a029                	j	80004580 <filewrite+0xee>
    80004578:	74e2                	ld	s1,56(sp)
    8000457a:	6ae2                	ld	s5,24(sp)
    8000457c:	6ba2                	ld	s7,8(sp)
    8000457e:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004580:	033a1c63          	bne	s4,s3,800045b8 <filewrite+0x126>
    80004584:	8552                	mv	a0,s4
    80004586:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004588:	60a6                	ld	ra,72(sp)
    8000458a:	6406                	ld	s0,64(sp)
    8000458c:	7942                	ld	s2,48(sp)
    8000458e:	7a02                	ld	s4,32(sp)
    80004590:	6b42                	ld	s6,16(sp)
    80004592:	6161                	addi	sp,sp,80
    80004594:	8082                	ret
    80004596:	fc26                	sd	s1,56(sp)
    80004598:	f44e                	sd	s3,40(sp)
    8000459a:	ec56                	sd	s5,24(sp)
    8000459c:	e45e                	sd	s7,8(sp)
    8000459e:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800045a0:	00004517          	auipc	a0,0x4
    800045a4:	51850513          	addi	a0,a0,1304 # 80008ab8 <etext+0xab8>
    800045a8:	5fb010ef          	jal	800063a2 <panic>
    return -1;
    800045ac:	557d                	li	a0,-1
}
    800045ae:	8082                	ret
      return -1;
    800045b0:	557d                	li	a0,-1
    800045b2:	bfd9                	j	80004588 <filewrite+0xf6>
    800045b4:	557d                	li	a0,-1
    800045b6:	bfc9                	j	80004588 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800045b8:	557d                	li	a0,-1
    800045ba:	79a2                	ld	s3,40(sp)
    800045bc:	b7f1                	j	80004588 <filewrite+0xf6>

00000000800045be <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800045be:	7179                	addi	sp,sp,-48
    800045c0:	f406                	sd	ra,40(sp)
    800045c2:	f022                	sd	s0,32(sp)
    800045c4:	ec26                	sd	s1,24(sp)
    800045c6:	e052                	sd	s4,0(sp)
    800045c8:	1800                	addi	s0,sp,48
    800045ca:	84aa                	mv	s1,a0
    800045cc:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800045ce:	0005b023          	sd	zero,0(a1)
    800045d2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800045d6:	c3bff0ef          	jal	80004210 <filealloc>
    800045da:	e088                	sd	a0,0(s1)
    800045dc:	c549                	beqz	a0,80004666 <pipealloc+0xa8>
    800045de:	c33ff0ef          	jal	80004210 <filealloc>
    800045e2:	00aa3023          	sd	a0,0(s4)
    800045e6:	cd25                	beqz	a0,8000465e <pipealloc+0xa0>
    800045e8:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800045ea:	cb7fb0ef          	jal	800002a0 <kalloc>
    800045ee:	892a                	mv	s2,a0
    800045f0:	c12d                	beqz	a0,80004652 <pipealloc+0x94>
    800045f2:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800045f4:	4985                	li	s3,1
    800045f6:	23352423          	sw	s3,552(a0)
  pi->writeopen = 1;
    800045fa:	23352623          	sw	s3,556(a0)
  pi->nwrite = 0;
    800045fe:	22052223          	sw	zero,548(a0)
  pi->nread = 0;
    80004602:	22052023          	sw	zero,544(a0)
  initlock(&pi->lock, "pipe");
    80004606:	00004597          	auipc	a1,0x4
    8000460a:	20258593          	addi	a1,a1,514 # 80008808 <etext+0x808>
    8000460e:	1f0020ef          	jal	800067fe <initlock>
  (*f0)->type = FD_PIPE;
    80004612:	609c                	ld	a5,0(s1)
    80004614:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004618:	609c                	ld	a5,0(s1)
    8000461a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000461e:	609c                	ld	a5,0(s1)
    80004620:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004624:	609c                	ld	a5,0(s1)
    80004626:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000462a:	000a3783          	ld	a5,0(s4)
    8000462e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004632:	000a3783          	ld	a5,0(s4)
    80004636:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000463a:	000a3783          	ld	a5,0(s4)
    8000463e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004642:	000a3783          	ld	a5,0(s4)
    80004646:	0127b823          	sd	s2,16(a5)
  return 0;
    8000464a:	4501                	li	a0,0
    8000464c:	6942                	ld	s2,16(sp)
    8000464e:	69a2                	ld	s3,8(sp)
    80004650:	a01d                	j	80004676 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004652:	6088                	ld	a0,0(s1)
    80004654:	c119                	beqz	a0,8000465a <pipealloc+0x9c>
    80004656:	6942                	ld	s2,16(sp)
    80004658:	a029                	j	80004662 <pipealloc+0xa4>
    8000465a:	6942                	ld	s2,16(sp)
    8000465c:	a029                	j	80004666 <pipealloc+0xa8>
    8000465e:	6088                	ld	a0,0(s1)
    80004660:	c10d                	beqz	a0,80004682 <pipealloc+0xc4>
    fileclose(*f0);
    80004662:	c53ff0ef          	jal	800042b4 <fileclose>
  if(*f1)
    80004666:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000466a:	557d                	li	a0,-1
  if(*f1)
    8000466c:	c789                	beqz	a5,80004676 <pipealloc+0xb8>
    fileclose(*f1);
    8000466e:	853e                	mv	a0,a5
    80004670:	c45ff0ef          	jal	800042b4 <fileclose>
  return -1;
    80004674:	557d                	li	a0,-1
}
    80004676:	70a2                	ld	ra,40(sp)
    80004678:	7402                	ld	s0,32(sp)
    8000467a:	64e2                	ld	s1,24(sp)
    8000467c:	6a02                	ld	s4,0(sp)
    8000467e:	6145                	addi	sp,sp,48
    80004680:	8082                	ret
  return -1;
    80004682:	557d                	li	a0,-1
    80004684:	bfcd                	j	80004676 <pipealloc+0xb8>

0000000080004686 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004686:	1101                	addi	sp,sp,-32
    80004688:	ec06                	sd	ra,24(sp)
    8000468a:	e822                	sd	s0,16(sp)
    8000468c:	e426                	sd	s1,8(sp)
    8000468e:	e04a                	sd	s2,0(sp)
    80004690:	1000                	addi	s0,sp,32
    80004692:	84aa                	mv	s1,a0
    80004694:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004696:	060020ef          	jal	800066f6 <acquire>
  if(writable){
    8000469a:	02090763          	beqz	s2,800046c8 <pipeclose+0x42>
    pi->writeopen = 0;
    8000469e:	2204a623          	sw	zero,556(s1)
    wakeup(&pi->nread);
    800046a2:	22048513          	addi	a0,s1,544
    800046a6:	803fd0ef          	jal	80001ea8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800046aa:	2284b783          	ld	a5,552(s1)
    800046ae:	e785                	bnez	a5,800046d6 <pipeclose+0x50>
    release(&pi->lock);
    800046b0:	8526                	mv	a0,s1
    800046b2:	110020ef          	jal	800067c2 <release>
    kfree((char*)pi);
    800046b6:	8526                	mv	a0,s1
    800046b8:	b2ffb0ef          	jal	800001e6 <kfree>
  } else
    release(&pi->lock);
}
    800046bc:	60e2                	ld	ra,24(sp)
    800046be:	6442                	ld	s0,16(sp)
    800046c0:	64a2                	ld	s1,8(sp)
    800046c2:	6902                	ld	s2,0(sp)
    800046c4:	6105                	addi	sp,sp,32
    800046c6:	8082                	ret
    pi->readopen = 0;
    800046c8:	2204a423          	sw	zero,552(s1)
    wakeup(&pi->nwrite);
    800046cc:	22448513          	addi	a0,s1,548
    800046d0:	fd8fd0ef          	jal	80001ea8 <wakeup>
    800046d4:	bfd9                	j	800046aa <pipeclose+0x24>
    release(&pi->lock);
    800046d6:	8526                	mv	a0,s1
    800046d8:	0ea020ef          	jal	800067c2 <release>
}
    800046dc:	b7c5                	j	800046bc <pipeclose+0x36>

00000000800046de <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800046de:	711d                	addi	sp,sp,-96
    800046e0:	ec86                	sd	ra,88(sp)
    800046e2:	e8a2                	sd	s0,80(sp)
    800046e4:	e4a6                	sd	s1,72(sp)
    800046e6:	e0ca                	sd	s2,64(sp)
    800046e8:	fc4e                	sd	s3,56(sp)
    800046ea:	f852                	sd	s4,48(sp)
    800046ec:	f456                	sd	s5,40(sp)
    800046ee:	1080                	addi	s0,sp,96
    800046f0:	84aa                	mv	s1,a0
    800046f2:	8aae                	mv	s5,a1
    800046f4:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800046f6:	8c2fd0ef          	jal	800017b8 <myproc>
    800046fa:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800046fc:	8526                	mv	a0,s1
    800046fe:	7f9010ef          	jal	800066f6 <acquire>
  while(i < n){
    80004702:	0b405a63          	blez	s4,800047b6 <pipewrite+0xd8>
    80004706:	f05a                	sd	s6,32(sp)
    80004708:	ec5e                	sd	s7,24(sp)
    8000470a:	e862                	sd	s8,16(sp)
  int i = 0;
    8000470c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000470e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004710:	22048c13          	addi	s8,s1,544
      sleep(&pi->nwrite, &pi->lock);
    80004714:	22448b93          	addi	s7,s1,548
    80004718:	a81d                	j	8000474e <pipewrite+0x70>
      release(&pi->lock);
    8000471a:	8526                	mv	a0,s1
    8000471c:	0a6020ef          	jal	800067c2 <release>
      return -1;
    80004720:	597d                	li	s2,-1
    80004722:	7b02                	ld	s6,32(sp)
    80004724:	6be2                	ld	s7,24(sp)
    80004726:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004728:	854a                	mv	a0,s2
    8000472a:	60e6                	ld	ra,88(sp)
    8000472c:	6446                	ld	s0,80(sp)
    8000472e:	64a6                	ld	s1,72(sp)
    80004730:	6906                	ld	s2,64(sp)
    80004732:	79e2                	ld	s3,56(sp)
    80004734:	7a42                	ld	s4,48(sp)
    80004736:	7aa2                	ld	s5,40(sp)
    80004738:	6125                	addi	sp,sp,96
    8000473a:	8082                	ret
      wakeup(&pi->nread);
    8000473c:	8562                	mv	a0,s8
    8000473e:	f6afd0ef          	jal	80001ea8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004742:	85a6                	mv	a1,s1
    80004744:	855e                	mv	a0,s7
    80004746:	f16fd0ef          	jal	80001e5c <sleep>
  while(i < n){
    8000474a:	05495b63          	bge	s2,s4,800047a0 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    8000474e:	2284a783          	lw	a5,552(s1)
    80004752:	d7e1                	beqz	a5,8000471a <pipewrite+0x3c>
    80004754:	854e                	mv	a0,s3
    80004756:	93ffd0ef          	jal	80002094 <killed>
    8000475a:	f161                	bnez	a0,8000471a <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000475c:	2204a783          	lw	a5,544(s1)
    80004760:	2244a703          	lw	a4,548(s1)
    80004764:	2007879b          	addiw	a5,a5,512
    80004768:	fcf70ae3          	beq	a4,a5,8000473c <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000476c:	4685                	li	a3,1
    8000476e:	01590633          	add	a2,s2,s5
    80004772:	faf40593          	addi	a1,s0,-81
    80004776:	0589b503          	ld	a0,88(s3)
    8000477a:	a81fc0ef          	jal	800011fa <copyin>
    8000477e:	03650e63          	beq	a0,s6,800047ba <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004782:	2244a783          	lw	a5,548(s1)
    80004786:	0017871b          	addiw	a4,a5,1
    8000478a:	22e4a223          	sw	a4,548(s1)
    8000478e:	1ff7f793          	andi	a5,a5,511
    80004792:	97a6                	add	a5,a5,s1
    80004794:	faf44703          	lbu	a4,-81(s0)
    80004798:	02e78023          	sb	a4,32(a5)
      i++;
    8000479c:	2905                	addiw	s2,s2,1
    8000479e:	b775                	j	8000474a <pipewrite+0x6c>
    800047a0:	7b02                	ld	s6,32(sp)
    800047a2:	6be2                	ld	s7,24(sp)
    800047a4:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800047a6:	22048513          	addi	a0,s1,544
    800047aa:	efefd0ef          	jal	80001ea8 <wakeup>
  release(&pi->lock);
    800047ae:	8526                	mv	a0,s1
    800047b0:	012020ef          	jal	800067c2 <release>
  return i;
    800047b4:	bf95                	j	80004728 <pipewrite+0x4a>
  int i = 0;
    800047b6:	4901                	li	s2,0
    800047b8:	b7fd                	j	800047a6 <pipewrite+0xc8>
    800047ba:	7b02                	ld	s6,32(sp)
    800047bc:	6be2                	ld	s7,24(sp)
    800047be:	6c42                	ld	s8,16(sp)
    800047c0:	b7dd                	j	800047a6 <pipewrite+0xc8>

00000000800047c2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800047c2:	715d                	addi	sp,sp,-80
    800047c4:	e486                	sd	ra,72(sp)
    800047c6:	e0a2                	sd	s0,64(sp)
    800047c8:	fc26                	sd	s1,56(sp)
    800047ca:	f84a                	sd	s2,48(sp)
    800047cc:	f44e                	sd	s3,40(sp)
    800047ce:	f052                	sd	s4,32(sp)
    800047d0:	ec56                	sd	s5,24(sp)
    800047d2:	0880                	addi	s0,sp,80
    800047d4:	84aa                	mv	s1,a0
    800047d6:	892e                	mv	s2,a1
    800047d8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800047da:	fdffc0ef          	jal	800017b8 <myproc>
    800047de:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800047e0:	8526                	mv	a0,s1
    800047e2:	715010ef          	jal	800066f6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800047e6:	2204a703          	lw	a4,544(s1)
    800047ea:	2244a783          	lw	a5,548(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800047ee:	22048993          	addi	s3,s1,544
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800047f2:	02f71563          	bne	a4,a5,8000481c <piperead+0x5a>
    800047f6:	22c4a783          	lw	a5,556(s1)
    800047fa:	cb85                	beqz	a5,8000482a <piperead+0x68>
    if(killed(pr)){
    800047fc:	8552                	mv	a0,s4
    800047fe:	897fd0ef          	jal	80002094 <killed>
    80004802:	ed19                	bnez	a0,80004820 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004804:	85a6                	mv	a1,s1
    80004806:	854e                	mv	a0,s3
    80004808:	e54fd0ef          	jal	80001e5c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000480c:	2204a703          	lw	a4,544(s1)
    80004810:	2244a783          	lw	a5,548(s1)
    80004814:	fef701e3          	beq	a4,a5,800047f6 <piperead+0x34>
    80004818:	e85a                	sd	s6,16(sp)
    8000481a:	a809                	j	8000482c <piperead+0x6a>
    8000481c:	e85a                	sd	s6,16(sp)
    8000481e:	a039                	j	8000482c <piperead+0x6a>
      release(&pi->lock);
    80004820:	8526                	mv	a0,s1
    80004822:	7a1010ef          	jal	800067c2 <release>
      return -1;
    80004826:	59fd                	li	s3,-1
    80004828:	a8b1                	j	80004884 <piperead+0xc2>
    8000482a:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000482c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000482e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004830:	05505263          	blez	s5,80004874 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004834:	2204a783          	lw	a5,544(s1)
    80004838:	2244a703          	lw	a4,548(s1)
    8000483c:	02f70c63          	beq	a4,a5,80004874 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004840:	0017871b          	addiw	a4,a5,1
    80004844:	22e4a023          	sw	a4,544(s1)
    80004848:	1ff7f793          	andi	a5,a5,511
    8000484c:	97a6                	add	a5,a5,s1
    8000484e:	0207c783          	lbu	a5,32(a5)
    80004852:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004856:	4685                	li	a3,1
    80004858:	fbf40613          	addi	a2,s0,-65
    8000485c:	85ca                	mv	a1,s2
    8000485e:	058a3503          	ld	a0,88(s4)
    80004862:	83bfc0ef          	jal	8000109c <copyout>
    80004866:	01650763          	beq	a0,s6,80004874 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000486a:	2985                	addiw	s3,s3,1
    8000486c:	0905                	addi	s2,s2,1
    8000486e:	fd3a93e3          	bne	s5,s3,80004834 <piperead+0x72>
    80004872:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004874:	22448513          	addi	a0,s1,548
    80004878:	e30fd0ef          	jal	80001ea8 <wakeup>
  release(&pi->lock);
    8000487c:	8526                	mv	a0,s1
    8000487e:	745010ef          	jal	800067c2 <release>
    80004882:	6b42                	ld	s6,16(sp)
  return i;
}
    80004884:	854e                	mv	a0,s3
    80004886:	60a6                	ld	ra,72(sp)
    80004888:	6406                	ld	s0,64(sp)
    8000488a:	74e2                	ld	s1,56(sp)
    8000488c:	7942                	ld	s2,48(sp)
    8000488e:	79a2                	ld	s3,40(sp)
    80004890:	7a02                	ld	s4,32(sp)
    80004892:	6ae2                	ld	s5,24(sp)
    80004894:	6161                	addi	sp,sp,80
    80004896:	8082                	ret

0000000080004898 <exec>:
  return perm;
}

int
exec(char *path, char **argv)
{
    80004898:	df010113          	addi	sp,sp,-528
    8000489c:	20113423          	sd	ra,520(sp)
    800048a0:	20813023          	sd	s0,512(sp)
    800048a4:	ffa6                	sd	s1,504(sp)
    800048a6:	fbca                	sd	s2,496(sp)
    800048a8:	0c00                	addi	s0,sp,528
    800048aa:	892a                	mv	s2,a0
    800048ac:	dea43c23          	sd	a0,-520(s0)
    800048b0:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800048b4:	f05fc0ef          	jal	800017b8 <myproc>
    800048b8:	84aa                	mv	s1,a0

  begin_op();
    800048ba:	de0ff0ef          	jal	80003e9a <begin_op>

  if((ip = namei(path)) == 0){
    800048be:	854a                	mv	a0,s2
    800048c0:	c1eff0ef          	jal	80003cde <namei>
    800048c4:	c931                	beqz	a0,80004918 <exec+0x80>
    800048c6:	f3d2                	sd	s4,480(sp)
    800048c8:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800048ca:	d3bfe0ef          	jal	80003604 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800048ce:	04000713          	li	a4,64
    800048d2:	4681                	li	a3,0
    800048d4:	e5040613          	addi	a2,s0,-432
    800048d8:	4581                	li	a1,0
    800048da:	8552                	mv	a0,s4
    800048dc:	f7dfe0ef          	jal	80003858 <readi>
    800048e0:	04000793          	li	a5,64
    800048e4:	00f51a63          	bne	a0,a5,800048f8 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800048e8:	e5042703          	lw	a4,-432(s0)
    800048ec:	464c47b7          	lui	a5,0x464c4
    800048f0:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800048f4:	02f70663          	beq	a4,a5,80004920 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800048f8:	8552                	mv	a0,s4
    800048fa:	f15fe0ef          	jal	8000380e <iunlockput>
    end_op();
    800048fe:	e06ff0ef          	jal	80003f04 <end_op>
  }
  return -1;
    80004902:	557d                	li	a0,-1
    80004904:	7a1e                	ld	s4,480(sp)
}
    80004906:	20813083          	ld	ra,520(sp)
    8000490a:	20013403          	ld	s0,512(sp)
    8000490e:	74fe                	ld	s1,504(sp)
    80004910:	795e                	ld	s2,496(sp)
    80004912:	21010113          	addi	sp,sp,528
    80004916:	8082                	ret
    end_op();
    80004918:	decff0ef          	jal	80003f04 <end_op>
    return -1;
    8000491c:	557d                	li	a0,-1
    8000491e:	b7e5                	j	80004906 <exec+0x6e>
    80004920:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004922:	8526                	mv	a0,s1
    80004924:	f3dfc0ef          	jal	80001860 <proc_pagetable>
    80004928:	8b2a                	mv	s6,a0
    8000492a:	2c050f63          	beqz	a0,80004c08 <exec+0x370>
    8000492e:	f7ce                	sd	s3,488(sp)
    80004930:	efd6                	sd	s5,472(sp)
    80004932:	e7de                	sd	s7,456(sp)
    80004934:	e3e2                	sd	s8,448(sp)
    80004936:	ff66                	sd	s9,440(sp)
    80004938:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000493a:	e7042d03          	lw	s10,-400(s0)
    8000493e:	e8845783          	lhu	a5,-376(s0)
    80004942:	12078d63          	beqz	a5,80004a7c <exec+0x1e4>
    80004946:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004948:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000494a:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    8000494c:	6c85                	lui	s9,0x1
    8000494e:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004952:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004956:	6a85                	lui	s5,0x1
    80004958:	a085                	j	800049b8 <exec+0x120>
      panic("loadseg: address should exist");
    8000495a:	00004517          	auipc	a0,0x4
    8000495e:	16e50513          	addi	a0,a0,366 # 80008ac8 <etext+0xac8>
    80004962:	241010ef          	jal	800063a2 <panic>
    if(sz - i < PGSIZE)
    80004966:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004968:	8726                	mv	a4,s1
    8000496a:	012c06bb          	addw	a3,s8,s2
    8000496e:	4581                	li	a1,0
    80004970:	8552                	mv	a0,s4
    80004972:	ee7fe0ef          	jal	80003858 <readi>
    80004976:	2501                	sext.w	a0,a0
    80004978:	24a49e63          	bne	s1,a0,80004bd4 <exec+0x33c>
  for(i = 0; i < sz; i += PGSIZE){
    8000497c:	012a893b          	addw	s2,s5,s2
    80004980:	03397363          	bgeu	s2,s3,800049a6 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80004984:	02091593          	slli	a1,s2,0x20
    80004988:	9181                	srli	a1,a1,0x20
    8000498a:	95de                	add	a1,a1,s7
    8000498c:	855a                	mv	a0,s6
    8000498e:	f23fb0ef          	jal	800008b0 <walkaddr>
    80004992:	862a                	mv	a2,a0
    if(pa == 0)
    80004994:	d179                	beqz	a0,8000495a <exec+0xc2>
    if(sz - i < PGSIZE)
    80004996:	412984bb          	subw	s1,s3,s2
    8000499a:	0004879b          	sext.w	a5,s1
    8000499e:	fcfcf4e3          	bgeu	s9,a5,80004966 <exec+0xce>
    800049a2:	84d6                	mv	s1,s5
    800049a4:	b7c9                	j	80004966 <exec+0xce>
    sz = sz1;
    800049a6:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800049aa:	2d85                	addiw	s11,s11,1
    800049ac:	038d0d1b          	addiw	s10,s10,56
    800049b0:	e8845783          	lhu	a5,-376(s0)
    800049b4:	08fdd463          	bge	s11,a5,80004a3c <exec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800049b8:	2d01                	sext.w	s10,s10
    800049ba:	03800713          	li	a4,56
    800049be:	86ea                	mv	a3,s10
    800049c0:	e1840613          	addi	a2,s0,-488
    800049c4:	4581                	li	a1,0
    800049c6:	8552                	mv	a0,s4
    800049c8:	e91fe0ef          	jal	80003858 <readi>
    800049cc:	03800793          	li	a5,56
    800049d0:	1cf51a63          	bne	a0,a5,80004ba4 <exec+0x30c>
    if(ph.type != ELF_PROG_LOAD)
    800049d4:	e1842783          	lw	a5,-488(s0)
    800049d8:	4705                	li	a4,1
    800049da:	fce798e3          	bne	a5,a4,800049aa <exec+0x112>
    if(ph.memsz < ph.filesz)
    800049de:	e4043603          	ld	a2,-448(s0)
    800049e2:	e3843783          	ld	a5,-456(s0)
    800049e6:	1cf66363          	bltu	a2,a5,80004bac <exec+0x314>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800049ea:	e2843783          	ld	a5,-472(s0)
    800049ee:	963e                	add	a2,a2,a5
    800049f0:	1cf66263          	bltu	a2,a5,80004bb4 <exec+0x31c>
    if(ph.vaddr % PGSIZE != 0)
    800049f4:	df043703          	ld	a4,-528(s0)
    800049f8:	8ff9                	and	a5,a5,a4
    800049fa:	1c079163          	bnez	a5,80004bbc <exec+0x324>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800049fe:	e1c42783          	lw	a5,-484(s0)
  if(flags & ELF_PROG_FLAG_WRITE) // ELF_PROG_FLAG_WRITE is 0x2
    80004a02:	0027f713          	andi	a4,a5,2
    perm |= PTE_W; // 可写
    80004a06:	46d9                	li	a3,22
  if(flags & ELF_PROG_FLAG_WRITE) // ELF_PROG_FLAG_WRITE is 0x2
    80004a08:	e311                	bnez	a4,80004a0c <exec+0x174>
  perm |= PTE_R; // <--- 必须设置可读权限
    80004a0a:	46c9                	li	a3,18
  if(flags & ELF_PROG_FLAG_EXEC) // ELF_PROG_FLAG_EXEC is 0x1
    80004a0c:	8b85                	andi	a5,a5,1
    80004a0e:	078e                	slli	a5,a5,0x3
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004a10:	8edd                	or	a3,a3,a5
    80004a12:	85a6                	mv	a1,s1
    80004a14:	855a                	mv	a0,s6
    80004a16:	bc0fc0ef          	jal	80000dd6 <uvmalloc>
    80004a1a:	e0a43423          	sd	a0,-504(s0)
    80004a1e:	1a050363          	beqz	a0,80004bc4 <exec+0x32c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004a22:	e2843b83          	ld	s7,-472(s0)
    80004a26:	e2042c03          	lw	s8,-480(s0)
    80004a2a:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004a2e:	00098463          	beqz	s3,80004a36 <exec+0x19e>
    80004a32:	4901                	li	s2,0
    80004a34:	bf81                	j	80004984 <exec+0xec>
    sz = sz1;
    80004a36:	e0843483          	ld	s1,-504(s0)
    80004a3a:	bf85                	j	800049aa <exec+0x112>
    80004a3c:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004a3e:	8552                	mv	a0,s4
    80004a40:	dcffe0ef          	jal	8000380e <iunlockput>
  end_op();
    80004a44:	cc0ff0ef          	jal	80003f04 <end_op>
  p = myproc();
    80004a48:	d71fc0ef          	jal	800017b8 <myproc>
    80004a4c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004a4e:	05053c83          	ld	s9,80(a0)
  sz = PGROUNDUP(sz);
    80004a52:	6985                	lui	s3,0x1
    80004a54:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004a56:	99a6                	add	s3,s3,s1
    80004a58:	77fd                	lui	a5,0xfffff
    80004a5a:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004a5e:	4691                	li	a3,4
    80004a60:	660d                	lui	a2,0x3
    80004a62:	964e                	add	a2,a2,s3
    80004a64:	85ce                	mv	a1,s3
    80004a66:	855a                	mv	a0,s6
    80004a68:	b6efc0ef          	jal	80000dd6 <uvmalloc>
    80004a6c:	892a                	mv	s2,a0
    80004a6e:	e0a43423          	sd	a0,-504(s0)
    80004a72:	e519                	bnez	a0,80004a80 <exec+0x1e8>
  if(pagetable)
    80004a74:	e1343423          	sd	s3,-504(s0)
    80004a78:	4a01                	li	s4,0
    80004a7a:	aab1                	j	80004bd6 <exec+0x33e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004a7c:	4481                	li	s1,0
    80004a7e:	b7c1                	j	80004a3e <exec+0x1a6>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004a80:	75f5                	lui	a1,0xffffd
    80004a82:	95aa                	add	a1,a1,a0
    80004a84:	855a                	mv	a0,s6
    80004a86:	decfc0ef          	jal	80001072 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004a8a:	7bf9                	lui	s7,0xffffe
    80004a8c:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004a8e:	e0043783          	ld	a5,-512(s0)
    80004a92:	6388                	ld	a0,0(a5)
    80004a94:	cd39                	beqz	a0,80004af2 <exec+0x25a>
    80004a96:	e9040993          	addi	s3,s0,-368
    80004a9a:	f9040c13          	addi	s8,s0,-112
    80004a9e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004aa0:	b7ffb0ef          	jal	8000061e <strlen>
    80004aa4:	0015079b          	addiw	a5,a0,1
    80004aa8:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004aac:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004ab0:	11796e63          	bltu	s2,s7,80004bcc <exec+0x334>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004ab4:	e0043d03          	ld	s10,-512(s0)
    80004ab8:	000d3a03          	ld	s4,0(s10)
    80004abc:	8552                	mv	a0,s4
    80004abe:	b61fb0ef          	jal	8000061e <strlen>
    80004ac2:	0015069b          	addiw	a3,a0,1
    80004ac6:	8652                	mv	a2,s4
    80004ac8:	85ca                	mv	a1,s2
    80004aca:	855a                	mv	a0,s6
    80004acc:	dd0fc0ef          	jal	8000109c <copyout>
    80004ad0:	10054063          	bltz	a0,80004bd0 <exec+0x338>
    ustack[argc] = sp;
    80004ad4:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004ad8:	0485                	addi	s1,s1,1
    80004ada:	008d0793          	addi	a5,s10,8
    80004ade:	e0f43023          	sd	a5,-512(s0)
    80004ae2:	008d3503          	ld	a0,8(s10)
    80004ae6:	c909                	beqz	a0,80004af8 <exec+0x260>
    if(argc >= MAXARG)
    80004ae8:	09a1                	addi	s3,s3,8
    80004aea:	fb899be3          	bne	s3,s8,80004aa0 <exec+0x208>
  ip = 0;
    80004aee:	4a01                	li	s4,0
    80004af0:	a0dd                	j	80004bd6 <exec+0x33e>
  sp = sz;
    80004af2:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004af6:	4481                	li	s1,0
  ustack[argc] = 0;
    80004af8:	00349793          	slli	a5,s1,0x3
    80004afc:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd9098>
    80004b00:	97a2                	add	a5,a5,s0
    80004b02:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004b06:	00148693          	addi	a3,s1,1
    80004b0a:	068e                	slli	a3,a3,0x3
    80004b0c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004b10:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004b14:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004b18:	f5796ee3          	bltu	s2,s7,80004a74 <exec+0x1dc>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004b1c:	e9040613          	addi	a2,s0,-368
    80004b20:	85ca                	mv	a1,s2
    80004b22:	855a                	mv	a0,s6
    80004b24:	d78fc0ef          	jal	8000109c <copyout>
    80004b28:	0e054263          	bltz	a0,80004c0c <exec+0x374>
  p->trapframe->a1 = sp;
    80004b2c:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    80004b30:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004b34:	df843783          	ld	a5,-520(s0)
    80004b38:	0007c703          	lbu	a4,0(a5)
    80004b3c:	cf11                	beqz	a4,80004b58 <exec+0x2c0>
    80004b3e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004b40:	02f00693          	li	a3,47
    80004b44:	a039                	j	80004b52 <exec+0x2ba>
      last = s+1;
    80004b46:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004b4a:	0785                	addi	a5,a5,1
    80004b4c:	fff7c703          	lbu	a4,-1(a5)
    80004b50:	c701                	beqz	a4,80004b58 <exec+0x2c0>
    if(*s == '/')
    80004b52:	fed71ce3          	bne	a4,a3,80004b4a <exec+0x2b2>
    80004b56:	bfc5                	j	80004b46 <exec+0x2ae>
  safestrcpy(p->name, last, sizeof(p->name));
    80004b58:	4641                	li	a2,16
    80004b5a:	df843583          	ld	a1,-520(s0)
    80004b5e:	160a8513          	addi	a0,s5,352
    80004b62:	a8bfb0ef          	jal	800005ec <safestrcpy>
  oldpagetable = p->pagetable;
    80004b66:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    80004b6a:	056abc23          	sd	s6,88(s5)
  p->sz = sz;
    80004b6e:	e0843783          	ld	a5,-504(s0)
    80004b72:	04fab823          	sd	a5,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004b76:	060ab783          	ld	a5,96(s5)
    80004b7a:	e6843703          	ld	a4,-408(s0)
    80004b7e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004b80:	060ab783          	ld	a5,96(s5)
    80004b84:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004b88:	85e6                	mv	a1,s9
    80004b8a:	d5bfc0ef          	jal	800018e4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004b8e:	0004851b          	sext.w	a0,s1
    80004b92:	79be                	ld	s3,488(sp)
    80004b94:	7a1e                	ld	s4,480(sp)
    80004b96:	6afe                	ld	s5,472(sp)
    80004b98:	6b5e                	ld	s6,464(sp)
    80004b9a:	6bbe                	ld	s7,456(sp)
    80004b9c:	6c1e                	ld	s8,448(sp)
    80004b9e:	7cfa                	ld	s9,440(sp)
    80004ba0:	7d5a                	ld	s10,432(sp)
    80004ba2:	b395                	j	80004906 <exec+0x6e>
    80004ba4:	e0943423          	sd	s1,-504(s0)
    80004ba8:	7dba                	ld	s11,424(sp)
    80004baa:	a035                	j	80004bd6 <exec+0x33e>
    80004bac:	e0943423          	sd	s1,-504(s0)
    80004bb0:	7dba                	ld	s11,424(sp)
    80004bb2:	a015                	j	80004bd6 <exec+0x33e>
    80004bb4:	e0943423          	sd	s1,-504(s0)
    80004bb8:	7dba                	ld	s11,424(sp)
    80004bba:	a831                	j	80004bd6 <exec+0x33e>
    80004bbc:	e0943423          	sd	s1,-504(s0)
    80004bc0:	7dba                	ld	s11,424(sp)
    80004bc2:	a811                	j	80004bd6 <exec+0x33e>
    80004bc4:	e0943423          	sd	s1,-504(s0)
    80004bc8:	7dba                	ld	s11,424(sp)
    80004bca:	a031                	j	80004bd6 <exec+0x33e>
  ip = 0;
    80004bcc:	4a01                	li	s4,0
    80004bce:	a021                	j	80004bd6 <exec+0x33e>
    80004bd0:	4a01                	li	s4,0
  if(pagetable)
    80004bd2:	a011                	j	80004bd6 <exec+0x33e>
    80004bd4:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004bd6:	e0843583          	ld	a1,-504(s0)
    80004bda:	855a                	mv	a0,s6
    80004bdc:	d09fc0ef          	jal	800018e4 <proc_freepagetable>
  return -1;
    80004be0:	557d                	li	a0,-1
  if(ip){
    80004be2:	000a1b63          	bnez	s4,80004bf8 <exec+0x360>
    80004be6:	79be                	ld	s3,488(sp)
    80004be8:	7a1e                	ld	s4,480(sp)
    80004bea:	6afe                	ld	s5,472(sp)
    80004bec:	6b5e                	ld	s6,464(sp)
    80004bee:	6bbe                	ld	s7,456(sp)
    80004bf0:	6c1e                	ld	s8,448(sp)
    80004bf2:	7cfa                	ld	s9,440(sp)
    80004bf4:	7d5a                	ld	s10,432(sp)
    80004bf6:	bb01                	j	80004906 <exec+0x6e>
    80004bf8:	79be                	ld	s3,488(sp)
    80004bfa:	6afe                	ld	s5,472(sp)
    80004bfc:	6b5e                	ld	s6,464(sp)
    80004bfe:	6bbe                	ld	s7,456(sp)
    80004c00:	6c1e                	ld	s8,448(sp)
    80004c02:	7cfa                	ld	s9,440(sp)
    80004c04:	7d5a                	ld	s10,432(sp)
    80004c06:	b9cd                	j	800048f8 <exec+0x60>
    80004c08:	6b5e                	ld	s6,464(sp)
    80004c0a:	b1fd                	j	800048f8 <exec+0x60>
  sz = sz1;
    80004c0c:	e0843983          	ld	s3,-504(s0)
    80004c10:	b595                	j	80004a74 <exec+0x1dc>

0000000080004c12 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004c12:	7179                	addi	sp,sp,-48
    80004c14:	f406                	sd	ra,40(sp)
    80004c16:	f022                	sd	s0,32(sp)
    80004c18:	ec26                	sd	s1,24(sp)
    80004c1a:	e84a                	sd	s2,16(sp)
    80004c1c:	1800                	addi	s0,sp,48
    80004c1e:	892e                	mv	s2,a1
    80004c20:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004c22:	fdc40593          	addi	a1,s0,-36
    80004c26:	b55fd0ef          	jal	8000277a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004c2a:	fdc42703          	lw	a4,-36(s0)
    80004c2e:	47bd                	li	a5,15
    80004c30:	02e7e963          	bltu	a5,a4,80004c62 <argfd+0x50>
    80004c34:	b85fc0ef          	jal	800017b8 <myproc>
    80004c38:	fdc42703          	lw	a4,-36(s0)
    80004c3c:	01a70793          	addi	a5,a4,26
    80004c40:	078e                	slli	a5,a5,0x3
    80004c42:	953e                	add	a0,a0,a5
    80004c44:	651c                	ld	a5,8(a0)
    80004c46:	c385                	beqz	a5,80004c66 <argfd+0x54>
    return -1;
  if(pfd)
    80004c48:	00090463          	beqz	s2,80004c50 <argfd+0x3e>
    *pfd = fd;
    80004c4c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004c50:	4501                	li	a0,0
  if(pf)
    80004c52:	c091                	beqz	s1,80004c56 <argfd+0x44>
    *pf = f;
    80004c54:	e09c                	sd	a5,0(s1)
}
    80004c56:	70a2                	ld	ra,40(sp)
    80004c58:	7402                	ld	s0,32(sp)
    80004c5a:	64e2                	ld	s1,24(sp)
    80004c5c:	6942                	ld	s2,16(sp)
    80004c5e:	6145                	addi	sp,sp,48
    80004c60:	8082                	ret
    return -1;
    80004c62:	557d                	li	a0,-1
    80004c64:	bfcd                	j	80004c56 <argfd+0x44>
    80004c66:	557d                	li	a0,-1
    80004c68:	b7fd                	j	80004c56 <argfd+0x44>

0000000080004c6a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004c6a:	1101                	addi	sp,sp,-32
    80004c6c:	ec06                	sd	ra,24(sp)
    80004c6e:	e822                	sd	s0,16(sp)
    80004c70:	e426                	sd	s1,8(sp)
    80004c72:	1000                	addi	s0,sp,32
    80004c74:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004c76:	b43fc0ef          	jal	800017b8 <myproc>
    80004c7a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004c7c:	0d850793          	addi	a5,a0,216
    80004c80:	4501                	li	a0,0
    80004c82:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004c84:	6398                	ld	a4,0(a5)
    80004c86:	cb19                	beqz	a4,80004c9c <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004c88:	2505                	addiw	a0,a0,1
    80004c8a:	07a1                	addi	a5,a5,8
    80004c8c:	fed51ce3          	bne	a0,a3,80004c84 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004c90:	557d                	li	a0,-1
}
    80004c92:	60e2                	ld	ra,24(sp)
    80004c94:	6442                	ld	s0,16(sp)
    80004c96:	64a2                	ld	s1,8(sp)
    80004c98:	6105                	addi	sp,sp,32
    80004c9a:	8082                	ret
      p->ofile[fd] = f;
    80004c9c:	01a50793          	addi	a5,a0,26
    80004ca0:	078e                	slli	a5,a5,0x3
    80004ca2:	963e                	add	a2,a2,a5
    80004ca4:	e604                	sd	s1,8(a2)
      return fd;
    80004ca6:	b7f5                	j	80004c92 <fdalloc+0x28>

0000000080004ca8 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004ca8:	715d                	addi	sp,sp,-80
    80004caa:	e486                	sd	ra,72(sp)
    80004cac:	e0a2                	sd	s0,64(sp)
    80004cae:	fc26                	sd	s1,56(sp)
    80004cb0:	f84a                	sd	s2,48(sp)
    80004cb2:	f44e                	sd	s3,40(sp)
    80004cb4:	ec56                	sd	s5,24(sp)
    80004cb6:	e85a                	sd	s6,16(sp)
    80004cb8:	0880                	addi	s0,sp,80
    80004cba:	8b2e                	mv	s6,a1
    80004cbc:	89b2                	mv	s3,a2
    80004cbe:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004cc0:	fb040593          	addi	a1,s0,-80
    80004cc4:	834ff0ef          	jal	80003cf8 <nameiparent>
    80004cc8:	84aa                	mv	s1,a0
    80004cca:	10050a63          	beqz	a0,80004dde <create+0x136>
    return 0;

  ilock(dp);
    80004cce:	937fe0ef          	jal	80003604 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004cd2:	4601                	li	a2,0
    80004cd4:	fb040593          	addi	a1,s0,-80
    80004cd8:	8526                	mv	a0,s1
    80004cda:	d9ffe0ef          	jal	80003a78 <dirlookup>
    80004cde:	8aaa                	mv	s5,a0
    80004ce0:	c129                	beqz	a0,80004d22 <create+0x7a>
    iunlockput(dp);
    80004ce2:	8526                	mv	a0,s1
    80004ce4:	b2bfe0ef          	jal	8000380e <iunlockput>
    ilock(ip);
    80004ce8:	8556                	mv	a0,s5
    80004cea:	91bfe0ef          	jal	80003604 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004cee:	4789                	li	a5,2
    80004cf0:	02fb1463          	bne	s6,a5,80004d18 <create+0x70>
    80004cf4:	04cad783          	lhu	a5,76(s5)
    80004cf8:	37f9                	addiw	a5,a5,-2
    80004cfa:	17c2                	slli	a5,a5,0x30
    80004cfc:	93c1                	srli	a5,a5,0x30
    80004cfe:	4705                	li	a4,1
    80004d00:	00f76c63          	bltu	a4,a5,80004d18 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004d04:	8556                	mv	a0,s5
    80004d06:	60a6                	ld	ra,72(sp)
    80004d08:	6406                	ld	s0,64(sp)
    80004d0a:	74e2                	ld	s1,56(sp)
    80004d0c:	7942                	ld	s2,48(sp)
    80004d0e:	79a2                	ld	s3,40(sp)
    80004d10:	6ae2                	ld	s5,24(sp)
    80004d12:	6b42                	ld	s6,16(sp)
    80004d14:	6161                	addi	sp,sp,80
    80004d16:	8082                	ret
    iunlockput(ip);
    80004d18:	8556                	mv	a0,s5
    80004d1a:	af5fe0ef          	jal	8000380e <iunlockput>
    return 0;
    80004d1e:	4a81                	li	s5,0
    80004d20:	b7d5                	j	80004d04 <create+0x5c>
    80004d22:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004d24:	85da                	mv	a1,s6
    80004d26:	4088                	lw	a0,0(s1)
    80004d28:	f6cfe0ef          	jal	80003494 <ialloc>
    80004d2c:	8a2a                	mv	s4,a0
    80004d2e:	cd15                	beqz	a0,80004d6a <create+0xc2>
  ilock(ip);
    80004d30:	8d5fe0ef          	jal	80003604 <ilock>
  ip->major = major;
    80004d34:	053a1723          	sh	s3,78(s4)
  ip->minor = minor;
    80004d38:	052a1823          	sh	s2,80(s4)
  ip->nlink = 1;
    80004d3c:	4905                	li	s2,1
    80004d3e:	052a1923          	sh	s2,82(s4)
  iupdate(ip);
    80004d42:	8552                	mv	a0,s4
    80004d44:	80dfe0ef          	jal	80003550 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004d48:	032b0763          	beq	s6,s2,80004d76 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004d4c:	004a2603          	lw	a2,4(s4)
    80004d50:	fb040593          	addi	a1,s0,-80
    80004d54:	8526                	mv	a0,s1
    80004d56:	eeffe0ef          	jal	80003c44 <dirlink>
    80004d5a:	06054563          	bltz	a0,80004dc4 <create+0x11c>
  iunlockput(dp);
    80004d5e:	8526                	mv	a0,s1
    80004d60:	aaffe0ef          	jal	8000380e <iunlockput>
  return ip;
    80004d64:	8ad2                	mv	s5,s4
    80004d66:	7a02                	ld	s4,32(sp)
    80004d68:	bf71                	j	80004d04 <create+0x5c>
    iunlockput(dp);
    80004d6a:	8526                	mv	a0,s1
    80004d6c:	aa3fe0ef          	jal	8000380e <iunlockput>
    return 0;
    80004d70:	8ad2                	mv	s5,s4
    80004d72:	7a02                	ld	s4,32(sp)
    80004d74:	bf41                	j	80004d04 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004d76:	004a2603          	lw	a2,4(s4)
    80004d7a:	00004597          	auipc	a1,0x4
    80004d7e:	d6e58593          	addi	a1,a1,-658 # 80008ae8 <etext+0xae8>
    80004d82:	8552                	mv	a0,s4
    80004d84:	ec1fe0ef          	jal	80003c44 <dirlink>
    80004d88:	02054e63          	bltz	a0,80004dc4 <create+0x11c>
    80004d8c:	40d0                	lw	a2,4(s1)
    80004d8e:	00004597          	auipc	a1,0x4
    80004d92:	d6258593          	addi	a1,a1,-670 # 80008af0 <etext+0xaf0>
    80004d96:	8552                	mv	a0,s4
    80004d98:	eadfe0ef          	jal	80003c44 <dirlink>
    80004d9c:	02054463          	bltz	a0,80004dc4 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004da0:	004a2603          	lw	a2,4(s4)
    80004da4:	fb040593          	addi	a1,s0,-80
    80004da8:	8526                	mv	a0,s1
    80004daa:	e9bfe0ef          	jal	80003c44 <dirlink>
    80004dae:	00054b63          	bltz	a0,80004dc4 <create+0x11c>
    dp->nlink++;  // for ".."
    80004db2:	0524d783          	lhu	a5,82(s1)
    80004db6:	2785                	addiw	a5,a5,1
    80004db8:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    80004dbc:	8526                	mv	a0,s1
    80004dbe:	f92fe0ef          	jal	80003550 <iupdate>
    80004dc2:	bf71                	j	80004d5e <create+0xb6>
  ip->nlink = 0;
    80004dc4:	040a1923          	sh	zero,82(s4)
  iupdate(ip);
    80004dc8:	8552                	mv	a0,s4
    80004dca:	f86fe0ef          	jal	80003550 <iupdate>
  iunlockput(ip);
    80004dce:	8552                	mv	a0,s4
    80004dd0:	a3ffe0ef          	jal	8000380e <iunlockput>
  iunlockput(dp);
    80004dd4:	8526                	mv	a0,s1
    80004dd6:	a39fe0ef          	jal	8000380e <iunlockput>
  return 0;
    80004dda:	7a02                	ld	s4,32(sp)
    80004ddc:	b725                	j	80004d04 <create+0x5c>
    return 0;
    80004dde:	8aaa                	mv	s5,a0
    80004de0:	b715                	j	80004d04 <create+0x5c>

0000000080004de2 <sys_dup>:
{
    80004de2:	7179                	addi	sp,sp,-48
    80004de4:	f406                	sd	ra,40(sp)
    80004de6:	f022                	sd	s0,32(sp)
    80004de8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004dea:	fd840613          	addi	a2,s0,-40
    80004dee:	4581                	li	a1,0
    80004df0:	4501                	li	a0,0
    80004df2:	e21ff0ef          	jal	80004c12 <argfd>
    return -1;
    80004df6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004df8:	02054363          	bltz	a0,80004e1e <sys_dup+0x3c>
    80004dfc:	ec26                	sd	s1,24(sp)
    80004dfe:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004e00:	fd843903          	ld	s2,-40(s0)
    80004e04:	854a                	mv	a0,s2
    80004e06:	e65ff0ef          	jal	80004c6a <fdalloc>
    80004e0a:	84aa                	mv	s1,a0
    return -1;
    80004e0c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004e0e:	00054d63          	bltz	a0,80004e28 <sys_dup+0x46>
  filedup(f);
    80004e12:	854a                	mv	a0,s2
    80004e14:	c5aff0ef          	jal	8000426e <filedup>
  return fd;
    80004e18:	87a6                	mv	a5,s1
    80004e1a:	64e2                	ld	s1,24(sp)
    80004e1c:	6942                	ld	s2,16(sp)
}
    80004e1e:	853e                	mv	a0,a5
    80004e20:	70a2                	ld	ra,40(sp)
    80004e22:	7402                	ld	s0,32(sp)
    80004e24:	6145                	addi	sp,sp,48
    80004e26:	8082                	ret
    80004e28:	64e2                	ld	s1,24(sp)
    80004e2a:	6942                	ld	s2,16(sp)
    80004e2c:	bfcd                	j	80004e1e <sys_dup+0x3c>

0000000080004e2e <sys_read>:
{
    80004e2e:	7179                	addi	sp,sp,-48
    80004e30:	f406                	sd	ra,40(sp)
    80004e32:	f022                	sd	s0,32(sp)
    80004e34:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004e36:	fd840593          	addi	a1,s0,-40
    80004e3a:	4505                	li	a0,1
    80004e3c:	95dfd0ef          	jal	80002798 <argaddr>
  argint(2, &n);
    80004e40:	fe440593          	addi	a1,s0,-28
    80004e44:	4509                	li	a0,2
    80004e46:	935fd0ef          	jal	8000277a <argint>
  if(argfd(0, 0, &f) < 0)
    80004e4a:	fe840613          	addi	a2,s0,-24
    80004e4e:	4581                	li	a1,0
    80004e50:	4501                	li	a0,0
    80004e52:	dc1ff0ef          	jal	80004c12 <argfd>
    80004e56:	87aa                	mv	a5,a0
    return -1;
    80004e58:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004e5a:	0007ca63          	bltz	a5,80004e6e <sys_read+0x40>
  return fileread(f, p, n);
    80004e5e:	fe442603          	lw	a2,-28(s0)
    80004e62:	fd843583          	ld	a1,-40(s0)
    80004e66:	fe843503          	ld	a0,-24(s0)
    80004e6a:	d6aff0ef          	jal	800043d4 <fileread>
}
    80004e6e:	70a2                	ld	ra,40(sp)
    80004e70:	7402                	ld	s0,32(sp)
    80004e72:	6145                	addi	sp,sp,48
    80004e74:	8082                	ret

0000000080004e76 <sys_write>:
{
    80004e76:	7179                	addi	sp,sp,-48
    80004e78:	f406                	sd	ra,40(sp)
    80004e7a:	f022                	sd	s0,32(sp)
    80004e7c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004e7e:	fd840593          	addi	a1,s0,-40
    80004e82:	4505                	li	a0,1
    80004e84:	915fd0ef          	jal	80002798 <argaddr>
  argint(2, &n);
    80004e88:	fe440593          	addi	a1,s0,-28
    80004e8c:	4509                	li	a0,2
    80004e8e:	8edfd0ef          	jal	8000277a <argint>
  if(argfd(0, 0, &f) < 0)
    80004e92:	fe840613          	addi	a2,s0,-24
    80004e96:	4581                	li	a1,0
    80004e98:	4501                	li	a0,0
    80004e9a:	d79ff0ef          	jal	80004c12 <argfd>
    80004e9e:	87aa                	mv	a5,a0
    return -1;
    80004ea0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004ea2:	0007ca63          	bltz	a5,80004eb6 <sys_write+0x40>
  return filewrite(f, p, n);
    80004ea6:	fe442603          	lw	a2,-28(s0)
    80004eaa:	fd843583          	ld	a1,-40(s0)
    80004eae:	fe843503          	ld	a0,-24(s0)
    80004eb2:	de0ff0ef          	jal	80004492 <filewrite>
}
    80004eb6:	70a2                	ld	ra,40(sp)
    80004eb8:	7402                	ld	s0,32(sp)
    80004eba:	6145                	addi	sp,sp,48
    80004ebc:	8082                	ret

0000000080004ebe <sys_close>:
{
    80004ebe:	1101                	addi	sp,sp,-32
    80004ec0:	ec06                	sd	ra,24(sp)
    80004ec2:	e822                	sd	s0,16(sp)
    80004ec4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004ec6:	fe040613          	addi	a2,s0,-32
    80004eca:	fec40593          	addi	a1,s0,-20
    80004ece:	4501                	li	a0,0
    80004ed0:	d43ff0ef          	jal	80004c12 <argfd>
    return -1;
    80004ed4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004ed6:	02054063          	bltz	a0,80004ef6 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004eda:	8dffc0ef          	jal	800017b8 <myproc>
    80004ede:	fec42783          	lw	a5,-20(s0)
    80004ee2:	07e9                	addi	a5,a5,26
    80004ee4:	078e                	slli	a5,a5,0x3
    80004ee6:	953e                	add	a0,a0,a5
    80004ee8:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004eec:	fe043503          	ld	a0,-32(s0)
    80004ef0:	bc4ff0ef          	jal	800042b4 <fileclose>
  return 0;
    80004ef4:	4781                	li	a5,0
}
    80004ef6:	853e                	mv	a0,a5
    80004ef8:	60e2                	ld	ra,24(sp)
    80004efa:	6442                	ld	s0,16(sp)
    80004efc:	6105                	addi	sp,sp,32
    80004efe:	8082                	ret

0000000080004f00 <sys_fstat>:
{
    80004f00:	1101                	addi	sp,sp,-32
    80004f02:	ec06                	sd	ra,24(sp)
    80004f04:	e822                	sd	s0,16(sp)
    80004f06:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004f08:	fe040593          	addi	a1,s0,-32
    80004f0c:	4505                	li	a0,1
    80004f0e:	88bfd0ef          	jal	80002798 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004f12:	fe840613          	addi	a2,s0,-24
    80004f16:	4581                	li	a1,0
    80004f18:	4501                	li	a0,0
    80004f1a:	cf9ff0ef          	jal	80004c12 <argfd>
    80004f1e:	87aa                	mv	a5,a0
    return -1;
    80004f20:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004f22:	0007c863          	bltz	a5,80004f32 <sys_fstat+0x32>
  return filestat(f, st);
    80004f26:	fe043583          	ld	a1,-32(s0)
    80004f2a:	fe843503          	ld	a0,-24(s0)
    80004f2e:	c48ff0ef          	jal	80004376 <filestat>
}
    80004f32:	60e2                	ld	ra,24(sp)
    80004f34:	6442                	ld	s0,16(sp)
    80004f36:	6105                	addi	sp,sp,32
    80004f38:	8082                	ret

0000000080004f3a <sys_link>:
{
    80004f3a:	7169                	addi	sp,sp,-304
    80004f3c:	f606                	sd	ra,296(sp)
    80004f3e:	f222                	sd	s0,288(sp)
    80004f40:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004f42:	08000613          	li	a2,128
    80004f46:	ed040593          	addi	a1,s0,-304
    80004f4a:	4501                	li	a0,0
    80004f4c:	86bfd0ef          	jal	800027b6 <argstr>
    return -1;
    80004f50:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004f52:	0c054e63          	bltz	a0,8000502e <sys_link+0xf4>
    80004f56:	08000613          	li	a2,128
    80004f5a:	f5040593          	addi	a1,s0,-176
    80004f5e:	4505                	li	a0,1
    80004f60:	857fd0ef          	jal	800027b6 <argstr>
    return -1;
    80004f64:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004f66:	0c054463          	bltz	a0,8000502e <sys_link+0xf4>
    80004f6a:	ee26                	sd	s1,280(sp)
  begin_op();
    80004f6c:	f2ffe0ef          	jal	80003e9a <begin_op>
  if((ip = namei(old)) == 0){
    80004f70:	ed040513          	addi	a0,s0,-304
    80004f74:	d6bfe0ef          	jal	80003cde <namei>
    80004f78:	84aa                	mv	s1,a0
    80004f7a:	c53d                	beqz	a0,80004fe8 <sys_link+0xae>
  ilock(ip);
    80004f7c:	e88fe0ef          	jal	80003604 <ilock>
  if(ip->type == T_DIR){
    80004f80:	04c49703          	lh	a4,76(s1)
    80004f84:	4785                	li	a5,1
    80004f86:	06f70663          	beq	a4,a5,80004ff2 <sys_link+0xb8>
    80004f8a:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004f8c:	0524d783          	lhu	a5,82(s1)
    80004f90:	2785                	addiw	a5,a5,1
    80004f92:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004f96:	8526                	mv	a0,s1
    80004f98:	db8fe0ef          	jal	80003550 <iupdate>
  iunlock(ip);
    80004f9c:	8526                	mv	a0,s1
    80004f9e:	f14fe0ef          	jal	800036b2 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004fa2:	fd040593          	addi	a1,s0,-48
    80004fa6:	f5040513          	addi	a0,s0,-176
    80004faa:	d4ffe0ef          	jal	80003cf8 <nameiparent>
    80004fae:	892a                	mv	s2,a0
    80004fb0:	cd21                	beqz	a0,80005008 <sys_link+0xce>
  ilock(dp);
    80004fb2:	e52fe0ef          	jal	80003604 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004fb6:	00092703          	lw	a4,0(s2)
    80004fba:	409c                	lw	a5,0(s1)
    80004fbc:	04f71363          	bne	a4,a5,80005002 <sys_link+0xc8>
    80004fc0:	40d0                	lw	a2,4(s1)
    80004fc2:	fd040593          	addi	a1,s0,-48
    80004fc6:	854a                	mv	a0,s2
    80004fc8:	c7dfe0ef          	jal	80003c44 <dirlink>
    80004fcc:	02054b63          	bltz	a0,80005002 <sys_link+0xc8>
  iunlockput(dp);
    80004fd0:	854a                	mv	a0,s2
    80004fd2:	83dfe0ef          	jal	8000380e <iunlockput>
  iput(ip);
    80004fd6:	8526                	mv	a0,s1
    80004fd8:	faefe0ef          	jal	80003786 <iput>
  end_op();
    80004fdc:	f29fe0ef          	jal	80003f04 <end_op>
  return 0;
    80004fe0:	4781                	li	a5,0
    80004fe2:	64f2                	ld	s1,280(sp)
    80004fe4:	6952                	ld	s2,272(sp)
    80004fe6:	a0a1                	j	8000502e <sys_link+0xf4>
    end_op();
    80004fe8:	f1dfe0ef          	jal	80003f04 <end_op>
    return -1;
    80004fec:	57fd                	li	a5,-1
    80004fee:	64f2                	ld	s1,280(sp)
    80004ff0:	a83d                	j	8000502e <sys_link+0xf4>
    iunlockput(ip);
    80004ff2:	8526                	mv	a0,s1
    80004ff4:	81bfe0ef          	jal	8000380e <iunlockput>
    end_op();
    80004ff8:	f0dfe0ef          	jal	80003f04 <end_op>
    return -1;
    80004ffc:	57fd                	li	a5,-1
    80004ffe:	64f2                	ld	s1,280(sp)
    80005000:	a03d                	j	8000502e <sys_link+0xf4>
    iunlockput(dp);
    80005002:	854a                	mv	a0,s2
    80005004:	80bfe0ef          	jal	8000380e <iunlockput>
  ilock(ip);
    80005008:	8526                	mv	a0,s1
    8000500a:	dfafe0ef          	jal	80003604 <ilock>
  ip->nlink--;
    8000500e:	0524d783          	lhu	a5,82(s1)
    80005012:	37fd                	addiw	a5,a5,-1
    80005014:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80005018:	8526                	mv	a0,s1
    8000501a:	d36fe0ef          	jal	80003550 <iupdate>
  iunlockput(ip);
    8000501e:	8526                	mv	a0,s1
    80005020:	feefe0ef          	jal	8000380e <iunlockput>
  end_op();
    80005024:	ee1fe0ef          	jal	80003f04 <end_op>
  return -1;
    80005028:	57fd                	li	a5,-1
    8000502a:	64f2                	ld	s1,280(sp)
    8000502c:	6952                	ld	s2,272(sp)
}
    8000502e:	853e                	mv	a0,a5
    80005030:	70b2                	ld	ra,296(sp)
    80005032:	7412                	ld	s0,288(sp)
    80005034:	6155                	addi	sp,sp,304
    80005036:	8082                	ret

0000000080005038 <sys_unlink>:
{
    80005038:	7151                	addi	sp,sp,-240
    8000503a:	f586                	sd	ra,232(sp)
    8000503c:	f1a2                	sd	s0,224(sp)
    8000503e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005040:	08000613          	li	a2,128
    80005044:	f3040593          	addi	a1,s0,-208
    80005048:	4501                	li	a0,0
    8000504a:	f6cfd0ef          	jal	800027b6 <argstr>
    8000504e:	16054063          	bltz	a0,800051ae <sys_unlink+0x176>
    80005052:	eda6                	sd	s1,216(sp)
  begin_op();
    80005054:	e47fe0ef          	jal	80003e9a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005058:	fb040593          	addi	a1,s0,-80
    8000505c:	f3040513          	addi	a0,s0,-208
    80005060:	c99fe0ef          	jal	80003cf8 <nameiparent>
    80005064:	84aa                	mv	s1,a0
    80005066:	c945                	beqz	a0,80005116 <sys_unlink+0xde>
  ilock(dp);
    80005068:	d9cfe0ef          	jal	80003604 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000506c:	00004597          	auipc	a1,0x4
    80005070:	a7c58593          	addi	a1,a1,-1412 # 80008ae8 <etext+0xae8>
    80005074:	fb040513          	addi	a0,s0,-80
    80005078:	9ebfe0ef          	jal	80003a62 <namecmp>
    8000507c:	10050e63          	beqz	a0,80005198 <sys_unlink+0x160>
    80005080:	00004597          	auipc	a1,0x4
    80005084:	a7058593          	addi	a1,a1,-1424 # 80008af0 <etext+0xaf0>
    80005088:	fb040513          	addi	a0,s0,-80
    8000508c:	9d7fe0ef          	jal	80003a62 <namecmp>
    80005090:	10050463          	beqz	a0,80005198 <sys_unlink+0x160>
    80005094:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005096:	f2c40613          	addi	a2,s0,-212
    8000509a:	fb040593          	addi	a1,s0,-80
    8000509e:	8526                	mv	a0,s1
    800050a0:	9d9fe0ef          	jal	80003a78 <dirlookup>
    800050a4:	892a                	mv	s2,a0
    800050a6:	0e050863          	beqz	a0,80005196 <sys_unlink+0x15e>
  ilock(ip);
    800050aa:	d5afe0ef          	jal	80003604 <ilock>
  if(ip->nlink < 1)
    800050ae:	05291783          	lh	a5,82(s2)
    800050b2:	06f05763          	blez	a5,80005120 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800050b6:	04c91703          	lh	a4,76(s2)
    800050ba:	4785                	li	a5,1
    800050bc:	06f70963          	beq	a4,a5,8000512e <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800050c0:	4641                	li	a2,16
    800050c2:	4581                	li	a1,0
    800050c4:	fc040513          	addi	a0,s0,-64
    800050c8:	be6fb0ef          	jal	800004ae <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800050cc:	4741                	li	a4,16
    800050ce:	f2c42683          	lw	a3,-212(s0)
    800050d2:	fc040613          	addi	a2,s0,-64
    800050d6:	4581                	li	a1,0
    800050d8:	8526                	mv	a0,s1
    800050da:	87bfe0ef          	jal	80003954 <writei>
    800050de:	47c1                	li	a5,16
    800050e0:	08f51b63          	bne	a0,a5,80005176 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    800050e4:	04c91703          	lh	a4,76(s2)
    800050e8:	4785                	li	a5,1
    800050ea:	08f70d63          	beq	a4,a5,80005184 <sys_unlink+0x14c>
  iunlockput(dp);
    800050ee:	8526                	mv	a0,s1
    800050f0:	f1efe0ef          	jal	8000380e <iunlockput>
  ip->nlink--;
    800050f4:	05295783          	lhu	a5,82(s2)
    800050f8:	37fd                	addiw	a5,a5,-1
    800050fa:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    800050fe:	854a                	mv	a0,s2
    80005100:	c50fe0ef          	jal	80003550 <iupdate>
  iunlockput(ip);
    80005104:	854a                	mv	a0,s2
    80005106:	f08fe0ef          	jal	8000380e <iunlockput>
  end_op();
    8000510a:	dfbfe0ef          	jal	80003f04 <end_op>
  return 0;
    8000510e:	4501                	li	a0,0
    80005110:	64ee                	ld	s1,216(sp)
    80005112:	694e                	ld	s2,208(sp)
    80005114:	a849                	j	800051a6 <sys_unlink+0x16e>
    end_op();
    80005116:	deffe0ef          	jal	80003f04 <end_op>
    return -1;
    8000511a:	557d                	li	a0,-1
    8000511c:	64ee                	ld	s1,216(sp)
    8000511e:	a061                	j	800051a6 <sys_unlink+0x16e>
    80005120:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005122:	00004517          	auipc	a0,0x4
    80005126:	9d650513          	addi	a0,a0,-1578 # 80008af8 <etext+0xaf8>
    8000512a:	278010ef          	jal	800063a2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000512e:	05492703          	lw	a4,84(s2)
    80005132:	02000793          	li	a5,32
    80005136:	f8e7f5e3          	bgeu	a5,a4,800050c0 <sys_unlink+0x88>
    8000513a:	e5ce                	sd	s3,200(sp)
    8000513c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005140:	4741                	li	a4,16
    80005142:	86ce                	mv	a3,s3
    80005144:	f1840613          	addi	a2,s0,-232
    80005148:	4581                	li	a1,0
    8000514a:	854a                	mv	a0,s2
    8000514c:	f0cfe0ef          	jal	80003858 <readi>
    80005150:	47c1                	li	a5,16
    80005152:	00f51c63          	bne	a0,a5,8000516a <sys_unlink+0x132>
    if(de.inum != 0)
    80005156:	f1845783          	lhu	a5,-232(s0)
    8000515a:	efa1                	bnez	a5,800051b2 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000515c:	29c1                	addiw	s3,s3,16
    8000515e:	05492783          	lw	a5,84(s2)
    80005162:	fcf9efe3          	bltu	s3,a5,80005140 <sys_unlink+0x108>
    80005166:	69ae                	ld	s3,200(sp)
    80005168:	bfa1                	j	800050c0 <sys_unlink+0x88>
      panic("isdirempty: readi");
    8000516a:	00004517          	auipc	a0,0x4
    8000516e:	9a650513          	addi	a0,a0,-1626 # 80008b10 <etext+0xb10>
    80005172:	230010ef          	jal	800063a2 <panic>
    80005176:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80005178:	00004517          	auipc	a0,0x4
    8000517c:	9b050513          	addi	a0,a0,-1616 # 80008b28 <etext+0xb28>
    80005180:	222010ef          	jal	800063a2 <panic>
    dp->nlink--;
    80005184:	0524d783          	lhu	a5,82(s1)
    80005188:	37fd                	addiw	a5,a5,-1
    8000518a:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    8000518e:	8526                	mv	a0,s1
    80005190:	bc0fe0ef          	jal	80003550 <iupdate>
    80005194:	bfa9                	j	800050ee <sys_unlink+0xb6>
    80005196:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005198:	8526                	mv	a0,s1
    8000519a:	e74fe0ef          	jal	8000380e <iunlockput>
  end_op();
    8000519e:	d67fe0ef          	jal	80003f04 <end_op>
  return -1;
    800051a2:	557d                	li	a0,-1
    800051a4:	64ee                	ld	s1,216(sp)
}
    800051a6:	70ae                	ld	ra,232(sp)
    800051a8:	740e                	ld	s0,224(sp)
    800051aa:	616d                	addi	sp,sp,240
    800051ac:	8082                	ret
    return -1;
    800051ae:	557d                	li	a0,-1
    800051b0:	bfdd                	j	800051a6 <sys_unlink+0x16e>
    iunlockput(ip);
    800051b2:	854a                	mv	a0,s2
    800051b4:	e5afe0ef          	jal	8000380e <iunlockput>
    goto bad;
    800051b8:	694e                	ld	s2,208(sp)
    800051ba:	69ae                	ld	s3,200(sp)
    800051bc:	bff1                	j	80005198 <sys_unlink+0x160>

00000000800051be <sys_open>:

uint64
sys_open(void)
{
    800051be:	7131                	addi	sp,sp,-192
    800051c0:	fd06                	sd	ra,184(sp)
    800051c2:	f922                	sd	s0,176(sp)
    800051c4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800051c6:	f4c40593          	addi	a1,s0,-180
    800051ca:	4505                	li	a0,1
    800051cc:	daefd0ef          	jal	8000277a <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800051d0:	08000613          	li	a2,128
    800051d4:	f5040593          	addi	a1,s0,-176
    800051d8:	4501                	li	a0,0
    800051da:	ddcfd0ef          	jal	800027b6 <argstr>
    800051de:	87aa                	mv	a5,a0
    return -1;
    800051e0:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800051e2:	0a07c263          	bltz	a5,80005286 <sys_open+0xc8>
    800051e6:	f526                	sd	s1,168(sp)

  begin_op();
    800051e8:	cb3fe0ef          	jal	80003e9a <begin_op>

  if(omode & O_CREATE){
    800051ec:	f4c42783          	lw	a5,-180(s0)
    800051f0:	2007f793          	andi	a5,a5,512
    800051f4:	c3d5                	beqz	a5,80005298 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    800051f6:	4681                	li	a3,0
    800051f8:	4601                	li	a2,0
    800051fa:	4589                	li	a1,2
    800051fc:	f5040513          	addi	a0,s0,-176
    80005200:	aa9ff0ef          	jal	80004ca8 <create>
    80005204:	84aa                	mv	s1,a0
    if(ip == 0){
    80005206:	c541                	beqz	a0,8000528e <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005208:	04c49703          	lh	a4,76(s1)
    8000520c:	478d                	li	a5,3
    8000520e:	00f71763          	bne	a4,a5,8000521c <sys_open+0x5e>
    80005212:	04e4d703          	lhu	a4,78(s1)
    80005216:	47a5                	li	a5,9
    80005218:	0ae7ed63          	bltu	a5,a4,800052d2 <sys_open+0x114>
    8000521c:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000521e:	ff3fe0ef          	jal	80004210 <filealloc>
    80005222:	892a                	mv	s2,a0
    80005224:	c179                	beqz	a0,800052ea <sys_open+0x12c>
    80005226:	ed4e                	sd	s3,152(sp)
    80005228:	a43ff0ef          	jal	80004c6a <fdalloc>
    8000522c:	89aa                	mv	s3,a0
    8000522e:	0a054a63          	bltz	a0,800052e2 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005232:	04c49703          	lh	a4,76(s1)
    80005236:	478d                	li	a5,3
    80005238:	0cf70263          	beq	a4,a5,800052fc <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000523c:	4789                	li	a5,2
    8000523e:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005242:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005246:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000524a:	f4c42783          	lw	a5,-180(s0)
    8000524e:	0017c713          	xori	a4,a5,1
    80005252:	8b05                	andi	a4,a4,1
    80005254:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005258:	0037f713          	andi	a4,a5,3
    8000525c:	00e03733          	snez	a4,a4
    80005260:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005264:	4007f793          	andi	a5,a5,1024
    80005268:	c791                	beqz	a5,80005274 <sys_open+0xb6>
    8000526a:	04c49703          	lh	a4,76(s1)
    8000526e:	4789                	li	a5,2
    80005270:	08f70d63          	beq	a4,a5,8000530a <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80005274:	8526                	mv	a0,s1
    80005276:	c3cfe0ef          	jal	800036b2 <iunlock>
  end_op();
    8000527a:	c8bfe0ef          	jal	80003f04 <end_op>

  return fd;
    8000527e:	854e                	mv	a0,s3
    80005280:	74aa                	ld	s1,168(sp)
    80005282:	790a                	ld	s2,160(sp)
    80005284:	69ea                	ld	s3,152(sp)
}
    80005286:	70ea                	ld	ra,184(sp)
    80005288:	744a                	ld	s0,176(sp)
    8000528a:	6129                	addi	sp,sp,192
    8000528c:	8082                	ret
      end_op();
    8000528e:	c77fe0ef          	jal	80003f04 <end_op>
      return -1;
    80005292:	557d                	li	a0,-1
    80005294:	74aa                	ld	s1,168(sp)
    80005296:	bfc5                	j	80005286 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80005298:	f5040513          	addi	a0,s0,-176
    8000529c:	a43fe0ef          	jal	80003cde <namei>
    800052a0:	84aa                	mv	s1,a0
    800052a2:	c11d                	beqz	a0,800052c8 <sys_open+0x10a>
    ilock(ip);
    800052a4:	b60fe0ef          	jal	80003604 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800052a8:	04c49703          	lh	a4,76(s1)
    800052ac:	4785                	li	a5,1
    800052ae:	f4f71de3          	bne	a4,a5,80005208 <sys_open+0x4a>
    800052b2:	f4c42783          	lw	a5,-180(s0)
    800052b6:	d3bd                	beqz	a5,8000521c <sys_open+0x5e>
      iunlockput(ip);
    800052b8:	8526                	mv	a0,s1
    800052ba:	d54fe0ef          	jal	8000380e <iunlockput>
      end_op();
    800052be:	c47fe0ef          	jal	80003f04 <end_op>
      return -1;
    800052c2:	557d                	li	a0,-1
    800052c4:	74aa                	ld	s1,168(sp)
    800052c6:	b7c1                	j	80005286 <sys_open+0xc8>
      end_op();
    800052c8:	c3dfe0ef          	jal	80003f04 <end_op>
      return -1;
    800052cc:	557d                	li	a0,-1
    800052ce:	74aa                	ld	s1,168(sp)
    800052d0:	bf5d                	j	80005286 <sys_open+0xc8>
    iunlockput(ip);
    800052d2:	8526                	mv	a0,s1
    800052d4:	d3afe0ef          	jal	8000380e <iunlockput>
    end_op();
    800052d8:	c2dfe0ef          	jal	80003f04 <end_op>
    return -1;
    800052dc:	557d                	li	a0,-1
    800052de:	74aa                	ld	s1,168(sp)
    800052e0:	b75d                	j	80005286 <sys_open+0xc8>
      fileclose(f);
    800052e2:	854a                	mv	a0,s2
    800052e4:	fd1fe0ef          	jal	800042b4 <fileclose>
    800052e8:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800052ea:	8526                	mv	a0,s1
    800052ec:	d22fe0ef          	jal	8000380e <iunlockput>
    end_op();
    800052f0:	c15fe0ef          	jal	80003f04 <end_op>
    return -1;
    800052f4:	557d                	li	a0,-1
    800052f6:	74aa                	ld	s1,168(sp)
    800052f8:	790a                	ld	s2,160(sp)
    800052fa:	b771                	j	80005286 <sys_open+0xc8>
    f->type = FD_DEVICE;
    800052fc:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005300:	04e49783          	lh	a5,78(s1)
    80005304:	02f91223          	sh	a5,36(s2)
    80005308:	bf3d                	j	80005246 <sys_open+0x88>
    itrunc(ip);
    8000530a:	8526                	mv	a0,s1
    8000530c:	be6fe0ef          	jal	800036f2 <itrunc>
    80005310:	b795                	j	80005274 <sys_open+0xb6>

0000000080005312 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005312:	7175                	addi	sp,sp,-144
    80005314:	e506                	sd	ra,136(sp)
    80005316:	e122                	sd	s0,128(sp)
    80005318:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000531a:	b81fe0ef          	jal	80003e9a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000531e:	08000613          	li	a2,128
    80005322:	f7040593          	addi	a1,s0,-144
    80005326:	4501                	li	a0,0
    80005328:	c8efd0ef          	jal	800027b6 <argstr>
    8000532c:	02054363          	bltz	a0,80005352 <sys_mkdir+0x40>
    80005330:	4681                	li	a3,0
    80005332:	4601                	li	a2,0
    80005334:	4585                	li	a1,1
    80005336:	f7040513          	addi	a0,s0,-144
    8000533a:	96fff0ef          	jal	80004ca8 <create>
    8000533e:	c911                	beqz	a0,80005352 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005340:	ccefe0ef          	jal	8000380e <iunlockput>
  end_op();
    80005344:	bc1fe0ef          	jal	80003f04 <end_op>
  return 0;
    80005348:	4501                	li	a0,0
}
    8000534a:	60aa                	ld	ra,136(sp)
    8000534c:	640a                	ld	s0,128(sp)
    8000534e:	6149                	addi	sp,sp,144
    80005350:	8082                	ret
    end_op();
    80005352:	bb3fe0ef          	jal	80003f04 <end_op>
    return -1;
    80005356:	557d                	li	a0,-1
    80005358:	bfcd                	j	8000534a <sys_mkdir+0x38>

000000008000535a <sys_mknod>:

uint64
sys_mknod(void)
{
    8000535a:	7135                	addi	sp,sp,-160
    8000535c:	ed06                	sd	ra,152(sp)
    8000535e:	e922                	sd	s0,144(sp)
    80005360:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005362:	b39fe0ef          	jal	80003e9a <begin_op>
  argint(1, &major);
    80005366:	f6c40593          	addi	a1,s0,-148
    8000536a:	4505                	li	a0,1
    8000536c:	c0efd0ef          	jal	8000277a <argint>
  argint(2, &minor);
    80005370:	f6840593          	addi	a1,s0,-152
    80005374:	4509                	li	a0,2
    80005376:	c04fd0ef          	jal	8000277a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000537a:	08000613          	li	a2,128
    8000537e:	f7040593          	addi	a1,s0,-144
    80005382:	4501                	li	a0,0
    80005384:	c32fd0ef          	jal	800027b6 <argstr>
    80005388:	02054563          	bltz	a0,800053b2 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000538c:	f6841683          	lh	a3,-152(s0)
    80005390:	f6c41603          	lh	a2,-148(s0)
    80005394:	458d                	li	a1,3
    80005396:	f7040513          	addi	a0,s0,-144
    8000539a:	90fff0ef          	jal	80004ca8 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000539e:	c911                	beqz	a0,800053b2 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800053a0:	c6efe0ef          	jal	8000380e <iunlockput>
  end_op();
    800053a4:	b61fe0ef          	jal	80003f04 <end_op>
  return 0;
    800053a8:	4501                	li	a0,0
}
    800053aa:	60ea                	ld	ra,152(sp)
    800053ac:	644a                	ld	s0,144(sp)
    800053ae:	610d                	addi	sp,sp,160
    800053b0:	8082                	ret
    end_op();
    800053b2:	b53fe0ef          	jal	80003f04 <end_op>
    return -1;
    800053b6:	557d                	li	a0,-1
    800053b8:	bfcd                	j	800053aa <sys_mknod+0x50>

00000000800053ba <sys_chdir>:

uint64
sys_chdir(void)
{
    800053ba:	7135                	addi	sp,sp,-160
    800053bc:	ed06                	sd	ra,152(sp)
    800053be:	e922                	sd	s0,144(sp)
    800053c0:	e14a                	sd	s2,128(sp)
    800053c2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800053c4:	bf4fc0ef          	jal	800017b8 <myproc>
    800053c8:	892a                	mv	s2,a0
  
  begin_op();
    800053ca:	ad1fe0ef          	jal	80003e9a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800053ce:	08000613          	li	a2,128
    800053d2:	f6040593          	addi	a1,s0,-160
    800053d6:	4501                	li	a0,0
    800053d8:	bdefd0ef          	jal	800027b6 <argstr>
    800053dc:	04054363          	bltz	a0,80005422 <sys_chdir+0x68>
    800053e0:	e526                	sd	s1,136(sp)
    800053e2:	f6040513          	addi	a0,s0,-160
    800053e6:	8f9fe0ef          	jal	80003cde <namei>
    800053ea:	84aa                	mv	s1,a0
    800053ec:	c915                	beqz	a0,80005420 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800053ee:	a16fe0ef          	jal	80003604 <ilock>
  if(ip->type != T_DIR){
    800053f2:	04c49703          	lh	a4,76(s1)
    800053f6:	4785                	li	a5,1
    800053f8:	02f71963          	bne	a4,a5,8000542a <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800053fc:	8526                	mv	a0,s1
    800053fe:	ab4fe0ef          	jal	800036b2 <iunlock>
  iput(p->cwd);
    80005402:	15893503          	ld	a0,344(s2)
    80005406:	b80fe0ef          	jal	80003786 <iput>
  end_op();
    8000540a:	afbfe0ef          	jal	80003f04 <end_op>
  p->cwd = ip;
    8000540e:	14993c23          	sd	s1,344(s2)
  return 0;
    80005412:	4501                	li	a0,0
    80005414:	64aa                	ld	s1,136(sp)
}
    80005416:	60ea                	ld	ra,152(sp)
    80005418:	644a                	ld	s0,144(sp)
    8000541a:	690a                	ld	s2,128(sp)
    8000541c:	610d                	addi	sp,sp,160
    8000541e:	8082                	ret
    80005420:	64aa                	ld	s1,136(sp)
    end_op();
    80005422:	ae3fe0ef          	jal	80003f04 <end_op>
    return -1;
    80005426:	557d                	li	a0,-1
    80005428:	b7fd                	j	80005416 <sys_chdir+0x5c>
    iunlockput(ip);
    8000542a:	8526                	mv	a0,s1
    8000542c:	be2fe0ef          	jal	8000380e <iunlockput>
    end_op();
    80005430:	ad5fe0ef          	jal	80003f04 <end_op>
    return -1;
    80005434:	557d                	li	a0,-1
    80005436:	64aa                	ld	s1,136(sp)
    80005438:	bff9                	j	80005416 <sys_chdir+0x5c>

000000008000543a <sys_exec>:

uint64
sys_exec(void)
{
    8000543a:	7121                	addi	sp,sp,-448
    8000543c:	ff06                	sd	ra,440(sp)
    8000543e:	fb22                	sd	s0,432(sp)
    80005440:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005442:	e4840593          	addi	a1,s0,-440
    80005446:	4505                	li	a0,1
    80005448:	b50fd0ef          	jal	80002798 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000544c:	08000613          	li	a2,128
    80005450:	f5040593          	addi	a1,s0,-176
    80005454:	4501                	li	a0,0
    80005456:	b60fd0ef          	jal	800027b6 <argstr>
    8000545a:	87aa                	mv	a5,a0
    return -1;
    8000545c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000545e:	0c07c463          	bltz	a5,80005526 <sys_exec+0xec>
    80005462:	f726                	sd	s1,424(sp)
    80005464:	f34a                	sd	s2,416(sp)
    80005466:	ef4e                	sd	s3,408(sp)
    80005468:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000546a:	10000613          	li	a2,256
    8000546e:	4581                	li	a1,0
    80005470:	e5040513          	addi	a0,s0,-432
    80005474:	83afb0ef          	jal	800004ae <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005478:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000547c:	89a6                	mv	s3,s1
    8000547e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005480:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005484:	00391513          	slli	a0,s2,0x3
    80005488:	e4040593          	addi	a1,s0,-448
    8000548c:	e4843783          	ld	a5,-440(s0)
    80005490:	953e                	add	a0,a0,a5
    80005492:	a5efd0ef          	jal	800026f0 <fetchaddr>
    80005496:	02054663          	bltz	a0,800054c2 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    8000549a:	e4043783          	ld	a5,-448(s0)
    8000549e:	c3a9                	beqz	a5,800054e0 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800054a0:	e01fa0ef          	jal	800002a0 <kalloc>
    800054a4:	85aa                	mv	a1,a0
    800054a6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800054aa:	cd01                	beqz	a0,800054c2 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800054ac:	6605                	lui	a2,0x1
    800054ae:	e4043503          	ld	a0,-448(s0)
    800054b2:	a88fd0ef          	jal	8000273a <fetchstr>
    800054b6:	00054663          	bltz	a0,800054c2 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800054ba:	0905                	addi	s2,s2,1
    800054bc:	09a1                	addi	s3,s3,8
    800054be:	fd4913e3          	bne	s2,s4,80005484 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800054c2:	f5040913          	addi	s2,s0,-176
    800054c6:	6088                	ld	a0,0(s1)
    800054c8:	c931                	beqz	a0,8000551c <sys_exec+0xe2>
    kfree(argv[i]);
    800054ca:	d1dfa0ef          	jal	800001e6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800054ce:	04a1                	addi	s1,s1,8
    800054d0:	ff249be3          	bne	s1,s2,800054c6 <sys_exec+0x8c>
  return -1;
    800054d4:	557d                	li	a0,-1
    800054d6:	74ba                	ld	s1,424(sp)
    800054d8:	791a                	ld	s2,416(sp)
    800054da:	69fa                	ld	s3,408(sp)
    800054dc:	6a5a                	ld	s4,400(sp)
    800054de:	a0a1                	j	80005526 <sys_exec+0xec>
      argv[i] = 0;
    800054e0:	0009079b          	sext.w	a5,s2
    800054e4:	078e                	slli	a5,a5,0x3
    800054e6:	fd078793          	addi	a5,a5,-48
    800054ea:	97a2                	add	a5,a5,s0
    800054ec:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800054f0:	e5040593          	addi	a1,s0,-432
    800054f4:	f5040513          	addi	a0,s0,-176
    800054f8:	ba0ff0ef          	jal	80004898 <exec>
    800054fc:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800054fe:	f5040993          	addi	s3,s0,-176
    80005502:	6088                	ld	a0,0(s1)
    80005504:	c511                	beqz	a0,80005510 <sys_exec+0xd6>
    kfree(argv[i]);
    80005506:	ce1fa0ef          	jal	800001e6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000550a:	04a1                	addi	s1,s1,8
    8000550c:	ff349be3          	bne	s1,s3,80005502 <sys_exec+0xc8>
  return ret;
    80005510:	854a                	mv	a0,s2
    80005512:	74ba                	ld	s1,424(sp)
    80005514:	791a                	ld	s2,416(sp)
    80005516:	69fa                	ld	s3,408(sp)
    80005518:	6a5a                	ld	s4,400(sp)
    8000551a:	a031                	j	80005526 <sys_exec+0xec>
  return -1;
    8000551c:	557d                	li	a0,-1
    8000551e:	74ba                	ld	s1,424(sp)
    80005520:	791a                	ld	s2,416(sp)
    80005522:	69fa                	ld	s3,408(sp)
    80005524:	6a5a                	ld	s4,400(sp)
}
    80005526:	70fa                	ld	ra,440(sp)
    80005528:	745a                	ld	s0,432(sp)
    8000552a:	6139                	addi	sp,sp,448
    8000552c:	8082                	ret

000000008000552e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000552e:	7139                	addi	sp,sp,-64
    80005530:	fc06                	sd	ra,56(sp)
    80005532:	f822                	sd	s0,48(sp)
    80005534:	f426                	sd	s1,40(sp)
    80005536:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005538:	a80fc0ef          	jal	800017b8 <myproc>
    8000553c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000553e:	fd840593          	addi	a1,s0,-40
    80005542:	4501                	li	a0,0
    80005544:	a54fd0ef          	jal	80002798 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005548:	fc840593          	addi	a1,s0,-56
    8000554c:	fd040513          	addi	a0,s0,-48
    80005550:	86eff0ef          	jal	800045be <pipealloc>
    return -1;
    80005554:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005556:	0a054463          	bltz	a0,800055fe <sys_pipe+0xd0>
  fd0 = -1;
    8000555a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000555e:	fd043503          	ld	a0,-48(s0)
    80005562:	f08ff0ef          	jal	80004c6a <fdalloc>
    80005566:	fca42223          	sw	a0,-60(s0)
    8000556a:	08054163          	bltz	a0,800055ec <sys_pipe+0xbe>
    8000556e:	fc843503          	ld	a0,-56(s0)
    80005572:	ef8ff0ef          	jal	80004c6a <fdalloc>
    80005576:	fca42023          	sw	a0,-64(s0)
    8000557a:	06054063          	bltz	a0,800055da <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000557e:	4691                	li	a3,4
    80005580:	fc440613          	addi	a2,s0,-60
    80005584:	fd843583          	ld	a1,-40(s0)
    80005588:	6ca8                	ld	a0,88(s1)
    8000558a:	b13fb0ef          	jal	8000109c <copyout>
    8000558e:	00054e63          	bltz	a0,800055aa <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005592:	4691                	li	a3,4
    80005594:	fc040613          	addi	a2,s0,-64
    80005598:	fd843583          	ld	a1,-40(s0)
    8000559c:	0591                	addi	a1,a1,4
    8000559e:	6ca8                	ld	a0,88(s1)
    800055a0:	afdfb0ef          	jal	8000109c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800055a4:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800055a6:	04055c63          	bgez	a0,800055fe <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800055aa:	fc442783          	lw	a5,-60(s0)
    800055ae:	07e9                	addi	a5,a5,26
    800055b0:	078e                	slli	a5,a5,0x3
    800055b2:	97a6                	add	a5,a5,s1
    800055b4:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800055b8:	fc042783          	lw	a5,-64(s0)
    800055bc:	07e9                	addi	a5,a5,26
    800055be:	078e                	slli	a5,a5,0x3
    800055c0:	94be                	add	s1,s1,a5
    800055c2:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    800055c6:	fd043503          	ld	a0,-48(s0)
    800055ca:	cebfe0ef          	jal	800042b4 <fileclose>
    fileclose(wf);
    800055ce:	fc843503          	ld	a0,-56(s0)
    800055d2:	ce3fe0ef          	jal	800042b4 <fileclose>
    return -1;
    800055d6:	57fd                	li	a5,-1
    800055d8:	a01d                	j	800055fe <sys_pipe+0xd0>
    if(fd0 >= 0)
    800055da:	fc442783          	lw	a5,-60(s0)
    800055de:	0007c763          	bltz	a5,800055ec <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800055e2:	07e9                	addi	a5,a5,26
    800055e4:	078e                	slli	a5,a5,0x3
    800055e6:	97a6                	add	a5,a5,s1
    800055e8:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    800055ec:	fd043503          	ld	a0,-48(s0)
    800055f0:	cc5fe0ef          	jal	800042b4 <fileclose>
    fileclose(wf);
    800055f4:	fc843503          	ld	a0,-56(s0)
    800055f8:	cbdfe0ef          	jal	800042b4 <fileclose>
    return -1;
    800055fc:	57fd                	li	a5,-1
}
    800055fe:	853e                	mv	a0,a5
    80005600:	70e2                	ld	ra,56(sp)
    80005602:	7442                	ld	s0,48(sp)
    80005604:	74a2                	ld	s1,40(sp)
    80005606:	6121                	addi	sp,sp,64
    80005608:	8082                	ret
    8000560a:	0000                	unimp
    8000560c:	0000                	unimp
	...

0000000080005610 <kernelvec>:
    80005610:	7111                	addi	sp,sp,-256
    80005612:	e006                	sd	ra,0(sp)
    80005614:	e40a                	sd	sp,8(sp)
    80005616:	e80e                	sd	gp,16(sp)
    80005618:	ec12                	sd	tp,24(sp)
    8000561a:	f016                	sd	t0,32(sp)
    8000561c:	f41a                	sd	t1,40(sp)
    8000561e:	f81e                	sd	t2,48(sp)
    80005620:	e4aa                	sd	a0,72(sp)
    80005622:	e8ae                	sd	a1,80(sp)
    80005624:	ecb2                	sd	a2,88(sp)
    80005626:	f0b6                	sd	a3,96(sp)
    80005628:	f4ba                	sd	a4,104(sp)
    8000562a:	f8be                	sd	a5,112(sp)
    8000562c:	fcc2                	sd	a6,120(sp)
    8000562e:	e146                	sd	a7,128(sp)
    80005630:	edf2                	sd	t3,216(sp)
    80005632:	f1f6                	sd	t4,224(sp)
    80005634:	f5fa                	sd	t5,232(sp)
    80005636:	f9fe                	sd	t6,240(sp)
    80005638:	fc9fc0ef          	jal	80002600 <kerneltrap>
    8000563c:	6082                	ld	ra,0(sp)
    8000563e:	6122                	ld	sp,8(sp)
    80005640:	61c2                	ld	gp,16(sp)
    80005642:	7282                	ld	t0,32(sp)
    80005644:	7322                	ld	t1,40(sp)
    80005646:	73c2                	ld	t2,48(sp)
    80005648:	6526                	ld	a0,72(sp)
    8000564a:	65c6                	ld	a1,80(sp)
    8000564c:	6666                	ld	a2,88(sp)
    8000564e:	7686                	ld	a3,96(sp)
    80005650:	7726                	ld	a4,104(sp)
    80005652:	77c6                	ld	a5,112(sp)
    80005654:	7866                	ld	a6,120(sp)
    80005656:	688a                	ld	a7,128(sp)
    80005658:	6e6e                	ld	t3,216(sp)
    8000565a:	7e8e                	ld	t4,224(sp)
    8000565c:	7f2e                	ld	t5,232(sp)
    8000565e:	7fce                	ld	t6,240(sp)
    80005660:	6111                	addi	sp,sp,256
    80005662:	10200073          	sret
	...

000000008000566e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000566e:	1141                	addi	sp,sp,-16
    80005670:	e422                	sd	s0,8(sp)
    80005672:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005674:	0c0007b7          	lui	a5,0xc000
    80005678:	4705                	li	a4,1
    8000567a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000567c:	0c0007b7          	lui	a5,0xc000
    80005680:	c3d8                	sw	a4,4(a5)
}
    80005682:	6422                	ld	s0,8(sp)
    80005684:	0141                	addi	sp,sp,16
    80005686:	8082                	ret

0000000080005688 <plicinithart>:

void
plicinithart(void)
{
    80005688:	1141                	addi	sp,sp,-16
    8000568a:	e406                	sd	ra,8(sp)
    8000568c:	e022                	sd	s0,0(sp)
    8000568e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005690:	8fcfc0ef          	jal	8000178c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005694:	0085171b          	slliw	a4,a0,0x8
    80005698:	0c0027b7          	lui	a5,0xc002
    8000569c:	97ba                	add	a5,a5,a4
    8000569e:	40200713          	li	a4,1026
    800056a2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800056a6:	00d5151b          	slliw	a0,a0,0xd
    800056aa:	0c2017b7          	lui	a5,0xc201
    800056ae:	97aa                	add	a5,a5,a0
    800056b0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800056b4:	60a2                	ld	ra,8(sp)
    800056b6:	6402                	ld	s0,0(sp)
    800056b8:	0141                	addi	sp,sp,16
    800056ba:	8082                	ret

00000000800056bc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800056bc:	1141                	addi	sp,sp,-16
    800056be:	e406                	sd	ra,8(sp)
    800056c0:	e022                	sd	s0,0(sp)
    800056c2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800056c4:	8c8fc0ef          	jal	8000178c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800056c8:	00d5151b          	slliw	a0,a0,0xd
    800056cc:	0c2017b7          	lui	a5,0xc201
    800056d0:	97aa                	add	a5,a5,a0
  return irq;
}
    800056d2:	43c8                	lw	a0,4(a5)
    800056d4:	60a2                	ld	ra,8(sp)
    800056d6:	6402                	ld	s0,0(sp)
    800056d8:	0141                	addi	sp,sp,16
    800056da:	8082                	ret

00000000800056dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800056dc:	1101                	addi	sp,sp,-32
    800056de:	ec06                	sd	ra,24(sp)
    800056e0:	e822                	sd	s0,16(sp)
    800056e2:	e426                	sd	s1,8(sp)
    800056e4:	1000                	addi	s0,sp,32
    800056e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800056e8:	8a4fc0ef          	jal	8000178c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800056ec:	00d5151b          	slliw	a0,a0,0xd
    800056f0:	0c2017b7          	lui	a5,0xc201
    800056f4:	97aa                	add	a5,a5,a0
    800056f6:	c3c4                	sw	s1,4(a5)
}
    800056f8:	60e2                	ld	ra,24(sp)
    800056fa:	6442                	ld	s0,16(sp)
    800056fc:	64a2                	ld	s1,8(sp)
    800056fe:	6105                	addi	sp,sp,32
    80005700:	8082                	ret

0000000080005702 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005702:	1141                	addi	sp,sp,-16
    80005704:	e406                	sd	ra,8(sp)
    80005706:	e022                	sd	s0,0(sp)
    80005708:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000570a:	479d                	li	a5,7
    8000570c:	04a7ca63          	blt	a5,a0,80005760 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005710:	00018797          	auipc	a5,0x18
    80005714:	16078793          	addi	a5,a5,352 # 8001d870 <disk>
    80005718:	97aa                	add	a5,a5,a0
    8000571a:	0187c783          	lbu	a5,24(a5)
    8000571e:	e7b9                	bnez	a5,8000576c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005720:	00451693          	slli	a3,a0,0x4
    80005724:	00018797          	auipc	a5,0x18
    80005728:	14c78793          	addi	a5,a5,332 # 8001d870 <disk>
    8000572c:	6398                	ld	a4,0(a5)
    8000572e:	9736                	add	a4,a4,a3
    80005730:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005734:	6398                	ld	a4,0(a5)
    80005736:	9736                	add	a4,a4,a3
    80005738:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000573c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005740:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005744:	97aa                	add	a5,a5,a0
    80005746:	4705                	li	a4,1
    80005748:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000574c:	00018517          	auipc	a0,0x18
    80005750:	13c50513          	addi	a0,a0,316 # 8001d888 <disk+0x18>
    80005754:	f54fc0ef          	jal	80001ea8 <wakeup>
}
    80005758:	60a2                	ld	ra,8(sp)
    8000575a:	6402                	ld	s0,0(sp)
    8000575c:	0141                	addi	sp,sp,16
    8000575e:	8082                	ret
    panic("free_desc 1");
    80005760:	00003517          	auipc	a0,0x3
    80005764:	3d850513          	addi	a0,a0,984 # 80008b38 <etext+0xb38>
    80005768:	43b000ef          	jal	800063a2 <panic>
    panic("free_desc 2");
    8000576c:	00003517          	auipc	a0,0x3
    80005770:	3dc50513          	addi	a0,a0,988 # 80008b48 <etext+0xb48>
    80005774:	42f000ef          	jal	800063a2 <panic>

0000000080005778 <virtio_disk_init>:
{
    80005778:	1101                	addi	sp,sp,-32
    8000577a:	ec06                	sd	ra,24(sp)
    8000577c:	e822                	sd	s0,16(sp)
    8000577e:	e426                	sd	s1,8(sp)
    80005780:	e04a                	sd	s2,0(sp)
    80005782:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005784:	00003597          	auipc	a1,0x3
    80005788:	3d458593          	addi	a1,a1,980 # 80008b58 <etext+0xb58>
    8000578c:	00018517          	auipc	a0,0x18
    80005790:	20c50513          	addi	a0,a0,524 # 8001d998 <disk+0x128>
    80005794:	06a010ef          	jal	800067fe <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005798:	100017b7          	lui	a5,0x10001
    8000579c:	4398                	lw	a4,0(a5)
    8000579e:	2701                	sext.w	a4,a4
    800057a0:	747277b7          	lui	a5,0x74727
    800057a4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800057a8:	18f71063          	bne	a4,a5,80005928 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800057ac:	100017b7          	lui	a5,0x10001
    800057b0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800057b2:	439c                	lw	a5,0(a5)
    800057b4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800057b6:	4709                	li	a4,2
    800057b8:	16e79863          	bne	a5,a4,80005928 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800057bc:	100017b7          	lui	a5,0x10001
    800057c0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800057c2:	439c                	lw	a5,0(a5)
    800057c4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800057c6:	16e79163          	bne	a5,a4,80005928 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800057ca:	100017b7          	lui	a5,0x10001
    800057ce:	47d8                	lw	a4,12(a5)
    800057d0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800057d2:	554d47b7          	lui	a5,0x554d4
    800057d6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800057da:	14f71763          	bne	a4,a5,80005928 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    800057de:	100017b7          	lui	a5,0x10001
    800057e2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800057e6:	4705                	li	a4,1
    800057e8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800057ea:	470d                	li	a4,3
    800057ec:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800057ee:	10001737          	lui	a4,0x10001
    800057f2:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800057f4:	c7ffe737          	lui	a4,0xc7ffe
    800057f8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd8867>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800057fc:	8ef9                	and	a3,a3,a4
    800057fe:	10001737          	lui	a4,0x10001
    80005802:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005804:	472d                	li	a4,11
    80005806:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005808:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000580c:	439c                	lw	a5,0(a5)
    8000580e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005812:	8ba1                	andi	a5,a5,8
    80005814:	12078063          	beqz	a5,80005934 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005818:	100017b7          	lui	a5,0x10001
    8000581c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005820:	100017b7          	lui	a5,0x10001
    80005824:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005828:	439c                	lw	a5,0(a5)
    8000582a:	2781                	sext.w	a5,a5
    8000582c:	10079a63          	bnez	a5,80005940 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005830:	100017b7          	lui	a5,0x10001
    80005834:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005838:	439c                	lw	a5,0(a5)
    8000583a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000583c:	10078863          	beqz	a5,8000594c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005840:	471d                	li	a4,7
    80005842:	10f77b63          	bgeu	a4,a5,80005958 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005846:	a5bfa0ef          	jal	800002a0 <kalloc>
    8000584a:	00018497          	auipc	s1,0x18
    8000584e:	02648493          	addi	s1,s1,38 # 8001d870 <disk>
    80005852:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005854:	a4dfa0ef          	jal	800002a0 <kalloc>
    80005858:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000585a:	a47fa0ef          	jal	800002a0 <kalloc>
    8000585e:	87aa                	mv	a5,a0
    80005860:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005862:	6088                	ld	a0,0(s1)
    80005864:	10050063          	beqz	a0,80005964 <virtio_disk_init+0x1ec>
    80005868:	00018717          	auipc	a4,0x18
    8000586c:	01073703          	ld	a4,16(a4) # 8001d878 <disk+0x8>
    80005870:	0e070a63          	beqz	a4,80005964 <virtio_disk_init+0x1ec>
    80005874:	0e078863          	beqz	a5,80005964 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005878:	6605                	lui	a2,0x1
    8000587a:	4581                	li	a1,0
    8000587c:	c33fa0ef          	jal	800004ae <memset>
  memset(disk.avail, 0, PGSIZE);
    80005880:	00018497          	auipc	s1,0x18
    80005884:	ff048493          	addi	s1,s1,-16 # 8001d870 <disk>
    80005888:	6605                	lui	a2,0x1
    8000588a:	4581                	li	a1,0
    8000588c:	6488                	ld	a0,8(s1)
    8000588e:	c21fa0ef          	jal	800004ae <memset>
  memset(disk.used, 0, PGSIZE);
    80005892:	6605                	lui	a2,0x1
    80005894:	4581                	li	a1,0
    80005896:	6888                	ld	a0,16(s1)
    80005898:	c17fa0ef          	jal	800004ae <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000589c:	100017b7          	lui	a5,0x10001
    800058a0:	4721                	li	a4,8
    800058a2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800058a4:	4098                	lw	a4,0(s1)
    800058a6:	100017b7          	lui	a5,0x10001
    800058aa:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800058ae:	40d8                	lw	a4,4(s1)
    800058b0:	100017b7          	lui	a5,0x10001
    800058b4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800058b8:	649c                	ld	a5,8(s1)
    800058ba:	0007869b          	sext.w	a3,a5
    800058be:	10001737          	lui	a4,0x10001
    800058c2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800058c6:	9781                	srai	a5,a5,0x20
    800058c8:	10001737          	lui	a4,0x10001
    800058cc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800058d0:	689c                	ld	a5,16(s1)
    800058d2:	0007869b          	sext.w	a3,a5
    800058d6:	10001737          	lui	a4,0x10001
    800058da:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800058de:	9781                	srai	a5,a5,0x20
    800058e0:	10001737          	lui	a4,0x10001
    800058e4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800058e8:	10001737          	lui	a4,0x10001
    800058ec:	4785                	li	a5,1
    800058ee:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800058f0:	00f48c23          	sb	a5,24(s1)
    800058f4:	00f48ca3          	sb	a5,25(s1)
    800058f8:	00f48d23          	sb	a5,26(s1)
    800058fc:	00f48da3          	sb	a5,27(s1)
    80005900:	00f48e23          	sb	a5,28(s1)
    80005904:	00f48ea3          	sb	a5,29(s1)
    80005908:	00f48f23          	sb	a5,30(s1)
    8000590c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005910:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005914:	100017b7          	lui	a5,0x10001
    80005918:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000591c:	60e2                	ld	ra,24(sp)
    8000591e:	6442                	ld	s0,16(sp)
    80005920:	64a2                	ld	s1,8(sp)
    80005922:	6902                	ld	s2,0(sp)
    80005924:	6105                	addi	sp,sp,32
    80005926:	8082                	ret
    panic("could not find virtio disk");
    80005928:	00003517          	auipc	a0,0x3
    8000592c:	24050513          	addi	a0,a0,576 # 80008b68 <etext+0xb68>
    80005930:	273000ef          	jal	800063a2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005934:	00003517          	auipc	a0,0x3
    80005938:	25450513          	addi	a0,a0,596 # 80008b88 <etext+0xb88>
    8000593c:	267000ef          	jal	800063a2 <panic>
    panic("virtio disk should not be ready");
    80005940:	00003517          	auipc	a0,0x3
    80005944:	26850513          	addi	a0,a0,616 # 80008ba8 <etext+0xba8>
    80005948:	25b000ef          	jal	800063a2 <panic>
    panic("virtio disk has no queue 0");
    8000594c:	00003517          	auipc	a0,0x3
    80005950:	27c50513          	addi	a0,a0,636 # 80008bc8 <etext+0xbc8>
    80005954:	24f000ef          	jal	800063a2 <panic>
    panic("virtio disk max queue too short");
    80005958:	00003517          	auipc	a0,0x3
    8000595c:	29050513          	addi	a0,a0,656 # 80008be8 <etext+0xbe8>
    80005960:	243000ef          	jal	800063a2 <panic>
    panic("virtio disk kalloc");
    80005964:	00003517          	auipc	a0,0x3
    80005968:	2a450513          	addi	a0,a0,676 # 80008c08 <etext+0xc08>
    8000596c:	237000ef          	jal	800063a2 <panic>

0000000080005970 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005970:	7159                	addi	sp,sp,-112
    80005972:	f486                	sd	ra,104(sp)
    80005974:	f0a2                	sd	s0,96(sp)
    80005976:	eca6                	sd	s1,88(sp)
    80005978:	e8ca                	sd	s2,80(sp)
    8000597a:	e4ce                	sd	s3,72(sp)
    8000597c:	e0d2                	sd	s4,64(sp)
    8000597e:	fc56                	sd	s5,56(sp)
    80005980:	f85a                	sd	s6,48(sp)
    80005982:	f45e                	sd	s7,40(sp)
    80005984:	f062                	sd	s8,32(sp)
    80005986:	ec66                	sd	s9,24(sp)
    80005988:	1880                	addi	s0,sp,112
    8000598a:	8a2a                	mv	s4,a0
    8000598c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000598e:	00c52c83          	lw	s9,12(a0)
    80005992:	001c9c9b          	slliw	s9,s9,0x1
    80005996:	1c82                	slli	s9,s9,0x20
    80005998:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000599c:	00018517          	auipc	a0,0x18
    800059a0:	ffc50513          	addi	a0,a0,-4 # 8001d998 <disk+0x128>
    800059a4:	553000ef          	jal	800066f6 <acquire>
  for(int i = 0; i < 3; i++){
    800059a8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800059aa:	44a1                	li	s1,8
      disk.free[i] = 0;
    800059ac:	00018b17          	auipc	s6,0x18
    800059b0:	ec4b0b13          	addi	s6,s6,-316 # 8001d870 <disk>
  for(int i = 0; i < 3; i++){
    800059b4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800059b6:	00018c17          	auipc	s8,0x18
    800059ba:	fe2c0c13          	addi	s8,s8,-30 # 8001d998 <disk+0x128>
    800059be:	a8b9                	j	80005a1c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    800059c0:	00fb0733          	add	a4,s6,a5
    800059c4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    800059c8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800059ca:	0207c563          	bltz	a5,800059f4 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    800059ce:	2905                	addiw	s2,s2,1
    800059d0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800059d2:	05590963          	beq	s2,s5,80005a24 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    800059d6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800059d8:	00018717          	auipc	a4,0x18
    800059dc:	e9870713          	addi	a4,a4,-360 # 8001d870 <disk>
    800059e0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800059e2:	01874683          	lbu	a3,24(a4)
    800059e6:	fee9                	bnez	a3,800059c0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    800059e8:	2785                	addiw	a5,a5,1
    800059ea:	0705                	addi	a4,a4,1
    800059ec:	fe979be3          	bne	a5,s1,800059e2 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    800059f0:	57fd                	li	a5,-1
    800059f2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800059f4:	01205d63          	blez	s2,80005a0e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    800059f8:	f9042503          	lw	a0,-112(s0)
    800059fc:	d07ff0ef          	jal	80005702 <free_desc>
      for(int j = 0; j < i; j++)
    80005a00:	4785                	li	a5,1
    80005a02:	0127d663          	bge	a5,s2,80005a0e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005a06:	f9442503          	lw	a0,-108(s0)
    80005a0a:	cf9ff0ef          	jal	80005702 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005a0e:	85e2                	mv	a1,s8
    80005a10:	00018517          	auipc	a0,0x18
    80005a14:	e7850513          	addi	a0,a0,-392 # 8001d888 <disk+0x18>
    80005a18:	c44fc0ef          	jal	80001e5c <sleep>
  for(int i = 0; i < 3; i++){
    80005a1c:	f9040613          	addi	a2,s0,-112
    80005a20:	894e                	mv	s2,s3
    80005a22:	bf55                	j	800059d6 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005a24:	f9042503          	lw	a0,-112(s0)
    80005a28:	00451693          	slli	a3,a0,0x4

  if(write)
    80005a2c:	00018797          	auipc	a5,0x18
    80005a30:	e4478793          	addi	a5,a5,-444 # 8001d870 <disk>
    80005a34:	00a50713          	addi	a4,a0,10
    80005a38:	0712                	slli	a4,a4,0x4
    80005a3a:	973e                	add	a4,a4,a5
    80005a3c:	01703633          	snez	a2,s7
    80005a40:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005a42:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005a46:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005a4a:	6398                	ld	a4,0(a5)
    80005a4c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005a4e:	0a868613          	addi	a2,a3,168
    80005a52:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005a54:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005a56:	6390                	ld	a2,0(a5)
    80005a58:	00d605b3          	add	a1,a2,a3
    80005a5c:	4741                	li	a4,16
    80005a5e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005a60:	4805                	li	a6,1
    80005a62:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005a66:	f9442703          	lw	a4,-108(s0)
    80005a6a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005a6e:	0712                	slli	a4,a4,0x4
    80005a70:	963a                	add	a2,a2,a4
    80005a72:	060a0593          	addi	a1,s4,96
    80005a76:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005a78:	0007b883          	ld	a7,0(a5)
    80005a7c:	9746                	add	a4,a4,a7
    80005a7e:	40000613          	li	a2,1024
    80005a82:	c710                	sw	a2,8(a4)
  if(write)
    80005a84:	001bb613          	seqz	a2,s7
    80005a88:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005a8c:	00166613          	ori	a2,a2,1
    80005a90:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005a94:	f9842583          	lw	a1,-104(s0)
    80005a98:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005a9c:	00250613          	addi	a2,a0,2
    80005aa0:	0612                	slli	a2,a2,0x4
    80005aa2:	963e                	add	a2,a2,a5
    80005aa4:	577d                	li	a4,-1
    80005aa6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005aaa:	0592                	slli	a1,a1,0x4
    80005aac:	98ae                	add	a7,a7,a1
    80005aae:	03068713          	addi	a4,a3,48
    80005ab2:	973e                	add	a4,a4,a5
    80005ab4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005ab8:	6398                	ld	a4,0(a5)
    80005aba:	972e                	add	a4,a4,a1
    80005abc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005ac0:	4689                	li	a3,2
    80005ac2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005ac6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005aca:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005ace:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005ad2:	6794                	ld	a3,8(a5)
    80005ad4:	0026d703          	lhu	a4,2(a3)
    80005ad8:	8b1d                	andi	a4,a4,7
    80005ada:	0706                	slli	a4,a4,0x1
    80005adc:	96ba                	add	a3,a3,a4
    80005ade:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005ae2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005ae6:	6798                	ld	a4,8(a5)
    80005ae8:	00275783          	lhu	a5,2(a4)
    80005aec:	2785                	addiw	a5,a5,1
    80005aee:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005af2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005af6:	100017b7          	lui	a5,0x10001
    80005afa:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005afe:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005b02:	00018917          	auipc	s2,0x18
    80005b06:	e9690913          	addi	s2,s2,-362 # 8001d998 <disk+0x128>
  while(b->disk == 1) {
    80005b0a:	4485                	li	s1,1
    80005b0c:	01079a63          	bne	a5,a6,80005b20 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005b10:	85ca                	mv	a1,s2
    80005b12:	8552                	mv	a0,s4
    80005b14:	b48fc0ef          	jal	80001e5c <sleep>
  while(b->disk == 1) {
    80005b18:	004a2783          	lw	a5,4(s4)
    80005b1c:	fe978ae3          	beq	a5,s1,80005b10 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005b20:	f9042903          	lw	s2,-112(s0)
    80005b24:	00290713          	addi	a4,s2,2
    80005b28:	0712                	slli	a4,a4,0x4
    80005b2a:	00018797          	auipc	a5,0x18
    80005b2e:	d4678793          	addi	a5,a5,-698 # 8001d870 <disk>
    80005b32:	97ba                	add	a5,a5,a4
    80005b34:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005b38:	00018997          	auipc	s3,0x18
    80005b3c:	d3898993          	addi	s3,s3,-712 # 8001d870 <disk>
    80005b40:	00491713          	slli	a4,s2,0x4
    80005b44:	0009b783          	ld	a5,0(s3)
    80005b48:	97ba                	add	a5,a5,a4
    80005b4a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005b4e:	854a                	mv	a0,s2
    80005b50:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005b54:	bafff0ef          	jal	80005702 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005b58:	8885                	andi	s1,s1,1
    80005b5a:	f0fd                	bnez	s1,80005b40 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005b5c:	00018517          	auipc	a0,0x18
    80005b60:	e3c50513          	addi	a0,a0,-452 # 8001d998 <disk+0x128>
    80005b64:	45f000ef          	jal	800067c2 <release>
}
    80005b68:	70a6                	ld	ra,104(sp)
    80005b6a:	7406                	ld	s0,96(sp)
    80005b6c:	64e6                	ld	s1,88(sp)
    80005b6e:	6946                	ld	s2,80(sp)
    80005b70:	69a6                	ld	s3,72(sp)
    80005b72:	6a06                	ld	s4,64(sp)
    80005b74:	7ae2                	ld	s5,56(sp)
    80005b76:	7b42                	ld	s6,48(sp)
    80005b78:	7ba2                	ld	s7,40(sp)
    80005b7a:	7c02                	ld	s8,32(sp)
    80005b7c:	6ce2                	ld	s9,24(sp)
    80005b7e:	6165                	addi	sp,sp,112
    80005b80:	8082                	ret

0000000080005b82 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005b82:	1101                	addi	sp,sp,-32
    80005b84:	ec06                	sd	ra,24(sp)
    80005b86:	e822                	sd	s0,16(sp)
    80005b88:	e426                	sd	s1,8(sp)
    80005b8a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005b8c:	00018497          	auipc	s1,0x18
    80005b90:	ce448493          	addi	s1,s1,-796 # 8001d870 <disk>
    80005b94:	00018517          	auipc	a0,0x18
    80005b98:	e0450513          	addi	a0,a0,-508 # 8001d998 <disk+0x128>
    80005b9c:	35b000ef          	jal	800066f6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005ba0:	100017b7          	lui	a5,0x10001
    80005ba4:	53b8                	lw	a4,96(a5)
    80005ba6:	8b0d                	andi	a4,a4,3
    80005ba8:	100017b7          	lui	a5,0x10001
    80005bac:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005bae:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005bb2:	689c                	ld	a5,16(s1)
    80005bb4:	0204d703          	lhu	a4,32(s1)
    80005bb8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005bbc:	04f70663          	beq	a4,a5,80005c08 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005bc0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005bc4:	6898                	ld	a4,16(s1)
    80005bc6:	0204d783          	lhu	a5,32(s1)
    80005bca:	8b9d                	andi	a5,a5,7
    80005bcc:	078e                	slli	a5,a5,0x3
    80005bce:	97ba                	add	a5,a5,a4
    80005bd0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005bd2:	00278713          	addi	a4,a5,2
    80005bd6:	0712                	slli	a4,a4,0x4
    80005bd8:	9726                	add	a4,a4,s1
    80005bda:	01074703          	lbu	a4,16(a4)
    80005bde:	e321                	bnez	a4,80005c1e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005be0:	0789                	addi	a5,a5,2
    80005be2:	0792                	slli	a5,a5,0x4
    80005be4:	97a6                	add	a5,a5,s1
    80005be6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005be8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005bec:	abcfc0ef          	jal	80001ea8 <wakeup>

    disk.used_idx += 1;
    80005bf0:	0204d783          	lhu	a5,32(s1)
    80005bf4:	2785                	addiw	a5,a5,1
    80005bf6:	17c2                	slli	a5,a5,0x30
    80005bf8:	93c1                	srli	a5,a5,0x30
    80005bfa:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005bfe:	6898                	ld	a4,16(s1)
    80005c00:	00275703          	lhu	a4,2(a4)
    80005c04:	faf71ee3          	bne	a4,a5,80005bc0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005c08:	00018517          	auipc	a0,0x18
    80005c0c:	d9050513          	addi	a0,a0,-624 # 8001d998 <disk+0x128>
    80005c10:	3b3000ef          	jal	800067c2 <release>
}
    80005c14:	60e2                	ld	ra,24(sp)
    80005c16:	6442                	ld	s0,16(sp)
    80005c18:	64a2                	ld	s1,8(sp)
    80005c1a:	6105                	addi	sp,sp,32
    80005c1c:	8082                	ret
      panic("virtio_disk_intr status");
    80005c1e:	00003517          	auipc	a0,0x3
    80005c22:	00250513          	addi	a0,a0,2 # 80008c20 <etext+0xc20>
    80005c26:	77c000ef          	jal	800063a2 <panic>

0000000080005c2a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80005c2a:	1141                	addi	sp,sp,-16
    80005c2c:	e422                	sd	s0,8(sp)
    80005c2e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005c30:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80005c34:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80005c38:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80005c3c:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80005c40:	577d                	li	a4,-1
    80005c42:	177e                	slli	a4,a4,0x3f
    80005c44:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80005c46:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80005c4a:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80005c4e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80005c52:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80005c56:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80005c5a:	000f4737          	lui	a4,0xf4
    80005c5e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80005c62:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80005c64:	14d79073          	csrw	stimecmp,a5
}
    80005c68:	6422                	ld	s0,8(sp)
    80005c6a:	0141                	addi	sp,sp,16
    80005c6c:	8082                	ret

0000000080005c6e <start>:
{
    80005c6e:	1141                	addi	sp,sp,-16
    80005c70:	e406                	sd	ra,8(sp)
    80005c72:	e022                	sd	s0,0(sp)
    80005c74:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005c76:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005c7a:	7779                	lui	a4,0xffffe
    80005c7c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd8907>
    80005c80:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005c82:	6705                	lui	a4,0x1
    80005c84:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005c88:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005c8a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005c8e:	ffffb797          	auipc	a5,0xffffb
    80005c92:	a9678793          	addi	a5,a5,-1386 # 80000724 <main>
    80005c96:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005c9a:	4781                	li	a5,0
    80005c9c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005ca0:	67c1                	lui	a5,0x10
    80005ca2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005ca4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005ca8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005cac:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005cb0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005cb4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005cb8:	57fd                	li	a5,-1
    80005cba:	83a9                	srli	a5,a5,0xa
    80005cbc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005cc0:	47bd                	li	a5,15
    80005cc2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005cc6:	f65ff0ef          	jal	80005c2a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005cca:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005cce:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005cd0:	823e                	mv	tp,a5
  asm volatile("mret");
    80005cd2:	30200073          	mret
}
    80005cd6:	60a2                	ld	ra,8(sp)
    80005cd8:	6402                	ld	s0,0(sp)
    80005cda:	0141                	addi	sp,sp,16
    80005cdc:	8082                	ret

0000000080005cde <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005cde:	715d                	addi	sp,sp,-80
    80005ce0:	e486                	sd	ra,72(sp)
    80005ce2:	e0a2                	sd	s0,64(sp)
    80005ce4:	f84a                	sd	s2,48(sp)
    80005ce6:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005ce8:	04c05263          	blez	a2,80005d2c <consolewrite+0x4e>
    80005cec:	fc26                	sd	s1,56(sp)
    80005cee:	f44e                	sd	s3,40(sp)
    80005cf0:	f052                	sd	s4,32(sp)
    80005cf2:	ec56                	sd	s5,24(sp)
    80005cf4:	8a2a                	mv	s4,a0
    80005cf6:	84ae                	mv	s1,a1
    80005cf8:	89b2                	mv	s3,a2
    80005cfa:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005cfc:	5afd                	li	s5,-1
    80005cfe:	4685                	li	a3,1
    80005d00:	8626                	mv	a2,s1
    80005d02:	85d2                	mv	a1,s4
    80005d04:	fbf40513          	addi	a0,s0,-65
    80005d08:	cfafc0ef          	jal	80002202 <either_copyin>
    80005d0c:	03550263          	beq	a0,s5,80005d30 <consolewrite+0x52>
      break;
    uartputc(c);
    80005d10:	fbf44503          	lbu	a0,-65(s0)
    80005d14:	035000ef          	jal	80006548 <uartputc>
  for(i = 0; i < n; i++){
    80005d18:	2905                	addiw	s2,s2,1
    80005d1a:	0485                	addi	s1,s1,1
    80005d1c:	ff2991e3          	bne	s3,s2,80005cfe <consolewrite+0x20>
    80005d20:	894e                	mv	s2,s3
    80005d22:	74e2                	ld	s1,56(sp)
    80005d24:	79a2                	ld	s3,40(sp)
    80005d26:	7a02                	ld	s4,32(sp)
    80005d28:	6ae2                	ld	s5,24(sp)
    80005d2a:	a039                	j	80005d38 <consolewrite+0x5a>
    80005d2c:	4901                	li	s2,0
    80005d2e:	a029                	j	80005d38 <consolewrite+0x5a>
    80005d30:	74e2                	ld	s1,56(sp)
    80005d32:	79a2                	ld	s3,40(sp)
    80005d34:	7a02                	ld	s4,32(sp)
    80005d36:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005d38:	854a                	mv	a0,s2
    80005d3a:	60a6                	ld	ra,72(sp)
    80005d3c:	6406                	ld	s0,64(sp)
    80005d3e:	7942                	ld	s2,48(sp)
    80005d40:	6161                	addi	sp,sp,80
    80005d42:	8082                	ret

0000000080005d44 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005d44:	711d                	addi	sp,sp,-96
    80005d46:	ec86                	sd	ra,88(sp)
    80005d48:	e8a2                	sd	s0,80(sp)
    80005d4a:	e4a6                	sd	s1,72(sp)
    80005d4c:	e0ca                	sd	s2,64(sp)
    80005d4e:	fc4e                	sd	s3,56(sp)
    80005d50:	f852                	sd	s4,48(sp)
    80005d52:	f456                	sd	s5,40(sp)
    80005d54:	f05a                	sd	s6,32(sp)
    80005d56:	1080                	addi	s0,sp,96
    80005d58:	8aaa                	mv	s5,a0
    80005d5a:	8a2e                	mv	s4,a1
    80005d5c:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005d5e:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005d62:	00020517          	auipc	a0,0x20
    80005d66:	c5e50513          	addi	a0,a0,-930 # 800259c0 <cons>
    80005d6a:	18d000ef          	jal	800066f6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005d6e:	00020497          	auipc	s1,0x20
    80005d72:	c5248493          	addi	s1,s1,-942 # 800259c0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005d76:	00020917          	auipc	s2,0x20
    80005d7a:	cea90913          	addi	s2,s2,-790 # 80025a60 <cons+0xa0>
  while(n > 0){
    80005d7e:	0b305d63          	blez	s3,80005e38 <consoleread+0xf4>
    while(cons.r == cons.w){
    80005d82:	0a04a783          	lw	a5,160(s1)
    80005d86:	0a44a703          	lw	a4,164(s1)
    80005d8a:	0af71263          	bne	a4,a5,80005e2e <consoleread+0xea>
      if(killed(myproc())){
    80005d8e:	a2bfb0ef          	jal	800017b8 <myproc>
    80005d92:	b02fc0ef          	jal	80002094 <killed>
    80005d96:	e12d                	bnez	a0,80005df8 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80005d98:	85a6                	mv	a1,s1
    80005d9a:	854a                	mv	a0,s2
    80005d9c:	8c0fc0ef          	jal	80001e5c <sleep>
    while(cons.r == cons.w){
    80005da0:	0a04a783          	lw	a5,160(s1)
    80005da4:	0a44a703          	lw	a4,164(s1)
    80005da8:	fef703e3          	beq	a4,a5,80005d8e <consoleread+0x4a>
    80005dac:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005dae:	00020717          	auipc	a4,0x20
    80005db2:	c1270713          	addi	a4,a4,-1006 # 800259c0 <cons>
    80005db6:	0017869b          	addiw	a3,a5,1
    80005dba:	0ad72023          	sw	a3,160(a4)
    80005dbe:	07f7f693          	andi	a3,a5,127
    80005dc2:	9736                	add	a4,a4,a3
    80005dc4:	02074703          	lbu	a4,32(a4)
    80005dc8:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005dcc:	4691                	li	a3,4
    80005dce:	04db8663          	beq	s7,a3,80005e1a <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005dd2:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005dd6:	4685                	li	a3,1
    80005dd8:	faf40613          	addi	a2,s0,-81
    80005ddc:	85d2                	mv	a1,s4
    80005dde:	8556                	mv	a0,s5
    80005de0:	bd8fc0ef          	jal	800021b8 <either_copyout>
    80005de4:	57fd                	li	a5,-1
    80005de6:	04f50863          	beq	a0,a5,80005e36 <consoleread+0xf2>
      break;

    dst++;
    80005dea:	0a05                	addi	s4,s4,1
    --n;
    80005dec:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005dee:	47a9                	li	a5,10
    80005df0:	04fb8d63          	beq	s7,a5,80005e4a <consoleread+0x106>
    80005df4:	6be2                	ld	s7,24(sp)
    80005df6:	b761                	j	80005d7e <consoleread+0x3a>
        release(&cons.lock);
    80005df8:	00020517          	auipc	a0,0x20
    80005dfc:	bc850513          	addi	a0,a0,-1080 # 800259c0 <cons>
    80005e00:	1c3000ef          	jal	800067c2 <release>
        return -1;
    80005e04:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005e06:	60e6                	ld	ra,88(sp)
    80005e08:	6446                	ld	s0,80(sp)
    80005e0a:	64a6                	ld	s1,72(sp)
    80005e0c:	6906                	ld	s2,64(sp)
    80005e0e:	79e2                	ld	s3,56(sp)
    80005e10:	7a42                	ld	s4,48(sp)
    80005e12:	7aa2                	ld	s5,40(sp)
    80005e14:	7b02                	ld	s6,32(sp)
    80005e16:	6125                	addi	sp,sp,96
    80005e18:	8082                	ret
      if(n < target){
    80005e1a:	0009871b          	sext.w	a4,s3
    80005e1e:	01677a63          	bgeu	a4,s6,80005e32 <consoleread+0xee>
        cons.r--;
    80005e22:	00020717          	auipc	a4,0x20
    80005e26:	c2f72f23          	sw	a5,-962(a4) # 80025a60 <cons+0xa0>
    80005e2a:	6be2                	ld	s7,24(sp)
    80005e2c:	a031                	j	80005e38 <consoleread+0xf4>
    80005e2e:	ec5e                	sd	s7,24(sp)
    80005e30:	bfbd                	j	80005dae <consoleread+0x6a>
    80005e32:	6be2                	ld	s7,24(sp)
    80005e34:	a011                	j	80005e38 <consoleread+0xf4>
    80005e36:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005e38:	00020517          	auipc	a0,0x20
    80005e3c:	b8850513          	addi	a0,a0,-1144 # 800259c0 <cons>
    80005e40:	183000ef          	jal	800067c2 <release>
  return target - n;
    80005e44:	413b053b          	subw	a0,s6,s3
    80005e48:	bf7d                	j	80005e06 <consoleread+0xc2>
    80005e4a:	6be2                	ld	s7,24(sp)
    80005e4c:	b7f5                	j	80005e38 <consoleread+0xf4>

0000000080005e4e <consputc>:
{
    80005e4e:	1141                	addi	sp,sp,-16
    80005e50:	e406                	sd	ra,8(sp)
    80005e52:	e022                	sd	s0,0(sp)
    80005e54:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005e56:	10000793          	li	a5,256
    80005e5a:	00f50863          	beq	a0,a5,80005e6a <consputc+0x1c>
    uartputc_sync(c);
    80005e5e:	604000ef          	jal	80006462 <uartputc_sync>
}
    80005e62:	60a2                	ld	ra,8(sp)
    80005e64:	6402                	ld	s0,0(sp)
    80005e66:	0141                	addi	sp,sp,16
    80005e68:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005e6a:	4521                	li	a0,8
    80005e6c:	5f6000ef          	jal	80006462 <uartputc_sync>
    80005e70:	02000513          	li	a0,32
    80005e74:	5ee000ef          	jal	80006462 <uartputc_sync>
    80005e78:	4521                	li	a0,8
    80005e7a:	5e8000ef          	jal	80006462 <uartputc_sync>
    80005e7e:	b7d5                	j	80005e62 <consputc+0x14>

0000000080005e80 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005e80:	1101                	addi	sp,sp,-32
    80005e82:	ec06                	sd	ra,24(sp)
    80005e84:	e822                	sd	s0,16(sp)
    80005e86:	e426                	sd	s1,8(sp)
    80005e88:	1000                	addi	s0,sp,32
    80005e8a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005e8c:	00020517          	auipc	a0,0x20
    80005e90:	b3450513          	addi	a0,a0,-1228 # 800259c0 <cons>
    80005e94:	063000ef          	jal	800066f6 <acquire>

  switch(c){
    80005e98:	47d5                	li	a5,21
    80005e9a:	08f48f63          	beq	s1,a5,80005f38 <consoleintr+0xb8>
    80005e9e:	0297c563          	blt	a5,s1,80005ec8 <consoleintr+0x48>
    80005ea2:	47a1                	li	a5,8
    80005ea4:	0ef48463          	beq	s1,a5,80005f8c <consoleintr+0x10c>
    80005ea8:	47c1                	li	a5,16
    80005eaa:	10f49563          	bne	s1,a5,80005fb4 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    80005eae:	b9efc0ef          	jal	8000224c <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005eb2:	00020517          	auipc	a0,0x20
    80005eb6:	b0e50513          	addi	a0,a0,-1266 # 800259c0 <cons>
    80005eba:	109000ef          	jal	800067c2 <release>
}
    80005ebe:	60e2                	ld	ra,24(sp)
    80005ec0:	6442                	ld	s0,16(sp)
    80005ec2:	64a2                	ld	s1,8(sp)
    80005ec4:	6105                	addi	sp,sp,32
    80005ec6:	8082                	ret
  switch(c){
    80005ec8:	07f00793          	li	a5,127
    80005ecc:	0cf48063          	beq	s1,a5,80005f8c <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005ed0:	00020717          	auipc	a4,0x20
    80005ed4:	af070713          	addi	a4,a4,-1296 # 800259c0 <cons>
    80005ed8:	0a872783          	lw	a5,168(a4)
    80005edc:	0a072703          	lw	a4,160(a4)
    80005ee0:	9f99                	subw	a5,a5,a4
    80005ee2:	07f00713          	li	a4,127
    80005ee6:	fcf766e3          	bltu	a4,a5,80005eb2 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80005eea:	47b5                	li	a5,13
    80005eec:	0cf48763          	beq	s1,a5,80005fba <consoleintr+0x13a>
      consputc(c);
    80005ef0:	8526                	mv	a0,s1
    80005ef2:	f5dff0ef          	jal	80005e4e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005ef6:	00020797          	auipc	a5,0x20
    80005efa:	aca78793          	addi	a5,a5,-1334 # 800259c0 <cons>
    80005efe:	0a87a683          	lw	a3,168(a5)
    80005f02:	0016871b          	addiw	a4,a3,1
    80005f06:	0007061b          	sext.w	a2,a4
    80005f0a:	0ae7a423          	sw	a4,168(a5)
    80005f0e:	07f6f693          	andi	a3,a3,127
    80005f12:	97b6                	add	a5,a5,a3
    80005f14:	02978023          	sb	s1,32(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005f18:	47a9                	li	a5,10
    80005f1a:	0cf48563          	beq	s1,a5,80005fe4 <consoleintr+0x164>
    80005f1e:	4791                	li	a5,4
    80005f20:	0cf48263          	beq	s1,a5,80005fe4 <consoleintr+0x164>
    80005f24:	00020797          	auipc	a5,0x20
    80005f28:	b3c7a783          	lw	a5,-1220(a5) # 80025a60 <cons+0xa0>
    80005f2c:	9f1d                	subw	a4,a4,a5
    80005f2e:	08000793          	li	a5,128
    80005f32:	f8f710e3          	bne	a4,a5,80005eb2 <consoleintr+0x32>
    80005f36:	a07d                	j	80005fe4 <consoleintr+0x164>
    80005f38:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005f3a:	00020717          	auipc	a4,0x20
    80005f3e:	a8670713          	addi	a4,a4,-1402 # 800259c0 <cons>
    80005f42:	0a872783          	lw	a5,168(a4)
    80005f46:	0a472703          	lw	a4,164(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005f4a:	00020497          	auipc	s1,0x20
    80005f4e:	a7648493          	addi	s1,s1,-1418 # 800259c0 <cons>
    while(cons.e != cons.w &&
    80005f52:	4929                	li	s2,10
    80005f54:	02f70863          	beq	a4,a5,80005f84 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005f58:	37fd                	addiw	a5,a5,-1
    80005f5a:	07f7f713          	andi	a4,a5,127
    80005f5e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005f60:	02074703          	lbu	a4,32(a4)
    80005f64:	03270263          	beq	a4,s2,80005f88 <consoleintr+0x108>
      cons.e--;
    80005f68:	0af4a423          	sw	a5,168(s1)
      consputc(BACKSPACE);
    80005f6c:	10000513          	li	a0,256
    80005f70:	edfff0ef          	jal	80005e4e <consputc>
    while(cons.e != cons.w &&
    80005f74:	0a84a783          	lw	a5,168(s1)
    80005f78:	0a44a703          	lw	a4,164(s1)
    80005f7c:	fcf71ee3          	bne	a4,a5,80005f58 <consoleintr+0xd8>
    80005f80:	6902                	ld	s2,0(sp)
    80005f82:	bf05                	j	80005eb2 <consoleintr+0x32>
    80005f84:	6902                	ld	s2,0(sp)
    80005f86:	b735                	j	80005eb2 <consoleintr+0x32>
    80005f88:	6902                	ld	s2,0(sp)
    80005f8a:	b725                	j	80005eb2 <consoleintr+0x32>
    if(cons.e != cons.w){
    80005f8c:	00020717          	auipc	a4,0x20
    80005f90:	a3470713          	addi	a4,a4,-1484 # 800259c0 <cons>
    80005f94:	0a872783          	lw	a5,168(a4)
    80005f98:	0a472703          	lw	a4,164(a4)
    80005f9c:	f0f70be3          	beq	a4,a5,80005eb2 <consoleintr+0x32>
      cons.e--;
    80005fa0:	37fd                	addiw	a5,a5,-1
    80005fa2:	00020717          	auipc	a4,0x20
    80005fa6:	acf72323          	sw	a5,-1338(a4) # 80025a68 <cons+0xa8>
      consputc(BACKSPACE);
    80005faa:	10000513          	li	a0,256
    80005fae:	ea1ff0ef          	jal	80005e4e <consputc>
    80005fb2:	b701                	j	80005eb2 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005fb4:	ee048fe3          	beqz	s1,80005eb2 <consoleintr+0x32>
    80005fb8:	bf21                	j	80005ed0 <consoleintr+0x50>
      consputc(c);
    80005fba:	4529                	li	a0,10
    80005fbc:	e93ff0ef          	jal	80005e4e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005fc0:	00020797          	auipc	a5,0x20
    80005fc4:	a0078793          	addi	a5,a5,-1536 # 800259c0 <cons>
    80005fc8:	0a87a703          	lw	a4,168(a5)
    80005fcc:	0017069b          	addiw	a3,a4,1
    80005fd0:	0006861b          	sext.w	a2,a3
    80005fd4:	0ad7a423          	sw	a3,168(a5)
    80005fd8:	07f77713          	andi	a4,a4,127
    80005fdc:	97ba                	add	a5,a5,a4
    80005fde:	4729                	li	a4,10
    80005fe0:	02e78023          	sb	a4,32(a5)
        cons.w = cons.e;
    80005fe4:	00020797          	auipc	a5,0x20
    80005fe8:	a8c7a023          	sw	a2,-1408(a5) # 80025a64 <cons+0xa4>
        wakeup(&cons.r);
    80005fec:	00020517          	auipc	a0,0x20
    80005ff0:	a7450513          	addi	a0,a0,-1420 # 80025a60 <cons+0xa0>
    80005ff4:	eb5fb0ef          	jal	80001ea8 <wakeup>
    80005ff8:	bd6d                	j	80005eb2 <consoleintr+0x32>

0000000080005ffa <consoleinit>:

void
consoleinit(void)
{
    80005ffa:	1141                	addi	sp,sp,-16
    80005ffc:	e406                	sd	ra,8(sp)
    80005ffe:	e022                	sd	s0,0(sp)
    80006000:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80006002:	00003597          	auipc	a1,0x3
    80006006:	c3658593          	addi	a1,a1,-970 # 80008c38 <etext+0xc38>
    8000600a:	00020517          	auipc	a0,0x20
    8000600e:	9b650513          	addi	a0,a0,-1610 # 800259c0 <cons>
    80006012:	7ec000ef          	jal	800067fe <initlock>

  uartinit();
    80006016:	3f4000ef          	jal	8000640a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000601a:	00016797          	auipc	a5,0x16
    8000601e:	7f678793          	addi	a5,a5,2038 # 8001c810 <devsw>
    80006022:	00000717          	auipc	a4,0x0
    80006026:	d2270713          	addi	a4,a4,-734 # 80005d44 <consoleread>
    8000602a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000602c:	00000717          	auipc	a4,0x0
    80006030:	cb270713          	addi	a4,a4,-846 # 80005cde <consolewrite>
    80006034:	ef98                	sd	a4,24(a5)
}
    80006036:	60a2                	ld	ra,8(sp)
    80006038:	6402                	ld	s0,0(sp)
    8000603a:	0141                	addi	sp,sp,16
    8000603c:	8082                	ret

000000008000603e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000603e:	7179                	addi	sp,sp,-48
    80006040:	f406                	sd	ra,40(sp)
    80006042:	f022                	sd	s0,32(sp)
    80006044:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80006046:	c219                	beqz	a2,8000604c <printint+0xe>
    80006048:	08054063          	bltz	a0,800060c8 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000604c:	4881                	li	a7,0
    8000604e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006052:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80006054:	00003617          	auipc	a2,0x3
    80006058:	e9c60613          	addi	a2,a2,-356 # 80008ef0 <digits>
    8000605c:	883e                	mv	a6,a5
    8000605e:	2785                	addiw	a5,a5,1
    80006060:	02b57733          	remu	a4,a0,a1
    80006064:	9732                	add	a4,a4,a2
    80006066:	00074703          	lbu	a4,0(a4)
    8000606a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000606e:	872a                	mv	a4,a0
    80006070:	02b55533          	divu	a0,a0,a1
    80006074:	0685                	addi	a3,a3,1
    80006076:	feb773e3          	bgeu	a4,a1,8000605c <printint+0x1e>

  if(sign)
    8000607a:	00088a63          	beqz	a7,8000608e <printint+0x50>
    buf[i++] = '-';
    8000607e:	1781                	addi	a5,a5,-32
    80006080:	97a2                	add	a5,a5,s0
    80006082:	02d00713          	li	a4,45
    80006086:	fee78823          	sb	a4,-16(a5)
    8000608a:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    8000608e:	02f05963          	blez	a5,800060c0 <printint+0x82>
    80006092:	ec26                	sd	s1,24(sp)
    80006094:	e84a                	sd	s2,16(sp)
    80006096:	fd040713          	addi	a4,s0,-48
    8000609a:	00f704b3          	add	s1,a4,a5
    8000609e:	fff70913          	addi	s2,a4,-1
    800060a2:	993e                	add	s2,s2,a5
    800060a4:	37fd                	addiw	a5,a5,-1
    800060a6:	1782                	slli	a5,a5,0x20
    800060a8:	9381                	srli	a5,a5,0x20
    800060aa:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800060ae:	fff4c503          	lbu	a0,-1(s1)
    800060b2:	d9dff0ef          	jal	80005e4e <consputc>
  while(--i >= 0)
    800060b6:	14fd                	addi	s1,s1,-1
    800060b8:	ff249be3          	bne	s1,s2,800060ae <printint+0x70>
    800060bc:	64e2                	ld	s1,24(sp)
    800060be:	6942                	ld	s2,16(sp)
}
    800060c0:	70a2                	ld	ra,40(sp)
    800060c2:	7402                	ld	s0,32(sp)
    800060c4:	6145                	addi	sp,sp,48
    800060c6:	8082                	ret
    x = -xx;
    800060c8:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800060cc:	4885                	li	a7,1
    x = -xx;
    800060ce:	b741                	j	8000604e <printint+0x10>

00000000800060d0 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800060d0:	7155                	addi	sp,sp,-208
    800060d2:	e506                	sd	ra,136(sp)
    800060d4:	e122                	sd	s0,128(sp)
    800060d6:	f0d2                	sd	s4,96(sp)
    800060d8:	0900                	addi	s0,sp,144
    800060da:	8a2a                	mv	s4,a0
    800060dc:	e40c                	sd	a1,8(s0)
    800060de:	e810                	sd	a2,16(s0)
    800060e0:	ec14                	sd	a3,24(s0)
    800060e2:	f018                	sd	a4,32(s0)
    800060e4:	f41c                	sd	a5,40(s0)
    800060e6:	03043823          	sd	a6,48(s0)
    800060ea:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800060ee:	00020797          	auipc	a5,0x20
    800060f2:	9a27a783          	lw	a5,-1630(a5) # 80025a90 <pr+0x20>
    800060f6:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800060fa:	e3a1                	bnez	a5,8000613a <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800060fc:	00840793          	addi	a5,s0,8
    80006100:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80006104:	00054503          	lbu	a0,0(a0)
    80006108:	26050763          	beqz	a0,80006376 <printf+0x2a6>
    8000610c:	fca6                	sd	s1,120(sp)
    8000610e:	f8ca                	sd	s2,112(sp)
    80006110:	f4ce                	sd	s3,104(sp)
    80006112:	ecd6                	sd	s5,88(sp)
    80006114:	e8da                	sd	s6,80(sp)
    80006116:	e0e2                	sd	s8,64(sp)
    80006118:	fc66                	sd	s9,56(sp)
    8000611a:	f86a                	sd	s10,48(sp)
    8000611c:	f46e                	sd	s11,40(sp)
    8000611e:	4981                	li	s3,0
    if(cx != '%'){
    80006120:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80006124:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80006128:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000612c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80006130:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80006134:	07000d93          	li	s11,112
    80006138:	a815                	j	8000616c <printf+0x9c>
    acquire(&pr.lock);
    8000613a:	00020517          	auipc	a0,0x20
    8000613e:	93650513          	addi	a0,a0,-1738 # 80025a70 <pr>
    80006142:	5b4000ef          	jal	800066f6 <acquire>
  va_start(ap, fmt);
    80006146:	00840793          	addi	a5,s0,8
    8000614a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000614e:	000a4503          	lbu	a0,0(s4)
    80006152:	fd4d                	bnez	a0,8000610c <printf+0x3c>
    80006154:	a481                	j	80006394 <printf+0x2c4>
      consputc(cx);
    80006156:	cf9ff0ef          	jal	80005e4e <consputc>
      continue;
    8000615a:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000615c:	0014899b          	addiw	s3,s1,1
    80006160:	013a07b3          	add	a5,s4,s3
    80006164:	0007c503          	lbu	a0,0(a5)
    80006168:	1e050b63          	beqz	a0,8000635e <printf+0x28e>
    if(cx != '%'){
    8000616c:	ff5515e3          	bne	a0,s5,80006156 <printf+0x86>
    i++;
    80006170:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80006174:	009a07b3          	add	a5,s4,s1
    80006178:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000617c:	1e090163          	beqz	s2,8000635e <printf+0x28e>
    80006180:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80006184:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80006186:	c789                	beqz	a5,80006190 <printf+0xc0>
    80006188:	009a0733          	add	a4,s4,s1
    8000618c:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80006190:	03690763          	beq	s2,s6,800061be <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80006194:	05890163          	beq	s2,s8,800061d6 <printf+0x106>
    } else if(c0 == 'u'){
    80006198:	0d990b63          	beq	s2,s9,8000626e <printf+0x19e>
    } else if(c0 == 'x'){
    8000619c:	13a90163          	beq	s2,s10,800062be <printf+0x1ee>
    } else if(c0 == 'p'){
    800061a0:	13b90b63          	beq	s2,s11,800062d6 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800061a4:	07300793          	li	a5,115
    800061a8:	16f90a63          	beq	s2,a5,8000631c <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800061ac:	1b590463          	beq	s2,s5,80006354 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800061b0:	8556                	mv	a0,s5
    800061b2:	c9dff0ef          	jal	80005e4e <consputc>
      consputc(c0);
    800061b6:	854a                	mv	a0,s2
    800061b8:	c97ff0ef          	jal	80005e4e <consputc>
    800061bc:	b745                	j	8000615c <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800061be:	f8843783          	ld	a5,-120(s0)
    800061c2:	00878713          	addi	a4,a5,8
    800061c6:	f8e43423          	sd	a4,-120(s0)
    800061ca:	4605                	li	a2,1
    800061cc:	45a9                	li	a1,10
    800061ce:	4388                	lw	a0,0(a5)
    800061d0:	e6fff0ef          	jal	8000603e <printint>
    800061d4:	b761                	j	8000615c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800061d6:	03678663          	beq	a5,s6,80006202 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800061da:	05878263          	beq	a5,s8,8000621e <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    800061de:	0b978463          	beq	a5,s9,80006286 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    800061e2:	fda797e3          	bne	a5,s10,800061b0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800061e6:	f8843783          	ld	a5,-120(s0)
    800061ea:	00878713          	addi	a4,a5,8
    800061ee:	f8e43423          	sd	a4,-120(s0)
    800061f2:	4601                	li	a2,0
    800061f4:	45c1                	li	a1,16
    800061f6:	6388                	ld	a0,0(a5)
    800061f8:	e47ff0ef          	jal	8000603e <printint>
      i += 1;
    800061fc:	0029849b          	addiw	s1,s3,2
    80006200:	bfb1                	j	8000615c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80006202:	f8843783          	ld	a5,-120(s0)
    80006206:	00878713          	addi	a4,a5,8
    8000620a:	f8e43423          	sd	a4,-120(s0)
    8000620e:	4605                	li	a2,1
    80006210:	45a9                	li	a1,10
    80006212:	6388                	ld	a0,0(a5)
    80006214:	e2bff0ef          	jal	8000603e <printint>
      i += 1;
    80006218:	0029849b          	addiw	s1,s3,2
    8000621c:	b781                	j	8000615c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000621e:	06400793          	li	a5,100
    80006222:	02f68863          	beq	a3,a5,80006252 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80006226:	07500793          	li	a5,117
    8000622a:	06f68c63          	beq	a3,a5,800062a2 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000622e:	07800793          	li	a5,120
    80006232:	f6f69fe3          	bne	a3,a5,800061b0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80006236:	f8843783          	ld	a5,-120(s0)
    8000623a:	00878713          	addi	a4,a5,8
    8000623e:	f8e43423          	sd	a4,-120(s0)
    80006242:	4601                	li	a2,0
    80006244:	45c1                	li	a1,16
    80006246:	6388                	ld	a0,0(a5)
    80006248:	df7ff0ef          	jal	8000603e <printint>
      i += 2;
    8000624c:	0039849b          	addiw	s1,s3,3
    80006250:	b731                	j	8000615c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80006252:	f8843783          	ld	a5,-120(s0)
    80006256:	00878713          	addi	a4,a5,8
    8000625a:	f8e43423          	sd	a4,-120(s0)
    8000625e:	4605                	li	a2,1
    80006260:	45a9                	li	a1,10
    80006262:	6388                	ld	a0,0(a5)
    80006264:	ddbff0ef          	jal	8000603e <printint>
      i += 2;
    80006268:	0039849b          	addiw	s1,s3,3
    8000626c:	bdc5                	j	8000615c <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    8000626e:	f8843783          	ld	a5,-120(s0)
    80006272:	00878713          	addi	a4,a5,8
    80006276:	f8e43423          	sd	a4,-120(s0)
    8000627a:	4601                	li	a2,0
    8000627c:	45a9                	li	a1,10
    8000627e:	4388                	lw	a0,0(a5)
    80006280:	dbfff0ef          	jal	8000603e <printint>
    80006284:	bde1                	j	8000615c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80006286:	f8843783          	ld	a5,-120(s0)
    8000628a:	00878713          	addi	a4,a5,8
    8000628e:	f8e43423          	sd	a4,-120(s0)
    80006292:	4601                	li	a2,0
    80006294:	45a9                	li	a1,10
    80006296:	6388                	ld	a0,0(a5)
    80006298:	da7ff0ef          	jal	8000603e <printint>
      i += 1;
    8000629c:	0029849b          	addiw	s1,s3,2
    800062a0:	bd75                	j	8000615c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800062a2:	f8843783          	ld	a5,-120(s0)
    800062a6:	00878713          	addi	a4,a5,8
    800062aa:	f8e43423          	sd	a4,-120(s0)
    800062ae:	4601                	li	a2,0
    800062b0:	45a9                	li	a1,10
    800062b2:	6388                	ld	a0,0(a5)
    800062b4:	d8bff0ef          	jal	8000603e <printint>
      i += 2;
    800062b8:	0039849b          	addiw	s1,s3,3
    800062bc:	b545                	j	8000615c <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800062be:	f8843783          	ld	a5,-120(s0)
    800062c2:	00878713          	addi	a4,a5,8
    800062c6:	f8e43423          	sd	a4,-120(s0)
    800062ca:	4601                	li	a2,0
    800062cc:	45c1                	li	a1,16
    800062ce:	4388                	lw	a0,0(a5)
    800062d0:	d6fff0ef          	jal	8000603e <printint>
    800062d4:	b561                	j	8000615c <printf+0x8c>
    800062d6:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800062d8:	f8843783          	ld	a5,-120(s0)
    800062dc:	00878713          	addi	a4,a5,8
    800062e0:	f8e43423          	sd	a4,-120(s0)
    800062e4:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800062e8:	03000513          	li	a0,48
    800062ec:	b63ff0ef          	jal	80005e4e <consputc>
  consputc('x');
    800062f0:	07800513          	li	a0,120
    800062f4:	b5bff0ef          	jal	80005e4e <consputc>
    800062f8:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800062fa:	00003b97          	auipc	s7,0x3
    800062fe:	bf6b8b93          	addi	s7,s7,-1034 # 80008ef0 <digits>
    80006302:	03c9d793          	srli	a5,s3,0x3c
    80006306:	97de                	add	a5,a5,s7
    80006308:	0007c503          	lbu	a0,0(a5)
    8000630c:	b43ff0ef          	jal	80005e4e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006310:	0992                	slli	s3,s3,0x4
    80006312:	397d                	addiw	s2,s2,-1
    80006314:	fe0917e3          	bnez	s2,80006302 <printf+0x232>
    80006318:	6ba6                	ld	s7,72(sp)
    8000631a:	b589                	j	8000615c <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000631c:	f8843783          	ld	a5,-120(s0)
    80006320:	00878713          	addi	a4,a5,8
    80006324:	f8e43423          	sd	a4,-120(s0)
    80006328:	0007b903          	ld	s2,0(a5)
    8000632c:	00090d63          	beqz	s2,80006346 <printf+0x276>
      for(; *s; s++)
    80006330:	00094503          	lbu	a0,0(s2)
    80006334:	e20504e3          	beqz	a0,8000615c <printf+0x8c>
        consputc(*s);
    80006338:	b17ff0ef          	jal	80005e4e <consputc>
      for(; *s; s++)
    8000633c:	0905                	addi	s2,s2,1
    8000633e:	00094503          	lbu	a0,0(s2)
    80006342:	f97d                	bnez	a0,80006338 <printf+0x268>
    80006344:	bd21                	j	8000615c <printf+0x8c>
        s = "(null)";
    80006346:	00003917          	auipc	s2,0x3
    8000634a:	8fa90913          	addi	s2,s2,-1798 # 80008c40 <etext+0xc40>
      for(; *s; s++)
    8000634e:	02800513          	li	a0,40
    80006352:	b7dd                	j	80006338 <printf+0x268>
      consputc('%');
    80006354:	02500513          	li	a0,37
    80006358:	af7ff0ef          	jal	80005e4e <consputc>
    8000635c:	b501                	j	8000615c <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    8000635e:	f7843783          	ld	a5,-136(s0)
    80006362:	e385                	bnez	a5,80006382 <printf+0x2b2>
    80006364:	74e6                	ld	s1,120(sp)
    80006366:	7946                	ld	s2,112(sp)
    80006368:	79a6                	ld	s3,104(sp)
    8000636a:	6ae6                	ld	s5,88(sp)
    8000636c:	6b46                	ld	s6,80(sp)
    8000636e:	6c06                	ld	s8,64(sp)
    80006370:	7ce2                	ld	s9,56(sp)
    80006372:	7d42                	ld	s10,48(sp)
    80006374:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80006376:	4501                	li	a0,0
    80006378:	60aa                	ld	ra,136(sp)
    8000637a:	640a                	ld	s0,128(sp)
    8000637c:	7a06                	ld	s4,96(sp)
    8000637e:	6169                	addi	sp,sp,208
    80006380:	8082                	ret
    80006382:	74e6                	ld	s1,120(sp)
    80006384:	7946                	ld	s2,112(sp)
    80006386:	79a6                	ld	s3,104(sp)
    80006388:	6ae6                	ld	s5,88(sp)
    8000638a:	6b46                	ld	s6,80(sp)
    8000638c:	6c06                	ld	s8,64(sp)
    8000638e:	7ce2                	ld	s9,56(sp)
    80006390:	7d42                	ld	s10,48(sp)
    80006392:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80006394:	0001f517          	auipc	a0,0x1f
    80006398:	6dc50513          	addi	a0,a0,1756 # 80025a70 <pr>
    8000639c:	426000ef          	jal	800067c2 <release>
    800063a0:	bfd9                	j	80006376 <printf+0x2a6>

00000000800063a2 <panic>:

void
panic(char *s)
{
    800063a2:	1101                	addi	sp,sp,-32
    800063a4:	ec06                	sd	ra,24(sp)
    800063a6:	e822                	sd	s0,16(sp)
    800063a8:	e426                	sd	s1,8(sp)
    800063aa:	1000                	addi	s0,sp,32
    800063ac:	84aa                	mv	s1,a0
  pr.locking = 0;
    800063ae:	0001f797          	auipc	a5,0x1f
    800063b2:	6e07a123          	sw	zero,1762(a5) # 80025a90 <pr+0x20>
  printf("panic: ");
    800063b6:	00003517          	auipc	a0,0x3
    800063ba:	89250513          	addi	a0,a0,-1902 # 80008c48 <etext+0xc48>
    800063be:	d13ff0ef          	jal	800060d0 <printf>
  printf("%s\n", s);
    800063c2:	85a6                	mv	a1,s1
    800063c4:	00003517          	auipc	a0,0x3
    800063c8:	88c50513          	addi	a0,a0,-1908 # 80008c50 <etext+0xc50>
    800063cc:	d05ff0ef          	jal	800060d0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800063d0:	4785                	li	a5,1
    800063d2:	00006717          	auipc	a4,0x6
    800063d6:	b0f72923          	sw	a5,-1262(a4) # 8000bee4 <panicked>
  for(;;)
    800063da:	a001                	j	800063da <panic+0x38>

00000000800063dc <printfinit>:
    ;
}

void
printfinit(void)
{
    800063dc:	1101                	addi	sp,sp,-32
    800063de:	ec06                	sd	ra,24(sp)
    800063e0:	e822                	sd	s0,16(sp)
    800063e2:	e426                	sd	s1,8(sp)
    800063e4:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800063e6:	0001f497          	auipc	s1,0x1f
    800063ea:	68a48493          	addi	s1,s1,1674 # 80025a70 <pr>
    800063ee:	00003597          	auipc	a1,0x3
    800063f2:	86a58593          	addi	a1,a1,-1942 # 80008c58 <etext+0xc58>
    800063f6:	8526                	mv	a0,s1
    800063f8:	406000ef          	jal	800067fe <initlock>
  pr.locking = 1;
    800063fc:	4785                	li	a5,1
    800063fe:	d09c                	sw	a5,32(s1)
}
    80006400:	60e2                	ld	ra,24(sp)
    80006402:	6442                	ld	s0,16(sp)
    80006404:	64a2                	ld	s1,8(sp)
    80006406:	6105                	addi	sp,sp,32
    80006408:	8082                	ret

000000008000640a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000640a:	1141                	addi	sp,sp,-16
    8000640c:	e406                	sd	ra,8(sp)
    8000640e:	e022                	sd	s0,0(sp)
    80006410:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006412:	100007b7          	lui	a5,0x10000
    80006416:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000641a:	10000737          	lui	a4,0x10000
    8000641e:	f8000693          	li	a3,-128
    80006422:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006426:	468d                	li	a3,3
    80006428:	10000637          	lui	a2,0x10000
    8000642c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006430:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006434:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006438:	10000737          	lui	a4,0x10000
    8000643c:	461d                	li	a2,7
    8000643e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006442:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006446:	00003597          	auipc	a1,0x3
    8000644a:	81a58593          	addi	a1,a1,-2022 # 80008c60 <etext+0xc60>
    8000644e:	0001f517          	auipc	a0,0x1f
    80006452:	64a50513          	addi	a0,a0,1610 # 80025a98 <uart_tx_lock>
    80006456:	3a8000ef          	jal	800067fe <initlock>
}
    8000645a:	60a2                	ld	ra,8(sp)
    8000645c:	6402                	ld	s0,0(sp)
    8000645e:	0141                	addi	sp,sp,16
    80006460:	8082                	ret

0000000080006462 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006462:	1101                	addi	sp,sp,-32
    80006464:	ec06                	sd	ra,24(sp)
    80006466:	e822                	sd	s0,16(sp)
    80006468:	e426                	sd	s1,8(sp)
    8000646a:	1000                	addi	s0,sp,32
    8000646c:	84aa                	mv	s1,a0
  push_off();
    8000646e:	248000ef          	jal	800066b6 <push_off>

  if(panicked){
    80006472:	00006797          	auipc	a5,0x6
    80006476:	a727a783          	lw	a5,-1422(a5) # 8000bee4 <panicked>
    8000647a:	e795                	bnez	a5,800064a6 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000647c:	10000737          	lui	a4,0x10000
    80006480:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006482:	00074783          	lbu	a5,0(a4)
    80006486:	0207f793          	andi	a5,a5,32
    8000648a:	dfe5                	beqz	a5,80006482 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000648c:	0ff4f513          	zext.b	a0,s1
    80006490:	100007b7          	lui	a5,0x10000
    80006494:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006498:	2d6000ef          	jal	8000676e <pop_off>
}
    8000649c:	60e2                	ld	ra,24(sp)
    8000649e:	6442                	ld	s0,16(sp)
    800064a0:	64a2                	ld	s1,8(sp)
    800064a2:	6105                	addi	sp,sp,32
    800064a4:	8082                	ret
    for(;;)
    800064a6:	a001                	j	800064a6 <uartputc_sync+0x44>

00000000800064a8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800064a8:	00006797          	auipc	a5,0x6
    800064ac:	a407b783          	ld	a5,-1472(a5) # 8000bee8 <uart_tx_r>
    800064b0:	00006717          	auipc	a4,0x6
    800064b4:	a4073703          	ld	a4,-1472(a4) # 8000bef0 <uart_tx_w>
    800064b8:	08f70263          	beq	a4,a5,8000653c <uartstart+0x94>
{
    800064bc:	7139                	addi	sp,sp,-64
    800064be:	fc06                	sd	ra,56(sp)
    800064c0:	f822                	sd	s0,48(sp)
    800064c2:	f426                	sd	s1,40(sp)
    800064c4:	f04a                	sd	s2,32(sp)
    800064c6:	ec4e                	sd	s3,24(sp)
    800064c8:	e852                	sd	s4,16(sp)
    800064ca:	e456                	sd	s5,8(sp)
    800064cc:	e05a                	sd	s6,0(sp)
    800064ce:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800064d0:	10000937          	lui	s2,0x10000
    800064d4:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800064d6:	0001fa97          	auipc	s5,0x1f
    800064da:	5c2a8a93          	addi	s5,s5,1474 # 80025a98 <uart_tx_lock>
    uart_tx_r += 1;
    800064de:	00006497          	auipc	s1,0x6
    800064e2:	a0a48493          	addi	s1,s1,-1526 # 8000bee8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800064e6:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800064ea:	00006997          	auipc	s3,0x6
    800064ee:	a0698993          	addi	s3,s3,-1530 # 8000bef0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800064f2:	00094703          	lbu	a4,0(s2)
    800064f6:	02077713          	andi	a4,a4,32
    800064fa:	c71d                	beqz	a4,80006528 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800064fc:	01f7f713          	andi	a4,a5,31
    80006500:	9756                	add	a4,a4,s5
    80006502:	02074b03          	lbu	s6,32(a4)
    uart_tx_r += 1;
    80006506:	0785                	addi	a5,a5,1
    80006508:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000650a:	8526                	mv	a0,s1
    8000650c:	99dfb0ef          	jal	80001ea8 <wakeup>
    WriteReg(THR, c);
    80006510:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80006514:	609c                	ld	a5,0(s1)
    80006516:	0009b703          	ld	a4,0(s3)
    8000651a:	fcf71ce3          	bne	a4,a5,800064f2 <uartstart+0x4a>
      ReadReg(ISR);
    8000651e:	100007b7          	lui	a5,0x10000
    80006522:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80006524:	0007c783          	lbu	a5,0(a5)
  }
}
    80006528:	70e2                	ld	ra,56(sp)
    8000652a:	7442                	ld	s0,48(sp)
    8000652c:	74a2                	ld	s1,40(sp)
    8000652e:	7902                	ld	s2,32(sp)
    80006530:	69e2                	ld	s3,24(sp)
    80006532:	6a42                	ld	s4,16(sp)
    80006534:	6aa2                	ld	s5,8(sp)
    80006536:	6b02                	ld	s6,0(sp)
    80006538:	6121                	addi	sp,sp,64
    8000653a:	8082                	ret
      ReadReg(ISR);
    8000653c:	100007b7          	lui	a5,0x10000
    80006540:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80006542:	0007c783          	lbu	a5,0(a5)
      return;
    80006546:	8082                	ret

0000000080006548 <uartputc>:
{
    80006548:	7179                	addi	sp,sp,-48
    8000654a:	f406                	sd	ra,40(sp)
    8000654c:	f022                	sd	s0,32(sp)
    8000654e:	ec26                	sd	s1,24(sp)
    80006550:	e84a                	sd	s2,16(sp)
    80006552:	e44e                	sd	s3,8(sp)
    80006554:	e052                	sd	s4,0(sp)
    80006556:	1800                	addi	s0,sp,48
    80006558:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000655a:	0001f517          	auipc	a0,0x1f
    8000655e:	53e50513          	addi	a0,a0,1342 # 80025a98 <uart_tx_lock>
    80006562:	194000ef          	jal	800066f6 <acquire>
  if(panicked){
    80006566:	00006797          	auipc	a5,0x6
    8000656a:	97e7a783          	lw	a5,-1666(a5) # 8000bee4 <panicked>
    8000656e:	efbd                	bnez	a5,800065ec <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006570:	00006717          	auipc	a4,0x6
    80006574:	98073703          	ld	a4,-1664(a4) # 8000bef0 <uart_tx_w>
    80006578:	00006797          	auipc	a5,0x6
    8000657c:	9707b783          	ld	a5,-1680(a5) # 8000bee8 <uart_tx_r>
    80006580:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006584:	0001f997          	auipc	s3,0x1f
    80006588:	51498993          	addi	s3,s3,1300 # 80025a98 <uart_tx_lock>
    8000658c:	00006497          	auipc	s1,0x6
    80006590:	95c48493          	addi	s1,s1,-1700 # 8000bee8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006594:	00006917          	auipc	s2,0x6
    80006598:	95c90913          	addi	s2,s2,-1700 # 8000bef0 <uart_tx_w>
    8000659c:	00e79d63          	bne	a5,a4,800065b6 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800065a0:	85ce                	mv	a1,s3
    800065a2:	8526                	mv	a0,s1
    800065a4:	8b9fb0ef          	jal	80001e5c <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800065a8:	00093703          	ld	a4,0(s2)
    800065ac:	609c                	ld	a5,0(s1)
    800065ae:	02078793          	addi	a5,a5,32
    800065b2:	fee787e3          	beq	a5,a4,800065a0 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800065b6:	0001f497          	auipc	s1,0x1f
    800065ba:	4e248493          	addi	s1,s1,1250 # 80025a98 <uart_tx_lock>
    800065be:	01f77793          	andi	a5,a4,31
    800065c2:	97a6                	add	a5,a5,s1
    800065c4:	03478023          	sb	s4,32(a5)
  uart_tx_w += 1;
    800065c8:	0705                	addi	a4,a4,1
    800065ca:	00006797          	auipc	a5,0x6
    800065ce:	92e7b323          	sd	a4,-1754(a5) # 8000bef0 <uart_tx_w>
  uartstart();
    800065d2:	ed7ff0ef          	jal	800064a8 <uartstart>
  release(&uart_tx_lock);
    800065d6:	8526                	mv	a0,s1
    800065d8:	1ea000ef          	jal	800067c2 <release>
}
    800065dc:	70a2                	ld	ra,40(sp)
    800065de:	7402                	ld	s0,32(sp)
    800065e0:	64e2                	ld	s1,24(sp)
    800065e2:	6942                	ld	s2,16(sp)
    800065e4:	69a2                	ld	s3,8(sp)
    800065e6:	6a02                	ld	s4,0(sp)
    800065e8:	6145                	addi	sp,sp,48
    800065ea:	8082                	ret
    for(;;)
    800065ec:	a001                	j	800065ec <uartputc+0xa4>

00000000800065ee <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800065ee:	1141                	addi	sp,sp,-16
    800065f0:	e422                	sd	s0,8(sp)
    800065f2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800065f4:	100007b7          	lui	a5,0x10000
    800065f8:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800065fa:	0007c783          	lbu	a5,0(a5)
    800065fe:	8b85                	andi	a5,a5,1
    80006600:	cb81                	beqz	a5,80006610 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80006602:	100007b7          	lui	a5,0x10000
    80006606:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000660a:	6422                	ld	s0,8(sp)
    8000660c:	0141                	addi	sp,sp,16
    8000660e:	8082                	ret
    return -1;
    80006610:	557d                	li	a0,-1
    80006612:	bfe5                	j	8000660a <uartgetc+0x1c>

0000000080006614 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80006614:	1101                	addi	sp,sp,-32
    80006616:	ec06                	sd	ra,24(sp)
    80006618:	e822                	sd	s0,16(sp)
    8000661a:	e426                	sd	s1,8(sp)
    8000661c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000661e:	54fd                	li	s1,-1
    80006620:	a019                	j	80006626 <uartintr+0x12>
      break;
    consoleintr(c);
    80006622:	85fff0ef          	jal	80005e80 <consoleintr>
    int c = uartgetc();
    80006626:	fc9ff0ef          	jal	800065ee <uartgetc>
    if(c == -1)
    8000662a:	fe951ce3          	bne	a0,s1,80006622 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000662e:	0001f497          	auipc	s1,0x1f
    80006632:	46a48493          	addi	s1,s1,1130 # 80025a98 <uart_tx_lock>
    80006636:	8526                	mv	a0,s1
    80006638:	0be000ef          	jal	800066f6 <acquire>
  uartstart();
    8000663c:	e6dff0ef          	jal	800064a8 <uartstart>
  release(&uart_tx_lock);
    80006640:	8526                	mv	a0,s1
    80006642:	180000ef          	jal	800067c2 <release>
}
    80006646:	60e2                	ld	ra,24(sp)
    80006648:	6442                	ld	s0,16(sp)
    8000664a:	64a2                	ld	s1,8(sp)
    8000664c:	6105                	addi	sp,sp,32
    8000664e:	8082                	ret

0000000080006650 <lockstatsinit>:
struct spinlock all_locks_list_meta_lock;         // static, 元锁

// 初始化锁列表和其保护锁，在 main() 中早期调用
void
lockstatsinit(void)
{
    80006650:	1141                	addi	sp,sp,-16
    80006652:	e422                	sd	s0,8(sp)
    80006654:	0800                	addi	s0,sp,16
  // 直接初始化元锁字段，避免调用 initlock 导致递归注册
  all_locks_list_meta_lock.name = "all_locks_meta"; // 简短且唯一的名称
    80006656:	0001f797          	auipc	a5,0x1f
    8000665a:	48278793          	addi	a5,a5,1154 # 80025ad8 <all_locks_list_meta_lock>
    8000665e:	00002717          	auipc	a4,0x2
    80006662:	60a70713          	addi	a4,a4,1546 # 80008c68 <etext+0xc68>
    80006666:	e798                	sd	a4,8(a5)
  all_locks_list_meta_lock.locked = 0;
    80006668:	0007a023          	sw	zero,0(a5)
  all_locks_list_meta_lock.cpu = 0;
    8000666c:	0007b823          	sd	zero,16(a5)
  all_locks_list_meta_lock.acquire_count = 0;
    80006670:	0007ac23          	sw	zero,24(a5)
  all_locks_list_meta_lock.tas_spins = 0;
    80006674:	0007ae23          	sw	zero,28(a5)
  // 元锁自身不加入 all_registered_locks 列表，因为它不应该被用户统计
  num_registered_locks = 0;
    80006678:	00006797          	auipc	a5,0x6
    8000667c:	8807a023          	sw	zero,-1920(a5) # 8000bef8 <num_registered_locks>
}
    80006680:	6422                	ld	s0,8(sp)
    80006682:	0141                	addi	sp,sp,16
    80006684:	8082                	ret

0000000080006686 <holding>:
  pop_off();
}

int
holding(struct spinlock *lk)
{
    80006686:	1101                	addi	sp,sp,-32
    80006688:	ec06                	sd	ra,24(sp)
    8000668a:	e822                	sd	s0,16(sp)
    8000668c:	e426                	sd	s1,8(sp)
    8000668e:	1000                	addi	s0,sp,32
    80006690:	84aa                	mv	s1,a0
  int r;
  struct cpu* c = mycpu();
    80006692:	90afb0ef          	jal	8000179c <mycpu>
  if (c == 0 && lk->locked != 0) { 
    80006696:	cd11                	beqz	a0,800066b2 <holding+0x2c>
    80006698:	87aa                	mv	a5,a0
    // For simplicity, if no cpu context, assume not holding.
    // A more robust check might be needed if locks are used before full CPU init.
    return 0; 
  }
  if (c == 0 && lk->locked == 0) return 0;
  r = (lk->locked && lk->cpu == c);
    8000669a:	4098                	lw	a4,0(s1)
    8000669c:	4501                	li	a0,0
    8000669e:	c709                	beqz	a4,800066a8 <holding+0x22>
    800066a0:	6888                	ld	a0,16(s1)
    800066a2:	8d1d                	sub	a0,a0,a5
    800066a4:	00153513          	seqz	a0,a0
  return r;
}
    800066a8:	60e2                	ld	ra,24(sp)
    800066aa:	6442                	ld	s0,16(sp)
    800066ac:	64a2                	ld	s1,8(sp)
    800066ae:	6105                	addi	sp,sp,32
    800066b0:	8082                	ret
    return 0; 
    800066b2:	4501                	li	a0,0
    800066b4:	bfd5                	j	800066a8 <holding+0x22>

00000000800066b6 <push_off>:

void
push_off(void)
{
    800066b6:	1101                	addi	sp,sp,-32
    800066b8:	ec06                	sd	ra,24(sp)
    800066ba:	e822                	sd	s0,16(sp)
    800066bc:	e426                	sd	s1,8(sp)
    800066be:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800066c0:	100024f3          	csrr	s1,sstatus
    800066c4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800066c8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800066ca:	10079073          	csrw	sstatus,a5
int old = intr_get();
intr_off();
if(mycpu()->noff == 0)
    800066ce:	8cefb0ef          	jal	8000179c <mycpu>
    800066d2:	5d3c                	lw	a5,120(a0)
    800066d4:	cb99                	beqz	a5,800066ea <push_off+0x34>
mycpu()->intena = old;
mycpu()->noff += 1;
    800066d6:	8c6fb0ef          	jal	8000179c <mycpu>
    800066da:	5d3c                	lw	a5,120(a0)
    800066dc:	2785                	addiw	a5,a5,1
    800066de:	dd3c                	sw	a5,120(a0)
}
    800066e0:	60e2                	ld	ra,24(sp)
    800066e2:	6442                	ld	s0,16(sp)
    800066e4:	64a2                	ld	s1,8(sp)
    800066e6:	6105                	addi	sp,sp,32
    800066e8:	8082                	ret
mycpu()->intena = old;
    800066ea:	8b2fb0ef          	jal	8000179c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800066ee:	8085                	srli	s1,s1,0x1
    800066f0:	8885                	andi	s1,s1,1
    800066f2:	dd64                	sw	s1,124(a0)
    800066f4:	b7cd                	j	800066d6 <push_off+0x20>

00000000800066f6 <acquire>:
{
    800066f6:	1101                	addi	sp,sp,-32
    800066f8:	ec06                	sd	ra,24(sp)
    800066fa:	e822                	sd	s0,16(sp)
    800066fc:	e426                	sd	s1,8(sp)
    800066fe:	1000                	addi	s0,sp,32
    80006700:	84aa                	mv	s1,a0
  lk->acquire_count++; // 记录尝试获取的次数
    80006702:	4d1c                	lw	a5,24(a0)
    80006704:	2785                	addiw	a5,a5,1
    80006706:	cd1c                	sw	a5,24(a0)
  push_off();
    80006708:	fafff0ef          	jal	800066b6 <push_off>
  if(holding(lk)) {
    8000670c:	8526                	mv	a0,s1
    8000670e:	f79ff0ef          	jal	80006686 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80006712:	4705                	li	a4,1
  if(holding(lk)) {
    80006714:	cd15                	beqz	a0,80006750 <acquire+0x5a>
    struct cpu* c = mycpu();
    80006716:	886fb0ef          	jal	8000179c <mycpu>
    if(c) hart_id = c - cpus;
    8000671a:	c515                	beqz	a0,80006746 <acquire+0x50>
    8000671c:	00006717          	auipc	a4,0x6
    80006720:	a0470713          	addi	a4,a4,-1532 # 8000c120 <cpus>
    80006724:	40e505b3          	sub	a1,a0,a4
    80006728:	859d                	srai	a1,a1,0x7
    8000672a:	2581                	sext.w	a1,a1
    printf("acquire: hart %d already holding lock '%s'\n", hart_id, lk->name);
    8000672c:	6490                	ld	a2,8(s1)
    8000672e:	00002517          	auipc	a0,0x2
    80006732:	54a50513          	addi	a0,a0,1354 # 80008c78 <etext+0xc78>
    80006736:	99bff0ef          	jal	800060d0 <printf>
    panic("acquire");
    8000673a:	00002517          	auipc	a0,0x2
    8000673e:	56e50513          	addi	a0,a0,1390 # 80008ca8 <etext+0xca8>
    80006742:	c61ff0ef          	jal	800063a2 <panic>
    int hart_id = -1;
    80006746:	55fd                	li	a1,-1
    80006748:	b7d5                	j	8000672c <acquire+0x36>
    lk->tas_spins++; // 记录旋转次数
    8000674a:	4cdc                	lw	a5,28(s1)
    8000674c:	2785                	addiw	a5,a5,1
    8000674e:	ccdc                	sw	a5,28(s1)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80006750:	87ba                	mv	a5,a4
    80006752:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006756:	2781                	sext.w	a5,a5
    80006758:	fbed                	bnez	a5,8000674a <acquire+0x54>
  __sync_synchronize();
    8000675a:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    8000675e:	83efb0ef          	jal	8000179c <mycpu>
    80006762:	e888                	sd	a0,16(s1)
}
    80006764:	60e2                	ld	ra,24(sp)
    80006766:	6442                	ld	s0,16(sp)
    80006768:	64a2                	ld	s1,8(sp)
    8000676a:	6105                	addi	sp,sp,32
    8000676c:	8082                	ret

000000008000676e <pop_off>:

void
pop_off(void)
{
    8000676e:	1141                	addi	sp,sp,-16
    80006770:	e406                	sd	ra,8(sp)
    80006772:	e022                	sd	s0,0(sp)
    80006774:	0800                	addi	s0,sp,16
struct cpu *c = mycpu();
    80006776:	826fb0ef          	jal	8000179c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000677a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000677e:	8b89                	andi	a5,a5,2
if(intr_get())
    80006780:	e78d                	bnez	a5,800067aa <pop_off+0x3c>
panic("pop_off - interruptible");
if(c->noff < 1)
    80006782:	5d3c                	lw	a5,120(a0)
    80006784:	02f05963          	blez	a5,800067b6 <pop_off+0x48>
panic("pop_off");
c->noff -= 1;
    80006788:	37fd                	addiw	a5,a5,-1
    8000678a:	0007871b          	sext.w	a4,a5
    8000678e:	dd3c                	sw	a5,120(a0)
if(c->noff == 0 && c->intena)
    80006790:	eb09                	bnez	a4,800067a2 <pop_off+0x34>
    80006792:	5d7c                	lw	a5,124(a0)
    80006794:	c799                	beqz	a5,800067a2 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006796:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000679a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000679e:	10079073          	csrw	sstatus,a5
intr_on();
}
    800067a2:	60a2                	ld	ra,8(sp)
    800067a4:	6402                	ld	s0,0(sp)
    800067a6:	0141                	addi	sp,sp,16
    800067a8:	8082                	ret
panic("pop_off - interruptible");
    800067aa:	00002517          	auipc	a0,0x2
    800067ae:	50650513          	addi	a0,a0,1286 # 80008cb0 <etext+0xcb0>
    800067b2:	bf1ff0ef          	jal	800063a2 <panic>
panic("pop_off");
    800067b6:	00002517          	auipc	a0,0x2
    800067ba:	51250513          	addi	a0,a0,1298 # 80008cc8 <etext+0xcc8>
    800067be:	be5ff0ef          	jal	800063a2 <panic>

00000000800067c2 <release>:
{
    800067c2:	1101                	addi	sp,sp,-32
    800067c4:	ec06                	sd	ra,24(sp)
    800067c6:	e822                	sd	s0,16(sp)
    800067c8:	e426                	sd	s1,8(sp)
    800067ca:	1000                	addi	s0,sp,32
    800067cc:	84aa                	mv	s1,a0
  if(!holding(lk)) {
    800067ce:	eb9ff0ef          	jal	80006686 <holding>
    800067d2:	c105                	beqz	a0,800067f2 <release+0x30>
  lk->cpu = 0;
    800067d4:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800067d8:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800067dc:	0310000f          	fence	rw,w
    800067e0:	0004a023          	sw	zero,0(s1)
  pop_off();
    800067e4:	f8bff0ef          	jal	8000676e <pop_off>
}
    800067e8:	60e2                	ld	ra,24(sp)
    800067ea:	6442                	ld	s0,16(sp)
    800067ec:	64a2                	ld	s1,8(sp)
    800067ee:	6105                	addi	sp,sp,32
    800067f0:	8082                	ret
    panic("release");
    800067f2:	00002517          	auipc	a0,0x2
    800067f6:	4de50513          	addi	a0,a0,1246 # 80008cd0 <etext+0xcd0>
    800067fa:	ba9ff0ef          	jal	800063a2 <panic>

00000000800067fe <initlock>:
  lk->name = name;
    800067fe:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006800:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006804:	00053823          	sd	zero,16(a0)
  lk->acquire_count = 0;
    80006808:	00052c23          	sw	zero,24(a0)
  lk->tas_spins = 0;
    8000680c:	00052e23          	sw	zero,28(a0)
  if (all_locks_list_meta_lock.name != 0 && lk != &all_locks_list_meta_lock) {
    80006810:	0001f797          	auipc	a5,0x1f
    80006814:	2d07b783          	ld	a5,720(a5) # 80025ae0 <all_locks_list_meta_lock+0x8>
    80006818:	cfbd                	beqz	a5,80006896 <initlock+0x98>
{
    8000681a:	1101                	addi	sp,sp,-32
    8000681c:	ec06                	sd	ra,24(sp)
    8000681e:	e822                	sd	s0,16(sp)
    80006820:	e426                	sd	s1,8(sp)
    80006822:	1000                	addi	s0,sp,32
    80006824:	84aa                	mv	s1,a0
  if (all_locks_list_meta_lock.name != 0 && lk != &all_locks_list_meta_lock) {
    80006826:	0001f797          	auipc	a5,0x1f
    8000682a:	2b278793          	addi	a5,a5,690 # 80025ad8 <all_locks_list_meta_lock>
    8000682e:	04f50f63          	beq	a0,a5,8000688c <initlock+0x8e>
  acquire(&all_locks_list_meta_lock);
    80006832:	853e                	mv	a0,a5
    80006834:	ec3ff0ef          	jal	800066f6 <acquire>
  for (int i = 0; i < num_registered_locks; i++) {
    80006838:	00005617          	auipc	a2,0x5
    8000683c:	6c062603          	lw	a2,1728(a2) # 8000bef8 <num_registered_locks>
    80006840:	02c05363          	blez	a2,80006866 <initlock+0x68>
    80006844:	0001f797          	auipc	a5,0x1f
    80006848:	2b478793          	addi	a5,a5,692 # 80025af8 <all_registered_locks>
    8000684c:	00361693          	slli	a3,a2,0x3
    80006850:	96be                	add	a3,a3,a5
    if (all_registered_locks[i] == lk) {
    80006852:	6398                	ld	a4,0(a5)
    80006854:	02e48663          	beq	s1,a4,80006880 <initlock+0x82>
  for (int i = 0; i < num_registered_locks; i++) {
    80006858:	07a1                	addi	a5,a5,8
    8000685a:	fed79ce3          	bne	a5,a3,80006852 <initlock+0x54>
    if (num_registered_locks < MAX_LOCKS) {
    8000685e:	07f00793          	li	a5,127
    80006862:	00c7cf63          	blt	a5,a2,80006880 <initlock+0x82>
      all_registered_locks[num_registered_locks++] = lk;
    80006866:	0016079b          	addiw	a5,a2,1
    8000686a:	00005717          	auipc	a4,0x5
    8000686e:	68f72723          	sw	a5,1678(a4) # 8000bef8 <num_registered_locks>
    80006872:	060e                	slli	a2,a2,0x3
    80006874:	0001f797          	auipc	a5,0x1f
    80006878:	26478793          	addi	a5,a5,612 # 80025ad8 <all_locks_list_meta_lock>
    8000687c:	97b2                	add	a5,a5,a2
    8000687e:	f384                	sd	s1,32(a5)
  release(&all_locks_list_meta_lock);
    80006880:	0001f517          	auipc	a0,0x1f
    80006884:	25850513          	addi	a0,a0,600 # 80025ad8 <all_locks_list_meta_lock>
    80006888:	f3bff0ef          	jal	800067c2 <release>
}
    8000688c:	60e2                	ld	ra,24(sp)
    8000688e:	6442                	ld	s0,16(sp)
    80006890:	64a2                	ld	s1,8(sp)
    80006892:	6105                	addi	sp,sp,32
    80006894:	8082                	ret
    80006896:	8082                	ret

0000000080006898 <reset_all_lock_stats_kernel>:


// --- 新的内核内部函数，供 sys_resetlockstats 和 sys_statistics 调用 ---
void
reset_all_lock_stats_kernel(void)
{
    80006898:	1141                	addi	sp,sp,-16
    8000689a:	e406                	sd	ra,8(sp)
    8000689c:	e022                	sd	s0,0(sp)
    8000689e:	0800                	addi	s0,sp,16
  acquire(&all_locks_list_meta_lock);
    800068a0:	0001f517          	auipc	a0,0x1f
    800068a4:	23850513          	addi	a0,a0,568 # 80025ad8 <all_locks_list_meta_lock>
    800068a8:	e4fff0ef          	jal	800066f6 <acquire>
  for (int i = 0; i < num_registered_locks; i++) {
    800068ac:	00005697          	auipc	a3,0x5
    800068b0:	64c6a683          	lw	a3,1612(a3) # 8000bef8 <num_registered_locks>
    800068b4:	02d05463          	blez	a3,800068dc <reset_all_lock_stats_kernel+0x44>
    800068b8:	0001f797          	auipc	a5,0x1f
    800068bc:	24078793          	addi	a5,a5,576 # 80025af8 <all_registered_locks>
    800068c0:	068e                	slli	a3,a3,0x3
    800068c2:	96be                	add	a3,a3,a5
    800068c4:	a809                	j	800068d6 <reset_all_lock_stats_kernel+0x3e>
    if(all_registered_locks[i]) {
        all_registered_locks[i]->acquire_count = 0;
    800068c6:	00072c23          	sw	zero,24(a4)
        all_registered_locks[i]->tas_spins = 0;
    800068ca:	6398                	ld	a4,0(a5)
    800068cc:	00072e23          	sw	zero,28(a4)
  for (int i = 0; i < num_registered_locks; i++) {
    800068d0:	07a1                	addi	a5,a5,8
    800068d2:	00d78563          	beq	a5,a3,800068dc <reset_all_lock_stats_kernel+0x44>
    if(all_registered_locks[i]) {
    800068d6:	6398                	ld	a4,0(a5)
    800068d8:	f77d                	bnez	a4,800068c6 <reset_all_lock_stats_kernel+0x2e>
    800068da:	bfdd                	j	800068d0 <reset_all_lock_stats_kernel+0x38>
    }
  }
  release(&all_locks_list_meta_lock);
    800068dc:	0001f517          	auipc	a0,0x1f
    800068e0:	1fc50513          	addi	a0,a0,508 # 80025ad8 <all_locks_list_meta_lock>
    800068e4:	edfff0ef          	jal	800067c2 <release>
}
    800068e8:	60a2                	ld	ra,8(sp)
    800068ea:	6402                	ld	s0,0(sp)
    800068ec:	0141                	addi	sp,sp,16
    800068ee:	8082                	ret

00000000800068f0 <report_kmem_bcache_spins_formatted>:
// 如果要输出所有锁的详细列表，这个函数会复杂得多。
// 我们将实现一个只返回 "kmem_bcache_spins = TOTAL_SPINS\n" 的版本
// 以匹配 kalloctest.c 中 ntas() 的解析逻辑。
int
report_kmem_bcache_spins_formatted(char *buf, int bufsz)
{
    800068f0:	7119                	addi	sp,sp,-128
    800068f2:	fc86                	sd	ra,120(sp)
    800068f4:	f8a2                	sd	s0,112(sp)
    800068f6:	f4a6                	sd	s1,104(sp)
    800068f8:	f0ca                	sd	s2,96(sp)
    800068fa:	e4d6                	sd	s5,72(sp)
    800068fc:	e0da                	sd	s6,64(sp)
    800068fe:	fc5e                	sd	s7,56(sp)
    80006900:	f862                	sd	s8,48(sp)
    80006902:	0100                	addi	s0,sp,128
    80006904:	8aaa                	mv	s5,a0
    80006906:	8c2e                	mv	s8,a1
  long long current_total_spins = 0; // 使用 long long 以防溢出
  char num_str[22];
  int num_len;
  int len = 0;
  char *prefix = "kmem_bcache_spins = "; // kalloctest.c 的 ntas 会找 '='
  int prefix_len = strlen(prefix);
    80006908:	00002517          	auipc	a0,0x2
    8000690c:	3d050513          	addi	a0,a0,976 # 80008cd8 <etext+0xcd8>
    80006910:	d0ff90ef          	jal	8000061e <strlen>
    80006914:	8baa                	mv	s7,a0

  acquire(&all_locks_list_meta_lock);
    80006916:	0001f517          	auipc	a0,0x1f
    8000691a:	1c250513          	addi	a0,a0,450 # 80025ad8 <all_locks_list_meta_lock>
    8000691e:	dd9ff0ef          	jal	800066f6 <acquire>
  for (int i = 0; i < num_registered_locks; i++) {
    80006922:	00005797          	auipc	a5,0x5
    80006926:	5d67a783          	lw	a5,1494(a5) # 8000bef8 <num_registered_locks>
    8000692a:	0ef05163          	blez	a5,80006a0c <report_kmem_bcache_spins_formatted+0x11c>
    8000692e:	ecce                	sd	s3,88(sp)
    80006930:	e8d2                	sd	s4,80(sp)
    80006932:	f466                	sd	s9,40(sp)
    80006934:	f06a                	sd	s10,32(sp)
    80006936:	0001f997          	auipc	s3,0x1f
    8000693a:	1c298993          	addi	s3,s3,450 # 80025af8 <all_registered_locks>
    8000693e:	4901                	li	s2,0
  long long current_total_spins = 0; // 使用 long long 以防溢出
    80006940:	4b01                	li	s6,0
    struct spinlock *lk = all_registered_locks[i];
    if (lk && lk->name) { // 确保锁和名字有效
      // 累加所有以 "kmem" 或 "bcache" 开头的锁的 tas_spins
      // 这包括了你优化后的 kmem_0, kmem_1 等
      if (strncmp(lk->name, "kmem", 4) == 0 || strncmp(lk->name, "bcache", 6) == 0) {
    80006942:	00002c97          	auipc	s9,0x2
    80006946:	3aec8c93          	addi	s9,s9,942 # 80008cf0 <etext+0xcf0>
    8000694a:	00002d17          	auipc	s10,0x2
    8000694e:	f4ed0d13          	addi	s10,s10,-178 # 80008898 <etext+0x898>
  for (int i = 0; i < num_registered_locks; i++) {
    80006952:	00005a17          	auipc	s4,0x5
    80006956:	5a6a0a13          	addi	s4,s4,1446 # 8000bef8 <num_registered_locks>
    8000695a:	a811                	j	8000696e <report_kmem_bcache_spins_formatted+0x7e>
        current_total_spins += lk->tas_spins;
    8000695c:	01c4e783          	lwu	a5,28(s1)
    80006960:	9b3e                	add	s6,s6,a5
  for (int i = 0; i < num_registered_locks; i++) {
    80006962:	2905                	addiw	s2,s2,1
    80006964:	09a1                	addi	s3,s3,8
    80006966:	000a2783          	lw	a5,0(s4)
    8000696a:	02f95363          	bge	s2,a5,80006990 <report_kmem_bcache_spins_formatted+0xa0>
    struct spinlock *lk = all_registered_locks[i];
    8000696e:	0009b483          	ld	s1,0(s3)
    if (lk && lk->name) { // 确保锁和名字有效
    80006972:	d8e5                	beqz	s1,80006962 <report_kmem_bcache_spins_formatted+0x72>
    80006974:	6488                	ld	a0,8(s1)
    80006976:	d575                	beqz	a0,80006962 <report_kmem_bcache_spins_formatted+0x72>
      if (strncmp(lk->name, "kmem", 4) == 0 || strncmp(lk->name, "bcache", 6) == 0) {
    80006978:	4611                	li	a2,4
    8000697a:	85e6                	mv	a1,s9
    8000697c:	bfff90ef          	jal	8000057a <strncmp>
    80006980:	dd71                	beqz	a0,8000695c <report_kmem_bcache_spins_formatted+0x6c>
    80006982:	4619                	li	a2,6
    80006984:	85ea                	mv	a1,s10
    80006986:	6488                	ld	a0,8(s1)
    80006988:	bf3f90ef          	jal	8000057a <strncmp>
    8000698c:	f979                	bnez	a0,80006962 <report_kmem_bcache_spins_formatted+0x72>
    8000698e:	b7f9                	j	8000695c <report_kmem_bcache_spins_formatted+0x6c>
    80006990:	69e6                	ld	s3,88(sp)
    80006992:	6a46                	ld	s4,80(sp)
    80006994:	7ca2                	ld	s9,40(sp)
    80006996:	7d02                	ld	s10,32(sp)
      }
    }
  }
  release(&all_locks_list_meta_lock);
    80006998:	0001f517          	auipc	a0,0x1f
    8000699c:	14050513          	addi	a0,a0,320 # 80025ad8 <all_locks_list_meta_lock>
    800069a0:	e23ff0ef          	jal	800067c2 <release>

  // 格式化输出字符串
  if (prefix_len >= bufsz - 12) return -1; // 检查前缀空间
    800069a4:	ff4c079b          	addiw	a5,s8,-12
    800069a8:	06fbd463          	bge	s7,a5,80006a10 <report_kmem_bcache_spins_formatted+0x120>
  memmove(buf, prefix, prefix_len);
    800069ac:	000b861b          	sext.w	a2,s7
    800069b0:	00002597          	auipc	a1,0x2
    800069b4:	32858593          	addi	a1,a1,808 # 80008cd8 <etext+0xcd8>
    800069b8:	8556                	mv	a0,s5
    800069ba:	b51f90ef          	jal	8000050a <memmove>
  len = prefix_len;

  num_len = k_itoa(current_total_spins, num_str, 10);
    800069be:	4629                	li	a2,10
    800069c0:	f8840593          	addi	a1,s0,-120
    800069c4:	855a                	mv	a0,s6
    800069c6:	cc3f90ef          	jal	80000688 <k_itoa>
  if (len + num_len + 1 >= bufsz) return -1; // 检查数字和换行符空间 (+1 for '\n')
    800069ca:	00ab84bb          	addw	s1,s7,a0
    800069ce:	0004891b          	sext.w	s2,s1
    800069d2:	2485                	addiw	s1,s1,1
    800069d4:	0584d063          	bge	s1,s8,80006a14 <report_kmem_bcache_spins_formatted+0x124>
  memmove(buf + len, num_str, num_len);
    800069d8:	0005061b          	sext.w	a2,a0
    800069dc:	f8840593          	addi	a1,s0,-120
    800069e0:	017a8533          	add	a0,s5,s7
    800069e4:	b27f90ef          	jal	8000050a <memmove>
  len += num_len;

  buf[len++] = '\n';
    800069e8:	9956                	add	s2,s2,s5
    800069ea:	47a9                	li	a5,10
    800069ec:	00f90023          	sb	a5,0(s2)
  buf[len] = '\0';
    800069f0:	9aa6                	add	s5,s5,s1
    800069f2:	000a8023          	sb	zero,0(s5)

  return len; // 返回写入的字符数 (不包括最后的 \0)
    800069f6:	8526                	mv	a0,s1
    800069f8:	70e6                	ld	ra,120(sp)
    800069fa:	7446                	ld	s0,112(sp)
    800069fc:	74a6                	ld	s1,104(sp)
    800069fe:	7906                	ld	s2,96(sp)
    80006a00:	6aa6                	ld	s5,72(sp)
    80006a02:	6b06                	ld	s6,64(sp)
    80006a04:	7be2                	ld	s7,56(sp)
    80006a06:	7c42                	ld	s8,48(sp)
    80006a08:	6109                	addi	sp,sp,128
    80006a0a:	8082                	ret
  long long current_total_spins = 0; // 使用 long long 以防溢出
    80006a0c:	4b01                	li	s6,0
    80006a0e:	b769                	j	80006998 <report_kmem_bcache_spins_formatted+0xa8>
  if (prefix_len >= bufsz - 12) return -1; // 检查前缀空间
    80006a10:	54fd                	li	s1,-1
    80006a12:	b7d5                	j	800069f6 <report_kmem_bcache_spins_formatted+0x106>
  if (len + num_len + 1 >= bufsz) return -1; // 检查数字和换行符空间 (+1 for '\n')
    80006a14:	54fd                	li	s1,-1
    80006a16:	b7c5                	j	800069f6 <report_kmem_bcache_spins_formatted+0x106>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
