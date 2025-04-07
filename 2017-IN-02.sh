#!/bin/bash

temp=$(mktemp)
sorted=$(mktemp)

ps -e -o user,pid,%cpu,%mem,vsz,rss,tty,stat,time,command | tail -n +2 | head -n 100 >$temp

sort $temp >$sorted

lastUser=""
foo=$1
count=1
fooCount=1
totalTime=0
totalCount=1


while read -r line;
do
    user=$(echo $line | cut -d " " -f 1)
    (( totalCount++ ))
    timeStr=$(echo "$line" | grep -o -E "[0-9]{2}:[0-9]{2}:[0-9]{2}")

    if [[ -n "$timeStr" ]]; then
        hours=${timeStr%%:*}
        minutes=${timeStr%:*}
        minutes=${minutes#*:}
        seconds=${timeStr##*:}

        timeInSeconds=$((hours * 3600 + minutes * 60 + seconds))

        if [[ "$user" == "$foo" ]]; then
            ((fooCount++))
            totalSeconds=$((totalSeconds + timeInSeconds))
        fi
    fi

done < $sorted

totalSeconds=$(( totalSeconds / totalCount ))

totalHours=$((totalSeconds / 3600))
remainingSeconds=$((totalSeconds % 3600))
totalMinutes=$((remainingSeconds / 60))
totalSeconds=$((remainingSeconds % 60))

printf "Avg %s: %02d:%02d:%02d\n" "$foo" "$totalHours" "$totalMinutes" "$totalSeconds"



count=1

while read -r line;
do
    user=$(echo $line | cut -d " " -f 1)

    timeStr=$(echo "$line" | grep -o -E "[0-9]{2}:[0-9]{2}:[0-9]{2}")

    if [[ -n "$timeStr" ]]; then
    hours=${timeStr%%:*}
    minutes=${timeStr%:*}
    minutes=${minutes#*:}
    seconds=${timeStr##*:}

    timeInSeconds=$((hours * 3600 + minutes * 60 + seconds))

    if [[ $timeInSeconds -gt $totalSeconds ]]; then
        echo "Terminate $user $timeStr"
    fi
    fi


    if [[ $user = $lastUser ]]; then
        count=$(( count + 1 ))
    else

        if [[ $count -gt $fooCount ]]; then
        echo "$lastUser"
        fi
        #echo "$lastUser has $count processes"
        count=1
    fi
    lastUser=$user
done < $sorted

if [[ $count -gt $fooCount ]]; then
    echo "$lastUser"
fi

rm $temp
rm $sorted
