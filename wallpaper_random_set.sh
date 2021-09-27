#!/bin/bash
# Choose and set a random wallpaper in the directory $WALLPAPER_DIR.
#
# Note that if you want to use this from a cron job, you'll have to specify the
# full path to this very script (PATH is not available).
# You also probably need to provide the X display, found with `echo $DISPLAY`.
# Example:
# * * * * * *  DISPLAY=:0 $HOME/bin/wallpaper_random_set.sh >> /tmp/cron_wallpaper.log 2>&1

WALLPAPER_DIR="$HOME/Pictures/wallpapers/fuzzy"
DISPLAY=:0 feh --bg-fill "$WALLPAPER_DIR/$(ls $WALLPAPER_DIR | sort -R | head -1)"
#DISPLAY=:0 feh --bg-fill --randomize $WALLPAPER_DIR # This sets different wallpapers for different monitors

# I read somewhere that you can update your PATH in the cron file (it's not the
# same as upon login, since .bashrc and similar are not loaded. Even env cannot
# seem to run), but the following does not seem to work:
# PATH=$HOME/bin:$PATH  # <-- DOES NOT WORK
# * * * * * * wallpaper_random_set.sh >> /tmp/cron_wallpaper.log 2>&1
