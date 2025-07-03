#include "param.h"
#include "types.h"
#include "memlayout.h"
#include "elf.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "spinlock.h"
#include "proc.h"

/*
 * the kernel's page table.
 */
pagetable_t kernel_pagetable;

extern char etext[];  // kernel.ld sets this to end of kernel code.

extern char trampoline[]; // trampoline.S

// Make a direct-map page table for the kernel.
pagetable_t
kvmmake(void)
{
  pagetable_t kpgtbl;

  kpgtbl = (pagetable_t) kalloc();
  memset(kpgtbl, 0, PGSIZE);

  // uart registers
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);

  // virtio mmio disk interface
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);

  // PLIC
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);

  // map kernel text executable and read-only.
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);

  // map kernel data and the physical RAM we'll make use of.
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);

  // map the trampoline for trap entry/exit to
  // the highest virtual address in the kernel.
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);

  // allocate and map a kernel stack for each process.
  proc_mapstacks(kpgtbl);
  
  return kpgtbl;
}

// Initialize the one kernel_pagetable
void
kvminit(void)
{
  kernel_pagetable = kvmmake();
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
  w_satp(MAKE_SATP(kernel_pagetable));
  sfence_vma();
}

// Return the address of the PTE in page table pagetable
// that corresponds to virtual address va.  If alloc!=0,
// create any required page-table pages.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
  if(va >= MAXVA)
    panic("walk");

  for(int level = 2; level > 0; level--) {
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      if(level == 1 && (*pte & (PTE_R|PTE_W|PTE_X))) {
        return pte;
      }
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pte_t*)kalloc()) == 0)
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE((uint64)pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
}

// Look up a virtual address, return the physical address,
// or 0 if not mapped.
uint64
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    return 0;

  pte = walk(pagetable, va, 0);
  if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0)
    return 0;
  
  if((*pte & (PTE_R|PTE_W|PTE_X)) == 0){
    // Not a leaf PTE, which is an error in this context
    return 0;
  }
  
  pa = PTE2PA(*pte);
  
  // Check if it's a superpage by checking if the PTE is an L1 entry
  pte_t* l2_pte = &pagetable[PX(2, va)];
  if(!(*l2_pte & PTE_V) || (*l2_pte & (PTE_R|PTE_W|PTE_X))) {
      // should not happen if walk succeeded
  } else {
      pagetable_t l1_table = (pagetable_t)PTE2PA(*l2_pte);
      if(&l1_table[PX(1, va)] == pte) { // It's an L1 PTE
          return pa + (va & (SUPERPGSIZE - 1));
      }
  }

  // It's a 4KB page
  return pa + (va & (PGSIZE - 1));
}

// add a mapping to the kernel page table.
void
kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm)
{
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    panic("kvmmap");
}

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size MUST be page-aligned.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
  uint64 a;
  pte_t *pte;

  if (size == 0)
    panic("mappages: size is 0");
  
  // 确保 va 和 size 都是页面大小的倍数。
  // 虽然调用者应该保证，但在这里检查更安全。
  if (va % PGSIZE != 0 || size % PGSIZE != 0)
    panic("mappages: va or size not page-aligned");

  // 使用一个清晰的 for 循环，避免 off-by-one 错误
  for(a = va; a < va + size; a += PGSIZE, pa += PGSIZE){
    if((pte = walk(pagetable, a, 1)) == 0)
      return -1; // kalloc 失败
    if(*pte & PTE_V)
      panic("mappages: remap"); // 尝试重新映射
    *pte = PA2PTE(pa) | perm | PTE_V;
  }

  return 0;
}

