#!/bin/bash

source ./config.sh

# Loop through each remote machine
for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
    COMMAND="sudo docker stop ${IMAGE_NAMES[i]}"

    #CMD="$COMMAND ${MACHINE_NAMES[i]} > $LOG_FILE 2>&1 &"
    echo ssh ${REMOTE_IPS[i]} $COMMAND
    ssh ${REMOTE_IPS[i]} $COMMAND
done
