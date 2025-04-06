#!/bin/bash

while read -r line; do
    user=$(echo $line | cut -d ':' -f 1)
    home=$(echo $line | cut -d ':' -f 6)

    if [[ $home =~ ^/home/* ]];
    then

        writeRight=$( ls -ld $home | cut -d ' ' -f 1 | cut -c 3 )

        if [[ "$writeRight" != "w" ]];
        then
            echo $line
        fi
    else
        echo $line
    fi


done < /etc/passwd
