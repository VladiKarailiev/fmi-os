#!/bin/bash

if [[ $# -ne 3 ]]; then
    echo "Should be given 3 args"
    exit 1
fi

if [[ ! -f $2 ]] || [[ ! -f $3 ]]; then
    echo "Not valid files"
    exit 1
fi


lineLeft=$(cat $2 | grep "$1" | sed "s/^.*:[[:space:]]*\(.*\)[[:space:]]*megaparsecs/\1/g")
lineRight=$(cat $3 | grep "$1"| sed "s/^.*:[[:space:]]*\(.*\)[[:space:]]*megaparsecs/\1/g")

if [[ $lineLeft -lt $lineRight ]]; then
    echo "$2"
    else
    echo "$3"
fi
