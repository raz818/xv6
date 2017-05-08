#include "types.h"
#include "passwd.h"
#include "stat.h"
#include "fcntl.h"
#include "user.h"
#include "x86.h"


int
thing(void){
  return 1;
}

char*
strcpy(char *s, char *t)
{
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    ;
  return os;
}



int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
    ;
  return n;
}

uint
stringlen(char **s){
	int n;

  for(n = 0; s[n]; n++)
    ;
  return n;
}

void*
memset(void *dst, int c, uint n)
{
  stosb(dst, c, n);
  return dst;
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    if(*s == c)
      return (char*)s;
  return 0;
}

char*
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
  return buf;
}

int
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
  close(fd);
  return r;
}

int
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
  return vdst;
}


int
strcmp_c(const char *s1, const char *s2)
{
    for ( ; *s1 == *s2; s1++, s2++)
	if (*s1 == '\0')
	    return 0;
    return ((*(unsigned char *)s1 < *(unsigned char *)s2) ? -1 : +1);
}


struct USER
readuser(){
	char buff1[512], buff2[512];
	struct USER u;
	printf(1,"Please enter a username: ");
	u.name = gets(buff1, 50);
	printf(1,"Please enter a password: ");
	u.pass = gets(buff2, 50);
	return u;
}


int
compareuser(int state){
	struct USER u1,u2;
	struct USER users[20];
	u1.name = "john\n";
	u1.pass = "1234\n";
	u1.ulevel = 0;
	u2.name = "james\n";
	u2.pass = "pass\n";
	u2.ulevel = 1;
	users[0] = u1;
	users[1] = u2;

	
	
	int ctr;

	while(1 == 1){
		struct USER u = readuser();
		
		for(ctr = 0; ctr < 20; ctr++)
		{

			if(strcmp_c(u.name,users[ctr].name) == 0 && strcmp_c(u.pass,users[ctr].pass) == 0)
			{
				setuser(users[ctr].ulevel);
				
				printf(1,"%d",getuser());
				return 1;
			}
		}
		printf(1,"Invalid username/password\n");
		if(state != 1)
			break;
	}
	return 0;
}


