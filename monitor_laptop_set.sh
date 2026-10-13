#!/bin/bash
echo "monitor_laptop_set" >> "$XMONAD_LOG_FILE"

# Note no space before "connected", which means "disconnected" will also match.
ALL_MONITORS_STR=$(xrandr --current | grep "connected " | awk 'BEGIN { ORS = " "}; {print $1}' )
read -r -a ALL_MONITORS <<< "$ALL_MONITORS_STR"

MONITOR_LAPTOP="eDP-1"

laptop_found=0
for m in "${ALL_MONITORS[@]}" ; do
    if [[ "$m" == "$MONITOR_LAPTOP" ]]; then
	laptop_found=1
	break
    fi
done

if (( laptop_found == 0 )); then
    echo "Laptop monitor $MONITOR_LAPTOP not found cannot undock!" >> "$XMONAD_LOG_FILE"
    exit 1
fi

for m in "${ALL_MONITORS[@]}" ; do
    echo "Turning off monitor $m"
    xrandr --output "$m" --off
done

echo "Monitor laptop is $MONITOR_LAPTOP"
xrandr --output $MONITOR_LAPTOP --auto --primary

if type compton; then
    # start compton if not running. xrandr seems to crash it sometimes.
    pgrep compton || compton --config "$HOME/.xmonad/compton.conf" &
fi

echo "monitor_laptop_set finished" >> "$XMONAD_LOG_FILE"
