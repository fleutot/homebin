#!/bin/bash
echo "monitor_laptop_set" > /tmp/xmonad.log

# Note no space before "connected", which means "disconnected" will also match.
ALL_MONITORS_STR=$(xrandr --current | grep "connected " | awk 'BEGIN { ORS = " "}; {print $1}' )
read -r -a ALL_MONITORS <<< "$ALL_MONITORS_STR"

for m in ${ALL_MONITORS[@]} ; do
    echo "Turning off monitor $m"
    xrandr --output $m --off
done

MONITOR_LAPTOP="eDP-1"
echo "Monitor laptop is $MONITOR_LAPTOP"
xrandr --output $MONITOR_LAPTOP --auto --primary

if type compton; then
    # start compton if not running. xrandr seems to crash it sometimes.
    pgrep compton || compton --config "$HOME/.xmonad/compton.conf" &
fi

