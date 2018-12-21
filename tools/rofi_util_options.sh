#!/bin/bash
#
#   Utility option selection with Rofi.
#
#   - TODO: もはやpower managerではないこともやってるから、名前をなんとかする
#
set -e

readonly dotfile_path="$HOME/dotfiles"
readonly tools_path="$dotfile_path/tools"
readonly tools_ext_path="$tools_path/external"

readonly font="Inconsolata 18"

readonly menus=(
    #----- i3wm menus
    "Reload i3"
    "Restart i3"
    "Exit i3"
    "Close Window"

    #----- Screen shot
    "ss - Take the Screen shot"
    "capgif - Caputre gif"

    #----- Power options
    "Sleep"             # Alias to Suspend
    "Suspend"           # Suspend to RAM
    #"Hibernate"         # Suspend to disk
    #"Hybrid Suspend"    # Suspend & Hibernate
    "Logout"
    "Reboot"
    "Shutdown"
    #"Halt"


    #========== TEST ==========
    #----- utils
    "compton-switch"
    "Dunst Restart"
    "Fcitx Restart"

    #----- notification test
    "notify-test"
    "notify-test-low"
    "notify-test-critical"
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


case "${result}" in
    #----- i3wm
    "Reload i3" )       i3-msg reload ;;
    "Restart i3" )      i3-msg restart ;;
    "Exit i3" )         i3-msg exit ;;
    "Close Window" )    i3-msg kill ;;


    #----- Screen shot
    "ss - Take the Screen shot" )
        output_path="${HOME}/Downloads/ss-$(date +%FT%T).png"
        $tools_ext_path/linux-screen-capture/take_ss.sh "${output_path}"
        notify 'Taken screenshot!' "Saved to: ${output_path}" 'low'
        ;;

    "capgif - Caputre gif" )
        output_path="${HOME}/Downloads/cap-$(date +%FT%T).gif"
        $tools_ext_path/linux-screen-capture/rec_screen.sh "${output_path}"
        notify 'Desktop Captured!' "Saved to: ${output_path}" 'low'
        ;;


    #----- Power options
    "Sleep" | "Suspend" )   exec systemctl suspend ;;
    "Hibernate" )           exec systemctl hibernate ;;
    "Hybrid Suspend" )      exec systemctl hybrid-sleep ;;
    "Logout" )              exec i3-msg exit ;;
    "Reboot" )              exec systemctl reboot ;;
    "Shutdown" )            exec systemctl poweroff ;;
    "Halt" )                exec systemctl halt ;;


    #========== TEST ==========
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
esac

exit 0
