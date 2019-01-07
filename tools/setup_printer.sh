#!/bin/bash
set -e

#
# Target ..... Debian
# Printer .... DCP-J957N
#
# - cf. https://support.brother.co.jp/j/b/producttop.aspx?c=jp&lang=ja&prod=dcpj957n
#

readonly SCRIPT_NAME=$(basename $0)

readonly DL_URL_CUPS_DRIVER=https://download.brother.com/welcome/dlf100577/dcpj952ncupswrapper-3.0.0-1.i386.deb
readonly CUPS_DRIVER_FILE="${DL_URL_CUPS_DRIVER##*/}"

readonly DL_URL_LPR_DRIVER=https://download.brother.com/welcome/dlf100575/dcpj952nlpr-3.0.0-1.i386.deb
readonly LPR_DRIVER_FILE="${DL_URL_LPR_DRIVER##*/}"


#
# prepare temp dir
#
unset TMP_DIR
on_exit() { [[ -n "${TMP_DIR}" ]] && rm -rf "${TMP_DIR}"; }
trap on_exit EXIT
trap 'trap - EXIT; on_exit; exit -1' INT PIPE TERM
readonly TMP_DIR=$(mktemp -d "/tmp/${SCRIPT_NAME}.tmp.XXXXXX")


#
# Install cups / lpr
# - cups ... The Common UNIX Printing System
# - lpr .... Line printer spooling system
#
sudo apt install cups lpr

# DCP-J957N を 64bit システムで使用する場合、32bit ライブラリが必要らしい。
sudo apt install lib32stdc++6


#
# Download deb files
#
cd ${TMP_DIR}

curl -OL ${DL_URL_CUPS_DRIVER}
if [ ! -f "${TMP_DIR}/${CUPS_DRIVER_FILE}" ]; then
    echo "ERROR: Failed to download cups driver: URL=${DL_URL_CUPS_DRIVER}" 1>&2
    exit 1
fi

curl -OL ${DL_URL_LPR_DRIVER}
if [ ! -f "${TMP_DIR}/${LPR_DRIVER_FILE}" ]; then
    echo "ERROR: Failed to download lpr driver: URL=${DL_URL_LPR_DRIVER}" 1>&2
    exit 1
fi


#
# install deb files
#
sudo dpkg -i --force-all ${TMP_DIR}/${LPR_DRIVER_FILE}
sudo dpkg -i --force-all ${TMP_DIR}/${CUPS_DRIVER_FILE}


cat << __EOS__
Driver installed!!

Next steps:
- 1. Open cups management page (http://localhost:631/admin)
- 2. Add DCP-J957N printer

__EOS__

#
# open cups page
#
xdg-open 'http://localhost:631/admin'

exit 0

