#!/bin/bash
# Installation requirement
# mysql
# nodejs
# npm
# git
# yarn
# pm2
# grunt-cli

# Modify this :
GLADYS_VERSION=v3.8.0
MYSQL_USER="root"
MYSQL_PASS="password"
#
ROOT_FOLDER="/home/pi/"
GLADYS_FOLDER="/home/pi/gladys"
TMP_HOOK_FOLDER="/tmp/gladys_hooks"
TMP_CACHE_FOLDER="/tmp/gladys_cache"
BASEDIR=$(pwd)

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

# Delete current gladys install
if [ -d "$GLADYS_FOLDER" ];then
  rm -rf $GLADYS_FOLDER
fi

#  install gladys 
tar zxvf gladys-$GLADYS_VERSION-Linux-armv6l.tar.gz -C $ROOT_FOLDER

# init and update npm packages 
cd $GLADYS_FOLDER
npm install
# build assets
grunt buildProd
node init.js

echo "Start Gladys with:"
echo "pm2 /home/pi/gladys/app.js --name gladys"
echo ""