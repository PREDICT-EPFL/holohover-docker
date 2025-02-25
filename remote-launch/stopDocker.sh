#!/bin/bash

source "$(dirname "$0")/config.sh"


for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
	if ping -c 1 ${REMOTE_IPS[i]} &> /dev/null; then
		echo ssh ${REMOTE_IPS[i]} docker stop ${IMAGE_NAMES[i]}
		ssh ${REMOTE_IPS[i]} docker stop ${IMAGE_NAMES[i]} &
	else
		echo "Cannot reach ${REMOTE_IPS[i]}"
	fi
done
wait
