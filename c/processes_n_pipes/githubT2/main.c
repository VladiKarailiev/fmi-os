#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <err.h>

int main(int argc, char* argv[])
{
    if(argc != 2) {
        err(1, "params problem");
    }

    execlp("ls", "ls", argv[1], NULL);
    err(1, "execlp failed");

    return 0;
}
