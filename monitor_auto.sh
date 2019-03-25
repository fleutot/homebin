#!/bin/bash

ALL_DISCONNECTED_MONITORS_STR=$(xrandr --current | grep " disconnected " | awk 'BEGIN { ORS = " "}; {print $1}' )
read -r -a ALL_DISCONNECTED_MONITORS <<< "$ALL_DISCONNECTED_MONITORS_STR"

for m in ${ALL_DISCONNECTED_MONITORS[@]} ; do
    # echo "Turning off monitor $m"
    xrandr --output $m --off
done

ALL_CONNECTED_MONITORS_STR=$(xrandr --current | grep " connected " | awk 'BEGIN { ORS = " "}; {print $1}' )
read -r -a ALL_CONNECTED_MONITORS <<< "$ALL_CONNECTED_MONITORS_STR"

MONITOR_LAPTOP="eDP-1"
xrandr --output $MONITOR_LAPTOP --auto --primary
PREV_MON=$MONITOR_LAPTOP
for m in ${ALL_CONNECTED_MONITORS[@]} ; do
    if [ $m != $MONITOR_LAPTOP ]; then
        echo "Turning on monitor $m"
        xrandr --output $m --auto --right-of $PREV_MON
        PREV_MON=$m
    fi
done

if type compton; then
    # start compton if not running. xrandr seems to crash it sometimes.
    pgrep compton || compton --config "$HOME/.xmonad/compton.conf" &
fi
