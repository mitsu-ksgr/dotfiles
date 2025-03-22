#!/bin/bash
set -u

#******************************************************************************
#
#   Setup dotfiles.
#
#******************************************************************************

dot_path="$(cd $(dirname $0); pwd)/.."
dist_name=$(${dot_path}/tools/detect_distribution.sh)
timestamp=$(date "+%Y%m%d%H%M%S")  # used as suffix of the backup file

ARG_REPLACE_FLAG=0

usage() {
    cat << __EOS__
Usage: setup.sh [-h] [-a b|y|n]

Description
    Setup dotfiles.

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
__EOS__
}


parse_args() {
    while getopts ha: flag; do
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


#
# walk through.
# args:
#   $1  dir-name
#
walk_dotfiles() {
    local fpath
    local fname
    for fpath in `ls -a ${dot_path}/${1}/\.[a-zA-Z0-9]*` ; do
        fname="$(basename ${fpath})"
        safeln "${fpath}" "${HOME}/${fname}"
    done
}

main() {
    local hname=$(hostname)

    #
    # zsh
    #
    echo "----- zsh -----"
    walk_dotfiles "zsh"
    echo -e "\n"

    #
    # Git
    #
    echo "----- git -----"
    walk_dotfiles "git"
    echo -e "\n"

    #
    # Editor
    #
    echo "----- editor -----"
    if [ ! -d "${HOME}/.vim" ]; then
        mkdir -p "${HOME}/.vim"
    fi
    safeln "${dot_path}/vim/.vimrc"             "${HOME}/.vimrc"
    safeln "${dot_path}/vim/filetype.vim"       "${HOME}/.vim/filetype.vim"
    safeln "${dot_path}/vim/after"              "${HOME}/.vim/after"
    safeln "${dot_path}/vim/.vim-lsp-settings"  "${HOME}/.vim-lsp-settings"
    echo -e "\n"


    #
    # tmux
    #
    echo "----- editor -----"
    safeln "${dot_path}/tmux/.tmux.conf" "${HOME}/.tmux.conf"
    echo -e "\n"


    #
    # Fcitx
    #
    echo "----- Fcitx -----"
    if [ ! -d "${HOME}/.config/fcitx" ]; then
        mkdir -p "${HOME}/.config/fcitx"
    fi
    safeln "${dot_path}/config/fcitx/config" "${HOME}/.config/fcitx/config"
    echo -e "\n"


    #
    # X11
    #
    echo "----- X11 -----"
    safeln "${dot_path}/X/.Xresources" "${HOME}/.Xresources"
    safeln "${dot_path}/X/.xinitrc" "${HOME}/.xinitrc"
    if [ -f "${dot_path}/X/.xinitrc.${hname}" ]; then
        safeln "${dot_path}/X/.xinitrc.${hname}" "${HOME}/.xinitrc.${hname}"
    fi
    safeln "${dot_path}/X/.xprofile" "${HOME}/.xprofile"
    if [ -f "${dot_path}/X/.xprofile.${hname}" ]; then
        safeln "${dot_path}/X/.xprofile.${hname}" "${HOME}/.xprofile.${hname}"
    fi

    echo -e "\n"


    #
    # ranger ... https://ranger.github.io/
    #
    echo "----- Ranger -----"
    if [ ! -d "${HOME}/.config/ranger" ]; then
        mkdir -p "${HOME}/.config/ranger"
    fi
    safeln "${dot_path}/config/ranger/commands_full.py" "${HOME}/.config/ranger/commands_full.py"
    safeln "${dot_path}/config/ranger/commands.py"      "${HOME}/.config/ranger/commands.py"
    safeln "${dot_path}/config/ranger/rc.conf"          "${HOME}/.config/ranger/rc.conf"
    safeln "${dot_path}/config/ranger/rifle.conf"       "${HOME}/.config/ranger/rifle.conf"
    safeln "${dot_path}/config/ranger/scope.sh"         "${HOME}/.config/ranger/scope.sh"
    echo -e "\n"


    #
    # mutt ... http://www.mutt.org/
    #
    echo "----- Mutt -----"
    if [ ! -d "${HOME}/.mutt" ]; then
        mkdir -p "${HOME}/.mutt"
    fi
    safeln "${dot_path}/mutt/muttrc" "${HOME}/.mutt/muttrc"
    if [ ! -f "${HOME}/.mutt/mutt_secret" ]; then
        cp "${dot_path}/mutt/mutt_secret" "${HOME}/.mutt/mutt_secret"
        echo "create file: ${HOME}/.mutt/mutt_secret"
        echo "you need update mutt_secret !!!"
    fi
    echo -e "\n"


    #
    # Desktop Environments
    #
    echo "----- Desktop Environments -----"
    safeln "${dot_path}/config/i3"          "${HOME}/.config/i3"
    safeln "${dot_path}/config/i3status"    "${HOME}/.config/i3status"
    safeln "${dot_path}/config/i3blocks"    "${HOME}/.config/i3blocks"
    safeln "${dot_path}/config/compton"     "${HOME}/.config/compton"
    safeln "${dot_path}/config/dunst"       "${HOME}/.config/dunst"
    safeln "${dot_path}/config/rofi"        "${HOME}/.config/rofi"
    safeln "${dot_path}/config/polybar"     "${HOME}/.config/polybar"
    safeln "${dot_path}/config/kitty"       "${HOME}/.config/kitty"
    echo -e "\n"


    #
    # peco ... https://github.com/peco/peco
    #
    echo "----- peco -----"
    safeln "${dot_path}/config/peco"          "${HOME}/.config/peco"
    echo -e "\n"


    #
    # font support
    #
    echo "----- Font support -----"
    safeln "${dot_path}/config/fontconfig"  "${HOME}/.config/fontconfig"
    echo -e "\n"
}


parse_args $@
main

unset dot_path
unset dist_name
unset timestamp
unset ARG_REPLACE_FLAG


echo "all done!"

