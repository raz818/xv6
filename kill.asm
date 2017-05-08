
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "usage: kill pid...\n");
   f:	c7 44 24 04 9e 0a 00 	movl   $0xa9e,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 af 06 00 00       	call   6d2 <printf>
    exit();
  23:	e8 1a 05 00 00       	call   542 <exit>
  }
  for(i=1; i<argc; i++)
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 27                	jmp    59 <main+0x59>
    kill(atoi(argv[i]));
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 28 02 00 00       	call   274 <atoi>
  4c:	89 04 24             	mov    %eax,(%esp)
  4f:	e8 1e 05 00 00       	call   572 <kill>

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  54:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  59:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5d:	3b 45 08             	cmp    0x8(%ebp),%eax
  60:	7c d0                	jl     32 <main+0x32>
    kill(atoi(argv[i]));
  exit();
  62:	e8 db 04 00 00       	call   542 <exit>

00000067 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  67:	55                   	push   %ebp
  68:	89 e5                	mov    %esp,%ebp
  6a:	57                   	push   %edi
  6b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6f:	8b 55 10             	mov    0x10(%ebp),%edx
  72:	8b 45 0c             	mov    0xc(%ebp),%eax
  75:	89 cb                	mov    %ecx,%ebx
  77:	89 df                	mov    %ebx,%edi
  79:	89 d1                	mov    %edx,%ecx
  7b:	fc                   	cld    
  7c:	f3 aa                	rep stos %al,%es:(%edi)
  7e:	89 ca                	mov    %ecx,%edx
  80:	89 fb                	mov    %edi,%ebx
  82:	89 5d 08             	mov    %ebx,0x8(%ebp)
  85:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  88:	5b                   	pop    %ebx
  89:	5f                   	pop    %edi
  8a:	5d                   	pop    %ebp
  8b:	c3                   	ret    

0000008c <thing>:
#include "user.h"
#include "x86.h"


