#!/bin/bash

all=$(mktemp)
replaces=$(mktemp)
files=$(mktemp)

token=$(pwgen 10 1)

for i in "$@"; do
    echo $i >> $all
done

grep "^-.*" $all > $replaces
grep "^[^-].*" $all > $files

while read -r line; do

    comm=$( echo $line | cut -d'R' -f2)
    from=$( echo $comm | cut -d'=' -f1)
    to=$( echo $comm | cut -d'=' -f2)

    while read -r file; do
        sed -i -e "s|\<$from\>|$token$to|g" $file
    done < $files


done < $replaces

while read -r file; do
   sed -i -e "s|$token||g" $file
done < $files

rm $all $replaces $files
