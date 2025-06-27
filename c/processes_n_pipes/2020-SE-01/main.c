#include <unistd.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <err.h>


int main(int argc, char* argv[])
{
    if (argc != 2) err(2,"params?");

    mkfifo("/tmp/fifo", 0644);
    int fd = open("/tmp/fifo",O_WRONLY);

    dup2(fd, 1);
    close(fd);

    execlp("cat", "cat", argv[1], NULL); 

    err(3,"exec fail");
}
