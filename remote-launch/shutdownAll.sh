#!/bin/bash

source "$(dirname "$0")/config.sh"


for ((i = 0; i < ${#FC_REMOTE_IPS[@]}; i++)); do
    if ! [ "${FC_REMOTE_IPS[i]}" = "localhost" ]; then
        if ping -c 1 -W 1 "${FC_REMOTE_IPS[i]}" > /dev/null 2>&1; then
            echo ssh ${FC_REMOTE_IPS[i]} sudo init 0
            ssh ${FC_REMOTE_IPS[i]} sudo init 0 &
        else
            echo "Host ${FC_REMOTE_IPS[i]} is unreachable"
        fi
    fi
done
wait
