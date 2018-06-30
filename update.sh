#!/bin/bash
# Gladys installation

function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}

update_gladys(){
    echo "Updating Gladys..."
    # Cleaning Gladys hook folder
    if [ -d "$TMP_HOOK_FOLDER" ];then
        rm -rf $TMP_HOOK_FOLDER/*
    fi
    # Cleaning Gladys cache folder
    if [ -d "$TMP_CACHE_FOLDER" ];then
        rm -rf $TMP_CACHE_FOLDER/*
    fi
    cp -r $GLADYS_FOLDER/hooks/* $TMP_HOOK_FOLDER
    cp -r $GLADYS_FOLDER/cache/* $TMP_CACHE_FOLDER
    # Delete current gladys install
    if [ -d "$GLADYS_FOLDER" ];then
        rm -rf $GLADYS_FOLDER
    fi
    # clone master version
    cd $ROOT_FOLDER
    git clone https://github.com/GladysProject/Gladys.git gladys
    # init and update npm packages 
    cd $GLADYS_FOLDER
    npm install
    mkdir $GLADYS_FOLDER/cache/sounds/
    # init and update npm packages 
    cd $GLADYS_FOLDER
    npm install
    cp -r $TMP_HOOK_FOLDER/* $GLADYS_FOLDER/hooks/
    cp -r $TMP_CACHE_FOLDER/* $GLADYS_FOLDER/cache/
    # build assets
    grunt buildProd
    node init.js
}

update_gladys_voice(){
    echo "Installing Gladys Voice..."
    if [ -d "$TMP_VOICE_FOLDER" ];then
        rm -rf $TMP_VOICE_FOLDER
    fi
    cp $GLADYS_VOICE/data/*.json $TMP_VOICE_FOLDER
    cp $GLADYS_VOICE/config.js $TMP_VOICE_FOLDER/
    cp $GLADYS_VOICE/node_modules/sonus/index.js $TMP_VOICE_FOLDER
    cd $ROOT_FOLDER
    sudo git clone https://github.com/GladysProject/gladys-voice
    cd $GLADYS_VOICE
    cp $TMP_VOICE_FOLDER/*.json $GLADYS_VOICE/data/
    cp $TMP_VOICE_FOLDER/config.js $GLADYS_VOICE/
    cp $TMP_VOICE_FOLDER/index.js $GLADYS_VOICE/node_modules/sonus/index.js
    sudo yarn install
}

update_gladys_bluetooth(){
    echo "Installing Gladys Bluetooth"
    if [ -d "$TMP_BT_FOLDER" ];then
        rm -rf $TMP_BT_FOLDER
    fi
    cp $GLADYS_BT/config.js $TMP_BT_FOLDER
    cd $ROOT_FOLDER
    sudo git clone https://github.com/GladysProject/gladys-bluetooth
    cd $GLADYS_BT
    cp $TMP_BT_FOLDER/config.js $GLADYS_BT
    sudo yarn install
    #sudo setcap cap_net_raw+eip $(eval readlink -f `which node`)
}

ROOT_FOLDER="/home/pi/"
GLADYS_FOLDER="/home/pi/gladys"
GLADYS_VOICE="/home/pi/gladys-voice"
GLADYS_BT="/home/pi/gladys-bluetooth"
TMP_HOOK_FOLDER="/tmp/gladys_hooks"
TMP_CACHE_FOLDER="/tmp/gladys_cache"
TMP_VOICE_FOLDER-"/tmp/gladys_voice"
TMP_BT_FOLDER="/tmp/gladys_bt"
BASEDIR=$(pwd)

read -p "Update Gladys (y/n)? " gladys
case ${gladys:0:1} in
    y|Y )
        update_gladys()
    ;;
    * )
        jumpto update_gladys_voice
    ;;
esac

update_gladys_voice:
read -p "Update Gladys Voice (y/n)? " gladys_voice
case ${gladys_voice:0:1} in
    y|Y )
        update_gladys_voice()
    ;;
    * )
        jumpto update_gladys_bluetooth
    ;;
esac

update_gladys_bluetooth:
read -p "Update Gladys Bluetooth (y/n)? " gladys_bluetooth
case ${gladys_bluetooth:0:1} in
    y|Y )
        update_gladys_bluetooth()
    ;;
    * )
        jumpto end
    ;;
esac


end:
echo "Update done."
echo "Restart update module manually"

