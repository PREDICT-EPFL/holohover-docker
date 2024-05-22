echo $0" - Starting the container."

touch .bash_history
mkdir -p log

sudo docker run -it --rm --name holohover \
    --cap-add=SYS_NICE \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$(pwd)/log:/root/ros2_ws/log" \
    --volume="$(pwd)/config/holohover_utils:/root/ros2_ws/src/holohover/holohover_utils/config" \
    --volume="$(pwd)/config/holohover_dmpc:/root/ros2_ws/src/holohover/holohover_dmpc/config" \
    --volume="/home/$USER/.Xauthority:/root/.Xauthority" \
    --volume="./.bash_history:/root/.bash_history" \
    --network host \
    holohover

