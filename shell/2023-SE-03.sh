#!/bin/bash

#stopwords script

if [[ $# -ne 1 ]]; then
    exit 1
fi

if [[ ! -d $1 ]]; then
    exit 1
fi

dir=$1
dict=$(mktemp)
sorted=$(mktemp)

while read -r file; do
    currDict=$(mktemp)
    for word in $(cat $file)
    do
        clean=$(echo $word |  sed -e "s/\([A-Z]\)/\L\1/g" | grep -i -o -e "\<[a-z][a-z]*’*[a-z]*\>")
        echo $clean >> $currDict
    done
    
    cat $currDict >> $dict
    rm $currDict
done < <( find $dir -type f )

filesCount=$(find $dir -type f | wc -l)

sort $dict | uniq -c | sort -nr > $sorted

sed -i 's/^[[:space:]]*//' $sorted
results=0
while read -r word; do

    count=0

    while read -r file; do
        if [[ $(cat $file | grep -i -o "$word" | wc -l) -gt 3 ]]; then
            count=$(( count + 1 ))
        fi
    done < <( find $dir -type f)

    if [[ $count -gt $((filesCount / 2 )) ]]; then
        echo $word
        results=$((results + 1))
        if [[ $results -eq 10 ]]; then
            exit 0
        fi
    fi

done < <(cat $sorted | cut -d" " -f2 )



rm $dict $sorted


