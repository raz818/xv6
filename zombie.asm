
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 e8 04 00 00       	call   4f6 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 70 05 00 00       	call   58e <sleep>
  exit();
  1e:	e8 db 04 00 00       	call   4fe <exit>

00000023 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  23:	55                   	push   %ebp
  24:	89 e5                	mov    %esp,%ebp
  26:	57                   	push   %edi
  27:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2b:	8b 55 10             	mov    0x10(%ebp),%edx
  2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  31:	89 cb                	mov    %ecx,%ebx
  33:	89 df                	mov    %ebx,%edi
  35:	89 d1                	mov    %edx,%ecx
  37:	fc                   	cld    
  38:	f3 aa                	rep stos %al,%es:(%edi)
  3a:	89 ca                	mov    %ecx,%edx
  3c:	89 fb                	mov    %edi,%ebx
  3e:	89 5d 08             	mov    %ebx,0x8(%ebp)
  41:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  44:	5b                   	pop    %ebx
  45:	5f                   	pop    %edi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    

00000048 <thing>:
#include "user.h"
#include "x86.h"


int
thing(void){
  48:	55                   	push   %ebp
  49:	89 e5                	mov    %esp,%ebp
  return 1;
  4b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  50:	5d                   	pop    %ebp
  51:	c3                   	ret    

00000052 <strcpy>:

char*
strcpy(char *s, char *t)
{
  52:	55                   	push   %ebp
  53:	89 e5                	mov    %esp,%ebp
  55:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  58:	8b 45 08             	mov    0x8(%ebp),%eax
  5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5e:	90                   	nop
  5f:	8b 45 08             	mov    0x8(%ebp),%eax
  62:	8d 50 01             	lea    0x1(%eax),%edx
  65:	89 55 08             	mov    %edx,0x8(%ebp)
  68:	8b 55 0c             	mov    0xc(%ebp),%edx
  6b:	8d 4a 01             	lea    0x1(%edx),%ecx
  6e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  71:	0f b6 12             	movzbl (%edx),%edx
  74:	88 10                	mov    %dl,(%eax)
  76:	0f b6 00             	movzbl (%eax),%eax
  79:	84 c0                	test   %al,%al
  7b:	75 e2                	jne    5f <strcpy+0xd>
    ;
  return os;
  7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80:	c9                   	leave  
  81:	c3                   	ret    

00000082 <strcmp>:



int
strcmp(const char *p, const char *q)
{
  82:	55                   	push   %ebp
  83:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  85:	eb 08                	jmp    8f <strcmp+0xd>
    p++, q++;
  87:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)


int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	0f b6 00             	movzbl (%eax),%eax
  95:	84 c0                	test   %al,%al
  97:	74 10                	je     a9 <strcmp+0x27>
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	0f b6 10             	movzbl (%eax),%edx
  9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  a2:	0f b6 00             	movzbl (%eax),%eax
  a5:	38 c2                	cmp    %al,%dl
  a7:	74 de                	je     87 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
  ac:	0f b6 00             	movzbl (%eax),%eax
  af:	0f b6 d0             	movzbl %al,%edx
  b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  b5:	0f b6 00             	movzbl (%eax),%eax
  b8:	0f b6 c0             	movzbl %al,%eax
  bb:	29 c2                	sub    %eax,%edx
  bd:	89 d0                	mov    %edx,%eax
}
  bf:	5d                   	pop    %ebp
  c0:	c3                   	ret    

000000c1 <strlen>:

uint
strlen(char *s)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  c4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ce:	eb 04                	jmp    d4 <strlen+0x13>
  d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	01 d0                	add    %edx,%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	84 c0                	test   %al,%al
  e1:	75 ed                	jne    d0 <strlen+0xf>
    ;
  return n;
  e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e6:	c9                   	leave  
  e7:	c3                   	ret    

000000e8 <stringlen>:

uint
stringlen(char **s){
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  eb:	83 ec 10             	sub    $0x10,%esp
	int n;

  for(n = 0; s[n]; n++)
  ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  f5:	eb 04                	jmp    fb <stringlen+0x13>
  f7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 105:	8b 45 08             	mov    0x8(%ebp),%eax
 108:	01 d0                	add    %edx,%eax
 10a:	8b 00                	mov    (%eax),%eax
 10c:	85 c0                	test   %eax,%eax
 10e:	75 e7                	jne    f7 <stringlen+0xf>
    ;
  return n;
 110:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 113:	c9                   	leave  
 114:	c3                   	ret    

00000115 <memset>:

void*
memset(void *dst, int c, uint n)
{
 115:	55                   	push   %ebp
 116:	89 e5                	mov    %esp,%ebp
 118:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 11b:	8b 45 10             	mov    0x10(%ebp),%eax
 11e:	89 44 24 08          	mov    %eax,0x8(%esp)
 122:	8b 45 0c             	mov    0xc(%ebp),%eax
 125:	89 44 24 04          	mov    %eax,0x4(%esp)
 129:	8b 45 08             	mov    0x8(%ebp),%eax
 12c:	89 04 24             	mov    %eax,(%esp)
 12f:	e8 ef fe ff ff       	call   23 <stosb>
  return dst;
 134:	8b 45 08             	mov    0x8(%ebp),%eax
}
 137:	c9                   	leave  
 138:	c3                   	ret    

00000139 <strchr>:

char*
strchr(const char *s, char c)
{
 139:	55                   	push   %ebp
 13a:	89 e5                	mov    %esp,%ebp
 13c:	83 ec 04             	sub    $0x4,%esp
 13f:	8b 45 0c             	mov    0xc(%ebp),%eax
 142:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 145:	eb 14                	jmp    15b <strchr+0x22>
    if(*s == c)
 147:	8b 45 08             	mov    0x8(%ebp),%eax
 14a:	0f b6 00             	movzbl (%eax),%eax
 14d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 150:	75 05                	jne    157 <strchr+0x1e>
      return (char*)s;
 152:	8b 45 08             	mov    0x8(%ebp),%eax
 155:	eb 13                	jmp    16a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 157:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15b:	8b 45 08             	mov    0x8(%ebp),%eax
 15e:	0f b6 00             	movzbl (%eax),%eax
 161:	84 c0                	test   %al,%al
 163:	75 e2                	jne    147 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 165:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16a:	c9                   	leave  
 16b:	c3                   	ret    

0000016c <gets>:

char*
gets(char *buf, int max)
{
 16c:	55                   	push   %ebp
 16d:	89 e5                	mov    %esp,%ebp
 16f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 172:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 179:	eb 4c                	jmp    1c7 <gets+0x5b>
    cc = read(0, &c, 1);
 17b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 182:	00 
 183:	8d 45 ef             	lea    -0x11(%ebp),%eax
 186:	89 44 24 04          	mov    %eax,0x4(%esp)
 18a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 191:	e8 80 03 00 00       	call   516 <read>
 196:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 199:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 19d:	7f 02                	jg     1a1 <gets+0x35>
      break;
 19f:	eb 31                	jmp    1d2 <gets+0x66>
    buf[i++] = c;
 1a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a4:	8d 50 01             	lea    0x1(%eax),%edx
 1a7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1aa:	89 c2                	mov    %eax,%edx
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	01 c2                	add    %eax,%edx
 1b1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b5:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bb:	3c 0a                	cmp    $0xa,%al
 1bd:	74 13                	je     1d2 <gets+0x66>
 1bf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c3:	3c 0d                	cmp    $0xd,%al
 1c5:	74 0b                	je     1d2 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ca:	83 c0 01             	add    $0x1,%eax
 1cd:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d0:	7c a9                	jl     17b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d5:	8b 45 08             	mov    0x8(%ebp),%eax
 1d8:	01 d0                	add    %edx,%eax
 1da:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e0:	c9                   	leave  
 1e1:	c3                   	ret    

000001e2 <stat>:

int
stat(char *n, struct stat *st)
{
 1e2:	55                   	push   %ebp
 1e3:	89 e5                	mov    %esp,%ebp
 1e5:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1ef:	00 
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	89 04 24             	mov    %eax,(%esp)
 1f6:	e8 43 03 00 00       	call   53e <open>
 1fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 202:	79 07                	jns    20b <stat+0x29>
    return -1;
 204:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 209:	eb 23                	jmp    22e <stat+0x4c>
  r = fstat(fd, st);
 20b:	8b 45 0c             	mov    0xc(%ebp),%eax
 20e:	89 44 24 04          	mov    %eax,0x4(%esp)
 212:	8b 45 f4             	mov    -0xc(%ebp),%eax
 215:	89 04 24             	mov    %eax,(%esp)
 218:	e8 39 03 00 00       	call   556 <fstat>
 21d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 220:	8b 45 f4             	mov    -0xc(%ebp),%eax
 223:	89 04 24             	mov    %eax,(%esp)
 226:	e8 fb 02 00 00       	call   526 <close>
  return r;
 22b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 22e:	c9                   	leave  
 22f:	c3                   	ret    

00000230 <atoi>:

int
atoi(const char *s)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 236:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 23d:	eb 25                	jmp    264 <atoi+0x34>
    n = n*10 + *s++ - '0';
 23f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 242:	89 d0                	mov    %edx,%eax
 244:	c1 e0 02             	shl    $0x2,%eax
 247:	01 d0                	add    %edx,%eax
 249:	01 c0                	add    %eax,%eax
 24b:	89 c1                	mov    %eax,%ecx
 24d:	8b 45 08             	mov    0x8(%ebp),%eax
 250:	8d 50 01             	lea    0x1(%eax),%edx
 253:	89 55 08             	mov    %edx,0x8(%ebp)
 256:	0f b6 00             	movzbl (%eax),%eax
 259:	0f be c0             	movsbl %al,%eax
 25c:	01 c8                	add    %ecx,%eax
 25e:	83 e8 30             	sub    $0x30,%eax
 261:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	0f b6 00             	movzbl (%eax),%eax
 26a:	3c 2f                	cmp    $0x2f,%al
 26c:	7e 0a                	jle    278 <atoi+0x48>
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
 271:	0f b6 00             	movzbl (%eax),%eax
 274:	3c 39                	cmp    $0x39,%al
 276:	7e c7                	jle    23f <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 278:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 27b:	c9                   	leave  
 27c:	c3                   	ret    

0000027d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 27d:	55                   	push   %ebp
 27e:	89 e5                	mov    %esp,%ebp
 280:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 289:	8b 45 0c             	mov    0xc(%ebp),%eax
 28c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 28f:	eb 17                	jmp    2a8 <memmove+0x2b>
    *dst++ = *src++;
 291:	8b 45 fc             	mov    -0x4(%ebp),%eax
 294:	8d 50 01             	lea    0x1(%eax),%edx
 297:	89 55 fc             	mov    %edx,-0x4(%ebp)
 29a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 29d:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a0:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2a3:	0f b6 12             	movzbl (%edx),%edx
 2a6:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a8:	8b 45 10             	mov    0x10(%ebp),%eax
 2ab:	8d 50 ff             	lea    -0x1(%eax),%edx
 2ae:	89 55 10             	mov    %edx,0x10(%ebp)
 2b1:	85 c0                	test   %eax,%eax
 2b3:	7f dc                	jg     291 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b8:	c9                   	leave  
 2b9:	c3                   	ret    

000002ba <strcmp_c>:


int
strcmp_c(const char *s1, const char *s2)
{
 2ba:	55                   	push   %ebp
 2bb:	89 e5                	mov    %esp,%ebp
    for ( ; *s1 == *s2; s1++, s2++)
 2bd:	eb 19                	jmp    2d8 <strcmp_c+0x1e>
	if (*s1 == '\0')
 2bf:	8b 45 08             	mov    0x8(%ebp),%eax
 2c2:	0f b6 00             	movzbl (%eax),%eax
 2c5:	84 c0                	test   %al,%al
 2c7:	75 07                	jne    2d0 <strcmp_c+0x16>
	    return 0;
 2c9:	b8 00 00 00 00       	mov    $0x0,%eax
 2ce:	eb 34                	jmp    304 <strcmp_c+0x4a>


int
strcmp_c(const char *s1, const char *s2)
{
    for ( ; *s1 == *s2; s1++, s2++)
 2d0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2d4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
 2db:	0f b6 10             	movzbl (%eax),%edx
 2de:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e1:	0f b6 00             	movzbl (%eax),%eax
 2e4:	38 c2                	cmp    %al,%dl
 2e6:	74 d7                	je     2bf <strcmp_c+0x5>
	if (*s1 == '\0')
	    return 0;
    return ((*(unsigned char *)s1 < *(unsigned char *)s2) ? -1 : +1);
 2e8:	8b 45 08             	mov    0x8(%ebp),%eax
 2eb:	0f b6 10             	movzbl (%eax),%edx
 2ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f1:	0f b6 00             	movzbl (%eax),%eax
 2f4:	38 c2                	cmp    %al,%dl
 2f6:	73 07                	jae    2ff <strcmp_c+0x45>
 2f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2fd:	eb 05                	jmp    304 <strcmp_c+0x4a>
 2ff:	b8 01 00 00 00       	mov    $0x1,%eax
}
 304:	5d                   	pop    %ebp
 305:	c3                   	ret    

00000306 <readuser>:


struct USER
readuser(){
 306:	55                   	push   %ebp
 307:	89 e5                	mov    %esp,%ebp
 309:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char buff1[512], buff2[512];
	struct USER u;
	printf(1,"Please enter a username: ");
 30f:	c7 44 24 04 5a 0a 00 	movl   $0xa5a,0x4(%esp)
 316:	00 
 317:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 31e:	e8 6b 03 00 00       	call   68e <printf>
	u.name = gets(buff1, 50);
 323:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 32a:	00 
 32b:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
 331:	89 04 24             	mov    %eax,(%esp)
 334:	e8 33 fe ff ff       	call   16c <gets>
 339:	89 85 ec fb ff ff    	mov    %eax,-0x414(%ebp)
	printf(1,"Please enter a password: ");
 33f:	c7 44 24 04 74 0a 00 	movl   $0xa74,0x4(%esp)
 346:	00 
 347:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 34e:	e8 3b 03 00 00       	call   68e <printf>
	u.pass = gets(buff2, 50);
 353:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 35a:	00 
 35b:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
 361:	89 04 24             	mov    %eax,(%esp)
 364:	e8 03 fe ff ff       	call   16c <gets>
 369:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
	return u;
 36f:	8b 45 08             	mov    0x8(%ebp),%eax
 372:	8b 95 ec fb ff ff    	mov    -0x414(%ebp),%edx
 378:	89 10                	mov    %edx,(%eax)
 37a:	8b 95 f0 fb ff ff    	mov    -0x410(%ebp),%edx
 380:	89 50 04             	mov    %edx,0x4(%eax)
 383:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
 389:	89 50 08             	mov    %edx,0x8(%eax)
}
 38c:	8b 45 08             	mov    0x8(%ebp),%eax
 38f:	c9                   	leave  
 390:	c2 04 00             	ret    $0x4

00000393 <compareuser>:


int
compareuser(int state){
 393:	55                   	push   %ebp
 394:	89 e5                	mov    %esp,%ebp
 396:	56                   	push   %esi
 397:	53                   	push   %ebx
 398:	81 ec 30 01 00 00    	sub    $0x130,%esp
	struct USER u1,u2;
	struct USER users[20];
	u1.name = "john\n";
 39e:	c7 45 e8 8e 0a 00 00 	movl   $0xa8e,-0x18(%ebp)
	u1.pass = "1234\n";
 3a5:	c7 45 ec 94 0a 00 00 	movl   $0xa94,-0x14(%ebp)
	u1.ulevel = 0;
 3ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	u2.name = "james\n";
 3b3:	c7 45 dc 9a 0a 00 00 	movl   $0xa9a,-0x24(%ebp)
	u2.pass = "pass\n";
 3ba:	c7 45 e0 a1 0a 00 00 	movl   $0xaa1,-0x20(%ebp)
	u2.ulevel = 1;
 3c1:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	users[0] = u1;
 3c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 3cb:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
 3d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d4:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
 3da:	8b 45 f0             	mov    -0x10(%ebp),%eax
 3dd:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
	users[1] = u2;
 3e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
 3e6:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
 3ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
 3ef:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
 3f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 3f8:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
	
	
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
 3fe:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
 404:	89 04 24             	mov    %eax,(%esp)
 407:	e8 fa fe ff ff       	call   306 <readuser>
 40c:	83 ec 04             	sub    $0x4,%esp
		
		for(ctr = 0; ctr < 20; ctr++)
 40f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 416:	e9 a4 00 00 00       	jmp    4bf <compareuser+0x12c>
		{

			if(strcmp_c(u.name,users[ctr].name) == 0 && strcmp_c(u.pass,users[ctr].pass) == 0)
 41b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 41e:	89 d0                	mov    %edx,%eax
 420:	01 c0                	add    %eax,%eax
 422:	01 d0                	add    %edx,%eax
 424:	c1 e0 02             	shl    $0x2,%eax
 427:	8d 4d f8             	lea    -0x8(%ebp),%ecx
 42a:	01 c8                	add    %ecx,%eax
 42c:	2d 0c 01 00 00       	sub    $0x10c,%eax
 431:	8b 10                	mov    (%eax),%edx
 433:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
 439:	89 54 24 04          	mov    %edx,0x4(%esp)
 43d:	89 04 24             	mov    %eax,(%esp)
 440:	e8 75 fe ff ff       	call   2ba <strcmp_c>
 445:	85 c0                	test   %eax,%eax
 447:	75 72                	jne    4bb <compareuser+0x128>
 449:	8b 55 f4             	mov    -0xc(%ebp),%edx
 44c:	89 d0                	mov    %edx,%eax
 44e:	01 c0                	add    %eax,%eax
 450:	01 d0                	add    %edx,%eax
 452:	c1 e0 02             	shl    $0x2,%eax
 455:	8d 5d f8             	lea    -0x8(%ebp),%ebx
 458:	01 d8                	add    %ebx,%eax
 45a:	2d 08 01 00 00       	sub    $0x108,%eax
 45f:	8b 10                	mov    (%eax),%edx
 461:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
 467:	89 54 24 04          	mov    %edx,0x4(%esp)
 46b:	89 04 24             	mov    %eax,(%esp)
 46e:	e8 47 fe ff ff       	call   2ba <strcmp_c>
 473:	85 c0                	test   %eax,%eax
 475:	75 44                	jne    4bb <compareuser+0x128>
			{
				setuser(users[ctr].ulevel);
 477:	8b 55 f4             	mov    -0xc(%ebp),%edx
 47a:	89 d0                	mov    %edx,%eax
 47c:	01 c0                	add    %eax,%eax
 47e:	01 d0                	add    %edx,%eax
 480:	c1 e0 02             	shl    $0x2,%eax
 483:	8d 75 f8             	lea    -0x8(%ebp),%esi
 486:	01 f0                	add    %esi,%eax
 488:	2d 04 01 00 00       	sub    $0x104,%eax
 48d:	8b 00                	mov    (%eax),%eax
 48f:	89 04 24             	mov    %eax,(%esp)
 492:	e8 0f 01 00 00       	call   5a6 <setuser>
				
				printf(1,"%d",getuser());
 497:	e8 02 01 00 00       	call   59e <getuser>
 49c:	89 44 24 08          	mov    %eax,0x8(%esp)
 4a0:	c7 44 24 04 a7 0a 00 	movl   $0xaa7,0x4(%esp)
 4a7:	00 
 4a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4af:	e8 da 01 00 00       	call   68e <printf>
				return 1;
 4b4:	b8 01 00 00 00       	mov    $0x1,%eax
 4b9:	eb 34                	jmp    4ef <compareuser+0x15c>
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
		
		for(ctr = 0; ctr < 20; ctr++)
 4bb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 4bf:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 4c3:	0f 8e 52 ff ff ff    	jle    41b <compareuser+0x88>
				
				printf(1,"%d",getuser());
				return 1;
			}
		}
		printf(1,"Invalid username/password\n");
 4c9:	c7 44 24 04 aa 0a 00 	movl   $0xaaa,0x4(%esp)
 4d0:	00 
 4d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4d8:	e8 b1 01 00 00       	call   68e <printf>
		if(state != 1)
 4dd:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 4e1:	74 07                	je     4ea <compareuser+0x157>
			break;
	}
	return 0;
 4e3:	b8 00 00 00 00       	mov    $0x0,%eax
 4e8:	eb 05                	jmp    4ef <compareuser+0x15c>
			}
		}
		printf(1,"Invalid username/password\n");
		if(state != 1)
			break;
	}
 4ea:	e9 0f ff ff ff       	jmp    3fe <compareuser+0x6b>
	return 0;
}
 4ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4f2:	5b                   	pop    %ebx
 4f3:	5e                   	pop    %esi
 4f4:	5d                   	pop    %ebp
 4f5:	c3                   	ret    

000004f6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4f6:	b8 01 00 00 00       	mov    $0x1,%eax
 4fb:	cd 40                	int    $0x40
 4fd:	c3                   	ret    

000004fe <exit>:
SYSCALL(exit)
 4fe:	b8 02 00 00 00       	mov    $0x2,%eax
 503:	cd 40                	int    $0x40
 505:	c3                   	ret    

00000506 <wait>:
SYSCALL(wait)
 506:	b8 03 00 00 00       	mov    $0x3,%eax
 50b:	cd 40                	int    $0x40
 50d:	c3                   	ret    

0000050e <pipe>:
SYSCALL(pipe)
 50e:	b8 04 00 00 00       	mov    $0x4,%eax
 513:	cd 40                	int    $0x40
 515:	c3                   	ret    

00000516 <read>:
SYSCALL(read)
 516:	b8 05 00 00 00       	mov    $0x5,%eax
 51b:	cd 40                	int    $0x40
 51d:	c3                   	ret    

0000051e <write>:
SYSCALL(write)
 51e:	b8 10 00 00 00       	mov    $0x10,%eax
 523:	cd 40                	int    $0x40
 525:	c3                   	ret    

00000526 <close>:
SYSCALL(close)
 526:	b8 15 00 00 00       	mov    $0x15,%eax
 52b:	cd 40                	int    $0x40
 52d:	c3                   	ret    

0000052e <kill>:
SYSCALL(kill)
 52e:	b8 06 00 00 00       	mov    $0x6,%eax
 533:	cd 40                	int    $0x40
 535:	c3                   	ret    

00000536 <exec>:
SYSCALL(exec)
 536:	b8 07 00 00 00       	mov    $0x7,%eax
 53b:	cd 40                	int    $0x40
 53d:	c3                   	ret    

0000053e <open>:
SYSCALL(open)
 53e:	b8 0f 00 00 00       	mov    $0xf,%eax
 543:	cd 40                	int    $0x40
 545:	c3                   	ret    

00000546 <mknod>:
SYSCALL(mknod)
 546:	b8 11 00 00 00       	mov    $0x11,%eax
 54b:	cd 40                	int    $0x40
 54d:	c3                   	ret    

0000054e <unlink>:
SYSCALL(unlink)
 54e:	b8 12 00 00 00       	mov    $0x12,%eax
 553:	cd 40                	int    $0x40
 555:	c3                   	ret    

00000556 <fstat>:
SYSCALL(fstat)
 556:	b8 08 00 00 00       	mov    $0x8,%eax
 55b:	cd 40                	int    $0x40
 55d:	c3                   	ret    

0000055e <link>:
SYSCALL(link)
 55e:	b8 13 00 00 00       	mov    $0x13,%eax
 563:	cd 40                	int    $0x40
 565:	c3                   	ret    

00000566 <mkdir>:
SYSCALL(mkdir)
 566:	b8 14 00 00 00       	mov    $0x14,%eax
 56b:	cd 40                	int    $0x40
 56d:	c3                   	ret    

0000056e <chdir>:
SYSCALL(chdir)
 56e:	b8 09 00 00 00       	mov    $0x9,%eax
 573:	cd 40                	int    $0x40
 575:	c3                   	ret    

00000576 <dup>:
SYSCALL(dup)
 576:	b8 0a 00 00 00       	mov    $0xa,%eax
 57b:	cd 40                	int    $0x40
 57d:	c3                   	ret    

0000057e <getpid>:
SYSCALL(getpid)
 57e:	b8 0b 00 00 00       	mov    $0xb,%eax
 583:	cd 40                	int    $0x40
 585:	c3                   	ret    

00000586 <sbrk>:
SYSCALL(sbrk)
 586:	b8 0c 00 00 00       	mov    $0xc,%eax
 58b:	cd 40                	int    $0x40
 58d:	c3                   	ret    

0000058e <sleep>:
SYSCALL(sleep)
 58e:	b8 0d 00 00 00       	mov    $0xd,%eax
 593:	cd 40                	int    $0x40
 595:	c3                   	ret    

00000596 <uptime>:
SYSCALL(uptime)
 596:	b8 0e 00 00 00       	mov    $0xe,%eax
 59b:	cd 40                	int    $0x40
 59d:	c3                   	ret    

0000059e <getuser>:
SYSCALL(getuser)
 59e:	b8 16 00 00 00       	mov    $0x16,%eax
 5a3:	cd 40                	int    $0x40
 5a5:	c3                   	ret    

000005a6 <setuser>:
SYSCALL(setuser)
 5a6:	b8 17 00 00 00       	mov    $0x17,%eax
 5ab:	cd 40                	int    $0x40
 5ad:	c3                   	ret    

000005ae <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5ae:	55                   	push   %ebp
 5af:	89 e5                	mov    %esp,%ebp
 5b1:	83 ec 18             	sub    $0x18,%esp
 5b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b7:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5ba:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5c1:	00 
 5c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c9:	8b 45 08             	mov    0x8(%ebp),%eax
 5cc:	89 04 24             	mov    %eax,(%esp)
 5cf:	e8 4a ff ff ff       	call   51e <write>
}
 5d4:	c9                   	leave  
 5d5:	c3                   	ret    

000005d6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5d6:	55                   	push   %ebp
 5d7:	89 e5                	mov    %esp,%ebp
 5d9:	56                   	push   %esi
 5da:	53                   	push   %ebx
 5db:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5e5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5e9:	74 17                	je     602 <printint+0x2c>
 5eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5ef:	79 11                	jns    602 <printint+0x2c>
    neg = 1;
 5f1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 5fb:	f7 d8                	neg    %eax
 5fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 600:	eb 06                	jmp    608 <printint+0x32>
  } else {
    x = xx;
 602:	8b 45 0c             	mov    0xc(%ebp),%eax
 605:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 608:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 60f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 612:	8d 41 01             	lea    0x1(%ecx),%eax
 615:	89 45 f4             	mov    %eax,-0xc(%ebp)
 618:	8b 5d 10             	mov    0x10(%ebp),%ebx
 61b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 61e:	ba 00 00 00 00       	mov    $0x0,%edx
 623:	f7 f3                	div    %ebx
 625:	89 d0                	mov    %edx,%eax
 627:	0f b6 80 bc 0d 00 00 	movzbl 0xdbc(%eax),%eax
 62e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 632:	8b 75 10             	mov    0x10(%ebp),%esi
 635:	8b 45 ec             	mov    -0x14(%ebp),%eax
 638:	ba 00 00 00 00       	mov    $0x0,%edx
 63d:	f7 f6                	div    %esi
 63f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 642:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 646:	75 c7                	jne    60f <printint+0x39>
  if(neg)
 648:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 64c:	74 10                	je     65e <printint+0x88>
    buf[i++] = '-';
 64e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 651:	8d 50 01             	lea    0x1(%eax),%edx
 654:	89 55 f4             	mov    %edx,-0xc(%ebp)
 657:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 65c:	eb 1f                	jmp    67d <printint+0xa7>
 65e:	eb 1d                	jmp    67d <printint+0xa7>
    putc(fd, buf[i]);
 660:	8d 55 dc             	lea    -0x24(%ebp),%edx
 663:	8b 45 f4             	mov    -0xc(%ebp),%eax
 666:	01 d0                	add    %edx,%eax
 668:	0f b6 00             	movzbl (%eax),%eax
 66b:	0f be c0             	movsbl %al,%eax
 66e:	89 44 24 04          	mov    %eax,0x4(%esp)
 672:	8b 45 08             	mov    0x8(%ebp),%eax
 675:	89 04 24             	mov    %eax,(%esp)
 678:	e8 31 ff ff ff       	call   5ae <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 67d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 681:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 685:	79 d9                	jns    660 <printint+0x8a>
    putc(fd, buf[i]);
}
 687:	83 c4 30             	add    $0x30,%esp
 68a:	5b                   	pop    %ebx
 68b:	5e                   	pop    %esi
 68c:	5d                   	pop    %ebp
 68d:	c3                   	ret    

