#!/bin/bash


# List of remote IP addresses and machine names
REMOTE_IPS=("localhost")
MACHINE_NAMES=("master")
IMAGE_NAMES=("holohover")

LAUNCH_FILE="mult.dmpc.simulation.launch.py"
OPT_ALG="admm"
EXPERIMENT_FILE="experiment1.yaml"

LOG_FILE="~/holohover-docker/log/console-$(date +"%Y_%m_%d_%I_%M_%S").log"

COMMAND="echo ciao!"

# Loop through each remote machine
for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
    COMMAND="~/holohover-docker/launch_docker.sh ${IMAGE_NAMES[i]} $LAUNCH_FILE $EXPERIMENT_FILE $OPT_ALG"

    CMD="$COMMAND ${MACHINE_NAMES[i]} > $LOG_FILE 2>&1 &"
    echo ssh ${REMOTE_IPS[i]} $CMD
    ssh ${REMOTE_IPS[i]} $CMD
done
