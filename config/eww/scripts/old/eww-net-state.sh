#!/bin/bash
#
# Output network widget contents for the eww's status-bar.
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


get_net_state() {
    local -r p=$(pwd)
    cd $(dirname $0)
    local -r s=$("./net-state.sh")
    cd "${p}"
    echo "${s}"
}

check_signal_strength() {
    local -r signal="${1-}"

    if [ "${signal}" -ge -30 ]; then
        echo "excellent"
    elif [ "${signal}" -ge -65 ]; then
        echo "good"
    elif [ "${signal}" -ge -70 ]; then
        echo "normal"
    elif [ "${signal}" -ge -80 ]; then
        echo "weak"
    else
        echo "bad"
    fi
}



main() {
    local -r net_state=$(get_net_state)
    local -r state=$(echo "${net_state}" | jq -r ".state")

    #echo "* Net State"
    #echo "${net_state}"
    #echo "State: ${state}"

    local class=
    local content=

    if [ "${state}" == "disconnected" ]; then
        class="disconnected"
        content="🌐❌"
    else
        local -r ssid=$(echo "${net_state}" | jq -r ".ssid")
        local -r signal=$(echo "${net_state}" | jq -r ".signal")

        #local -r quality=$(check_signal_strength "${signal}")

        class="$(check_signal_strength "${signal}")"
        content="🌐${signal}dBm"
    fi


    local eww_lbl=$(cat <<-EOS
        (label :class "${class}" :text "${content}")
EOS
    )
    #echo "${eww_lbl}"

    local ret=$(cat <<-EOS
        (box :class "net-state"
             :orientation "h"
             :tooltip "SSID: ${ssid}"

             ${eww_lbl}
             )
EOS
    )
    echo "${ret}"

}

main $@
exit 0

