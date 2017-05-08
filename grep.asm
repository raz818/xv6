
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
   d:	e9 c6 00 00 00       	jmp    d8 <grep+0xd8>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    buf[m] = '\0';
  18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1b:	05 00 12 00 00       	add    $0x1200,%eax
  20:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
  23:	c7 45 f0 00 12 00 00 	movl   $0x1200,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  2a:	eb 51                	jmp    7d <grep+0x7d>
      *q = 0;
  2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2f:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  35:	89 44 24 04          	mov    %eax,0x4(%esp)
  39:	8b 45 08             	mov    0x8(%ebp),%eax
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 bc 01 00 00       	call   200 <match>
  44:	85 c0                	test   %eax,%eax
  46:	74 2c                	je     74 <grep+0x74>
        *q = '\n';
  48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  4b:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  51:	83 c0 01             	add    $0x1,%eax
  54:	89 c2                	mov    %eax,%edx
  56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  59:	29 c2                	sub    %eax,%edx
  5b:	89 d0                	mov    %edx,%eax
  5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  64:	89 44 24 04          	mov    %eax,0x4(%esp)
  68:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  6f:	e8 e7 07 00 00       	call   85b <write>
      }
      p = q+1;
  74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  77:	83 c0 01             	add    $0x1,%eax
  7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    m += n;
    buf[m] = '\0';
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  7d:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  84:	00 
  85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  88:	89 04 24             	mov    %eax,(%esp)
  8b:	e8 e6 03 00 00       	call   476 <strchr>
  90:	89 45 e8             	mov    %eax,-0x18(%ebp)
  93:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  97:	75 93                	jne    2c <grep+0x2c>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  99:	81 7d f0 00 12 00 00 	cmpl   $0x1200,-0x10(%ebp)
  a0:	75 07                	jne    a9 <grep+0xa9>
      m = 0;
  a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  ad:	7e 29                	jle    d8 <grep+0xd8>
      m -= p - buf;
  af:	ba 00 12 00 00       	mov    $0x1200,%edx
  b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  b7:	29 c2                	sub    %eax,%edx
  b9:	89 d0                	mov    %edx,%eax
  bb:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  cc:	c7 04 24 00 12 00 00 	movl   $0x1200,(%esp)
  d3:	e8 e2 04 00 00       	call   5ba <memmove>
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  db:	ba ff 03 00 00       	mov    $0x3ff,%edx
  e0:	29 c2                	sub    %eax,%edx
  e2:	89 d0                	mov    %edx,%eax
  e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  e7:	81 c2 00 12 00 00    	add    $0x1200,%edx
  ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  f8:	89 04 24             	mov    %eax,(%esp)
  fb:	e8 53 07 00 00       	call   853 <read>
 100:	89 45 ec             	mov    %eax,-0x14(%ebp)
 103:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 107:	0f 8f 05 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
 10d:	c9                   	leave  
 10e:	c3                   	ret    

0000010f <main>:

int
main(int argc, char *argv[])
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	83 e4 f0             	and    $0xfffffff0,%esp
 115:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 118:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 11c:	7f 19                	jg     137 <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
 11e:	c7 44 24 04 98 0d 00 	movl   $0xd98,0x4(%esp)
 125:	00 
 126:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 12d:	e8 99 08 00 00       	call   9cb <printf>
    exit();
 132:	e8 04 07 00 00       	call   83b <exit>
  }
  pattern = argv[1];
 137:	8b 45 0c             	mov    0xc(%ebp),%eax
 13a:	8b 40 04             	mov    0x4(%eax),%eax
 13d:	89 44 24 18          	mov    %eax,0x18(%esp)
  
  if(argc <= 2){
 141:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 145:	7f 19                	jg     160 <main+0x51>
    grep(pattern, 0);
 147:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 14e:	00 
 14f:	8b 44 24 18          	mov    0x18(%esp),%eax
 153:	89 04 24             	mov    %eax,(%esp)
 156:	e8 a5 fe ff ff       	call   0 <grep>
    exit();
 15b:	e8 db 06 00 00       	call   83b <exit>
  }

  for(i = 2; i < argc; i++){
 160:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
 167:	00 
 168:	e9 81 00 00 00       	jmp    1ee <main+0xdf>
    if((fd = open(argv[i], 0)) < 0){
 16d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 171:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 178:	8b 45 0c             	mov    0xc(%ebp),%eax
 17b:	01 d0                	add    %edx,%eax
 17d:	8b 00                	mov    (%eax),%eax
 17f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 186:	00 
 187:	89 04 24             	mov    %eax,(%esp)
 18a:	e8 ec 06 00 00       	call   87b <open>
 18f:	89 44 24 14          	mov    %eax,0x14(%esp)
 193:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 198:	79 2f                	jns    1c9 <main+0xba>
      printf(1, "grep: cannot open %s\n", argv[i]);
 19a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 19e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 1a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a8:	01 d0                	add    %edx,%eax
 1aa:	8b 00                	mov    (%eax),%eax
 1ac:	89 44 24 08          	mov    %eax,0x8(%esp)
 1b0:	c7 44 24 04 b8 0d 00 	movl   $0xdb8,0x4(%esp)
 1b7:	00 
 1b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1bf:	e8 07 08 00 00       	call   9cb <printf>
      exit();
 1c4:	e8 72 06 00 00       	call   83b <exit>
    }
    grep(pattern, fd);
 1c9:	8b 44 24 14          	mov    0x14(%esp),%eax
 1cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d1:	8b 44 24 18          	mov    0x18(%esp),%eax
 1d5:	89 04 24             	mov    %eax,(%esp)
 1d8:	e8 23 fe ff ff       	call   0 <grep>
    close(fd);
 1dd:	8b 44 24 14          	mov    0x14(%esp),%eax
 1e1:	89 04 24             	mov    %eax,(%esp)
 1e4:	e8 7a 06 00 00       	call   863 <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1e9:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1ee:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1f2:	3b 45 08             	cmp    0x8(%ebp),%eax
 1f5:	0f 8c 72 ff ff ff    	jl     16d <main+0x5e>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1fb:	e8 3b 06 00 00       	call   83b <exit>

00000200 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
 206:	8b 45 08             	mov    0x8(%ebp),%eax
 209:	0f b6 00             	movzbl (%eax),%eax
 20c:	3c 5e                	cmp    $0x5e,%al
 20e:	75 17                	jne    227 <match+0x27>
    return matchhere(re+1, text);
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	8d 50 01             	lea    0x1(%eax),%edx
 216:	8b 45 0c             	mov    0xc(%ebp),%eax
 219:	89 44 24 04          	mov    %eax,0x4(%esp)
 21d:	89 14 24             	mov    %edx,(%esp)
 220:	e8 36 00 00 00       	call   25b <matchhere>
 225:	eb 32                	jmp    259 <match+0x59>
  do{  // must look at empty string
    if(matchhere(re, text))
 227:	8b 45 0c             	mov    0xc(%ebp),%eax
 22a:	89 44 24 04          	mov    %eax,0x4(%esp)
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
 231:	89 04 24             	mov    %eax,(%esp)
 234:	e8 22 00 00 00       	call   25b <matchhere>
 239:	85 c0                	test   %eax,%eax
 23b:	74 07                	je     244 <match+0x44>
      return 1;
 23d:	b8 01 00 00 00       	mov    $0x1,%eax
 242:	eb 15                	jmp    259 <match+0x59>
  }while(*text++ != '\0');
 244:	8b 45 0c             	mov    0xc(%ebp),%eax
 247:	8d 50 01             	lea    0x1(%eax),%edx
 24a:	89 55 0c             	mov    %edx,0xc(%ebp)
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	84 c0                	test   %al,%al
 252:	75 d3                	jne    227 <match+0x27>
  return 0;
 254:	b8 00 00 00 00       	mov    $0x0,%eax
}
 259:	c9                   	leave  
 25a:	c3                   	ret    

