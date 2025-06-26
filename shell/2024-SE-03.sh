#!/bin/bash


chords=$(mktemp)
echo -n "A Bb B C Db D Eb E F Gb G Ab" > $chords

#trqq da se naprai da prevurta ;)
transpose() {
    chord=$1
    amount=$2
    amount=$(( amount % 12 ))
    amount=$(( amount + 1 ))
    
    line=$(mktemp)
    cat $chords | sed -e "s|.*$chord\( .*\)|$chord\1 A Bb B C Db D Eb E F Gb G Ab|" > $line
    
#    echo "line: $(cat $line)"
    cat $line | cut -d' ' -f $amount
    rm $line
}

n=$1

transpose F 3


token=$(pwgen 10 1)
echo "token:$token"
while read -r line; do

    newLine=$(mktemp)
    echo $line > $newLine
    for i in $(cat $chords); do
        
        if [[ $i =~ .b ]]; then
        
            sed -i -e "s|\[$i\(.*\]\)|[${token}$(transpose $i $n)\1|g" $newLine
        else
        
           sed -i -e "s|\[$i\([^b].*\]\)|[${token}$(transpose $i $n)\1|g" $newLine
           sed -i -e "s|\[$i\]|[${token}$(transpose $i $n)]|g" $newLine

        fi
        
    done
    sed -i -e "s|$token||g" $newLine
    cat $newLine
    rm $newLine
done 

rm $chords
