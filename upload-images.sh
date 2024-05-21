docker-push-ssh ubuntu@192.168.0.71 holohover -i ~/.ssh/id_ed25519
docker-push-ssh ubuntu@192.168.0.71 holohover -i ~/.ssh/id_ed25519
docker-push-ssh ubuntu@192.168.0.140 holohover-light-aa -i ~/.ssh/id_ed25519
docker-push-ssh pi@192.168.0.113 holohover-light-aa -i ~/.ssh/id_ed25519

#sudo docker save holohover | ssh -C ubuntu@192.168.0.71 sudo docker load &
#sudo docker save holohover | ssh -C ubuntu@192.168.0.72 sudo docker load &
#sudo docker save holohover-light-aa | ssh -C ubuntu@192.168.0.140 docker load &
#sudo docker save holohover-light-aa | ssh -C pi@192.168.0.113 docker load &
wait
