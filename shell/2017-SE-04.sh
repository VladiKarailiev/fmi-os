#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Not enough args"
    exit 1
fi

dir=$1

if [[ ! -d $dir ]]
    then echo "no such directory!"
    exit 1
fi


count=0

while read -r link;
do
    if [[ -e $link ]]; then

        if [[ $# -eq 2 ]]; then
            echo "$link -> $( readlink $link )" >>$2
        else
            echo "$link -> $( readlink $link )"
        fi
    else
        count=$(( count + "1" ))
    fi
done < <(find $dir -type l)

if [[ $# -eq 2 ]]; then
    echo "Broken symlinks: $count" >>$2
else
    echo "Broken symlinks: $count"
fi
