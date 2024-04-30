FROM ros:humble-ros-base

WORKDIR /root/ros2_ws

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    python3-pip \
    git \
    nano \
    less \
    libbox2d-dev \
    libeigen3-dev \
    libmatio-dev \
    ros-humble-rosbag2-storage-mcap

RUN echo "export ROS_DOMAIN_ID=123; source /opt/ros/humble/setup.bash; source /root/ros2_ws/install/local_setup.sh" >> /root/.bashrc

COPY ./bin/install.sh /root/install.sh

RUN /root/install.sh

RUN /ros_entrypoint.sh 

COPY ./ws/src /root/ros2_ws/src

RUN . /opt/ros/humble/setup.sh && colcon build --symlink-install --packages-select holohover_msgs holohover_common holohover_dmpc holohover_utils

RUN cd /root/ros2_ws/install/holohover_dmpc/share/holohover_dmpc/ocp_specs/sProb_chain_QP_N20_acc_050_damped && bash gen_locFuns.sh

