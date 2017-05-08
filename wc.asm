
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 48             	sub    $0x48,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 68                	jmp    8a <wc+0x8a>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 57                	jmp    82 <wc+0x82>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 00 10 00 00       	add    $0x1000,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 00 10 00 00       	add    $0x1000,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	89 44 24 04          	mov    %eax,0x4(%esp)
  54:	c7 04 24 10 0c 00 00 	movl   $0xc10,(%esp)
  5b:	e8 8f 02 00 00       	call   2ef <strchr>
  60:	85 c0                	test   %eax,%eax
  62:	74 09                	je     6d <wc+0x6d>
        inword = 0;
  64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6b:	eb 11                	jmp    7e <wc+0x7e>
      else if(!inword){
  6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  71:	75 0b                	jne    7e <wc+0x7e>
        w++;
  73:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  77:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  85:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  88:	7c a1                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  91:	00 
  92:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  99:	00 
  9a:	8b 45 08             	mov    0x8(%ebp),%eax
  9d:	89 04 24             	mov    %eax,(%esp)
  a0:	e8 27 06 00 00       	call   6cc <read>
  a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  ac:	0f 8f 70 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b6:	79 19                	jns    d1 <wc+0xd1>
    printf(1, "wc: read error\n");
  b8:	c7 44 24 04 16 0c 00 	movl   $0xc16,0x4(%esp)
  bf:	00 
  c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c7:	e8 78 07 00 00       	call   844 <printf>
    exit();
  cc:	e8 e3 05 00 00       	call   6b4 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  d4:	89 44 24 14          	mov    %eax,0x14(%esp)
  d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  db:	89 44 24 10          	mov    %eax,0x10(%esp)
  df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  ed:	c7 44 24 04 26 0c 00 	movl   $0xc26,0x4(%esp)
  f4:	00 
  f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fc:	e8 43 07 00 00       	call   844 <printf>
}
 101:	c9                   	leave  
 102:	c3                   	ret    

00000103 <main>:

