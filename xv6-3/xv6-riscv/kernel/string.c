#include "types.h"
#include "stdarg.h"

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

int
ksnprintf(char *buf, int size, const char *fmt, ...)
{
  va_list ap;
  char *p = buf;
  char *end = buf + size - 1;

  va_start(ap, fmt);
  
  for (; *fmt && p < end; fmt++) {
    if (*fmt != '%') {
      *p++ = *fmt;
      continue;
    }

    fmt++;
    if (*fmt == '\0') break;

    switch (*fmt) {
    case 'd': {
      int val = va_arg(ap, int);
      // 使用一个临时的小缓冲区来转换数字
      char num_buf[12];
      int i = sizeof(num_buf) - 1;
      num_buf[i--] = '\0';
      int is_neg = val < 0;
      if (is_neg) val = -val;

      do {
        num_buf[i--] = (val % 10) + '0';
        val /= 10;
      } while (val > 0);
      
      if (is_neg) num_buf[i--] = '-';

      char *num_start = &num_buf[i + 1];
      while (*num_start && p < end) {
        *p++ = *num_start++;
      }
      break;
    }
    case 's': {
      char *s = va_arg(ap, char *);
      if (!s) s = "(null)";
      while (*s && p < end) {
        *p++ = *s++;
      }
      break;
    }
    case 'p': {
      uint64 addr = va_arg(ap, uint64);
      *p++ = '0';
      *p++ = 'x';
      for (int i = 15; i >= 0 && p < end; i--) {
        int digit = (addr >> (i * 4)) & 0xF;
        *p++ = "0123456789abcdef"[digit];
      }
      break;
    }
    case '%':
      *p++ = '%';
      break;
    default:
      *p++ = '%';
      if(p < end) *p++ = *fmt;
      break;
    }
  }

  *p = '\0'; // 确保字符串以空字符结尾
  va_end(ap);

  return p - buf;
}