#!/bin/sh

#
# apply_xorgconf.sh
#
#   xorg.confをいろいろいじって試すときのヘルパー
#

set -eu

if [ "`whoami`" != "root" ]; then
    echo "Require root privilage."
    echo "run to \`sudo ./apply.sh\`"
    exit 1
fi

x11_conf_path="/etc/X11/xorg.conf"
my_conf_path="~/dotfiles/X/xorg.conf"

if [ -e "${x11_conf_path}" ]; then
    suf=".backup_$(date '+%Y%m%d%H%M%S')"
    echo "${x11_conf_path} already exists, backup to ${x11_conf_path}${suf}"
    cp -b --suffix="${suf}" "${my_conf_path}" "${x11_conf_path}"
else
    cp "${my_conf_path}" "${x11_conf_path}"
fi

unset x11_conf_path
unset my_conf_path
echo "complete apply."

