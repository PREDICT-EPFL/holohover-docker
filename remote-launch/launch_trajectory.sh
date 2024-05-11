#!/bin/bash

sudo docker exec -it holohover /bin/bash -c "export ROS_DOMAIN_ID=123 && source /opt/ros/humble/setup.bash && source /root/ros2_ws/install/local_setup.bash && ros2 run holohover_dmpc trajectory_generator --ros-args -p trajectory_file:='/root/ros2_ws/src/holohover/holohover_dmpc/config/trajectories/$1'"