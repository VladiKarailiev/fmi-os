#!/bin/bash

dir=$1
file=$2

temp=$(mktemp)
sorted=$(mktemp)
while read -r line
do
    person=$(echo $line | cut -d ':' -f1 | cut -d '(' -f1)
    echo $person >> $temp
done < $file

sort $temp > $sorted

touch "$dir/dict.txt"
i=0
while read -r entry
do
    i=$(( i + 1 ))
    echo "$entry; $i" >> "$dir/dict.txt"
done < <(cat $sorted | uniq)

cat "$dir/dict.txt"

rm $temp
rm $sorted
