#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <err.h>
#include <sys/wait.h>
#include <fcntl.h>

int main(int argc, char* argv[])
{
    int fd = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd == -1) err(1, "belq");
    write(fd, "fo", 2);
    pid_t pid = fork();
    if (pid == 0) {
        write(fd, "bar\n", 4);
    }
    else {
        wait(NULL);
        write(fd,"o\n",2);
    }
    argc--;
    return 0;
}
