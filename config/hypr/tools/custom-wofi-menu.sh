#!/usr/bin/env bash
#
# custom wofi menu.
#
set -eu


#------------------------------------------------------------------------------
# Defines
#------------------------------------------------------------------------------
readonly HOME_DIR=$(eval echo ~$USER)
readonly SS_STORE_DIR="${HOME_DIR}/media/screenshots"



#------------------------------------------------------------------------------
# Menu list
#------------------------------------------------------------------------------
readonly MENU_SAY_HI="Say hi"
readonly MENU_TAKE_SS="ss - Take Screenshot"

# GUI
readonly MENU_RELOAD_EWW="eww - Reload eww"
readonly MENU_RELOAD_WALLPAPER="wallpaper - Reload Wallpaper"
readonly MENU_SETUP_MONITOR="monitor - Setup multi-monitor"

# Powermenu
readonly MENU_LOGOUT="logout"
readonly MENU_SCREEN_LOCK="lock - Screen lock"
readonly MENU_SHUTDOWN="shutdown"
readonly MENU_REBOOT="reboot"
readonly MENU_SUSPEND="hybernate - suspend to RAM"

# List
readonly MENU_LIST=(
    "${MENU_SAY_HI}"

    # Utils
    "${MENU_TAKE_SS}"

    # Hyprland
    "${MENU_RELOAD_EWW}"
    "${MENU_RELOAD_WALLPAPER}"
    "${MENU_SETUP_MONITOR}"

    # Powermenu
    "${MENU_LOGOUT}"
    "${MENU_SCREEN_LOCK}"
    "${MENU_SHUTDOWN}"
    "${MENU_REBOOT}"
    "${MENU_SUSPEND}"
)



#------------------------------------------------------------------------------
# Utils
#------------------------------------------------------------------------------
now_ts() {
    date +'%Y%m%dT%H%M%S'
}

take_ss() {
    local readonly fpath="${SS_STORE_DIR}/ss_$(now_ts).png"
    slurp | grim -g - "${fpath}"
    notify-send "Screenshot" "Saved at ${fpath}"
}



#------------------------------------------------------------------------------
# Main process
#------------------------------------------------------------------------------
main() {
    local readonly mode=$(
        printf "%s\n" "${MENU_LIST[@]}" |
        wofi --dmenu --prompt "Select an option:"
    )

    case "${mode}" in
        #----------------------------------------------------------------------
        # Utils
        #----------------------------------------------------------------------
        "${MENU_TAKE_SS}" )
            take_ss
            ;;


        #----------------------------------------------------------------------
        # GUI
        #----------------------------------------------------------------------
        "${MENU_RELOAD_EWW}" )
            bash ~/.config/eww/exec-eww.sh
            ;;

        "${MENU_RELOAD_WALLPAPER}" )
            bash ~/.config/hypr/tools/wallpaper.sh
            ;;

        "${MENU_SETUP_MONITOR}" )
            bash ~/.config/hypr/tools/moni.sh
            ;;


        #----------------------------------------------------------------------
        # Power menus
        #----------------------------------------------------------------------
        "${MENU_LOGOUT}" )
            hyprctl dispatch exit
            ;;

        "${MENU_SCREEN_LOCK}" )
            hyprlock
            ;;

        "${MENU_SHUTDOWN}" )
            shutdown -h now
            ;;

        "${MENU_REBOOT}" )
            reboot
            ;;

        "${MENU_SUSPEND}" )
            systemctl suspend
            ;;


        #----------------------------------------------------------------------
        # misc
        #----------------------------------------------------------------------
        "${MENU_SAY_HI}" )
            notify-send "Hi!" "Now: $(now_ts)"
            ;;

        * )
            # do nothing.
            ;;
    esac
}


main $@
exit 0

