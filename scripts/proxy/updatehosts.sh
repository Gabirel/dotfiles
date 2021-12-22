#!/bin/bash
if [ `id -u` -eq 0 ]; then
    wget https://raw.githubusercontent.com/googlehosts/hosts/master/hosts-files/hosts -O /tmp/hosts
    sleep 1
    
    echo "removing /etc/hosts"
    rm /etc/hosts
    cp /tmp/hosts /etc/hosts
    rm /tmp/hosts
    
    sleep 1
    echo "/etc/hosts is updated"
else
    echo "Youd need root priviledge!"
fi


