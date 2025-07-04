// struct buf {
//   int valid;   // has data been read from disk?
//   int disk;    // does disk "own" buf?
//   uint dev;
//   uint blockno;
//   struct sleeplock lock;
//   uint refcnt;
//   struct buf *prev; // LRU cache list
//   struct buf *next;
//   uchar data[BSIZE];
// };

// 将 struct buf 修改为:
struct buf {
  int valid;   // has data been read from disk?
  int disk;    // does disk block need to be written?
  uint dev;
  uint blockno;
  struct sleeplock lock;
  uint refcnt;
  struct buf *prev; // for doubly-linked list
  struct buf *next;
  uchar data[BSIZE];
};