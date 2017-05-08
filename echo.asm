
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  for(i = 1; i < argc; i++)
   9:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  10:	00 
  11:	eb 4b                	jmp    5e <main+0x5e>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  13:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  17:	83 c0 01             	add    $0x1,%eax
  1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  1d:	7d 07                	jge    26 <main+0x26>
  1f:	b8 a3 0a 00 00       	mov    $0xaa3,%eax
  24:	eb 05                	jmp    2b <main+0x2b>
  26:	b8 a5 0a 00 00       	mov    $0xaa5,%eax
  2b:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2f:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  36:	8b 55 0c             	mov    0xc(%ebp),%edx
  39:	01 ca                	add    %ecx,%edx
  3b:	8b 12                	mov    (%edx),%edx
  3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  41:	89 54 24 08          	mov    %edx,0x8(%esp)
  45:	c7 44 24 04 a7 0a 00 	movl   $0xaa7,0x4(%esp)
  4c:	00 
  4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  54:	e8 7e 06 00 00       	call   6d7 <printf>
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  59:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  5e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  62:	3b 45 08             	cmp    0x8(%ebp),%eax
  65:	7c ac                	jl     13 <main+0x13>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  67:	e8 db 04 00 00       	call   547 <exit>

0000006c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	57                   	push   %edi
  70:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  74:	8b 55 10             	mov    0x10(%ebp),%edx
  77:	8b 45 0c             	mov    0xc(%ebp),%eax
  7a:	89 cb                	mov    %ecx,%ebx
  7c:	89 df                	mov    %ebx,%edi
  7e:	89 d1                	mov    %edx,%ecx
  80:	fc                   	cld    
  81:	f3 aa                	rep stos %al,%es:(%edi)
  83:	89 ca                	mov    %ecx,%edx
  85:	89 fb                	mov    %edi,%ebx
  87:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  8d:	5b                   	pop    %ebx
  8e:	5f                   	pop    %edi
  8f:	5d                   	pop    %ebp
  90:	c3                   	ret    

00000091 <thing>:
#include "user.h"
#include "x86.h"


int
thing(void){
  91:	55                   	push   %ebp
  92:	89 e5                	mov    %esp,%ebp
  return 1;
  94:	b8 01 00 00 00       	mov    $0x1,%eax
}
  99:	5d                   	pop    %ebp
  9a:	c3                   	ret    

0000009b <strcpy>:

char*
strcpy(char *s, char *t)
{
  9b:	55                   	push   %ebp
  9c:	89 e5                	mov    %esp,%ebp
  9e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a1:	8b 45 08             	mov    0x8(%ebp),%eax
  a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a7:	90                   	nop
  a8:	8b 45 08             	mov    0x8(%ebp),%eax
  ab:	8d 50 01             	lea    0x1(%eax),%edx
  ae:	89 55 08             	mov    %edx,0x8(%ebp)
  b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  b4:	8d 4a 01             	lea    0x1(%edx),%ecx
  b7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  ba:	0f b6 12             	movzbl (%edx),%edx
  bd:	88 10                	mov    %dl,(%eax)
  bf:	0f b6 00             	movzbl (%eax),%eax
  c2:	84 c0                	test   %al,%al
  c4:	75 e2                	jne    a8 <strcpy+0xd>
    ;
  return os;
  c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c9:	c9                   	leave  
  ca:	c3                   	ret    

000000cb <strcmp>:



int
strcmp(const char *p, const char *q)
{
  cb:	55                   	push   %ebp
  cc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  ce:	eb 08                	jmp    d8 <strcmp+0xd>
    p++, q++;
  d0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)


int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d8:	8b 45 08             	mov    0x8(%ebp),%eax
  db:	0f b6 00             	movzbl (%eax),%eax
  de:	84 c0                	test   %al,%al
  e0:	74 10                	je     f2 <strcmp+0x27>
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	0f b6 10             	movzbl (%eax),%edx
  e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  eb:	0f b6 00             	movzbl (%eax),%eax
  ee:	38 c2                	cmp    %al,%dl
  f0:	74 de                	je     d0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f2:	8b 45 08             	mov    0x8(%ebp),%eax
  f5:	0f b6 00             	movzbl (%eax),%eax
  f8:	0f b6 d0             	movzbl %al,%edx
  fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  fe:	0f b6 00             	movzbl (%eax),%eax
 101:	0f b6 c0             	movzbl %al,%eax
 104:	29 c2                	sub    %eax,%edx
 106:	89 d0                	mov    %edx,%eax
}
 108:	5d                   	pop    %ebp
 109:	c3                   	ret    

0000010a <strlen>:

