#!/bin/bash 

# ===========================================================================================
# wmctrl -r ${vs_code_window} -b add,fullscreen
# wmctrl -r ${vs_code_window} -b remove,fullscreen
# wmctrl -R <win>
# wmctrl -c <win>

    # note 
    # coordinate
    #
    #  o ----------> X
    #  |
    #  |
    #  |
    #  |
    # \|/
    #  v
    #  y

# ===========================================================================================
_resized_help()
{
    echo " "
    echo " "
    echo "---------------------- resized ----------------------"
    echo " Author      : Dingjiang Zhou"
    echo " Email       : zhoudingjiang@gmail.com "
    echo " Create Date : 2019-09-16"
    echo "-----------------------------------------------------"
    echo " "
    echo " First level commands:"
    echo "   embedded   - to arrange terminator and vscode"
    echo "   gitg       - to arrange terminator and gitg"
    echo "   fullscreen - to make terminator full screen"
    echo "   kdiff3     - to arrange kdiff3"
    echo "   difftool   - the same as kdiff3"
    echo "   MORE IS COMMING"
    echo " "
    echo " All commands support tab completion"
    echo " "
    echo "-----------------------------------------------------"
}

# ===========================================================================================
_resize_embedded()
{
    # ---------------------------------------------------------------
    # get the real screen size
    SCREENSIZE=$(xrandr |grep '*')
    current_folder=$(pwd | xargs -n1 basename)
    echo $current_folder
    # vs_code_window=${current_folder}"Visual Studio Code" # did not work!
    vs_code_window="Visual Studio Code"
    echo ${vs_code_window}
    if [[ "$SCREENSIZE" = *"3840x2160"*"3840x2160"* ]]; then
        echo "resized embedded: Double 3840x2160 screen"
        #                   none, x,     y,   width,   height
        wmctrl -r "/bin/bash" -e 0,3840,0,1800,2080
        wmctrl -r "Terminal" -e 0,2340,0,1500,2160
        wmctrl -r "eclipse" -e 0,5370,0,2710,2150
        wmctrl -r "Sublime Text" -e 0,5660,0,1500,2150
        wmctrl -r ${vs_code_window} -e 0,5660,0,2000,2080
    elif [[ $SCREENSIZE = *"3840x2160"* ]]; then
        echo "resized embedded: Single 3840x2160 screen"
        #                   none, x,     y,   width,   height
        wmctrl -r "/bin/bash" -e 0,10,0,1600,2030
        wmctrl -r "eclipse" -e 0,1830,0,2000,2050
        wmctrl -r "Sublime Text" -e 0,1730,0,2000,2050
        wmctrl -r ${vs_code_window} -e 0,1730,0,2300,2030
    elif [[ "$SCREENSIZE" = *"1920x1080"*"1920x1080"* ]]; then
        echo "resized embedded: Double 1920x1080 screen"
        #                   none, x,     y,   width,   height
        wmctrl -r "/bin/bash" -e 0,1930,0,800,1020
        wmctrl -r "Terminal" -e 0,1200,0,710,1050
        wmctrl -r "eclipse" -e 0,2720,0,1200,1050
        wmctrl -r "Sublime Text" -e 0,2830,0,1500,1000
        wmctrl -r ${vs_code_window} -e 0,2720,0,1120,1050
    elif [[ "$SCREENSIZE" = *"1920x1080"* ]]; then
        echo "resized embedded: Single 1920x1080 screen"
        #                   none, x,     y,   width,   height
        wmctrl -r "/bin/bash" -e 0,10,0,800,1000
        wmctrl -r "eclipse" -e 0,820,0,1200,1000
        wmctrl -r "Sublime Text" -e 0,1030,0,1500,1000
        wmctrl -r ${vs_code_window} -e 0,820,0,1200,1080
    elif [[ "$SCREENSIZE" = *"2560x1080"* ]]; then
        echo "resized embedded: Single 2560x1080 screen"
        #                   none, x,     y,   width,   height
        wmctrl -r "/bin/bash" -e 0,10,0,1000,1020
        wmctrl -r "eclipse" -e 0,1530,0,1200,1060
        wmctrl -r "Sublime Text" -e 0,810,0,800,1040
        wmctrl -r ${vs_code_window} -e 0,1020,0,1530,1070
    elif [[ "$SCREENSIZE" = *"1366x768"* ]]; then
        echo "resized embedded: Single 1366x768 screen"
        #                   none, x,     y,   width,   height
        wmctrl -r "/bin/bash" -e 0,10,0,600,700
        wmctrl -r ${vs_code_window} -e 0,620,0,800,700
    elif [[ "$SCREENSIZE" = *"1280x800"* ]]; then
        echo "resized embedded: Single 1280x800 screen"
        #                   none, x,     y,   width,   height
        wmctrl -r "/bin/bash" -e 0,10,0,600,700
        wmctrl -r ${vs_code_window} -e 0,620,0,800,700
    fi
    clear
}

