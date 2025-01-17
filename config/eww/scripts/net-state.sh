#!/bin/bash
#
# Output the internet state (json).
#
# * Usage
# ./net-state.sh
# {"state": "", "type": ""}
#
# - state
#   - connected
#   - disconnected
# - type
#   - none ... disconnected
#   - wired ... wired connection
#   - wireless ... wifi connection
#
# * Dependencies
# - jq
# - ip
# - iw
#

set -eu

check_wifi_signal_strength() {
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
    local -r ipr=$(ip route)

    if [[ "${ipr}" == "" ]]; then
        echo '{"state": "disconnected", "type": "none"}'
        return 0
    fi

    # Get the first default interface name
    local -r interface=$(echo "${ipr}" | awk '/^default/ {print $5; exit}')

    # Wired connection
    if [[ "${interface}" == "en"* ]]; then
        cat <<-EOS | jq -c --monochrome-output .
        {
            "state": "connected",
            "type": "wired",
            "interface": "${interface}"
        }
EOS
        return 0
    fi

    # Wireless connection
    local -r conn_info=$(iw dev "${interface}" link)
    if [[ "${conn_info}" == "Not connected." ]]; then
        echo '{"state": "disconnected", "type": "none"}'

    else
        local -r ssid=$(echo "${conn_info}" | grep 'SSID' | awk '{printf $2}')
        local -r signal=$(echo "${conn_info}" | grep 'signal' | awk '{printf $2}')
        local -r quality="$(check_wifi_signal_strength "${signal}")"

        cat <<-EOS | jq -c --monochrome-output .
        {
            "state": "connected",
            "type": "wireless",
            "interface": "${interface}",
            "ssid": "${ssid}",
            "signal": "${signal}",
            "quality": "${quality}"
        }
EOS
    fi
}

main $@
exit 0