uint
strlen(char *s)
{
 10a:	55                   	push   %ebp
 10b:	89 e5                	mov    %esp,%ebp
 10d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 110:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 117:	eb 04                	jmp    11d <strlen+0x13>
 119:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 120:	8b 45 08             	mov    0x8(%ebp),%eax
 123:	01 d0                	add    %edx,%eax
 125:	0f b6 00             	movzbl (%eax),%eax
 128:	84 c0                	test   %al,%al
 12a:	75 ed                	jne    119 <strlen+0xf>
    ;
  return n;
 12c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12f:	c9                   	leave  
 130:	c3                   	ret    

00000131 <stringlen>:

uint
stringlen(char **s){
 131:	55                   	push   %ebp
 132:	89 e5                	mov    %esp,%ebp
 134:	83 ec 10             	sub    $0x10,%esp
	int n;

  for(n = 0; s[n]; n++)
 137:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 13e:	eb 04                	jmp    144 <stringlen+0x13>
 140:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 144:	8b 45 fc             	mov    -0x4(%ebp),%eax
 147:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 14e:	8b 45 08             	mov    0x8(%ebp),%eax
 151:	01 d0                	add    %edx,%eax
 153:	8b 00                	mov    (%eax),%eax
 155:	85 c0                	test   %eax,%eax
 157:	75 e7                	jne    140 <stringlen+0xf>
    ;
  return n;
 159:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 15c:	c9                   	leave  
 15d:	c3                   	ret    

0000015e <memset>:

void*
memset(void *dst, int c, uint n)
{
 15e:	55                   	push   %ebp
 15f:	89 e5                	mov    %esp,%ebp
 161:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 164:	8b 45 10             	mov    0x10(%ebp),%eax
 167:	89 44 24 08          	mov    %eax,0x8(%esp)
 16b:	8b 45 0c             	mov    0xc(%ebp),%eax
 16e:	89 44 24 04          	mov    %eax,0x4(%esp)
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	89 04 24             	mov    %eax,(%esp)
 178:	e8 ef fe ff ff       	call   6c <stosb>
  return dst;
 17d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 180:	c9                   	leave  
 181:	c3                   	ret    

00000182 <strchr>:

char*
strchr(const char *s, char c)
{
 182:	55                   	push   %ebp
 183:	89 e5                	mov    %esp,%ebp
 185:	83 ec 04             	sub    $0x4,%esp
 188:	8b 45 0c             	mov    0xc(%ebp),%eax
 18b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 18e:	eb 14                	jmp    1a4 <strchr+0x22>
    if(*s == c)
 190:	8b 45 08             	mov    0x8(%ebp),%eax
 193:	0f b6 00             	movzbl (%eax),%eax
 196:	3a 45 fc             	cmp    -0x4(%ebp),%al
 199:	75 05                	jne    1a0 <strchr+0x1e>
      return (char*)s;
 19b:	8b 45 08             	mov    0x8(%ebp),%eax
 19e:	eb 13                	jmp    1b3 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1a0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	0f b6 00             	movzbl (%eax),%eax
 1aa:	84 c0                	test   %al,%al
 1ac:	75 e2                	jne    190 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1b3:	c9                   	leave  
 1b4:	c3                   	ret    

000001b5 <gets>:

char*
gets(char *buf, int max)
{
 1b5:	55                   	push   %ebp
 1b6:	89 e5                	mov    %esp,%ebp
 1b8:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1c2:	eb 4c                	jmp    210 <gets+0x5b>
    cc = read(0, &c, 1);
 1c4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1cb:	00 
 1cc:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1cf:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1da:	e8 80 03 00 00       	call   55f <read>
 1df:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1e6:	7f 02                	jg     1ea <gets+0x35>
      break;
 1e8:	eb 31                	jmp    21b <gets+0x66>
    buf[i++] = c;
 1ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ed:	8d 50 01             	lea    0x1(%eax),%edx
 1f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1f3:	89 c2                	mov    %eax,%edx
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
 1f8:	01 c2                	add    %eax,%edx
 1fa:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1fe:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 200:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 204:	3c 0a                	cmp    $0xa,%al
 206:	74 13                	je     21b <gets+0x66>
 208:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 20c:	3c 0d                	cmp    $0xd,%al
 20e:	74 0b                	je     21b <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 210:	8b 45 f4             	mov    -0xc(%ebp),%eax
 213:	83 c0 01             	add    $0x1,%eax
 216:	3b 45 0c             	cmp    0xc(%ebp),%eax
 219:	7c a9                	jl     1c4 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 21b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 21e:	8b 45 08             	mov    0x8(%ebp),%eax
 221:	01 d0                	add    %edx,%eax
 223:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 226:	8b 45 08             	mov    0x8(%ebp),%eax
}
 229:	c9                   	leave  
 22a:	c3                   	ret    

0000022b <stat>:

int
stat(char *n, struct stat *st)
{
 22b:	55                   	push   %ebp
 22c:	89 e5                	mov    %esp,%ebp
 22e:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 231:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 238:	00 
 239:	8b 45 08             	mov    0x8(%ebp),%eax
 23c:	89 04 24             	mov    %eax,(%esp)
 23f:	e8 43 03 00 00       	call   587 <open>
 244:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 247:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 24b:	79 07                	jns    254 <stat+0x29>
    return -1;
 24d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 252:	eb 23                	jmp    277 <stat+0x4c>
  r = fstat(fd, st);
 254:	8b 45 0c             	mov    0xc(%ebp),%eax
 257:	89 44 24 04          	mov    %eax,0x4(%esp)
 25b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25e:	89 04 24             	mov    %eax,(%esp)
 261:	e8 39 03 00 00       	call   59f <fstat>
 266:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 269:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26c:	89 04 24             	mov    %eax,(%esp)
 26f:	e8 fb 02 00 00       	call   56f <close>
  return r;
 274:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <atoi>:

int
atoi(const char *s)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
 27c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 27f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 286:	eb 25                	jmp    2ad <atoi+0x34>
    n = n*10 + *s++ - '0';
 288:	8b 55 fc             	mov    -0x4(%ebp),%edx
 28b:	89 d0                	mov    %edx,%eax
 28d:	c1 e0 02             	shl    $0x2,%eax
 290:	01 d0                	add    %edx,%eax
 292:	01 c0                	add    %eax,%eax
 294:	89 c1                	mov    %eax,%ecx
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	8d 50 01             	lea    0x1(%eax),%edx
 29c:	89 55 08             	mov    %edx,0x8(%ebp)
 29f:	0f b6 00             	movzbl (%eax),%eax
 2a2:	0f be c0             	movsbl %al,%eax
 2a5:	01 c8                	add    %ecx,%eax
 2a7:	83 e8 30             	sub    $0x30,%eax
 2aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	0f b6 00             	movzbl (%eax),%eax
 2b3:	3c 2f                	cmp    $0x2f,%al
 2b5:	7e 0a                	jle    2c1 <atoi+0x48>
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	0f b6 00             	movzbl (%eax),%eax
 2bd:	3c 39                	cmp    $0x39,%al
 2bf:	7e c7                	jle    288 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2d8:	eb 17                	jmp    2f1 <memmove+0x2b>
    *dst++ = *src++;
 2da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2dd:	8d 50 01             	lea    0x1(%eax),%edx
 2e0:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2e3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2e6:	8d 4a 01             	lea    0x1(%edx),%ecx
 2e9:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2ec:	0f b6 12             	movzbl (%edx),%edx
 2ef:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2f1:	8b 45 10             	mov    0x10(%ebp),%eax
 2f4:	8d 50 ff             	lea    -0x1(%eax),%edx
 2f7:	89 55 10             	mov    %edx,0x10(%ebp)
 2fa:	85 c0                	test   %eax,%eax
 2fc:	7f dc                	jg     2da <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2fe:	8b 45 08             	mov    0x8(%ebp),%eax
}
 301:	c9                   	leave  
 302:	c3                   	ret    

00000303 <strcmp_c>:


int
strcmp_c(const char *s1, const char *s2)
{
 303:	55                   	push   %ebp
 304:	89 e5                	mov    %esp,%ebp
    for ( ; *s1 == *s2; s1++, s2++)
 306:	eb 19                	jmp    321 <strcmp_c+0x1e>
	if (*s1 == '\0')
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	0f b6 00             	movzbl (%eax),%eax
 30e:	84 c0                	test   %al,%al
 310:	75 07                	jne    319 <strcmp_c+0x16>
	    return 0;
 312:	b8 00 00 00 00       	mov    $0x0,%eax
 317:	eb 34                	jmp    34d <strcmp_c+0x4a>


int
strcmp_c(const char *s1, const char *s2)
{
    for ( ; *s1 == *s2; s1++, s2++)
 319:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 31d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 321:	8b 45 08             	mov    0x8(%ebp),%eax
 324:	0f b6 10             	movzbl (%eax),%edx
 327:	8b 45 0c             	mov    0xc(%ebp),%eax
 32a:	0f b6 00             	movzbl (%eax),%eax
 32d:	38 c2                	cmp    %al,%dl
 32f:	74 d7                	je     308 <strcmp_c+0x5>
	if (*s1 == '\0')
	    return 0;
    return ((*(unsigned char *)s1 < *(unsigned char *)s2) ? -1 : +1);
 331:	8b 45 08             	mov    0x8(%ebp),%eax
 334:	0f b6 10             	movzbl (%eax),%edx
 337:	8b 45 0c             	mov    0xc(%ebp),%eax
 33a:	0f b6 00             	movzbl (%eax),%eax
 33d:	38 c2                	cmp    %al,%dl
 33f:	73 07                	jae    348 <strcmp_c+0x45>
 341:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 346:	eb 05                	jmp    34d <strcmp_c+0x4a>
 348:	b8 01 00 00 00       	mov    $0x1,%eax
}
 34d:	5d                   	pop    %ebp
 34e:	c3                   	ret    

0000034f <readuser>:


struct USER
readuser(){
 34f:	55                   	push   %ebp
 350:	89 e5                	mov    %esp,%ebp
 352:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char buff1[512], buff2[512];
	struct USER u;
	printf(1,"Please enter a username: ");
 358:	c7 44 24 04 ac 0a 00 	movl   $0xaac,0x4(%esp)
 35f:	00 
 360:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 367:	e8 6b 03 00 00       	call   6d7 <printf>
	u.name = gets(buff1, 50);
 36c:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 373:	00 
 374:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
 37a:	89 04 24             	mov    %eax,(%esp)
 37d:	e8 33 fe ff ff       	call   1b5 <gets>
 382:	89 85 ec fb ff ff    	mov    %eax,-0x414(%ebp)
	printf(1,"Please enter a password: ");
 388:	c7 44 24 04 c6 0a 00 	movl   $0xac6,0x4(%esp)
 38f:	00 
 390:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 397:	e8 3b 03 00 00       	call   6d7 <printf>
	u.pass = gets(buff2, 50);
 39c:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 3a3:	00 
 3a4:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
 3aa:	89 04 24             	mov    %eax,(%esp)
 3ad:	e8 03 fe ff ff       	call   1b5 <gets>
 3b2:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
	return u;
 3b8:	8b 45 08             	mov    0x8(%ebp),%eax
 3bb:	8b 95 ec fb ff ff    	mov    -0x414(%ebp),%edx
 3c1:	89 10                	mov    %edx,(%eax)
 3c3:	8b 95 f0 fb ff ff    	mov    -0x410(%ebp),%edx
 3c9:	89 50 04             	mov    %edx,0x4(%eax)
 3cc:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
 3d2:	89 50 08             	mov    %edx,0x8(%eax)
}
 3d5:	8b 45 08             	mov    0x8(%ebp),%eax
 3d8:	c9                   	leave  
 3d9:	c2 04 00             	ret    $0x4

000003dc <compareuser>:


int
compareuser(int state){
 3dc:	55                   	push   %ebp
 3dd:	89 e5                	mov    %esp,%ebp
 3df:	56                   	push   %esi
 3e0:	53                   	push   %ebx
 3e1:	81 ec 30 01 00 00    	sub    $0x130,%esp
	struct USER u1,u2;
	struct USER users[20];
	u1.name = "john\n";
 3e7:	c7 45 e8 e0 0a 00 00 	movl   $0xae0,-0x18(%ebp)
	u1.pass = "1234\n";
 3ee:	c7 45 ec e6 0a 00 00 	movl   $0xae6,-0x14(%ebp)
	u1.ulevel = 0;
 3f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	u2.name = "james\n";
 3fc:	c7 45 dc ec 0a 00 00 	movl   $0xaec,-0x24(%ebp)
	u2.pass = "pass\n";
 403:	c7 45 e0 f3 0a 00 00 	movl   $0xaf3,-0x20(%ebp)
	u2.ulevel = 1;
 40a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	users[0] = u1;
 411:	8b 45 e8             	mov    -0x18(%ebp),%eax
 414:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
 41a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
 423:	8b 45 f0             	mov    -0x10(%ebp),%eax
 426:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
	users[1] = u2;
 42c:	8b 45 dc             	mov    -0x24(%ebp),%eax
 42f:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
 435:	8b 45 e0             	mov    -0x20(%ebp),%eax
 438:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
 43e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 441:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
	
	
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
 447:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
 44d:	89 04 24             	mov    %eax,(%esp)
 450:	e8 fa fe ff ff       	call   34f <readuser>
 455:	83 ec 04             	sub    $0x4,%esp
		
		for(ctr = 0; ctr < 20; ctr++)
 458:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 45f:	e9 a4 00 00 00       	jmp    508 <compareuser+0x12c>
		{

			if(strcmp_c(u.name,users[ctr].name) == 0 && strcmp_c(u.pass,users[ctr].pass) == 0)
 464:	8b 55 f4             	mov    -0xc(%ebp),%edx
 467:	89 d0                	mov    %edx,%eax
 469:	01 c0                	add    %eax,%eax
 46b:	01 d0                	add    %edx,%eax
 46d:	c1 e0 02             	shl    $0x2,%eax
 470:	8d 4d f8             	lea    -0x8(%ebp),%ecx
 473:	01 c8                	add    %ecx,%eax
 475:	2d 0c 01 00 00       	sub    $0x10c,%eax
 47a:	8b 10                	mov    (%eax),%edx
 47c:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
 482:	89 54 24 04          	mov    %edx,0x4(%esp)
 486:	89 04 24             	mov    %eax,(%esp)
 489:	e8 75 fe ff ff       	call   303 <strcmp_c>
 48e:	85 c0                	test   %eax,%eax
 490:	75 72                	jne    504 <compareuser+0x128>
 492:	8b 55 f4             	mov    -0xc(%ebp),%edx
 495:	89 d0                	mov    %edx,%eax
 497:	01 c0                	add    %eax,%eax
 499:	01 d0                	add    %edx,%eax
 49b:	c1 e0 02             	shl    $0x2,%eax
 49e:	8d 5d f8             	lea    -0x8(%ebp),%ebx
 4a1:	01 d8                	add    %ebx,%eax
 4a3:	2d 08 01 00 00       	sub    $0x108,%eax
 4a8:	8b 10                	mov    (%eax),%edx
 4aa:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
 4b0:	89 54 24 04          	mov    %edx,0x4(%esp)
 4b4:	89 04 24             	mov    %eax,(%esp)
 4b7:	e8 47 fe ff ff       	call   303 <strcmp_c>
 4bc:	85 c0                	test   %eax,%eax
 4be:	75 44                	jne    504 <compareuser+0x128>
			{
				setuser(users[ctr].ulevel);
 4c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4c3:	89 d0                	mov    %edx,%eax
 4c5:	01 c0                	add    %eax,%eax
 4c7:	01 d0                	add    %edx,%eax
 4c9:	c1 e0 02             	shl    $0x2,%eax
 4cc:	8d 75 f8             	lea    -0x8(%ebp),%esi
 4cf:	01 f0                	add    %esi,%eax
 4d1:	2d 04 01 00 00       	sub    $0x104,%eax
 4d6:	8b 00                	mov    (%eax),%eax
 4d8:	89 04 24             	mov    %eax,(%esp)
 4db:	e8 0f 01 00 00       	call   5ef <setuser>
				
				printf(1,"%d",getuser());
 4e0:	e8 02 01 00 00       	call   5e7 <getuser>
 4e5:	89 44 24 08          	mov    %eax,0x8(%esp)
 4e9:	c7 44 24 04 f9 0a 00 	movl   $0xaf9,0x4(%esp)
 4f0:	00 
 4f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4f8:	e8 da 01 00 00       	call   6d7 <printf>
				return 1;
 4fd:	b8 01 00 00 00       	mov    $0x1,%eax
 502:	eb 34                	jmp    538 <compareuser+0x15c>
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
		
		for(ctr = 0; ctr < 20; ctr++)
 504:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 508:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 50c:	0f 8e 52 ff ff ff    	jle    464 <compareuser+0x88>
				
				printf(1,"%d",getuser());
				return 1;
			}
		}
		printf(1,"Invalid username/password\n");
 512:	c7 44 24 04 fc 0a 00 	movl   $0xafc,0x4(%esp)
 519:	00 
 51a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 521:	e8 b1 01 00 00       	call   6d7 <printf>
		if(state != 1)
 526:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 52a:	74 07                	je     533 <compareuser+0x157>
			break;
	}
	return 0;
 52c:	b8 00 00 00 00       	mov    $0x0,%eax
 531:	eb 05                	jmp    538 <compareuser+0x15c>
			}
		}
		printf(1,"Invalid username/password\n");
		if(state != 1)
			break;
	}
 533:	e9 0f ff ff ff       	jmp    447 <compareuser+0x6b>
	return 0;
}
 538:	8d 65 f8             	lea    -0x8(%ebp),%esp
 53b:	5b                   	pop    %ebx
 53c:	5e                   	pop    %esi
 53d:	5d                   	pop    %ebp
 53e:	c3                   	ret    

0000053f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 53f:	b8 01 00 00 00       	mov    $0x1,%eax
 544:	cd 40                	int    $0x40
 546:	c3                   	ret    

00000547 <exit>:
SYSCALL(exit)
 547:	b8 02 00 00 00       	mov    $0x2,%eax
 54c:	cd 40                	int    $0x40
 54e:	c3                   	ret    

0000054f <wait>:
SYSCALL(wait)
 54f:	b8 03 00 00 00       	mov    $0x3,%eax
 554:	cd 40                	int    $0x40
 556:	c3                   	ret    

00000557 <pipe>:
SYSCALL(pipe)
 557:	b8 04 00 00 00       	mov    $0x4,%eax
 55c:	cd 40                	int    $0x40
 55e:	c3                   	ret    

0000055f <read>:
SYSCALL(read)
 55f:	b8 05 00 00 00       	mov    $0x5,%eax
 564:	cd 40                	int    $0x40
 566:	c3                   	ret    

00000567 <write>:
SYSCALL(write)
 567:	b8 10 00 00 00       	mov    $0x10,%eax
 56c:	cd 40                	int    $0x40
 56e:	c3                   	ret    

0000056f <close>:
SYSCALL(close)
 56f:	b8 15 00 00 00       	mov    $0x15,%eax
 574:	cd 40                	int    $0x40
 576:	c3                   	ret    

00000577 <kill>:
SYSCALL(kill)
 577:	b8 06 00 00 00       	mov    $0x6,%eax
 57c:	cd 40                	int    $0x40
 57e:	c3                   	ret    

0000057f <exec>:
SYSCALL(exec)
 57f:	b8 07 00 00 00       	mov    $0x7,%eax
 584:	cd 40                	int    $0x40
 586:	c3                   	ret    

00000587 <open>:
SYSCALL(open)
 587:	b8 0f 00 00 00       	mov    $0xf,%eax
 58c:	cd 40                	int    $0x40
 58e:	c3                   	ret    

0000058f <mknod>:
SYSCALL(mknod)
 58f:	b8 11 00 00 00       	mov    $0x11,%eax
 594:	cd 40                	int    $0x40
 596:	c3                   	ret    

00000597 <unlink>:
SYSCALL(unlink)
 597:	b8 12 00 00 00       	mov    $0x12,%eax
 59c:	cd 40                	int    $0x40
 59e:	c3                   	ret    

0000059f <fstat>:
SYSCALL(fstat)
 59f:	b8 08 00 00 00       	mov    $0x8,%eax
 5a4:	cd 40                	int    $0x40
 5a6:	c3                   	ret    

000005a7 <link>:
SYSCALL(link)
 5a7:	b8 13 00 00 00       	mov    $0x13,%eax
 5ac:	cd 40                	int    $0x40
 5ae:	c3                   	ret    

000005af <mkdir>:
SYSCALL(mkdir)
 5af:	b8 14 00 00 00       	mov    $0x14,%eax
 5b4:	cd 40                	int    $0x40
 5b6:	c3                   	ret    

000005b7 <chdir>:
SYSCALL(chdir)
 5b7:	b8 09 00 00 00       	mov    $0x9,%eax
 5bc:	cd 40                	int    $0x40
 5be:	c3                   	ret    

000005bf <dup>:
SYSCALL(dup)
 5bf:	b8 0a 00 00 00       	mov    $0xa,%eax
 5c4:	cd 40                	int    $0x40
 5c6:	c3                   	ret    

000005c7 <getpid>:
SYSCALL(getpid)
 5c7:	b8 0b 00 00 00       	mov    $0xb,%eax
 5cc:	cd 40                	int    $0x40
 5ce:	c3                   	ret    

000005cf <sbrk>:
SYSCALL(sbrk)
 5cf:	b8 0c 00 00 00       	mov    $0xc,%eax
 5d4:	cd 40                	int    $0x40
 5d6:	c3                   	ret    

000005d7 <sleep>:
SYSCALL(sleep)
 5d7:	b8 0d 00 00 00       	mov    $0xd,%eax
 5dc:	cd 40                	int    $0x40
 5de:	c3                   	ret    

000005df <uptime>:
SYSCALL(uptime)
 5df:	b8 0e 00 00 00       	mov    $0xe,%eax
 5e4:	cd 40                	int    $0x40
 5e6:	c3                   	ret    

000005e7 <getuser>:
SYSCALL(getuser)
 5e7:	b8 16 00 00 00       	mov    $0x16,%eax
 5ec:	cd 40                	int    $0x40
 5ee:	c3                   	ret    

000005ef <setuser>:
SYSCALL(setuser)
 5ef:	b8 17 00 00 00       	mov    $0x17,%eax
 5f4:	cd 40                	int    $0x40
 5f6:	c3                   	ret    

000005f7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5f7:	55                   	push   %ebp
 5f8:	89 e5                	mov    %esp,%ebp
 5fa:	83 ec 18             	sub    $0x18,%esp
 5fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 600:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 603:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 60a:	00 
 60b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 60e:	89 44 24 04          	mov    %eax,0x4(%esp)
 612:	8b 45 08             	mov    0x8(%ebp),%eax
 615:	89 04 24             	mov    %eax,(%esp)
 618:	e8 4a ff ff ff       	call   567 <write>
}
 61d:	c9                   	leave  
 61e:	c3                   	ret    

