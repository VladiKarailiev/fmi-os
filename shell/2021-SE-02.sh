#!/bin/bash

date=$(date +"%Y%m%d")

soa=$(cat $1 | grep ".* SOA .*")
if [[ -z $soa ]]; then
    exit 1
fi

if [[ $(echo $soa | grep "(" | wc -l) -ne 0 ]]; then
    serial=$(cat $1 | grep -A 1 "SOA" | tail -n 1 | cut -d ";" -f1)
    else

    serial=$(echo $soa | cut -d ' ' -f7 )
fi

if [[ $(echo $serial | grep "$date" | wc -l) -ne 0 ]]; then
    nr=$(echo $serial | cut -b 9-10)
    nr=$(( nr + 1 ))
    if [[ $nr -lt 10 ]]; then
        newSerial="${date}0$nr"
    else
    newSerial="$date$nr"
    fi
    sed -i -e "s/$serial/$newSerial/g" $1
else
    newSerial="${date}01"
    sed -i -e "s/$serial/$newSerial/g" $1
fi
cat $1
