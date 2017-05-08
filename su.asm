
_su:     file format elf32-i386


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
	int newUser = compareuser(0);
   9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10:	e8 85 03 00 00       	call   39a <compareuser>
  15:	89 44 24 1c          	mov    %eax,0x1c(%esp)
	setuser(newUser);
  19:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  1d:	89 04 24             	mov    %eax,(%esp)
  20:	e8 88 05 00 00       	call   5ad <setuser>
	exit();
  25:	e8 db 04 00 00       	call   505 <exit>

0000002a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  2a:	55                   	push   %ebp
  2b:	89 e5                	mov    %esp,%ebp
  2d:	57                   	push   %edi
  2e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  32:	8b 55 10             	mov    0x10(%ebp),%edx
  35:	8b 45 0c             	mov    0xc(%ebp),%eax
  38:	89 cb                	mov    %ecx,%ebx
  3a:	89 df                	mov    %ebx,%edi
  3c:	89 d1                	mov    %edx,%ecx
  3e:	fc                   	cld    
  3f:	f3 aa                	rep stos %al,%es:(%edi)
  41:	89 ca                	mov    %ecx,%edx
  43:	89 fb                	mov    %edi,%ebx
  45:	89 5d 08             	mov    %ebx,0x8(%ebp)
  48:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  4b:	5b                   	pop    %ebx
  4c:	5f                   	pop    %edi
  4d:	5d                   	pop    %ebp
  4e:	c3                   	ret    

0000004f <thing>:
#include "user.h"
#include "x86.h"


int
thing(void){
  4f:	55                   	push   %ebp
  50:	89 e5                	mov    %esp,%ebp
  return 1;
  52:	b8 01 00 00 00       	mov    $0x1,%eax
}
  57:	5d                   	pop    %ebp
  58:	c3                   	ret    

00000059 <strcpy>:

