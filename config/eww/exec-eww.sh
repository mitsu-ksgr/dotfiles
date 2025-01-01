#!/bin/bash

set -eu

#readonly EWW=$(command -v eww)
readonly EWW=/home/mitsu/dev/bin/eww
readonly CONFIG_PATH="$(dirname $0)"

readonly LOG="$(dirname $0)/my.log"

log() {
    echo -e "${1-}" >> ${LOG}
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

    ${EWW} --config "${CONFIG_PATH}" \
        open bar


    return 0
}

main $@
log "exec-eww.sh: finish"

exit 0



