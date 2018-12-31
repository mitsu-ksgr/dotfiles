#!/bin/bash

#
# Launch Polybar
#
# - cf. https://wiki.archlinux.org/index.php/Polybar#Running_with_WM
#


# Terminate already running bar instance
killall -q polybar

# Wait until the processes have been shut down
while grep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config
polybar example &


