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
    gdialog --title 'Remove a File (dj-convenience)' --yesno 'Do you want to remove file "'$1'"?' 9 50
    if [ $? != 0 ] ; then
        gdialog --infobox 'File "'$1'" is not removed!' 9 50
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
        gdialog --infobox 'Folder "'$1'" is not removed!' 9 50
    else
        rm -rf $1
        gdialog --infobox 'Folder "'$1'" is removed!' 9 50
    fi
    gdialog --clear
}

# ===========================================================================================
function _ask_to_execute_cmd()
{
    gdialog --title 'Execute a Command (dj-convenience)' --yesno 'Do you want to execute command "'$1'"?' 9 50
    if [ $? != 0 ] ; then
        gdialog --infobox 'Command "'$1'" is not executed!' 9 50
    else
        $1
        gdialog --infobox 'Command "'$1'" is executed!' 9 50
    fi
    gdialog --clear
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
