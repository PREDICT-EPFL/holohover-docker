echo $0" - Starting the container."

touch .bash_history

sudo docker run -it --rm --name holohover \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="/home/$USER/.Xauthority:/root/.Xauthority" \
    --volume="./.bash_history:/root/.bash_history" \
    --network host \
    holohover-light
#    --volume="$(pwd)/ws:/root/ros2_ws" \

