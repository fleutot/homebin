#!/bin/bash

# Note no space before "connected", which means "disconnected" will also match.
ALL_MONITORS_STR=$(xrandr --current | grep "connected " | awk 'BEGIN { ORS = " "}; {print $1}' )
read -r -a ALL_MONITORS <<< "$ALL_MONITORS_STR"

for m in ${ALL_MONITORS[@]} ; do
    echo "Turning off monitor $m"
    xrandr --output $m --off
done

MONITOR_LAPTOP="eDP-1"
xrandr --output $MONITOR_LAPTOP --auto --primary
