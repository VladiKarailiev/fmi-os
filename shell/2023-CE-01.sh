#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo "not 2 args"
    exit 1
fi

csv=$1
star_type=$2

constelations=$(mktemp)

cat $csv | cut -d',' -f4 | sort | uniq > $constelations

ranking=$(mktemp)
while read -r con; do

    echo "$con:$(grep ".*,$con,$star_type,.*" $csv | wc -l)" >> $ranking
done < $constelations
constelation=$(sort -n -k2 $ranking | head -n 1 | cut -d":" -f1)

stars=$(mktemp)
cat $csv | grep ".*,$constelation,.*" > $stars

cat $stars | sort -t',' -n -k7 | tail -n 1
rm $stars $constelations $ranking