int
thing(void){
  8c:	55                   	push   %ebp
  8d:	89 e5                	mov    %esp,%ebp
  return 1;
  8f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  94:	5d                   	pop    %ebp
  95:	c3                   	ret    

00000096 <strcpy>:

char*
strcpy(char *s, char *t)
{
  96:	55                   	push   %ebp
  97:	89 e5                	mov    %esp,%ebp
  99:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9c:	8b 45 08             	mov    0x8(%ebp),%eax
  9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a2:	90                   	nop
  a3:	8b 45 08             	mov    0x8(%ebp),%eax
  a6:	8d 50 01             	lea    0x1(%eax),%edx
  a9:	89 55 08             	mov    %edx,0x8(%ebp)
  ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  af:	8d 4a 01             	lea    0x1(%edx),%ecx
  b2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b5:	0f b6 12             	movzbl (%edx),%edx
  b8:	88 10                	mov    %dl,(%eax)
  ba:	0f b6 00             	movzbl (%eax),%eax
  bd:	84 c0                	test   %al,%al
  bf:	75 e2                	jne    a3 <strcpy+0xd>
    ;
  return os;
  c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c4:	c9                   	leave  
  c5:	c3                   	ret    

000000c6 <strcmp>:



int
strcmp(const char *p, const char *q)
{
  c6:	55                   	push   %ebp
  c7:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c9:	eb 08                	jmp    d3 <strcmp+0xd>
    p++, q++;
  cb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  cf:	83 45 0c 01          	addl   $0x1,0xc(%ebp)


int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	0f b6 00             	movzbl (%eax),%eax
  d9:	84 c0                	test   %al,%al
  db:	74 10                	je     ed <strcmp+0x27>
  dd:	8b 45 08             	mov    0x8(%ebp),%eax
  e0:	0f b6 10             	movzbl (%eax),%edx
  e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  e6:	0f b6 00             	movzbl (%eax),%eax
  e9:	38 c2                	cmp    %al,%dl
  eb:	74 de                	je     cb <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  ed:	8b 45 08             	mov    0x8(%ebp),%eax
  f0:	0f b6 00             	movzbl (%eax),%eax
  f3:	0f b6 d0             	movzbl %al,%edx
  f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  f9:	0f b6 00             	movzbl (%eax),%eax
  fc:	0f b6 c0             	movzbl %al,%eax
  ff:	29 c2                	sub    %eax,%edx
 101:	89 d0                	mov    %edx,%eax
}
 103:	5d                   	pop    %ebp
 104:	c3                   	ret    

00000105 <strlen>:

uint
strlen(char *s)
{
 105:	55                   	push   %ebp
 106:	89 e5                	mov    %esp,%ebp
 108:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 112:	eb 04                	jmp    118 <strlen+0x13>
 114:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 118:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	01 d0                	add    %edx,%eax
 120:	0f b6 00             	movzbl (%eax),%eax
 123:	84 c0                	test   %al,%al
 125:	75 ed                	jne    114 <strlen+0xf>
    ;
  return n;
 127:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12a:	c9                   	leave  
 12b:	c3                   	ret    

0000012c <stringlen>:

uint
stringlen(char **s){
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
 12f:	83 ec 10             	sub    $0x10,%esp
	int n;

  for(n = 0; s[n]; n++)
 132:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 139:	eb 04                	jmp    13f <stringlen+0x13>
 13b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 13f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 142:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 149:	8b 45 08             	mov    0x8(%ebp),%eax
 14c:	01 d0                	add    %edx,%eax
 14e:	8b 00                	mov    (%eax),%eax
 150:	85 c0                	test   %eax,%eax
 152:	75 e7                	jne    13b <stringlen+0xf>
    ;
  return n;
 154:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 157:	c9                   	leave  
 158:	c3                   	ret    

00000159 <memset>:

void*
memset(void *dst, int c, uint n)
{
 159:	55                   	push   %ebp
 15a:	89 e5                	mov    %esp,%ebp
 15c:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 15f:	8b 45 10             	mov    0x10(%ebp),%eax
 162:	89 44 24 08          	mov    %eax,0x8(%esp)
 166:	8b 45 0c             	mov    0xc(%ebp),%eax
 169:	89 44 24 04          	mov    %eax,0x4(%esp)
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	89 04 24             	mov    %eax,(%esp)
 173:	e8 ef fe ff ff       	call   67 <stosb>
  return dst;
 178:	8b 45 08             	mov    0x8(%ebp),%eax
}
 17b:	c9                   	leave  
 17c:	c3                   	ret    

0000017d <strchr>:

char*
strchr(const char *s, char c)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	83 ec 04             	sub    $0x4,%esp
 183:	8b 45 0c             	mov    0xc(%ebp),%eax
 186:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 189:	eb 14                	jmp    19f <strchr+0x22>
    if(*s == c)
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	0f b6 00             	movzbl (%eax),%eax
 191:	3a 45 fc             	cmp    -0x4(%ebp),%al
 194:	75 05                	jne    19b <strchr+0x1e>
      return (char*)s;
 196:	8b 45 08             	mov    0x8(%ebp),%eax
 199:	eb 13                	jmp    1ae <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 19b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
 1a2:	0f b6 00             	movzbl (%eax),%eax
 1a5:	84 c0                	test   %al,%al
 1a7:	75 e2                	jne    18b <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1ae:	c9                   	leave  
 1af:	c3                   	ret    

000001b0 <gets>:

char*
gets(char *buf, int max)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1bd:	eb 4c                	jmp    20b <gets+0x5b>
    cc = read(0, &c, 1);
 1bf:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1c6:	00 
 1c7:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1d5:	e8 80 03 00 00       	call   55a <read>
 1da:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1e1:	7f 02                	jg     1e5 <gets+0x35>
      break;
 1e3:	eb 31                	jmp    216 <gets+0x66>
    buf[i++] = c;
 1e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e8:	8d 50 01             	lea    0x1(%eax),%edx
 1eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1ee:	89 c2                	mov    %eax,%edx
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	01 c2                	add    %eax,%edx
 1f5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f9:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1fb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ff:	3c 0a                	cmp    $0xa,%al
 201:	74 13                	je     216 <gets+0x66>
 203:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 207:	3c 0d                	cmp    $0xd,%al
 209:	74 0b                	je     216 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 20e:	83 c0 01             	add    $0x1,%eax
 211:	3b 45 0c             	cmp    0xc(%ebp),%eax
 214:	7c a9                	jl     1bf <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 216:	8b 55 f4             	mov    -0xc(%ebp),%edx
 219:	8b 45 08             	mov    0x8(%ebp),%eax
 21c:	01 d0                	add    %edx,%eax
 21e:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 221:	8b 45 08             	mov    0x8(%ebp),%eax
}
 224:	c9                   	leave  
 225:	c3                   	ret    

00000226 <stat>:

int
stat(char *n, struct stat *st)
{
 226:	55                   	push   %ebp
 227:	89 e5                	mov    %esp,%ebp
 229:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 233:	00 
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	89 04 24             	mov    %eax,(%esp)
 23a:	e8 43 03 00 00       	call   582 <open>
 23f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 242:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 246:	79 07                	jns    24f <stat+0x29>
    return -1;
 248:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 24d:	eb 23                	jmp    272 <stat+0x4c>
  r = fstat(fd, st);
 24f:	8b 45 0c             	mov    0xc(%ebp),%eax
 252:	89 44 24 04          	mov    %eax,0x4(%esp)
 256:	8b 45 f4             	mov    -0xc(%ebp),%eax
 259:	89 04 24             	mov    %eax,(%esp)
 25c:	e8 39 03 00 00       	call   59a <fstat>
 261:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 264:	8b 45 f4             	mov    -0xc(%ebp),%eax
 267:	89 04 24             	mov    %eax,(%esp)
 26a:	e8 fb 02 00 00       	call   56a <close>
  return r;
 26f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 272:	c9                   	leave  
 273:	c3                   	ret    

00000274 <atoi>:

int
atoi(const char *s)
{
 274:	55                   	push   %ebp
 275:	89 e5                	mov    %esp,%ebp
 277:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 27a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 281:	eb 25                	jmp    2a8 <atoi+0x34>
    n = n*10 + *s++ - '0';
 283:	8b 55 fc             	mov    -0x4(%ebp),%edx
 286:	89 d0                	mov    %edx,%eax
 288:	c1 e0 02             	shl    $0x2,%eax
 28b:	01 d0                	add    %edx,%eax
 28d:	01 c0                	add    %eax,%eax
 28f:	89 c1                	mov    %eax,%ecx
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	8d 50 01             	lea    0x1(%eax),%edx
 297:	89 55 08             	mov    %edx,0x8(%ebp)
 29a:	0f b6 00             	movzbl (%eax),%eax
 29d:	0f be c0             	movsbl %al,%eax
 2a0:	01 c8                	add    %ecx,%eax
 2a2:	83 e8 30             	sub    $0x30,%eax
 2a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	0f b6 00             	movzbl (%eax),%eax
 2ae:	3c 2f                	cmp    $0x2f,%al
 2b0:	7e 0a                	jle    2bc <atoi+0x48>
 2b2:	8b 45 08             	mov    0x8(%ebp),%eax
 2b5:	0f b6 00             	movzbl (%eax),%eax
 2b8:	3c 39                	cmp    $0x39,%al
 2ba:	7e c7                	jle    283 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2bf:	c9                   	leave  
 2c0:	c3                   	ret    

000002c1 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2c1:	55                   	push   %ebp
 2c2:	89 e5                	mov    %esp,%ebp
 2c4:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2d3:	eb 17                	jmp    2ec <memmove+0x2b>
    *dst++ = *src++;
 2d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2d8:	8d 50 01             	lea    0x1(%eax),%edx
 2db:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2de:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2e1:	8d 4a 01             	lea    0x1(%edx),%ecx
 2e4:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2e7:	0f b6 12             	movzbl (%edx),%edx
 2ea:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ec:	8b 45 10             	mov    0x10(%ebp),%eax
 2ef:	8d 50 ff             	lea    -0x1(%eax),%edx
 2f2:	89 55 10             	mov    %edx,0x10(%ebp)
 2f5:	85 c0                	test   %eax,%eax
 2f7:	7f dc                	jg     2d5 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2fc:	c9                   	leave  
 2fd:	c3                   	ret    

000002fe <strcmp_c>:


int
strcmp_c(const char *s1, const char *s2)
{
 2fe:	55                   	push   %ebp
 2ff:	89 e5                	mov    %esp,%ebp
    for ( ; *s1 == *s2; s1++, s2++)
 301:	eb 19                	jmp    31c <strcmp_c+0x1e>
	if (*s1 == '\0')
 303:	8b 45 08             	mov    0x8(%ebp),%eax
 306:	0f b6 00             	movzbl (%eax),%eax
 309:	84 c0                	test   %al,%al
 30b:	75 07                	jne    314 <strcmp_c+0x16>
	    return 0;
 30d:	b8 00 00 00 00       	mov    $0x0,%eax
 312:	eb 34                	jmp    348 <strcmp_c+0x4a>


int
strcmp_c(const char *s1, const char *s2)
{
    for ( ; *s1 == *s2; s1++, s2++)
 314:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 318:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 31c:	8b 45 08             	mov    0x8(%ebp),%eax
 31f:	0f b6 10             	movzbl (%eax),%edx
 322:	8b 45 0c             	mov    0xc(%ebp),%eax
 325:	0f b6 00             	movzbl (%eax),%eax
 328:	38 c2                	cmp    %al,%dl
 32a:	74 d7                	je     303 <strcmp_c+0x5>
	if (*s1 == '\0')
	    return 0;
    return ((*(unsigned char *)s1 < *(unsigned char *)s2) ? -1 : +1);
 32c:	8b 45 08             	mov    0x8(%ebp),%eax
 32f:	0f b6 10             	movzbl (%eax),%edx
 332:	8b 45 0c             	mov    0xc(%ebp),%eax
 335:	0f b6 00             	movzbl (%eax),%eax
 338:	38 c2                	cmp    %al,%dl
 33a:	73 07                	jae    343 <strcmp_c+0x45>
 33c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 341:	eb 05                	jmp    348 <strcmp_c+0x4a>
 343:	b8 01 00 00 00       	mov    $0x1,%eax
}
 348:	5d                   	pop    %ebp
 349:	c3                   	ret    

0000034a <readuser>:


struct USER
readuser(){
 34a:	55                   	push   %ebp
 34b:	89 e5                	mov    %esp,%ebp
 34d:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char buff1[512], buff2[512];
	struct USER u;
	printf(1,"Please enter a username: ");
 353:	c7 44 24 04 b2 0a 00 	movl   $0xab2,0x4(%esp)
 35a:	00 
 35b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 362:	e8 6b 03 00 00       	call   6d2 <printf>
	u.name = gets(buff1, 50);
 367:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 36e:	00 
 36f:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
 375:	89 04 24             	mov    %eax,(%esp)
 378:	e8 33 fe ff ff       	call   1b0 <gets>
 37d:	89 85 ec fb ff ff    	mov    %eax,-0x414(%ebp)
	printf(1,"Please enter a password: ");
 383:	c7 44 24 04 cc 0a 00 	movl   $0xacc,0x4(%esp)
 38a:	00 
 38b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 392:	e8 3b 03 00 00       	call   6d2 <printf>
	u.pass = gets(buff2, 50);
 397:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 39e:	00 
 39f:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
 3a5:	89 04 24             	mov    %eax,(%esp)
 3a8:	e8 03 fe ff ff       	call   1b0 <gets>
 3ad:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
	return u;
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	8b 95 ec fb ff ff    	mov    -0x414(%ebp),%edx
 3bc:	89 10                	mov    %edx,(%eax)
 3be:	8b 95 f0 fb ff ff    	mov    -0x410(%ebp),%edx
 3c4:	89 50 04             	mov    %edx,0x4(%eax)
 3c7:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
 3cd:	89 50 08             	mov    %edx,0x8(%eax)
}
 3d0:	8b 45 08             	mov    0x8(%ebp),%eax
 3d3:	c9                   	leave  
 3d4:	c2 04 00             	ret    $0x4

000003d7 <compareuser>:


int
compareuser(int state){
 3d7:	55                   	push   %ebp
 3d8:	89 e5                	mov    %esp,%ebp
 3da:	56                   	push   %esi
 3db:	53                   	push   %ebx
 3dc:	81 ec 30 01 00 00    	sub    $0x130,%esp
	struct USER u1,u2;
	struct USER users[20];
	u1.name = "john\n";
 3e2:	c7 45 e8 e6 0a 00 00 	movl   $0xae6,-0x18(%ebp)
	u1.pass = "1234\n";
 3e9:	c7 45 ec ec 0a 00 00 	movl   $0xaec,-0x14(%ebp)
	u1.ulevel = 0;
 3f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	u2.name = "james\n";
 3f7:	c7 45 dc f2 0a 00 00 	movl   $0xaf2,-0x24(%ebp)
	u2.pass = "pass\n";
 3fe:	c7 45 e0 f9 0a 00 00 	movl   $0xaf9,-0x20(%ebp)
	u2.ulevel = 1;
 405:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	users[0] = u1;
 40c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 40f:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
 415:	8b 45 ec             	mov    -0x14(%ebp),%eax
 418:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
 41e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 421:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
	users[1] = u2;
 427:	8b 45 dc             	mov    -0x24(%ebp),%eax
 42a:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
 430:	8b 45 e0             	mov    -0x20(%ebp),%eax
 433:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
 439:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 43c:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
	
	
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
 442:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
 448:	89 04 24             	mov    %eax,(%esp)
 44b:	e8 fa fe ff ff       	call   34a <readuser>
 450:	83 ec 04             	sub    $0x4,%esp
		
		for(ctr = 0; ctr < 20; ctr++)
 453:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 45a:	e9 a4 00 00 00       	jmp    503 <compareuser+0x12c>
		{

			if(strcmp_c(u.name,users[ctr].name) == 0 && strcmp_c(u.pass,users[ctr].pass) == 0)
 45f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 462:	89 d0                	mov    %edx,%eax
 464:	01 c0                	add    %eax,%eax
 466:	01 d0                	add    %edx,%eax
 468:	c1 e0 02             	shl    $0x2,%eax
 46b:	8d 4d f8             	lea    -0x8(%ebp),%ecx
 46e:	01 c8                	add    %ecx,%eax
 470:	2d 0c 01 00 00       	sub    $0x10c,%eax
 475:	8b 10                	mov    (%eax),%edx
 477:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
 47d:	89 54 24 04          	mov    %edx,0x4(%esp)
 481:	89 04 24             	mov    %eax,(%esp)
 484:	e8 75 fe ff ff       	call   2fe <strcmp_c>
 489:	85 c0                	test   %eax,%eax
 48b:	75 72                	jne    4ff <compareuser+0x128>
 48d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 490:	89 d0                	mov    %edx,%eax
 492:	01 c0                	add    %eax,%eax
 494:	01 d0                	add    %edx,%eax
 496:	c1 e0 02             	shl    $0x2,%eax
 499:	8d 5d f8             	lea    -0x8(%ebp),%ebx
 49c:	01 d8                	add    %ebx,%eax
 49e:	2d 08 01 00 00       	sub    $0x108,%eax
 4a3:	8b 10                	mov    (%eax),%edx
 4a5:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
 4ab:	89 54 24 04          	mov    %edx,0x4(%esp)
 4af:	89 04 24             	mov    %eax,(%esp)
 4b2:	e8 47 fe ff ff       	call   2fe <strcmp_c>
 4b7:	85 c0                	test   %eax,%eax
 4b9:	75 44                	jne    4ff <compareuser+0x128>
			{
				setuser(users[ctr].ulevel);
 4bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4be:	89 d0                	mov    %edx,%eax
 4c0:	01 c0                	add    %eax,%eax
 4c2:	01 d0                	add    %edx,%eax
 4c4:	c1 e0 02             	shl    $0x2,%eax
 4c7:	8d 75 f8             	lea    -0x8(%ebp),%esi
 4ca:	01 f0                	add    %esi,%eax
 4cc:	2d 04 01 00 00       	sub    $0x104,%eax
 4d1:	8b 00                	mov    (%eax),%eax
 4d3:	89 04 24             	mov    %eax,(%esp)
 4d6:	e8 0f 01 00 00       	call   5ea <setuser>
				
				printf(1,"%d",getuser());
 4db:	e8 02 01 00 00       	call   5e2 <getuser>
 4e0:	89 44 24 08          	mov    %eax,0x8(%esp)
 4e4:	c7 44 24 04 ff 0a 00 	movl   $0xaff,0x4(%esp)
 4eb:	00 
 4ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4f3:	e8 da 01 00 00       	call   6d2 <printf>
				return 1;
 4f8:	b8 01 00 00 00       	mov    $0x1,%eax
 4fd:	eb 34                	jmp    533 <compareuser+0x15c>
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
		
		for(ctr = 0; ctr < 20; ctr++)
 4ff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 503:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 507:	0f 8e 52 ff ff ff    	jle    45f <compareuser+0x88>
				
				printf(1,"%d",getuser());
				return 1;
			}
		}
		printf(1,"Invalid username/password\n");
 50d:	c7 44 24 04 02 0b 00 	movl   $0xb02,0x4(%esp)
 514:	00 
 515:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 51c:	e8 b1 01 00 00       	call   6d2 <printf>
		if(state != 1)
 521:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 525:	74 07                	je     52e <compareuser+0x157>
			break;
	}
	return 0;
 527:	b8 00 00 00 00       	mov    $0x0,%eax
 52c:	eb 05                	jmp    533 <compareuser+0x15c>
			}
		}
		printf(1,"Invalid username/password\n");
		if(state != 1)
			break;
	}
 52e:	e9 0f ff ff ff       	jmp    442 <compareuser+0x6b>
	return 0;
}
 533:	8d 65 f8             	lea    -0x8(%ebp),%esp
 536:	5b                   	pop    %ebx
 537:	5e                   	pop    %esi
 538:	5d                   	pop    %ebp
 539:	c3                   	ret    

0000053a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 53a:	b8 01 00 00 00       	mov    $0x1,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <exit>:
SYSCALL(exit)
 542:	b8 02 00 00 00       	mov    $0x2,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <wait>:
SYSCALL(wait)
 54a:	b8 03 00 00 00       	mov    $0x3,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <pipe>:
SYSCALL(pipe)
 552:	b8 04 00 00 00       	mov    $0x4,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <read>:
SYSCALL(read)
 55a:	b8 05 00 00 00       	mov    $0x5,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <write>:
SYSCALL(write)
 562:	b8 10 00 00 00       	mov    $0x10,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <close>:
SYSCALL(close)
 56a:	b8 15 00 00 00       	mov    $0x15,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <kill>:
SYSCALL(kill)
 572:	b8 06 00 00 00       	mov    $0x6,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <exec>:
SYSCALL(exec)
 57a:	b8 07 00 00 00       	mov    $0x7,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <open>:
SYSCALL(open)
 582:	b8 0f 00 00 00       	mov    $0xf,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <mknod>:
SYSCALL(mknod)
 58a:	b8 11 00 00 00       	mov    $0x11,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <unlink>:
SYSCALL(unlink)
 592:	b8 12 00 00 00       	mov    $0x12,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <fstat>:
SYSCALL(fstat)
 59a:	b8 08 00 00 00       	mov    $0x8,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <link>:
SYSCALL(link)
 5a2:	b8 13 00 00 00       	mov    $0x13,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <mkdir>:
SYSCALL(mkdir)
 5aa:	b8 14 00 00 00       	mov    $0x14,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <chdir>:
SYSCALL(chdir)
 5b2:	b8 09 00 00 00       	mov    $0x9,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <dup>:
SYSCALL(dup)
 5ba:	b8 0a 00 00 00       	mov    $0xa,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <getpid>:
SYSCALL(getpid)
 5c2:	b8 0b 00 00 00       	mov    $0xb,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <sbrk>:
SYSCALL(sbrk)
 5ca:	b8 0c 00 00 00       	mov    $0xc,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <sleep>:
SYSCALL(sleep)
 5d2:	b8 0d 00 00 00       	mov    $0xd,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <uptime>:
SYSCALL(uptime)
 5da:	b8 0e 00 00 00       	mov    $0xe,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <getuser>:
SYSCALL(getuser)
 5e2:	b8 16 00 00 00       	mov    $0x16,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <setuser>:
SYSCALL(setuser)
 5ea:	b8 17 00 00 00       	mov    $0x17,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5f2:	55                   	push   %ebp
 5f3:	89 e5                	mov    %esp,%ebp
 5f5:	83 ec 18             	sub    $0x18,%esp
 5f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 5fb:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5fe:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 605:	00 
 606:	8d 45 f4             	lea    -0xc(%ebp),%eax
 609:	89 44 24 04          	mov    %eax,0x4(%esp)
 60d:	8b 45 08             	mov    0x8(%ebp),%eax
 610:	89 04 24             	mov    %eax,(%esp)
 613:	e8 4a ff ff ff       	call   562 <write>
}
 618:	c9                   	leave  
 619:	c3                   	ret    

0000061a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 61a:	55                   	push   %ebp
 61b:	89 e5                	mov    %esp,%ebp
 61d:	56                   	push   %esi
 61e:	53                   	push   %ebx
 61f:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 622:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 629:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 62d:	74 17                	je     646 <printint+0x2c>
 62f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 633:	79 11                	jns    646 <printint+0x2c>
    neg = 1;
 635:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 63c:	8b 45 0c             	mov    0xc(%ebp),%eax
 63f:	f7 d8                	neg    %eax
 641:	89 45 ec             	mov    %eax,-0x14(%ebp)
 644:	eb 06                	jmp    64c <printint+0x32>
  } else {
    x = xx;
 646:	8b 45 0c             	mov    0xc(%ebp),%eax
 649:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 64c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 653:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 656:	8d 41 01             	lea    0x1(%ecx),%eax
 659:	89 45 f4             	mov    %eax,-0xc(%ebp)
 65c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 65f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 662:	ba 00 00 00 00       	mov    $0x0,%edx
 667:	f7 f3                	div    %ebx
 669:	89 d0                	mov    %edx,%eax
 66b:	0f b6 80 14 0e 00 00 	movzbl 0xe14(%eax),%eax
 672:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 676:	8b 75 10             	mov    0x10(%ebp),%esi
 679:	8b 45 ec             	mov    -0x14(%ebp),%eax
 67c:	ba 00 00 00 00       	mov    $0x0,%edx
 681:	f7 f6                	div    %esi
 683:	89 45 ec             	mov    %eax,-0x14(%ebp)
 686:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 68a:	75 c7                	jne    653 <printint+0x39>
  if(neg)
 68c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 690:	74 10                	je     6a2 <printint+0x88>
    buf[i++] = '-';
 692:	8b 45 f4             	mov    -0xc(%ebp),%eax
 695:	8d 50 01             	lea    0x1(%eax),%edx
 698:	89 55 f4             	mov    %edx,-0xc(%ebp)
 69b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6a0:	eb 1f                	jmp    6c1 <printint+0xa7>
 6a2:	eb 1d                	jmp    6c1 <printint+0xa7>
    putc(fd, buf[i]);
 6a4:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6aa:	01 d0                	add    %edx,%eax
 6ac:	0f b6 00             	movzbl (%eax),%eax
 6af:	0f be c0             	movsbl %al,%eax
 6b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b6:	8b 45 08             	mov    0x8(%ebp),%eax
 6b9:	89 04 24             	mov    %eax,(%esp)
 6bc:	e8 31 ff ff ff       	call   5f2 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6c1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6c9:	79 d9                	jns    6a4 <printint+0x8a>
    putc(fd, buf[i]);
}
 6cb:	83 c4 30             	add    $0x30,%esp
 6ce:	5b                   	pop    %ebx
 6cf:	5e                   	pop    %esi
 6d0:	5d                   	pop    %ebp
 6d1:	c3                   	ret    

