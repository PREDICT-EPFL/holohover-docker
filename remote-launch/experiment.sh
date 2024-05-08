#!/bin/bash

source ./config.sh

# Loop through each remote machine
for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
    COMMAND="~/holohover-docker/remote-launch/launch_docker.sh ${IMAGE_NAMES[i]} $LAUNCH_FILE $EXPERIMENT_FILE $OPT_ALG"

    CMD="$COMMAND ${MACHINE_NAMES[i]} > $LOG_FILE 2>&1 &"
    echo ssh ${REMOTE_IPS[i]} $CMD
    ssh ${REMOTE_IPS[i]} $CMD
done
