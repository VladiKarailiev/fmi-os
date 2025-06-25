#!/bin/bash

file1=$1
br1=0
while read -r line
do
    artist=$(echo $line | cut -d ' ' -f 2)
    if [[ $artist = $1 ]]; then
     br1=$(( br1 + 1 ))
    fi
done < $1

file2=$2
br2=0
while read -r line
do
    artist=$(echo $line | cut -d ' ' -f 2)
    if [[ $artist = $2 ]]; then
     br2=$(( br1 + 1 ))
    fi
done < $2

if [[ $1 -gt $2 ]]; then
    file=$1
    else
    file=$2
    fi
touch "$file.songs"
cut $file -d "-" -f 2 | sort | sed -E "s/ \"/\"/g" > "$file.songs"
