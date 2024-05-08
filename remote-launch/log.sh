#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "$0 - Wrong number of parameters"
    echo "Usage:"
    echo "   $0 IP INDEX"
    exit -1
fi

port=$((5000 + $2))

tail -f ~/holohover-docker/log/console-2024_05_08_23_38_35.log | nc $1 $port
