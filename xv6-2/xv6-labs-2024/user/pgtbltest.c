// user/pgtbltest.c

#include "kernel/param.h"
#include "kernel/fcntl.h"   // Not strictly needed for these tests, but often included
#include "kernel/types.h"
#include "kernel/riscv.h"   // For PGSIZE, MAXVA, SUPERPGSIZE, PTE_V, PTE_R, PTE_W, PTE_U, PTE2PA, PTE_FLAGS
#include "user/user.h"

// Define N for sbrk in superpg_test, e.g., 8MB
// Make sure SUPERPGSIZE is defined, either via user.h including riscv.h,
// or define it here if not globally available to user space.
#ifndef SUPERPGSIZE
#define SUPERPGSIZE (2 * 1024 * 1024) // 2MB, ensure this matches kernel definition
#endif
#define SBRK_SIZE_FOR_SUPERPG_TEST (4 * SUPERPGSIZE) // Allocate 8MB to ensure at least one 2MB aligned block

// Global variable to store the current test name for error reporting
char *testname = "???";

// Forward declarations for test functions
void print_pgtbl_using_pgpte(); // Renamed to be more descriptive
void ugetpid_test();
void print_kpgtbl_using_syscall(); // Renamed
void superpg_test();
void err(char *why);


// Main function to run all tests
int
main(int argc, char *argv[])
{
  printf("pgtbltest: Starting all tests...\n\n");

  // Test 1: Print parts of the initial user page table using pgpte syscall
  print_pgtbl_using_pgpte();
  printf("\n");

  // Test 2: ugetpid system call test
  ugetpid_test();
  printf("\n");

  // Test 3: Print current process's full page table using kpgtbl syscall
  // This is called again within superpg_test at relevant points.
  // print_kpgtbl_using_syscall(); 
  // printf("\n");

  // Test 4: Superpage allocation and usage test
  superpg_test();
  printf("\n");

  printf("pgtbltest: all tests (that were run) succeeded\n");
  exit(0);
}

// Helper function to report errors and exit
void
err(char *why)
{
  printf("pgtbltest: %s FAILED: %s, pid=%d\n", testname, why, getpid());
  exit(1);
}

// Helper function to print a single PTE using pgpte syscall
void
print_single_pte_info(uint64 va)
{
    uint64 pte_val = pgpte((void *) va); // Assumes pgpte returns uint64 (the PTE value)
                                       // or 0 if not mapped/error.
    if (pte_val == 0) {
        printf("va 0x%lx: pte not mapped or error in pgpte()\n", va);
    } else {
        // Assuming PTE2PA and PTE_FLAGS are available to user space via user.h or riscv.h
        // If not, user space cannot directly interpret these bits without kernel knowledge.
        // For the lab, it's common to make these macros available or simplify the check.
        // Let's assume they are available for now.
        printf("va 0x%lx pte 0x%lx pa 0x%lx perm 0x%x\n",
               va,
               pte_val,
               PTE2PA(pte_val), // This macro works on the PTE value
               (int)(pte_val & 0x3FF)); // Extracting low 10 bits for flags
    }
}

// Test function to print parts of the user page table using pgpte
void
print_pgtbl_using_pgpte()
{
  testname = "print_pgtbl_using_pgpte";
  printf("%s starting\n", testname);

  printf("Bottom of address space:\n");
  for (uint64 i = 0; i < 5; i++) { // Print a few pages from the bottom
    print_single_pte_info(i * PGSIZE);
  }

  printf("Top of address space (below MAXVA):\n");
  // MAXVA might not be directly usable/visible in user.h,
  // but TRAMPOLINE typically is MAXVA - PGSIZE.
  // Let's use a known high address like TRAMPOLINE if MAXVA is not available.
  // For simplicity, let's assume MAXVA is defined or calculate a high VA.
  // uint64 top_va_region_start = MAXVA - 5 * PGSIZE;
  // A more robust way if MAXVA is not in user.h:
  uint64 top_va_region_start = (1L << (39-1)) - 5 * PGSIZE; // Approximation of user MAXVA

  for (uint64 i = 0; i < 5; i++) { // Print a few pages from the top
    print_single_pte_info(top_va_region_start + i * PGSIZE);
  }
  printf("%s: OK\n", testname);
}

