#!/bin/bash 

# ===========================================================================================
# setup wallpaper
function _wallpaper_setup()
{
    current_folder=${PWD}
    file="wallpaper.bash.desktop"
    if [ ! -d ~/.config/autostart/ ] ; then
        mkdir -p ~/.config/autostart/
    fi
    cd ~/.config/autostart/
    if [ ! -f $file ] ; then
        echo  '[Desktop Entry]' > $file
        echo  'Type=Application' >> $file
        echo  'Exec='$HOME'/workspace/dj-convenience/wallpaper.bash' >> $file
        echo  'Hidden=false' >> $file
        echo  'X-GNOME-Autostart-enabled=true' >> $file
        echo  'Name[en_US]=wallpaper' >> $file
        echo  'Name=wallpaper' >> $file
        echo  'Comment[en_US]=' >> $file
        echo  'Comment=' >> $file
    fi

    cd $current_folder
}

# ===========================================================================================
function _ask_to_remove_a_file()
{
    gdialog --title 'Remove a File (dj-convenience)' --yesno 'Do you want to remove file "'$1'"?' 9 50
    if [ $? != 0 ] ; then
        gdialog --infobox 'File "'$1'" is NOT removed!' 9 50
    else
        rm $1
        gdialog --infobox 'File "'$1'" is removed!' 9 50
    fi
    gdialog --clear
}

# ===========================================================================================
function _ask_to_remove_a_folder()
{
    gdialog --title 'Remove a Folder (dj-convenience)' --yesno 'Do you want to remove folder "'$1'"?' 9 50
    if [ $? != 0 ] ; then
        gdialog --infobox 'Folder "'$1'" is NOT removed!' 9 50
    else
        rm -rf $1
        gdialog --infobox 'Folder "'$1'" is removed!' 9 50
    fi
    gdialog --clear
}

# ===========================================================================================
function _ask_to_execute_cmd()
{
    echo "command: "$1
    # gdialog --title 'Execute a Command (dj-convenience)' --yesno 'Do you want to execute command '${1}'?' 9 50
    # if [ $? != 0 ] ; then
    #     gdialog --infobox 'Command "'$1'" is NOT executed!' 9 50
    # else
    #     $1
    #     gdialog --infobox 'Command "'$1'" is executed!' 9 50
    # fi
    # gdialog --clear

    echo " "
    echo 'Do you want to execute command "'${1}'"?'
    echo " "
    read answer
    if [[ ($answer = 'n') || ($answer = 'N') || ($answer = 'NO') || ($answer = 'No') || ($answer = 'no') ]] ; then
        echo 'Command "'$1'" is NOT executed!'
    elif [[ ($answer = 'y') || ($answer = 'Y') || ($answer = 'YES') || ($answer = 'Yes') || ($answer = 'yes') ]] ; then
        echo 'Command "'$1'" is going to be executed!'
        $1
    else
        echo "Wrong answer! No action was taken!"
    fi
}

# ===========================================================================================
# a duplicated function from Bito Convenience
function _terminal_format_hostname_short_path_no_space() 
{
    export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;29m\]\h\[\033[00m\]:\[\033[01;36m\]\W\[\033[00m\]$ '
}

# ===========================================================================================
function _write_to_text_file_with_width()
{
    str=$1
    width=$2
    file="$3"
    str_len=${#str}
    if [[ str_len > width ]] ; then
        echo " "
        echo " "
        echo "_write_to_text_file_with_width: width set too short!"
        echo " "
        echo " "
        for ((c=1;c<=$width;c++ )) ; do
            single_char=${str:${c}-1:1}
            echo -ne "$single_char" >> $file
        done
        return 1
    fi
    echo -ne "$str" >> $file
    for ((c=1;c<=$width-$str_len+1;c++ )) ; do
        echo -ne " " >> $file
    done
}

# ===========================================================================================
# duplicated function from Bito Convenience
function _dj_keyremap_enable()
{
    xmodmap ~/workspace/bito_convenience/keyremap_enable.txt
    echo " "
    echo "keyremap enabled"
    echo " "
}

# ===========================================================================================
# duplicated function from Bito Convenience
function _dj_keyremap_disable()
{
    xmodmap $dj_convenience_path/keyremap_disable.txt
    echo " "
    echo "keyremap disabled"
    echo " "
}

# ===========================================================================================
# duplicated function from Bito Convenience
function _dj_touchpad_thinkpad_control()
{
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
