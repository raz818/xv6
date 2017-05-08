
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <printf>:

#define N  1000

void
printf(int fd, char *s, ...)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  write(fd, s, strlen(s));
   6:	8b 45 0c             	mov    0xc(%ebp),%eax
   9:	89 04 24             	mov    %eax,(%esp)
   c:	e8 a2 01 00 00       	call   1b3 <strlen>
  11:	89 44 24 08          	mov    %eax,0x8(%esp)
  15:	8b 45 0c             	mov    0xc(%ebp),%eax
  18:	89 44 24 04          	mov    %eax,0x4(%esp)
  1c:	8b 45 08             	mov    0x8(%ebp),%eax
  1f:	89 04 24             	mov    %eax,(%esp)
  22:	e8 e9 05 00 00       	call   610 <write>
}
  27:	c9                   	leave  
  28:	c3                   	ret    

00000029 <forktest>:

void
forktest(void)
{
  29:	55                   	push   %ebp
  2a:	89 e5                	mov    %esp,%ebp
  2c:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
  2f:	c7 44 24 04 a0 06 00 	movl   $0x6a0,0x4(%esp)
  36:	00 
  37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3e:	e8 bd ff ff ff       	call   0 <printf>

  for(n=0; n<N; n++){
  43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  4a:	eb 1f                	jmp    6b <forktest+0x42>
    pid = fork();
  4c:	e8 97 05 00 00       	call   5e8 <fork>
  51:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
  54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  58:	79 02                	jns    5c <forktest+0x33>
      break;
  5a:	eb 18                	jmp    74 <forktest+0x4b>
    if(pid == 0)
  5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  60:	75 05                	jne    67 <forktest+0x3e>
      exit();
  62:	e8 89 05 00 00       	call   5f0 <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<N; n++){
  67:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  6b:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  72:	7e d8                	jle    4c <forktest+0x23>
      break;
    if(pid == 0)
      exit();
  }
  
  if(n == N){
  74:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
  7b:	75 21                	jne    9e <forktest+0x75>
    printf(1, "fork claimed to work N times!\n", N);
  7d:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
  84:	00 
  85:	c7 44 24 04 ac 06 00 	movl   $0x6ac,0x4(%esp)
  8c:	00 
  8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  94:	e8 67 ff ff ff       	call   0 <printf>
    exit();
  99:	e8 52 05 00 00       	call   5f0 <exit>
  }
  
  for(; n > 0; n--){
  9e:	eb 26                	jmp    c6 <forktest+0x9d>
    if(wait() < 0){
  a0:	e8 53 05 00 00       	call   5f8 <wait>
  a5:	85 c0                	test   %eax,%eax
  a7:	79 19                	jns    c2 <forktest+0x99>
      printf(1, "wait stopped early\n");
  a9:	c7 44 24 04 cb 06 00 	movl   $0x6cb,0x4(%esp)
  b0:	00 
  b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b8:	e8 43 ff ff ff       	call   0 <printf>
      exit();
  bd:	e8 2e 05 00 00       	call   5f0 <exit>
  if(n == N){
    printf(1, "fork claimed to work N times!\n", N);
    exit();
  }
  
  for(; n > 0; n--){
  c2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  ca:	7f d4                	jg     a0 <forktest+0x77>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
  cc:	e8 27 05 00 00       	call   5f8 <wait>
  d1:	83 f8 ff             	cmp    $0xffffffff,%eax
  d4:	74 19                	je     ef <forktest+0xc6>
    printf(1, "wait got too many\n");
  d6:	c7 44 24 04 df 06 00 	movl   $0x6df,0x4(%esp)
  dd:	00 
  de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e5:	e8 16 ff ff ff       	call   0 <printf>
    exit();
  ea:	e8 01 05 00 00       	call   5f0 <exit>
  }
  
  printf(1, "fork test OK\n");
  ef:	c7 44 24 04 f2 06 00 	movl   $0x6f2,0x4(%esp)
  f6:	00 
  f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fe:	e8 fd fe ff ff       	call   0 <printf>
}
 103:	c9                   	leave  
 104:	c3                   	ret    

00000105 <main>:

int
main(void)
{
 105:	55                   	push   %ebp
 106:	89 e5                	mov    %esp,%ebp
 108:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
 10b:	e8 19 ff ff ff       	call   29 <forktest>
  exit();
 110:	e8 db 04 00 00       	call   5f0 <exit>

00000115 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 115:	55                   	push   %ebp
 116:	89 e5                	mov    %esp,%ebp
 118:	57                   	push   %edi
 119:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 11a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11d:	8b 55 10             	mov    0x10(%ebp),%edx
 120:	8b 45 0c             	mov    0xc(%ebp),%eax
 123:	89 cb                	mov    %ecx,%ebx
 125:	89 df                	mov    %ebx,%edi
 127:	89 d1                	mov    %edx,%ecx
 129:	fc                   	cld    
 12a:	f3 aa                	rep stos %al,%es:(%edi)
 12c:	89 ca                	mov    %ecx,%edx
 12e:	89 fb                	mov    %edi,%ebx
 130:	89 5d 08             	mov    %ebx,0x8(%ebp)
 133:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 136:	5b                   	pop    %ebx
 137:	5f                   	pop    %edi
 138:	5d                   	pop    %ebp
 139:	c3                   	ret    

0000013a <thing>:
#include "user.h"
#include "x86.h"


int
thing(void){
 13a:	55                   	push   %ebp
 13b:	89 e5                	mov    %esp,%ebp
  return 1;
 13d:	b8 01 00 00 00       	mov    $0x1,%eax
}
 142:	5d                   	pop    %ebp
 143:	c3                   	ret    

00000144 <strcpy>:

char*
strcpy(char *s, char *t)
{
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
 147:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 14a:	8b 45 08             	mov    0x8(%ebp),%eax
 14d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 150:	90                   	nop
 151:	8b 45 08             	mov    0x8(%ebp),%eax
 154:	8d 50 01             	lea    0x1(%eax),%edx
 157:	89 55 08             	mov    %edx,0x8(%ebp)
 15a:	8b 55 0c             	mov    0xc(%ebp),%edx
 15d:	8d 4a 01             	lea    0x1(%edx),%ecx
 160:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 163:	0f b6 12             	movzbl (%edx),%edx
 166:	88 10                	mov    %dl,(%eax)
 168:	0f b6 00             	movzbl (%eax),%eax
 16b:	84 c0                	test   %al,%al
 16d:	75 e2                	jne    151 <strcpy+0xd>
    ;
  return os;
 16f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 172:	c9                   	leave  
 173:	c3                   	ret    

00000174 <strcmp>:



int
strcmp(const char *p, const char *q)
{
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 177:	eb 08                	jmp    181 <strcmp+0xd>
    p++, q++;
 179:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)


int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 181:	8b 45 08             	mov    0x8(%ebp),%eax
 184:	0f b6 00             	movzbl (%eax),%eax
 187:	84 c0                	test   %al,%al
 189:	74 10                	je     19b <strcmp+0x27>
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	0f b6 10             	movzbl (%eax),%edx
 191:	8b 45 0c             	mov    0xc(%ebp),%eax
 194:	0f b6 00             	movzbl (%eax),%eax
 197:	38 c2                	cmp    %al,%dl
 199:	74 de                	je     179 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 19b:	8b 45 08             	mov    0x8(%ebp),%eax
 19e:	0f b6 00             	movzbl (%eax),%eax
 1a1:	0f b6 d0             	movzbl %al,%edx
 1a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a7:	0f b6 00             	movzbl (%eax),%eax
 1aa:	0f b6 c0             	movzbl %al,%eax
 1ad:	29 c2                	sub    %eax,%edx
 1af:	89 d0                	mov    %edx,%eax
}
 1b1:	5d                   	pop    %ebp
 1b2:	c3                   	ret    

000001b3 <strlen>:

uint
strlen(char *s)
{
 1b3:	55                   	push   %ebp
 1b4:	89 e5                	mov    %esp,%ebp
 1b6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1c0:	eb 04                	jmp    1c6 <strlen+0x13>
 1c2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1c9:	8b 45 08             	mov    0x8(%ebp),%eax
 1cc:	01 d0                	add    %edx,%eax
 1ce:	0f b6 00             	movzbl (%eax),%eax
 1d1:	84 c0                	test   %al,%al
 1d3:	75 ed                	jne    1c2 <strlen+0xf>
    ;
  return n;
 1d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1d8:	c9                   	leave  
 1d9:	c3                   	ret    

000001da <stringlen>:

uint
stringlen(char **s){
 1da:	55                   	push   %ebp
 1db:	89 e5                	mov    %esp,%ebp
 1dd:	83 ec 10             	sub    $0x10,%esp
	int n;

  for(n = 0; s[n]; n++)
 1e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1e7:	eb 04                	jmp    1ed <stringlen+0x13>
 1e9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
 1fa:	01 d0                	add    %edx,%eax
 1fc:	8b 00                	mov    (%eax),%eax
 1fe:	85 c0                	test   %eax,%eax
 200:	75 e7                	jne    1e9 <stringlen+0xf>
    ;
  return n;
 202:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 205:	c9                   	leave  
 206:	c3                   	ret    

00000207 <memset>:

void*
memset(void *dst, int c, uint n)
{
 207:	55                   	push   %ebp
 208:	89 e5                	mov    %esp,%ebp
 20a:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 20d:	8b 45 10             	mov    0x10(%ebp),%eax
 210:	89 44 24 08          	mov    %eax,0x8(%esp)
 214:	8b 45 0c             	mov    0xc(%ebp),%eax
 217:	89 44 24 04          	mov    %eax,0x4(%esp)
 21b:	8b 45 08             	mov    0x8(%ebp),%eax
 21e:	89 04 24             	mov    %eax,(%esp)
 221:	e8 ef fe ff ff       	call   115 <stosb>
  return dst;
 226:	8b 45 08             	mov    0x8(%ebp),%eax
}
 229:	c9                   	leave  
 22a:	c3                   	ret    

0000022b <strchr>:

char*
strchr(const char *s, char c)
{
 22b:	55                   	push   %ebp
 22c:	89 e5                	mov    %esp,%ebp
 22e:	83 ec 04             	sub    $0x4,%esp
 231:	8b 45 0c             	mov    0xc(%ebp),%eax
 234:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 237:	eb 14                	jmp    24d <strchr+0x22>
    if(*s == c)
 239:	8b 45 08             	mov    0x8(%ebp),%eax
 23c:	0f b6 00             	movzbl (%eax),%eax
 23f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 242:	75 05                	jne    249 <strchr+0x1e>
      return (char*)s;
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	eb 13                	jmp    25c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 249:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 24d:	8b 45 08             	mov    0x8(%ebp),%eax
 250:	0f b6 00             	movzbl (%eax),%eax
 253:	84 c0                	test   %al,%al
 255:	75 e2                	jne    239 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 257:	b8 00 00 00 00       	mov    $0x0,%eax
}
 25c:	c9                   	leave  
 25d:	c3                   	ret    

0000025e <gets>:

char*
gets(char *buf, int max)
{
 25e:	55                   	push   %ebp
 25f:	89 e5                	mov    %esp,%ebp
 261:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 264:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 26b:	eb 4c                	jmp    2b9 <gets+0x5b>
    cc = read(0, &c, 1);
 26d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 274:	00 
 275:	8d 45 ef             	lea    -0x11(%ebp),%eax
 278:	89 44 24 04          	mov    %eax,0x4(%esp)
 27c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 283:	e8 80 03 00 00       	call   608 <read>
 288:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 28b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 28f:	7f 02                	jg     293 <gets+0x35>
      break;
 291:	eb 31                	jmp    2c4 <gets+0x66>
    buf[i++] = c;
 293:	8b 45 f4             	mov    -0xc(%ebp),%eax
 296:	8d 50 01             	lea    0x1(%eax),%edx
 299:	89 55 f4             	mov    %edx,-0xc(%ebp)
 29c:	89 c2                	mov    %eax,%edx
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
 2a1:	01 c2                	add    %eax,%edx
 2a3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2a9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2ad:	3c 0a                	cmp    $0xa,%al
 2af:	74 13                	je     2c4 <gets+0x66>
 2b1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2b5:	3c 0d                	cmp    $0xd,%al
 2b7:	74 0b                	je     2c4 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2bc:	83 c0 01             	add    $0x1,%eax
 2bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2c2:	7c a9                	jl     26d <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ca:	01 d0                	add    %edx,%eax
 2cc:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d2:	c9                   	leave  
 2d3:	c3                   	ret    

000002d4 <stat>:

int
stat(char *n, struct stat *st)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2da:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2e1:	00 
 2e2:	8b 45 08             	mov    0x8(%ebp),%eax
 2e5:	89 04 24             	mov    %eax,(%esp)
 2e8:	e8 43 03 00 00       	call   630 <open>
 2ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2f4:	79 07                	jns    2fd <stat+0x29>
    return -1;
 2f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2fb:	eb 23                	jmp    320 <stat+0x4c>
  r = fstat(fd, st);
 2fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 300:	89 44 24 04          	mov    %eax,0x4(%esp)
 304:	8b 45 f4             	mov    -0xc(%ebp),%eax
 307:	89 04 24             	mov    %eax,(%esp)
 30a:	e8 39 03 00 00       	call   648 <fstat>
 30f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 312:	8b 45 f4             	mov    -0xc(%ebp),%eax
 315:	89 04 24             	mov    %eax,(%esp)
 318:	e8 fb 02 00 00       	call   618 <close>
  return r;
 31d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 320:	c9                   	leave  
 321:	c3                   	ret    

00000322 <atoi>:

int
atoi(const char *s)
{
 322:	55                   	push   %ebp
 323:	89 e5                	mov    %esp,%ebp
 325:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 328:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 32f:	eb 25                	jmp    356 <atoi+0x34>
    n = n*10 + *s++ - '0';
 331:	8b 55 fc             	mov    -0x4(%ebp),%edx
 334:	89 d0                	mov    %edx,%eax
 336:	c1 e0 02             	shl    $0x2,%eax
 339:	01 d0                	add    %edx,%eax
 33b:	01 c0                	add    %eax,%eax
 33d:	89 c1                	mov    %eax,%ecx
 33f:	8b 45 08             	mov    0x8(%ebp),%eax
 342:	8d 50 01             	lea    0x1(%eax),%edx
 345:	89 55 08             	mov    %edx,0x8(%ebp)
 348:	0f b6 00             	movzbl (%eax),%eax
 34b:	0f be c0             	movsbl %al,%eax
 34e:	01 c8                	add    %ecx,%eax
 350:	83 e8 30             	sub    $0x30,%eax
 353:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 356:	8b 45 08             	mov    0x8(%ebp),%eax
 359:	0f b6 00             	movzbl (%eax),%eax
 35c:	3c 2f                	cmp    $0x2f,%al
 35e:	7e 0a                	jle    36a <atoi+0x48>
 360:	8b 45 08             	mov    0x8(%ebp),%eax
 363:	0f b6 00             	movzbl (%eax),%eax
 366:	3c 39                	cmp    $0x39,%al
 368:	7e c7                	jle    331 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 36a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 36d:	c9                   	leave  
 36e:	c3                   	ret    

0000036f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 36f:	55                   	push   %ebp
 370:	89 e5                	mov    %esp,%ebp
 372:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 375:	8b 45 08             	mov    0x8(%ebp),%eax
 378:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 37b:	8b 45 0c             	mov    0xc(%ebp),%eax
 37e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 381:	eb 17                	jmp    39a <memmove+0x2b>
    *dst++ = *src++;
 383:	8b 45 fc             	mov    -0x4(%ebp),%eax
 386:	8d 50 01             	lea    0x1(%eax),%edx
 389:	89 55 fc             	mov    %edx,-0x4(%ebp)
 38c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 38f:	8d 4a 01             	lea    0x1(%edx),%ecx
 392:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 395:	0f b6 12             	movzbl (%edx),%edx
 398:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 39a:	8b 45 10             	mov    0x10(%ebp),%eax
 39d:	8d 50 ff             	lea    -0x1(%eax),%edx
 3a0:	89 55 10             	mov    %edx,0x10(%ebp)
 3a3:	85 c0                	test   %eax,%eax
 3a5:	7f dc                	jg     383 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3aa:	c9                   	leave  
 3ab:	c3                   	ret    

000003ac <strcmp_c>:


int
strcmp_c(const char *s1, const char *s2)
{
 3ac:	55                   	push   %ebp
 3ad:	89 e5                	mov    %esp,%ebp
    for ( ; *s1 == *s2; s1++, s2++)
 3af:	eb 19                	jmp    3ca <strcmp_c+0x1e>
	if (*s1 == '\0')
 3b1:	8b 45 08             	mov    0x8(%ebp),%eax
 3b4:	0f b6 00             	movzbl (%eax),%eax
 3b7:	84 c0                	test   %al,%al
 3b9:	75 07                	jne    3c2 <strcmp_c+0x16>
	    return 0;
 3bb:	b8 00 00 00 00       	mov    $0x0,%eax
 3c0:	eb 34                	jmp    3f6 <strcmp_c+0x4a>


int
strcmp_c(const char *s1, const char *s2)
{
    for ( ; *s1 == *s2; s1++, s2++)
 3c2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3c6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 3ca:	8b 45 08             	mov    0x8(%ebp),%eax
 3cd:	0f b6 10             	movzbl (%eax),%edx
 3d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d3:	0f b6 00             	movzbl (%eax),%eax
 3d6:	38 c2                	cmp    %al,%dl
 3d8:	74 d7                	je     3b1 <strcmp_c+0x5>
	if (*s1 == '\0')
	    return 0;
    return ((*(unsigned char *)s1 < *(unsigned char *)s2) ? -1 : +1);
 3da:	8b 45 08             	mov    0x8(%ebp),%eax
 3dd:	0f b6 10             	movzbl (%eax),%edx
 3e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e3:	0f b6 00             	movzbl (%eax),%eax
 3e6:	38 c2                	cmp    %al,%dl
 3e8:	73 07                	jae    3f1 <strcmp_c+0x45>
 3ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3ef:	eb 05                	jmp    3f6 <strcmp_c+0x4a>
 3f1:	b8 01 00 00 00       	mov    $0x1,%eax
}
 3f6:	5d                   	pop    %ebp
 3f7:	c3                   	ret    

000003f8 <readuser>:


struct USER
readuser(){
 3f8:	55                   	push   %ebp
 3f9:	89 e5                	mov    %esp,%ebp
 3fb:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char buff1[512], buff2[512];
	struct USER u;
	printf(1,"Please enter a username: ");
 401:	c7 44 24 04 00 07 00 	movl   $0x700,0x4(%esp)
 408:	00 
 409:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 410:	e8 eb fb ff ff       	call   0 <printf>
	u.name = gets(buff1, 50);
 415:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 41c:	00 
 41d:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
 423:	89 04 24             	mov    %eax,(%esp)
 426:	e8 33 fe ff ff       	call   25e <gets>
 42b:	89 85 ec fb ff ff    	mov    %eax,-0x414(%ebp)
	printf(1,"Please enter a password: ");
 431:	c7 44 24 04 1a 07 00 	movl   $0x71a,0x4(%esp)
 438:	00 
 439:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 440:	e8 bb fb ff ff       	call   0 <printf>
	u.pass = gets(buff2, 50);
 445:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 44c:	00 
 44d:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
 453:	89 04 24             	mov    %eax,(%esp)
 456:	e8 03 fe ff ff       	call   25e <gets>
 45b:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
	return u;
 461:	8b 45 08             	mov    0x8(%ebp),%eax
 464:	8b 95 ec fb ff ff    	mov    -0x414(%ebp),%edx
 46a:	89 10                	mov    %edx,(%eax)
 46c:	8b 95 f0 fb ff ff    	mov    -0x410(%ebp),%edx
 472:	89 50 04             	mov    %edx,0x4(%eax)
 475:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
 47b:	89 50 08             	mov    %edx,0x8(%eax)
}
 47e:	8b 45 08             	mov    0x8(%ebp),%eax
 481:	c9                   	leave  
 482:	c2 04 00             	ret    $0x4

00000485 <compareuser>:


int
compareuser(int state){
 485:	55                   	push   %ebp
 486:	89 e5                	mov    %esp,%ebp
 488:	56                   	push   %esi
 489:	53                   	push   %ebx
 48a:	81 ec 30 01 00 00    	sub    $0x130,%esp
	struct USER u1,u2;
	struct USER users[20];
	u1.name = "john\n";
 490:	c7 45 e8 34 07 00 00 	movl   $0x734,-0x18(%ebp)
	u1.pass = "1234\n";
 497:	c7 45 ec 3a 07 00 00 	movl   $0x73a,-0x14(%ebp)
	u1.ulevel = 0;
 49e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	u2.name = "james\n";
 4a5:	c7 45 dc 40 07 00 00 	movl   $0x740,-0x24(%ebp)
	u2.pass = "pass\n";
 4ac:	c7 45 e0 47 07 00 00 	movl   $0x747,-0x20(%ebp)
	u2.ulevel = 1;
 4b3:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	users[0] = u1;
 4ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4bd:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
 4c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c6:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
 4cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4cf:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
	users[1] = u2;
 4d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
 4d8:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
 4de:	8b 45 e0             	mov    -0x20(%ebp),%eax
 4e1:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
 4e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ea:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
	
	
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
 4f0:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
 4f6:	89 04 24             	mov    %eax,(%esp)
 4f9:	e8 fa fe ff ff       	call   3f8 <readuser>
 4fe:	83 ec 04             	sub    $0x4,%esp
		
		for(ctr = 0; ctr < 20; ctr++)
 501:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 508:	e9 a4 00 00 00       	jmp    5b1 <compareuser+0x12c>
		{

			if(strcmp_c(u.name,users[ctr].name) == 0 && strcmp_c(u.pass,users[ctr].pass) == 0)
 50d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 510:	89 d0                	mov    %edx,%eax
 512:	01 c0                	add    %eax,%eax
 514:	01 d0                	add    %edx,%eax
 516:	c1 e0 02             	shl    $0x2,%eax
 519:	8d 4d f8             	lea    -0x8(%ebp),%ecx
 51c:	01 c8                	add    %ecx,%eax
 51e:	2d 0c 01 00 00       	sub    $0x10c,%eax
 523:	8b 10                	mov    (%eax),%edx
 525:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
 52b:	89 54 24 04          	mov    %edx,0x4(%esp)
 52f:	89 04 24             	mov    %eax,(%esp)
 532:	e8 75 fe ff ff       	call   3ac <strcmp_c>
 537:	85 c0                	test   %eax,%eax
 539:	75 72                	jne    5ad <compareuser+0x128>
 53b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 53e:	89 d0                	mov    %edx,%eax
 540:	01 c0                	add    %eax,%eax
 542:	01 d0                	add    %edx,%eax
 544:	c1 e0 02             	shl    $0x2,%eax
 547:	8d 5d f8             	lea    -0x8(%ebp),%ebx
 54a:	01 d8                	add    %ebx,%eax
 54c:	2d 08 01 00 00       	sub    $0x108,%eax
 551:	8b 10                	mov    (%eax),%edx
 553:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
 559:	89 54 24 04          	mov    %edx,0x4(%esp)
 55d:	89 04 24             	mov    %eax,(%esp)
 560:	e8 47 fe ff ff       	call   3ac <strcmp_c>
 565:	85 c0                	test   %eax,%eax
 567:	75 44                	jne    5ad <compareuser+0x128>
			{
				setuser(users[ctr].ulevel);
 569:	8b 55 f4             	mov    -0xc(%ebp),%edx
 56c:	89 d0                	mov    %edx,%eax
 56e:	01 c0                	add    %eax,%eax
 570:	01 d0                	add    %edx,%eax
 572:	c1 e0 02             	shl    $0x2,%eax
 575:	8d 75 f8             	lea    -0x8(%ebp),%esi
 578:	01 f0                	add    %esi,%eax
 57a:	2d 04 01 00 00       	sub    $0x104,%eax
 57f:	8b 00                	mov    (%eax),%eax
 581:	89 04 24             	mov    %eax,(%esp)
 584:	e8 0f 01 00 00       	call   698 <setuser>
				
				printf(1,"%d",getuser());
 589:	e8 02 01 00 00       	call   690 <getuser>
 58e:	89 44 24 08          	mov    %eax,0x8(%esp)
 592:	c7 44 24 04 4d 07 00 	movl   $0x74d,0x4(%esp)
 599:	00 
 59a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5a1:	e8 5a fa ff ff       	call   0 <printf>
				return 1;
 5a6:	b8 01 00 00 00       	mov    $0x1,%eax
 5ab:	eb 34                	jmp    5e1 <compareuser+0x15c>
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
		
		for(ctr = 0; ctr < 20; ctr++)
 5ad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 5b1:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 5b5:	0f 8e 52 ff ff ff    	jle    50d <compareuser+0x88>
				
				printf(1,"%d",getuser());
				return 1;
			}
		}
		printf(1,"Invalid username/password\n");
 5bb:	c7 44 24 04 50 07 00 	movl   $0x750,0x4(%esp)
 5c2:	00 
 5c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5ca:	e8 31 fa ff ff       	call   0 <printf>
		if(state != 1)
 5cf:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 5d3:	74 07                	je     5dc <compareuser+0x157>
			break;
	}
	return 0;
 5d5:	b8 00 00 00 00       	mov    $0x0,%eax
 5da:	eb 05                	jmp    5e1 <compareuser+0x15c>
			}
		}
		printf(1,"Invalid username/password\n");
		if(state != 1)
			break;
	}
 5dc:	e9 0f ff ff ff       	jmp    4f0 <compareuser+0x6b>
	return 0;
}
 5e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
 5e4:	5b                   	pop    %ebx
 5e5:	5e                   	pop    %esi
 5e6:	5d                   	pop    %ebp
 5e7:	c3                   	ret    

000005e8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5e8:	b8 01 00 00 00       	mov    $0x1,%eax
 5ed:	cd 40                	int    $0x40
 5ef:	c3                   	ret    

000005f0 <exit>:
SYSCALL(exit)
 5f0:	b8 02 00 00 00       	mov    $0x2,%eax
 5f5:	cd 40                	int    $0x40
 5f7:	c3                   	ret    

000005f8 <wait>:
SYSCALL(wait)
 5f8:	b8 03 00 00 00       	mov    $0x3,%eax
 5fd:	cd 40                	int    $0x40
 5ff:	c3                   	ret    

00000600 <pipe>:
SYSCALL(pipe)
 600:	b8 04 00 00 00       	mov    $0x4,%eax
 605:	cd 40                	int    $0x40
 607:	c3                   	ret    

00000608 <read>:
SYSCALL(read)
 608:	b8 05 00 00 00       	mov    $0x5,%eax
 60d:	cd 40                	int    $0x40
 60f:	c3                   	ret    

00000610 <write>:
SYSCALL(write)
 610:	b8 10 00 00 00       	mov    $0x10,%eax
 615:	cd 40                	int    $0x40
 617:	c3                   	ret    

00000618 <close>:
SYSCALL(close)
 618:	b8 15 00 00 00       	mov    $0x15,%eax
 61d:	cd 40                	int    $0x40
 61f:	c3                   	ret    

00000620 <kill>:
SYSCALL(kill)
 620:	b8 06 00 00 00       	mov    $0x6,%eax
 625:	cd 40                	int    $0x40
 627:	c3                   	ret    

00000628 <exec>:
SYSCALL(exec)
 628:	b8 07 00 00 00       	mov    $0x7,%eax
 62d:	cd 40                	int    $0x40
 62f:	c3                   	ret    

00000630 <open>:
SYSCALL(open)
 630:	b8 0f 00 00 00       	mov    $0xf,%eax
 635:	cd 40                	int    $0x40
 637:	c3                   	ret    

00000638 <mknod>:
SYSCALL(mknod)
 638:	b8 11 00 00 00       	mov    $0x11,%eax
 63d:	cd 40                	int    $0x40
 63f:	c3                   	ret    

00000640 <unlink>:
SYSCALL(unlink)
 640:	b8 12 00 00 00       	mov    $0x12,%eax
 645:	cd 40                	int    $0x40
 647:	c3                   	ret    

00000648 <fstat>:
SYSCALL(fstat)
 648:	b8 08 00 00 00       	mov    $0x8,%eax
 64d:	cd 40                	int    $0x40
 64f:	c3                   	ret    

00000650 <link>:
SYSCALL(link)
 650:	b8 13 00 00 00       	mov    $0x13,%eax
 655:	cd 40                	int    $0x40
 657:	c3                   	ret    

00000658 <mkdir>:
SYSCALL(mkdir)
 658:	b8 14 00 00 00       	mov    $0x14,%eax
 65d:	cd 40                	int    $0x40
 65f:	c3                   	ret    

00000660 <chdir>:
SYSCALL(chdir)
 660:	b8 09 00 00 00       	mov    $0x9,%eax
 665:	cd 40                	int    $0x40
 667:	c3                   	ret    

00000668 <dup>:
SYSCALL(dup)
 668:	b8 0a 00 00 00       	mov    $0xa,%eax
 66d:	cd 40                	int    $0x40
 66f:	c3                   	ret    

00000670 <getpid>:
SYSCALL(getpid)
 670:	b8 0b 00 00 00       	mov    $0xb,%eax
 675:	cd 40                	int    $0x40
 677:	c3                   	ret    

00000678 <sbrk>:
SYSCALL(sbrk)
 678:	b8 0c 00 00 00       	mov    $0xc,%eax
 67d:	cd 40                	int    $0x40
 67f:	c3                   	ret    

00000680 <sleep>:
SYSCALL(sleep)
 680:	b8 0d 00 00 00       	mov    $0xd,%eax
 685:	cd 40                	int    $0x40
 687:	c3                   	ret    

00000688 <uptime>:
SYSCALL(uptime)
 688:	b8 0e 00 00 00       	mov    $0xe,%eax
 68d:	cd 40                	int    $0x40
 68f:	c3                   	ret    

00000690 <getuser>:
SYSCALL(getuser)
 690:	b8 16 00 00 00       	mov    $0x16,%eax
 695:	cd 40                	int    $0x40
 697:	c3                   	ret    

00000698 <setuser>:
SYSCALL(setuser)
 698:	b8 17 00 00 00       	mov    $0x17,%eax
 69d:	cd 40                	int    $0x40
 69f:	c3                   	ret    
