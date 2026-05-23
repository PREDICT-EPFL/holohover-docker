#!/bin/bash

# Choose between ONBOARD and OFFBOARD
MODE="OFFBOARD"

if [ "$MODE" != "ONBOARD" ] && [ "$MODE" != "OFFBOARD" ]; then
    echo "Invalid MODE: $MODE. Please set MODE to either 'ONBOARD' or 'OFFBOARD'."
    exit 1
fi

if [ "$MODE" == "ONBOARD" ]; then
    REMOTE_IPS=("192.168.0.131")
    MACHINE_NAMES=("radxa_h0")
    IMAGE_NAMES=("holohover-light-base")
    USERS=("ubuntu")
else
    REMOTE_IPS=("192.168.0.71" "192.168.0.72")
    MACHINE_NAMES=("la016" "la017")
    IMAGE_NAMES=("holohover" "holohover")
    USERS=("ubuntu" "ubuntu")
fi


# These are read just to start the fc nodes, should not be changed even to run offboard
FC_REMOTE_IPS=("192.168.0.131")
FC_CONTROLLER=("h0")
FC_USERS=("ubuntu")

MAIN_IP="192.168.0.70"

LAUNCH_FILE="mult.dmpc.simulation.launch.py"

DATE=$(date -u +"%Y_%m_%d_%H_%M_%S")

LOG_FILE="~/holohover-docker/log/console-$DATE.log"
