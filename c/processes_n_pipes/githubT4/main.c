#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <err.h>

int main(void)
{
    pid_t pid = fork();
    if(pid == -1) err(1, "belq");
    if (pid == 0) {
        printf("Child pid %d\n", getpid());
    }
    else {
        printf("Parent pid %d with child %d\n", getpid(), pid);
    }

    return 0;
}
