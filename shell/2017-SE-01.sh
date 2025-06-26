#!/bin/bash



if [[ ! -d $1 ]]; then
    echo "Not a dir"
    exit 1
fi

if [[ "$#" -eq "0" ]]; then
    echo "Not enough args"
    exit 1
fi

dir=$1

if [[ $# -gt 1 ]]; then

if [[ $# -ne 2 ]]; then
    echo "Too many args"
    exit 1
fi

for i in "$dir"/*; 
do 
    if [[ ! -f $i ]]; then
        continue
    fi
    
    count=$( find $i -links +"$2" | wc -l)

    if [[ $count -gt 0 ]]; then
        echo "$i file has enough hardlinks"
    fi

done

else

    while read -r link; 
    do
    cat $link 2>"/dev/null" >"/dev/null"
    if [[ $? -ne 0 ]]; then
        echo "$link is a broken symlink"
    fi
    done < <(find $dir -type l)

fi






