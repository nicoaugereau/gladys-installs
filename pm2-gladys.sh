#!/bin/bash
# Execute pm2 Gladys
# Gladys
# Gladys-voice
# Gladys-bluetooth

# if no command line arg given
# set rental to Unknown
if [ -z $1 ]
then
        gladys="no command send"
elif [ -n $1 ]
then
# otherwise make first arg as a rental
	gladys=$1
fi

case $gladys in
  start)
	# clean pm2 logs
	pm2 flush

	# start gladys
	pm2 start /home/pi/gladys/app.js --name gladys

 	# wait 10 seconds
	sleep 10

	# start gladys-voice
	pm2 start /home/pi/gladys-voice/app.js --name gladys-voice

	# start gladys-bluetooth
	#sudo setcap cap_net_raw+eip $(eval readlink -f `which node`)
	pm2 start /home/pi/gladys-bluetooth/app.js --name gladys-bluetooth
  ;;
  stop)
        pm2 stop all
  ;;
  reload)
        pm2 reload all
  ;;
  restart)
        pm2 restart all
  ;; 
  status)
        pm2 status
  ;;
  list)
	pm2 list
  ;;
  *)
       echo $"Usage: $0 {start|stop|restart|reload|status|list}"
       exit 1
esac
