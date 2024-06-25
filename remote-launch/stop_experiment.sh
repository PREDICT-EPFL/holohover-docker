#!/bin/bash

source ./config.sh

# Loop through each remote machine
for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
    #COMMAND="sudo docker stop ${IMAGE_NAMES[i]}"
    COMMAND="sudo docker exec ${IMAGE_NAMES[i]} /bin/bash /root/stop_controller.sh"

    #CMD="$COMMAND ${MACHINE_NAMES[i]} > $LOG_FILE 2>&1 &"
    echo ssh ${REMOTE_IPS[i]} $COMMAND
    ssh ${REMOTE_IPS[i]} $COMMAND &
done

wait

# Stop local process
tmux select-pane -t 0
tmux send-keys  C-c
tmux select-pane -t 5

#sudo docker stop holohover

DIR=~/holohover-docker/log/remote-$DATE
mkdir -p $DIR
mkdir -p $DIR/master

sudo mv ~/holohover-docker/log/rosbag* $DIR
sudo mv ~/holohover-docker/log/dmpc* $DIR/master




# Loop through each remote machine
for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
    DIR=~/holohover-docker/log/remote-$DATE/${MACHINE_NAMES[i]}
    mkdir -p $DIR
    echo scp -r ${REMOTE_IPS[i]}:~/holohover-docker/log $DIR
    scp -r ${REMOTE_IPS[i]}:~/holohover-docker/log $DIR
    echo ssh ${REMOTE_IPS[i]} "sudo rm -rf ~/holohover-docker/log/*"
    ssh ${REMOTE_IPS[i]} "sudo rm -rf ~/holohover-docker/log/*"
done

read -p "Do you want to save logs? (YES/no): " answer

DIR=~/holohover-docker/log/remote-$DATE

case $answer in
    [Nn][Oo]|[Nn])
        echo "Deleting logs."
        sudo mv $DIR /tmp
        ;;
    *)
        echo "SAVING LOGS"
        nano $DIR/readme.md
        ;;
esac



SESSION="Holohover"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

# Only create tmux session if it doesn't already exist
if ! [ "$SESSIONEXISTS" = "" ]
then
    tmux kill-session -t $SESSION
fi