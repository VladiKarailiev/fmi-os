#!/bin/bash

if [[ $# -ne "3" ]]; then
    exit 1
fi

src=$1
dst=$2
str=$3

if [[ ! -d $src ]] || [[ ! -d $dst ]]
    then echo "SRC and DST need to be directories"
elif [[ ! -z $(ls -A $dst) ]]
    then echo "DST needs to be empty!"
fi

find $1 -regex ".*${str}.*" -exec mv -i {} $dst \;


