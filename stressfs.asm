
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	81 ec 30 02 00 00    	sub    $0x230,%esp
  int fd, i;
  char path[] = "stressfs0";
   c:	c7 84 24 1e 02 00 00 	movl   $0x65727473,0x21e(%esp)
  13:	73 74 72 65 
  17:	c7 84 24 22 02 00 00 	movl   $0x73667373,0x222(%esp)
  1e:	73 73 66 73 
  22:	66 c7 84 24 26 02 00 	movw   $0x30,0x226(%esp)
  29:	00 30 00 
  char data[512];

  printf(1, "stressfs starting\n");
  2c:	c7 44 24 04 ea 0b 00 	movl   $0xbea,0x4(%esp)
  33:	00 
  34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3b:	e8 de 07 00 00       	call   81e <printf>
  memset(data, 'a', sizeof(data));
  40:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  47:	00 
  48:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  4f:	00 
  50:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 49 02 00 00       	call   2a5 <memset>

  for(i = 0; i < 4; i++)
  5c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  63:	00 00 00 00 
  67:	eb 13                	jmp    7c <main+0x7c>
    if(fork() > 0)
  69:	e8 18 06 00 00       	call   686 <fork>
  6e:	85 c0                	test   %eax,%eax
  70:	7e 02                	jle    74 <main+0x74>
      break;
  72:	eb 12                	jmp    86 <main+0x86>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  74:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
  7b:	01 
  7c:	83 bc 24 2c 02 00 00 	cmpl   $0x3,0x22c(%esp)
  83:	03 
  84:	7e e3                	jle    69 <main+0x69>
    if(fork() > 0)
      break;

  printf(1, "write %d\n", i);
  86:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  8d:	89 44 24 08          	mov    %eax,0x8(%esp)
  91:	c7 44 24 04 fd 0b 00 	movl   $0xbfd,0x4(%esp)
  98:	00 
  99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a0:	e8 79 07 00 00       	call   81e <printf>

  path[8] += i;
  a5:	0f b6 84 24 26 02 00 	movzbl 0x226(%esp),%eax
  ac:	00 
  ad:	89 c2                	mov    %eax,%edx
  af:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  b6:	01 d0                	add    %edx,%eax
  b8:	88 84 24 26 02 00 00 	mov    %al,0x226(%esp)
  fd = open(path, O_CREATE | O_RDWR);
  bf:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  c6:	00 
  c7:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
  ce:	89 04 24             	mov    %eax,(%esp)
  d1:	e8 f8 05 00 00       	call   6ce <open>
  d6:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for(i = 0; i < 20; i++)
  dd:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  e4:	00 00 00 00 
  e8:	eb 27                	jmp    111 <main+0x111>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  ea:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  f1:	00 
  f2:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  fa:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 101:	89 04 24             	mov    %eax,(%esp)
 104:	e8 a5 05 00 00       	call   6ae <write>

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
 109:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 110:	01 
 111:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 118:	13 
 119:	7e cf                	jle    ea <main+0xea>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
 11b:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 122:	89 04 24             	mov    %eax,(%esp)
 125:	e8 8c 05 00 00       	call   6b6 <close>

  printf(1, "read\n");
 12a:	c7 44 24 04 07 0c 00 	movl   $0xc07,0x4(%esp)
 131:	00 
 132:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 139:	e8 e0 06 00 00       	call   81e <printf>

  fd = open(path, O_RDONLY);
 13e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 145:	00 
 146:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
 14d:	89 04 24             	mov    %eax,(%esp)
 150:	e8 79 05 00 00       	call   6ce <open>
 155:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for (i = 0; i < 20; i++)
 15c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
 163:	00 00 00 00 
 167:	eb 27                	jmp    190 <main+0x190>
    read(fd, data, sizeof(data));
 169:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 170:	00 
 171:	8d 44 24 1e          	lea    0x1e(%esp),%eax
 175:	89 44 24 04          	mov    %eax,0x4(%esp)
 179:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 180:	89 04 24             	mov    %eax,(%esp)
 183:	e8 1e 05 00 00       	call   6a6 <read>
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 188:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 18f:	01 
 190:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 197:	13 
 198:	7e cf                	jle    169 <main+0x169>
    read(fd, data, sizeof(data));
  close(fd);
 19a:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 1a1:	89 04 24             	mov    %eax,(%esp)
 1a4:	e8 0d 05 00 00       	call   6b6 <close>

  wait();
 1a9:	e8 e8 04 00 00       	call   696 <wait>
  
  exit();
 1ae:	e8 db 04 00 00       	call   68e <exit>

000001b3 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1b3:	55                   	push   %ebp
 1b4:	89 e5                	mov    %esp,%ebp
 1b6:	57                   	push   %edi
 1b7:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1bb:	8b 55 10             	mov    0x10(%ebp),%edx
 1be:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c1:	89 cb                	mov    %ecx,%ebx
 1c3:	89 df                	mov    %ebx,%edi
 1c5:	89 d1                	mov    %edx,%ecx
 1c7:	fc                   	cld    
 1c8:	f3 aa                	rep stos %al,%es:(%edi)
 1ca:	89 ca                	mov    %ecx,%edx
 1cc:	89 fb                	mov    %edi,%ebx
 1ce:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1d1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1d4:	5b                   	pop    %ebx
 1d5:	5f                   	pop    %edi
 1d6:	5d                   	pop    %ebp
 1d7:	c3                   	ret    

000001d8 <thing>:
#include "user.h"
#include "x86.h"


int
thing(void){
 1d8:	55                   	push   %ebp
 1d9:	89 e5                	mov    %esp,%ebp
  return 1;
 1db:	b8 01 00 00 00       	mov    $0x1,%eax
}
 1e0:	5d                   	pop    %ebp
 1e1:	c3                   	ret    

000001e2 <strcpy>:

