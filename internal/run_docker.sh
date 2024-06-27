
docker run -it --rm --name $1 \
    --env ROS_DOMAIN_ID=123 \
    --env ROS_DISCOVERY_SERVER=192.168.0.70:11811 \
    --env FASTRTPS_DEFAULT_PROFILES_FILE=/root/fastrtps_profiles_superclient.xml \
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
    $@ 