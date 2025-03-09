# Holohover Docker  

This repository contains all the necessary files to set up and manage the **Holohover system** using Docker.  

## Contents  

This repository includes:  
- **Dockerfiles** for both workstation and embedded platform images.  
- **Scripts for Docker image management**, including building, pushing, and handling Docker registries.  
- **Experiment management scripts** for remotely starting and stopping experiments.  
- **Logging and data collection tools** for gathering logs and experimental data from remote devices.  

## Usage  

The entry point is the `holohover` Python script, which integrates all the scripts and tools in this repository.  

### Configuration  

The IP addresses of the remote machines (both workstations and embedded platforms on the hovercraft) are configured in the `remote-launch/config.sh` file.  

### Available Commands  

The `holohover` script exposes the following commands:  

| Command | Description |
|---------|-------------|
| `docker-build` | Builds Docker image |
| `docker-update-pi-image` | Updates Docker image for Raspberry Pi |
| `experiment` | Launches an experiment |
| `docker-install` | Installs Docker |
| `docker-run` | Runs Docker image |
| `docker-attach` | Attaches to a running Docker container |
| `edit-config` | Opens the config file in an editor |
| `shutdown` | Turns off the Radxas |
| `stop-experiment` | Stops the experiment on remote machines |
| `docker-upload-images` | Uploads Docker images to remote machines |
| `docker-stop` | Stops the Docker daemon on remote machines |
| `update-holohover-scripts` | Updates scripts on remote machines |
| `fc-launch` | Launches the flight controller |
| `fc-stop` | Stops the flight controller |

## Author  

📧 [Andrea Grillo](mailto:andrea.grillo@epfl.ch)  

📍 2024-2025, École Polytechnique Fédérale de Lausanne (EPFL)  
