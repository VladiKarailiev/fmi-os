#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <err.h>
#include <sys/wait.h>

int main(void)
{
    pid_t pid = fork();
    if(pid == -1) err(1, "belq");
    if (pid == 0) {
        printf("Child pid %d\n", getpid());
    }
    else {
        
        pid_t returns = wait(NULL);
        printf("Parent pid %d waited for child %d and wait returned %d\n", getpid(), pid, returns);
    }

    return 0;
}
