#!/usr/bin/env bash

if [ "$1" == "" ]
then
    echo "Usage:"
    echo "./Scan-NetworkHosts.sh <ip_subnet>"
    echo " "
    echo "Example:"
    echo "./Scan-NetworkHosts.sh 192.168.1"
else
    for x in `seq 1 254`; do
        ping $1.$x -c 1 | grep "64 bytes" | cut -d " " -f 4 | cut -d ":" -f 1
    done
fi
