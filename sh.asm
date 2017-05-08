
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 05                	jne    11 <runcmd+0x11>
    exit();
       c:	e8 c3 11 00 00       	call   11d4 <exit>
  
  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 5c 17 00 00 	mov    0x175c(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	c7 04 24 30 17 00 00 	movl   $0x1730,(%esp)
      2b:	e8 27 03 00 00       	call   357 <panic>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      30:	8b 45 08             	mov    0x8(%ebp),%eax
      33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ecmd->argv[0] == 0)
      36:	8b 45 f4             	mov    -0xc(%ebp),%eax
      39:	8b 40 04             	mov    0x4(%eax),%eax
      3c:	85 c0                	test   %eax,%eax
      3e:	75 05                	jne    45 <runcmd+0x45>
      exit();
      40:	e8 8f 11 00 00       	call   11d4 <exit>
    exec(ecmd->argv[0], ecmd->argv);
      45:	8b 45 f4             	mov    -0xc(%ebp),%eax
      48:	8d 50 04             	lea    0x4(%eax),%edx
      4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4e:	8b 40 04             	mov    0x4(%eax),%eax
      51:	89 54 24 04          	mov    %edx,0x4(%esp)
      55:	89 04 24             	mov    %eax,(%esp)
      58:	e8 af 11 00 00       	call   120c <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
      60:	8b 40 04             	mov    0x4(%eax),%eax
      63:	89 44 24 08          	mov    %eax,0x8(%esp)
      67:	c7 44 24 04 37 17 00 	movl   $0x1737,0x4(%esp)
      6e:	00 
      6f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      76:	e8 e9 12 00 00       	call   1364 <printf>
    break;
      7b:	e9 86 01 00 00       	jmp    206 <runcmd+0x206>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      80:	8b 45 08             	mov    0x8(%ebp),%eax
      83:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(rcmd->fd);
      86:	8b 45 f0             	mov    -0x10(%ebp),%eax
      89:	8b 40 14             	mov    0x14(%eax),%eax
      8c:	89 04 24             	mov    %eax,(%esp)
      8f:	e8 68 11 00 00       	call   11fc <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      94:	8b 45 f0             	mov    -0x10(%ebp),%eax
      97:	8b 50 10             	mov    0x10(%eax),%edx
      9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
      9d:	8b 40 08             	mov    0x8(%eax),%eax
      a0:	89 54 24 04          	mov    %edx,0x4(%esp)
      a4:	89 04 24             	mov    %eax,(%esp)
      a7:	e8 68 11 00 00       	call   1214 <open>
      ac:	85 c0                	test   %eax,%eax
      ae:	79 23                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b3:	8b 40 08             	mov    0x8(%eax),%eax
      b6:	89 44 24 08          	mov    %eax,0x8(%esp)
      ba:	c7 44 24 04 47 17 00 	movl   $0x1747,0x4(%esp)
      c1:	00 
      c2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      c9:	e8 96 12 00 00       	call   1364 <printf>
      exit();
      ce:	e8 01 11 00 00       	call   11d4 <exit>
    }
    runcmd(rcmd->cmd);
      d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
      d6:	8b 40 04             	mov    0x4(%eax),%eax
      d9:	89 04 24             	mov    %eax,(%esp)
      dc:	e8 1f ff ff ff       	call   0 <runcmd>
    break;
      e1:	e9 20 01 00 00       	jmp    206 <runcmd+0x206>

  case LIST:
    lcmd = (struct listcmd*)cmd;
      e6:	8b 45 08             	mov    0x8(%ebp),%eax
      e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
      ec:	e8 8c 02 00 00       	call   37d <fork1>
      f1:	85 c0                	test   %eax,%eax
      f3:	75 0e                	jne    103 <runcmd+0x103>
      runcmd(lcmd->left);
      f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
      f8:	8b 40 04             	mov    0x4(%eax),%eax
      fb:	89 04 24             	mov    %eax,(%esp)
      fe:	e8 fd fe ff ff       	call   0 <runcmd>
    wait();
     103:	e8 d4 10 00 00       	call   11dc <wait>
    runcmd(lcmd->right);
     108:	8b 45 ec             	mov    -0x14(%ebp),%eax
     10b:	8b 40 08             	mov    0x8(%eax),%eax
     10e:	89 04 24             	mov    %eax,(%esp)
     111:	e8 ea fe ff ff       	call   0 <runcmd>
    break;
     116:	e9 eb 00 00 00       	jmp    206 <runcmd+0x206>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     11b:	8b 45 08             	mov    0x8(%ebp),%eax
     11e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pipe(p) < 0)
     121:	8d 45 dc             	lea    -0x24(%ebp),%eax
     124:	89 04 24             	mov    %eax,(%esp)
     127:	e8 b8 10 00 00       	call   11e4 <pipe>
     12c:	85 c0                	test   %eax,%eax
     12e:	79 0c                	jns    13c <runcmd+0x13c>
      panic("pipe");
     130:	c7 04 24 57 17 00 00 	movl   $0x1757,(%esp)
     137:	e8 1b 02 00 00       	call   357 <panic>
    if(fork1() == 0){
     13c:	e8 3c 02 00 00       	call   37d <fork1>
     141:	85 c0                	test   %eax,%eax
     143:	75 3b                	jne    180 <runcmd+0x180>
      close(1);
     145:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     14c:	e8 ab 10 00 00       	call   11fc <close>
      dup(p[1]);
     151:	8b 45 e0             	mov    -0x20(%ebp),%eax
     154:	89 04 24             	mov    %eax,(%esp)
     157:	e8 f0 10 00 00       	call   124c <dup>
      close(p[0]);
     15c:	8b 45 dc             	mov    -0x24(%ebp),%eax
     15f:	89 04 24             	mov    %eax,(%esp)
     162:	e8 95 10 00 00       	call   11fc <close>
      close(p[1]);
     167:	8b 45 e0             	mov    -0x20(%ebp),%eax
     16a:	89 04 24             	mov    %eax,(%esp)
     16d:	e8 8a 10 00 00       	call   11fc <close>
      runcmd(pcmd->left);
     172:	8b 45 e8             	mov    -0x18(%ebp),%eax
     175:	8b 40 04             	mov    0x4(%eax),%eax
     178:	89 04 24             	mov    %eax,(%esp)
     17b:	e8 80 fe ff ff       	call   0 <runcmd>
    }
    if(fork1() == 0){
     180:	e8 f8 01 00 00       	call   37d <fork1>
     185:	85 c0                	test   %eax,%eax
     187:	75 3b                	jne    1c4 <runcmd+0x1c4>
      close(0);
     189:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     190:	e8 67 10 00 00       	call   11fc <close>
      dup(p[0]);
     195:	8b 45 dc             	mov    -0x24(%ebp),%eax
     198:	89 04 24             	mov    %eax,(%esp)
     19b:	e8 ac 10 00 00       	call   124c <dup>
      close(p[0]);
     1a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1a3:	89 04 24             	mov    %eax,(%esp)
     1a6:	e8 51 10 00 00       	call   11fc <close>
      close(p[1]);
     1ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1ae:	89 04 24             	mov    %eax,(%esp)
     1b1:	e8 46 10 00 00       	call   11fc <close>
      runcmd(pcmd->right);
     1b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1b9:	8b 40 08             	mov    0x8(%eax),%eax
     1bc:	89 04 24             	mov    %eax,(%esp)
     1bf:	e8 3c fe ff ff       	call   0 <runcmd>
    }
    close(p[0]);
     1c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1c7:	89 04 24             	mov    %eax,(%esp)
     1ca:	e8 2d 10 00 00       	call   11fc <close>
    close(p[1]);
     1cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1d2:	89 04 24             	mov    %eax,(%esp)
     1d5:	e8 22 10 00 00       	call   11fc <close>
    wait();
     1da:	e8 fd 0f 00 00       	call   11dc <wait>
    wait();
     1df:	e8 f8 0f 00 00       	call   11dc <wait>
    break;
     1e4:	eb 20                	jmp    206 <runcmd+0x206>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
     1e6:	8b 45 08             	mov    0x8(%ebp),%eax
     1e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     1ec:	e8 8c 01 00 00       	call   37d <fork1>
     1f1:	85 c0                	test   %eax,%eax
     1f3:	75 10                	jne    205 <runcmd+0x205>
      runcmd(bcmd->cmd);
     1f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1f8:	8b 40 04             	mov    0x4(%eax),%eax
     1fb:	89 04 24             	mov    %eax,(%esp)
     1fe:	e8 fd fd ff ff       	call   0 <runcmd>
    break;
     203:	eb 00                	jmp    205 <runcmd+0x205>
     205:	90                   	nop
  }
  exit();
     206:	e8 c9 0f 00 00       	call   11d4 <exit>

0000020b <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     20b:	55                   	push   %ebp
     20c:	89 e5                	mov    %esp,%ebp
     20e:	83 ec 18             	sub    $0x18,%esp
  printf(2, "$ ");
     211:	c7 44 24 04 74 17 00 	movl   $0x1774,0x4(%esp)
     218:	00 
     219:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     220:	e8 3f 11 00 00       	call   1364 <printf>
  memset(buf, 0, nbuf);
     225:	8b 45 0c             	mov    0xc(%ebp),%eax
     228:	89 44 24 08          	mov    %eax,0x8(%esp)
     22c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     233:	00 
     234:	8b 45 08             	mov    0x8(%ebp),%eax
     237:	89 04 24             	mov    %eax,(%esp)
     23a:	e8 ac 0b 00 00       	call   deb <memset>
  gets(buf, nbuf);
     23f:	8b 45 0c             	mov    0xc(%ebp),%eax
     242:	89 44 24 04          	mov    %eax,0x4(%esp)
     246:	8b 45 08             	mov    0x8(%ebp),%eax
     249:	89 04 24             	mov    %eax,(%esp)
     24c:	e8 f1 0b 00 00       	call   e42 <gets>
  if(buf[0] == 0) // EOF
     251:	8b 45 08             	mov    0x8(%ebp),%eax
     254:	0f b6 00             	movzbl (%eax),%eax
     257:	84 c0                	test   %al,%al
     259:	75 07                	jne    262 <getcmd+0x57>
    return -1;
     25b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     260:	eb 05                	jmp    267 <getcmd+0x5c>
  return 0;
     262:	b8 00 00 00 00       	mov    $0x0,%eax
}
     267:	c9                   	leave  
     268:	c3                   	ret    

00000269 <main>:

