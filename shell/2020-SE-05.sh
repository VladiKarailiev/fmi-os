#!/bin/bash

pwdFile=$1
config=$2
dir=$3
rm $config
touch $config

while read -r file
do
    i=0
    errors=$(mktemp)
    
    while read -r line
    do
        
        i=$(( i+1 ))
        
        if [[ -z $line ]]; then
            continue
        fi
        comm=$( echo $line | grep "^[[:space:]]*#.*" | wc -l)
        code=$( echo $line | grep "^[[:space:]]*{ .* };[[:space:]]*\$" | wc -l)
        if [[ $(( comm + code )) -eq 0 ]]; then
            echo "Line $i:$line" >> $errors
        fi
    done < $file

    if [[ $(cat $errors | wc -l) -ne 0 ]]; then
        echo "Error in $file:"
        cat $errors
    
    else
        cat $file >> $config
        

        user=$(basename "$file")
        if [[ $(echo $pwdFile | grep "^$user:\[0-9\]*\$" | wc -l ) -eq 0 ]]; then
            pass=$(pwgen 16 1)
            echo "$user:$pass" >> $pwdFile
            echo "$user $pass"
        fi

    fi

done < <( find $dir -regex ".*.cfg" )
