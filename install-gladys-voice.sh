#!/bin/bash

GLADYS_VOICE="/home/pi/gladys-voice"
ROOT_FOLDER="/home/pi/"

sudo apt-get install sox libsox-fmt-all libatlas-base-dev mpg321
sudo apt-get install libasound2-dev

cd $ROOT_FOLDER
sudo git clone https://github.com/GladysProject/gladys-voice

cd $GLADYS_VOICE
sudo yarn install

cp /home/pi/gladys-installs/gladys-voice/Gladys-API-Project-3f508873f719.json $GLADYS_VOICE/data/
cp /home/pi/gladys-installs/gladys-voice/config.js $GLADYS_VOICE/
cp /home/pi/gladys-installs/gladys-voice/index.js $GLADYS_VOICE/node_modules/sonus/index.js
cp /home/pi/gladys-installs/gladys-voice/shared.js $ROOT_FOLDER/gladys/api/hooks/speak/lib/shared.js

mkdir $ROOT_FOLDER/gladys/cache/sounds/

