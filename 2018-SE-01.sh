#!/bin/bash

dir=$1
counter=$(mktemp)
sorted=$(mktemp)
output=$(mktemp)
while read -r file
do
    friend=$(echo $file | cut -d '/' -f 4)

    echo "$friend $(wc -l $file | cut -d ' ' -f 1)" >> $counter

done < <(find $dir -type f)

sort $counter >$sorted

lastFr=""
total=0
while read -r log
do
    fr=$( echo $log | cut -d ' ' -f 1)
    lines=$( echo $log | cut -d ' ' -f 2)

    if [[ $lastFr == $fr ]]; then
        total=$(( total + lines ))
    else
      if [[ $lastFr != "" ]]; then
        echo "$lastFr $total" >> $output
      fi
    total=$lines
    fi
    lastFr=$fr
done < $sorted

echo "$lastFr $total" >> $output

cat $output | sort | head
rm $counter
rm $sorted
rm $output
