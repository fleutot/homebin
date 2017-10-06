#!/bin/bash

ALL_MONITORS_STR=$(xrandr --current | grep " connected " | awk 'BEGIN { ORS = " "}; {print $1}' )
read -r -a ALL_MONITORS <<< "$ALL_MONITORS_STR"
NB_CONNECT_OUTPUT="${#ALL_MONITORS[@]}"
MONITOR_LAPTOP=${ALL_MONITORS[0]}
MONITOR_LEFT=${ALL_MONITORS[1]}
MONITOR_RIGHT=${ALL_MONITORS[2]}
if [ $NB_CONNECT_OUTPUT == 3 ] ; then
    xrandr \
        --output $MONITOR_LEFT --pos 0x0 --auto --primary \
        --output $MONITOR_RIGHT --right-of $MONITOR_LEFT --auto \
        --output $MONITOR_LAPTOP --auto --pos 960x1200
fi
