


remote=$(ls ~/holohover-docker/log -rt | grep remote | tail -n1)

cd ~/holohover-docker/ws/src/holohover
git add .
git commit -m "produced $remote"


cd -

