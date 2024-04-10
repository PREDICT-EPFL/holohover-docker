#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "$0 - Wrong number of parameters"
    echo "Usage:"
    echo "   $0 EXPERIMENT_FILE MACHINE_NAME"
    exit -1
fi

echo "This machine is: $1"
echo "Starting"

sudo docker run --rm --name holohover \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$(pwd)/holohover-docker/ws:/root/ros2_ws" \
    --volume="$(pwd)/piqp:/root/piqp" \
    --volume="/home/$USER/.Xauthority:/root/.Xauthority" \
    --volume="./.bash_history:/root/.bash_history" \
    --network host \
    holohover /bin/bash -c "source /opt/ros/humble/setup.bash; source /root/ros2_ws/install/local_setup.sh; ros2 launch holohover_utils mult.dmpc.simulation.launch.py experiment:='$1' machine:='$2'"