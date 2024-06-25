#!/bin/bash

source remote-launch/config.sh


for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
    if ! [ "${REMOTE_IPS[i]}" = "localhost" ]; then
        CMD="docker pull 192.168.0.70:5000/${IMAGE_NAMES[i]} && docker tag 192.168.0.70:5000/${IMAGE_NAMES[i]} ${IMAGE_NAMES[i]} && docker image prune -f"

        echo ssh ${REMOTE_IPS[i]} $CMD
        ssh ${REMOTE_IPS[i]} $CMD &
    fi
done

wait
cd remote-launch
bash ./stopDocker.sh
cd -
