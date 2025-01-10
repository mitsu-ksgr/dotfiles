#!/bin/bash
#
# Power menu
#
# - Archlinux
# - Hyprland DE
# - systemd
#
set -eu


#readonly EWW=$(command -v eww)
readonly EWW="/home/mitsu/dev/bin/eww"
readonly EWW_POWERMENU="powermenu"


close_powermenu() {
    if ${EWW} active-windows | grep -q "${EWW_POWERMENU}"; then
        ${EWW} close "${EWW_POWERMENU}"
    fi
}

main() {
    local readonly mode="${1-}"
    if [ -z "${mode}" ]; then
        mode="cancel"
    fi

    case "${mode}" in
        logout )
            close_powermenu
            hyprctl dispatch exit
            ;;

        shutdown )
            close_powermenu
            shutdown -h now
            ;;

        reboot )
            close_powermenu
            reboot
            ;;

        suspend )
            notify-send "Suspend" "suspending..."
            close_powermenu
            systemctl suspend
            ;;

        cancel )
            close_powermenu
            ;;

        * )
            # do nothing.
            ;;
    esac
}

main $@
exit 0

