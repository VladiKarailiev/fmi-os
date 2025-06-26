#!/bin/bash


dir=$1
arch=$2

bestFile=""
bestX=0
bestY=0
bestZ=0

while read -r file
do
    version=$(echo $file | cut -d "-" -f 2 )
    currArch=$(echo $file | cut -d "-" -f 3)
    
    x=$(echo $version | cut -d "." -f 1)
    y=$(echo $version | cut -d "." -f 2)
    z=$(echo $version | cut -d "." -f 3)


    if [[ $currArch != $arch ]]; then
        continue
    fi

    echo "currently best: $bestX.$bestY.$bestZ and the  current is $x.$y.$z"

    if [[ $x -gt $bestX ]]; then
        bestFile=$file
        bestX=$x
        bestY=$y
        bestZ=$z

    elif [[ $y -gt $bestY ]]; then
        bestFile=$file
        bestX=$x
        bestY=$y
        bestZ=$z
    elif [[ $z -gt $bestZ ]]; then        
        bestFile=$file
        bestX=$x
        bestY=$y
        bestZ=$z
    fi

done < <(find $dir -maxdepth 1 -regex .*/vmlinuz-\[0-9\]*\.\[0-9\]*\.\[0-9\]*-.*)

echo $bestFile
