
user/_pgtbltest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:
}

// Helper function to report errors and exit
void
err(char *why)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
  printf("pgtbltest: %s FAILED: %s, pid=%d\n", testname, why, getpid());
   e:	00003917          	auipc	s2,0x3
  12:	ff293903          	ld	s2,-14(s2) # 3000 <testname>
  16:	249000ef          	jal	a5e <getpid>
  1a:	86aa                	mv	a3,a0
  1c:	8626                	mv	a2,s1
  1e:	85ca                	mv	a1,s2
  20:	00001517          	auipc	a0,0x1
  24:	fd050513          	addi	a0,a0,-48 # ff0 <malloc+0xfe>
  28:	617000ef          	jal	e3e <printf>
  exit(1);
  2c:	4505                	li	a0,1
  2e:	1b1000ef          	jal	9de <exit>

0000000000000032 <print_single_pte_info>:
}

// Helper function to print a single PTE using pgpte syscall
void
print_single_pte_info(uint64 va)
{
  32:	1101                	addi	sp,sp,-32
  34:	ec06                	sd	ra,24(sp)
  36:	e822                	sd	s0,16(sp)
  38:	e426                	sd	s1,8(sp)
  3a:	1000                	addi	s0,sp,32
  3c:	84aa                	mv	s1,a0
    uint64 pte_val = pgpte((void *) va); // Assumes pgpte returns uint64 (the PTE value)
  3e:	271000ef          	jal	aae <pgpte>
                                       // or 0 if not mapped/error.
    if (pte_val == 0) {
  42:	ed09                	bnez	a0,5c <print_single_pte_info+0x2a>
        printf("va 0x%lx: pte not mapped or error in pgpte()\n", va);
  44:	85a6                	mv	a1,s1
  46:	00001517          	auipc	a0,0x1
  4a:	fd250513          	addi	a0,a0,-46 # 1018 <malloc+0x126>
  4e:	5f1000ef          	jal	e3e <printf>
               va,
               pte_val,
               PTE2PA(pte_val), // This macro works on the PTE value
               (int)(pte_val & 0x3FF)); // Extracting low 10 bits for flags
    }
}
  52:	60e2                	ld	ra,24(sp)
  54:	6442                	ld	s0,16(sp)
  56:	64a2                	ld	s1,8(sp)
  58:	6105                	addi	sp,sp,32
  5a:	8082                	ret
  5c:	862a                	mv	a2,a0
               PTE2PA(pte_val), // This macro works on the PTE value
  5e:	00a55693          	srli	a3,a0,0xa
        printf("va 0x%lx pte 0x%lx pa 0x%lx perm 0x%x\n",
  62:	3ff57713          	andi	a4,a0,1023
  66:	06b2                	slli	a3,a3,0xc
  68:	85a6                	mv	a1,s1
  6a:	00001517          	auipc	a0,0x1
  6e:	fde50513          	addi	a0,a0,-34 # 1048 <malloc+0x156>
  72:	5cd000ef          	jal	e3e <printf>
}
  76:	bff1                	j	52 <print_single_pte_info+0x20>

0000000000000078 <print_pgtbl_using_pgpte>:

// Test function to print parts of the user page table using pgpte
void
print_pgtbl_using_pgpte()
{
  78:	1101                	addi	sp,sp,-32
  7a:	ec06                	sd	ra,24(sp)
  7c:	e822                	sd	s0,16(sp)
  7e:	e426                	sd	s1,8(sp)
  80:	1000                	addi	s0,sp,32
  testname = "print_pgtbl_using_pgpte";
  82:	00003497          	auipc	s1,0x3
  86:	f7e48493          	addi	s1,s1,-130 # 3000 <testname>
  8a:	00001597          	auipc	a1,0x1
  8e:	fe658593          	addi	a1,a1,-26 # 1070 <malloc+0x17e>
  92:	e08c                	sd	a1,0(s1)
  printf("%s starting\n", testname);
  94:	00001517          	auipc	a0,0x1
  98:	ff450513          	addi	a0,a0,-12 # 1088 <malloc+0x196>
  9c:	5a3000ef          	jal	e3e <printf>

  printf("Bottom of address space:\n");
  a0:	00001517          	auipc	a0,0x1
  a4:	ff850513          	addi	a0,a0,-8 # 1098 <malloc+0x1a6>
  a8:	597000ef          	jal	e3e <printf>
  for (uint64 i = 0; i < 5; i++) { // Print a few pages from the bottom
    print_single_pte_info(i * PGSIZE);
  ac:	4501                	li	a0,0
  ae:	f85ff0ef          	jal	32 <print_single_pte_info>
  b2:	6505                	lui	a0,0x1
  b4:	f7fff0ef          	jal	32 <print_single_pte_info>
  b8:	6509                	lui	a0,0x2
  ba:	f79ff0ef          	jal	32 <print_single_pte_info>
  be:	650d                	lui	a0,0x3
  c0:	f73ff0ef          	jal	32 <print_single_pte_info>
  c4:	6511                	lui	a0,0x4
  c6:	f6dff0ef          	jal	32 <print_single_pte_info>
  }

  printf("Top of address space (below MAXVA):\n");
  ca:	00001517          	auipc	a0,0x1
  ce:	fee50513          	addi	a0,a0,-18 # 10b8 <malloc+0x1c6>
  d2:	56d000ef          	jal	e3e <printf>
  // uint64 top_va_region_start = MAXVA - 5 * PGSIZE;
  // A more robust way if MAXVA is not in user.h:
  uint64 top_va_region_start = (1L << (39-1)) - 5 * PGSIZE; // Approximation of user MAXVA

  for (uint64 i = 0; i < 5; i++) { // Print a few pages from the top
    print_single_pte_info(top_va_region_start + i * PGSIZE);
  d6:	04000537          	lui	a0,0x4000
  da:	156d                	addi	a0,a0,-5 # 3fffffb <base+0x3ffcfdb>
  dc:	0532                	slli	a0,a0,0xc
  de:	f55ff0ef          	jal	32 <print_single_pte_info>
  e2:	01000537          	lui	a0,0x1000
  e6:	157d                	addi	a0,a0,-1 # ffffff <base+0xffcfdf>
  e8:	053a                	slli	a0,a0,0xe
  ea:	f49ff0ef          	jal	32 <print_single_pte_info>
  ee:	04000537          	lui	a0,0x4000
  f2:	1575                	addi	a0,a0,-3 # 3fffffd <base+0x3ffcfdd>
  f4:	0532                	slli	a0,a0,0xc
  f6:	f3dff0ef          	jal	32 <print_single_pte_info>
  fa:	02000537          	lui	a0,0x2000
  fe:	157d                	addi	a0,a0,-1 # 1ffffff <base+0x1ffcfdf>
 100:	0536                	slli	a0,a0,0xd
 102:	f31ff0ef          	jal	32 <print_single_pte_info>
 106:	04000537          	lui	a0,0x4000
 10a:	157d                	addi	a0,a0,-1 # 3ffffff <base+0x3ffcfdf>
 10c:	0532                	slli	a0,a0,0xc
 10e:	f25ff0ef          	jal	32 <print_single_pte_info>
  }
  printf("%s: OK\n", testname);
 112:	608c                	ld	a1,0(s1)
 114:	00001517          	auipc	a0,0x1
 118:	fcc50513          	addi	a0,a0,-52 # 10e0 <malloc+0x1ee>
 11c:	523000ef          	jal	e3e <printf>
}
 120:	60e2                	ld	ra,24(sp)
 122:	6442                	ld	s0,16(sp)
 124:	64a2                	ld	s1,8(sp)
 126:	6105                	addi	sp,sp,32
 128:	8082                	ret

000000000000012a <ugetpid_test>:

