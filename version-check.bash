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
    tag_width=40

    if [ $# = 0 ] ; then
        workspace_path=$(pwd)
    fi
    CURRENT_DATE_TIME=`date +"%Y%m%d_%I%M%S"`
    OUTPUT_FILE="${HOME}/version_check_${HOSTNAME}_${CURRENT_DATE_TIME}.txt"
    echo -e '\c' > ${OUTPUT_FILE}
    echo -ne "-----------------------------------------------------------------------------------------------------\n" >> ${OUTPUT_FILE}
    echo -ne "----- Tool      : Version Check ---------------------------------------------------------------------\n" >> ${OUTPUT_FILE}
    echo -ne "----- Command   : dj version-check <path> -----------------------------------------------------------\n" >> ${OUTPUT_FILE}
    echo -ne "----- Developer : Dingjiang Zhou --------------------------------------------------------------------\n" >> ${OUTPUT_FILE}
    echo -ne "----- Date      : October 3rd, 2019 -----------------------------------------------------------------\n" >> ${OUTPUT_FILE}
    echo -ne "-----------------------------------------------------------------------------------------------------\n" >> ${OUTPUT_FILE}

    $(_write_to_text_file_with_width "Date and Time" 24 $OUTPUT_FILE)
    $(_write_to_text_file_with_width "Package or Repo" $package_width $OUTPUT_FILE)
    $(_write_to_text_file_with_width "Source" 15 $OUTPUT_FILE)
    $(_write_to_text_file_with_width "Branch" $branch_width $OUTPUT_FILE)
    $(_write_to_text_file_with_width "Tag" $tag_width $OUTPUT_FILE)
    $(_write_to_text_file_with_width "Commit" 14 $OUTPUT_FILE)
    $(_write_to_text_file_with_width "Commit Message" 50 $OUTPUT_FILE)
    echo -ne "\n" >> ${OUTPUT_FILE}

    # check all folders workspace_path folder --------------------
    cd $workspace_path/
    for folder in $workspace_path/*; do
        if [[ -d $folder ]] ; then
            repo=`basename "$folder"`
            echo $repo
            path=$workspace_path/$repo
            if [ -x "$path" ]; then
                cd $workspace_path/$repo
                # --------------------------------------------------------
                # git_remove_v=$(git remote -v | grep fetch)
                # if [[ $git_remove_v = *"bitbucket"* ]] ; then
                #     git_source="BitBucket"
                # elif [[ $git_remove_v = *"github"* ]] ; then
                #     git_source="GitHub"
                # else
                #     git_source="----"
                # fi
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
                else
                    b_name="----"
                    t_name="----"
                    branch_commit_value="----------"
                    commit_str="----"
                fi
                # --------------------------------------------------------
                $(_write_to_text_file_with_width "$date_time" 24 $OUTPUT_FILE)
                $(_write_to_text_file_with_width "$repo" $package_width $OUTPUT_FILE)
                $(_write_to_text_file_with_width "$git_source" 15 $OUTPUT_FILE)
                $(_write_to_text_file_with_width "$b_name" $branch_width $OUTPUT_FILE)
                $(_write_to_text_file_with_width "$t_name" $tag_width $OUTPUT_FILE)
                $(_write_to_text_file_with_width "$branch_commit_value" 10 $OUTPUT_FILE)
                $(_write_to_text_file_with_width "$commit_str" 50 $OUTPUT_FILE)
                echo -ne "\n" >> ${OUTPUT_FILE}
            else
                echo >> ${OUTPUT_FILE}
            fi
        fi
    done
    
    echo -ne "\n" >> ${OUTPUT_FILE}
    echo -ne "\n" >> ${OUTPUT_FILE}
    echo -ne "\n" >> ${OUTPUT_FILE}
    echo " "
    echo " "
    echo "----------------- git simple diff -----------------"
    cd $workspace_path/
    echo -ne "-------------------------------------------------\n" >> ${OUTPUT_FILE}
    echo -ne "-----------------git simple diff-----------------\n" >> ${OUTPUT_FILE}
    echo -ne "-------------------------------------------------\n" >> ${OUTPUT_FILE}
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
                    echo -ne "$repo $branch_diff\n" >> ${OUTPUT_FILE}
                else
                    echo >> ${OUTPUT_FILE}
                fi
            else
                echo $folder": not a git repo"
            fi
            cd $workspace_path/
        fi
    done

    echo -ne "\n" >> ${OUTPUT_FILE}
    echo -ne "\n" >> ${OUTPUT_FILE}
    echo -ne "\n" >> ${OUTPUT_FILE}

    echo " "
    echo " "
    echo "------------ git detailed local change ------------"
    cd $workspace_path/
    echo -ne "-------------------------------------------------\n" >> ${OUTPUT_FILE}
    echo -ne "------------git detailed local change------------\n" >> ${OUTPUT_FILE}
    echo -ne "-------------------------------------------------\n" >> ${OUTPUT_FILE}
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
                    echo -ne "$repo $branch_diff\n" >> ${OUTPUT_FILE}
                else
                    echo >> ${OUTPUT_FILE}
                fi
            else
                echo $folder": not a git repo"
            fi
            cd $workspace_path/
        fi
    done

    cd ${cwd_before_running}
}
