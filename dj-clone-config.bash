# ===========================================================================================
function _dj_zhou_github()
{
    COMPREPLY=()

    # All possible first values in command line
    local SERVICES=("
        clone
    ")

    # declare an associative array for options
    declare -A ACTIONS

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
