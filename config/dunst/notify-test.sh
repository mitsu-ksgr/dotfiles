#!/usr/bin/env bash
#
# notify-send test.
#
# * Icon names (-i option)
#
#
set -eu



killall dunst


readonly now=$(date +"%Y/%m/%d %H:%M:%S")


#
# Basic
#
notify-send "Test notice!"
notify-send "Test notice!" "Current Time: ${now}"

sleep 1.5


#
# Icon
# see: https://specifications.freedesktop.org/icon-naming-spec/latest/#names
#
notify-send -i face-angel     "Angel" "You should eat Angel food cake!"
sleep 0.5
notify-send -i face-devilish  "Devil" "You should eat Devil's food cake!"
sleep 0.5
notify-send -i face-raspberry "Human" "I'll eat both."

sleep 1.5


#
# urgency: low, normal, critical
#
notify-send -u low      "Urgency Low"      "low urgency something!"
notify-send -u normal   "Urgency Normal"   "normal urgency something!"
notify-send -u critical "Urgency Critical" "critical urgency something!"