0000068e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 68e:	55                   	push   %ebp
 68f:	89 e5                	mov    %esp,%ebp
 691:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 694:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 69b:	8d 45 0c             	lea    0xc(%ebp),%eax
 69e:	83 c0 04             	add    $0x4,%eax
 6a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6ab:	e9 7c 01 00 00       	jmp    82c <printf+0x19e>
    c = fmt[i] & 0xff;
 6b0:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6b6:	01 d0                	add    %edx,%eax
 6b8:	0f b6 00             	movzbl (%eax),%eax
 6bb:	0f be c0             	movsbl %al,%eax
 6be:	25 ff 00 00 00       	and    $0xff,%eax
 6c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6ca:	75 2c                	jne    6f8 <printf+0x6a>
      if(c == '%'){
 6cc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6d0:	75 0c                	jne    6de <printf+0x50>
        state = '%';
 6d2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6d9:	e9 4a 01 00 00       	jmp    828 <printf+0x19a>
      } else {
        putc(fd, c);
 6de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6e1:	0f be c0             	movsbl %al,%eax
 6e4:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e8:	8b 45 08             	mov    0x8(%ebp),%eax
 6eb:	89 04 24             	mov    %eax,(%esp)
 6ee:	e8 bb fe ff ff       	call   5ae <putc>
 6f3:	e9 30 01 00 00       	jmp    828 <printf+0x19a>
      }
    } else if(state == '%'){
 6f8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6fc:	0f 85 26 01 00 00    	jne    828 <printf+0x19a>
      if(c == 'd'){
 702:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 706:	75 2d                	jne    735 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 708:	8b 45 e8             	mov    -0x18(%ebp),%eax
 70b:	8b 00                	mov    (%eax),%eax
 70d:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 714:	00 
 715:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 71c:	00 
 71d:	89 44 24 04          	mov    %eax,0x4(%esp)
 721:	8b 45 08             	mov    0x8(%ebp),%eax
 724:	89 04 24             	mov    %eax,(%esp)
 727:	e8 aa fe ff ff       	call   5d6 <printint>
        ap++;
 72c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 730:	e9 ec 00 00 00       	jmp    821 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 735:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 739:	74 06                	je     741 <printf+0xb3>
 73b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 73f:	75 2d                	jne    76e <printf+0xe0>
        printint(fd, *ap, 16, 0);
 741:	8b 45 e8             	mov    -0x18(%ebp),%eax
 744:	8b 00                	mov    (%eax),%eax
 746:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 74d:	00 
 74e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 755:	00 
 756:	89 44 24 04          	mov    %eax,0x4(%esp)
 75a:	8b 45 08             	mov    0x8(%ebp),%eax
 75d:	89 04 24             	mov    %eax,(%esp)
 760:	e8 71 fe ff ff       	call   5d6 <printint>
        ap++;
 765:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 769:	e9 b3 00 00 00       	jmp    821 <printf+0x193>
      } else if(c == 's'){
 76e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 772:	75 45                	jne    7b9 <printf+0x12b>
        s = (char*)*ap;
 774:	8b 45 e8             	mov    -0x18(%ebp),%eax
 777:	8b 00                	mov    (%eax),%eax
 779:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 77c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 780:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 784:	75 09                	jne    78f <printf+0x101>
          s = "(null)";
 786:	c7 45 f4 c5 0a 00 00 	movl   $0xac5,-0xc(%ebp)
        while(*s != 0){
 78d:	eb 1e                	jmp    7ad <printf+0x11f>
 78f:	eb 1c                	jmp    7ad <printf+0x11f>
          putc(fd, *s);
 791:	8b 45 f4             	mov    -0xc(%ebp),%eax
 794:	0f b6 00             	movzbl (%eax),%eax
 797:	0f be c0             	movsbl %al,%eax
 79a:	89 44 24 04          	mov    %eax,0x4(%esp)
 79e:	8b 45 08             	mov    0x8(%ebp),%eax
 7a1:	89 04 24             	mov    %eax,(%esp)
 7a4:	e8 05 fe ff ff       	call   5ae <putc>
          s++;
 7a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b0:	0f b6 00             	movzbl (%eax),%eax
 7b3:	84 c0                	test   %al,%al
 7b5:	75 da                	jne    791 <printf+0x103>
 7b7:	eb 68                	jmp    821 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7b9:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7bd:	75 1d                	jne    7dc <printf+0x14e>
        putc(fd, *ap);
 7bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c2:	8b 00                	mov    (%eax),%eax
 7c4:	0f be c0             	movsbl %al,%eax
 7c7:	89 44 24 04          	mov    %eax,0x4(%esp)
 7cb:	8b 45 08             	mov    0x8(%ebp),%eax
 7ce:	89 04 24             	mov    %eax,(%esp)
 7d1:	e8 d8 fd ff ff       	call   5ae <putc>
        ap++;
 7d6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7da:	eb 45                	jmp    821 <printf+0x193>
      } else if(c == '%'){
 7dc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7e0:	75 17                	jne    7f9 <printf+0x16b>
        putc(fd, c);
 7e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7e5:	0f be c0             	movsbl %al,%eax
 7e8:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ec:	8b 45 08             	mov    0x8(%ebp),%eax
 7ef:	89 04 24             	mov    %eax,(%esp)
 7f2:	e8 b7 fd ff ff       	call   5ae <putc>
 7f7:	eb 28                	jmp    821 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7f9:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 800:	00 
 801:	8b 45 08             	mov    0x8(%ebp),%eax
 804:	89 04 24             	mov    %eax,(%esp)
 807:	e8 a2 fd ff ff       	call   5ae <putc>
        putc(fd, c);
 80c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80f:	0f be c0             	movsbl %al,%eax
 812:	89 44 24 04          	mov    %eax,0x4(%esp)
 816:	8b 45 08             	mov    0x8(%ebp),%eax
 819:	89 04 24             	mov    %eax,(%esp)
 81c:	e8 8d fd ff ff       	call   5ae <putc>
      }
      state = 0;
 821:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 828:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 82c:	8b 55 0c             	mov    0xc(%ebp),%edx
 82f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 832:	01 d0                	add    %edx,%eax
 834:	0f b6 00             	movzbl (%eax),%eax
 837:	84 c0                	test   %al,%al
 839:	0f 85 71 fe ff ff    	jne    6b0 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 83f:	c9                   	leave  
 840:	c3                   	ret    

00000841 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 841:	55                   	push   %ebp
 842:	89 e5                	mov    %esp,%ebp
 844:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 847:	8b 45 08             	mov    0x8(%ebp),%eax
 84a:	83 e8 08             	sub    $0x8,%eax
 84d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 850:	a1 d8 0d 00 00       	mov    0xdd8,%eax
 855:	89 45 fc             	mov    %eax,-0x4(%ebp)
 858:	eb 24                	jmp    87e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85d:	8b 00                	mov    (%eax),%eax
 85f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 862:	77 12                	ja     876 <free+0x35>
 864:	8b 45 f8             	mov    -0x8(%ebp),%eax
 867:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 86a:	77 24                	ja     890 <free+0x4f>
 86c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86f:	8b 00                	mov    (%eax),%eax
 871:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 874:	77 1a                	ja     890 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 876:	8b 45 fc             	mov    -0x4(%ebp),%eax
 879:	8b 00                	mov    (%eax),%eax
 87b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 87e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 881:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 884:	76 d4                	jbe    85a <free+0x19>
 886:	8b 45 fc             	mov    -0x4(%ebp),%eax
 889:	8b 00                	mov    (%eax),%eax
 88b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 88e:	76 ca                	jbe    85a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 890:	8b 45 f8             	mov    -0x8(%ebp),%eax
 893:	8b 40 04             	mov    0x4(%eax),%eax
 896:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 89d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a0:	01 c2                	add    %eax,%edx
 8a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a5:	8b 00                	mov    (%eax),%eax
 8a7:	39 c2                	cmp    %eax,%edx
 8a9:	75 24                	jne    8cf <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ae:	8b 50 04             	mov    0x4(%eax),%edx
 8b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b4:	8b 00                	mov    (%eax),%eax
 8b6:	8b 40 04             	mov    0x4(%eax),%eax
 8b9:	01 c2                	add    %eax,%edx
 8bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8be:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c4:	8b 00                	mov    (%eax),%eax
 8c6:	8b 10                	mov    (%eax),%edx
 8c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cb:	89 10                	mov    %edx,(%eax)
 8cd:	eb 0a                	jmp    8d9 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d2:	8b 10                	mov    (%eax),%edx
 8d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d7:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8dc:	8b 40 04             	mov    0x4(%eax),%eax
 8df:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e9:	01 d0                	add    %edx,%eax
 8eb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8ee:	75 20                	jne    910 <free+0xcf>
    p->s.size += bp->s.size;
 8f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f3:	8b 50 04             	mov    0x4(%eax),%edx
 8f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f9:	8b 40 04             	mov    0x4(%eax),%eax
 8fc:	01 c2                	add    %eax,%edx
 8fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 901:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 904:	8b 45 f8             	mov    -0x8(%ebp),%eax
 907:	8b 10                	mov    (%eax),%edx
 909:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90c:	89 10                	mov    %edx,(%eax)
 90e:	eb 08                	jmp    918 <free+0xd7>
  } else
    p->s.ptr = bp;
 910:	8b 45 fc             	mov    -0x4(%ebp),%eax
 913:	8b 55 f8             	mov    -0x8(%ebp),%edx
 916:	89 10                	mov    %edx,(%eax)
  freep = p;
 918:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91b:	a3 d8 0d 00 00       	mov    %eax,0xdd8
}
 920:	c9                   	leave  
 921:	c3                   	ret    