char*
strcpy(char *s, char *t)
{
  59:	55                   	push   %ebp
  5a:	89 e5                	mov    %esp,%ebp
  5c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  5f:	8b 45 08             	mov    0x8(%ebp),%eax
  62:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  65:	90                   	nop
  66:	8b 45 08             	mov    0x8(%ebp),%eax
  69:	8d 50 01             	lea    0x1(%eax),%edx
  6c:	89 55 08             	mov    %edx,0x8(%ebp)
  6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  72:	8d 4a 01             	lea    0x1(%edx),%ecx
  75:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  78:	0f b6 12             	movzbl (%edx),%edx
  7b:	88 10                	mov    %dl,(%eax)
  7d:	0f b6 00             	movzbl (%eax),%eax
  80:	84 c0                	test   %al,%al
  82:	75 e2                	jne    66 <strcpy+0xd>
    ;
  return os;
  84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  87:	c9                   	leave  
  88:	c3                   	ret    

00000089 <strcmp>:



int
strcmp(const char *p, const char *q)
{
  89:	55                   	push   %ebp
  8a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  8c:	eb 08                	jmp    96 <strcmp+0xd>
    p++, q++;
  8e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  92:	83 45 0c 01          	addl   $0x1,0xc(%ebp)


int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  96:	8b 45 08             	mov    0x8(%ebp),%eax
  99:	0f b6 00             	movzbl (%eax),%eax
  9c:	84 c0                	test   %al,%al
  9e:	74 10                	je     b0 <strcmp+0x27>
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	0f b6 10             	movzbl (%eax),%edx
  a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  a9:	0f b6 00             	movzbl (%eax),%eax
  ac:	38 c2                	cmp    %al,%dl
  ae:	74 de                	je     8e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  b0:	8b 45 08             	mov    0x8(%ebp),%eax
  b3:	0f b6 00             	movzbl (%eax),%eax
  b6:	0f b6 d0             	movzbl %al,%edx
  b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	0f b6 c0             	movzbl %al,%eax
  c2:	29 c2                	sub    %eax,%edx
  c4:	89 d0                	mov    %edx,%eax
}
  c6:	5d                   	pop    %ebp
  c7:	c3                   	ret    

000000c8 <strlen>:

uint
strlen(char *s)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  cb:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  d5:	eb 04                	jmp    db <strlen+0x13>
  d7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  de:	8b 45 08             	mov    0x8(%ebp),%eax
  e1:	01 d0                	add    %edx,%eax
  e3:	0f b6 00             	movzbl (%eax),%eax
  e6:	84 c0                	test   %al,%al
  e8:	75 ed                	jne    d7 <strlen+0xf>
    ;
  return n;
  ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ed:	c9                   	leave  
  ee:	c3                   	ret    

000000ef <stringlen>:

uint
stringlen(char **s){
  ef:	55                   	push   %ebp
  f0:	89 e5                	mov    %esp,%ebp
  f2:	83 ec 10             	sub    $0x10,%esp
	int n;

  for(n = 0; s[n]; n++)
  f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  fc:	eb 04                	jmp    102 <stringlen+0x13>
  fe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 102:	8b 45 fc             	mov    -0x4(%ebp),%eax
 105:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	01 d0                	add    %edx,%eax
 111:	8b 00                	mov    (%eax),%eax
 113:	85 c0                	test   %eax,%eax
 115:	75 e7                	jne    fe <stringlen+0xf>
    ;
  return n;
 117:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11a:	c9                   	leave  
 11b:	c3                   	ret    

0000011c <memset>:

void*
memset(void *dst, int c, uint n)
{
 11c:	55                   	push   %ebp
 11d:	89 e5                	mov    %esp,%ebp
 11f:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 122:	8b 45 10             	mov    0x10(%ebp),%eax
 125:	89 44 24 08          	mov    %eax,0x8(%esp)
 129:	8b 45 0c             	mov    0xc(%ebp),%eax
 12c:	89 44 24 04          	mov    %eax,0x4(%esp)
 130:	8b 45 08             	mov    0x8(%ebp),%eax
 133:	89 04 24             	mov    %eax,(%esp)
 136:	e8 ef fe ff ff       	call   2a <stosb>
  return dst;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 13e:	c9                   	leave  
 13f:	c3                   	ret    

00000140 <strchr>:

char*
strchr(const char *s, char c)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	83 ec 04             	sub    $0x4,%esp
 146:	8b 45 0c             	mov    0xc(%ebp),%eax
 149:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 14c:	eb 14                	jmp    162 <strchr+0x22>
    if(*s == c)
 14e:	8b 45 08             	mov    0x8(%ebp),%eax
 151:	0f b6 00             	movzbl (%eax),%eax
 154:	3a 45 fc             	cmp    -0x4(%ebp),%al
 157:	75 05                	jne    15e <strchr+0x1e>
      return (char*)s;
 159:	8b 45 08             	mov    0x8(%ebp),%eax
 15c:	eb 13                	jmp    171 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 15e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 162:	8b 45 08             	mov    0x8(%ebp),%eax
 165:	0f b6 00             	movzbl (%eax),%eax
 168:	84 c0                	test   %al,%al
 16a:	75 e2                	jne    14e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 16c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 171:	c9                   	leave  
 172:	c3                   	ret    

00000173 <gets>:

char*
gets(char *buf, int max)
{
 173:	55                   	push   %ebp
 174:	89 e5                	mov    %esp,%ebp
 176:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 179:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 180:	eb 4c                	jmp    1ce <gets+0x5b>
    cc = read(0, &c, 1);
 182:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 189:	00 
 18a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 18d:	89 44 24 04          	mov    %eax,0x4(%esp)
 191:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 198:	e8 80 03 00 00       	call   51d <read>
 19d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a4:	7f 02                	jg     1a8 <gets+0x35>
      break;
 1a6:	eb 31                	jmp    1d9 <gets+0x66>
    buf[i++] = c;
 1a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ab:	8d 50 01             	lea    0x1(%eax),%edx
 1ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b1:	89 c2                	mov    %eax,%edx
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	01 c2                	add    %eax,%edx
 1b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c2:	3c 0a                	cmp    $0xa,%al
 1c4:	74 13                	je     1d9 <gets+0x66>
 1c6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ca:	3c 0d                	cmp    $0xd,%al
 1cc:	74 0b                	je     1d9 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d1:	83 c0 01             	add    $0x1,%eax
 1d4:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d7:	7c a9                	jl     182 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1dc:	8b 45 08             	mov    0x8(%ebp),%eax
 1df:	01 d0                	add    %edx,%eax
 1e1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e7:	c9                   	leave  
 1e8:	c3                   	ret    

000001e9 <stat>:

int
stat(char *n, struct stat *st)
{
 1e9:	55                   	push   %ebp
 1ea:	89 e5                	mov    %esp,%ebp
 1ec:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1f6:	00 
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
 1fa:	89 04 24             	mov    %eax,(%esp)
 1fd:	e8 43 03 00 00       	call   545 <open>
 202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 209:	79 07                	jns    212 <stat+0x29>
    return -1;
 20b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 210:	eb 23                	jmp    235 <stat+0x4c>
  r = fstat(fd, st);
 212:	8b 45 0c             	mov    0xc(%ebp),%eax
 215:	89 44 24 04          	mov    %eax,0x4(%esp)
 219:	8b 45 f4             	mov    -0xc(%ebp),%eax
 21c:	89 04 24             	mov    %eax,(%esp)
 21f:	e8 39 03 00 00       	call   55d <fstat>
 224:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 227:	8b 45 f4             	mov    -0xc(%ebp),%eax
 22a:	89 04 24             	mov    %eax,(%esp)
 22d:	e8 fb 02 00 00       	call   52d <close>
  return r;
 232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 235:	c9                   	leave  
 236:	c3                   	ret    

00000237 <atoi>:

int
atoi(const char *s)
{
 237:	55                   	push   %ebp
 238:	89 e5                	mov    %esp,%ebp
 23a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 244:	eb 25                	jmp    26b <atoi+0x34>
    n = n*10 + *s++ - '0';
 246:	8b 55 fc             	mov    -0x4(%ebp),%edx
 249:	89 d0                	mov    %edx,%eax
 24b:	c1 e0 02             	shl    $0x2,%eax
 24e:	01 d0                	add    %edx,%eax
 250:	01 c0                	add    %eax,%eax
 252:	89 c1                	mov    %eax,%ecx
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	8d 50 01             	lea    0x1(%eax),%edx
 25a:	89 55 08             	mov    %edx,0x8(%ebp)
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	0f be c0             	movsbl %al,%eax
 263:	01 c8                	add    %ecx,%eax
 265:	83 e8 30             	sub    $0x30,%eax
 268:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	0f b6 00             	movzbl (%eax),%eax
 271:	3c 2f                	cmp    $0x2f,%al
 273:	7e 0a                	jle    27f <atoi+0x48>
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	3c 39                	cmp    $0x39,%al
 27d:	7e c7                	jle    246 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 27f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 282:	c9                   	leave  
 283:	c3                   	ret    

00000284 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 290:	8b 45 0c             	mov    0xc(%ebp),%eax
 293:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 296:	eb 17                	jmp    2af <memmove+0x2b>
    *dst++ = *src++;
 298:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29b:	8d 50 01             	lea    0x1(%eax),%edx
 29e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2a4:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a7:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2aa:	0f b6 12             	movzbl (%edx),%edx
 2ad:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2af:	8b 45 10             	mov    0x10(%ebp),%eax
 2b2:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b5:	89 55 10             	mov    %edx,0x10(%ebp)
 2b8:	85 c0                	test   %eax,%eax
 2ba:	7f dc                	jg     298 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bf:	c9                   	leave  
 2c0:	c3                   	ret    

000002c1 <strcmp_c>:


int
strcmp_c(const char *s1, const char *s2)
{
 2c1:	55                   	push   %ebp
 2c2:	89 e5                	mov    %esp,%ebp
    for ( ; *s1 == *s2; s1++, s2++)
 2c4:	eb 19                	jmp    2df <strcmp_c+0x1e>
	if (*s1 == '\0')
 2c6:	8b 45 08             	mov    0x8(%ebp),%eax
 2c9:	0f b6 00             	movzbl (%eax),%eax
 2cc:	84 c0                	test   %al,%al
 2ce:	75 07                	jne    2d7 <strcmp_c+0x16>
	    return 0;
 2d0:	b8 00 00 00 00       	mov    $0x0,%eax
 2d5:	eb 34                	jmp    30b <strcmp_c+0x4a>


int
strcmp_c(const char *s1, const char *s2)
{
    for ( ; *s1 == *s2; s1++, s2++)
 2d7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2db:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
 2e2:	0f b6 10             	movzbl (%eax),%edx
 2e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e8:	0f b6 00             	movzbl (%eax),%eax
 2eb:	38 c2                	cmp    %al,%dl
 2ed:	74 d7                	je     2c6 <strcmp_c+0x5>
	if (*s1 == '\0')
	    return 0;
    return ((*(unsigned char *)s1 < *(unsigned char *)s2) ? -1 : +1);
 2ef:	8b 45 08             	mov    0x8(%ebp),%eax
 2f2:	0f b6 10             	movzbl (%eax),%edx
 2f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f8:	0f b6 00             	movzbl (%eax),%eax
 2fb:	38 c2                	cmp    %al,%dl
 2fd:	73 07                	jae    306 <strcmp_c+0x45>
 2ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 304:	eb 05                	jmp    30b <strcmp_c+0x4a>
 306:	b8 01 00 00 00       	mov    $0x1,%eax
}
 30b:	5d                   	pop    %ebp
 30c:	c3                   	ret    

0000030d <readuser>:


struct USER
readuser(){
 30d:	55                   	push   %ebp
 30e:	89 e5                	mov    %esp,%ebp
 310:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char buff1[512], buff2[512];
	struct USER u;
	printf(1,"Please enter a username: ");
 316:	c7 44 24 04 61 0a 00 	movl   $0xa61,0x4(%esp)
 31d:	00 
 31e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 325:	e8 6b 03 00 00       	call   695 <printf>
	u.name = gets(buff1, 50);
 32a:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 331:	00 
 332:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
 338:	89 04 24             	mov    %eax,(%esp)
 33b:	e8 33 fe ff ff       	call   173 <gets>
 340:	89 85 ec fb ff ff    	mov    %eax,-0x414(%ebp)
	printf(1,"Please enter a password: ");
 346:	c7 44 24 04 7b 0a 00 	movl   $0xa7b,0x4(%esp)
 34d:	00 
 34e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 355:	e8 3b 03 00 00       	call   695 <printf>
	u.pass = gets(buff2, 50);
 35a:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 361:	00 
 362:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
 368:	89 04 24             	mov    %eax,(%esp)
 36b:	e8 03 fe ff ff       	call   173 <gets>
 370:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
	return u;
 376:	8b 45 08             	mov    0x8(%ebp),%eax
 379:	8b 95 ec fb ff ff    	mov    -0x414(%ebp),%edx
 37f:	89 10                	mov    %edx,(%eax)
 381:	8b 95 f0 fb ff ff    	mov    -0x410(%ebp),%edx
 387:	89 50 04             	mov    %edx,0x4(%eax)
 38a:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
 390:	89 50 08             	mov    %edx,0x8(%eax)
}
 393:	8b 45 08             	mov    0x8(%ebp),%eax
 396:	c9                   	leave  
 397:	c2 04 00             	ret    $0x4

0000039a <compareuser>:


int
compareuser(int state){
 39a:	55                   	push   %ebp
 39b:	89 e5                	mov    %esp,%ebp
 39d:	56                   	push   %esi
 39e:	53                   	push   %ebx
 39f:	81 ec 30 01 00 00    	sub    $0x130,%esp
	struct USER u1,u2;
	struct USER users[20];
	u1.name = "john\n";
 3a5:	c7 45 e8 95 0a 00 00 	movl   $0xa95,-0x18(%ebp)
	u1.pass = "1234\n";
 3ac:	c7 45 ec 9b 0a 00 00 	movl   $0xa9b,-0x14(%ebp)
	u1.ulevel = 0;
 3b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	u2.name = "james\n";
 3ba:	c7 45 dc a1 0a 00 00 	movl   $0xaa1,-0x24(%ebp)
	u2.pass = "pass\n";
 3c1:	c7 45 e0 a8 0a 00 00 	movl   $0xaa8,-0x20(%ebp)
	u2.ulevel = 1;
 3c8:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	users[0] = u1;
 3cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 3d2:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
 3d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3db:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
 3e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 3e4:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
	users[1] = u2;
 3ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
 3ed:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
 3f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
 3f6:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
 3fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 3ff:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
	
	
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
 405:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
 40b:	89 04 24             	mov    %eax,(%esp)
 40e:	e8 fa fe ff ff       	call   30d <readuser>
 413:	83 ec 04             	sub    $0x4,%esp
		
		for(ctr = 0; ctr < 20; ctr++)
 416:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 41d:	e9 a4 00 00 00       	jmp    4c6 <compareuser+0x12c>
		{

			if(strcmp_c(u.name,users[ctr].name) == 0 && strcmp_c(u.pass,users[ctr].pass) == 0)
 422:	8b 55 f4             	mov    -0xc(%ebp),%edx
 425:	89 d0                	mov    %edx,%eax
 427:	01 c0                	add    %eax,%eax
 429:	01 d0                	add    %edx,%eax
 42b:	c1 e0 02             	shl    $0x2,%eax
 42e:	8d 4d f8             	lea    -0x8(%ebp),%ecx
 431:	01 c8                	add    %ecx,%eax
 433:	2d 0c 01 00 00       	sub    $0x10c,%eax
 438:	8b 10                	mov    (%eax),%edx
 43a:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
 440:	89 54 24 04          	mov    %edx,0x4(%esp)
 444:	89 04 24             	mov    %eax,(%esp)
 447:	e8 75 fe ff ff       	call   2c1 <strcmp_c>
 44c:	85 c0                	test   %eax,%eax
 44e:	75 72                	jne    4c2 <compareuser+0x128>
 450:	8b 55 f4             	mov    -0xc(%ebp),%edx
 453:	89 d0                	mov    %edx,%eax
 455:	01 c0                	add    %eax,%eax
 457:	01 d0                	add    %edx,%eax
 459:	c1 e0 02             	shl    $0x2,%eax
 45c:	8d 5d f8             	lea    -0x8(%ebp),%ebx
 45f:	01 d8                	add    %ebx,%eax
 461:	2d 08 01 00 00       	sub    $0x108,%eax
 466:	8b 10                	mov    (%eax),%edx
 468:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
 46e:	89 54 24 04          	mov    %edx,0x4(%esp)
 472:	89 04 24             	mov    %eax,(%esp)
 475:	e8 47 fe ff ff       	call   2c1 <strcmp_c>
 47a:	85 c0                	test   %eax,%eax
 47c:	75 44                	jne    4c2 <compareuser+0x128>
			{
				setuser(users[ctr].ulevel);
 47e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 481:	89 d0                	mov    %edx,%eax
 483:	01 c0                	add    %eax,%eax
 485:	01 d0                	add    %edx,%eax
 487:	c1 e0 02             	shl    $0x2,%eax
 48a:	8d 75 f8             	lea    -0x8(%ebp),%esi
 48d:	01 f0                	add    %esi,%eax
 48f:	2d 04 01 00 00       	sub    $0x104,%eax
 494:	8b 00                	mov    (%eax),%eax
 496:	89 04 24             	mov    %eax,(%esp)
 499:	e8 0f 01 00 00       	call   5ad <setuser>
				
				printf(1,"%d",getuser());
 49e:	e8 02 01 00 00       	call   5a5 <getuser>
 4a3:	89 44 24 08          	mov    %eax,0x8(%esp)
 4a7:	c7 44 24 04 ae 0a 00 	movl   $0xaae,0x4(%esp)
 4ae:	00 
 4af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4b6:	e8 da 01 00 00       	call   695 <printf>
				return 1;
 4bb:	b8 01 00 00 00       	mov    $0x1,%eax
 4c0:	eb 34                	jmp    4f6 <compareuser+0x15c>
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
		
		for(ctr = 0; ctr < 20; ctr++)
 4c2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 4c6:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 4ca:	0f 8e 52 ff ff ff    	jle    422 <compareuser+0x88>
				
				printf(1,"%d",getuser());
				return 1;
			}
		}
		printf(1,"Invalid username/password\n");
 4d0:	c7 44 24 04 b1 0a 00 	movl   $0xab1,0x4(%esp)
 4d7:	00 
 4d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4df:	e8 b1 01 00 00       	call   695 <printf>
		if(state != 1)
 4e4:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 4e8:	74 07                	je     4f1 <compareuser+0x157>
			break;
	}
	return 0;
 4ea:	b8 00 00 00 00       	mov    $0x0,%eax
 4ef:	eb 05                	jmp    4f6 <compareuser+0x15c>
			}
		}
		printf(1,"Invalid username/password\n");
		if(state != 1)
			break;
	}
 4f1:	e9 0f ff ff ff       	jmp    405 <compareuser+0x6b>
	return 0;
}
 4f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4f9:	5b                   	pop    %ebx
 4fa:	5e                   	pop    %esi
 4fb:	5d                   	pop    %ebp
 4fc:	c3                   	ret    

000004fd <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4fd:	b8 01 00 00 00       	mov    $0x1,%eax
 502:	cd 40                	int    $0x40
 504:	c3                   	ret    

00000505 <exit>:
SYSCALL(exit)
 505:	b8 02 00 00 00       	mov    $0x2,%eax
 50a:	cd 40                	int    $0x40
 50c:	c3                   	ret    

0000050d <wait>:
SYSCALL(wait)
 50d:	b8 03 00 00 00       	mov    $0x3,%eax
 512:	cd 40                	int    $0x40
 514:	c3                   	ret    

00000515 <pipe>:
SYSCALL(pipe)
 515:	b8 04 00 00 00       	mov    $0x4,%eax
 51a:	cd 40                	int    $0x40
 51c:	c3                   	ret    

0000051d <read>:
SYSCALL(read)
 51d:	b8 05 00 00 00       	mov    $0x5,%eax
 522:	cd 40                	int    $0x40
 524:	c3                   	ret    

00000525 <write>:
SYSCALL(write)
 525:	b8 10 00 00 00       	mov    $0x10,%eax
 52a:	cd 40                	int    $0x40
 52c:	c3                   	ret    

0000052d <close>:
SYSCALL(close)
 52d:	b8 15 00 00 00       	mov    $0x15,%eax
 532:	cd 40                	int    $0x40
 534:	c3                   	ret    

00000535 <kill>:
SYSCALL(kill)
 535:	b8 06 00 00 00       	mov    $0x6,%eax
 53a:	cd 40                	int    $0x40
 53c:	c3                   	ret    

0000053d <exec>:
SYSCALL(exec)
 53d:	b8 07 00 00 00       	mov    $0x7,%eax
 542:	cd 40                	int    $0x40
 544:	c3                   	ret    

00000545 <open>:
SYSCALL(open)
 545:	b8 0f 00 00 00       	mov    $0xf,%eax
 54a:	cd 40                	int    $0x40
 54c:	c3                   	ret    

0000054d <mknod>:
SYSCALL(mknod)
 54d:	b8 11 00 00 00       	mov    $0x11,%eax
 552:	cd 40                	int    $0x40
 554:	c3                   	ret    

00000555 <unlink>:
SYSCALL(unlink)
 555:	b8 12 00 00 00       	mov    $0x12,%eax
 55a:	cd 40                	int    $0x40
 55c:	c3                   	ret    

0000055d <fstat>:
SYSCALL(fstat)
 55d:	b8 08 00 00 00       	mov    $0x8,%eax
 562:	cd 40                	int    $0x40
 564:	c3                   	ret    

00000565 <link>:
SYSCALL(link)
 565:	b8 13 00 00 00       	mov    $0x13,%eax
 56a:	cd 40                	int    $0x40
 56c:	c3                   	ret    

0000056d <mkdir>:
SYSCALL(mkdir)
 56d:	b8 14 00 00 00       	mov    $0x14,%eax
 572:	cd 40                	int    $0x40
 574:	c3                   	ret    

00000575 <chdir>:
SYSCALL(chdir)
 575:	b8 09 00 00 00       	mov    $0x9,%eax
 57a:	cd 40                	int    $0x40
 57c:	c3                   	ret    

0000057d <dup>:
SYSCALL(dup)
 57d:	b8 0a 00 00 00       	mov    $0xa,%eax
 582:	cd 40                	int    $0x40
 584:	c3                   	ret    

00000585 <getpid>:
SYSCALL(getpid)
 585:	b8 0b 00 00 00       	mov    $0xb,%eax
 58a:	cd 40                	int    $0x40
 58c:	c3                   	ret    

0000058d <sbrk>:
SYSCALL(sbrk)
 58d:	b8 0c 00 00 00       	mov    $0xc,%eax
 592:	cd 40                	int    $0x40
 594:	c3                   	ret    

00000595 <sleep>:
SYSCALL(sleep)
 595:	b8 0d 00 00 00       	mov    $0xd,%eax
 59a:	cd 40                	int    $0x40
 59c:	c3                   	ret    

0000059d <uptime>:
SYSCALL(uptime)
 59d:	b8 0e 00 00 00       	mov    $0xe,%eax
 5a2:	cd 40                	int    $0x40
 5a4:	c3                   	ret    

000005a5 <getuser>:
SYSCALL(getuser)
 5a5:	b8 16 00 00 00       	mov    $0x16,%eax
 5aa:	cd 40                	int    $0x40
 5ac:	c3                   	ret    

000005ad <setuser>:
SYSCALL(setuser)
 5ad:	b8 17 00 00 00       	mov    $0x17,%eax
 5b2:	cd 40                	int    $0x40
 5b4:	c3                   	ret    

000005b5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5b5:	55                   	push   %ebp
 5b6:	89 e5                	mov    %esp,%ebp
 5b8:	83 ec 18             	sub    $0x18,%esp
 5bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 5be:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5c1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5c8:	00 
 5c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d0:	8b 45 08             	mov    0x8(%ebp),%eax
 5d3:	89 04 24             	mov    %eax,(%esp)
 5d6:	e8 4a ff ff ff       	call   525 <write>
}
 5db:	c9                   	leave  
 5dc:	c3                   	ret    

000005dd <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5dd:	55                   	push   %ebp
 5de:	89 e5                	mov    %esp,%ebp
 5e0:	56                   	push   %esi
 5e1:	53                   	push   %ebx
 5e2:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5ec:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5f0:	74 17                	je     609 <printint+0x2c>
 5f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5f6:	79 11                	jns    609 <printint+0x2c>
    neg = 1;
 5f8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 602:	f7 d8                	neg    %eax
 604:	89 45 ec             	mov    %eax,-0x14(%ebp)
 607:	eb 06                	jmp    60f <printint+0x32>
  } else {
    x = xx;
 609:	8b 45 0c             	mov    0xc(%ebp),%eax
 60c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 60f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 616:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 619:	8d 41 01             	lea    0x1(%ecx),%eax
 61c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 61f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 622:	8b 45 ec             	mov    -0x14(%ebp),%eax
 625:	ba 00 00 00 00       	mov    $0x0,%edx
 62a:	f7 f3                	div    %ebx
 62c:	89 d0                	mov    %edx,%eax
 62e:	0f b6 80 c4 0d 00 00 	movzbl 0xdc4(%eax),%eax
 635:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 639:	8b 75 10             	mov    0x10(%ebp),%esi
 63c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 63f:	ba 00 00 00 00       	mov    $0x0,%edx
 644:	f7 f6                	div    %esi
 646:	89 45 ec             	mov    %eax,-0x14(%ebp)
 649:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 64d:	75 c7                	jne    616 <printint+0x39>
  if(neg)
 64f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 653:	74 10                	je     665 <printint+0x88>
    buf[i++] = '-';
 655:	8b 45 f4             	mov    -0xc(%ebp),%eax
 658:	8d 50 01             	lea    0x1(%eax),%edx
 65b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 65e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 663:	eb 1f                	jmp    684 <printint+0xa7>
 665:	eb 1d                	jmp    684 <printint+0xa7>
    putc(fd, buf[i]);
 667:	8d 55 dc             	lea    -0x24(%ebp),%edx
 66a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 66d:	01 d0                	add    %edx,%eax
 66f:	0f b6 00             	movzbl (%eax),%eax
 672:	0f be c0             	movsbl %al,%eax
 675:	89 44 24 04          	mov    %eax,0x4(%esp)
 679:	8b 45 08             	mov    0x8(%ebp),%eax
 67c:	89 04 24             	mov    %eax,(%esp)
 67f:	e8 31 ff ff ff       	call   5b5 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 684:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 688:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 68c:	79 d9                	jns    667 <printint+0x8a>
    putc(fd, buf[i]);
}
 68e:	83 c4 30             	add    $0x30,%esp
 691:	5b                   	pop    %ebx
 692:	5e                   	pop    %esi
 693:	5d                   	pop    %ebp
 694:	c3                   	ret    

00000695 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 695:	55                   	push   %ebp
 696:	89 e5                	mov    %esp,%ebp
 698:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 69b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6a2:	8d 45 0c             	lea    0xc(%ebp),%eax
 6a5:	83 c0 04             	add    $0x4,%eax
 6a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6b2:	e9 7c 01 00 00       	jmp    833 <printf+0x19e>
    c = fmt[i] & 0xff;
 6b7:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6bd:	01 d0                	add    %edx,%eax
 6bf:	0f b6 00             	movzbl (%eax),%eax
 6c2:	0f be c0             	movsbl %al,%eax
 6c5:	25 ff 00 00 00       	and    $0xff,%eax
 6ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6d1:	75 2c                	jne    6ff <printf+0x6a>
      if(c == '%'){
 6d3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6d7:	75 0c                	jne    6e5 <printf+0x50>
        state = '%';
 6d9:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6e0:	e9 4a 01 00 00       	jmp    82f <printf+0x19a>
      } else {
        putc(fd, c);
 6e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6e8:	0f be c0             	movsbl %al,%eax
 6eb:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ef:	8b 45 08             	mov    0x8(%ebp),%eax
 6f2:	89 04 24             	mov    %eax,(%esp)
 6f5:	e8 bb fe ff ff       	call   5b5 <putc>
 6fa:	e9 30 01 00 00       	jmp    82f <printf+0x19a>
      }
    } else if(state == '%'){
 6ff:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 703:	0f 85 26 01 00 00    	jne    82f <printf+0x19a>
      if(c == 'd'){
 709:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 70d:	75 2d                	jne    73c <printf+0xa7>
        printint(fd, *ap, 10, 1);
 70f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 712:	8b 00                	mov    (%eax),%eax
 714:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 71b:	00 
 71c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 723:	00 
 724:	89 44 24 04          	mov    %eax,0x4(%esp)
 728:	8b 45 08             	mov    0x8(%ebp),%eax
 72b:	89 04 24             	mov    %eax,(%esp)
 72e:	e8 aa fe ff ff       	call   5dd <printint>
        ap++;
 733:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 737:	e9 ec 00 00 00       	jmp    828 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 73c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 740:	74 06                	je     748 <printf+0xb3>
 742:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 746:	75 2d                	jne    775 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 748:	8b 45 e8             	mov    -0x18(%ebp),%eax
 74b:	8b 00                	mov    (%eax),%eax
 74d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 754:	00 
 755:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 75c:	00 
 75d:	89 44 24 04          	mov    %eax,0x4(%esp)
 761:	8b 45 08             	mov    0x8(%ebp),%eax
 764:	89 04 24             	mov    %eax,(%esp)
 767:	e8 71 fe ff ff       	call   5dd <printint>
        ap++;
 76c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 770:	e9 b3 00 00 00       	jmp    828 <printf+0x193>
      } else if(c == 's'){
 775:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 779:	75 45                	jne    7c0 <printf+0x12b>
        s = (char*)*ap;
 77b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 77e:	8b 00                	mov    (%eax),%eax
 780:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 783:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 787:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 78b:	75 09                	jne    796 <printf+0x101>
          s = "(null)";
 78d:	c7 45 f4 cc 0a 00 00 	movl   $0xacc,-0xc(%ebp)
        while(*s != 0){
 794:	eb 1e                	jmp    7b4 <printf+0x11f>
 796:	eb 1c                	jmp    7b4 <printf+0x11f>
          putc(fd, *s);
 798:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79b:	0f b6 00             	movzbl (%eax),%eax
 79e:	0f be c0             	movsbl %al,%eax
 7a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 7a5:	8b 45 08             	mov    0x8(%ebp),%eax
 7a8:	89 04 24             	mov    %eax,(%esp)
 7ab:	e8 05 fe ff ff       	call   5b5 <putc>
          s++;
 7b0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b7:	0f b6 00             	movzbl (%eax),%eax
 7ba:	84 c0                	test   %al,%al
 7bc:	75 da                	jne    798 <printf+0x103>
 7be:	eb 68                	jmp    828 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7c0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7c4:	75 1d                	jne    7e3 <printf+0x14e>
        putc(fd, *ap);
 7c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c9:	8b 00                	mov    (%eax),%eax
 7cb:	0f be c0             	movsbl %al,%eax
 7ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 7d2:	8b 45 08             	mov    0x8(%ebp),%eax
 7d5:	89 04 24             	mov    %eax,(%esp)
 7d8:	e8 d8 fd ff ff       	call   5b5 <putc>
        ap++;
 7dd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7e1:	eb 45                	jmp    828 <printf+0x193>
      } else if(c == '%'){
 7e3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7e7:	75 17                	jne    800 <printf+0x16b>
        putc(fd, c);
 7e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7ec:	0f be c0             	movsbl %al,%eax
 7ef:	89 44 24 04          	mov    %eax,0x4(%esp)
 7f3:	8b 45 08             	mov    0x8(%ebp),%eax
 7f6:	89 04 24             	mov    %eax,(%esp)
 7f9:	e8 b7 fd ff ff       	call   5b5 <putc>
 7fe:	eb 28                	jmp    828 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 800:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 807:	00 
 808:	8b 45 08             	mov    0x8(%ebp),%eax
 80b:	89 04 24             	mov    %eax,(%esp)
 80e:	e8 a2 fd ff ff       	call   5b5 <putc>
        putc(fd, c);
 813:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 816:	0f be c0             	movsbl %al,%eax
 819:	89 44 24 04          	mov    %eax,0x4(%esp)
 81d:	8b 45 08             	mov    0x8(%ebp),%eax
 820:	89 04 24             	mov    %eax,(%esp)
 823:	e8 8d fd ff ff       	call   5b5 <putc>
      }
      state = 0;
 828:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 82f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 833:	8b 55 0c             	mov    0xc(%ebp),%edx
 836:	8b 45 f0             	mov    -0x10(%ebp),%eax
 839:	01 d0                	add    %edx,%eax
 83b:	0f b6 00             	movzbl (%eax),%eax
 83e:	84 c0                	test   %al,%al
 840:	0f 85 71 fe ff ff    	jne    6b7 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 846:	c9                   	leave  
 847:	c3                   	ret    

00000848 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 848:	55                   	push   %ebp
 849:	89 e5                	mov    %esp,%ebp
 84b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 84e:	8b 45 08             	mov    0x8(%ebp),%eax
 851:	83 e8 08             	sub    $0x8,%eax
 854:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 857:	a1 e0 0d 00 00       	mov    0xde0,%eax
 85c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 85f:	eb 24                	jmp    885 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 861:	8b 45 fc             	mov    -0x4(%ebp),%eax
 864:	8b 00                	mov    (%eax),%eax
 866:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 869:	77 12                	ja     87d <free+0x35>
 86b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 871:	77 24                	ja     897 <free+0x4f>
 873:	8b 45 fc             	mov    -0x4(%ebp),%eax
 876:	8b 00                	mov    (%eax),%eax
 878:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 87b:	77 1a                	ja     897 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 880:	8b 00                	mov    (%eax),%eax
 882:	89 45 fc             	mov    %eax,-0x4(%ebp)
 885:	8b 45 f8             	mov    -0x8(%ebp),%eax
 888:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 88b:	76 d4                	jbe    861 <free+0x19>
 88d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 890:	8b 00                	mov    (%eax),%eax
 892:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 895:	76 ca                	jbe    861 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 897:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89a:	8b 40 04             	mov    0x4(%eax),%eax
 89d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a7:	01 c2                	add    %eax,%edx
 8a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ac:	8b 00                	mov    (%eax),%eax
 8ae:	39 c2                	cmp    %eax,%edx
 8b0:	75 24                	jne    8d6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b5:	8b 50 04             	mov    0x4(%eax),%edx
 8b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bb:	8b 00                	mov    (%eax),%eax
 8bd:	8b 40 04             	mov    0x4(%eax),%eax
 8c0:	01 c2                	add    %eax,%edx
 8c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cb:	8b 00                	mov    (%eax),%eax
 8cd:	8b 10                	mov    (%eax),%edx
 8cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d2:	89 10                	mov    %edx,(%eax)
 8d4:	eb 0a                	jmp    8e0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d9:	8b 10                	mov    (%eax),%edx
 8db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8de:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e3:	8b 40 04             	mov    0x4(%eax),%eax
 8e6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f0:	01 d0                	add    %edx,%eax
 8f2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8f5:	75 20                	jne    917 <free+0xcf>
    p->s.size += bp->s.size;
 8f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fa:	8b 50 04             	mov    0x4(%eax),%edx
 8fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 900:	8b 40 04             	mov    0x4(%eax),%eax
 903:	01 c2                	add    %eax,%edx
 905:	8b 45 fc             	mov    -0x4(%ebp),%eax
 908:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 90b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90e:	8b 10                	mov    (%eax),%edx
 910:	8b 45 fc             	mov    -0x4(%ebp),%eax
 913:	89 10                	mov    %edx,(%eax)
 915:	eb 08                	jmp    91f <free+0xd7>
  } else
    p->s.ptr = bp;
 917:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 91d:	89 10                	mov    %edx,(%eax)
  freep = p;
 91f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 922:	a3 e0 0d 00 00       	mov    %eax,0xde0
}
 927:	c9                   	leave  
 928:	c3                   	ret    

