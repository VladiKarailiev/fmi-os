#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>
#include <fcntl.h>

int main(void)
{
    int fd1;
    int fd2;
    char c;

    fd1 = open("foo.txt", O_RDONLY);
    if (fd1 == -1) {
        write(2, "File failed to open\n", 20);
        exit(1);
    }
    fd2 = open("out.txt", O_TRUNC | O_WRONLY | O_CREAT, 0666);
    if (fd2 == -1) {
        write(2, "Out file failed to create\n", 26);
    }
    while( read(fd1, &c, 1) == 1) {
        write(fd2, &c, 1);
    }
    close(fd1);
    close(fd2);
    
    return 0;
}
