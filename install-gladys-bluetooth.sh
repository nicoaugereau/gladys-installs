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

echo "Gladys Bluetooth:"
echo "1- Create token from Gladys / Parameters / Security"
echo "2- Add token into /home/pi/gladys-bluetooth/config.js file"
echo ""
echo "Start Gladys Voice and Gladys Bluetooth"
echo "pm2 /home/pi/gladys-voice/app.js --name gladys-voice"
echo "pm2 /home/pi/gladys-bluetooth/app.js --name gladys-bluetooth"
echo ""