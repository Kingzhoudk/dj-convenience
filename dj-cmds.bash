#!/bin/bash 

# ===========================================================================================
function _dj_help()
{
    echo " "
    echo "------------------------ dj -------------------------"
    echo " Author      : Dingjiang Zhou"
    echo " Email       : zhoudingjiang@gmail.com "
    echo " Create Date : 2019-09-11"
    echo "-----------------------------------------------------"
    echo " "
    echo " First level commands:"
    echo "   setup   - to install some software"
    echo "   MORE IS COMMING"
    echo " "
    echo " All commands support tab completion"
    echo " "
}

# ===========================================================================================
function _dj_setup_help()
{
    _dj_help
    echo "--------------------- dj setup ----------------------"
    echo " Second level commands:"
    echo "   computer - to pre install lots of necessary"
    echo "              software package"
    echo "   eigen    - to install eigen library"
    echo "   i219-v   - to install Intel I219-V WiFi chipset"
    echo "              driver"
    echo "   MORE IS COMMING"
    echo "-----------------------------------------------------"
    echo " "
}

# ===========================================================================================
function _dj_setup_computer()
{
    current_folder=${PWD}

    cd ~

    sudo apt-get update -y
    sudo apt-get upgrade -y

    sudo apt-get install curl g++ git vim terminator kate scrot wmctrl -y
    sudo apt-get install dconf-editor dconf-tools vlc cutecom -y
    sudo apt-get install ark yasm cmake libgtk2.0-dev -y

    # -----------------------------------
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome*

    _ask_to_remove_a_file google-chrome*

    # -----------------------------------
    # windows fonts
    sudo apt-get install ttf-mscorefonts-installer -y
    sudo apt-get install msttcorefonts -y
    sudo apt-get install gtk2-engines-pixbuf -y # works for solving the GTK warning

    # -----------------------------------
    # remove firefox
    sudo apt-get purge firefox -y; rm -R ~/.mozilla/firefox/;

    # to display simplified chinese: important, do not comment out!
    gsettings set org.gnome.gedit.preferences.encodings auto-detected "['CURRENT','GB18030','GBK','GB2312','UTF-8','UTF-16']"

    # -----------------------------------
    # to lock the screen from commands
    sudo apt-get install gnome-screensaver -y

    cd $current_folder

}

# ===========================================================================================
function _dj_setup_eigen()
{
    current_folder=${PWD}

    sudo apt-get install libeigen3-dev
    sudo updatedb
    # locate eigen3
    echo " "
    echo " eigen is installed in: /usr/include/eigen3"
    echo " "

    cd $current_folder
}

# ===========================================================================================
function _dj_setup_i219_v()
{
    current_folder=${PWD}

    cd ~
    
    git clone https://sky-Hawk@bitbucket.org/sky-Hawk/$1.git
    cd $1
    tar zxf e1000e-*.tar.gz
    cd $1/src/
    sudo make install

    cd ~
    _ask_to_remove_a_folder ~/$1

    _ask_to_take_an_action "sudo reboot"

    cd $current_folder
}

# ===========================================================================================
function dj {
    # ------------------------------
    if [ $# -eq 0 ] ; then
        _dj_help
        return
    fi
    # ------------------------------
    if [ $1 = 'setup' ] ; then
        # --------------------------
        if [ $2 = 'computer' ] ; then
            _dj_setup_computer
            return
        fi
        # --------------------------
        if [ $2 = 'eigen' ] ; then
            _dj_setup_eigen
            return
        fi
        # --------------------------
        if [ $2 = 'i219-v' ] ; then
            _dj_setup_i219_v $3
            return
        fi
        # --------------------------
        _dj_setup_help
        return
    fi
    _dj_help
    # ------------------------------
}

# ===========================================================================================
function _dj()
{
    COMPREPLY=()

    # All possible first values in command line
    local SERVICES=("
        setup
    ")

    # declare an associative array for options
    declare -A ACTIONS

    ACTIONS[setup]+="computer eigen i219-v "
    ACTIONS[eigen]=" "
    ACTIONS[i219-v]="e1000e-3.4.2.1 e1000e-3.4.2.4 "
    ACTIONS[e1000e-3.4.2.1]=" "
    ACTIONS[e1000e-3.4.2.4]=" "

    # --------------------------------------------------------
    local cur=${COMP_WORDS[COMP_CWORD]}
    if [ ${ACTIONS[$3]+1} ] ; then
        COMPREPLY=( `compgen -W "${ACTIONS[$3]}" -- $cur` )
    else
        COMPREPLY=( `compgen -W "${SERVICES[*]}" -- $cur` )
    fi
}

# ===========================================================================================
complete -F _dj dj