00000929 <morecore>:

static Header*
morecore(uint nu)
{
 929:	55                   	push   %ebp
 92a:	89 e5                	mov    %esp,%ebp
 92c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 92f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 936:	77 07                	ja     93f <morecore+0x16>
    nu = 4096;
 938:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 93f:	8b 45 08             	mov    0x8(%ebp),%eax
 942:	c1 e0 03             	shl    $0x3,%eax
 945:	89 04 24             	mov    %eax,(%esp)
 948:	e8 40 fc ff ff       	call   58d <sbrk>
 94d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 950:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 954:	75 07                	jne    95d <morecore+0x34>
    return 0;
 956:	b8 00 00 00 00       	mov    $0x0,%eax
 95b:	eb 22                	jmp    97f <morecore+0x56>
  hp = (Header*)p;
 95d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 960:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 963:	8b 45 f0             	mov    -0x10(%ebp),%eax
 966:	8b 55 08             	mov    0x8(%ebp),%edx
 969:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 96c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 96f:	83 c0 08             	add    $0x8,%eax
 972:	89 04 24             	mov    %eax,(%esp)
 975:	e8 ce fe ff ff       	call   848 <free>
  return freep;
 97a:	a1 e0 0d 00 00       	mov    0xde0,%eax
}
 97f:	c9                   	leave  
 980:	c3                   	ret    

