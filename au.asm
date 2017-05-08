
_au:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	81 ec 3c 04 00 00    	sub    $0x43c,%esp
   c:	89 e0                	mov    %esp,%eax
   e:	89 c7                	mov    %eax,%edi
  int n;
  char buff1[512], buff2[512];
  char* name;
  char* pass;
  
  printf(1,"Please enter a username: ");
  10:	c7 44 24 04 40 0c 00 	movl   $0xc40,0x4(%esp)
  17:	00 
  18:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1f:	e8 50 08 00 00       	call   874 <printf>
  name = gets(buff1, 50);
  24:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  2b:	00 
  2c:	8d 85 cc fd ff ff    	lea    -0x234(%ebp),%eax
  32:	89 04 24             	mov    %eax,(%esp)
  35:	e8 18 03 00 00       	call   352 <gets>
  3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char tmpName[strlen(name)];
  3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  40:	89 04 24             	mov    %eax,(%esp)
  43:	e8 5f 02 00 00       	call   2a7 <strlen>
  48:	89 c3                	mov    %eax,%ebx
  4a:	89 d8                	mov    %ebx,%eax
  4c:	83 e8 01             	sub    $0x1,%eax
  4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  52:	b8 10 00 00 00       	mov    $0x10,%eax
  57:	83 e8 01             	sub    $0x1,%eax
  5a:	01 d8                	add    %ebx,%eax
  5c:	b9 10 00 00 00       	mov    $0x10,%ecx
  61:	ba 00 00 00 00       	mov    $0x0,%edx
  66:	f7 f1                	div    %ecx
  68:	6b c0 10             	imul   $0x10,%eax,%eax
  6b:	29 c4                	sub    %eax,%esp
  6d:	8d 44 24 0c          	lea    0xc(%esp),%eax
  71:	83 c0 00             	add    $0x0,%eax
  74:	89 45 dc             	mov    %eax,-0x24(%ebp)
  strcpy(tmpName,name);
  77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  7d:	89 54 24 04          	mov    %edx,0x4(%esp)
  81:	89 04 24             	mov    %eax,(%esp)
  84:	e8 af 01 00 00       	call   238 <strcpy>
  tmpName[strlen(tmpName)-1] = '\n';
  89:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8c:	89 04 24             	mov    %eax,(%esp)
  8f:	e8 13 02 00 00       	call   2a7 <strlen>
  94:	8d 50 ff             	lea    -0x1(%eax),%edx
  97:	8b 45 dc             	mov    -0x24(%ebp),%eax
  9a:	c6 04 10 0a          	movb   $0xa,(%eax,%edx,1)
  
  printf(1,"Please enter a password: ");
  9e:	c7 44 24 04 5a 0c 00 	movl   $0xc5a,0x4(%esp)
  a5:	00 
  a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ad:	e8 c2 07 00 00       	call   874 <printf>
  pass = gets(buff2, 50);
  b2:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  b9:	00 
  ba:	8d 85 cc fb ff ff    	lea    -0x434(%ebp),%eax
  c0:	89 04 24             	mov    %eax,(%esp)
  c3:	e8 8a 02 00 00       	call   352 <gets>
  c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  char tmpPass[strlen(pass)];
  cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  ce:	89 04 24             	mov    %eax,(%esp)
  d1:	e8 d1 01 00 00       	call   2a7 <strlen>
  d6:	89 c6                	mov    %eax,%esi
  d8:	89 f0                	mov    %esi,%eax
  da:	83 e8 01             	sub    $0x1,%eax
  dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  e0:	b8 10 00 00 00       	mov    $0x10,%eax
  e5:	83 e8 01             	sub    $0x1,%eax
  e8:	01 f0                	add    %esi,%eax
  ea:	b9 10 00 00 00       	mov    $0x10,%ecx
  ef:	ba 00 00 00 00       	mov    $0x0,%edx
  f4:	f7 f1                	div    %ecx
  f6:	6b c0 10             	imul   $0x10,%eax,%eax
  f9:	29 c4                	sub    %eax,%esp
  fb:	8d 44 24 0c          	lea    0xc(%esp),%eax
  ff:	83 c0 00             	add    $0x0,%eax
 102:	89 45 d0             	mov    %eax,-0x30(%ebp)
  strcpy(tmpPass,pass);
 105:	8b 45 d0             	mov    -0x30(%ebp),%eax
 108:	8b 55 d8             	mov    -0x28(%ebp),%edx
 10b:	89 54 24 04          	mov    %edx,0x4(%esp)
 10f:	89 04 24             	mov    %eax,(%esp)
 112:	e8 21 01 00 00       	call   238 <strcpy>
  tmpPass[strlen(tmpPass)-1] = '\n';
 117:	8b 45 d0             	mov    -0x30(%ebp),%eax
 11a:	89 04 24             	mov    %eax,(%esp)
 11d:	e8 85 01 00 00       	call   2a7 <strlen>
 122:	8d 50 ff             	lea    -0x1(%eax),%edx
 125:	8b 45 d0             	mov    -0x30(%ebp),%eax
 128:	c6 04 10 0a          	movb   $0xa,(%eax,%edx,1)
  while((n = read(fd, buf, sizeof(buf))) > 0){
 12c:	eb 30                	jmp    15e <cat+0x15e>
    
    write(fd, tmpName, sizeof(tmpName));
 12e:	89 da                	mov    %ebx,%edx
 130:	8b 45 dc             	mov    -0x24(%ebp),%eax
 133:	89 54 24 08          	mov    %edx,0x8(%esp)
 137:	89 44 24 04          	mov    %eax,0x4(%esp)
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 04 24             	mov    %eax,(%esp)
 141:	e8 be 05 00 00       	call   704 <write>
    write(fd, tmpPass, sizeof(tmpPass));
 146:	89 f2                	mov    %esi,%edx
 148:	8b 45 d0             	mov    -0x30(%ebp),%eax
 14b:	89 54 24 08          	mov    %edx,0x8(%esp)
 14f:	89 44 24 04          	mov    %eax,0x4(%esp)
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	89 04 24             	mov    %eax,(%esp)
 159:	e8 a6 05 00 00       	call   704 <write>
  printf(1,"Please enter a password: ");
  pass = gets(buff2, 50);
  char tmpPass[strlen(pass)];
  strcpy(tmpPass,pass);
  tmpPass[strlen(tmpPass)-1] = '\n';
  while((n = read(fd, buf, sizeof(buf))) > 0){
 15e:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 165:	00 
 166:	c7 44 24 04 80 10 00 	movl   $0x1080,0x4(%esp)
 16d:	00 
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	89 04 24             	mov    %eax,(%esp)
 174:	e8 83 05 00 00       	call   6fc <read>
 179:	89 45 cc             	mov    %eax,-0x34(%ebp)
 17c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
 180:	7f ac                	jg     12e <cat+0x12e>
    
    write(fd, tmpName, sizeof(tmpName));
    write(fd, tmpPass, sizeof(tmpPass));
  }
  
    if(n < 0){
 182:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
 186:	79 19                	jns    1a1 <cat+0x1a1>
    printf(1, "Add user: read error\n");
 188:	c7 44 24 04 74 0c 00 	movl   $0xc74,0x4(%esp)
 18f:	00 
 190:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 197:	e8 d8 06 00 00       	call   874 <printf>
    exit();
 19c:	e8 43 05 00 00       	call   6e4 <exit>
 1a1:	89 fc                	mov    %edi,%esp
    
  }
  
}
 1a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1a6:	5b                   	pop    %ebx
 1a7:	5e                   	pop    %esi
 1a8:	5f                   	pop    %edi
 1a9:	5d                   	pop    %ebp
 1aa:	c3                   	ret    

