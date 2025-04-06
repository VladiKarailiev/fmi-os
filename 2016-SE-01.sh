#!/bin/sh

set +e

if [ ${#} -eq 0 ]
    then echo "Not enough params"
else
if [ -d $1 ]
    then

temp_file=$(mktemp)
find $1 -type l >$temp_file

while IFS= read -r line
do
    trash=$(readlink -e $line)
    if [ $? -ne 0 ]; then
        echo $line
    fi
done < $temp_file

else echo "Not a directory"
fi
fi
