#!/bin/bash
#
# Sound helper.
#
#
# * Usage
# ./sound.sh            ... get current volume.
# ./sound.sh mute       ... set to mute
# ./sound.sh unmute     ... unmute
# ./sound.sh toggle     ... toggle mute / unmute
# ./sound.sh set 80     ... set volume.
#
#
# * Dependencies
# - pactl (extra/libpulse)
# - jq (extra/jq)
#
set -eu


#
# Params
#
readonly sink_name=$(pactl get-default-sink) # or "0"
readonly sink_info=$(\
    pactl --format=json list sinks |\
    jq ".[] | select(.name == \"${sink_name}\")" )



#
# Utils
#
validate_number() {
    local -r value=$(echo "${1-}" | grep -Eo '^[+-]?[0-9]+%?$')
    echo "${value}" | tr -d "%"
}

is_mute() {
    echo ${sink_info} | jq '.mute'
}

get_volume() {
    echo ${sink_info} |\
        jq '.volume."front-left".value_percent' |\
        tr -d '"'
}

set_volume() {
    local -r vol=$(echo "${1-}" | tr -d "%") # Remove % if exists.
    if [ -z "${vol}" ]; then
        return # TODO: Error?
    fi

    pactl set-sink-volume ${sink_name} ${vol}%
}



#
# Entrypoint
#
main() {
    ### Error
    if [ -z "${sink_name}" ]; then exit 1; fi
    if [ -z "${sink_info}" ]; then exit 1; fi


    ### Args
    local mode="${1-}"
    if [ -z "${mode}" ]; then
        mode="volume"
    fi
    local -r is_mute=$(is_mute)


    ### Mode
    case "${mode}" in
        ### Get
        volume | vol )
            if [ "${is_mute}" == "true" ]; then
                echo "🔇Mute"
            else
                local -r vol=$(get_volume | tr -d "%")

                if [ "${vol}" -ge "70" ]; then
                    echo "🔊${vol}%"
                elif [ "${vol}" -ge "30" ]; then
                    echo "🔉${vol}%"
                else
                    echo "🔈${vol}%"
                fi
            fi
            ;;

        value )
            local -r vol=$(get_volume | tr -d "%")
            local -r ret=$(cat <<-EOS
                {
                    "is_mute": "${is_mute}",
                    "volume": ${vol}
                }
EOS
            )
            echo $ret
            ;;

        info )
            echo "{\"is_mute\": \"${is_mute}\", \"volume\": \"$(get_volume)\"}"
            ;;

        set )
            local -r vol=$(validate_number "${2-}")
            if [ -n "${vol}" ]; then
                set_volume "${vol}"
            fi
            ;;

        up )
            local -r vol=$(validate_number "${2-}" | sed 's/[^0-9]//g')
            if [ -n "${vol}" ]; then
                set_volume "+${vol}"
            else
                set_volume "+5%"
            fi
            ;;

        down )
            local -r vol=$(validate_number "${2-}" | sed 's/[^0-9]//g')
            if [ -n "${vol}" ]; then
                set_volume "-${vol}"
            else
                set_volume "-5%"
            fi
            ;;


        ### Mute / Unmute
        mute )
            pactl set-sink-mute ${sink_name} 1
            ;;

        unmute | umute )
            pactl set-sink-mute ${sink_name} 0
            ;;

        toggle | toggle-mute | tmute | tm )
            pactl set-sink-mute ${sink_name} toggle
            ;;


        ### Others: Specify the volume value directly
        * )
            local -r vol=$(validate_number "${mode}")
            if [ -n "${vol}" ]; then
                set_volume "${vol}"
            fi
            ;;
    esac

}

main $@
exit 0

