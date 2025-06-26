#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <err.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <string.h>

int main(void)
{
    
    while(1) {
        pid_t pid = fork();
        if (pid == 0) {
            printf("enter command:\n");
            char cmd[64];
            strcpy(cmd, "/bin/");
            char c;
            int i = 5;
            while ( read(0, &c, 1) == 1) {
                if (c == '\n') break;
                cmd[i++] = c;
            }
            cmd[i] = '\0';
            
            //printf("will execute command %s| with path %s\n", cmd, cmd);
            execl(cmd, cmd, NULL);
            err(1, "execl failed");
        }
        wait(NULL);
        
    }

}
