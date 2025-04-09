#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Should give 1 arg"
    exit 1
fi

if [[ $(echo $1 | cut -b 1-4) != $1 ]]; then
    echo "Not a valid name"
    exit 1
fi

if [[ $(cat wakeup | grep $1 | wc -l) -ne 0 ]]; then
    echo "vlezna"
    sed -i -e "s/\(^$1.*\)\*enabled/\1\*disabled/" wakeup
fi
cat wakeup