000006d2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6d2:	55                   	push   %ebp
 6d3:	89 e5                	mov    %esp,%ebp
 6d5:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6d8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6df:	8d 45 0c             	lea    0xc(%ebp),%eax
 6e2:	83 c0 04             	add    $0x4,%eax
 6e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6ef:	e9 7c 01 00 00       	jmp    870 <printf+0x19e>
    c = fmt[i] & 0xff;
 6f4:	8b 55 0c             	mov    0xc(%ebp),%edx
 6f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6fa:	01 d0                	add    %edx,%eax
 6fc:	0f b6 00             	movzbl (%eax),%eax
 6ff:	0f be c0             	movsbl %al,%eax
 702:	25 ff 00 00 00       	and    $0xff,%eax
 707:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 70a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 70e:	75 2c                	jne    73c <printf+0x6a>
      if(c == '%'){
 710:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 714:	75 0c                	jne    722 <printf+0x50>
        state = '%';
 716:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 71d:	e9 4a 01 00 00       	jmp    86c <printf+0x19a>
      } else {
        putc(fd, c);
 722:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 725:	0f be c0             	movsbl %al,%eax
 728:	89 44 24 04          	mov    %eax,0x4(%esp)
 72c:	8b 45 08             	mov    0x8(%ebp),%eax
 72f:	89 04 24             	mov    %eax,(%esp)
 732:	e8 bb fe ff ff       	call   5f2 <putc>
 737:	e9 30 01 00 00       	jmp    86c <printf+0x19a>
      }
    } else if(state == '%'){
 73c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 740:	0f 85 26 01 00 00    	jne    86c <printf+0x19a>
      if(c == 'd'){
 746:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 74a:	75 2d                	jne    779 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 74c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 74f:	8b 00                	mov    (%eax),%eax
 751:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 758:	00 
 759:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 760:	00 
 761:	89 44 24 04          	mov    %eax,0x4(%esp)
 765:	8b 45 08             	mov    0x8(%ebp),%eax
 768:	89 04 24             	mov    %eax,(%esp)
 76b:	e8 aa fe ff ff       	call   61a <printint>
        ap++;
 770:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 774:	e9 ec 00 00 00       	jmp    865 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 779:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 77d:	74 06                	je     785 <printf+0xb3>
 77f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 783:	75 2d                	jne    7b2 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 785:	8b 45 e8             	mov    -0x18(%ebp),%eax
 788:	8b 00                	mov    (%eax),%eax
 78a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 791:	00 
 792:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 799:	00 
 79a:	89 44 24 04          	mov    %eax,0x4(%esp)
 79e:	8b 45 08             	mov    0x8(%ebp),%eax
 7a1:	89 04 24             	mov    %eax,(%esp)
 7a4:	e8 71 fe ff ff       	call   61a <printint>
        ap++;
 7a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7ad:	e9 b3 00 00 00       	jmp    865 <printf+0x193>
      } else if(c == 's'){
 7b2:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7b6:	75 45                	jne    7fd <printf+0x12b>
        s = (char*)*ap;
 7b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7bb:	8b 00                	mov    (%eax),%eax
 7bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7c0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7c8:	75 09                	jne    7d3 <printf+0x101>
          s = "(null)";
 7ca:	c7 45 f4 1d 0b 00 00 	movl   $0xb1d,-0xc(%ebp)
        while(*s != 0){
 7d1:	eb 1e                	jmp    7f1 <printf+0x11f>
 7d3:	eb 1c                	jmp    7f1 <printf+0x11f>
          putc(fd, *s);
 7d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d8:	0f b6 00             	movzbl (%eax),%eax
 7db:	0f be c0             	movsbl %al,%eax
 7de:	89 44 24 04          	mov    %eax,0x4(%esp)
 7e2:	8b 45 08             	mov    0x8(%ebp),%eax
 7e5:	89 04 24             	mov    %eax,(%esp)
 7e8:	e8 05 fe ff ff       	call   5f2 <putc>
          s++;
 7ed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f4:	0f b6 00             	movzbl (%eax),%eax
 7f7:	84 c0                	test   %al,%al
 7f9:	75 da                	jne    7d5 <printf+0x103>
 7fb:	eb 68                	jmp    865 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7fd:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 801:	75 1d                	jne    820 <printf+0x14e>
        putc(fd, *ap);
 803:	8b 45 e8             	mov    -0x18(%ebp),%eax
 806:	8b 00                	mov    (%eax),%eax
 808:	0f be c0             	movsbl %al,%eax
 80b:	89 44 24 04          	mov    %eax,0x4(%esp)
 80f:	8b 45 08             	mov    0x8(%ebp),%eax
 812:	89 04 24             	mov    %eax,(%esp)
 815:	e8 d8 fd ff ff       	call   5f2 <putc>
        ap++;
 81a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 81e:	eb 45                	jmp    865 <printf+0x193>
      } else if(c == '%'){
 820:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 824:	75 17                	jne    83d <printf+0x16b>
        putc(fd, c);
 826:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 829:	0f be c0             	movsbl %al,%eax
 82c:	89 44 24 04          	mov    %eax,0x4(%esp)
 830:	8b 45 08             	mov    0x8(%ebp),%eax
 833:	89 04 24             	mov    %eax,(%esp)
 836:	e8 b7 fd ff ff       	call   5f2 <putc>
 83b:	eb 28                	jmp    865 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 83d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 844:	00 
 845:	8b 45 08             	mov    0x8(%ebp),%eax
 848:	89 04 24             	mov    %eax,(%esp)
 84b:	e8 a2 fd ff ff       	call   5f2 <putc>
        putc(fd, c);
 850:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 853:	0f be c0             	movsbl %al,%eax
 856:	89 44 24 04          	mov    %eax,0x4(%esp)
 85a:	8b 45 08             	mov    0x8(%ebp),%eax
 85d:	89 04 24             	mov    %eax,(%esp)
 860:	e8 8d fd ff ff       	call   5f2 <putc>
      }
      state = 0;
 865:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 86c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 870:	8b 55 0c             	mov    0xc(%ebp),%edx
 873:	8b 45 f0             	mov    -0x10(%ebp),%eax
 876:	01 d0                	add    %edx,%eax
 878:	0f b6 00             	movzbl (%eax),%eax
 87b:	84 c0                	test   %al,%al
 87d:	0f 85 71 fe ff ff    	jne    6f4 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 883:	c9                   	leave  
 884:	c3                   	ret    

00000885 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 885:	55                   	push   %ebp
 886:	89 e5                	mov    %esp,%ebp
 888:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 88b:	8b 45 08             	mov    0x8(%ebp),%eax
 88e:	83 e8 08             	sub    $0x8,%eax
 891:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 894:	a1 30 0e 00 00       	mov    0xe30,%eax
 899:	89 45 fc             	mov    %eax,-0x4(%ebp)
 89c:	eb 24                	jmp    8c2 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 89e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a1:	8b 00                	mov    (%eax),%eax
 8a3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8a6:	77 12                	ja     8ba <free+0x35>
 8a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ab:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ae:	77 24                	ja     8d4 <free+0x4f>
 8b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b3:	8b 00                	mov    (%eax),%eax
 8b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8b8:	77 1a                	ja     8d4 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bd:	8b 00                	mov    (%eax),%eax
 8bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8c8:	76 d4                	jbe    89e <free+0x19>
 8ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cd:	8b 00                	mov    (%eax),%eax
 8cf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8d2:	76 ca                	jbe    89e <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d7:	8b 40 04             	mov    0x4(%eax),%eax
 8da:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e4:	01 c2                	add    %eax,%edx
 8e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e9:	8b 00                	mov    (%eax),%eax
 8eb:	39 c2                	cmp    %eax,%edx
 8ed:	75 24                	jne    913 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f2:	8b 50 04             	mov    0x4(%eax),%edx
 8f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f8:	8b 00                	mov    (%eax),%eax
 8fa:	8b 40 04             	mov    0x4(%eax),%eax
 8fd:	01 c2                	add    %eax,%edx
 8ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 902:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 905:	8b 45 fc             	mov    -0x4(%ebp),%eax
 908:	8b 00                	mov    (%eax),%eax
 90a:	8b 10                	mov    (%eax),%edx
 90c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90f:	89 10                	mov    %edx,(%eax)
 911:	eb 0a                	jmp    91d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 913:	8b 45 fc             	mov    -0x4(%ebp),%eax
 916:	8b 10                	mov    (%eax),%edx
 918:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 91d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 920:	8b 40 04             	mov    0x4(%eax),%eax
 923:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 92a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92d:	01 d0                	add    %edx,%eax
 92f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 932:	75 20                	jne    954 <free+0xcf>
    p->s.size += bp->s.size;
 934:	8b 45 fc             	mov    -0x4(%ebp),%eax
 937:	8b 50 04             	mov    0x4(%eax),%edx
 93a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93d:	8b 40 04             	mov    0x4(%eax),%eax
 940:	01 c2                	add    %eax,%edx
 942:	8b 45 fc             	mov    -0x4(%ebp),%eax
 945:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 948:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94b:	8b 10                	mov    (%eax),%edx
 94d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 950:	89 10                	mov    %edx,(%eax)
 952:	eb 08                	jmp    95c <free+0xd7>
  } else
    p->s.ptr = bp;
 954:	8b 45 fc             	mov    -0x4(%ebp),%eax
 957:	8b 55 f8             	mov    -0x8(%ebp),%edx
 95a:	89 10                	mov    %edx,(%eax)
  freep = p;
 95c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95f:	a3 30 0e 00 00       	mov    %eax,0xe30
}
 964:	c9                   	leave  
 965:	c3                   	ret    

