#!/bin/bash
set -e

readonly SCRIPT_NAME=$(basename $0)

usage () {
    cat << __EOS__
Usage:
    ${SCRIPT_NAME} [-h] BRIGHTNESS

Description:
    set brightness of the display as percentage.

PARAMETERS:
    BRIGHTNESS  value of brightness as percentage (0 ~ 100).
__EOS__
}

die() {
    echo $@ 1>&2
    usage
    exit 1
}


if [ "$1" = '-h' -o -z "$1" ]; then
    usage
    exit 0
fi


arg=$1
if [[ $arg =~ ^[0-9]+$ ]]; then
    : # ok
else
    die "Error: invalid value. '${arg}'"
fi

if (( 0 <= "$arg" && "$arg" <= 100 )); then
    : # ok
else
    die "Error: invalid value. '${arg}'"
fi


brightness=$(echo "scale=2; $arg / 100.0" | bc)
displays=$(xrandr | grep ' connected' | cut -d ' ' -f 1)
for display in $displays; do
    xrandr --output ${display} --brightness ${brightness}
done

exit 0

