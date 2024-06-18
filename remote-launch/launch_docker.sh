#!/bin/bash


# nome immagine
# launch file
# experiment file
# opt_alg
# machine_name

DIRECTORY=~/holohover-docker/

if [ "$#" -ne 5 ]; then
    echo "$0 - Wrong number of parameters"
    echo "Usage:"
    echo "   $0 IMAGE_NAME LAUNCH_FILE EXPERIMENT_FILE OPT_ALG MACHINE_NAME"
    exit -1
fi

echo "This machine is: $5"
echo "Image: $1"
echo "Starting"

sudo docker run --rm --name $1 \
    --cap-add=SYS_NICE \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$DIRECTORY/log:/root/ros2_ws/log" \
    --volume="$(pwd)/ws/src:/root/ros2_ws/src" \
    --volume="/home/$USER/.Xauthority:/root/.Xauthority" \
    --volume="$DIRECTORY/.bash_history:/root/.bash_history" \
    --network host \
    $1 bash -c "export ROS_DOMAIN_ID=123 && source /opt/ros/humble/setup.bash && source /root/ros2_ws/install/local_setup.bash && ros2 launch holohover_utils $2 experiment:='$3' opt_alg:='$4' machine:='$5' record:='true'"
