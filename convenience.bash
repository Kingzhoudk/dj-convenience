#!/bin/bash 

# ===========================================================================================
# by doing so, the system can find the whole tooklit
dj_convenience_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ubuntu_release_version=$(lsb_release -a)

# ===========================================================================================
# dependency on Bito Convenience
keyremap enable
touchpad thinkpad disable
_terminal_format_hostname_short_path_no_space

# ===========================================================================================
source $dj_convenience_path/dj-cmds.bash
source $dj_convenience_path/dj-funcs.bash

# ===========================================================================================
# set-up on DJ Convenience
_wallpaper_setup

# ===========================================================================================
# alias ----------------------------------------------
alias ls="ls -l --color=always"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias cal="/usr/share/applications/gcalctool.desktop" #shortcuts/symbol links to /usr/share/applications/
alias eixt="exit" 
alias amke="make"
alias maek="make"
alias mkae="make"
alias amke="make"
alias maek="make"
alias m="make"
alias mc="make clean"
alias mm="make clean && make && make"
alias md="make clean && make release && make download" 
alias mdd="make clean && make debug  && make download-debug"
alias d="djfile"
alias ccc="clear"
alias geidt="gedit"
alias logout="gnome-session-quit"
alias lock="gnome-screensaver-command -l"

# folder alias ----------------------------------------------
# dropbox related folders will be removed at a later time
alias cdgcc="cd ~/Dropbox/work/gcc/"
alias cdg++="cd ~/Dropbox/work/g++/"
alias cdbash="cd ~/Dropbox/work/bash/"
alias cdcmds="cd ~/Dropbox/work/bash/cmds/"
alias cddj="cd "$dj_convenience_path
alias cdcv="cd ~/workspace/work/openCV/"
alias cdros="cd ~/yugong_ws/"

# ROS ---------------------------------------------------------
# set some ROS IP address
export ROS_MASTER_URI=http://localhost:11311
export ROS_IP=localhost

# echo ${ubuntu_release_version}
if [[ ${ubuntu_release_version} = *'18.04'* ]] ; then
    source /opt/ros/melodic/setup.bash 
elif  [[ ${ubuntu_release_version} = *'16.04'* ]] ; then
    source /opt/ros/kinetic/setup.bash 
fi

source ~/yugong_ws/devel/setup.bash
export HOSTNAME
export ROS_HOME=~/.ros
export PATH=/opt/ros/melodic/bin:~/yugong_ws/devel/bin:~/bin:~/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
export PYTHONPATH=/opt/ros/melodic/lib/python2.7/dist-packages:/usr/lib/python2.7/dist-packages:~/yugong_ws/install/lib/python2.7/dist-packages:~/yugong_ws/devel/lib/python2.7/dist-packages
export ROS_PACKAGE_PATH=/opt/ros/melodic/share:~/yugong_ws/src:~/yugong_ws/install/share:~/yugong_ws/devel/share
export CMAKE_PREFIX_PATH=~/yugong_ws/devel:/opt/ros/melodic:~/yugong_ws/install
export LD_LIBRARY_PATH=~/yugong_ws/devel/lib:/opt/ros/melodic/lib:~/yugong_ws/install/lib
export PKG_CONFIG_PATH=/opt/ros/melodic/lib/pkgconfig:~/yugong_ws/devel/lib/pkgconfig:~/yugong_ws/install/lib/pkgconfig

#====================================================================
# Qt
export PATH=~/Qt5.11.2/5.11.2/gcc_64/bin:$PATH

ccc