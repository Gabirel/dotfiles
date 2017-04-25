#!/bin/bash
wget https://raw.githubusercontent.com/racaljk/hosts/master/hosts -O /tmp/hosts
sleep 1

echo "remving /etc/hosts"
rm /etc/hosts
cp /tmp/hosts /etc/hosts
rm /tmp/hosts

sleep 1
echo "/etc/hosts is updated"

