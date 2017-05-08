
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 24             	sub    $0x24,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	8b 45 08             	mov    0x8(%ebp),%eax
   a:	89 04 24             	mov    %eax,(%esp)
   d:	e8 e7 03 00 00       	call   3f9 <strlen>
  12:	8b 55 08             	mov    0x8(%ebp),%edx
  15:	01 d0                	add    %edx,%eax
  17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1a:	eb 04                	jmp    20 <fmtname+0x20>
  1c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  23:	3b 45 08             	cmp    0x8(%ebp),%eax
  26:	72 0a                	jb     32 <fmtname+0x32>
  28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2b:	0f b6 00             	movzbl (%eax),%eax
  2e:	3c 2f                	cmp    $0x2f,%al
  30:	75 ea                	jne    1c <fmtname+0x1c>
    ;
  p++;
  32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  39:	89 04 24             	mov    %eax,(%esp)
  3c:	e8 b8 03 00 00       	call   3f9 <strlen>
  41:	83 f8 0d             	cmp    $0xd,%eax
  44:	76 05                	jbe    4b <fmtname+0x4b>
    return p;
  46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  49:	eb 5f                	jmp    aa <fmtname+0xaa>
  memmove(buf, p, strlen(p));
  4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4e:	89 04 24             	mov    %eax,(%esp)
  51:	e8 a3 03 00 00       	call   3f9 <strlen>
  56:	89 44 24 08          	mov    %eax,0x8(%esp)
  5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  61:	c7 04 24 a8 11 00 00 	movl   $0x11a8,(%esp)
  68:	e8 48 05 00 00       	call   5b5 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  70:	89 04 24             	mov    %eax,(%esp)
  73:	e8 81 03 00 00       	call   3f9 <strlen>
  78:	ba 0e 00 00 00       	mov    $0xe,%edx
  7d:	89 d3                	mov    %edx,%ebx
  7f:	29 c3                	sub    %eax,%ebx
  81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  84:	89 04 24             	mov    %eax,(%esp)
  87:	e8 6d 03 00 00       	call   3f9 <strlen>
  8c:	05 a8 11 00 00       	add    $0x11a8,%eax
  91:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  95:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  9c:	00 
  9d:	89 04 24             	mov    %eax,(%esp)
  a0:	e8 a8 03 00 00       	call   44d <memset>
  return buf;
  a5:	b8 a8 11 00 00       	mov    $0x11a8,%eax
}
  aa:	83 c4 24             	add    $0x24,%esp
  ad:	5b                   	pop    %ebx
  ae:	5d                   	pop    %ebp
  af:	c3                   	ret    

000000b0 <ls>:

void
ls(char *path)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	57                   	push   %edi
  b4:	56                   	push   %esi
  b5:	53                   	push   %ebx
  b6:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  c3:	00 
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	89 04 24             	mov    %eax,(%esp)
  ca:	e8 a7 07 00 00       	call   876 <open>
  cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  d6:	79 20                	jns    f8 <ls+0x48>
    printf(2, "ls: cannot open %s\n", path);
  d8:	8b 45 08             	mov    0x8(%ebp),%eax
  db:	89 44 24 08          	mov    %eax,0x8(%esp)
  df:	c7 44 24 04 92 0d 00 	movl   $0xd92,0x4(%esp)
  e6:	00 
  e7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  ee:	e8 d3 08 00 00       	call   9c6 <printf>
    return;
  f3:	e9 01 02 00 00       	jmp    2f9 <ls+0x249>
  }
  
  if(fstat(fd, &st) < 0){
  f8:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
  fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 102:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 105:	89 04 24             	mov    %eax,(%esp)
 108:	e8 81 07 00 00       	call   88e <fstat>
 10d:	85 c0                	test   %eax,%eax
 10f:	79 2b                	jns    13c <ls+0x8c>
    printf(2, "ls: cannot stat %s\n", path);
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	89 44 24 08          	mov    %eax,0x8(%esp)
 118:	c7 44 24 04 a6 0d 00 	movl   $0xda6,0x4(%esp)
 11f:	00 
 120:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 127:	e8 9a 08 00 00       	call   9c6 <printf>
    close(fd);
 12c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 12f:	89 04 24             	mov    %eax,(%esp)
 132:	e8 27 07 00 00       	call   85e <close>
    return;
 137:	e9 bd 01 00 00       	jmp    2f9 <ls+0x249>
  }
  
  switch(st.type){
 13c:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 143:	98                   	cwtl   
 144:	83 f8 01             	cmp    $0x1,%eax
 147:	74 53                	je     19c <ls+0xec>
 149:	83 f8 02             	cmp    $0x2,%eax
 14c:	0f 85 9c 01 00 00    	jne    2ee <ls+0x23e>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 152:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 158:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 15e:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 165:	0f bf d8             	movswl %ax,%ebx
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	89 04 24             	mov    %eax,(%esp)
 16e:	e8 8d fe ff ff       	call   0 <fmtname>
 173:	89 7c 24 14          	mov    %edi,0x14(%esp)
 177:	89 74 24 10          	mov    %esi,0x10(%esp)
 17b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 17f:	89 44 24 08          	mov    %eax,0x8(%esp)
 183:	c7 44 24 04 ba 0d 00 	movl   $0xdba,0x4(%esp)
 18a:	00 
 18b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 192:	e8 2f 08 00 00       	call   9c6 <printf>
    break;
 197:	e9 52 01 00 00       	jmp    2ee <ls+0x23e>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
 19f:	89 04 24             	mov    %eax,(%esp)
 1a2:	e8 52 02 00 00       	call   3f9 <strlen>
 1a7:	83 c0 10             	add    $0x10,%eax
 1aa:	3d 00 02 00 00       	cmp    $0x200,%eax
 1af:	76 19                	jbe    1ca <ls+0x11a>
      printf(1, "ls: path too long\n");
 1b1:	c7 44 24 04 c7 0d 00 	movl   $0xdc7,0x4(%esp)
 1b8:	00 
 1b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c0:	e8 01 08 00 00       	call   9c6 <printf>
      break;
 1c5:	e9 24 01 00 00       	jmp    2ee <ls+0x23e>
    }
    strcpy(buf, path);
 1ca:	8b 45 08             	mov    0x8(%ebp),%eax
 1cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d1:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1d7:	89 04 24             	mov    %eax,(%esp)
 1da:	e8 ab 01 00 00       	call   38a <strcpy>
    p = buf+strlen(buf);
 1df:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1e5:	89 04 24             	mov    %eax,(%esp)
 1e8:	e8 0c 02 00 00       	call   3f9 <strlen>
 1ed:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
 1f3:	01 d0                	add    %edx,%eax
 1f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1fb:	8d 50 01             	lea    0x1(%eax),%edx
 1fe:	89 55 e0             	mov    %edx,-0x20(%ebp)
 201:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 204:	e9 be 00 00 00       	jmp    2c7 <ls+0x217>
      if(de.inum == 0)
 209:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 210:	66 85 c0             	test   %ax,%ax
 213:	75 05                	jne    21a <ls+0x16a>
        continue;
 215:	e9 ad 00 00 00       	jmp    2c7 <ls+0x217>
      memmove(p, de.name, DIRSIZ);
 21a:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 221:	00 
 222:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 228:	83 c0 02             	add    $0x2,%eax
 22b:	89 44 24 04          	mov    %eax,0x4(%esp)
 22f:	8b 45 e0             	mov    -0x20(%ebp),%eax
 232:	89 04 24             	mov    %eax,(%esp)
 235:	e8 7b 03 00 00       	call   5b5 <memmove>
      p[DIRSIZ] = 0;
 23a:	8b 45 e0             	mov    -0x20(%ebp),%eax
 23d:	83 c0 0e             	add    $0xe,%eax
 240:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 243:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 249:	89 44 24 04          	mov    %eax,0x4(%esp)
 24d:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 253:	89 04 24             	mov    %eax,(%esp)
 256:	e8 bf 02 00 00       	call   51a <stat>
 25b:	85 c0                	test   %eax,%eax
 25d:	79 20                	jns    27f <ls+0x1cf>
        printf(1, "ls: cannot stat %s\n", buf);
 25f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 265:	89 44 24 08          	mov    %eax,0x8(%esp)
 269:	c7 44 24 04 a6 0d 00 	movl   $0xda6,0x4(%esp)
 270:	00 
 271:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 278:	e8 49 07 00 00       	call   9c6 <printf>
        continue;
 27d:	eb 48                	jmp    2c7 <ls+0x217>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 27f:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 285:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 28b:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 292:	0f bf d8             	movswl %ax,%ebx
 295:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 29b:	89 04 24             	mov    %eax,(%esp)
 29e:	e8 5d fd ff ff       	call   0 <fmtname>
 2a3:	89 7c 24 14          	mov    %edi,0x14(%esp)
 2a7:	89 74 24 10          	mov    %esi,0x10(%esp)
 2ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 2af:	89 44 24 08          	mov    %eax,0x8(%esp)
 2b3:	c7 44 24 04 ba 0d 00 	movl   $0xdba,0x4(%esp)
 2ba:	00 
 2bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2c2:	e8 ff 06 00 00       	call   9c6 <printf>
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2c7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 2ce:	00 
 2cf:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2dc:	89 04 24             	mov    %eax,(%esp)
 2df:	e8 6a 05 00 00       	call   84e <read>
 2e4:	83 f8 10             	cmp    $0x10,%eax
 2e7:	0f 84 1c ff ff ff    	je     209 <ls+0x159>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
 2ed:	90                   	nop
  }
  close(fd);
 2ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2f1:	89 04 24             	mov    %eax,(%esp)
 2f4:	e8 65 05 00 00       	call   85e <close>
}
 2f9:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 2ff:	5b                   	pop    %ebx
 300:	5e                   	pop    %esi
 301:	5f                   	pop    %edi
 302:	5d                   	pop    %ebp
 303:	c3                   	ret    

