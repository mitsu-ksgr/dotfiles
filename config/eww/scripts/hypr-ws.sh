#!/bin/bash
#
# Hyprland workspace helper.
#
# * TODO
# - Support multi-monitor env
#
#
# * Dependencies
# - hyprctl (Hyprland)
# - jq (extra/jq)
#
set -eu

main() {
    ### Args
    local -r mode="${1-}"
    if [ -z "${mode}" ]; then
        exit 0
    fi


    ### Mode
    case "${mode}" in
        ls )
            hyprctl -j workspaces | jq -c "map(.id)"
            ;;

        now | active-id )
            hyprctl -j activeworkspace | jq ".id"
            ;;

        check-active )
            local -r target="${2-}"
            if [ -z "${target}" ]; then
                exit 0 # TODO: Error?
            fi

            local -r cur=$(hyprctl -j activeworkspace | jq ".id")
            if [ "${target}" == "${cur}" ]; then
                echo "active"
            fi
            ;;

        to )
            local -r next="${2-}"
            if [ -z "${next}" ]; then
                exit 0 # TODO: Error?
            fi
            hyprctl dispatch workspace "${next}"
            ;;
    esac
}

main $@
exit 0

