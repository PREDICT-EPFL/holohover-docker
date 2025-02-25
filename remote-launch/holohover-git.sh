#!/bin/bash

source "$(dirname "$0")/config.sh"


for ((i = 0; i < ${#FC_REMOTE_IPS[@]}; i++)); do
    echo ssh ${FC_REMOTE_IPS[i]} "cd holohover-docker && git pull"
    ssh ${FC_REMOTE_IPS[i]} "cd holohover-docker && git pull"
done

for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
    echo ssh ${REMOTE_IPS[i]} "cd holohover-docker && git pull"
    ssh ${REMOTE_IPS[i]} "cd holohover-docker && git pull"
done

wait
