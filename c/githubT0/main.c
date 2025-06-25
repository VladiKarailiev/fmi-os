#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>

int main(void)
{
    uid_t me = getuid();
	uid_t pretending = geteuid();
    printf("uid: %d euid: %d\n", me, pretending);

    return 0;
}
