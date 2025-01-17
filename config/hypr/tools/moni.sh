#!/usr/bin/env bash
#
# * Usage
# ./moni.sh OPTION
#
# - OPTION
#   - ext
#   - mirror
#
#
# * Dependencies
# - hyprctl
# - jq
# - eww
#
#
# * Preconditions
# - for GPD Pocket 3
# - Only one external monitor.
#
#
set -eu

readonly SCRIPT_NAME=$(basename $0)


# MM ... Main Monitor
# - transform = 3
# - scale     = x2.0
readonly MM_NAME=DSI-1
readonly MM_RESO=1920x1200
readonly MM_W=1920
readonly MM_H=1200

# EM ... External Monitor
readonly EM_RESO=1920x1080
readonly EM_W=1920
readonly EM_H=1080
readonly EM_SCALE=1.0


usage() {
    cat << __EOS__
Usage:
    ${SCRIPT_NAME} [MODE]

Mode:
    ext ... external monitor.
    mirror ... mirroring mode.


__EOS__
}

err() {
    echo "Error: $@" 1>&2
    exit 1
}

main() {
    #--------------------------------------------
    # Validation args.
    #
    # - ext ... default.
    # - mirror ... mirroring mode.
    #--------------------------------------------
    local -r mode="${1:-ext}"
    #echo "Mode: ${mode}"

    case "${mode}" in
        ext | mirror) ;;
        * )
            err "Invalid mode specified: ${mode}."
            ;;
    esac
    echo "Mode: ${mode}"



    #--------------------------------------------
    # Get monitor information
    #--------------------------------------------
    local -r monis=$(hyprctl -j monitors all)
    local -r moni_count=$(echo "${monis}" | jq ". | length")

    if [ "${moni_count}" -le 1 ]; then
        echo "Main monitor only."
        exit 0
    fi

    ### DEBUG: start
    #for ((i=0; i<moni_count; ++i)); do
    #    local -r w=$(echo "${monis}" | jq ".[${i}].width")
    #    local -r h=$(echo "${monis}" | jq ".[${i}].height")
    #    local -r name=$(echo "${monis}" | jq -r ".[${i}].name")
    #    echo "- Monitor [${i}]: ${name} (${w}x${h})"
    #done
    ### DEBUG: end



    #--------------------------------------------
    # External monitor
    #--------------------------------------------
    local -r em_name=$(echo "${monis}" | jq -r ".[1].name")

    # Resolution check
    local -r em_reso_available=$(
        echo "${monis}" |
        jq "[.[1].availableModes[] | contains(\"${EM_RESO}\")] | any"
    )
    if [ "${em_reso_available}" != "true" ]; then
        err "The external monitor (${em_name}) does not support a resolution of ${EM_RESO}."
    fi


    #--------------------------------------------
    # Connect monitor
    #
    # monitor = name, resolution, position, scale
    #--------------------------------------------
    local hymoni=""
    case "${mode}" in
        ext )
            hymoni="${em_name}, ${EM_RESO}, auto-up, ${EM_SCALE}"
            ;;

        mirror)
            hymoni="${em_name}, preferred, 0x0, ${EM_SCALE}, mirror, ${MM_NAME}"
            ;;
    esac
    hyprctl keyword monitor "${hymoni}"



    #--------------------------------------------
    # Setup eww
    #--------------------------------------------
    eww close-all
    case "${mode}" in
        ext )
            eww open bar --screen 0 --id primary
            eww open bar --screen 1 --id secondary
            ;;

        mirror)
            eww open bar
            ;;
    esac
}

main $@
exit 0