// Map a 2MB superpage. va must be 2MB aligned. pa_super must be 2MB aligned.
int
uvmmap_super(pagetable_t pagetable, uint64 va, uint64 pa_super, int perm)
{
  if (va % SUPERPGSIZE != 0 || pa_super % SUPERPGSIZE != 0)
    panic("uvmmap_super: unaligned va or pa_super");
  if (va >= MAXVA)
    panic("uvmmap_super: va out of bounds");
  
  pte_t *pte_l2 = &pagetable[PX(2, va)];
  pagetable_t l1_table;

  if (*pte_l2 & PTE_V) {
    if (*pte_l2 & (PTE_R | PTE_W | PTE_X))
      panic("uvmmap_super: L2 entry is already a 1GB leaf page");
    l1_table = (pagetable_t)PTE2PA(*pte_l2);
  } else {
    if ((l1_table = (pagetable_t)kalloc()) == 0) return -1;
    memset(l1_table, 0, PGSIZE);
    *pte_l2 = PA2PTE((uint64)l1_table) | PTE_V;
  }

  pte_t *l1_pte = &l1_table[PX(1, va)];
  if (*l1_pte & PTE_V) panic("uvmmap_super: L1 PTE is already in use");
  
  *l1_pte = PA2PTE(pa_super) | perm | PTE_V;
  return 0;
}

// Remove mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 size, int do_free)
{
  if((va % PGSIZE) != 0) panic("uvmunmap: va not page-aligned");
  if(size == 0) return;
    
  uint64 end_va = va + size;

  for(uint64 a = va; a < end_va; ){
    pte_t *l2_pte = &pagetable[PX(2, a)];
    if(!(*l2_pte & PTE_V) || (*l2_pte & (PTE_R|PTE_W|PTE_X))) {
      a = GIGAROUNDUP(a+1);
      if (a == 0) break;
      continue;
    }

    pagetable_t l1_table = (pagetable_t)PTE2PA(*l2_pte);
    pte_t *l1_pte = &l1_table[PX(1, a)];

    if(!(*l1_pte & PTE_V)) {
      a = SUPERPGROUNDUP(a+1);
      if (a == 0) break;
      continue;
    }

    if(*l1_pte & (PTE_R|PTE_W|PTE_X)) { // Superpage leaf
      if (a % SUPERPGSIZE != 0) panic("uvmunmap: unaligned superpage unmap");
      if (do_free) superfree((void*)PTE2PA(*l1_pte));
      *l1_pte = 0;
      a += SUPERPGSIZE;
    } else { // Intermediate PTE to L0 table
      pagetable_t l0_table = (pagetable_t)PTE2PA(*l1_pte);
      pte_t *pte = &l0_table[PX(0, a)];

      if(*pte & PTE_V) {
        if(PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: L0 pte is intermediate");
        if(do_free) kfree((void*)PTE2PA(*pte));
        *pte = 0;
      }
      a += PGSIZE;
    }
  }
}

// create an empty user page table.
pagetable_t
uvmcreate()
{
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
  if(pagetable == 0) return 0;
  memset(pagetable, 0, PGSIZE);
  return pagetable;
}

// Load the user initcode into address 0 of pagetable.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
  char *mem;
  if(sz >= PGSIZE) panic("uvmfirst: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
  memmove(mem, src, sz);
}

// Allocate PTEs and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.
uint64
uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int xperm)
{
  char *mem;
  uint64 a;

  if(newsz < oldsz) return oldsz;
  oldsz = PGROUNDUP(oldsz);
  for(a = oldsz; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      uvmdealloc(pagetable, a, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
      kfree(mem);
      uvmdealloc(pagetable, a, oldsz);
      return 0;
    }
  }
  return newsz;
}

// Deallocate user pages to bring the process size from oldsz to newsz.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
  if(newsz >= oldsz) return oldsz;
  uvmunmap(pagetable, PGROUNDUP(newsz), PGROUNDUP(oldsz) - PGROUNDUP(newsz), 1);
  return newsz;
}

// Recursively free page-table pages.
void
freewalk(pagetable_t pagetable)
{
  for(int i = 0; i < 512; i++){
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf found");
    }
  }
  kfree((void*)pagetable);
}

// Free user memory pages, then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
  if(sz > 0)
    uvmunmap(pagetable, 0, PGROUNDUP(sz), 1);
  
  for(int i=0; i<512; i++){
      pte_t pte = pagetable[i];
      if((pte & PTE_V) && !(pte & (PTE_R|PTE_W|PTE_X))){
          freewalk((pagetable_t)PTE2PA(pte));
      } else if (pte & PTE_V) {
          panic("uvmfree: L2 leaf found");
      }
      pagetable[i] = 0;
  }
  kfree((void*)pagetable);
}

