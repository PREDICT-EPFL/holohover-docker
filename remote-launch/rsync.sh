#!/bin/bash

source ./config.sh

for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
    if ! [ "${REMOTE_IPS[i]}" = "localhost" ]; then
        echo rsync -av ~/holohover-docker/ws/src ${REMOTE_IPS[i]}:~/holohover-docker/ws
        rsync -av ~/holohover-docker/ws/src ${REMOTE_IPS[i]}:~/holohover-docker/ws &
    fi
done

wait
