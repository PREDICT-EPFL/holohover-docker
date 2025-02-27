#!/bin/bash

source "$(dirname "$0")/config.sh"

current_branch=$(git rev-parse --abbrev-ref HEAD)
echo "Current branch is $current_branch"

for ((i = 0; i < ${#FC_REMOTE_IPS[@]}; i++)); do
   echo "Pinging ${FC_REMOTE_IPS[i]}..."
   if ping -c 1 ${FC_REMOTE_IPS[i]} &> /dev/null; then
       echo "Machine ${FC_REMOTE_IPS[i]} is reachable. Pulling latest code..."
       ssh ${FC_USERS[i]}@${FC_REMOTE_IPS[i]} "cd holohover-docker && git checkout $current_branch && git pull"
   else
       echo "Machine ${FC_REMOTE_IPS[i]} is not reachable."
   fi
done

for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
    echo "Pinging ${REMOTE_IPS[i]}..."
    if ping -c 1 ${REMOTE_IPS[i]} &> /dev/null; then
        echo "Machine ${REMOTE_IPS[i]} is reachable. Pulling latest code..."
        ssh ${USERS[i]}@${REMOTE_IPS[i]} "cd holohover-docker && git pull && git checkout $current_branch && git pull"
    else
        echo "Machine ${REMOTE_IPS[i]} is not reachable."
    fi
done

wait
