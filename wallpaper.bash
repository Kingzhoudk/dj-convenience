#!/bin/bash 

sleep 1

# ===========================================================================================
# duplicated function from Bito Convenience
_keyremap_wallpaper_enable()
{
    xmodmap ~/workspace/bito_convenience/keyremap_enable.txt
    echo " "
    echo "keyremap enabled"
    echo " "
}

# ===========================================================================================
# duplicated function from Bito Convenience
_keyremap_wallpaper_disable()
{
    xmodmap $dj_convenience_path/keyremap_disable.txt
    echo " "
    echo "keyremap disabled"
    echo " "
}

# ===========================================================================================
# duplicated function from Bito Convenience
function _touchpad_wallpaper_thinkpad_control() {
    # xinput list | grep TouchPad
    touchpad=$(xinput list | grep TouchPad | tr -dc '0-9')
    # the number is not a constant number, for example it was 13, and it then 14 at some time
    touchpadID=${touchpad:1:2}
    xinput set-prop $touchpadID "Device Enabled" $1
    # for my new P52 computer, it is "Touchpad" instead of "TouchPad"
    # xinput list | grep Touchpad
    touchpad=$(xinput list | grep Touchpad | tr -dc '0-9')
    # the number is not a constant number, for example it was 13, and it then 14 at some time
    touchpadID=${touchpad:1:2}
    xinput set-prop $touchpadID "Device Enabled" $1
}


# ===========================================================================================
# keyremap enable
_keyremap_wallpaper_enable
# touchpad thinkpad disable
_touchpad_wallpaper_thinkpad_control 0

# ===========================================================================================
WP_DIR=~/Dropbox/wallpaper # some day, change this folder
time_sec=0
up_limit=120
while true ; do
	time_sec=$((time_sec+1))
	if [ "$time_sec" -eq "$up_limit" ]; then 
  		time_sec=0
  		cd $WP_DIR
		set -- *
		length=$#
		random_num=$((( $RANDOM % ($length) ) + 1)) 
		gsettings set org.gnome.desktop.background picture-uri "file://$WP_DIR/${!random_num}"
		sleep 1 # otherwise, it will not change
	fi
	sleep 5
done
