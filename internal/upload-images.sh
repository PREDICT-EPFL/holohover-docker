#!/bin/bash

source remote-launch/config.sh


for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
    if ! [ "${REMOTE_IPS[i]}" = "localhost" ]; then
        if ping -c 1 ${REMOTE_IPS[i]} &> /dev/null; then
            CMD="docker pull 192.168.0.70:5000/${IMAGE_NAMES[i]} && docker tag 192.168.0.70:5000/${IMAGE_NAMES[i]} ${IMAGE_NAMES[i]} && docker image prune -f"

            echo ssh ${REMOTE_IPS[i]} $CMD
            ssh ${REMOTE_IPS[i]} $CMD &
        else
            echo "Ping to ${REMOTE_IPS[i]} failed"
        fi
    fi
done

for ((i = 0; i < ${#FC_REMOTE_IPS[@]}; i++)); do
    if ! [ "${FC_REMOTE_IPS[i]}" = "localhost" ]; then
        if ping -c 1 ${FC_REMOTE_IPS[i]} &> /dev/null; then
            CMD="docker pull 192.168.0.70:5000/${IMAGE_NAMES[i]} && docker tag 192.168.0.70:5000/${IMAGE_NAMES[i]} ${IMAGE_NAMES[i]} && docker image prune -f"

            echo ssh ${FC_REMOTE_IPS[i]} $CMD
            ssh ${FC_REMOTE_IPS[i]} $CMD &
        else
            echo "Ping to ${FC_REMOTE_IPS[i]} failed"
        fi
    fi
done

wait

echo
echo "Stopping Docker daemons"
cd remote-launch
bash ./stopDocker.sh
cd -