char*
strcpy(char *s, char *t)
{
 1e2:	55                   	push   %ebp
 1e3:	89 e5                	mov    %esp,%ebp
 1e5:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1e8:	8b 45 08             	mov    0x8(%ebp),%eax
 1eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1ee:	90                   	nop
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
 1f2:	8d 50 01             	lea    0x1(%eax),%edx
 1f5:	89 55 08             	mov    %edx,0x8(%ebp)
 1f8:	8b 55 0c             	mov    0xc(%ebp),%edx
 1fb:	8d 4a 01             	lea    0x1(%edx),%ecx
 1fe:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 201:	0f b6 12             	movzbl (%edx),%edx
 204:	88 10                	mov    %dl,(%eax)
 206:	0f b6 00             	movzbl (%eax),%eax
 209:	84 c0                	test   %al,%al
 20b:	75 e2                	jne    1ef <strcpy+0xd>
    ;
  return os;
 20d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 210:	c9                   	leave  
 211:	c3                   	ret    

00000212 <strcmp>:



int
strcmp(const char *p, const char *q)
{
 212:	55                   	push   %ebp
 213:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 215:	eb 08                	jmp    21f <strcmp+0xd>
    p++, q++;
 217:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)


int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	0f b6 00             	movzbl (%eax),%eax
 225:	84 c0                	test   %al,%al
 227:	74 10                	je     239 <strcmp+0x27>
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	0f b6 10             	movzbl (%eax),%edx
 22f:	8b 45 0c             	mov    0xc(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	38 c2                	cmp    %al,%dl
 237:	74 de                	je     217 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 239:	8b 45 08             	mov    0x8(%ebp),%eax
 23c:	0f b6 00             	movzbl (%eax),%eax
 23f:	0f b6 d0             	movzbl %al,%edx
 242:	8b 45 0c             	mov    0xc(%ebp),%eax
 245:	0f b6 00             	movzbl (%eax),%eax
 248:	0f b6 c0             	movzbl %al,%eax
 24b:	29 c2                	sub    %eax,%edx
 24d:	89 d0                	mov    %edx,%eax
}
 24f:	5d                   	pop    %ebp
 250:	c3                   	ret    

00000251 <strlen>:

uint
strlen(char *s)
{
 251:	55                   	push   %ebp
 252:	89 e5                	mov    %esp,%ebp
 254:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 257:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25e:	eb 04                	jmp    264 <strlen+0x13>
 260:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 264:	8b 55 fc             	mov    -0x4(%ebp),%edx
 267:	8b 45 08             	mov    0x8(%ebp),%eax
 26a:	01 d0                	add    %edx,%eax
 26c:	0f b6 00             	movzbl (%eax),%eax
 26f:	84 c0                	test   %al,%al
 271:	75 ed                	jne    260 <strlen+0xf>
    ;
  return n;
 273:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 276:	c9                   	leave  
 277:	c3                   	ret    

00000278 <stringlen>:

uint
stringlen(char **s){
 278:	55                   	push   %ebp
 279:	89 e5                	mov    %esp,%ebp
 27b:	83 ec 10             	sub    $0x10,%esp
	int n;

  for(n = 0; s[n]; n++)
 27e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 285:	eb 04                	jmp    28b <stringlen+0x13>
 287:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 28b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 28e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	01 d0                	add    %edx,%eax
 29a:	8b 00                	mov    (%eax),%eax
 29c:	85 c0                	test   %eax,%eax
 29e:	75 e7                	jne    287 <stringlen+0xf>
    ;
  return n;
 2a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a3:	c9                   	leave  
 2a4:	c3                   	ret    

000002a5 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2a5:	55                   	push   %ebp
 2a6:	89 e5                	mov    %esp,%ebp
 2a8:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2ab:	8b 45 10             	mov    0x10(%ebp),%eax
 2ae:	89 44 24 08          	mov    %eax,0x8(%esp)
 2b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
 2bc:	89 04 24             	mov    %eax,(%esp)
 2bf:	e8 ef fe ff ff       	call   1b3 <stosb>
  return dst;
 2c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c7:	c9                   	leave  
 2c8:	c3                   	ret    

000002c9 <strchr>:

char*
strchr(const char *s, char c)
{
 2c9:	55                   	push   %ebp
 2ca:	89 e5                	mov    %esp,%ebp
 2cc:	83 ec 04             	sub    $0x4,%esp
 2cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d2:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2d5:	eb 14                	jmp    2eb <strchr+0x22>
    if(*s == c)
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
 2da:	0f b6 00             	movzbl (%eax),%eax
 2dd:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2e0:	75 05                	jne    2e7 <strchr+0x1e>
      return (char*)s;
 2e2:	8b 45 08             	mov    0x8(%ebp),%eax
 2e5:	eb 13                	jmp    2fa <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2e7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2eb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ee:	0f b6 00             	movzbl (%eax),%eax
 2f1:	84 c0                	test   %al,%al
 2f3:	75 e2                	jne    2d7 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2fa:	c9                   	leave  
 2fb:	c3                   	ret    

000002fc <gets>:

char*
gets(char *buf, int max)
{
 2fc:	55                   	push   %ebp
 2fd:	89 e5                	mov    %esp,%ebp
 2ff:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 302:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 309:	eb 4c                	jmp    357 <gets+0x5b>
    cc = read(0, &c, 1);
 30b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 312:	00 
 313:	8d 45 ef             	lea    -0x11(%ebp),%eax
 316:	89 44 24 04          	mov    %eax,0x4(%esp)
 31a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 321:	e8 80 03 00 00       	call   6a6 <read>
 326:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 329:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 32d:	7f 02                	jg     331 <gets+0x35>
      break;
 32f:	eb 31                	jmp    362 <gets+0x66>
    buf[i++] = c;
 331:	8b 45 f4             	mov    -0xc(%ebp),%eax
 334:	8d 50 01             	lea    0x1(%eax),%edx
 337:	89 55 f4             	mov    %edx,-0xc(%ebp)
 33a:	89 c2                	mov    %eax,%edx
 33c:	8b 45 08             	mov    0x8(%ebp),%eax
 33f:	01 c2                	add    %eax,%edx
 341:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 345:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 347:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 34b:	3c 0a                	cmp    $0xa,%al
 34d:	74 13                	je     362 <gets+0x66>
 34f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 353:	3c 0d                	cmp    $0xd,%al
 355:	74 0b                	je     362 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 357:	8b 45 f4             	mov    -0xc(%ebp),%eax
 35a:	83 c0 01             	add    $0x1,%eax
 35d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 360:	7c a9                	jl     30b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 362:	8b 55 f4             	mov    -0xc(%ebp),%edx
 365:	8b 45 08             	mov    0x8(%ebp),%eax
 368:	01 d0                	add    %edx,%eax
 36a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 36d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 370:	c9                   	leave  
 371:	c3                   	ret    

00000372 <stat>:

int
stat(char *n, struct stat *st)
{
 372:	55                   	push   %ebp
 373:	89 e5                	mov    %esp,%ebp
 375:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 378:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 37f:	00 
 380:	8b 45 08             	mov    0x8(%ebp),%eax
 383:	89 04 24             	mov    %eax,(%esp)
 386:	e8 43 03 00 00       	call   6ce <open>
 38b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 38e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 392:	79 07                	jns    39b <stat+0x29>
    return -1;
 394:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 399:	eb 23                	jmp    3be <stat+0x4c>
  r = fstat(fd, st);
 39b:	8b 45 0c             	mov    0xc(%ebp),%eax
 39e:	89 44 24 04          	mov    %eax,0x4(%esp)
 3a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3a5:	89 04 24             	mov    %eax,(%esp)
 3a8:	e8 39 03 00 00       	call   6e6 <fstat>
 3ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3b3:	89 04 24             	mov    %eax,(%esp)
 3b6:	e8 fb 02 00 00       	call   6b6 <close>
  return r;
 3bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3be:	c9                   	leave  
 3bf:	c3                   	ret    

000003c0 <atoi>:

int
atoi(const char *s)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3cd:	eb 25                	jmp    3f4 <atoi+0x34>
    n = n*10 + *s++ - '0';
 3cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3d2:	89 d0                	mov    %edx,%eax
 3d4:	c1 e0 02             	shl    $0x2,%eax
 3d7:	01 d0                	add    %edx,%eax
 3d9:	01 c0                	add    %eax,%eax
 3db:	89 c1                	mov    %eax,%ecx
 3dd:	8b 45 08             	mov    0x8(%ebp),%eax
 3e0:	8d 50 01             	lea    0x1(%eax),%edx
 3e3:	89 55 08             	mov    %edx,0x8(%ebp)
 3e6:	0f b6 00             	movzbl (%eax),%eax
 3e9:	0f be c0             	movsbl %al,%eax
 3ec:	01 c8                	add    %ecx,%eax
 3ee:	83 e8 30             	sub    $0x30,%eax
 3f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3f4:	8b 45 08             	mov    0x8(%ebp),%eax
 3f7:	0f b6 00             	movzbl (%eax),%eax
 3fa:	3c 2f                	cmp    $0x2f,%al
 3fc:	7e 0a                	jle    408 <atoi+0x48>
 3fe:	8b 45 08             	mov    0x8(%ebp),%eax
 401:	0f b6 00             	movzbl (%eax),%eax
 404:	3c 39                	cmp    $0x39,%al
 406:	7e c7                	jle    3cf <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 408:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 40b:	c9                   	leave  
 40c:	c3                   	ret    

0000040d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 40d:	55                   	push   %ebp
 40e:	89 e5                	mov    %esp,%ebp
 410:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 413:	8b 45 08             	mov    0x8(%ebp),%eax
 416:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 419:	8b 45 0c             	mov    0xc(%ebp),%eax
 41c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 41f:	eb 17                	jmp    438 <memmove+0x2b>
    *dst++ = *src++;
 421:	8b 45 fc             	mov    -0x4(%ebp),%eax
 424:	8d 50 01             	lea    0x1(%eax),%edx
 427:	89 55 fc             	mov    %edx,-0x4(%ebp)
 42a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 42d:	8d 4a 01             	lea    0x1(%edx),%ecx
 430:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 433:	0f b6 12             	movzbl (%edx),%edx
 436:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 438:	8b 45 10             	mov    0x10(%ebp),%eax
 43b:	8d 50 ff             	lea    -0x1(%eax),%edx
 43e:	89 55 10             	mov    %edx,0x10(%ebp)
 441:	85 c0                	test   %eax,%eax
 443:	7f dc                	jg     421 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 445:	8b 45 08             	mov    0x8(%ebp),%eax
}
 448:	c9                   	leave  
 449:	c3                   	ret    

0000044a <strcmp_c>:


int
strcmp_c(const char *s1, const char *s2)
{
 44a:	55                   	push   %ebp
 44b:	89 e5                	mov    %esp,%ebp
    for ( ; *s1 == *s2; s1++, s2++)
 44d:	eb 19                	jmp    468 <strcmp_c+0x1e>
	if (*s1 == '\0')
 44f:	8b 45 08             	mov    0x8(%ebp),%eax
 452:	0f b6 00             	movzbl (%eax),%eax
 455:	84 c0                	test   %al,%al
 457:	75 07                	jne    460 <strcmp_c+0x16>
	    return 0;
 459:	b8 00 00 00 00       	mov    $0x0,%eax
 45e:	eb 34                	jmp    494 <strcmp_c+0x4a>


int
strcmp_c(const char *s1, const char *s2)
{
    for ( ; *s1 == *s2; s1++, s2++)
 460:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 464:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 468:	8b 45 08             	mov    0x8(%ebp),%eax
 46b:	0f b6 10             	movzbl (%eax),%edx
 46e:	8b 45 0c             	mov    0xc(%ebp),%eax
 471:	0f b6 00             	movzbl (%eax),%eax
 474:	38 c2                	cmp    %al,%dl
 476:	74 d7                	je     44f <strcmp_c+0x5>
	if (*s1 == '\0')
	    return 0;
    return ((*(unsigned char *)s1 < *(unsigned char *)s2) ? -1 : +1);
 478:	8b 45 08             	mov    0x8(%ebp),%eax
 47b:	0f b6 10             	movzbl (%eax),%edx
 47e:	8b 45 0c             	mov    0xc(%ebp),%eax
 481:	0f b6 00             	movzbl (%eax),%eax
 484:	38 c2                	cmp    %al,%dl
 486:	73 07                	jae    48f <strcmp_c+0x45>
 488:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 48d:	eb 05                	jmp    494 <strcmp_c+0x4a>
 48f:	b8 01 00 00 00       	mov    $0x1,%eax
}
 494:	5d                   	pop    %ebp
 495:	c3                   	ret    

00000496 <readuser>:


struct USER
readuser(){
 496:	55                   	push   %ebp
 497:	89 e5                	mov    %esp,%ebp
 499:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char buff1[512], buff2[512];
	struct USER u;
	printf(1,"Please enter a username: ");
 49f:	c7 44 24 04 0d 0c 00 	movl   $0xc0d,0x4(%esp)
 4a6:	00 
 4a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4ae:	e8 6b 03 00 00       	call   81e <printf>
	u.name = gets(buff1, 50);
 4b3:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 4ba:	00 
 4bb:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
 4c1:	89 04 24             	mov    %eax,(%esp)
 4c4:	e8 33 fe ff ff       	call   2fc <gets>
 4c9:	89 85 ec fb ff ff    	mov    %eax,-0x414(%ebp)
	printf(1,"Please enter a password: ");
 4cf:	c7 44 24 04 27 0c 00 	movl   $0xc27,0x4(%esp)
 4d6:	00 
 4d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4de:	e8 3b 03 00 00       	call   81e <printf>
	u.pass = gets(buff2, 50);
 4e3:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 4ea:	00 
 4eb:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
 4f1:	89 04 24             	mov    %eax,(%esp)
 4f4:	e8 03 fe ff ff       	call   2fc <gets>
 4f9:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
	return u;
 4ff:	8b 45 08             	mov    0x8(%ebp),%eax
 502:	8b 95 ec fb ff ff    	mov    -0x414(%ebp),%edx
 508:	89 10                	mov    %edx,(%eax)
 50a:	8b 95 f0 fb ff ff    	mov    -0x410(%ebp),%edx
 510:	89 50 04             	mov    %edx,0x4(%eax)
 513:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
 519:	89 50 08             	mov    %edx,0x8(%eax)
}
 51c:	8b 45 08             	mov    0x8(%ebp),%eax
 51f:	c9                   	leave  
 520:	c2 04 00             	ret    $0x4

00000523 <compareuser>:


int
compareuser(int state){
 523:	55                   	push   %ebp
 524:	89 e5                	mov    %esp,%ebp
 526:	56                   	push   %esi
 527:	53                   	push   %ebx
 528:	81 ec 30 01 00 00    	sub    $0x130,%esp
	struct USER u1,u2;
	struct USER users[20];
	u1.name = "john\n";
 52e:	c7 45 e8 41 0c 00 00 	movl   $0xc41,-0x18(%ebp)
	u1.pass = "1234\n";
 535:	c7 45 ec 47 0c 00 00 	movl   $0xc47,-0x14(%ebp)
	u1.ulevel = 0;
 53c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	u2.name = "james\n";
 543:	c7 45 dc 4d 0c 00 00 	movl   $0xc4d,-0x24(%ebp)
	u2.pass = "pass\n";
 54a:	c7 45 e0 54 0c 00 00 	movl   $0xc54,-0x20(%ebp)
	u2.ulevel = 1;
 551:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	users[0] = u1;
 558:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55b:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
 561:	8b 45 ec             	mov    -0x14(%ebp),%eax
 564:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
 56a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 56d:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
	users[1] = u2;
 573:	8b 45 dc             	mov    -0x24(%ebp),%eax
 576:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
 57c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 57f:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
 585:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 588:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
	
	
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
 58e:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
 594:	89 04 24             	mov    %eax,(%esp)
 597:	e8 fa fe ff ff       	call   496 <readuser>
 59c:	83 ec 04             	sub    $0x4,%esp
		
		for(ctr = 0; ctr < 20; ctr++)
 59f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 5a6:	e9 a4 00 00 00       	jmp    64f <compareuser+0x12c>
		{

			if(strcmp_c(u.name,users[ctr].name) == 0 && strcmp_c(u.pass,users[ctr].pass) == 0)
 5ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
 5ae:	89 d0                	mov    %edx,%eax
 5b0:	01 c0                	add    %eax,%eax
 5b2:	01 d0                	add    %edx,%eax
 5b4:	c1 e0 02             	shl    $0x2,%eax
 5b7:	8d 4d f8             	lea    -0x8(%ebp),%ecx
 5ba:	01 c8                	add    %ecx,%eax
 5bc:	2d 0c 01 00 00       	sub    $0x10c,%eax
 5c1:	8b 10                	mov    (%eax),%edx
 5c3:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
 5c9:	89 54 24 04          	mov    %edx,0x4(%esp)
 5cd:	89 04 24             	mov    %eax,(%esp)
 5d0:	e8 75 fe ff ff       	call   44a <strcmp_c>
 5d5:	85 c0                	test   %eax,%eax
 5d7:	75 72                	jne    64b <compareuser+0x128>
 5d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 5dc:	89 d0                	mov    %edx,%eax
 5de:	01 c0                	add    %eax,%eax
 5e0:	01 d0                	add    %edx,%eax
 5e2:	c1 e0 02             	shl    $0x2,%eax
 5e5:	8d 5d f8             	lea    -0x8(%ebp),%ebx
 5e8:	01 d8                	add    %ebx,%eax
 5ea:	2d 08 01 00 00       	sub    $0x108,%eax
 5ef:	8b 10                	mov    (%eax),%edx
 5f1:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
 5f7:	89 54 24 04          	mov    %edx,0x4(%esp)
 5fb:	89 04 24             	mov    %eax,(%esp)
 5fe:	e8 47 fe ff ff       	call   44a <strcmp_c>
 603:	85 c0                	test   %eax,%eax
 605:	75 44                	jne    64b <compareuser+0x128>
			{
				setuser(users[ctr].ulevel);
 607:	8b 55 f4             	mov    -0xc(%ebp),%edx
 60a:	89 d0                	mov    %edx,%eax
 60c:	01 c0                	add    %eax,%eax
 60e:	01 d0                	add    %edx,%eax
 610:	c1 e0 02             	shl    $0x2,%eax
 613:	8d 75 f8             	lea    -0x8(%ebp),%esi
 616:	01 f0                	add    %esi,%eax
 618:	2d 04 01 00 00       	sub    $0x104,%eax
 61d:	8b 00                	mov    (%eax),%eax
 61f:	89 04 24             	mov    %eax,(%esp)
 622:	e8 0f 01 00 00       	call   736 <setuser>
				
				printf(1,"%d",getuser());
 627:	e8 02 01 00 00       	call   72e <getuser>
 62c:	89 44 24 08          	mov    %eax,0x8(%esp)
 630:	c7 44 24 04 5a 0c 00 	movl   $0xc5a,0x4(%esp)
 637:	00 
 638:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 63f:	e8 da 01 00 00       	call   81e <printf>
				return 1;
 644:	b8 01 00 00 00       	mov    $0x1,%eax
 649:	eb 34                	jmp    67f <compareuser+0x15c>
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
		
		for(ctr = 0; ctr < 20; ctr++)
 64b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 64f:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 653:	0f 8e 52 ff ff ff    	jle    5ab <compareuser+0x88>
				
				printf(1,"%d",getuser());
				return 1;
			}
		}
		printf(1,"Invalid username/password\n");
 659:	c7 44 24 04 5d 0c 00 	movl   $0xc5d,0x4(%esp)
 660:	00 
 661:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 668:	e8 b1 01 00 00       	call   81e <printf>
		if(state != 1)
 66d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 671:	74 07                	je     67a <compareuser+0x157>
			break;
	}
	return 0;
 673:	b8 00 00 00 00       	mov    $0x0,%eax
 678:	eb 05                	jmp    67f <compareuser+0x15c>
			}
		}
		printf(1,"Invalid username/password\n");
		if(state != 1)
			break;
	}
 67a:	e9 0f ff ff ff       	jmp    58e <compareuser+0x6b>
	return 0;
}
 67f:	8d 65 f8             	lea    -0x8(%ebp),%esp
 682:	5b                   	pop    %ebx
 683:	5e                   	pop    %esi
 684:	5d                   	pop    %ebp
 685:	c3                   	ret    

00000686 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 686:	b8 01 00 00 00       	mov    $0x1,%eax
 68b:	cd 40                	int    $0x40
 68d:	c3                   	ret    

0000068e <exit>:
SYSCALL(exit)
 68e:	b8 02 00 00 00       	mov    $0x2,%eax
 693:	cd 40                	int    $0x40
 695:	c3                   	ret    

00000696 <wait>:
SYSCALL(wait)
 696:	b8 03 00 00 00       	mov    $0x3,%eax
 69b:	cd 40                	int    $0x40
 69d:	c3                   	ret    

0000069e <pipe>:
SYSCALL(pipe)
 69e:	b8 04 00 00 00       	mov    $0x4,%eax
 6a3:	cd 40                	int    $0x40
 6a5:	c3                   	ret    

000006a6 <read>:
SYSCALL(read)
 6a6:	b8 05 00 00 00       	mov    $0x5,%eax
 6ab:	cd 40                	int    $0x40
 6ad:	c3                   	ret    

000006ae <write>:
SYSCALL(write)
 6ae:	b8 10 00 00 00       	mov    $0x10,%eax
 6b3:	cd 40                	int    $0x40
 6b5:	c3                   	ret    

000006b6 <close>:
SYSCALL(close)
 6b6:	b8 15 00 00 00       	mov    $0x15,%eax
 6bb:	cd 40                	int    $0x40
 6bd:	c3                   	ret    

000006be <kill>:
SYSCALL(kill)
 6be:	b8 06 00 00 00       	mov    $0x6,%eax
 6c3:	cd 40                	int    $0x40
 6c5:	c3                   	ret    

000006c6 <exec>:
SYSCALL(exec)
 6c6:	b8 07 00 00 00       	mov    $0x7,%eax
 6cb:	cd 40                	int    $0x40
 6cd:	c3                   	ret    

000006ce <open>:
SYSCALL(open)
 6ce:	b8 0f 00 00 00       	mov    $0xf,%eax
 6d3:	cd 40                	int    $0x40
 6d5:	c3                   	ret    

000006d6 <mknod>:
SYSCALL(mknod)
 6d6:	b8 11 00 00 00       	mov    $0x11,%eax
 6db:	cd 40                	int    $0x40
 6dd:	c3                   	ret    

000006de <unlink>:
SYSCALL(unlink)
 6de:	b8 12 00 00 00       	mov    $0x12,%eax
 6e3:	cd 40                	int    $0x40
 6e5:	c3                   	ret    

000006e6 <fstat>:
SYSCALL(fstat)
 6e6:	b8 08 00 00 00       	mov    $0x8,%eax
 6eb:	cd 40                	int    $0x40
 6ed:	c3                   	ret    

000006ee <link>:
SYSCALL(link)
 6ee:	b8 13 00 00 00       	mov    $0x13,%eax
 6f3:	cd 40                	int    $0x40
 6f5:	c3                   	ret    

000006f6 <mkdir>:
SYSCALL(mkdir)
 6f6:	b8 14 00 00 00       	mov    $0x14,%eax
 6fb:	cd 40                	int    $0x40
 6fd:	c3                   	ret    

000006fe <chdir>:
SYSCALL(chdir)
 6fe:	b8 09 00 00 00       	mov    $0x9,%eax
 703:	cd 40                	int    $0x40
 705:	c3                   	ret    

00000706 <dup>:
SYSCALL(dup)
 706:	b8 0a 00 00 00       	mov    $0xa,%eax
 70b:	cd 40                	int    $0x40
 70d:	c3                   	ret    

0000070e <getpid>:
SYSCALL(getpid)
 70e:	b8 0b 00 00 00       	mov    $0xb,%eax
 713:	cd 40                	int    $0x40
 715:	c3                   	ret    

00000716 <sbrk>:
SYSCALL(sbrk)
 716:	b8 0c 00 00 00       	mov    $0xc,%eax
 71b:	cd 40                	int    $0x40
 71d:	c3                   	ret    

0000071e <sleep>:
SYSCALL(sleep)
 71e:	b8 0d 00 00 00       	mov    $0xd,%eax
 723:	cd 40                	int    $0x40
 725:	c3                   	ret    

00000726 <uptime>:
SYSCALL(uptime)
 726:	b8 0e 00 00 00       	mov    $0xe,%eax
 72b:	cd 40                	int    $0x40
 72d:	c3                   	ret    

0000072e <getuser>:
SYSCALL(getuser)
 72e:	b8 16 00 00 00       	mov    $0x16,%eax
 733:	cd 40                	int    $0x40
 735:	c3                   	ret    

00000736 <setuser>:
SYSCALL(setuser)
 736:	b8 17 00 00 00       	mov    $0x17,%eax
 73b:	cd 40                	int    $0x40
 73d:	c3                   	ret    

0000073e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 73e:	55                   	push   %ebp
 73f:	89 e5                	mov    %esp,%ebp
 741:	83 ec 18             	sub    $0x18,%esp
 744:	8b 45 0c             	mov    0xc(%ebp),%eax
 747:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 74a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 751:	00 
 752:	8d 45 f4             	lea    -0xc(%ebp),%eax
 755:	89 44 24 04          	mov    %eax,0x4(%esp)
 759:	8b 45 08             	mov    0x8(%ebp),%eax
 75c:	89 04 24             	mov    %eax,(%esp)
 75f:	e8 4a ff ff ff       	call   6ae <write>
}
 764:	c9                   	leave  
 765:	c3                   	ret    

00000766 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 766:	55                   	push   %ebp
 767:	89 e5                	mov    %esp,%ebp
 769:	56                   	push   %esi
 76a:	53                   	push   %ebx
 76b:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 76e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 775:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 779:	74 17                	je     792 <printint+0x2c>
 77b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 77f:	79 11                	jns    792 <printint+0x2c>
    neg = 1;
 781:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 788:	8b 45 0c             	mov    0xc(%ebp),%eax
 78b:	f7 d8                	neg    %eax
 78d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 790:	eb 06                	jmp    798 <printint+0x32>
  } else {
    x = xx;
 792:	8b 45 0c             	mov    0xc(%ebp),%eax
 795:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 798:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 79f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 7a2:	8d 41 01             	lea    0x1(%ecx),%eax
 7a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ae:	ba 00 00 00 00       	mov    $0x0,%edx
 7b3:	f7 f3                	div    %ebx
 7b5:	89 d0                	mov    %edx,%eax
 7b7:	0f b6 80 70 0f 00 00 	movzbl 0xf70(%eax),%eax
 7be:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 7c2:	8b 75 10             	mov    0x10(%ebp),%esi
 7c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7c8:	ba 00 00 00 00       	mov    $0x0,%edx
 7cd:	f7 f6                	div    %esi
 7cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7d6:	75 c7                	jne    79f <printint+0x39>
  if(neg)
 7d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7dc:	74 10                	je     7ee <printint+0x88>
    buf[i++] = '-';
 7de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e1:	8d 50 01             	lea    0x1(%eax),%edx
 7e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7e7:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 7ec:	eb 1f                	jmp    80d <printint+0xa7>
 7ee:	eb 1d                	jmp    80d <printint+0xa7>
    putc(fd, buf[i]);
 7f0:	8d 55 dc             	lea    -0x24(%ebp),%edx
 7f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f6:	01 d0                	add    %edx,%eax
 7f8:	0f b6 00             	movzbl (%eax),%eax
 7fb:	0f be c0             	movsbl %al,%eax
 7fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 802:	8b 45 08             	mov    0x8(%ebp),%eax
 805:	89 04 24             	mov    %eax,(%esp)
 808:	e8 31 ff ff ff       	call   73e <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 80d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 811:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 815:	79 d9                	jns    7f0 <printint+0x8a>
    putc(fd, buf[i]);
}
 817:	83 c4 30             	add    $0x30,%esp
 81a:	5b                   	pop    %ebx
 81b:	5e                   	pop    %esi
 81c:	5d                   	pop    %ebp
 81d:	c3                   	ret    

