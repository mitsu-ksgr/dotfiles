#!/usr/bin/env bash
#
# Mirroring monitor.
#
# * GPD Pocket Display
# - DSI-1 (ID 0)
# - 1920x1200
#
# * External Display
# - HDMI-A-1 (ID 1)
# - 1920x1080
#

hyprctl keyword monitor "HDMI-A-1, preferred, 0x0, 1, mirror, DSI-1"

