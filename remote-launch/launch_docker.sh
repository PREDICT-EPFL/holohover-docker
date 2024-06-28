#!/bin/bash


# nome immagine
# launch file
# experiment file
# machine_name

DIRECTORY=~/holohover-docker/

if [ "$#" -ne 4 ]; then
    echo "$0 - Wrong number of parameters"
    echo "Usage:"
    echo "   $0 IMAGE_NAME LAUNCH_FILE EXPERIMENT_FILE MACHINE_NAME"
    exit -1
fi 

echo "This machine is: $4"
echo "Image: $1"
echo "Starting"

if docker ps --filter "name=$1" --filter "status=running" | grep -q $1; then
    sudo docker exec $1 /bin/bash -c "source /root/source.sh && ros2 launch holohover_utils $2 experiment:='$3' machine:='$4' record:='true'"
else
    sudo docker run --rm --name $1 \
    --env ROS_DOMAIN_ID=123 \
    --env ROS_DISCOVERY_SERVER=192.168.0.70:11811 \
    --env FASTRTPS_DEFAULT_PROFILES_FILE=/root/fastrtps_profiles_superclient.xml \
    --privileged \
    --cap-add=SYS_NICE \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$DIRECTORY/log:/root/ros2_ws/log" \
    --volume="$DIRECTORY/ws/src:/root/ros2_ws/src" \
    --volume="/home/$USER/.Xauthority:/root/.Xauthority" \
    --volume="$DIRECTORY/.bash_history:/root/.bash_history" \
    --network host \
    $1 bash -c "source /root/source.sh && ros2 launch holohover_utils $2 experiment:='$3' machine:='$4' record:='true'"
fi
