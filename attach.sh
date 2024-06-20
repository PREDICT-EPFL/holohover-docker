if [ "$#" -ne 1 ]; then
	CONT="holohover"
else
	CONT=$1
fi

sudo docker exec -it $CONT /bin/bash