0000025b <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 25b:	55                   	push   %ebp
 25c:	89 e5                	mov    %esp,%ebp
 25e:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	0f b6 00             	movzbl (%eax),%eax
 267:	84 c0                	test   %al,%al
 269:	75 0a                	jne    275 <matchhere+0x1a>
    return 1;
 26b:	b8 01 00 00 00       	mov    $0x1,%eax
 270:	e9 9b 00 00 00       	jmp    310 <matchhere+0xb5>
  if(re[1] == '*')
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	83 c0 01             	add    $0x1,%eax
 27b:	0f b6 00             	movzbl (%eax),%eax
 27e:	3c 2a                	cmp    $0x2a,%al
 280:	75 24                	jne    2a6 <matchhere+0x4b>
    return matchstar(re[0], re+2, text);
 282:	8b 45 08             	mov    0x8(%ebp),%eax
 285:	8d 48 02             	lea    0x2(%eax),%ecx
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	0f b6 00             	movzbl (%eax),%eax
 28e:	0f be c0             	movsbl %al,%eax
 291:	8b 55 0c             	mov    0xc(%ebp),%edx
 294:	89 54 24 08          	mov    %edx,0x8(%esp)
 298:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 29c:	89 04 24             	mov    %eax,(%esp)
 29f:	e8 6e 00 00 00       	call   312 <matchstar>
 2a4:	eb 6a                	jmp    310 <matchhere+0xb5>
  if(re[0] == '$' && re[1] == '\0')
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	0f b6 00             	movzbl (%eax),%eax
 2ac:	3c 24                	cmp    $0x24,%al
 2ae:	75 1d                	jne    2cd <matchhere+0x72>
 2b0:	8b 45 08             	mov    0x8(%ebp),%eax
 2b3:	83 c0 01             	add    $0x1,%eax
 2b6:	0f b6 00             	movzbl (%eax),%eax
 2b9:	84 c0                	test   %al,%al
 2bb:	75 10                	jne    2cd <matchhere+0x72>
    return *text == '\0';
 2bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c0:	0f b6 00             	movzbl (%eax),%eax
 2c3:	84 c0                	test   %al,%al
 2c5:	0f 94 c0             	sete   %al
 2c8:	0f b6 c0             	movzbl %al,%eax
 2cb:	eb 43                	jmp    310 <matchhere+0xb5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d0:	0f b6 00             	movzbl (%eax),%eax
 2d3:	84 c0                	test   %al,%al
 2d5:	74 34                	je     30b <matchhere+0xb0>
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
 2da:	0f b6 00             	movzbl (%eax),%eax
 2dd:	3c 2e                	cmp    $0x2e,%al
 2df:	74 10                	je     2f1 <matchhere+0x96>
 2e1:	8b 45 08             	mov    0x8(%ebp),%eax
 2e4:	0f b6 10             	movzbl (%eax),%edx
 2e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ea:	0f b6 00             	movzbl (%eax),%eax
 2ed:	38 c2                	cmp    %al,%dl
 2ef:	75 1a                	jne    30b <matchhere+0xb0>
    return matchhere(re+1, text+1);
 2f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	8b 45 08             	mov    0x8(%ebp),%eax
 2fa:	83 c0 01             	add    $0x1,%eax
 2fd:	89 54 24 04          	mov    %edx,0x4(%esp)
 301:	89 04 24             	mov    %eax,(%esp)
 304:	e8 52 ff ff ff       	call   25b <matchhere>
 309:	eb 05                	jmp    310 <matchhere+0xb5>
  return 0;
 30b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 310:	c9                   	leave  
 311:	c3                   	ret    

00000312 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 312:	55                   	push   %ebp
 313:	89 e5                	mov    %esp,%ebp
 315:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 318:	8b 45 10             	mov    0x10(%ebp),%eax
 31b:	89 44 24 04          	mov    %eax,0x4(%esp)
 31f:	8b 45 0c             	mov    0xc(%ebp),%eax
 322:	89 04 24             	mov    %eax,(%esp)
 325:	e8 31 ff ff ff       	call   25b <matchhere>
 32a:	85 c0                	test   %eax,%eax
 32c:	74 07                	je     335 <matchstar+0x23>
      return 1;
 32e:	b8 01 00 00 00       	mov    $0x1,%eax
 333:	eb 29                	jmp    35e <matchstar+0x4c>
  }while(*text!='\0' && (*text++==c || c=='.'));
 335:	8b 45 10             	mov    0x10(%ebp),%eax
 338:	0f b6 00             	movzbl (%eax),%eax
 33b:	84 c0                	test   %al,%al
 33d:	74 1a                	je     359 <matchstar+0x47>
 33f:	8b 45 10             	mov    0x10(%ebp),%eax
 342:	8d 50 01             	lea    0x1(%eax),%edx
 345:	89 55 10             	mov    %edx,0x10(%ebp)
 348:	0f b6 00             	movzbl (%eax),%eax
 34b:	0f be c0             	movsbl %al,%eax
 34e:	3b 45 08             	cmp    0x8(%ebp),%eax
 351:	74 c5                	je     318 <matchstar+0x6>
 353:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 357:	74 bf                	je     318 <matchstar+0x6>
  return 0;
 359:	b8 00 00 00 00       	mov    $0x0,%eax
}
 35e:	c9                   	leave  
 35f:	c3                   	ret    

00000360 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 365:	8b 4d 08             	mov    0x8(%ebp),%ecx
 368:	8b 55 10             	mov    0x10(%ebp),%edx
 36b:	8b 45 0c             	mov    0xc(%ebp),%eax
 36e:	89 cb                	mov    %ecx,%ebx
 370:	89 df                	mov    %ebx,%edi
 372:	89 d1                	mov    %edx,%ecx
 374:	fc                   	cld    
 375:	f3 aa                	rep stos %al,%es:(%edi)
 377:	89 ca                	mov    %ecx,%edx
 379:	89 fb                	mov    %edi,%ebx
 37b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 37e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 381:	5b                   	pop    %ebx
 382:	5f                   	pop    %edi
 383:	5d                   	pop    %ebp
 384:	c3                   	ret    

00000385 <thing>:
#include "user.h"
#include "x86.h"


int
thing(void){
 385:	55                   	push   %ebp
 386:	89 e5                	mov    %esp,%ebp
  return 1;
 388:	b8 01 00 00 00       	mov    $0x1,%eax
}
 38d:	5d                   	pop    %ebp
 38e:	c3                   	ret    

0000038f <strcpy>:

