#!/bin/bash
set -u

#******************************************************************************
#
#   Setup systemd user service.
#
#******************************************************************************

dot_path="$(cd $(dirname $0); pwd)/.."
dist_name=$(${dot_path}/tools/detect_distribution.sh)
timestamp=$(date "+%Y%m%d%H%M%S")  # used as suffix of the backup file

ARG_REPLACE_FLAG=0
ARG_ENABLE_FLAG=0

usage() {
    cat << __EOS__
Usage: setup_systemd_user_service.sh [-h] [-a b|y|n]

Description
    Setup systemd user services.

Options
    -h  print help (this message) and exit.
    -a  replace flag. this determines the behavior if the original file or
        link already exists.  if you do not specify this option, ask you what
        to do each time.
        "b"     if the original file or link already exists, backup it.  then
                after, create a symlink.
        "y"     if the original file or link already exists, then it will be
                replace with symlink.  the original file are lost.
        "n"     if the original file or link already exists, do nothing.
    -e  enable service.
__EOS__
}


parse_args() {
    while getopts ha:e flag; do
        case "${flag}" in
            h )
                usage
                exit 0
                ;;
            a )
                case "${OPTARG}" in
                    n ) ARG_REPLACE_FLAG=1 ;;
                    y ) ARG_REPLACE_FLAG=2 ;;
                    b ) ARG_REPLACE_FLAG=3 ;;
                esac
                ;;
            e )
                ARG_ENABLE_FLAG=1
                ;;
            * )
                usage
                exit 1
                ;;
        esac
    done
}


#
# Ask the user how to handle of the existing file.
#
# return:
#   1   'do nothing' was selected.
#   2   'replace' was selected.
#   3   'backup adn replace' was selected.
#
ask() {
    cat << __EOS__
Do you want to replace with symlink?
    b: backup the original file and replace it with symlink.
    y: replace it with symlink. the original file are lost.
    n: do nothing, skip this file.
__EOS__
    while :
    do
        echo -n "(b/y/n)? "
        read answer
        case ${answer} in
            "N" | "n" | "No"  | "NO"  | "no"  ) return 1 ;;
            "Y" | "y" | "Yes" | "YES" | "yes" ) return 2 ;;
            "B" | "b" ) return 3 ;;
        esac
    done
}

#
# Ask the user enable of the service.
#
# return:
#   1   'yes'
#   2   'no'
#
ask_enable() {
    cat << __EOS__
Do you want to enable this service?
    y: yes, enable now.
    n: no, skip.
__EOS__
    while :
    do
        echo -n "(y/n)? "
        read answer
        case ${answer} in
            "Y" | "y" | "Yes" | "YES" | "yes" ) return 1 ;;
            "N" | "n" | "No"  | "NO"  | "no"  ) return 2 ;;
        esac
    done
}


#
# Backup the file.
#
# args:
#   $1  Backup target.
#
backup() {
    suf=".backup_${timestamp}"
    echo "backup: '$1' to $1$suf"
    mv $1 "$1$suf"
}


#
# Create symlink safely.
# if the link or file already exists, ask the user how handle that file.
#
# args:
#   $1  link target
#   $2  link name
#
safeln() {
    if [ ! -e "$2" ]; then
        ln -fs "$1" "$2"
        echo "create symlink: $2"
        return
    fi

    echo "\"$2\" is already exists."
    local opt=${3:-${ARG_REPLACE_FLAG}}
    if [ "${opt}" = "0" ]; then
        ask
        opt=$?
    fi

    case $opt in
        1 ) # skip, do nothing.
            echo "skipped: $2"
            ;;
        2 ) # replace and create symlink.
            rm -rf "$2"
            ln -fs "$1" "$2"
            echo "replace with symlink: $2"
            ;;
        3 ) # backup and create symlink.
            backup $2
            ln -fs "$1" "$2"
            echo "create symlink: $2"
            ;;
    esac
}


main() {
    local hname=$(hostname)

    for fpath in `ls ${dot_path}/config/systemd/user/*` ; do
        fname="$(basename ${fpath})"
        safeln "${fpath}" "${HOME}/.config/systemd/user/${fname}"

        local opt=${ARG_ENABLE_FLAG}
        if [ "${opt}" = "0" ]; then
            ask_enable
            opt=$?
        fi
        if [ "${opt}" = "1" ]; then
            systemctl --user enable ${fname}
            echo "enable ${fname}"
        fi
        unset opt
    done
}


parse_args $@
main

unset dot_path
unset dist_name
unset timestamp
unset ARG_REPLACE_FLAG


echo "all done!"

