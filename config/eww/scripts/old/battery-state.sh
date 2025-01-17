#!/bin/bash
#
# Output the battery state.
#
# * Usage
# ./battery-state.sh
#
#
# * Output
# - Charging
#   - 🔌100%
#   - 🔌90%
#   - 🔌30%
# - Discharging
#   - 🔋100%
#   - 🔋90%
#   - 🪫30%
set -eu

readonly FILE_BAT=/sys/class/power_supply/BAT0
readonly LOW_BAT_TH=30

readonly ICON_CHARGING="🔌"
readonly ICON_DISCHARGING="🔋"
readonly ICON_DISCHARGING_LOW="🪫"


main() {
    local -r cap=$(cat ${FILE_BAT}/capacity)
    local -r state=$(cat ${FILE_BAT}/status)


    # Charging.
    if [ "${state}" == "Charging" ]; then
        echo "${ICON_CHARGING}${cap}%"

    # Discharging.
    elif [ "${cap}" -ge "${LOW_BAT_TH}" ]; then
        echo "${ICON_DISCHARGING}${cap}%"

    # Discharging: low battery.
    else
        echo "${ICON_DISCHARGING_LOW}${cap}%"
    fi
}

main $@
exit 0


