#!/bin/bash


temp=$(mktemp)
pstemp=$(mktemp)


while read -r line
do
    uid=$(echo $line | cut -d ":" -f 3)
    home=$(echo $line | cut -d ":" -f 6)

    homePerms=$( stat --format %A $home 2>/dev/null | cut -c 3)
    homeOwner=$( stat --format %u $home 2>/dev/null )

    if [[ ! -e $home ]] || [[ $uid -ne $homeOwner ]] || [[ $homePerms != "w" ]] ; then
#        echo "ne sushtestvuva $home na $uid ili ne e sobvstenik (sobstvenika e ${homeOwner} s prava ${homePerms})"
        echo $uid >> $temp
    fi

#    echo $line
done < /etc/passwd

rootTotal=0

ps -e -o uid,rss | tail -n +2 | sort >$pstemp




while read -r user
do
    currUserPs=0
    while read -r process
    do
        memory=$(echo $process | cut -d ' ' -f 2)
        currUserPs=$(( currUserPs + memory ))
    done < <(grep "[[:space:]]${user}[[:space:]][0-9]*" $pstemp)
    echo "$user with memory: $currUserPs"
done < $temp

rm $pstemp
rm $temp
s0600319@astero:~/scripts$ ^C
s0600319@astero:~/scripts$ vim 2017-SE-06.sh
s0600319@astero:~/scripts$ ./2017-SE-06.sh
s0600319@astero:~/scripts$ cat 2017-SE-06.sh
#!/bin/bash


temp=$(mktemp)
pstemp=$(mktemp)


while read -r line
do
    uid=$(echo $line | cut -d ":" -f 3)
    home=$(echo $line | cut -d ":" -f 6)

    homePerms=$( stat --format %A $home 2>/dev/null | cut -c 3)
    homeOwner=$( stat --format %u $home 2>/dev/null )

    if [[ ! -e $home ]] || [[ $uid -ne $homeOwner ]] || [[ $homePerms != "w" ]] ; then
#        echo "ne sushtestvuva $home na $uid ili ne e sobvstenik (sobstvenika e ${homeOwner} s prava ${homePerms})"
        echo $uid >> $temp
    fi

#    echo $line
done < /etc/passwd

rootTotal=0

ps -e -o uid,rss | tail -n +2 | sort >$pstemp

rootMemory=0
while read -r process
do
    memory=$(echo $process | cut -d ' ' -f 2)
    rootMemory=$(( rootMemory + memory ))
done < <(grep "[[:space:]]0[[:space:]][0-9]*" $pstemp)

while read -r user
do
    currUserPs=0
    while read -r process
    do
        memory=$(echo $process | cut -d ' ' -f 2)
        currUserPs=$(( currUserPs + memory ))
    done < <(grep "[[:space:]]${user}[[:space:]][0-9]*" $pstemp)
    if [[ $currUserPs -gt $rootMemory ]]; then
        echo "Terminate $user ! "
    fi
done < $temp

rm $pstemp
rm $temp
