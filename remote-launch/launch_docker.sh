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

sudo docker run --rm --name holohover \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$DIRECTORY/log:/root/ros2_ws/log" \
    --volume="$DIRECTORY/config:/root/ros2_ws/src/holohover/holohover_utils/config" \
    --volume="/home/$USER/.Xauthority:/root/.Xauthority" \
    --volume="./.bash_history:/root/.bash_history" \
    --network host \
    $1 bash -c "echo eddai && source /opt/ros/humble/setup.bash && source /root/ros2_ws/install/local_setup.bash && ros2 launch holohover_utils $2 experiment:='$3' opt_alg:='$4' machine:='$5'"

#source /opt/ros/humble/setup.bash && source /root/ros2_ws/install/local_setup.sh && ros2 launch holohover_utils mult.dmpc.simulation.launch.py experiment:='experiment1.yaml' machine:='all' opt_alg:='admm'
