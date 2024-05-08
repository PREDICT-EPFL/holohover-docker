#!/bin/bash

# List of remote IP addresses and machine names
REMOTE_IPS=("localhost" "ubuntu@192.168.0.71")
MACHINE_NAMES=("master" "la016")
IMAGE_NAMES=("holohover" "holohover")

LAUNCH_FILE="mult.dmpc.simulation.launch.py"
OPT_ALG="admm"
EXPERIMENT_FILE="experiment1.yaml"

LOG_FILE="~/holohover-docker/log/console-$(date +"%Y_%m_%d_%H_%M_%S").log"
