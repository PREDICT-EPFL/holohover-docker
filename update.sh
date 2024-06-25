

cp Dockerfile.piupdate Dockerfile

PACKAGES="holohover_dmpc"

echo "RUN . /opt/ros/humble/setup.sh && cd /root/ros2_ws && colcon build --symlink-install --packages-select $PACKAGES
RUN /bin/bash /root/ocpSpecsSymlink.sh amd64" >> Dockerfile

sudo docker build --platform linux/arm64 . -t holohover-light-aa

sudo docker tag holohover-light-aa localhost:5000/holohover-light-aa

docker push localhost:5000/holohover-light-aa

rm Dockerfile



