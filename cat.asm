
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 1b                	jmp    23 <cat+0x23>
    write(1, buf, n);
   8:	8b 45 f4             	mov    -0xc(%ebp),%eax
   b:	89 44 24 08          	mov    %eax,0x8(%esp)
   f:	c7 44 24 04 40 0f 00 	movl   $0xf40,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 f5 05 00 00       	call   618 <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  23:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2a:	00 
  2b:	c7 44 24 04 40 0f 00 	movl   $0xf40,0x4(%esp)
  32:	00 
  33:	8b 45 08             	mov    0x8(%ebp),%eax
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 d2 05 00 00       	call   610 <read>
  3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  45:	7f c1                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  4b:	79 19                	jns    66 <cat+0x66>
    printf(1, "cat: read error\n");
  4d:	c7 44 24 04 54 0b 00 	movl   $0xb54,0x4(%esp)
  54:	00 
  55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5c:	e8 27 07 00 00       	call   788 <printf>
    exit();
  61:	e8 92 05 00 00       	call   5f8 <exit>
  }
}
  66:	c9                   	leave  
  67:	c3                   	ret    

00000068 <main>:

int
main(int argc, char *argv[])
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	83 e4 f0             	and    $0xfffffff0,%esp
  6e:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
  71:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  75:	7f 11                	jg     88 <main+0x20>
    cat(0);
  77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  7e:	e8 7d ff ff ff       	call   0 <cat>
    exit();
  83:	e8 70 05 00 00       	call   5f8 <exit>
  }

  for(i = 1; i < argc; i++){
  88:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  8f:	00 
  90:	eb 79                	jmp    10b <main+0xa3>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  a0:	01 d0                	add    %edx,%eax
  a2:	8b 00                	mov    (%eax),%eax
  a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  ab:	00 
  ac:	89 04 24             	mov    %eax,(%esp)
  af:	e8 84 05 00 00       	call   638 <open>
  b4:	89 44 24 18          	mov    %eax,0x18(%esp)
  b8:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  bd:	79 2f                	jns    ee <main+0x86>
      printf(1, "cat: cannot open %s\n", argv[i]);
  bf:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	01 d0                	add    %edx,%eax
  cf:	8b 00                	mov    (%eax),%eax
  d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  d5:	c7 44 24 04 65 0b 00 	movl   $0xb65,0x4(%esp)
  dc:	00 
  dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e4:	e8 9f 06 00 00       	call   788 <printf>
      exit();
  e9:	e8 0a 05 00 00       	call   5f8 <exit>
    }
    cat(fd);
  ee:	8b 44 24 18          	mov    0x18(%esp),%eax
  f2:	89 04 24             	mov    %eax,(%esp)
  f5:	e8 06 ff ff ff       	call   0 <cat>
    close(fd);
  fa:	8b 44 24 18          	mov    0x18(%esp),%eax
  fe:	89 04 24             	mov    %eax,(%esp)
 101:	e8 1a 05 00 00       	call   620 <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
 106:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 10b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 10f:	3b 45 08             	cmp    0x8(%ebp),%eax
 112:	0f 8c 7a ff ff ff    	jl     92 <main+0x2a>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 118:	e8 db 04 00 00       	call   5f8 <exit>

0000011d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
 120:	57                   	push   %edi
 121:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 122:	8b 4d 08             	mov    0x8(%ebp),%ecx
 125:	8b 55 10             	mov    0x10(%ebp),%edx
 128:	8b 45 0c             	mov    0xc(%ebp),%eax
 12b:	89 cb                	mov    %ecx,%ebx
 12d:	89 df                	mov    %ebx,%edi
 12f:	89 d1                	mov    %edx,%ecx
 131:	fc                   	cld    
 132:	f3 aa                	rep stos %al,%es:(%edi)
 134:	89 ca                	mov    %ecx,%edx
 136:	89 fb                	mov    %edi,%ebx
 138:	89 5d 08             	mov    %ebx,0x8(%ebp)
 13b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 13e:	5b                   	pop    %ebx
 13f:	5f                   	pop    %edi
 140:	5d                   	pop    %ebp
 141:	c3                   	ret    

00000142 <thing>:
#include "user.h"
#include "x86.h"


int
thing(void){
 142:	55                   	push   %ebp
 143:	89 e5                	mov    %esp,%ebp
  return 1;
 145:	b8 01 00 00 00       	mov    $0x1,%eax
}
 14a:	5d                   	pop    %ebp
 14b:	c3                   	ret    

0000014c <strcpy>:

char*
strcpy(char *s, char *t)
{
 14c:	55                   	push   %ebp
 14d:	89 e5                	mov    %esp,%ebp
 14f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 152:	8b 45 08             	mov    0x8(%ebp),%eax
 155:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 158:	90                   	nop
 159:	8b 45 08             	mov    0x8(%ebp),%eax
 15c:	8d 50 01             	lea    0x1(%eax),%edx
 15f:	89 55 08             	mov    %edx,0x8(%ebp)
 162:	8b 55 0c             	mov    0xc(%ebp),%edx
 165:	8d 4a 01             	lea    0x1(%edx),%ecx
 168:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 16b:	0f b6 12             	movzbl (%edx),%edx
 16e:	88 10                	mov    %dl,(%eax)
 170:	0f b6 00             	movzbl (%eax),%eax
 173:	84 c0                	test   %al,%al
 175:	75 e2                	jne    159 <strcpy+0xd>
    ;
  return os;
 177:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 17a:	c9                   	leave  
 17b:	c3                   	ret    

0000017c <strcmp>:



int
strcmp(const char *p, const char *q)
{
 17c:	55                   	push   %ebp
 17d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 17f:	eb 08                	jmp    189 <strcmp+0xd>
    p++, q++;
 181:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 185:	83 45 0c 01          	addl   $0x1,0xc(%ebp)


int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	0f b6 00             	movzbl (%eax),%eax
 18f:	84 c0                	test   %al,%al
 191:	74 10                	je     1a3 <strcmp+0x27>
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	0f b6 10             	movzbl (%eax),%edx
 199:	8b 45 0c             	mov    0xc(%ebp),%eax
 19c:	0f b6 00             	movzbl (%eax),%eax
 19f:	38 c2                	cmp    %al,%dl
 1a1:	74 de                	je     181 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1a3:	8b 45 08             	mov    0x8(%ebp),%eax
 1a6:	0f b6 00             	movzbl (%eax),%eax
 1a9:	0f b6 d0             	movzbl %al,%edx
 1ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 1af:	0f b6 00             	movzbl (%eax),%eax
 1b2:	0f b6 c0             	movzbl %al,%eax
 1b5:	29 c2                	sub    %eax,%edx
 1b7:	89 d0                	mov    %edx,%eax
}
 1b9:	5d                   	pop    %ebp
 1ba:	c3                   	ret    

000001bb <strlen>:

uint
strlen(char *s)
{
 1bb:	55                   	push   %ebp
 1bc:	89 e5                	mov    %esp,%ebp
 1be:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1c8:	eb 04                	jmp    1ce <strlen+0x13>
 1ca:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1d1:	8b 45 08             	mov    0x8(%ebp),%eax
 1d4:	01 d0                	add    %edx,%eax
 1d6:	0f b6 00             	movzbl (%eax),%eax
 1d9:	84 c0                	test   %al,%al
 1db:	75 ed                	jne    1ca <strlen+0xf>
    ;
  return n;
 1dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1e0:	c9                   	leave  
 1e1:	c3                   	ret    

000001e2 <stringlen>:

uint
stringlen(char **s){
 1e2:	55                   	push   %ebp
 1e3:	89 e5                	mov    %esp,%ebp
 1e5:	83 ec 10             	sub    $0x10,%esp
	int n;

  for(n = 0; s[n]; n++)
 1e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1ef:	eb 04                	jmp    1f5 <stringlen+0x13>
 1f1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 1ff:	8b 45 08             	mov    0x8(%ebp),%eax
 202:	01 d0                	add    %edx,%eax
 204:	8b 00                	mov    (%eax),%eax
 206:	85 c0                	test   %eax,%eax
 208:	75 e7                	jne    1f1 <stringlen+0xf>
    ;
  return n;
 20a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 20d:	c9                   	leave  
 20e:	c3                   	ret    

0000020f <memset>:

void*
memset(void *dst, int c, uint n)
{
 20f:	55                   	push   %ebp
 210:	89 e5                	mov    %esp,%ebp
 212:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 215:	8b 45 10             	mov    0x10(%ebp),%eax
 218:	89 44 24 08          	mov    %eax,0x8(%esp)
 21c:	8b 45 0c             	mov    0xc(%ebp),%eax
 21f:	89 44 24 04          	mov    %eax,0x4(%esp)
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	89 04 24             	mov    %eax,(%esp)
 229:	e8 ef fe ff ff       	call   11d <stosb>
  return dst;
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 231:	c9                   	leave  
 232:	c3                   	ret    

00000233 <strchr>:

char*
strchr(const char *s, char c)
{
 233:	55                   	push   %ebp
 234:	89 e5                	mov    %esp,%ebp
 236:	83 ec 04             	sub    $0x4,%esp
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
 23c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 23f:	eb 14                	jmp    255 <strchr+0x22>
    if(*s == c)
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	0f b6 00             	movzbl (%eax),%eax
 247:	3a 45 fc             	cmp    -0x4(%ebp),%al
 24a:	75 05                	jne    251 <strchr+0x1e>
      return (char*)s;
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	eb 13                	jmp    264 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 251:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 255:	8b 45 08             	mov    0x8(%ebp),%eax
 258:	0f b6 00             	movzbl (%eax),%eax
 25b:	84 c0                	test   %al,%al
 25d:	75 e2                	jne    241 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 25f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 264:	c9                   	leave  
 265:	c3                   	ret    

00000266 <gets>:

char*
gets(char *buf, int max)
{
 266:	55                   	push   %ebp
 267:	89 e5                	mov    %esp,%ebp
 269:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 273:	eb 4c                	jmp    2c1 <gets+0x5b>
    cc = read(0, &c, 1);
 275:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 27c:	00 
 27d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 280:	89 44 24 04          	mov    %eax,0x4(%esp)
 284:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 28b:	e8 80 03 00 00       	call   610 <read>
 290:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 293:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 297:	7f 02                	jg     29b <gets+0x35>
      break;
 299:	eb 31                	jmp    2cc <gets+0x66>
    buf[i++] = c;
 29b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 29e:	8d 50 01             	lea    0x1(%eax),%edx
 2a1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2a4:	89 c2                	mov    %eax,%edx
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	01 c2                	add    %eax,%edx
 2ab:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2af:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2b1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2b5:	3c 0a                	cmp    $0xa,%al
 2b7:	74 13                	je     2cc <gets+0x66>
 2b9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2bd:	3c 0d                	cmp    $0xd,%al
 2bf:	74 0b                	je     2cc <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c4:	83 c0 01             	add    $0x1,%eax
 2c7:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2ca:	7c a9                	jl     275 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	01 d0                	add    %edx,%eax
 2d4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2da:	c9                   	leave  
 2db:	c3                   	ret    

000002dc <stat>:

int
stat(char *n, struct stat *st)
{
 2dc:	55                   	push   %ebp
 2dd:	89 e5                	mov    %esp,%ebp
 2df:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2e9:	00 
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
 2ed:	89 04 24             	mov    %eax,(%esp)
 2f0:	e8 43 03 00 00       	call   638 <open>
 2f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2fc:	79 07                	jns    305 <stat+0x29>
    return -1;
 2fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 303:	eb 23                	jmp    328 <stat+0x4c>
  r = fstat(fd, st);
 305:	8b 45 0c             	mov    0xc(%ebp),%eax
 308:	89 44 24 04          	mov    %eax,0x4(%esp)
 30c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 30f:	89 04 24             	mov    %eax,(%esp)
 312:	e8 39 03 00 00       	call   650 <fstat>
 317:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 31a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31d:	89 04 24             	mov    %eax,(%esp)
 320:	e8 fb 02 00 00       	call   620 <close>
  return r;
 325:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 328:	c9                   	leave  
 329:	c3                   	ret    

0000032a <atoi>:

int
atoi(const char *s)
{
 32a:	55                   	push   %ebp
 32b:	89 e5                	mov    %esp,%ebp
 32d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 330:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 337:	eb 25                	jmp    35e <atoi+0x34>
    n = n*10 + *s++ - '0';
 339:	8b 55 fc             	mov    -0x4(%ebp),%edx
 33c:	89 d0                	mov    %edx,%eax
 33e:	c1 e0 02             	shl    $0x2,%eax
 341:	01 d0                	add    %edx,%eax
 343:	01 c0                	add    %eax,%eax
 345:	89 c1                	mov    %eax,%ecx
 347:	8b 45 08             	mov    0x8(%ebp),%eax
 34a:	8d 50 01             	lea    0x1(%eax),%edx
 34d:	89 55 08             	mov    %edx,0x8(%ebp)
 350:	0f b6 00             	movzbl (%eax),%eax
 353:	0f be c0             	movsbl %al,%eax
 356:	01 c8                	add    %ecx,%eax
 358:	83 e8 30             	sub    $0x30,%eax
 35b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 35e:	8b 45 08             	mov    0x8(%ebp),%eax
 361:	0f b6 00             	movzbl (%eax),%eax
 364:	3c 2f                	cmp    $0x2f,%al
 366:	7e 0a                	jle    372 <atoi+0x48>
 368:	8b 45 08             	mov    0x8(%ebp),%eax
 36b:	0f b6 00             	movzbl (%eax),%eax
 36e:	3c 39                	cmp    $0x39,%al
 370:	7e c7                	jle    339 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 372:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 375:	c9                   	leave  
 376:	c3                   	ret    

00000377 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 377:	55                   	push   %ebp
 378:	89 e5                	mov    %esp,%ebp
 37a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 37d:	8b 45 08             	mov    0x8(%ebp),%eax
 380:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 383:	8b 45 0c             	mov    0xc(%ebp),%eax
 386:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 389:	eb 17                	jmp    3a2 <memmove+0x2b>
    *dst++ = *src++;
 38b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 38e:	8d 50 01             	lea    0x1(%eax),%edx
 391:	89 55 fc             	mov    %edx,-0x4(%ebp)
 394:	8b 55 f8             	mov    -0x8(%ebp),%edx
 397:	8d 4a 01             	lea    0x1(%edx),%ecx
 39a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 39d:	0f b6 12             	movzbl (%edx),%edx
 3a0:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3a2:	8b 45 10             	mov    0x10(%ebp),%eax
 3a5:	8d 50 ff             	lea    -0x1(%eax),%edx
 3a8:	89 55 10             	mov    %edx,0x10(%ebp)
 3ab:	85 c0                	test   %eax,%eax
 3ad:	7f dc                	jg     38b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3af:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3b2:	c9                   	leave  
 3b3:	c3                   	ret    

000003b4 <strcmp_c>:


int
strcmp_c(const char *s1, const char *s2)
{
 3b4:	55                   	push   %ebp
 3b5:	89 e5                	mov    %esp,%ebp
    for ( ; *s1 == *s2; s1++, s2++)
 3b7:	eb 19                	jmp    3d2 <strcmp_c+0x1e>
	if (*s1 == '\0')
 3b9:	8b 45 08             	mov    0x8(%ebp),%eax
 3bc:	0f b6 00             	movzbl (%eax),%eax
 3bf:	84 c0                	test   %al,%al
 3c1:	75 07                	jne    3ca <strcmp_c+0x16>
	    return 0;
 3c3:	b8 00 00 00 00       	mov    $0x0,%eax
 3c8:	eb 34                	jmp    3fe <strcmp_c+0x4a>


int
strcmp_c(const char *s1, const char *s2)
{
    for ( ; *s1 == *s2; s1++, s2++)
 3ca:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3ce:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 3d2:	8b 45 08             	mov    0x8(%ebp),%eax
 3d5:	0f b6 10             	movzbl (%eax),%edx
 3d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3db:	0f b6 00             	movzbl (%eax),%eax
 3de:	38 c2                	cmp    %al,%dl
 3e0:	74 d7                	je     3b9 <strcmp_c+0x5>
	if (*s1 == '\0')
	    return 0;
    return ((*(unsigned char *)s1 < *(unsigned char *)s2) ? -1 : +1);
 3e2:	8b 45 08             	mov    0x8(%ebp),%eax
 3e5:	0f b6 10             	movzbl (%eax),%edx
 3e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3eb:	0f b6 00             	movzbl (%eax),%eax
 3ee:	38 c2                	cmp    %al,%dl
 3f0:	73 07                	jae    3f9 <strcmp_c+0x45>
 3f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3f7:	eb 05                	jmp    3fe <strcmp_c+0x4a>
 3f9:	b8 01 00 00 00       	mov    $0x1,%eax
}
 3fe:	5d                   	pop    %ebp
 3ff:	c3                   	ret    

00000400 <readuser>:


struct USER
readuser(){
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char buff1[512], buff2[512];
	struct USER u;
	printf(1,"Please enter a username: ");
 409:	c7 44 24 04 7a 0b 00 	movl   $0xb7a,0x4(%esp)
 410:	00 
 411:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 418:	e8 6b 03 00 00       	call   788 <printf>
	u.name = gets(buff1, 50);
 41d:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 424:	00 
 425:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
 42b:	89 04 24             	mov    %eax,(%esp)
 42e:	e8 33 fe ff ff       	call   266 <gets>
 433:	89 85 ec fb ff ff    	mov    %eax,-0x414(%ebp)
	printf(1,"Please enter a password: ");
 439:	c7 44 24 04 94 0b 00 	movl   $0xb94,0x4(%esp)
 440:	00 
 441:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 448:	e8 3b 03 00 00       	call   788 <printf>
	u.pass = gets(buff2, 50);
 44d:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 454:	00 
 455:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
 45b:	89 04 24             	mov    %eax,(%esp)
 45e:	e8 03 fe ff ff       	call   266 <gets>
 463:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
	return u;
 469:	8b 45 08             	mov    0x8(%ebp),%eax
 46c:	8b 95 ec fb ff ff    	mov    -0x414(%ebp),%edx
 472:	89 10                	mov    %edx,(%eax)
 474:	8b 95 f0 fb ff ff    	mov    -0x410(%ebp),%edx
 47a:	89 50 04             	mov    %edx,0x4(%eax)
 47d:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
 483:	89 50 08             	mov    %edx,0x8(%eax)
}
 486:	8b 45 08             	mov    0x8(%ebp),%eax
 489:	c9                   	leave  
 48a:	c2 04 00             	ret    $0x4

0000048d <compareuser>:


int
compareuser(int state){
 48d:	55                   	push   %ebp
 48e:	89 e5                	mov    %esp,%ebp
 490:	56                   	push   %esi
 491:	53                   	push   %ebx
 492:	81 ec 30 01 00 00    	sub    $0x130,%esp
	struct USER u1,u2;
	struct USER users[20];
	u1.name = "john\n";
 498:	c7 45 e8 ae 0b 00 00 	movl   $0xbae,-0x18(%ebp)
	u1.pass = "1234\n";
 49f:	c7 45 ec b4 0b 00 00 	movl   $0xbb4,-0x14(%ebp)
	u1.ulevel = 0;
 4a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	u2.name = "james\n";
 4ad:	c7 45 dc ba 0b 00 00 	movl   $0xbba,-0x24(%ebp)
	u2.pass = "pass\n";
 4b4:	c7 45 e0 c1 0b 00 00 	movl   $0xbc1,-0x20(%ebp)
	u2.ulevel = 1;
 4bb:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	users[0] = u1;
 4c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c5:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
 4cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ce:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
 4d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4d7:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
	users[1] = u2;
 4dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
 4e0:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
 4e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
 4e9:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
 4ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4f2:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
	
	
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
 4f8:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
 4fe:	89 04 24             	mov    %eax,(%esp)
 501:	e8 fa fe ff ff       	call   400 <readuser>
 506:	83 ec 04             	sub    $0x4,%esp
		
		for(ctr = 0; ctr < 20; ctr++)
 509:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 510:	e9 a4 00 00 00       	jmp    5b9 <compareuser+0x12c>
		{

			if(strcmp_c(u.name,users[ctr].name) == 0 && strcmp_c(u.pass,users[ctr].pass) == 0)
 515:	8b 55 f4             	mov    -0xc(%ebp),%edx
 518:	89 d0                	mov    %edx,%eax
 51a:	01 c0                	add    %eax,%eax
 51c:	01 d0                	add    %edx,%eax
 51e:	c1 e0 02             	shl    $0x2,%eax
 521:	8d 4d f8             	lea    -0x8(%ebp),%ecx
 524:	01 c8                	add    %ecx,%eax
 526:	2d 0c 01 00 00       	sub    $0x10c,%eax
 52b:	8b 10                	mov    (%eax),%edx
 52d:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
 533:	89 54 24 04          	mov    %edx,0x4(%esp)
 537:	89 04 24             	mov    %eax,(%esp)
 53a:	e8 75 fe ff ff       	call   3b4 <strcmp_c>
 53f:	85 c0                	test   %eax,%eax
 541:	75 72                	jne    5b5 <compareuser+0x128>
 543:	8b 55 f4             	mov    -0xc(%ebp),%edx
 546:	89 d0                	mov    %edx,%eax
 548:	01 c0                	add    %eax,%eax
 54a:	01 d0                	add    %edx,%eax
 54c:	c1 e0 02             	shl    $0x2,%eax
 54f:	8d 5d f8             	lea    -0x8(%ebp),%ebx
 552:	01 d8                	add    %ebx,%eax
 554:	2d 08 01 00 00       	sub    $0x108,%eax
 559:	8b 10                	mov    (%eax),%edx
 55b:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
 561:	89 54 24 04          	mov    %edx,0x4(%esp)
 565:	89 04 24             	mov    %eax,(%esp)
 568:	e8 47 fe ff ff       	call   3b4 <strcmp_c>
 56d:	85 c0                	test   %eax,%eax
 56f:	75 44                	jne    5b5 <compareuser+0x128>
			{
				setuser(users[ctr].ulevel);
 571:	8b 55 f4             	mov    -0xc(%ebp),%edx
 574:	89 d0                	mov    %edx,%eax
 576:	01 c0                	add    %eax,%eax
 578:	01 d0                	add    %edx,%eax
 57a:	c1 e0 02             	shl    $0x2,%eax
 57d:	8d 75 f8             	lea    -0x8(%ebp),%esi
 580:	01 f0                	add    %esi,%eax
 582:	2d 04 01 00 00       	sub    $0x104,%eax
 587:	8b 00                	mov    (%eax),%eax
 589:	89 04 24             	mov    %eax,(%esp)
 58c:	e8 0f 01 00 00       	call   6a0 <setuser>
				
				printf(1,"%d",getuser());
 591:	e8 02 01 00 00       	call   698 <getuser>
 596:	89 44 24 08          	mov    %eax,0x8(%esp)
 59a:	c7 44 24 04 c7 0b 00 	movl   $0xbc7,0x4(%esp)
 5a1:	00 
 5a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5a9:	e8 da 01 00 00       	call   788 <printf>
				return 1;
 5ae:	b8 01 00 00 00       	mov    $0x1,%eax
 5b3:	eb 34                	jmp    5e9 <compareuser+0x15c>
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
		
		for(ctr = 0; ctr < 20; ctr++)
 5b5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 5b9:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 5bd:	0f 8e 52 ff ff ff    	jle    515 <compareuser+0x88>
				
				printf(1,"%d",getuser());
				return 1;
			}
		}
		printf(1,"Invalid username/password\n");
 5c3:	c7 44 24 04 ca 0b 00 	movl   $0xbca,0x4(%esp)
 5ca:	00 
 5cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5d2:	e8 b1 01 00 00       	call   788 <printf>
		if(state != 1)
 5d7:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 5db:	74 07                	je     5e4 <compareuser+0x157>
			break;
	}
	return 0;
 5dd:	b8 00 00 00 00       	mov    $0x0,%eax
 5e2:	eb 05                	jmp    5e9 <compareuser+0x15c>
			}
		}
		printf(1,"Invalid username/password\n");
		if(state != 1)
			break;
	}
 5e4:	e9 0f ff ff ff       	jmp    4f8 <compareuser+0x6b>
	return 0;
}
 5e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
 5ec:	5b                   	pop    %ebx
 5ed:	5e                   	pop    %esi
 5ee:	5d                   	pop    %ebp
 5ef:	c3                   	ret    

000005f0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5f0:	b8 01 00 00 00       	mov    $0x1,%eax
 5f5:	cd 40                	int    $0x40
 5f7:	c3                   	ret    

000005f8 <exit>:
SYSCALL(exit)
 5f8:	b8 02 00 00 00       	mov    $0x2,%eax
 5fd:	cd 40                	int    $0x40
 5ff:	c3                   	ret    

00000600 <wait>:
SYSCALL(wait)
 600:	b8 03 00 00 00       	mov    $0x3,%eax
 605:	cd 40                	int    $0x40
 607:	c3                   	ret    

00000608 <pipe>:
SYSCALL(pipe)
 608:	b8 04 00 00 00       	mov    $0x4,%eax
 60d:	cd 40                	int    $0x40
 60f:	c3                   	ret    

00000610 <read>:
SYSCALL(read)
 610:	b8 05 00 00 00       	mov    $0x5,%eax
 615:	cd 40                	int    $0x40
 617:	c3                   	ret    

00000618 <write>:
SYSCALL(write)
 618:	b8 10 00 00 00       	mov    $0x10,%eax
 61d:	cd 40                	int    $0x40
 61f:	c3                   	ret    

00000620 <close>:
SYSCALL(close)
 620:	b8 15 00 00 00       	mov    $0x15,%eax
 625:	cd 40                	int    $0x40
 627:	c3                   	ret    

00000628 <kill>:
SYSCALL(kill)
 628:	b8 06 00 00 00       	mov    $0x6,%eax
 62d:	cd 40                	int    $0x40
 62f:	c3                   	ret    

00000630 <exec>:
SYSCALL(exec)
 630:	b8 07 00 00 00       	mov    $0x7,%eax
 635:	cd 40                	int    $0x40
 637:	c3                   	ret    

00000638 <open>:
SYSCALL(open)
 638:	b8 0f 00 00 00       	mov    $0xf,%eax
 63d:	cd 40                	int    $0x40
 63f:	c3                   	ret    

00000640 <mknod>:
SYSCALL(mknod)
 640:	b8 11 00 00 00       	mov    $0x11,%eax
 645:	cd 40                	int    $0x40
 647:	c3                   	ret    

00000648 <unlink>:
SYSCALL(unlink)
 648:	b8 12 00 00 00       	mov    $0x12,%eax
 64d:	cd 40                	int    $0x40
 64f:	c3                   	ret    

00000650 <fstat>:
SYSCALL(fstat)
 650:	b8 08 00 00 00       	mov    $0x8,%eax
 655:	cd 40                	int    $0x40
 657:	c3                   	ret    

00000658 <link>:
SYSCALL(link)
 658:	b8 13 00 00 00       	mov    $0x13,%eax
 65d:	cd 40                	int    $0x40
 65f:	c3                   	ret    

00000660 <mkdir>:
SYSCALL(mkdir)
 660:	b8 14 00 00 00       	mov    $0x14,%eax
 665:	cd 40                	int    $0x40
 667:	c3                   	ret    

00000668 <chdir>:
SYSCALL(chdir)
 668:	b8 09 00 00 00       	mov    $0x9,%eax
 66d:	cd 40                	int    $0x40
 66f:	c3                   	ret    

00000670 <dup>:
SYSCALL(dup)
 670:	b8 0a 00 00 00       	mov    $0xa,%eax
 675:	cd 40                	int    $0x40
 677:	c3                   	ret    

00000678 <getpid>:
SYSCALL(getpid)
 678:	b8 0b 00 00 00       	mov    $0xb,%eax
 67d:	cd 40                	int    $0x40
 67f:	c3                   	ret    

00000680 <sbrk>:
SYSCALL(sbrk)
 680:	b8 0c 00 00 00       	mov    $0xc,%eax
 685:	cd 40                	int    $0x40
 687:	c3                   	ret    

00000688 <sleep>:
SYSCALL(sleep)
 688:	b8 0d 00 00 00       	mov    $0xd,%eax
 68d:	cd 40                	int    $0x40
 68f:	c3                   	ret    

00000690 <uptime>:
SYSCALL(uptime)
 690:	b8 0e 00 00 00       	mov    $0xe,%eax
 695:	cd 40                	int    $0x40
 697:	c3                   	ret    

00000698 <getuser>:
SYSCALL(getuser)
 698:	b8 16 00 00 00       	mov    $0x16,%eax
 69d:	cd 40                	int    $0x40
 69f:	c3                   	ret    

000006a0 <setuser>:
SYSCALL(setuser)
 6a0:	b8 17 00 00 00       	mov    $0x17,%eax
 6a5:	cd 40                	int    $0x40
 6a7:	c3                   	ret    

000006a8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6a8:	55                   	push   %ebp
 6a9:	89 e5                	mov    %esp,%ebp
 6ab:	83 ec 18             	sub    $0x18,%esp
 6ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6b4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6bb:	00 
 6bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6bf:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c3:	8b 45 08             	mov    0x8(%ebp),%eax
 6c6:	89 04 24             	mov    %eax,(%esp)
 6c9:	e8 4a ff ff ff       	call   618 <write>
}
 6ce:	c9                   	leave  
 6cf:	c3                   	ret    

000006d0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	56                   	push   %esi
 6d4:	53                   	push   %ebx
 6d5:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6df:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6e3:	74 17                	je     6fc <printint+0x2c>
 6e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6e9:	79 11                	jns    6fc <printint+0x2c>
    neg = 1;
 6eb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f5:	f7 d8                	neg    %eax
 6f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6fa:	eb 06                	jmp    702 <printint+0x32>
  } else {
    x = xx;
 6fc:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 702:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 709:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 70c:	8d 41 01             	lea    0x1(%ecx),%eax
 70f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 712:	8b 5d 10             	mov    0x10(%ebp),%ebx
 715:	8b 45 ec             	mov    -0x14(%ebp),%eax
 718:	ba 00 00 00 00       	mov    $0x0,%edx
 71d:	f7 f3                	div    %ebx
 71f:	89 d0                	mov    %edx,%eax
 721:	0f b6 80 fc 0e 00 00 	movzbl 0xefc(%eax),%eax
 728:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 72c:	8b 75 10             	mov    0x10(%ebp),%esi
 72f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 732:	ba 00 00 00 00       	mov    $0x0,%edx
 737:	f7 f6                	div    %esi
 739:	89 45 ec             	mov    %eax,-0x14(%ebp)
 73c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 740:	75 c7                	jne    709 <printint+0x39>
  if(neg)
 742:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 746:	74 10                	je     758 <printint+0x88>
    buf[i++] = '-';
 748:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74b:	8d 50 01             	lea    0x1(%eax),%edx
 74e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 751:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 756:	eb 1f                	jmp    777 <printint+0xa7>
 758:	eb 1d                	jmp    777 <printint+0xa7>
    putc(fd, buf[i]);
 75a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 75d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 760:	01 d0                	add    %edx,%eax
 762:	0f b6 00             	movzbl (%eax),%eax
 765:	0f be c0             	movsbl %al,%eax
 768:	89 44 24 04          	mov    %eax,0x4(%esp)
 76c:	8b 45 08             	mov    0x8(%ebp),%eax
 76f:	89 04 24             	mov    %eax,(%esp)
 772:	e8 31 ff ff ff       	call   6a8 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 777:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 77b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 77f:	79 d9                	jns    75a <printint+0x8a>
    putc(fd, buf[i]);
}
 781:	83 c4 30             	add    $0x30,%esp
 784:	5b                   	pop    %ebx
 785:	5e                   	pop    %esi
 786:	5d                   	pop    %ebp
 787:	c3                   	ret    

00000788 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 788:	55                   	push   %ebp
 789:	89 e5                	mov    %esp,%ebp
 78b:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 78e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 795:	8d 45 0c             	lea    0xc(%ebp),%eax
 798:	83 c0 04             	add    $0x4,%eax
 79b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 79e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7a5:	e9 7c 01 00 00       	jmp    926 <printf+0x19e>
    c = fmt[i] & 0xff;
 7aa:	8b 55 0c             	mov    0xc(%ebp),%edx
 7ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b0:	01 d0                	add    %edx,%eax
 7b2:	0f b6 00             	movzbl (%eax),%eax
 7b5:	0f be c0             	movsbl %al,%eax
 7b8:	25 ff 00 00 00       	and    $0xff,%eax
 7bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7c4:	75 2c                	jne    7f2 <printf+0x6a>
      if(c == '%'){
 7c6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7ca:	75 0c                	jne    7d8 <printf+0x50>
        state = '%';
 7cc:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7d3:	e9 4a 01 00 00       	jmp    922 <printf+0x19a>
      } else {
        putc(fd, c);
 7d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7db:	0f be c0             	movsbl %al,%eax
 7de:	89 44 24 04          	mov    %eax,0x4(%esp)
 7e2:	8b 45 08             	mov    0x8(%ebp),%eax
 7e5:	89 04 24             	mov    %eax,(%esp)
 7e8:	e8 bb fe ff ff       	call   6a8 <putc>
 7ed:	e9 30 01 00 00       	jmp    922 <printf+0x19a>
      }
    } else if(state == '%'){
 7f2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7f6:	0f 85 26 01 00 00    	jne    922 <printf+0x19a>
      if(c == 'd'){
 7fc:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 800:	75 2d                	jne    82f <printf+0xa7>
        printint(fd, *ap, 10, 1);
 802:	8b 45 e8             	mov    -0x18(%ebp),%eax
 805:	8b 00                	mov    (%eax),%eax
 807:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 80e:	00 
 80f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 816:	00 
 817:	89 44 24 04          	mov    %eax,0x4(%esp)
 81b:	8b 45 08             	mov    0x8(%ebp),%eax
 81e:	89 04 24             	mov    %eax,(%esp)
 821:	e8 aa fe ff ff       	call   6d0 <printint>
        ap++;
 826:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 82a:	e9 ec 00 00 00       	jmp    91b <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 82f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 833:	74 06                	je     83b <printf+0xb3>
 835:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 839:	75 2d                	jne    868 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 83b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 83e:	8b 00                	mov    (%eax),%eax
 840:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 847:	00 
 848:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 84f:	00 
 850:	89 44 24 04          	mov    %eax,0x4(%esp)
 854:	8b 45 08             	mov    0x8(%ebp),%eax
 857:	89 04 24             	mov    %eax,(%esp)
 85a:	e8 71 fe ff ff       	call   6d0 <printint>
        ap++;
 85f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 863:	e9 b3 00 00 00       	jmp    91b <printf+0x193>
      } else if(c == 's'){
 868:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 86c:	75 45                	jne    8b3 <printf+0x12b>
        s = (char*)*ap;
 86e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 871:	8b 00                	mov    (%eax),%eax
 873:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 876:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 87a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 87e:	75 09                	jne    889 <printf+0x101>
          s = "(null)";
 880:	c7 45 f4 e5 0b 00 00 	movl   $0xbe5,-0xc(%ebp)
        while(*s != 0){
 887:	eb 1e                	jmp    8a7 <printf+0x11f>
 889:	eb 1c                	jmp    8a7 <printf+0x11f>
          putc(fd, *s);
 88b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88e:	0f b6 00             	movzbl (%eax),%eax
 891:	0f be c0             	movsbl %al,%eax
 894:	89 44 24 04          	mov    %eax,0x4(%esp)
 898:	8b 45 08             	mov    0x8(%ebp),%eax
 89b:	89 04 24             	mov    %eax,(%esp)
 89e:	e8 05 fe ff ff       	call   6a8 <putc>
          s++;
 8a3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8aa:	0f b6 00             	movzbl (%eax),%eax
 8ad:	84 c0                	test   %al,%al
 8af:	75 da                	jne    88b <printf+0x103>
 8b1:	eb 68                	jmp    91b <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8b3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 8b7:	75 1d                	jne    8d6 <printf+0x14e>
        putc(fd, *ap);
 8b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8bc:	8b 00                	mov    (%eax),%eax
 8be:	0f be c0             	movsbl %al,%eax
 8c1:	89 44 24 04          	mov    %eax,0x4(%esp)
 8c5:	8b 45 08             	mov    0x8(%ebp),%eax
 8c8:	89 04 24             	mov    %eax,(%esp)
 8cb:	e8 d8 fd ff ff       	call   6a8 <putc>
        ap++;
 8d0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8d4:	eb 45                	jmp    91b <printf+0x193>
      } else if(c == '%'){
 8d6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8da:	75 17                	jne    8f3 <printf+0x16b>
        putc(fd, c);
 8dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8df:	0f be c0             	movsbl %al,%eax
 8e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 8e6:	8b 45 08             	mov    0x8(%ebp),%eax
 8e9:	89 04 24             	mov    %eax,(%esp)
 8ec:	e8 b7 fd ff ff       	call   6a8 <putc>
 8f1:	eb 28                	jmp    91b <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8f3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8fa:	00 
 8fb:	8b 45 08             	mov    0x8(%ebp),%eax
 8fe:	89 04 24             	mov    %eax,(%esp)
 901:	e8 a2 fd ff ff       	call   6a8 <putc>
        putc(fd, c);
 906:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 909:	0f be c0             	movsbl %al,%eax
 90c:	89 44 24 04          	mov    %eax,0x4(%esp)
 910:	8b 45 08             	mov    0x8(%ebp),%eax
 913:	89 04 24             	mov    %eax,(%esp)
 916:	e8 8d fd ff ff       	call   6a8 <putc>
      }
      state = 0;
 91b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 922:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 926:	8b 55 0c             	mov    0xc(%ebp),%edx
 929:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92c:	01 d0                	add    %edx,%eax
 92e:	0f b6 00             	movzbl (%eax),%eax
 931:	84 c0                	test   %al,%al
 933:	0f 85 71 fe ff ff    	jne    7aa <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 939:	c9                   	leave  
 93a:	c3                   	ret    

0000093b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 93b:	55                   	push   %ebp
 93c:	89 e5                	mov    %esp,%ebp
 93e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 941:	8b 45 08             	mov    0x8(%ebp),%eax
 944:	83 e8 08             	sub    $0x8,%eax
 947:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 94a:	a1 28 0f 00 00       	mov    0xf28,%eax
 94f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 952:	eb 24                	jmp    978 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 954:	8b 45 fc             	mov    -0x4(%ebp),%eax
 957:	8b 00                	mov    (%eax),%eax
 959:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 95c:	77 12                	ja     970 <free+0x35>
 95e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 961:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 964:	77 24                	ja     98a <free+0x4f>
 966:	8b 45 fc             	mov    -0x4(%ebp),%eax
 969:	8b 00                	mov    (%eax),%eax
 96b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 96e:	77 1a                	ja     98a <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 970:	8b 45 fc             	mov    -0x4(%ebp),%eax
 973:	8b 00                	mov    (%eax),%eax
 975:	89 45 fc             	mov    %eax,-0x4(%ebp)
 978:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 97e:	76 d4                	jbe    954 <free+0x19>
 980:	8b 45 fc             	mov    -0x4(%ebp),%eax
 983:	8b 00                	mov    (%eax),%eax
 985:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 988:	76 ca                	jbe    954 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 98a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98d:	8b 40 04             	mov    0x4(%eax),%eax
 990:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 997:	8b 45 f8             	mov    -0x8(%ebp),%eax
 99a:	01 c2                	add    %eax,%edx
 99c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99f:	8b 00                	mov    (%eax),%eax
 9a1:	39 c2                	cmp    %eax,%edx
 9a3:	75 24                	jne    9c9 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 9a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a8:	8b 50 04             	mov    0x4(%eax),%edx
 9ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ae:	8b 00                	mov    (%eax),%eax
 9b0:	8b 40 04             	mov    0x4(%eax),%eax
 9b3:	01 c2                	add    %eax,%edx
 9b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b8:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 9bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9be:	8b 00                	mov    (%eax),%eax
 9c0:	8b 10                	mov    (%eax),%edx
 9c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c5:	89 10                	mov    %edx,(%eax)
 9c7:	eb 0a                	jmp    9d3 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cc:	8b 10                	mov    (%eax),%edx
 9ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d1:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d6:	8b 40 04             	mov    0x4(%eax),%eax
 9d9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e3:	01 d0                	add    %edx,%eax
 9e5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9e8:	75 20                	jne    a0a <free+0xcf>
    p->s.size += bp->s.size;
 9ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ed:	8b 50 04             	mov    0x4(%eax),%edx
 9f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f3:	8b 40 04             	mov    0x4(%eax),%eax
 9f6:	01 c2                	add    %eax,%edx
 9f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9fb:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a01:	8b 10                	mov    (%eax),%edx
 a03:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a06:	89 10                	mov    %edx,(%eax)
 a08:	eb 08                	jmp    a12 <free+0xd7>
  } else
    p->s.ptr = bp;
 a0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a0d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a10:	89 10                	mov    %edx,(%eax)
  freep = p;
 a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a15:	a3 28 0f 00 00       	mov    %eax,0xf28
}
 a1a:	c9                   	leave  
 a1b:	c3                   	ret    

00000a1c <morecore>:

static Header*
morecore(uint nu)
{
 a1c:	55                   	push   %ebp
 a1d:	89 e5                	mov    %esp,%ebp
 a1f:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a22:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a29:	77 07                	ja     a32 <morecore+0x16>
    nu = 4096;
 a2b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a32:	8b 45 08             	mov    0x8(%ebp),%eax
 a35:	c1 e0 03             	shl    $0x3,%eax
 a38:	89 04 24             	mov    %eax,(%esp)
 a3b:	e8 40 fc ff ff       	call   680 <sbrk>
 a40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a43:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a47:	75 07                	jne    a50 <morecore+0x34>
    return 0;
 a49:	b8 00 00 00 00       	mov    $0x0,%eax
 a4e:	eb 22                	jmp    a72 <morecore+0x56>
  hp = (Header*)p;
 a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a59:	8b 55 08             	mov    0x8(%ebp),%edx
 a5c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a62:	83 c0 08             	add    $0x8,%eax
 a65:	89 04 24             	mov    %eax,(%esp)
 a68:	e8 ce fe ff ff       	call   93b <free>
  return freep;
 a6d:	a1 28 0f 00 00       	mov    0xf28,%eax
}
 a72:	c9                   	leave  
 a73:	c3                   	ret    

00000a74 <malloc>:

void*
malloc(uint nbytes)
{
 a74:	55                   	push   %ebp
 a75:	89 e5                	mov    %esp,%ebp
 a77:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a7a:	8b 45 08             	mov    0x8(%ebp),%eax
 a7d:	83 c0 07             	add    $0x7,%eax
 a80:	c1 e8 03             	shr    $0x3,%eax
 a83:	83 c0 01             	add    $0x1,%eax
 a86:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a89:	a1 28 0f 00 00       	mov    0xf28,%eax
 a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a95:	75 23                	jne    aba <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a97:	c7 45 f0 20 0f 00 00 	movl   $0xf20,-0x10(%ebp)
 a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa1:	a3 28 0f 00 00       	mov    %eax,0xf28
 aa6:	a1 28 0f 00 00       	mov    0xf28,%eax
 aab:	a3 20 0f 00 00       	mov    %eax,0xf20
    base.s.size = 0;
 ab0:	c7 05 24 0f 00 00 00 	movl   $0x0,0xf24
 ab7:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 abd:	8b 00                	mov    (%eax),%eax
 abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac5:	8b 40 04             	mov    0x4(%eax),%eax
 ac8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 acb:	72 4d                	jb     b1a <malloc+0xa6>
      if(p->s.size == nunits)
 acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad0:	8b 40 04             	mov    0x4(%eax),%eax
 ad3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ad6:	75 0c                	jne    ae4 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 adb:	8b 10                	mov    (%eax),%edx
 add:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ae0:	89 10                	mov    %edx,(%eax)
 ae2:	eb 26                	jmp    b0a <malloc+0x96>
      else {
        p->s.size -= nunits;
 ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae7:	8b 40 04             	mov    0x4(%eax),%eax
 aea:	2b 45 ec             	sub    -0x14(%ebp),%eax
 aed:	89 c2                	mov    %eax,%edx
 aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af8:	8b 40 04             	mov    0x4(%eax),%eax
 afb:	c1 e0 03             	shl    $0x3,%eax
 afe:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b04:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b07:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b0d:	a3 28 0f 00 00       	mov    %eax,0xf28
      return (void*)(p + 1);
 b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b15:	83 c0 08             	add    $0x8,%eax
 b18:	eb 38                	jmp    b52 <malloc+0xde>
    }
    if(p == freep)
 b1a:	a1 28 0f 00 00       	mov    0xf28,%eax
 b1f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b22:	75 1b                	jne    b3f <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 b24:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b27:	89 04 24             	mov    %eax,(%esp)
 b2a:	e8 ed fe ff ff       	call   a1c <morecore>
 b2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b36:	75 07                	jne    b3f <malloc+0xcb>
        return 0;
 b38:	b8 00 00 00 00       	mov    $0x0,%eax
 b3d:	eb 13                	jmp    b52 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b42:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b48:	8b 00                	mov    (%eax),%eax
 b4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b4d:	e9 70 ff ff ff       	jmp    ac2 <malloc+0x4e>
}
 b52:	c9                   	leave  
 b53:	c3                   	ret    