0000081e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 81e:	55                   	push   %ebp
 81f:	89 e5                	mov    %esp,%ebp
 821:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 824:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 82b:	8d 45 0c             	lea    0xc(%ebp),%eax
 82e:	83 c0 04             	add    $0x4,%eax
 831:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 834:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 83b:	e9 7c 01 00 00       	jmp    9bc <printf+0x19e>
    c = fmt[i] & 0xff;
 840:	8b 55 0c             	mov    0xc(%ebp),%edx
 843:	8b 45 f0             	mov    -0x10(%ebp),%eax
 846:	01 d0                	add    %edx,%eax
 848:	0f b6 00             	movzbl (%eax),%eax
 84b:	0f be c0             	movsbl %al,%eax
 84e:	25 ff 00 00 00       	and    $0xff,%eax
 853:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 856:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 85a:	75 2c                	jne    888 <printf+0x6a>
      if(c == '%'){
 85c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 860:	75 0c                	jne    86e <printf+0x50>
        state = '%';
 862:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 869:	e9 4a 01 00 00       	jmp    9b8 <printf+0x19a>
      } else {
        putc(fd, c);
 86e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 871:	0f be c0             	movsbl %al,%eax
 874:	89 44 24 04          	mov    %eax,0x4(%esp)
 878:	8b 45 08             	mov    0x8(%ebp),%eax
 87b:	89 04 24             	mov    %eax,(%esp)
 87e:	e8 bb fe ff ff       	call   73e <putc>
 883:	e9 30 01 00 00       	jmp    9b8 <printf+0x19a>
      }
    } else if(state == '%'){
 888:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 88c:	0f 85 26 01 00 00    	jne    9b8 <printf+0x19a>
      if(c == 'd'){
 892:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 896:	75 2d                	jne    8c5 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 898:	8b 45 e8             	mov    -0x18(%ebp),%eax
 89b:	8b 00                	mov    (%eax),%eax
 89d:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 8a4:	00 
 8a5:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 8ac:	00 
 8ad:	89 44 24 04          	mov    %eax,0x4(%esp)
 8b1:	8b 45 08             	mov    0x8(%ebp),%eax
 8b4:	89 04 24             	mov    %eax,(%esp)
 8b7:	e8 aa fe ff ff       	call   766 <printint>
        ap++;
 8bc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8c0:	e9 ec 00 00 00       	jmp    9b1 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 8c5:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 8c9:	74 06                	je     8d1 <printf+0xb3>
 8cb:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 8cf:	75 2d                	jne    8fe <printf+0xe0>
        printint(fd, *ap, 16, 0);
 8d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8d4:	8b 00                	mov    (%eax),%eax
 8d6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 8dd:	00 
 8de:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 8e5:	00 
 8e6:	89 44 24 04          	mov    %eax,0x4(%esp)
 8ea:	8b 45 08             	mov    0x8(%ebp),%eax
 8ed:	89 04 24             	mov    %eax,(%esp)
 8f0:	e8 71 fe ff ff       	call   766 <printint>
        ap++;
 8f5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8f9:	e9 b3 00 00 00       	jmp    9b1 <printf+0x193>
      } else if(c == 's'){
 8fe:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 902:	75 45                	jne    949 <printf+0x12b>
        s = (char*)*ap;
 904:	8b 45 e8             	mov    -0x18(%ebp),%eax
 907:	8b 00                	mov    (%eax),%eax
 909:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 90c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 910:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 914:	75 09                	jne    91f <printf+0x101>
          s = "(null)";
 916:	c7 45 f4 78 0c 00 00 	movl   $0xc78,-0xc(%ebp)
        while(*s != 0){
 91d:	eb 1e                	jmp    93d <printf+0x11f>
 91f:	eb 1c                	jmp    93d <printf+0x11f>
          putc(fd, *s);
 921:	8b 45 f4             	mov    -0xc(%ebp),%eax
 924:	0f b6 00             	movzbl (%eax),%eax
 927:	0f be c0             	movsbl %al,%eax
 92a:	89 44 24 04          	mov    %eax,0x4(%esp)
 92e:	8b 45 08             	mov    0x8(%ebp),%eax
 931:	89 04 24             	mov    %eax,(%esp)
 934:	e8 05 fe ff ff       	call   73e <putc>
          s++;
 939:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 93d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 940:	0f b6 00             	movzbl (%eax),%eax
 943:	84 c0                	test   %al,%al
 945:	75 da                	jne    921 <printf+0x103>
 947:	eb 68                	jmp    9b1 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 949:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 94d:	75 1d                	jne    96c <printf+0x14e>
        putc(fd, *ap);
 94f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 952:	8b 00                	mov    (%eax),%eax
 954:	0f be c0             	movsbl %al,%eax
 957:	89 44 24 04          	mov    %eax,0x4(%esp)
 95b:	8b 45 08             	mov    0x8(%ebp),%eax
 95e:	89 04 24             	mov    %eax,(%esp)
 961:	e8 d8 fd ff ff       	call   73e <putc>
        ap++;
 966:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 96a:	eb 45                	jmp    9b1 <printf+0x193>
      } else if(c == '%'){
 96c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 970:	75 17                	jne    989 <printf+0x16b>
        putc(fd, c);
 972:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 975:	0f be c0             	movsbl %al,%eax
 978:	89 44 24 04          	mov    %eax,0x4(%esp)
 97c:	8b 45 08             	mov    0x8(%ebp),%eax
 97f:	89 04 24             	mov    %eax,(%esp)
 982:	e8 b7 fd ff ff       	call   73e <putc>
 987:	eb 28                	jmp    9b1 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 989:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 990:	00 
 991:	8b 45 08             	mov    0x8(%ebp),%eax
 994:	89 04 24             	mov    %eax,(%esp)
 997:	e8 a2 fd ff ff       	call   73e <putc>
        putc(fd, c);
 99c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 99f:	0f be c0             	movsbl %al,%eax
 9a2:	89 44 24 04          	mov    %eax,0x4(%esp)
 9a6:	8b 45 08             	mov    0x8(%ebp),%eax
 9a9:	89 04 24             	mov    %eax,(%esp)
 9ac:	e8 8d fd ff ff       	call   73e <putc>
      }
      state = 0;
 9b1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 9b8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 9bc:	8b 55 0c             	mov    0xc(%ebp),%edx
 9bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c2:	01 d0                	add    %edx,%eax
 9c4:	0f b6 00             	movzbl (%eax),%eax
 9c7:	84 c0                	test   %al,%al
 9c9:	0f 85 71 fe ff ff    	jne    840 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 9cf:	c9                   	leave  
 9d0:	c3                   	ret    

000009d1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9d1:	55                   	push   %ebp
 9d2:	89 e5                	mov    %esp,%ebp
 9d4:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9d7:	8b 45 08             	mov    0x8(%ebp),%eax
 9da:	83 e8 08             	sub    $0x8,%eax
 9dd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9e0:	a1 8c 0f 00 00       	mov    0xf8c,%eax
 9e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9e8:	eb 24                	jmp    a0e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ed:	8b 00                	mov    (%eax),%eax
 9ef:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9f2:	77 12                	ja     a06 <free+0x35>
 9f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9fa:	77 24                	ja     a20 <free+0x4f>
 9fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ff:	8b 00                	mov    (%eax),%eax
 a01:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a04:	77 1a                	ja     a20 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a06:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a09:	8b 00                	mov    (%eax),%eax
 a0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a11:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a14:	76 d4                	jbe    9ea <free+0x19>
 a16:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a19:	8b 00                	mov    (%eax),%eax
 a1b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a1e:	76 ca                	jbe    9ea <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a20:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a23:	8b 40 04             	mov    0x4(%eax),%eax
 a26:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a30:	01 c2                	add    %eax,%edx
 a32:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a35:	8b 00                	mov    (%eax),%eax
 a37:	39 c2                	cmp    %eax,%edx
 a39:	75 24                	jne    a5f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a3e:	8b 50 04             	mov    0x4(%eax),%edx
 a41:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a44:	8b 00                	mov    (%eax),%eax
 a46:	8b 40 04             	mov    0x4(%eax),%eax
 a49:	01 c2                	add    %eax,%edx
 a4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a4e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a51:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a54:	8b 00                	mov    (%eax),%eax
 a56:	8b 10                	mov    (%eax),%edx
 a58:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a5b:	89 10                	mov    %edx,(%eax)
 a5d:	eb 0a                	jmp    a69 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a62:	8b 10                	mov    (%eax),%edx
 a64:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a67:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a69:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a6c:	8b 40 04             	mov    0x4(%eax),%eax
 a6f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a76:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a79:	01 d0                	add    %edx,%eax
 a7b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a7e:	75 20                	jne    aa0 <free+0xcf>
    p->s.size += bp->s.size;
 a80:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a83:	8b 50 04             	mov    0x4(%eax),%edx
 a86:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a89:	8b 40 04             	mov    0x4(%eax),%eax
 a8c:	01 c2                	add    %eax,%edx
 a8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a91:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a94:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a97:	8b 10                	mov    (%eax),%edx
 a99:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a9c:	89 10                	mov    %edx,(%eax)
 a9e:	eb 08                	jmp    aa8 <free+0xd7>
  } else
    p->s.ptr = bp;
 aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 aa6:	89 10                	mov    %edx,(%eax)
  freep = p;
 aa8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aab:	a3 8c 0f 00 00       	mov    %eax,0xf8c
}
 ab0:	c9                   	leave  
 ab1:	c3                   	ret    