int
main(void)
{
     269:	55                   	push   %ebp
     26a:	89 e5                	mov    %esp,%ebp
     26c:	83 e4 f0             	and    $0xfffffff0,%esp
     26f:	83 ec 20             	sub    $0x20,%esp
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     272:	eb 15                	jmp    289 <main+0x20>
    if(fd >= 3){
     274:	83 7c 24 1c 02       	cmpl   $0x2,0x1c(%esp)
     279:	7e 0e                	jle    289 <main+0x20>
      close(fd);
     27b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     27f:	89 04 24             	mov    %eax,(%esp)
     282:	e8 75 0f 00 00       	call   11fc <close>
      break;
     287:	eb 1f                	jmp    2a8 <main+0x3f>
{
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     289:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     290:	00 
     291:	c7 04 24 77 17 00 00 	movl   $0x1777,(%esp)
     298:	e8 77 0f 00 00       	call   1214 <open>
     29d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
     2a1:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
     2a6:	79 cc                	jns    274 <main+0xb>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     2a8:	e9 89 00 00 00       	jmp    336 <main+0xcd>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     2ad:	0f b6 05 e0 1d 00 00 	movzbl 0x1de0,%eax
     2b4:	3c 63                	cmp    $0x63,%al
     2b6:	75 5c                	jne    314 <main+0xab>
     2b8:	0f b6 05 e1 1d 00 00 	movzbl 0x1de1,%eax
     2bf:	3c 64                	cmp    $0x64,%al
     2c1:	75 51                	jne    314 <main+0xab>
     2c3:	0f b6 05 e2 1d 00 00 	movzbl 0x1de2,%eax
     2ca:	3c 20                	cmp    $0x20,%al
     2cc:	75 46                	jne    314 <main+0xab>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     2ce:	c7 04 24 e0 1d 00 00 	movl   $0x1de0,(%esp)
     2d5:	e8 bd 0a 00 00       	call   d97 <strlen>
     2da:	83 e8 01             	sub    $0x1,%eax
     2dd:	c6 80 e0 1d 00 00 00 	movb   $0x0,0x1de0(%eax)
      if(chdir(buf+3) < 0)
     2e4:	c7 04 24 e3 1d 00 00 	movl   $0x1de3,(%esp)
     2eb:	e8 54 0f 00 00       	call   1244 <chdir>
     2f0:	85 c0                	test   %eax,%eax
     2f2:	79 1e                	jns    312 <main+0xa9>
        printf(2, "cannot cd %s\n", buf+3);
     2f4:	c7 44 24 08 e3 1d 00 	movl   $0x1de3,0x8(%esp)
     2fb:	00 
     2fc:	c7 44 24 04 7f 17 00 	movl   $0x177f,0x4(%esp)
     303:	00 
     304:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     30b:	e8 54 10 00 00       	call   1364 <printf>
      continue;
     310:	eb 24                	jmp    336 <main+0xcd>
     312:	eb 22                	jmp    336 <main+0xcd>
    }
    if(fork1() == 0)
     314:	e8 64 00 00 00       	call   37d <fork1>
     319:	85 c0                	test   %eax,%eax
     31b:	75 14                	jne    331 <main+0xc8>
      runcmd(parsecmd(buf));
     31d:	c7 04 24 e0 1d 00 00 	movl   $0x1de0,(%esp)
     324:	e8 c9 03 00 00       	call   6f2 <parsecmd>
     329:	89 04 24             	mov    %eax,(%esp)
     32c:	e8 cf fc ff ff       	call   0 <runcmd>
    wait();
     331:	e8 a6 0e 00 00       	call   11dc <wait>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     336:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     33d:	00 
     33e:	c7 04 24 e0 1d 00 00 	movl   $0x1de0,(%esp)
     345:	e8 c1 fe ff ff       	call   20b <getcmd>
     34a:	85 c0                	test   %eax,%eax
     34c:	0f 89 5b ff ff ff    	jns    2ad <main+0x44>
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     352:	e8 7d 0e 00 00       	call   11d4 <exit>

00000357 <panic>:
}

void
panic(char *s)
{
     357:	55                   	push   %ebp
     358:	89 e5                	mov    %esp,%ebp
     35a:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
     35d:	8b 45 08             	mov    0x8(%ebp),%eax
     360:	89 44 24 08          	mov    %eax,0x8(%esp)
     364:	c7 44 24 04 8d 17 00 	movl   $0x178d,0x4(%esp)
     36b:	00 
     36c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     373:	e8 ec 0f 00 00       	call   1364 <printf>
  exit();
     378:	e8 57 0e 00 00       	call   11d4 <exit>

0000037d <fork1>:
}

int
fork1(void)
{
     37d:	55                   	push   %ebp
     37e:	89 e5                	mov    %esp,%ebp
     380:	83 ec 28             	sub    $0x28,%esp
  int pid;
  
  pid = fork();
     383:	e8 44 0e 00 00       	call   11cc <fork>
     388:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     38b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     38f:	75 0c                	jne    39d <fork1+0x20>
    panic("fork");
     391:	c7 04 24 91 17 00 00 	movl   $0x1791,(%esp)
     398:	e8 ba ff ff ff       	call   357 <panic>
  return pid;
     39d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3a0:	c9                   	leave  
     3a1:	c3                   	ret    

000003a2 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     3a2:	55                   	push   %ebp
     3a3:	89 e5                	mov    %esp,%ebp
     3a5:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3a8:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
     3af:	e8 9c 12 00 00       	call   1650 <malloc>
     3b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3b7:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
     3be:	00 
     3bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3c6:	00 
     3c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3ca:	89 04 24             	mov    %eax,(%esp)
     3cd:	e8 19 0a 00 00       	call   deb <memset>
  cmd->type = EXEC;
     3d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3d5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     3db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3de:	c9                   	leave  
     3df:	c3                   	ret    

000003e0 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     3e0:	55                   	push   %ebp
     3e1:	89 e5                	mov    %esp,%ebp
     3e3:	83 ec 28             	sub    $0x28,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3e6:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     3ed:	e8 5e 12 00 00       	call   1650 <malloc>
     3f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3f5:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     3fc:	00 
     3fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     404:	00 
     405:	8b 45 f4             	mov    -0xc(%ebp),%eax
     408:	89 04 24             	mov    %eax,(%esp)
     40b:	e8 db 09 00 00       	call   deb <memset>
  cmd->type = REDIR;
     410:	8b 45 f4             	mov    -0xc(%ebp),%eax
     413:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     419:	8b 45 f4             	mov    -0xc(%ebp),%eax
     41c:	8b 55 08             	mov    0x8(%ebp),%edx
     41f:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     422:	8b 45 f4             	mov    -0xc(%ebp),%eax
     425:	8b 55 0c             	mov    0xc(%ebp),%edx
     428:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     42b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     42e:	8b 55 10             	mov    0x10(%ebp),%edx
     431:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     434:	8b 45 f4             	mov    -0xc(%ebp),%eax
     437:	8b 55 14             	mov    0x14(%ebp),%edx
     43a:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     43d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     440:	8b 55 18             	mov    0x18(%ebp),%edx
     443:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     446:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     449:	c9                   	leave  
     44a:	c3                   	ret    

0000044b <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     44b:	55                   	push   %ebp
     44c:	89 e5                	mov    %esp,%ebp
     44e:	83 ec 28             	sub    $0x28,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     451:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     458:	e8 f3 11 00 00       	call   1650 <malloc>
     45d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     460:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     467:	00 
     468:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     46f:	00 
     470:	8b 45 f4             	mov    -0xc(%ebp),%eax
     473:	89 04 24             	mov    %eax,(%esp)
     476:	e8 70 09 00 00       	call   deb <memset>
  cmd->type = PIPE;
     47b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     47e:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     484:	8b 45 f4             	mov    -0xc(%ebp),%eax
     487:	8b 55 08             	mov    0x8(%ebp),%edx
     48a:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     48d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     490:	8b 55 0c             	mov    0xc(%ebp),%edx
     493:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     496:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     499:	c9                   	leave  
     49a:	c3                   	ret    

0000049b <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     49b:	55                   	push   %ebp
     49c:	89 e5                	mov    %esp,%ebp
     49e:	83 ec 28             	sub    $0x28,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4a1:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     4a8:	e8 a3 11 00 00       	call   1650 <malloc>
     4ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4b0:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     4b7:	00 
     4b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     4bf:	00 
     4c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c3:	89 04 24             	mov    %eax,(%esp)
     4c6:	e8 20 09 00 00       	call   deb <memset>
  cmd->type = LIST;
     4cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4ce:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     4d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4d7:	8b 55 08             	mov    0x8(%ebp),%edx
     4da:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     4dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4e0:	8b 55 0c             	mov    0xc(%ebp),%edx
     4e3:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     4e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4e9:	c9                   	leave  
     4ea:	c3                   	ret    

000004eb <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     4eb:	55                   	push   %ebp
     4ec:	89 e5                	mov    %esp,%ebp
     4ee:	83 ec 28             	sub    $0x28,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4f1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     4f8:	e8 53 11 00 00       	call   1650 <malloc>
     4fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     500:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     507:	00 
     508:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     50f:	00 
     510:	8b 45 f4             	mov    -0xc(%ebp),%eax
     513:	89 04 24             	mov    %eax,(%esp)
     516:	e8 d0 08 00 00       	call   deb <memset>
  cmd->type = BACK;
     51b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     51e:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     524:	8b 45 f4             	mov    -0xc(%ebp),%eax
     527:	8b 55 08             	mov    0x8(%ebp),%edx
     52a:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     52d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     530:	c9                   	leave  
     531:	c3                   	ret    

00000532 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     532:	55                   	push   %ebp
     533:	89 e5                	mov    %esp,%ebp
     535:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int ret;
  
  s = *ps;
     538:	8b 45 08             	mov    0x8(%ebp),%eax
     53b:	8b 00                	mov    (%eax),%eax
     53d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     540:	eb 04                	jmp    546 <gettoken+0x14>
    s++;
     542:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     546:	8b 45 f4             	mov    -0xc(%ebp),%eax
     549:	3b 45 0c             	cmp    0xc(%ebp),%eax
     54c:	73 1d                	jae    56b <gettoken+0x39>
     54e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     551:	0f b6 00             	movzbl (%eax),%eax
     554:	0f be c0             	movsbl %al,%eax
     557:	89 44 24 04          	mov    %eax,0x4(%esp)
     55b:	c7 04 24 c0 1d 00 00 	movl   $0x1dc0,(%esp)
     562:	e8 a8 08 00 00       	call   e0f <strchr>
     567:	85 c0                	test   %eax,%eax
     569:	75 d7                	jne    542 <gettoken+0x10>
    s++;
  if(q)
     56b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     56f:	74 08                	je     579 <gettoken+0x47>
    *q = s;
     571:	8b 45 10             	mov    0x10(%ebp),%eax
     574:	8b 55 f4             	mov    -0xc(%ebp),%edx
     577:	89 10                	mov    %edx,(%eax)
  ret = *s;
     579:	8b 45 f4             	mov    -0xc(%ebp),%eax
     57c:	0f b6 00             	movzbl (%eax),%eax
     57f:	0f be c0             	movsbl %al,%eax
     582:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     585:	8b 45 f4             	mov    -0xc(%ebp),%eax
     588:	0f b6 00             	movzbl (%eax),%eax
     58b:	0f be c0             	movsbl %al,%eax
     58e:	83 f8 29             	cmp    $0x29,%eax
     591:	7f 14                	jg     5a7 <gettoken+0x75>
     593:	83 f8 28             	cmp    $0x28,%eax
     596:	7d 28                	jge    5c0 <gettoken+0x8e>
     598:	85 c0                	test   %eax,%eax
     59a:	0f 84 94 00 00 00    	je     634 <gettoken+0x102>
     5a0:	83 f8 26             	cmp    $0x26,%eax
     5a3:	74 1b                	je     5c0 <gettoken+0x8e>
     5a5:	eb 3c                	jmp    5e3 <gettoken+0xb1>
     5a7:	83 f8 3e             	cmp    $0x3e,%eax
     5aa:	74 1a                	je     5c6 <gettoken+0x94>
     5ac:	83 f8 3e             	cmp    $0x3e,%eax
     5af:	7f 0a                	jg     5bb <gettoken+0x89>
     5b1:	83 e8 3b             	sub    $0x3b,%eax
     5b4:	83 f8 01             	cmp    $0x1,%eax
     5b7:	77 2a                	ja     5e3 <gettoken+0xb1>
     5b9:	eb 05                	jmp    5c0 <gettoken+0x8e>
     5bb:	83 f8 7c             	cmp    $0x7c,%eax
     5be:	75 23                	jne    5e3 <gettoken+0xb1>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     5c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
     5c4:	eb 6f                	jmp    635 <gettoken+0x103>
  case '>':
    s++;
     5c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(*s == '>'){
     5ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5cd:	0f b6 00             	movzbl (%eax),%eax
     5d0:	3c 3e                	cmp    $0x3e,%al
     5d2:	75 0d                	jne    5e1 <gettoken+0xaf>
      ret = '+';
     5d4:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     5db:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
     5df:	eb 54                	jmp    635 <gettoken+0x103>
     5e1:	eb 52                	jmp    635 <gettoken+0x103>
  default:
    ret = 'a';
     5e3:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5ea:	eb 04                	jmp    5f0 <gettoken+0xbe>
      s++;
     5ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
     5f6:	73 3a                	jae    632 <gettoken+0x100>
     5f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5fb:	0f b6 00             	movzbl (%eax),%eax
     5fe:	0f be c0             	movsbl %al,%eax
     601:	89 44 24 04          	mov    %eax,0x4(%esp)
     605:	c7 04 24 c0 1d 00 00 	movl   $0x1dc0,(%esp)
     60c:	e8 fe 07 00 00       	call   e0f <strchr>
     611:	85 c0                	test   %eax,%eax
     613:	75 1d                	jne    632 <gettoken+0x100>
     615:	8b 45 f4             	mov    -0xc(%ebp),%eax
     618:	0f b6 00             	movzbl (%eax),%eax
     61b:	0f be c0             	movsbl %al,%eax
     61e:	89 44 24 04          	mov    %eax,0x4(%esp)
     622:	c7 04 24 c6 1d 00 00 	movl   $0x1dc6,(%esp)
     629:	e8 e1 07 00 00       	call   e0f <strchr>
     62e:	85 c0                	test   %eax,%eax
     630:	74 ba                	je     5ec <gettoken+0xba>
      s++;
    break;
     632:	eb 01                	jmp    635 <gettoken+0x103>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     634:	90                   	nop
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     635:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     639:	74 0a                	je     645 <gettoken+0x113>
    *eq = s;
     63b:	8b 45 14             	mov    0x14(%ebp),%eax
     63e:	8b 55 f4             	mov    -0xc(%ebp),%edx
     641:	89 10                	mov    %edx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     643:	eb 06                	jmp    64b <gettoken+0x119>
     645:	eb 04                	jmp    64b <gettoken+0x119>
    s++;
     647:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     64b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     64e:	3b 45 0c             	cmp    0xc(%ebp),%eax
     651:	73 1d                	jae    670 <gettoken+0x13e>
     653:	8b 45 f4             	mov    -0xc(%ebp),%eax
     656:	0f b6 00             	movzbl (%eax),%eax
     659:	0f be c0             	movsbl %al,%eax
     65c:	89 44 24 04          	mov    %eax,0x4(%esp)
     660:	c7 04 24 c0 1d 00 00 	movl   $0x1dc0,(%esp)
     667:	e8 a3 07 00 00       	call   e0f <strchr>
     66c:	85 c0                	test   %eax,%eax
     66e:	75 d7                	jne    647 <gettoken+0x115>
    s++;
  *ps = s;
     670:	8b 45 08             	mov    0x8(%ebp),%eax
     673:	8b 55 f4             	mov    -0xc(%ebp),%edx
     676:	89 10                	mov    %edx,(%eax)
  return ret;
     678:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     67b:	c9                   	leave  
     67c:	c3                   	ret    

0000067d <peek>:

int
peek(char **ps, char *es, char *toks)
{
     67d:	55                   	push   %ebp
     67e:	89 e5                	mov    %esp,%ebp
     680:	83 ec 28             	sub    $0x28,%esp
  char *s;
  
  s = *ps;
     683:	8b 45 08             	mov    0x8(%ebp),%eax
     686:	8b 00                	mov    (%eax),%eax
     688:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     68b:	eb 04                	jmp    691 <peek+0x14>
    s++;
     68d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     691:	8b 45 f4             	mov    -0xc(%ebp),%eax
     694:	3b 45 0c             	cmp    0xc(%ebp),%eax
     697:	73 1d                	jae    6b6 <peek+0x39>
     699:	8b 45 f4             	mov    -0xc(%ebp),%eax
     69c:	0f b6 00             	movzbl (%eax),%eax
     69f:	0f be c0             	movsbl %al,%eax
     6a2:	89 44 24 04          	mov    %eax,0x4(%esp)
     6a6:	c7 04 24 c0 1d 00 00 	movl   $0x1dc0,(%esp)
     6ad:	e8 5d 07 00 00       	call   e0f <strchr>
     6b2:	85 c0                	test   %eax,%eax
     6b4:	75 d7                	jne    68d <peek+0x10>
    s++;
  *ps = s;
     6b6:	8b 45 08             	mov    0x8(%ebp),%eax
     6b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6bc:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     6be:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6c1:	0f b6 00             	movzbl (%eax),%eax
     6c4:	84 c0                	test   %al,%al
     6c6:	74 23                	je     6eb <peek+0x6e>
     6c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6cb:	0f b6 00             	movzbl (%eax),%eax
     6ce:	0f be c0             	movsbl %al,%eax
     6d1:	89 44 24 04          	mov    %eax,0x4(%esp)
     6d5:	8b 45 10             	mov    0x10(%ebp),%eax
     6d8:	89 04 24             	mov    %eax,(%esp)
     6db:	e8 2f 07 00 00       	call   e0f <strchr>
     6e0:	85 c0                	test   %eax,%eax
     6e2:	74 07                	je     6eb <peek+0x6e>
     6e4:	b8 01 00 00 00       	mov    $0x1,%eax
     6e9:	eb 05                	jmp    6f0 <peek+0x73>
     6eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
     6f0:	c9                   	leave  
     6f1:	c3                   	ret    

000006f2 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     6f2:	55                   	push   %ebp
     6f3:	89 e5                	mov    %esp,%ebp
     6f5:	53                   	push   %ebx
     6f6:	83 ec 24             	sub    $0x24,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     6f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
     6fc:	8b 45 08             	mov    0x8(%ebp),%eax
     6ff:	89 04 24             	mov    %eax,(%esp)
     702:	e8 90 06 00 00       	call   d97 <strlen>
     707:	01 d8                	add    %ebx,%eax
     709:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     70c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     70f:	89 44 24 04          	mov    %eax,0x4(%esp)
     713:	8d 45 08             	lea    0x8(%ebp),%eax
     716:	89 04 24             	mov    %eax,(%esp)
     719:	e8 60 00 00 00       	call   77e <parseline>
     71e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     721:	c7 44 24 08 96 17 00 	movl   $0x1796,0x8(%esp)
     728:	00 
     729:	8b 45 f4             	mov    -0xc(%ebp),%eax
     72c:	89 44 24 04          	mov    %eax,0x4(%esp)
     730:	8d 45 08             	lea    0x8(%ebp),%eax
     733:	89 04 24             	mov    %eax,(%esp)
     736:	e8 42 ff ff ff       	call   67d <peek>
  if(s != es){
     73b:	8b 45 08             	mov    0x8(%ebp),%eax
     73e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     741:	74 27                	je     76a <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     743:	8b 45 08             	mov    0x8(%ebp),%eax
     746:	89 44 24 08          	mov    %eax,0x8(%esp)
     74a:	c7 44 24 04 97 17 00 	movl   $0x1797,0x4(%esp)
     751:	00 
     752:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     759:	e8 06 0c 00 00       	call   1364 <printf>
    panic("syntax");
     75e:	c7 04 24 a6 17 00 00 	movl   $0x17a6,(%esp)
     765:	e8 ed fb ff ff       	call   357 <panic>
  }
  nulterminate(cmd);
     76a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     76d:	89 04 24             	mov    %eax,(%esp)
     770:	e8 a3 04 00 00       	call   c18 <nulterminate>
  return cmd;
     775:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     778:	83 c4 24             	add    $0x24,%esp
     77b:	5b                   	pop    %ebx
     77c:	5d                   	pop    %ebp
     77d:	c3                   	ret    

0000077e <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     77e:	55                   	push   %ebp
     77f:	89 e5                	mov    %esp,%ebp
     781:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     784:	8b 45 0c             	mov    0xc(%ebp),%eax
     787:	89 44 24 04          	mov    %eax,0x4(%esp)
     78b:	8b 45 08             	mov    0x8(%ebp),%eax
     78e:	89 04 24             	mov    %eax,(%esp)
     791:	e8 bc 00 00 00       	call   852 <parsepipe>
     796:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     799:	eb 30                	jmp    7cb <parseline+0x4d>
    gettoken(ps, es, 0, 0);
     79b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     7a2:	00 
     7a3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     7aa:	00 
     7ab:	8b 45 0c             	mov    0xc(%ebp),%eax
     7ae:	89 44 24 04          	mov    %eax,0x4(%esp)
     7b2:	8b 45 08             	mov    0x8(%ebp),%eax
     7b5:	89 04 24             	mov    %eax,(%esp)
     7b8:	e8 75 fd ff ff       	call   532 <gettoken>
    cmd = backcmd(cmd);
     7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7c0:	89 04 24             	mov    %eax,(%esp)
     7c3:	e8 23 fd ff ff       	call   4eb <backcmd>
     7c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     7cb:	c7 44 24 08 ad 17 00 	movl   $0x17ad,0x8(%esp)
     7d2:	00 
     7d3:	8b 45 0c             	mov    0xc(%ebp),%eax
     7d6:	89 44 24 04          	mov    %eax,0x4(%esp)
     7da:	8b 45 08             	mov    0x8(%ebp),%eax
     7dd:	89 04 24             	mov    %eax,(%esp)
     7e0:	e8 98 fe ff ff       	call   67d <peek>
     7e5:	85 c0                	test   %eax,%eax
     7e7:	75 b2                	jne    79b <parseline+0x1d>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     7e9:	c7 44 24 08 af 17 00 	movl   $0x17af,0x8(%esp)
     7f0:	00 
     7f1:	8b 45 0c             	mov    0xc(%ebp),%eax
     7f4:	89 44 24 04          	mov    %eax,0x4(%esp)
     7f8:	8b 45 08             	mov    0x8(%ebp),%eax
     7fb:	89 04 24             	mov    %eax,(%esp)
     7fe:	e8 7a fe ff ff       	call   67d <peek>
     803:	85 c0                	test   %eax,%eax
     805:	74 46                	je     84d <parseline+0xcf>
    gettoken(ps, es, 0, 0);
     807:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     80e:	00 
     80f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     816:	00 
     817:	8b 45 0c             	mov    0xc(%ebp),%eax
     81a:	89 44 24 04          	mov    %eax,0x4(%esp)
     81e:	8b 45 08             	mov    0x8(%ebp),%eax
     821:	89 04 24             	mov    %eax,(%esp)
     824:	e8 09 fd ff ff       	call   532 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     829:	8b 45 0c             	mov    0xc(%ebp),%eax
     82c:	89 44 24 04          	mov    %eax,0x4(%esp)
     830:	8b 45 08             	mov    0x8(%ebp),%eax
     833:	89 04 24             	mov    %eax,(%esp)
     836:	e8 43 ff ff ff       	call   77e <parseline>
     83b:	89 44 24 04          	mov    %eax,0x4(%esp)
     83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     842:	89 04 24             	mov    %eax,(%esp)
     845:	e8 51 fc ff ff       	call   49b <listcmd>
     84a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     84d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     850:	c9                   	leave  
     851:	c3                   	ret    

00000852 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     852:	55                   	push   %ebp
     853:	89 e5                	mov    %esp,%ebp
     855:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     858:	8b 45 0c             	mov    0xc(%ebp),%eax
     85b:	89 44 24 04          	mov    %eax,0x4(%esp)
     85f:	8b 45 08             	mov    0x8(%ebp),%eax
     862:	89 04 24             	mov    %eax,(%esp)
     865:	e8 68 02 00 00       	call   ad2 <parseexec>
     86a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     86d:	c7 44 24 08 b1 17 00 	movl   $0x17b1,0x8(%esp)
     874:	00 
     875:	8b 45 0c             	mov    0xc(%ebp),%eax
     878:	89 44 24 04          	mov    %eax,0x4(%esp)
     87c:	8b 45 08             	mov    0x8(%ebp),%eax
     87f:	89 04 24             	mov    %eax,(%esp)
     882:	e8 f6 fd ff ff       	call   67d <peek>
     887:	85 c0                	test   %eax,%eax
     889:	74 46                	je     8d1 <parsepipe+0x7f>
    gettoken(ps, es, 0, 0);
     88b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     892:	00 
     893:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     89a:	00 
     89b:	8b 45 0c             	mov    0xc(%ebp),%eax
     89e:	89 44 24 04          	mov    %eax,0x4(%esp)
     8a2:	8b 45 08             	mov    0x8(%ebp),%eax
     8a5:	89 04 24             	mov    %eax,(%esp)
     8a8:	e8 85 fc ff ff       	call   532 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     8ad:	8b 45 0c             	mov    0xc(%ebp),%eax
     8b0:	89 44 24 04          	mov    %eax,0x4(%esp)
     8b4:	8b 45 08             	mov    0x8(%ebp),%eax
     8b7:	89 04 24             	mov    %eax,(%esp)
     8ba:	e8 93 ff ff ff       	call   852 <parsepipe>
     8bf:	89 44 24 04          	mov    %eax,0x4(%esp)
     8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8c6:	89 04 24             	mov    %eax,(%esp)
     8c9:	e8 7d fb ff ff       	call   44b <pipecmd>
     8ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     8d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     8d4:	c9                   	leave  
     8d5:	c3                   	ret    

000008d6 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     8d6:	55                   	push   %ebp
     8d7:	89 e5                	mov    %esp,%ebp
     8d9:	83 ec 38             	sub    $0x38,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     8dc:	e9 f6 00 00 00       	jmp    9d7 <parseredirs+0x101>
    tok = gettoken(ps, es, 0, 0);
     8e1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     8e8:	00 
     8e9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     8f0:	00 
     8f1:	8b 45 10             	mov    0x10(%ebp),%eax
     8f4:	89 44 24 04          	mov    %eax,0x4(%esp)
     8f8:	8b 45 0c             	mov    0xc(%ebp),%eax
     8fb:	89 04 24             	mov    %eax,(%esp)
     8fe:	e8 2f fc ff ff       	call   532 <gettoken>
     903:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     906:	8d 45 ec             	lea    -0x14(%ebp),%eax
     909:	89 44 24 0c          	mov    %eax,0xc(%esp)
     90d:	8d 45 f0             	lea    -0x10(%ebp),%eax
     910:	89 44 24 08          	mov    %eax,0x8(%esp)
     914:	8b 45 10             	mov    0x10(%ebp),%eax
     917:	89 44 24 04          	mov    %eax,0x4(%esp)
     91b:	8b 45 0c             	mov    0xc(%ebp),%eax
     91e:	89 04 24             	mov    %eax,(%esp)
     921:	e8 0c fc ff ff       	call   532 <gettoken>
     926:	83 f8 61             	cmp    $0x61,%eax
     929:	74 0c                	je     937 <parseredirs+0x61>
      panic("missing file for redirection");
     92b:	c7 04 24 b3 17 00 00 	movl   $0x17b3,(%esp)
     932:	e8 20 fa ff ff       	call   357 <panic>
    switch(tok){
     937:	8b 45 f4             	mov    -0xc(%ebp),%eax
     93a:	83 f8 3c             	cmp    $0x3c,%eax
     93d:	74 0f                	je     94e <parseredirs+0x78>
     93f:	83 f8 3e             	cmp    $0x3e,%eax
     942:	74 38                	je     97c <parseredirs+0xa6>
     944:	83 f8 2b             	cmp    $0x2b,%eax
     947:	74 61                	je     9aa <parseredirs+0xd4>
     949:	e9 89 00 00 00       	jmp    9d7 <parseredirs+0x101>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     94e:	8b 55 ec             	mov    -0x14(%ebp),%edx
     951:	8b 45 f0             	mov    -0x10(%ebp),%eax
     954:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     95b:	00 
     95c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     963:	00 
     964:	89 54 24 08          	mov    %edx,0x8(%esp)
     968:	89 44 24 04          	mov    %eax,0x4(%esp)
     96c:	8b 45 08             	mov    0x8(%ebp),%eax
     96f:	89 04 24             	mov    %eax,(%esp)
     972:	e8 69 fa ff ff       	call   3e0 <redircmd>
     977:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     97a:	eb 5b                	jmp    9d7 <parseredirs+0x101>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     97c:	8b 55 ec             	mov    -0x14(%ebp),%edx
     97f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     982:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     989:	00 
     98a:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     991:	00 
     992:	89 54 24 08          	mov    %edx,0x8(%esp)
     996:	89 44 24 04          	mov    %eax,0x4(%esp)
     99a:	8b 45 08             	mov    0x8(%ebp),%eax
     99d:	89 04 24             	mov    %eax,(%esp)
     9a0:	e8 3b fa ff ff       	call   3e0 <redircmd>
     9a5:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     9a8:	eb 2d                	jmp    9d7 <parseredirs+0x101>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     9aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
     9ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9b0:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     9b7:	00 
     9b8:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     9bf:	00 
     9c0:	89 54 24 08          	mov    %edx,0x8(%esp)
     9c4:	89 44 24 04          	mov    %eax,0x4(%esp)
     9c8:	8b 45 08             	mov    0x8(%ebp),%eax
     9cb:	89 04 24             	mov    %eax,(%esp)
     9ce:	e8 0d fa ff ff       	call   3e0 <redircmd>
     9d3:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     9d6:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     9d7:	c7 44 24 08 d0 17 00 	movl   $0x17d0,0x8(%esp)
     9de:	00 
     9df:	8b 45 10             	mov    0x10(%ebp),%eax
     9e2:	89 44 24 04          	mov    %eax,0x4(%esp)
     9e6:	8b 45 0c             	mov    0xc(%ebp),%eax
     9e9:	89 04 24             	mov    %eax,(%esp)
     9ec:	e8 8c fc ff ff       	call   67d <peek>
     9f1:	85 c0                	test   %eax,%eax
     9f3:	0f 85 e8 fe ff ff    	jne    8e1 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     9f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
     9fc:	c9                   	leave  
     9fd:	c3                   	ret    

000009fe <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     9fe:	55                   	push   %ebp
     9ff:	89 e5                	mov    %esp,%ebp
     a01:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     a04:	c7 44 24 08 d3 17 00 	movl   $0x17d3,0x8(%esp)
     a0b:	00 
     a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
     a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
     a13:	8b 45 08             	mov    0x8(%ebp),%eax
     a16:	89 04 24             	mov    %eax,(%esp)
     a19:	e8 5f fc ff ff       	call   67d <peek>
     a1e:	85 c0                	test   %eax,%eax
     a20:	75 0c                	jne    a2e <parseblock+0x30>
    panic("parseblock");
     a22:	c7 04 24 d5 17 00 00 	movl   $0x17d5,(%esp)
     a29:	e8 29 f9 ff ff       	call   357 <panic>
  gettoken(ps, es, 0, 0);
     a2e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a35:	00 
     a36:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a3d:	00 
     a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
     a41:	89 44 24 04          	mov    %eax,0x4(%esp)
     a45:	8b 45 08             	mov    0x8(%ebp),%eax
     a48:	89 04 24             	mov    %eax,(%esp)
     a4b:	e8 e2 fa ff ff       	call   532 <gettoken>
  cmd = parseline(ps, es);
     a50:	8b 45 0c             	mov    0xc(%ebp),%eax
     a53:	89 44 24 04          	mov    %eax,0x4(%esp)
     a57:	8b 45 08             	mov    0x8(%ebp),%eax
     a5a:	89 04 24             	mov    %eax,(%esp)
     a5d:	e8 1c fd ff ff       	call   77e <parseline>
     a62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     a65:	c7 44 24 08 e0 17 00 	movl   $0x17e0,0x8(%esp)
     a6c:	00 
     a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
     a70:	89 44 24 04          	mov    %eax,0x4(%esp)
     a74:	8b 45 08             	mov    0x8(%ebp),%eax
     a77:	89 04 24             	mov    %eax,(%esp)
     a7a:	e8 fe fb ff ff       	call   67d <peek>
     a7f:	85 c0                	test   %eax,%eax
     a81:	75 0c                	jne    a8f <parseblock+0x91>
    panic("syntax - missing )");
     a83:	c7 04 24 e2 17 00 00 	movl   $0x17e2,(%esp)
     a8a:	e8 c8 f8 ff ff       	call   357 <panic>
  gettoken(ps, es, 0, 0);
     a8f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a96:	00 
     a97:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a9e:	00 
     a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
     aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
     aa6:	8b 45 08             	mov    0x8(%ebp),%eax
     aa9:	89 04 24             	mov    %eax,(%esp)
     aac:	e8 81 fa ff ff       	call   532 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
     ab4:	89 44 24 08          	mov    %eax,0x8(%esp)
     ab8:	8b 45 08             	mov    0x8(%ebp),%eax
     abb:	89 44 24 04          	mov    %eax,0x4(%esp)
     abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ac2:	89 04 24             	mov    %eax,(%esp)
     ac5:	e8 0c fe ff ff       	call   8d6 <parseredirs>
     aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     ad0:	c9                   	leave  
     ad1:	c3                   	ret    

00000ad2 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     ad2:	55                   	push   %ebp
     ad3:	89 e5                	mov    %esp,%ebp
     ad5:	83 ec 38             	sub    $0x38,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     ad8:	c7 44 24 08 d3 17 00 	movl   $0x17d3,0x8(%esp)
     adf:	00 
     ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
     ae3:	89 44 24 04          	mov    %eax,0x4(%esp)
     ae7:	8b 45 08             	mov    0x8(%ebp),%eax
     aea:	89 04 24             	mov    %eax,(%esp)
     aed:	e8 8b fb ff ff       	call   67d <peek>
     af2:	85 c0                	test   %eax,%eax
     af4:	74 17                	je     b0d <parseexec+0x3b>
    return parseblock(ps, es);
     af6:	8b 45 0c             	mov    0xc(%ebp),%eax
     af9:	89 44 24 04          	mov    %eax,0x4(%esp)
     afd:	8b 45 08             	mov    0x8(%ebp),%eax
     b00:	89 04 24             	mov    %eax,(%esp)
     b03:	e8 f6 fe ff ff       	call   9fe <parseblock>
     b08:	e9 09 01 00 00       	jmp    c16 <parseexec+0x144>

  ret = execcmd();
     b0d:	e8 90 f8 ff ff       	call   3a2 <execcmd>
     b12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b18:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     b1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     b22:	8b 45 0c             	mov    0xc(%ebp),%eax
     b25:	89 44 24 08          	mov    %eax,0x8(%esp)
     b29:	8b 45 08             	mov    0x8(%ebp),%eax
     b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
     b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b33:	89 04 24             	mov    %eax,(%esp)
     b36:	e8 9b fd ff ff       	call   8d6 <parseredirs>
     b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     b3e:	e9 8f 00 00 00       	jmp    bd2 <parseexec+0x100>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     b43:	8d 45 e0             	lea    -0x20(%ebp),%eax
     b46:	89 44 24 0c          	mov    %eax,0xc(%esp)
     b4a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b4d:	89 44 24 08          	mov    %eax,0x8(%esp)
     b51:	8b 45 0c             	mov    0xc(%ebp),%eax
     b54:	89 44 24 04          	mov    %eax,0x4(%esp)
     b58:	8b 45 08             	mov    0x8(%ebp),%eax
     b5b:	89 04 24             	mov    %eax,(%esp)
     b5e:	e8 cf f9 ff ff       	call   532 <gettoken>
     b63:	89 45 e8             	mov    %eax,-0x18(%ebp)
     b66:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     b6a:	75 05                	jne    b71 <parseexec+0x9f>
      break;
     b6c:	e9 83 00 00 00       	jmp    bf4 <parseexec+0x122>
    if(tok != 'a')
     b71:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     b75:	74 0c                	je     b83 <parseexec+0xb1>
      panic("syntax");
     b77:	c7 04 24 a6 17 00 00 	movl   $0x17a6,(%esp)
     b7e:	e8 d4 f7 ff ff       	call   357 <panic>
    cmd->argv[argc] = q;
     b83:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     b86:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b89:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b8c:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     b90:	8b 55 e0             	mov    -0x20(%ebp),%edx
     b93:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b96:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     b99:	83 c1 08             	add    $0x8,%ecx
     b9c:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     ba0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(argc >= MAXARGS)
     ba4:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     ba8:	7e 0c                	jle    bb6 <parseexec+0xe4>
      panic("too many args");
     baa:	c7 04 24 f5 17 00 00 	movl   $0x17f5,(%esp)
     bb1:	e8 a1 f7 ff ff       	call   357 <panic>
    ret = parseredirs(ret, ps, es);
     bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
     bb9:	89 44 24 08          	mov    %eax,0x8(%esp)
     bbd:	8b 45 08             	mov    0x8(%ebp),%eax
     bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
     bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bc7:	89 04 24             	mov    %eax,(%esp)
     bca:	e8 07 fd ff ff       	call   8d6 <parseredirs>
     bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     bd2:	c7 44 24 08 03 18 00 	movl   $0x1803,0x8(%esp)
     bd9:	00 
     bda:	8b 45 0c             	mov    0xc(%ebp),%eax
     bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
     be1:	8b 45 08             	mov    0x8(%ebp),%eax
     be4:	89 04 24             	mov    %eax,(%esp)
     be7:	e8 91 fa ff ff       	call   67d <peek>
     bec:	85 c0                	test   %eax,%eax
     bee:	0f 84 4f ff ff ff    	je     b43 <parseexec+0x71>
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     bf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
     bf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bfa:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     c01:	00 
  cmd->eargv[argc] = 0;
     c02:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c05:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c08:	83 c2 08             	add    $0x8,%edx
     c0b:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     c12:	00 
  return ret;
     c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     c16:	c9                   	leave  
     c17:	c3                   	ret    

00000c18 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     c18:	55                   	push   %ebp
     c19:	89 e5                	mov    %esp,%ebp
     c1b:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     c1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     c22:	75 0a                	jne    c2e <nulterminate+0x16>
    return 0;
     c24:	b8 00 00 00 00       	mov    $0x0,%eax
     c29:	e9 c9 00 00 00       	jmp    cf7 <nulterminate+0xdf>
  
  switch(cmd->type){
     c2e:	8b 45 08             	mov    0x8(%ebp),%eax
     c31:	8b 00                	mov    (%eax),%eax
     c33:	83 f8 05             	cmp    $0x5,%eax
     c36:	0f 87 b8 00 00 00    	ja     cf4 <nulterminate+0xdc>
     c3c:	8b 04 85 08 18 00 00 	mov    0x1808(,%eax,4),%eax
     c43:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     c45:	8b 45 08             	mov    0x8(%ebp),%eax
     c48:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c52:	eb 14                	jmp    c68 <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
     c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c57:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c5a:	83 c2 08             	add    $0x8,%edx
     c5d:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     c61:	c6 00 00             	movb   $0x0,(%eax)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     c64:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c6e:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     c72:	85 c0                	test   %eax,%eax
     c74:	75 de                	jne    c54 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     c76:	eb 7c                	jmp    cf4 <nulterminate+0xdc>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     c78:	8b 45 08             	mov    0x8(%ebp),%eax
     c7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c81:	8b 40 04             	mov    0x4(%eax),%eax
     c84:	89 04 24             	mov    %eax,(%esp)
     c87:	e8 8c ff ff ff       	call   c18 <nulterminate>
    *rcmd->efile = 0;
     c8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c8f:	8b 40 0c             	mov    0xc(%eax),%eax
     c92:	c6 00 00             	movb   $0x0,(%eax)
    break;
     c95:	eb 5d                	jmp    cf4 <nulterminate+0xdc>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     c97:	8b 45 08             	mov    0x8(%ebp),%eax
     c9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     c9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ca0:	8b 40 04             	mov    0x4(%eax),%eax
     ca3:	89 04 24             	mov    %eax,(%esp)
     ca6:	e8 6d ff ff ff       	call   c18 <nulterminate>
    nulterminate(pcmd->right);
     cab:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cae:	8b 40 08             	mov    0x8(%eax),%eax
     cb1:	89 04 24             	mov    %eax,(%esp)
     cb4:	e8 5f ff ff ff       	call   c18 <nulterminate>
    break;
     cb9:	eb 39                	jmp    cf4 <nulterminate+0xdc>
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
     cbb:	8b 45 08             	mov    0x8(%ebp),%eax
     cbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
     cc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     cc4:	8b 40 04             	mov    0x4(%eax),%eax
     cc7:	89 04 24             	mov    %eax,(%esp)
     cca:	e8 49 ff ff ff       	call   c18 <nulterminate>
    nulterminate(lcmd->right);
     ccf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     cd2:	8b 40 08             	mov    0x8(%eax),%eax
     cd5:	89 04 24             	mov    %eax,(%esp)
     cd8:	e8 3b ff ff ff       	call   c18 <nulterminate>
    break;
     cdd:	eb 15                	jmp    cf4 <nulterminate+0xdc>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     cdf:	8b 45 08             	mov    0x8(%ebp),%eax
     ce2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
     ce5:	8b 45 e0             	mov    -0x20(%ebp),%eax
     ce8:	8b 40 04             	mov    0x4(%eax),%eax
     ceb:	89 04 24             	mov    %eax,(%esp)
     cee:	e8 25 ff ff ff       	call   c18 <nulterminate>
    break;
     cf3:	90                   	nop
  }
  return cmd;
     cf4:	8b 45 08             	mov    0x8(%ebp),%eax
}
     cf7:	c9                   	leave  
     cf8:	c3                   	ret    

00000cf9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     cf9:	55                   	push   %ebp
     cfa:	89 e5                	mov    %esp,%ebp
     cfc:	57                   	push   %edi
     cfd:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     cfe:	8b 4d 08             	mov    0x8(%ebp),%ecx
     d01:	8b 55 10             	mov    0x10(%ebp),%edx
     d04:	8b 45 0c             	mov    0xc(%ebp),%eax
     d07:	89 cb                	mov    %ecx,%ebx
     d09:	89 df                	mov    %ebx,%edi
     d0b:	89 d1                	mov    %edx,%ecx
     d0d:	fc                   	cld    
     d0e:	f3 aa                	rep stos %al,%es:(%edi)
     d10:	89 ca                	mov    %ecx,%edx
     d12:	89 fb                	mov    %edi,%ebx
     d14:	89 5d 08             	mov    %ebx,0x8(%ebp)
     d17:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     d1a:	5b                   	pop    %ebx
     d1b:	5f                   	pop    %edi
     d1c:	5d                   	pop    %ebp
     d1d:	c3                   	ret    

00000d1e <thing>:
#include "user.h"
#include "x86.h"


int
thing(void){
     d1e:	55                   	push   %ebp
     d1f:	89 e5                	mov    %esp,%ebp
  return 1;
     d21:	b8 01 00 00 00       	mov    $0x1,%eax
}
     d26:	5d                   	pop    %ebp
     d27:	c3                   	ret    

00000d28 <strcpy>:

char*
strcpy(char *s, char *t)
{
     d28:	55                   	push   %ebp
     d29:	89 e5                	mov    %esp,%ebp
     d2b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     d2e:	8b 45 08             	mov    0x8(%ebp),%eax
     d31:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     d34:	90                   	nop
     d35:	8b 45 08             	mov    0x8(%ebp),%eax
     d38:	8d 50 01             	lea    0x1(%eax),%edx
     d3b:	89 55 08             	mov    %edx,0x8(%ebp)
     d3e:	8b 55 0c             	mov    0xc(%ebp),%edx
     d41:	8d 4a 01             	lea    0x1(%edx),%ecx
     d44:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     d47:	0f b6 12             	movzbl (%edx),%edx
     d4a:	88 10                	mov    %dl,(%eax)
     d4c:	0f b6 00             	movzbl (%eax),%eax
     d4f:	84 c0                	test   %al,%al
     d51:	75 e2                	jne    d35 <strcpy+0xd>
    ;
  return os;
     d53:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d56:	c9                   	leave  
     d57:	c3                   	ret    

00000d58 <strcmp>:



int
strcmp(const char *p, const char *q)
{
     d58:	55                   	push   %ebp
     d59:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     d5b:	eb 08                	jmp    d65 <strcmp+0xd>
    p++, q++;
     d5d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     d61:	83 45 0c 01          	addl   $0x1,0xc(%ebp)


int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     d65:	8b 45 08             	mov    0x8(%ebp),%eax
     d68:	0f b6 00             	movzbl (%eax),%eax
     d6b:	84 c0                	test   %al,%al
     d6d:	74 10                	je     d7f <strcmp+0x27>
     d6f:	8b 45 08             	mov    0x8(%ebp),%eax
     d72:	0f b6 10             	movzbl (%eax),%edx
     d75:	8b 45 0c             	mov    0xc(%ebp),%eax
     d78:	0f b6 00             	movzbl (%eax),%eax
     d7b:	38 c2                	cmp    %al,%dl
     d7d:	74 de                	je     d5d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     d7f:	8b 45 08             	mov    0x8(%ebp),%eax
     d82:	0f b6 00             	movzbl (%eax),%eax
     d85:	0f b6 d0             	movzbl %al,%edx
     d88:	8b 45 0c             	mov    0xc(%ebp),%eax
     d8b:	0f b6 00             	movzbl (%eax),%eax
     d8e:	0f b6 c0             	movzbl %al,%eax
     d91:	29 c2                	sub    %eax,%edx
     d93:	89 d0                	mov    %edx,%eax
}
     d95:	5d                   	pop    %ebp
     d96:	c3                   	ret    

00000d97 <strlen>:

uint
strlen(char *s)
{
     d97:	55                   	push   %ebp
     d98:	89 e5                	mov    %esp,%ebp
     d9a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     d9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     da4:	eb 04                	jmp    daa <strlen+0x13>
     da6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     daa:	8b 55 fc             	mov    -0x4(%ebp),%edx
     dad:	8b 45 08             	mov    0x8(%ebp),%eax
     db0:	01 d0                	add    %edx,%eax
     db2:	0f b6 00             	movzbl (%eax),%eax
     db5:	84 c0                	test   %al,%al
     db7:	75 ed                	jne    da6 <strlen+0xf>
    ;
  return n;
     db9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     dbc:	c9                   	leave  
     dbd:	c3                   	ret    

00000dbe <stringlen>:

uint
stringlen(char **s){
     dbe:	55                   	push   %ebp
     dbf:	89 e5                	mov    %esp,%ebp
     dc1:	83 ec 10             	sub    $0x10,%esp
	int n;

  for(n = 0; s[n]; n++)
     dc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     dcb:	eb 04                	jmp    dd1 <stringlen+0x13>
     dcd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     dd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
     dd4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     ddb:	8b 45 08             	mov    0x8(%ebp),%eax
     dde:	01 d0                	add    %edx,%eax
     de0:	8b 00                	mov    (%eax),%eax
     de2:	85 c0                	test   %eax,%eax
     de4:	75 e7                	jne    dcd <stringlen+0xf>
    ;
  return n;
     de6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     de9:	c9                   	leave  
     dea:	c3                   	ret    

00000deb <memset>:

void*
memset(void *dst, int c, uint n)
{
     deb:	55                   	push   %ebp
     dec:	89 e5                	mov    %esp,%ebp
     dee:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     df1:	8b 45 10             	mov    0x10(%ebp),%eax
     df4:	89 44 24 08          	mov    %eax,0x8(%esp)
     df8:	8b 45 0c             	mov    0xc(%ebp),%eax
     dfb:	89 44 24 04          	mov    %eax,0x4(%esp)
     dff:	8b 45 08             	mov    0x8(%ebp),%eax
     e02:	89 04 24             	mov    %eax,(%esp)
     e05:	e8 ef fe ff ff       	call   cf9 <stosb>
  return dst;
     e0a:	8b 45 08             	mov    0x8(%ebp),%eax
}
     e0d:	c9                   	leave  
     e0e:	c3                   	ret    

00000e0f <strchr>:

char*
strchr(const char *s, char c)
{
     e0f:	55                   	push   %ebp
     e10:	89 e5                	mov    %esp,%ebp
     e12:	83 ec 04             	sub    $0x4,%esp
     e15:	8b 45 0c             	mov    0xc(%ebp),%eax
     e18:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     e1b:	eb 14                	jmp    e31 <strchr+0x22>
    if(*s == c)
     e1d:	8b 45 08             	mov    0x8(%ebp),%eax
     e20:	0f b6 00             	movzbl (%eax),%eax
     e23:	3a 45 fc             	cmp    -0x4(%ebp),%al
     e26:	75 05                	jne    e2d <strchr+0x1e>
      return (char*)s;
     e28:	8b 45 08             	mov    0x8(%ebp),%eax
     e2b:	eb 13                	jmp    e40 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     e2d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     e31:	8b 45 08             	mov    0x8(%ebp),%eax
     e34:	0f b6 00             	movzbl (%eax),%eax
     e37:	84 c0                	test   %al,%al
     e39:	75 e2                	jne    e1d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     e3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
     e40:	c9                   	leave  
     e41:	c3                   	ret    

00000e42 <gets>:

char*
gets(char *buf, int max)
{
     e42:	55                   	push   %ebp
     e43:	89 e5                	mov    %esp,%ebp
     e45:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e4f:	eb 4c                	jmp    e9d <gets+0x5b>
    cc = read(0, &c, 1);
     e51:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     e58:	00 
     e59:	8d 45 ef             	lea    -0x11(%ebp),%eax
     e5c:	89 44 24 04          	mov    %eax,0x4(%esp)
     e60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e67:	e8 80 03 00 00       	call   11ec <read>
     e6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     e6f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     e73:	7f 02                	jg     e77 <gets+0x35>
      break;
     e75:	eb 31                	jmp    ea8 <gets+0x66>
    buf[i++] = c;
     e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e7a:	8d 50 01             	lea    0x1(%eax),%edx
     e7d:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e80:	89 c2                	mov    %eax,%edx
     e82:	8b 45 08             	mov    0x8(%ebp),%eax
     e85:	01 c2                	add    %eax,%edx
     e87:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e8b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     e8d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e91:	3c 0a                	cmp    $0xa,%al
     e93:	74 13                	je     ea8 <gets+0x66>
     e95:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e99:	3c 0d                	cmp    $0xd,%al
     e9b:	74 0b                	je     ea8 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ea0:	83 c0 01             	add    $0x1,%eax
     ea3:	3b 45 0c             	cmp    0xc(%ebp),%eax
     ea6:	7c a9                	jl     e51 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     ea8:	8b 55 f4             	mov    -0xc(%ebp),%edx
     eab:	8b 45 08             	mov    0x8(%ebp),%eax
     eae:	01 d0                	add    %edx,%eax
     eb0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     eb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
     eb6:	c9                   	leave  
     eb7:	c3                   	ret    

00000eb8 <stat>:

int
stat(char *n, struct stat *st)
{
     eb8:	55                   	push   %ebp
     eb9:	89 e5                	mov    %esp,%ebp
     ebb:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ebe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     ec5:	00 
     ec6:	8b 45 08             	mov    0x8(%ebp),%eax
     ec9:	89 04 24             	mov    %eax,(%esp)
     ecc:	e8 43 03 00 00       	call   1214 <open>
     ed1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     ed4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ed8:	79 07                	jns    ee1 <stat+0x29>
    return -1;
     eda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     edf:	eb 23                	jmp    f04 <stat+0x4c>
  r = fstat(fd, st);
     ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
     ee4:	89 44 24 04          	mov    %eax,0x4(%esp)
     ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     eeb:	89 04 24             	mov    %eax,(%esp)
     eee:	e8 39 03 00 00       	call   122c <fstat>
     ef3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ef9:	89 04 24             	mov    %eax,(%esp)
     efc:	e8 fb 02 00 00       	call   11fc <close>
  return r;
     f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     f04:	c9                   	leave  
     f05:	c3                   	ret    

00000f06 <atoi>:

int
atoi(const char *s)
{
     f06:	55                   	push   %ebp
     f07:	89 e5                	mov    %esp,%ebp
     f09:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     f0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     f13:	eb 25                	jmp    f3a <atoi+0x34>
    n = n*10 + *s++ - '0';
     f15:	8b 55 fc             	mov    -0x4(%ebp),%edx
     f18:	89 d0                	mov    %edx,%eax
     f1a:	c1 e0 02             	shl    $0x2,%eax
     f1d:	01 d0                	add    %edx,%eax
     f1f:	01 c0                	add    %eax,%eax
     f21:	89 c1                	mov    %eax,%ecx
     f23:	8b 45 08             	mov    0x8(%ebp),%eax
     f26:	8d 50 01             	lea    0x1(%eax),%edx
     f29:	89 55 08             	mov    %edx,0x8(%ebp)
     f2c:	0f b6 00             	movzbl (%eax),%eax
     f2f:	0f be c0             	movsbl %al,%eax
     f32:	01 c8                	add    %ecx,%eax
     f34:	83 e8 30             	sub    $0x30,%eax
     f37:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     f3a:	8b 45 08             	mov    0x8(%ebp),%eax
     f3d:	0f b6 00             	movzbl (%eax),%eax
     f40:	3c 2f                	cmp    $0x2f,%al
     f42:	7e 0a                	jle    f4e <atoi+0x48>
     f44:	8b 45 08             	mov    0x8(%ebp),%eax
     f47:	0f b6 00             	movzbl (%eax),%eax
     f4a:	3c 39                	cmp    $0x39,%al
     f4c:	7e c7                	jle    f15 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     f4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     f51:	c9                   	leave  
     f52:	c3                   	ret    

00000f53 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     f53:	55                   	push   %ebp
     f54:	89 e5                	mov    %esp,%ebp
     f56:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     f59:	8b 45 08             	mov    0x8(%ebp),%eax
     f5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
     f62:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     f65:	eb 17                	jmp    f7e <memmove+0x2b>
    *dst++ = *src++;
     f67:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f6a:	8d 50 01             	lea    0x1(%eax),%edx
     f6d:	89 55 fc             	mov    %edx,-0x4(%ebp)
     f70:	8b 55 f8             	mov    -0x8(%ebp),%edx
     f73:	8d 4a 01             	lea    0x1(%edx),%ecx
     f76:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     f79:	0f b6 12             	movzbl (%edx),%edx
     f7c:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     f7e:	8b 45 10             	mov    0x10(%ebp),%eax
     f81:	8d 50 ff             	lea    -0x1(%eax),%edx
     f84:	89 55 10             	mov    %edx,0x10(%ebp)
     f87:	85 c0                	test   %eax,%eax
     f89:	7f dc                	jg     f67 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     f8b:	8b 45 08             	mov    0x8(%ebp),%eax
}
     f8e:	c9                   	leave  
     f8f:	c3                   	ret    

00000f90 <strcmp_c>:


int
strcmp_c(const char *s1, const char *s2)
{
     f90:	55                   	push   %ebp
     f91:	89 e5                	mov    %esp,%ebp
    for ( ; *s1 == *s2; s1++, s2++)
     f93:	eb 19                	jmp    fae <strcmp_c+0x1e>
	if (*s1 == '\0')
     f95:	8b 45 08             	mov    0x8(%ebp),%eax
     f98:	0f b6 00             	movzbl (%eax),%eax
     f9b:	84 c0                	test   %al,%al
     f9d:	75 07                	jne    fa6 <strcmp_c+0x16>
	    return 0;
     f9f:	b8 00 00 00 00       	mov    $0x0,%eax
     fa4:	eb 34                	jmp    fda <strcmp_c+0x4a>


int
strcmp_c(const char *s1, const char *s2)
{
    for ( ; *s1 == *s2; s1++, s2++)
     fa6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     faa:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
     fae:	8b 45 08             	mov    0x8(%ebp),%eax
     fb1:	0f b6 10             	movzbl (%eax),%edx
     fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
     fb7:	0f b6 00             	movzbl (%eax),%eax
     fba:	38 c2                	cmp    %al,%dl
     fbc:	74 d7                	je     f95 <strcmp_c+0x5>
	if (*s1 == '\0')
	    return 0;
    return ((*(unsigned char *)s1 < *(unsigned char *)s2) ? -1 : +1);
     fbe:	8b 45 08             	mov    0x8(%ebp),%eax
     fc1:	0f b6 10             	movzbl (%eax),%edx
     fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
     fc7:	0f b6 00             	movzbl (%eax),%eax
     fca:	38 c2                	cmp    %al,%dl
     fcc:	73 07                	jae    fd5 <strcmp_c+0x45>
     fce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fd3:	eb 05                	jmp    fda <strcmp_c+0x4a>
     fd5:	b8 01 00 00 00       	mov    $0x1,%eax
}
     fda:	5d                   	pop    %ebp
     fdb:	c3                   	ret    

00000fdc <readuser>:


struct USER
readuser(){
     fdc:	55                   	push   %ebp
     fdd:	89 e5                	mov    %esp,%ebp
     fdf:	81 ec 28 04 00 00    	sub    $0x428,%esp
	char buff1[512], buff2[512];
	struct USER u;
	printf(1,"Please enter a username: ");
     fe5:	c7 44 24 04 20 18 00 	movl   $0x1820,0x4(%esp)
     fec:	00 
     fed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ff4:	e8 6b 03 00 00       	call   1364 <printf>
	u.name = gets(buff1, 50);
     ff9:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
    1000:	00 
    1001:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
    1007:	89 04 24             	mov    %eax,(%esp)
    100a:	e8 33 fe ff ff       	call   e42 <gets>
    100f:	89 85 ec fb ff ff    	mov    %eax,-0x414(%ebp)
	printf(1,"Please enter a password: ");
    1015:	c7 44 24 04 3a 18 00 	movl   $0x183a,0x4(%esp)
    101c:	00 
    101d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1024:	e8 3b 03 00 00       	call   1364 <printf>
	u.pass = gets(buff2, 50);
    1029:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
    1030:	00 
    1031:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
    1037:	89 04 24             	mov    %eax,(%esp)
    103a:	e8 03 fe ff ff       	call   e42 <gets>
    103f:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
	return u;
    1045:	8b 45 08             	mov    0x8(%ebp),%eax
    1048:	8b 95 ec fb ff ff    	mov    -0x414(%ebp),%edx
    104e:	89 10                	mov    %edx,(%eax)
    1050:	8b 95 f0 fb ff ff    	mov    -0x410(%ebp),%edx
    1056:	89 50 04             	mov    %edx,0x4(%eax)
    1059:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
    105f:	89 50 08             	mov    %edx,0x8(%eax)
}
    1062:	8b 45 08             	mov    0x8(%ebp),%eax
    1065:	c9                   	leave  
    1066:	c2 04 00             	ret    $0x4

00001069 <compareuser>:


int
compareuser(int state){
    1069:	55                   	push   %ebp
    106a:	89 e5                	mov    %esp,%ebp
    106c:	56                   	push   %esi
    106d:	53                   	push   %ebx
    106e:	81 ec 30 01 00 00    	sub    $0x130,%esp
	struct USER u1,u2;
	struct USER users[20];
	u1.name = "john\n";
    1074:	c7 45 e8 54 18 00 00 	movl   $0x1854,-0x18(%ebp)
	u1.pass = "1234\n";
    107b:	c7 45 ec 5a 18 00 00 	movl   $0x185a,-0x14(%ebp)
	u1.ulevel = 0;
    1082:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	u2.name = "james\n";
    1089:	c7 45 dc 60 18 00 00 	movl   $0x1860,-0x24(%ebp)
	u2.pass = "pass\n";
    1090:	c7 45 e0 67 18 00 00 	movl   $0x1867,-0x20(%ebp)
	u2.ulevel = 1;
    1097:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	users[0] = u1;
    109e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10a1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
    10a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    10aa:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
    10b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10b3:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
	users[1] = u2;
    10b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
    10bc:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
    10c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
    10c5:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
    10cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    10ce:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
	
	
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
    10d4:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
    10da:	89 04 24             	mov    %eax,(%esp)
    10dd:	e8 fa fe ff ff       	call   fdc <readuser>
    10e2:	83 ec 04             	sub    $0x4,%esp
		
		for(ctr = 0; ctr < 20; ctr++)
    10e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    10ec:	e9 a4 00 00 00       	jmp    1195 <compareuser+0x12c>
		{

			if(strcmp_c(u.name,users[ctr].name) == 0 && strcmp_c(u.pass,users[ctr].pass) == 0)
    10f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    10f4:	89 d0                	mov    %edx,%eax
    10f6:	01 c0                	add    %eax,%eax
    10f8:	01 d0                	add    %edx,%eax
    10fa:	c1 e0 02             	shl    $0x2,%eax
    10fd:	8d 4d f8             	lea    -0x8(%ebp),%ecx
    1100:	01 c8                	add    %ecx,%eax
    1102:	2d 0c 01 00 00       	sub    $0x10c,%eax
    1107:	8b 10                	mov    (%eax),%edx
    1109:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
    110f:	89 54 24 04          	mov    %edx,0x4(%esp)
    1113:	89 04 24             	mov    %eax,(%esp)
    1116:	e8 75 fe ff ff       	call   f90 <strcmp_c>
    111b:	85 c0                	test   %eax,%eax
    111d:	75 72                	jne    1191 <compareuser+0x128>
    111f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1122:	89 d0                	mov    %edx,%eax
    1124:	01 c0                	add    %eax,%eax
    1126:	01 d0                	add    %edx,%eax
    1128:	c1 e0 02             	shl    $0x2,%eax
    112b:	8d 5d f8             	lea    -0x8(%ebp),%ebx
    112e:	01 d8                	add    %ebx,%eax
    1130:	2d 08 01 00 00       	sub    $0x108,%eax
    1135:	8b 10                	mov    (%eax),%edx
    1137:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
    113d:	89 54 24 04          	mov    %edx,0x4(%esp)
    1141:	89 04 24             	mov    %eax,(%esp)
    1144:	e8 47 fe ff ff       	call   f90 <strcmp_c>
    1149:	85 c0                	test   %eax,%eax
    114b:	75 44                	jne    1191 <compareuser+0x128>
			{
				setuser(users[ctr].ulevel);
    114d:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1150:	89 d0                	mov    %edx,%eax
    1152:	01 c0                	add    %eax,%eax
    1154:	01 d0                	add    %edx,%eax
    1156:	c1 e0 02             	shl    $0x2,%eax
    1159:	8d 75 f8             	lea    -0x8(%ebp),%esi
    115c:	01 f0                	add    %esi,%eax
    115e:	2d 04 01 00 00       	sub    $0x104,%eax
    1163:	8b 00                	mov    (%eax),%eax
    1165:	89 04 24             	mov    %eax,(%esp)
    1168:	e8 0f 01 00 00       	call   127c <setuser>
				
				printf(1,"%d",getuser());
    116d:	e8 02 01 00 00       	call   1274 <getuser>
    1172:	89 44 24 08          	mov    %eax,0x8(%esp)
    1176:	c7 44 24 04 6d 18 00 	movl   $0x186d,0x4(%esp)
    117d:	00 
    117e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1185:	e8 da 01 00 00       	call   1364 <printf>
				return 1;
    118a:	b8 01 00 00 00       	mov    $0x1,%eax
    118f:	eb 34                	jmp    11c5 <compareuser+0x15c>
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
		
		for(ctr = 0; ctr < 20; ctr++)
    1191:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1195:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1199:	0f 8e 52 ff ff ff    	jle    10f1 <compareuser+0x88>
				
				printf(1,"%d",getuser());
				return 1;
			}
		}
		printf(1,"Invalid username/password\n");
    119f:	c7 44 24 04 70 18 00 	movl   $0x1870,0x4(%esp)
    11a6:	00 
    11a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11ae:	e8 b1 01 00 00       	call   1364 <printf>
		if(state != 1)
    11b3:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    11b7:	74 07                	je     11c0 <compareuser+0x157>
			break;
	}
	return 0;
    11b9:	b8 00 00 00 00       	mov    $0x0,%eax
    11be:	eb 05                	jmp    11c5 <compareuser+0x15c>
			}
		}
		printf(1,"Invalid username/password\n");
		if(state != 1)
			break;
	}
    11c0:	e9 0f ff ff ff       	jmp    10d4 <compareuser+0x6b>
	return 0;
}
    11c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
    11c8:	5b                   	pop    %ebx
    11c9:	5e                   	pop    %esi
    11ca:	5d                   	pop    %ebp
    11cb:	c3                   	ret    

000011cc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    11cc:	b8 01 00 00 00       	mov    $0x1,%eax
    11d1:	cd 40                	int    $0x40
    11d3:	c3                   	ret    

000011d4 <exit>:
SYSCALL(exit)
    11d4:	b8 02 00 00 00       	mov    $0x2,%eax
    11d9:	cd 40                	int    $0x40
    11db:	c3                   	ret    

000011dc <wait>:
SYSCALL(wait)
    11dc:	b8 03 00 00 00       	mov    $0x3,%eax
    11e1:	cd 40                	int    $0x40
    11e3:	c3                   	ret    

000011e4 <pipe>:
SYSCALL(pipe)
    11e4:	b8 04 00 00 00       	mov    $0x4,%eax
    11e9:	cd 40                	int    $0x40
    11eb:	c3                   	ret    

000011ec <read>:
SYSCALL(read)
    11ec:	b8 05 00 00 00       	mov    $0x5,%eax
    11f1:	cd 40                	int    $0x40
    11f3:	c3                   	ret    

000011f4 <write>:
SYSCALL(write)
    11f4:	b8 10 00 00 00       	mov    $0x10,%eax
    11f9:	cd 40                	int    $0x40
    11fb:	c3                   	ret    

000011fc <close>:
SYSCALL(close)
    11fc:	b8 15 00 00 00       	mov    $0x15,%eax
    1201:	cd 40                	int    $0x40
    1203:	c3                   	ret    

00001204 <kill>:
SYSCALL(kill)
    1204:	b8 06 00 00 00       	mov    $0x6,%eax
    1209:	cd 40                	int    $0x40
    120b:	c3                   	ret    

0000120c <exec>:
SYSCALL(exec)
    120c:	b8 07 00 00 00       	mov    $0x7,%eax
    1211:	cd 40                	int    $0x40
    1213:	c3                   	ret    

00001214 <open>:
SYSCALL(open)
    1214:	b8 0f 00 00 00       	mov    $0xf,%eax
    1219:	cd 40                	int    $0x40
    121b:	c3                   	ret    

0000121c <mknod>:
SYSCALL(mknod)
    121c:	b8 11 00 00 00       	mov    $0x11,%eax
    1221:	cd 40                	int    $0x40
    1223:	c3                   	ret    

00001224 <unlink>:
SYSCALL(unlink)
    1224:	b8 12 00 00 00       	mov    $0x12,%eax
    1229:	cd 40                	int    $0x40
    122b:	c3                   	ret    

0000122c <fstat>:
SYSCALL(fstat)
    122c:	b8 08 00 00 00       	mov    $0x8,%eax
    1231:	cd 40                	int    $0x40
    1233:	c3                   	ret    

00001234 <link>:
SYSCALL(link)
    1234:	b8 13 00 00 00       	mov    $0x13,%eax
    1239:	cd 40                	int    $0x40
    123b:	c3                   	ret    

0000123c <mkdir>:
SYSCALL(mkdir)
    123c:	b8 14 00 00 00       	mov    $0x14,%eax
    1241:	cd 40                	int    $0x40
    1243:	c3                   	ret    

00001244 <chdir>:
SYSCALL(chdir)
    1244:	b8 09 00 00 00       	mov    $0x9,%eax
    1249:	cd 40                	int    $0x40
    124b:	c3                   	ret    

0000124c <dup>:
SYSCALL(dup)
    124c:	b8 0a 00 00 00       	mov    $0xa,%eax
    1251:	cd 40                	int    $0x40
    1253:	c3                   	ret    

00001254 <getpid>:
SYSCALL(getpid)
    1254:	b8 0b 00 00 00       	mov    $0xb,%eax
    1259:	cd 40                	int    $0x40
    125b:	c3                   	ret    

0000125c <sbrk>:
SYSCALL(sbrk)
    125c:	b8 0c 00 00 00       	mov    $0xc,%eax
    1261:	cd 40                	int    $0x40
    1263:	c3                   	ret    

00001264 <sleep>:
SYSCALL(sleep)
    1264:	b8 0d 00 00 00       	mov    $0xd,%eax
    1269:	cd 40                	int    $0x40
    126b:	c3                   	ret    

0000126c <uptime>:
SYSCALL(uptime)
    126c:	b8 0e 00 00 00       	mov    $0xe,%eax
    1271:	cd 40                	int    $0x40
    1273:	c3                   	ret    

00001274 <getuser>:
SYSCALL(getuser)
    1274:	b8 16 00 00 00       	mov    $0x16,%eax
    1279:	cd 40                	int    $0x40
    127b:	c3                   	ret    

0000127c <setuser>:
SYSCALL(setuser)
    127c:	b8 17 00 00 00       	mov    $0x17,%eax
    1281:	cd 40                	int    $0x40
    1283:	c3                   	ret    

00001284 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1284:	55                   	push   %ebp
    1285:	89 e5                	mov    %esp,%ebp
    1287:	83 ec 18             	sub    $0x18,%esp
    128a:	8b 45 0c             	mov    0xc(%ebp),%eax
    128d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1290:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1297:	00 
    1298:	8d 45 f4             	lea    -0xc(%ebp),%eax
    129b:	89 44 24 04          	mov    %eax,0x4(%esp)
    129f:	8b 45 08             	mov    0x8(%ebp),%eax
    12a2:	89 04 24             	mov    %eax,(%esp)
    12a5:	e8 4a ff ff ff       	call   11f4 <write>
}
    12aa:	c9                   	leave  
    12ab:	c3                   	ret    

000012ac <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    12ac:	55                   	push   %ebp
    12ad:	89 e5                	mov    %esp,%ebp
    12af:	56                   	push   %esi
    12b0:	53                   	push   %ebx
    12b1:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    12b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    12bb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    12bf:	74 17                	je     12d8 <printint+0x2c>
    12c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    12c5:	79 11                	jns    12d8 <printint+0x2c>
    neg = 1;
    12c7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    12ce:	8b 45 0c             	mov    0xc(%ebp),%eax
    12d1:	f7 d8                	neg    %eax
    12d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    12d6:	eb 06                	jmp    12de <printint+0x32>
  } else {
    x = xx;
    12d8:	8b 45 0c             	mov    0xc(%ebp),%eax
    12db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    12de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    12e5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    12e8:	8d 41 01             	lea    0x1(%ecx),%eax
    12eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    12ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
    12f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    12f4:	ba 00 00 00 00       	mov    $0x0,%edx
    12f9:	f7 f3                	div    %ebx
    12fb:	89 d0                	mov    %edx,%eax
    12fd:	0f b6 80 ce 1d 00 00 	movzbl 0x1dce(%eax),%eax
    1304:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1308:	8b 75 10             	mov    0x10(%ebp),%esi
    130b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    130e:	ba 00 00 00 00       	mov    $0x0,%edx
    1313:	f7 f6                	div    %esi
    1315:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1318:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    131c:	75 c7                	jne    12e5 <printint+0x39>
  if(neg)
    131e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1322:	74 10                	je     1334 <printint+0x88>
    buf[i++] = '-';
    1324:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1327:	8d 50 01             	lea    0x1(%eax),%edx
    132a:	89 55 f4             	mov    %edx,-0xc(%ebp)
    132d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1332:	eb 1f                	jmp    1353 <printint+0xa7>
    1334:	eb 1d                	jmp    1353 <printint+0xa7>
    putc(fd, buf[i]);
    1336:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1339:	8b 45 f4             	mov    -0xc(%ebp),%eax
    133c:	01 d0                	add    %edx,%eax
    133e:	0f b6 00             	movzbl (%eax),%eax
    1341:	0f be c0             	movsbl %al,%eax
    1344:	89 44 24 04          	mov    %eax,0x4(%esp)
    1348:	8b 45 08             	mov    0x8(%ebp),%eax
    134b:	89 04 24             	mov    %eax,(%esp)
    134e:	e8 31 ff ff ff       	call   1284 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1353:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1357:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    135b:	79 d9                	jns    1336 <printint+0x8a>
    putc(fd, buf[i]);
}
    135d:	83 c4 30             	add    $0x30,%esp
    1360:	5b                   	pop    %ebx
    1361:	5e                   	pop    %esi
    1362:	5d                   	pop    %ebp
    1363:	c3                   	ret    

00001364 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1364:	55                   	push   %ebp
    1365:	89 e5                	mov    %esp,%ebp
    1367:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    136a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1371:	8d 45 0c             	lea    0xc(%ebp),%eax
    1374:	83 c0 04             	add    $0x4,%eax
    1377:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    137a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1381:	e9 7c 01 00 00       	jmp    1502 <printf+0x19e>
    c = fmt[i] & 0xff;
    1386:	8b 55 0c             	mov    0xc(%ebp),%edx
    1389:	8b 45 f0             	mov    -0x10(%ebp),%eax
    138c:	01 d0                	add    %edx,%eax
    138e:	0f b6 00             	movzbl (%eax),%eax
    1391:	0f be c0             	movsbl %al,%eax
    1394:	25 ff 00 00 00       	and    $0xff,%eax
    1399:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    139c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    13a0:	75 2c                	jne    13ce <printf+0x6a>
      if(c == '%'){
    13a2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    13a6:	75 0c                	jne    13b4 <printf+0x50>
        state = '%';
    13a8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    13af:	e9 4a 01 00 00       	jmp    14fe <printf+0x19a>
      } else {
        putc(fd, c);
    13b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    13b7:	0f be c0             	movsbl %al,%eax
    13ba:	89 44 24 04          	mov    %eax,0x4(%esp)
    13be:	8b 45 08             	mov    0x8(%ebp),%eax
    13c1:	89 04 24             	mov    %eax,(%esp)
    13c4:	e8 bb fe ff ff       	call   1284 <putc>
    13c9:	e9 30 01 00 00       	jmp    14fe <printf+0x19a>
      }
    } else if(state == '%'){
    13ce:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    13d2:	0f 85 26 01 00 00    	jne    14fe <printf+0x19a>
      if(c == 'd'){
    13d8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    13dc:	75 2d                	jne    140b <printf+0xa7>
        printint(fd, *ap, 10, 1);
    13de:	8b 45 e8             	mov    -0x18(%ebp),%eax
    13e1:	8b 00                	mov    (%eax),%eax
    13e3:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    13ea:	00 
    13eb:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    13f2:	00 
    13f3:	89 44 24 04          	mov    %eax,0x4(%esp)
    13f7:	8b 45 08             	mov    0x8(%ebp),%eax
    13fa:	89 04 24             	mov    %eax,(%esp)
    13fd:	e8 aa fe ff ff       	call   12ac <printint>
        ap++;
    1402:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1406:	e9 ec 00 00 00       	jmp    14f7 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    140b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    140f:	74 06                	je     1417 <printf+0xb3>
    1411:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1415:	75 2d                	jne    1444 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1417:	8b 45 e8             	mov    -0x18(%ebp),%eax
    141a:	8b 00                	mov    (%eax),%eax
    141c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1423:	00 
    1424:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    142b:	00 
    142c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1430:	8b 45 08             	mov    0x8(%ebp),%eax
    1433:	89 04 24             	mov    %eax,(%esp)
    1436:	e8 71 fe ff ff       	call   12ac <printint>
        ap++;
    143b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    143f:	e9 b3 00 00 00       	jmp    14f7 <printf+0x193>
      } else if(c == 's'){
    1444:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1448:	75 45                	jne    148f <printf+0x12b>
        s = (char*)*ap;
    144a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    144d:	8b 00                	mov    (%eax),%eax
    144f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1452:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1456:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    145a:	75 09                	jne    1465 <printf+0x101>
          s = "(null)";
    145c:	c7 45 f4 8b 18 00 00 	movl   $0x188b,-0xc(%ebp)
        while(*s != 0){
    1463:	eb 1e                	jmp    1483 <printf+0x11f>
    1465:	eb 1c                	jmp    1483 <printf+0x11f>
          putc(fd, *s);
    1467:	8b 45 f4             	mov    -0xc(%ebp),%eax
    146a:	0f b6 00             	movzbl (%eax),%eax
    146d:	0f be c0             	movsbl %al,%eax
    1470:	89 44 24 04          	mov    %eax,0x4(%esp)
    1474:	8b 45 08             	mov    0x8(%ebp),%eax
    1477:	89 04 24             	mov    %eax,(%esp)
    147a:	e8 05 fe ff ff       	call   1284 <putc>
          s++;
    147f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1483:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1486:	0f b6 00             	movzbl (%eax),%eax
    1489:	84 c0                	test   %al,%al
    148b:	75 da                	jne    1467 <printf+0x103>
    148d:	eb 68                	jmp    14f7 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    148f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1493:	75 1d                	jne    14b2 <printf+0x14e>
        putc(fd, *ap);
    1495:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1498:	8b 00                	mov    (%eax),%eax
    149a:	0f be c0             	movsbl %al,%eax
    149d:	89 44 24 04          	mov    %eax,0x4(%esp)
    14a1:	8b 45 08             	mov    0x8(%ebp),%eax
    14a4:	89 04 24             	mov    %eax,(%esp)
    14a7:	e8 d8 fd ff ff       	call   1284 <putc>
        ap++;
    14ac:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14b0:	eb 45                	jmp    14f7 <printf+0x193>
      } else if(c == '%'){
    14b2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    14b6:	75 17                	jne    14cf <printf+0x16b>
        putc(fd, c);
    14b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14bb:	0f be c0             	movsbl %al,%eax
    14be:	89 44 24 04          	mov    %eax,0x4(%esp)
    14c2:	8b 45 08             	mov    0x8(%ebp),%eax
    14c5:	89 04 24             	mov    %eax,(%esp)
    14c8:	e8 b7 fd ff ff       	call   1284 <putc>
    14cd:	eb 28                	jmp    14f7 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    14cf:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    14d6:	00 
    14d7:	8b 45 08             	mov    0x8(%ebp),%eax
    14da:	89 04 24             	mov    %eax,(%esp)
    14dd:	e8 a2 fd ff ff       	call   1284 <putc>
        putc(fd, c);
    14e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14e5:	0f be c0             	movsbl %al,%eax
    14e8:	89 44 24 04          	mov    %eax,0x4(%esp)
    14ec:	8b 45 08             	mov    0x8(%ebp),%eax
    14ef:	89 04 24             	mov    %eax,(%esp)
    14f2:	e8 8d fd ff ff       	call   1284 <putc>
      }
      state = 0;
    14f7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    14fe:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1502:	8b 55 0c             	mov    0xc(%ebp),%edx
    1505:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1508:	01 d0                	add    %edx,%eax
    150a:	0f b6 00             	movzbl (%eax),%eax
    150d:	84 c0                	test   %al,%al
    150f:	0f 85 71 fe ff ff    	jne    1386 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1515:	c9                   	leave  
    1516:	c3                   	ret    

00001517 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1517:	55                   	push   %ebp
    1518:	89 e5                	mov    %esp,%ebp
    151a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    151d:	8b 45 08             	mov    0x8(%ebp),%eax
    1520:	83 e8 08             	sub    $0x8,%eax
    1523:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1526:	a1 4c 1e 00 00       	mov    0x1e4c,%eax
    152b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    152e:	eb 24                	jmp    1554 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1530:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1533:	8b 00                	mov    (%eax),%eax
    1535:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1538:	77 12                	ja     154c <free+0x35>
    153a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    153d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1540:	77 24                	ja     1566 <free+0x4f>
    1542:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1545:	8b 00                	mov    (%eax),%eax
    1547:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    154a:	77 1a                	ja     1566 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    154c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    154f:	8b 00                	mov    (%eax),%eax
    1551:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1554:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1557:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    155a:	76 d4                	jbe    1530 <free+0x19>
    155c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    155f:	8b 00                	mov    (%eax),%eax
    1561:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1564:	76 ca                	jbe    1530 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1566:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1569:	8b 40 04             	mov    0x4(%eax),%eax
    156c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1573:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1576:	01 c2                	add    %eax,%edx
    1578:	8b 45 fc             	mov    -0x4(%ebp),%eax
    157b:	8b 00                	mov    (%eax),%eax
    157d:	39 c2                	cmp    %eax,%edx
    157f:	75 24                	jne    15a5 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1581:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1584:	8b 50 04             	mov    0x4(%eax),%edx
    1587:	8b 45 fc             	mov    -0x4(%ebp),%eax
    158a:	8b 00                	mov    (%eax),%eax
    158c:	8b 40 04             	mov    0x4(%eax),%eax
    158f:	01 c2                	add    %eax,%edx
    1591:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1594:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1597:	8b 45 fc             	mov    -0x4(%ebp),%eax
    159a:	8b 00                	mov    (%eax),%eax
    159c:	8b 10                	mov    (%eax),%edx
    159e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15a1:	89 10                	mov    %edx,(%eax)
    15a3:	eb 0a                	jmp    15af <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    15a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15a8:	8b 10                	mov    (%eax),%edx
    15aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15ad:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    15af:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15b2:	8b 40 04             	mov    0x4(%eax),%eax
    15b5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    15bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15bf:	01 d0                	add    %edx,%eax
    15c1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    15c4:	75 20                	jne    15e6 <free+0xcf>
    p->s.size += bp->s.size;
    15c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15c9:	8b 50 04             	mov    0x4(%eax),%edx
    15cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15cf:	8b 40 04             	mov    0x4(%eax),%eax
    15d2:	01 c2                	add    %eax,%edx
    15d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15d7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    15da:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15dd:	8b 10                	mov    (%eax),%edx
    15df:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15e2:	89 10                	mov    %edx,(%eax)
    15e4:	eb 08                	jmp    15ee <free+0xd7>
  } else
    p->s.ptr = bp;
    15e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15e9:	8b 55 f8             	mov    -0x8(%ebp),%edx
    15ec:	89 10                	mov    %edx,(%eax)
  freep = p;
    15ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15f1:	a3 4c 1e 00 00       	mov    %eax,0x1e4c
}
    15f6:	c9                   	leave  
    15f7:	c3                   	ret    

000015f8 <morecore>:

static Header*
morecore(uint nu)
{
    15f8:	55                   	push   %ebp
    15f9:	89 e5                	mov    %esp,%ebp
    15fb:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    15fe:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1605:	77 07                	ja     160e <morecore+0x16>
    nu = 4096;
    1607:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    160e:	8b 45 08             	mov    0x8(%ebp),%eax
    1611:	c1 e0 03             	shl    $0x3,%eax
    1614:	89 04 24             	mov    %eax,(%esp)
    1617:	e8 40 fc ff ff       	call   125c <sbrk>
    161c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    161f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1623:	75 07                	jne    162c <morecore+0x34>
    return 0;
    1625:	b8 00 00 00 00       	mov    $0x0,%eax
    162a:	eb 22                	jmp    164e <morecore+0x56>
  hp = (Header*)p;
    162c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    162f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1632:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1635:	8b 55 08             	mov    0x8(%ebp),%edx
    1638:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    163b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    163e:	83 c0 08             	add    $0x8,%eax
    1641:	89 04 24             	mov    %eax,(%esp)
    1644:	e8 ce fe ff ff       	call   1517 <free>
  return freep;
    1649:	a1 4c 1e 00 00       	mov    0x1e4c,%eax
}
    164e:	c9                   	leave  
    164f:	c3                   	ret    

00001650 <malloc>:

void*
malloc(uint nbytes)
{
    1650:	55                   	push   %ebp
    1651:	89 e5                	mov    %esp,%ebp
    1653:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1656:	8b 45 08             	mov    0x8(%ebp),%eax
    1659:	83 c0 07             	add    $0x7,%eax
    165c:	c1 e8 03             	shr    $0x3,%eax
    165f:	83 c0 01             	add    $0x1,%eax
    1662:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1665:	a1 4c 1e 00 00       	mov    0x1e4c,%eax
    166a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    166d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1671:	75 23                	jne    1696 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1673:	c7 45 f0 44 1e 00 00 	movl   $0x1e44,-0x10(%ebp)
    167a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    167d:	a3 4c 1e 00 00       	mov    %eax,0x1e4c
    1682:	a1 4c 1e 00 00       	mov    0x1e4c,%eax
    1687:	a3 44 1e 00 00       	mov    %eax,0x1e44
    base.s.size = 0;
    168c:	c7 05 48 1e 00 00 00 	movl   $0x0,0x1e48
    1693:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1696:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1699:	8b 00                	mov    (%eax),%eax
    169b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    169e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16a1:	8b 40 04             	mov    0x4(%eax),%eax
    16a4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    16a7:	72 4d                	jb     16f6 <malloc+0xa6>
      if(p->s.size == nunits)
    16a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16ac:	8b 40 04             	mov    0x4(%eax),%eax
    16af:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    16b2:	75 0c                	jne    16c0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    16b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16b7:	8b 10                	mov    (%eax),%edx
    16b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16bc:	89 10                	mov    %edx,(%eax)
    16be:	eb 26                	jmp    16e6 <malloc+0x96>
      else {
        p->s.size -= nunits;
    16c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16c3:	8b 40 04             	mov    0x4(%eax),%eax
    16c6:	2b 45 ec             	sub    -0x14(%ebp),%eax
    16c9:	89 c2                	mov    %eax,%edx
    16cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16ce:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    16d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16d4:	8b 40 04             	mov    0x4(%eax),%eax
    16d7:	c1 e0 03             	shl    $0x3,%eax
    16da:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    16dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
    16e3:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    16e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16e9:	a3 4c 1e 00 00       	mov    %eax,0x1e4c
      return (void*)(p + 1);
    16ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16f1:	83 c0 08             	add    $0x8,%eax
    16f4:	eb 38                	jmp    172e <malloc+0xde>
    }
    if(p == freep)
    16f6:	a1 4c 1e 00 00       	mov    0x1e4c,%eax
    16fb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    16fe:	75 1b                	jne    171b <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1700:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1703:	89 04 24             	mov    %eax,(%esp)
    1706:	e8 ed fe ff ff       	call   15f8 <morecore>
    170b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    170e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1712:	75 07                	jne    171b <malloc+0xcb>
        return 0;
    1714:	b8 00 00 00 00       	mov    $0x0,%eax
    1719:	eb 13                	jmp    172e <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    171b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    171e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1721:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1724:	8b 00                	mov    (%eax),%eax
    1726:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1729:	e9 70 ff ff ff       	jmp    169e <malloc+0x4e>
}
    172e:	c9                   	leave  
    172f:	c3                   	ret    
