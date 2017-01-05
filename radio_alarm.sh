#!/bin/bash

cd $(dirname $0)

#set -e

log() {

  echo "$(date +%Y-%m-%d" "%H:%M:%S) $*" >&2

}

volume() {

  for vol in {40..70}; do
    mpc volume $vol
    sleep 30
  done

}

if [ "x$1" != "x--" ]; then
  ./$(basename $0) -- &> .radio_alarm.log &
  echo pid=$! >&2 |& tee -a .radio_alarm.log
  disown
  exit 0
fi

log starting...

START=$(cat .alarm_start) || START=0700
STOP=$(cat .alarm_stop) || STOP=1000

log Radio will play between $START and $STOP

# Reset Alarm
echo true > .alarm_switch

while true; do

  [ $(date +%u) -gt 5 ] && log weekend && sleep 21600

  [ $(date +%H%M) -eq $START ] && log start && \
    sudo service networking restart && sleep 10 && \
    mpc clear && \
    mpc add http://178.79.224.13/stream/bbcmedia_6music_mf_p && \
    mpc play && volume

  [ $(date +%H%M) -eq 0900 ] && mpc volume 80 && sleep 60

  [ $(date +%H%M) -eq $STOP ] && log auto stop && mpc stop && sleep 60
  ! $(cat .alarm_switch) && log force stop && mpc stop

  START=$(cat .alarm_start) 2>/dev/null || START=0700
  STOP=$(cat .alarm_stop) 2>/dev/null || STOP=1000

  sleep 1

done
