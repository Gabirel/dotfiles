#!/bin/bash
if [ `id -u` -eq 0 ]; then
    wget https://raw.githubusercontent.com/racaljk/hosts/master/hosts -O /tmp/hosts
    sleep 1
    
    echo "remving /etc/hosts"
    rm /etc/hosts
    cp /tmp/hosts /etc/hosts
    rm /tmp/hosts
    
    sleep 1
    echo "/etc/hosts is updated"
else
    echo "Youd need root priviledge!"
fi


