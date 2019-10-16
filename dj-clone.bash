#!/bin/bash 

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


