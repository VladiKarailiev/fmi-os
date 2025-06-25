#!/bin/bash
sed -i -e "s/^\($2[[:space:]]*=[[:space:]]*\)\([^# ]*\)\([[:space:]]*#.*\)/# \1\2\3 # edited at $(date) by $(whoami)\n\1$3 # added at $(date) by $(whoami)/g" $1
if [[ $(cat $1 | grep "^[[:space:]]*$2" | wc -l) -eq 0 ]]; then
    echo "$2 = $3 # added at $(date) by $(whoami)" >> $1
fi