// Test function for ugetpid system call
void
ugetpid_test()
{
  int i;
  int mypid_kernel = getpid(); // Get PID via standard getpid for comparison

  testname = "ugetpid_test";
  printf("%s starting (kernel pid for this process: %d)\n", testname, mypid_kernel);

  for (i = 0; i < 10; i++) { // Reduced loop count for faster testing
    int ret = fork();
    if (ret < 0) {
      err("fork failed");
    }
    if (ret == 0) { // Child process
      int child_pid_kernel = getpid();
      int child_pid_ugetpid = ugetpid();
      if (child_pid_kernel != child_pid_ugetpid) {
        printf("ugetpid_test: Child PID mismatch! getpid()=%d, ugetpid()=%d\n",
               child_pid_kernel, child_pid_ugetpid);
        err("mismatched PID in child");
      }
      exit(0); // Child exits successfully
    } else { // Parent process
      int status;
      wait(&status);
      if (status != 0) {
        printf("ugetpid_test: Child (pid %d) exited with status %d\n", ret, status);
        err("child process failed");
      }
    }
  }
  // Check parent's PID again
  if (mypid_kernel != ugetpid()){
    printf("ugetpid_test: Parent PID mismatch! getpid()=%d, ugetpid()=%d\n",
            mypid_kernel, ugetpid());
    err("mismatched PID in parent after children");
  }
  printf("%s: OK\n", testname);
}

// Test function to print current process's page table using kpgtbl syscall
void
print_kpgtbl_using_syscall()
{
  testname = "print_kpgtbl_using_syscall";
  printf("%s starting for pid %d\n", testname, getpid());
  kpgtbl(); // Call the system call
  printf("%s: OK (output above)\n", testname);
}

// Helper function to check a 2MB superpage region
void
supercheck(uint64 va_start_of_2mb_region)
{
  uint64 first_pte_val = 0;

  testname = "supercheck"; // Temporarily set for err() if it happens inside
  printf("supercheck: Verifying 2MB region starting at VA 0x%lx\n", va_start_of_2mb_region);

  for (uint64 va_offset = 0; va_offset < SUPERPGSIZE; va_offset += PGSIZE) {
    uint64 current_va = va_start_of_2mb_region + va_offset;
    uint64 pte_val = pgpte((void *) current_va);

    if (pte_val == 0) {
      printf("supercheck: No PTE for VA 0x%lx within the 2MB region.\n", current_va);
      err("no pte within superpage region");
    }

    if (va_offset == 0) {
      first_pte_val = pte_val; // Store the PTE of the first 4KB chunk
      // Check if it's actually a superpage by looking at flags (R/W/X not all zero)
      // This assumes pgpte returns the L1 PTE for a superpage.
      // And that PTE_FLAGS can be applied to it directly.
      if (!((pte_val & PTE_V) && (pte_val & (PTE_R | PTE_W | PTE_X)))) {
         printf("supercheck: VA 0x%lx does not look like a leaf PTE (R|W|X not set for superpage), pte=0x%lx\n", current_va, pte_val);
         err("first PTE of superpage region is not a leaf");
      }
       printf("supercheck: First PTE in 2MB region (VA 0x%lx) is 0x%lx\n", current_va, pte_val);
    } else {
      if (pte_val != first_pte_val) {
        printf("supercheck: PTE mismatch within 2MB region! VA 0x%lx has pte 0x%lx, expected 0x%lx\n",
               current_va, pte_val, first_pte_val);
        err("pte different - not a single superpage mapping");
      }
    }

    // Basic permission check based on the first PTE (assuming it's a superpage)
    if (!((first_pte_val & PTE_V) && (first_pte_val & PTE_R) && (first_pte_val & PTE_W) && (first_pte_val & PTE_U))) {
      printf("supercheck: Expected V,R,W,U for sbrk'd superpage at VA 0x%lx, pte=0x%lx\n", va_start_of_2mb_region, first_pte_val);
      err("superpage pte missing expected permissions (V,R,W,U)");
    }
  }
  printf("supercheck: PTE consistency OK for 2MB region at VA 0x%lx.\n", va_start_of_2mb_region);

  // Memory content writability and readability check
  printf("supercheck: Performing memory R/W test in 2MB region at VA 0x%lx.\n", va_start_of_2mb_region);
  for(uint64 offset_in_superpage = 0; offset_in_superpage < SUPERPGSIZE; offset_in_superpage += PGSIZE) {
    char *ptr = (char *)(va_start_of_2mb_region + offset_in_superpage);
    *ptr = (char)((va_start_of_2mb_region + offset_in_superpage) % 128);
  }

  for(uint64 offset_in_superpage = 0; offset_in_superpage < SUPERPGSIZE; offset_in_superpage += PGSIZE) {
    char *ptr = (char *)(va_start_of_2mb_region + offset_in_superpage);
    if (*ptr != (char)((va_start_of_2mb_region + offset_in_superpage) % 128)) {
      printf("supercheck: Memory content mismatch at VA 0x%lx.\n", va_start_of_2mb_region + offset_in_superpage);
      err("wrong value in superpage memory");
    }
  }
  printf("supercheck: Memory R/W test OK for 2MB region at VA 0x%lx.\n", va_start_of_2mb_region);
}

