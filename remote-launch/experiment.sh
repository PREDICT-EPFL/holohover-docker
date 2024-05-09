#!/bin/bash

source ./config.sh


for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
    if ! [ "${REMOTE_IPS[i]}" = "localhost" ]; then
        echo scp -r ~/holohover-docker/config/* ${REMOTE_IPS[i]}:~/holohover-docker/config
        scp -r ~/holohover-docker/config/* ${REMOTE_IPS[i]}:~/holohover-docker/config
    fi
done

# Loop through each remote machine
for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
    
    if [ "${REMOTE_IPS[i]}" = "localhost" ]; then
        echo ~/holohover-docker/remote-launch/launch_docker.sh ${IMAGE_NAMES[i]} $LAUNCH_FILE $EXPERIMENT_FILE $OPT_ALG ${MACHINE_NAMES[i]} 
        ~/holohover-docker/remote-launch/launch_docker.sh ${IMAGE_NAMES[i]} $LAUNCH_FILE $EXPERIMENT_FILE $OPT_ALG ${MACHINE_NAMES[i]}
    else
        COMMAND="/home/${USERS[i]}/holohover-docker/remote-launch/launch_docker.sh ${IMAGE_NAMES[i]} $LAUNCH_FILE $EXPERIMENT_FILE $OPT_ALG"
        CMD="$COMMAND ${MACHINE_NAMES[i]} > $LOG_FILE 2>&1 &"
        
        echo ssh ${REMOTE_IPS[i]} $CMD
        ssh ${REMOTE_IPS[i]} $CMD
        echo ssh ${REMOTE_IPS[i]} "~/holohover-docker/remote-launch/log.sh $LOG_FILE $MAIN_IP $i >/dev/null 2>&1 &"
        ssh ${REMOTE_IPS[i]} "~/holohover-docker/remote-launch/log.sh $LOG_FILE $MAIN_IP $i >/dev/null 2>&1 &"
    fi

    printf '\n\n\n'
done
