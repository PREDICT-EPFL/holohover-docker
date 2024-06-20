#!/bin/bash

# List of remote IP addresses and machine names
# REMOTE_IPS=("ubuntu@192.168.0.71" "ubuntu@192.168.0.72" "ubuntu@192.168.0.140" "ubuntu@192.168.0.113" "ubuntu@192.168.0.131")
# MACHINE_NAMES=("la016" "la017" "radxa" "pi" "radxa_new")
# IMAGE_NAMES=("holohover" "holohover" "holohover-light-aa" "holohover-light-aa" "holohover-light-aa")
# USERS=("ubuntu" "ubuntu" "ubuntu" "ubuntu" "ubuntu")
# EMBEDDED_CONTROLLER=(false false false false true)

REMOTE_IPS=("ubuntu@192.168.0.71" "ubuntu@192.168.0.72" "ubuntu@192.168.0.131")
MACHINE_NAMES=("la016" "la017" "radxa_new")
IMAGE_NAMES=("holohover" "holohover" "holohover-light-aa")
USERS=("ubuntu" "ubuntu" "ubuntu")
EMBEDDED_CONTROLLER=(false false true)


# REMOTE_IPS=("ubuntu@192.168.0.131")
# MACHINE_NAMES=("radxa_new")
# IMAGE_NAMES=("holohover-light-aa")
# USERS=("ubuntu")
# EMBEDDED_CONTROLLER=(true)


MAIN_IP="192.168.0.70"

LAUNCH_FILE="mult.dmpc.simulation.launch.py"

DATE=$(date -u +"%Y_%m_%d_%H_%M_%S")

LOG_FILE="~/holohover-docker/log/console-$DATE.log"
