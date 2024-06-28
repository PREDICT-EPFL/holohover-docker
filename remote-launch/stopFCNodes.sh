#!/bin/bash

source ./config.sh



# Loop through each remote machine
for ((i = 0; i < ${#FC_REMOTE_IPS[@]}; i++)); do
    COMMAND="sudo docker exec holohover-light-aa /bin/bash /root/stop_fc.sh"

    echo ssh ${FC_REMOTE_IPS[i]} $COMMAND
    ssh ${FC_REMOTE_IPS[i]} $COMMAND &
done

wait
