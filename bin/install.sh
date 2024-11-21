#!/bin/bash

CASADI_VERSION=${CASADI_VERSION:-3.3.5};

# saving current directory
curr_dir=$(pwd)
# move to home directory
cd

echo "Installing QUILL..."
git clone http://github.com/odygrd/quill.git quill
cd quill
git checkout tags/v4.4.1

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j12
sudo make install

cd

echo "Installing CASADI..."
git clone https://github.com/casadi/casadi.git casadi
cd casadi
git checkout "$CASADI_VERSION"

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j12
sudo make install

cd
echo "Installing PIQP"
git clone https://github.com/PREDICT-EPFL/piqp.git
cd piqp

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j12
sudo make install


cd $curr_dir
