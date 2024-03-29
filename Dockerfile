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
    libbox2d-dev \
    libeigen3-dev

RUN echo "export ROS_DOMAIN_ID=0; source /opt/ros/humble/setup.bash; source /root/ros2_ws/install/local_setup.sh" >> /root/.bashrc

COPY ./bin/install.sh /root/install.sh

RUN /root/install.sh

RUN /ros_entrypoint.sh 


