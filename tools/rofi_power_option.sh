#!/bin/bash
#
#   Power Option selection with Rofi.
#
#   - TODO: もはやpower managerではないこともやってるから、名前をなんとかする
#
set -e

readonly font="Inconsolata 18"

readonly menus=(
    #----- i3wm menus
    "Reload i3"
    "Restart i3"
    "Exit i3"
    "Close Window"

    #----- utils
    "compton-switch"
    "notify-test"
    "notify-test-low"
    "notify-test-critical"
    "Dunst Restart"
    "Fcitx Restart"
    "ss"    # Screenshot: maim

    #----- Power options
    "Suspend"           # Suspend to RAM
#    "Hibernate"         # Suspend to disk
#    "Hybrid Suspend"    # Suspend & Hibernate
    "Reboot"
    "Shutdown"
#    "Halt"
)


#
# Notification helper.
#
notify() {
    lv=${3:-normal}
    if hash notify-send 2>/dev/null; then
        notify-send -u "$lv" "$1" "$2" --icon=dialog-information
    fi
}



readonly result=$(
    printf "%s\n" "${menus[@]}" | \
    rofi -dmenu -p "PowerOptios: " \
            -i -hide-scrollbar -tokenize \
            -lines ${#menus[@]} -eh 1 -width 50 -padding 50 \
            -disable-history -font "${font}"
)
#echo "Rofi PowerOptions: '${result}' selected."

case "${result}" in
    #----- i3wm
    "Reload i3" )       i3-msg reload ;;
    "Restart i3" )      i3-msg restart ;;
    "Exit i3" )         i3-msg exit ;;
    "Close Window" )    i3-msg kill ;;


    #----- Power options
    "Suspend" )         exec systemctl suspend ;;
    "Hibernate" )       exec systemctl hibernate ;;
    "Hybrid Suspend" )  exec systemctl hybrid-sleep ;;
    "Reboot" )          exec systemctl reboot ;;
    "Shutdown" )        exec systemctl poweroff ;;
    "Halt" )            exec systemctl halt ;;


    #----- notification test
    "notify-test" )          notify 'Hello!' 'This is notification test!' ;;
    "notify-test-low" )      notify 'Hello!' 'This is low level notification test!' 'low' ;;
    "notify-test-critical" ) notify 'Hello!' 'THis is critical notification test!' 'critical' ;;


    #----- other
    "Dunst Restart" )
        killall dunst
        i3-msg restart
        ;;

    "Fcitx Restart" )
        fcitx -r
        notify 'Restart fcitx'
        ;;

    "compton-switch" )
        if pgrep compton &> /dev/null; then
            pkill compton &
            notify 'compton off'
        else
            compton -b --config $HOME/.config/compton/compton.conf
            notify 'compton on'
        fi
        ;;

    "ss" )
        compton_flag=0
        if pgrep compton &> /dev/null; then
            pkill compton &
            compton_flag=1
        fi

        output_path="${HOME}/Downloads/ss-$(date +%FT%T).png"
        maim -s ${output_path}
        notify 'Taken screenshot!' "Saved to: ${output_path}" 'low'

        if [ $compton_flag -eq 1 ]; then
            compton -b --config $HOME/.config/compton/compton.conf
        fi
        ;;

esac

exit 0