00000922 <morecore>:

static Header*
morecore(uint nu)
{
 922:	55                   	push   %ebp
 923:	89 e5                	mov    %esp,%ebp
 925:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 928:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 92f:	77 07                	ja     938 <morecore+0x16>
    nu = 4096;
 931:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 938:	8b 45 08             	mov    0x8(%ebp),%eax
 93b:	c1 e0 03             	shl    $0x3,%eax
 93e:	89 04 24             	mov    %eax,(%esp)
 941:	e8 40 fc ff ff       	call   586 <sbrk>
 946:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 949:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 94d:	75 07                	jne    956 <morecore+0x34>
    return 0;
 94f:	b8 00 00 00 00       	mov    $0x0,%eax
 954:	eb 22                	jmp    978 <morecore+0x56>
  hp = (Header*)p;
 956:	8b 45 f4             	mov    -0xc(%ebp),%eax
 959:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 95c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95f:	8b 55 08             	mov    0x8(%ebp),%edx
 962:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 965:	8b 45 f0             	mov    -0x10(%ebp),%eax
 968:	83 c0 08             	add    $0x8,%eax
 96b:	89 04 24             	mov    %eax,(%esp)
 96e:	e8 ce fe ff ff       	call   841 <free>
  return freep;
 973:	a1 d8 0d 00 00       	mov    0xdd8,%eax
}
 978:	c9                   	leave  
 979:	c3                   	ret    