// Given a parent process's page table, copy its memory into a child's.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; ){
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
      panic("uvmcopy: page not present");

    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);

    if(*pte & (PTE_R|PTE_W|PTE_X)) { // Leaf PTE
        // Check if it's a superpage by checking if the PTE is an L1 entry
        pte_t* l2_pte = &old[PX(2, i)];
        if(!(*l2_pte & PTE_V)) panic("uvmcopy: l2 pte invalid");
        pagetable_t l1_table = (pagetable_t)PTE2PA(*l2_pte);

        if(&l1_table[PX(1, i)] == pte) { // It's an L1 PTE (superpage)
            char* mem = superalloc();
            if(mem == 0) goto err;
            memmove(mem, (char*)pa, SUPERPGSIZE);
            if(uvmmap_super(new, i, (uint64)mem, flags) != 0){
                superfree(mem);
                goto err;
            }
            i += SUPERPGSIZE;
            continue;
        }
    }
    
    // It's a 4KB page
    char* mem = kalloc();
    if(mem == 0) goto err;
    memmove(mem, (char*)pa, PGSIZE);
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
      kfree(mem);
      goto err;
    }
    i += PGSIZE;
  }
  return 0;

 err:
  uvmunmap(new, 0, i, 1);
  return -1;
}

// mark a PTE invalid for user access.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
  pte_t *pte = walk(pagetable, va, 0);
  if(pte == 0) panic("uvmclear: walk failed");
  *pte &= ~PTE_U;
}

// Copy from kernel to user.
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n_this_iter, va_current_page_base, phys_base_of_current_page;
  uint64 size_of_current_page;

  // Initial comprehensive check for dstva and len validity
  if (dstva >= MAXVA || dstva + len < dstva || dstva + len > MAXVA) {
      return -1;
  }

  while(len > 0){
    // If dstva hits MAXVA and len > 0, it's an error (should be caught by initial check mostly).
    if (dstva >= MAXVA) return -1; // Added safety check within loop for MAXVA boundary


    size_of_current_page = PGSIZE; // Default to 4KB
    va_current_page_base = PGROUNDDOWN(dstva);

    pte_t *l2_pte = &pagetable[PX(2, dstva)];
    if(!(*l2_pte & PTE_V) || (*l2_pte & (PTE_R|PTE_W|PTE_X))) { // L2 not valid or is 1GB leaf (error for user)
        // Fallback to check as a 4KB page path through walk. This covers kernel mappings too.
        goto cout_try_4k_walk;
    }
    
    pagetable_t l1_table = (pagetable_t)PTE2PA(*l2_pte);
    pte_t *l1_pte = &l1_table[PX(1, dstva)];

    if(!(*l1_pte & PTE_V)) { // L1 entry not valid, try 4KB walk
        goto cout_try_4k_walk; 
    }

    if(*l1_pte & (PTE_R|PTE_W|PTE_X)) { // L1 PTE is a Superpage leaf
        if(!(*l1_pte & PTE_U) || !(*l1_pte & PTE_W)) return -1; // Check user access AND writable
        size_of_current_page = SUPERPGSIZE;
        va_current_page_base = SUPERPGROUNDDOWN(dstva);
        phys_base_of_current_page = PTE2PA(*l1_pte);
    } else { // L1 PTE points to L0 table
    cout_try_4k_walk:; // Label for fallback to 4KB page walk
        pte_t* pte_l0 = walk(pagetable, dstva, 0); 
        if(pte_l0 == 0 || !(*pte_l0 & PTE_V) || !(*pte_l0 & PTE_U) || !(*pte_l0 & PTE_W)) return -1;
        phys_base_of_current_page = PTE2PA(*pte_l0);
        // size_of_current_page remains PGSIZE
        // va_current_page_base is already PGROUNDDOWN(dstva)
    }
    
    n_this_iter = size_of_current_page - (dstva - va_current_page_base); 
    if(n_this_iter > len)
      n_this_iter = len;
    
    memmove((void *)(phys_base_of_current_page + (dstva - va_current_page_base)), src, n_this_iter);

    len -= n_this_iter;
    src += n_this_iter;
    dstva += n_this_iter; // Correctly advance dstva by amount copied
  }
  return 0;
}

