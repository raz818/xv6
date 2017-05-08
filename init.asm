
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10:	00 
  11:	c7 04 24 55 0b 00 00 	movl   $0xb55,(%esp)
  18:	e8 19 06 00 00       	call   636 <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 55 0b 00 00 	movl   $0xb55,(%esp)
  38:	e8 01 06 00 00       	call   63e <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 55 0b 00 00 	movl   $0xb55,(%esp)
  4c:	e8 e5 05 00 00       	call   636 <open>
  }
  dup(0);  // stdout
  51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  58:	e8 11 06 00 00       	call   66e <dup>
  dup(0);  // stderr
  5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  64:	e8 05 06 00 00       	call   66e <dup>

  for(;;){
    printf(1, "init: starting sh\n");
  69:	c7 44 24 04 5d 0b 00 	movl   $0xb5d,0x4(%esp)
  70:	00 
  71:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  78:	e8 09 07 00 00       	call   786 <printf>
    pid = fork();
  7d:	e8 6c 05 00 00       	call   5ee <fork>
  82:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
  86:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  8b:	79 19                	jns    a6 <main+0xa6>
      printf(1, "init: fork failed\n");
  8d:	c7 44 24 04 70 0b 00 	movl   $0xb70,0x4(%esp)
  94:	00 
  95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9c:	e8 e5 06 00 00       	call   786 <printf>
      exit();
  a1:	e8 50 05 00 00       	call   5f6 <exit>
    }
    if(pid == 0){
  a6:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  ab:	75 39                	jne    e6 <main+0xe6>
	  compareuser(1);
  ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b4:	e8 d2 03 00 00       	call   48b <compareuser>
      exec("sh", argv);
  b9:	c7 44 24 04 04 0f 00 	movl   $0xf04,0x4(%esp)
  c0:	00 
  c1:	c7 04 24 52 0b 00 00 	movl   $0xb52,(%esp)
  c8:	e8 61 05 00 00       	call   62e <exec>
      printf(1, "init: exec sh failed\n");
  cd:	c7 44 24 04 83 0b 00 	movl   $0xb83,0x4(%esp)
  d4:	00 
  d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  dc:	e8 a5 06 00 00       	call   786 <printf>
      exit();
  e1:	e8 10 05 00 00       	call   5f6 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  e6:	eb 14                	jmp    fc <main+0xfc>
      printf(1, "zombie!\n");
  e8:	c7 44 24 04 99 0b 00 	movl   $0xb99,0x4(%esp)
  ef:	00 
  f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f7:	e8 8a 06 00 00       	call   786 <printf>
	  compareuser(1);
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  fc:	e8 fd 04 00 00       	call   5fe <wait>
 101:	89 44 24 18          	mov    %eax,0x18(%esp)
 105:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 10a:	78 0a                	js     116 <main+0x116>
 10c:	8b 44 24 18          	mov    0x18(%esp),%eax
 110:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
 114:	75 d2                	jne    e8 <main+0xe8>
      printf(1, "zombie!\n");
  }
 116:	e9 4e ff ff ff       	jmp    69 <main+0x69>

0000011b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 11b:	55                   	push   %ebp
 11c:	89 e5                	mov    %esp,%ebp
 11e:	57                   	push   %edi
 11f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 120:	8b 4d 08             	mov    0x8(%ebp),%ecx
 123:	8b 55 10             	mov    0x10(%ebp),%edx
 126:	8b 45 0c             	mov    0xc(%ebp),%eax
 129:	89 cb                	mov    %ecx,%ebx
 12b:	89 df                	mov    %ebx,%edi
 12d:	89 d1                	mov    %edx,%ecx
 12f:	fc                   	cld    
 130:	f3 aa                	rep stos %al,%es:(%edi)
 132:	89 ca                	mov    %ecx,%edx
 134:	89 fb                	mov    %edi,%ebx
 136:	89 5d 08             	mov    %ebx,0x8(%ebp)
 139:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 13c:	5b                   	pop    %ebx
 13d:	5f                   	pop    %edi
 13e:	5d                   	pop    %ebp
 13f:	c3                   	ret    

00000140 <thing>:
#include "user.h"
#include "x86.h"


int
thing(void){
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
  return 1;
 143:	b8 01 00 00 00       	mov    $0x1,%eax
}
 148:	5d                   	pop    %ebp
 149:	c3                   	ret    

0000014a <strcpy>:

char*
strcpy(char *s, char *t)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 156:	90                   	nop
 157:	8b 45 08             	mov    0x8(%ebp),%eax
 15a:	8d 50 01             	lea    0x1(%eax),%edx
 15d:	89 55 08             	mov    %edx,0x8(%ebp)
 160:	8b 55 0c             	mov    0xc(%ebp),%edx
 163:	8d 4a 01             	lea    0x1(%edx),%ecx
 166:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 169:	0f b6 12             	movzbl (%edx),%edx
 16c:	88 10                	mov    %dl,(%eax)
 16e:	0f b6 00             	movzbl (%eax),%eax
 171:	84 c0                	test   %al,%al
 173:	75 e2                	jne    157 <strcpy+0xd>
    ;
  return os;
 175:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 178:	c9                   	leave  
 179:	c3                   	ret    

0000017a <strcmp>:



