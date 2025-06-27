#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <err.h>
#include <stdlib.h>
#include <sys/wait.h>


int main(int argc, char* argv[])
{
    if(argc != 3) err(1,"params?");
    int n = argv[1][0] - '0';
    int d = argv[2][0] - '0';
    d++;    
    int pipe1[2];
    pipe(pipe1);
    int pipe2[2];
    pipe(pipe2);
    pid_t kid = fork();

    if(kid == 0) {
        write(pipe2[1], "start", 5);
        close(pipe1[1]);
        close(pipe2[0]);
        char buff[64];
        while(read(pipe1[0], buff, sizeof(buff)) > 0) {
//            printf("buff e %s\n", buff);
            printf("dong\n");
            write(pipe2[1], "dong", 4);
        }
        write(pipe2[1],"dong",4);
        close(pipe1[0]);
        close(pipe2[1]);
        exit(0);
    }
    int i =0;
    close(pipe1[0]);
    close(pipe2[1]);
    while(i < n) {
        char buff[64];
        
        read(pipe2[0],buff,sizeof(buff));
        sleep(d);
        //printf("i:%d bashtata chete %s\n",i, buff);
        printf("ding\n");
        write(pipe1[1], "ding", 4);
        i++;
    }
    close(pipe1[1]);
    close(pipe2[0]);


    wait(NULL);
    return 0;
}
