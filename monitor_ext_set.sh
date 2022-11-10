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
	--output $MONITOR_LEFT --auto --primary \
        --output $MONITOR_RIGHT --right-of $MONITOR_LEFT --auto \
	--output $MONITOR_LAPTOP --auto --right-of $MONITOR_RIGHT --mode 1680x1050
fi

if [ $NB_CONNECT_OUTPUT == 2 ] ; then
    # dock with single monitor, don't use laptop
    xrandr \
	--output $MONITOR_LAPTOP --off \
        --output $MONITOR_LEFT --auto
fi

if [ $NB_CONNECT_OUTPUT == 1 ] ; then
    for m in ${ALL_MONITORS[@]} ; do
	echo "Turning off monitor $m"
	xrandr --output $m --off
    done

    # dock with single monitor, don't use laptop
    xrandr --output $MONITOR_LAPTOP --auto --primary
fi

if type compton; then
    # start compton if not running. xrandr seems to crash it sometimes.
    pgrep compton || compton --config "$HOME/.xmonad/compton.conf" &
fi
