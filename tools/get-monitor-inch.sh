#!/usr/bin/env bash
#
# Getthe monitor size (inch) in X11 env.
#
# * Dependency
# - X11
# - xrandr
#
set -eu

xrandr | grep " connected" | while IFS= read -r line; do
    read -r name w h <<EOF
        $(echo "${line}" | awk '{print $1, $(NF-2), $NF}')
EOF

    # Remove 'mm'
    w=${w%mm}
    h=${h%mm}

    # Calculate monitor size.
    #
    # inch = squrt(w*w + h*h) / 25.4
    inch=$(echo "scale=1; sqrt(${w}*${w} + ${h}*${h}) / 25.4" | bc)

    # Output
    echo "${name}: ${inch} inch (${w} x ${h})"
done

