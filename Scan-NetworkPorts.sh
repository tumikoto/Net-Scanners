#!/usr/bin/env bash

if [ "$3" == "" ]
then
    echo "Usage:"
    echo "    ./Scan-NetworkPorts.sh <target_ip> <first_port> <last_port>"
    echo " "
    echo "Example:"
    echo "    ./Scan-NetworkPorts.sh 192.168.1.5 1 1024"
else
    targetip=$1
    minport=$2
    maxport=$3

    for port in `seq $minport $maxport`; do
        timeout 1 bash -c "echo >/dev/tcp/$targetip/$port" &&
            echo "Port $port is open!" ||
                echo "Port $port is closed."
    done
fi
