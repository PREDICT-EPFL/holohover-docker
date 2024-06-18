#!/bin/bash

DIRECTORY=~/holohover-docker/


# image name
# experiment file
# machine_name

DIRECTORY=~/holohover-docker/

if [ "$#" -ne 3 ]; then
    echo "$0 - Wrong number of parameters"
    echo "Usage:"
    echo "   $0 IMAGE_NAME EXPERIMENT_FILE MACHINE_NAME"
    exit -1
fi
EXPERIMENT=$2
MACHINE=$3

echo "This machine is: $3"
echo "Image: $1"
echo "Starting controller"

sudo docker run --rm --name controller \
    --cap-add=SYS_NICE \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$DIRECTORY/ws/src:/root/ros2_ws/src" \
    --volume="/home/$USER/.Xauthority:/root/.Xauthority" \
    --volume="$DIRECTORY/.bash_history:/root/.bash_history" \
    --network host \
    $1 bash -c "export ROS_DOMAIN_ID=123 && source /opt/ros/humble/setup.bash && source /root/ros2_ws/install/local_setup.bash && ros2 launch holohover_utils embedded_controller.launch.py experiment:='$EXPERIMENT' machine:='$MACHINE'"
