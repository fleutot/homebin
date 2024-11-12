#!/bin/bash
echo "monitor_ext_set" >> /tmp/xmonad.log

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
	--output $MONITOR_LAPTOP --auto --right-of $MONITOR_RIGHT

    # Shift the laptop monitor downwards, closer to where it
    # physically is.
    raw=$(xrandr --current)

    regex="([0-9])+x([0-9]+)\+([0-9]+)\+([0-9]+)"
    right_line=$(echo "$raw" | grep "$MONITOR_RIGHT connected ")
    laptop_line=$(echo "$raw" | grep "$MONITOR_LAPTOP connected ")

    if [[ "$right_line" =~ $regex ]]
    then
	right_y_size=${BASH_REMATCH[2]}
    else
	echo -e "Error parsing xrandr output for right" $LOG_REDIRECT
    fi

    if [[ "$laptop_line" =~ $regex ]]
    then
	laptop_y_size=${BASH_REMATCH[2]}
	laptop_x_pos=${BASH_REMATCH[3]}
	laptop_y_pos=${BASH_REMATCH[4]}
    else
	echo -e "Error parsing xrandr output for laptop" $LOG_REDIRECT
    fi

    laptop_y_pos=$((laptop_y_pos+right_y_size-laptop_y_size))

    xrandr --output $MONITOR_LAPTOP --pos ${laptop_x_pos}x${laptop_y_pos}
fi

if [ $NB_CONNECT_OUTPUT == 2 ] ; then
    # dock with single monitor, duplicate for meeting room
    # TODO: only duplicate if the other monitor has high resolution
    # (meeting room with stupidly large screen).
    xrandr --output $MONITOR_LAPTOP --auto --mode 1920x1080
    xrandr --output $MONITOR_LEFT --auto --mode 1920x1080
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
