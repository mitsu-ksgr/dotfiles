#!/bin/bash

#
# Install the Google Play Music Manager to the Debian system.
#
# cf. https://support.google.com/googleplaymusic/answer/1075570?visit_id=636826112004987940-4162487573&rd=1
# cf. https://play.google.com/music/listen?u=0#/manager
#
set -e

readonly SCRIPT_NAME=$(basename $0)
readonly DL_URL=https://dl.google.com/linux/direct/google-musicmanager-beta_current_amd64.deb
readonly DL_FILE="${DL_URL##*/}"


#
# prepare temp dir
#
unset TMP_DIR
on_exit() { [[ -n "${TMP_DIR}" ]] && rm -rf "${TMP_DIR}"; }
trap on_exit EXIT
trap 'trap - EXIT; on_exit; exit -1' INT PIPE TERM
readonly TMP_DIR=$(mktemp -d "/tmp/${SCRIPT_NAME}.tmp.XXXXXX")


#
# Download
#
cd ${TMP_DIR}
curl -OL ${DL_URL}
if [ ! -f "${TMP_DIR}/${DL_FILE}" ]; then
    echo "ERROR: Failed to download ${DL_FILE}: URL=${DL_URL}" 1>&2
    exit 1
fi


#
# install packages.
#
sudo dpkg -i ${DL_FILE}
sudo apt --fix-broken install

echo 'successfully install the PlayMusicManager.'

google-musicmanager

exit 0