00000304 <main>:

int
main(int argc, char *argv[])
{
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	83 e4 f0             	and    $0xfffffff0,%esp
 30a:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
 30d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 311:	7f 11                	jg     324 <main+0x20>
    ls(".");
 313:	c7 04 24 da 0d 00 00 	movl   $0xdda,(%esp)
 31a:	e8 91 fd ff ff       	call   b0 <ls>
    exit();
 31f:	e8 12 05 00 00       	call   836 <exit>
  }
  for(i=1; i<argc; i++)
 324:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 32b:	00 
 32c:	eb 1f                	jmp    34d <main+0x49>
    ls(argv[i]);
 32e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 339:	8b 45 0c             	mov    0xc(%ebp),%eax
 33c:	01 d0                	add    %edx,%eax
 33e:	8b 00                	mov    (%eax),%eax
 340:	89 04 24             	mov    %eax,(%esp)
 343:	e8 68 fd ff ff       	call   b0 <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 348:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 34d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 351:	3b 45 08             	cmp    0x8(%ebp),%eax
 354:	7c d8                	jl     32e <main+0x2a>
    ls(argv[i]);
  exit();
 356:	e8 db 04 00 00       	call   836 <exit>

0000035b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 35b:	55                   	push   %ebp
 35c:	89 e5                	mov    %esp,%ebp
 35e:	57                   	push   %edi
 35f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 360:	8b 4d 08             	mov    0x8(%ebp),%ecx
 363:	8b 55 10             	mov    0x10(%ebp),%edx
 366:	8b 45 0c             	mov    0xc(%ebp),%eax
 369:	89 cb                	mov    %ecx,%ebx
 36b:	89 df                	mov    %ebx,%edi
 36d:	89 d1                	mov    %edx,%ecx
 36f:	fc                   	cld    
 370:	f3 aa                	rep stos %al,%es:(%edi)
 372:	89 ca                	mov    %ecx,%edx
 374:	89 fb                	mov    %edi,%ebx
 376:	89 5d 08             	mov    %ebx,0x8(%ebp)
 379:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 37c:	5b                   	pop    %ebx
 37d:	5f                   	pop    %edi
 37e:	5d                   	pop    %ebp
 37f:	c3                   	ret    

00000380 <thing>:
#include "user.h"
#include "x86.h"


int
thing(void){
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
  return 1;
 383:	b8 01 00 00 00       	mov    $0x1,%eax
}
 388:	5d                   	pop    %ebp
 389:	c3                   	ret    

0000038a <strcpy>:

char*
strcpy(char *s, char *t)
{
 38a:	55                   	push   %ebp
 38b:	89 e5                	mov    %esp,%ebp
 38d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 390:	8b 45 08             	mov    0x8(%ebp),%eax
 393:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 396:	90                   	nop
 397:	8b 45 08             	mov    0x8(%ebp),%eax
 39a:	8d 50 01             	lea    0x1(%eax),%edx
 39d:	89 55 08             	mov    %edx,0x8(%ebp)
 3a0:	8b 55 0c             	mov    0xc(%ebp),%edx
 3a3:	8d 4a 01             	lea    0x1(%edx),%ecx
 3a6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 3a9:	0f b6 12             	movzbl (%edx),%edx
 3ac:	88 10                	mov    %dl,(%eax)
 3ae:	0f b6 00             	movzbl (%eax),%eax
 3b1:	84 c0                	test   %al,%al
 3b3:	75 e2                	jne    397 <strcpy+0xd>
    ;
  return os;
 3b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3b8:	c9                   	leave  
 3b9:	c3                   	ret    

000003ba <strcmp>:



int
strcmp(const char *p, const char *q)
{
 3ba:	55                   	push   %ebp
 3bb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3bd:	eb 08                	jmp    3c7 <strcmp+0xd>
    p++, q++;
 3bf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3c3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)


int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	0f b6 00             	movzbl (%eax),%eax
 3cd:	84 c0                	test   %al,%al
 3cf:	74 10                	je     3e1 <strcmp+0x27>
 3d1:	8b 45 08             	mov    0x8(%ebp),%eax
 3d4:	0f b6 10             	movzbl (%eax),%edx
 3d7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3da:	0f b6 00             	movzbl (%eax),%eax
 3dd:	38 c2                	cmp    %al,%dl
 3df:	74 de                	je     3bf <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3e1:	8b 45 08             	mov    0x8(%ebp),%eax
 3e4:	0f b6 00             	movzbl (%eax),%eax
 3e7:	0f b6 d0             	movzbl %al,%edx
 3ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ed:	0f b6 00             	movzbl (%eax),%eax
 3f0:	0f b6 c0             	movzbl %al,%eax
 3f3:	29 c2                	sub    %eax,%edx
 3f5:	89 d0                	mov    %edx,%eax
}
 3f7:	5d                   	pop    %ebp
 3f8:	c3                   	ret    

