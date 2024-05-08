#!/bin/bash


# List of remote IP addresses and machine names
REMOTE_IPS=("10.10.10.14" "localhost")
MACHINE_NAMES=("la013" "eddai")

# COMMAND="~/holohover-docker/launch_docker.sh experiment1.yaml admm"
COMMAND="echo ciao!"

# Loop through each remote machine
for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
    CMD="$COMMAND ${MACHINE_NAMES[i]} > /tmp/mylogfile 2>&1 &"
    echo ssh ${REMOTE_IPS[i]} $CMD
    ssh ${REMOTE_IPS[i]} $CMD
done
