#!/bin/sh

#
# /etc/X11/xinit/xinitrc
#

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "f" ] && . "$f"
    done
    unset f
fi


# invoke global X session script
#. /etc/X11/Xsession


if [ -e ~/.Xresources ]; then
    # -Iオプションに、~は渡せないぽい？
    #xrdb -I~/dotfiles/X -merge ~/.Xresources
    xrdb -I./dotfiles/X -merge ~/.Xresources
fi

if [ -f ~/.Xmodmap ]; then
    xmodmap ~/.Xmodmap
fi


#
# Input Method
#
export DefaultImModule=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export GLFX_IM_MODULE=ibus
export INPUT_METHOD=fcitx
export XMODIFIERS=@im=fcitx


#
# Read .xinitrc for each devices.
#
hname=$(hostname)
if [ -e "${HOME}/.xinitrc.${hname}" ]; then
    . "${HOME}/.xinitrc.${hname}"
fi


#exec awesome
exec i3

