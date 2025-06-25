#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>
#include <fcntl.h>
#include <stdint.h>
#include <err.h>


void printInterval(int fdIn, int fdOut, uint32_t left, uint32_t right) {
    int currPos = lseek(fdIn, 0, SEEK_CUR);
    lseek(fdIn, left * sizeof(uint32_t), SEEK_SET);
    
    
    while(right > 0) {
        uint32_t num;
        read(fdIn, &num, sizeof(num));
        printf("chislo: %d\n", num);
        write(fdOut, &num, sizeof(num));
        right--;
    }
    lseek(fdIn, currPos, SEEK_SET);
}


int main(int argc, char *argv[])
{
    if (argc != 3) {
        errx(2, "Not good params\n");
    }
    int fd1 = open(argv[1], O_RDONLY);
    if (fd1 == -1) {
        errx(2, "ne otvori faila :(");
    }
    int fd2 = open(argv[2], O_RDONLY);
    if (fd2 == -1) {
        errx(2, "ne otvori 2 fail");
    }
    int fd3;
    if ((fd3 = open("out.bin", O_WRONLY | O_CREAT | O_TRUNC, 0644)) == -1) {
       errx(2, "ne otvori out"); 
    }

    

//    uint32_t buffer[1024];

    int numbersCount = lseek(fd1, 0, SEEK_END) / sizeof(uint32_t);
    lseek(fd1, 0, SEEK_SET);
    while (numbersCount > 0) {
        
        uint32_t left;
        uint32_t right;
        
        read(fd1, &left, sizeof(uint32_t));
        read(fd1, &right, sizeof(uint32_t));

        printf("levo: %d | desno: %d\n", left, right);
        printInterval(fd2, fd3, left, right);
        numbersCount = numbersCount - 2;
    }
/*
    int bytes_read = read(fd1, &buffer, sizeof(buffer));

    
    if (lseek(fd,0,SEEK_SET) < 0) {
        errx(3, "belq sus seek");
    }

    if ( write(fd, &buffer, bytes_read) < 0) {
        err(4, "error while writing");
    }
    close(fd);
*/
    close(fd1);
    close(fd2);
    close(fd3);
    return 0;
}
/*
2 3 0 2
100 200 300 400 500 600
*/
