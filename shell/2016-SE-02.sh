#!/bin/bash

if [[ $(id -u) -ne 0 ]]; then
    echo "Not root..."
    exit 1
fi

if [[ ${#} -ne 1 ]]
    then echo "Expected 1 arg"
    exit 1
fi

while IFS=" " read -r uid pid rss

do
    if [ -z $currUser ]; then
        currUser=$uid
        sum=0
        max=0
        maxPid=0
    fi

    if [ $currUser != $uid ]; then
        echo "$currUser with sum: $sum and max proccess: $maxPid : $max"
        
        if [ $sum -gt $1 ]; then
            echo "User $currUser exceeded max pss"
            echo kill -TERM $maxPid
        fi
        currUser=$uid
        sum=0
        max=0
        maxPid=0
    fi
        sum=$(( rss+sum ))

        if [ $max -le $rss ]; then
            max=$rss
            maxPid=$pid
        fi

done < <(ps -e -o uid,pid,rss --sort -uid | head -n 100)



