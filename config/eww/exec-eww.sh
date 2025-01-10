#!/bin/bash

set -eu

#readonly EWW=$(command -v eww)
readonly EWW=/home/mitsu/dev/bin/eww
readonly CONFIG_PATH="$(dirname $0)"

readonly LOG="$(dirname $0)/my.log"

log() {
    echo -e "${1-}" >> ${LOG}
}

count_monitor() {
    find /sys/class/drm/ \
        -name "card*-*" \
        -exec grep -q "^connected$" {}/status \; \
        -print | wc -l
}


log "\nexec-eww.sh: start"

main() {
    log "EWW=${EWW}"
    log "CONFIG_PATH=${CONFIG_PATH}"

    if ! pidof eww > /dev/null; then
        log "eww is not started."
        ${EWW} daemon
        sleep 1
        log "eww daemon running"
    else
        log "eww is already started."
    fi

    local readonly monitor_count=$(count_monitor)
    log "monitor count: ${monitor_count}"

    ${EWW} close-all

    if [ ${monitor_count} -eq 1 ]; then
        ${EWW} --config "${CONFIG_PATH}" open bar

    else # Multi monitor
        ${EWW} --config "${CONFIG_PATH}" open bar --screen 0 --id primary
        ${EWW} --config "${CONFIG_PATH}" open bar --screen 1 --id secondary
    fi

    return 0
}

main $@
log "exec-eww.sh: finish"

exit 0



