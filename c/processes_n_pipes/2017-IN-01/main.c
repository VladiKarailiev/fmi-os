// went a too complex path, needs to be redone but will be left for now
#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <err.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int addCmd (char** cmds, int count, char* cmd) {
    int i=0;
    while(i < count){
        char* tmpCmd = cmd;
        char* tmpRecorded = cmds[i];
        while( *tmp != '\0') {
            if(*tmpCmd != *tmpRecorded) {
                break;
            }
            tmpCmd++;
            tmpRecorded++;
        }
        if(*tmpCmd != '\0') {
            i++;
        }
        else {
            tmpRecorded++;

        }
    }
}

//ps -e
int main(void)
{
    
    pid_t pidPs = fork();
    if (pidPs == 0) {
      //  close(pipefd[0]);
        mkfifo("/tmp/psout", 0644);
        int out = open("/tmp/psout", O_WRONLY);
        dup2(out, 1);
        close(out);
        execlp("ps", "ps", "-eo", "cmd", NULL);
    }
    
    pid_t pid = fork();
    if (pid == 0) {
        //close(pipefd[1]);
        char c;
        char cmd[64];
        int cmdCount = 0;
        int i =0;
        int in = open("/tmp/psout", O_RDONLY);
        while ( read(in, &c, 1) == 1) {
            if ( c == '\n' ) {
                cmd[i] = '\0';
                i=0;
                cmdCount = addCmd(cmds, cmdCount, cmd);
            }
            else {
                cmd[i++] = c;
            }
            
        }
        close(in);        
    }
        
    wait(NULL);
    wait(NULL);
    return 0;

}

// 16319 pts/8    00:00:00 bash