0000061f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 61f:	55                   	push   %ebp
 620:	89 e5                	mov    %esp,%ebp
 622:	56                   	push   %esi
 623:	53                   	push   %ebx
 624:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 627:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 62e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 632:	74 17                	je     64b <printint+0x2c>
 634:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 638:	79 11                	jns    64b <printint+0x2c>
    neg = 1;
 63a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 641:	8b 45 0c             	mov    0xc(%ebp),%eax
 644:	f7 d8                	neg    %eax
 646:	89 45 ec             	mov    %eax,-0x14(%ebp)
 649:	eb 06                	jmp    651 <printint+0x32>
  } else {
    x = xx;
 64b:	8b 45 0c             	mov    0xc(%ebp),%eax
 64e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 651:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 658:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 65b:	8d 41 01             	lea    0x1(%ecx),%eax
 65e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 661:	8b 5d 10             	mov    0x10(%ebp),%ebx
 664:	8b 45 ec             	mov    -0x14(%ebp),%eax
 667:	ba 00 00 00 00       	mov    $0x0,%edx
 66c:	f7 f3                	div    %ebx
 66e:	89 d0                	mov    %edx,%eax
 670:	0f b6 80 10 0e 00 00 	movzbl 0xe10(%eax),%eax
 677:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 67b:	8b 75 10             	mov    0x10(%ebp),%esi
 67e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 681:	ba 00 00 00 00       	mov    $0x0,%edx
 686:	f7 f6                	div    %esi
 688:	89 45 ec             	mov    %eax,-0x14(%ebp)
 68b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 68f:	75 c7                	jne    658 <printint+0x39>
  if(neg)
 691:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 695:	74 10                	je     6a7 <printint+0x88>
    buf[i++] = '-';
 697:	8b 45 f4             	mov    -0xc(%ebp),%eax
 69a:	8d 50 01             	lea    0x1(%eax),%edx
 69d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6a0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6a5:	eb 1f                	jmp    6c6 <printint+0xa7>
 6a7:	eb 1d                	jmp    6c6 <printint+0xa7>
    putc(fd, buf[i]);
 6a9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6af:	01 d0                	add    %edx,%eax
 6b1:	0f b6 00             	movzbl (%eax),%eax
 6b4:	0f be c0             	movsbl %al,%eax
 6b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 6bb:	8b 45 08             	mov    0x8(%ebp),%eax
 6be:	89 04 24             	mov    %eax,(%esp)
 6c1:	e8 31 ff ff ff       	call   5f7 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6c6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6ce:	79 d9                	jns    6a9 <printint+0x8a>
    putc(fd, buf[i]);
}
 6d0:	83 c4 30             	add    $0x30,%esp
 6d3:	5b                   	pop    %ebx
 6d4:	5e                   	pop    %esi
 6d5:	5d                   	pop    %ebp
 6d6:	c3                   	ret    

