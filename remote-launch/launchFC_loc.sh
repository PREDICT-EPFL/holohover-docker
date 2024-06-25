#!/bin/bash


DIRECTORY=~/holohover-docker/

if [ "$#" -ne 1 ]; then
    echo "$0 - Wrong number of parameters"
    echo "Usage:"
    echo "   $0 HOVERCRAFT_NAME"
    exit -1
fi 

echo "This hovercraft is: $1"
echo "Starting controller"

	
if docker ps --filter "name=holohover-light-aa" --filter "status=running" | grep -q holohover-light-aa; then
    sudo docker exec holohover-light-aa /bin/bash -c "export ROS_DOMAIN_ID=123 && source /opt/ros/humble/setup.bash && source /root/ros2_ws/install/local_setup.bash && ros2 launch holohover_utils embedded_controller.launch.py name:=$1"
else
    sudo docker run --rm --name holohover-light-aa \
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
    holohover-light-aa bash -c "export ROS_DOMAIN_ID=123 && source /opt/ros/humble/setup.bash && source /root/ros2_ws/install/local_setup.bash && ros2 launch holohover_utils embedded_controller.launch.py name:=$1"
fi