char*
strcpy(char *s, char *t)
{
 38f:	55                   	push   %ebp
 390:	89 e5                	mov    %esp,%ebp
 392:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 395:	8b 45 08             	mov    0x8(%ebp),%eax
 398:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 39b:	90                   	nop
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
 39f:	8d 50 01             	lea    0x1(%eax),%edx
 3a2:	89 55 08             	mov    %edx,0x8(%ebp)
 3a5:	8b 55 0c             	mov    0xc(%ebp),%edx
 3a8:	8d 4a 01             	lea    0x1(%edx),%ecx
 3ab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 3ae:	0f b6 12             	movzbl (%edx),%edx
 3b1:	88 10                	mov    %dl,(%eax)
 3b3:	0f b6 00             	movzbl (%eax),%eax
 3b6:	84 c0                	test   %al,%al
 3b8:	75 e2                	jne    39c <strcpy+0xd>
    ;
  return os;
 3ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3bd:	c9                   	leave  
 3be:	c3                   	ret    

000003bf <strcmp>:



int
strcmp(const char *p, const char *q)
{
 3bf:	55                   	push   %ebp
 3c0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3c2:	eb 08                	jmp    3cc <strcmp+0xd>
    p++, q++;
 3c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3c8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)


int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3cc:	8b 45 08             	mov    0x8(%ebp),%eax
 3cf:	0f b6 00             	movzbl (%eax),%eax
 3d2:	84 c0                	test   %al,%al
 3d4:	74 10                	je     3e6 <strcmp+0x27>
 3d6:	8b 45 08             	mov    0x8(%ebp),%eax
 3d9:	0f b6 10             	movzbl (%eax),%edx
 3dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3df:	0f b6 00             	movzbl (%eax),%eax
 3e2:	38 c2                	cmp    %al,%dl
 3e4:	74 de                	je     3c4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3e6:	8b 45 08             	mov    0x8(%ebp),%eax
 3e9:	0f b6 00             	movzbl (%eax),%eax
 3ec:	0f b6 d0             	movzbl %al,%edx
 3ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f2:	0f b6 00             	movzbl (%eax),%eax
 3f5:	0f b6 c0             	movzbl %al,%eax
 3f8:	29 c2                	sub    %eax,%edx
 3fa:	89 d0                	mov    %edx,%eax
}
 3fc:	5d                   	pop    %ebp
 3fd:	c3                   	ret    

000003fe <strlen>:

