#!/bin/sh
# Shell script to control the fan on Archlinux Odroid XU-3
# Compare every temperatures
TMU_PATH="/sys/bus/platform/drivers/exynos-tmu/10060000.tmu/temp"
# Path of the Duty file used to set the throttle from 60 to 255
FAN_PATH="/sys/bus/platform/drivers/odroid-fan/odroid_fan.15/pwm_duty"
FAN_MODE="/sys/bus/platform/drivers/odroid-fan/odroid_fan.15/fan_mode"
# Timer for the infinite while loop
FAN_MIN=60
FAN_MAX=255
FAN_RATIO=5
FAN_OFFSET=140
WAIT_TIME=15
echo 0 > $FAN_MODE 
while true;
do
  T=`cat $TMU_PATH | cut -b 11-15 | sort -r | head -n 1`
  T=$(( $T / 200 - $FAN_OFFSET ))
  if [ "$T" -gt 255 ];
  then
    echo 255 > $FAN_PATH
  elif [ "$T" -lt 60 ];
  then
    echo 60 > $FAN_PATH
  else
    echo "$T" > $FAN_PATH
  fi
  sleep $WAIT_TIME
done
