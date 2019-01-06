#!/bin/bash

#
# install noto-color-emoji to debian.
#
# cf. https://www.google.com/get/noto/#emoji-zsye-color
# cf. https://www.google.com/get/noto/help/install/
#
set -e

readonly SCRIPT_NAME=$(basename $0)

readonly DL_URL=https://noto-website-2.storage.googleapis.com/pkgs/NotoColorEmoji-unhinted.zip
readonly DL_FILE="${DL_URL##*/}"

#
# flag
#
readonly FLAG_INSTALL_FOR=system    # install for system (all users).
#readonly FLAG_INSTALL_FOR=user      # install for single user.


#
# prepare temp dir
#
unset TMP_DIR
on_exit() { [[ -n "${TMP_DIR}" ]] && rm -rf "${TMP_DIR}"; }
trap on_exit EXIT
trap 'trap - EXIT; on_exit; exit -1' INT PIPE TERM
readonly TMP_DIR=$(mktemp -d "/tmp/${SCRIPT_NAME}.tmp.XXXXXX")


#
# Download zip
#
cd ${TMP_DIR}
curl -OL ${DL_URL}
if [ ! -f "${TMP_DIR}/${DL_FILE}" ]; then
    echo "ERROR: Failed to download noto-color-emoji: URL=${DL_URL}" 1>&2
    exit 1
fi

unzip ${DL_FILE}


#
# install for single user.
#
if [ "${FLAG_INSTALL_FOR}" == 'user' ]; then
    mkdir -p ~/.fonts
    cp ${TMP_DIR}/*.ttf ~/.fonts
    fc-cache -fv

#
# install for system (all users).
#
else
    font_dir=/usr/share/fonts/truetype/noto
    sudo mkdir -p ${font_dir}
    sudo cp ${TMP_DIR}/*.ttf ${font_dir}
    sudo fc-cache -fv
fi

exit 0
