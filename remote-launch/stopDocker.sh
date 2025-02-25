#!/bin/bash

source "$(dirname "$0")/config.sh"


for ((i = 0; i < ${#REMOTE_IPS[@]}; i++)); do
	ssh ${REMOTE_IPS[i]} docker stop ${IMAGE_NAMES[i]} &
done
wait
