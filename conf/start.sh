#!/bin/sh

echo "*** NUT upsd startup ***"

chmod 440 /etc/nut/*

printf "Starting NGINX on port 9199 ...\n"
exec /usr/sbin/nginx &

printf "Starting php-fpm8...\n"
exec /usr/sbin/php-fpm8 &

# initialize UPS driver
printf "Starting up the UPS drivers ...\n"

if [ -f /var/run/nut/nutdrv_qx-effekta.pid ]; then
   rm /var/run/nut/nutdrv_qx-effekta.pid 
   fi
   
exec /usr/sbin/upsdrvctl -u root start &
sleep 3

# run the ups daemon
printf "Starting up the UPS daemon ...\n"

if [ -f /var/run/nut/upsd.pid ]; then
  rm /var/run/nut/upsd.pid
  fi
  
exec /usr/sbin/upsd -4 -u root &
sleep 5
exec /status.sh
