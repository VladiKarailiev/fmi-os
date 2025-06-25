#!/bin/bash

src=$1
dst=$2

cp -r $src $dst

while read -r file; do
    file=$(echo $file | sed "s/$src/$dst/g")
    rm $file
done < <(find $src -regex "${src}/\..*\..*\.swp")
