#!/bin/bash

base="base.csv"
prefix="prefix.csv"

if [[ $# -ne 3 ]]; then
    echo "Expected 3 args"
    exit 1
fi

num=$1

mult=$( cat prefix.csv | grep "$2" | cut -d',' -f3 )

if [[ $? -eq 0 ]]; then
    echo "Not found prefix"
    exit 1
fi


unit=$( cat base.csv | grep ",$3," | cut -d',' -f1 )

if [[ $? -eq 0 ]]; then
    echo "Not found unit"
    exit 1
fi

measure=$(cat base.csv | grep ",$3," | cut -d',' -f3)

if [[ $? -eq 0 ]]; then
    echo "Not found measure"
    exit 1
fi

num=$(echo "$num * $mult" | bc)
echo "$num $3 ($measure, $unit)"


