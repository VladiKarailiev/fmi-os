#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <err.h>
#include <sys/wait.h>

void waitch(void){

    int ws;
    if(wait(&ws) < 0){
        err(10, "error while wait");
    }
    if(!WIFEXITED(ws)){
        errx(11, "child did not end successfuly");
    }
    if(WEXITSTATUS(ws) != 0){
        errx(12, "child did not exit with 0");
    }
}

int main(int argc, char* argv[]) {

    if (argc != 2) {
        err(1,"params?");
    }

    char* dir = argv[1];

    int pipe1[2];
    pipe(pipe1);
    int pipe2[2];
    pipe(pipe2);
    int pipe3[2];
    pipe(pipe3);
    
    pid_t kid1 = fork();
    if(kid1 == 0) {
        close(pipe1[0]);
        dup2(pipe1[1], 1);
        close(pipe1[1]);
        execlp("find","find", dir, "-type", "f", "-exec", "stat", "--printf","%Y %n\n", "{}","+", NULL);
        err(2,"execlp problem");
    }
    //waitch();
    close(pipe1[1]);        
    pid_t kid2 = fork();
    if(kid2 == 0) {
        close(pipe1[1]);
        dup2(pipe1[0],0);
        close(pipe2[0]);
        dup2(pipe2[1],1);
        close(pipe2[1]);
        close(pipe1[0]);
//        printf("puskam sort\n");
        execlp("sort", "sort","-r", NULL);
    }
    close(pipe2[1]);
    close(pipe1[0]);
    pid_t kid3 = fork();
    if(kid3 ==0) {
        close(pipe2[1]);
        close(pipe3[0]);
        dup2(pipe3[1],1);
        close(pipe3[0]);
        dup2(pipe2[0], 0);
        close(pipe2[0]);
  //      printf("head\n");
        execlp("head", "head", "-n", "1", NULL);
    }
    close(pipe3[1]);
    close(pipe2[0]);
    pid_t kid4 = fork();
    if(kid4 ==0) {
        close(pipe3[1]);
        dup2(pipe3[0],0);
        close(pipe3[0]);
    //    printf("cut\n");
        execlp("cut", "cut","-d", " ", "-f", "2", NULL); 
    }
    
    close(pipe3[0]);
    close(pipe3[1]);

    while (wait(NULL) > 0);
    



    return 0;
}

