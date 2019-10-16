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
    echo "   clone   - clone a repo from bitbucket/github"
    echo " "
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
    echo "   foxit    - the foxit PDF reader"
    echo "   yaml-cpp - C++ based yaml file parser"
    echo "   pip      - python software pip"
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
    
    git clone https://dj-zhou@github.com/dj-zhou/$1.git
    cd $1/src/
    sudo make install

    cd ~
    _ask_to_remove_a_folder ~/$1

    _ask_to_execute_cmd "sudo reboot"

    cd $current_folder
}

# ===========================================================================================
function _dj_setup_foxit_reader()
{
    current_folder=${PWD}
    cd ~
    # no way to get the latest version?
    wget http://cdn01.foxitsoftware.com/pub/foxit/reader/desktop/linux/2.x/2.4/en_us/FoxitReader.enu.setup.2.4.4.0911.x64.run.tar.gz
    gzip -d FoxitReader.enu.setup.2.4.4.0911.x64.run.tar.gz
    tar xvf FoxitReader.enu.setup.2.4.4.0911.x64.run.tar
    sudo ./FoxitReader.enu.setup.*.run
    cd $current_folder
}

# ===========================================================================================
function _dj_setup_pangolin()
{
    current_folder=${PWD}
    # dependency installation
    sudo apt-get install libglew-dev mesa-utils -y
    sudo apt-get install libglm-dev -y # opengl related mathematics lib
    # use command 'glxinfo | grep "OpenGL version" ' to see opengl version in Ubuntu
    
    cd ~
    git clone https://dj-zhou@github.com/dj-zhou/pangolin.git
    cd pangolin
    git checkout add-eigen3-include
    git pull
    mkdir build && cd build
    cmake ..
    make -j$(cat /proc/cpuinfo | grep processor | wc -l)
    sudo make install
    cd ~
    _ask_to_remove_a_folder pangolin
    echo " "
    echo "libpangolin.so is in path: /usr/local/lib/"
    echo "header files (i.e., pangolin/pangolin.h) are in path: /usr/local/include/"
    echo " "
    
    cd $current_folder
}

# ===========================================================================================
function _dj_setup_yaml_cpp()
{
    cwd_before_running=$PWD

    cd ~
    dj clone github yaml-cpp
    cd yaml-cpp
    rm -rf build/ && mkdir build
    cd build && cmake -DYAML_BUILD_SHARED_LIBS=ON ..
    make -j$(cat /proc/cpuinfo | grep processor | wc -l)
    sudo make install
    cd ~

    echo " "
    echo "libyaml-cpp.a is installed in /usr/local/lib/"
    echo "header files are installed in /usr/local/include/yaml-cpp/"
    echo " "

    _ask_to_remove_a_folder ~/yaml-cpp/

    cd ${cwd_before_running}
}

# ===========================================================================================
function _dj_setup_pip()
{
    cwd_before_running=$PWD
    cd ~/

    # method 1: from https://www.zhihu.com/question/56927648
    # the webpage says it is for installing python3 (and pip)
    # curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    # python get-pip.py --force-reinstall

    # _ask_to_remove_a_file ~/get-pip.py

    # to show pip installation
    # pip show pip

    # method 2:
    sudo apt-get install python3-pip

    # also need to install python-pip??
    sudo apt-get install python-pip
    cd ${cwd_before_running}
}


# ===========================================================================================
function _dj_setup_typora()
{
    wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
    # add Typora's repository
    sudo add-apt-repository 'deb https://typora.io/linux ./'
    sudo apt-get update
    # install typora
    sudo apt-get install typora
}

# ===========================================================================================
# call function in workspace-check.bash
function _dj_version_check()
{
    _version_check $1 $2 $3 $4
}

# ===========================================================================================
function dj()
{
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
        if [ $2 = 'foxit' ] ; then
            _dj_setup_foxit_reader
            return
        fi
        # --------------------------
        if [ $2 = 'pangolin' ] ; then
            _dj_setup_pangolin
            return
        fi
        # --------------------------
        if [ $2 = 'yaml-cpp' ] ; then
            _dj_setup_yaml_cpp
            return
        fi
        # --------------------------
        if [ $2 = 'pip' ] ; then
            _dj_setup_pip
            return
        fi
        # --------------------------
        if [ $2 = 'typora' ] ; then
            _dj_setup_typora
            return
        fi
        # --------------------------
        _dj_setup_help
        return
    fi
    # ------------------------------
    if [ $1 = 'clone' ] ; then
        # --------------------------
        if [ $2 = 'bitbucket' ] ; then
            _dj_clone_bitbucket $3 $4 $5 $6 $7
            return
        fi
        # --------------------------
        if [ $2 = 'github' ] ; then
            _dj_clone_github $3 $4 $5 $6 $7
            return
        fi
        # --------------------------
        _dj_clone_help
        return
    fi
    # ------------------------------
    if [ $1 = 'version-check' ] ; then
        _dj_version_check $2 $3 $4 $5
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
        version-check
    ")

    # declare an associative array for options
    declare -A ACTIONS

    ACTIONS[setup]+="computer eigen i219-v foxit pangolin yaml-cpp "
    ACTIONS[setup]+="pip typora "
    ACTIONS[eigen]=" "
    ACTIONS[i219-v]="e1000e-3.4.2.1 e1000e-3.4.2.4 "
    ACTIONS[e1000e-3.4.2.1]=" "
    ACTIONS[e1000e-3.4.2.4]=" "
    ACTIONS[foxit]=" "
    ACTIONS[pangolin]=" "
    ACTIONS[yaml-cpp]=" "
    ACTIONS[pip]=" "
    ACTIONS[typora]=" "
    #---------------------------------------------------------
    # ACTIONS[clone]="bitbucket github "
    # #---------------------------------------------------------
    # ACTIONS[bitbucket]+="dj-convenience lib-stm32f4-v2 eigen-demo "
    # ACTIONS[dj-convenience]=" "
    # ACTIONS[lib-stm32f4-v2]=" "
    # ACTIONS[dj-lib-cpp]=" "
    # ACTIONS[eigen-demo]=" "
    # #---------------------------------------------------------
    # ACTIONS[github]="dj-lib-cpp yaml-cpp pangolin-demo dj-convenience "
    # ACTIONS[version-check]=" "
    # ACTIONS[yaml-cpp]=" "
    # ACTIONS[pangolin-demo]=" "
    # ACTIONS[dj-conveneince]=" "
    # #---------------------------------------------------------
    # ACTIONS[github]+="pangolin e1000e-3.4.2.1 e1000e-3.4.2.4 "
    # ACTIONS[pangolin]=" "
    # ACTIONS[e1000e-3.4.2.1]=" "
    # ACTIONS[e1000e-3.4.2.4]=" "


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
source $dj_convenience_path/dj-clone-config.bash
complete -F _dj_zhou_github dj