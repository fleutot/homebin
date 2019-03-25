#!/bin/bash

# Packages
sudo apt-get update

sudo apt-get install -y git
sudo apt-get install -y gitk
sudo apt-get install -y emacs
sudo apt-get install -y trayer
sudo apt-get install -y xmonad
sudo apt-get install -y xmobar
sudo apt-get install -y compton
#sudo apt-get install -y unclutter # Use locally compiled alternative below
sudo apt-get install -y kbdd
sudo apt-get install -y feh
sudo apt-get install -y icdiff
sudo apt-get install -y xfonts-terminus
sudo apt-get install -y arc-theme
sudo apt-get install -y nm-applet
sudo apt-get install -y ack-grep
sudo apt-get install -y bash-completion
sudo apt-get install -y xclip
sudo apt-get install -y rofi

sudo apt-get install -y xautolock
sudo apt-get install -y i3lock

# Create an rsa key to connect to github.com
if [ ! -f $HOME/.ssh/id_rsa.pub ]; then
    echo "No existing rsa key found, create a new one..."
    ssh-keygen
else
    echo "Using existing rsa key..."
fi

if [ -f $HOME/.ssh/id_rsa.pub ]; then
    xclip -sel clip < $HOME/.ssh/id_rsa.pub
    echo "SSH public key saved to clipboard, create a new key at github..."
    xdg-open https://github.com/settings/keys
else
    echo "\033[1;31mERROR\033[0m: failed to create or find an rsa public key!"
    exit 1
fi

# Clone settings from github.com
# The following commands should not be run as super user.
cd $HOME

git clone git://github.com/fleutot/.emacs.d.git

git clone git://github.com/fleutot/homebin.git && mv homebin bin

git clone git://github.com/fleutot/dotfiles.git && cd dotfiles && ./setlinks
cd $HOME

git clone git://github.com/fleutot/kinesis.git

# Notify the user about things that might have to be done manually
# No need to comment about the unclutter defaults since using another version:
#echo -e "\033[1;33mNOTE\033[0m: unclutter has default settings in /etc/default/unclutter. You might want to edit this file to start unclutter on your own, with the options you want."


# Build and install unclutter with xfixes.
mkdir -p ~/code
cd ~/code
git clone https://github.com/Airblader/unclutter-xfixes.git
sudo apt-get install -y libev-dev
sudo apt-get install -y libxi-dev
sudo apt-get install -y asciidoc
cd unclutter-xfixes
make
sudo make install
