#!/bin/sh
rsync -av --delete /home/gauthier /media/cipherstone_data/Backup/ --exclude-from=/home/gauthier/bin/rsync-exclude.txt
