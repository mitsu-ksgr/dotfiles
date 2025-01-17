#!/bin/bash
#
# Output workspace widget contents for the eww's status-bar.
#
# * How to use
# in eww.yuck, then:
#
# ```
# (defpoll hypr_workspaces :interval "1s" "scripts/eww-hypr-ws.sh")
# (defwidget workspaces [] (literal :content hypr_workspaces))
# ```
#
# * TODO
# - Support multi-monitor env
#
# * Dependencies
# - hyprctl (Hyprland)
# - jq (extra/jq)
#
set -eu

readonly CSS_CLASS_ACTIVE="active"
readonly CSS_CLASS_UNUSED="unused"


main() {
    local -r used_ws=$(hyprctl -j workspaces | jq -c "map(.id)")
    local -r cur=$(hyprctl -j activeworkspace | jq -c ".id")

    local ret=$(cat <<-EOS
        (box :class "workspaces"
             :orientation "h"
             :space-evenly true
             :spacing 5
EOS
    )

    local i=1
    for i in $(seq 1 10); do
        local idx="${i}"
        if [ "${idx}" == "10" ]; then
            idx="0"
        fi

        local cls=""
        if [ "${idx}" == "${cur}" ]; then
            cls=":class \"${CSS_CLASS_ACTIVE}\""

        elif [ "$(expr "${used_ws}" : ".*${idx}")" -gt 0 ]; then
            : # used.

        else
            cls=":class \"${CSS_CLASS_UNUSED}\""
        fi


        local ws=$(cat <<-EOS
            (button ${cls} :onclick "scripts/hypr-ws.sh to ${idx}" ${idx})
EOS
        )
        ret="${ret} ${ws}"
    done

    ret="${ret})"

    echo -e "$ret"
}

main $@
exit 0

