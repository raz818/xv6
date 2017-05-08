
_ln:     file format elf32-i386


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
   6:	83 ec 10             	sub    $0x10,%esp
  if(argc != 3){
   9:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
   d:	74 19                	je     28 <main+0x28>
    printf(2, "Usage: ln old new\n");
   f:	c7 44 24 04 b0 0a 00 	movl   $0xab0,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 c1 06 00 00       	call   6e4 <printf>
    exit();
  23:	e8 2c 05 00 00       	call   554 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 08             	add    $0x8,%eax
  2e:	8b 10                	mov    (%eax),%edx
  30:	8b 45 0c             	mov    0xc(%ebp),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	89 54 24 04          	mov    %edx,0x4(%esp)
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 70 05 00 00       	call   5b4 <link>
  44:	85 c0                	test   %eax,%eax
  46:	79 2c                	jns    74 <main+0x74>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	8b 45 0c             	mov    0xc(%ebp),%eax
  4b:	83 c0 08             	add    $0x8,%eax
  4e:	8b 10                	mov    (%eax),%edx
  50:	8b 45 0c             	mov    0xc(%ebp),%eax
  53:	83 c0 04             	add    $0x4,%eax
  56:	8b 00                	mov    (%eax),%eax
  58:	89 54 24 0c          	mov    %edx,0xc(%esp)
  5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  60:	c7 44 24 04 c3 0a 00 	movl   $0xac3,0x4(%esp)
  67:	00 
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 70 06 00 00       	call   6e4 <printf>
  exit();
  74:	e8 db 04 00 00       	call   554 <exit>

00000079 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  79:	55                   	push   %ebp
  7a:	89 e5                	mov    %esp,%ebp
  7c:	57                   	push   %edi
  7d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  81:	8b 55 10             	mov    0x10(%ebp),%edx
  84:	8b 45 0c             	mov    0xc(%ebp),%eax
  87:	89 cb                	mov    %ecx,%ebx
  89:	89 df                	mov    %ebx,%edi
  8b:	89 d1                	mov    %edx,%ecx
  8d:	fc                   	cld    
  8e:	f3 aa                	rep stos %al,%es:(%edi)
  90:	89 ca                	mov    %ecx,%edx
  92:	89 fb                	mov    %edi,%ebx
  94:	89 5d 08             	mov    %ebx,0x8(%ebp)
  97:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9a:	5b                   	pop    %ebx
  9b:	5f                   	pop    %edi
  9c:	5d                   	pop    %ebp
  9d:	c3                   	ret    

0000009e <thing>:
#include "user.h"
#include "x86.h"


int
thing(void){
  9e:	55                   	push   %ebp
  9f:	89 e5                	mov    %esp,%ebp
  return 1;
  a1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  a6:	5d                   	pop    %ebp
  a7:	c3                   	ret    

000000a8 <strcpy>:

char*
strcpy(char *s, char *t)
{
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  ae:	8b 45 08             	mov    0x8(%ebp),%eax
  b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  b4:	90                   	nop
  b5:	8b 45 08             	mov    0x8(%ebp),%eax
  b8:	8d 50 01             	lea    0x1(%eax),%edx
  bb:	89 55 08             	mov    %edx,0x8(%ebp)
  be:	8b 55 0c             	mov    0xc(%ebp),%edx
  c1:	8d 4a 01             	lea    0x1(%edx),%ecx
  c4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  c7:	0f b6 12             	movzbl (%edx),%edx
  ca:	88 10                	mov    %dl,(%eax)
  cc:	0f b6 00             	movzbl (%eax),%eax
  cf:	84 c0                	test   %al,%al
  d1:	75 e2                	jne    b5 <strcpy+0xd>
    ;
  return os;
  d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d6:	c9                   	leave  
  d7:	c3                   	ret    

000000d8 <strcmp>:



int
strcmp(const char *p, const char *q)
{
  d8:	55                   	push   %ebp
  d9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  db:	eb 08                	jmp    e5 <strcmp+0xd>
    p++, q++;
  dd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  e1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)


int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e5:	8b 45 08             	mov    0x8(%ebp),%eax
  e8:	0f b6 00             	movzbl (%eax),%eax
  eb:	84 c0                	test   %al,%al
  ed:	74 10                	je     ff <strcmp+0x27>
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
  f2:	0f b6 10             	movzbl (%eax),%edx
  f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  f8:	0f b6 00             	movzbl (%eax),%eax
  fb:	38 c2                	cmp    %al,%dl
  fd:	74 de                	je     dd <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  ff:	8b 45 08             	mov    0x8(%ebp),%eax
 102:	0f b6 00             	movzbl (%eax),%eax
 105:	0f b6 d0             	movzbl %al,%edx
 108:	8b 45 0c             	mov    0xc(%ebp),%eax
 10b:	0f b6 00             	movzbl (%eax),%eax
 10e:	0f b6 c0             	movzbl %al,%eax
 111:	29 c2                	sub    %eax,%edx
 113:	89 d0                	mov    %edx,%eax
}
 115:	5d                   	pop    %ebp
 116:	c3                   	ret    

00000117 <strlen>:

uint
strlen(char *s)
{
 117:	55                   	push   %ebp
 118:	89 e5                	mov    %esp,%ebp
 11a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 11d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 124:	eb 04                	jmp    12a <strlen+0x13>
 126:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 12a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 12d:	8b 45 08             	mov    0x8(%ebp),%eax
 130:	01 d0                	add    %edx,%eax
 132:	0f b6 00             	movzbl (%eax),%eax
 135:	84 c0                	test   %al,%al
 137:	75 ed                	jne    126 <strlen+0xf>
    ;
  return n;
 139:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 13c:	c9                   	leave  
 13d:	c3                   	ret    

0000013e <stringlen>:

uint
stringlen(char **s){
 13e:	55                   	push   %ebp
 13f:	89 e5                	mov    %esp,%ebp
 141:	83 ec 10             	sub    $0x10,%esp
	int n;

  for(n = 0; s[n]; n++)
 144:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 14b:	eb 04                	jmp    151 <stringlen+0x13>
 14d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 151:	8b 45 fc             	mov    -0x4(%ebp),%eax
 154:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 15b:	8b 45 08             	mov    0x8(%ebp),%eax
 15e:	01 d0                	add    %edx,%eax
 160:	8b 00                	mov    (%eax),%eax
 162:	85 c0                	test   %eax,%eax
 164:	75 e7                	jne    14d <stringlen+0xf>
    ;
  return n;
 166:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 169:	c9                   	leave  
 16a:	c3                   	ret    

0000016b <memset>:

void*
memset(void *dst, int c, uint n)
{
 16b:	55                   	push   %ebp
 16c:	89 e5                	mov    %esp,%ebp
 16e:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 171:	8b 45 10             	mov    0x10(%ebp),%eax
 174:	89 44 24 08          	mov    %eax,0x8(%esp)
 178:	8b 45 0c             	mov    0xc(%ebp),%eax
 17b:	89 44 24 04          	mov    %eax,0x4(%esp)
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	89 04 24             	mov    %eax,(%esp)
 185:	e8 ef fe ff ff       	call   79 <stosb>
  return dst;
 18a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 18d:	c9                   	leave  
 18e:	c3                   	ret    

0000018f <strchr>:

char*
strchr(const char *s, char c)
{
 18f:	55                   	push   %ebp
 190:	89 e5                	mov    %esp,%ebp
 192:	83 ec 04             	sub    $0x4,%esp
 195:	8b 45 0c             	mov    0xc(%ebp),%eax
 198:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 19b:	eb 14                	jmp    1b1 <strchr+0x22>
    if(*s == c)
 19d:	8b 45 08             	mov    0x8(%ebp),%eax
 1a0:	0f b6 00             	movzbl (%eax),%eax
 1a3:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1a6:	75 05                	jne    1ad <strchr+0x1e>
      return (char*)s;
 1a8:	8b 45 08             	mov    0x8(%ebp),%eax
 1ab:	eb 13                	jmp    1c0 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1ad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	0f b6 00             	movzbl (%eax),%eax
 1b7:	84 c0                	test   %al,%al
 1b9:	75 e2                	jne    19d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1c0:	c9                   	leave  
 1c1:	c3                   	ret    

000001c2 <gets>:

char*
gets(char *buf, int max)
{
 1c2:	55                   	push   %ebp
 1c3:	89 e5                	mov    %esp,%ebp
 1c5:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1cf:	eb 4c                	jmp    21d <gets+0x5b>
    cc = read(0, &c, 1);
 1d1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1d8:	00 
 1d9:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 1e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1e7:	e8 80 03 00 00       	call   56c <read>
 1ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1f3:	7f 02                	jg     1f7 <gets+0x35>
      break;
 1f5:	eb 31                	jmp    228 <gets+0x66>
    buf[i++] = c;
 1f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1fa:	8d 50 01             	lea    0x1(%eax),%edx
 1fd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 200:	89 c2                	mov    %eax,%edx
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	01 c2                	add    %eax,%edx
 207:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 20b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 20d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 211:	3c 0a                	cmp    $0xa,%al
 213:	74 13                	je     228 <gets+0x66>
 215:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 219:	3c 0d                	cmp    $0xd,%al
 21b:	74 0b                	je     228 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 220:	83 c0 01             	add    $0x1,%eax
 223:	3b 45 0c             	cmp    0xc(%ebp),%eax
 226:	7c a9                	jl     1d1 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 228:	8b 55 f4             	mov    -0xc(%ebp),%edx
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
 22e:	01 d0                	add    %edx,%eax
 230:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 233:	8b 45 08             	mov    0x8(%ebp),%eax
}
 236:	c9                   	leave  
 237:	c3                   	ret    

00000238 <stat>:

int
stat(char *n, struct stat *st)
{
 238:	55                   	push   %ebp
 239:	89 e5                	mov    %esp,%ebp
 23b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 23e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 245:	00 
 246:	8b 45 08             	mov    0x8(%ebp),%eax
 249:	89 04 24             	mov    %eax,(%esp)
 24c:	e8 43 03 00 00       	call   594 <open>
 251:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 254:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 258:	79 07                	jns    261 <stat+0x29>
    return -1;
 25a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 25f:	eb 23                	jmp    284 <stat+0x4c>
  r = fstat(fd, st);
 261:	8b 45 0c             	mov    0xc(%ebp),%eax
 264:	89 44 24 04          	mov    %eax,0x4(%esp)
 268:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26b:	89 04 24             	mov    %eax,(%esp)
 26e:	e8 39 03 00 00       	call   5ac <fstat>
 273:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 276:	8b 45 f4             	mov    -0xc(%ebp),%eax
 279:	89 04 24             	mov    %eax,(%esp)
 27c:	e8 fb 02 00 00       	call   57c <close>
  return r;
 281:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 284:	c9                   	leave  
 285:	c3                   	ret    

00000286 <atoi>:

int
atoi(const char *s)
{
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 28c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 293:	eb 25                	jmp    2ba <atoi+0x34>
    n = n*10 + *s++ - '0';
 295:	8b 55 fc             	mov    -0x4(%ebp),%edx
 298:	89 d0                	mov    %edx,%eax
 29a:	c1 e0 02             	shl    $0x2,%eax
 29d:	01 d0                	add    %edx,%eax
 29f:	01 c0                	add    %eax,%eax
 2a1:	89 c1                	mov    %eax,%ecx
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	8d 50 01             	lea    0x1(%eax),%edx
 2a9:	89 55 08             	mov    %edx,0x8(%ebp)
 2ac:	0f b6 00             	movzbl (%eax),%eax
 2af:	0f be c0             	movsbl %al,%eax
 2b2:	01 c8                	add    %ecx,%eax
 2b4:	83 e8 30             	sub    $0x30,%eax
 2b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2ba:	8b 45 08             	mov    0x8(%ebp),%eax
 2bd:	0f b6 00             	movzbl (%eax),%eax
 2c0:	3c 2f                	cmp    $0x2f,%al
 2c2:	7e 0a                	jle    2ce <atoi+0x48>
 2c4:	8b 45 08             	mov    0x8(%ebp),%eax
 2c7:	0f b6 00             	movzbl (%eax),%eax
 2ca:	3c 39                	cmp    $0x39,%al
 2cc:	7e c7                	jle    295 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2d1:	c9                   	leave  
 2d2:	c3                   	ret    

000002d3 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2d3:	55                   	push   %ebp
 2d4:	89 e5                	mov    %esp,%ebp
 2d6:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2df:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2e5:	eb 17                	jmp    2fe <memmove+0x2b>
    *dst++ = *src++;
 2e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ea:	8d 50 01             	lea    0x1(%eax),%edx
 2ed:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2f0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2f3:	8d 4a 01             	lea    0x1(%edx),%ecx
 2f6:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2f9:	0f b6 12             	movzbl (%edx),%edx
 2fc:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2fe:	8b 45 10             	mov    0x10(%ebp),%eax
 301:	8d 50 ff             	lea    -0x1(%eax),%edx
 304:	89 55 10             	mov    %edx,0x10(%ebp)
 307:	85 c0                	test   %eax,%eax
 309:	7f dc                	jg     2e7 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 30b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 30e:	c9                   	leave  
 30f:	c3                   	ret    

00000310 <strcmp_c>:


int
strcmp_c(const char *s1, const char *s2)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
    for ( ; *s1 == *s2; s1++, s2++)
 313:	eb 19                	jmp    32e <strcmp_c+0x1e>
	if (*s1 == '\0')
 315:	8b 45 08             	mov    0x8(%ebp),%eax
 318:	0f b6 00             	movzbl (%eax),%eax
 31b:	84 c0                	test   %al,%al
 31d:	75 07                	jne    326 <strcmp_c+0x16>
	    return 0;
 31f:	b8 00 00 00 00       	mov    $0x0,%eax
 324:	eb 34                	jmp    35a <strcmp_c+0x4a>


int
strcmp_c(const char *s1, const char *s2)
{
    for ( ; *s1 == *s2; s1++, s2++)
 326:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 32a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 32e:	8b 45 08             	mov    0x8(%ebp),%eax
 331:	0f b6 10             	movzbl (%eax),%edx
 334:	8b 45 0c             	mov    0xc(%ebp),%eax
 337:	0f b6 00             	movzbl (%eax),%eax
 33a:	38 c2                	cmp    %al,%dl
 33c:	74 d7                	je     315 <strcmp_c+0x5>
	if (*s1 == '\0')
	    return 0;
    return ((*(unsigned char *)s1 < *(unsigned char *)s2) ? -1 : +1);
 33e:	8b 45 08             	mov    0x8(%ebp),%eax
 341:	0f b6 10             	movzbl (%eax),%edx
 344:	8b 45 0c             	mov    0xc(%ebp),%eax
 347:	0f b6 00             	movzbl (%eax),%eax
 34a:	38 c2                	cmp    %al,%dl
 34c:	73 07                	jae    355 <strcmp_c+0x45>
 34e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 353:	eb 05                	jmp    35a <strcmp_c+0x4a>
 355:	b8 01 00 00 00       	mov    $0x1,%eax
}
 35a:	5d                   	pop    %ebp
 35b:	c3                   	ret    

0000035c <readuser>:


struct USER
readuser(){
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char buff1[512], buff2[512];
	struct USER u;
	printf(1,"Please enter a username: ");
 365:	c7 44 24 04 d7 0a 00 	movl   $0xad7,0x4(%esp)
 36c:	00 
 36d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 374:	e8 6b 03 00 00       	call   6e4 <printf>
	u.name = gets(buff1, 50);
 379:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 380:	00 
 381:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
 387:	89 04 24             	mov    %eax,(%esp)
 38a:	e8 33 fe ff ff       	call   1c2 <gets>
 38f:	89 85 ec fb ff ff    	mov    %eax,-0x414(%ebp)
	printf(1,"Please enter a password: ");
 395:	c7 44 24 04 f1 0a 00 	movl   $0xaf1,0x4(%esp)
 39c:	00 
 39d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3a4:	e8 3b 03 00 00       	call   6e4 <printf>
	u.pass = gets(buff2, 50);
 3a9:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 3b0:	00 
 3b1:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
 3b7:	89 04 24             	mov    %eax,(%esp)
 3ba:	e8 03 fe ff ff       	call   1c2 <gets>
 3bf:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
	return u;
 3c5:	8b 45 08             	mov    0x8(%ebp),%eax
 3c8:	8b 95 ec fb ff ff    	mov    -0x414(%ebp),%edx
 3ce:	89 10                	mov    %edx,(%eax)
 3d0:	8b 95 f0 fb ff ff    	mov    -0x410(%ebp),%edx
 3d6:	89 50 04             	mov    %edx,0x4(%eax)
 3d9:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
 3df:	89 50 08             	mov    %edx,0x8(%eax)
}
 3e2:	8b 45 08             	mov    0x8(%ebp),%eax
 3e5:	c9                   	leave  
 3e6:	c2 04 00             	ret    $0x4

000003e9 <compareuser>:


int
compareuser(int state){
 3e9:	55                   	push   %ebp
 3ea:	89 e5                	mov    %esp,%ebp
 3ec:	56                   	push   %esi
 3ed:	53                   	push   %ebx
 3ee:	81 ec 30 01 00 00    	sub    $0x130,%esp
	struct USER u1,u2;
	struct USER users[20];
	u1.name = "john\n";
 3f4:	c7 45 e8 0b 0b 00 00 	movl   $0xb0b,-0x18(%ebp)
	u1.pass = "1234\n";
 3fb:	c7 45 ec 11 0b 00 00 	movl   $0xb11,-0x14(%ebp)
	u1.ulevel = 0;
 402:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	u2.name = "james\n";
 409:	c7 45 dc 17 0b 00 00 	movl   $0xb17,-0x24(%ebp)
	u2.pass = "pass\n";
 410:	c7 45 e0 1e 0b 00 00 	movl   $0xb1e,-0x20(%ebp)
	u2.ulevel = 1;
 417:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	users[0] = u1;
 41e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 421:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
 427:	8b 45 ec             	mov    -0x14(%ebp),%eax
 42a:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
 430:	8b 45 f0             	mov    -0x10(%ebp),%eax
 433:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
	users[1] = u2;
 439:	8b 45 dc             	mov    -0x24(%ebp),%eax
 43c:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
 442:	8b 45 e0             	mov    -0x20(%ebp),%eax
 445:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
 44b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 44e:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
	
	
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
 454:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
 45a:	89 04 24             	mov    %eax,(%esp)
 45d:	e8 fa fe ff ff       	call   35c <readuser>
 462:	83 ec 04             	sub    $0x4,%esp
		
		for(ctr = 0; ctr < 20; ctr++)
 465:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 46c:	e9 a4 00 00 00       	jmp    515 <compareuser+0x12c>
		{

			if(strcmp_c(u.name,users[ctr].name) == 0 && strcmp_c(u.pass,users[ctr].pass) == 0)
 471:	8b 55 f4             	mov    -0xc(%ebp),%edx
 474:	89 d0                	mov    %edx,%eax
 476:	01 c0                	add    %eax,%eax
 478:	01 d0                	add    %edx,%eax
 47a:	c1 e0 02             	shl    $0x2,%eax
 47d:	8d 4d f8             	lea    -0x8(%ebp),%ecx
 480:	01 c8                	add    %ecx,%eax
 482:	2d 0c 01 00 00       	sub    $0x10c,%eax
 487:	8b 10                	mov    (%eax),%edx
 489:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
 48f:	89 54 24 04          	mov    %edx,0x4(%esp)
 493:	89 04 24             	mov    %eax,(%esp)
 496:	e8 75 fe ff ff       	call   310 <strcmp_c>
 49b:	85 c0                	test   %eax,%eax
 49d:	75 72                	jne    511 <compareuser+0x128>
 49f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4a2:	89 d0                	mov    %edx,%eax
 4a4:	01 c0                	add    %eax,%eax
 4a6:	01 d0                	add    %edx,%eax
 4a8:	c1 e0 02             	shl    $0x2,%eax
 4ab:	8d 5d f8             	lea    -0x8(%ebp),%ebx
 4ae:	01 d8                	add    %ebx,%eax
 4b0:	2d 08 01 00 00       	sub    $0x108,%eax
 4b5:	8b 10                	mov    (%eax),%edx
 4b7:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
 4bd:	89 54 24 04          	mov    %edx,0x4(%esp)
 4c1:	89 04 24             	mov    %eax,(%esp)
 4c4:	e8 47 fe ff ff       	call   310 <strcmp_c>
 4c9:	85 c0                	test   %eax,%eax
 4cb:	75 44                	jne    511 <compareuser+0x128>
			{
				setuser(users[ctr].ulevel);
 4cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4d0:	89 d0                	mov    %edx,%eax
 4d2:	01 c0                	add    %eax,%eax
 4d4:	01 d0                	add    %edx,%eax
 4d6:	c1 e0 02             	shl    $0x2,%eax
 4d9:	8d 75 f8             	lea    -0x8(%ebp),%esi
 4dc:	01 f0                	add    %esi,%eax
 4de:	2d 04 01 00 00       	sub    $0x104,%eax
 4e3:	8b 00                	mov    (%eax),%eax
 4e5:	89 04 24             	mov    %eax,(%esp)
 4e8:	e8 0f 01 00 00       	call   5fc <setuser>
				
				printf(1,"%d",getuser());
 4ed:	e8 02 01 00 00       	call   5f4 <getuser>
 4f2:	89 44 24 08          	mov    %eax,0x8(%esp)
 4f6:	c7 44 24 04 24 0b 00 	movl   $0xb24,0x4(%esp)
 4fd:	00 
 4fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 505:	e8 da 01 00 00       	call   6e4 <printf>
				return 1;
 50a:	b8 01 00 00 00       	mov    $0x1,%eax
 50f:	eb 34                	jmp    545 <compareuser+0x15c>
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
		
		for(ctr = 0; ctr < 20; ctr++)
 511:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 515:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 519:	0f 8e 52 ff ff ff    	jle    471 <compareuser+0x88>
				
				printf(1,"%d",getuser());
				return 1;
			}
		}
		printf(1,"Invalid username/password\n");
 51f:	c7 44 24 04 27 0b 00 	movl   $0xb27,0x4(%esp)
 526:	00 
 527:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 52e:	e8 b1 01 00 00       	call   6e4 <printf>
		if(state != 1)
 533:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 537:	74 07                	je     540 <compareuser+0x157>
			break;
	}
	return 0;
 539:	b8 00 00 00 00       	mov    $0x0,%eax
 53e:	eb 05                	jmp    545 <compareuser+0x15c>
			}
		}
		printf(1,"Invalid username/password\n");
		if(state != 1)
			break;
	}
 540:	e9 0f ff ff ff       	jmp    454 <compareuser+0x6b>
	return 0;
}
 545:	8d 65 f8             	lea    -0x8(%ebp),%esp
 548:	5b                   	pop    %ebx
 549:	5e                   	pop    %esi
 54a:	5d                   	pop    %ebp
 54b:	c3                   	ret    

0000054c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 54c:	b8 01 00 00 00       	mov    $0x1,%eax
 551:	cd 40                	int    $0x40
 553:	c3                   	ret    

00000554 <exit>:
SYSCALL(exit)
 554:	b8 02 00 00 00       	mov    $0x2,%eax
 559:	cd 40                	int    $0x40
 55b:	c3                   	ret    

0000055c <wait>:
SYSCALL(wait)
 55c:	b8 03 00 00 00       	mov    $0x3,%eax
 561:	cd 40                	int    $0x40
 563:	c3                   	ret    

00000564 <pipe>:
SYSCALL(pipe)
 564:	b8 04 00 00 00       	mov    $0x4,%eax
 569:	cd 40                	int    $0x40
 56b:	c3                   	ret    

0000056c <read>:
SYSCALL(read)
 56c:	b8 05 00 00 00       	mov    $0x5,%eax
 571:	cd 40                	int    $0x40
 573:	c3                   	ret    

00000574 <write>:
SYSCALL(write)
 574:	b8 10 00 00 00       	mov    $0x10,%eax
 579:	cd 40                	int    $0x40
 57b:	c3                   	ret    

0000057c <close>:
SYSCALL(close)
 57c:	b8 15 00 00 00       	mov    $0x15,%eax
 581:	cd 40                	int    $0x40
 583:	c3                   	ret    

00000584 <kill>:
SYSCALL(kill)
 584:	b8 06 00 00 00       	mov    $0x6,%eax
 589:	cd 40                	int    $0x40
 58b:	c3                   	ret    

0000058c <exec>:
SYSCALL(exec)
 58c:	b8 07 00 00 00       	mov    $0x7,%eax
 591:	cd 40                	int    $0x40
 593:	c3                   	ret    

00000594 <open>:
SYSCALL(open)
 594:	b8 0f 00 00 00       	mov    $0xf,%eax
 599:	cd 40                	int    $0x40
 59b:	c3                   	ret    

0000059c <mknod>:
SYSCALL(mknod)
 59c:	b8 11 00 00 00       	mov    $0x11,%eax
 5a1:	cd 40                	int    $0x40
 5a3:	c3                   	ret    

000005a4 <unlink>:
SYSCALL(unlink)
 5a4:	b8 12 00 00 00       	mov    $0x12,%eax
 5a9:	cd 40                	int    $0x40
 5ab:	c3                   	ret    

000005ac <fstat>:
SYSCALL(fstat)
 5ac:	b8 08 00 00 00       	mov    $0x8,%eax
 5b1:	cd 40                	int    $0x40
 5b3:	c3                   	ret    

000005b4 <link>:
SYSCALL(link)
 5b4:	b8 13 00 00 00       	mov    $0x13,%eax
 5b9:	cd 40                	int    $0x40
 5bb:	c3                   	ret    

000005bc <mkdir>:
SYSCALL(mkdir)
 5bc:	b8 14 00 00 00       	mov    $0x14,%eax
 5c1:	cd 40                	int    $0x40
 5c3:	c3                   	ret    

000005c4 <chdir>:
SYSCALL(chdir)
 5c4:	b8 09 00 00 00       	mov    $0x9,%eax
 5c9:	cd 40                	int    $0x40
 5cb:	c3                   	ret    

000005cc <dup>:
SYSCALL(dup)
 5cc:	b8 0a 00 00 00       	mov    $0xa,%eax
 5d1:	cd 40                	int    $0x40
 5d3:	c3                   	ret    

000005d4 <getpid>:
SYSCALL(getpid)
 5d4:	b8 0b 00 00 00       	mov    $0xb,%eax
 5d9:	cd 40                	int    $0x40
 5db:	c3                   	ret    

000005dc <sbrk>:
SYSCALL(sbrk)
 5dc:	b8 0c 00 00 00       	mov    $0xc,%eax
 5e1:	cd 40                	int    $0x40
 5e3:	c3                   	ret    

000005e4 <sleep>:
SYSCALL(sleep)
 5e4:	b8 0d 00 00 00       	mov    $0xd,%eax
 5e9:	cd 40                	int    $0x40
 5eb:	c3                   	ret    

000005ec <uptime>:
SYSCALL(uptime)
 5ec:	b8 0e 00 00 00       	mov    $0xe,%eax
 5f1:	cd 40                	int    $0x40
 5f3:	c3                   	ret    

000005f4 <getuser>:
SYSCALL(getuser)
 5f4:	b8 16 00 00 00       	mov    $0x16,%eax
 5f9:	cd 40                	int    $0x40
 5fb:	c3                   	ret    

000005fc <setuser>:
SYSCALL(setuser)
 5fc:	b8 17 00 00 00       	mov    $0x17,%eax
 601:	cd 40                	int    $0x40
 603:	c3                   	ret    

00000604 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 604:	55                   	push   %ebp
 605:	89 e5                	mov    %esp,%ebp
 607:	83 ec 18             	sub    $0x18,%esp
 60a:	8b 45 0c             	mov    0xc(%ebp),%eax
 60d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 610:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 617:	00 
 618:	8d 45 f4             	lea    -0xc(%ebp),%eax
 61b:	89 44 24 04          	mov    %eax,0x4(%esp)
 61f:	8b 45 08             	mov    0x8(%ebp),%eax
 622:	89 04 24             	mov    %eax,(%esp)
 625:	e8 4a ff ff ff       	call   574 <write>
}
 62a:	c9                   	leave  
 62b:	c3                   	ret    

0000062c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 62c:	55                   	push   %ebp
 62d:	89 e5                	mov    %esp,%ebp
 62f:	56                   	push   %esi
 630:	53                   	push   %ebx
 631:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 634:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 63b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 63f:	74 17                	je     658 <printint+0x2c>
 641:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 645:	79 11                	jns    658 <printint+0x2c>
    neg = 1;
 647:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 64e:	8b 45 0c             	mov    0xc(%ebp),%eax
 651:	f7 d8                	neg    %eax
 653:	89 45 ec             	mov    %eax,-0x14(%ebp)
 656:	eb 06                	jmp    65e <printint+0x32>
  } else {
    x = xx;
 658:	8b 45 0c             	mov    0xc(%ebp),%eax
 65b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 65e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 665:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 668:	8d 41 01             	lea    0x1(%ecx),%eax
 66b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 66e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 671:	8b 45 ec             	mov    -0x14(%ebp),%eax
 674:	ba 00 00 00 00       	mov    $0x0,%edx
 679:	f7 f3                	div    %ebx
 67b:	89 d0                	mov    %edx,%eax
 67d:	0f b6 80 3c 0e 00 00 	movzbl 0xe3c(%eax),%eax
 684:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 688:	8b 75 10             	mov    0x10(%ebp),%esi
 68b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 68e:	ba 00 00 00 00       	mov    $0x0,%edx
 693:	f7 f6                	div    %esi
 695:	89 45 ec             	mov    %eax,-0x14(%ebp)
 698:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 69c:	75 c7                	jne    665 <printint+0x39>
  if(neg)
 69e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6a2:	74 10                	je     6b4 <printint+0x88>
    buf[i++] = '-';
 6a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a7:	8d 50 01             	lea    0x1(%eax),%edx
 6aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6ad:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6b2:	eb 1f                	jmp    6d3 <printint+0xa7>
 6b4:	eb 1d                	jmp    6d3 <printint+0xa7>
    putc(fd, buf[i]);
 6b6:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6bc:	01 d0                	add    %edx,%eax
 6be:	0f b6 00             	movzbl (%eax),%eax
 6c1:	0f be c0             	movsbl %al,%eax
 6c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c8:	8b 45 08             	mov    0x8(%ebp),%eax
 6cb:	89 04 24             	mov    %eax,(%esp)
 6ce:	e8 31 ff ff ff       	call   604 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6d3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6db:	79 d9                	jns    6b6 <printint+0x8a>
    putc(fd, buf[i]);
}
 6dd:	83 c4 30             	add    $0x30,%esp
 6e0:	5b                   	pop    %ebx
 6e1:	5e                   	pop    %esi
 6e2:	5d                   	pop    %ebp
 6e3:	c3                   	ret    

000006e4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6e4:	55                   	push   %ebp
 6e5:	89 e5                	mov    %esp,%ebp
 6e7:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6f1:	8d 45 0c             	lea    0xc(%ebp),%eax
 6f4:	83 c0 04             	add    $0x4,%eax
 6f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 701:	e9 7c 01 00 00       	jmp    882 <printf+0x19e>
    c = fmt[i] & 0xff;
 706:	8b 55 0c             	mov    0xc(%ebp),%edx
 709:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70c:	01 d0                	add    %edx,%eax
 70e:	0f b6 00             	movzbl (%eax),%eax
 711:	0f be c0             	movsbl %al,%eax
 714:	25 ff 00 00 00       	and    $0xff,%eax
 719:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 71c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 720:	75 2c                	jne    74e <printf+0x6a>
      if(c == '%'){
 722:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 726:	75 0c                	jne    734 <printf+0x50>
        state = '%';
 728:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 72f:	e9 4a 01 00 00       	jmp    87e <printf+0x19a>
      } else {
        putc(fd, c);
 734:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 737:	0f be c0             	movsbl %al,%eax
 73a:	89 44 24 04          	mov    %eax,0x4(%esp)
 73e:	8b 45 08             	mov    0x8(%ebp),%eax
 741:	89 04 24             	mov    %eax,(%esp)
 744:	e8 bb fe ff ff       	call   604 <putc>
 749:	e9 30 01 00 00       	jmp    87e <printf+0x19a>
      }
    } else if(state == '%'){
 74e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 752:	0f 85 26 01 00 00    	jne    87e <printf+0x19a>
      if(c == 'd'){
 758:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 75c:	75 2d                	jne    78b <printf+0xa7>
        printint(fd, *ap, 10, 1);
 75e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 761:	8b 00                	mov    (%eax),%eax
 763:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 76a:	00 
 76b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 772:	00 
 773:	89 44 24 04          	mov    %eax,0x4(%esp)
 777:	8b 45 08             	mov    0x8(%ebp),%eax
 77a:	89 04 24             	mov    %eax,(%esp)
 77d:	e8 aa fe ff ff       	call   62c <printint>
        ap++;
 782:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 786:	e9 ec 00 00 00       	jmp    877 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 78b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 78f:	74 06                	je     797 <printf+0xb3>
 791:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 795:	75 2d                	jne    7c4 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 797:	8b 45 e8             	mov    -0x18(%ebp),%eax
 79a:	8b 00                	mov    (%eax),%eax
 79c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 7a3:	00 
 7a4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 7ab:	00 
 7ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 7b0:	8b 45 08             	mov    0x8(%ebp),%eax
 7b3:	89 04 24             	mov    %eax,(%esp)
 7b6:	e8 71 fe ff ff       	call   62c <printint>
        ap++;
 7bb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7bf:	e9 b3 00 00 00       	jmp    877 <printf+0x193>
      } else if(c == 's'){
 7c4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7c8:	75 45                	jne    80f <printf+0x12b>
        s = (char*)*ap;
 7ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7cd:	8b 00                	mov    (%eax),%eax
 7cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7d2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7da:	75 09                	jne    7e5 <printf+0x101>
          s = "(null)";
 7dc:	c7 45 f4 42 0b 00 00 	movl   $0xb42,-0xc(%ebp)
        while(*s != 0){
 7e3:	eb 1e                	jmp    803 <printf+0x11f>
 7e5:	eb 1c                	jmp    803 <printf+0x11f>
          putc(fd, *s);
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	0f b6 00             	movzbl (%eax),%eax
 7ed:	0f be c0             	movsbl %al,%eax
 7f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 7f4:	8b 45 08             	mov    0x8(%ebp),%eax
 7f7:	89 04 24             	mov    %eax,(%esp)
 7fa:	e8 05 fe ff ff       	call   604 <putc>
          s++;
 7ff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 803:	8b 45 f4             	mov    -0xc(%ebp),%eax
 806:	0f b6 00             	movzbl (%eax),%eax
 809:	84 c0                	test   %al,%al
 80b:	75 da                	jne    7e7 <printf+0x103>
 80d:	eb 68                	jmp    877 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 80f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 813:	75 1d                	jne    832 <printf+0x14e>
        putc(fd, *ap);
 815:	8b 45 e8             	mov    -0x18(%ebp),%eax
 818:	8b 00                	mov    (%eax),%eax
 81a:	0f be c0             	movsbl %al,%eax
 81d:	89 44 24 04          	mov    %eax,0x4(%esp)
 821:	8b 45 08             	mov    0x8(%ebp),%eax
 824:	89 04 24             	mov    %eax,(%esp)
 827:	e8 d8 fd ff ff       	call   604 <putc>
        ap++;
 82c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 830:	eb 45                	jmp    877 <printf+0x193>
      } else if(c == '%'){
 832:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 836:	75 17                	jne    84f <printf+0x16b>
        putc(fd, c);
 838:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 83b:	0f be c0             	movsbl %al,%eax
 83e:	89 44 24 04          	mov    %eax,0x4(%esp)
 842:	8b 45 08             	mov    0x8(%ebp),%eax
 845:	89 04 24             	mov    %eax,(%esp)
 848:	e8 b7 fd ff ff       	call   604 <putc>
 84d:	eb 28                	jmp    877 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 84f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 856:	00 
 857:	8b 45 08             	mov    0x8(%ebp),%eax
 85a:	89 04 24             	mov    %eax,(%esp)
 85d:	e8 a2 fd ff ff       	call   604 <putc>
        putc(fd, c);
 862:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 865:	0f be c0             	movsbl %al,%eax
 868:	89 44 24 04          	mov    %eax,0x4(%esp)
 86c:	8b 45 08             	mov    0x8(%ebp),%eax
 86f:	89 04 24             	mov    %eax,(%esp)
 872:	e8 8d fd ff ff       	call   604 <putc>
      }
      state = 0;
 877:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 87e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 882:	8b 55 0c             	mov    0xc(%ebp),%edx
 885:	8b 45 f0             	mov    -0x10(%ebp),%eax
 888:	01 d0                	add    %edx,%eax
 88a:	0f b6 00             	movzbl (%eax),%eax
 88d:	84 c0                	test   %al,%al
 88f:	0f 85 71 fe ff ff    	jne    706 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 895:	c9                   	leave  
 896:	c3                   	ret    

00000897 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 897:	55                   	push   %ebp
 898:	89 e5                	mov    %esp,%ebp
 89a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 89d:	8b 45 08             	mov    0x8(%ebp),%eax
 8a0:	83 e8 08             	sub    $0x8,%eax
 8a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a6:	a1 58 0e 00 00       	mov    0xe58,%eax
 8ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8ae:	eb 24                	jmp    8d4 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b3:	8b 00                	mov    (%eax),%eax
 8b5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8b8:	77 12                	ja     8cc <free+0x35>
 8ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8bd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8c0:	77 24                	ja     8e6 <free+0x4f>
 8c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c5:	8b 00                	mov    (%eax),%eax
 8c7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8ca:	77 1a                	ja     8e6 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cf:	8b 00                	mov    (%eax),%eax
 8d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8da:	76 d4                	jbe    8b0 <free+0x19>
 8dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8df:	8b 00                	mov    (%eax),%eax
 8e1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8e4:	76 ca                	jbe    8b0 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e9:	8b 40 04             	mov    0x4(%eax),%eax
 8ec:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f6:	01 c2                	add    %eax,%edx
 8f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fb:	8b 00                	mov    (%eax),%eax
 8fd:	39 c2                	cmp    %eax,%edx
 8ff:	75 24                	jne    925 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 901:	8b 45 f8             	mov    -0x8(%ebp),%eax
 904:	8b 50 04             	mov    0x4(%eax),%edx
 907:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90a:	8b 00                	mov    (%eax),%eax
 90c:	8b 40 04             	mov    0x4(%eax),%eax
 90f:	01 c2                	add    %eax,%edx
 911:	8b 45 f8             	mov    -0x8(%ebp),%eax
 914:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 917:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91a:	8b 00                	mov    (%eax),%eax
 91c:	8b 10                	mov    (%eax),%edx
 91e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 921:	89 10                	mov    %edx,(%eax)
 923:	eb 0a                	jmp    92f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 925:	8b 45 fc             	mov    -0x4(%ebp),%eax
 928:	8b 10                	mov    (%eax),%edx
 92a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 92f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 932:	8b 40 04             	mov    0x4(%eax),%eax
 935:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 93c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93f:	01 d0                	add    %edx,%eax
 941:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 944:	75 20                	jne    966 <free+0xcf>
    p->s.size += bp->s.size;
 946:	8b 45 fc             	mov    -0x4(%ebp),%eax
 949:	8b 50 04             	mov    0x4(%eax),%edx
 94c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94f:	8b 40 04             	mov    0x4(%eax),%eax
 952:	01 c2                	add    %eax,%edx
 954:	8b 45 fc             	mov    -0x4(%ebp),%eax
 957:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 95a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95d:	8b 10                	mov    (%eax),%edx
 95f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 962:	89 10                	mov    %edx,(%eax)
 964:	eb 08                	jmp    96e <free+0xd7>
  } else
    p->s.ptr = bp;
 966:	8b 45 fc             	mov    -0x4(%ebp),%eax
 969:	8b 55 f8             	mov    -0x8(%ebp),%edx
 96c:	89 10                	mov    %edx,(%eax)
  freep = p;
 96e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 971:	a3 58 0e 00 00       	mov    %eax,0xe58
}
 976:	c9                   	leave  
 977:	c3                   	ret    

00000978 <morecore>:

static Header*
morecore(uint nu)
{
 978:	55                   	push   %ebp
 979:	89 e5                	mov    %esp,%ebp
 97b:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 97e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 985:	77 07                	ja     98e <morecore+0x16>
    nu = 4096;
 987:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 98e:	8b 45 08             	mov    0x8(%ebp),%eax
 991:	c1 e0 03             	shl    $0x3,%eax
 994:	89 04 24             	mov    %eax,(%esp)
 997:	e8 40 fc ff ff       	call   5dc <sbrk>
 99c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 99f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9a3:	75 07                	jne    9ac <morecore+0x34>
    return 0;
 9a5:	b8 00 00 00 00       	mov    $0x0,%eax
 9aa:	eb 22                	jmp    9ce <morecore+0x56>
  hp = (Header*)p;
 9ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b5:	8b 55 08             	mov    0x8(%ebp),%edx
 9b8:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9be:	83 c0 08             	add    $0x8,%eax
 9c1:	89 04 24             	mov    %eax,(%esp)
 9c4:	e8 ce fe ff ff       	call   897 <free>
  return freep;
 9c9:	a1 58 0e 00 00       	mov    0xe58,%eax
}
 9ce:	c9                   	leave  
 9cf:	c3                   	ret    

000009d0 <malloc>:

void*
malloc(uint nbytes)
{
 9d0:	55                   	push   %ebp
 9d1:	89 e5                	mov    %esp,%ebp
 9d3:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d6:	8b 45 08             	mov    0x8(%ebp),%eax
 9d9:	83 c0 07             	add    $0x7,%eax
 9dc:	c1 e8 03             	shr    $0x3,%eax
 9df:	83 c0 01             	add    $0x1,%eax
 9e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9e5:	a1 58 0e 00 00       	mov    0xe58,%eax
 9ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9f1:	75 23                	jne    a16 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9f3:	c7 45 f0 50 0e 00 00 	movl   $0xe50,-0x10(%ebp)
 9fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9fd:	a3 58 0e 00 00       	mov    %eax,0xe58
 a02:	a1 58 0e 00 00       	mov    0xe58,%eax
 a07:	a3 50 0e 00 00       	mov    %eax,0xe50
    base.s.size = 0;
 a0c:	c7 05 54 0e 00 00 00 	movl   $0x0,0xe54
 a13:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a19:	8b 00                	mov    (%eax),%eax
 a1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a21:	8b 40 04             	mov    0x4(%eax),%eax
 a24:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a27:	72 4d                	jb     a76 <malloc+0xa6>
      if(p->s.size == nunits)
 a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2c:	8b 40 04             	mov    0x4(%eax),%eax
 a2f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a32:	75 0c                	jne    a40 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a37:	8b 10                	mov    (%eax),%edx
 a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a3c:	89 10                	mov    %edx,(%eax)
 a3e:	eb 26                	jmp    a66 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a43:	8b 40 04             	mov    0x4(%eax),%eax
 a46:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a49:	89 c2                	mov    %eax,%edx
 a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a54:	8b 40 04             	mov    0x4(%eax),%eax
 a57:	c1 e0 03             	shl    $0x3,%eax
 a5a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a60:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a63:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a69:	a3 58 0e 00 00       	mov    %eax,0xe58
      return (void*)(p + 1);
 a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a71:	83 c0 08             	add    $0x8,%eax
 a74:	eb 38                	jmp    aae <malloc+0xde>
    }
    if(p == freep)
 a76:	a1 58 0e 00 00       	mov    0xe58,%eax
 a7b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a7e:	75 1b                	jne    a9b <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 a80:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a83:	89 04 24             	mov    %eax,(%esp)
 a86:	e8 ed fe ff ff       	call   978 <morecore>
 a8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a92:	75 07                	jne    a9b <malloc+0xcb>
        return 0;
 a94:	b8 00 00 00 00       	mov    $0x0,%eax
 a99:	eb 13                	jmp    aae <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa4:	8b 00                	mov    (%eax),%eax
 aa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 aa9:	e9 70 ff ff ff       	jmp    a1e <malloc+0x4e>
}
 aae:	c9                   	leave  
 aaf:	c3                   	ret    
