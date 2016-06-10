#!/bin/bash

cd $(dirname $0)

log() {

  echo "$(date +%Y-%m-%d" "%H:%M:%S) $*" >&2

}

if [ "x$1" != "x--" ]; then
  ./$(basename $0) -- &> .$(basename $0 .sh).log &
  echo pid=$! >&2 |& tee -a .$(basename $0 .sh).log
  disown
  exit 0
fi

log Starting $(basename $0)

while true; do

  status1=$(mpc | grep "\[playing\]")
  sleep 1

  [ -z "$status1" ] && continue

  status2=$(mpc | grep "\[playing\]")

  [ "$status1" == "$status2" ] && log ERROR: stream has stopped && sudo service mpd restart && sleep 30

done
