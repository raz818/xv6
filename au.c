#include "types.h"
#include "stat.h"
#include "user.h"

char buf[512];

void
cat(int fd)
{
  int n;
  char buff1[512], buff2[512];
  char* name;
  char* pass;
  
  printf(1,"Please enter a username: ");
  name = gets(buff1, 50);
  char tmpName[strlen(name)];
  strcpy(tmpName,name);
  tmpName[strlen(tmpName)-1] = '\n';
  
  printf(1,"Please enter a password: ");
  pass = gets(buff2, 50);
  char tmpPass[strlen(pass)];
  strcpy(tmpPass,pass);
  tmpPass[strlen(tmpPass)-1] = '\n';
  while((n = read(fd, buf, sizeof(buf))) > 0){
    
    write(fd, tmpName, sizeof(tmpName));
    write(fd, tmpPass, sizeof(tmpPass));
  }
  
    if(n < 0){
    printf(1, "Add user: read error\n");
    exit();
    
  }
  
}

int
main(int argc, char *argv[])
{
  int fd;

  if((fd = open("auth_passwd.confi", 2)) < 0){
    printf(1, "Add user: cannot open\n");
    exit();
  }
  cat(fd);
  close(fd);
  
  exit();
}