000003f9 <strlen>:

uint
strlen(char *s)
{
 3f9:	55                   	push   %ebp
 3fa:	89 e5                	mov    %esp,%ebp
 3fc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 406:	eb 04                	jmp    40c <strlen+0x13>
 408:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 40c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 40f:	8b 45 08             	mov    0x8(%ebp),%eax
 412:	01 d0                	add    %edx,%eax
 414:	0f b6 00             	movzbl (%eax),%eax
 417:	84 c0                	test   %al,%al
 419:	75 ed                	jne    408 <strlen+0xf>
    ;
  return n;
 41b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 41e:	c9                   	leave  
 41f:	c3                   	ret    

00000420 <stringlen>:

uint
stringlen(char **s){
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	83 ec 10             	sub    $0x10,%esp
	int n;

  for(n = 0; s[n]; n++)
 426:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 42d:	eb 04                	jmp    433 <stringlen+0x13>
 42f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 433:	8b 45 fc             	mov    -0x4(%ebp),%eax
 436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 43d:	8b 45 08             	mov    0x8(%ebp),%eax
 440:	01 d0                	add    %edx,%eax
 442:	8b 00                	mov    (%eax),%eax
 444:	85 c0                	test   %eax,%eax
 446:	75 e7                	jne    42f <stringlen+0xf>
    ;
  return n;
 448:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 44b:	c9                   	leave  
 44c:	c3                   	ret    

0000044d <memset>:

void*
memset(void *dst, int c, uint n)
{
 44d:	55                   	push   %ebp
 44e:	89 e5                	mov    %esp,%ebp
 450:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 453:	8b 45 10             	mov    0x10(%ebp),%eax
 456:	89 44 24 08          	mov    %eax,0x8(%esp)
 45a:	8b 45 0c             	mov    0xc(%ebp),%eax
 45d:	89 44 24 04          	mov    %eax,0x4(%esp)
 461:	8b 45 08             	mov    0x8(%ebp),%eax
 464:	89 04 24             	mov    %eax,(%esp)
 467:	e8 ef fe ff ff       	call   35b <stosb>
  return dst;
 46c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 46f:	c9                   	leave  
 470:	c3                   	ret    

00000471 <strchr>:

char*
strchr(const char *s, char c)
{
 471:	55                   	push   %ebp
 472:	89 e5                	mov    %esp,%ebp
 474:	83 ec 04             	sub    $0x4,%esp
 477:	8b 45 0c             	mov    0xc(%ebp),%eax
 47a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 47d:	eb 14                	jmp    493 <strchr+0x22>
    if(*s == c)
 47f:	8b 45 08             	mov    0x8(%ebp),%eax
 482:	0f b6 00             	movzbl (%eax),%eax
 485:	3a 45 fc             	cmp    -0x4(%ebp),%al
 488:	75 05                	jne    48f <strchr+0x1e>
      return (char*)s;
 48a:	8b 45 08             	mov    0x8(%ebp),%eax
 48d:	eb 13                	jmp    4a2 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 48f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 493:	8b 45 08             	mov    0x8(%ebp),%eax
 496:	0f b6 00             	movzbl (%eax),%eax
 499:	84 c0                	test   %al,%al
 49b:	75 e2                	jne    47f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 49d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4a2:	c9                   	leave  
 4a3:	c3                   	ret    

000004a4 <gets>:

char*
gets(char *buf, int max)
{
 4a4:	55                   	push   %ebp
 4a5:	89 e5                	mov    %esp,%ebp
 4a7:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 4b1:	eb 4c                	jmp    4ff <gets+0x5b>
    cc = read(0, &c, 1);
 4b3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4ba:	00 
 4bb:	8d 45 ef             	lea    -0x11(%ebp),%eax
 4be:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4c9:	e8 80 03 00 00       	call   84e <read>
 4ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 4d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4d5:	7f 02                	jg     4d9 <gets+0x35>
      break;
 4d7:	eb 31                	jmp    50a <gets+0x66>
    buf[i++] = c;
 4d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4dc:	8d 50 01             	lea    0x1(%eax),%edx
 4df:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4e2:	89 c2                	mov    %eax,%edx
 4e4:	8b 45 08             	mov    0x8(%ebp),%eax
 4e7:	01 c2                	add    %eax,%edx
 4e9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4ed:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 4ef:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4f3:	3c 0a                	cmp    $0xa,%al
 4f5:	74 13                	je     50a <gets+0x66>
 4f7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4fb:	3c 0d                	cmp    $0xd,%al
 4fd:	74 0b                	je     50a <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 502:	83 c0 01             	add    $0x1,%eax
 505:	3b 45 0c             	cmp    0xc(%ebp),%eax
 508:	7c a9                	jl     4b3 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 50a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 50d:	8b 45 08             	mov    0x8(%ebp),%eax
 510:	01 d0                	add    %edx,%eax
 512:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 515:	8b 45 08             	mov    0x8(%ebp),%eax
}
 518:	c9                   	leave  
 519:	c3                   	ret    

0000051a <stat>:

int
stat(char *n, struct stat *st)
{
 51a:	55                   	push   %ebp
 51b:	89 e5                	mov    %esp,%ebp
 51d:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 520:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 527:	00 
 528:	8b 45 08             	mov    0x8(%ebp),%eax
 52b:	89 04 24             	mov    %eax,(%esp)
 52e:	e8 43 03 00 00       	call   876 <open>
 533:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 536:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 53a:	79 07                	jns    543 <stat+0x29>
    return -1;
 53c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 541:	eb 23                	jmp    566 <stat+0x4c>
  r = fstat(fd, st);
 543:	8b 45 0c             	mov    0xc(%ebp),%eax
 546:	89 44 24 04          	mov    %eax,0x4(%esp)
 54a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54d:	89 04 24             	mov    %eax,(%esp)
 550:	e8 39 03 00 00       	call   88e <fstat>
 555:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 558:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55b:	89 04 24             	mov    %eax,(%esp)
 55e:	e8 fb 02 00 00       	call   85e <close>
  return r;
 563:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 566:	c9                   	leave  
 567:	c3                   	ret    

00000568 <atoi>:

int
atoi(const char *s)
{
 568:	55                   	push   %ebp
 569:	89 e5                	mov    %esp,%ebp
 56b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 56e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 575:	eb 25                	jmp    59c <atoi+0x34>
    n = n*10 + *s++ - '0';
 577:	8b 55 fc             	mov    -0x4(%ebp),%edx
 57a:	89 d0                	mov    %edx,%eax
 57c:	c1 e0 02             	shl    $0x2,%eax
 57f:	01 d0                	add    %edx,%eax
 581:	01 c0                	add    %eax,%eax
 583:	89 c1                	mov    %eax,%ecx
 585:	8b 45 08             	mov    0x8(%ebp),%eax
 588:	8d 50 01             	lea    0x1(%eax),%edx
 58b:	89 55 08             	mov    %edx,0x8(%ebp)
 58e:	0f b6 00             	movzbl (%eax),%eax
 591:	0f be c0             	movsbl %al,%eax
 594:	01 c8                	add    %ecx,%eax
 596:	83 e8 30             	sub    $0x30,%eax
 599:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 59c:	8b 45 08             	mov    0x8(%ebp),%eax
 59f:	0f b6 00             	movzbl (%eax),%eax
 5a2:	3c 2f                	cmp    $0x2f,%al
 5a4:	7e 0a                	jle    5b0 <atoi+0x48>
 5a6:	8b 45 08             	mov    0x8(%ebp),%eax
 5a9:	0f b6 00             	movzbl (%eax),%eax
 5ac:	3c 39                	cmp    $0x39,%al
 5ae:	7e c7                	jle    577 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 5b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5b3:	c9                   	leave  
 5b4:	c3                   	ret    

000005b5 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 5b5:	55                   	push   %ebp
 5b6:	89 e5                	mov    %esp,%ebp
 5b8:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 5bb:	8b 45 08             	mov    0x8(%ebp),%eax
 5be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 5c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 5c7:	eb 17                	jmp    5e0 <memmove+0x2b>
    *dst++ = *src++;
 5c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5cc:	8d 50 01             	lea    0x1(%eax),%edx
 5cf:	89 55 fc             	mov    %edx,-0x4(%ebp)
 5d2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5d5:	8d 4a 01             	lea    0x1(%edx),%ecx
 5d8:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 5db:	0f b6 12             	movzbl (%edx),%edx
 5de:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5e0:	8b 45 10             	mov    0x10(%ebp),%eax
 5e3:	8d 50 ff             	lea    -0x1(%eax),%edx
 5e6:	89 55 10             	mov    %edx,0x10(%ebp)
 5e9:	85 c0                	test   %eax,%eax
 5eb:	7f dc                	jg     5c9 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5f0:	c9                   	leave  
 5f1:	c3                   	ret    

000005f2 <strcmp_c>:


int
strcmp_c(const char *s1, const char *s2)
{
 5f2:	55                   	push   %ebp
 5f3:	89 e5                	mov    %esp,%ebp
    for ( ; *s1 == *s2; s1++, s2++)
 5f5:	eb 19                	jmp    610 <strcmp_c+0x1e>
	if (*s1 == '\0')
 5f7:	8b 45 08             	mov    0x8(%ebp),%eax
 5fa:	0f b6 00             	movzbl (%eax),%eax
 5fd:	84 c0                	test   %al,%al
 5ff:	75 07                	jne    608 <strcmp_c+0x16>
	    return 0;
 601:	b8 00 00 00 00       	mov    $0x0,%eax
 606:	eb 34                	jmp    63c <strcmp_c+0x4a>


int
strcmp_c(const char *s1, const char *s2)
{
    for ( ; *s1 == *s2; s1++, s2++)
 608:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 60c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 610:	8b 45 08             	mov    0x8(%ebp),%eax
 613:	0f b6 10             	movzbl (%eax),%edx
 616:	8b 45 0c             	mov    0xc(%ebp),%eax
 619:	0f b6 00             	movzbl (%eax),%eax
 61c:	38 c2                	cmp    %al,%dl
 61e:	74 d7                	je     5f7 <strcmp_c+0x5>
	if (*s1 == '\0')
	    return 0;
    return ((*(unsigned char *)s1 < *(unsigned char *)s2) ? -1 : +1);
 620:	8b 45 08             	mov    0x8(%ebp),%eax
 623:	0f b6 10             	movzbl (%eax),%edx
 626:	8b 45 0c             	mov    0xc(%ebp),%eax
 629:	0f b6 00             	movzbl (%eax),%eax
 62c:	38 c2                	cmp    %al,%dl
 62e:	73 07                	jae    637 <strcmp_c+0x45>
 630:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 635:	eb 05                	jmp    63c <strcmp_c+0x4a>
 637:	b8 01 00 00 00       	mov    $0x1,%eax
}
 63c:	5d                   	pop    %ebp
 63d:	c3                   	ret    

0000063e <readuser>:


struct USER
readuser(){
 63e:	55                   	push   %ebp
 63f:	89 e5                	mov    %esp,%ebp
 641:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char buff1[512], buff2[512];
	struct USER u;
	printf(1,"Please enter a username: ");
 647:	c7 44 24 04 dc 0d 00 	movl   $0xddc,0x4(%esp)
 64e:	00 
 64f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 656:	e8 6b 03 00 00       	call   9c6 <printf>
	u.name = gets(buff1, 50);
 65b:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 662:	00 
 663:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
 669:	89 04 24             	mov    %eax,(%esp)
 66c:	e8 33 fe ff ff       	call   4a4 <gets>
 671:	89 85 ec fb ff ff    	mov    %eax,-0x414(%ebp)
	printf(1,"Please enter a password: ");
 677:	c7 44 24 04 f6 0d 00 	movl   $0xdf6,0x4(%esp)
 67e:	00 
 67f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 686:	e8 3b 03 00 00       	call   9c6 <printf>
	u.pass = gets(buff2, 50);
 68b:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
 692:	00 
 693:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
 699:	89 04 24             	mov    %eax,(%esp)
 69c:	e8 03 fe ff ff       	call   4a4 <gets>
 6a1:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
	return u;
 6a7:	8b 45 08             	mov    0x8(%ebp),%eax
 6aa:	8b 95 ec fb ff ff    	mov    -0x414(%ebp),%edx
 6b0:	89 10                	mov    %edx,(%eax)
 6b2:	8b 95 f0 fb ff ff    	mov    -0x410(%ebp),%edx
 6b8:	89 50 04             	mov    %edx,0x4(%eax)
 6bb:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
 6c1:	89 50 08             	mov    %edx,0x8(%eax)
}
 6c4:	8b 45 08             	mov    0x8(%ebp),%eax
 6c7:	c9                   	leave  
 6c8:	c2 04 00             	ret    $0x4

000006cb <compareuser>:


int
compareuser(int state){
 6cb:	55                   	push   %ebp
 6cc:	89 e5                	mov    %esp,%ebp
 6ce:	56                   	push   %esi
 6cf:	53                   	push   %ebx
 6d0:	81 ec 30 01 00 00    	sub    $0x130,%esp
	struct USER u1,u2;
	struct USER users[20];
	u1.name = "john\n";
 6d6:	c7 45 e8 10 0e 00 00 	movl   $0xe10,-0x18(%ebp)
	u1.pass = "1234\n";
 6dd:	c7 45 ec 16 0e 00 00 	movl   $0xe16,-0x14(%ebp)
	u1.ulevel = 0;
 6e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	u2.name = "james\n";
 6eb:	c7 45 dc 1c 0e 00 00 	movl   $0xe1c,-0x24(%ebp)
	u2.pass = "pass\n";
 6f2:	c7 45 e0 23 0e 00 00 	movl   $0xe23,-0x20(%ebp)
	u2.ulevel = 1;
 6f9:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	users[0] = u1;
 700:	8b 45 e8             	mov    -0x18(%ebp),%eax
 703:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
 709:	8b 45 ec             	mov    -0x14(%ebp),%eax
 70c:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
 712:	8b 45 f0             	mov    -0x10(%ebp),%eax
 715:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
	users[1] = u2;
 71b:	8b 45 dc             	mov    -0x24(%ebp),%eax
 71e:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
 724:	8b 45 e0             	mov    -0x20(%ebp),%eax
 727:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
 72d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 730:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
	
	
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
 736:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
 73c:	89 04 24             	mov    %eax,(%esp)
 73f:	e8 fa fe ff ff       	call   63e <readuser>
 744:	83 ec 04             	sub    $0x4,%esp
		
		for(ctr = 0; ctr < 20; ctr++)
 747:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 74e:	e9 a4 00 00 00       	jmp    7f7 <compareuser+0x12c>
		{

			if(strcmp_c(u.name,users[ctr].name) == 0 && strcmp_c(u.pass,users[ctr].pass) == 0)
 753:	8b 55 f4             	mov    -0xc(%ebp),%edx
 756:	89 d0                	mov    %edx,%eax
 758:	01 c0                	add    %eax,%eax
 75a:	01 d0                	add    %edx,%eax
 75c:	c1 e0 02             	shl    $0x2,%eax
 75f:	8d 4d f8             	lea    -0x8(%ebp),%ecx
 762:	01 c8                	add    %ecx,%eax
 764:	2d 0c 01 00 00       	sub    $0x10c,%eax
 769:	8b 10                	mov    (%eax),%edx
 76b:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
 771:	89 54 24 04          	mov    %edx,0x4(%esp)
 775:	89 04 24             	mov    %eax,(%esp)
 778:	e8 75 fe ff ff       	call   5f2 <strcmp_c>
 77d:	85 c0                	test   %eax,%eax
 77f:	75 72                	jne    7f3 <compareuser+0x128>
 781:	8b 55 f4             	mov    -0xc(%ebp),%edx
 784:	89 d0                	mov    %edx,%eax
 786:	01 c0                	add    %eax,%eax
 788:	01 d0                	add    %edx,%eax
 78a:	c1 e0 02             	shl    $0x2,%eax
 78d:	8d 5d f8             	lea    -0x8(%ebp),%ebx
 790:	01 d8                	add    %ebx,%eax
 792:	2d 08 01 00 00       	sub    $0x108,%eax
 797:	8b 10                	mov    (%eax),%edx
 799:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
 79f:	89 54 24 04          	mov    %edx,0x4(%esp)
 7a3:	89 04 24             	mov    %eax,(%esp)
 7a6:	e8 47 fe ff ff       	call   5f2 <strcmp_c>
 7ab:	85 c0                	test   %eax,%eax
 7ad:	75 44                	jne    7f3 <compareuser+0x128>
			{
				setuser(users[ctr].ulevel);
 7af:	8b 55 f4             	mov    -0xc(%ebp),%edx
 7b2:	89 d0                	mov    %edx,%eax
 7b4:	01 c0                	add    %eax,%eax
 7b6:	01 d0                	add    %edx,%eax
 7b8:	c1 e0 02             	shl    $0x2,%eax
 7bb:	8d 75 f8             	lea    -0x8(%ebp),%esi
 7be:	01 f0                	add    %esi,%eax
 7c0:	2d 04 01 00 00       	sub    $0x104,%eax
 7c5:	8b 00                	mov    (%eax),%eax
 7c7:	89 04 24             	mov    %eax,(%esp)
 7ca:	e8 0f 01 00 00       	call   8de <setuser>
				
				printf(1,"%d",getuser());
 7cf:	e8 02 01 00 00       	call   8d6 <getuser>
 7d4:	89 44 24 08          	mov    %eax,0x8(%esp)
 7d8:	c7 44 24 04 29 0e 00 	movl   $0xe29,0x4(%esp)
 7df:	00 
 7e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 7e7:	e8 da 01 00 00       	call   9c6 <printf>
				return 1;
 7ec:	b8 01 00 00 00       	mov    $0x1,%eax
 7f1:	eb 34                	jmp    827 <compareuser+0x15c>
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
		
		for(ctr = 0; ctr < 20; ctr++)
 7f3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 7f7:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 7fb:	0f 8e 52 ff ff ff    	jle    753 <compareuser+0x88>
				
				printf(1,"%d",getuser());
				return 1;
			}
		}
		printf(1,"Invalid username/password\n");
 801:	c7 44 24 04 2c 0e 00 	movl   $0xe2c,0x4(%esp)
 808:	00 
 809:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 810:	e8 b1 01 00 00       	call   9c6 <printf>
		if(state != 1)
 815:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 819:	74 07                	je     822 <compareuser+0x157>
			break;
	}
	return 0;
 81b:	b8 00 00 00 00       	mov    $0x0,%eax
 820:	eb 05                	jmp    827 <compareuser+0x15c>
			}
		}
		printf(1,"Invalid username/password\n");
		if(state != 1)
			break;
	}
 822:	e9 0f ff ff ff       	jmp    736 <compareuser+0x6b>
	return 0;
}
 827:	8d 65 f8             	lea    -0x8(%ebp),%esp
 82a:	5b                   	pop    %ebx
 82b:	5e                   	pop    %esi
 82c:	5d                   	pop    %ebp
 82d:	c3                   	ret    

0000082e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 82e:	b8 01 00 00 00       	mov    $0x1,%eax
 833:	cd 40                	int    $0x40
 835:	c3                   	ret    

00000836 <exit>:
SYSCALL(exit)
 836:	b8 02 00 00 00       	mov    $0x2,%eax
 83b:	cd 40                	int    $0x40
 83d:	c3                   	ret    

0000083e <wait>:
SYSCALL(wait)
 83e:	b8 03 00 00 00       	mov    $0x3,%eax
 843:	cd 40                	int    $0x40
 845:	c3                   	ret    

00000846 <pipe>:
SYSCALL(pipe)
 846:	b8 04 00 00 00       	mov    $0x4,%eax
 84b:	cd 40                	int    $0x40
 84d:	c3                   	ret    

0000084e <read>:
SYSCALL(read)
 84e:	b8 05 00 00 00       	mov    $0x5,%eax
 853:	cd 40                	int    $0x40
 855:	c3                   	ret    

00000856 <write>:
SYSCALL(write)
 856:	b8 10 00 00 00       	mov    $0x10,%eax
 85b:	cd 40                	int    $0x40
 85d:	c3                   	ret    

0000085e <close>:
SYSCALL(close)
 85e:	b8 15 00 00 00       	mov    $0x15,%eax
 863:	cd 40                	int    $0x40
 865:	c3                   	ret    

00000866 <kill>:
SYSCALL(kill)
 866:	b8 06 00 00 00       	mov    $0x6,%eax
 86b:	cd 40                	int    $0x40
 86d:	c3                   	ret    

0000086e <exec>:
SYSCALL(exec)
 86e:	b8 07 00 00 00       	mov    $0x7,%eax
 873:	cd 40                	int    $0x40
 875:	c3                   	ret    

00000876 <open>:
SYSCALL(open)
 876:	b8 0f 00 00 00       	mov    $0xf,%eax
 87b:	cd 40                	int    $0x40
 87d:	c3                   	ret    

0000087e <mknod>:
SYSCALL(mknod)
 87e:	b8 11 00 00 00       	mov    $0x11,%eax
 883:	cd 40                	int    $0x40
 885:	c3                   	ret    

00000886 <unlink>:
SYSCALL(unlink)
 886:	b8 12 00 00 00       	mov    $0x12,%eax
 88b:	cd 40                	int    $0x40
 88d:	c3                   	ret    

0000088e <fstat>:
SYSCALL(fstat)
 88e:	b8 08 00 00 00       	mov    $0x8,%eax
 893:	cd 40                	int    $0x40
 895:	c3                   	ret    

00000896 <link>:
SYSCALL(link)
 896:	b8 13 00 00 00       	mov    $0x13,%eax
 89b:	cd 40                	int    $0x40
 89d:	c3                   	ret    

0000089e <mkdir>:
SYSCALL(mkdir)
 89e:	b8 14 00 00 00       	mov    $0x14,%eax
 8a3:	cd 40                	int    $0x40
 8a5:	c3                   	ret    

000008a6 <chdir>:
SYSCALL(chdir)
 8a6:	b8 09 00 00 00       	mov    $0x9,%eax
 8ab:	cd 40                	int    $0x40
 8ad:	c3                   	ret    

000008ae <dup>:
SYSCALL(dup)
 8ae:	b8 0a 00 00 00       	mov    $0xa,%eax
 8b3:	cd 40                	int    $0x40
 8b5:	c3                   	ret    

000008b6 <getpid>:
SYSCALL(getpid)
 8b6:	b8 0b 00 00 00       	mov    $0xb,%eax
 8bb:	cd 40                	int    $0x40
 8bd:	c3                   	ret    

000008be <sbrk>:
SYSCALL(sbrk)
 8be:	b8 0c 00 00 00       	mov    $0xc,%eax
 8c3:	cd 40                	int    $0x40
 8c5:	c3                   	ret    

000008c6 <sleep>:
SYSCALL(sleep)
 8c6:	b8 0d 00 00 00       	mov    $0xd,%eax
 8cb:	cd 40                	int    $0x40
 8cd:	c3                   	ret    

000008ce <uptime>:
SYSCALL(uptime)
 8ce:	b8 0e 00 00 00       	mov    $0xe,%eax
 8d3:	cd 40                	int    $0x40
 8d5:	c3                   	ret    

000008d6 <getuser>:
SYSCALL(getuser)
 8d6:	b8 16 00 00 00       	mov    $0x16,%eax
 8db:	cd 40                	int    $0x40
 8dd:	c3                   	ret    

000008de <setuser>:
SYSCALL(setuser)
 8de:	b8 17 00 00 00       	mov    $0x17,%eax
 8e3:	cd 40                	int    $0x40
 8e5:	c3                   	ret    

000008e6 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 8e6:	55                   	push   %ebp
 8e7:	89 e5                	mov    %esp,%ebp
 8e9:	83 ec 18             	sub    $0x18,%esp
 8ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 8ef:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 8f2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8f9:	00 
 8fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
 8fd:	89 44 24 04          	mov    %eax,0x4(%esp)
 901:	8b 45 08             	mov    0x8(%ebp),%eax
 904:	89 04 24             	mov    %eax,(%esp)
 907:	e8 4a ff ff ff       	call   856 <write>
}
 90c:	c9                   	leave  
 90d:	c3                   	ret    

0000090e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 90e:	55                   	push   %ebp
 90f:	89 e5                	mov    %esp,%ebp
 911:	56                   	push   %esi
 912:	53                   	push   %ebx
 913:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 916:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 91d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 921:	74 17                	je     93a <printint+0x2c>
 923:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 927:	79 11                	jns    93a <printint+0x2c>
    neg = 1;
 929:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 930:	8b 45 0c             	mov    0xc(%ebp),%eax
 933:	f7 d8                	neg    %eax
 935:	89 45 ec             	mov    %eax,-0x14(%ebp)
 938:	eb 06                	jmp    940 <printint+0x32>
  } else {
    x = xx;
 93a:	8b 45 0c             	mov    0xc(%ebp),%eax
 93d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 940:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 947:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 94a:	8d 41 01             	lea    0x1(%ecx),%eax
 94d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 950:	8b 5d 10             	mov    0x10(%ebp),%ebx
 953:	8b 45 ec             	mov    -0x14(%ebp),%eax
 956:	ba 00 00 00 00       	mov    $0x0,%edx
 95b:	f7 f3                	div    %ebx
 95d:	89 d0                	mov    %edx,%eax
 95f:	0f b6 80 94 11 00 00 	movzbl 0x1194(%eax),%eax
 966:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 96a:	8b 75 10             	mov    0x10(%ebp),%esi
 96d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 970:	ba 00 00 00 00       	mov    $0x0,%edx
 975:	f7 f6                	div    %esi
 977:	89 45 ec             	mov    %eax,-0x14(%ebp)
 97a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 97e:	75 c7                	jne    947 <printint+0x39>
  if(neg)
 980:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 984:	74 10                	je     996 <printint+0x88>
    buf[i++] = '-';
 986:	8b 45 f4             	mov    -0xc(%ebp),%eax
 989:	8d 50 01             	lea    0x1(%eax),%edx
 98c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 98f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 994:	eb 1f                	jmp    9b5 <printint+0xa7>
 996:	eb 1d                	jmp    9b5 <printint+0xa7>
    putc(fd, buf[i]);
 998:	8d 55 dc             	lea    -0x24(%ebp),%edx
 99b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99e:	01 d0                	add    %edx,%eax
 9a0:	0f b6 00             	movzbl (%eax),%eax
 9a3:	0f be c0             	movsbl %al,%eax
 9a6:	89 44 24 04          	mov    %eax,0x4(%esp)
 9aa:	8b 45 08             	mov    0x8(%ebp),%eax
 9ad:	89 04 24             	mov    %eax,(%esp)
 9b0:	e8 31 ff ff ff       	call   8e6 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 9b5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 9b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9bd:	79 d9                	jns    998 <printint+0x8a>
    putc(fd, buf[i]);
}
 9bf:	83 c4 30             	add    $0x30,%esp
 9c2:	5b                   	pop    %ebx
 9c3:	5e                   	pop    %esi
 9c4:	5d                   	pop    %ebp
 9c5:	c3                   	ret    

000009c6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 9c6:	55                   	push   %ebp
 9c7:	89 e5                	mov    %esp,%ebp
 9c9:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 9cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 9d3:	8d 45 0c             	lea    0xc(%ebp),%eax
 9d6:	83 c0 04             	add    $0x4,%eax
 9d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 9dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 9e3:	e9 7c 01 00 00       	jmp    b64 <printf+0x19e>
    c = fmt[i] & 0xff;
 9e8:	8b 55 0c             	mov    0xc(%ebp),%edx
 9eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ee:	01 d0                	add    %edx,%eax
 9f0:	0f b6 00             	movzbl (%eax),%eax
 9f3:	0f be c0             	movsbl %al,%eax
 9f6:	25 ff 00 00 00       	and    $0xff,%eax
 9fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 9fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a02:	75 2c                	jne    a30 <printf+0x6a>
      if(c == '%'){
 a04:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a08:	75 0c                	jne    a16 <printf+0x50>
        state = '%';
 a0a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 a11:	e9 4a 01 00 00       	jmp    b60 <printf+0x19a>
      } else {
        putc(fd, c);
 a16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a19:	0f be c0             	movsbl %al,%eax
 a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
 a20:	8b 45 08             	mov    0x8(%ebp),%eax
 a23:	89 04 24             	mov    %eax,(%esp)
 a26:	e8 bb fe ff ff       	call   8e6 <putc>
 a2b:	e9 30 01 00 00       	jmp    b60 <printf+0x19a>
      }
    } else if(state == '%'){
 a30:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 a34:	0f 85 26 01 00 00    	jne    b60 <printf+0x19a>
      if(c == 'd'){
 a3a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 a3e:	75 2d                	jne    a6d <printf+0xa7>
        printint(fd, *ap, 10, 1);
 a40:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a43:	8b 00                	mov    (%eax),%eax
 a45:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 a4c:	00 
 a4d:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 a54:	00 
 a55:	89 44 24 04          	mov    %eax,0x4(%esp)
 a59:	8b 45 08             	mov    0x8(%ebp),%eax
 a5c:	89 04 24             	mov    %eax,(%esp)
 a5f:	e8 aa fe ff ff       	call   90e <printint>
        ap++;
 a64:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a68:	e9 ec 00 00 00       	jmp    b59 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 a6d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 a71:	74 06                	je     a79 <printf+0xb3>
 a73:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 a77:	75 2d                	jne    aa6 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 a79:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a7c:	8b 00                	mov    (%eax),%eax
 a7e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 a85:	00 
 a86:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 a8d:	00 
 a8e:	89 44 24 04          	mov    %eax,0x4(%esp)
 a92:	8b 45 08             	mov    0x8(%ebp),%eax
 a95:	89 04 24             	mov    %eax,(%esp)
 a98:	e8 71 fe ff ff       	call   90e <printint>
        ap++;
 a9d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 aa1:	e9 b3 00 00 00       	jmp    b59 <printf+0x193>
      } else if(c == 's'){
 aa6:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 aaa:	75 45                	jne    af1 <printf+0x12b>
        s = (char*)*ap;
 aac:	8b 45 e8             	mov    -0x18(%ebp),%eax
 aaf:	8b 00                	mov    (%eax),%eax
 ab1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 ab4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 ab8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 abc:	75 09                	jne    ac7 <printf+0x101>
          s = "(null)";
 abe:	c7 45 f4 47 0e 00 00 	movl   $0xe47,-0xc(%ebp)
        while(*s != 0){
 ac5:	eb 1e                	jmp    ae5 <printf+0x11f>
 ac7:	eb 1c                	jmp    ae5 <printf+0x11f>
          putc(fd, *s);
 ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 acc:	0f b6 00             	movzbl (%eax),%eax
 acf:	0f be c0             	movsbl %al,%eax
 ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
 ad6:	8b 45 08             	mov    0x8(%ebp),%eax
 ad9:	89 04 24             	mov    %eax,(%esp)
 adc:	e8 05 fe ff ff       	call   8e6 <putc>
          s++;
 ae1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae8:	0f b6 00             	movzbl (%eax),%eax
 aeb:	84 c0                	test   %al,%al
 aed:	75 da                	jne    ac9 <printf+0x103>
 aef:	eb 68                	jmp    b59 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 af1:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 af5:	75 1d                	jne    b14 <printf+0x14e>
        putc(fd, *ap);
 af7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 afa:	8b 00                	mov    (%eax),%eax
 afc:	0f be c0             	movsbl %al,%eax
 aff:	89 44 24 04          	mov    %eax,0x4(%esp)
 b03:	8b 45 08             	mov    0x8(%ebp),%eax
 b06:	89 04 24             	mov    %eax,(%esp)
 b09:	e8 d8 fd ff ff       	call   8e6 <putc>
        ap++;
 b0e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b12:	eb 45                	jmp    b59 <printf+0x193>
      } else if(c == '%'){
 b14:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b18:	75 17                	jne    b31 <printf+0x16b>
        putc(fd, c);
 b1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b1d:	0f be c0             	movsbl %al,%eax
 b20:	89 44 24 04          	mov    %eax,0x4(%esp)
 b24:	8b 45 08             	mov    0x8(%ebp),%eax
 b27:	89 04 24             	mov    %eax,(%esp)
 b2a:	e8 b7 fd ff ff       	call   8e6 <putc>
 b2f:	eb 28                	jmp    b59 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b31:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 b38:	00 
 b39:	8b 45 08             	mov    0x8(%ebp),%eax
 b3c:	89 04 24             	mov    %eax,(%esp)
 b3f:	e8 a2 fd ff ff       	call   8e6 <putc>
        putc(fd, c);
 b44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b47:	0f be c0             	movsbl %al,%eax
 b4a:	89 44 24 04          	mov    %eax,0x4(%esp)
 b4e:	8b 45 08             	mov    0x8(%ebp),%eax
 b51:	89 04 24             	mov    %eax,(%esp)
 b54:	e8 8d fd ff ff       	call   8e6 <putc>
      }
      state = 0;
 b59:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 b60:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 b64:	8b 55 0c             	mov    0xc(%ebp),%edx
 b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b6a:	01 d0                	add    %edx,%eax
 b6c:	0f b6 00             	movzbl (%eax),%eax
 b6f:	84 c0                	test   %al,%al
 b71:	0f 85 71 fe ff ff    	jne    9e8 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 b77:	c9                   	leave  
 b78:	c3                   	ret    

00000b79 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b79:	55                   	push   %ebp
 b7a:	89 e5                	mov    %esp,%ebp
 b7c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b7f:	8b 45 08             	mov    0x8(%ebp),%eax
 b82:	83 e8 08             	sub    $0x8,%eax
 b85:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b88:	a1 c0 11 00 00       	mov    0x11c0,%eax
 b8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b90:	eb 24                	jmp    bb6 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b92:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b95:	8b 00                	mov    (%eax),%eax
 b97:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b9a:	77 12                	ja     bae <free+0x35>
 b9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b9f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ba2:	77 24                	ja     bc8 <free+0x4f>
 ba4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ba7:	8b 00                	mov    (%eax),%eax
 ba9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bac:	77 1a                	ja     bc8 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bb1:	8b 00                	mov    (%eax),%eax
 bb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 bb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bb9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bbc:	76 d4                	jbe    b92 <free+0x19>
 bbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bc1:	8b 00                	mov    (%eax),%eax
 bc3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bc6:	76 ca                	jbe    b92 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 bc8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bcb:	8b 40 04             	mov    0x4(%eax),%eax
 bce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 bd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bd8:	01 c2                	add    %eax,%edx
 bda:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bdd:	8b 00                	mov    (%eax),%eax
 bdf:	39 c2                	cmp    %eax,%edx
 be1:	75 24                	jne    c07 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 be3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 be6:	8b 50 04             	mov    0x4(%eax),%edx
 be9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bec:	8b 00                	mov    (%eax),%eax
 bee:	8b 40 04             	mov    0x4(%eax),%eax
 bf1:	01 c2                	add    %eax,%edx
 bf3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bf6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 bf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bfc:	8b 00                	mov    (%eax),%eax
 bfe:	8b 10                	mov    (%eax),%edx
 c00:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c03:	89 10                	mov    %edx,(%eax)
 c05:	eb 0a                	jmp    c11 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 c07:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c0a:	8b 10                	mov    (%eax),%edx
 c0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c0f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c14:	8b 40 04             	mov    0x4(%eax),%eax
 c17:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c21:	01 d0                	add    %edx,%eax
 c23:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c26:	75 20                	jne    c48 <free+0xcf>
    p->s.size += bp->s.size;
 c28:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c2b:	8b 50 04             	mov    0x4(%eax),%edx
 c2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c31:	8b 40 04             	mov    0x4(%eax),%eax
 c34:	01 c2                	add    %eax,%edx
 c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c39:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 c3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c3f:	8b 10                	mov    (%eax),%edx
 c41:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c44:	89 10                	mov    %edx,(%eax)
 c46:	eb 08                	jmp    c50 <free+0xd7>
  } else
    p->s.ptr = bp;
 c48:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c4b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 c4e:	89 10                	mov    %edx,(%eax)
  freep = p;
 c50:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c53:	a3 c0 11 00 00       	mov    %eax,0x11c0
}
 c58:	c9                   	leave  
 c59:	c3                   	ret    

