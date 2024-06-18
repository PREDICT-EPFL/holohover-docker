#!/bin/bash

source ./config.sh

# Loop through each remote machine
for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
    if ${EMBEDDED_CONTROLLER[i]} ; then
        CMD="docker stop controller"
        
        echo ssh ${REMOTE_IPS[i]} $CMD
        ssh ${REMOTE_IPS[i]} $CMD
    fi
done
