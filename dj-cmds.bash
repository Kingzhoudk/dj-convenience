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
function _dj_setup_qt_5_11_2()
{
    cwd_before_running=$PWD

    echo "  "
    echo "Install Qt 5.11.2" 
    echo "  "
    sleep 2

    cd ~
    filename="qt-opensource-linux-x64-5.11.2.run"
    wget http://qt.mirror.constant.com/archive/qt/5.11/5.11.2/$filename
    chmod +x $filename
    ./$filename

    _ask_to_remove_a_file $filename
    
    # install serialport module
    sudo apt-get install libqt5serialport5-dev -y

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
function _dj_setup_glfw3_gtest_glog()
{
    cwd_before_running=$PWD

    echo " "
    echo "  Install glfw3, gtest, glog ..."
    echo " "
    sleep 2
    cd ~
    
    # glfw3
    sudo apt-get -y install build-essential cmake git xorg-dev libglu1-mesa-dev -y
    sudo rm -rf glfw3/
    git clone https://dj-zhou@github.com/dj-zhou/glfw3.git
    cd glfw3/
    mkdir build && cd build/
    cmake .. -DBUILD_SHARED_LIBS=ON
    make -j$(cat /proc/cpuinfo | grep processor | wc -l)
    sudo make install && sudo ldconfig
    cd ~
    _ask_to_remove_a_folder glfw3
    
    # gtest
    sudo apt-get install libgtest-dev -y
    cd /usr/src/gtest
    sudo cmake CMakeLists.txt
    sudo make
    sudo cp *.a /usr/local/lib

    # glog
    sudo apt-get install libgoogle-glog-dev -y

    cd ${cwd_before_running}
}


# ===========================================================================================
# note: under test in Ubuntu 18.04
function _dj_setup_opencv_2_4_13()
{
    cwd_before_running=$PWD

    echo " "
    echo " Have you installed Qt? The openCV installation may need Qt"
    echo " use the following command to install Qt 5.11.2"
    echo " "
    sleep 3

    cd ~/
    mkdir -p soft/
    cd soft/
    wget https://codeload.github.com/opencv/opencv/zip/2.4.13.6
    mv 2.4.13.6 opencv-2.4.13.6.zip
    unzip opencv-2.4.13.6.zip
    cd opencv-2.4.13.6
    mkdir build && cd build
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D WITH_V4L=ON -D WITH_QT=ON -D WITH_OPENGL=ON WITH_OPENCL=ON WITH_GDAL=ON WITH_IPP=ON BUILD_JASPER=ON BUILD_JPEG=ON BUILD_PNG=ON BUIILD_TIFF=ON WITH_OPENMP=ON ..
    make -j$(cat /proc/cpuinfo | grep processor | wc -l) && sudo make install

    _ask_to_remove_a_folder ~/opencv-2.4.13
    _ask_to_remove_a_file ~/opencv-2.4.13.zip

    cd ${cwd_before_running}
    echo " "
    echo " lib files *.so are installed in /usr/local/lib/"
    echo " header files are installded in /usr/local/include/opencv2/"
    echo " "
}

# ===========================================================================================
# note: under test in Ubuntu 18.04
function _dj_setup_opencv_4_0_0()
{
    cwd_before_running=$PWD

    echo " "
    echo " Have you installed Qt? The openCV installation may need Qt"
    echo " use the following command to install Qt 5.11.2"
    echo " "
    sleep 3

    cd ~/
    mkdir -p soft/
    cd soft/
    wget https://codeload.github.com/opencv/opencv/zip/4.0.0
    mv 4.0.0 opencv-4.0.0.zip
    unzip opencv-4.0.0.zip
    cd opencv-4.0.0
    mkdir build && cd build
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D WITH_V4L=ON -D WITH_QT=ON -D WITH_OPENGL=ON WITH_OPENCL=ON WITH_GDAL=ON WITH_IPP=ON BUILD_JASPER=ON BUILD_JPEG=ON BUILD_PNG=ON BUIILD_TIFF=ON WITH_OPENMP=ON ..
    make -j$(cat /proc/cpuinfo | grep processor | wc -l) && sudo make install

    _ask_to_remove_a_folder ~/opencv-4.0.0
    _ask_to_remove_a_file ~/opencv-4.0.0.zip
    cd ${cwd_before_running}
    echo " "
    echo " lib files *.so are installed in /usr/local/lib/"
    echo " header files are installded in /usr/local/include/opencv4/, in which there is another folder opencv2/"
    echo " "
}

# ===========================================================================================
function _dj_setup_opencv_4_1_1()
{
    cwd_before_running=$PWD

    echo " "
    echo " Have you installed Qt? The openCV installation may need Qt"
    echo " use the following command to install Qt 5.11.2"
    echo " "
    sleep 3

    cd ~/
    mkdir -p soft/
    cd soft/
    wget https://codeload.github.com/opencv/opencv/zip/4.1.1
    mv 4.1.1 opencv-4.1.1.zip
    unzip opencv-4.1.1.zip
    cd opencv-4.1.1
    mkdir build && cd build
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D WITH_V4L=ON -D WITH_QT=ON -D WITH_OPENGL=ON WITH_OPENCL=ON WITH_GDAL=ON WITH_IPP=ON BUILD_JASPER=ON BUILD_JPEG=ON BUILD_PNG=ON BUIILD_TIFF=ON WITH_OPENMP=ON ..
    make -j$(cat /proc/cpuinfo | grep processor | wc -l) && sudo make install

    _ask_to_remove_a_folder ~/opencv-4.1.1
    _ask_to_remove_a_file ~/opencv-4.1.1.zip
    cd ${cwd_before_running}
    echo " "
    echo " lib files *.so are installed in /usr/local/lib/"
    echo " header files are installded in /usr/local/include/opencv4/, in which there is another folder opencv2/"
    echo " "
}
# ===========================================================================================
function _dj_clone_help()
{
    _dj_help
    echo "--------------------- dj clone ----------------------"
    echo " Second level commands:"
    echo "   bitbuket - to clone repo from bitbucket"
    echo "   github   - to clone repo from github"
    echo "   MORE IS COMMING"
    echo "-----------------------------------------------------"
    echo " "
}

# ===========================================================================================
function _dj_clone_bitbucket()
{
    echo " "
    echo "dj clone "$1" with bitbucket username"$bitbucket_username
    echo " "
    git clone https://$bitbucket_username@bitbucket.org/$bitbucket_username/$1.git
}

# ===========================================================================================
function _dj_clone_github()
{
    echo " "
    echo "dj clone "$1" with github username "$github_username
    echo " "
    git clone https://$github_username@github.com/$github_username/$1.git
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
        if [ $2 = 'qt-5.11.2' ] ; then
            _dj_setup_qt_5_11_2
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
        if [ $2 = 'glfw3-gtest-glog' ] ; then
            _dj_setup_glfw3_gtest_glog
            return
        fi
        # --------------------------
        if [ $2 = 'opencv-4.0.0' ] ; then
            _dj_setup_opencv_4_0_0
            return
        fi
        # --------------------------
        if [ $2 = 'opencv-4.1.1' ] ; then
            _dj_setup_opencv_4_1_1
            return
        fi
        # --------------------------
        if [ $2 = 'opencv-2.4.13' ] ; then
            _dj_setup_opencv_2_4_13
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
        clone
        version-check
    ")

    # declare an associative array for options
    declare -A ACTIONS

    ACTIONS[setup]+="computer eigen i219-v foxit pangolin yaml-cpp qt-5.11.2 "
    ACTIONS[setup]+="pip typora glfw3-gtest-glog opencv-4.0.0 opencv-2.4.13 "
    ACTIONS[setup]+=" opencv-4.1.1 "
    ACTIONS[computer]=" "
    ACTIONS[eigen]=" "
    ACTIONS[i219-v]="e1000e-3.4.2.1 e1000e-3.4.2.4 "
    ACTIONS[e1000e-3.4.2.1]=" "
    ACTIONS[e1000e-3.4.2.4]=" "
    ACTIONS[foxit]=" "
    ACTIONS[pangolin]=" "
    ACTIONS[yaml-cpp]=" "
    ACTIONS[qt-5.11.2]=" "
    ACTIONS[pip]=" "
    ACTIONS[typora]=" "
    ACTIONS[glfw3-gtest-glog]=" "
    ACTIONS[opencv-4.0.0]=" "
    ACTIONS[opencv-4.1.1]=" "
    ACTIONS[opencv-2.4.13]=" "
    #---------------------------------------------------------
    ACTIONS[clone]="bitbucket github "
    #---------------------------------------------------------
    ACTIONS[bitbucket]+="dj-convenience lib-stm32f4-v2 eigen-demo "
    ACTIONS[dj-convenience]=" "
    ACTIONS[lib-stm32f4-v2]=" "
    ACTIONS[dj-lib-cpp]=" "
    ACTIONS[eigen-demo]=" "
    #---------------------------------------------------------
    ACTIONS[github]="dj-lib-cpp yaml-cpp pangolin-demo dj-convenience "
    ACTIONS[version-check]=" "
    ACTIONS[yaml-cpp]=" "
    ACTIONS[pangolin-demo]=" "
    ACTIONS[dj-conveneince]=" "
    #---------------------------------------------------------
    ACTIONS[github]+="pangolin e1000e-3.4.2.1 e1000e-3.4.2.4 "
    ACTIONS[pangolin]=" "
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
