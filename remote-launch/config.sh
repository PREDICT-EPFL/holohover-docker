#!/bin/bash

# List of remote IP addresses and machine names
REMOTE_IPS=("ubuntu@192.168.0.71" "ubuntu@192.168.0.72" "ubuntu@192.168.0.140" "pi@192.168.0.113")
MACHINE_NAMES=("la016" "la017" "radxa" "pi")
IMAGE_NAMES=("holohover" "holohover" "holohover-light-aa" "holohover-light-aa")
USERS=("ubuntu" "ubuntu" "ubuntu" "pi")

MAIN_IP="192.168.0.70"

LAUNCH_FILE="mult.dmpc.simulation.launch.py"
OPT_ALG="admm"
EXPERIMENT_FILE="experiment1.yaml"

DATE=$(date +"%Y_%m_%d_%H_%M_%S")

LOG_FILE="~/holohover-docker/log/console-$DATE.log"