000006d7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6d7:	55                   	push   %ebp
 6d8:	89 e5                	mov    %esp,%ebp
 6da:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6dd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6e4:	8d 45 0c             	lea    0xc(%ebp),%eax
 6e7:	83 c0 04             	add    $0x4,%eax
 6ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6f4:	e9 7c 01 00 00       	jmp    875 <printf+0x19e>
    c = fmt[i] & 0xff;
 6f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 6fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ff:	01 d0                	add    %edx,%eax
 701:	0f b6 00             	movzbl (%eax),%eax
 704:	0f be c0             	movsbl %al,%eax
 707:	25 ff 00 00 00       	and    $0xff,%eax
 70c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 70f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 713:	75 2c                	jne    741 <printf+0x6a>
      if(c == '%'){
 715:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 719:	75 0c                	jne    727 <printf+0x50>
        state = '%';
 71b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 722:	e9 4a 01 00 00       	jmp    871 <printf+0x19a>
      } else {
        putc(fd, c);
 727:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 72a:	0f be c0             	movsbl %al,%eax
 72d:	89 44 24 04          	mov    %eax,0x4(%esp)
 731:	8b 45 08             	mov    0x8(%ebp),%eax
 734:	89 04 24             	mov    %eax,(%esp)
 737:	e8 bb fe ff ff       	call   5f7 <putc>
 73c:	e9 30 01 00 00       	jmp    871 <printf+0x19a>
      }
    } else if(state == '%'){
 741:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 745:	0f 85 26 01 00 00    	jne    871 <printf+0x19a>
      if(c == 'd'){
 74b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 74f:	75 2d                	jne    77e <printf+0xa7>
        printint(fd, *ap, 10, 1);
 751:	8b 45 e8             	mov    -0x18(%ebp),%eax
 754:	8b 00                	mov    (%eax),%eax
 756:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 75d:	00 
 75e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 765:	00 
 766:	89 44 24 04          	mov    %eax,0x4(%esp)
 76a:	8b 45 08             	mov    0x8(%ebp),%eax
 76d:	89 04 24             	mov    %eax,(%esp)
 770:	e8 aa fe ff ff       	call   61f <printint>
        ap++;
 775:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 779:	e9 ec 00 00 00       	jmp    86a <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 77e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 782:	74 06                	je     78a <printf+0xb3>
 784:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 788:	75 2d                	jne    7b7 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 78a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 78d:	8b 00                	mov    (%eax),%eax
 78f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 796:	00 
 797:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 79e:	00 
 79f:	89 44 24 04          	mov    %eax,0x4(%esp)
 7a3:	8b 45 08             	mov    0x8(%ebp),%eax
 7a6:	89 04 24             	mov    %eax,(%esp)
 7a9:	e8 71 fe ff ff       	call   61f <printint>
        ap++;
 7ae:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7b2:	e9 b3 00 00 00       	jmp    86a <printf+0x193>
      } else if(c == 's'){
 7b7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7bb:	75 45                	jne    802 <printf+0x12b>
        s = (char*)*ap;
 7bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c0:	8b 00                	mov    (%eax),%eax
 7c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7c5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7cd:	75 09                	jne    7d8 <printf+0x101>
          s = "(null)";
 7cf:	c7 45 f4 17 0b 00 00 	movl   $0xb17,-0xc(%ebp)
        while(*s != 0){
 7d6:	eb 1e                	jmp    7f6 <printf+0x11f>
 7d8:	eb 1c                	jmp    7f6 <printf+0x11f>
          putc(fd, *s);
 7da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dd:	0f b6 00             	movzbl (%eax),%eax
 7e0:	0f be c0             	movsbl %al,%eax
 7e3:	89 44 24 04          	mov    %eax,0x4(%esp)
 7e7:	8b 45 08             	mov    0x8(%ebp),%eax
 7ea:	89 04 24             	mov    %eax,(%esp)
 7ed:	e8 05 fe ff ff       	call   5f7 <putc>
          s++;
 7f2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f9:	0f b6 00             	movzbl (%eax),%eax
 7fc:	84 c0                	test   %al,%al
 7fe:	75 da                	jne    7da <printf+0x103>
 800:	eb 68                	jmp    86a <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 802:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 806:	75 1d                	jne    825 <printf+0x14e>
        putc(fd, *ap);
 808:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80b:	8b 00                	mov    (%eax),%eax
 80d:	0f be c0             	movsbl %al,%eax
 810:	89 44 24 04          	mov    %eax,0x4(%esp)
 814:	8b 45 08             	mov    0x8(%ebp),%eax
 817:	89 04 24             	mov    %eax,(%esp)
 81a:	e8 d8 fd ff ff       	call   5f7 <putc>
        ap++;
 81f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 823:	eb 45                	jmp    86a <printf+0x193>
      } else if(c == '%'){
 825:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 829:	75 17                	jne    842 <printf+0x16b>
        putc(fd, c);
 82b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 82e:	0f be c0             	movsbl %al,%eax
 831:	89 44 24 04          	mov    %eax,0x4(%esp)
 835:	8b 45 08             	mov    0x8(%ebp),%eax
 838:	89 04 24             	mov    %eax,(%esp)
 83b:	e8 b7 fd ff ff       	call   5f7 <putc>
 840:	eb 28                	jmp    86a <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 842:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 849:	00 
 84a:	8b 45 08             	mov    0x8(%ebp),%eax
 84d:	89 04 24             	mov    %eax,(%esp)
 850:	e8 a2 fd ff ff       	call   5f7 <putc>
        putc(fd, c);
 855:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 858:	0f be c0             	movsbl %al,%eax
 85b:	89 44 24 04          	mov    %eax,0x4(%esp)
 85f:	8b 45 08             	mov    0x8(%ebp),%eax
 862:	89 04 24             	mov    %eax,(%esp)
 865:	e8 8d fd ff ff       	call   5f7 <putc>
      }
      state = 0;
 86a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 871:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 875:	8b 55 0c             	mov    0xc(%ebp),%edx
 878:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87b:	01 d0                	add    %edx,%eax
 87d:	0f b6 00             	movzbl (%eax),%eax
 880:	84 c0                	test   %al,%al
 882:	0f 85 71 fe ff ff    	jne    6f9 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 888:	c9                   	leave  
 889:	c3                   	ret    

0000088a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 88a:	55                   	push   %ebp
 88b:	89 e5                	mov    %esp,%ebp
 88d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 890:	8b 45 08             	mov    0x8(%ebp),%eax
 893:	83 e8 08             	sub    $0x8,%eax
 896:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 899:	a1 2c 0e 00 00       	mov    0xe2c,%eax
 89e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8a1:	eb 24                	jmp    8c7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a6:	8b 00                	mov    (%eax),%eax
 8a8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ab:	77 12                	ja     8bf <free+0x35>
 8ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8b3:	77 24                	ja     8d9 <free+0x4f>
 8b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b8:	8b 00                	mov    (%eax),%eax
 8ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8bd:	77 1a                	ja     8d9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c2:	8b 00                	mov    (%eax),%eax
 8c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8cd:	76 d4                	jbe    8a3 <free+0x19>
 8cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d2:	8b 00                	mov    (%eax),%eax
 8d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8d7:	76 ca                	jbe    8a3 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8dc:	8b 40 04             	mov    0x4(%eax),%eax
 8df:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e9:	01 c2                	add    %eax,%edx
 8eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ee:	8b 00                	mov    (%eax),%eax
 8f0:	39 c2                	cmp    %eax,%edx
 8f2:	75 24                	jne    918 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f7:	8b 50 04             	mov    0x4(%eax),%edx
 8fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fd:	8b 00                	mov    (%eax),%eax
 8ff:	8b 40 04             	mov    0x4(%eax),%eax
 902:	01 c2                	add    %eax,%edx
 904:	8b 45 f8             	mov    -0x8(%ebp),%eax
 907:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 90a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90d:	8b 00                	mov    (%eax),%eax
 90f:	8b 10                	mov    (%eax),%edx
 911:	8b 45 f8             	mov    -0x8(%ebp),%eax
 914:	89 10                	mov    %edx,(%eax)
 916:	eb 0a                	jmp    922 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 918:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91b:	8b 10                	mov    (%eax),%edx
 91d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 920:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 922:	8b 45 fc             	mov    -0x4(%ebp),%eax
 925:	8b 40 04             	mov    0x4(%eax),%eax
 928:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 92f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 932:	01 d0                	add    %edx,%eax
 934:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 937:	75 20                	jne    959 <free+0xcf>
    p->s.size += bp->s.size;
 939:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93c:	8b 50 04             	mov    0x4(%eax),%edx
 93f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 942:	8b 40 04             	mov    0x4(%eax),%eax
 945:	01 c2                	add    %eax,%edx
 947:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 94d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 950:	8b 10                	mov    (%eax),%edx
 952:	8b 45 fc             	mov    -0x4(%ebp),%eax
 955:	89 10                	mov    %edx,(%eax)
 957:	eb 08                	jmp    961 <free+0xd7>
  } else
    p->s.ptr = bp;
 959:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 95f:	89 10                	mov    %edx,(%eax)
  freep = p;
 961:	8b 45 fc             	mov    -0x4(%ebp),%eax
 964:	a3 2c 0e 00 00       	mov    %eax,0xe2c
}
 969:	c9                   	leave  
 96a:	c3                   	ret    

