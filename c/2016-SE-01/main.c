#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>
#include <fcntl.h>
#include <stdint.h>
#include <err.h>



int compare(const void* a, const void* b) {
    uint8_t x = *(const uint8_t*)a;
    uint8_t y = *(const uint8_t*)b;
    if ( x < y ) return -1;
    if ( x > y) return 1;
    return 0;
}


int main(int argc, char *argv[])
{
    if (argc != 2) {
        errx(2, "Not good params\n");
    }
    int fd = open(argv[1], O_RDWR);
    if (fd == -1) {
        errx(2, "ne otvori faila :(");
    }

    uint8_t buffer[1024];

    int bytes_read = read(fd, &buffer, sizeof(buffer));
    if (bytes_read < 0) {
        err(2, "belq s cheteneto");
    }

    qsort(buffer, bytes_read, sizeof(uint8_t), compare);

    if (lseek(fd,0,SEEK_SET) < 0) {
        errx(3, "belq sus seek");
    }

    if ( write(fd, &buffer, bytes_read) < 0) {
        err(4, "error while writing");
    }
    close(fd);

    return 0;
}
