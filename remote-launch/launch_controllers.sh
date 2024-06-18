#!/bin/bash

source ./config.sh

if [ "$#" -ne 1 ]; then
    echo "$0 - Wrong number of parameters"
    echo "Usage:"
    echo "   $0 EXPERIMENT_FILE"
    exit -1
fi

EXPERIMENT_FILE=$1

# Loop through each remote machine
for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
    if ${EMBEDDED_CONTROLLER[i]} ; then
        COMMAND="/home/${USERS[i]}/holohover-docker/remote-launch/controller.sh ${IMAGE_NAMES[i]} $EXPERIMENT_FILE ${MACHINE_NAMES[i]}"
        
        echo ssh ${REMOTE_IPS[i]} $COMMAND
        ssh ${REMOTE_IPS[i]} $COMMAND
    fi
done