00000966 <morecore>:

static Header*
morecore(uint nu)
{
 966:	55                   	push   %ebp
 967:	89 e5                	mov    %esp,%ebp
 969:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 96c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 973:	77 07                	ja     97c <morecore+0x16>
    nu = 4096;
 975:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 97c:	8b 45 08             	mov    0x8(%ebp),%eax
 97f:	c1 e0 03             	shl    $0x3,%eax
 982:	89 04 24             	mov    %eax,(%esp)
 985:	e8 40 fc ff ff       	call   5ca <sbrk>
 98a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 98d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 991:	75 07                	jne    99a <morecore+0x34>
    return 0;
 993:	b8 00 00 00 00       	mov    $0x0,%eax
 998:	eb 22                	jmp    9bc <morecore+0x56>
  hp = (Header*)p;
 99a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a3:	8b 55 08             	mov    0x8(%ebp),%edx
 9a6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ac:	83 c0 08             	add    $0x8,%eax
 9af:	89 04 24             	mov    %eax,(%esp)
 9b2:	e8 ce fe ff ff       	call   885 <free>
  return freep;
 9b7:	a1 30 0e 00 00       	mov    0xe30,%eax
}
 9bc:	c9                   	leave  
 9bd:	c3                   	ret    

000009be <malloc>:

