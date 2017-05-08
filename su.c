#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
	int newUser = compareuser(0);
	setuser(newUser);
	exit();
}