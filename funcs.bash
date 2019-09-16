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

# ===========================================================================================
function _ask_to_remove_a_file()
{
    echo " "
    echo 'Do you want to remove file "'$1'" ? [Yes/No]'
    echo " "
    read answer
    if [[ ($answer = 'n') || ($answer = 'N') || ($answer = 'NO') || ($answer = 'No') || ($answer = 'no') ]] ; then
        echo 'You can remove the file "'$1'" manually.'
    elif [[ ($answer = 'y') || ($answer = 'Y') || ($answer = 'YES') || ($answer = 'Yes') || ($answer = 'yes') ]] ; then
        echo 'File "'$1'" is removed.'
        sudo rm $1
    else
        echo "Wrong answer! No file was removed!"
    fi
}


# ===========================================================================================
function _ask_to_take_an_action()
{
    echo " "
    echo 'Do you want to execute command: "'$1'"? [Yes/No]'
    echo " "
    read answer
    if [[ ($answer = 'n') || ($answer = 'N') || ($answer = 'NO') || ($answer = 'No') || ($answer = 'no') ]] ; then
        echo 'Command "'$1'" is not executed.'
    elif [[ ($answer = 'y') || ($answer = 'Y') || ($answer = 'YES') || ($answer = 'Yes') || ($answer = 'yes') ]] ; then
        $1
    else
        echo "Wrong answer! No command was taken!"
    fi
    echo " "
}
