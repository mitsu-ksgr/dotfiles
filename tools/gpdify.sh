#!/bin/bash

#
# gpd pocket setup
#

if [ "`whoami`" != "root" ]; then
    echo "Require root privilage."
    echo "run to \`sudo ./apply.sh\`"
    exit 1
fi

my_path="$(cd "$(dirname "${BASH_SOURCE:-${(%):-%N}}")"; pwd)"
fname="$(basename ${0})"

rfpath=""
if [[ -L "${0}" ]]; then
    rfpath="$(readlink -f ${0})"
else
    rfpath="${0}"
fi
td="$(dirname ${rfpath})"

# run script
"${td}/gpd_switch_bs_del.sh"
"${td}/gpd_adjust_display_scale.sh"


#
# Enable wifi
#
echo "----- wifi setting -----"
local wdev_name="wlp0s20u4"
sudo ip link set "${wde_name}" up
sudo wifi-menu "${dev_name}"

# if [ "${1}" = "off" ]; then
#     xmodmap -e "keycode 22  = BackSpace"
#     xmodmap -e "keycode 119 = Delete"
#     echo "Reswitch Del/BS"
# else
#     xmodmap -e "keycode 22  = Delete"
#     xmodmap -e "keycode 119 = BackSpace"
#     echo "switch Del/BS"
# fi


