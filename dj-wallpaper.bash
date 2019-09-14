#!/bin/bash 

sleep 1

WP_DIR=~/Dropbox/wallpaper # some day, change this folder
aa=0
a0=0
bb=120
cc=5
while true ; do
	# # keyboard remap ------------------
	# if [ "$a0" -le "$cc" ]; then
	# 	xmodmap ~/workspace/bito_convenience/keyremap_enable.txt
	# 	echo $a0
	# fi
	a0=$((a0+1))
	aa=$((aa+1))
	#echo $aa
	if [ "$aa" -eq "$bb" ]; then 
  		aa=0 
  		# wallpaper change ----------------
  		# copied from wallpaper.sh
  		cd $WP_DIR
		set -- *
		length=$#
		random_num=$((( $RANDOM % ($length) ) + 1)) 
		gsettings set org.gnome.desktop.background picture-uri "file://$WP_DIR/${!random_num}"
		sleep 1 # otherwise, it will not change
	fi
	sleep 5
done
