#!/bin/bash

source ./config.sh


for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
    if ${EMBEDDED_CONTROLLER[i]}; then
	    ssh ${REMOTE_IPS[i]} /home/ubuntu/holohover-docker/remote-launch/launchFC_loc.sh ${CONTROLLER[i]}  &
    fi
done

wait
