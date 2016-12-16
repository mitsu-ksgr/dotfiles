#!/usr/bin/env sh

function safe_link() {
    [ -z "${2-}" ] && target=~/`basename $1` || target=$2
    [ -e "${target}" ] && rm -rf "${target}"
    ln -s $1 "${target}"
}

pwd=`pwd`

safe_link $pwd/git/.gitconfig
safe_link $pwd/git/.gitignore_global


