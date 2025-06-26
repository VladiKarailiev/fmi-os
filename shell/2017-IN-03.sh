#!/bin/bash

bestFile=""
bestTime=0

while read -r line; 
do 
    dir=$(echo $line | cut -d ":" -f 6)
    #echo $dir

    for i in "$dir"/*; do
        
        if [[ ! -f $i ]]; then
            continue
        fi
        echo "checking $i"
        currTime=$(stat $i -c %Y 2>"/dev/null")

        if [[ $bestTime -lt $currTime ]]; then
            bestTime=$currTime
            bestFile=$i
        fi
    done
done < <( cat /etc/passwd  ) 

echo "$bestFile modified at: $bestTime"
