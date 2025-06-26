#include <stdbool.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>
#include <fcntl.h>
#include <stdint.h>
#include <err.h>


int main(int argc, char *argv[])
{
    if (argc != 4) {
        errx(2, "Not good params\n");
    }
    int f1 = open(argv[1], O_RDONLY);
    if (f1 == -1) {
        errx(2, "ne otvori f1");
    }
    int f2 = open(argv[2], O_RDONLY);
    if (f2 == -1) {
        errx(2, "ne otvori f2");
    }
    int patch = open(argv[3], O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (patch == -1) {
        errx(2, "ne otvori patch");
    }
    
    lseek(f1, 0, SEEK_SET);
    lseek(f2, 0, SEEK_SET);
    char org;
    char new;
    while ( read(f1, &org, 1) == 1) {
        
        uint16_t offset = lseek(f2, 0, SEEK_CUR);
        read(f2, &new, 1);

        if(org != new) {
            write(patch, &offset, sizeof(uint16_t));
            write(patch, &org, 1);
            write(patch, &new, 1);
            printf("offset: %d | org: %c | new: %c\n", offset, org, new);
        }



    }

    close(f1);
    close(f2);
    close(patch);
    
    return 0;
}

