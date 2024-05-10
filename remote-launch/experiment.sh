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
    
    if ! [ "${REMOTE_IPS[i]}" = "localhost" ]; then
        COMMAND="/home/${USERS[i]}/holohover-docker/remote-launch/launch_docker.sh ${IMAGE_NAMES[i]} $LAUNCH_FILE $EXPERIMENT_FILE $OPT_ALG"
        CMD="$COMMAND ${MACHINE_NAMES[i]} > $LOG_FILE 2>&1 &"
        
        echo ssh ${REMOTE_IPS[i]} $CMD
        ssh ${REMOTE_IPS[i]} $CMD
    fi

    printf '\n\n\n'
done


tmux new-session -d -s "Holohover"


tmux \
    split-window -v \; \
    split-window -h \; \
    split-window -h \; \
    split-window -v \; \
    split-window -v \; \
    select-layout tiled
    
sleep 0.1



tmux select-pane -t 1
tmux send-keys "ssh ${REMOTE_IPS[0]} \"tail -f $LOG_FILE\"" C-m

tmux select-pane -t 2
tmux send-keys "ssh ${REMOTE_IPS[1]} \"tail -f $LOG_FILE\"" C-m

tmux select-pane -t 3
tmux send-keys "ssh ${REMOTE_IPS[2]} \"tail -f $LOG_FILE\"" C-m

tmux select-pane -t 4
tmux send-keys "ssh ${REMOTE_IPS[3]} \"tail -f $LOG_FILE\"" C-m

tmux select-pane -t 5
tmux send-keys "ssh ${REMOTE_IPS[4]} \"tail -f $LOG_FILE\"" C-m

tmux select-pane -t 0
tmux send-keys "~/holohover-docker/remote-launch/launch_docker.sh holohover $LAUNCH_FILE $EXPERIMENT_FILE $OPT_ALG master" C-m


tmux attach-session -t "Holohover"
