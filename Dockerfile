FROM ros:humble-ros-base

WORKDIR /root/ros2_ws

COPY ./bin/install.sh /root/install.sh

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    libbox2d-dev \
    libeigen3-dev \
    libmatio-dev \
    ros-humble-rosbag2-storage-mcap \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    && echo "export ROS_DOMAIN_ID=123; source /opt/ros/humble/setup.bash; source /root/ros2_ws/install/local_setup.sh" >> /root/.bashrc \
    && /root/install.sh  \
    && /ros_entrypoint.sh


RUN echo aaaa

COPY ./ws/src /root/ros2_ws/src

RUN cd /root/ros2_ws/src/holohover/holohover_dmpc/ocp_specs/sProb_chain_QCQP_N20 && bash gen_locFuns.sh

RUN . /opt/ros/humble/setup.sh && cd /root/ros2_ws && colcon build --symlink-install --packages-select pingpong holohover_msgs holohover_common holohover_dmpc holohover_utils

