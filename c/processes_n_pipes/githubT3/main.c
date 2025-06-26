#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <err.h>

int main(void)
{

    execlp("sleep", "sleep", "60", NULL);
    err(1, "execlp failed");

    return 0;
}
