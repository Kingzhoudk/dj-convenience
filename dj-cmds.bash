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
    echo "   setup        - to install some software"
    echo "   clone        - clone a repo from bitbucket/github"
    echo "   udev         - udev rule setup for usb devices"
    echo "  version-check - check version of repos in a path "
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

    sudo apt-get install libeigen3-dev -y
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
    
    cd ~ && mkdir -p soft/ &&  cd soft/
    git clone https://dj-zhou@github.com/dj-zhou/pangolin.git
    cd pangolin
    git checkout add-eigen3-include
    git pull
    mkdir build && cd build
    cmake ..
    make -j$(cat /proc/cpuinfo | grep processor | wc -l)
    sudo make install

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

    cd ~ && mkdir -p soft/ &&  cd soft/
    dj clone github yaml-cpp
    cd yaml-cpp
    rm -rf build/ && mkdir build
    cd build && cmake -DYAML_BUILD_SHARED_LIBS=ON ..
    make -j$(cat /proc/cpuinfo | grep processor | wc -l)
    sudo make install

    echo " "
    echo "libyaml-cpp.a is installed in /usr/local/lib/"
    echo "header files are installed in /usr/local/include/yaml-cpp/"
    echo " "

    _ask_to_remove_a_folder yaml-cpp/

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

    cd ~ && mkdir -p soft/ &&  cd soft/
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
    sudo apt-get install python3-pip -y
    sudo apt-get install python-pip -y
    # pip upgrade, only for python 2
    sudo pip install --upgrade pip
    cd ${cwd_before_running}
}

