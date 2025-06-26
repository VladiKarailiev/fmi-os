#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <err.h>
#include <sys/wait.h>
#include <stdlib.h>

int main(int argc, char* argv[])
{
    if (argc != 2) errx(1, "belq");
    int pipefd[2];
    if( pipe(pipefd) == -1) err(1, "pipe failed");
    

    pid_t pid1 = fork();
    if (pid1 == 0) {
        close(pipefd[1]);
        dup2(pipefd[0], 0);
        close(pipefd[0]);
        execlp("sort", "sort", NULL);
        err(1, "execlp failed");
    }
    
    pid_t pid2 = fork();
    if(pid2 == -1) err(1, "fork fail");
    if(pid2 == 0) {
        close(pipefd[0]);
        dup2(pipefd[1], 1);
        close(pipefd[1]);
        execlp("cat", "cat", argv[1], NULL);
        err(1,"execlp fail");
    }

    close(pipefd[0]);
    close(pipefd[1]);
    wait(NULL);
    wait(NULL);

    return 0;
}
