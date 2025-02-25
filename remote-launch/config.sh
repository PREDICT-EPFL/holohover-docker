#!/bin/bash

# Choose between ONBOARD and OFFBOARD
MODE="OFFBOARD"

if [ "$MODE" != "ONBOARD" ] && [ "$MODE" != "OFFBOARD" ]; then
    echo "Invalid MODE: $MODE. Please set MODE to either 'ONBOARD' or 'OFFBOARD'."
    exit 1
fi

if [ "$MODE" == "ONBOARD" ]; then
    REMOTE_IPS=("ubuntu@192.168.0.131" "ubuntu@192.168.0.122" "ubuntu@192.168.0.136" "ubuntu@192.168.0.108" "ubuntu@192.168.0.109")
    MACHINE_NAMES=("radxa_h0" "radxa_h1" "radxa_h2" "radxa_h3" "radxa_h4")
    IMAGE_NAMES=("holohover-light-aa"  "holohover-light-aa"  "holohover-light-aa" "holohover-light-aa" "holohover-light-aa")
    USERS=("ubuntu" "ubuntu" "ubuntu" "ubuntu" "ubuntu")
else
    REMOTE_IPS=("ubuntu@192.168.0.71" "ubuntu@192.168.0.72")
    MACHINE_NAMES=("la016" "la017")
    IMAGE_NAMES=("holohover" "holohover")
    USERS=("ubuntu" "ubuntu")
fi


# These are read just to start the fc nodes, should not be changed even to run offboard
FC_REMOTE_IPS=("ubuntu@192.168.0.131" "ubuntu@192.168.0.122" "ubuntu@192.168.0.136" "ubuntu@192.168.0.108" "ubuntu@192.168.0.109")
FC_CONTROLLER=("h0" "h1" "h2" "h3" "o4")


MAIN_IP="192.168.0.70"

LAUNCH_FILE="mult.dmpc.simulation.launch.py"

DATE=$(date -u +"%Y_%m_%d_%H_%M_%S")

LOG_FILE="~/holohover-docker/log/console-$DATE.log"
