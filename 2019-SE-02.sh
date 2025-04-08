#!/bin/bash



if [[ $1 == "-n" ]]; then
    n=$2
else n=10
fi


for i in $*; do

    idf=$( echo $i | cut -d "." -f1 )
    #echo $idf
    if [[ ! -f $i ]]; then
        continue
    fi

    while read -r line; do


        echo $line | awk -v id=$idf '{ printf "%s ", $1; printf "%s ", $2; printf "%s ", id;  for(i=3;i<=NF;i++) { printf "%s",$i}}'
        echo ""
    done < <(tail -n $n $i)

done
