#!/bin/bash

if [ "${1}" = "off" ]; then
    xmodmap -e "keycode 22  = BackSpace"
    xmodmap -e "keycode 119 = Delete"
    echo "Reswitch Del/BS"
else
    xmodmap -e "keycode 22  = Delete"
    xmodmap -e "keycode 119 = BackSpace"
    echo "switch Del/BS"
fi

