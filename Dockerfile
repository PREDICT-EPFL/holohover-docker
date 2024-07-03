FROM osrf/ros:humble-desktop

WORKDIR /root/ros2_ws

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    python3-pip \
    git \
    nano \
    less \
    libgpiod-dev \
    libbox2d-dev \
    libeigen3-dev \
    libmatio-dev \
    xterm \
    ros-humble-rosbag2-storage-mcap

RUN echo "export ROS_DOMAIN_ID=123; source /opt/ros/humble/setup.bash; source /root/ros2_ws/install/local_setup.sh" >> /root/.bashrc

COPY ./bin/install.sh /root/install.sh

RUN /root/install.sh

RUN /ros_entrypoint.sh 


