#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "$0 - Wrong number of parameters"
    echo "Usage:"
    echo "   $0 FILE IP INDEX"
    exit -1
fi

port=$((5000 + $3))

tail -f $1 | nc $2 $port
