#!/usr/bin/env bash
#
set -eu

readonly SCRIPT_NAME=$(basename $0)
readonly WP_BASE_PATH=~/media/wallpapers


if pgrep -x mpvpaper > /dev/null; then
    echo "mpvpaper is already running. stop it."
    pkill -x mpvpaper
fi

#readonly wp_path="${WP_BASE_PATH}/livebg-cityspace.mp4"
#readonly wp_path="${WP_BASE_PATH}/spl2_octo_wallpaper.mp4"
readonly wp_path="${WP_BASE_PATH}/st-trina-loop.mp4"

nohup mpvpaper \
    -s -o "no-audio --loop" \
    '*' \
    "${wp_path}" \
    > /dev/null 2>&1 &


