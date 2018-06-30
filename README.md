# gladys-installs

Informations how to manual install Gladys, Gladys Voice, Gladys Bluetooth.

Prerequisites
-------------
Jessie or Stretch installed on Raspberry.


How to
-------------
Raspberry configuration: raspi-config

Check sources :
```
# vi /etc/apt/sources.list
```
Change root password:
```
# sudo passwd root
```

Getting started
-------------

Install:
```
# cd /home/pi/gladys-installs
# sudo ./install.sh
```

If key expired when update or upgrade:
```
# LANG=C apt-key list | grep expired
pub   4096R/BE1DB1F1 2011-03-29 [expired: 2014-03-28]
```
Update:
```
# apt-key adv --recv-keys --keyserver keys.gnupg.net BE1DB1F1
```
Install nvm (node version manager) :
```
# curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
# sudo /home/pi/.nvm/install.sh
```
Install node v8
```
# sudo nvm install 8
```
Other method for nvm :
```
# wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
```
nvm usage:
```
# nvm use node
```

update all npm packages:
```
# sudo npm update -g
```

# Database
Acces :
```
# mysql -uroot -p gladys
```
If ER_NOT_SUPPORTED_AUTH_MODE:
```
# sudo mysql -uroot 
# use mysql;
# update user set authentication_string=password('password'), plugin='mysql_native_password' where user='root';
```
Reboot

Or
```
# sudo mysql -uroot
# SET PASSWORD FOR 'root'@'localhost' = PASSWORD('password');
```

Export database
```
# mysqldump -uUSERNAME -pPASSWORD -hHOSTNAME USER_DATABASE > FILENAME.sql
```
Then import using:
```
# mysql -uUSERNAME -pPASSWORD -hHOSTNAME USER_DATABASE < FILENAME.sql
```
If needed :
```
create user 'root'@'127.0.0.1' identified by 'password';
grant all privileges on *.* to 'root'@'127.0.0.1' with grant option;
create user 'root'@'%' identified by 'password';
grant all privileges on *.* to 'root'@'%' with grant option;
flush privileges
```

Remote database access:
Add to /etc/mysql/my.cnf
```
# The following options will be passed to all MySQL clients
[client]
user=root
password=password
port=3306
socket=/var/run/mysql/mysql.sock
[mysqld]
bind-address=0.0.0.0
```
Add iptables rule:
```
iptables -A INPUT -i eth0 -p tcp --destination-port 3306 -j ACCEPT
```

# PM2 and startup

Create systemd service:
Create a file gladys.service in /etc/systemd/system/ with:
```
[Unit]
Description=Gladys service
After=network.target
After=pulseaudio.target

[Service]
User=root
Type=simple
ExecStart=/bin/sh /home/pi/gladys-installs/gladys.start.sh
ExecStop=/bin/sh /home/pi/gladys-installs/gladys.stop.sh
StandardOutput=tty
SysVStartPriority=90
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```
Chmod +x gladys.service

Reload and enable service:
```
# systemctl daemon-reload
# systemctl enable gladys.service
```

Check status:
```
# systemctl is-active nom_du_service.service 
```


# Gladys-voice

Tutorial:
https://community.gladysproject.com/t/tutoriel-gladys-et-la-reconnaissance-vocale/1419


Create token Parameters / Security and add to:
/home/pi/gladys-voice/config.js

Modify :
/home/pi/gladys-voice/node_modules/sonus/index.js

Where:
```
opts.resource = opts.resource || 'node_modules/gladys-voice/data/common.res'
opts.audioGain = opts.audioGain || 2.0
opts.language = opts.language || 'en-US' //https://cloud.google.com/speech/docs/languages
```

With this:
```
opts.resource = opts.resource || '/home/pi/gladys-voice/node_modules/gladys-voice/data/common.res'
opts.audioGain = opts.audioGain || 2.0
opts.language = opts.language || 'fr-FR' //https://cloud.google.com/speech/docs/languages
```

Modify:<br>
/home/pi/gladys/api/hooks/speak/lib/shared.js

Where "./cache/sound"<br>
With this "/home/pi/gladys/cache/sounds/"

Create sounds/ into /home/pi/gladys/cache/

If message : Unable to reach user with service speak<br>
Force presence with box Events


# Sound card onfiguration

List sound cards: aplay -l<br>
Find sound card number: cat /proc/asound/cards

Replace if needed into /usr/share/alsa/alsa.conf:
```
defaults.ctl.card 1
defaults.pcm.card 1
```

Create .asoundrc for user, or /etc/asound.conf for all users and add:
```
# vi ~/.asoundrc

pcm.!default {
         type asym
         playback.pcm {
                 type plug
                 slave.pcm "hw:1,0"
         }
         capture.pcm {
                 type plug
                 slave.pcm "hw:1,0"
         } 
 }

 ctl.!default {
        type hw
        card 1
}
```
Test with arecord test.wav for recording, and aplay test.wav

# Gladys Bluetooth

Create token Parameters / Security and add: 
```
# /home/pi/gladys-bluetooth/config.js 
```

Detect user presence: https://gladysproject.com/fr/article/detecter-presence-porte-cle-bluetooth

# Debug
Find what missing in database.<br>
Edit utils.sqlUnique.js from gladys/api/core/utils/ and add lines under module.exports :<br>
  sails.log.debug(`DEBUG :: query: ${query} - params: ${params}`);<br>

we have:
```
module.exports = function(query, params){
sails.log.debug(`DEBUG :: query: ${query} - params: ${params}`);
    return gladys.utils.sql(query, params)
```