uint
strlen(char *s)
{
 3fe:	55                   	push   %ebp
 3ff:	89 e5                	mov    %esp,%ebp
 401:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 404:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 40b:	eb 04                	jmp    411 <strlen+0x13>
 40d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 411:	8b 55 fc             	mov    -0x4(%ebp),%edx
 414:	8b 45 08             	mov    0x8(%ebp),%eax
 417:	01 d0                	add    %edx,%eax
 419:	0f b6 00             	movzbl (%eax),%eax
 41c:	84 c0                	test   %al,%al
 41e:	75 ed                	jne    40d <strlen+0xf>
    ;
  return n;
 420:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 423:	c9                   	leave  
 424:	c3                   	ret    

00000425 <stringlen>:

uint
stringlen(char **s){
 425:	55                   	push   %ebp
 426:	89 e5                	mov    %esp,%ebp
 428:	83 ec 10             	sub    $0x10,%esp
	int n;

  for(n = 0; s[n]; n++)
 42b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 432:	eb 04                	jmp    438 <stringlen+0x13>
 434:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 438:	8b 45 fc             	mov    -0x4(%ebp),%eax
 43b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 442:	8b 45 08             	mov    0x8(%ebp),%eax
 445:	01 d0                	add    %edx,%eax
 447:	8b 00                	mov    (%eax),%eax
 449:	85 c0                	test   %eax,%eax
 44b:	75 e7                	jne    434 <stringlen+0xf>
    ;
  return n;
 44d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 450:	c9                   	leave  
 451:	c3                   	ret    

00000452 <memset>:

void*
memset(void *dst, int c, uint n)
{
 452:	55                   	push   %ebp
 453:	89 e5                	mov    %esp,%ebp
 455:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 458:	8b 45 10             	mov    0x10(%ebp),%eax
 45b:	89 44 24 08          	mov    %eax,0x8(%esp)
 45f:	8b 45 0c             	mov    0xc(%ebp),%eax
 462:	89 44 24 04          	mov    %eax,0x4(%esp)
 466:	8b 45 08             	mov    0x8(%ebp),%eax
 469:	89 04 24             	mov    %eax,(%esp)
 46c:	e8 ef fe ff ff       	call   360 <stosb>
  return dst;
 471:	8b 45 08             	mov    0x8(%ebp),%eax
}
 474:	c9                   	leave  
 475:	c3                   	ret    

00000476 <strchr>:

char*
strchr(const char *s, char c)
{
 476:	55                   	push   %ebp
 477:	89 e5                	mov    %esp,%ebp
 479:	83 ec 04             	sub    $0x4,%esp
 47c:	8b 45 0c             	mov    0xc(%ebp),%eax
 47f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 482:	eb 14                	jmp    498 <strchr+0x22>
    if(*s == c)
 484:	8b 45 08             	mov    0x8(%ebp),%eax
 487:	0f b6 00             	movzbl (%eax),%eax
 48a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 48d:	75 05                	jne    494 <strchr+0x1e>
      return (char*)s;
 48f:	8b 45 08             	mov    0x8(%ebp),%eax
 492:	eb 13                	jmp    4a7 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 494:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 498:	8b 45 08             	mov    0x8(%ebp),%eax
 49b:	0f b6 00             	movzbl (%eax),%eax
 49e:	84 c0                	test   %al,%al
 4a0:	75 e2                	jne    484 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 4a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4a7:	c9                   	leave  
 4a8:	c3                   	ret    

000004a9 <gets>:

char*
gets(char *buf, int max)
{
 4a9:	55                   	push   %ebp
 4aa:	89 e5                	mov    %esp,%ebp
 4ac:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 4b6:	eb 4c                	jmp    504 <gets+0x5b>
    cc = read(0, &c, 1);
 4b8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4bf:	00 
 4c0:	8d 45 ef             	lea    -0x11(%ebp),%eax
 4c3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4ce:	e8 80 03 00 00       	call   853 <read>
 4d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 4d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4da:	7f 02                	jg     4de <gets+0x35>
      break;
 4dc:	eb 31                	jmp    50f <gets+0x66>
    buf[i++] = c;
 4de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e1:	8d 50 01             	lea    0x1(%eax),%edx
 4e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4e7:	89 c2                	mov    %eax,%edx
 4e9:	8b 45 08             	mov    0x8(%ebp),%eax
 4ec:	01 c2                	add    %eax,%edx
 4ee:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4f2:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 4f4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4f8:	3c 0a                	cmp    $0xa,%al
 4fa:	74 13                	je     50f <gets+0x66>
 4fc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 500:	3c 0d                	cmp    $0xd,%al
 502:	74 0b                	je     50f <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 504:	8b 45 f4             	mov    -0xc(%ebp),%eax
 507:	83 c0 01             	add    $0x1,%eax
 50a:	3b 45 0c             	cmp    0xc(%ebp),%eax
 50d:	7c a9                	jl     4b8 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 50f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 512:	8b 45 08             	mov    0x8(%ebp),%eax
 515:	01 d0                	add    %edx,%eax
 517:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 51a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 51d:	c9                   	leave  
 51e:	c3                   	ret    

0000051f <stat>:

int
stat(char *n, struct stat *st)
{
 51f:	55                   	push   %ebp
 520:	89 e5                	mov    %esp,%ebp
 522:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 525:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 52c:	00 
 52d:	8b 45 08             	mov    0x8(%ebp),%eax
 530:	89 04 24             	mov    %eax,(%esp)
 533:	e8 43 03 00 00       	call   87b <open>
 538:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 53b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 53f:	79 07                	jns    548 <stat+0x29>
    return -1;
 541:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 546:	eb 23                	jmp    56b <stat+0x4c>
  r = fstat(fd, st);
 548:	8b 45 0c             	mov    0xc(%ebp),%eax
 54b:	89 44 24 04          	mov    %eax,0x4(%esp)
 54f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 552:	89 04 24             	mov    %eax,(%esp)
 555:	e8 39 03 00 00       	call   893 <fstat>
 55a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 55d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 560:	89 04 24             	mov    %eax,(%esp)
 563:	e8 fb 02 00 00       	call   863 <close>
  return r;
 568:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 56b:	c9                   	leave  
 56c:	c3                   	ret    

0000056d <atoi>:

int
atoi(const char *s)
{
 56d:	55                   	push   %ebp
 56e:	89 e5                	mov    %esp,%ebp
 570:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 573:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 57a:	eb 25                	jmp    5a1 <atoi+0x34>
    n = n*10 + *s++ - '0';
 57c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 57f:	89 d0                	mov    %edx,%eax
 581:	c1 e0 02             	shl    $0x2,%eax
 584:	01 d0                	add    %edx,%eax
 586:	01 c0                	add    %eax,%eax
 588:	89 c1                	mov    %eax,%ecx
 58a:	8b 45 08             	mov    0x8(%ebp),%eax
 58d:	8d 50 01             	lea    0x1(%eax),%edx
 590:	89 55 08             	mov    %edx,0x8(%ebp)
 593:	0f b6 00             	movzbl (%eax),%eax
 596:	0f be c0             	movsbl %al,%eax
 599:	01 c8                	add    %ecx,%eax
 59b:	83 e8 30             	sub    $0x30,%eax
 59e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5a1:	8b 45 08             	mov    0x8(%ebp),%eax
 5a4:	0f b6 00             	movzbl (%eax),%eax
 5a7:	3c 2f                	cmp    $0x2f,%al
 5a9:	7e 0a                	jle    5b5 <atoi+0x48>
 5ab:	8b 45 08             	mov    0x8(%ebp),%eax
 5ae:	0f b6 00             	movzbl (%eax),%eax
 5b1:	3c 39                	cmp    $0x39,%al
 5b3:	7e c7                	jle    57c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 5b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5b8:	c9                   	leave  
 5b9:	c3                   	ret    

000005ba <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 5ba:	55                   	push   %ebp
 5bb:	89 e5                	mov    %esp,%ebp
 5bd:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 5c0:	8b 45 08             	mov    0x8(%ebp),%eax
 5c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 5c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 5cc:	eb 17                	jmp    5e5 <memmove+0x2b>
    *dst++ = *src++;
 5ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d1:	8d 50 01             	lea    0x1(%eax),%edx
 5d4:	89 55 fc             	mov    %edx,-0x4(%ebp)
 5d7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5da:	8d 4a 01             	lea    0x1(%edx),%ecx
 5dd:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 5e0:	0f b6 12             	movzbl (%edx),%edx
 5e3:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5e5:	8b 45 10             	mov    0x10(%ebp),%eax
 5e8:	8d 50 ff             	lea    -0x1(%eax),%edx
 5eb:	89 55 10             	mov    %edx,0x10(%ebp)
 5ee:	85 c0                	test   %eax,%eax
 5f0:	7f dc                	jg     5ce <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5f5:	c9                   	leave  
 5f6:	c3                   	ret    

000005f7 <strcmp_c>:


int
strcmp_c(const char *s1, const char *s2)
{
 5f7:	55                   	push   %ebp
 5f8:	89 e5                	mov    %esp,%ebp
    for ( ; *s1 == *s2; s1++, s2++)
 5fa:	eb 19                	jmp    615 <strcmp_c+0x1e>
	if (*s1 == '\0')
 5fc:	8b 45 08             	mov    0x8(%ebp),%eax
 5ff:	0f b6 00             	movzbl (%eax),%eax
 602:	84 c0                	test   %al,%al
 604:	75 07                	jne    60d <strcmp_c+0x16>
	    return 0;
 606:	b8 00 00 00 00       	mov    $0x0,%eax
 60b:	eb 34                	jmp    641 <strcmp_c+0x4a>


int
strcmp_c(const char *s1, const char *s2)
{
    for ( ; *s1 == *s2; s1++, s2++)
 60d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 611:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 615:	8b 45 08             	mov    0x8(%ebp),%eax
 618:	0f b6 10             	movzbl (%eax),%edx
 61b:	8b 45 0c             	mov    0xc(%ebp),%eax
 61e:	0f b6 00             	movzbl (%eax),%eax
 621:	38 c2                	cmp    %al,%dl
 623:	74 d7                	je     5fc <strcmp_c+0x5>
	if (*s1 == '\0')
	    return 0;
    return ((*(unsigned char *)s1 < *(unsigned char *)s2) ? -1 : +1);
 625:	8b 45 08             	mov    0x8(%ebp),%eax
 628:	0f b6 10             	movzbl (%eax),%edx
 62b:	8b 45 0c             	mov    0xc(%ebp),%eax
 62e:	0f b6 00             	movzbl (%eax),%eax
 631:	38 c2                	cmp    %al,%dl
 633:	73 07                	jae    63c <strcmp_c+0x45>
 635:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 63a:	eb 05                	jmp    641 <strcmp_c+0x4a>
 63c:	b8 01 00 00 00       	mov    $0x1,%eax
}
 641:	5d                   	pop    %ebp
 642:	c3                   	ret    

00000643 <readuser>:


struct USER
readuser(){
 643:	55                   	push   %ebp
 644:	89 e5                	mov    %esp,%ebp
 646:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char buff1[512], buff2[512];
	struct USER u;
	printf(1,"Please enter a username: ");
 64c:	c7 44 24 04 ce 0d 00 	movl   $0xdce,0x4(%esp)
 653:	00 
 654:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 65b:	e8 6b 03 00 00       	call   9cb <printf>
	u.name = gets(buff1, 50);
 660:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 667:	00 
 668:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
 66e:	89 04 24             	mov    %eax,(%esp)
 671:	e8 33 fe ff ff       	call   4a9 <gets>
 676:	89 85 ec fb ff ff    	mov    %eax,-0x414(%ebp)
	printf(1,"Please enter a password: ");
 67c:	c7 44 24 04 e8 0d 00 	movl   $0xde8,0x4(%esp)
 683:	00 
 684:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 68b:	e8 3b 03 00 00       	call   9cb <printf>
	u.pass = gets(buff2, 50);
 690:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 697:	00 
 698:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
 69e:	89 04 24             	mov    %eax,(%esp)
 6a1:	e8 03 fe ff ff       	call   4a9 <gets>
 6a6:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
	return u;
 6ac:	8b 45 08             	mov    0x8(%ebp),%eax
 6af:	8b 95 ec fb ff ff    	mov    -0x414(%ebp),%edx
 6b5:	89 10                	mov    %edx,(%eax)
 6b7:	8b 95 f0 fb ff ff    	mov    -0x410(%ebp),%edx
 6bd:	89 50 04             	mov    %edx,0x4(%eax)
 6c0:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
 6c6:	89 50 08             	mov    %edx,0x8(%eax)
}
 6c9:	8b 45 08             	mov    0x8(%ebp),%eax
 6cc:	c9                   	leave  
 6cd:	c2 04 00             	ret    $0x4

000006d0 <compareuser>:


int
compareuser(int state){
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	56                   	push   %esi
 6d4:	53                   	push   %ebx
 6d5:	81 ec 30 01 00 00    	sub    $0x130,%esp
	struct USER u1,u2;
	struct USER users[20];
	u1.name = "john\n";
 6db:	c7 45 e8 02 0e 00 00 	movl   $0xe02,-0x18(%ebp)
	u1.pass = "1234\n";
 6e2:	c7 45 ec 08 0e 00 00 	movl   $0xe08,-0x14(%ebp)
	u1.ulevel = 0;
 6e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	u2.name = "james\n";
 6f0:	c7 45 dc 0e 0e 00 00 	movl   $0xe0e,-0x24(%ebp)
	u2.pass = "pass\n";
 6f7:	c7 45 e0 15 0e 00 00 	movl   $0xe15,-0x20(%ebp)
	u2.ulevel = 1;
 6fe:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	users[0] = u1;
 705:	8b 45 e8             	mov    -0x18(%ebp),%eax
 708:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
 70e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 711:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
 717:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71a:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
	users[1] = u2;
 720:	8b 45 dc             	mov    -0x24(%ebp),%eax
 723:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
 729:	8b 45 e0             	mov    -0x20(%ebp),%eax
 72c:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
 732:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 735:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
	
	
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
 73b:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
 741:	89 04 24             	mov    %eax,(%esp)
 744:	e8 fa fe ff ff       	call   643 <readuser>
 749:	83 ec 04             	sub    $0x4,%esp
		
		for(ctr = 0; ctr < 20; ctr++)
 74c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 753:	e9 a4 00 00 00       	jmp    7fc <compareuser+0x12c>
		{

			if(strcmp_c(u.name,users[ctr].name) == 0 && strcmp_c(u.pass,users[ctr].pass) == 0)
 758:	8b 55 f4             	mov    -0xc(%ebp),%edx
 75b:	89 d0                	mov    %edx,%eax
 75d:	01 c0                	add    %eax,%eax
 75f:	01 d0                	add    %edx,%eax
 761:	c1 e0 02             	shl    $0x2,%eax
 764:	8d 4d f8             	lea    -0x8(%ebp),%ecx
 767:	01 c8                	add    %ecx,%eax
 769:	2d 0c 01 00 00       	sub    $0x10c,%eax
 76e:	8b 10                	mov    (%eax),%edx
 770:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
 776:	89 54 24 04          	mov    %edx,0x4(%esp)
 77a:	89 04 24             	mov    %eax,(%esp)
 77d:	e8 75 fe ff ff       	call   5f7 <strcmp_c>
 782:	85 c0                	test   %eax,%eax
 784:	75 72                	jne    7f8 <compareuser+0x128>
 786:	8b 55 f4             	mov    -0xc(%ebp),%edx
 789:	89 d0                	mov    %edx,%eax
 78b:	01 c0                	add    %eax,%eax
 78d:	01 d0                	add    %edx,%eax
 78f:	c1 e0 02             	shl    $0x2,%eax
 792:	8d 5d f8             	lea    -0x8(%ebp),%ebx
 795:	01 d8                	add    %ebx,%eax
 797:	2d 08 01 00 00       	sub    $0x108,%eax
 79c:	8b 10                	mov    (%eax),%edx
 79e:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
 7a4:	89 54 24 04          	mov    %edx,0x4(%esp)
 7a8:	89 04 24             	mov    %eax,(%esp)
 7ab:	e8 47 fe ff ff       	call   5f7 <strcmp_c>
 7b0:	85 c0                	test   %eax,%eax
 7b2:	75 44                	jne    7f8 <compareuser+0x128>
			{
				setuser(users[ctr].ulevel);
 7b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 7b7:	89 d0                	mov    %edx,%eax
 7b9:	01 c0                	add    %eax,%eax
 7bb:	01 d0                	add    %edx,%eax
 7bd:	c1 e0 02             	shl    $0x2,%eax
 7c0:	8d 75 f8             	lea    -0x8(%ebp),%esi
 7c3:	01 f0                	add    %esi,%eax
 7c5:	2d 04 01 00 00       	sub    $0x104,%eax
 7ca:	8b 00                	mov    (%eax),%eax
 7cc:	89 04 24             	mov    %eax,(%esp)
 7cf:	e8 0f 01 00 00       	call   8e3 <setuser>
				
				printf(1,"%d",getuser());
 7d4:	e8 02 01 00 00       	call   8db <getuser>
 7d9:	89 44 24 08          	mov    %eax,0x8(%esp)
 7dd:	c7 44 24 04 1b 0e 00 	movl   $0xe1b,0x4(%esp)
 7e4:	00 
 7e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 7ec:	e8 da 01 00 00       	call   9cb <printf>
				return 1;
 7f1:	b8 01 00 00 00       	mov    $0x1,%eax
 7f6:	eb 34                	jmp    82c <compareuser+0x15c>
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
		
		for(ctr = 0; ctr < 20; ctr++)
 7f8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 7fc:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 800:	0f 8e 52 ff ff ff    	jle    758 <compareuser+0x88>
				
				printf(1,"%d",getuser());
				return 1;
			}
		}
		printf(1,"Invalid username/password\n");
 806:	c7 44 24 04 1e 0e 00 	movl   $0xe1e,0x4(%esp)
 80d:	00 
 80e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 815:	e8 b1 01 00 00       	call   9cb <printf>
		if(state != 1)
 81a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 81e:	74 07                	je     827 <compareuser+0x157>
			break;
	}
	return 0;
 820:	b8 00 00 00 00       	mov    $0x0,%eax
 825:	eb 05                	jmp    82c <compareuser+0x15c>
			}
		}
		printf(1,"Invalid username/password\n");
		if(state != 1)
			break;
	}
 827:	e9 0f ff ff ff       	jmp    73b <compareuser+0x6b>
	return 0;
}
 82c:	8d 65 f8             	lea    -0x8(%ebp),%esp
 82f:	5b                   	pop    %ebx
 830:	5e                   	pop    %esi
 831:	5d                   	pop    %ebp
 832:	c3                   	ret    

00000833 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 833:	b8 01 00 00 00       	mov    $0x1,%eax
 838:	cd 40                	int    $0x40
 83a:	c3                   	ret    

0000083b <exit>:
SYSCALL(exit)
 83b:	b8 02 00 00 00       	mov    $0x2,%eax
 840:	cd 40                	int    $0x40
 842:	c3                   	ret    

00000843 <wait>:
SYSCALL(wait)
 843:	b8 03 00 00 00       	mov    $0x3,%eax
 848:	cd 40                	int    $0x40
 84a:	c3                   	ret    

0000084b <pipe>:
SYSCALL(pipe)
 84b:	b8 04 00 00 00       	mov    $0x4,%eax
 850:	cd 40                	int    $0x40
 852:	c3                   	ret    

00000853 <read>:
SYSCALL(read)
 853:	b8 05 00 00 00       	mov    $0x5,%eax
 858:	cd 40                	int    $0x40
 85a:	c3                   	ret    

0000085b <write>:
SYSCALL(write)
 85b:	b8 10 00 00 00       	mov    $0x10,%eax
 860:	cd 40                	int    $0x40
 862:	c3                   	ret    

00000863 <close>:
SYSCALL(close)
 863:	b8 15 00 00 00       	mov    $0x15,%eax
 868:	cd 40                	int    $0x40
 86a:	c3                   	ret    

0000086b <kill>:
SYSCALL(kill)
 86b:	b8 06 00 00 00       	mov    $0x6,%eax
 870:	cd 40                	int    $0x40
 872:	c3                   	ret    

00000873 <exec>:
SYSCALL(exec)
 873:	b8 07 00 00 00       	mov    $0x7,%eax
 878:	cd 40                	int    $0x40
 87a:	c3                   	ret    

0000087b <open>:
SYSCALL(open)
 87b:	b8 0f 00 00 00       	mov    $0xf,%eax
 880:	cd 40                	int    $0x40
 882:	c3                   	ret    

00000883 <mknod>:
SYSCALL(mknod)
 883:	b8 11 00 00 00       	mov    $0x11,%eax
 888:	cd 40                	int    $0x40
 88a:	c3                   	ret    

0000088b <unlink>:
SYSCALL(unlink)
 88b:	b8 12 00 00 00       	mov    $0x12,%eax
 890:	cd 40                	int    $0x40
 892:	c3                   	ret    

00000893 <fstat>:
SYSCALL(fstat)
 893:	b8 08 00 00 00       	mov    $0x8,%eax
 898:	cd 40                	int    $0x40
 89a:	c3                   	ret    

0000089b <link>:
SYSCALL(link)
 89b:	b8 13 00 00 00       	mov    $0x13,%eax
 8a0:	cd 40                	int    $0x40
 8a2:	c3                   	ret    

000008a3 <mkdir>:
SYSCALL(mkdir)
 8a3:	b8 14 00 00 00       	mov    $0x14,%eax
 8a8:	cd 40                	int    $0x40
 8aa:	c3                   	ret    

000008ab <chdir>:
SYSCALL(chdir)
 8ab:	b8 09 00 00 00       	mov    $0x9,%eax
 8b0:	cd 40                	int    $0x40
 8b2:	c3                   	ret    

000008b3 <dup>:
SYSCALL(dup)
 8b3:	b8 0a 00 00 00       	mov    $0xa,%eax
 8b8:	cd 40                	int    $0x40
 8ba:	c3                   	ret    

000008bb <getpid>:
SYSCALL(getpid)
 8bb:	b8 0b 00 00 00       	mov    $0xb,%eax
 8c0:	cd 40                	int    $0x40
 8c2:	c3                   	ret    

000008c3 <sbrk>:
SYSCALL(sbrk)
 8c3:	b8 0c 00 00 00       	mov    $0xc,%eax
 8c8:	cd 40                	int    $0x40
 8ca:	c3                   	ret    

000008cb <sleep>:
SYSCALL(sleep)
 8cb:	b8 0d 00 00 00       	mov    $0xd,%eax
 8d0:	cd 40                	int    $0x40
 8d2:	c3                   	ret    

000008d3 <uptime>:
SYSCALL(uptime)
 8d3:	b8 0e 00 00 00       	mov    $0xe,%eax
 8d8:	cd 40                	int    $0x40
 8da:	c3                   	ret    

000008db <getuser>:
SYSCALL(getuser)
 8db:	b8 16 00 00 00       	mov    $0x16,%eax
 8e0:	cd 40                	int    $0x40
 8e2:	c3                   	ret    

000008e3 <setuser>:
SYSCALL(setuser)
 8e3:	b8 17 00 00 00       	mov    $0x17,%eax
 8e8:	cd 40                	int    $0x40
 8ea:	c3                   	ret    

000008eb <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 8eb:	55                   	push   %ebp
 8ec:	89 e5                	mov    %esp,%ebp
 8ee:	83 ec 18             	sub    $0x18,%esp
 8f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 8f4:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 8f7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8fe:	00 
 8ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
 902:	89 44 24 04          	mov    %eax,0x4(%esp)
 906:	8b 45 08             	mov    0x8(%ebp),%eax
 909:	89 04 24             	mov    %eax,(%esp)
 90c:	e8 4a ff ff ff       	call   85b <write>
}
 911:	c9                   	leave  
 912:	c3                   	ret    

00000913 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 913:	55                   	push   %ebp
 914:	89 e5                	mov    %esp,%ebp
 916:	56                   	push   %esi
 917:	53                   	push   %ebx
 918:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 91b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 922:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 926:	74 17                	je     93f <printint+0x2c>
 928:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 92c:	79 11                	jns    93f <printint+0x2c>
    neg = 1;
 92e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 935:	8b 45 0c             	mov    0xc(%ebp),%eax
 938:	f7 d8                	neg    %eax
 93a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 93d:	eb 06                	jmp    945 <printint+0x32>
  } else {
    x = xx;
 93f:	8b 45 0c             	mov    0xc(%ebp),%eax
 942:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 945:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 94c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 94f:	8d 41 01             	lea    0x1(%ecx),%eax
 952:	89 45 f4             	mov    %eax,-0xc(%ebp)
 955:	8b 5d 10             	mov    0x10(%ebp),%ebx
 958:	8b 45 ec             	mov    -0x14(%ebp),%eax
 95b:	ba 00 00 00 00       	mov    $0x0,%edx
 960:	f7 f3                	div    %ebx
 962:	89 d0                	mov    %edx,%eax
 964:	0f b6 80 b0 11 00 00 	movzbl 0x11b0(%eax),%eax
 96b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 96f:	8b 75 10             	mov    0x10(%ebp),%esi
 972:	8b 45 ec             	mov    -0x14(%ebp),%eax
 975:	ba 00 00 00 00       	mov    $0x0,%edx
 97a:	f7 f6                	div    %esi
 97c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 97f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 983:	75 c7                	jne    94c <printint+0x39>
  if(neg)
 985:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 989:	74 10                	je     99b <printint+0x88>
    buf[i++] = '-';
 98b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98e:	8d 50 01             	lea    0x1(%eax),%edx
 991:	89 55 f4             	mov    %edx,-0xc(%ebp)
 994:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 999:	eb 1f                	jmp    9ba <printint+0xa7>
 99b:	eb 1d                	jmp    9ba <printint+0xa7>
    putc(fd, buf[i]);
 99d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 9a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a3:	01 d0                	add    %edx,%eax
 9a5:	0f b6 00             	movzbl (%eax),%eax
 9a8:	0f be c0             	movsbl %al,%eax
 9ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 9af:	8b 45 08             	mov    0x8(%ebp),%eax
 9b2:	89 04 24             	mov    %eax,(%esp)
 9b5:	e8 31 ff ff ff       	call   8eb <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 9ba:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 9be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9c2:	79 d9                	jns    99d <printint+0x8a>
    putc(fd, buf[i]);
}
 9c4:	83 c4 30             	add    $0x30,%esp
 9c7:	5b                   	pop    %ebx
 9c8:	5e                   	pop    %esi
 9c9:	5d                   	pop    %ebp
 9ca:	c3                   	ret    

000009cb <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 9cb:	55                   	push   %ebp
 9cc:	89 e5                	mov    %esp,%ebp
 9ce:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 9d1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 9d8:	8d 45 0c             	lea    0xc(%ebp),%eax
 9db:	83 c0 04             	add    $0x4,%eax
 9de:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 9e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 9e8:	e9 7c 01 00 00       	jmp    b69 <printf+0x19e>
    c = fmt[i] & 0xff;
 9ed:	8b 55 0c             	mov    0xc(%ebp),%edx
 9f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f3:	01 d0                	add    %edx,%eax
 9f5:	0f b6 00             	movzbl (%eax),%eax
 9f8:	0f be c0             	movsbl %al,%eax
 9fb:	25 ff 00 00 00       	and    $0xff,%eax
 a00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 a03:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a07:	75 2c                	jne    a35 <printf+0x6a>
      if(c == '%'){
 a09:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a0d:	75 0c                	jne    a1b <printf+0x50>
        state = '%';
 a0f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 a16:	e9 4a 01 00 00       	jmp    b65 <printf+0x19a>
      } else {
        putc(fd, c);
 a1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a1e:	0f be c0             	movsbl %al,%eax
 a21:	89 44 24 04          	mov    %eax,0x4(%esp)
 a25:	8b 45 08             	mov    0x8(%ebp),%eax
 a28:	89 04 24             	mov    %eax,(%esp)
 a2b:	e8 bb fe ff ff       	call   8eb <putc>
 a30:	e9 30 01 00 00       	jmp    b65 <printf+0x19a>
      }
    } else if(state == '%'){
 a35:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 a39:	0f 85 26 01 00 00    	jne    b65 <printf+0x19a>
      if(c == 'd'){
 a3f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 a43:	75 2d                	jne    a72 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 a45:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a48:	8b 00                	mov    (%eax),%eax
 a4a:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 a51:	00 
 a52:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 a59:	00 
 a5a:	89 44 24 04          	mov    %eax,0x4(%esp)
 a5e:	8b 45 08             	mov    0x8(%ebp),%eax
 a61:	89 04 24             	mov    %eax,(%esp)
 a64:	e8 aa fe ff ff       	call   913 <printint>
        ap++;
 a69:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a6d:	e9 ec 00 00 00       	jmp    b5e <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 a72:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 a76:	74 06                	je     a7e <printf+0xb3>
 a78:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 a7c:	75 2d                	jne    aab <printf+0xe0>
        printint(fd, *ap, 16, 0);
 a7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a81:	8b 00                	mov    (%eax),%eax
 a83:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 a8a:	00 
 a8b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 a92:	00 
 a93:	89 44 24 04          	mov    %eax,0x4(%esp)
 a97:	8b 45 08             	mov    0x8(%ebp),%eax
 a9a:	89 04 24             	mov    %eax,(%esp)
 a9d:	e8 71 fe ff ff       	call   913 <printint>
        ap++;
 aa2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 aa6:	e9 b3 00 00 00       	jmp    b5e <printf+0x193>
      } else if(c == 's'){
 aab:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 aaf:	75 45                	jne    af6 <printf+0x12b>
        s = (char*)*ap;
 ab1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ab4:	8b 00                	mov    (%eax),%eax
 ab6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 ab9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 abd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ac1:	75 09                	jne    acc <printf+0x101>
          s = "(null)";
 ac3:	c7 45 f4 39 0e 00 00 	movl   $0xe39,-0xc(%ebp)
        while(*s != 0){
 aca:	eb 1e                	jmp    aea <printf+0x11f>
 acc:	eb 1c                	jmp    aea <printf+0x11f>
          putc(fd, *s);
 ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad1:	0f b6 00             	movzbl (%eax),%eax
 ad4:	0f be c0             	movsbl %al,%eax
 ad7:	89 44 24 04          	mov    %eax,0x4(%esp)
 adb:	8b 45 08             	mov    0x8(%ebp),%eax
 ade:	89 04 24             	mov    %eax,(%esp)
 ae1:	e8 05 fe ff ff       	call   8eb <putc>
          s++;
 ae6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aed:	0f b6 00             	movzbl (%eax),%eax
 af0:	84 c0                	test   %al,%al
 af2:	75 da                	jne    ace <printf+0x103>
 af4:	eb 68                	jmp    b5e <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 af6:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 afa:	75 1d                	jne    b19 <printf+0x14e>
        putc(fd, *ap);
 afc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 aff:	8b 00                	mov    (%eax),%eax
 b01:	0f be c0             	movsbl %al,%eax
 b04:	89 44 24 04          	mov    %eax,0x4(%esp)
 b08:	8b 45 08             	mov    0x8(%ebp),%eax
 b0b:	89 04 24             	mov    %eax,(%esp)
 b0e:	e8 d8 fd ff ff       	call   8eb <putc>
        ap++;
 b13:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b17:	eb 45                	jmp    b5e <printf+0x193>
      } else if(c == '%'){
 b19:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b1d:	75 17                	jne    b36 <printf+0x16b>
        putc(fd, c);
 b1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b22:	0f be c0             	movsbl %al,%eax
 b25:	89 44 24 04          	mov    %eax,0x4(%esp)
 b29:	8b 45 08             	mov    0x8(%ebp),%eax
 b2c:	89 04 24             	mov    %eax,(%esp)
 b2f:	e8 b7 fd ff ff       	call   8eb <putc>
 b34:	eb 28                	jmp    b5e <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b36:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 b3d:	00 
 b3e:	8b 45 08             	mov    0x8(%ebp),%eax
 b41:	89 04 24             	mov    %eax,(%esp)
 b44:	e8 a2 fd ff ff       	call   8eb <putc>
        putc(fd, c);
 b49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b4c:	0f be c0             	movsbl %al,%eax
 b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
 b53:	8b 45 08             	mov    0x8(%ebp),%eax
 b56:	89 04 24             	mov    %eax,(%esp)
 b59:	e8 8d fd ff ff       	call   8eb <putc>
      }
      state = 0;
 b5e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 b65:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 b69:	8b 55 0c             	mov    0xc(%ebp),%edx
 b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b6f:	01 d0                	add    %edx,%eax
 b71:	0f b6 00             	movzbl (%eax),%eax
 b74:	84 c0                	test   %al,%al
 b76:	0f 85 71 fe ff ff    	jne    9ed <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 b7c:	c9                   	leave  
 b7d:	c3                   	ret    

00000b7e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b7e:	55                   	push   %ebp
 b7f:	89 e5                	mov    %esp,%ebp
 b81:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b84:	8b 45 08             	mov    0x8(%ebp),%eax
 b87:	83 e8 08             	sub    $0x8,%eax
 b8a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b8d:	a1 e8 11 00 00       	mov    0x11e8,%eax
 b92:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b95:	eb 24                	jmp    bbb <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b97:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b9a:	8b 00                	mov    (%eax),%eax
 b9c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b9f:	77 12                	ja     bb3 <free+0x35>
 ba1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ba4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ba7:	77 24                	ja     bcd <free+0x4f>
 ba9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bac:	8b 00                	mov    (%eax),%eax
 bae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bb1:	77 1a                	ja     bcd <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bb6:	8b 00                	mov    (%eax),%eax
 bb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 bbb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bbe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bc1:	76 d4                	jbe    b97 <free+0x19>
 bc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bc6:	8b 00                	mov    (%eax),%eax
 bc8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bcb:	76 ca                	jbe    b97 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 bcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bd0:	8b 40 04             	mov    0x4(%eax),%eax
 bd3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 bda:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bdd:	01 c2                	add    %eax,%edx
 bdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 be2:	8b 00                	mov    (%eax),%eax
 be4:	39 c2                	cmp    %eax,%edx
 be6:	75 24                	jne    c0c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 be8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 beb:	8b 50 04             	mov    0x4(%eax),%edx
 bee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bf1:	8b 00                	mov    (%eax),%eax
 bf3:	8b 40 04             	mov    0x4(%eax),%eax
 bf6:	01 c2                	add    %eax,%edx
 bf8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bfb:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 bfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c01:	8b 00                	mov    (%eax),%eax
 c03:	8b 10                	mov    (%eax),%edx
 c05:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c08:	89 10                	mov    %edx,(%eax)
 c0a:	eb 0a                	jmp    c16 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 c0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c0f:	8b 10                	mov    (%eax),%edx
 c11:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c14:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 c16:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c19:	8b 40 04             	mov    0x4(%eax),%eax
 c1c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c23:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c26:	01 d0                	add    %edx,%eax
 c28:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c2b:	75 20                	jne    c4d <free+0xcf>
    p->s.size += bp->s.size;
 c2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c30:	8b 50 04             	mov    0x4(%eax),%edx
 c33:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c36:	8b 40 04             	mov    0x4(%eax),%eax
 c39:	01 c2                	add    %eax,%edx
 c3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c3e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 c41:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c44:	8b 10                	mov    (%eax),%edx
 c46:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c49:	89 10                	mov    %edx,(%eax)
 c4b:	eb 08                	jmp    c55 <free+0xd7>
  } else
    p->s.ptr = bp;
 c4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c50:	8b 55 f8             	mov    -0x8(%ebp),%edx
 c53:	89 10                	mov    %edx,(%eax)
  freep = p;
 c55:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c58:	a3 e8 11 00 00       	mov    %eax,0x11e8
}
 c5d:	c9                   	leave  
 c5e:	c3                   	ret    

