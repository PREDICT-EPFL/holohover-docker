echo $0" - Starting the container."
if [ "$#" -ne 1 ]; then
	CONT="holohover"
else
	CONT=$1
fi

touch .bash_history
mkdir -p log

sudo docker run -it --rm --name $CONT \
    --env ROS_DOMAIN_ID=123 \
    --env ROS_DISCOVERY_SERVER=192.168.0.70:11811 \
    --privileged \
    --cap-add=SYS_NICE \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$(pwd)/log:/root/ros2_ws/log" \
    --volume="$(pwd)/ws/src:/root/ros2_ws/src" \
    --volume="/home/$USER/.Xauthority:/root/.Xauthority" \
    --volume="./.bash_history:/root/.bash_history" \
    --network host \
    $CONT