0000096b <morecore>:

static Header*
morecore(uint nu)
{
 96b:	55                   	push   %ebp
 96c:	89 e5                	mov    %esp,%ebp
 96e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 971:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 978:	77 07                	ja     981 <morecore+0x16>
    nu = 4096;
 97a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 981:	8b 45 08             	mov    0x8(%ebp),%eax
 984:	c1 e0 03             	shl    $0x3,%eax
 987:	89 04 24             	mov    %eax,(%esp)
 98a:	e8 40 fc ff ff       	call   5cf <sbrk>
 98f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 992:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 996:	75 07                	jne    99f <morecore+0x34>
    return 0;
 998:	b8 00 00 00 00       	mov    $0x0,%eax
 99d:	eb 22                	jmp    9c1 <morecore+0x56>
  hp = (Header*)p;
 99f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a8:	8b 55 08             	mov    0x8(%ebp),%edx
 9ab:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b1:	83 c0 08             	add    $0x8,%eax
 9b4:	89 04 24             	mov    %eax,(%esp)
 9b7:	e8 ce fe ff ff       	call   88a <free>
  return freep;
 9bc:	a1 2c 0e 00 00       	mov    0xe2c,%eax
}
 9c1:	c9                   	leave  
 9c2:	c3                   	ret    

000009c3 <malloc>:

