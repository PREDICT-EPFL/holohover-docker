#!/bin/bash

source "$(dirname "$0")/config.sh"


for ((i = 0; i < ${#FC_REMOTE_IPS[@]}; i++)); do
    if ! [ "${FC_REMOTE_IPS[i]}" = "localhost" ]; then
        ssh ${FC_REMOTE_IPS[i]} sudo init 0 &
    fi
done
wait
