#!/usr/bin/env bash
#
# for Wayland + Hyprland environment.
#
set -eu

if ! pidof eww > /dev/null; then
    eww daemon
    sleep 1
fi


# Get monitor count. (Hyprland)
readonly moni=$(hyprctl monitors all | grep "Monitor" | wc -l)


eww close-all

if [ "${moni}" -le 1 ]; then
    eww open bar
else
    eww open bar --screen 0 --id primary
    eww open bar --screen 1 --id secondary
fi


