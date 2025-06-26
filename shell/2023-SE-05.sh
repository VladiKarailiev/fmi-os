# Should pass an argument instead of using 65535
#!/bin/bash

mems=$(mktemp)
globalCount=1
psout=$(mktemp)
results=$(mktemp)

if [[ $# -ne 1 ]]; then
    echo "should give a number (min memory)"
    exit 1
fi

n=$1

while [[ globalCount -gt 0 ]]; do
ps -eo comm,pss | tail -n +2 | sort > $psout
globalCount=0



> $mems
while read -r line; do


    

    comm=$(echo $line | awk '{print $1}')
    pss=$(echo $line | awk '{print $2}')
    
#    echo "$comm with $pss"    
    if ! [[ "$pss" =~ ^[0-9]+$ ]]; then
            continue
    fi
 #   echo "alabala"

    
    escaped_comm=$(echo "$comm" | sed 's/[][\/\.*^$]/\\&/g')

    if grep -q "^$escaped_comm[[:space:]]" "$mems"; then
        
        currVal=$(grep "^$escaped_comm " $mems | awk '{print $NF}')
        newVal=$(( currVal + pss ))
        sed -i -e "s|^\($escaped_comm[[:space:]]*\)$currVal|\1$newVal|" $mems

        else
            echo "$comm $pss" >> "$mems"
    fi

done < $psout

#cat $mems


while read -r line; do
    val=$(echo $line | awk '{print $NF}')
    comm=$(echo $line | awk '{print $1}')

    if ! [[ "$val" =~ ^[0-9]+$ ]]; then
            continue
    fi

    if [[ $val -gt $n ]]; then
        globalCount=1
        escaped_comm=$(echo "$comm" | sed 's/[][\/\.*^$]/\\&/g')        

        if grep -q "^$escaped_comm[[:space:]]" "$results"; then
         currVal=$(grep "^$escaped_comm[[:space:]]" $results | awk '{print $NF}')
         if ! [[ "$currVal" =~ ^[0-9]+$ ]]; then
            continue
         fi
         newVal=$(( currVal + 1 ))
         sed -i -e "s|^\($escaped_comm[[:space:]]*\)$currVal|\1$newVal|" $results
        
        else
            echo "$comm 1" >> $results
         fi
    fi
done < $mems
#echo "=::::::::::::::::::::::::::::::::::::::::::::::="
#cat $results
#echo "=::::::::::::::::::::::::::::::::::::::::::::::="

counter=$(( counter + 1))
sleep 1
#globalCount=0
done 


counter=$(( counter / 2 ))
while read -r line; do
    
    occurs=$(echo $line | awk '{print $NF}')

    if [[ $occurs -gt $counter ]]; then
        echo $(echo $line | awk '{print $1}')
    fi

done < $results


rm $mems $results $psout