int
strcmp(const char *p, const char *q)
{
 17a:	55                   	push   %ebp
 17b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 17d:	eb 08                	jmp    187 <strcmp+0xd>
    p++, q++;
 17f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 183:	83 45 0c 01          	addl   $0x1,0xc(%ebp)


int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 187:	8b 45 08             	mov    0x8(%ebp),%eax
 18a:	0f b6 00             	movzbl (%eax),%eax
 18d:	84 c0                	test   %al,%al
 18f:	74 10                	je     1a1 <strcmp+0x27>
 191:	8b 45 08             	mov    0x8(%ebp),%eax
 194:	0f b6 10             	movzbl (%eax),%edx
 197:	8b 45 0c             	mov    0xc(%ebp),%eax
 19a:	0f b6 00             	movzbl (%eax),%eax
 19d:	38 c2                	cmp    %al,%dl
 19f:	74 de                	je     17f <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1a1:	8b 45 08             	mov    0x8(%ebp),%eax
 1a4:	0f b6 00             	movzbl (%eax),%eax
 1a7:	0f b6 d0             	movzbl %al,%edx
 1aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ad:	0f b6 00             	movzbl (%eax),%eax
 1b0:	0f b6 c0             	movzbl %al,%eax
 1b3:	29 c2                	sub    %eax,%edx
 1b5:	89 d0                	mov    %edx,%eax
}
 1b7:	5d                   	pop    %ebp
 1b8:	c3                   	ret    

000001b9 <strlen>:

