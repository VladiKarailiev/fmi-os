#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <err.h>

int main(void)
{
    execl("/bin/date", "date", NULL);
    err(1, "execl failed");

    return 0;
}
