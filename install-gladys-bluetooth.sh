#!/bin/bash

GLADYS_BT="/home/pi/gladys-bluetooth/"
ROOT_FOLDER="/home/pi/"

sudo apt-get install libbluetooth-dev libudev-dev

cd $ROOT_FOLDER
sudo git clone https://github.com/GladysProject/gladys-bluetooth

cd $GLADYS_BT
sudo yarn install

cp /home/pi/gladys-update/gladys-bluetooth/config.js $GLADYS_BT

#sudo setcap cap_net_raw+eip $(eval readlink -f `which node`)
