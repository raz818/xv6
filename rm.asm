
_rm:     file format elf32-i386


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

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "Usage: rm files...\n");
   f:	c7 44 24 04 ec 0a 00 	movl   $0xaec,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 fc 06 00 00       	call   71f <printf>
    exit();
  23:	e8 67 05 00 00       	call   58f <exit>
  }
  if(getuser() != 0){
  28:	e8 02 06 00 00       	call   62f <getuser>
  2d:	85 c0                	test   %eax,%eax
  2f:	74 65                	je     96 <main+0x96>
  for(i = 1; i < argc; i++){
  31:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  38:	00 
  39:	eb 50                	jmp    8b <main+0x8b>
    if(unlink(argv[i]) < 0){
  3b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  3f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  46:	8b 45 0c             	mov    0xc(%ebp),%eax
  49:	01 d0                	add    %edx,%eax
  4b:	8b 00                	mov    (%eax),%eax
  4d:	89 04 24             	mov    %eax,(%esp)
  50:	e8 8a 05 00 00       	call   5df <unlink>
  55:	85 c0                	test   %eax,%eax
  57:	79 2d                	jns    86 <main+0x86>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  59:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  64:	8b 45 0c             	mov    0xc(%ebp),%eax
  67:	01 d0                	add    %edx,%eax
  69:	8b 00                	mov    (%eax),%eax
  6b:	89 44 24 08          	mov    %eax,0x8(%esp)
  6f:	c7 44 24 04 00 0b 00 	movl   $0xb00,0x4(%esp)
  76:	00 
  77:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  7e:	e8 9c 06 00 00       	call   71f <printf>
      break;
  83:	90                   	nop
  84:	eb 29                	jmp    af <main+0xaf>
  if(argc < 2){
    printf(2, "Usage: rm files...\n");
    exit();
  }
  if(getuser() != 0){
  for(i = 1; i < argc; i++){
  86:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  8b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  8f:	3b 45 08             	cmp    0x8(%ebp),%eax
  92:	7c a7                	jl     3b <main+0x3b>
  94:	eb 19                	jmp    af <main+0xaf>
      break;
    }
  }
  }
  else{
    printf(2, "You do not have permission to do that\n");
  96:	c7 44 24 04 1c 0b 00 	movl   $0xb1c,0x4(%esp)
  9d:	00 
  9e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  a5:	e8 75 06 00 00       	call   71f <printf>
    exit();
  aa:	e8 e0 04 00 00       	call   58f <exit>
  }

  exit();
  af:	e8 db 04 00 00       	call   58f <exit>

000000b4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  b4:	55                   	push   %ebp
  b5:	89 e5                	mov    %esp,%ebp
  b7:	57                   	push   %edi
  b8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  bc:	8b 55 10             	mov    0x10(%ebp),%edx
  bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  c2:	89 cb                	mov    %ecx,%ebx
  c4:	89 df                	mov    %ebx,%edi
  c6:	89 d1                	mov    %edx,%ecx
  c8:	fc                   	cld    
  c9:	f3 aa                	rep stos %al,%es:(%edi)
  cb:	89 ca                	mov    %ecx,%edx
  cd:	89 fb                	mov    %edi,%ebx
  cf:	89 5d 08             	mov    %ebx,0x8(%ebp)
  d2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  d5:	5b                   	pop    %ebx
  d6:	5f                   	pop    %edi
  d7:	5d                   	pop    %ebp
  d8:	c3                   	ret    

000000d9 <thing>:
#include "user.h"
#include "x86.h"


int
thing(void){
  d9:	55                   	push   %ebp
  da:	89 e5                	mov    %esp,%ebp
  return 1;
  dc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  e1:	5d                   	pop    %ebp
  e2:	c3                   	ret    

000000e3 <strcpy>:

char*
strcpy(char *s, char *t)
{
  e3:	55                   	push   %ebp
  e4:	89 e5                	mov    %esp,%ebp
  e6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  e9:	8b 45 08             	mov    0x8(%ebp),%eax
  ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ef:	90                   	nop
  f0:	8b 45 08             	mov    0x8(%ebp),%eax
  f3:	8d 50 01             	lea    0x1(%eax),%edx
  f6:	89 55 08             	mov    %edx,0x8(%ebp)
  f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  fc:	8d 4a 01             	lea    0x1(%edx),%ecx
  ff:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 102:	0f b6 12             	movzbl (%edx),%edx
 105:	88 10                	mov    %dl,(%eax)
 107:	0f b6 00             	movzbl (%eax),%eax
 10a:	84 c0                	test   %al,%al
 10c:	75 e2                	jne    f0 <strcpy+0xd>
    ;
  return os;
 10e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 111:	c9                   	leave  
 112:	c3                   	ret    

00000113 <strcmp>:



int
strcmp(const char *p, const char *q)
{
 113:	55                   	push   %ebp
 114:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 116:	eb 08                	jmp    120 <strcmp+0xd>
    p++, q++;
 118:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 11c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)


int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 120:	8b 45 08             	mov    0x8(%ebp),%eax
 123:	0f b6 00             	movzbl (%eax),%eax
 126:	84 c0                	test   %al,%al
 128:	74 10                	je     13a <strcmp+0x27>
 12a:	8b 45 08             	mov    0x8(%ebp),%eax
 12d:	0f b6 10             	movzbl (%eax),%edx
 130:	8b 45 0c             	mov    0xc(%ebp),%eax
 133:	0f b6 00             	movzbl (%eax),%eax
 136:	38 c2                	cmp    %al,%dl
 138:	74 de                	je     118 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 13a:	8b 45 08             	mov    0x8(%ebp),%eax
 13d:	0f b6 00             	movzbl (%eax),%eax
 140:	0f b6 d0             	movzbl %al,%edx
 143:	8b 45 0c             	mov    0xc(%ebp),%eax
 146:	0f b6 00             	movzbl (%eax),%eax
 149:	0f b6 c0             	movzbl %al,%eax
 14c:	29 c2                	sub    %eax,%edx
 14e:	89 d0                	mov    %edx,%eax
}
 150:	5d                   	pop    %ebp
 151:	c3                   	ret    

00000152 <strlen>:

uint
strlen(char *s)
{
 152:	55                   	push   %ebp
 153:	89 e5                	mov    %esp,%ebp
 155:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 158:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 15f:	eb 04                	jmp    165 <strlen+0x13>
 161:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 165:	8b 55 fc             	mov    -0x4(%ebp),%edx
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	01 d0                	add    %edx,%eax
 16d:	0f b6 00             	movzbl (%eax),%eax
 170:	84 c0                	test   %al,%al
 172:	75 ed                	jne    161 <strlen+0xf>
    ;
  return n;
 174:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 177:	c9                   	leave  
 178:	c3                   	ret    

00000179 <stringlen>:

uint
stringlen(char **s){
 179:	55                   	push   %ebp
 17a:	89 e5                	mov    %esp,%ebp
 17c:	83 ec 10             	sub    $0x10,%esp
	int n;

  for(n = 0; s[n]; n++)
 17f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 186:	eb 04                	jmp    18c <stringlen+0x13>
 188:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 18c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 18f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 196:	8b 45 08             	mov    0x8(%ebp),%eax
 199:	01 d0                	add    %edx,%eax
 19b:	8b 00                	mov    (%eax),%eax
 19d:	85 c0                	test   %eax,%eax
 19f:	75 e7                	jne    188 <stringlen+0xf>
    ;
  return n;
 1a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a4:	c9                   	leave  
 1a5:	c3                   	ret    

000001a6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a6:	55                   	push   %ebp
 1a7:	89 e5                	mov    %esp,%ebp
 1a9:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1ac:	8b 45 10             	mov    0x10(%ebp),%eax
 1af:	89 44 24 08          	mov    %eax,0x8(%esp)
 1b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	89 04 24             	mov    %eax,(%esp)
 1c0:	e8 ef fe ff ff       	call   b4 <stosb>
  return dst;
 1c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1c8:	c9                   	leave  
 1c9:	c3                   	ret    

000001ca <strchr>:

char*
strchr(const char *s, char c)
{
 1ca:	55                   	push   %ebp
 1cb:	89 e5                	mov    %esp,%ebp
 1cd:	83 ec 04             	sub    $0x4,%esp
 1d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1d6:	eb 14                	jmp    1ec <strchr+0x22>
    if(*s == c)
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
 1db:	0f b6 00             	movzbl (%eax),%eax
 1de:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1e1:	75 05                	jne    1e8 <strchr+0x1e>
      return (char*)s;
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	eb 13                	jmp    1fb <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1e8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1ec:	8b 45 08             	mov    0x8(%ebp),%eax
 1ef:	0f b6 00             	movzbl (%eax),%eax
 1f2:	84 c0                	test   %al,%al
 1f4:	75 e2                	jne    1d8 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1fb:	c9                   	leave  
 1fc:	c3                   	ret    

000001fd <gets>:

char*
gets(char *buf, int max)
{
 1fd:	55                   	push   %ebp
 1fe:	89 e5                	mov    %esp,%ebp
 200:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 203:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 20a:	eb 4c                	jmp    258 <gets+0x5b>
    cc = read(0, &c, 1);
 20c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 213:	00 
 214:	8d 45 ef             	lea    -0x11(%ebp),%eax
 217:	89 44 24 04          	mov    %eax,0x4(%esp)
 21b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 222:	e8 80 03 00 00       	call   5a7 <read>
 227:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 22a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 22e:	7f 02                	jg     232 <gets+0x35>
      break;
 230:	eb 31                	jmp    263 <gets+0x66>
    buf[i++] = c;
 232:	8b 45 f4             	mov    -0xc(%ebp),%eax
 235:	8d 50 01             	lea    0x1(%eax),%edx
 238:	89 55 f4             	mov    %edx,-0xc(%ebp)
 23b:	89 c2                	mov    %eax,%edx
 23d:	8b 45 08             	mov    0x8(%ebp),%eax
 240:	01 c2                	add    %eax,%edx
 242:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 246:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 248:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24c:	3c 0a                	cmp    $0xa,%al
 24e:	74 13                	je     263 <gets+0x66>
 250:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 254:	3c 0d                	cmp    $0xd,%al
 256:	74 0b                	je     263 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 258:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25b:	83 c0 01             	add    $0x1,%eax
 25e:	3b 45 0c             	cmp    0xc(%ebp),%eax
 261:	7c a9                	jl     20c <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 263:	8b 55 f4             	mov    -0xc(%ebp),%edx
 266:	8b 45 08             	mov    0x8(%ebp),%eax
 269:	01 d0                	add    %edx,%eax
 26b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 271:	c9                   	leave  
 272:	c3                   	ret    

00000273 <stat>:

int
stat(char *n, struct stat *st)
{
 273:	55                   	push   %ebp
 274:	89 e5                	mov    %esp,%ebp
 276:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 279:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 280:	00 
 281:	8b 45 08             	mov    0x8(%ebp),%eax
 284:	89 04 24             	mov    %eax,(%esp)
 287:	e8 43 03 00 00       	call   5cf <open>
 28c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 28f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 293:	79 07                	jns    29c <stat+0x29>
    return -1;
 295:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 29a:	eb 23                	jmp    2bf <stat+0x4c>
  r = fstat(fd, st);
 29c:	8b 45 0c             	mov    0xc(%ebp),%eax
 29f:	89 44 24 04          	mov    %eax,0x4(%esp)
 2a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a6:	89 04 24             	mov    %eax,(%esp)
 2a9:	e8 39 03 00 00       	call   5e7 <fstat>
 2ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2b4:	89 04 24             	mov    %eax,(%esp)
 2b7:	e8 fb 02 00 00       	call   5b7 <close>
  return r;
 2bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2bf:	c9                   	leave  
 2c0:	c3                   	ret    

000002c1 <atoi>:

int
atoi(const char *s)
{
 2c1:	55                   	push   %ebp
 2c2:	89 e5                	mov    %esp,%ebp
 2c4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2ce:	eb 25                	jmp    2f5 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d3:	89 d0                	mov    %edx,%eax
 2d5:	c1 e0 02             	shl    $0x2,%eax
 2d8:	01 d0                	add    %edx,%eax
 2da:	01 c0                	add    %eax,%eax
 2dc:	89 c1                	mov    %eax,%ecx
 2de:	8b 45 08             	mov    0x8(%ebp),%eax
 2e1:	8d 50 01             	lea    0x1(%eax),%edx
 2e4:	89 55 08             	mov    %edx,0x8(%ebp)
 2e7:	0f b6 00             	movzbl (%eax),%eax
 2ea:	0f be c0             	movsbl %al,%eax
 2ed:	01 c8                	add    %ecx,%eax
 2ef:	83 e8 30             	sub    $0x30,%eax
 2f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f5:	8b 45 08             	mov    0x8(%ebp),%eax
 2f8:	0f b6 00             	movzbl (%eax),%eax
 2fb:	3c 2f                	cmp    $0x2f,%al
 2fd:	7e 0a                	jle    309 <atoi+0x48>
 2ff:	8b 45 08             	mov    0x8(%ebp),%eax
 302:	0f b6 00             	movzbl (%eax),%eax
 305:	3c 39                	cmp    $0x39,%al
 307:	7e c7                	jle    2d0 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 309:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 30c:	c9                   	leave  
 30d:	c3                   	ret    

0000030e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 30e:	55                   	push   %ebp
 30f:	89 e5                	mov    %esp,%ebp
 311:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 314:	8b 45 08             	mov    0x8(%ebp),%eax
 317:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 31a:	8b 45 0c             	mov    0xc(%ebp),%eax
 31d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 320:	eb 17                	jmp    339 <memmove+0x2b>
    *dst++ = *src++;
 322:	8b 45 fc             	mov    -0x4(%ebp),%eax
 325:	8d 50 01             	lea    0x1(%eax),%edx
 328:	89 55 fc             	mov    %edx,-0x4(%ebp)
 32b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 32e:	8d 4a 01             	lea    0x1(%edx),%ecx
 331:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 334:	0f b6 12             	movzbl (%edx),%edx
 337:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 339:	8b 45 10             	mov    0x10(%ebp),%eax
 33c:	8d 50 ff             	lea    -0x1(%eax),%edx
 33f:	89 55 10             	mov    %edx,0x10(%ebp)
 342:	85 c0                	test   %eax,%eax
 344:	7f dc                	jg     322 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 346:	8b 45 08             	mov    0x8(%ebp),%eax
}
 349:	c9                   	leave  
 34a:	c3                   	ret    

0000034b <strcmp_c>:


int
strcmp_c(const char *s1, const char *s2)
{
 34b:	55                   	push   %ebp
 34c:	89 e5                	mov    %esp,%ebp
    for ( ; *s1 == *s2; s1++, s2++)
 34e:	eb 19                	jmp    369 <strcmp_c+0x1e>
	if (*s1 == '\0')
 350:	8b 45 08             	mov    0x8(%ebp),%eax
 353:	0f b6 00             	movzbl (%eax),%eax
 356:	84 c0                	test   %al,%al
 358:	75 07                	jne    361 <strcmp_c+0x16>
	    return 0;
 35a:	b8 00 00 00 00       	mov    $0x0,%eax
 35f:	eb 34                	jmp    395 <strcmp_c+0x4a>


int
strcmp_c(const char *s1, const char *s2)
{
    for ( ; *s1 == *s2; s1++, s2++)
 361:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 365:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 369:	8b 45 08             	mov    0x8(%ebp),%eax
 36c:	0f b6 10             	movzbl (%eax),%edx
 36f:	8b 45 0c             	mov    0xc(%ebp),%eax
 372:	0f b6 00             	movzbl (%eax),%eax
 375:	38 c2                	cmp    %al,%dl
 377:	74 d7                	je     350 <strcmp_c+0x5>
	if (*s1 == '\0')
	    return 0;
    return ((*(unsigned char *)s1 < *(unsigned char *)s2) ? -1 : +1);
 379:	8b 45 08             	mov    0x8(%ebp),%eax
 37c:	0f b6 10             	movzbl (%eax),%edx
 37f:	8b 45 0c             	mov    0xc(%ebp),%eax
 382:	0f b6 00             	movzbl (%eax),%eax
 385:	38 c2                	cmp    %al,%dl
 387:	73 07                	jae    390 <strcmp_c+0x45>
 389:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 38e:	eb 05                	jmp    395 <strcmp_c+0x4a>
 390:	b8 01 00 00 00       	mov    $0x1,%eax
}
 395:	5d                   	pop    %ebp
 396:	c3                   	ret    

00000397 <readuser>:


struct USER
readuser(){
 397:	55                   	push   %ebp
 398:	89 e5                	mov    %esp,%ebp
 39a:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char buff1[512], buff2[512];
	struct USER u;
	printf(1,"Please enter a username: ");
 3a0:	c7 44 24 04 43 0b 00 	movl   $0xb43,0x4(%esp)
 3a7:	00 
 3a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3af:	e8 6b 03 00 00       	call   71f <printf>
	u.name = gets(buff1, 50);
 3b4:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 3bb:	00 
 3bc:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
 3c2:	89 04 24             	mov    %eax,(%esp)
 3c5:	e8 33 fe ff ff       	call   1fd <gets>
 3ca:	89 85 ec fb ff ff    	mov    %eax,-0x414(%ebp)
	printf(1,"Please enter a password: ");
 3d0:	c7 44 24 04 5d 0b 00 	movl   $0xb5d,0x4(%esp)
 3d7:	00 
 3d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3df:	e8 3b 03 00 00       	call   71f <printf>
	u.pass = gets(buff2, 50);
 3e4:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 3eb:	00 
 3ec:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
 3f2:	89 04 24             	mov    %eax,(%esp)
 3f5:	e8 03 fe ff ff       	call   1fd <gets>
 3fa:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
	return u;
 400:	8b 45 08             	mov    0x8(%ebp),%eax
 403:	8b 95 ec fb ff ff    	mov    -0x414(%ebp),%edx
 409:	89 10                	mov    %edx,(%eax)
 40b:	8b 95 f0 fb ff ff    	mov    -0x410(%ebp),%edx
 411:	89 50 04             	mov    %edx,0x4(%eax)
 414:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
 41a:	89 50 08             	mov    %edx,0x8(%eax)
}
 41d:	8b 45 08             	mov    0x8(%ebp),%eax
 420:	c9                   	leave  
 421:	c2 04 00             	ret    $0x4

00000424 <compareuser>:


int
compareuser(int state){
 424:	55                   	push   %ebp
 425:	89 e5                	mov    %esp,%ebp
 427:	56                   	push   %esi
 428:	53                   	push   %ebx
 429:	81 ec 30 01 00 00    	sub    $0x130,%esp
	struct USER u1,u2;
	struct USER users[20];
	u1.name = "john\n";
 42f:	c7 45 e8 77 0b 00 00 	movl   $0xb77,-0x18(%ebp)
	u1.pass = "1234\n";
 436:	c7 45 ec 7d 0b 00 00 	movl   $0xb7d,-0x14(%ebp)
	u1.ulevel = 0;
 43d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	u2.name = "james\n";
 444:	c7 45 dc 83 0b 00 00 	movl   $0xb83,-0x24(%ebp)
	u2.pass = "pass\n";
 44b:	c7 45 e0 8a 0b 00 00 	movl   $0xb8a,-0x20(%ebp)
	u2.ulevel = 1;
 452:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	users[0] = u1;
 459:	8b 45 e8             	mov    -0x18(%ebp),%eax
 45c:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
 462:	8b 45 ec             	mov    -0x14(%ebp),%eax
 465:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
 46b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 46e:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
	users[1] = u2;
 474:	8b 45 dc             	mov    -0x24(%ebp),%eax
 477:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
 47d:	8b 45 e0             	mov    -0x20(%ebp),%eax
 480:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
 486:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 489:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
	
	
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
 48f:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
 495:	89 04 24             	mov    %eax,(%esp)
 498:	e8 fa fe ff ff       	call   397 <readuser>
 49d:	83 ec 04             	sub    $0x4,%esp
		
		for(ctr = 0; ctr < 20; ctr++)
 4a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 4a7:	e9 a4 00 00 00       	jmp    550 <compareuser+0x12c>
		{

			if(strcmp_c(u.name,users[ctr].name) == 0 && strcmp_c(u.pass,users[ctr].pass) == 0)
 4ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4af:	89 d0                	mov    %edx,%eax
 4b1:	01 c0                	add    %eax,%eax
 4b3:	01 d0                	add    %edx,%eax
 4b5:	c1 e0 02             	shl    $0x2,%eax
 4b8:	8d 4d f8             	lea    -0x8(%ebp),%ecx
 4bb:	01 c8                	add    %ecx,%eax
 4bd:	2d 0c 01 00 00       	sub    $0x10c,%eax
 4c2:	8b 10                	mov    (%eax),%edx
 4c4:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
 4ca:	89 54 24 04          	mov    %edx,0x4(%esp)
 4ce:	89 04 24             	mov    %eax,(%esp)
 4d1:	e8 75 fe ff ff       	call   34b <strcmp_c>
 4d6:	85 c0                	test   %eax,%eax
 4d8:	75 72                	jne    54c <compareuser+0x128>
 4da:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4dd:	89 d0                	mov    %edx,%eax
 4df:	01 c0                	add    %eax,%eax
 4e1:	01 d0                	add    %edx,%eax
 4e3:	c1 e0 02             	shl    $0x2,%eax
 4e6:	8d 5d f8             	lea    -0x8(%ebp),%ebx
 4e9:	01 d8                	add    %ebx,%eax
 4eb:	2d 08 01 00 00       	sub    $0x108,%eax
 4f0:	8b 10                	mov    (%eax),%edx
 4f2:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
 4f8:	89 54 24 04          	mov    %edx,0x4(%esp)
 4fc:	89 04 24             	mov    %eax,(%esp)
 4ff:	e8 47 fe ff ff       	call   34b <strcmp_c>
 504:	85 c0                	test   %eax,%eax
 506:	75 44                	jne    54c <compareuser+0x128>
			{
				setuser(users[ctr].ulevel);
 508:	8b 55 f4             	mov    -0xc(%ebp),%edx
 50b:	89 d0                	mov    %edx,%eax
 50d:	01 c0                	add    %eax,%eax
 50f:	01 d0                	add    %edx,%eax
 511:	c1 e0 02             	shl    $0x2,%eax
 514:	8d 75 f8             	lea    -0x8(%ebp),%esi
 517:	01 f0                	add    %esi,%eax
 519:	2d 04 01 00 00       	sub    $0x104,%eax
 51e:	8b 00                	mov    (%eax),%eax
 520:	89 04 24             	mov    %eax,(%esp)
 523:	e8 0f 01 00 00       	call   637 <setuser>
				
				printf(1,"%d",getuser());
 528:	e8 02 01 00 00       	call   62f <getuser>
 52d:	89 44 24 08          	mov    %eax,0x8(%esp)
 531:	c7 44 24 04 90 0b 00 	movl   $0xb90,0x4(%esp)
 538:	00 
 539:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 540:	e8 da 01 00 00       	call   71f <printf>
				return 1;
 545:	b8 01 00 00 00       	mov    $0x1,%eax
 54a:	eb 34                	jmp    580 <compareuser+0x15c>
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
		
		for(ctr = 0; ctr < 20; ctr++)
 54c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 550:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 554:	0f 8e 52 ff ff ff    	jle    4ac <compareuser+0x88>
				
				printf(1,"%d",getuser());
				return 1;
			}
		}
		printf(1,"Invalid username/password\n");
 55a:	c7 44 24 04 93 0b 00 	movl   $0xb93,0x4(%esp)
 561:	00 
 562:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 569:	e8 b1 01 00 00       	call   71f <printf>
		if(state != 1)
 56e:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 572:	74 07                	je     57b <compareuser+0x157>
			break;
	}
	return 0;
 574:	b8 00 00 00 00       	mov    $0x0,%eax
 579:	eb 05                	jmp    580 <compareuser+0x15c>
			}
		}
		printf(1,"Invalid username/password\n");
		if(state != 1)
			break;
	}
 57b:	e9 0f ff ff ff       	jmp    48f <compareuser+0x6b>
	return 0;
}
 580:	8d 65 f8             	lea    -0x8(%ebp),%esp
 583:	5b                   	pop    %ebx
 584:	5e                   	pop    %esi
 585:	5d                   	pop    %ebp
 586:	c3                   	ret    

00000587 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 587:	b8 01 00 00 00       	mov    $0x1,%eax
 58c:	cd 40                	int    $0x40
 58e:	c3                   	ret    

0000058f <exit>:
SYSCALL(exit)
 58f:	b8 02 00 00 00       	mov    $0x2,%eax
 594:	cd 40                	int    $0x40
 596:	c3                   	ret    

00000597 <wait>:
SYSCALL(wait)
 597:	b8 03 00 00 00       	mov    $0x3,%eax
 59c:	cd 40                	int    $0x40
 59e:	c3                   	ret    

0000059f <pipe>:
SYSCALL(pipe)
 59f:	b8 04 00 00 00       	mov    $0x4,%eax
 5a4:	cd 40                	int    $0x40
 5a6:	c3                   	ret    

000005a7 <read>:
SYSCALL(read)
 5a7:	b8 05 00 00 00       	mov    $0x5,%eax
 5ac:	cd 40                	int    $0x40
 5ae:	c3                   	ret    

000005af <write>:
SYSCALL(write)
 5af:	b8 10 00 00 00       	mov    $0x10,%eax
 5b4:	cd 40                	int    $0x40
 5b6:	c3                   	ret    

000005b7 <close>:
SYSCALL(close)
 5b7:	b8 15 00 00 00       	mov    $0x15,%eax
 5bc:	cd 40                	int    $0x40
 5be:	c3                   	ret    

000005bf <kill>:
SYSCALL(kill)
 5bf:	b8 06 00 00 00       	mov    $0x6,%eax
 5c4:	cd 40                	int    $0x40
 5c6:	c3                   	ret    

000005c7 <exec>:
SYSCALL(exec)
 5c7:	b8 07 00 00 00       	mov    $0x7,%eax
 5cc:	cd 40                	int    $0x40
 5ce:	c3                   	ret    

000005cf <open>:
SYSCALL(open)
 5cf:	b8 0f 00 00 00       	mov    $0xf,%eax
 5d4:	cd 40                	int    $0x40
 5d6:	c3                   	ret    

000005d7 <mknod>:
SYSCALL(mknod)
 5d7:	b8 11 00 00 00       	mov    $0x11,%eax
 5dc:	cd 40                	int    $0x40
 5de:	c3                   	ret    

000005df <unlink>:
SYSCALL(unlink)
 5df:	b8 12 00 00 00       	mov    $0x12,%eax
 5e4:	cd 40                	int    $0x40
 5e6:	c3                   	ret    

000005e7 <fstat>:
SYSCALL(fstat)
 5e7:	b8 08 00 00 00       	mov    $0x8,%eax
 5ec:	cd 40                	int    $0x40
 5ee:	c3                   	ret    

000005ef <link>:
SYSCALL(link)
 5ef:	b8 13 00 00 00       	mov    $0x13,%eax
 5f4:	cd 40                	int    $0x40
 5f6:	c3                   	ret    

000005f7 <mkdir>:
SYSCALL(mkdir)
 5f7:	b8 14 00 00 00       	mov    $0x14,%eax
 5fc:	cd 40                	int    $0x40
 5fe:	c3                   	ret    

000005ff <chdir>:
SYSCALL(chdir)
 5ff:	b8 09 00 00 00       	mov    $0x9,%eax
 604:	cd 40                	int    $0x40
 606:	c3                   	ret    

00000607 <dup>:
SYSCALL(dup)
 607:	b8 0a 00 00 00       	mov    $0xa,%eax
 60c:	cd 40                	int    $0x40
 60e:	c3                   	ret    

0000060f <getpid>:
SYSCALL(getpid)
 60f:	b8 0b 00 00 00       	mov    $0xb,%eax
 614:	cd 40                	int    $0x40
 616:	c3                   	ret    

00000617 <sbrk>:
SYSCALL(sbrk)
 617:	b8 0c 00 00 00       	mov    $0xc,%eax
 61c:	cd 40                	int    $0x40
 61e:	c3                   	ret    

0000061f <sleep>:
SYSCALL(sleep)
 61f:	b8 0d 00 00 00       	mov    $0xd,%eax
 624:	cd 40                	int    $0x40
 626:	c3                   	ret    

00000627 <uptime>:
SYSCALL(uptime)
 627:	b8 0e 00 00 00       	mov    $0xe,%eax
 62c:	cd 40                	int    $0x40
 62e:	c3                   	ret    

0000062f <getuser>:
SYSCALL(getuser)
 62f:	b8 16 00 00 00       	mov    $0x16,%eax
 634:	cd 40                	int    $0x40
 636:	c3                   	ret    

00000637 <setuser>:
SYSCALL(setuser)
 637:	b8 17 00 00 00       	mov    $0x17,%eax
 63c:	cd 40                	int    $0x40
 63e:	c3                   	ret    

0000063f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 63f:	55                   	push   %ebp
 640:	89 e5                	mov    %esp,%ebp
 642:	83 ec 18             	sub    $0x18,%esp
 645:	8b 45 0c             	mov    0xc(%ebp),%eax
 648:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 64b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 652:	00 
 653:	8d 45 f4             	lea    -0xc(%ebp),%eax
 656:	89 44 24 04          	mov    %eax,0x4(%esp)
 65a:	8b 45 08             	mov    0x8(%ebp),%eax
 65d:	89 04 24             	mov    %eax,(%esp)
 660:	e8 4a ff ff ff       	call   5af <write>
}
 665:	c9                   	leave  
 666:	c3                   	ret    

00000667 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 667:	55                   	push   %ebp
 668:	89 e5                	mov    %esp,%ebp
 66a:	56                   	push   %esi
 66b:	53                   	push   %ebx
 66c:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 66f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 676:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 67a:	74 17                	je     693 <printint+0x2c>
 67c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 680:	79 11                	jns    693 <printint+0x2c>
    neg = 1;
 682:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 689:	8b 45 0c             	mov    0xc(%ebp),%eax
 68c:	f7 d8                	neg    %eax
 68e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 691:	eb 06                	jmp    699 <printint+0x32>
  } else {
    x = xx;
 693:	8b 45 0c             	mov    0xc(%ebp),%eax
 696:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 699:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6a0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6a3:	8d 41 01             	lea    0x1(%ecx),%eax
 6a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6af:	ba 00 00 00 00       	mov    $0x0,%edx
 6b4:	f7 f3                	div    %ebx
 6b6:	89 d0                	mov    %edx,%eax
 6b8:	0f b6 80 a8 0e 00 00 	movzbl 0xea8(%eax),%eax
 6bf:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6c3:	8b 75 10             	mov    0x10(%ebp),%esi
 6c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6c9:	ba 00 00 00 00       	mov    $0x0,%edx
 6ce:	f7 f6                	div    %esi
 6d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6d7:	75 c7                	jne    6a0 <printint+0x39>
  if(neg)
 6d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6dd:	74 10                	je     6ef <printint+0x88>
    buf[i++] = '-';
 6df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e2:	8d 50 01             	lea    0x1(%eax),%edx
 6e5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6e8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6ed:	eb 1f                	jmp    70e <printint+0xa7>
 6ef:	eb 1d                	jmp    70e <printint+0xa7>
    putc(fd, buf[i]);
 6f1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f7:	01 d0                	add    %edx,%eax
 6f9:	0f b6 00             	movzbl (%eax),%eax
 6fc:	0f be c0             	movsbl %al,%eax
 6ff:	89 44 24 04          	mov    %eax,0x4(%esp)
 703:	8b 45 08             	mov    0x8(%ebp),%eax
 706:	89 04 24             	mov    %eax,(%esp)
 709:	e8 31 ff ff ff       	call   63f <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 70e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 712:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 716:	79 d9                	jns    6f1 <printint+0x8a>
    putc(fd, buf[i]);
}
 718:	83 c4 30             	add    $0x30,%esp
 71b:	5b                   	pop    %ebx
 71c:	5e                   	pop    %esi
 71d:	5d                   	pop    %ebp
 71e:	c3                   	ret    

0000071f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 71f:	55                   	push   %ebp
 720:	89 e5                	mov    %esp,%ebp
 722:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 725:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 72c:	8d 45 0c             	lea    0xc(%ebp),%eax
 72f:	83 c0 04             	add    $0x4,%eax
 732:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 735:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 73c:	e9 7c 01 00 00       	jmp    8bd <printf+0x19e>
    c = fmt[i] & 0xff;
 741:	8b 55 0c             	mov    0xc(%ebp),%edx
 744:	8b 45 f0             	mov    -0x10(%ebp),%eax
 747:	01 d0                	add    %edx,%eax
 749:	0f b6 00             	movzbl (%eax),%eax
 74c:	0f be c0             	movsbl %al,%eax
 74f:	25 ff 00 00 00       	and    $0xff,%eax
 754:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 757:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 75b:	75 2c                	jne    789 <printf+0x6a>
      if(c == '%'){
 75d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 761:	75 0c                	jne    76f <printf+0x50>
        state = '%';
 763:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 76a:	e9 4a 01 00 00       	jmp    8b9 <printf+0x19a>
      } else {
        putc(fd, c);
 76f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 772:	0f be c0             	movsbl %al,%eax
 775:	89 44 24 04          	mov    %eax,0x4(%esp)
 779:	8b 45 08             	mov    0x8(%ebp),%eax
 77c:	89 04 24             	mov    %eax,(%esp)
 77f:	e8 bb fe ff ff       	call   63f <putc>
 784:	e9 30 01 00 00       	jmp    8b9 <printf+0x19a>
      }
    } else if(state == '%'){
 789:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 78d:	0f 85 26 01 00 00    	jne    8b9 <printf+0x19a>
      if(c == 'd'){
 793:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 797:	75 2d                	jne    7c6 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 799:	8b 45 e8             	mov    -0x18(%ebp),%eax
 79c:	8b 00                	mov    (%eax),%eax
 79e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7a5:	00 
 7a6:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7ad:	00 
 7ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 7b2:	8b 45 08             	mov    0x8(%ebp),%eax
 7b5:	89 04 24             	mov    %eax,(%esp)
 7b8:	e8 aa fe ff ff       	call   667 <printint>
        ap++;
 7bd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7c1:	e9 ec 00 00 00       	jmp    8b2 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 7c6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7ca:	74 06                	je     7d2 <printf+0xb3>
 7cc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7d0:	75 2d                	jne    7ff <printf+0xe0>
        printint(fd, *ap, 16, 0);
 7d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7d5:	8b 00                	mov    (%eax),%eax
 7d7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 7de:	00 
 7df:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 7e6:	00 
 7e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 7eb:	8b 45 08             	mov    0x8(%ebp),%eax
 7ee:	89 04 24             	mov    %eax,(%esp)
 7f1:	e8 71 fe ff ff       	call   667 <printint>
        ap++;
 7f6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7fa:	e9 b3 00 00 00       	jmp    8b2 <printf+0x193>
      } else if(c == 's'){
 7ff:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 803:	75 45                	jne    84a <printf+0x12b>
        s = (char*)*ap;
 805:	8b 45 e8             	mov    -0x18(%ebp),%eax
 808:	8b 00                	mov    (%eax),%eax
 80a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 80d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 811:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 815:	75 09                	jne    820 <printf+0x101>
          s = "(null)";
 817:	c7 45 f4 ae 0b 00 00 	movl   $0xbae,-0xc(%ebp)
        while(*s != 0){
 81e:	eb 1e                	jmp    83e <printf+0x11f>
 820:	eb 1c                	jmp    83e <printf+0x11f>
          putc(fd, *s);
 822:	8b 45 f4             	mov    -0xc(%ebp),%eax
 825:	0f b6 00             	movzbl (%eax),%eax
 828:	0f be c0             	movsbl %al,%eax
 82b:	89 44 24 04          	mov    %eax,0x4(%esp)
 82f:	8b 45 08             	mov    0x8(%ebp),%eax
 832:	89 04 24             	mov    %eax,(%esp)
 835:	e8 05 fe ff ff       	call   63f <putc>
          s++;
 83a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 83e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 841:	0f b6 00             	movzbl (%eax),%eax
 844:	84 c0                	test   %al,%al
 846:	75 da                	jne    822 <printf+0x103>
 848:	eb 68                	jmp    8b2 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 84a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 84e:	75 1d                	jne    86d <printf+0x14e>
        putc(fd, *ap);
 850:	8b 45 e8             	mov    -0x18(%ebp),%eax
 853:	8b 00                	mov    (%eax),%eax
 855:	0f be c0             	movsbl %al,%eax
 858:	89 44 24 04          	mov    %eax,0x4(%esp)
 85c:	8b 45 08             	mov    0x8(%ebp),%eax
 85f:	89 04 24             	mov    %eax,(%esp)
 862:	e8 d8 fd ff ff       	call   63f <putc>
        ap++;
 867:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 86b:	eb 45                	jmp    8b2 <printf+0x193>
      } else if(c == '%'){
 86d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 871:	75 17                	jne    88a <printf+0x16b>
        putc(fd, c);
 873:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 876:	0f be c0             	movsbl %al,%eax
 879:	89 44 24 04          	mov    %eax,0x4(%esp)
 87d:	8b 45 08             	mov    0x8(%ebp),%eax
 880:	89 04 24             	mov    %eax,(%esp)
 883:	e8 b7 fd ff ff       	call   63f <putc>
 888:	eb 28                	jmp    8b2 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 88a:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 891:	00 
 892:	8b 45 08             	mov    0x8(%ebp),%eax
 895:	89 04 24             	mov    %eax,(%esp)
 898:	e8 a2 fd ff ff       	call   63f <putc>
        putc(fd, c);
 89d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8a0:	0f be c0             	movsbl %al,%eax
 8a3:	89 44 24 04          	mov    %eax,0x4(%esp)
 8a7:	8b 45 08             	mov    0x8(%ebp),%eax
 8aa:	89 04 24             	mov    %eax,(%esp)
 8ad:	e8 8d fd ff ff       	call   63f <putc>
      }
      state = 0;
 8b2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8b9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8bd:	8b 55 0c             	mov    0xc(%ebp),%edx
 8c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c3:	01 d0                	add    %edx,%eax
 8c5:	0f b6 00             	movzbl (%eax),%eax
 8c8:	84 c0                	test   %al,%al
 8ca:	0f 85 71 fe ff ff    	jne    741 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8d0:	c9                   	leave  
 8d1:	c3                   	ret    

000008d2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8d2:	55                   	push   %ebp
 8d3:	89 e5                	mov    %esp,%ebp
 8d5:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8d8:	8b 45 08             	mov    0x8(%ebp),%eax
 8db:	83 e8 08             	sub    $0x8,%eax
 8de:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e1:	a1 c4 0e 00 00       	mov    0xec4,%eax
 8e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8e9:	eb 24                	jmp    90f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ee:	8b 00                	mov    (%eax),%eax
 8f0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8f3:	77 12                	ja     907 <free+0x35>
 8f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8fb:	77 24                	ja     921 <free+0x4f>
 8fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 900:	8b 00                	mov    (%eax),%eax
 902:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 905:	77 1a                	ja     921 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 907:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90a:	8b 00                	mov    (%eax),%eax
 90c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 90f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 912:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 915:	76 d4                	jbe    8eb <free+0x19>
 917:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91a:	8b 00                	mov    (%eax),%eax
 91c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 91f:	76 ca                	jbe    8eb <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 921:	8b 45 f8             	mov    -0x8(%ebp),%eax
 924:	8b 40 04             	mov    0x4(%eax),%eax
 927:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 92e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 931:	01 c2                	add    %eax,%edx
 933:	8b 45 fc             	mov    -0x4(%ebp),%eax
 936:	8b 00                	mov    (%eax),%eax
 938:	39 c2                	cmp    %eax,%edx
 93a:	75 24                	jne    960 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 93c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93f:	8b 50 04             	mov    0x4(%eax),%edx
 942:	8b 45 fc             	mov    -0x4(%ebp),%eax
 945:	8b 00                	mov    (%eax),%eax
 947:	8b 40 04             	mov    0x4(%eax),%eax
 94a:	01 c2                	add    %eax,%edx
 94c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 952:	8b 45 fc             	mov    -0x4(%ebp),%eax
 955:	8b 00                	mov    (%eax),%eax
 957:	8b 10                	mov    (%eax),%edx
 959:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95c:	89 10                	mov    %edx,(%eax)
 95e:	eb 0a                	jmp    96a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 960:	8b 45 fc             	mov    -0x4(%ebp),%eax
 963:	8b 10                	mov    (%eax),%edx
 965:	8b 45 f8             	mov    -0x8(%ebp),%eax
 968:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 96a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96d:	8b 40 04             	mov    0x4(%eax),%eax
 970:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 977:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97a:	01 d0                	add    %edx,%eax
 97c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 97f:	75 20                	jne    9a1 <free+0xcf>
    p->s.size += bp->s.size;
 981:	8b 45 fc             	mov    -0x4(%ebp),%eax
 984:	8b 50 04             	mov    0x4(%eax),%edx
 987:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98a:	8b 40 04             	mov    0x4(%eax),%eax
 98d:	01 c2                	add    %eax,%edx
 98f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 992:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 995:	8b 45 f8             	mov    -0x8(%ebp),%eax
 998:	8b 10                	mov    (%eax),%edx
 99a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99d:	89 10                	mov    %edx,(%eax)
 99f:	eb 08                	jmp    9a9 <free+0xd7>
  } else
    p->s.ptr = bp;
 9a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9a7:	89 10                	mov    %edx,(%eax)
  freep = p;
 9a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ac:	a3 c4 0e 00 00       	mov    %eax,0xec4
}
 9b1:	c9                   	leave  
 9b2:	c3                   	ret    

000009b3 <morecore>:

static Header*
morecore(uint nu)
{
 9b3:	55                   	push   %ebp
 9b4:	89 e5                	mov    %esp,%ebp
 9b6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9b9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9c0:	77 07                	ja     9c9 <morecore+0x16>
    nu = 4096;
 9c2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9c9:	8b 45 08             	mov    0x8(%ebp),%eax
 9cc:	c1 e0 03             	shl    $0x3,%eax
 9cf:	89 04 24             	mov    %eax,(%esp)
 9d2:	e8 40 fc ff ff       	call   617 <sbrk>
 9d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9da:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9de:	75 07                	jne    9e7 <morecore+0x34>
    return 0;
 9e0:	b8 00 00 00 00       	mov    $0x0,%eax
 9e5:	eb 22                	jmp    a09 <morecore+0x56>
  hp = (Header*)p;
 9e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f0:	8b 55 08             	mov    0x8(%ebp),%edx
 9f3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f9:	83 c0 08             	add    $0x8,%eax
 9fc:	89 04 24             	mov    %eax,(%esp)
 9ff:	e8 ce fe ff ff       	call   8d2 <free>
  return freep;
 a04:	a1 c4 0e 00 00       	mov    0xec4,%eax
}
 a09:	c9                   	leave  
 a0a:	c3                   	ret    

00000a0b <malloc>:

void*
malloc(uint nbytes)
{
 a0b:	55                   	push   %ebp
 a0c:	89 e5                	mov    %esp,%ebp
 a0e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a11:	8b 45 08             	mov    0x8(%ebp),%eax
 a14:	83 c0 07             	add    $0x7,%eax
 a17:	c1 e8 03             	shr    $0x3,%eax
 a1a:	83 c0 01             	add    $0x1,%eax
 a1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a20:	a1 c4 0e 00 00       	mov    0xec4,%eax
 a25:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a2c:	75 23                	jne    a51 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a2e:	c7 45 f0 bc 0e 00 00 	movl   $0xebc,-0x10(%ebp)
 a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a38:	a3 c4 0e 00 00       	mov    %eax,0xec4
 a3d:	a1 c4 0e 00 00       	mov    0xec4,%eax
 a42:	a3 bc 0e 00 00       	mov    %eax,0xebc
    base.s.size = 0;
 a47:	c7 05 c0 0e 00 00 00 	movl   $0x0,0xec0
 a4e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a54:	8b 00                	mov    (%eax),%eax
 a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5c:	8b 40 04             	mov    0x4(%eax),%eax
 a5f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a62:	72 4d                	jb     ab1 <malloc+0xa6>
      if(p->s.size == nunits)
 a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a67:	8b 40 04             	mov    0x4(%eax),%eax
 a6a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a6d:	75 0c                	jne    a7b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a72:	8b 10                	mov    (%eax),%edx
 a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a77:	89 10                	mov    %edx,(%eax)
 a79:	eb 26                	jmp    aa1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7e:	8b 40 04             	mov    0x4(%eax),%eax
 a81:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a84:	89 c2                	mov    %eax,%edx
 a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a89:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8f:	8b 40 04             	mov    0x4(%eax),%eax
 a92:	c1 e0 03             	shl    $0x3,%eax
 a95:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a9e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa4:	a3 c4 0e 00 00       	mov    %eax,0xec4
      return (void*)(p + 1);
 aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aac:	83 c0 08             	add    $0x8,%eax
 aaf:	eb 38                	jmp    ae9 <malloc+0xde>
    }
    if(p == freep)
 ab1:	a1 c4 0e 00 00       	mov    0xec4,%eax
 ab6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 ab9:	75 1b                	jne    ad6 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 abb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 abe:	89 04 24             	mov    %eax,(%esp)
 ac1:	e8 ed fe ff ff       	call   9b3 <morecore>
 ac6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ac9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 acd:	75 07                	jne    ad6 <malloc+0xcb>
        return 0;
 acf:	b8 00 00 00 00       	mov    $0x0,%eax
 ad4:	eb 13                	jmp    ae9 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 adf:	8b 00                	mov    (%eax),%eax
 ae1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ae4:	e9 70 ff ff ff       	jmp    a59 <malloc+0x4e>
}
 ae9:	c9                   	leave  
 aea:	c3                   	ret    