int
main(int argc, char *argv[])
{
 103:	55                   	push   %ebp
 104:	89 e5                	mov    %esp,%ebp
 106:	83 e4 f0             	and    $0xfffffff0,%esp
 109:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
 10c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 110:	7f 19                	jg     12b <main+0x28>
    wc(0, "");
 112:	c7 44 24 04 33 0c 00 	movl   $0xc33,0x4(%esp)
 119:	00 
 11a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 121:	e8 da fe ff ff       	call   0 <wc>
    exit();
 126:	e8 89 05 00 00       	call   6b4 <exit>
  }

  for(i = 1; i < argc; i++){
 12b:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 132:	00 
 133:	e9 8f 00 00 00       	jmp    1c7 <main+0xc4>
    if((fd = open(argv[i], 0)) < 0){
 138:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 13c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 143:	8b 45 0c             	mov    0xc(%ebp),%eax
 146:	01 d0                	add    %edx,%eax
 148:	8b 00                	mov    (%eax),%eax
 14a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 151:	00 
 152:	89 04 24             	mov    %eax,(%esp)
 155:	e8 9a 05 00 00       	call   6f4 <open>
 15a:	89 44 24 18          	mov    %eax,0x18(%esp)
 15e:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 163:	79 2f                	jns    194 <main+0x91>
      printf(1, "wc: cannot open %s\n", argv[i]);
 165:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 169:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 170:	8b 45 0c             	mov    0xc(%ebp),%eax
 173:	01 d0                	add    %edx,%eax
 175:	8b 00                	mov    (%eax),%eax
 177:	89 44 24 08          	mov    %eax,0x8(%esp)
 17b:	c7 44 24 04 34 0c 00 	movl   $0xc34,0x4(%esp)
 182:	00 
 183:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 18a:	e8 b5 06 00 00       	call   844 <printf>
      exit();
 18f:	e8 20 05 00 00       	call   6b4 <exit>
    }
    wc(fd, argv[i]);
 194:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 198:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 19f:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a2:	01 d0                	add    %edx,%eax
 1a4:	8b 00                	mov    (%eax),%eax
 1a6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1aa:	8b 44 24 18          	mov    0x18(%esp),%eax
 1ae:	89 04 24             	mov    %eax,(%esp)
 1b1:	e8 4a fe ff ff       	call   0 <wc>
    close(fd);
 1b6:	8b 44 24 18          	mov    0x18(%esp),%eax
 1ba:	89 04 24             	mov    %eax,(%esp)
 1bd:	e8 1a 05 00 00       	call   6dc <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1c2:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1c7:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1cb:	3b 45 08             	cmp    0x8(%ebp),%eax
 1ce:	0f 8c 64 ff ff ff    	jl     138 <main+0x35>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1d4:	e8 db 04 00 00       	call   6b4 <exit>

000001d9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1d9:	55                   	push   %ebp
 1da:	89 e5                	mov    %esp,%ebp
 1dc:	57                   	push   %edi
 1dd:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1de:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1e1:	8b 55 10             	mov    0x10(%ebp),%edx
 1e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e7:	89 cb                	mov    %ecx,%ebx
 1e9:	89 df                	mov    %ebx,%edi
 1eb:	89 d1                	mov    %edx,%ecx
 1ed:	fc                   	cld    
 1ee:	f3 aa                	rep stos %al,%es:(%edi)
 1f0:	89 ca                	mov    %ecx,%edx
 1f2:	89 fb                	mov    %edi,%ebx
 1f4:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1f7:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1fa:	5b                   	pop    %ebx
 1fb:	5f                   	pop    %edi
 1fc:	5d                   	pop    %ebp
 1fd:	c3                   	ret    

000001fe <thing>:
#include "user.h"
#include "x86.h"


int
thing(void){
 1fe:	55                   	push   %ebp
 1ff:	89 e5                	mov    %esp,%ebp
  return 1;
 201:	b8 01 00 00 00       	mov    $0x1,%eax
}
 206:	5d                   	pop    %ebp
 207:	c3                   	ret    

00000208 <strcpy>:

char*
strcpy(char *s, char *t)
{
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
 20b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 214:	90                   	nop
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	8d 50 01             	lea    0x1(%eax),%edx
 21b:	89 55 08             	mov    %edx,0x8(%ebp)
 21e:	8b 55 0c             	mov    0xc(%ebp),%edx
 221:	8d 4a 01             	lea    0x1(%edx),%ecx
 224:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 227:	0f b6 12             	movzbl (%edx),%edx
 22a:	88 10                	mov    %dl,(%eax)
 22c:	0f b6 00             	movzbl (%eax),%eax
 22f:	84 c0                	test   %al,%al
 231:	75 e2                	jne    215 <strcpy+0xd>
    ;
  return os;
 233:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 236:	c9                   	leave  
 237:	c3                   	ret    

00000238 <strcmp>:



int
strcmp(const char *p, const char *q)
{
 238:	55                   	push   %ebp
 239:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 23b:	eb 08                	jmp    245 <strcmp+0xd>
    p++, q++;
 23d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 241:	83 45 0c 01          	addl   $0x1,0xc(%ebp)


int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 245:	8b 45 08             	mov    0x8(%ebp),%eax
 248:	0f b6 00             	movzbl (%eax),%eax
 24b:	84 c0                	test   %al,%al
 24d:	74 10                	je     25f <strcmp+0x27>
 24f:	8b 45 08             	mov    0x8(%ebp),%eax
 252:	0f b6 10             	movzbl (%eax),%edx
 255:	8b 45 0c             	mov    0xc(%ebp),%eax
 258:	0f b6 00             	movzbl (%eax),%eax
 25b:	38 c2                	cmp    %al,%dl
 25d:	74 de                	je     23d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	0f b6 00             	movzbl (%eax),%eax
 265:	0f b6 d0             	movzbl %al,%edx
 268:	8b 45 0c             	mov    0xc(%ebp),%eax
 26b:	0f b6 00             	movzbl (%eax),%eax
 26e:	0f b6 c0             	movzbl %al,%eax
 271:	29 c2                	sub    %eax,%edx
 273:	89 d0                	mov    %edx,%eax
}
 275:	5d                   	pop    %ebp
 276:	c3                   	ret    

00000277 <strlen>:

uint
strlen(char *s)
{
 277:	55                   	push   %ebp
 278:	89 e5                	mov    %esp,%ebp
 27a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 27d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 284:	eb 04                	jmp    28a <strlen+0x13>
 286:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 28a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
 290:	01 d0                	add    %edx,%eax
 292:	0f b6 00             	movzbl (%eax),%eax
 295:	84 c0                	test   %al,%al
 297:	75 ed                	jne    286 <strlen+0xf>
    ;
  return n;
 299:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29c:	c9                   	leave  
 29d:	c3                   	ret    

0000029e <stringlen>:

uint
stringlen(char **s){
 29e:	55                   	push   %ebp
 29f:	89 e5                	mov    %esp,%ebp
 2a1:	83 ec 10             	sub    $0x10,%esp
	int n;

  for(n = 0; s[n]; n++)
 2a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2ab:	eb 04                	jmp    2b1 <stringlen+0x13>
 2ad:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 2bb:	8b 45 08             	mov    0x8(%ebp),%eax
 2be:	01 d0                	add    %edx,%eax
 2c0:	8b 00                	mov    (%eax),%eax
 2c2:	85 c0                	test   %eax,%eax
 2c4:	75 e7                	jne    2ad <stringlen+0xf>
    ;
  return n;
 2c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2c9:	c9                   	leave  
 2ca:	c3                   	ret    

000002cb <memset>:

void*
memset(void *dst, int c, uint n)
{
 2cb:	55                   	push   %ebp
 2cc:	89 e5                	mov    %esp,%ebp
 2ce:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2d1:	8b 45 10             	mov    0x10(%ebp),%eax
 2d4:	89 44 24 08          	mov    %eax,0x8(%esp)
 2d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2db:	89 44 24 04          	mov    %eax,0x4(%esp)
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
 2e2:	89 04 24             	mov    %eax,(%esp)
 2e5:	e8 ef fe ff ff       	call   1d9 <stosb>
  return dst;
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ed:	c9                   	leave  
 2ee:	c3                   	ret    

000002ef <strchr>:

char*
strchr(const char *s, char c)
{
 2ef:	55                   	push   %ebp
 2f0:	89 e5                	mov    %esp,%ebp
 2f2:	83 ec 04             	sub    $0x4,%esp
 2f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f8:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2fb:	eb 14                	jmp    311 <strchr+0x22>
    if(*s == c)
 2fd:	8b 45 08             	mov    0x8(%ebp),%eax
 300:	0f b6 00             	movzbl (%eax),%eax
 303:	3a 45 fc             	cmp    -0x4(%ebp),%al
 306:	75 05                	jne    30d <strchr+0x1e>
      return (char*)s;
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	eb 13                	jmp    320 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 30d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 311:	8b 45 08             	mov    0x8(%ebp),%eax
 314:	0f b6 00             	movzbl (%eax),%eax
 317:	84 c0                	test   %al,%al
 319:	75 e2                	jne    2fd <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 31b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 320:	c9                   	leave  
 321:	c3                   	ret    

00000322 <gets>:

char*
gets(char *buf, int max)
{
 322:	55                   	push   %ebp
 323:	89 e5                	mov    %esp,%ebp
 325:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 32f:	eb 4c                	jmp    37d <gets+0x5b>
    cc = read(0, &c, 1);
 331:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 338:	00 
 339:	8d 45 ef             	lea    -0x11(%ebp),%eax
 33c:	89 44 24 04          	mov    %eax,0x4(%esp)
 340:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 347:	e8 80 03 00 00       	call   6cc <read>
 34c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 34f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 353:	7f 02                	jg     357 <gets+0x35>
      break;
 355:	eb 31                	jmp    388 <gets+0x66>
    buf[i++] = c;
 357:	8b 45 f4             	mov    -0xc(%ebp),%eax
 35a:	8d 50 01             	lea    0x1(%eax),%edx
 35d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 360:	89 c2                	mov    %eax,%edx
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	01 c2                	add    %eax,%edx
 367:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 36b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 36d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 371:	3c 0a                	cmp    $0xa,%al
 373:	74 13                	je     388 <gets+0x66>
 375:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 379:	3c 0d                	cmp    $0xd,%al
 37b:	74 0b                	je     388 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 37d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 380:	83 c0 01             	add    $0x1,%eax
 383:	3b 45 0c             	cmp    0xc(%ebp),%eax
 386:	7c a9                	jl     331 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 388:	8b 55 f4             	mov    -0xc(%ebp),%edx
 38b:	8b 45 08             	mov    0x8(%ebp),%eax
 38e:	01 d0                	add    %edx,%eax
 390:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 393:	8b 45 08             	mov    0x8(%ebp),%eax
}
 396:	c9                   	leave  
 397:	c3                   	ret    

00000398 <stat>:

int
stat(char *n, struct stat *st)
{
 398:	55                   	push   %ebp
 399:	89 e5                	mov    %esp,%ebp
 39b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 39e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3a5:	00 
 3a6:	8b 45 08             	mov    0x8(%ebp),%eax
 3a9:	89 04 24             	mov    %eax,(%esp)
 3ac:	e8 43 03 00 00       	call   6f4 <open>
 3b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3b8:	79 07                	jns    3c1 <stat+0x29>
    return -1;
 3ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3bf:	eb 23                	jmp    3e4 <stat+0x4c>
  r = fstat(fd, st);
 3c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 3c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3cb:	89 04 24             	mov    %eax,(%esp)
 3ce:	e8 39 03 00 00       	call   70c <fstat>
 3d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d9:	89 04 24             	mov    %eax,(%esp)
 3dc:	e8 fb 02 00 00       	call   6dc <close>
  return r;
 3e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3e4:	c9                   	leave  
 3e5:	c3                   	ret    

000003e6 <atoi>:

int
atoi(const char *s)
{
 3e6:	55                   	push   %ebp
 3e7:	89 e5                	mov    %esp,%ebp
 3e9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3f3:	eb 25                	jmp    41a <atoi+0x34>
    n = n*10 + *s++ - '0';
 3f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3f8:	89 d0                	mov    %edx,%eax
 3fa:	c1 e0 02             	shl    $0x2,%eax
 3fd:	01 d0                	add    %edx,%eax
 3ff:	01 c0                	add    %eax,%eax
 401:	89 c1                	mov    %eax,%ecx
 403:	8b 45 08             	mov    0x8(%ebp),%eax
 406:	8d 50 01             	lea    0x1(%eax),%edx
 409:	89 55 08             	mov    %edx,0x8(%ebp)
 40c:	0f b6 00             	movzbl (%eax),%eax
 40f:	0f be c0             	movsbl %al,%eax
 412:	01 c8                	add    %ecx,%eax
 414:	83 e8 30             	sub    $0x30,%eax
 417:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	0f b6 00             	movzbl (%eax),%eax
 420:	3c 2f                	cmp    $0x2f,%al
 422:	7e 0a                	jle    42e <atoi+0x48>
 424:	8b 45 08             	mov    0x8(%ebp),%eax
 427:	0f b6 00             	movzbl (%eax),%eax
 42a:	3c 39                	cmp    $0x39,%al
 42c:	7e c7                	jle    3f5 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 42e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 431:	c9                   	leave  
 432:	c3                   	ret    

00000433 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 433:	55                   	push   %ebp
 434:	89 e5                	mov    %esp,%ebp
 436:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 439:	8b 45 08             	mov    0x8(%ebp),%eax
 43c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 43f:	8b 45 0c             	mov    0xc(%ebp),%eax
 442:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 445:	eb 17                	jmp    45e <memmove+0x2b>
    *dst++ = *src++;
 447:	8b 45 fc             	mov    -0x4(%ebp),%eax
 44a:	8d 50 01             	lea    0x1(%eax),%edx
 44d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 450:	8b 55 f8             	mov    -0x8(%ebp),%edx
 453:	8d 4a 01             	lea    0x1(%edx),%ecx
 456:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 459:	0f b6 12             	movzbl (%edx),%edx
 45c:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 45e:	8b 45 10             	mov    0x10(%ebp),%eax
 461:	8d 50 ff             	lea    -0x1(%eax),%edx
 464:	89 55 10             	mov    %edx,0x10(%ebp)
 467:	85 c0                	test   %eax,%eax
 469:	7f dc                	jg     447 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 46b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 46e:	c9                   	leave  
 46f:	c3                   	ret    

00000470 <strcmp_c>:


int
strcmp_c(const char *s1, const char *s2)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
    for ( ; *s1 == *s2; s1++, s2++)
 473:	eb 19                	jmp    48e <strcmp_c+0x1e>
	if (*s1 == '\0')
 475:	8b 45 08             	mov    0x8(%ebp),%eax
 478:	0f b6 00             	movzbl (%eax),%eax
 47b:	84 c0                	test   %al,%al
 47d:	75 07                	jne    486 <strcmp_c+0x16>
	    return 0;
 47f:	b8 00 00 00 00       	mov    $0x0,%eax
 484:	eb 34                	jmp    4ba <strcmp_c+0x4a>


int
strcmp_c(const char *s1, const char *s2)
{
    for ( ; *s1 == *s2; s1++, s2++)
 486:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 48a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 48e:	8b 45 08             	mov    0x8(%ebp),%eax
 491:	0f b6 10             	movzbl (%eax),%edx
 494:	8b 45 0c             	mov    0xc(%ebp),%eax
 497:	0f b6 00             	movzbl (%eax),%eax
 49a:	38 c2                	cmp    %al,%dl
 49c:	74 d7                	je     475 <strcmp_c+0x5>
	if (*s1 == '\0')
	    return 0;
    return ((*(unsigned char *)s1 < *(unsigned char *)s2) ? -1 : +1);
 49e:	8b 45 08             	mov    0x8(%ebp),%eax
 4a1:	0f b6 10             	movzbl (%eax),%edx
 4a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a7:	0f b6 00             	movzbl (%eax),%eax
 4aa:	38 c2                	cmp    %al,%dl
 4ac:	73 07                	jae    4b5 <strcmp_c+0x45>
 4ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4b3:	eb 05                	jmp    4ba <strcmp_c+0x4a>
 4b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
 4ba:	5d                   	pop    %ebp
 4bb:	c3                   	ret    

000004bc <readuser>:


struct USER
readuser(){
 4bc:	55                   	push   %ebp
 4bd:	89 e5                	mov    %esp,%ebp
 4bf:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char buff1[512], buff2[512];
	struct USER u;
	printf(1,"Please enter a username: ");
 4c5:	c7 44 24 04 48 0c 00 	movl   $0xc48,0x4(%esp)
 4cc:	00 
 4cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4d4:	e8 6b 03 00 00       	call   844 <printf>
	u.name = gets(buff1, 50);
 4d9:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 4e0:	00 
 4e1:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
 4e7:	89 04 24             	mov    %eax,(%esp)
 4ea:	e8 33 fe ff ff       	call   322 <gets>
 4ef:	89 85 ec fb ff ff    	mov    %eax,-0x414(%ebp)
	printf(1,"Please enter a password: ");
 4f5:	c7 44 24 04 62 0c 00 	movl   $0xc62,0x4(%esp)
 4fc:	00 
 4fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 504:	e8 3b 03 00 00       	call   844 <printf>
	u.pass = gets(buff2, 50);
 509:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 510:	00 
 511:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
 517:	89 04 24             	mov    %eax,(%esp)
 51a:	e8 03 fe ff ff       	call   322 <gets>
 51f:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
	return u;
 525:	8b 45 08             	mov    0x8(%ebp),%eax
 528:	8b 95 ec fb ff ff    	mov    -0x414(%ebp),%edx
 52e:	89 10                	mov    %edx,(%eax)
 530:	8b 95 f0 fb ff ff    	mov    -0x410(%ebp),%edx
 536:	89 50 04             	mov    %edx,0x4(%eax)
 539:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
 53f:	89 50 08             	mov    %edx,0x8(%eax)
}
 542:	8b 45 08             	mov    0x8(%ebp),%eax
 545:	c9                   	leave  
 546:	c2 04 00             	ret    $0x4

00000549 <compareuser>:


int
compareuser(int state){
 549:	55                   	push   %ebp
 54a:	89 e5                	mov    %esp,%ebp
 54c:	56                   	push   %esi
 54d:	53                   	push   %ebx
 54e:	81 ec 30 01 00 00    	sub    $0x130,%esp
	struct USER u1,u2;
	struct USER users[20];
	u1.name = "john\n";
 554:	c7 45 e8 7c 0c 00 00 	movl   $0xc7c,-0x18(%ebp)
	u1.pass = "1234\n";
 55b:	c7 45 ec 82 0c 00 00 	movl   $0xc82,-0x14(%ebp)
	u1.ulevel = 0;
 562:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	u2.name = "james\n";
 569:	c7 45 dc 88 0c 00 00 	movl   $0xc88,-0x24(%ebp)
	u2.pass = "pass\n";
 570:	c7 45 e0 8f 0c 00 00 	movl   $0xc8f,-0x20(%ebp)
	u2.ulevel = 1;
 577:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	users[0] = u1;
 57e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 581:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
 587:	8b 45 ec             	mov    -0x14(%ebp),%eax
 58a:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
 590:	8b 45 f0             	mov    -0x10(%ebp),%eax
 593:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
	users[1] = u2;
 599:	8b 45 dc             	mov    -0x24(%ebp),%eax
 59c:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
 5a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
 5a5:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
 5ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ae:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
	
	
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
 5b4:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
 5ba:	89 04 24             	mov    %eax,(%esp)
 5bd:	e8 fa fe ff ff       	call   4bc <readuser>
 5c2:	83 ec 04             	sub    $0x4,%esp
		
		for(ctr = 0; ctr < 20; ctr++)
 5c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 5cc:	e9 a4 00 00 00       	jmp    675 <compareuser+0x12c>
		{

			if(strcmp_c(u.name,users[ctr].name) == 0 && strcmp_c(u.pass,users[ctr].pass) == 0)
 5d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 5d4:	89 d0                	mov    %edx,%eax
 5d6:	01 c0                	add    %eax,%eax
 5d8:	01 d0                	add    %edx,%eax
 5da:	c1 e0 02             	shl    $0x2,%eax
 5dd:	8d 4d f8             	lea    -0x8(%ebp),%ecx
 5e0:	01 c8                	add    %ecx,%eax
 5e2:	2d 0c 01 00 00       	sub    $0x10c,%eax
 5e7:	8b 10                	mov    (%eax),%edx
 5e9:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
 5ef:	89 54 24 04          	mov    %edx,0x4(%esp)
 5f3:	89 04 24             	mov    %eax,(%esp)
 5f6:	e8 75 fe ff ff       	call   470 <strcmp_c>
 5fb:	85 c0                	test   %eax,%eax
 5fd:	75 72                	jne    671 <compareuser+0x128>
 5ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
 602:	89 d0                	mov    %edx,%eax
 604:	01 c0                	add    %eax,%eax
 606:	01 d0                	add    %edx,%eax
 608:	c1 e0 02             	shl    $0x2,%eax
 60b:	8d 5d f8             	lea    -0x8(%ebp),%ebx
 60e:	01 d8                	add    %ebx,%eax
 610:	2d 08 01 00 00       	sub    $0x108,%eax
 615:	8b 10                	mov    (%eax),%edx
 617:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
 61d:	89 54 24 04          	mov    %edx,0x4(%esp)
 621:	89 04 24             	mov    %eax,(%esp)
 624:	e8 47 fe ff ff       	call   470 <strcmp_c>
 629:	85 c0                	test   %eax,%eax
 62b:	75 44                	jne    671 <compareuser+0x128>
			{
				setuser(users[ctr].ulevel);
 62d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 630:	89 d0                	mov    %edx,%eax
 632:	01 c0                	add    %eax,%eax
 634:	01 d0                	add    %edx,%eax
 636:	c1 e0 02             	shl    $0x2,%eax
 639:	8d 75 f8             	lea    -0x8(%ebp),%esi
 63c:	01 f0                	add    %esi,%eax
 63e:	2d 04 01 00 00       	sub    $0x104,%eax
 643:	8b 00                	mov    (%eax),%eax
 645:	89 04 24             	mov    %eax,(%esp)
 648:	e8 0f 01 00 00       	call   75c <setuser>
				
				printf(1,"%d",getuser());
 64d:	e8 02 01 00 00       	call   754 <getuser>
 652:	89 44 24 08          	mov    %eax,0x8(%esp)
 656:	c7 44 24 04 95 0c 00 	movl   $0xc95,0x4(%esp)
 65d:	00 
 65e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 665:	e8 da 01 00 00       	call   844 <printf>
				return 1;
 66a:	b8 01 00 00 00       	mov    $0x1,%eax
 66f:	eb 34                	jmp    6a5 <compareuser+0x15c>
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
		
		for(ctr = 0; ctr < 20; ctr++)
 671:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 675:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 679:	0f 8e 52 ff ff ff    	jle    5d1 <compareuser+0x88>
				
				printf(1,"%d",getuser());
				return 1;
			}
		}
		printf(1,"Invalid username/password\n");
 67f:	c7 44 24 04 98 0c 00 	movl   $0xc98,0x4(%esp)
 686:	00 
 687:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 68e:	e8 b1 01 00 00       	call   844 <printf>
		if(state != 1)
 693:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 697:	74 07                	je     6a0 <compareuser+0x157>
			break;
	}
	return 0;
 699:	b8 00 00 00 00       	mov    $0x0,%eax
 69e:	eb 05                	jmp    6a5 <compareuser+0x15c>
			}
		}
		printf(1,"Invalid username/password\n");
		if(state != 1)
			break;
	}
 6a0:	e9 0f ff ff ff       	jmp    5b4 <compareuser+0x6b>
	return 0;
}
 6a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
 6a8:	5b                   	pop    %ebx
 6a9:	5e                   	pop    %esi
 6aa:	5d                   	pop    %ebp
 6ab:	c3                   	ret    

000006ac <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 6ac:	b8 01 00 00 00       	mov    $0x1,%eax
 6b1:	cd 40                	int    $0x40
 6b3:	c3                   	ret    

000006b4 <exit>:
SYSCALL(exit)
 6b4:	b8 02 00 00 00       	mov    $0x2,%eax
 6b9:	cd 40                	int    $0x40
 6bb:	c3                   	ret    

000006bc <wait>:
SYSCALL(wait)
 6bc:	b8 03 00 00 00       	mov    $0x3,%eax
 6c1:	cd 40                	int    $0x40
 6c3:	c3                   	ret    

000006c4 <pipe>:
SYSCALL(pipe)
 6c4:	b8 04 00 00 00       	mov    $0x4,%eax
 6c9:	cd 40                	int    $0x40
 6cb:	c3                   	ret    

000006cc <read>:
SYSCALL(read)
 6cc:	b8 05 00 00 00       	mov    $0x5,%eax
 6d1:	cd 40                	int    $0x40
 6d3:	c3                   	ret    

000006d4 <write>:
SYSCALL(write)
 6d4:	b8 10 00 00 00       	mov    $0x10,%eax
 6d9:	cd 40                	int    $0x40
 6db:	c3                   	ret    

000006dc <close>:
SYSCALL(close)
 6dc:	b8 15 00 00 00       	mov    $0x15,%eax
 6e1:	cd 40                	int    $0x40
 6e3:	c3                   	ret    

000006e4 <kill>:
SYSCALL(kill)
 6e4:	b8 06 00 00 00       	mov    $0x6,%eax
 6e9:	cd 40                	int    $0x40
 6eb:	c3                   	ret    

000006ec <exec>:
SYSCALL(exec)
 6ec:	b8 07 00 00 00       	mov    $0x7,%eax
 6f1:	cd 40                	int    $0x40
 6f3:	c3                   	ret    

000006f4 <open>:
SYSCALL(open)
 6f4:	b8 0f 00 00 00       	mov    $0xf,%eax
 6f9:	cd 40                	int    $0x40
 6fb:	c3                   	ret    

000006fc <mknod>:
SYSCALL(mknod)
 6fc:	b8 11 00 00 00       	mov    $0x11,%eax
 701:	cd 40                	int    $0x40
 703:	c3                   	ret    

00000704 <unlink>:
SYSCALL(unlink)
 704:	b8 12 00 00 00       	mov    $0x12,%eax
 709:	cd 40                	int    $0x40
 70b:	c3                   	ret    

0000070c <fstat>:
SYSCALL(fstat)
 70c:	b8 08 00 00 00       	mov    $0x8,%eax
 711:	cd 40                	int    $0x40
 713:	c3                   	ret    

00000714 <link>:
SYSCALL(link)
 714:	b8 13 00 00 00       	mov    $0x13,%eax
 719:	cd 40                	int    $0x40
 71b:	c3                   	ret    

0000071c <mkdir>:
SYSCALL(mkdir)
 71c:	b8 14 00 00 00       	mov    $0x14,%eax
 721:	cd 40                	int    $0x40
 723:	c3                   	ret    

00000724 <chdir>:
SYSCALL(chdir)
 724:	b8 09 00 00 00       	mov    $0x9,%eax
 729:	cd 40                	int    $0x40
 72b:	c3                   	ret    

0000072c <dup>:
SYSCALL(dup)
 72c:	b8 0a 00 00 00       	mov    $0xa,%eax
 731:	cd 40                	int    $0x40
 733:	c3                   	ret    

00000734 <getpid>:
SYSCALL(getpid)
 734:	b8 0b 00 00 00       	mov    $0xb,%eax
 739:	cd 40                	int    $0x40
 73b:	c3                   	ret    

0000073c <sbrk>:
SYSCALL(sbrk)
 73c:	b8 0c 00 00 00       	mov    $0xc,%eax
 741:	cd 40                	int    $0x40
 743:	c3                   	ret    

00000744 <sleep>:
SYSCALL(sleep)
 744:	b8 0d 00 00 00       	mov    $0xd,%eax
 749:	cd 40                	int    $0x40
 74b:	c3                   	ret    

0000074c <uptime>:
SYSCALL(uptime)
 74c:	b8 0e 00 00 00       	mov    $0xe,%eax
 751:	cd 40                	int    $0x40
 753:	c3                   	ret    

00000754 <getuser>:
SYSCALL(getuser)
 754:	b8 16 00 00 00       	mov    $0x16,%eax
 759:	cd 40                	int    $0x40
 75b:	c3                   	ret    

0000075c <setuser>:
SYSCALL(setuser)
 75c:	b8 17 00 00 00       	mov    $0x17,%eax
 761:	cd 40                	int    $0x40
 763:	c3                   	ret    

00000764 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 764:	55                   	push   %ebp
 765:	89 e5                	mov    %esp,%ebp
 767:	83 ec 18             	sub    $0x18,%esp
 76a:	8b 45 0c             	mov    0xc(%ebp),%eax
 76d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 770:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 777:	00 
 778:	8d 45 f4             	lea    -0xc(%ebp),%eax
 77b:	89 44 24 04          	mov    %eax,0x4(%esp)
 77f:	8b 45 08             	mov    0x8(%ebp),%eax
 782:	89 04 24             	mov    %eax,(%esp)
 785:	e8 4a ff ff ff       	call   6d4 <write>
}
 78a:	c9                   	leave  
 78b:	c3                   	ret    

0000078c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 78c:	55                   	push   %ebp
 78d:	89 e5                	mov    %esp,%ebp
 78f:	56                   	push   %esi
 790:	53                   	push   %ebx
 791:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 794:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 79b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 79f:	74 17                	je     7b8 <printint+0x2c>
 7a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 7a5:	79 11                	jns    7b8 <printint+0x2c>
    neg = 1;
 7a7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 7ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 7b1:	f7 d8                	neg    %eax
 7b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7b6:	eb 06                	jmp    7be <printint+0x32>
  } else {
    x = xx;
 7b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 7bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 7be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 7c5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 7c8:	8d 41 01             	lea    0x1(%ecx),%eax
 7cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7d4:	ba 00 00 00 00       	mov    $0x0,%edx
 7d9:	f7 f3                	div    %ebx
 7db:	89 d0                	mov    %edx,%eax
 7dd:	0f b6 80 cc 0f 00 00 	movzbl 0xfcc(%eax),%eax
 7e4:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 7e8:	8b 75 10             	mov    0x10(%ebp),%esi
 7eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ee:	ba 00 00 00 00       	mov    $0x0,%edx
 7f3:	f7 f6                	div    %esi
 7f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7fc:	75 c7                	jne    7c5 <printint+0x39>
  if(neg)
 7fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 802:	74 10                	je     814 <printint+0x88>
    buf[i++] = '-';
 804:	8b 45 f4             	mov    -0xc(%ebp),%eax
 807:	8d 50 01             	lea    0x1(%eax),%edx
 80a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 80d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 812:	eb 1f                	jmp    833 <printint+0xa7>
 814:	eb 1d                	jmp    833 <printint+0xa7>
    putc(fd, buf[i]);
 816:	8d 55 dc             	lea    -0x24(%ebp),%edx
 819:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81c:	01 d0                	add    %edx,%eax
 81e:	0f b6 00             	movzbl (%eax),%eax
 821:	0f be c0             	movsbl %al,%eax
 824:	89 44 24 04          	mov    %eax,0x4(%esp)
 828:	8b 45 08             	mov    0x8(%ebp),%eax
 82b:	89 04 24             	mov    %eax,(%esp)
 82e:	e8 31 ff ff ff       	call   764 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 833:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 837:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 83b:	79 d9                	jns    816 <printint+0x8a>
    putc(fd, buf[i]);
}
 83d:	83 c4 30             	add    $0x30,%esp
 840:	5b                   	pop    %ebx
 841:	5e                   	pop    %esi
 842:	5d                   	pop    %ebp
 843:	c3                   	ret    

00000844 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 844:	55                   	push   %ebp
 845:	89 e5                	mov    %esp,%ebp
 847:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 84a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 851:	8d 45 0c             	lea    0xc(%ebp),%eax
 854:	83 c0 04             	add    $0x4,%eax
 857:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 85a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 861:	e9 7c 01 00 00       	jmp    9e2 <printf+0x19e>
    c = fmt[i] & 0xff;
 866:	8b 55 0c             	mov    0xc(%ebp),%edx
 869:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86c:	01 d0                	add    %edx,%eax
 86e:	0f b6 00             	movzbl (%eax),%eax
 871:	0f be c0             	movsbl %al,%eax
 874:	25 ff 00 00 00       	and    $0xff,%eax
 879:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 87c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 880:	75 2c                	jne    8ae <printf+0x6a>
      if(c == '%'){
 882:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 886:	75 0c                	jne    894 <printf+0x50>
        state = '%';
 888:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 88f:	e9 4a 01 00 00       	jmp    9de <printf+0x19a>
      } else {
        putc(fd, c);
 894:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 897:	0f be c0             	movsbl %al,%eax
 89a:	89 44 24 04          	mov    %eax,0x4(%esp)
 89e:	8b 45 08             	mov    0x8(%ebp),%eax
 8a1:	89 04 24             	mov    %eax,(%esp)
 8a4:	e8 bb fe ff ff       	call   764 <putc>
 8a9:	e9 30 01 00 00       	jmp    9de <printf+0x19a>
      }
    } else if(state == '%'){
 8ae:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 8b2:	0f 85 26 01 00 00    	jne    9de <printf+0x19a>
      if(c == 'd'){
 8b8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 8bc:	75 2d                	jne    8eb <printf+0xa7>
        printint(fd, *ap, 10, 1);
 8be:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8c1:	8b 00                	mov    (%eax),%eax
 8c3:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 8ca:	00 
 8cb:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 8d2:	00 
 8d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 8d7:	8b 45 08             	mov    0x8(%ebp),%eax
 8da:	89 04 24             	mov    %eax,(%esp)
 8dd:	e8 aa fe ff ff       	call   78c <printint>
        ap++;
 8e2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8e6:	e9 ec 00 00 00       	jmp    9d7 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 8eb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 8ef:	74 06                	je     8f7 <printf+0xb3>
 8f1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 8f5:	75 2d                	jne    924 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 8f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8fa:	8b 00                	mov    (%eax),%eax
 8fc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 903:	00 
 904:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 90b:	00 
 90c:	89 44 24 04          	mov    %eax,0x4(%esp)
 910:	8b 45 08             	mov    0x8(%ebp),%eax
 913:	89 04 24             	mov    %eax,(%esp)
 916:	e8 71 fe ff ff       	call   78c <printint>
        ap++;
 91b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 91f:	e9 b3 00 00 00       	jmp    9d7 <printf+0x193>
      } else if(c == 's'){
 924:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 928:	75 45                	jne    96f <printf+0x12b>
        s = (char*)*ap;
 92a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 92d:	8b 00                	mov    (%eax),%eax
 92f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 932:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 936:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 93a:	75 09                	jne    945 <printf+0x101>
          s = "(null)";
 93c:	c7 45 f4 b3 0c 00 00 	movl   $0xcb3,-0xc(%ebp)
        while(*s != 0){
 943:	eb 1e                	jmp    963 <printf+0x11f>
 945:	eb 1c                	jmp    963 <printf+0x11f>
          putc(fd, *s);
 947:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94a:	0f b6 00             	movzbl (%eax),%eax
 94d:	0f be c0             	movsbl %al,%eax
 950:	89 44 24 04          	mov    %eax,0x4(%esp)
 954:	8b 45 08             	mov    0x8(%ebp),%eax
 957:	89 04 24             	mov    %eax,(%esp)
 95a:	e8 05 fe ff ff       	call   764 <putc>
          s++;
 95f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 963:	8b 45 f4             	mov    -0xc(%ebp),%eax
 966:	0f b6 00             	movzbl (%eax),%eax
 969:	84 c0                	test   %al,%al
 96b:	75 da                	jne    947 <printf+0x103>
 96d:	eb 68                	jmp    9d7 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 96f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 973:	75 1d                	jne    992 <printf+0x14e>
        putc(fd, *ap);
 975:	8b 45 e8             	mov    -0x18(%ebp),%eax
 978:	8b 00                	mov    (%eax),%eax
 97a:	0f be c0             	movsbl %al,%eax
 97d:	89 44 24 04          	mov    %eax,0x4(%esp)
 981:	8b 45 08             	mov    0x8(%ebp),%eax
 984:	89 04 24             	mov    %eax,(%esp)
 987:	e8 d8 fd ff ff       	call   764 <putc>
        ap++;
 98c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 990:	eb 45                	jmp    9d7 <printf+0x193>
      } else if(c == '%'){
 992:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 996:	75 17                	jne    9af <printf+0x16b>
        putc(fd, c);
 998:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 99b:	0f be c0             	movsbl %al,%eax
 99e:	89 44 24 04          	mov    %eax,0x4(%esp)
 9a2:	8b 45 08             	mov    0x8(%ebp),%eax
 9a5:	89 04 24             	mov    %eax,(%esp)
 9a8:	e8 b7 fd ff ff       	call   764 <putc>
 9ad:	eb 28                	jmp    9d7 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9af:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 9b6:	00 
 9b7:	8b 45 08             	mov    0x8(%ebp),%eax
 9ba:	89 04 24             	mov    %eax,(%esp)
 9bd:	e8 a2 fd ff ff       	call   764 <putc>
        putc(fd, c);
 9c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9c5:	0f be c0             	movsbl %al,%eax
 9c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 9cc:	8b 45 08             	mov    0x8(%ebp),%eax
 9cf:	89 04 24             	mov    %eax,(%esp)
 9d2:	e8 8d fd ff ff       	call   764 <putc>
      }
      state = 0;
 9d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 9de:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 9e2:	8b 55 0c             	mov    0xc(%ebp),%edx
 9e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e8:	01 d0                	add    %edx,%eax
 9ea:	0f b6 00             	movzbl (%eax),%eax
 9ed:	84 c0                	test   %al,%al
 9ef:	0f 85 71 fe ff ff    	jne    866 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 9f5:	c9                   	leave  
 9f6:	c3                   	ret    

000009f7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9f7:	55                   	push   %ebp
 9f8:	89 e5                	mov    %esp,%ebp
 9fa:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9fd:	8b 45 08             	mov    0x8(%ebp),%eax
 a00:	83 e8 08             	sub    $0x8,%eax
 a03:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a06:	a1 e8 0f 00 00       	mov    0xfe8,%eax
 a0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a0e:	eb 24                	jmp    a34 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a10:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a13:	8b 00                	mov    (%eax),%eax
 a15:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a18:	77 12                	ja     a2c <free+0x35>
 a1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a1d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a20:	77 24                	ja     a46 <free+0x4f>
 a22:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a25:	8b 00                	mov    (%eax),%eax
 a27:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a2a:	77 1a                	ja     a46 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a2f:	8b 00                	mov    (%eax),%eax
 a31:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a34:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a37:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a3a:	76 d4                	jbe    a10 <free+0x19>
 a3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a3f:	8b 00                	mov    (%eax),%eax
 a41:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a44:	76 ca                	jbe    a10 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a46:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a49:	8b 40 04             	mov    0x4(%eax),%eax
 a4c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a53:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a56:	01 c2                	add    %eax,%edx
 a58:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5b:	8b 00                	mov    (%eax),%eax
 a5d:	39 c2                	cmp    %eax,%edx
 a5f:	75 24                	jne    a85 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a61:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a64:	8b 50 04             	mov    0x4(%eax),%edx
 a67:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a6a:	8b 00                	mov    (%eax),%eax
 a6c:	8b 40 04             	mov    0x4(%eax),%eax
 a6f:	01 c2                	add    %eax,%edx
 a71:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a74:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a77:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a7a:	8b 00                	mov    (%eax),%eax
 a7c:	8b 10                	mov    (%eax),%edx
 a7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a81:	89 10                	mov    %edx,(%eax)
 a83:	eb 0a                	jmp    a8f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a85:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a88:	8b 10                	mov    (%eax),%edx
 a8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a8d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a92:	8b 40 04             	mov    0x4(%eax),%eax
 a95:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a9f:	01 d0                	add    %edx,%eax
 aa1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 aa4:	75 20                	jne    ac6 <free+0xcf>
    p->s.size += bp->s.size;
 aa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa9:	8b 50 04             	mov    0x4(%eax),%edx
 aac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aaf:	8b 40 04             	mov    0x4(%eax),%eax
 ab2:	01 c2                	add    %eax,%edx
 ab4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 aba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 abd:	8b 10                	mov    (%eax),%edx
 abf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac2:	89 10                	mov    %edx,(%eax)
 ac4:	eb 08                	jmp    ace <free+0xd7>
  } else
    p->s.ptr = bp;
 ac6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 acc:	89 10                	mov    %edx,(%eax)
  freep = p;
 ace:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ad1:	a3 e8 0f 00 00       	mov    %eax,0xfe8
}
 ad6:	c9                   	leave  
 ad7:	c3                   	ret    

00000ad8 <morecore>:

static Header*
morecore(uint nu)
{
 ad8:	55                   	push   %ebp
 ad9:	89 e5                	mov    %esp,%ebp
 adb:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 ade:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 ae5:	77 07                	ja     aee <morecore+0x16>
    nu = 4096;
 ae7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 aee:	8b 45 08             	mov    0x8(%ebp),%eax
 af1:	c1 e0 03             	shl    $0x3,%eax
 af4:	89 04 24             	mov    %eax,(%esp)
 af7:	e8 40 fc ff ff       	call   73c <sbrk>
 afc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 aff:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b03:	75 07                	jne    b0c <morecore+0x34>
    return 0;
 b05:	b8 00 00 00 00       	mov    $0x0,%eax
 b0a:	eb 22                	jmp    b2e <morecore+0x56>
  hp = (Header*)p;
 b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b15:	8b 55 08             	mov    0x8(%ebp),%edx
 b18:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b1e:	83 c0 08             	add    $0x8,%eax
 b21:	89 04 24             	mov    %eax,(%esp)
 b24:	e8 ce fe ff ff       	call   9f7 <free>
  return freep;
 b29:	a1 e8 0f 00 00       	mov    0xfe8,%eax
}
 b2e:	c9                   	leave  
 b2f:	c3                   	ret    

00000b30 <malloc>:

void*
malloc(uint nbytes)
{
 b30:	55                   	push   %ebp
 b31:	89 e5                	mov    %esp,%ebp
 b33:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b36:	8b 45 08             	mov    0x8(%ebp),%eax
 b39:	83 c0 07             	add    $0x7,%eax
 b3c:	c1 e8 03             	shr    $0x3,%eax
 b3f:	83 c0 01             	add    $0x1,%eax
 b42:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b45:	a1 e8 0f 00 00       	mov    0xfe8,%eax
 b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b51:	75 23                	jne    b76 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b53:	c7 45 f0 e0 0f 00 00 	movl   $0xfe0,-0x10(%ebp)
 b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b5d:	a3 e8 0f 00 00       	mov    %eax,0xfe8
 b62:	a1 e8 0f 00 00       	mov    0xfe8,%eax
 b67:	a3 e0 0f 00 00       	mov    %eax,0xfe0
    base.s.size = 0;
 b6c:	c7 05 e4 0f 00 00 00 	movl   $0x0,0xfe4
 b73:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b79:	8b 00                	mov    (%eax),%eax
 b7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b81:	8b 40 04             	mov    0x4(%eax),%eax
 b84:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b87:	72 4d                	jb     bd6 <malloc+0xa6>
      if(p->s.size == nunits)
 b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b8c:	8b 40 04             	mov    0x4(%eax),%eax
 b8f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b92:	75 0c                	jne    ba0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b97:	8b 10                	mov    (%eax),%edx
 b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b9c:	89 10                	mov    %edx,(%eax)
 b9e:	eb 26                	jmp    bc6 <malloc+0x96>
      else {
        p->s.size -= nunits;
 ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba3:	8b 40 04             	mov    0x4(%eax),%eax
 ba6:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ba9:	89 c2                	mov    %eax,%edx
 bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bae:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bb4:	8b 40 04             	mov    0x4(%eax),%eax
 bb7:	c1 e0 03             	shl    $0x3,%eax
 bba:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bc0:	8b 55 ec             	mov    -0x14(%ebp),%edx
 bc3:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bc9:	a3 e8 0f 00 00       	mov    %eax,0xfe8
      return (void*)(p + 1);
 bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd1:	83 c0 08             	add    $0x8,%eax
 bd4:	eb 38                	jmp    c0e <malloc+0xde>
    }
    if(p == freep)
 bd6:	a1 e8 0f 00 00       	mov    0xfe8,%eax
 bdb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 bde:	75 1b                	jne    bfb <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 be0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 be3:	89 04 24             	mov    %eax,(%esp)
 be6:	e8 ed fe ff ff       	call   ad8 <morecore>
 beb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 bee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 bf2:	75 07                	jne    bfb <malloc+0xcb>
        return 0;
 bf4:	b8 00 00 00 00       	mov    $0x0,%eax
 bf9:	eb 13                	jmp    c0e <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c04:	8b 00                	mov    (%eax),%eax
 c06:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 c09:	e9 70 ff ff ff       	jmp    b7e <malloc+0x4e>
}
 c0e:	c9                   	leave  
 c0f:	c3                   	ret    
