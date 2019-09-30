#!/bin/bash

idleExecStart=$1

if [[ -z $idleExecStart ]]; then
	echo
	echo "Must provide full path to executable as first argument."
	echo
	echo "Example: ./runIdle.sh /usr/bin/foo 5"
	echo "(Will run executable \"foo\" in 5 minutes.)"
	echo
	exit
fi

if [[ ! -e $idleExecStart ]]; then
	echo
	echo "${idleExecStart} does not exist. Check path and try again."
	echo
	exit
fi

idleDefaultMinutes=10
idleMinutes=$2

if [[ -n $idleMinutes ]]; then
	idleAfter=$((idleMinutes*60000))
#	echo "Idle timeout set to ${idleMinutes} minutes."
else
	idleAfter=$((idleDefaultMinutes*60000))
#	echo "Idle timeout set to default of ${idleDefaultMinutes} minutes."
fi

echo
echo "Will run ${idleExecStart} after ${idleMinutes} minutes of inactivity."

idleExecStop=$3

if [[ -n $idleExecStop ]]; then
	if [[ -e $idleExecStop ]]; then
		echo "Will run ${idleExecStop} when returning from idle."
	else
		echo
		echo "${idleExecStop} does not exist. Check path and try again."
		echo
		exit
	fi
fi

echo

idle=false

while true; do
#	idleTimeMillis=$(./getIdle)
	idleTimeMillis=$(/home/hunter/.xmrig/monitor/getIdle)
	echo $idleTimeMillis  # just for debug purposes.
	if [[ $idle = false && $idleTimeMillis -gt $idleAfter ]] ; then
#		echo "System idle detected."   # run command here
#		/home/hunter/.xmrig/start-miners.sh
		echo "Executing ${idleExecStart}."
		/bin/bash $idleExecStart
		idle=true
	fi

	if [[ $idle = true && $idleTimeMillis -lt $idleAfter ]] ; then
		echo "System no longer idle."     # same here
#		/home/hunter/.xmrig/stop-miners.sh
		if [[ -n $idleExecStop ]]; then
			echo "Executing ${idleExecStop}."
			/bin/bash $idleExecStop
		fi
		idle=false
	fi

	sleep 1      # polling interval

done
