#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

#define NBUCKETS 13 // A prime number for better hash distribution

struct {
  struct spinlock locks[NBUCKETS];
  struct buf buf[NBUF];

  // Each bucket has a sentinel head for its doubly-linked list of bufs.
  struct buf buckets[NBUCKETS]; 
} bcache;

// Hash function to map a block number to a bucket index.
static inline int
hash(uint blockno)
{
  return blockno % NBUCKETS;
}

void
binit(void)
{
  char lock_name[20];

  // Initialize bucket locks and sentinel list heads.
  for (int i = 0; i < NBUCKETS; i++) {
    // Use ksnprintf, the kernel's version of snprintf
    ksnprintf(lock_name, sizeof(lock_name), "bcache.bucket"); 
    initlock(&bcache.locks[i], lock_name);
    // Initialize sentinel head for the doubly-linked list.
    bcache.buckets[i].prev = &bcache.buckets[i];
    bcache.buckets[i].next = &bcache.buckets[i];
  }

  // Add all buffers to the first bucket's list initially.
  for(struct buf *b = bcache.buf; b < bcache.buf + NBUF; b++){
    initsleeplock(&b->lock, "buffer");
    b->next = bcache.buckets[0].next;
    b->prev = &bcache.buckets[0];
    bcache.buckets[0].next->prev = b;
    bcache.buckets[0].next = b;
  }
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;
  int idx = hash(blockno);

restart:
  // Fast path: Check if the block is already in the cache.
  acquire(&bcache.locks[idx]);
  for(b = bcache.buckets[idx].next; b != &bcache.buckets[idx]; b = b->next){
    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;
      release(&bcache.locks[idx]);
      acquiresleep(&b->lock);
      return b;
    }
  }
  release(&bcache.locks[idx]);

  // Slow path: Not cached. Need to find a free buffer (victim).
  // We must not hold any bucket locks while searching for a victim
  // across buckets to avoid deadlock.
  
  for (int i = 0; i < NBUCKETS; i++) {
    acquire(&bcache.locks[i]);
    for (b = bcache.buckets[i].next; b != &bcache.buckets[i]; b = b->next) {
      if (b->refcnt == 0) {
        // Found a victim. Claim it.
        // We are holding the lock for the victim's current bucket (`i`).
        b->refcnt = 1;
        b->dev = dev;
        b->blockno = blockno;
        b->valid = 0;
        
        // If the victim is not in the correct bucket for its new blockno, move it.
        if (i != idx) {
          // Unlink from the old bucket's list (bucket `i`).
          b->prev->next = b->next;
          b->next->prev = b->prev;
          release(&bcache.locks[i]);

          // Link to the new bucket's list (bucket `idx`).
          acquire(&bcache.locks[idx]);
          b->next = bcache.buckets[idx].next;
          b->prev = &bcache.buckets[idx];
          bcache.buckets[idx].next->prev = b;
          bcache.buckets[idx].next = b;
          release(&bcache.locks[idx]);
        } else {
          // Victim was already in the correct bucket. Just release the lock.
          release(&bcache.locks[i]);
        }
        
        acquiresleep(&b->lock);
        return b;
      }
    }
    // No victim in this bucket, release lock and try next one.
    release(&bcache.locks[i]);
  }

  // It's possible that after we started our search, all buffers became referenced.
  // In a real system, we might sleep and wait. Here, we retry, which is a simple
  // and effective strategy for this lab.
  goto restart; 
  // A panic("bget: no buffers") would also be reasonable if retrying is not desired.
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk. Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);

  int idx = hash(b->blockno);
  acquire(&bcache.locks[idx]);
  b->refcnt--;
  release(&bcache.locks[idx]);
}

// Pin a buffer, incrementing its reference count.
void
bpin(struct buf *b) {
  int idx = hash(b->blockno);
  acquire(&bcache.locks[idx]);
  b->refcnt++;
  release(&bcache.locks[idx]);
}

// Unpin a buffer, decrementing its reference count.
void
bunpin(struct buf *b) {
  int idx = hash(b->blockno);
  acquire(&bcache.locks[idx]);
  b->refcnt--;
  release(&bcache.locks[idx]);
}