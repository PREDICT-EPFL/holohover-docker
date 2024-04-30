echo $0" - Building the docker image"
sudo docker build --platform "linux/arm64" . -t holohover-light-a

echo $0" - Finish!"
