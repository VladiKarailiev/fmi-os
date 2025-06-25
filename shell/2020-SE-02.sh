#!/bin/bash

file=$1

hostCount=$(mktemp)
uniqueHosts=$(mktemp)
top=$(mktemp)


while read -r line
do
#    echo "line= $line"
    host=$(echo $line | cut -d " " -f2)

    requests=$(grep -e ".* $host .*" $file | wc -l)
    found=$(grep $host $hostCount | wc -l)
    if [[ $found -eq 0 ]]; then
        echo "$host:$requests " >> $hostCount
    fi

done < $file

sort $hostCount -k2 | tail -n 3 > $top

while read -r line
do
    clients=$(mktemp)

    host=$(echo $line | cut -d ':' -f1)
    nontwo=$(echo $line | cut -d ":" -f2)
    two=$(grep "$host.*HTTP/2.0 .*" $file | wc -l)
    echo -n "$host "
    echo -n "HTTP/2.0: $two "
    echo -n "non-HTTP2: $(( nontwo - two )) "
    echo ""
    while read -r req; do

        ip=$(echo $req | cut -d ' ' -f1)
        count=0
        clientStatuses=$(mktemp)

        grep -e "$ip $host" $file | cut -d ' ' -f9 > $clientStatuses

        while read -r status; do
            if [[ $status -gt 302 ]]; then
                count=$(( count + 1 ))
            fi
        done < $clientStatuses
        if [[ $(grep $ip $clients | wc -l) -eq 0 ]]; then
            echo "$count $ip" >> $clients
        fi
    done < <(grep ".* $host .*" $file | sort | uniq)
    sort -n -r $clients | head -n 5
    echo ""
done < $top

rm $hostCount
rm $uniqueHosts
rm $top
