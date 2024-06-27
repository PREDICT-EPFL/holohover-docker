#!/bin/bash

source ./config.sh


for ((i = 0; i < ${#FC_REMOTE_IPS[@]}; i++)); do
	ssh ${FC_REMOTE_IPS[i]} docker stop holohover-light-aa &
done
wait