// Copy from user to kernel.
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n_this_iter, va_current_page_base, phys_base_of_current_page;
  uint64 size_of_current_page;

  if (srcva >= MAXVA || srcva + len < srcva || srcva + len > MAXVA) {
      return -1;
  }

  while(len > 0){
    if (srcva >= MAXVA) return -1; // Added safety check within loop for MAXVA boundary

    size_of_current_page = PGSIZE; // Default to 4KB
    va_current_page_base = PGROUNDDOWN(srcva);

    pte_t *l2_pte = &pagetable[PX(2, srcva)];
    if(!(*l2_pte & PTE_V) || (*l2_pte & (PTE_R|PTE_W|PTE_X))) { 
        goto cin_try_4k_walk;
    }
    
    pagetable_t l1_table = (pagetable_t)PTE2PA(*l2_pte);
    pte_t *l1_pte = &l1_table[PX(1, srcva)];

    if(!(*l1_pte & PTE_V)) { 
        goto cin_try_4k_walk; 
    }

    if(*l1_pte & (PTE_R|PTE_W|PTE_X)) { // L1 PTE is a Superpage leaf
        if(!(*l1_pte & PTE_U)) return -1; // Check user access
        size_of_current_page = SUPERPGSIZE;
        va_current_page_base = SUPERPGROUNDDOWN(srcva);
        phys_base_of_current_page = PTE2PA(*l1_pte);
    } else { // L1 PTE points to L0 table
    cin_try_4k_walk:;
        pte_t* pte_l0 = walk(pagetable, srcva, 0); 
        if(pte_l0 == 0 || !(*pte_l0 & PTE_V) || !(*pte_l0 & PTE_U)) return -1;
        phys_base_of_current_page = PTE2PA(*pte_l0);
        // size_of_current_page remains PGSIZE
        // va_current_page_base is already PGROUNDDOWN(srcva)
    }
    
    n_this_iter = size_of_current_page - (srcva - va_current_page_base); 
    if(n_this_iter > len)
      n_this_iter = len;
    
    memmove(dst, (void *)(phys_base_of_current_page + (srcva - va_current_page_base)), n_this_iter);

    len -= n_this_iter;
    dst += n_this_iter;
    srcva += n_this_iter; // Correctly advance srcva by amount copied
  }
  return 0;
}


