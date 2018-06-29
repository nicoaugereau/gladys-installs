#!/bin/bash
# Installation requirement
# mysql
# nodejs
# npm
# git

# A MODIFIER POUR INSTALLATION :
GLADYS_VERSION=v3.7.6
MYSQL_USER="root"
MYSQL_PASS="raspberry"
ROOT_FOLDER="/home/pi/"
GLADYS_FOLDER="/home/pi/gladys"
#
TMP_HOOK_FOLDER="/tmp/gladys_hooks"
TMP_CACHE_FOLDER="/tmp/gladys_cache"
BASEDIR=$(pwd)

# create gladys database
MAINDB=gladys
sudo mysql -u$MYSQL_USER -p$MYSQL_PASS -e "CREATE DATABASE IF NOT EXISTS ${MAINDB} CHARACTER SET latin1 COLLATE latin1_swedish_ci;"
sudo mysql -u$MYSQL_USER -p$MYSQL_PASS -e "GRANT ALL PRIVILEGES ON ${MAINDB}.* TO '$MYSQL_USER'@'localhost';"
sudo mysql -u$MYSQL_USER -p$MYSQL_PASS -e "FLUSH PRIVILEGES;"

# install necessary
sudo apt-get update
sudo apt-get install nmap
sudo npm install -g pm2
sudo npm install -g yarn
sudo npm install -g grunt-cli

# download update (-N allow to don't retrieve file unless newer than local)
#wget -N https://github.com/GladysProject/Gladys/releases/download/v3.6.3/gladys-v3.6.3-Linux-armv6l.tar.gz
if [ ! -f "gladys-$GLADYS_VERSION-Linux-armv6l.tar.gz" ];then
  wget -N https://github.com/GladysProject/Gladys/releases/download/$GLADYS_VERSION/gladys-$GLADYS_VERSION-Linux-armv6l.tar.gz
fi

# Delete current gladys install
if [ -d "$GLADYS_FOLDER" ];then
  rm -rf $GLADYS_FOLDER
fi

#  install gladys 
#tar zxvf gladys-$GLADYS_VERSION-Linux-armv6l.tar.gz -C $GLADYS_FOLDER
tar zxvf gladys-$GLADYS_VERSION-Linux-armv6l.tar.gz -C $ROOT_FOLDER

# cp .env file to Gladys version (for development)
#cp $BASEDIR/gladys/env $GLADYS_FOLDER/.env
# cp gladys.js connections to config folder
cp $BASEDIR/gladys/gladys.js $GLADYS_FOLDER/config/

# init and update npm packages 
cd $GLADYS_FOLDER
npm install
# build assets
grunt buildProd
node init.js

# restart gladys
#pm2 start /home/pi/gladys/app.js --name gladys

