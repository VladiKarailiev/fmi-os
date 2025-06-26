#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <err.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <string.h>

int main(int argc, char* argv[])
{
    if(argc !=2) errx(1, "need 1 param");
    int pipefd[2];
    if (pipe(pipefd) == -1) err(1, "pipe fail");
    
    pid_t pid = fork();
    if (pid == 0) {
        close(pipefd[1]);
        char buf[256];
        int n = read(pipefd[0], buf, sizeof(buf));
        if (n > 0) printf("%s\n", buf);
        close(pipefd[0]);
    }
    close(pipefd[0]);
    write(pipefd[1], argv[1], strlen(argv[1]));
    close(pipefd[1]);
    
    return 0;
}
