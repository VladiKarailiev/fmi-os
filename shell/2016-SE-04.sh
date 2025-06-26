#!/bin/bash


#mkdir a
#mkdir b
#mkdir c


if [[ "$#" -ne 2 ]];
then
    echo "Not 2 params"
    exit 1
fi

if [[ $1 -gt $2 ]]; 
then
    echo "First parameter can't be less than the second"
    exit 1
fi

for file in *; do
    if [[ -f $file ]]; then
        lines=$(wc -l $file | cut -d ' ' -f 1)
        echo "$file has $lines lines and is moved to: "
        if [[ $lines -lt $1 ]]; then
            mv $file "/a"
            echo "a"
        else
        if [[ $lines -lt $2 ]]; then
            mv $file "/b"
            echo "b"
        else
            mv $file "/c"
            echo "c"
        fi
        fi
        fi
done


