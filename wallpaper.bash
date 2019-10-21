#!/bin/bash 

sleep 1

# ===========================================================================================
WP_DIR=~/Dropbox/wallpaper # some day, change this folder
time_sec=0
up_limit=120

# ===========================================================================================
function _random_wallpaper()
{
	cd $WP_DIR
	set -- *
	length=$#
	random_num=$((( $RANDOM % ($length) ) + 1))
	gsettings set org.gnome.desktop.background picture-uri "file://$WP_DIR/${!random_num}"
}

# ===========================================================================================
_random_wallpaper
while true ; do
	time_sec=$((time_sec+1))
	if [ "$time_sec" -eq "$up_limit" ]; then
  		time_sec=0
		_random_wallpaper
		sleep 1
	fi
	sleep 5
done