0000097a <malloc>:

void*
malloc(uint nbytes)
{
 97a:	55                   	push   %ebp
 97b:	89 e5                	mov    %esp,%ebp
 97d:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 980:	8b 45 08             	mov    0x8(%ebp),%eax
 983:	83 c0 07             	add    $0x7,%eax
 986:	c1 e8 03             	shr    $0x3,%eax
 989:	83 c0 01             	add    $0x1,%eax
 98c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 98f:	a1 d8 0d 00 00       	mov    0xdd8,%eax
 994:	89 45 f0             	mov    %eax,-0x10(%ebp)
 997:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 99b:	75 23                	jne    9c0 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 99d:	c7 45 f0 d0 0d 00 00 	movl   $0xdd0,-0x10(%ebp)
 9a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a7:	a3 d8 0d 00 00       	mov    %eax,0xdd8
 9ac:	a1 d8 0d 00 00       	mov    0xdd8,%eax
 9b1:	a3 d0 0d 00 00       	mov    %eax,0xdd0
    base.s.size = 0;
 9b6:	c7 05 d4 0d 00 00 00 	movl   $0x0,0xdd4
 9bd:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c3:	8b 00                	mov    (%eax),%eax
 9c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cb:	8b 40 04             	mov    0x4(%eax),%eax
 9ce:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9d1:	72 4d                	jb     a20 <malloc+0xa6>
      if(p->s.size == nunits)
 9d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d6:	8b 40 04             	mov    0x4(%eax),%eax
 9d9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9dc:	75 0c                	jne    9ea <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e1:	8b 10                	mov    (%eax),%edx
 9e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e6:	89 10                	mov    %edx,(%eax)
 9e8:	eb 26                	jmp    a10 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ed:	8b 40 04             	mov    0x4(%eax),%eax
 9f0:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9f3:	89 c2                	mov    %eax,%edx
 9f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f8:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fe:	8b 40 04             	mov    0x4(%eax),%eax
 a01:	c1 e0 03             	shl    $0x3,%eax
 a04:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a0d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a13:	a3 d8 0d 00 00       	mov    %eax,0xdd8
      return (void*)(p + 1);
 a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1b:	83 c0 08             	add    $0x8,%eax
 a1e:	eb 38                	jmp    a58 <malloc+0xde>
    }
    if(p == freep)
 a20:	a1 d8 0d 00 00       	mov    0xdd8,%eax
 a25:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a28:	75 1b                	jne    a45 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 a2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a2d:	89 04 24             	mov    %eax,(%esp)
 a30:	e8 ed fe ff ff       	call   922 <morecore>
 a35:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a3c:	75 07                	jne    a45 <malloc+0xcb>
        return 0;
 a3e:	b8 00 00 00 00       	mov    $0x0,%eax
 a43:	eb 13                	jmp    a58 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a48:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4e:	8b 00                	mov    (%eax),%eax
 a50:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a53:	e9 70 ff ff ff       	jmp    9c8 <malloc+0x4e>
}
 a58:	c9                   	leave  
 a59:	c3                   	ret    