void*
malloc(uint nbytes)
{
 9be:	55                   	push   %ebp
 9bf:	89 e5                	mov    %esp,%ebp
 9c1:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9c4:	8b 45 08             	mov    0x8(%ebp),%eax
 9c7:	83 c0 07             	add    $0x7,%eax
 9ca:	c1 e8 03             	shr    $0x3,%eax
 9cd:	83 c0 01             	add    $0x1,%eax
 9d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9d3:	a1 30 0e 00 00       	mov    0xe30,%eax
 9d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9df:	75 23                	jne    a04 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9e1:	c7 45 f0 28 0e 00 00 	movl   $0xe28,-0x10(%ebp)
 9e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9eb:	a3 30 0e 00 00       	mov    %eax,0xe30
 9f0:	a1 30 0e 00 00       	mov    0xe30,%eax
 9f5:	a3 28 0e 00 00       	mov    %eax,0xe28
    base.s.size = 0;
 9fa:	c7 05 2c 0e 00 00 00 	movl   $0x0,0xe2c
 a01:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a07:	8b 00                	mov    (%eax),%eax
 a09:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0f:	8b 40 04             	mov    0x4(%eax),%eax
 a12:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a15:	72 4d                	jb     a64 <malloc+0xa6>
      if(p->s.size == nunits)
 a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1a:	8b 40 04             	mov    0x4(%eax),%eax
 a1d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a20:	75 0c                	jne    a2e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a25:	8b 10                	mov    (%eax),%edx
 a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2a:	89 10                	mov    %edx,(%eax)
 a2c:	eb 26                	jmp    a54 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a31:	8b 40 04             	mov    0x4(%eax),%eax
 a34:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a37:	89 c2                	mov    %eax,%edx
 a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a42:	8b 40 04             	mov    0x4(%eax),%eax
 a45:	c1 e0 03             	shl    $0x3,%eax
 a48:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a51:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a57:	a3 30 0e 00 00       	mov    %eax,0xe30
      return (void*)(p + 1);
 a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5f:	83 c0 08             	add    $0x8,%eax
 a62:	eb 38                	jmp    a9c <malloc+0xde>
    }
    if(p == freep)
 a64:	a1 30 0e 00 00       	mov    0xe30,%eax
 a69:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a6c:	75 1b                	jne    a89 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 a6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a71:	89 04 24             	mov    %eax,(%esp)
 a74:	e8 ed fe ff ff       	call   966 <morecore>
 a79:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a80:	75 07                	jne    a89 <malloc+0xcb>
        return 0;
 a82:	b8 00 00 00 00       	mov    $0x0,%eax
 a87:	eb 13                	jmp    a9c <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a92:	8b 00                	mov    (%eax),%eax
 a94:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a97:	e9 70 ff ff ff       	jmp    a0c <malloc+0x4e>
}
 a9c:	c9                   	leave  
 a9d:	c3                   	ret    
