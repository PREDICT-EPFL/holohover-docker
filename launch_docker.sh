#!/bin/bash

DIRECTORY=~/holohover-docker/

if [ "$#" -ne 3 ]; then
    echo "$0 - Wrong number of parameters"
    echo "Usage:"
    echo "   $0 EXPERIMENT_FILE OPT_ALG MACHINE_NAME"
    exit -1
fi

echo "This machine is: $1"
echo "Starting"

sudo docker run --rm --name holohover \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="/home/$USER/.Xauthority:/root/.Xauthority" \
    --volume="./.bash_history:/root/.bash_history" \
    --volume="$DIRECTORY/ws:/root/ros2_ws" \
    --network host \
    holohover bash -c "source /opt/ros/humble/setup.bash && source /root/ros2_ws/install/local_setup.sh && ros2 launch holohover_utils mult.dmpc.simulation.launch.py experiment:='$1' machine:='$3' opt_alg:='$2'"


    #holohover bash -c "source /opt/ros/humble/setup.bash && source /root/ros2_ws/install/local_setup.sh && ros2 launch holohover_utils mult.dmpc.simulation.launch.py experiment:='$1' machine:='$2' opt_alg:='$3'"
