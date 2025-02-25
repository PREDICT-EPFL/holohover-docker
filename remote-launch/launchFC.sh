#!/bin/bash

source "$(dirname "$0")/config.sh"


for ((i = 0; i < ${#FC_REMOTE_IPS[@]}; i++)); do
    if ping -c 1 ${FC_REMOTE_IPS[i]} &> /dev/null; then
        echo ssh ${FC_REMOTE_IPS[i]} /home/ubuntu/holohover-docker/remote-launch/launchFC_loc.sh ${FC_CONTROLLER[i]}
        ssh ${FC_REMOTE_IPS[i]} /home/ubuntu/holohover-docker/remote-launch/launchFC_loc.sh ${FC_CONTROLLER[i]} &
    else
        echo "Unable to reach ${FC_REMOTE_IPS[i]}"
    fi
done

wait
