#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>
#include <fcntl.h>


int main(int argc, char *argv[])
{
    if (argc != 2) {
        write(2, "Not good params\n", 16);
        exit(1);
    }
    int fd = open(argv[1], O_RDONLY);
    if (fd == -1) {
        write(2, "problem\n", 8);
        exit(1);
    }
    int i = 0;
    char c;
    while (read(fd, &c, 1) == 1) {
        if ( c == '\n') {
            i++;
        }
        write(1, &c, 1);
        if(i == 2) {
            break;
        }
    }


    return 0;
}
