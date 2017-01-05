#!/bin/bash


run () {
while [ $(date +%H) -ne 3 ]; do
  sleep 60
done

mpc volume 40
mpc play
for x in {41..80}; do
  mpc volume $x
done

while [ $(date +%H) -ne 4 ]; do
  sleep 60
done

mpc stop

}

run &