00000c5a <morecore>:

static Header*
morecore(uint nu)
{
 c5a:	55                   	push   %ebp
 c5b:	89 e5                	mov    %esp,%ebp
 c5d:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 c60:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 c67:	77 07                	ja     c70 <morecore+0x16>
    nu = 4096;
 c69:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 c70:	8b 45 08             	mov    0x8(%ebp),%eax
 c73:	c1 e0 03             	shl    $0x3,%eax
 c76:	89 04 24             	mov    %eax,(%esp)
 c79:	e8 40 fc ff ff       	call   8be <sbrk>
 c7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 c81:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 c85:	75 07                	jne    c8e <morecore+0x34>
    return 0;
 c87:	b8 00 00 00 00       	mov    $0x0,%eax
 c8c:	eb 22                	jmp    cb0 <morecore+0x56>
  hp = (Header*)p;
 c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c97:	8b 55 08             	mov    0x8(%ebp),%edx
 c9a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ca0:	83 c0 08             	add    $0x8,%eax
 ca3:	89 04 24             	mov    %eax,(%esp)
 ca6:	e8 ce fe ff ff       	call   b79 <free>
  return freep;
 cab:	a1 c0 11 00 00       	mov    0x11c0,%eax
}
 cb0:	c9                   	leave  
 cb1:	c3                   	ret    

