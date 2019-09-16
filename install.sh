#!/bin/bash

# =============================================================================================
# make sure the package is in ~/workspace folder
# or make sure it can be sourced from anywhere
dj_convenience_path=$PWD
echo $dj_convenience_path

installed=0
while IFS='' read -r line || [[ -n "$line" ]]; do
    if [[ $line == *"source "$dj_convenience_path$"/convenience.bash"* ]] ; then 
        echo " "
        echo "DJ Convenience has already been installed."
        echo " "
        installed=1
    fi
done < ~/.bashrc

if [ $installed = 0 ] ; then 
    echo "source "$dj_convenience_path"/convenience.bash" >> ~/.bashrc
    echo " "
    echo "DJ Convenience installation finished."
    echo " "
fi
source ~/.bashrc