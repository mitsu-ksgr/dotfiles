#!/bin/bash

#
#   Detect OS/Distribution Name.
#
#   - Debian        'debian'
#   - ArchLinux     'arch'
#   - Ubuntu        'ubuntu'
#   - OSX           'darwin'
#
set -eu

dist=''
case "$(uname -s)" in
    Linux* )
        dist=$(cat /etc/*release | awk -F= '/^ID=.*/ {print $2}')
        ;;
    
    Darwin* )
        dist='darwin'
        ;;
esac

echo "${dist}"

exit 0

