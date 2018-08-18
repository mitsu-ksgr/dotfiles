#!/bin/bash

#
# gpd pocket setup
#
if [ "`whoami`" != "root" ]; then
    echo "Require root privilage."
    echo "run to \`sudo ./apply.sh\`"
    exit 1
fi

# my_path="$(cd "$(dirname "${BASH_SOURCE:-${(%):-%N}}")"; pwd)"
# fname="$(basename ${0})"

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
wdev_name="wlp0s20u4"
sudo ip link set "${wdev_name}" up
sudo wifi-menu "${dev_name}"


exit 0