# ===========================================================================================
# special use, do not put this function to funcs.bash
function _resized_get_current_folder_name()
{
    cwd=$PWD
    # echo $cwd 
    cwd_len=${#cwd} # get the length of a string
    slash_number=0
    for (( c=1; c<=cwd_len; c++ )) ; do
        single_char=${cwd:$cwd_len-${c}:1} # get a single charactor in a string
        # echo "single_char = " $single_char
        if [ $single_char = '/' ] ; then
            # echo "hedfafdsfsfsdsfa"
            slash_number=$((slash_number+1))
            if [ $slash_number = 1 ] ; then
            folder_name=${cwd:$cwd_len-${c}+1:$cwd_len-1}
            fi
        fi
    done
    echo $folder_name "("
}

# ===========================================================================================
function _resize_gitg()
{
    echo " "
    # ---------------------------------------------------------------
    # get the real screen size
    SCREENSIZE=$(xrandr |grep '*')
    folder_name=$(_resized_get_current_folder_name)
    echo "folder_name = "$folder_name
    # echo $folder_name
    if [[ "$SCREENSIZE" = *"3840x2160"*"3840x2160"* ]]; then
        echo "resized gitg: Double 3840x2160 screen"
        #                   none, x,     y,   width,   height 
        wmctrl -r "/bin/bash" -e 0,3840,0,1200,2080
        wmctrl -r $folder_name -e 0,2300,0,1560,2180
        wmctrl -R "$folder_name"
    elif [[ $SCREENSIZE = *"3840x2160"* ]]; then 
        echo "resized gitg: Single 3840x2160 screen"
        wmctrl -r "/bin/bash" -e 0,10,0,1800,2030
        #                   none, x,     y,   width,   height
        wmctrl -r $folder_name -e 0,1820,0,1830,2030
        wmctrl -R "$folder_name"
    elif [[ "$SCREENSIZE" = *"1920x1080"* ]]; then
        echo "resized gitg: Single 1920x1080 screen"
        #                   none, x,     y,   width,   height
    elif [[ "$SCREENSIZE" = *"2560x1080"* ]]; then
        echo "resized gitg: Single 2560x1080 screen"
        #                   none, x,     y,   width,   height
    
    elif [[ "$SCREENSIZE" = *"1366x768"* ]]; then
        echo "resized gitg: Single 1366x768 screen"
        #                   none, x,     y,   width,   height
        wmctrl -r "/bin/bash" -e 0,10,0,600,700
        wmctrl -r $folder_name -e 0,620,0,750,750
        wmctrl -R "$folder_name"
    fi
    echo " "
    clear
}

# ===========================================================================================
_resize_fullscreen()
{  
    # ---------------------------------------------------------------
    # get the real screen size
    SCREENSIZE=$(xrandr |grep '*')

    if [[ "$SCREENSIZE" = *"3840x2160"*"3840x2160"* ]]; then
        echo "resized fullscreen: Double 3840x2160 screen"
        #                   none, x,     y,   width,   height
        wmctrl -r "/bin/bash" -e 0,3840,0,3840,2080
        wmctrl -r "eclipse" -e 0,5370,0,2710,2150
        wmctrl -r "Sublime Text" -e 0,3860,0,1500,2150
        wmctrl -r ${vs_code_window} -e 0,5040,0,2000,2080
    elif [[ $SCREENSIZE = *"3840x2160"* ]]; then
        echo "resized fullscreen: Single 3840x2160 screen"
        #                   none, x,     y,   width,   height
        wmctrl -r "/bin/bash" -e 0,10,0,3820,2030
    elif [[ "$SCREENSIZE" = *"1920x1080"* ]]; then
        echo "resized fullscreen: Single 1920x1080 screen"
        #                   none, x,     y,   width,   height
        wmctrl -r "/bin/bash" -e 0,10,0,800,1000
        wmctrl -r "eclipse" -e 0,820,0,1200,1000
        wmctrl -r "Sublime Text" -e 0,1030,0,1500,1000
        wmctrl -r ${vs_code_window} -e 0,530,0,1000,800
    elif [[ "$SCREENSIZE" = *"2560x1080"* ]]; then
        echo "resized fullscreen: Single 2560x1080 screen"
        #                   none, x,     y,   width,   height
        wmctrl -r "/bin/bash" -e 0,10,0,1000,1020
        wmctrl -r "eclipse" -e 0,1530,0,1200,1060
        wmctrl -r "Sublime Text" -e 0,810,0,800,1040
        wmctrl -r ${vs_code_window} -e 0,1020,0,1500,1020
    elif [[ "$SCREENSIZE" = *"1366x768"* ]]; then
        echo "resized fullscreen: Single 1366x768 screen"
        #                   none, x,     y,   width,   height
        wmctrl -r "/bin/bash" -e 0,10,0,1360,750
        wmctrl -r ${vs_code_window} -e 0,620,0,800,700
    fi
    clear
}

# ===========================================================================================
_resize_kdiff3()
{  
    # ---------------------------------------------------------------
    # get the real screen size
    SCREENSIZE=$(xrandr |grep '*')

    if [[ "$SCREENSIZE" = *"3840x2160"*"3840x2160"* ]]; then
        echo "resized kdiff3: Double 3840x2160 screen"
        #                   none, x,     y,   width,   height
        wmctrl -r "/bin/bash" -e 0,3840,0,1200,2080
        wmctrl -r "eclipse" -e 0,5370,0,2710,2150 
        wmctrl -r "Sublime Text" -e 0,3860,0,1500,2150
        wmctrl -r ${vs_code_window} -e 0,5040,0,2700,2080
        wmctrl -r "KDiff3" -e 0,2000,0,1830,2160
    elif [[ $SCREENSIZE = *"3840x2160"* ]]; then
        echo "resized kdiff3: Single 3840x2160 screen"
        #                   none, x,     y,   width,   height
        wmctrl -r "/bin/bash" -e 0,10,0,1800,2030
        wmctrl -r "eclipse" -e 0,1830,0,2000,2050
        wmctrl -r "Sublime Text" -e 0,1830,0,2000,2050
        wmctrl -r ${vs_code_window} -e 0,1830,0,2000,2030
    elif [[ "$SCREENSIZE" = *"1920x1080"* ]]; then
        echo "resized kdiff3: Single 1920x1080 screen"
        #                   none, x,     y,   width,   height
        wmctrl -r "/bin/bash" -e 0,10,0,800,1000
        wmctrl -r "eclipse" -e 0,820,0,1200,1000
        wmctrl -r "Sublime Text" -e 0,1030,0,1500,1000
        wmctrl -r ${vs_code_window} -e 0,530,0,1000,800
    elif [[ "$SCREENSIZE" = *"2560x1080"* ]]; then
        echo "resized kdiff3: Single 2560x1080 screen"
        #                   none, x,     y,   width,   height
        wmctrl -r "/bin/bash" -e 0,10,0,1000,1020
        wmctrl -r "eclipse" -e 0,1530,0,1200,1060
        wmctrl -r "Sublime Text" -e 0,810,0,800,1040
        wmctrl -r ${vs_code_window} -e 0,1020,0,1500,1020
    elif [[ "$SCREENSIZE" = *"1366x768"* ]]; then
        echo "resized kdiff3: Single 1366x768 screen"
        #                   none, x,     y,   width,   height
        wmctrl -r "/bin/bash" -e 0,10,0,600,700
        wmctrl -r ${vs_code_window} -e 0,620,0,800,700
    fi
    clear
}

# ===========================================================================================
function resized()
{
    if [ $# -eq 0 ] ; then
        _resized_help
        return
    fi
    if [ $1 = 'embedded' ] ; then
        _resize_embedded
        return
    fi
    if [ $1 = 'gitg' ] ; then
        _resize_gitg
        return
    fi
    if [ $1 = 'fullscreen' ] ; then
        _resize_fullscreen
        return
    fi
    if [ $1 = 'kdiff3' ] || [ $1 = 'difftool' ] ; then
        _resize_kdiff3
        return
    fi
    _resized_help
}

# ===========================================================================================
# auto tab completion
function _resized()
{
   COMPREPLY=()

    # All possible first values in command line
    local SERVICES=(
        "embedded"
        "gitg"
        "fullscreen"
        "kdiff3"
        "difftool"
    )

    # declare an associative array for options
    declare -A ACTIONS
    # -------------------------------------------------------------------------
    ACTIONS[embedded]=" "
    ACTIONS[gitg]=" "
    ACTIONS[fullscreen]=" "
    ACTIONS[kdiff3]=" "
    ACTIONS[difftool]=" "
    local cur=${COMP_WORDS[COMP_CWORD]}
    if [ ${ACTIONS[$3]+1} ] ; then
        COMPREPLY=( `compgen -W "${ACTIONS[$3]}" -- $cur` )
    else
        COMPREPLY=( `compgen -W "${SERVICES[*]}" -- $cur` )
    fi
}

# ===================================================================
complete -F _resized resized
