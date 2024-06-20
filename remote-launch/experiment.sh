#!/bin/bash

source ./config.sh

if [ "$#" -ne 1 ]; then
    echo "$0 - Wrong number of parameters"
    echo "Usage:"
    echo "   $0 EXPERIMENT_FILE"
    exit -1
fi

EXPERIMENT_FILE=$1

for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
    if ! [ "${REMOTE_IPS[i]}" = "localhost" ]; then
        echo rsync -av ~/holohover-docker/ws/src ${REMOTE_IPS[i]}:~/holohover-docker/ws
        rsync -av ~/holohover-docker/ws/src ${REMOTE_IPS[i]}:~/holohover-docker/ws &
    fi
done

wait

# # Loop through each remote machine
# for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
#     if ! [ "${REMOTE_IPS[i]}" = "localhost" ]; then
#         CMD="sudo systemctl restart docker"
#         echo ssh ${REMOTE_IPS[i]} $CMD
#         ssh ${REMOTE_IPS[i]} $CMD &
#     fi
# done

# wait

# Loop through each remote machine
for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
    
    if ! [ "${REMOTE_IPS[i]}" = "localhost" ]; then
        COMMAND="/home/${USERS[i]}/holohover-docker/remote-launch/launch_docker.sh ${IMAGE_NAMES[i]} $LAUNCH_FILE $EXPERIMENT_FILE"
        CMD="$COMMAND ${MACHINE_NAMES[i]} > $LOG_FILE 2>&1 &"
        
        echo ssh ${REMOTE_IPS[i]} $CMD
        #ssh ${REMOTE_IPS[i]} $CMD
    fi

    printf '\n\n\n'
done

exit

tmux new-session -d -s "Holohover"


tmux \
    split-window -v \; \
    split-window -h \; \
    split-window -h \; \
    split-window -v \; \
    split-window -v \; \
    select-layout tiled
    
sleep 0.2



tmux select-pane -t 1
tmux send-keys "ssh ${REMOTE_IPS[0]} \"tail -f $LOG_FILE\"" C-m

tmux select-pane -t 2
tmux send-keys "ssh ${REMOTE_IPS[1]} \"tail -f $LOG_FILE\"" C-m

tmux select-pane -t 3
tmux send-keys "ssh ${REMOTE_IPS[2]} \"tail -f $LOG_FILE\"" C-m

tmux select-pane -t 4
tmux send-keys "ssh ${REMOTE_IPS[3]} \"tail -f $LOG_FILE\"" C-m

tmux select-pane -t 0

tmux send-keys "docker exec -it holohover /bin/bash -c \"export ROS_DOMAIN_ID=123 && source /opt/ros/humble/setup.bash && source /root/ros2_ws/install/local_setup.bash && ros2 launch holohover_utils $LAUNCH_FILE experiment:=$EXPERIMENT_FILE machine:=master record:='true'\" " C-m
# tmux send-keys "~/holohover-docker/remote-launch/launch_docker.sh holohover $LAUNCH_FILE $EXPERIMENT_FILE master" C-m

tmux select-pane -t 5
tmux send-keys "bash stop_experiment.sh"
#tmux send-keys "bash launch_trajectory.sh trajectory4.yaml"

tmux attach-session -t "Holohover"
