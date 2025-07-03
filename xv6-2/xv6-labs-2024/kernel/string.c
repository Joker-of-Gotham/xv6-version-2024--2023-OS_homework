#include "types.h"

void*
memset(void *dst, int c, uint n)
{
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    cdst[i] = c;
  }
  return dst;
}

int
memcmp(const void *v1, const void *v2, uint n)
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}

void*
memmove(void *dst, const void *src, uint n)
{
  const char *s;
  char *d;

  if(n == 0)
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  char *os;

  os = s;
  if(n <= 0)
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    ;
  *s = 0;
  return os;
}

int
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
    ;
  return n;
}

// 辅助函数，反转字符串
// s: 要反转的字符串
// len: 字符串的有效长度 (不包括末尾的 \0，如果已添加)
void k_strrev(char *s, int len) {
  for (int i = 0; i < len / 2; i++) {
      char t = s[i];
      s[i] = s[len - 1 - i];
      s[len - 1 - i] = t;
  }
}

// 简化版 itoa (整数转ASCII字符串)
// n: 要转换的整数
// s: 存储结果的字符缓冲区
// base: 转换的基数 (通常是10)
// 返回转换后的字符串长度 (不包括末尾的 \0)
int k_itoa(long long val, char *s, int base) {
  int i = 0;
  int sign = 0;
  unsigned long long n;

  if (val == 0) {
      s[i++] = '0';
      s[i] = '\0';
      return 1;
  }

  if (val < 0 && base == 10) {
      sign = 1;
      n = -val;
  } else {
      n = val;
  }

  while (n != 0) {
      int rem = n % base;
      s[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
      n = n / base;
  }

  if (sign) {
      s[i++] = '-';
  }
  s[i] = '\0'; // Null terminate
  k_strrev(s, i); // 反转字符串，因为数字是反向生成的
  return i;       // 返回长度
}