// Copy a null-terminated string from user to kernel.
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max. Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max_len_arg) // Renamed max to max_len_arg for clarity
{
  uint64 n_this_segment, va_current_page_base, phys_base_of_current_page;
  uint64 size_of_current_page;
  int got_null = 0;
  char current_char_val; // To store the character value
  
  // Initial comprehensive check for srcva and max_len_arg validity
  if (srcva >= MAXVA) {
      return -1;
  }
  if (max_len_arg > 0) {
      if ((srcva + max_len_arg < srcva) || // Overflow
          (srcva + max_len_arg > MAXVA) ) {   // Exceeds MAXVA
          return -1;
      }
  } else if (max_len_arg == 0) {
      return -1; 
  }


  while(got_null == 0 && max_len_arg > 0){
    if (srcva >= MAXVA ) { // Added safety check within loop for MAXVA boundary
        return -1; 
    }

    size_of_current_page = PGSIZE; 
    va_current_page_base = PGROUNDDOWN(srcva);

    // --- Logic to determine phys_base_of_current_page and size_of_current_page ---
    pte_t *l2_pte = &pagetable[PX(2, srcva)];
    if(!(*l2_pte & PTE_V) || (*l2_pte & (PTE_R|PTE_W|PTE_X))) {
        goto cinstr_fallback_4k;
    }
    pagetable_t l1_table = (pagetable_t)PTE2PA(*l2_pte);
    pte_t *l1_pte = &l1_table[PX(1, srcva)];
    if(!(*l1_pte & PTE_V)) {
        goto cinstr_fallback_4k;
    }
    if(*l1_pte & (PTE_R|PTE_W|PTE_X)) { // Superpage
        if(!(*l1_pte & PTE_U)) return -1;
        size_of_current_page = SUPERPGSIZE;
        va_current_page_base = SUPERPGROUNDDOWN(srcva);
        phys_base_of_current_page = PTE2PA(*l1_pte);
    } else { // 4KB page path
    cinstr_fallback_4k:;
        pte_t* pte_l0 = walk(pagetable, srcva, 0); 
        if(pte_l0 == 0 || !(*pte_l0 & PTE_V) || !(*pte_l0 & PTE_U)) return -1;
        phys_base_of_current_page = PTE2PA(*pte_l0);
        // size_of_current_page remains PGSIZE
        // va_current_page_base is PGROUNDDOWN(srcva)
    }
    // --- End of placeholder ---
    
    n_this_segment = size_of_current_page - (srcva - va_current_page_base);
    if(n_this_segment > max_len_arg) // Cap segment scan by remaining max_len_arg
      n_this_segment = max_len_arg;

    char *pa_char_ptr = (char *)(phys_base_of_current_page + (srcva - va_current_page_base));
    uint64 i; // Bytes to copy from this segment in this inner loop
    for(i = 0; i < n_this_segment; i++){
      current_char_val = pa_char_ptr[i];
      *dst = current_char_val;
      
      dst++; // Advance kernel destination buffer

      if(current_char_val == '\0'){
        got_null = 1;
        break; 
      }
    }
    
    uint64 bytes_read_in_iter;
    if (got_null) {
        bytes_read_in_iter = i + 1; // Read 'i' chars + 1 null.
    } else {
        bytes_read_in_iter = i;     // Read 'i' (which is n_this_segment) non-null chars.
    }

    srcva += bytes_read_in_iter;
    max_len_arg -= bytes_read_in_iter;

  } // end while

  if(got_null){
    return 0; // Success: null terminator found and copied within max_len_arg
  } else {
    // Failure: Either max_len_arg exhausted before null, or an invalid access occurred.
    return -1;
  }
}

void
vmprint_level(pagetable_t pagetable, int level)
{
  // Sv39页表有三级，我们用level 0, 1, 2来代表L2, L1, L0。
  if (level > 2)
    return;

  // 遍历当前页表中的512个PTE。
  for(int i = 0; i < 512; i++){
    pte_t pte = pagetable[i];
    
    // 只打印有效的PTE (PTE_V位被设置)。
    if(pte & PTE_V){
      // 打印缩进，表示当前层级。
      for (int j = 0; j < level; j++) {
        printf(".. "); 
      }
      
      // 打印PTE的索引、PTE本身的值、以及它指向的物理地址。
      uint64 pa = PTE2PA(pte);
      printf("pte %d: pte %ld, pa %ld", i, pte, pa);

      // 检查这是一个中间PTE还是叶子PTE。
      // 如果R,W,X位都为0，它就是一个指向下一级页表的中间PTE。
      if((pte & (PTE_R|PTE_W|PTE_X)) == 0){
        // 是中间PTE，换行并递归到下一级。
        printf("\n");
        vmprint_level((pagetable_t)pa, level + 1);
      } else {
        // 是叶子PTE，它映射一个物理页面。打印它的权限标志。
        printf(" -> flags:");
        if(pte & PTE_V) printf(" V");
        if(pte & PTE_R) printf(" R");
        if(pte & PTE_W) printf(" W");
        if(pte & PTE_X) printf(" X");
        if(pte & PTE_U) printf(" U");
        printf("\n");
      }
    }
  }
}

// 打印页表的主函数。
void
vmprint(pagetable_t pagetable)
{
  printf("page table -------------------- 0x%p\n", pagetable);
  // 从level 0 (即L2根页表) 开始递归打印。
  vmprint_level(pagetable, 0);
  printf("--------------------------------\n");
}
// --- end of vmprint ---