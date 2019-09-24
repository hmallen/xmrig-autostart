#!/bin/bash

IDLE_DEFAULT_MINUTES=10
IDLE_MINUTES=$1

if [[ -n $IDLE_MINUTES ]]; then
	idleAfter=$((IDLE_MINUTES*60000))
	echo "Idle timeout set to ${IDLE_MINUTES} minutes."
else
	idleAfter=$((IDLE_DEFAULT_MINUTES*60000))
	echo "Idle timeout set to default of ${IDLE_DEFAULT_MINUTES} minutes."
fi

idle=false
#idleAfter=3000

while true; do
  idleTimeMillis=$(./getIdle)
  #echo $idleTimeMillis  # just for debug purposes.
  if [[ $idle = false && $idleTimeMillis -gt $idleAfter ]] ; then
    echo "System idle detected."   # run command here
    idle=true
  fi

  if [[ $idle = true && $idleTimeMillis -lt $idleAfter ]] ; then
    echo "System no longer idle."     # same here.
    idle=false
  fi
  sleep 1      # polling interval

done