uint
strlen(char *s)
{
 1b9:	55                   	push   %ebp
 1ba:	89 e5                	mov    %esp,%ebp
 1bc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1c6:	eb 04                	jmp    1cc <strlen+0x13>
 1c8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	01 d0                	add    %edx,%eax
 1d4:	0f b6 00             	movzbl (%eax),%eax
 1d7:	84 c0                	test   %al,%al
 1d9:	75 ed                	jne    1c8 <strlen+0xf>
    ;
  return n;
 1db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1de:	c9                   	leave  
 1df:	c3                   	ret    

000001e0 <stringlen>:

uint
stringlen(char **s){
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	83 ec 10             	sub    $0x10,%esp
	int n;

  for(n = 0; s[n]; n++)
 1e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1ed:	eb 04                	jmp    1f3 <stringlen+0x13>
 1ef:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	01 d0                	add    %edx,%eax
 202:	8b 00                	mov    (%eax),%eax
 204:	85 c0                	test   %eax,%eax
 206:	75 e7                	jne    1ef <stringlen+0xf>
    ;
  return n;
 208:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 20b:	c9                   	leave  
 20c:	c3                   	ret    

0000020d <memset>:

void*
memset(void *dst, int c, uint n)
{
 20d:	55                   	push   %ebp
 20e:	89 e5                	mov    %esp,%ebp
 210:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 213:	8b 45 10             	mov    0x10(%ebp),%eax
 216:	89 44 24 08          	mov    %eax,0x8(%esp)
 21a:	8b 45 0c             	mov    0xc(%ebp),%eax
 21d:	89 44 24 04          	mov    %eax,0x4(%esp)
 221:	8b 45 08             	mov    0x8(%ebp),%eax
 224:	89 04 24             	mov    %eax,(%esp)
 227:	e8 ef fe ff ff       	call   11b <stosb>
  return dst;
 22c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 22f:	c9                   	leave  
 230:	c3                   	ret    

00000231 <strchr>:

char*
strchr(const char *s, char c)
{
 231:	55                   	push   %ebp
 232:	89 e5                	mov    %esp,%ebp
 234:	83 ec 04             	sub    $0x4,%esp
 237:	8b 45 0c             	mov    0xc(%ebp),%eax
 23a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 23d:	eb 14                	jmp    253 <strchr+0x22>
    if(*s == c)
 23f:	8b 45 08             	mov    0x8(%ebp),%eax
 242:	0f b6 00             	movzbl (%eax),%eax
 245:	3a 45 fc             	cmp    -0x4(%ebp),%al
 248:	75 05                	jne    24f <strchr+0x1e>
      return (char*)s;
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	eb 13                	jmp    262 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 24f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 253:	8b 45 08             	mov    0x8(%ebp),%eax
 256:	0f b6 00             	movzbl (%eax),%eax
 259:	84 c0                	test   %al,%al
 25b:	75 e2                	jne    23f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 25d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 262:	c9                   	leave  
 263:	c3                   	ret    

00000264 <gets>:

char*
gets(char *buf, int max)
{
 264:	55                   	push   %ebp
 265:	89 e5                	mov    %esp,%ebp
 267:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 271:	eb 4c                	jmp    2bf <gets+0x5b>
    cc = read(0, &c, 1);
 273:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 27a:	00 
 27b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 27e:	89 44 24 04          	mov    %eax,0x4(%esp)
 282:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 289:	e8 80 03 00 00       	call   60e <read>
 28e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 291:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 295:	7f 02                	jg     299 <gets+0x35>
      break;
 297:	eb 31                	jmp    2ca <gets+0x66>
    buf[i++] = c;
 299:	8b 45 f4             	mov    -0xc(%ebp),%eax
 29c:	8d 50 01             	lea    0x1(%eax),%edx
 29f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2a2:	89 c2                	mov    %eax,%edx
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
 2a7:	01 c2                	add    %eax,%edx
 2a9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2ad:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2af:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2b3:	3c 0a                	cmp    $0xa,%al
 2b5:	74 13                	je     2ca <gets+0x66>
 2b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2bb:	3c 0d                	cmp    $0xd,%al
 2bd:	74 0b                	je     2ca <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c2:	83 c0 01             	add    $0x1,%eax
 2c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2c8:	7c a9                	jl     273 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
 2d0:	01 d0                	add    %edx,%eax
 2d2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d8:	c9                   	leave  
 2d9:	c3                   	ret    

000002da <stat>:

int
stat(char *n, struct stat *st)
{
 2da:	55                   	push   %ebp
 2db:	89 e5                	mov    %esp,%ebp
 2dd:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2e7:	00 
 2e8:	8b 45 08             	mov    0x8(%ebp),%eax
 2eb:	89 04 24             	mov    %eax,(%esp)
 2ee:	e8 43 03 00 00       	call   636 <open>
 2f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2fa:	79 07                	jns    303 <stat+0x29>
    return -1;
 2fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 301:	eb 23                	jmp    326 <stat+0x4c>
  r = fstat(fd, st);
 303:	8b 45 0c             	mov    0xc(%ebp),%eax
 306:	89 44 24 04          	mov    %eax,0x4(%esp)
 30a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 30d:	89 04 24             	mov    %eax,(%esp)
 310:	e8 39 03 00 00       	call   64e <fstat>
 315:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 318:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31b:	89 04 24             	mov    %eax,(%esp)
 31e:	e8 fb 02 00 00       	call   61e <close>
  return r;
 323:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 326:	c9                   	leave  
 327:	c3                   	ret    

00000328 <atoi>:

int
atoi(const char *s)
{
 328:	55                   	push   %ebp
 329:	89 e5                	mov    %esp,%ebp
 32b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 32e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 335:	eb 25                	jmp    35c <atoi+0x34>
    n = n*10 + *s++ - '0';
 337:	8b 55 fc             	mov    -0x4(%ebp),%edx
 33a:	89 d0                	mov    %edx,%eax
 33c:	c1 e0 02             	shl    $0x2,%eax
 33f:	01 d0                	add    %edx,%eax
 341:	01 c0                	add    %eax,%eax
 343:	89 c1                	mov    %eax,%ecx
 345:	8b 45 08             	mov    0x8(%ebp),%eax
 348:	8d 50 01             	lea    0x1(%eax),%edx
 34b:	89 55 08             	mov    %edx,0x8(%ebp)
 34e:	0f b6 00             	movzbl (%eax),%eax
 351:	0f be c0             	movsbl %al,%eax
 354:	01 c8                	add    %ecx,%eax
 356:	83 e8 30             	sub    $0x30,%eax
 359:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 35c:	8b 45 08             	mov    0x8(%ebp),%eax
 35f:	0f b6 00             	movzbl (%eax),%eax
 362:	3c 2f                	cmp    $0x2f,%al
 364:	7e 0a                	jle    370 <atoi+0x48>
 366:	8b 45 08             	mov    0x8(%ebp),%eax
 369:	0f b6 00             	movzbl (%eax),%eax
 36c:	3c 39                	cmp    $0x39,%al
 36e:	7e c7                	jle    337 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 370:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 373:	c9                   	leave  
 374:	c3                   	ret    

00000375 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 375:	55                   	push   %ebp
 376:	89 e5                	mov    %esp,%ebp
 378:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 37b:	8b 45 08             	mov    0x8(%ebp),%eax
 37e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 381:	8b 45 0c             	mov    0xc(%ebp),%eax
 384:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 387:	eb 17                	jmp    3a0 <memmove+0x2b>
    *dst++ = *src++;
 389:	8b 45 fc             	mov    -0x4(%ebp),%eax
 38c:	8d 50 01             	lea    0x1(%eax),%edx
 38f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 392:	8b 55 f8             	mov    -0x8(%ebp),%edx
 395:	8d 4a 01             	lea    0x1(%edx),%ecx
 398:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 39b:	0f b6 12             	movzbl (%edx),%edx
 39e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3a0:	8b 45 10             	mov    0x10(%ebp),%eax
 3a3:	8d 50 ff             	lea    -0x1(%eax),%edx
 3a6:	89 55 10             	mov    %edx,0x10(%ebp)
 3a9:	85 c0                	test   %eax,%eax
 3ab:	7f dc                	jg     389 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3b0:	c9                   	leave  
 3b1:	c3                   	ret    

000003b2 <strcmp_c>:


int
strcmp_c(const char *s1, const char *s2)
{
 3b2:	55                   	push   %ebp
 3b3:	89 e5                	mov    %esp,%ebp
    for ( ; *s1 == *s2; s1++, s2++)
 3b5:	eb 19                	jmp    3d0 <strcmp_c+0x1e>
	if (*s1 == '\0')
 3b7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ba:	0f b6 00             	movzbl (%eax),%eax
 3bd:	84 c0                	test   %al,%al
 3bf:	75 07                	jne    3c8 <strcmp_c+0x16>
	    return 0;
 3c1:	b8 00 00 00 00       	mov    $0x0,%eax
 3c6:	eb 34                	jmp    3fc <strcmp_c+0x4a>


int
strcmp_c(const char *s1, const char *s2)
{
    for ( ; *s1 == *s2; s1++, s2++)
 3c8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3cc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 3d0:	8b 45 08             	mov    0x8(%ebp),%eax
 3d3:	0f b6 10             	movzbl (%eax),%edx
 3d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d9:	0f b6 00             	movzbl (%eax),%eax
 3dc:	38 c2                	cmp    %al,%dl
 3de:	74 d7                	je     3b7 <strcmp_c+0x5>
	if (*s1 == '\0')
	    return 0;
    return ((*(unsigned char *)s1 < *(unsigned char *)s2) ? -1 : +1);
 3e0:	8b 45 08             	mov    0x8(%ebp),%eax
 3e3:	0f b6 10             	movzbl (%eax),%edx
 3e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e9:	0f b6 00             	movzbl (%eax),%eax
 3ec:	38 c2                	cmp    %al,%dl
 3ee:	73 07                	jae    3f7 <strcmp_c+0x45>
 3f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3f5:	eb 05                	jmp    3fc <strcmp_c+0x4a>
 3f7:	b8 01 00 00 00       	mov    $0x1,%eax
}
 3fc:	5d                   	pop    %ebp
 3fd:	c3                   	ret    

000003fe <readuser>:


struct USER
readuser(){
 3fe:	55                   	push   %ebp
 3ff:	89 e5                	mov    %esp,%ebp
 401:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char buff1[512], buff2[512];
	struct USER u;
	printf(1,"Please enter a username: ");
 407:	c7 44 24 04 a2 0b 00 	movl   $0xba2,0x4(%esp)
 40e:	00 
 40f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 416:	e8 6b 03 00 00       	call   786 <printf>
	u.name = gets(buff1, 50);
 41b:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 422:	00 
 423:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
 429:	89 04 24             	mov    %eax,(%esp)
 42c:	e8 33 fe ff ff       	call   264 <gets>
 431:	89 85 ec fb ff ff    	mov    %eax,-0x414(%ebp)
	printf(1,"Please enter a password: ");
 437:	c7 44 24 04 bc 0b 00 	movl   $0xbbc,0x4(%esp)
 43e:	00 
 43f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 446:	e8 3b 03 00 00       	call   786 <printf>
	u.pass = gets(buff2, 50);
 44b:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 452:	00 
 453:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
 459:	89 04 24             	mov    %eax,(%esp)
 45c:	e8 03 fe ff ff       	call   264 <gets>
 461:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
	return u;
 467:	8b 45 08             	mov    0x8(%ebp),%eax
 46a:	8b 95 ec fb ff ff    	mov    -0x414(%ebp),%edx
 470:	89 10                	mov    %edx,(%eax)
 472:	8b 95 f0 fb ff ff    	mov    -0x410(%ebp),%edx
 478:	89 50 04             	mov    %edx,0x4(%eax)
 47b:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
 481:	89 50 08             	mov    %edx,0x8(%eax)
}
 484:	8b 45 08             	mov    0x8(%ebp),%eax
 487:	c9                   	leave  
 488:	c2 04 00             	ret    $0x4

0000048b <compareuser>:


int
compareuser(int state){
 48b:	55                   	push   %ebp
 48c:	89 e5                	mov    %esp,%ebp
 48e:	56                   	push   %esi
 48f:	53                   	push   %ebx
 490:	81 ec 30 01 00 00    	sub    $0x130,%esp
	struct USER u1,u2;
	struct USER users[20];
	u1.name = "john\n";
 496:	c7 45 e8 d6 0b 00 00 	movl   $0xbd6,-0x18(%ebp)
	u1.pass = "1234\n";
 49d:	c7 45 ec dc 0b 00 00 	movl   $0xbdc,-0x14(%ebp)
	u1.ulevel = 0;
 4a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	u2.name = "james\n";
 4ab:	c7 45 dc e2 0b 00 00 	movl   $0xbe2,-0x24(%ebp)
	u2.pass = "pass\n";
 4b2:	c7 45 e0 e9 0b 00 00 	movl   $0xbe9,-0x20(%ebp)
	u2.ulevel = 1;
 4b9:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	users[0] = u1;
 4c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
 4c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4cc:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
 4d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4d5:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
	users[1] = u2;
 4db:	8b 45 dc             	mov    -0x24(%ebp),%eax
 4de:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
 4e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
 4e7:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
 4ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4f0:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
	
	
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
 4f6:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
 4fc:	89 04 24             	mov    %eax,(%esp)
 4ff:	e8 fa fe ff ff       	call   3fe <readuser>
 504:	83 ec 04             	sub    $0x4,%esp
		
		for(ctr = 0; ctr < 20; ctr++)
 507:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 50e:	e9 a4 00 00 00       	jmp    5b7 <compareuser+0x12c>
		{

			if(strcmp_c(u.name,users[ctr].name) == 0 && strcmp_c(u.pass,users[ctr].pass) == 0)
 513:	8b 55 f4             	mov    -0xc(%ebp),%edx
 516:	89 d0                	mov    %edx,%eax
 518:	01 c0                	add    %eax,%eax
 51a:	01 d0                	add    %edx,%eax
 51c:	c1 e0 02             	shl    $0x2,%eax
 51f:	8d 4d f8             	lea    -0x8(%ebp),%ecx
 522:	01 c8                	add    %ecx,%eax
 524:	2d 0c 01 00 00       	sub    $0x10c,%eax
 529:	8b 10                	mov    (%eax),%edx
 52b:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
 531:	89 54 24 04          	mov    %edx,0x4(%esp)
 535:	89 04 24             	mov    %eax,(%esp)
 538:	e8 75 fe ff ff       	call   3b2 <strcmp_c>
 53d:	85 c0                	test   %eax,%eax
 53f:	75 72                	jne    5b3 <compareuser+0x128>
 541:	8b 55 f4             	mov    -0xc(%ebp),%edx
 544:	89 d0                	mov    %edx,%eax
 546:	01 c0                	add    %eax,%eax
 548:	01 d0                	add    %edx,%eax
 54a:	c1 e0 02             	shl    $0x2,%eax
 54d:	8d 5d f8             	lea    -0x8(%ebp),%ebx
 550:	01 d8                	add    %ebx,%eax
 552:	2d 08 01 00 00       	sub    $0x108,%eax
 557:	8b 10                	mov    (%eax),%edx
 559:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
 55f:	89 54 24 04          	mov    %edx,0x4(%esp)
 563:	89 04 24             	mov    %eax,(%esp)
 566:	e8 47 fe ff ff       	call   3b2 <strcmp_c>
 56b:	85 c0                	test   %eax,%eax
 56d:	75 44                	jne    5b3 <compareuser+0x128>
			{
				setuser(users[ctr].ulevel);
 56f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 572:	89 d0                	mov    %edx,%eax
 574:	01 c0                	add    %eax,%eax
 576:	01 d0                	add    %edx,%eax
 578:	c1 e0 02             	shl    $0x2,%eax
 57b:	8d 75 f8             	lea    -0x8(%ebp),%esi
 57e:	01 f0                	add    %esi,%eax
 580:	2d 04 01 00 00       	sub    $0x104,%eax
 585:	8b 00                	mov    (%eax),%eax
 587:	89 04 24             	mov    %eax,(%esp)
 58a:	e8 0f 01 00 00       	call   69e <setuser>
				
				printf(1,"%d",getuser());
 58f:	e8 02 01 00 00       	call   696 <getuser>
 594:	89 44 24 08          	mov    %eax,0x8(%esp)
 598:	c7 44 24 04 ef 0b 00 	movl   $0xbef,0x4(%esp)
 59f:	00 
 5a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5a7:	e8 da 01 00 00       	call   786 <printf>
				return 1;
 5ac:	b8 01 00 00 00       	mov    $0x1,%eax
 5b1:	eb 34                	jmp    5e7 <compareuser+0x15c>
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
		
		for(ctr = 0; ctr < 20; ctr++)
 5b3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 5b7:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 5bb:	0f 8e 52 ff ff ff    	jle    513 <compareuser+0x88>
				
				printf(1,"%d",getuser());
				return 1;
			}
		}
		printf(1,"Invalid username/password\n");
 5c1:	c7 44 24 04 f2 0b 00 	movl   $0xbf2,0x4(%esp)
 5c8:	00 
 5c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5d0:	e8 b1 01 00 00       	call   786 <printf>
		if(state != 1)
 5d5:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 5d9:	74 07                	je     5e2 <compareuser+0x157>
			break;
	}
	return 0;
 5db:	b8 00 00 00 00       	mov    $0x0,%eax
 5e0:	eb 05                	jmp    5e7 <compareuser+0x15c>
			}
		}
		printf(1,"Invalid username/password\n");
		if(state != 1)
			break;
	}
 5e2:	e9 0f ff ff ff       	jmp    4f6 <compareuser+0x6b>
	return 0;
}
 5e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
 5ea:	5b                   	pop    %ebx
 5eb:	5e                   	pop    %esi
 5ec:	5d                   	pop    %ebp
 5ed:	c3                   	ret    

000005ee <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5ee:	b8 01 00 00 00       	mov    $0x1,%eax
 5f3:	cd 40                	int    $0x40
 5f5:	c3                   	ret    

000005f6 <exit>:
SYSCALL(exit)
 5f6:	b8 02 00 00 00       	mov    $0x2,%eax
 5fb:	cd 40                	int    $0x40
 5fd:	c3                   	ret    

000005fe <wait>:
SYSCALL(wait)
 5fe:	b8 03 00 00 00       	mov    $0x3,%eax
 603:	cd 40                	int    $0x40
 605:	c3                   	ret    

00000606 <pipe>:
SYSCALL(pipe)
 606:	b8 04 00 00 00       	mov    $0x4,%eax
 60b:	cd 40                	int    $0x40
 60d:	c3                   	ret    

0000060e <read>:
SYSCALL(read)
 60e:	b8 05 00 00 00       	mov    $0x5,%eax
 613:	cd 40                	int    $0x40
 615:	c3                   	ret    

00000616 <write>:
SYSCALL(write)
 616:	b8 10 00 00 00       	mov    $0x10,%eax
 61b:	cd 40                	int    $0x40
 61d:	c3                   	ret    

0000061e <close>:
SYSCALL(close)
 61e:	b8 15 00 00 00       	mov    $0x15,%eax
 623:	cd 40                	int    $0x40
 625:	c3                   	ret    

00000626 <kill>:
SYSCALL(kill)
 626:	b8 06 00 00 00       	mov    $0x6,%eax
 62b:	cd 40                	int    $0x40
 62d:	c3                   	ret    

0000062e <exec>:
SYSCALL(exec)
 62e:	b8 07 00 00 00       	mov    $0x7,%eax
 633:	cd 40                	int    $0x40
 635:	c3                   	ret    

00000636 <open>:
SYSCALL(open)
 636:	b8 0f 00 00 00       	mov    $0xf,%eax
 63b:	cd 40                	int    $0x40
 63d:	c3                   	ret    

0000063e <mknod>:
SYSCALL(mknod)
 63e:	b8 11 00 00 00       	mov    $0x11,%eax
 643:	cd 40                	int    $0x40
 645:	c3                   	ret    

00000646 <unlink>:
SYSCALL(unlink)
 646:	b8 12 00 00 00       	mov    $0x12,%eax
 64b:	cd 40                	int    $0x40
 64d:	c3                   	ret    

0000064e <fstat>:
SYSCALL(fstat)
 64e:	b8 08 00 00 00       	mov    $0x8,%eax
 653:	cd 40                	int    $0x40
 655:	c3                   	ret    

00000656 <link>:
SYSCALL(link)
 656:	b8 13 00 00 00       	mov    $0x13,%eax
 65b:	cd 40                	int    $0x40
 65d:	c3                   	ret    

0000065e <mkdir>:
SYSCALL(mkdir)
 65e:	b8 14 00 00 00       	mov    $0x14,%eax
 663:	cd 40                	int    $0x40
 665:	c3                   	ret    

00000666 <chdir>:
SYSCALL(chdir)
 666:	b8 09 00 00 00       	mov    $0x9,%eax
 66b:	cd 40                	int    $0x40
 66d:	c3                   	ret    

0000066e <dup>:
SYSCALL(dup)
 66e:	b8 0a 00 00 00       	mov    $0xa,%eax
 673:	cd 40                	int    $0x40
 675:	c3                   	ret    

00000676 <getpid>:
SYSCALL(getpid)
 676:	b8 0b 00 00 00       	mov    $0xb,%eax
 67b:	cd 40                	int    $0x40
 67d:	c3                   	ret    

0000067e <sbrk>:
SYSCALL(sbrk)
 67e:	b8 0c 00 00 00       	mov    $0xc,%eax
 683:	cd 40                	int    $0x40
 685:	c3                   	ret    

00000686 <sleep>:
SYSCALL(sleep)
 686:	b8 0d 00 00 00       	mov    $0xd,%eax
 68b:	cd 40                	int    $0x40
 68d:	c3                   	ret    

0000068e <uptime>:
SYSCALL(uptime)
 68e:	b8 0e 00 00 00       	mov    $0xe,%eax
 693:	cd 40                	int    $0x40
 695:	c3                   	ret    

00000696 <getuser>:
SYSCALL(getuser)
 696:	b8 16 00 00 00       	mov    $0x16,%eax
 69b:	cd 40                	int    $0x40
 69d:	c3                   	ret    

0000069e <setuser>:
SYSCALL(setuser)
 69e:	b8 17 00 00 00       	mov    $0x17,%eax
 6a3:	cd 40                	int    $0x40
 6a5:	c3                   	ret    

000006a6 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6a6:	55                   	push   %ebp
 6a7:	89 e5                	mov    %esp,%ebp
 6a9:	83 ec 18             	sub    $0x18,%esp
 6ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 6af:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6b2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6b9:	00 
 6ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6bd:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c1:	8b 45 08             	mov    0x8(%ebp),%eax
 6c4:	89 04 24             	mov    %eax,(%esp)
 6c7:	e8 4a ff ff ff       	call   616 <write>
}
 6cc:	c9                   	leave  
 6cd:	c3                   	ret    

000006ce <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6ce:	55                   	push   %ebp
 6cf:	89 e5                	mov    %esp,%ebp
 6d1:	56                   	push   %esi
 6d2:	53                   	push   %ebx
 6d3:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6dd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6e1:	74 17                	je     6fa <printint+0x2c>
 6e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6e7:	79 11                	jns    6fa <printint+0x2c>
    neg = 1;
 6e9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f3:	f7 d8                	neg    %eax
 6f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6f8:	eb 06                	jmp    700 <printint+0x32>
  } else {
    x = xx;
 6fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 6fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 700:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 707:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 70a:	8d 41 01             	lea    0x1(%ecx),%eax
 70d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 710:	8b 5d 10             	mov    0x10(%ebp),%ebx
 713:	8b 45 ec             	mov    -0x14(%ebp),%eax
 716:	ba 00 00 00 00       	mov    $0x0,%edx
 71b:	f7 f3                	div    %ebx
 71d:	89 d0                	mov    %edx,%eax
 71f:	0f b6 80 0c 0f 00 00 	movzbl 0xf0c(%eax),%eax
 726:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 72a:	8b 75 10             	mov    0x10(%ebp),%esi
 72d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 730:	ba 00 00 00 00       	mov    $0x0,%edx
 735:	f7 f6                	div    %esi
 737:	89 45 ec             	mov    %eax,-0x14(%ebp)
 73a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 73e:	75 c7                	jne    707 <printint+0x39>
  if(neg)
 740:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 744:	74 10                	je     756 <printint+0x88>
    buf[i++] = '-';
 746:	8b 45 f4             	mov    -0xc(%ebp),%eax
 749:	8d 50 01             	lea    0x1(%eax),%edx
 74c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 74f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 754:	eb 1f                	jmp    775 <printint+0xa7>
 756:	eb 1d                	jmp    775 <printint+0xa7>
    putc(fd, buf[i]);
 758:	8d 55 dc             	lea    -0x24(%ebp),%edx
 75b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75e:	01 d0                	add    %edx,%eax
 760:	0f b6 00             	movzbl (%eax),%eax
 763:	0f be c0             	movsbl %al,%eax
 766:	89 44 24 04          	mov    %eax,0x4(%esp)
 76a:	8b 45 08             	mov    0x8(%ebp),%eax
 76d:	89 04 24             	mov    %eax,(%esp)
 770:	e8 31 ff ff ff       	call   6a6 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 775:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 779:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 77d:	79 d9                	jns    758 <printint+0x8a>
    putc(fd, buf[i]);
}
 77f:	83 c4 30             	add    $0x30,%esp
 782:	5b                   	pop    %ebx
 783:	5e                   	pop    %esi
 784:	5d                   	pop    %ebp
 785:	c3                   	ret    

00000786 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 786:	55                   	push   %ebp
 787:	89 e5                	mov    %esp,%ebp
 789:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 78c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 793:	8d 45 0c             	lea    0xc(%ebp),%eax
 796:	83 c0 04             	add    $0x4,%eax
 799:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 79c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7a3:	e9 7c 01 00 00       	jmp    924 <printf+0x19e>
    c = fmt[i] & 0xff;
 7a8:	8b 55 0c             	mov    0xc(%ebp),%edx
 7ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ae:	01 d0                	add    %edx,%eax
 7b0:	0f b6 00             	movzbl (%eax),%eax
 7b3:	0f be c0             	movsbl %al,%eax
 7b6:	25 ff 00 00 00       	and    $0xff,%eax
 7bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7c2:	75 2c                	jne    7f0 <printf+0x6a>
      if(c == '%'){
 7c4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7c8:	75 0c                	jne    7d6 <printf+0x50>
        state = '%';
 7ca:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7d1:	e9 4a 01 00 00       	jmp    920 <printf+0x19a>
      } else {
        putc(fd, c);
 7d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7d9:	0f be c0             	movsbl %al,%eax
 7dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 7e0:	8b 45 08             	mov    0x8(%ebp),%eax
 7e3:	89 04 24             	mov    %eax,(%esp)
 7e6:	e8 bb fe ff ff       	call   6a6 <putc>
 7eb:	e9 30 01 00 00       	jmp    920 <printf+0x19a>
      }
    } else if(state == '%'){
 7f0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7f4:	0f 85 26 01 00 00    	jne    920 <printf+0x19a>
      if(c == 'd'){
 7fa:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7fe:	75 2d                	jne    82d <printf+0xa7>
        printint(fd, *ap, 10, 1);
 800:	8b 45 e8             	mov    -0x18(%ebp),%eax
 803:	8b 00                	mov    (%eax),%eax
 805:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 80c:	00 
 80d:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 814:	00 
 815:	89 44 24 04          	mov    %eax,0x4(%esp)
 819:	8b 45 08             	mov    0x8(%ebp),%eax
 81c:	89 04 24             	mov    %eax,(%esp)
 81f:	e8 aa fe ff ff       	call   6ce <printint>
        ap++;
 824:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 828:	e9 ec 00 00 00       	jmp    919 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 82d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 831:	74 06                	je     839 <printf+0xb3>
 833:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 837:	75 2d                	jne    866 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 839:	8b 45 e8             	mov    -0x18(%ebp),%eax
 83c:	8b 00                	mov    (%eax),%eax
 83e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 845:	00 
 846:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 84d:	00 
 84e:	89 44 24 04          	mov    %eax,0x4(%esp)
 852:	8b 45 08             	mov    0x8(%ebp),%eax
 855:	89 04 24             	mov    %eax,(%esp)
 858:	e8 71 fe ff ff       	call   6ce <printint>
        ap++;
 85d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 861:	e9 b3 00 00 00       	jmp    919 <printf+0x193>
      } else if(c == 's'){
 866:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 86a:	75 45                	jne    8b1 <printf+0x12b>
        s = (char*)*ap;
 86c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 86f:	8b 00                	mov    (%eax),%eax
 871:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 874:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 878:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 87c:	75 09                	jne    887 <printf+0x101>
          s = "(null)";
 87e:	c7 45 f4 0d 0c 00 00 	movl   $0xc0d,-0xc(%ebp)
        while(*s != 0){
 885:	eb 1e                	jmp    8a5 <printf+0x11f>
 887:	eb 1c                	jmp    8a5 <printf+0x11f>
          putc(fd, *s);
 889:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88c:	0f b6 00             	movzbl (%eax),%eax
 88f:	0f be c0             	movsbl %al,%eax
 892:	89 44 24 04          	mov    %eax,0x4(%esp)
 896:	8b 45 08             	mov    0x8(%ebp),%eax
 899:	89 04 24             	mov    %eax,(%esp)
 89c:	e8 05 fe ff ff       	call   6a6 <putc>
          s++;
 8a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a8:	0f b6 00             	movzbl (%eax),%eax
 8ab:	84 c0                	test   %al,%al
 8ad:	75 da                	jne    889 <printf+0x103>
 8af:	eb 68                	jmp    919 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8b1:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 8b5:	75 1d                	jne    8d4 <printf+0x14e>
        putc(fd, *ap);
 8b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8ba:	8b 00                	mov    (%eax),%eax
 8bc:	0f be c0             	movsbl %al,%eax
 8bf:	89 44 24 04          	mov    %eax,0x4(%esp)
 8c3:	8b 45 08             	mov    0x8(%ebp),%eax
 8c6:	89 04 24             	mov    %eax,(%esp)
 8c9:	e8 d8 fd ff ff       	call   6a6 <putc>
        ap++;
 8ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8d2:	eb 45                	jmp    919 <printf+0x193>
      } else if(c == '%'){
 8d4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8d8:	75 17                	jne    8f1 <printf+0x16b>
        putc(fd, c);
 8da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8dd:	0f be c0             	movsbl %al,%eax
 8e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 8e4:	8b 45 08             	mov    0x8(%ebp),%eax
 8e7:	89 04 24             	mov    %eax,(%esp)
 8ea:	e8 b7 fd ff ff       	call   6a6 <putc>
 8ef:	eb 28                	jmp    919 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8f1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8f8:	00 
 8f9:	8b 45 08             	mov    0x8(%ebp),%eax
 8fc:	89 04 24             	mov    %eax,(%esp)
 8ff:	e8 a2 fd ff ff       	call   6a6 <putc>
        putc(fd, c);
 904:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 907:	0f be c0             	movsbl %al,%eax
 90a:	89 44 24 04          	mov    %eax,0x4(%esp)
 90e:	8b 45 08             	mov    0x8(%ebp),%eax
 911:	89 04 24             	mov    %eax,(%esp)
 914:	e8 8d fd ff ff       	call   6a6 <putc>
      }
      state = 0;
 919:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 920:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 924:	8b 55 0c             	mov    0xc(%ebp),%edx
 927:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92a:	01 d0                	add    %edx,%eax
 92c:	0f b6 00             	movzbl (%eax),%eax
 92f:	84 c0                	test   %al,%al
 931:	0f 85 71 fe ff ff    	jne    7a8 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 937:	c9                   	leave  
 938:	c3                   	ret    

00000939 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 939:	55                   	push   %ebp
 93a:	89 e5                	mov    %esp,%ebp
 93c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 93f:	8b 45 08             	mov    0x8(%ebp),%eax
 942:	83 e8 08             	sub    $0x8,%eax
 945:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 948:	a1 28 0f 00 00       	mov    0xf28,%eax
 94d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 950:	eb 24                	jmp    976 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 952:	8b 45 fc             	mov    -0x4(%ebp),%eax
 955:	8b 00                	mov    (%eax),%eax
 957:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 95a:	77 12                	ja     96e <free+0x35>
 95c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 962:	77 24                	ja     988 <free+0x4f>
 964:	8b 45 fc             	mov    -0x4(%ebp),%eax
 967:	8b 00                	mov    (%eax),%eax
 969:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 96c:	77 1a                	ja     988 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 96e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 971:	8b 00                	mov    (%eax),%eax
 973:	89 45 fc             	mov    %eax,-0x4(%ebp)
 976:	8b 45 f8             	mov    -0x8(%ebp),%eax
 979:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 97c:	76 d4                	jbe    952 <free+0x19>
 97e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 981:	8b 00                	mov    (%eax),%eax
 983:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 986:	76 ca                	jbe    952 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 988:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98b:	8b 40 04             	mov    0x4(%eax),%eax
 98e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 995:	8b 45 f8             	mov    -0x8(%ebp),%eax
 998:	01 c2                	add    %eax,%edx
 99a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99d:	8b 00                	mov    (%eax),%eax
 99f:	39 c2                	cmp    %eax,%edx
 9a1:	75 24                	jne    9c7 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 9a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a6:	8b 50 04             	mov    0x4(%eax),%edx
 9a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ac:	8b 00                	mov    (%eax),%eax
 9ae:	8b 40 04             	mov    0x4(%eax),%eax
 9b1:	01 c2                	add    %eax,%edx
 9b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 9b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9bc:	8b 00                	mov    (%eax),%eax
 9be:	8b 10                	mov    (%eax),%edx
 9c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c3:	89 10                	mov    %edx,(%eax)
 9c5:	eb 0a                	jmp    9d1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ca:	8b 10                	mov    (%eax),%edx
 9cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9cf:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d4:	8b 40 04             	mov    0x4(%eax),%eax
 9d7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e1:	01 d0                	add    %edx,%eax
 9e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9e6:	75 20                	jne    a08 <free+0xcf>
    p->s.size += bp->s.size;
 9e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9eb:	8b 50 04             	mov    0x4(%eax),%edx
 9ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f1:	8b 40 04             	mov    0x4(%eax),%eax
 9f4:	01 c2                	add    %eax,%edx
 9f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ff:	8b 10                	mov    (%eax),%edx
 a01:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a04:	89 10                	mov    %edx,(%eax)
 a06:	eb 08                	jmp    a10 <free+0xd7>
  } else
    p->s.ptr = bp;
 a08:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a0b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a0e:	89 10                	mov    %edx,(%eax)
  freep = p;
 a10:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a13:	a3 28 0f 00 00       	mov    %eax,0xf28
}
 a18:	c9                   	leave  
 a19:	c3                   	ret    

00000a1a <morecore>:

static Header*
morecore(uint nu)
{
 a1a:	55                   	push   %ebp
 a1b:	89 e5                	mov    %esp,%ebp
 a1d:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a20:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a27:	77 07                	ja     a30 <morecore+0x16>
    nu = 4096;
 a29:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a30:	8b 45 08             	mov    0x8(%ebp),%eax
 a33:	c1 e0 03             	shl    $0x3,%eax
 a36:	89 04 24             	mov    %eax,(%esp)
 a39:	e8 40 fc ff ff       	call   67e <sbrk>
 a3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a41:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a45:	75 07                	jne    a4e <morecore+0x34>
    return 0;
 a47:	b8 00 00 00 00       	mov    $0x0,%eax
 a4c:	eb 22                	jmp    a70 <morecore+0x56>
  hp = (Header*)p;
 a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a57:	8b 55 08             	mov    0x8(%ebp),%edx
 a5a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a60:	83 c0 08             	add    $0x8,%eax
 a63:	89 04 24             	mov    %eax,(%esp)
 a66:	e8 ce fe ff ff       	call   939 <free>
  return freep;
 a6b:	a1 28 0f 00 00       	mov    0xf28,%eax
}
 a70:	c9                   	leave  
 a71:	c3                   	ret    

00000a72 <malloc>:

void*
malloc(uint nbytes)
{
 a72:	55                   	push   %ebp
 a73:	89 e5                	mov    %esp,%ebp
 a75:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a78:	8b 45 08             	mov    0x8(%ebp),%eax
 a7b:	83 c0 07             	add    $0x7,%eax
 a7e:	c1 e8 03             	shr    $0x3,%eax
 a81:	83 c0 01             	add    $0x1,%eax
 a84:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a87:	a1 28 0f 00 00       	mov    0xf28,%eax
 a8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a8f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a93:	75 23                	jne    ab8 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a95:	c7 45 f0 20 0f 00 00 	movl   $0xf20,-0x10(%ebp)
 a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a9f:	a3 28 0f 00 00       	mov    %eax,0xf28
 aa4:	a1 28 0f 00 00       	mov    0xf28,%eax
 aa9:	a3 20 0f 00 00       	mov    %eax,0xf20
    base.s.size = 0;
 aae:	c7 05 24 0f 00 00 00 	movl   $0x0,0xf24
 ab5:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 abb:	8b 00                	mov    (%eax),%eax
 abd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac3:	8b 40 04             	mov    0x4(%eax),%eax
 ac6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ac9:	72 4d                	jb     b18 <malloc+0xa6>
      if(p->s.size == nunits)
 acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ace:	8b 40 04             	mov    0x4(%eax),%eax
 ad1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ad4:	75 0c                	jne    ae2 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad9:	8b 10                	mov    (%eax),%edx
 adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ade:	89 10                	mov    %edx,(%eax)
 ae0:	eb 26                	jmp    b08 <malloc+0x96>
      else {
        p->s.size -= nunits;
 ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae5:	8b 40 04             	mov    0x4(%eax),%eax
 ae8:	2b 45 ec             	sub    -0x14(%ebp),%eax
 aeb:	89 c2                	mov    %eax,%edx
 aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af0:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af6:	8b 40 04             	mov    0x4(%eax),%eax
 af9:	c1 e0 03             	shl    $0x3,%eax
 afc:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b02:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b05:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b0b:	a3 28 0f 00 00       	mov    %eax,0xf28
      return (void*)(p + 1);
 b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b13:	83 c0 08             	add    $0x8,%eax
 b16:	eb 38                	jmp    b50 <malloc+0xde>
    }
    if(p == freep)
 b18:	a1 28 0f 00 00       	mov    0xf28,%eax
 b1d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b20:	75 1b                	jne    b3d <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 b22:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b25:	89 04 24             	mov    %eax,(%esp)
 b28:	e8 ed fe ff ff       	call   a1a <morecore>
 b2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b34:	75 07                	jne    b3d <malloc+0xcb>
        return 0;
 b36:	b8 00 00 00 00       	mov    $0x0,%eax
 b3b:	eb 13                	jmp    b50 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b40:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b46:	8b 00                	mov    (%eax),%eax
 b48:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b4b:	e9 70 ff ff ff       	jmp    ac0 <malloc+0x4e>
}
 b50:	c9                   	leave  
 b51:	c3                   	ret    
