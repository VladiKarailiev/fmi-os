#!/bin/bash

file="z1.txt"
s1="ENABLED_OPTIONS"
s2="ENABLED_OPTIONS_EXTRA"

s1+="="
s2+="="

value1=$(grep "$s1" "$file" | cut -d "=" -f2)
value2=$(grep "$s2" "$file" | cut -d "=" -f2)

value3=""


for i in $value2; do
     echo $value1 | grep "$i" >"/dev/null"
     if [[ "$?" -ne 0 ]]; then
        value3+="$i "
    fi
done

sed -E "s/$s2.*\$/$s2$value3/g" < $file
