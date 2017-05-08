
_mkdir:     file format elf32-i386


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
    printf(2, "Usage: mkdir files...\n");
   f:	c7 44 24 04 c6 0a 00 	movl   $0xac6,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 d7 06 00 00       	call   6fa <printf>
    exit();
  23:	e8 42 05 00 00       	call   56a <exit>
  }

  for(i = 1; i < argc; i++){
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 4f                	jmp    81 <main+0x81>
    if(mkdir(argv[i]) < 0){
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 86 05 00 00       	call   5d2 <mkdir>
  4c:	85 c0                	test   %eax,%eax
  4e:	79 2c                	jns    7c <main+0x7c>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  50:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  5e:	01 d0                	add    %edx,%eax
  60:	8b 00                	mov    (%eax),%eax
  62:	89 44 24 08          	mov    %eax,0x8(%esp)
  66:	c7 44 24 04 dd 0a 00 	movl   $0xadd,0x4(%esp)
  6d:	00 
  6e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  75:	e8 80 06 00 00       	call   6fa <printf>
      break;
  7a:	eb 0e                	jmp    8a <main+0x8a>
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  7c:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  81:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  85:	3b 45 08             	cmp    0x8(%ebp),%eax
  88:	7c a8                	jl     32 <main+0x32>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
  8a:	e8 db 04 00 00       	call   56a <exit>

0000008f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  8f:	55                   	push   %ebp
  90:	89 e5                	mov    %esp,%ebp
  92:	57                   	push   %edi
  93:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  97:	8b 55 10             	mov    0x10(%ebp),%edx
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	89 cb                	mov    %ecx,%ebx
  9f:	89 df                	mov    %ebx,%edi
  a1:	89 d1                	mov    %edx,%ecx
  a3:	fc                   	cld    
  a4:	f3 aa                	rep stos %al,%es:(%edi)
  a6:	89 ca                	mov    %ecx,%edx
  a8:	89 fb                	mov    %edi,%ebx
  aa:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ad:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b0:	5b                   	pop    %ebx
  b1:	5f                   	pop    %edi
  b2:	5d                   	pop    %ebp
  b3:	c3                   	ret    

000000b4 <thing>:
#include "user.h"
#include "x86.h"


int
thing(void){
  b4:	55                   	push   %ebp
  b5:	89 e5                	mov    %esp,%ebp
  return 1;
  b7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  bc:	5d                   	pop    %ebp
  bd:	c3                   	ret    

000000be <strcpy>:

char*
strcpy(char *s, char *t)
{
  be:	55                   	push   %ebp
  bf:	89 e5                	mov    %esp,%ebp
  c1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ca:	90                   	nop
  cb:	8b 45 08             	mov    0x8(%ebp),%eax
  ce:	8d 50 01             	lea    0x1(%eax),%edx
  d1:	89 55 08             	mov    %edx,0x8(%ebp)
  d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  d7:	8d 4a 01             	lea    0x1(%edx),%ecx
  da:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  dd:	0f b6 12             	movzbl (%edx),%edx
  e0:	88 10                	mov    %dl,(%eax)
  e2:	0f b6 00             	movzbl (%eax),%eax
  e5:	84 c0                	test   %al,%al
  e7:	75 e2                	jne    cb <strcpy+0xd>
    ;
  return os;
  e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ec:	c9                   	leave  
  ed:	c3                   	ret    

000000ee <strcmp>:



int
strcmp(const char *p, const char *q)
{
  ee:	55                   	push   %ebp
  ef:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  f1:	eb 08                	jmp    fb <strcmp+0xd>
    p++, q++;
  f3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  f7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)


int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  fb:	8b 45 08             	mov    0x8(%ebp),%eax
  fe:	0f b6 00             	movzbl (%eax),%eax
 101:	84 c0                	test   %al,%al
 103:	74 10                	je     115 <strcmp+0x27>
 105:	8b 45 08             	mov    0x8(%ebp),%eax
 108:	0f b6 10             	movzbl (%eax),%edx
 10b:	8b 45 0c             	mov    0xc(%ebp),%eax
 10e:	0f b6 00             	movzbl (%eax),%eax
 111:	38 c2                	cmp    %al,%dl
 113:	74 de                	je     f3 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 115:	8b 45 08             	mov    0x8(%ebp),%eax
 118:	0f b6 00             	movzbl (%eax),%eax
 11b:	0f b6 d0             	movzbl %al,%edx
 11e:	8b 45 0c             	mov    0xc(%ebp),%eax
 121:	0f b6 00             	movzbl (%eax),%eax
 124:	0f b6 c0             	movzbl %al,%eax
 127:	29 c2                	sub    %eax,%edx
 129:	89 d0                	mov    %edx,%eax
}
 12b:	5d                   	pop    %ebp
 12c:	c3                   	ret    

0000012d <strlen>:

uint
strlen(char *s)
{
 12d:	55                   	push   %ebp
 12e:	89 e5                	mov    %esp,%ebp
 130:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 133:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 13a:	eb 04                	jmp    140 <strlen+0x13>
 13c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 140:	8b 55 fc             	mov    -0x4(%ebp),%edx
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	01 d0                	add    %edx,%eax
 148:	0f b6 00             	movzbl (%eax),%eax
 14b:	84 c0                	test   %al,%al
 14d:	75 ed                	jne    13c <strlen+0xf>
    ;
  return n;
 14f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 152:	c9                   	leave  
 153:	c3                   	ret    

00000154 <stringlen>:

uint
stringlen(char **s){
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	83 ec 10             	sub    $0x10,%esp
	int n;

  for(n = 0; s[n]; n++)
 15a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 161:	eb 04                	jmp    167 <stringlen+0x13>
 163:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 167:	8b 45 fc             	mov    -0x4(%ebp),%eax
 16a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 171:	8b 45 08             	mov    0x8(%ebp),%eax
 174:	01 d0                	add    %edx,%eax
 176:	8b 00                	mov    (%eax),%eax
 178:	85 c0                	test   %eax,%eax
 17a:	75 e7                	jne    163 <stringlen+0xf>
    ;
  return n;
 17c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 17f:	c9                   	leave  
 180:	c3                   	ret    

00000181 <memset>:

void*
memset(void *dst, int c, uint n)
{
 181:	55                   	push   %ebp
 182:	89 e5                	mov    %esp,%ebp
 184:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 187:	8b 45 10             	mov    0x10(%ebp),%eax
 18a:	89 44 24 08          	mov    %eax,0x8(%esp)
 18e:	8b 45 0c             	mov    0xc(%ebp),%eax
 191:	89 44 24 04          	mov    %eax,0x4(%esp)
 195:	8b 45 08             	mov    0x8(%ebp),%eax
 198:	89 04 24             	mov    %eax,(%esp)
 19b:	e8 ef fe ff ff       	call   8f <stosb>
  return dst;
 1a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a3:	c9                   	leave  
 1a4:	c3                   	ret    

000001a5 <strchr>:

char*
strchr(const char *s, char c)
{
 1a5:	55                   	push   %ebp
 1a6:	89 e5                	mov    %esp,%ebp
 1a8:	83 ec 04             	sub    $0x4,%esp
 1ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ae:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1b1:	eb 14                	jmp    1c7 <strchr+0x22>
    if(*s == c)
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	0f b6 00             	movzbl (%eax),%eax
 1b9:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1bc:	75 05                	jne    1c3 <strchr+0x1e>
      return (char*)s;
 1be:	8b 45 08             	mov    0x8(%ebp),%eax
 1c1:	eb 13                	jmp    1d6 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1c3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	0f b6 00             	movzbl (%eax),%eax
 1cd:	84 c0                	test   %al,%al
 1cf:	75 e2                	jne    1b3 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1d6:	c9                   	leave  
 1d7:	c3                   	ret    

000001d8 <gets>:

char*
gets(char *buf, int max)
{
 1d8:	55                   	push   %ebp
 1d9:	89 e5                	mov    %esp,%ebp
 1db:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1e5:	eb 4c                	jmp    233 <gets+0x5b>
    cc = read(0, &c, 1);
 1e7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1ee:	00 
 1ef:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1f2:	89 44 24 04          	mov    %eax,0x4(%esp)
 1f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1fd:	e8 80 03 00 00       	call   582 <read>
 202:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 205:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 209:	7f 02                	jg     20d <gets+0x35>
      break;
 20b:	eb 31                	jmp    23e <gets+0x66>
    buf[i++] = c;
 20d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 210:	8d 50 01             	lea    0x1(%eax),%edx
 213:	89 55 f4             	mov    %edx,-0xc(%ebp)
 216:	89 c2                	mov    %eax,%edx
 218:	8b 45 08             	mov    0x8(%ebp),%eax
 21b:	01 c2                	add    %eax,%edx
 21d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 221:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 223:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 227:	3c 0a                	cmp    $0xa,%al
 229:	74 13                	je     23e <gets+0x66>
 22b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 22f:	3c 0d                	cmp    $0xd,%al
 231:	74 0b                	je     23e <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 233:	8b 45 f4             	mov    -0xc(%ebp),%eax
 236:	83 c0 01             	add    $0x1,%eax
 239:	3b 45 0c             	cmp    0xc(%ebp),%eax
 23c:	7c a9                	jl     1e7 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 23e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	01 d0                	add    %edx,%eax
 246:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 249:	8b 45 08             	mov    0x8(%ebp),%eax
}
 24c:	c9                   	leave  
 24d:	c3                   	ret    

0000024e <stat>:

int
stat(char *n, struct stat *st)
{
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
 251:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 254:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 25b:	00 
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	89 04 24             	mov    %eax,(%esp)
 262:	e8 43 03 00 00       	call   5aa <open>
 267:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 26a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 26e:	79 07                	jns    277 <stat+0x29>
    return -1;
 270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 275:	eb 23                	jmp    29a <stat+0x4c>
  r = fstat(fd, st);
 277:	8b 45 0c             	mov    0xc(%ebp),%eax
 27a:	89 44 24 04          	mov    %eax,0x4(%esp)
 27e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 281:	89 04 24             	mov    %eax,(%esp)
 284:	e8 39 03 00 00       	call   5c2 <fstat>
 289:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 28c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 28f:	89 04 24             	mov    %eax,(%esp)
 292:	e8 fb 02 00 00       	call   592 <close>
  return r;
 297:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 29a:	c9                   	leave  
 29b:	c3                   	ret    

0000029c <atoi>:

int
atoi(const char *s)
{
 29c:	55                   	push   %ebp
 29d:	89 e5                	mov    %esp,%ebp
 29f:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2a9:	eb 25                	jmp    2d0 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ae:	89 d0                	mov    %edx,%eax
 2b0:	c1 e0 02             	shl    $0x2,%eax
 2b3:	01 d0                	add    %edx,%eax
 2b5:	01 c0                	add    %eax,%eax
 2b7:	89 c1                	mov    %eax,%ecx
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
 2bc:	8d 50 01             	lea    0x1(%eax),%edx
 2bf:	89 55 08             	mov    %edx,0x8(%ebp)
 2c2:	0f b6 00             	movzbl (%eax),%eax
 2c5:	0f be c0             	movsbl %al,%eax
 2c8:	01 c8                	add    %ecx,%eax
 2ca:	83 e8 30             	sub    $0x30,%eax
 2cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
 2d3:	0f b6 00             	movzbl (%eax),%eax
 2d6:	3c 2f                	cmp    $0x2f,%al
 2d8:	7e 0a                	jle    2e4 <atoi+0x48>
 2da:	8b 45 08             	mov    0x8(%ebp),%eax
 2dd:	0f b6 00             	movzbl (%eax),%eax
 2e0:	3c 39                	cmp    $0x39,%al
 2e2:	7e c7                	jle    2ab <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2e7:	c9                   	leave  
 2e8:	c3                   	ret    

000002e9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2e9:	55                   	push   %ebp
 2ea:	89 e5                	mov    %esp,%ebp
 2ec:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2ef:	8b 45 08             	mov    0x8(%ebp),%eax
 2f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2fb:	eb 17                	jmp    314 <memmove+0x2b>
    *dst++ = *src++;
 2fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 300:	8d 50 01             	lea    0x1(%eax),%edx
 303:	89 55 fc             	mov    %edx,-0x4(%ebp)
 306:	8b 55 f8             	mov    -0x8(%ebp),%edx
 309:	8d 4a 01             	lea    0x1(%edx),%ecx
 30c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 30f:	0f b6 12             	movzbl (%edx),%edx
 312:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 314:	8b 45 10             	mov    0x10(%ebp),%eax
 317:	8d 50 ff             	lea    -0x1(%eax),%edx
 31a:	89 55 10             	mov    %edx,0x10(%ebp)
 31d:	85 c0                	test   %eax,%eax
 31f:	7f dc                	jg     2fd <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 321:	8b 45 08             	mov    0x8(%ebp),%eax
}
 324:	c9                   	leave  
 325:	c3                   	ret    

00000326 <strcmp_c>:


int
strcmp_c(const char *s1, const char *s2)
{
 326:	55                   	push   %ebp
 327:	89 e5                	mov    %esp,%ebp
    for ( ; *s1 == *s2; s1++, s2++)
 329:	eb 19                	jmp    344 <strcmp_c+0x1e>
	if (*s1 == '\0')
 32b:	8b 45 08             	mov    0x8(%ebp),%eax
 32e:	0f b6 00             	movzbl (%eax),%eax
 331:	84 c0                	test   %al,%al
 333:	75 07                	jne    33c <strcmp_c+0x16>
	    return 0;
 335:	b8 00 00 00 00       	mov    $0x0,%eax
 33a:	eb 34                	jmp    370 <strcmp_c+0x4a>


int
strcmp_c(const char *s1, const char *s2)
{
    for ( ; *s1 == *s2; s1++, s2++)
 33c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 340:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	0f b6 10             	movzbl (%eax),%edx
 34a:	8b 45 0c             	mov    0xc(%ebp),%eax
 34d:	0f b6 00             	movzbl (%eax),%eax
 350:	38 c2                	cmp    %al,%dl
 352:	74 d7                	je     32b <strcmp_c+0x5>
	if (*s1 == '\0')
	    return 0;
    return ((*(unsigned char *)s1 < *(unsigned char *)s2) ? -1 : +1);
 354:	8b 45 08             	mov    0x8(%ebp),%eax
 357:	0f b6 10             	movzbl (%eax),%edx
 35a:	8b 45 0c             	mov    0xc(%ebp),%eax
 35d:	0f b6 00             	movzbl (%eax),%eax
 360:	38 c2                	cmp    %al,%dl
 362:	73 07                	jae    36b <strcmp_c+0x45>
 364:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 369:	eb 05                	jmp    370 <strcmp_c+0x4a>
 36b:	b8 01 00 00 00       	mov    $0x1,%eax
}
 370:	5d                   	pop    %ebp
 371:	c3                   	ret    

00000372 <readuser>:


struct USER
readuser(){
 372:	55                   	push   %ebp
 373:	89 e5                	mov    %esp,%ebp
 375:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char buff1[512], buff2[512];
	struct USER u;
	printf(1,"Please enter a username: ");
 37b:	c7 44 24 04 f9 0a 00 	movl   $0xaf9,0x4(%esp)
 382:	00 
 383:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 38a:	e8 6b 03 00 00       	call   6fa <printf>
	u.name = gets(buff1, 50);
 38f:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 396:	00 
 397:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
 39d:	89 04 24             	mov    %eax,(%esp)
 3a0:	e8 33 fe ff ff       	call   1d8 <gets>
 3a5:	89 85 ec fb ff ff    	mov    %eax,-0x414(%ebp)
	printf(1,"Please enter a password: ");
 3ab:	c7 44 24 04 13 0b 00 	movl   $0xb13,0x4(%esp)
 3b2:	00 
 3b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3ba:	e8 3b 03 00 00       	call   6fa <printf>
	u.pass = gets(buff2, 50);
 3bf:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 3c6:	00 
 3c7:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
 3cd:	89 04 24             	mov    %eax,(%esp)
 3d0:	e8 03 fe ff ff       	call   1d8 <gets>
 3d5:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
	return u;
 3db:	8b 45 08             	mov    0x8(%ebp),%eax
 3de:	8b 95 ec fb ff ff    	mov    -0x414(%ebp),%edx
 3e4:	89 10                	mov    %edx,(%eax)
 3e6:	8b 95 f0 fb ff ff    	mov    -0x410(%ebp),%edx
 3ec:	89 50 04             	mov    %edx,0x4(%eax)
 3ef:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
 3f5:	89 50 08             	mov    %edx,0x8(%eax)
}
 3f8:	8b 45 08             	mov    0x8(%ebp),%eax
 3fb:	c9                   	leave  
 3fc:	c2 04 00             	ret    $0x4

000003ff <compareuser>:


int
compareuser(int state){
 3ff:	55                   	push   %ebp
 400:	89 e5                	mov    %esp,%ebp
 402:	56                   	push   %esi
 403:	53                   	push   %ebx
 404:	81 ec 30 01 00 00    	sub    $0x130,%esp
	struct USER u1,u2;
	struct USER users[20];
	u1.name = "john\n";
 40a:	c7 45 e8 2d 0b 00 00 	movl   $0xb2d,-0x18(%ebp)
	u1.pass = "1234\n";
 411:	c7 45 ec 33 0b 00 00 	movl   $0xb33,-0x14(%ebp)
	u1.ulevel = 0;
 418:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	u2.name = "james\n";
 41f:	c7 45 dc 39 0b 00 00 	movl   $0xb39,-0x24(%ebp)
	u2.pass = "pass\n";
 426:	c7 45 e0 40 0b 00 00 	movl   $0xb40,-0x20(%ebp)
	u2.ulevel = 1;
 42d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	users[0] = u1;
 434:	8b 45 e8             	mov    -0x18(%ebp),%eax
 437:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
 43d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 440:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
 446:	8b 45 f0             	mov    -0x10(%ebp),%eax
 449:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
	users[1] = u2;
 44f:	8b 45 dc             	mov    -0x24(%ebp),%eax
 452:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
 458:	8b 45 e0             	mov    -0x20(%ebp),%eax
 45b:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
 461:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 464:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
	
	
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
 46a:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
 470:	89 04 24             	mov    %eax,(%esp)
 473:	e8 fa fe ff ff       	call   372 <readuser>
 478:	83 ec 04             	sub    $0x4,%esp
		
		for(ctr = 0; ctr < 20; ctr++)
 47b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 482:	e9 a4 00 00 00       	jmp    52b <compareuser+0x12c>
		{

			if(strcmp_c(u.name,users[ctr].name) == 0 && strcmp_c(u.pass,users[ctr].pass) == 0)
 487:	8b 55 f4             	mov    -0xc(%ebp),%edx
 48a:	89 d0                	mov    %edx,%eax
 48c:	01 c0                	add    %eax,%eax
 48e:	01 d0                	add    %edx,%eax
 490:	c1 e0 02             	shl    $0x2,%eax
 493:	8d 4d f8             	lea    -0x8(%ebp),%ecx
 496:	01 c8                	add    %ecx,%eax
 498:	2d 0c 01 00 00       	sub    $0x10c,%eax
 49d:	8b 10                	mov    (%eax),%edx
 49f:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
 4a5:	89 54 24 04          	mov    %edx,0x4(%esp)
 4a9:	89 04 24             	mov    %eax,(%esp)
 4ac:	e8 75 fe ff ff       	call   326 <strcmp_c>
 4b1:	85 c0                	test   %eax,%eax
 4b3:	75 72                	jne    527 <compareuser+0x128>
 4b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4b8:	89 d0                	mov    %edx,%eax
 4ba:	01 c0                	add    %eax,%eax
 4bc:	01 d0                	add    %edx,%eax
 4be:	c1 e0 02             	shl    $0x2,%eax
 4c1:	8d 5d f8             	lea    -0x8(%ebp),%ebx
 4c4:	01 d8                	add    %ebx,%eax
 4c6:	2d 08 01 00 00       	sub    $0x108,%eax
 4cb:	8b 10                	mov    (%eax),%edx
 4cd:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
 4d3:	89 54 24 04          	mov    %edx,0x4(%esp)
 4d7:	89 04 24             	mov    %eax,(%esp)
 4da:	e8 47 fe ff ff       	call   326 <strcmp_c>
 4df:	85 c0                	test   %eax,%eax
 4e1:	75 44                	jne    527 <compareuser+0x128>
			{
				setuser(users[ctr].ulevel);
 4e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4e6:	89 d0                	mov    %edx,%eax
 4e8:	01 c0                	add    %eax,%eax
 4ea:	01 d0                	add    %edx,%eax
 4ec:	c1 e0 02             	shl    $0x2,%eax
 4ef:	8d 75 f8             	lea    -0x8(%ebp),%esi
 4f2:	01 f0                	add    %esi,%eax
 4f4:	2d 04 01 00 00       	sub    $0x104,%eax
 4f9:	8b 00                	mov    (%eax),%eax
 4fb:	89 04 24             	mov    %eax,(%esp)
 4fe:	e8 0f 01 00 00       	call   612 <setuser>
				
				printf(1,"%d",getuser());
 503:	e8 02 01 00 00       	call   60a <getuser>
 508:	89 44 24 08          	mov    %eax,0x8(%esp)
 50c:	c7 44 24 04 46 0b 00 	movl   $0xb46,0x4(%esp)
 513:	00 
 514:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 51b:	e8 da 01 00 00       	call   6fa <printf>
				return 1;
 520:	b8 01 00 00 00       	mov    $0x1,%eax
 525:	eb 34                	jmp    55b <compareuser+0x15c>
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
		
		for(ctr = 0; ctr < 20; ctr++)
 527:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 52b:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 52f:	0f 8e 52 ff ff ff    	jle    487 <compareuser+0x88>
				
				printf(1,"%d",getuser());
				return 1;
			}
		}
		printf(1,"Invalid username/password\n");
 535:	c7 44 24 04 49 0b 00 	movl   $0xb49,0x4(%esp)
 53c:	00 
 53d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 544:	e8 b1 01 00 00       	call   6fa <printf>
		if(state != 1)
 549:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 54d:	74 07                	je     556 <compareuser+0x157>
			break;
	}
	return 0;
 54f:	b8 00 00 00 00       	mov    $0x0,%eax
 554:	eb 05                	jmp    55b <compareuser+0x15c>
			}
		}
		printf(1,"Invalid username/password\n");
		if(state != 1)
			break;
	}
 556:	e9 0f ff ff ff       	jmp    46a <compareuser+0x6b>
	return 0;
}
 55b:	8d 65 f8             	lea    -0x8(%ebp),%esp
 55e:	5b                   	pop    %ebx
 55f:	5e                   	pop    %esi
 560:	5d                   	pop    %ebp
 561:	c3                   	ret    

00000562 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 562:	b8 01 00 00 00       	mov    $0x1,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <exit>:
SYSCALL(exit)
 56a:	b8 02 00 00 00       	mov    $0x2,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <wait>:
SYSCALL(wait)
 572:	b8 03 00 00 00       	mov    $0x3,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <pipe>:
SYSCALL(pipe)
 57a:	b8 04 00 00 00       	mov    $0x4,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <read>:
SYSCALL(read)
 582:	b8 05 00 00 00       	mov    $0x5,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <write>:
SYSCALL(write)
 58a:	b8 10 00 00 00       	mov    $0x10,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <close>:
SYSCALL(close)
 592:	b8 15 00 00 00       	mov    $0x15,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <kill>:
SYSCALL(kill)
 59a:	b8 06 00 00 00       	mov    $0x6,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <exec>:
SYSCALL(exec)
 5a2:	b8 07 00 00 00       	mov    $0x7,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <open>:
SYSCALL(open)
 5aa:	b8 0f 00 00 00       	mov    $0xf,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <mknod>:
SYSCALL(mknod)
 5b2:	b8 11 00 00 00       	mov    $0x11,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <unlink>:
SYSCALL(unlink)
 5ba:	b8 12 00 00 00       	mov    $0x12,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <fstat>:
SYSCALL(fstat)
 5c2:	b8 08 00 00 00       	mov    $0x8,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <link>:
SYSCALL(link)
 5ca:	b8 13 00 00 00       	mov    $0x13,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <mkdir>:
SYSCALL(mkdir)
 5d2:	b8 14 00 00 00       	mov    $0x14,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <chdir>:
SYSCALL(chdir)
 5da:	b8 09 00 00 00       	mov    $0x9,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <dup>:
SYSCALL(dup)
 5e2:	b8 0a 00 00 00       	mov    $0xa,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <getpid>:
SYSCALL(getpid)
 5ea:	b8 0b 00 00 00       	mov    $0xb,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <sbrk>:
SYSCALL(sbrk)
 5f2:	b8 0c 00 00 00       	mov    $0xc,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <sleep>:
SYSCALL(sleep)
 5fa:	b8 0d 00 00 00       	mov    $0xd,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <uptime>:
SYSCALL(uptime)
 602:	b8 0e 00 00 00       	mov    $0xe,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <getuser>:
SYSCALL(getuser)
 60a:	b8 16 00 00 00       	mov    $0x16,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <setuser>:
SYSCALL(setuser)
 612:	b8 17 00 00 00       	mov    $0x17,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 61a:	55                   	push   %ebp
 61b:	89 e5                	mov    %esp,%ebp
 61d:	83 ec 18             	sub    $0x18,%esp
 620:	8b 45 0c             	mov    0xc(%ebp),%eax
 623:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 626:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 62d:	00 
 62e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 631:	89 44 24 04          	mov    %eax,0x4(%esp)
 635:	8b 45 08             	mov    0x8(%ebp),%eax
 638:	89 04 24             	mov    %eax,(%esp)
 63b:	e8 4a ff ff ff       	call   58a <write>
}
 640:	c9                   	leave  
 641:	c3                   	ret    

00000642 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 642:	55                   	push   %ebp
 643:	89 e5                	mov    %esp,%ebp
 645:	56                   	push   %esi
 646:	53                   	push   %ebx
 647:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 64a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 651:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 655:	74 17                	je     66e <printint+0x2c>
 657:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 65b:	79 11                	jns    66e <printint+0x2c>
    neg = 1;
 65d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 664:	8b 45 0c             	mov    0xc(%ebp),%eax
 667:	f7 d8                	neg    %eax
 669:	89 45 ec             	mov    %eax,-0x14(%ebp)
 66c:	eb 06                	jmp    674 <printint+0x32>
  } else {
    x = xx;
 66e:	8b 45 0c             	mov    0xc(%ebp),%eax
 671:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 674:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 67b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 67e:	8d 41 01             	lea    0x1(%ecx),%eax
 681:	89 45 f4             	mov    %eax,-0xc(%ebp)
 684:	8b 5d 10             	mov    0x10(%ebp),%ebx
 687:	8b 45 ec             	mov    -0x14(%ebp),%eax
 68a:	ba 00 00 00 00       	mov    $0x0,%edx
 68f:	f7 f3                	div    %ebx
 691:	89 d0                	mov    %edx,%eax
 693:	0f b6 80 5c 0e 00 00 	movzbl 0xe5c(%eax),%eax
 69a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 69e:	8b 75 10             	mov    0x10(%ebp),%esi
 6a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6a4:	ba 00 00 00 00       	mov    $0x0,%edx
 6a9:	f7 f6                	div    %esi
 6ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6b2:	75 c7                	jne    67b <printint+0x39>
  if(neg)
 6b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6b8:	74 10                	je     6ca <printint+0x88>
    buf[i++] = '-';
 6ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6bd:	8d 50 01             	lea    0x1(%eax),%edx
 6c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6c3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6c8:	eb 1f                	jmp    6e9 <printint+0xa7>
 6ca:	eb 1d                	jmp    6e9 <printint+0xa7>
    putc(fd, buf[i]);
 6cc:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d2:	01 d0                	add    %edx,%eax
 6d4:	0f b6 00             	movzbl (%eax),%eax
 6d7:	0f be c0             	movsbl %al,%eax
 6da:	89 44 24 04          	mov    %eax,0x4(%esp)
 6de:	8b 45 08             	mov    0x8(%ebp),%eax
 6e1:	89 04 24             	mov    %eax,(%esp)
 6e4:	e8 31 ff ff ff       	call   61a <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6e9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6f1:	79 d9                	jns    6cc <printint+0x8a>
    putc(fd, buf[i]);
}
 6f3:	83 c4 30             	add    $0x30,%esp
 6f6:	5b                   	pop    %ebx
 6f7:	5e                   	pop    %esi
 6f8:	5d                   	pop    %ebp
 6f9:	c3                   	ret    

000006fa <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6fa:	55                   	push   %ebp
 6fb:	89 e5                	mov    %esp,%ebp
 6fd:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 700:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 707:	8d 45 0c             	lea    0xc(%ebp),%eax
 70a:	83 c0 04             	add    $0x4,%eax
 70d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 710:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 717:	e9 7c 01 00 00       	jmp    898 <printf+0x19e>
    c = fmt[i] & 0xff;
 71c:	8b 55 0c             	mov    0xc(%ebp),%edx
 71f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 722:	01 d0                	add    %edx,%eax
 724:	0f b6 00             	movzbl (%eax),%eax
 727:	0f be c0             	movsbl %al,%eax
 72a:	25 ff 00 00 00       	and    $0xff,%eax
 72f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 732:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 736:	75 2c                	jne    764 <printf+0x6a>
      if(c == '%'){
 738:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 73c:	75 0c                	jne    74a <printf+0x50>
        state = '%';
 73e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 745:	e9 4a 01 00 00       	jmp    894 <printf+0x19a>
      } else {
        putc(fd, c);
 74a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 74d:	0f be c0             	movsbl %al,%eax
 750:	89 44 24 04          	mov    %eax,0x4(%esp)
 754:	8b 45 08             	mov    0x8(%ebp),%eax
 757:	89 04 24             	mov    %eax,(%esp)
 75a:	e8 bb fe ff ff       	call   61a <putc>
 75f:	e9 30 01 00 00       	jmp    894 <printf+0x19a>
      }
    } else if(state == '%'){
 764:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 768:	0f 85 26 01 00 00    	jne    894 <printf+0x19a>
      if(c == 'd'){
 76e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 772:	75 2d                	jne    7a1 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 774:	8b 45 e8             	mov    -0x18(%ebp),%eax
 777:	8b 00                	mov    (%eax),%eax
 779:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 780:	00 
 781:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 788:	00 
 789:	89 44 24 04          	mov    %eax,0x4(%esp)
 78d:	8b 45 08             	mov    0x8(%ebp),%eax
 790:	89 04 24             	mov    %eax,(%esp)
 793:	e8 aa fe ff ff       	call   642 <printint>
        ap++;
 798:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 79c:	e9 ec 00 00 00       	jmp    88d <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 7a1:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7a5:	74 06                	je     7ad <printf+0xb3>
 7a7:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7ab:	75 2d                	jne    7da <printf+0xe0>
        printint(fd, *ap, 16, 0);
 7ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7b0:	8b 00                	mov    (%eax),%eax
 7b2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 7b9:	00 
 7ba:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 7c1:	00 
 7c2:	89 44 24 04          	mov    %eax,0x4(%esp)
 7c6:	8b 45 08             	mov    0x8(%ebp),%eax
 7c9:	89 04 24             	mov    %eax,(%esp)
 7cc:	e8 71 fe ff ff       	call   642 <printint>
        ap++;
 7d1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7d5:	e9 b3 00 00 00       	jmp    88d <printf+0x193>
      } else if(c == 's'){
 7da:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7de:	75 45                	jne    825 <printf+0x12b>
        s = (char*)*ap;
 7e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e3:	8b 00                	mov    (%eax),%eax
 7e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7e8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f0:	75 09                	jne    7fb <printf+0x101>
          s = "(null)";
 7f2:	c7 45 f4 64 0b 00 00 	movl   $0xb64,-0xc(%ebp)
        while(*s != 0){
 7f9:	eb 1e                	jmp    819 <printf+0x11f>
 7fb:	eb 1c                	jmp    819 <printf+0x11f>
          putc(fd, *s);
 7fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 800:	0f b6 00             	movzbl (%eax),%eax
 803:	0f be c0             	movsbl %al,%eax
 806:	89 44 24 04          	mov    %eax,0x4(%esp)
 80a:	8b 45 08             	mov    0x8(%ebp),%eax
 80d:	89 04 24             	mov    %eax,(%esp)
 810:	e8 05 fe ff ff       	call   61a <putc>
          s++;
 815:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 819:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81c:	0f b6 00             	movzbl (%eax),%eax
 81f:	84 c0                	test   %al,%al
 821:	75 da                	jne    7fd <printf+0x103>
 823:	eb 68                	jmp    88d <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 825:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 829:	75 1d                	jne    848 <printf+0x14e>
        putc(fd, *ap);
 82b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 82e:	8b 00                	mov    (%eax),%eax
 830:	0f be c0             	movsbl %al,%eax
 833:	89 44 24 04          	mov    %eax,0x4(%esp)
 837:	8b 45 08             	mov    0x8(%ebp),%eax
 83a:	89 04 24             	mov    %eax,(%esp)
 83d:	e8 d8 fd ff ff       	call   61a <putc>
        ap++;
 842:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 846:	eb 45                	jmp    88d <printf+0x193>
      } else if(c == '%'){
 848:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 84c:	75 17                	jne    865 <printf+0x16b>
        putc(fd, c);
 84e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 851:	0f be c0             	movsbl %al,%eax
 854:	89 44 24 04          	mov    %eax,0x4(%esp)
 858:	8b 45 08             	mov    0x8(%ebp),%eax
 85b:	89 04 24             	mov    %eax,(%esp)
 85e:	e8 b7 fd ff ff       	call   61a <putc>
 863:	eb 28                	jmp    88d <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 865:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 86c:	00 
 86d:	8b 45 08             	mov    0x8(%ebp),%eax
 870:	89 04 24             	mov    %eax,(%esp)
 873:	e8 a2 fd ff ff       	call   61a <putc>
        putc(fd, c);
 878:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 87b:	0f be c0             	movsbl %al,%eax
 87e:	89 44 24 04          	mov    %eax,0x4(%esp)
 882:	8b 45 08             	mov    0x8(%ebp),%eax
 885:	89 04 24             	mov    %eax,(%esp)
 888:	e8 8d fd ff ff       	call   61a <putc>
      }
      state = 0;
 88d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 894:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 898:	8b 55 0c             	mov    0xc(%ebp),%edx
 89b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89e:	01 d0                	add    %edx,%eax
 8a0:	0f b6 00             	movzbl (%eax),%eax
 8a3:	84 c0                	test   %al,%al
 8a5:	0f 85 71 fe ff ff    	jne    71c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8ab:	c9                   	leave  
 8ac:	c3                   	ret    

000008ad <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8ad:	55                   	push   %ebp
 8ae:	89 e5                	mov    %esp,%ebp
 8b0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8b3:	8b 45 08             	mov    0x8(%ebp),%eax
 8b6:	83 e8 08             	sub    $0x8,%eax
 8b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8bc:	a1 78 0e 00 00       	mov    0xe78,%eax
 8c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8c4:	eb 24                	jmp    8ea <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c9:	8b 00                	mov    (%eax),%eax
 8cb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ce:	77 12                	ja     8e2 <free+0x35>
 8d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8d6:	77 24                	ja     8fc <free+0x4f>
 8d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8db:	8b 00                	mov    (%eax),%eax
 8dd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8e0:	77 1a                	ja     8fc <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e5:	8b 00                	mov    (%eax),%eax
 8e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ed:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8f0:	76 d4                	jbe    8c6 <free+0x19>
 8f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f5:	8b 00                	mov    (%eax),%eax
 8f7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8fa:	76 ca                	jbe    8c6 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ff:	8b 40 04             	mov    0x4(%eax),%eax
 902:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 909:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90c:	01 c2                	add    %eax,%edx
 90e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 911:	8b 00                	mov    (%eax),%eax
 913:	39 c2                	cmp    %eax,%edx
 915:	75 24                	jne    93b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 917:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91a:	8b 50 04             	mov    0x4(%eax),%edx
 91d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 920:	8b 00                	mov    (%eax),%eax
 922:	8b 40 04             	mov    0x4(%eax),%eax
 925:	01 c2                	add    %eax,%edx
 927:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 92d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 930:	8b 00                	mov    (%eax),%eax
 932:	8b 10                	mov    (%eax),%edx
 934:	8b 45 f8             	mov    -0x8(%ebp),%eax
 937:	89 10                	mov    %edx,(%eax)
 939:	eb 0a                	jmp    945 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 93b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93e:	8b 10                	mov    (%eax),%edx
 940:	8b 45 f8             	mov    -0x8(%ebp),%eax
 943:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 945:	8b 45 fc             	mov    -0x4(%ebp),%eax
 948:	8b 40 04             	mov    0x4(%eax),%eax
 94b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 952:	8b 45 fc             	mov    -0x4(%ebp),%eax
 955:	01 d0                	add    %edx,%eax
 957:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 95a:	75 20                	jne    97c <free+0xcf>
    p->s.size += bp->s.size;
 95c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95f:	8b 50 04             	mov    0x4(%eax),%edx
 962:	8b 45 f8             	mov    -0x8(%ebp),%eax
 965:	8b 40 04             	mov    0x4(%eax),%eax
 968:	01 c2                	add    %eax,%edx
 96a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 970:	8b 45 f8             	mov    -0x8(%ebp),%eax
 973:	8b 10                	mov    (%eax),%edx
 975:	8b 45 fc             	mov    -0x4(%ebp),%eax
 978:	89 10                	mov    %edx,(%eax)
 97a:	eb 08                	jmp    984 <free+0xd7>
  } else
    p->s.ptr = bp;
 97c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 982:	89 10                	mov    %edx,(%eax)
  freep = p;
 984:	8b 45 fc             	mov    -0x4(%ebp),%eax
 987:	a3 78 0e 00 00       	mov    %eax,0xe78
}
 98c:	c9                   	leave  
 98d:	c3                   	ret    

0000098e <morecore>:

static Header*
morecore(uint nu)
{
 98e:	55                   	push   %ebp
 98f:	89 e5                	mov    %esp,%ebp
 991:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 994:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 99b:	77 07                	ja     9a4 <morecore+0x16>
    nu = 4096;
 99d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9a4:	8b 45 08             	mov    0x8(%ebp),%eax
 9a7:	c1 e0 03             	shl    $0x3,%eax
 9aa:	89 04 24             	mov    %eax,(%esp)
 9ad:	e8 40 fc ff ff       	call   5f2 <sbrk>
 9b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9b5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9b9:	75 07                	jne    9c2 <morecore+0x34>
    return 0;
 9bb:	b8 00 00 00 00       	mov    $0x0,%eax
 9c0:	eb 22                	jmp    9e4 <morecore+0x56>
  hp = (Header*)p;
 9c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9cb:	8b 55 08             	mov    0x8(%ebp),%edx
 9ce:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d4:	83 c0 08             	add    $0x8,%eax
 9d7:	89 04 24             	mov    %eax,(%esp)
 9da:	e8 ce fe ff ff       	call   8ad <free>
  return freep;
 9df:	a1 78 0e 00 00       	mov    0xe78,%eax
}
 9e4:	c9                   	leave  
 9e5:	c3                   	ret    

000009e6 <malloc>:

void*
malloc(uint nbytes)
{
 9e6:	55                   	push   %ebp
 9e7:	89 e5                	mov    %esp,%ebp
 9e9:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9ec:	8b 45 08             	mov    0x8(%ebp),%eax
 9ef:	83 c0 07             	add    $0x7,%eax
 9f2:	c1 e8 03             	shr    $0x3,%eax
 9f5:	83 c0 01             	add    $0x1,%eax
 9f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9fb:	a1 78 0e 00 00       	mov    0xe78,%eax
 a00:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a07:	75 23                	jne    a2c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a09:	c7 45 f0 70 0e 00 00 	movl   $0xe70,-0x10(%ebp)
 a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a13:	a3 78 0e 00 00       	mov    %eax,0xe78
 a18:	a1 78 0e 00 00       	mov    0xe78,%eax
 a1d:	a3 70 0e 00 00       	mov    %eax,0xe70
    base.s.size = 0;
 a22:	c7 05 74 0e 00 00 00 	movl   $0x0,0xe74
 a29:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2f:	8b 00                	mov    (%eax),%eax
 a31:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a37:	8b 40 04             	mov    0x4(%eax),%eax
 a3a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a3d:	72 4d                	jb     a8c <malloc+0xa6>
      if(p->s.size == nunits)
 a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a42:	8b 40 04             	mov    0x4(%eax),%eax
 a45:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a48:	75 0c                	jne    a56 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4d:	8b 10                	mov    (%eax),%edx
 a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a52:	89 10                	mov    %edx,(%eax)
 a54:	eb 26                	jmp    a7c <malloc+0x96>
      else {
        p->s.size -= nunits;
 a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a59:	8b 40 04             	mov    0x4(%eax),%eax
 a5c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a5f:	89 c2                	mov    %eax,%edx
 a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a64:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6a:	8b 40 04             	mov    0x4(%eax),%eax
 a6d:	c1 e0 03             	shl    $0x3,%eax
 a70:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a76:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a79:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a7f:	a3 78 0e 00 00       	mov    %eax,0xe78
      return (void*)(p + 1);
 a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a87:	83 c0 08             	add    $0x8,%eax
 a8a:	eb 38                	jmp    ac4 <malloc+0xde>
    }
    if(p == freep)
 a8c:	a1 78 0e 00 00       	mov    0xe78,%eax
 a91:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a94:	75 1b                	jne    ab1 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 a96:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a99:	89 04 24             	mov    %eax,(%esp)
 a9c:	e8 ed fe ff ff       	call   98e <morecore>
 aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 aa4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 aa8:	75 07                	jne    ab1 <malloc+0xcb>
        return 0;
 aaa:	b8 00 00 00 00       	mov    $0x0,%eax
 aaf:	eb 13                	jmp    ac4 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aba:	8b 00                	mov    (%eax),%eax
 abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 abf:	e9 70 ff ff ff       	jmp    a34 <malloc+0x4e>
}
 ac4:	c9                   	leave  
 ac5:	c3                   	ret    