000001ab <main>:

int
main(int argc, char *argv[])
{
 1ab:	55                   	push   %ebp
 1ac:	89 e5                	mov    %esp,%ebp
 1ae:	83 e4 f0             	and    $0xfffffff0,%esp
 1b1:	83 ec 20             	sub    $0x20,%esp
  int fd;

  if((fd = open("auth_passwd.confi", 2)) < 0){
 1b4:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
 1bb:	00 
 1bc:	c7 04 24 8a 0c 00 00 	movl   $0xc8a,(%esp)
 1c3:	e8 5c 05 00 00       	call   724 <open>
 1c8:	89 44 24 1c          	mov    %eax,0x1c(%esp)
 1cc:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
 1d1:	79 19                	jns    1ec <main+0x41>
    printf(1, "Add user: cannot open\n");
 1d3:	c7 44 24 04 9c 0c 00 	movl   $0xc9c,0x4(%esp)
 1da:	00 
 1db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1e2:	e8 8d 06 00 00       	call   874 <printf>
    exit();
 1e7:	e8 f8 04 00 00       	call   6e4 <exit>
  }
  cat(fd);
 1ec:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1f0:	89 04 24             	mov    %eax,(%esp)
 1f3:	e8 08 fe ff ff       	call   0 <cat>
  close(fd);
 1f8:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1fc:	89 04 24             	mov    %eax,(%esp)
 1ff:	e8 08 05 00 00       	call   70c <close>
  
  exit();
 204:	e8 db 04 00 00       	call   6e4 <exit>

00000209 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 209:	55                   	push   %ebp
 20a:	89 e5                	mov    %esp,%ebp
 20c:	57                   	push   %edi
 20d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 20e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 211:	8b 55 10             	mov    0x10(%ebp),%edx
 214:	8b 45 0c             	mov    0xc(%ebp),%eax
 217:	89 cb                	mov    %ecx,%ebx
 219:	89 df                	mov    %ebx,%edi
 21b:	89 d1                	mov    %edx,%ecx
 21d:	fc                   	cld    
 21e:	f3 aa                	rep stos %al,%es:(%edi)
 220:	89 ca                	mov    %ecx,%edx
 222:	89 fb                	mov    %edi,%ebx
 224:	89 5d 08             	mov    %ebx,0x8(%ebp)
 227:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 22a:	5b                   	pop    %ebx
 22b:	5f                   	pop    %edi
 22c:	5d                   	pop    %ebp
 22d:	c3                   	ret    

0000022e <thing>:
#include "user.h"
#include "x86.h"


int
thing(void){
 22e:	55                   	push   %ebp
 22f:	89 e5                	mov    %esp,%ebp
  return 1;
 231:	b8 01 00 00 00       	mov    $0x1,%eax
}
 236:	5d                   	pop    %ebp
 237:	c3                   	ret    

00000238 <strcpy>:

char*
strcpy(char *s, char *t)
{
 238:	55                   	push   %ebp
 239:	89 e5                	mov    %esp,%ebp
 23b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 23e:	8b 45 08             	mov    0x8(%ebp),%eax
 241:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 244:	90                   	nop
 245:	8b 45 08             	mov    0x8(%ebp),%eax
 248:	8d 50 01             	lea    0x1(%eax),%edx
 24b:	89 55 08             	mov    %edx,0x8(%ebp)
 24e:	8b 55 0c             	mov    0xc(%ebp),%edx
 251:	8d 4a 01             	lea    0x1(%edx),%ecx
 254:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 257:	0f b6 12             	movzbl (%edx),%edx
 25a:	88 10                	mov    %dl,(%eax)
 25c:	0f b6 00             	movzbl (%eax),%eax
 25f:	84 c0                	test   %al,%al
 261:	75 e2                	jne    245 <strcpy+0xd>
    ;
  return os;
 263:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 266:	c9                   	leave  
 267:	c3                   	ret    

00000268 <strcmp>:



int
strcmp(const char *p, const char *q)
{
 268:	55                   	push   %ebp
 269:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 26b:	eb 08                	jmp    275 <strcmp+0xd>
    p++, q++;
 26d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 271:	83 45 0c 01          	addl   $0x1,0xc(%ebp)


int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	84 c0                	test   %al,%al
 27d:	74 10                	je     28f <strcmp+0x27>
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
 282:	0f b6 10             	movzbl (%eax),%edx
 285:	8b 45 0c             	mov    0xc(%ebp),%eax
 288:	0f b6 00             	movzbl (%eax),%eax
 28b:	38 c2                	cmp    %al,%dl
 28d:	74 de                	je     26d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 28f:	8b 45 08             	mov    0x8(%ebp),%eax
 292:	0f b6 00             	movzbl (%eax),%eax
 295:	0f b6 d0             	movzbl %al,%edx
 298:	8b 45 0c             	mov    0xc(%ebp),%eax
 29b:	0f b6 00             	movzbl (%eax),%eax
 29e:	0f b6 c0             	movzbl %al,%eax
 2a1:	29 c2                	sub    %eax,%edx
 2a3:	89 d0                	mov    %edx,%eax
}
 2a5:	5d                   	pop    %ebp
 2a6:	c3                   	ret    

000002a7 <strlen>:

uint
strlen(char *s)
{
 2a7:	55                   	push   %ebp
 2a8:	89 e5                	mov    %esp,%ebp
 2aa:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2b4:	eb 04                	jmp    2ba <strlen+0x13>
 2b6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	01 d0                	add    %edx,%eax
 2c2:	0f b6 00             	movzbl (%eax),%eax
 2c5:	84 c0                	test   %al,%al
 2c7:	75 ed                	jne    2b6 <strlen+0xf>
    ;
  return n;
 2c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2cc:	c9                   	leave  
 2cd:	c3                   	ret    

000002ce <stringlen>:

uint
stringlen(char **s){
 2ce:	55                   	push   %ebp
 2cf:	89 e5                	mov    %esp,%ebp
 2d1:	83 ec 10             	sub    $0x10,%esp
	int n;

  for(n = 0; s[n]; n++)
 2d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2db:	eb 04                	jmp    2e1 <stringlen+0x13>
 2dd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 2eb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ee:	01 d0                	add    %edx,%eax
 2f0:	8b 00                	mov    (%eax),%eax
 2f2:	85 c0                	test   %eax,%eax
 2f4:	75 e7                	jne    2dd <stringlen+0xf>
    ;
  return n;
 2f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2f9:	c9                   	leave  
 2fa:	c3                   	ret    

000002fb <memset>:

void*
memset(void *dst, int c, uint n)
{
 2fb:	55                   	push   %ebp
 2fc:	89 e5                	mov    %esp,%ebp
 2fe:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 301:	8b 45 10             	mov    0x10(%ebp),%eax
 304:	89 44 24 08          	mov    %eax,0x8(%esp)
 308:	8b 45 0c             	mov    0xc(%ebp),%eax
 30b:	89 44 24 04          	mov    %eax,0x4(%esp)
 30f:	8b 45 08             	mov    0x8(%ebp),%eax
 312:	89 04 24             	mov    %eax,(%esp)
 315:	e8 ef fe ff ff       	call   209 <stosb>
  return dst;
 31a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 31d:	c9                   	leave  
 31e:	c3                   	ret    

0000031f <strchr>:

char*
strchr(const char *s, char c)
{
 31f:	55                   	push   %ebp
 320:	89 e5                	mov    %esp,%ebp
 322:	83 ec 04             	sub    $0x4,%esp
 325:	8b 45 0c             	mov    0xc(%ebp),%eax
 328:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 32b:	eb 14                	jmp    341 <strchr+0x22>
    if(*s == c)
 32d:	8b 45 08             	mov    0x8(%ebp),%eax
 330:	0f b6 00             	movzbl (%eax),%eax
 333:	3a 45 fc             	cmp    -0x4(%ebp),%al
 336:	75 05                	jne    33d <strchr+0x1e>
      return (char*)s;
 338:	8b 45 08             	mov    0x8(%ebp),%eax
 33b:	eb 13                	jmp    350 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 33d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 341:	8b 45 08             	mov    0x8(%ebp),%eax
 344:	0f b6 00             	movzbl (%eax),%eax
 347:	84 c0                	test   %al,%al
 349:	75 e2                	jne    32d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 34b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 350:	c9                   	leave  
 351:	c3                   	ret    

00000352 <gets>:

char*
gets(char *buf, int max)
{
 352:	55                   	push   %ebp
 353:	89 e5                	mov    %esp,%ebp
 355:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 358:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 35f:	eb 4c                	jmp    3ad <gets+0x5b>
    cc = read(0, &c, 1);
 361:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 368:	00 
 369:	8d 45 ef             	lea    -0x11(%ebp),%eax
 36c:	89 44 24 04          	mov    %eax,0x4(%esp)
 370:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 377:	e8 80 03 00 00       	call   6fc <read>
 37c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 37f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 383:	7f 02                	jg     387 <gets+0x35>
      break;
 385:	eb 31                	jmp    3b8 <gets+0x66>
    buf[i++] = c;
 387:	8b 45 f4             	mov    -0xc(%ebp),%eax
 38a:	8d 50 01             	lea    0x1(%eax),%edx
 38d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 390:	89 c2                	mov    %eax,%edx
 392:	8b 45 08             	mov    0x8(%ebp),%eax
 395:	01 c2                	add    %eax,%edx
 397:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 39b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 39d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3a1:	3c 0a                	cmp    $0xa,%al
 3a3:	74 13                	je     3b8 <gets+0x66>
 3a5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3a9:	3c 0d                	cmp    $0xd,%al
 3ab:	74 0b                	je     3b8 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3b0:	83 c0 01             	add    $0x1,%eax
 3b3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 3b6:	7c a9                	jl     361 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3bb:	8b 45 08             	mov    0x8(%ebp),%eax
 3be:	01 d0                	add    %edx,%eax
 3c0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3c6:	c9                   	leave  
 3c7:	c3                   	ret    

000003c8 <stat>:

int
stat(char *n, struct stat *st)
{
 3c8:	55                   	push   %ebp
 3c9:	89 e5                	mov    %esp,%ebp
 3cb:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3ce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3d5:	00 
 3d6:	8b 45 08             	mov    0x8(%ebp),%eax
 3d9:	89 04 24             	mov    %eax,(%esp)
 3dc:	e8 43 03 00 00       	call   724 <open>
 3e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3e8:	79 07                	jns    3f1 <stat+0x29>
    return -1;
 3ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3ef:	eb 23                	jmp    414 <stat+0x4c>
  r = fstat(fd, st);
 3f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 3f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3fb:	89 04 24             	mov    %eax,(%esp)
 3fe:	e8 39 03 00 00       	call   73c <fstat>
 403:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 406:	8b 45 f4             	mov    -0xc(%ebp),%eax
 409:	89 04 24             	mov    %eax,(%esp)
 40c:	e8 fb 02 00 00       	call   70c <close>
  return r;
 411:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 414:	c9                   	leave  
 415:	c3                   	ret    

00000416 <atoi>:

int
atoi(const char *s)
{
 416:	55                   	push   %ebp
 417:	89 e5                	mov    %esp,%ebp
 419:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 41c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 423:	eb 25                	jmp    44a <atoi+0x34>
    n = n*10 + *s++ - '0';
 425:	8b 55 fc             	mov    -0x4(%ebp),%edx
 428:	89 d0                	mov    %edx,%eax
 42a:	c1 e0 02             	shl    $0x2,%eax
 42d:	01 d0                	add    %edx,%eax
 42f:	01 c0                	add    %eax,%eax
 431:	89 c1                	mov    %eax,%ecx
 433:	8b 45 08             	mov    0x8(%ebp),%eax
 436:	8d 50 01             	lea    0x1(%eax),%edx
 439:	89 55 08             	mov    %edx,0x8(%ebp)
 43c:	0f b6 00             	movzbl (%eax),%eax
 43f:	0f be c0             	movsbl %al,%eax
 442:	01 c8                	add    %ecx,%eax
 444:	83 e8 30             	sub    $0x30,%eax
 447:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 44a:	8b 45 08             	mov    0x8(%ebp),%eax
 44d:	0f b6 00             	movzbl (%eax),%eax
 450:	3c 2f                	cmp    $0x2f,%al
 452:	7e 0a                	jle    45e <atoi+0x48>
 454:	8b 45 08             	mov    0x8(%ebp),%eax
 457:	0f b6 00             	movzbl (%eax),%eax
 45a:	3c 39                	cmp    $0x39,%al
 45c:	7e c7                	jle    425 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 45e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 461:	c9                   	leave  
 462:	c3                   	ret    

00000463 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 463:	55                   	push   %ebp
 464:	89 e5                	mov    %esp,%ebp
 466:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 469:	8b 45 08             	mov    0x8(%ebp),%eax
 46c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 46f:	8b 45 0c             	mov    0xc(%ebp),%eax
 472:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 475:	eb 17                	jmp    48e <memmove+0x2b>
    *dst++ = *src++;
 477:	8b 45 fc             	mov    -0x4(%ebp),%eax
 47a:	8d 50 01             	lea    0x1(%eax),%edx
 47d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 480:	8b 55 f8             	mov    -0x8(%ebp),%edx
 483:	8d 4a 01             	lea    0x1(%edx),%ecx
 486:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 489:	0f b6 12             	movzbl (%edx),%edx
 48c:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 48e:	8b 45 10             	mov    0x10(%ebp),%eax
 491:	8d 50 ff             	lea    -0x1(%eax),%edx
 494:	89 55 10             	mov    %edx,0x10(%ebp)
 497:	85 c0                	test   %eax,%eax
 499:	7f dc                	jg     477 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 49b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 49e:	c9                   	leave  
 49f:	c3                   	ret    

000004a0 <strcmp_c>:


int
strcmp_c(const char *s1, const char *s2)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
    for ( ; *s1 == *s2; s1++, s2++)
 4a3:	eb 19                	jmp    4be <strcmp_c+0x1e>
	if (*s1 == '\0')
 4a5:	8b 45 08             	mov    0x8(%ebp),%eax
 4a8:	0f b6 00             	movzbl (%eax),%eax
 4ab:	84 c0                	test   %al,%al
 4ad:	75 07                	jne    4b6 <strcmp_c+0x16>
	    return 0;
 4af:	b8 00 00 00 00       	mov    $0x0,%eax
 4b4:	eb 34                	jmp    4ea <strcmp_c+0x4a>


int
strcmp_c(const char *s1, const char *s2)
{
    for ( ; *s1 == *s2; s1++, s2++)
 4b6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 4ba:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 4be:	8b 45 08             	mov    0x8(%ebp),%eax
 4c1:	0f b6 10             	movzbl (%eax),%edx
 4c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c7:	0f b6 00             	movzbl (%eax),%eax
 4ca:	38 c2                	cmp    %al,%dl
 4cc:	74 d7                	je     4a5 <strcmp_c+0x5>
	if (*s1 == '\0')
	    return 0;
    return ((*(unsigned char *)s1 < *(unsigned char *)s2) ? -1 : +1);
 4ce:	8b 45 08             	mov    0x8(%ebp),%eax
 4d1:	0f b6 10             	movzbl (%eax),%edx
 4d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d7:	0f b6 00             	movzbl (%eax),%eax
 4da:	38 c2                	cmp    %al,%dl
 4dc:	73 07                	jae    4e5 <strcmp_c+0x45>
 4de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4e3:	eb 05                	jmp    4ea <strcmp_c+0x4a>
 4e5:	b8 01 00 00 00       	mov    $0x1,%eax
}
 4ea:	5d                   	pop    %ebp
 4eb:	c3                   	ret    

000004ec <readuser>:


struct USER
readuser(){
 4ec:	55                   	push   %ebp
 4ed:	89 e5                	mov    %esp,%ebp
 4ef:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char buff1[512], buff2[512];
	struct USER u;
	printf(1,"Please enter a username: ");
 4f5:	c7 44 24 04 b3 0c 00 	movl   $0xcb3,0x4(%esp)
 4fc:	00 
 4fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 504:	e8 6b 03 00 00       	call   874 <printf>
	u.name = gets(buff1, 50);
 509:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 510:	00 
 511:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
 517:	89 04 24             	mov    %eax,(%esp)
 51a:	e8 33 fe ff ff       	call   352 <gets>
 51f:	89 85 ec fb ff ff    	mov    %eax,-0x414(%ebp)
	printf(1,"Please enter a password: ");
 525:	c7 44 24 04 cd 0c 00 	movl   $0xccd,0x4(%esp)
 52c:	00 
 52d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 534:	e8 3b 03 00 00       	call   874 <printf>
	u.pass = gets(buff2, 50);
 539:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 540:	00 
 541:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
 547:	89 04 24             	mov    %eax,(%esp)
 54a:	e8 03 fe ff ff       	call   352 <gets>
 54f:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
	return u;
 555:	8b 45 08             	mov    0x8(%ebp),%eax
 558:	8b 95 ec fb ff ff    	mov    -0x414(%ebp),%edx
 55e:	89 10                	mov    %edx,(%eax)
 560:	8b 95 f0 fb ff ff    	mov    -0x410(%ebp),%edx
 566:	89 50 04             	mov    %edx,0x4(%eax)
 569:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
 56f:	89 50 08             	mov    %edx,0x8(%eax)
}
 572:	8b 45 08             	mov    0x8(%ebp),%eax
 575:	c9                   	leave  
 576:	c2 04 00             	ret    $0x4

00000579 <compareuser>:


int
compareuser(int state){
 579:	55                   	push   %ebp
 57a:	89 e5                	mov    %esp,%ebp
 57c:	56                   	push   %esi
 57d:	53                   	push   %ebx
 57e:	81 ec 30 01 00 00    	sub    $0x130,%esp
	struct USER u1,u2;
	struct USER users[20];
	u1.name = "john\n";
 584:	c7 45 e8 e7 0c 00 00 	movl   $0xce7,-0x18(%ebp)
	u1.pass = "1234\n";
 58b:	c7 45 ec ed 0c 00 00 	movl   $0xced,-0x14(%ebp)
	u1.ulevel = 0;
 592:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	u2.name = "james\n";
 599:	c7 45 dc f3 0c 00 00 	movl   $0xcf3,-0x24(%ebp)
	u2.pass = "pass\n";
 5a0:	c7 45 e0 fa 0c 00 00 	movl   $0xcfa,-0x20(%ebp)
	u2.ulevel = 1;
 5a7:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	users[0] = u1;
 5ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
 5b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5ba:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
 5c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5c3:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
	users[1] = u2;
 5c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
 5cc:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
 5d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
 5d5:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
 5db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5de:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
	
	
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
 5e4:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
 5ea:	89 04 24             	mov    %eax,(%esp)
 5ed:	e8 fa fe ff ff       	call   4ec <readuser>
 5f2:	83 ec 04             	sub    $0x4,%esp
		
		for(ctr = 0; ctr < 20; ctr++)
 5f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 5fc:	e9 a4 00 00 00       	jmp    6a5 <compareuser+0x12c>
		{

			if(strcmp_c(u.name,users[ctr].name) == 0 && strcmp_c(u.pass,users[ctr].pass) == 0)
 601:	8b 55 f4             	mov    -0xc(%ebp),%edx
 604:	89 d0                	mov    %edx,%eax
 606:	01 c0                	add    %eax,%eax
 608:	01 d0                	add    %edx,%eax
 60a:	c1 e0 02             	shl    $0x2,%eax
 60d:	8d 4d f8             	lea    -0x8(%ebp),%ecx
 610:	01 c8                	add    %ecx,%eax
 612:	2d 0c 01 00 00       	sub    $0x10c,%eax
 617:	8b 10                	mov    (%eax),%edx
 619:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
 61f:	89 54 24 04          	mov    %edx,0x4(%esp)
 623:	89 04 24             	mov    %eax,(%esp)
 626:	e8 75 fe ff ff       	call   4a0 <strcmp_c>
 62b:	85 c0                	test   %eax,%eax
 62d:	75 72                	jne    6a1 <compareuser+0x128>
 62f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 632:	89 d0                	mov    %edx,%eax
 634:	01 c0                	add    %eax,%eax
 636:	01 d0                	add    %edx,%eax
 638:	c1 e0 02             	shl    $0x2,%eax
 63b:	8d 5d f8             	lea    -0x8(%ebp),%ebx
 63e:	01 d8                	add    %ebx,%eax
 640:	2d 08 01 00 00       	sub    $0x108,%eax
 645:	8b 10                	mov    (%eax),%edx
 647:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
 64d:	89 54 24 04          	mov    %edx,0x4(%esp)
 651:	89 04 24             	mov    %eax,(%esp)
 654:	e8 47 fe ff ff       	call   4a0 <strcmp_c>
 659:	85 c0                	test   %eax,%eax
 65b:	75 44                	jne    6a1 <compareuser+0x128>
			{
				setuser(users[ctr].ulevel);
 65d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 660:	89 d0                	mov    %edx,%eax
 662:	01 c0                	add    %eax,%eax
 664:	01 d0                	add    %edx,%eax
 666:	c1 e0 02             	shl    $0x2,%eax
 669:	8d 75 f8             	lea    -0x8(%ebp),%esi
 66c:	01 f0                	add    %esi,%eax
 66e:	2d 04 01 00 00       	sub    $0x104,%eax
 673:	8b 00                	mov    (%eax),%eax
 675:	89 04 24             	mov    %eax,(%esp)
 678:	e8 0f 01 00 00       	call   78c <setuser>
				
				printf(1,"%d",getuser());
 67d:	e8 02 01 00 00       	call   784 <getuser>
 682:	89 44 24 08          	mov    %eax,0x8(%esp)
 686:	c7 44 24 04 00 0d 00 	movl   $0xd00,0x4(%esp)
 68d:	00 
 68e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 695:	e8 da 01 00 00       	call   874 <printf>
				return 1;
 69a:	b8 01 00 00 00       	mov    $0x1,%eax
 69f:	eb 34                	jmp    6d5 <compareuser+0x15c>
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
		
		for(ctr = 0; ctr < 20; ctr++)
 6a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 6a5:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 6a9:	0f 8e 52 ff ff ff    	jle    601 <compareuser+0x88>
				
				printf(1,"%d",getuser());
				return 1;
			}
		}
		printf(1,"Invalid username/password\n");
 6af:	c7 44 24 04 03 0d 00 	movl   $0xd03,0x4(%esp)
 6b6:	00 
 6b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 6be:	e8 b1 01 00 00       	call   874 <printf>
		if(state != 1)
 6c3:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 6c7:	74 07                	je     6d0 <compareuser+0x157>
			break;
	}
	return 0;
 6c9:	b8 00 00 00 00       	mov    $0x0,%eax
 6ce:	eb 05                	jmp    6d5 <compareuser+0x15c>
			}
		}
		printf(1,"Invalid username/password\n");
		if(state != 1)
			break;
	}
 6d0:	e9 0f ff ff ff       	jmp    5e4 <compareuser+0x6b>
	return 0;
}
 6d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
 6d8:	5b                   	pop    %ebx
 6d9:	5e                   	pop    %esi
 6da:	5d                   	pop    %ebp
 6db:	c3                   	ret    

000006dc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 6dc:	b8 01 00 00 00       	mov    $0x1,%eax
 6e1:	cd 40                	int    $0x40
 6e3:	c3                   	ret    

000006e4 <exit>:
SYSCALL(exit)
 6e4:	b8 02 00 00 00       	mov    $0x2,%eax
 6e9:	cd 40                	int    $0x40
 6eb:	c3                   	ret    

000006ec <wait>:
SYSCALL(wait)
 6ec:	b8 03 00 00 00       	mov    $0x3,%eax
 6f1:	cd 40                	int    $0x40
 6f3:	c3                   	ret    

000006f4 <pipe>:
SYSCALL(pipe)
 6f4:	b8 04 00 00 00       	mov    $0x4,%eax
 6f9:	cd 40                	int    $0x40
 6fb:	c3                   	ret    

000006fc <read>:
SYSCALL(read)
 6fc:	b8 05 00 00 00       	mov    $0x5,%eax
 701:	cd 40                	int    $0x40
 703:	c3                   	ret    

00000704 <write>:
SYSCALL(write)
 704:	b8 10 00 00 00       	mov    $0x10,%eax
 709:	cd 40                	int    $0x40
 70b:	c3                   	ret    

0000070c <close>:
SYSCALL(close)
 70c:	b8 15 00 00 00       	mov    $0x15,%eax
 711:	cd 40                	int    $0x40
 713:	c3                   	ret    

00000714 <kill>:
SYSCALL(kill)
 714:	b8 06 00 00 00       	mov    $0x6,%eax
 719:	cd 40                	int    $0x40
 71b:	c3                   	ret    

0000071c <exec>:
SYSCALL(exec)
 71c:	b8 07 00 00 00       	mov    $0x7,%eax
 721:	cd 40                	int    $0x40
 723:	c3                   	ret    

00000724 <open>:
SYSCALL(open)
 724:	b8 0f 00 00 00       	mov    $0xf,%eax
 729:	cd 40                	int    $0x40
 72b:	c3                   	ret    

0000072c <mknod>:
SYSCALL(mknod)
 72c:	b8 11 00 00 00       	mov    $0x11,%eax
 731:	cd 40                	int    $0x40
 733:	c3                   	ret    

00000734 <unlink>:
SYSCALL(unlink)
 734:	b8 12 00 00 00       	mov    $0x12,%eax
 739:	cd 40                	int    $0x40
 73b:	c3                   	ret    

0000073c <fstat>:
SYSCALL(fstat)
 73c:	b8 08 00 00 00       	mov    $0x8,%eax
 741:	cd 40                	int    $0x40
 743:	c3                   	ret    

00000744 <link>:
SYSCALL(link)
 744:	b8 13 00 00 00       	mov    $0x13,%eax
 749:	cd 40                	int    $0x40
 74b:	c3                   	ret    

0000074c <mkdir>:
SYSCALL(mkdir)
 74c:	b8 14 00 00 00       	mov    $0x14,%eax
 751:	cd 40                	int    $0x40
 753:	c3                   	ret    

00000754 <chdir>:
SYSCALL(chdir)
 754:	b8 09 00 00 00       	mov    $0x9,%eax
 759:	cd 40                	int    $0x40
 75b:	c3                   	ret    

0000075c <dup>:
SYSCALL(dup)
 75c:	b8 0a 00 00 00       	mov    $0xa,%eax
 761:	cd 40                	int    $0x40
 763:	c3                   	ret    

00000764 <getpid>:
SYSCALL(getpid)
 764:	b8 0b 00 00 00       	mov    $0xb,%eax
 769:	cd 40                	int    $0x40
 76b:	c3                   	ret    

0000076c <sbrk>:
SYSCALL(sbrk)
 76c:	b8 0c 00 00 00       	mov    $0xc,%eax
 771:	cd 40                	int    $0x40
 773:	c3                   	ret    

00000774 <sleep>:
SYSCALL(sleep)
 774:	b8 0d 00 00 00       	mov    $0xd,%eax
 779:	cd 40                	int    $0x40
 77b:	c3                   	ret    

0000077c <uptime>:
SYSCALL(uptime)
 77c:	b8 0e 00 00 00       	mov    $0xe,%eax
 781:	cd 40                	int    $0x40
 783:	c3                   	ret    

00000784 <getuser>:
SYSCALL(getuser)
 784:	b8 16 00 00 00       	mov    $0x16,%eax
 789:	cd 40                	int    $0x40
 78b:	c3                   	ret    

0000078c <setuser>:
SYSCALL(setuser)
 78c:	b8 17 00 00 00       	mov    $0x17,%eax
 791:	cd 40                	int    $0x40
 793:	c3                   	ret    

00000794 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 794:	55                   	push   %ebp
 795:	89 e5                	mov    %esp,%ebp
 797:	83 ec 18             	sub    $0x18,%esp
 79a:	8b 45 0c             	mov    0xc(%ebp),%eax
 79d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 7a0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7a7:	00 
 7a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 7ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 7af:	8b 45 08             	mov    0x8(%ebp),%eax
 7b2:	89 04 24             	mov    %eax,(%esp)
 7b5:	e8 4a ff ff ff       	call   704 <write>
}
 7ba:	c9                   	leave  
 7bb:	c3                   	ret    

000007bc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7bc:	55                   	push   %ebp
 7bd:	89 e5                	mov    %esp,%ebp
 7bf:	56                   	push   %esi
 7c0:	53                   	push   %ebx
 7c1:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 7cb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 7cf:	74 17                	je     7e8 <printint+0x2c>
 7d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 7d5:	79 11                	jns    7e8 <printint+0x2c>
    neg = 1;
 7d7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 7de:	8b 45 0c             	mov    0xc(%ebp),%eax
 7e1:	f7 d8                	neg    %eax
 7e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7e6:	eb 06                	jmp    7ee <printint+0x32>
  } else {
    x = xx;
 7e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 7eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 7ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 7f5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 7f8:	8d 41 01             	lea    0x1(%ecx),%eax
 7fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
 801:	8b 45 ec             	mov    -0x14(%ebp),%eax
 804:	ba 00 00 00 00       	mov    $0x0,%edx
 809:	f7 f3                	div    %ebx
 80b:	89 d0                	mov    %edx,%eax
 80d:	0f b6 80 48 10 00 00 	movzbl 0x1048(%eax),%eax
 814:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 818:	8b 75 10             	mov    0x10(%ebp),%esi
 81b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 81e:	ba 00 00 00 00       	mov    $0x0,%edx
 823:	f7 f6                	div    %esi
 825:	89 45 ec             	mov    %eax,-0x14(%ebp)
 828:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 82c:	75 c7                	jne    7f5 <printint+0x39>
  if(neg)
 82e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 832:	74 10                	je     844 <printint+0x88>
    buf[i++] = '-';
 834:	8b 45 f4             	mov    -0xc(%ebp),%eax
 837:	8d 50 01             	lea    0x1(%eax),%edx
 83a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 83d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 842:	eb 1f                	jmp    863 <printint+0xa7>
 844:	eb 1d                	jmp    863 <printint+0xa7>
    putc(fd, buf[i]);
 846:	8d 55 dc             	lea    -0x24(%ebp),%edx
 849:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84c:	01 d0                	add    %edx,%eax
 84e:	0f b6 00             	movzbl (%eax),%eax
 851:	0f be c0             	movsbl %al,%eax
 854:	89 44 24 04          	mov    %eax,0x4(%esp)
 858:	8b 45 08             	mov    0x8(%ebp),%eax
 85b:	89 04 24             	mov    %eax,(%esp)
 85e:	e8 31 ff ff ff       	call   794 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 863:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 867:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 86b:	79 d9                	jns    846 <printint+0x8a>
    putc(fd, buf[i]);
}
 86d:	83 c4 30             	add    $0x30,%esp
 870:	5b                   	pop    %ebx
 871:	5e                   	pop    %esi
 872:	5d                   	pop    %ebp
 873:	c3                   	ret    

00000874 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 874:	55                   	push   %ebp
 875:	89 e5                	mov    %esp,%ebp
 877:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 87a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 881:	8d 45 0c             	lea    0xc(%ebp),%eax
 884:	83 c0 04             	add    $0x4,%eax
 887:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 88a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 891:	e9 7c 01 00 00       	jmp    a12 <printf+0x19e>
    c = fmt[i] & 0xff;
 896:	8b 55 0c             	mov    0xc(%ebp),%edx
 899:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89c:	01 d0                	add    %edx,%eax
 89e:	0f b6 00             	movzbl (%eax),%eax
 8a1:	0f be c0             	movsbl %al,%eax
 8a4:	25 ff 00 00 00       	and    $0xff,%eax
 8a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 8ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8b0:	75 2c                	jne    8de <printf+0x6a>
      if(c == '%'){
 8b2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8b6:	75 0c                	jne    8c4 <printf+0x50>
        state = '%';
 8b8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 8bf:	e9 4a 01 00 00       	jmp    a0e <printf+0x19a>
      } else {
        putc(fd, c);
 8c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8c7:	0f be c0             	movsbl %al,%eax
 8ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 8ce:	8b 45 08             	mov    0x8(%ebp),%eax
 8d1:	89 04 24             	mov    %eax,(%esp)
 8d4:	e8 bb fe ff ff       	call   794 <putc>
 8d9:	e9 30 01 00 00       	jmp    a0e <printf+0x19a>
      }
    } else if(state == '%'){
 8de:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 8e2:	0f 85 26 01 00 00    	jne    a0e <printf+0x19a>
      if(c == 'd'){
 8e8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 8ec:	75 2d                	jne    91b <printf+0xa7>
        printint(fd, *ap, 10, 1);
 8ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8f1:	8b 00                	mov    (%eax),%eax
 8f3:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 8fa:	00 
 8fb:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 902:	00 
 903:	89 44 24 04          	mov    %eax,0x4(%esp)
 907:	8b 45 08             	mov    0x8(%ebp),%eax
 90a:	89 04 24             	mov    %eax,(%esp)
 90d:	e8 aa fe ff ff       	call   7bc <printint>
        ap++;
 912:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 916:	e9 ec 00 00 00       	jmp    a07 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 91b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 91f:	74 06                	je     927 <printf+0xb3>
 921:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 925:	75 2d                	jne    954 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 927:	8b 45 e8             	mov    -0x18(%ebp),%eax
 92a:	8b 00                	mov    (%eax),%eax
 92c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 933:	00 
 934:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 93b:	00 
 93c:	89 44 24 04          	mov    %eax,0x4(%esp)
 940:	8b 45 08             	mov    0x8(%ebp),%eax
 943:	89 04 24             	mov    %eax,(%esp)
 946:	e8 71 fe ff ff       	call   7bc <printint>
        ap++;
 94b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 94f:	e9 b3 00 00 00       	jmp    a07 <printf+0x193>
      } else if(c == 's'){
 954:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 958:	75 45                	jne    99f <printf+0x12b>
        s = (char*)*ap;
 95a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 95d:	8b 00                	mov    (%eax),%eax
 95f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 962:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 966:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 96a:	75 09                	jne    975 <printf+0x101>
          s = "(null)";
 96c:	c7 45 f4 1e 0d 00 00 	movl   $0xd1e,-0xc(%ebp)
        while(*s != 0){
 973:	eb 1e                	jmp    993 <printf+0x11f>
 975:	eb 1c                	jmp    993 <printf+0x11f>
          putc(fd, *s);
 977:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97a:	0f b6 00             	movzbl (%eax),%eax
 97d:	0f be c0             	movsbl %al,%eax
 980:	89 44 24 04          	mov    %eax,0x4(%esp)
 984:	8b 45 08             	mov    0x8(%ebp),%eax
 987:	89 04 24             	mov    %eax,(%esp)
 98a:	e8 05 fe ff ff       	call   794 <putc>
          s++;
 98f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 993:	8b 45 f4             	mov    -0xc(%ebp),%eax
 996:	0f b6 00             	movzbl (%eax),%eax
 999:	84 c0                	test   %al,%al
 99b:	75 da                	jne    977 <printf+0x103>
 99d:	eb 68                	jmp    a07 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 99f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 9a3:	75 1d                	jne    9c2 <printf+0x14e>
        putc(fd, *ap);
 9a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9a8:	8b 00                	mov    (%eax),%eax
 9aa:	0f be c0             	movsbl %al,%eax
 9ad:	89 44 24 04          	mov    %eax,0x4(%esp)
 9b1:	8b 45 08             	mov    0x8(%ebp),%eax
 9b4:	89 04 24             	mov    %eax,(%esp)
 9b7:	e8 d8 fd ff ff       	call   794 <putc>
        ap++;
 9bc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9c0:	eb 45                	jmp    a07 <printf+0x193>
      } else if(c == '%'){
 9c2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9c6:	75 17                	jne    9df <printf+0x16b>
        putc(fd, c);
 9c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9cb:	0f be c0             	movsbl %al,%eax
 9ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 9d2:	8b 45 08             	mov    0x8(%ebp),%eax
 9d5:	89 04 24             	mov    %eax,(%esp)
 9d8:	e8 b7 fd ff ff       	call   794 <putc>
 9dd:	eb 28                	jmp    a07 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9df:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 9e6:	00 
 9e7:	8b 45 08             	mov    0x8(%ebp),%eax
 9ea:	89 04 24             	mov    %eax,(%esp)
 9ed:	e8 a2 fd ff ff       	call   794 <putc>
        putc(fd, c);
 9f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9f5:	0f be c0             	movsbl %al,%eax
 9f8:	89 44 24 04          	mov    %eax,0x4(%esp)
 9fc:	8b 45 08             	mov    0x8(%ebp),%eax
 9ff:	89 04 24             	mov    %eax,(%esp)
 a02:	e8 8d fd ff ff       	call   794 <putc>
      }
      state = 0;
 a07:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a0e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 a12:	8b 55 0c             	mov    0xc(%ebp),%edx
 a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a18:	01 d0                	add    %edx,%eax
 a1a:	0f b6 00             	movzbl (%eax),%eax
 a1d:	84 c0                	test   %al,%al
 a1f:	0f 85 71 fe ff ff    	jne    896 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 a25:	c9                   	leave  
 a26:	c3                   	ret    

00000a27 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a27:	55                   	push   %ebp
 a28:	89 e5                	mov    %esp,%ebp
 a2a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a2d:	8b 45 08             	mov    0x8(%ebp),%eax
 a30:	83 e8 08             	sub    $0x8,%eax
 a33:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a36:	a1 68 10 00 00       	mov    0x1068,%eax
 a3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a3e:	eb 24                	jmp    a64 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a40:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a43:	8b 00                	mov    (%eax),%eax
 a45:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a48:	77 12                	ja     a5c <free+0x35>
 a4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a4d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a50:	77 24                	ja     a76 <free+0x4f>
 a52:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a55:	8b 00                	mov    (%eax),%eax
 a57:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a5a:	77 1a                	ja     a76 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5f:	8b 00                	mov    (%eax),%eax
 a61:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a64:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a67:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a6a:	76 d4                	jbe    a40 <free+0x19>
 a6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a6f:	8b 00                	mov    (%eax),%eax
 a71:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a74:	76 ca                	jbe    a40 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a76:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a79:	8b 40 04             	mov    0x4(%eax),%eax
 a7c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a83:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a86:	01 c2                	add    %eax,%edx
 a88:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a8b:	8b 00                	mov    (%eax),%eax
 a8d:	39 c2                	cmp    %eax,%edx
 a8f:	75 24                	jne    ab5 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a91:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a94:	8b 50 04             	mov    0x4(%eax),%edx
 a97:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a9a:	8b 00                	mov    (%eax),%eax
 a9c:	8b 40 04             	mov    0x4(%eax),%eax
 a9f:	01 c2                	add    %eax,%edx
 aa1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aa4:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 aa7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aaa:	8b 00                	mov    (%eax),%eax
 aac:	8b 10                	mov    (%eax),%edx
 aae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ab1:	89 10                	mov    %edx,(%eax)
 ab3:	eb 0a                	jmp    abf <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 ab5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab8:	8b 10                	mov    (%eax),%edx
 aba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 abd:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 abf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac2:	8b 40 04             	mov    0x4(%eax),%eax
 ac5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 acc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 acf:	01 d0                	add    %edx,%eax
 ad1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ad4:	75 20                	jne    af6 <free+0xcf>
    p->s.size += bp->s.size;
 ad6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ad9:	8b 50 04             	mov    0x4(%eax),%edx
 adc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 adf:	8b 40 04             	mov    0x4(%eax),%eax
 ae2:	01 c2                	add    %eax,%edx
 ae4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ae7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 aea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aed:	8b 10                	mov    (%eax),%edx
 aef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 af2:	89 10                	mov    %edx,(%eax)
 af4:	eb 08                	jmp    afe <free+0xd7>
  } else
    p->s.ptr = bp;
 af6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 af9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 afc:	89 10                	mov    %edx,(%eax)
  freep = p;
 afe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b01:	a3 68 10 00 00       	mov    %eax,0x1068
}
 b06:	c9                   	leave  
 b07:	c3                   	ret    

00000b08 <morecore>:

static Header*
morecore(uint nu)
{
 b08:	55                   	push   %ebp
 b09:	89 e5                	mov    %esp,%ebp
 b0b:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b0e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b15:	77 07                	ja     b1e <morecore+0x16>
    nu = 4096;
 b17:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b1e:	8b 45 08             	mov    0x8(%ebp),%eax
 b21:	c1 e0 03             	shl    $0x3,%eax
 b24:	89 04 24             	mov    %eax,(%esp)
 b27:	e8 40 fc ff ff       	call   76c <sbrk>
 b2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b2f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b33:	75 07                	jne    b3c <morecore+0x34>
    return 0;
 b35:	b8 00 00 00 00       	mov    $0x0,%eax
 b3a:	eb 22                	jmp    b5e <morecore+0x56>
  hp = (Header*)p;
 b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b45:	8b 55 08             	mov    0x8(%ebp),%edx
 b48:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b4e:	83 c0 08             	add    $0x8,%eax
 b51:	89 04 24             	mov    %eax,(%esp)
 b54:	e8 ce fe ff ff       	call   a27 <free>
  return freep;
 b59:	a1 68 10 00 00       	mov    0x1068,%eax
}
 b5e:	c9                   	leave  
 b5f:	c3                   	ret    

00000b60 <malloc>:

void*
malloc(uint nbytes)
{
 b60:	55                   	push   %ebp
 b61:	89 e5                	mov    %esp,%ebp
 b63:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b66:	8b 45 08             	mov    0x8(%ebp),%eax
 b69:	83 c0 07             	add    $0x7,%eax
 b6c:	c1 e8 03             	shr    $0x3,%eax
 b6f:	83 c0 01             	add    $0x1,%eax
 b72:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b75:	a1 68 10 00 00       	mov    0x1068,%eax
 b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b81:	75 23                	jne    ba6 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b83:	c7 45 f0 60 10 00 00 	movl   $0x1060,-0x10(%ebp)
 b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b8d:	a3 68 10 00 00       	mov    %eax,0x1068
 b92:	a1 68 10 00 00       	mov    0x1068,%eax
 b97:	a3 60 10 00 00       	mov    %eax,0x1060
    base.s.size = 0;
 b9c:	c7 05 64 10 00 00 00 	movl   $0x0,0x1064
 ba3:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ba9:	8b 00                	mov    (%eax),%eax
 bab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bb1:	8b 40 04             	mov    0x4(%eax),%eax
 bb4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bb7:	72 4d                	jb     c06 <malloc+0xa6>
      if(p->s.size == nunits)
 bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bbc:	8b 40 04             	mov    0x4(%eax),%eax
 bbf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bc2:	75 0c                	jne    bd0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bc7:	8b 10                	mov    (%eax),%edx
 bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bcc:	89 10                	mov    %edx,(%eax)
 bce:	eb 26                	jmp    bf6 <malloc+0x96>
      else {
        p->s.size -= nunits;
 bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd3:	8b 40 04             	mov    0x4(%eax),%eax
 bd6:	2b 45 ec             	sub    -0x14(%ebp),%eax
 bd9:	89 c2                	mov    %eax,%edx
 bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bde:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 be4:	8b 40 04             	mov    0x4(%eax),%eax
 be7:	c1 e0 03             	shl    $0x3,%eax
 bea:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf0:	8b 55 ec             	mov    -0x14(%ebp),%edx
 bf3:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bf9:	a3 68 10 00 00       	mov    %eax,0x1068
      return (void*)(p + 1);
 bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c01:	83 c0 08             	add    $0x8,%eax
 c04:	eb 38                	jmp    c3e <malloc+0xde>
    }
    if(p == freep)
 c06:	a1 68 10 00 00       	mov    0x1068,%eax
 c0b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c0e:	75 1b                	jne    c2b <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 c10:	8b 45 ec             	mov    -0x14(%ebp),%eax
 c13:	89 04 24             	mov    %eax,(%esp)
 c16:	e8 ed fe ff ff       	call   b08 <morecore>
 c1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c22:	75 07                	jne    c2b <malloc+0xcb>
        return 0;
 c24:	b8 00 00 00 00       	mov    $0x0,%eax
 c29:	eb 13                	jmp    c3e <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c34:	8b 00                	mov    (%eax),%eax
 c36:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 c39:	e9 70 ff ff ff       	jmp    bae <malloc+0x4e>
}
 c3e:	c9                   	leave  
 c3f:	c3                   	ret    
