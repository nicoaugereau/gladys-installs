#!/bin/bash

GLADYS_VOICE="/home/pi/gladys-voice"
ROOT_FOLDER="/home/pi/"

sudo apt-get install sox libsox-fmt-all libatlas-base-dev mpg321
sudo apt-get install libasound2-dev

cd $ROOT_FOLDER
sudo git clone https://github.com/GladysProject/gladys-voice

cd $GLADYS_VOICE
sudo yarn install

mkdir $ROOT_FOLDER/gladys/cache/sounds/

echo "Gladys Voice:"
echo "1- Create token from Gladys / Parameters / Security"
echo "2- Add token to /home/pi/gladys-voice/config.js"
echo "3- Modify /home/pi/gladys-voice/node_modules/sonus/index.js"
echo "Replace this:"
echo " opts.resource = opts.resource || 'node_modules/gladys-voice/data/common.res'"
echo " opts.audioGain = opts.audioGain || 2.0"
echo " opts.language = opts.language || 'en-US' //https://cloud.google.com/speech/docs/languages"
echo "With this:"
echo " opts.resource = opts.resource || '/home/pi/gladys-voice/node_modules/gladys-voice/data/common.res'"
echo " opts.audioGain = opts.audioGain || 2.0"
echo " opts.language = opts.language || 'fr-FR' //https://cloud.google.com/speech/docs/languages"
echo "4- Modify /home/pi/gladys/api/hooks/speak/lib/shared.js"
echo "5- Replace ./cache/sound with this /home/pi/gladys/cache/sounds/"
echo "6- Place your API json projet into /home/pi/gladys-voice/data/"
echo ""