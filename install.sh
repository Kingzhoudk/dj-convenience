#!/bin/bash

# =============================================================================================
# make sure the package is in ~/workspace folder
# or make sure it can be sourced from anywhere
dj_convenience_path=$PWD
echo $dj_convenience_path

# =============================================================================================
# get bitbucket/github, etc,  user name

echo " "
echo 'dj convenience installation...'
echo " "
# -----------------------------------------------------------------
echo " "
echo 'Do you have a BitBucket username? [Yes/No]'
echo " "
read answer
if [[ ($answer = 'n') || ($answer = 'N') || ($answer = 'NO') || ($answer = 'No') || ($answer = 'no') ]] ; then
    echo 'BitBucket username is not set.'
elif [[ ($answer = 'y') || ($answer = 'Y') || ($answer = 'YES') || ($answer = 'Yes') || ($answer = 'yes') ]] ; then
    echo " "
    echo 'Please enter your BitBucket username'
    read username
fi

echo 'bitbucket_username='$username >> ~/.bashrc
# -----------------------------------------------------------------
echo " "
echo 'Do you have a GitHub username? [Yes/No]'
echo " "
read answer
if [[ ($answer = 'n') || ($answer = 'N') || ($answer = 'NO') || ($answer = 'No') || ($answer = 'no') ]] ; then
    echo 'GitHub username is not set.'
elif [[ ($answer = 'y') || ($answer = 'Y') || ($answer = 'YES') || ($answer = 'Yes') || ($answer = 'yes') ]] ; then
    echo " "
    echo 'Please enter your GitHub username:'
    read username
fi

echo 'github_username='$username >> ~/.bashrc


echo " "
echo 'If bitbucket/github usernames set wrong, you can still edit them in ~/.bashrc'
echo " "

# =============================================================================================
# source the package in ~/.bashrc
installed=0
while IFS='' read -r line || [[ -n "$line" ]] ; do
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