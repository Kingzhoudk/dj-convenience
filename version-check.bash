#!/bin/bash

# ===========================================================================================
function _version_check_git_source()
{
    if [[ ! -d ".git" ]] ; then
        git_source="----"
        echo $git_source
        return
    fi
    git_remove_v=$(git remote -v | grep fetch)
    if [[ $git_remove_v = *"bitbucket"* ]] ; then
        git_source="BitBucket"
    elif [[ $git_remove_v = *"github"* ]] ; then
        git_source="GitHub"
    else
        git_source="----"
    fi
    echo $git_source
}

# ===========================================================================================
# for now, it only checks the $workspace_path/ folder
function _version_check() 
{
    cwd_before_running=$PWD

    package_width=30
    branch_width=40
    tag_width=35 # if len > 32, then use xxx for the last three charactors
    status_width=15 # if current commit is ahead or behind the remote

    if [ $# = 0 ] ; then
        target_path=$(pwd)
    else
        target_path="$1"
    fi
    echo "target_path: "$target_path
    
    # check all folders target_path folder --------------------
    if [[ ! -d $target_path ]] ; then
        echo " "
        echo "path wrong, return"
        echo " "
        return
    fi
    cd $target_path
    workspace_path=$(pwd)
    echo $workspace_path
    # return

    CURRENT_DATE_TIME=`date +"%Y%m%d_%I%M%S"`
    OUTPUT_FILE="${HOME}/version_check_${HOSTNAME}_${CURRENT_DATE_TIME}.txt"
    echo -e '\c' > $OUTPUT_FILE
    echo -ne "-----------------------------------------------------------------------------------------------------\n" >> $OUTPUT_FILE
    echo -ne "----- Tool      : Version Check ---------------------------------------------------------------------\n" >> $OUTPUT_FILE
    echo -ne "----- Command   : dj version-check <path> -----------------------------------------------------------\n" >> $OUTPUT_FILE
    echo -ne "----- Developer : Dingjiang Zhou --------------------------------------------------------------------\n" >> $OUTPUT_FILE
    echo -ne "----- Date      : October 8th, 2019 -----------------------------------------------------------------\n" >> $OUTPUT_FILE
    echo -ne "-----------------------------------------------------------------------------------------------------\n" >> $OUTPUT_FILE
    echo -ne "\nWorking Directory  : "$workspace_path"\n" >> $OUTPUT_FILE
    echo -ne "Computer Hostname  : "$HOSTNAME"\n" >> $OUTPUT_FILE
    echo -ne "Computer Username  : "$USER"\n" >> $OUTPUT_FILE
    echo -ne "Version Check Time : "$(date)"\n\n" >> $OUTPUT_FILE

    $(_write_to_text_file_with_width "Commit Time" 24 $OUTPUT_FILE)
    $(_write_to_text_file_with_width "Source" 15 $OUTPUT_FILE)
    $(_write_to_text_file_with_width "Status" $status_width $OUTPUT_FILE)
    $(_write_to_text_file_with_width "Folder/Repo" $package_width $OUTPUT_FILE)
    $(_write_to_text_file_with_width "Branch" $branch_width $OUTPUT_FILE)
    $(_write_to_text_file_with_width "Tag" $tag_width $OUTPUT_FILE)
    $(_write_to_text_file_with_width "Commit" 15 $OUTPUT_FILE)
    $(_write_to_text_file_with_width "Commit Message" 50 $OUTPUT_FILE)
    echo -ne "\n" >> $OUTPUT_FILE
    
    for folder in $workspace_path/*; do
        if [[ -d $folder ]] ; then
            repo=`basename "$folder"`
            echo $repo
            path=$workspace_path/$repo
            if [ -x "$path" ]; then
                cd $workspace_path/$repo
                # --------------------------------------------------------
                git_source=$(_version_check_git_source)
                # --------------------------------------------------------
                if [[ $git_source != "----" ]] ; then
                    b_name=`git branch | grep \* | cut -d ' ' -f2`
                    t_name=`git describe --abbrev=7 --dirty --always --tags`
                    branch_commit=`git log --pretty=oneline | awk 'NR==1'`
                    branch_commit_len=${#branch_commit}
                    branch_commit_value=${branch_commit:0:10}"     "
                    date_time=`git log -1 --format=%ai`
                    date_time=${date_time:0:19}"     "
                    # --------------------------------------------------------
                    commit_str=${branch_commit:41:$branch_commit_len-41}
                    # if too long, make it shorter
                    commit_str_len=${#commit_str}
                    if [ $commit_str_len -gt 50 ] ; then
                        commit_str=${commit_str:0:50}"xxxxxx"
                    fi
                    # --------------------------------------------------------
                    # to see if current commit is ahead or behind the remote
                    git_status=$(git status)
                    if [[ $git_status = *"is ahead"* ]] ; then
                        git_status_str="ahead"
                    elif [[ $git_status = *"is behind"* ]] ; then
                        git_status_str="behind"
                    else
                        git_status_str="    "
                    fi
                    if [[ $t_name = *"dirty"* ]] ; then
                        if [[ $git_status_str = "    " ]] ; then
                            git_status_str="dirty"
                        else
                            git_status_str=$git_status_str" + dirty"
                        fi
                    fi
                else
                    b_name="----"
                    t_name="----"
                    branch_commit_value="----------"
                    commit_str="----"
                    git_status_str="----"
                fi
                # --------------------------------------------------------
                $(_write_to_text_file_with_width "$date_time" 24 $OUTPUT_FILE)
                $(_write_to_text_file_with_width "$git_source" 15 $OUTPUT_FILE)
                $(_write_to_text_file_with_width "$git_status_str" $status_width $OUTPUT_FILE)
                $(_write_to_text_file_with_width "$repo" $package_width $OUTPUT_FILE)
                $(_write_to_text_file_with_width "$b_name" $branch_width $OUTPUT_FILE)
                $(_write_to_text_file_with_width "$t_name" $tag_width $OUTPUT_FILE)
                $(_write_to_text_file_with_width "$branch_commit_value" 15 $OUTPUT_FILE)
                $(_write_to_text_file_with_width "$commit_str" 50 $OUTPUT_FILE)
                echo -ne "\n" >> $OUTPUT_FILE
            else
                echo >> $OUTPUT_FILE
            fi
        fi
    done
    
    echo -ne "\n" >> $OUTPUT_FILE
    echo -ne "\n" >> $OUTPUT_FILE
    echo -ne "\n" >> $OUTPUT_FILE
    echo " "
    echo " "
    echo "----------------- git simple diff -----------------"
    cd $workspace_path/
    echo -ne "+-----------------------------------------------+\n" >> $OUTPUT_FILE
    echo -ne "|--------------- git simple diff ---------------|\n" >> $OUTPUT_FILE
    echo -ne "+-----------------------------------------------+\n" >> $OUTPUT_FILE
    for folder in $workspace_path/*; do
        if [[ -d $folder ]] ; then
            cd $folder/
            git_source=$(_version_check_git_source)
            if [[ $git_source != "----" ]] ; then
                repo=`basename "$folder"`
                echo $repo
                #path=$workspace_path/$repo
                if [ -x "$path" ] ; then
                    cd $workspace_path/$repo
                    branch_diff=`git diff | awk 'NR==1'`
                    echo -ne "\n+------ $repo ------+\n" >> $OUTPUT_FILE
                    echo -ne "$branch_diff\n" >> $OUTPUT_FILE
                else
                    echo >> $OUTPUT_FILE
                fi
            else
                echo $folder": not a git repo"
            fi
            cd $workspace_path/
        fi
    done

    echo -ne "\n" >> $OUTPUT_FILE
    echo -ne "\n" >> $OUTPUT_FILE
    echo -ne "\n" >> $OUTPUT_FILE

    echo " "
    echo " "
    echo "------------ git detailed local change ------------"
    cd $workspace_path/
    echo -ne "+-----------------------------------------------+\n" >> $OUTPUT_FILE
    echo -ne "|---------- git detailed local change ----------|\n" >> $OUTPUT_FILE
    echo -ne "+-----------------------------------------------+\n" >> $OUTPUT_FILE
    for folder in $workspace_path/*; do
        if [[ -d $folder ]] ; then
            cd $folder
            git_source=$(_version_check_git_source)
            if [[ $git_source != "----" ]] ; then
                repo=`basename "$folder"`
                echo $repo
                #path=$workspace_path/$repo
                if [ -x "$path" ]; then
                    cd $workspace_path/$repo
                    branch_diff=`git diff`
                    echo -ne "\n+------ $repo ------+\n" >> $OUTPUT_FILE
                    echo -ne "$branch_diff\n" >> $OUTPUT_FILE
                else
                    echo >> $OUTPUT_FILE
                fi
            else
                echo $folder": not a git repo"
            fi
            cd $workspace_path/
        fi
    done

    cd ${cwd_before_running}
    # open the file!
    gedit $OUTPUT_FILE
}
