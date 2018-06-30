#!/bin/bash
# Gladys installation

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

echo "Installing mariadb..."
sudo apt-get install -y mariadb-server mariadb-client

