#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "$0 - Wrong number of parameters"
    echo "Usage:"
    echo "   $0 [amd64/x86]"
    exit -1
fi

ARCH=$1

echo architecture $ARCH

cd /root/ros2_ws/install/holohover_dmpc/share/holohover_dmpc/ocp_specs/

for subdir in */; do
  if [ -d "$subdir" ] && [ "$(basename "$subdir")" != "matlab" ]; then
    echo "Entering directory: $subdir"
    cd $subdir
    echo "ln -s  locFuns-$ARCH.so locFuns.so"
    rm locFuns.so
    ln -s  locFuns-$ARCH.so locFuns.so
    cd -
  fi
done