void*
malloc(uint nbytes)
{
 9c3:	55                   	push   %ebp
 9c4:	89 e5                	mov    %esp,%ebp
 9c6:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9c9:	8b 45 08             	mov    0x8(%ebp),%eax
 9cc:	83 c0 07             	add    $0x7,%eax
 9cf:	c1 e8 03             	shr    $0x3,%eax
 9d2:	83 c0 01             	add    $0x1,%eax
 9d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9d8:	a1 2c 0e 00 00       	mov    0xe2c,%eax
 9dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9e4:	75 23                	jne    a09 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9e6:	c7 45 f0 24 0e 00 00 	movl   $0xe24,-0x10(%ebp)
 9ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f0:	a3 2c 0e 00 00       	mov    %eax,0xe2c
 9f5:	a1 2c 0e 00 00       	mov    0xe2c,%eax
 9fa:	a3 24 0e 00 00       	mov    %eax,0xe24
    base.s.size = 0;
 9ff:	c7 05 28 0e 00 00 00 	movl   $0x0,0xe28
 a06:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a0c:	8b 00                	mov    (%eax),%eax
 a0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a14:	8b 40 04             	mov    0x4(%eax),%eax
 a17:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a1a:	72 4d                	jb     a69 <malloc+0xa6>
      if(p->s.size == nunits)
 a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1f:	8b 40 04             	mov    0x4(%eax),%eax
 a22:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a25:	75 0c                	jne    a33 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2a:	8b 10                	mov    (%eax),%edx
 a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2f:	89 10                	mov    %edx,(%eax)
 a31:	eb 26                	jmp    a59 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a36:	8b 40 04             	mov    0x4(%eax),%eax
 a39:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a3c:	89 c2                	mov    %eax,%edx
 a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a41:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a47:	8b 40 04             	mov    0x4(%eax),%eax
 a4a:	c1 e0 03             	shl    $0x3,%eax
 a4d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a53:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a56:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a5c:	a3 2c 0e 00 00       	mov    %eax,0xe2c
      return (void*)(p + 1);
 a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a64:	83 c0 08             	add    $0x8,%eax
 a67:	eb 38                	jmp    aa1 <malloc+0xde>
    }
    if(p == freep)
 a69:	a1 2c 0e 00 00       	mov    0xe2c,%eax
 a6e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a71:	75 1b                	jne    a8e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 a73:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a76:	89 04 24             	mov    %eax,(%esp)
 a79:	e8 ed fe ff ff       	call   96b <morecore>
 a7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a85:	75 07                	jne    a8e <malloc+0xcb>
        return 0;
 a87:	b8 00 00 00 00       	mov    $0x0,%eax
 a8c:	eb 13                	jmp    aa1 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a97:	8b 00                	mov    (%eax),%eax
 a99:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a9c:	e9 70 ff ff ff       	jmp    a11 <malloc+0x4e>
}
 aa1:	c9                   	leave  
 aa2:	c3                   	ret    
