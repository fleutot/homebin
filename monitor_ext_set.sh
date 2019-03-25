#!/bin/bash

ALL_MONITORS_STR=$(xrandr --current | grep " connected " | awk 'BEGIN { ORS = " "}; {print $1}' )
read -r -a ALL_MONITORS <<< "$ALL_MONITORS_STR"
echo -e "All monitors: ${ALL_MONITORS[@]}"

NB_CONNECT_OUTPUT="${#ALL_MONITORS[@]}"
echo -e "Number of connected output: $NB_CONNECT_OUTPUT"

MONITOR_LAPTOP=${ALL_MONITORS[0]}
echo -e "Laptop: ${ALL_MONITORS[0]}"

MONITOR_LEFT=${ALL_MONITORS[1]}
echo -e "Left: ${ALL_MONITORS[1]}"

MONITOR_RIGHT=${ALL_MONITORS[2]}
echo -e "Right: ${ALL_MONITORS[2]}"

# If I don't do this first, xrandr gives a strange error (Configure crtc 1 failed)
xrandr --output $MONITOR_LEFT --auto

if [ $NB_CONNECT_OUTPUT == 3 ] ; then
    xrandr \
        --output $MONITOR_LEFT --pos 0x0 --auto --primary \
        --output $MONITOR_RIGHT --right-of $MONITOR_LEFT --auto \
        --output $MONITOR_LAPTOP --auto --pos 960x1200
fi