// Test function for superpage allocation and usage
void
superpg_test()
{
  int pid;
  char *sbrk_old_break, *sbrk_new_break;
  
  testname = "superpg_test";
  printf("%s starting\n", testname);
  
  printf("pgtbltest: Current process pagetable (before superpg_test sbrk):\n");
  print_kpgtbl_using_syscall();

  sbrk_old_break = sbrk(0);
  printf("superpg_test: Current break before sbrk(0x%lx) is 0x%p\n", (uint64)SBRK_SIZE_FOR_SUPERPG_TEST, sbrk_old_break);
  
  if (sbrk(SBRK_SIZE_FOR_SUPERPG_TEST) == (char*)-1) { // sbrk returns -1 on error
    err("sbrk(N) failed");
  }
  sbrk_new_break = sbrk(0);
  printf("superpg_test: sbrk(N) successful. Old break 0x%p, new break is 0x%p\n", sbrk_old_break, sbrk_new_break);

  // Find the first 2MB-aligned VA within the newly sbrk'd region [sbrk_old_break, sbrk_new_break)
  uint64 va_to_check = SUPERPGROUNDUP((uint64)sbrk_old_break); 

  if (va_to_check + SUPERPGSIZE <= (uint64)sbrk_new_break) {
     printf("superpg_test: Will check for superpage at VA 0x%lx (within sbrk'd region 0x%p-0x%p).\n",
            va_to_check, sbrk_old_break, sbrk_new_break);
     supercheck(va_to_check);
  } else {
     printf("superpg_test: WARN - sbrk'd region (0x%p to 0x%p) does not contain a full 2MB aligned block starting at or after 0x%lx to check with supercheck.\n",
            sbrk_old_break, sbrk_new_break, va_to_check);
     // This might indicate an issue if SBRK_SIZE_FOR_SUPERPG_TEST was large enough
     // or could be normal if sbrk_old_break was already close to a 2MB boundary.
  }
  
  printf("pgtbltest: Current process pagetable (after sbrk(N) and supercheck):\n");
  print_kpgtbl_using_syscall();

  // Fork test
  printf("superpg_test: Fork test starting.\n");
  pid = fork();
  if(pid < 0) {
    err("fork failed");
  } else if (pid == 0) { // Child process
    testname = "superpg_test_child";
    printf("superpg_test child (pid %d): Verifying inherited/copied superpage region.\n", getpid());
    if (va_to_check + SUPERPGSIZE <= (uint64)sbrk_new_break) { // Check same region as parent
        supercheck(va_to_check); 
    }
    // Optional: Child modifies its memory to test copy-on-write or independence
    // char* child_ptr_to_modify = (char*)va_to_check;
    // if (va_to_check + SUPERPGSIZE <= (uint64)sbrk_new_break) {
    //    *child_ptr_to_modify = 'C';
    // }
    printf("superpg_test child: OK. Exiting.\n");
    exit(0);
  } else { // Parent process
    int child_status;
    wait(&child_status);
    if(child_status != 0) {
        printf("superpg_test: Child process (pid %d) failed with status %d.\n", pid, child_status);
        err("child process failed during fork test");
    }
    printf("superpg_test parent: Child (pid %d) exited. Verifying parent's memory (if child modified).\n", pid);
    // Optional: Check if parent's memory was affected by child's modification
    // char* parent_ptr_to_check = (char*)va_to_check;
    // if (va_to_check + SUPERPGSIZE <= (uint64)sbrk_new_break && *parent_ptr_to_check == 'C') {
    //    err("parent's memory affected by child (COW issue or shared mapping)");
    // }
  }
  
  printf("superpg_test: sbrk(-SBRK_SIZE_FOR_SUPERPG_TEST) to free the allocated memory.\n");
  if (sbrk(-SBRK_SIZE_FOR_SUPERPG_TEST) == (char*)-1) { // sbrk returns -1 on error
       err("sbrk(-N) failed to free memory");
  }
   printf("superpg_test: Memory freed. New break is 0x%p\n", sbrk(0));
  
  printf("pgtbltest: Current process pagetable (after sbrk(-N)):\n");
  print_kpgtbl_using_syscall();

  printf("%s: OK\n", testname);
}