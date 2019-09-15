#!/bin/bash 

# ===========================================================================================
# setup wallpaper
function _wallpaper_setup()
{
    current_folder=${PWD}
    file="wallpaper.desktop"
    cd ~/.config/autostart/
    if [ ! -f $file ] ; then
        touch $file
        echo '[Desktop Entry]' >> $file
        echo 'Type=Application' >> $file
        echo $dj_convenience_path"/wallpaper.bash" >> $file
        echo 'Hidden=false' >> $file
        echo 'X-GNOME-Autostart-enabled=true' >> $file
        echo 'Name[en_US]=wallpaper' >> $file
        echo 'Name=wallpaper' >> $file
        echo 'Name[en_US]=' >> $file
        echo 'Comment=' >> $file
    fi
    cd $current_folder
}
