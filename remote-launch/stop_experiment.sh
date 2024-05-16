#!/bin/bash

source ./config.sh

# Loop through each remote machine
for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
    COMMAND="sudo docker stop ${IMAGE_NAMES[i]}"

    #CMD="$COMMAND ${MACHINE_NAMES[i]} > $LOG_FILE 2>&1 &"
    echo ssh ${REMOTE_IPS[i]} $COMMAND
    ssh ${REMOTE_IPS[i]} $COMMAND &
done

wait

sudo docker stop holohover

DIR=~/holohover-docker/log/remote-$DATE/master
mkdir -p $DIR
sudo mv ~/holohover-docker/log/rosbag* $DIR/..
sudo mv ~/holohover-docker/log/dmpc* $DIR


# Loop through each remote machine
for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
    DIR=~/holohover-docker/log/remote-$DATE/${MACHINE_NAMES[i]}
    mkdir -p $DIR
    echo scp -r ${REMOTE_IPS[i]}:~/holohover-docker/log $DIR
    scp -r ${REMOTE_IPS[i]}:~/holohover-docker/log $DIR
    echo ssh ${REMOTE_IPS[i]} "sudo rm -rf ~/holohover-docker/log/*"
    ssh ${REMOTE_IPS[i]} "sudo rm -rf ~/holohover-docker/log/*"
done



SESSION="Holohover"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

# Only create tmux session if it doesn't already exist
if ! [ "$SESSIONEXISTS" = "" ]
then
    tmux kill-session -t $SESSION
fi