# ===========================================================================================
# this shadowsocks is from
# https://medium.com/@mighil/how-to-install-shadowsocks-on-ubuntu-to-bypass-china-gfw-db6f79d1f7f9
# however, it does not support aes-256-gcm encryption
# the another tool is shadowsocks-qt5 (https://github.com/shadowsocks/shadowsocks-qt5)
# however, I failed to install it.
function _dj_setup_shadowsocks()
{
    cwd_before_running=$PWD
    cd ~/
    # if pip is installed:
    sudo pip install shadowsocks
    
    # M2Crypto, the most complete python wrapper for OpenSSL featuring RSA, DSA, DH, EC,
    # HMACs, mesage digests, symmetric ciphers (including AES).
    sudo apt-get install python-m2crypto -y
    sudo apt-get install build-essential -y

    # libsodium
    # installation: https://download.libsodium.org/doc/installation
    git clone https://github.com/dj-zhou/libsodium-1.0.18.git
    cd libsodium-1.0.18
    ./autogen.sh
    ./configure
    make -j$(cat /proc/cpuinfo | grep processor | wc -l)
    sudo make install
    sudo ldconfig

    _ask_to_remove_a_folder libsodium-1.0.18
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
# may not be a good way to install opencv
# recommend to install opencv-4.1.1
function _dj_setup_opencv_2_4_13()
{
    cwd_before_running=$PWD

    echo " "
    echo " Have you installed Qt? The openCV installation may need Qt"
    echo " use the following command to install Qt 5.11.2"
    echo " "
    sleep 3
    
    cd ~
    if [[ ! -d soft ]] ; then
        mkdir -p soft
    fi
    cd soft/

    wget https://codeload.github.com/opencv/opencv/zip/2.4.13.6
    mv 2.4.13.6 opencv-2.4.13.6.zip
    unzip opencv-2.4.13.6.zip
    cd opencv-2.4.13.6
    mkdir build && cd build
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D WITH_V4L=ON -D WITH_QT=ON -D WITH_OPENGL=ON WITH_OPENCL=ON WITH_GDAL=ON WITH_IPP=ON BUILD_JASPER=ON BUILD_JPEG=ON BUILD_PNG=ON BUIILD_TIFF=ON WITH_OPENMP=ON ..
    make -j$(cat /proc/cpuinfo | grep processor | wc -l) && sudo make install

    _ask_to_remove_a_folder opencv-2.4.13
    _ask_to_remove_a_file opencv-2.4.13.zip

    cd ${cwd_before_running}
    echo " "
    echo " lib files *.so are installed in /usr/local/lib/"
    echo " header files are installded in /usr/local/include/opencv2/"
    echo " "
}

# ===========================================================================================
# the installation is from the book, which has a github repo:
# https://github.com/PacktPublishing/Learn-OpenCV-4-By-Building-Projects-Second-Edition
# however, this is a bad reference
function _dj_setup_opencv_4_1_1()
{
    cwd_before_running=$PWD

    echo " "
    echo " Have you installed Qt? The openCV installation may need Qt"
    echo " use the following command to install Qt 5.11.2"
    echo " "
    sleep 3

    # install dependency:
    sudo apt-get install -y libopencv-dev build-essential cmake libdc1394-22
    sudo apt-get install -y libdc1394-22-dev libjpeg-dev libpng12-dev
    sudo apt-get install -y libtiff5-dev libjasper-dev libavcodec-dev
    sudo apt-get install -y libavformat-dev libswscale-dev libxine2-dev
    sudo apt-get install -y libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev
    sudo apt-get install -y libv4l-dev libtbb-dev libqt4-dev libmp3lame-dev
    sudo apt-get install -y libopencore-amrnb-dev libopencore-amrwb-dev
    sudo apt-get install -y libtheora-dev libvorbis-dev libxvidcore-dev
    sudo apt-get install -y x264 v4l-utils

    cd ~
    if [[ ! -d soft ]] ; then
        mkdir -p soft
    fi
    cd soft/
    # to check the existing files, and check its md5 checksum, if passed, no need to download the tar ball again
    wget "https://github.com/opencv/opencv/archive/4.1.1.tar.gz" -O opencv-4.1.1.tar.gz
    wget "https://github.com/opencv/opencv_contrib/archive/4.1.1.tar.gz" -O opencv_contrib-4.1.1.tar.gz
    tar -zxvf opencv-4.1.1.tar.gz
    tar -zxvf opencv_contrib-4.1.1.tar.gz
    cd opencv-4.1.1
    mkdir build && cd build
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D INSTALL_C_EXAMPLES=ON -D BUILD_EXAMPLES=ON -D OPENCV_EXTRA_MOUDLES_PATH=~/soft/opencv_contrib-4.1.1/modules ../

    make -j$(cat /proc/cpuinfo | grep processor | wc -l) && sudo make install
    
    _ask_to_remove_a_folder opencv-4.1.1
    _ask_to_remove_a_file   opencv-4.1.1.tar.gz
    _ask_to_remove_a_folder opencv_contrib-4.1.1
    _ask_to_remove_a_file   opencv_contrib-4.1.1.tar.gz

    cd ${cwd_before_running}
    echo " "
    echo " lib files *.so are installed in /usr/local/lib/"
    echo " header files are installded in /usr/local/include/opencv4/, in which there is another folder opencv2/"
    echo " "
    echo " example code or template project can be seen from:"
    echo " https://github.com/dj-zhou/opencv4-demo/001-imread-imshow"
}

# ===========================================================================================
# https://www.linuxbabe.com/desktop-linux/how-to-install-chinese-wubi-input-method-on-debian-8-gnome-desktop
function _dj_setup_wubi()
{
    cwd_before_running=$PWD

    sudo apt-get install ibus ibus-table-wubi -y
    echo " "
    echo "Following the steps:"
    echo " "
    echo "  $ ibus-setup"
    echo "  in the opened window: Input Method -> Add -> Chinese -> choose WuBi-Jidian-86-JiShuang"
	echo "  (it may need reboot the computer if the WuBi input is not shown) "
	echo "  $ im-config -n ibus (nothing will happen after ENTER)"
	echo "  Add an Input Source to Gnome:"
	echo "  Settings -> Keyboard -> Input Sources -> Others -> Chinese -> Chise (WuBi-Jidian-86-JiShuang-6.0) "
    echo "  use Windows Key (or named Super Key) + Space to switch the two input methods"
    echo " "
    cd ${cwd_before_running}
}

# ===========================================================================================
function _dj_setup_vtk()
{
    echo "vtk installation"

    cwd_before_running=$PWD


    # vtk 6 ----------------
    # sudo apt-get install vtk6 -y
    # vtk6 is already the newest version (6.2.0+dfsg1-10build1+debian11.1+osrf1).

    # vtk 8 ----------------
    # reference: https://kezunlin.me/post/b901735e/
    cd ~
    if [[ ! -d soft ]] ; then
        mkdir -p soft
    fi
    cd soft/

    sudo apt-get install cmake-qt-gui -y

    wget https://vtk.org/files/release/8.2/VTK-8.2.0.zip
    unzip VTK-8.2.0.zip
    wget https://vtk.org/files/release/8.2/VTKData-8.2.0.zip
    unzip VTKData-8.2.0.zip
    # note: the data will be unziped into VTK-8.2.0/.ExternalData/ folder

    cd VTK-8.2.0 && sudo rm -r build/ && mkdir -p build && cd build
    cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DVTK_RENDERING_BACKEND=OpenGL2 -DQT5_DIR=$HOME/Qt5.11.2/5.11.2/gcc_64/lib/cmake/Qt5 -DVTK_QT_VERSION=5 -DVTK_Group_Qt=ON ..
    make -j$(cat /proc/cpuinfo | grep processor | wc -l) && sudo make install
    # some warning:
    # CMake Warning:
    #     Manually-specified variables were not used by the project:

    #     QT5_DIR
    # however, the compilation seems have no problem

    echo " "
    echo " the installed library seems to be in /usr/local/lib folder"
    echo " the installed header files seem to be in /usr/local/include/vtk-8.2/ folder"
    echo " "

    cd ~/soft/
    _ask_to_remove_a_folder VTK-8.2.0
    _ask_to_remove_a_file VTK-8.2.0.zip
    cd ${cwd_before_running}
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
    echo "dj clone "$1" with bitbucket username "$bitbucket_username
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
function _dj_udev_help()
{
    _dj_help
    echo "--------------------- dj udev ----------------------"
    echo " Second level commands:"
    echo "   uvc-video-capture - to assign static device name to the UVC"
    echo "                       video capture device"
    echo "   MORE IS COMMING"
    echo "-----------------------------------------------------"
    echo " "
}

# ===========================================================================================
function _dj_udev_uvc_video_capture()
{
    echo " "
    echo " udev rule setup to /etc/udev/rule.d/"
    echo " "
    if [ $# -eq 0 ] ; then
        _dj_udev_help
        return
    fi
    if [ $1 = 'uvc-video-capture' ] ; then
        sudo $dj_convenience_path/udev/uvc_video_capture_udev.sh
        return
    fi

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
        if [ $2 = 'shadowsocks' ] ; then
            _dj_setup_shadowsocks
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
        if [ $2 = 'opencv-2.4.13' ] ; then
            _dj_setup_opencv_2_4_13
            return
        fi
        # --------------------------
        if [ $2 = 'opencv-4.1.1' ] ; then
            _dj_setup_opencv_4_1_1
            return
        fi
        # --------------------------
        if [ $2 = 'wubi' ] ; then
            _dj_setup_wubi
            return
        fi
        # --------------------------
        if [ $2 = 'vtk' ] ; then
            _dj_setup_vtk
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
    if [ $1 = 'udev' ] ; then
        _dj_udev_uvc_video_capture $2 $3 $4 $5
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
        udev
        dingkun
    ")

    # declare an associative array for options
    declare -A ACTIONS

    #---------------------------------------------------------
    #---------------------------------------------------------
    ACTIONS[setup]+="computer eigen i219-v foxit pangolin yaml-cpp qt-5.11.2 "
    ACTIONS[setup]+="pip typora glfw3-gtest-glog opencv-2.4.13 opencv-4.1.1 "
    ACTIONS[setup]+="shadowsocks wubi vtk "
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
    ACTIONS[opencv-2.4.13]=" "
    ACTIONS[opencv-4.1.1]=" "
    ACTIONS[shadowsocks]=" "
    ACTIONS[wubi]=" "
    ACTIONS[vtk]=" "

    #---------------------------------------------------------
    #---------------------------------------------------------
    ACTIONS[clone]="bitbucket github "
    #---------------------------------------------------------
    ACTIONS[bitbucket]+=" lib-stm32f4-v2 "
    ACTIONS[lib-stm32f4-v2]=" "
    #---------------------------------------------------------
    ACTIONS[github]="dj-convenience dj-tools python-demo learn-ml opencv4-demo "
    ACTIONS[github]="e1000e-3.4.2.1 e1000e-3.4.2.4 vtk-demo libsodium-1.0.18 pangolin-demo"
    ACTIONS[github]="learn-md dj-lib-cpp glfw3 pangolin yaml-cpp "
    ACTIONS[dj-conveneince]=" "
    ACTIONS[dj-tools]=" "
    ACTIONS[python-demo]=" "
    ACTIONS[learn-ml]=" "
    ACTIONS[opencv4-demo]=" "
    ACTIONS[e1000e-3.4.2.1]=" "
    ACTIONS[e1000e-3.4.2.4]=" "
    ACTIONS[vtk-demo]=" "
    ACTIONS[libsodium-1.0.18]=" "
    ACTIONS[pangolin-demo]=" "
    ACTIONS[learn-md]=" "
    ACTIONS[dj-lib-cpp]=" "
    ACTIONS[glfw3]=" "
    ACTIONS[pangolin]=" "
    ACTIONS[yaml-cpp]=" "

    #---------------------------------------------------------
    #---------------------------------------------------------
    ACTIONS[version-check]=" "
    ACTIONS[udev]="uvc-video-capture "
    ACTIONS[uvc-video-capture]=" "

    ACTIONS[dingkun]="dingjiang hello world "
    ACTIONS[dingjiang]=" "
    ACTIONS[hello]=" "
    ACTIONS[world]=" "

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
