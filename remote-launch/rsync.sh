#!/bin/bash

source "$(dirname "$0")/config.sh"

for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
    if ! [ "${REMOTE_IPS[i]}" = "localhost" ]; then
        if ping -c 1 "${REMOTE_IPS[i]}" &> /dev/null; then
            echo "Pinging ${REMOTE_IPS[i]} successful. Starting rsync..."
            echo rsync -av ~/holohover-docker/ws/src ${USERS[i]}@${REMOTE_IPS[i]}:~/holohover-docker/ws
            rsync -av ~/holohover-docker/ws/src ${USERS[i]}@${REMOTE_IPS[i]}:~/holohover-docker/ws &
        else
            echo "Failed to ping ${REMOTE_IPS[i]}. Skipping rsync."
        fi
    fi
done

wait
