#!/bin/bash

lastUid=""
count=0
total=0
userBestSize=0
userBestPID=""

while read -r line; 
do
    currUid=$( echo $line | cut -d " " -f 1)
    currPss=$( echo $line | cut -d " " -f 3)
    currPID=$( echo $line | cut -d " " -f 2)
    if [[ $currUid == $lastUid ]]; then
        count=$(( count + "1" ))
        total=$(( total + currPss ))
        if [[ $currPss -gt $userBestSize ]]; then
            userBestSize=$currPss
            userBestPID=$currPID
        fi
    else
        if [[ $count -eq 0 ]]; then
            continue
        fi

        echo "$lastUid has $count processes with $total memory"

        if [[ $(( total / count )) -lt $userBestSize ]]; then
            echo "Process $userBestPID should be terminated."
        fi
        lastUid=$currUid
        total=$currPss
        count=1
        userBestSize=$currPss
        userBestPID=$currPID

    fi

done < <(ps -e -o uid,pid,rss | sort )