00000981 <malloc>:

void*
malloc(uint nbytes)
{
 981:	55                   	push   %ebp
 982:	89 e5                	mov    %esp,%ebp
 984:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 987:	8b 45 08             	mov    0x8(%ebp),%eax
 98a:	83 c0 07             	add    $0x7,%eax
 98d:	c1 e8 03             	shr    $0x3,%eax
 990:	83 c0 01             	add    $0x1,%eax
 993:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 996:	a1 e0 0d 00 00       	mov    0xde0,%eax
 99b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 99e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9a2:	75 23                	jne    9c7 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9a4:	c7 45 f0 d8 0d 00 00 	movl   $0xdd8,-0x10(%ebp)
 9ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ae:	a3 e0 0d 00 00       	mov    %eax,0xde0
 9b3:	a1 e0 0d 00 00       	mov    0xde0,%eax
 9b8:	a3 d8 0d 00 00       	mov    %eax,0xdd8
    base.s.size = 0;
 9bd:	c7 05 dc 0d 00 00 00 	movl   $0x0,0xddc
 9c4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ca:	8b 00                	mov    (%eax),%eax
 9cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d2:	8b 40 04             	mov    0x4(%eax),%eax
 9d5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9d8:	72 4d                	jb     a27 <malloc+0xa6>
      if(p->s.size == nunits)
 9da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9dd:	8b 40 04             	mov    0x4(%eax),%eax
 9e0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9e3:	75 0c                	jne    9f1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e8:	8b 10                	mov    (%eax),%edx
 9ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ed:	89 10                	mov    %edx,(%eax)
 9ef:	eb 26                	jmp    a17 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f4:	8b 40 04             	mov    0x4(%eax),%eax
 9f7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9fa:	89 c2                	mov    %eax,%edx
 9fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ff:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a05:	8b 40 04             	mov    0x4(%eax),%eax
 a08:	c1 e0 03             	shl    $0x3,%eax
 a0b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a11:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a14:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a1a:	a3 e0 0d 00 00       	mov    %eax,0xde0
      return (void*)(p + 1);
 a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a22:	83 c0 08             	add    $0x8,%eax
 a25:	eb 38                	jmp    a5f <malloc+0xde>
    }
    if(p == freep)
 a27:	a1 e0 0d 00 00       	mov    0xde0,%eax
 a2c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a2f:	75 1b                	jne    a4c <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 a31:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a34:	89 04 24             	mov    %eax,(%esp)
 a37:	e8 ed fe ff ff       	call   929 <morecore>
 a3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a43:	75 07                	jne    a4c <malloc+0xcb>
        return 0;
 a45:	b8 00 00 00 00       	mov    $0x0,%eax
 a4a:	eb 13                	jmp    a5f <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a55:	8b 00                	mov    (%eax),%eax
 a57:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a5a:	e9 70 ff ff ff       	jmp    9cf <malloc+0x4e>
}
 a5f:	c9                   	leave  
 a60:	c3                   	ret    
