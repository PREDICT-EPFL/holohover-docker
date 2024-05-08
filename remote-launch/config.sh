#!/bin/bash

# List of remote IP addresses and machine names
REMOTE_IPS=("ubuntu@192.168.0.71" "ubuntu@192.168.0.72" "pi@192.168.0.113" "localhost")
MACHINE_NAMES=("la016" "la017" "pi" "master")
IMAGE_NAMES=("holohover" "holohover" "holohover-light-a" "holohover")
USERS=("ubuntu" "ubuntu" "pi" "andrea")

MAIN_IP="192.168.0.70"

LAUNCH_FILE="mult.dmpc.simulation.launch.py"
OPT_ALG="admm"
EXPERIMENT_FILE="experiment_h_all.yaml"

LOG_FILE="~/holohover-docker/log/console-$(date +"%Y_%m_%d_%H_%M_%S").log"