00000c5f <morecore>:

static Header*
morecore(uint nu)
{
 c5f:	55                   	push   %ebp
 c60:	89 e5                	mov    %esp,%ebp
 c62:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 c65:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 c6c:	77 07                	ja     c75 <morecore+0x16>
    nu = 4096;
 c6e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 c75:	8b 45 08             	mov    0x8(%ebp),%eax
 c78:	c1 e0 03             	shl    $0x3,%eax
 c7b:	89 04 24             	mov    %eax,(%esp)
 c7e:	e8 40 fc ff ff       	call   8c3 <sbrk>
 c83:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 c86:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 c8a:	75 07                	jne    c93 <morecore+0x34>
    return 0;
 c8c:	b8 00 00 00 00       	mov    $0x0,%eax
 c91:	eb 22                	jmp    cb5 <morecore+0x56>
  hp = (Header*)p;
 c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c9c:	8b 55 08             	mov    0x8(%ebp),%edx
 c9f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ca5:	83 c0 08             	add    $0x8,%eax
 ca8:	89 04 24             	mov    %eax,(%esp)
 cab:	e8 ce fe ff ff       	call   b7e <free>
  return freep;
 cb0:	a1 e8 11 00 00       	mov    0x11e8,%eax
}
 cb5:	c9                   	leave  
 cb6:	c3                   	ret    

