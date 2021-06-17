#!/bin/bash
echo "monitor_ext_set" > /tmp/xmonad.log

LOG_REDIRECT="|tee /tmp/xmonad.log"

# Set awk Output Record Separator to one space, since records are separated by \n by
# default (unlike fields).
ALL_MONITORS_STR=$(xrandr --current | grep " connected " | awk 'BEGIN { ORS = " "}; {print $1}' )
read -r -a ALL_MONITORS <<< "$ALL_MONITORS_STR"
echo -e "All monitors: ${ALL_MONITORS[@]}" $LOG_REDIRECT

NB_CONNECT_OUTPUT="${#ALL_MONITORS[@]}"
echo -e "Number of connected output: $NB_CONNECT_OUTPUT" $LOG_REDIRECT

MONITOR_LAPTOP=${ALL_MONITORS[0]}
echo -e "Laptop: ${ALL_MONITORS[0]}" $LOG_REDIRECT

MONITOR_LEFT=${ALL_MONITORS[1]}
echo -e "Left: ${ALL_MONITORS[1]}" $LOG_REDIRECT

MONITOR_RIGHT=${ALL_MONITORS[2]}
echo -e "Right: ${ALL_MONITORS[2]}" $LOG_REDIRECT

# If I don't do this first, xrandr gives a strange error (Configure crtc 1 failed)
xrandr --output $MONITOR_LEFT --auto

if [ $NB_CONNECT_OUTPUT == 3 ] ; then
    xrandr \
	--output $MONITOR_LEFT --pos 1600x0 --mode 1920x1200 --auto --primary \
        --output $MONITOR_RIGHT --right-of $MONITOR_LEFT --auto \
	--output $MONITOR_LAPTOP --auto --pos 0x300 --mode 1600x900
fi
