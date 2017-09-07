#!/bin/bash
# Temporary, working with the grey USB-C dongle I got with my old Mac
# Find monitor names with xrandr first.

#xrandr --output eDP-1 --auto --pos 1600x1200 --output DP-1 --above eDP-1 --auto --primary

# With an x-offset for the laptop monitor
#xrandr --output eDP-1 --auto --pos 960x1200 \
       #--output DP-1 --pos 0x0 --auto --primary

#NB_CONNECT_OUTPUT=$(xrandr --current | grep " connected " | wc -l)
#
#if [ $NB_CONNECT_OUTPUT == 3 ] ; then
#       echo RUN
#       xrandr \
#              --output DP-1-1 --pos 0x0 --auto --primary \
#              --output DP-1-2 --right-of DP-1-1 --auto \
#              --output eDP-1 --auto --pos 960x1200
#fi

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
