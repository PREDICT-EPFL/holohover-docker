#!/bin/bash

source "$(dirname "$0")/config.sh"


# Loop through each remote machine
for ((i = 0; i < ${#FC_REMOTE_IPS[@]}; i++)); do
    # Ping the remote machine to check if it's reachable
    if ping -c 1 ${FC_REMOTE_IPS[i]} &> /dev/null; then
        COMMAND="sudo docker exec holohover-light-aa /bin/bash /root/stop_fc.sh"

        echo ssh ${FC_USERS[i]}@${FC_REMOTE_IPS[i]} $COMMAND
        ssh ${FC_USERS[i]}@${FC_REMOTE_IPS[i]} $COMMAND &
    else
        echo "Machine ${FC_REMOTE_IPS[i]} is not reachable"
    fi
done

wait