00000cb2 <malloc>:

void*
malloc(uint nbytes)
{
 cb2:	55                   	push   %ebp
 cb3:	89 e5                	mov    %esp,%ebp
 cb5:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cb8:	8b 45 08             	mov    0x8(%ebp),%eax
 cbb:	83 c0 07             	add    $0x7,%eax
 cbe:	c1 e8 03             	shr    $0x3,%eax
 cc1:	83 c0 01             	add    $0x1,%eax
 cc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 cc7:	a1 c0 11 00 00       	mov    0x11c0,%eax
 ccc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ccf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 cd3:	75 23                	jne    cf8 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 cd5:	c7 45 f0 b8 11 00 00 	movl   $0x11b8,-0x10(%ebp)
 cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cdf:	a3 c0 11 00 00       	mov    %eax,0x11c0
 ce4:	a1 c0 11 00 00       	mov    0x11c0,%eax
 ce9:	a3 b8 11 00 00       	mov    %eax,0x11b8
    base.s.size = 0;
 cee:	c7 05 bc 11 00 00 00 	movl   $0x0,0x11bc
 cf5:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cfb:	8b 00                	mov    (%eax),%eax
 cfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d03:	8b 40 04             	mov    0x4(%eax),%eax
 d06:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d09:	72 4d                	jb     d58 <malloc+0xa6>
      if(p->s.size == nunits)
 d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d0e:	8b 40 04             	mov    0x4(%eax),%eax
 d11:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d14:	75 0c                	jne    d22 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d19:	8b 10                	mov    (%eax),%edx
 d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d1e:	89 10                	mov    %edx,(%eax)
 d20:	eb 26                	jmp    d48 <malloc+0x96>
      else {
        p->s.size -= nunits;
 d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d25:	8b 40 04             	mov    0x4(%eax),%eax
 d28:	2b 45 ec             	sub    -0x14(%ebp),%eax
 d2b:	89 c2                	mov    %eax,%edx
 d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d30:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d36:	8b 40 04             	mov    0x4(%eax),%eax
 d39:	c1 e0 03             	shl    $0x3,%eax
 d3c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d42:	8b 55 ec             	mov    -0x14(%ebp),%edx
 d45:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d4b:	a3 c0 11 00 00       	mov    %eax,0x11c0
      return (void*)(p + 1);
 d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d53:	83 c0 08             	add    $0x8,%eax
 d56:	eb 38                	jmp    d90 <malloc+0xde>
    }
    if(p == freep)
 d58:	a1 c0 11 00 00       	mov    0x11c0,%eax
 d5d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 d60:	75 1b                	jne    d7d <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 d62:	8b 45 ec             	mov    -0x14(%ebp),%eax
 d65:	89 04 24             	mov    %eax,(%esp)
 d68:	e8 ed fe ff ff       	call   c5a <morecore>
 d6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 d70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d74:	75 07                	jne    d7d <malloc+0xcb>
        return 0;
 d76:	b8 00 00 00 00       	mov    $0x0,%eax
 d7b:	eb 13                	jmp    d90 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d80:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d86:	8b 00                	mov    (%eax),%eax
 d88:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 d8b:	e9 70 ff ff ff       	jmp    d00 <malloc+0x4e>
}
 d90:	c9                   	leave  
 d91:	c3                   	ret    
