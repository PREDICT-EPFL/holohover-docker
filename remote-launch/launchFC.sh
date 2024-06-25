#!/bin/bash

source ./config.sh


for ((i = 0; i < ${#FC_REMOTE_IPS[@]}; i++)); do
    ssh ${FC_REMOTE_IPS[i]} /home/ubuntu/holohover-docker/remote-launch/launchFC_loc.sh ${FC_CONTROLLER[i]}  &
done

wait
