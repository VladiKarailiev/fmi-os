#!/bin/bash

input=$(mktemp)

max=0
maxSum=0

digits()
{
    num=$1
    sum=0

    while [[ $num -gt 0 ]]
    do
    digit=$(( num % 10))
    sum=$(( sum + digit ))
    num=$(( num / 10 ))

    done
    
    echo $sum
}

while read -r line; do
    if [[ $line == "exit" ]]; then
        break
    fi

    positive=$(echo $line | grep -e "^[0-9]*$")
    negative=$(echo $line | grep -e "^-[0-9]*$")
    echo $line >> $input

    if [[ -z $positive ]] && [[ -z $negative ]]; then
        echo "$line ne e chislo"
        continue
    elif [[ ! -z $negative ]]; then
        line=$(( line * -1 ))
    fi
    
    if [[ $(digits $line) -gt $maxSum ]]; then
        maxSum=$(digits $line)
    fi

    if [[ $line -gt $max ]]; then
        max=$line
    fi

    echo $(digits $line)    

done

echo "max digits sum: $maxSum"

grep -e "^-$max$" $input | uniq
grep -e "^$max$" $input | uniq
