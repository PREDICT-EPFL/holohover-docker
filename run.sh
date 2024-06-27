echo $0" - Starting the container."
if [ "$#" -ne 1 ]; then
	CONT="holohover"
else
	CONT=$1
fi

touch .bash_history
mkdir -p log

./internal/run_docker.sh $CONT