00000ab2 <morecore>:

static Header*
morecore(uint nu)
{
 ab2:	55                   	push   %ebp
 ab3:	89 e5                	mov    %esp,%ebp
 ab5:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 ab8:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 abf:	77 07                	ja     ac8 <morecore+0x16>
    nu = 4096;
 ac1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 ac8:	8b 45 08             	mov    0x8(%ebp),%eax
 acb:	c1 e0 03             	shl    $0x3,%eax
 ace:	89 04 24             	mov    %eax,(%esp)
 ad1:	e8 40 fc ff ff       	call   716 <sbrk>
 ad6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 ad9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 add:	75 07                	jne    ae6 <morecore+0x34>
    return 0;
 adf:	b8 00 00 00 00       	mov    $0x0,%eax
 ae4:	eb 22                	jmp    b08 <morecore+0x56>
  hp = (Header*)p;
 ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aef:	8b 55 08             	mov    0x8(%ebp),%edx
 af2:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 af8:	83 c0 08             	add    $0x8,%eax
 afb:	89 04 24             	mov    %eax,(%esp)
 afe:	e8 ce fe ff ff       	call   9d1 <free>
  return freep;
 b03:	a1 8c 0f 00 00       	mov    0xf8c,%eax
}
 b08:	c9                   	leave  
 b09:	c3                   	ret    

