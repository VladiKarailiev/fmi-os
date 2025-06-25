#!/bin/bash

file=$1
dir=$2


touch $file

echo "hostname,phy,vlans,hosts,failover,VPN-3DES-AES,peers,VLAN Trunk Ports,license,SN,key" >> $file


while read -r i
do
    OFS=','
    echo -n "$(basename $i .log)," >> $file
    echo -n "$(grep "Maximum Physical Interfaces" $i | cut -d ":" -f 2 )," >> $file
    echo -n "$(grep "VLANs" $i | cut -d ":" -f 2)," >> $file
    echo -n "$(grep "Inside" $i | cut -d ":" -f 2)," >> $file
    echo -n "$(grep "Failover" $i | cut -d ":" -f2)," >> $file
    echo -n "$(grep "VPN-3DES" $i | cut -d ":" -f2)," >> $file
    echo -n "$(grep "*Total VPN" $i | cut -d ":" -f2)," >> $file
    echo -n "$(grep "VLAN Trunk" $i | cut -d ":" -f2)," >> $file
    echo -n "$(grep "This platform has" $i | cut -d' ' -f5-)," >> $file
    echo -n "$(grep "Serial" $i | cut -d ":" -f2)," >> $file
    echo "$(grep "Key" $i | cut -d ":" -f2)" >> $file
done < <(find $dir -regex ".*\.log$")
