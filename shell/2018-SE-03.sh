#!/bin/bash

src=$1
dst=$2

temp=$(mktemp)
res=$(mktemp)
touch $2

while read -r line
do
    echo $line | awk -F"," '{ for(i=2;i<NF;i++) {printf "%s,", $i} printf "%s", $NF}' > $temp
    
    min=$(echo $line | cut -d ',' -f1)
    while read -r copy
    do
        curr=$(echo $copy | cut -d ',' -f1)
        if [[ $min -gt $curr ]]; then
            min=$curr
        fi
    done < <(grep "$(cat $temp)" $1)
    
    echo "$min,$(cat $temp)" >> $res

done < <(sort -k 2 --field-separator="," $1)

uniq $res > $dst

rm $res
rm $temp

