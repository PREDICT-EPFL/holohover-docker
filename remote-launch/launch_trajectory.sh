#!/bin/bash

FILE="/root/ros2_ws/src/holohover/holohover_dmpc/config/trajectories/$1"


echo "export ROS_DOMAIN_ID=123 && source /opt/ros/humble/setup.bash && source /root/ros2_ws/install/local_setup.bash && ros2 service call /trajectory_generator holohover_msgs/srv/TrajectoryGeneratorTrigger \"{filename: {data: \"$FILE\"}}"
sudo docker exec -it holohover /bin/bash -c "export ROS_DOMAIN_ID=123 && source /opt/ros/humble/setup.bash && source /root/ros2_ws/install/local_setup.bash && ros2 service call /trajectory_generator holohover_msgs/srv/TrajectoryGeneratorTrigger \"{filename: {data: \"$FILE\"}}\""