00000b0a <malloc>:

void*
malloc(uint nbytes)
{
 b0a:	55                   	push   %ebp
 b0b:	89 e5                	mov    %esp,%ebp
 b0d:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b10:	8b 45 08             	mov    0x8(%ebp),%eax
 b13:	83 c0 07             	add    $0x7,%eax
 b16:	c1 e8 03             	shr    $0x3,%eax
 b19:	83 c0 01             	add    $0x1,%eax
 b1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b1f:	a1 8c 0f 00 00       	mov    0xf8c,%eax
 b24:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b2b:	75 23                	jne    b50 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b2d:	c7 45 f0 84 0f 00 00 	movl   $0xf84,-0x10(%ebp)
 b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b37:	a3 8c 0f 00 00       	mov    %eax,0xf8c
 b3c:	a1 8c 0f 00 00       	mov    0xf8c,%eax
 b41:	a3 84 0f 00 00       	mov    %eax,0xf84
    base.s.size = 0;
 b46:	c7 05 88 0f 00 00 00 	movl   $0x0,0xf88
 b4d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b53:	8b 00                	mov    (%eax),%eax
 b55:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b5b:	8b 40 04             	mov    0x4(%eax),%eax
 b5e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b61:	72 4d                	jb     bb0 <malloc+0xa6>
      if(p->s.size == nunits)
 b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b66:	8b 40 04             	mov    0x4(%eax),%eax
 b69:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b6c:	75 0c                	jne    b7a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b71:	8b 10                	mov    (%eax),%edx
 b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b76:	89 10                	mov    %edx,(%eax)
 b78:	eb 26                	jmp    ba0 <malloc+0x96>
      else {
        p->s.size -= nunits;
 b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b7d:	8b 40 04             	mov    0x4(%eax),%eax
 b80:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b83:	89 c2                	mov    %eax,%edx
 b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b88:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b8e:	8b 40 04             	mov    0x4(%eax),%eax
 b91:	c1 e0 03             	shl    $0x3,%eax
 b94:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b9a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b9d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ba3:	a3 8c 0f 00 00       	mov    %eax,0xf8c
      return (void*)(p + 1);
 ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bab:	83 c0 08             	add    $0x8,%eax
 bae:	eb 38                	jmp    be8 <malloc+0xde>
    }
    if(p == freep)
 bb0:	a1 8c 0f 00 00       	mov    0xf8c,%eax
 bb5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 bb8:	75 1b                	jne    bd5 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 bba:	8b 45 ec             	mov    -0x14(%ebp),%eax
 bbd:	89 04 24             	mov    %eax,(%esp)
 bc0:	e8 ed fe ff ff       	call   ab2 <morecore>
 bc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 bc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 bcc:	75 07                	jne    bd5 <malloc+0xcb>
        return 0;
 bce:	b8 00 00 00 00       	mov    $0x0,%eax
 bd3:	eb 13                	jmp    be8 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bde:	8b 00                	mov    (%eax),%eax
 be0:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 be3:	e9 70 ff ff ff       	jmp    b58 <malloc+0x4e>
}
 be8:	c9                   	leave  
 be9:	c3                   	ret    
