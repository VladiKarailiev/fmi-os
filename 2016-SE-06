#!/bin/bash

file="books.txt"
temp=$(mktemp)
sorted=$(mktemp)
nr=1

while read -r line
do
    line=$(echo $line | sed -E 's/[0-9][0-9][0-9][0-9] г. - //g')
    echo "${nr}. $line" >> $temp
    nr=$((nr+1))
done < $file
sort -k2 "$temp" > $sorted
cat $sorted
rm $temp
rm $sorted