// Test function for ugetpid system call
void
ugetpid_test()
{
 12a:	7139                	addi	sp,sp,-64
 12c:	fc06                	sd	ra,56(sp)
 12e:	f822                	sd	s0,48(sp)
 130:	f426                	sd	s1,40(sp)
 132:	f04a                	sd	s2,32(sp)
 134:	ec4e                	sd	s3,24(sp)
 136:	0080                	addi	s0,sp,64
  int i;
  int mypid_kernel = getpid(); // Get PID via standard getpid for comparison
 138:	127000ef          	jal	a5e <getpid>
 13c:	89aa                	mv	s3,a0

  testname = "ugetpid_test";
 13e:	00001597          	auipc	a1,0x1
 142:	faa58593          	addi	a1,a1,-86 # 10e8 <malloc+0x1f6>
 146:	00003797          	auipc	a5,0x3
 14a:	eab7bd23          	sd	a1,-326(a5) # 3000 <testname>
  printf("%s starting (kernel pid for this process: %d)\n", testname, mypid_kernel);
 14e:	862a                	mv	a2,a0
 150:	00001517          	auipc	a0,0x1
 154:	fa850513          	addi	a0,a0,-88 # 10f8 <malloc+0x206>
 158:	4e7000ef          	jal	e3e <printf>
 15c:	4929                	li	s2,10

  for (i = 0; i < 10; i++) { // Reduced loop count for faster testing
    int ret = fork();
 15e:	079000ef          	jal	9d6 <fork>
 162:	84aa                	mv	s1,a0
    if (ret < 0) {
 164:	04054263          	bltz	a0,1a8 <ugetpid_test+0x7e>
      err("fork failed");
    }
    if (ret == 0) { // Child process
 168:	c531                	beqz	a0,1b4 <ugetpid_test+0x8a>
        err("mismatched PID in child");
      }
      exit(0); // Child exits successfully
    } else { // Parent process
      int status;
      wait(&status);
 16a:	fcc40513          	addi	a0,s0,-52
 16e:	079000ef          	jal	9e6 <wait>
      if (status != 0) {
 172:	fcc42603          	lw	a2,-52(s0)
 176:	e63d                	bnez	a2,1e4 <ugetpid_test+0xba>
  for (i = 0; i < 10; i++) { // Reduced loop count for faster testing
 178:	397d                	addiw	s2,s2,-1
 17a:	fe0912e3          	bnez	s2,15e <ugetpid_test+0x34>
        err("child process failed");
      }
    }
  }
  // Check parent's PID again
  if (mypid_kernel != ugetpid()){
 17e:	139000ef          	jal	ab6 <ugetpid>
 182:	07351e63          	bne	a0,s3,1fe <ugetpid_test+0xd4>
    printf("ugetpid_test: Parent PID mismatch! getpid()=%d, ugetpid()=%d\n",
            mypid_kernel, ugetpid());
    err("mismatched PID in parent after children");
  }
  printf("%s: OK\n", testname);
 186:	00003597          	auipc	a1,0x3
 18a:	e7a5b583          	ld	a1,-390(a1) # 3000 <testname>
 18e:	00001517          	auipc	a0,0x1
 192:	f5250513          	addi	a0,a0,-174 # 10e0 <malloc+0x1ee>
 196:	4a9000ef          	jal	e3e <printf>
}
 19a:	70e2                	ld	ra,56(sp)
 19c:	7442                	ld	s0,48(sp)
 19e:	74a2                	ld	s1,40(sp)
 1a0:	7902                	ld	s2,32(sp)
 1a2:	69e2                	ld	s3,24(sp)
 1a4:	6121                	addi	sp,sp,64
 1a6:	8082                	ret
      err("fork failed");
 1a8:	00001517          	auipc	a0,0x1
 1ac:	f8050513          	addi	a0,a0,-128 # 1128 <malloc+0x236>
 1b0:	e51ff0ef          	jal	0 <err>
      int child_pid_kernel = getpid();
 1b4:	0ab000ef          	jal	a5e <getpid>
 1b8:	84aa                	mv	s1,a0
      int child_pid_ugetpid = ugetpid();
 1ba:	0fd000ef          	jal	ab6 <ugetpid>
 1be:	862a                	mv	a2,a0
      if (child_pid_kernel != child_pid_ugetpid) {
 1c0:	00a48f63          	beq	s1,a0,1de <ugetpid_test+0xb4>
        printf("ugetpid_test: Child PID mismatch! getpid()=%d, ugetpid()=%d\n",
 1c4:	85a6                	mv	a1,s1
 1c6:	00001517          	auipc	a0,0x1
 1ca:	f7250513          	addi	a0,a0,-142 # 1138 <malloc+0x246>
 1ce:	471000ef          	jal	e3e <printf>
        err("mismatched PID in child");
 1d2:	00001517          	auipc	a0,0x1
 1d6:	fa650513          	addi	a0,a0,-90 # 1178 <malloc+0x286>
 1da:	e27ff0ef          	jal	0 <err>
      exit(0); // Child exits successfully
 1de:	4501                	li	a0,0
 1e0:	7fe000ef          	jal	9de <exit>
        printf("ugetpid_test: Child (pid %d) exited with status %d\n", ret, status);
 1e4:	85a6                	mv	a1,s1
 1e6:	00001517          	auipc	a0,0x1
 1ea:	faa50513          	addi	a0,a0,-86 # 1190 <malloc+0x29e>
 1ee:	451000ef          	jal	e3e <printf>
        err("child process failed");
 1f2:	00001517          	auipc	a0,0x1
 1f6:	fd650513          	addi	a0,a0,-42 # 11c8 <malloc+0x2d6>
 1fa:	e07ff0ef          	jal	0 <err>
    printf("ugetpid_test: Parent PID mismatch! getpid()=%d, ugetpid()=%d\n",
 1fe:	0b9000ef          	jal	ab6 <ugetpid>
 202:	862a                	mv	a2,a0
 204:	85ce                	mv	a1,s3
 206:	00001517          	auipc	a0,0x1
 20a:	fda50513          	addi	a0,a0,-38 # 11e0 <malloc+0x2ee>
 20e:	431000ef          	jal	e3e <printf>
    err("mismatched PID in parent after children");
 212:	00001517          	auipc	a0,0x1
 216:	00e50513          	addi	a0,a0,14 # 1220 <malloc+0x32e>
 21a:	de7ff0ef          	jal	0 <err>

000000000000021e <print_kpgtbl_using_syscall>:

// Test function to print current process's page table using kpgtbl syscall
void
print_kpgtbl_using_syscall()
{
 21e:	1101                	addi	sp,sp,-32
 220:	ec06                	sd	ra,24(sp)
 222:	e822                	sd	s0,16(sp)
 224:	e426                	sd	s1,8(sp)
 226:	e04a                	sd	s2,0(sp)
 228:	1000                	addi	s0,sp,32
  testname = "print_kpgtbl_using_syscall";
 22a:	00003497          	auipc	s1,0x3
 22e:	dd648493          	addi	s1,s1,-554 # 3000 <testname>
 232:	00001917          	auipc	s2,0x1
 236:	01690913          	addi	s2,s2,22 # 1248 <malloc+0x356>
 23a:	0124b023          	sd	s2,0(s1)
  printf("%s starting for pid %d\n", testname, getpid());
 23e:	021000ef          	jal	a5e <getpid>
 242:	862a                	mv	a2,a0
 244:	85ca                	mv	a1,s2
 246:	00001517          	auipc	a0,0x1
 24a:	02250513          	addi	a0,a0,34 # 1268 <malloc+0x376>
 24e:	3f1000ef          	jal	e3e <printf>
  kpgtbl(); // Call the system call
 252:	02d000ef          	jal	a7e <kpgtbl>
  printf("%s: OK (output above)\n", testname);
 256:	608c                	ld	a1,0(s1)
 258:	00001517          	auipc	a0,0x1
 25c:	02850513          	addi	a0,a0,40 # 1280 <malloc+0x38e>
 260:	3df000ef          	jal	e3e <printf>
}
 264:	60e2                	ld	ra,24(sp)
 266:	6442                	ld	s0,16(sp)
 268:	64a2                	ld	s1,8(sp)
 26a:	6902                	ld	s2,0(sp)
 26c:	6105                	addi	sp,sp,32
 26e:	8082                	ret

0000000000000270 <supercheck>:

// Helper function to check a 2MB superpage region
void
supercheck(uint64 va_start_of_2mb_region)
{
 270:	711d                	addi	sp,sp,-96
 272:	ec86                	sd	ra,88(sp)
 274:	e8a2                	sd	s0,80(sp)
 276:	e4a6                	sd	s1,72(sp)
 278:	e0ca                	sd	s2,64(sp)
 27a:	fc4e                	sd	s3,56(sp)
 27c:	f852                	sd	s4,48(sp)
 27e:	f456                	sd	s5,40(sp)
 280:	f05a                	sd	s6,32(sp)
 282:	ec5e                	sd	s7,24(sp)
 284:	e862                	sd	s8,16(sp)
 286:	e466                	sd	s9,8(sp)
 288:	1080                	addi	s0,sp,96
 28a:	8aaa                	mv	s5,a0
  uint64 first_pte_val = 0;

  testname = "supercheck"; // Temporarily set for err() if it happens inside
 28c:	00001797          	auipc	a5,0x1
 290:	00c78793          	addi	a5,a5,12 # 1298 <malloc+0x3a6>
 294:	00003717          	auipc	a4,0x3
 298:	d6f73623          	sd	a5,-660(a4) # 3000 <testname>
  printf("supercheck: Verifying 2MB region starting at VA 0x%lx\n", va_start_of_2mb_region);
 29c:	85aa                	mv	a1,a0
 29e:	00001517          	auipc	a0,0x1
 2a2:	00a50513          	addi	a0,a0,10 # 12a8 <malloc+0x3b6>
 2a6:	399000ef          	jal	e3e <printf>
 2aa:	89d6                	mv	s3,s5

  for (uint64 va_offset = 0; va_offset < SUPERPGSIZE; va_offset += PGSIZE) {
 2ac:	4901                	li	s2,0
  uint64 first_pte_val = 0;
 2ae:	4b01                	li	s6,0
        err("pte different - not a single superpage mapping");
      }
    }

    // Basic permission check based on the first PTE (assuming it's a superpage)
    if (!((first_pte_val & PTE_V) && (first_pte_val & PTE_R) && (first_pte_val & PTE_W) && (first_pte_val & PTE_U))) {
 2b0:	4bdd                	li	s7,23
  for (uint64 va_offset = 0; va_offset < SUPERPGSIZE; va_offset += PGSIZE) {
 2b2:	6a05                	lui	s4,0x1
 2b4:	00200c37          	lui	s8,0x200
       printf("supercheck: First PTE in 2MB region (VA 0x%lx) is 0x%lx\n", current_va, pte_val);
 2b8:	00001c97          	auipc	s9,0x1
 2bc:	110c8c93          	addi	s9,s9,272 # 13c8 <malloc+0x4d6>
 2c0:	a081                	j	300 <supercheck+0x90>
      printf("supercheck: No PTE for VA 0x%lx within the 2MB region.\n", current_va);
 2c2:	85ce                	mv	a1,s3
 2c4:	00001517          	auipc	a0,0x1
 2c8:	01c50513          	addi	a0,a0,28 # 12e0 <malloc+0x3ee>
 2cc:	373000ef          	jal	e3e <printf>
      err("no pte within superpage region");
 2d0:	00001517          	auipc	a0,0x1
 2d4:	04850513          	addi	a0,a0,72 # 1318 <malloc+0x426>
 2d8:	d29ff0ef          	jal	0 <err>
      if (!((pte_val & PTE_V) && (pte_val & (PTE_R | PTE_W | PTE_X)))) {
 2dc:	00157793          	andi	a5,a0,1
 2e0:	cbd5                	beqz	a5,394 <supercheck+0x124>
 2e2:	00e57793          	andi	a5,a0,14
 2e6:	c7dd                	beqz	a5,394 <supercheck+0x124>
       printf("supercheck: First PTE in 2MB region (VA 0x%lx) is 0x%lx\n", current_va, pte_val);
 2e8:	862a                	mv	a2,a0
 2ea:	85ce                	mv	a1,s3
 2ec:	8566                	mv	a0,s9
 2ee:	351000ef          	jal	e3e <printf>
    if (!((first_pte_val & PTE_V) && (first_pte_val & PTE_R) && (first_pte_val & PTE_W) && (first_pte_val & PTE_U))) {
 2f2:	0174f793          	andi	a5,s1,23
 2f6:	0d779c63          	bne	a5,s7,3ce <supercheck+0x15e>
  for (uint64 va_offset = 0; va_offset < SUPERPGSIZE; va_offset += PGSIZE) {
 2fa:	9952                	add	s2,s2,s4
 2fc:	99d2                	add	s3,s3,s4
{
 2fe:	8b26                	mv	s6,s1
    uint64 pte_val = pgpte((void *) current_va);
 300:	854e                	mv	a0,s3
 302:	7ac000ef          	jal	aae <pgpte>
 306:	84aa                	mv	s1,a0
    if (pte_val == 0) {
 308:	dd4d                	beqz	a0,2c2 <supercheck+0x52>
    if (va_offset == 0) {
 30a:	fc0909e3          	beqz	s2,2dc <supercheck+0x6c>
      if (pte_val != first_pte_val) {
 30e:	0b651163          	bne	a0,s6,3b0 <supercheck+0x140>
    if (!((first_pte_val & PTE_V) && (first_pte_val & PTE_R) && (first_pte_val & PTE_W) && (first_pte_val & PTE_U))) {
 312:	01757793          	andi	a5,a0,23
 316:	0b779c63          	bne	a5,s7,3ce <supercheck+0x15e>
  for (uint64 va_offset = 0; va_offset < SUPERPGSIZE; va_offset += PGSIZE) {
 31a:	9952                	add	s2,s2,s4
 31c:	99d2                	add	s3,s3,s4
 31e:	ff8910e3          	bne	s2,s8,2fe <supercheck+0x8e>
      printf("supercheck: Expected V,R,W,U for sbrk'd superpage at VA 0x%lx, pte=0x%lx\n", va_start_of_2mb_region, first_pte_val);
      err("superpage pte missing expected permissions (V,R,W,U)");
    }
  }
  printf("supercheck: PTE consistency OK for 2MB region at VA 0x%lx.\n", va_start_of_2mb_region);
 322:	85d6                	mv	a1,s5
 324:	00001517          	auipc	a0,0x1
 328:	1f450513          	addi	a0,a0,500 # 1518 <malloc+0x626>
 32c:	313000ef          	jal	e3e <printf>

  // Memory content writability and readability check
  printf("supercheck: Performing memory R/W test in 2MB region at VA 0x%lx.\n", va_start_of_2mb_region);
 330:	85d6                	mv	a1,s5
 332:	00001517          	auipc	a0,0x1
 336:	22650513          	addi	a0,a0,550 # 1558 <malloc+0x666>
 33a:	305000ef          	jal	e3e <printf>
  for(uint64 offset_in_superpage = 0; offset_in_superpage < SUPERPGSIZE; offset_in_superpage += PGSIZE) {
 33e:	002006b7          	lui	a3,0x200
 342:	96d6                	add	a3,a3,s5
  printf("supercheck: Performing memory R/W test in 2MB region at VA 0x%lx.\n", va_start_of_2mb_region);
 344:	87d6                	mv	a5,s5
  for(uint64 offset_in_superpage = 0; offset_in_superpage < SUPERPGSIZE; offset_in_superpage += PGSIZE) {
 346:	6605                	lui	a2,0x1
    char *ptr = (char *)(va_start_of_2mb_region + offset_in_superpage);
    *ptr = (char)((va_start_of_2mb_region + offset_in_superpage) % 128);
 348:	07f7f713          	andi	a4,a5,127
 34c:	00e78023          	sb	a4,0(a5)
  for(uint64 offset_in_superpage = 0; offset_in_superpage < SUPERPGSIZE; offset_in_superpage += PGSIZE) {
 350:	97b2                	add	a5,a5,a2
 352:	fed79be3          	bne	a5,a3,348 <supercheck+0xd8>
 356:	85d6                	mv	a1,s5
  }

  for(uint64 offset_in_superpage = 0; offset_in_superpage < SUPERPGSIZE; offset_in_superpage += PGSIZE) {
 358:	6605                	lui	a2,0x1
    char *ptr = (char *)(va_start_of_2mb_region + offset_in_superpage);
    if (*ptr != (char)((va_start_of_2mb_region + offset_in_superpage) % 128)) {
 35a:	0005c703          	lbu	a4,0(a1)
 35e:	07f5f793          	andi	a5,a1,127
 362:	08f71463          	bne	a4,a5,3ea <supercheck+0x17a>
  for(uint64 offset_in_superpage = 0; offset_in_superpage < SUPERPGSIZE; offset_in_superpage += PGSIZE) {
 366:	95b2                	add	a1,a1,a2
 368:	fed599e3          	bne	a1,a3,35a <supercheck+0xea>
      printf("supercheck: Memory content mismatch at VA 0x%lx.\n", va_start_of_2mb_region + offset_in_superpage);
      err("wrong value in superpage memory");
    }
  }
  printf("supercheck: Memory R/W test OK for 2MB region at VA 0x%lx.\n", va_start_of_2mb_region);
 36c:	85d6                	mv	a1,s5
 36e:	00001517          	auipc	a0,0x1
 372:	28a50513          	addi	a0,a0,650 # 15f8 <malloc+0x706>
 376:	2c9000ef          	jal	e3e <printf>
}
 37a:	60e6                	ld	ra,88(sp)
 37c:	6446                	ld	s0,80(sp)
 37e:	64a6                	ld	s1,72(sp)
 380:	6906                	ld	s2,64(sp)
 382:	79e2                	ld	s3,56(sp)
 384:	7a42                	ld	s4,48(sp)
 386:	7aa2                	ld	s5,40(sp)
 388:	7b02                	ld	s6,32(sp)
 38a:	6be2                	ld	s7,24(sp)
 38c:	6c42                	ld	s8,16(sp)
 38e:	6ca2                	ld	s9,8(sp)
 390:	6125                	addi	sp,sp,96
 392:	8082                	ret
         printf("supercheck: VA 0x%lx does not look like a leaf PTE (R|W|X not set for superpage), pte=0x%lx\n", current_va, pte_val);
 394:	8626                	mv	a2,s1
 396:	85ce                	mv	a1,s3
 398:	00001517          	auipc	a0,0x1
 39c:	fa050513          	addi	a0,a0,-96 # 1338 <malloc+0x446>
 3a0:	29f000ef          	jal	e3e <printf>
         err("first PTE of superpage region is not a leaf");
 3a4:	00001517          	auipc	a0,0x1
 3a8:	ff450513          	addi	a0,a0,-12 # 1398 <malloc+0x4a6>
 3ac:	c55ff0ef          	jal	0 <err>
        printf("supercheck: PTE mismatch within 2MB region! VA 0x%lx has pte 0x%lx, expected 0x%lx\n",
 3b0:	86da                	mv	a3,s6
 3b2:	862a                	mv	a2,a0
 3b4:	85ce                	mv	a1,s3
 3b6:	00001517          	auipc	a0,0x1
 3ba:	05250513          	addi	a0,a0,82 # 1408 <malloc+0x516>
 3be:	281000ef          	jal	e3e <printf>
        err("pte different - not a single superpage mapping");
 3c2:	00001517          	auipc	a0,0x1
 3c6:	09e50513          	addi	a0,a0,158 # 1460 <malloc+0x56e>
 3ca:	c37ff0ef          	jal	0 <err>
      printf("supercheck: Expected V,R,W,U for sbrk'd superpage at VA 0x%lx, pte=0x%lx\n", va_start_of_2mb_region, first_pte_val);
 3ce:	8626                	mv	a2,s1
 3d0:	85d6                	mv	a1,s5
 3d2:	00001517          	auipc	a0,0x1
 3d6:	0be50513          	addi	a0,a0,190 # 1490 <malloc+0x59e>
 3da:	265000ef          	jal	e3e <printf>
      err("superpage pte missing expected permissions (V,R,W,U)");
 3de:	00001517          	auipc	a0,0x1
 3e2:	10250513          	addi	a0,a0,258 # 14e0 <malloc+0x5ee>
 3e6:	c1bff0ef          	jal	0 <err>
      printf("supercheck: Memory content mismatch at VA 0x%lx.\n", va_start_of_2mb_region + offset_in_superpage);
 3ea:	00001517          	auipc	a0,0x1
 3ee:	1b650513          	addi	a0,a0,438 # 15a0 <malloc+0x6ae>
 3f2:	24d000ef          	jal	e3e <printf>
      err("wrong value in superpage memory");
 3f6:	00001517          	auipc	a0,0x1
 3fa:	1e250513          	addi	a0,a0,482 # 15d8 <malloc+0x6e6>
 3fe:	c03ff0ef          	jal	0 <err>

0000000000000402 <superpg_test>:

// Test function for superpage allocation and usage
void
superpg_test()
{
 402:	715d                	addi	sp,sp,-80
 404:	e486                	sd	ra,72(sp)
 406:	e0a2                	sd	s0,64(sp)
 408:	fc26                	sd	s1,56(sp)
 40a:	f84a                	sd	s2,48(sp)
 40c:	f44e                	sd	s3,40(sp)
 40e:	f052                	sd	s4,32(sp)
 410:	ec56                	sd	s5,24(sp)
 412:	0880                	addi	s0,sp,80
  int pid;
  char *sbrk_old_break, *sbrk_new_break;
  
  testname = "superpg_test";
 414:	00001597          	auipc	a1,0x1
 418:	22458593          	addi	a1,a1,548 # 1638 <malloc+0x746>
 41c:	00003797          	auipc	a5,0x3
 420:	beb7b223          	sd	a1,-1052(a5) # 3000 <testname>
  printf("%s starting\n", testname);
 424:	00001517          	auipc	a0,0x1
 428:	c6450513          	addi	a0,a0,-924 # 1088 <malloc+0x196>
 42c:	213000ef          	jal	e3e <printf>
  
  printf("pgtbltest: Current process pagetable (before superpg_test sbrk):\n");
 430:	00001517          	auipc	a0,0x1
 434:	21850513          	addi	a0,a0,536 # 1648 <malloc+0x756>
 438:	207000ef          	jal	e3e <printf>
  print_kpgtbl_using_syscall();
 43c:	de3ff0ef          	jal	21e <print_kpgtbl_using_syscall>

  sbrk_old_break = sbrk(0);
 440:	4501                	li	a0,0
 442:	624000ef          	jal	a66 <sbrk>
 446:	892a                	mv	s2,a0
  printf("superpg_test: Current break before sbrk(0x%lx) is 0x%p\n", (uint64)SBRK_SIZE_FOR_SUPERPG_TEST, sbrk_old_break);
 448:	862a                	mv	a2,a0
 44a:	008005b7          	lui	a1,0x800
 44e:	00001517          	auipc	a0,0x1
 452:	24250513          	addi	a0,a0,578 # 1690 <malloc+0x79e>
 456:	1e9000ef          	jal	e3e <printf>
  
  if (sbrk(SBRK_SIZE_FOR_SUPERPG_TEST) == (char*)-1) { // sbrk returns -1 on error
 45a:	00800537          	lui	a0,0x800
 45e:	608000ef          	jal	a66 <sbrk>
 462:	57fd                	li	a5,-1
 464:	0ef50c63          	beq	a0,a5,55c <superpg_test+0x15a>
    err("sbrk(N) failed");
  }
  sbrk_new_break = sbrk(0);
 468:	4501                	li	a0,0
 46a:	5fc000ef          	jal	a66 <sbrk>
 46e:	89aa                	mv	s3,a0
  printf("superpg_test: sbrk(N) successful. Old break 0x%p, new break is 0x%p\n", sbrk_old_break, sbrk_new_break);
 470:	862a                	mv	a2,a0
 472:	85ca                	mv	a1,s2
 474:	00001517          	auipc	a0,0x1
 478:	26450513          	addi	a0,a0,612 # 16d8 <malloc+0x7e6>
 47c:	1c3000ef          	jal	e3e <printf>

  // Find the first 2MB-aligned VA within the newly sbrk'd region [sbrk_old_break, sbrk_new_break)
  uint64 va_to_check = SUPERPGROUNDUP((uint64)sbrk_old_break); 
 480:	002007b7          	lui	a5,0x200
 484:	fff78493          	addi	s1,a5,-1 # 1fffff <base+0x1fcfdf>
 488:	94ca                	add	s1,s1,s2
 48a:	ffe00737          	lui	a4,0xffe00
 48e:	8cf9                	and	s1,s1,a4

  if (va_to_check + SUPERPGSIZE <= (uint64)sbrk_new_break) {
 490:	00f48a33          	add	s4,s1,a5
 494:	8ace                	mv	s5,s3
 496:	0d49e963          	bltu	s3,s4,568 <superpg_test+0x166>
     printf("superpg_test: Will check for superpage at VA 0x%lx (within sbrk'd region 0x%p-0x%p).\n",
 49a:	86ce                	mv	a3,s3
 49c:	864a                	mv	a2,s2
 49e:	85a6                	mv	a1,s1
 4a0:	00001517          	auipc	a0,0x1
 4a4:	28050513          	addi	a0,a0,640 # 1720 <malloc+0x82e>
 4a8:	197000ef          	jal	e3e <printf>
            va_to_check, sbrk_old_break, sbrk_new_break);
     supercheck(va_to_check);
 4ac:	8526                	mv	a0,s1
 4ae:	dc3ff0ef          	jal	270 <supercheck>
            sbrk_old_break, sbrk_new_break, va_to_check);
     // This might indicate an issue if SBRK_SIZE_FOR_SUPERPG_TEST was large enough
     // or could be normal if sbrk_old_break was already close to a 2MB boundary.
  }
  
  printf("pgtbltest: Current process pagetable (after sbrk(N) and supercheck):\n");
 4b2:	00001517          	auipc	a0,0x1
 4b6:	35e50513          	addi	a0,a0,862 # 1810 <malloc+0x91e>
 4ba:	185000ef          	jal	e3e <printf>
  print_kpgtbl_using_syscall();
 4be:	d61ff0ef          	jal	21e <print_kpgtbl_using_syscall>

  // Fork test
  printf("superpg_test: Fork test starting.\n");
 4c2:	00001517          	auipc	a0,0x1
 4c6:	39650513          	addi	a0,a0,918 # 1858 <malloc+0x966>
 4ca:	175000ef          	jal	e3e <printf>
  pid = fork();
 4ce:	508000ef          	jal	9d6 <fork>
 4d2:	892a                	mv	s2,a0
  if(pid < 0) {
 4d4:	0a054463          	bltz	a0,57c <superpg_test+0x17a>
    err("fork failed");
  } else if (pid == 0) { // Child process
 4d8:	c945                	beqz	a0,588 <superpg_test+0x186>
    // }
    printf("superpg_test child: OK. Exiting.\n");
    exit(0);
  } else { // Parent process
    int child_status;
    wait(&child_status);
 4da:	fbc40513          	addi	a0,s0,-68
 4de:	508000ef          	jal	9e6 <wait>
    if(child_status != 0) {
 4e2:	fbc42603          	lw	a2,-68(s0)
 4e6:	0e061163          	bnez	a2,5c8 <superpg_test+0x1c6>
        printf("superpg_test: Child process (pid %d) failed with status %d.\n", pid, child_status);
        err("child process failed during fork test");
    }
    printf("superpg_test parent: Child (pid %d) exited. Verifying parent's memory (if child modified).\n", pid);
 4ea:	85ca                	mv	a1,s2
 4ec:	00001517          	auipc	a0,0x1
 4f0:	48c50513          	addi	a0,a0,1164 # 1978 <malloc+0xa86>
 4f4:	14b000ef          	jal	e3e <printf>
    // if (va_to_check + SUPERPGSIZE <= (uint64)sbrk_new_break && *parent_ptr_to_check == 'C') {
    //    err("parent's memory affected by child (COW issue or shared mapping)");
    // }
  }
  
  printf("superpg_test: sbrk(-SBRK_SIZE_FOR_SUPERPG_TEST) to free the allocated memory.\n");
 4f8:	00001517          	auipc	a0,0x1
 4fc:	4e050513          	addi	a0,a0,1248 # 19d8 <malloc+0xae6>
 500:	13f000ef          	jal	e3e <printf>
  if (sbrk(-SBRK_SIZE_FOR_SUPERPG_TEST) == (char*)-1) { // sbrk returns -1 on error
 504:	ff800537          	lui	a0,0xff800
 508:	55e000ef          	jal	a66 <sbrk>
 50c:	57fd                	li	a5,-1
 50e:	0cf50a63          	beq	a0,a5,5e2 <superpg_test+0x1e0>
       err("sbrk(-N) failed to free memory");
  }
   printf("superpg_test: Memory freed. New break is 0x%p\n", sbrk(0));
 512:	4501                	li	a0,0
 514:	552000ef          	jal	a66 <sbrk>
 518:	85aa                	mv	a1,a0
 51a:	00001517          	auipc	a0,0x1
 51e:	52e50513          	addi	a0,a0,1326 # 1a48 <malloc+0xb56>
 522:	11d000ef          	jal	e3e <printf>
  
  printf("pgtbltest: Current process pagetable (after sbrk(-N)):\n");
 526:	00001517          	auipc	a0,0x1
 52a:	55250513          	addi	a0,a0,1362 # 1a78 <malloc+0xb86>
 52e:	111000ef          	jal	e3e <printf>
  print_kpgtbl_using_syscall();
 532:	cedff0ef          	jal	21e <print_kpgtbl_using_syscall>

  printf("%s: OK\n", testname);
 536:	00003597          	auipc	a1,0x3
 53a:	aca5b583          	ld	a1,-1334(a1) # 3000 <testname>
 53e:	00001517          	auipc	a0,0x1
 542:	ba250513          	addi	a0,a0,-1118 # 10e0 <malloc+0x1ee>
 546:	0f9000ef          	jal	e3e <printf>
 54a:	60a6                	ld	ra,72(sp)
 54c:	6406                	ld	s0,64(sp)
 54e:	74e2                	ld	s1,56(sp)
 550:	7942                	ld	s2,48(sp)
 552:	79a2                	ld	s3,40(sp)
 554:	7a02                	ld	s4,32(sp)
 556:	6ae2                	ld	s5,24(sp)
 558:	6161                	addi	sp,sp,80
 55a:	8082                	ret
    err("sbrk(N) failed");
 55c:	00001517          	auipc	a0,0x1
 560:	16c50513          	addi	a0,a0,364 # 16c8 <malloc+0x7d6>
 564:	a9dff0ef          	jal	0 <err>
     printf("superpg_test: WARN - sbrk'd region (0x%p to 0x%p) does not contain a full 2MB aligned block starting at or after 0x%lx to check with supercheck.\n",
 568:	86a6                	mv	a3,s1
 56a:	864e                	mv	a2,s3
 56c:	85ca                	mv	a1,s2
 56e:	00001517          	auipc	a0,0x1
 572:	20a50513          	addi	a0,a0,522 # 1778 <malloc+0x886>
 576:	0c9000ef          	jal	e3e <printf>
 57a:	bf25                	j	4b2 <superpg_test+0xb0>
    err("fork failed");
 57c:	00001517          	auipc	a0,0x1
 580:	bac50513          	addi	a0,a0,-1108 # 1128 <malloc+0x236>
 584:	a7dff0ef          	jal	0 <err>
    testname = "superpg_test_child";
 588:	00001797          	auipc	a5,0x1
 58c:	2f878793          	addi	a5,a5,760 # 1880 <malloc+0x98e>
 590:	00003717          	auipc	a4,0x3
 594:	a6f73823          	sd	a5,-1424(a4) # 3000 <testname>
    printf("superpg_test child (pid %d): Verifying inherited/copied superpage region.\n", getpid());
 598:	4c6000ef          	jal	a5e <getpid>
 59c:	85aa                	mv	a1,a0
 59e:	00001517          	auipc	a0,0x1
 5a2:	2fa50513          	addi	a0,a0,762 # 1898 <malloc+0x9a6>
 5a6:	099000ef          	jal	e3e <printf>
    if (va_to_check + SUPERPGSIZE <= (uint64)sbrk_new_break) { // Check same region as parent
 5aa:	014afb63          	bgeu	s5,s4,5c0 <superpg_test+0x1be>
    printf("superpg_test child: OK. Exiting.\n");
 5ae:	00001517          	auipc	a0,0x1
 5b2:	33a50513          	addi	a0,a0,826 # 18e8 <malloc+0x9f6>
 5b6:	089000ef          	jal	e3e <printf>
    exit(0);
 5ba:	4501                	li	a0,0
 5bc:	422000ef          	jal	9de <exit>
        supercheck(va_to_check); 
 5c0:	8526                	mv	a0,s1
 5c2:	cafff0ef          	jal	270 <supercheck>
 5c6:	b7e5                	j	5ae <superpg_test+0x1ac>
        printf("superpg_test: Child process (pid %d) failed with status %d.\n", pid, child_status);
 5c8:	85ca                	mv	a1,s2
 5ca:	00001517          	auipc	a0,0x1
 5ce:	34650513          	addi	a0,a0,838 # 1910 <malloc+0xa1e>
 5d2:	06d000ef          	jal	e3e <printf>
        err("child process failed during fork test");
 5d6:	00001517          	auipc	a0,0x1
 5da:	37a50513          	addi	a0,a0,890 # 1950 <malloc+0xa5e>
 5de:	a23ff0ef          	jal	0 <err>
       err("sbrk(-N) failed to free memory");
 5e2:	00001517          	auipc	a0,0x1
 5e6:	44650513          	addi	a0,a0,1094 # 1a28 <malloc+0xb36>
 5ea:	a17ff0ef          	jal	0 <err>

00000000000005ee <main>:
{
 5ee:	1141                	addi	sp,sp,-16
 5f0:	e406                	sd	ra,8(sp)
 5f2:	e022                	sd	s0,0(sp)
 5f4:	0800                	addi	s0,sp,16
  printf("pgtbltest: Starting all tests...\n\n");
 5f6:	00001517          	auipc	a0,0x1
 5fa:	4ba50513          	addi	a0,a0,1210 # 1ab0 <malloc+0xbbe>
 5fe:	041000ef          	jal	e3e <printf>
  print_pgtbl_using_pgpte();
 602:	a77ff0ef          	jal	78 <print_pgtbl_using_pgpte>
  printf("\n");
 606:	00001517          	auipc	a0,0x1
 60a:	4d250513          	addi	a0,a0,1234 # 1ad8 <malloc+0xbe6>
 60e:	031000ef          	jal	e3e <printf>
  ugetpid_test();
 612:	b19ff0ef          	jal	12a <ugetpid_test>
  printf("\n");
 616:	00001517          	auipc	a0,0x1
 61a:	4c250513          	addi	a0,a0,1218 # 1ad8 <malloc+0xbe6>
 61e:	021000ef          	jal	e3e <printf>
  superpg_test();
 622:	de1ff0ef          	jal	402 <superpg_test>
  printf("\n");
 626:	00001517          	auipc	a0,0x1
 62a:	4b250513          	addi	a0,a0,1202 # 1ad8 <malloc+0xbe6>
 62e:	011000ef          	jal	e3e <printf>
  printf("pgtbltest: all tests (that were run) succeeded\n");
 632:	00001517          	auipc	a0,0x1
 636:	4ae50513          	addi	a0,a0,1198 # 1ae0 <malloc+0xbee>
 63a:	005000ef          	jal	e3e <printf>
  exit(0);
 63e:	4501                	li	a0,0
 640:	39e000ef          	jal	9de <exit>

0000000000000644 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 644:	1141                	addi	sp,sp,-16
 646:	e406                	sd	ra,8(sp)
 648:	e022                	sd	s0,0(sp)
 64a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 64c:	fa3ff0ef          	jal	5ee <main>
  exit(0);
 650:	4501                	li	a0,0
 652:	38c000ef          	jal	9de <exit>

0000000000000656 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 656:	1141                	addi	sp,sp,-16
 658:	e422                	sd	s0,8(sp)
 65a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 65c:	87aa                	mv	a5,a0
 65e:	0585                	addi	a1,a1,1
 660:	0785                	addi	a5,a5,1
 662:	fff5c703          	lbu	a4,-1(a1)
 666:	fee78fa3          	sb	a4,-1(a5)
 66a:	fb75                	bnez	a4,65e <strcpy+0x8>
    ;
  return os;
}
 66c:	6422                	ld	s0,8(sp)
 66e:	0141                	addi	sp,sp,16
 670:	8082                	ret

0000000000000672 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 672:	1141                	addi	sp,sp,-16
 674:	e422                	sd	s0,8(sp)
 676:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 678:	00054783          	lbu	a5,0(a0)
 67c:	cb91                	beqz	a5,690 <strcmp+0x1e>
 67e:	0005c703          	lbu	a4,0(a1)
 682:	00f71763          	bne	a4,a5,690 <strcmp+0x1e>
    p++, q++;
 686:	0505                	addi	a0,a0,1
 688:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 68a:	00054783          	lbu	a5,0(a0)
 68e:	fbe5                	bnez	a5,67e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 690:	0005c503          	lbu	a0,0(a1)
}
 694:	40a7853b          	subw	a0,a5,a0
 698:	6422                	ld	s0,8(sp)
 69a:	0141                	addi	sp,sp,16
 69c:	8082                	ret

000000000000069e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 69e:	1141                	addi	sp,sp,-16
 6a0:	e422                	sd	s0,8(sp)
 6a2:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q) {
 6a4:	ce11                	beqz	a2,6c0 <strncmp+0x22>
 6a6:	00054783          	lbu	a5,0(a0)
 6aa:	cf89                	beqz	a5,6c4 <strncmp+0x26>
 6ac:	0005c703          	lbu	a4,0(a1)
 6b0:	00f71a63          	bne	a4,a5,6c4 <strncmp+0x26>
    n--;
 6b4:	367d                	addiw	a2,a2,-1 # fff <malloc+0x10d>
    p++;
 6b6:	0505                	addi	a0,a0,1
    q++;
 6b8:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q) {
 6ba:	f675                	bnez	a2,6a6 <strncmp+0x8>
  }
  if(n == 0)
    return 0;
 6bc:	4501                	li	a0,0
 6be:	a801                	j	6ce <strncmp+0x30>
 6c0:	4501                	li	a0,0
 6c2:	a031                	j	6ce <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
 6c4:	00054503          	lbu	a0,0(a0)
 6c8:	0005c783          	lbu	a5,0(a1)
 6cc:	9d1d                	subw	a0,a0,a5
}
 6ce:	6422                	ld	s0,8(sp)
 6d0:	0141                	addi	sp,sp,16
 6d2:	8082                	ret

00000000000006d4 <strlen>:

uint
strlen(const char *s)
{
 6d4:	1141                	addi	sp,sp,-16
 6d6:	e422                	sd	s0,8(sp)
 6d8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 6da:	00054783          	lbu	a5,0(a0)
 6de:	cf91                	beqz	a5,6fa <strlen+0x26>
 6e0:	0505                	addi	a0,a0,1
 6e2:	87aa                	mv	a5,a0
 6e4:	86be                	mv	a3,a5
 6e6:	0785                	addi	a5,a5,1
 6e8:	fff7c703          	lbu	a4,-1(a5)
 6ec:	ff65                	bnez	a4,6e4 <strlen+0x10>
 6ee:	40a6853b          	subw	a0,a3,a0
 6f2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 6f4:	6422                	ld	s0,8(sp)
 6f6:	0141                	addi	sp,sp,16
 6f8:	8082                	ret
  for(n = 0; s[n]; n++)
 6fa:	4501                	li	a0,0
 6fc:	bfe5                	j	6f4 <strlen+0x20>

00000000000006fe <memset>:

void*
memset(void *dst, int c, uint n)
{
 6fe:	1141                	addi	sp,sp,-16
 700:	e422                	sd	s0,8(sp)
 702:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 704:	ca19                	beqz	a2,71a <memset+0x1c>
 706:	87aa                	mv	a5,a0
 708:	1602                	slli	a2,a2,0x20
 70a:	9201                	srli	a2,a2,0x20
 70c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 710:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 714:	0785                	addi	a5,a5,1
 716:	fee79de3          	bne	a5,a4,710 <memset+0x12>
  }
  return dst;
}
 71a:	6422                	ld	s0,8(sp)
 71c:	0141                	addi	sp,sp,16
 71e:	8082                	ret

0000000000000720 <strchr>:

char*
strchr(const char *s, char c)
{
 720:	1141                	addi	sp,sp,-16
 722:	e422                	sd	s0,8(sp)
 724:	0800                	addi	s0,sp,16
  for(; *s; s++)
 726:	00054783          	lbu	a5,0(a0)
 72a:	cb99                	beqz	a5,740 <strchr+0x20>
    if(*s == c)
 72c:	00f58763          	beq	a1,a5,73a <strchr+0x1a>
  for(; *s; s++)
 730:	0505                	addi	a0,a0,1
 732:	00054783          	lbu	a5,0(a0)
 736:	fbfd                	bnez	a5,72c <strchr+0xc>
      return (char*)s;
  return 0;
 738:	4501                	li	a0,0
}
 73a:	6422                	ld	s0,8(sp)
 73c:	0141                	addi	sp,sp,16
 73e:	8082                	ret
  return 0;
 740:	4501                	li	a0,0
 742:	bfe5                	j	73a <strchr+0x1a>

0000000000000744 <gets>:

char*
gets(char *buf, int max)
{
 744:	711d                	addi	sp,sp,-96
 746:	ec86                	sd	ra,88(sp)
 748:	e8a2                	sd	s0,80(sp)
 74a:	e4a6                	sd	s1,72(sp)
 74c:	e0ca                	sd	s2,64(sp)
 74e:	fc4e                	sd	s3,56(sp)
 750:	f852                	sd	s4,48(sp)
 752:	f456                	sd	s5,40(sp)
 754:	f05a                	sd	s6,32(sp)
 756:	ec5e                	sd	s7,24(sp)
 758:	1080                	addi	s0,sp,96
 75a:	8baa                	mv	s7,a0
 75c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 75e:	892a                	mv	s2,a0
 760:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 762:	4aa9                	li	s5,10
 764:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 766:	89a6                	mv	s3,s1
 768:	2485                	addiw	s1,s1,1
 76a:	0344d663          	bge	s1,s4,796 <gets+0x52>
    cc = read(0, &c, 1);
 76e:	4605                	li	a2,1
 770:	faf40593          	addi	a1,s0,-81
 774:	4501                	li	a0,0
 776:	280000ef          	jal	9f6 <read>
    if(cc < 1)
 77a:	00a05e63          	blez	a0,796 <gets+0x52>
    buf[i++] = c;
 77e:	faf44783          	lbu	a5,-81(s0)
 782:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 786:	01578763          	beq	a5,s5,794 <gets+0x50>
 78a:	0905                	addi	s2,s2,1
 78c:	fd679de3          	bne	a5,s6,766 <gets+0x22>
    buf[i++] = c;
 790:	89a6                	mv	s3,s1
 792:	a011                	j	796 <gets+0x52>
 794:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 796:	99de                	add	s3,s3,s7
 798:	00098023          	sb	zero,0(s3)
  return buf;
}
 79c:	855e                	mv	a0,s7
 79e:	60e6                	ld	ra,88(sp)
 7a0:	6446                	ld	s0,80(sp)
 7a2:	64a6                	ld	s1,72(sp)
 7a4:	6906                	ld	s2,64(sp)
 7a6:	79e2                	ld	s3,56(sp)
 7a8:	7a42                	ld	s4,48(sp)
 7aa:	7aa2                	ld	s5,40(sp)
 7ac:	7b02                	ld	s6,32(sp)
 7ae:	6be2                	ld	s7,24(sp)
 7b0:	6125                	addi	sp,sp,96
 7b2:	8082                	ret

00000000000007b4 <stat>:

int
stat(const char *n, struct stat *st)
{
 7b4:	1101                	addi	sp,sp,-32
 7b6:	ec06                	sd	ra,24(sp)
 7b8:	e822                	sd	s0,16(sp)
 7ba:	e04a                	sd	s2,0(sp)
 7bc:	1000                	addi	s0,sp,32
 7be:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 7c0:	4581                	li	a1,0
 7c2:	25c000ef          	jal	a1e <open>
  if(fd < 0)
 7c6:	02054263          	bltz	a0,7ea <stat+0x36>
 7ca:	e426                	sd	s1,8(sp)
 7cc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 7ce:	85ca                	mv	a1,s2
 7d0:	266000ef          	jal	a36 <fstat>
 7d4:	892a                	mv	s2,a0
  close(fd);
 7d6:	8526                	mv	a0,s1
 7d8:	22e000ef          	jal	a06 <close>
  return r;
 7dc:	64a2                	ld	s1,8(sp)
}
 7de:	854a                	mv	a0,s2
 7e0:	60e2                	ld	ra,24(sp)
 7e2:	6442                	ld	s0,16(sp)
 7e4:	6902                	ld	s2,0(sp)
 7e6:	6105                	addi	sp,sp,32
 7e8:	8082                	ret
    return -1;
 7ea:	597d                	li	s2,-1
 7ec:	bfcd                	j	7de <stat+0x2a>

00000000000007ee <atoi>:

int
atoi(const char *s)
{
 7ee:	1141                	addi	sp,sp,-16
 7f0:	e422                	sd	s0,8(sp)
 7f2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 7f4:	00054683          	lbu	a3,0(a0)
 7f8:	fd06879b          	addiw	a5,a3,-48 # 1fffd0 <base+0x1fcfb0>
 7fc:	0ff7f793          	zext.b	a5,a5
 800:	4625                	li	a2,9
 802:	02f66863          	bltu	a2,a5,832 <atoi+0x44>
 806:	872a                	mv	a4,a0
  n = 0;
 808:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 80a:	0705                	addi	a4,a4,1
 80c:	0025179b          	slliw	a5,a0,0x2
 810:	9fa9                	addw	a5,a5,a0
 812:	0017979b          	slliw	a5,a5,0x1
 816:	9fb5                	addw	a5,a5,a3
 818:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 81c:	00074683          	lbu	a3,0(a4)
 820:	fd06879b          	addiw	a5,a3,-48
 824:	0ff7f793          	zext.b	a5,a5
 828:	fef671e3          	bgeu	a2,a5,80a <atoi+0x1c>
  return n;
}
 82c:	6422                	ld	s0,8(sp)
 82e:	0141                	addi	sp,sp,16
 830:	8082                	ret
  n = 0;
 832:	4501                	li	a0,0
 834:	bfe5                	j	82c <atoi+0x3e>

0000000000000836 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 836:	1141                	addi	sp,sp,-16
 838:	e422                	sd	s0,8(sp)
 83a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 83c:	02b57463          	bgeu	a0,a1,864 <memmove+0x2e>
    while(n-- > 0)
 840:	00c05f63          	blez	a2,85e <memmove+0x28>
 844:	1602                	slli	a2,a2,0x20
 846:	9201                	srli	a2,a2,0x20
 848:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 84c:	872a                	mv	a4,a0
      *dst++ = *src++;
 84e:	0585                	addi	a1,a1,1
 850:	0705                	addi	a4,a4,1
 852:	fff5c683          	lbu	a3,-1(a1)
 856:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 85a:	fef71ae3          	bne	a4,a5,84e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 85e:	6422                	ld	s0,8(sp)
 860:	0141                	addi	sp,sp,16
 862:	8082                	ret
    dst += n;
 864:	00c50733          	add	a4,a0,a2
    src += n;
 868:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 86a:	fec05ae3          	blez	a2,85e <memmove+0x28>
 86e:	fff6079b          	addiw	a5,a2,-1
 872:	1782                	slli	a5,a5,0x20
 874:	9381                	srli	a5,a5,0x20
 876:	fff7c793          	not	a5,a5
 87a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 87c:	15fd                	addi	a1,a1,-1
 87e:	177d                	addi	a4,a4,-1
 880:	0005c683          	lbu	a3,0(a1)
 884:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 888:	fee79ae3          	bne	a5,a4,87c <memmove+0x46>
 88c:	bfc9                	j	85e <memmove+0x28>

000000000000088e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 88e:	1141                	addi	sp,sp,-16
 890:	e422                	sd	s0,8(sp)
 892:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 894:	ca05                	beqz	a2,8c4 <memcmp+0x36>
 896:	fff6069b          	addiw	a3,a2,-1
 89a:	1682                	slli	a3,a3,0x20
 89c:	9281                	srli	a3,a3,0x20
 89e:	0685                	addi	a3,a3,1
 8a0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 8a2:	00054783          	lbu	a5,0(a0)
 8a6:	0005c703          	lbu	a4,0(a1)
 8aa:	00e79863          	bne	a5,a4,8ba <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 8ae:	0505                	addi	a0,a0,1
    p2++;
 8b0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 8b2:	fed518e3          	bne	a0,a3,8a2 <memcmp+0x14>
  }
  return 0;
 8b6:	4501                	li	a0,0
 8b8:	a019                	j	8be <memcmp+0x30>
      return *p1 - *p2;
 8ba:	40e7853b          	subw	a0,a5,a4
}
 8be:	6422                	ld	s0,8(sp)
 8c0:	0141                	addi	sp,sp,16
 8c2:	8082                	ret
  return 0;
 8c4:	4501                	li	a0,0
 8c6:	bfe5                	j	8be <memcmp+0x30>

00000000000008c8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 8c8:	1141                	addi	sp,sp,-16
 8ca:	e406                	sd	ra,8(sp)
 8cc:	e022                	sd	s0,0(sp)
 8ce:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 8d0:	f67ff0ef          	jal	836 <memmove>
}
 8d4:	60a2                	ld	ra,8(sp)
 8d6:	6402                	ld	s0,0(sp)
 8d8:	0141                	addi	sp,sp,16
 8da:	8082                	ret

00000000000008dc <simplesort>:

void
simplesort(void *base, uint nmemb, uint size, int (*compar)(const void *, const void *))
{
 8dc:	7119                	addi	sp,sp,-128
 8de:	fc86                	sd	ra,120(sp)
 8e0:	f8a2                	sd	s0,112(sp)
 8e2:	0100                	addi	s0,sp,128
 8e4:	f8b43423          	sd	a1,-120(s0)
  char *arr = (char *)base; // Treat array as char array for byte-level manipulation
  char *temp;               // Temporary storage for an element

  if (nmemb <= 1 || size == 0) {
 8e8:	4785                	li	a5,1
 8ea:	00b7fc63          	bgeu	a5,a1,902 <simplesort+0x26>
 8ee:	e8d2                	sd	s4,80(sp)
 8f0:	e4d6                	sd	s5,72(sp)
 8f2:	f466                	sd	s9,40(sp)
 8f4:	8aaa                	mv	s5,a0
 8f6:	8a32                	mv	s4,a2
 8f8:	8cb6                	mv	s9,a3
 8fa:	ea01                	bnez	a2,90a <simplesort+0x2e>
 8fc:	6a46                	ld	s4,80(sp)
 8fe:	6aa6                	ld	s5,72(sp)
 900:	7ca2                	ld	s9,40(sp)
    // Place temp at its correct position
    memmove(arr + j * size, temp, size);
  }

  free(temp); // Free temporary space
 902:	70e6                	ld	ra,120(sp)
 904:	7446                	ld	s0,112(sp)
 906:	6109                	addi	sp,sp,128
 908:	8082                	ret
 90a:	fc5e                	sd	s7,56(sp)
 90c:	f862                	sd	s8,48(sp)
 90e:	f06a                	sd	s10,32(sp)
 910:	ec6e                	sd	s11,24(sp)
  temp = malloc(size); // Allocate temporary space for one element
 912:	8532                	mv	a0,a2
 914:	5de000ef          	jal	ef2 <malloc>
 918:	8baa                	mv	s7,a0
  if (temp == 0) {
 91a:	4d81                	li	s11,0
  for (uint i = 1; i < nmemb; i++) {
 91c:	4d05                	li	s10,1
    memmove(temp, arr + i * size, size);
 91e:	000a0c1b          	sext.w	s8,s4
  if (temp == 0) {
 922:	c511                	beqz	a0,92e <simplesort+0x52>
 924:	f4a6                	sd	s1,104(sp)
 926:	f0ca                	sd	s2,96(sp)
 928:	ecce                	sd	s3,88(sp)
 92a:	e0da                	sd	s6,64(sp)
 92c:	a82d                	j	966 <simplesort+0x8a>
    printf("simplesort: malloc failed, cannot sort\n");
 92e:	00001517          	auipc	a0,0x1
 932:	1ea50513          	addi	a0,a0,490 # 1b18 <malloc+0xc26>
 936:	508000ef          	jal	e3e <printf>
    return;
 93a:	6a46                	ld	s4,80(sp)
 93c:	6aa6                	ld	s5,72(sp)
 93e:	7be2                	ld	s7,56(sp)
 940:	7c42                	ld	s8,48(sp)
 942:	7ca2                	ld	s9,40(sp)
 944:	7d02                	ld	s10,32(sp)
 946:	6de2                	ld	s11,24(sp)
 948:	bf6d                	j	902 <simplesort+0x26>
    memmove(arr + j * size, temp, size);
 94a:	036a053b          	mulw	a0,s4,s6
 94e:	1502                	slli	a0,a0,0x20
 950:	9101                	srli	a0,a0,0x20
 952:	8662                	mv	a2,s8
 954:	85de                	mv	a1,s7
 956:	9556                	add	a0,a0,s5
 958:	edfff0ef          	jal	836 <memmove>
  for (uint i = 1; i < nmemb; i++) {
 95c:	2d05                	addiw	s10,s10,1
 95e:	f8843783          	ld	a5,-120(s0)
 962:	05a78b63          	beq	a5,s10,9b8 <simplesort+0xdc>
    memmove(temp, arr + i * size, size);
 966:	000d899b          	sext.w	s3,s11
 96a:	01ba05bb          	addw	a1,s4,s11
 96e:	00058d9b          	sext.w	s11,a1
 972:	1582                	slli	a1,a1,0x20
 974:	9181                	srli	a1,a1,0x20
 976:	8662                	mv	a2,s8
 978:	95d6                	add	a1,a1,s5
 97a:	855e                	mv	a0,s7
 97c:	ebbff0ef          	jal	836 <memmove>
    uint j = i;
 980:	896a                	mv	s2,s10
 982:	00090b1b          	sext.w	s6,s2
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 986:	397d                	addiw	s2,s2,-1
 988:	02099493          	slli	s1,s3,0x20
 98c:	9081                	srli	s1,s1,0x20
 98e:	94d6                	add	s1,s1,s5
 990:	85de                	mv	a1,s7
 992:	8526                	mv	a0,s1
 994:	9c82                	jalr	s9
 996:	faa05ae3          	blez	a0,94a <simplesort+0x6e>
      memmove(arr + j * size, arr + (j - 1) * size, size); // Shift element
 99a:	0149853b          	addw	a0,s3,s4
 99e:	1502                	slli	a0,a0,0x20
 9a0:	9101                	srli	a0,a0,0x20
 9a2:	8662                	mv	a2,s8
 9a4:	85a6                	mv	a1,s1
 9a6:	9556                	add	a0,a0,s5
 9a8:	e8fff0ef          	jal	836 <memmove>
    while (j > 0 && compar(arr + (j - 1) * size, temp) > 0) {
 9ac:	414989bb          	subw	s3,s3,s4
 9b0:	fc0919e3          	bnez	s2,982 <simplesort+0xa6>
 9b4:	8b4a                	mv	s6,s2
 9b6:	bf51                	j	94a <simplesort+0x6e>
  free(temp); // Free temporary space
 9b8:	855e                	mv	a0,s7
 9ba:	4b6000ef          	jal	e70 <free>
 9be:	74a6                	ld	s1,104(sp)
 9c0:	7906                	ld	s2,96(sp)
 9c2:	69e6                	ld	s3,88(sp)
 9c4:	6a46                	ld	s4,80(sp)
 9c6:	6aa6                	ld	s5,72(sp)
 9c8:	6b06                	ld	s6,64(sp)
 9ca:	7be2                	ld	s7,56(sp)
 9cc:	7c42                	ld	s8,48(sp)
 9ce:	7ca2                	ld	s9,40(sp)
 9d0:	7d02                	ld	s10,32(sp)
 9d2:	6de2                	ld	s11,24(sp)
 9d4:	b73d                	j	902 <simplesort+0x26>

00000000000009d6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 9d6:	4885                	li	a7,1
 ecall
 9d8:	00000073          	ecall
 ret
 9dc:	8082                	ret

00000000000009de <exit>:
.global exit
exit:
 li a7, SYS_exit
 9de:	4889                	li	a7,2
 ecall
 9e0:	00000073          	ecall
 ret
 9e4:	8082                	ret

00000000000009e6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 9e6:	488d                	li	a7,3
 ecall
 9e8:	00000073          	ecall
 ret
 9ec:	8082                	ret

00000000000009ee <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 9ee:	4891                	li	a7,4
 ecall
 9f0:	00000073          	ecall
 ret
 9f4:	8082                	ret

00000000000009f6 <read>:
.global read
read:
 li a7, SYS_read
 9f6:	4895                	li	a7,5
 ecall
 9f8:	00000073          	ecall
 ret
 9fc:	8082                	ret

00000000000009fe <write>:
.global write
write:
 li a7, SYS_write
 9fe:	48c1                	li	a7,16
 ecall
 a00:	00000073          	ecall
 ret
 a04:	8082                	ret

0000000000000a06 <close>:
.global close
close:
 li a7, SYS_close
 a06:	48d5                	li	a7,21
 ecall
 a08:	00000073          	ecall
 ret
 a0c:	8082                	ret

0000000000000a0e <kill>:
.global kill
kill:
 li a7, SYS_kill
 a0e:	4899                	li	a7,6
 ecall
 a10:	00000073          	ecall
 ret
 a14:	8082                	ret

0000000000000a16 <exec>:
.global exec
exec:
 li a7, SYS_exec
 a16:	489d                	li	a7,7
 ecall
 a18:	00000073          	ecall
 ret
 a1c:	8082                	ret

0000000000000a1e <open>:
.global open
open:
 li a7, SYS_open
 a1e:	48bd                	li	a7,15
 ecall
 a20:	00000073          	ecall
 ret
 a24:	8082                	ret

0000000000000a26 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 a26:	48c5                	li	a7,17
 ecall
 a28:	00000073          	ecall
 ret
 a2c:	8082                	ret

0000000000000a2e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 a2e:	48c9                	li	a7,18
 ecall
 a30:	00000073          	ecall
 ret
 a34:	8082                	ret

0000000000000a36 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 a36:	48a1                	li	a7,8
 ecall
 a38:	00000073          	ecall
 ret
 a3c:	8082                	ret

0000000000000a3e <link>:
.global link
link:
 li a7, SYS_link
 a3e:	48cd                	li	a7,19
 ecall
 a40:	00000073          	ecall
 ret
 a44:	8082                	ret

0000000000000a46 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 a46:	48d1                	li	a7,20
 ecall
 a48:	00000073          	ecall
 ret
 a4c:	8082                	ret

0000000000000a4e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 a4e:	48a5                	li	a7,9
 ecall
 a50:	00000073          	ecall
 ret
 a54:	8082                	ret

0000000000000a56 <dup>:
.global dup
dup:
 li a7, SYS_dup
 a56:	48a9                	li	a7,10
 ecall
 a58:	00000073          	ecall
 ret
 a5c:	8082                	ret

0000000000000a5e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 a5e:	48ad                	li	a7,11
 ecall
 a60:	00000073          	ecall
 ret
 a64:	8082                	ret

0000000000000a66 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 a66:	48b1                	li	a7,12
 ecall
 a68:	00000073          	ecall
 ret
 a6c:	8082                	ret

0000000000000a6e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 a6e:	48b5                	li	a7,13
 ecall
 a70:	00000073          	ecall
 ret
 a74:	8082                	ret

0000000000000a76 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 a76:	48b9                	li	a7,14
 ecall
 a78:	00000073          	ecall
 ret
 a7c:	8082                	ret

0000000000000a7e <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 a7e:	48dd                	li	a7,23
 ecall
 a80:	00000073          	ecall
 ret
 a84:	8082                	ret

0000000000000a86 <statistics>:
.global statistics
statistics:
 li a7, SYS_statistics
 a86:	48e1                	li	a7,24
 ecall
 a88:	00000073          	ecall
 ret
 a8c:	8082                	ret

0000000000000a8e <reset_stats>:
.global reset_stats
reset_stats:
 li a7, SYS_reset_stats
 a8e:	48e5                	li	a7,25
 ecall
 a90:	00000073          	ecall
 ret
 a94:	8082                	ret

0000000000000a96 <resetlockstats>:
.global resetlockstats
resetlockstats:
 li a7, SYS_resetlockstats
 a96:	48e9                	li	a7,26
 ecall
 a98:	00000073          	ecall
 ret
 a9c:	8082                	ret

0000000000000a9e <getlockstats>:
.global getlockstats
getlockstats:
 li a7, SYS_getlockstats
 a9e:	48ed                	li	a7,27
 ecall
 aa0:	00000073          	ecall
 ret
 aa4:	8082                	ret

0000000000000aa6 <trace>:
.global trace
trace:
 li a7, SYS_trace
 aa6:	48d9                	li	a7,22
 ecall
 aa8:	00000073          	ecall
 ret
 aac:	8082                	ret

0000000000000aae <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 aae:	48f1                	li	a7,28
 ecall
 ab0:	00000073          	ecall
 ret
 ab4:	8082                	ret

0000000000000ab6 <ugetpid>:
.global ugetpid
ugetpid:
 li a7, SYS_ugetpid
 ab6:	48f5                	li	a7,29
 ecall
 ab8:	00000073          	ecall
 ret
 abc:	8082                	ret

0000000000000abe <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 abe:	48f9                	li	a7,30
 ecall
 ac0:	00000073          	ecall
 ret
 ac4:	8082                	ret

0000000000000ac6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 ac6:	1101                	addi	sp,sp,-32
 ac8:	ec06                	sd	ra,24(sp)
 aca:	e822                	sd	s0,16(sp)
 acc:	1000                	addi	s0,sp,32
 ace:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 ad2:	4605                	li	a2,1
 ad4:	fef40593          	addi	a1,s0,-17
 ad8:	f27ff0ef          	jal	9fe <write>
}
 adc:	60e2                	ld	ra,24(sp)
 ade:	6442                	ld	s0,16(sp)
 ae0:	6105                	addi	sp,sp,32
 ae2:	8082                	ret

0000000000000ae4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 ae4:	7139                	addi	sp,sp,-64
 ae6:	fc06                	sd	ra,56(sp)
 ae8:	f822                	sd	s0,48(sp)
 aea:	f426                	sd	s1,40(sp)
 aec:	0080                	addi	s0,sp,64
 aee:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 af0:	c299                	beqz	a3,af6 <printint+0x12>
 af2:	0805c963          	bltz	a1,b84 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 af6:	2581                	sext.w	a1,a1
  neg = 0;
 af8:	4881                	li	a7,0
 afa:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 afe:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 b00:	2601                	sext.w	a2,a2
 b02:	00001517          	auipc	a0,0x1
 b06:	04650513          	addi	a0,a0,70 # 1b48 <digits>
 b0a:	883a                	mv	a6,a4
 b0c:	2705                	addiw	a4,a4,1
 b0e:	02c5f7bb          	remuw	a5,a1,a2
 b12:	1782                	slli	a5,a5,0x20
 b14:	9381                	srli	a5,a5,0x20
 b16:	97aa                	add	a5,a5,a0
 b18:	0007c783          	lbu	a5,0(a5)
 b1c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 b20:	0005879b          	sext.w	a5,a1
 b24:	02c5d5bb          	divuw	a1,a1,a2
 b28:	0685                	addi	a3,a3,1
 b2a:	fec7f0e3          	bgeu	a5,a2,b0a <printint+0x26>
  if(neg)
 b2e:	00088c63          	beqz	a7,b46 <printint+0x62>
    buf[i++] = '-';
 b32:	fd070793          	addi	a5,a4,-48
 b36:	00878733          	add	a4,a5,s0
 b3a:	02d00793          	li	a5,45
 b3e:	fef70823          	sb	a5,-16(a4)
 b42:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 b46:	02e05a63          	blez	a4,b7a <printint+0x96>
 b4a:	f04a                	sd	s2,32(sp)
 b4c:	ec4e                	sd	s3,24(sp)
 b4e:	fc040793          	addi	a5,s0,-64
 b52:	00e78933          	add	s2,a5,a4
 b56:	fff78993          	addi	s3,a5,-1
 b5a:	99ba                	add	s3,s3,a4
 b5c:	377d                	addiw	a4,a4,-1
 b5e:	1702                	slli	a4,a4,0x20
 b60:	9301                	srli	a4,a4,0x20
 b62:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 b66:	fff94583          	lbu	a1,-1(s2)
 b6a:	8526                	mv	a0,s1
 b6c:	f5bff0ef          	jal	ac6 <putc>
  while(--i >= 0)
 b70:	197d                	addi	s2,s2,-1
 b72:	ff391ae3          	bne	s2,s3,b66 <printint+0x82>
 b76:	7902                	ld	s2,32(sp)
 b78:	69e2                	ld	s3,24(sp)
}
 b7a:	70e2                	ld	ra,56(sp)
 b7c:	7442                	ld	s0,48(sp)
 b7e:	74a2                	ld	s1,40(sp)
 b80:	6121                	addi	sp,sp,64
 b82:	8082                	ret
    x = -xx;
 b84:	40b005bb          	negw	a1,a1
    neg = 1;
 b88:	4885                	li	a7,1
    x = -xx;
 b8a:	bf85                	j	afa <printint+0x16>

0000000000000b8c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 b8c:	711d                	addi	sp,sp,-96
 b8e:	ec86                	sd	ra,88(sp)
 b90:	e8a2                	sd	s0,80(sp)
 b92:	e0ca                	sd	s2,64(sp)
 b94:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 b96:	0005c903          	lbu	s2,0(a1)
 b9a:	26090863          	beqz	s2,e0a <vprintf+0x27e>
 b9e:	e4a6                	sd	s1,72(sp)
 ba0:	fc4e                	sd	s3,56(sp)
 ba2:	f852                	sd	s4,48(sp)
 ba4:	f456                	sd	s5,40(sp)
 ba6:	f05a                	sd	s6,32(sp)
 ba8:	ec5e                	sd	s7,24(sp)
 baa:	e862                	sd	s8,16(sp)
 bac:	e466                	sd	s9,8(sp)
 bae:	8b2a                	mv	s6,a0
 bb0:	8a2e                	mv	s4,a1
 bb2:	8bb2                	mv	s7,a2
  state = 0;
 bb4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 bb6:	4481                	li	s1,0
 bb8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 bba:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 bbe:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 bc2:	06c00c93          	li	s9,108
 bc6:	a005                	j	be6 <vprintf+0x5a>
        putc(fd, c0);
 bc8:	85ca                	mv	a1,s2
 bca:	855a                	mv	a0,s6
 bcc:	efbff0ef          	jal	ac6 <putc>
 bd0:	a019                	j	bd6 <vprintf+0x4a>
    } else if(state == '%'){
 bd2:	03598263          	beq	s3,s5,bf6 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 bd6:	2485                	addiw	s1,s1,1
 bd8:	8726                	mv	a4,s1
 bda:	009a07b3          	add	a5,s4,s1
 bde:	0007c903          	lbu	s2,0(a5)
 be2:	20090c63          	beqz	s2,dfa <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 be6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 bea:	fe0994e3          	bnez	s3,bd2 <vprintf+0x46>
      if(c0 == '%'){
 bee:	fd579de3          	bne	a5,s5,bc8 <vprintf+0x3c>
        state = '%';
 bf2:	89be                	mv	s3,a5
 bf4:	b7cd                	j	bd6 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 bf6:	00ea06b3          	add	a3,s4,a4
 bfa:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 bfe:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 c00:	c681                	beqz	a3,c08 <vprintf+0x7c>
 c02:	9752                	add	a4,a4,s4
 c04:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 c08:	03878f63          	beq	a5,s8,c46 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 c0c:	05978963          	beq	a5,s9,c5e <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 c10:	07500713          	li	a4,117
 c14:	0ee78363          	beq	a5,a4,cfa <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 c18:	07800713          	li	a4,120
 c1c:	12e78563          	beq	a5,a4,d46 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 c20:	07000713          	li	a4,112
 c24:	14e78a63          	beq	a5,a4,d78 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 c28:	07300713          	li	a4,115
 c2c:	18e78a63          	beq	a5,a4,dc0 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 c30:	02500713          	li	a4,37
 c34:	04e79563          	bne	a5,a4,c7e <vprintf+0xf2>
        putc(fd, '%');
 c38:	02500593          	li	a1,37
 c3c:	855a                	mv	a0,s6
 c3e:	e89ff0ef          	jal	ac6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 c42:	4981                	li	s3,0
 c44:	bf49                	j	bd6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 c46:	008b8913          	addi	s2,s7,8
 c4a:	4685                	li	a3,1
 c4c:	4629                	li	a2,10
 c4e:	000ba583          	lw	a1,0(s7)
 c52:	855a                	mv	a0,s6
 c54:	e91ff0ef          	jal	ae4 <printint>
 c58:	8bca                	mv	s7,s2
      state = 0;
 c5a:	4981                	li	s3,0
 c5c:	bfad                	j	bd6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 c5e:	06400793          	li	a5,100
 c62:	02f68963          	beq	a3,a5,c94 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 c66:	06c00793          	li	a5,108
 c6a:	04f68263          	beq	a3,a5,cae <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 c6e:	07500793          	li	a5,117
 c72:	0af68063          	beq	a3,a5,d12 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 c76:	07800793          	li	a5,120
 c7a:	0ef68263          	beq	a3,a5,d5e <vprintf+0x1d2>
        putc(fd, '%');
 c7e:	02500593          	li	a1,37
 c82:	855a                	mv	a0,s6
 c84:	e43ff0ef          	jal	ac6 <putc>
        putc(fd, c0);
 c88:	85ca                	mv	a1,s2
 c8a:	855a                	mv	a0,s6
 c8c:	e3bff0ef          	jal	ac6 <putc>
      state = 0;
 c90:	4981                	li	s3,0
 c92:	b791                	j	bd6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 c94:	008b8913          	addi	s2,s7,8
 c98:	4685                	li	a3,1
 c9a:	4629                	li	a2,10
 c9c:	000ba583          	lw	a1,0(s7)
 ca0:	855a                	mv	a0,s6
 ca2:	e43ff0ef          	jal	ae4 <printint>
        i += 1;
 ca6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 ca8:	8bca                	mv	s7,s2
      state = 0;
 caa:	4981                	li	s3,0
        i += 1;
 cac:	b72d                	j	bd6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 cae:	06400793          	li	a5,100
 cb2:	02f60763          	beq	a2,a5,ce0 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 cb6:	07500793          	li	a5,117
 cba:	06f60963          	beq	a2,a5,d2c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 cbe:	07800793          	li	a5,120
 cc2:	faf61ee3          	bne	a2,a5,c7e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 cc6:	008b8913          	addi	s2,s7,8
 cca:	4681                	li	a3,0
 ccc:	4641                	li	a2,16
 cce:	000ba583          	lw	a1,0(s7)
 cd2:	855a                	mv	a0,s6
 cd4:	e11ff0ef          	jal	ae4 <printint>
        i += 2;
 cd8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 cda:	8bca                	mv	s7,s2
      state = 0;
 cdc:	4981                	li	s3,0
        i += 2;
 cde:	bde5                	j	bd6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 ce0:	008b8913          	addi	s2,s7,8
 ce4:	4685                	li	a3,1
 ce6:	4629                	li	a2,10
 ce8:	000ba583          	lw	a1,0(s7)
 cec:	855a                	mv	a0,s6
 cee:	df7ff0ef          	jal	ae4 <printint>
        i += 2;
 cf2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 cf4:	8bca                	mv	s7,s2
      state = 0;
 cf6:	4981                	li	s3,0
        i += 2;
 cf8:	bdf9                	j	bd6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 cfa:	008b8913          	addi	s2,s7,8
 cfe:	4681                	li	a3,0
 d00:	4629                	li	a2,10
 d02:	000ba583          	lw	a1,0(s7)
 d06:	855a                	mv	a0,s6
 d08:	dddff0ef          	jal	ae4 <printint>
 d0c:	8bca                	mv	s7,s2
      state = 0;
 d0e:	4981                	li	s3,0
 d10:	b5d9                	j	bd6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 d12:	008b8913          	addi	s2,s7,8
 d16:	4681                	li	a3,0
 d18:	4629                	li	a2,10
 d1a:	000ba583          	lw	a1,0(s7)
 d1e:	855a                	mv	a0,s6
 d20:	dc5ff0ef          	jal	ae4 <printint>
        i += 1;
 d24:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 d26:	8bca                	mv	s7,s2
      state = 0;
 d28:	4981                	li	s3,0
        i += 1;
 d2a:	b575                	j	bd6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 d2c:	008b8913          	addi	s2,s7,8
 d30:	4681                	li	a3,0
 d32:	4629                	li	a2,10
 d34:	000ba583          	lw	a1,0(s7)
 d38:	855a                	mv	a0,s6
 d3a:	dabff0ef          	jal	ae4 <printint>
        i += 2;
 d3e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 d40:	8bca                	mv	s7,s2
      state = 0;
 d42:	4981                	li	s3,0
        i += 2;
 d44:	bd49                	j	bd6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 d46:	008b8913          	addi	s2,s7,8
 d4a:	4681                	li	a3,0
 d4c:	4641                	li	a2,16
 d4e:	000ba583          	lw	a1,0(s7)
 d52:	855a                	mv	a0,s6
 d54:	d91ff0ef          	jal	ae4 <printint>
 d58:	8bca                	mv	s7,s2
      state = 0;
 d5a:	4981                	li	s3,0
 d5c:	bdad                	j	bd6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 d5e:	008b8913          	addi	s2,s7,8
 d62:	4681                	li	a3,0
 d64:	4641                	li	a2,16
 d66:	000ba583          	lw	a1,0(s7)
 d6a:	855a                	mv	a0,s6
 d6c:	d79ff0ef          	jal	ae4 <printint>
        i += 1;
 d70:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 d72:	8bca                	mv	s7,s2
      state = 0;
 d74:	4981                	li	s3,0
        i += 1;
 d76:	b585                	j	bd6 <vprintf+0x4a>
 d78:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 d7a:	008b8d13          	addi	s10,s7,8
 d7e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 d82:	03000593          	li	a1,48
 d86:	855a                	mv	a0,s6
 d88:	d3fff0ef          	jal	ac6 <putc>
  putc(fd, 'x');
 d8c:	07800593          	li	a1,120
 d90:	855a                	mv	a0,s6
 d92:	d35ff0ef          	jal	ac6 <putc>
 d96:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 d98:	00001b97          	auipc	s7,0x1
 d9c:	db0b8b93          	addi	s7,s7,-592 # 1b48 <digits>
 da0:	03c9d793          	srli	a5,s3,0x3c
 da4:	97de                	add	a5,a5,s7
 da6:	0007c583          	lbu	a1,0(a5)
 daa:	855a                	mv	a0,s6
 dac:	d1bff0ef          	jal	ac6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 db0:	0992                	slli	s3,s3,0x4
 db2:	397d                	addiw	s2,s2,-1
 db4:	fe0916e3          	bnez	s2,da0 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 db8:	8bea                	mv	s7,s10
      state = 0;
 dba:	4981                	li	s3,0
 dbc:	6d02                	ld	s10,0(sp)
 dbe:	bd21                	j	bd6 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 dc0:	008b8993          	addi	s3,s7,8
 dc4:	000bb903          	ld	s2,0(s7)
 dc8:	00090f63          	beqz	s2,de6 <vprintf+0x25a>
        for(; *s; s++)
 dcc:	00094583          	lbu	a1,0(s2)
 dd0:	c195                	beqz	a1,df4 <vprintf+0x268>
          putc(fd, *s);
 dd2:	855a                	mv	a0,s6
 dd4:	cf3ff0ef          	jal	ac6 <putc>
        for(; *s; s++)
 dd8:	0905                	addi	s2,s2,1
 dda:	00094583          	lbu	a1,0(s2)
 dde:	f9f5                	bnez	a1,dd2 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 de0:	8bce                	mv	s7,s3
      state = 0;
 de2:	4981                	li	s3,0
 de4:	bbcd                	j	bd6 <vprintf+0x4a>
          s = "(null)";
 de6:	00001917          	auipc	s2,0x1
 dea:	d5a90913          	addi	s2,s2,-678 # 1b40 <malloc+0xc4e>
        for(; *s; s++)
 dee:	02800593          	li	a1,40
 df2:	b7c5                	j	dd2 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 df4:	8bce                	mv	s7,s3
      state = 0;
 df6:	4981                	li	s3,0
 df8:	bbf9                	j	bd6 <vprintf+0x4a>
 dfa:	64a6                	ld	s1,72(sp)
 dfc:	79e2                	ld	s3,56(sp)
 dfe:	7a42                	ld	s4,48(sp)
 e00:	7aa2                	ld	s5,40(sp)
 e02:	7b02                	ld	s6,32(sp)
 e04:	6be2                	ld	s7,24(sp)
 e06:	6c42                	ld	s8,16(sp)
 e08:	6ca2                	ld	s9,8(sp)
    }
  }
}
 e0a:	60e6                	ld	ra,88(sp)
 e0c:	6446                	ld	s0,80(sp)
 e0e:	6906                	ld	s2,64(sp)
 e10:	6125                	addi	sp,sp,96
 e12:	8082                	ret

0000000000000e14 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 e14:	715d                	addi	sp,sp,-80
 e16:	ec06                	sd	ra,24(sp)
 e18:	e822                	sd	s0,16(sp)
 e1a:	1000                	addi	s0,sp,32
 e1c:	e010                	sd	a2,0(s0)
 e1e:	e414                	sd	a3,8(s0)
 e20:	e818                	sd	a4,16(s0)
 e22:	ec1c                	sd	a5,24(s0)
 e24:	03043023          	sd	a6,32(s0)
 e28:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 e2c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 e30:	8622                	mv	a2,s0
 e32:	d5bff0ef          	jal	b8c <vprintf>
}
 e36:	60e2                	ld	ra,24(sp)
 e38:	6442                	ld	s0,16(sp)
 e3a:	6161                	addi	sp,sp,80
 e3c:	8082                	ret

0000000000000e3e <printf>:

void
printf(const char *fmt, ...)
{
 e3e:	711d                	addi	sp,sp,-96
 e40:	ec06                	sd	ra,24(sp)
 e42:	e822                	sd	s0,16(sp)
 e44:	1000                	addi	s0,sp,32
 e46:	e40c                	sd	a1,8(s0)
 e48:	e810                	sd	a2,16(s0)
 e4a:	ec14                	sd	a3,24(s0)
 e4c:	f018                	sd	a4,32(s0)
 e4e:	f41c                	sd	a5,40(s0)
 e50:	03043823          	sd	a6,48(s0)
 e54:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 e58:	00840613          	addi	a2,s0,8
 e5c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 e60:	85aa                	mv	a1,a0
 e62:	4505                	li	a0,1
 e64:	d29ff0ef          	jal	b8c <vprintf>
}
 e68:	60e2                	ld	ra,24(sp)
 e6a:	6442                	ld	s0,16(sp)
 e6c:	6125                	addi	sp,sp,96
 e6e:	8082                	ret

0000000000000e70 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 e70:	1141                	addi	sp,sp,-16
 e72:	e422                	sd	s0,8(sp)
 e74:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 e76:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e7a:	00002797          	auipc	a5,0x2
 e7e:	1967b783          	ld	a5,406(a5) # 3010 <freep>
 e82:	a02d                	j	eac <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 e84:	4618                	lw	a4,8(a2)
 e86:	9f2d                	addw	a4,a4,a1
 e88:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 e8c:	6398                	ld	a4,0(a5)
 e8e:	6310                	ld	a2,0(a4)
 e90:	a83d                	j	ece <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 e92:	ff852703          	lw	a4,-8(a0)
 e96:	9f31                	addw	a4,a4,a2
 e98:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 e9a:	ff053683          	ld	a3,-16(a0)
 e9e:	a091                	j	ee2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ea0:	6398                	ld	a4,0(a5)
 ea2:	00e7e463          	bltu	a5,a4,eaa <free+0x3a>
 ea6:	00e6ea63          	bltu	a3,a4,eba <free+0x4a>
{
 eaa:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 eac:	fed7fae3          	bgeu	a5,a3,ea0 <free+0x30>
 eb0:	6398                	ld	a4,0(a5)
 eb2:	00e6e463          	bltu	a3,a4,eba <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 eb6:	fee7eae3          	bltu	a5,a4,eaa <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 eba:	ff852583          	lw	a1,-8(a0)
 ebe:	6390                	ld	a2,0(a5)
 ec0:	02059813          	slli	a6,a1,0x20
 ec4:	01c85713          	srli	a4,a6,0x1c
 ec8:	9736                	add	a4,a4,a3
 eca:	fae60de3          	beq	a2,a4,e84 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 ece:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 ed2:	4790                	lw	a2,8(a5)
 ed4:	02061593          	slli	a1,a2,0x20
 ed8:	01c5d713          	srli	a4,a1,0x1c
 edc:	973e                	add	a4,a4,a5
 ede:	fae68ae3          	beq	a3,a4,e92 <free+0x22>
    p->s.ptr = bp->s.ptr;
 ee2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 ee4:	00002717          	auipc	a4,0x2
 ee8:	12f73623          	sd	a5,300(a4) # 3010 <freep>
}
 eec:	6422                	ld	s0,8(sp)
 eee:	0141                	addi	sp,sp,16
 ef0:	8082                	ret

0000000000000ef2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ef2:	7139                	addi	sp,sp,-64
 ef4:	fc06                	sd	ra,56(sp)
 ef6:	f822                	sd	s0,48(sp)
 ef8:	f426                	sd	s1,40(sp)
 efa:	ec4e                	sd	s3,24(sp)
 efc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 efe:	02051493          	slli	s1,a0,0x20
 f02:	9081                	srli	s1,s1,0x20
 f04:	04bd                	addi	s1,s1,15
 f06:	8091                	srli	s1,s1,0x4
 f08:	0014899b          	addiw	s3,s1,1
 f0c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 f0e:	00002517          	auipc	a0,0x2
 f12:	10253503          	ld	a0,258(a0) # 3010 <freep>
 f16:	c915                	beqz	a0,f4a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f18:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 f1a:	4798                	lw	a4,8(a5)
 f1c:	08977a63          	bgeu	a4,s1,fb0 <malloc+0xbe>
 f20:	f04a                	sd	s2,32(sp)
 f22:	e852                	sd	s4,16(sp)
 f24:	e456                	sd	s5,8(sp)
 f26:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 f28:	8a4e                	mv	s4,s3
 f2a:	0009871b          	sext.w	a4,s3
 f2e:	6685                	lui	a3,0x1
 f30:	00d77363          	bgeu	a4,a3,f36 <malloc+0x44>
 f34:	6a05                	lui	s4,0x1
 f36:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 f3a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 f3e:	00002917          	auipc	s2,0x2
 f42:	0d290913          	addi	s2,s2,210 # 3010 <freep>
  if(p == (char*)-1)
 f46:	5afd                	li	s5,-1
 f48:	a081                	j	f88 <malloc+0x96>
 f4a:	f04a                	sd	s2,32(sp)
 f4c:	e852                	sd	s4,16(sp)
 f4e:	e456                	sd	s5,8(sp)
 f50:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 f52:	00002797          	auipc	a5,0x2
 f56:	0ce78793          	addi	a5,a5,206 # 3020 <base>
 f5a:	00002717          	auipc	a4,0x2
 f5e:	0af73b23          	sd	a5,182(a4) # 3010 <freep>
 f62:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 f64:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 f68:	b7c1                	j	f28 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 f6a:	6398                	ld	a4,0(a5)
 f6c:	e118                	sd	a4,0(a0)
 f6e:	a8a9                	j	fc8 <malloc+0xd6>
  hp->s.size = nu;
 f70:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 f74:	0541                	addi	a0,a0,16
 f76:	efbff0ef          	jal	e70 <free>
  return freep;
 f7a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 f7e:	c12d                	beqz	a0,fe0 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f80:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 f82:	4798                	lw	a4,8(a5)
 f84:	02977263          	bgeu	a4,s1,fa8 <malloc+0xb6>
    if(p == freep)
 f88:	00093703          	ld	a4,0(s2)
 f8c:	853e                	mv	a0,a5
 f8e:	fef719e3          	bne	a4,a5,f80 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 f92:	8552                	mv	a0,s4
 f94:	ad3ff0ef          	jal	a66 <sbrk>
  if(p == (char*)-1)
 f98:	fd551ce3          	bne	a0,s5,f70 <malloc+0x7e>
        return 0;
 f9c:	4501                	li	a0,0
 f9e:	7902                	ld	s2,32(sp)
 fa0:	6a42                	ld	s4,16(sp)
 fa2:	6aa2                	ld	s5,8(sp)
 fa4:	6b02                	ld	s6,0(sp)
 fa6:	a03d                	j	fd4 <malloc+0xe2>
 fa8:	7902                	ld	s2,32(sp)
 faa:	6a42                	ld	s4,16(sp)
 fac:	6aa2                	ld	s5,8(sp)
 fae:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 fb0:	fae48de3          	beq	s1,a4,f6a <malloc+0x78>
        p->s.size -= nunits;
 fb4:	4137073b          	subw	a4,a4,s3
 fb8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 fba:	02071693          	slli	a3,a4,0x20
 fbe:	01c6d713          	srli	a4,a3,0x1c
 fc2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 fc4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 fc8:	00002717          	auipc	a4,0x2
 fcc:	04a73423          	sd	a0,72(a4) # 3010 <freep>
      return (void*)(p + 1);
 fd0:	01078513          	addi	a0,a5,16
  }
}
 fd4:	70e2                	ld	ra,56(sp)
 fd6:	7442                	ld	s0,48(sp)
 fd8:	74a2                	ld	s1,40(sp)
 fda:	69e2                	ld	s3,24(sp)
 fdc:	6121                	addi	sp,sp,64
 fde:	8082                	ret
 fe0:	7902                	ld	s2,32(sp)
 fe2:	6a42                	ld	s4,16(sp)
 fe4:	6aa2                	ld	s5,8(sp)
 fe6:	6b02                	ld	s6,0(sp)
 fe8:	b7f5                	j	fd4 <malloc+0xe2>
