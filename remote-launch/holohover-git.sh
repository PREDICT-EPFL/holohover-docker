#!/bin/bash

source ./config.sh


for ((i = 0; i < ${#FC_REMOTE_IPS[@]}; i++)); do
    ssh ${REMOTE_IPS[i]} "cd holohover-docker && git pull"
done

wait
