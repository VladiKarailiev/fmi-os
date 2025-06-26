#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <err.h>
#include <sys/wait.h>

#define MAX_PARAM_LEN 4

int main(int argc, char* argv[]) {
    char* cmd;

    if (argc == 1) {
        cmd = "echo";
    } else if (argc == 2) {
        if (strlen(argv[1]) > MAX_PARAM_LEN) {
            errx(2, "too long");
        }
        cmd = argv[1];
    } else {
        errx(1, "params?");
    }

    char word[MAX_PARAM_LEN + 1];  
    int idx = 0;

    char* args[3];  // cmd, param1, param2, NULL
    int arg_count = 0;

    char c;
    while (read(0, &c, 1) == 1) {
        if (c == ' ' || c == '\n') {
            if (idx == 0) continue; 

            word[idx] = '\0';


            args[arg_count] = malloc(strlen(word) + 1);
            if (!args[arg_count]) err(6, "malloc failed");
            strcpy(args[arg_count], word);

            idx = 0;
            arg_count++;
            if (arg_count == 2) {

                pid_t pid = fork();
                if (pid == -1) err(4, "fork failed");

                if (pid == 0) {
                    execlp(cmd, cmd, args[0], args[1], NULL);
                    err(5, "execlp failed");
                }

                wait(NULL);
                free(args[0]);
                free(args[1]);
                arg_count = 0;
            }
        } else {
            if (idx >= MAX_PARAM_LEN) {
                errx(3, "too long param");
            }
            word[idx++] = c;
        }
    }


    if (idx > 0) {
        word[idx] = '\0';
        args[arg_count] = malloc(strlen(word) + 1);
        if (!args[arg_count]) err(6, "malloc failed");
        strcpy(args[arg_count], word);
        arg_count++;
    }

    if (arg_count > 0) {
        pid_t pid = fork();
        if (pid == -1) err(4, "fork failed");

        if (pid == 0) {
            if (arg_count == 1)
                execlp(cmd, cmd, args[0], NULL);
            else
                execlp(cmd, cmd, args[0], args[1], NULL);
            err(5, "execlp failed");
        }
        wait(NULL);
        for (int i = 0; i < arg_count; i++) {
            free(args[i]);
        }
    }

    return 0;
}

