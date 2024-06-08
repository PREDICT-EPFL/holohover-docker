#!/bin/bash

source ./config.sh


for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
    if ! [ "${REMOTE_IPS[i]}" = "localhost" ]; then
        ssh ${REMOTE_IPS[i]} sudo init 6
    fi
done
