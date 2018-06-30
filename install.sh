#!/bin/bash
# Gladys installation

function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}

updade_upgrade(){ 
    echo "update and upgrade..."
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get update --fix-missing

    echo "Installing tools..."
    sudo apt-get install locate
    sudo apt-get install nmap
    sudo apt-get install -y git build-essential
    sudo npm install -g pm2
    sudo npm install -g yarn
    sudo npm install -g grunt-cli
    sudo apt-get install sox libsox-fmt-all libatlas-base-dev mpg321
    sudo apt-get install libasound2-dev

    echo "Installing mariadb..."
    sudo apt-get install -y mariadb-server mariadb-client
}

install_gladys(){
    echo "Installing Gladys..."
    # create gladys database
    MAINDB=gladys
    sudo mysql -u$MYSQL_USER -p$MYSQL_PASS -e "CREATE DATABASE IF NOT EXISTS ${MAINDB} CHARACTER SET latin1 COLLATE latin1_swedish_ci;"
    sudo mysql -u$MYSQL_USER -p$MYSQL_PASS -e "GRANT ALL PRIVILEGES ON ${MAINDB}.* TO '$MYSQL_USER'@'localhost';"
    sudo mysql -u$MYSQL_USER -p$MYSQL_PASS -e "FLUSH PRIVILEGES;"
    # download update (-N allow to don't retrieve file unless newer than local)
    #wget -N https://github.com/GladysProject/Gladys/releases/download/v3.6.3/gladys-v3.6.3-Linux-armv6l.tar.gz
    if [ ! -f "gladys-$GLADYS_VERSION-Linux-armv6l.tar.gz" ];then
        wget -N https://github.com/GladysProject/Gladys/releases/download/$GLADYS_VERSION/gladys-$GLADYS_VERSION-Linux-armv6l.tar.gz
    fi
    #  install gladys 
    tar zxvf gladys-$GLADYS_VERSION-Linux-armv6l.tar.gz -C $ROOT_FOLDER
    # init and update npm packages 
    cd $GLADYS_FOLDER
    npm install
    mkdir $ROOT_FOLDER/gladys/cache/sounds/
    # build assets
    grunt buildProd
    node init.js
}

install_gladys_voice(){
    echo "Installing Gladys Voice..."
    cd $ROOT_FOLDER
    sudo git clone https://github.com/GladysProject/gladys-voice
    cd $GLADYS_VOICE
    sudo yarn install
}

install_gladys_bluetooth(){
    echo "Installing Gladys Bluetooth"
    sudo apt-get install libbluetooth-dev libudev-dev
    cd $ROOT_FOLDER
    sudo git clone https://github.com/GladysProject/gladys-bluetooth
    cd $GLADYS_BT
    sudo yarn install
    #sudo setcap cap_net_raw+eip $(eval readlink -f `which node`)
}

# Modify this :
GLADYS_VERSION=v3.7.6
MYSQL_USER="root"
MYSQL_PASS="password"
#
ROOT_FOLDER="/home/pi/"
GLADYS_FOLDER="/home/pi/gladys"
GLADYS_VOICE="/home/pi/gladys-voice"
GLADYS_BT="/home/pi/gladys-bluetooth/"
BASEDIR=$(pwd)

read -p "Update and upgrade Raspberry (y/n)? " upgrade
case ${upgrade:0:1} in
    y|Y )
        updade_upgrade()
    ;;
    * )
        jumpto install_gladys
    ;;
esac

install_gladys:
read -p "Install Gladys (y/n)? " gladys
case ${gladys:0:1} in
    y|Y )
        install_gladys()
    ;;
    * )
        jumpto install_gladys_voice
    ;;
esac

install_gladys_voice:
read -p "Install Gladys Voice (y/n)? " gladys_voice
case ${gladys_voice:0:1} in
    y|Y )
        install_gladys_voice()
    ;;
    * )
        jumpto install_gladys_bluetooth
    ;;
esac

install_gladys_bluetooth:
read -p "Install Gladys Bluetooth (y/n)? " gladys_bluetooth
case ${gladys_bluetooth:0:1} in
    y|Y )
        install_gladys_bluetooth()
    ;;
    * )
        jumpto end
    ;;
esac


end:
echo "Install done."
echo 
echo "Start Gladys with:"
echo "pm2 /home/pi/gladys/app.js --name gladys"
echo ""
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
echo "Gladys Bluetooth:"
echo "1- Create token from Gladys / Parameters / Security"
echo "2- Add token into /home/pi/gladys-bluetooth/config.js file"
echo ""
echo "Start Gladys Voice and Gladys Bluetooth"
echo "pm2 /home/pi/gladys-voice/app.js --name gladys-voice"
echo "pm2 /home/pi/gladys-bluetooth/app.js --name gladys-bluetooth"
echo ""
echo "And save pm2 for startup"
echo "pm2 save"