sudo docker save holohover | ssh -C ubuntu@192.168.0.71 sudo docker load &
sudo docker save holohover | ssh -C ubuntu@192.168.0.72 sudo docker load &
sudo docker save holohover-light-aa | ssh -C ubuntu@192.168.0.140 docker load &
sudo docker save holohover-light-aa | ssh -C pi@192.168.0.113 docker load &
