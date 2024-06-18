#!/bin/bash

# List of remote IP addresses and machine names
REMOTE_IPS=("ubuntu@192.168.0.71" "ubuntu@192.168.0.72" "ubuntu@192.168.0.140" "ubuntu@192.168.0.113")
MACHINE_NAMES=("la016" "la017" "radxa" "pi")
IMAGE_NAMES=("holohover" "holohover" "holohover-light-aa" "holohover-light-aa")
USERS=("ubuntu" "ubuntu" "ubuntu" "ubuntu")
EMBEDDED_CONTROLLER=(false false true true)

#REMOTE_IPS=("ubuntu@192.168.0.131")
#MACHINE_NAMES=("radxa_new")
#IMAGE_NAMES=("holohover-light-aa")
#USERS=("ubuntu")

MAIN_IP="192.168.0.70"

LAUNCH_FILE="mult.dmpc.simulation.launch.py"
OPT_ALG="admm"
#EXPERIMENT_FILE="experiment1.yaml"

DATE=$(date +"%Y_%m_%d_%H_%M_%S")

LOG_FILE="~/holohover-docker/log/console-$DATE.log"
