#include <stdbool.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>
#include <fcntl.h>
#include <stdint.h>
#include <err.h>

void loshomie(int dat1, int dat2, int idx2, int offset, int size, int temp) {
    int currPos = lseek(dat1, 0, SEEK_CUR);
    lseek(dat1, offset *sizeof(uint8_t), SEEK_SET);
    char c;
    bool flag = true;

    while ( read(dat1, &c, 1) == 1) {
        if (size == 0) {
            return;
        }
        uint16_t pos = lseek(dat2, 0, SEEK_CUR);
    
        if(flag == true) {
            if(c < 0x41 || c > 0x5A) return;
            write(idx2, &pos, 2);
            write(idx2, &size, 1);
            write(idx2, &temp, 1);
            flag = false;
        }
        write(dat2, &c, 1);
       // printf("%c i poziciq %d\n", c, pos);
        size--;    
    }
    lseek(dat1, currPos, SEEK_SET);
}   


int main(int argc, char *argv[])
{
    if (argc != 5) {
        errx(2, "Not good params\n");
    }
    int dat1 = open(argv[1], O_RDONLY);
    if (dat1 == -1) {
        errx(2, "ne otvori dat1");
    }
    int idx1 = open(argv[2], O_RDONLY);
    if (idx1 == -1) {
        errx(2, "ne otvori idx1");
    }
    int dat2;
    if ((dat2 = open(argv[3], O_WRONLY | O_CREAT | O_TRUNC, 0644)) == -1) {
       errx(2, "ne otvori dat2"); 
    }
    int idx2 = open(argv[4], O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (idx2 == -1) {
        errx(2, "ne otvori idx2");
    }
    
    
//    uint32_t buffer[1024];

    int numbersCount = lseek(idx1, 0, SEEK_END) / (sizeof(uint16_t) + sizeof(uint8_t) + sizeof(uint8_t));
    lseek(idx1, 0, SEEK_SET);
    while (numbersCount > 0) {
        uint16_t offset;
        uint8_t size;
        uint8_t temp;
        
        read(idx1, &offset, sizeof(offset));
        read(idx1, &size, sizeof(size));
        read(idx1, &temp, sizeof(temp));

        printf("offset: %d | size: %d | temp: %d\n", offset, size, temp);
        
        loshomie(dat1, dat2, idx2, offset, size, temp);

        //printInterval(fd2, fd3, left, right);
        numbersCount--;
    }

    close(dat1);
    close(idx1);
    close(dat2);
    close(idx2);
    return 0;
}

