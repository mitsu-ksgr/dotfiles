#!/bin/sh

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


if [ -f ~/.Xresources ]; then
    xrdb -merge ~/.Xresources
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
export XMODIFIERS="@im=fcitx"


#exec awesome
exec i3


