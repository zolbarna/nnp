#!/bin/sh

STOPIT=0

function sig_term {
#  echo "Sigterm caught"
  STOPIT=1
}

trap sig_term SIGTERM

while true
do 
	date | tr -d '\n'
	if [ $STOPIT -eq 1 ]
	then 
		echo ' Initiate terminating sequence...'
		break
		fi
		echo ' ' | tr -d '\n'
		upsc effekta@127.0.0.1 2>&1| grep battery.charge
		sleep 10
done
