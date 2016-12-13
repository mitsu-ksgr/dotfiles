#!/usr/bin/env sh

function safe_link() {
    [ -z "${2-}" ] && target=~/`basename $1` || target=$2
    [ -e "${target}" ] && rm -rf "${target}"
    ln -s $1 "${target}"
}

pwd=`pwd`

safe_link $pwd/osx/.zshrc
safe_link $pwd/osx/.vimrc
safe_link $pwd/osx/.gitconfig
safe_link $pwd/osx/.gitignore_global
safe_link $pwd/osx/.irbrc
safe_link $pwd/osx/SublimeText3/User ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User


