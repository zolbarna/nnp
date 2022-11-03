#!/bin/sh

STOPIT=0
LOGSEQUENCE=60

function sig_term {
#  echo "Sigterm caught"
#
  STOPIT=1
}

trap sig_term SIGTERM

date | tr -d '\n' 
echo " Checking data form $UPS"

while true
do 
	if [ $STOPIT -eq 1 ]
	then
		echo ' Initiate terminating sequence...'
		break
		fi
		if [ $LOGSEQUENCE -eq 60 ]
		then
			date | tr -d '\n'
			echo ' ' | tr -d '\n'
			upsc $UPS@127.0.0.1 2>&1| grep battery.charge
			LOGSEQUENCE=0
		fi
		let "LOGSEQUENCE=LOGSEQUENCE+1"
		sleep 10
done
