#!/bin/bash 

# ===========================================================================================
# setup wallpaper
function _wallpaper_setup()
{
    current_folder=${PWD}
    file="wallpaper.bash.desktop"
    cd ~/.config/autostart/
    if [ ! -f $file ] ; then
        cp $dj_convenience_path/$file .
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