00000cb7 <malloc>:

void*
malloc(uint nbytes)
{
 cb7:	55                   	push   %ebp
 cb8:	89 e5                	mov    %esp,%ebp
 cba:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cbd:	8b 45 08             	mov    0x8(%ebp),%eax
 cc0:	83 c0 07             	add    $0x7,%eax
 cc3:	c1 e8 03             	shr    $0x3,%eax
 cc6:	83 c0 01             	add    $0x1,%eax
 cc9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 ccc:	a1 e8 11 00 00       	mov    0x11e8,%eax
 cd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 cd4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 cd8:	75 23                	jne    cfd <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 cda:	c7 45 f0 e0 11 00 00 	movl   $0x11e0,-0x10(%ebp)
 ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ce4:	a3 e8 11 00 00       	mov    %eax,0x11e8
 ce9:	a1 e8 11 00 00       	mov    0x11e8,%eax
 cee:	a3 e0 11 00 00       	mov    %eax,0x11e0
    base.s.size = 0;
 cf3:	c7 05 e4 11 00 00 00 	movl   $0x0,0x11e4
 cfa:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d00:	8b 00                	mov    (%eax),%eax
 d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d08:	8b 40 04             	mov    0x4(%eax),%eax
 d0b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d0e:	72 4d                	jb     d5d <malloc+0xa6>
      if(p->s.size == nunits)
 d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d13:	8b 40 04             	mov    0x4(%eax),%eax
 d16:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d19:	75 0c                	jne    d27 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d1e:	8b 10                	mov    (%eax),%edx
 d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d23:	89 10                	mov    %edx,(%eax)
 d25:	eb 26                	jmp    d4d <malloc+0x96>
      else {
        p->s.size -= nunits;
 d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d2a:	8b 40 04             	mov    0x4(%eax),%eax
 d2d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 d30:	89 c2                	mov    %eax,%edx
 d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d35:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d3b:	8b 40 04             	mov    0x4(%eax),%eax
 d3e:	c1 e0 03             	shl    $0x3,%eax
 d41:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d47:	8b 55 ec             	mov    -0x14(%ebp),%edx
 d4a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d50:	a3 e8 11 00 00       	mov    %eax,0x11e8
      return (void*)(p + 1);
 d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d58:	83 c0 08             	add    $0x8,%eax
 d5b:	eb 38                	jmp    d95 <malloc+0xde>
    }
    if(p == freep)
 d5d:	a1 e8 11 00 00       	mov    0x11e8,%eax
 d62:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 d65:	75 1b                	jne    d82 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 d67:	8b 45 ec             	mov    -0x14(%ebp),%eax
 d6a:	89 04 24             	mov    %eax,(%esp)
 d6d:	e8 ed fe ff ff       	call   c5f <morecore>
 d72:	89 45 f4             	mov    %eax,-0xc(%ebp)
 d75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d79:	75 07                	jne    d82 <malloc+0xcb>
        return 0;
 d7b:	b8 00 00 00 00       	mov    $0x0,%eax
 d80:	eb 13                	jmp    d95 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d85:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d8b:	8b 00                	mov    (%eax),%eax
 d8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 d90:	e9 70 ff ff ff       	jmp    d05 <malloc+0x4e>
}
 d95:	c9                   	leave  
 d96:	c3                   	ret    
