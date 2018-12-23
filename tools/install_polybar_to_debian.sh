#!/bin/sh

#
# Polybar install support for debian streach
# - jaagr/polybar https://github.com/jaagr/polybar
#
set -e

readonly POLYBAR_GIT_REPO=https://github.com/jaagr/polybar
readonly POLYBAR_CLONE_PATH=$HOME/dev/src/github.com/jaagr


#
# Install dependent packages
#
echo 'Install dependent packages...'
depends_pkgs () {
    # cf. https://github.com/jaagr/polybar/wiki/Compiling#dependencies
    cat << __EOS__
build-essential
git
cmake
cmake-data
pkg-config
libcairo2-dev
libxcb1-dev
libxcb-util0-dev
libxcb-randr0-dev
libxcb-composite0-dev
python-xcbgen
xcb-proto
libxcb-image0-dev
libxcb-ewmh-dev
libxcb-icccm4-dev
__EOS__
}
depends_opt_pkgs () {
    # cf. https://github.com/jaagr/polybar/wiki/Compiling#optional-dependencies
    cat << __EOS__
libxcb-xkb-dev
libxcb-xrm-dev
libxcb-cursor-dev
libasound2-dev
libpulse-dev
libjsoncpp-dev
libmpdclient-dev
libcurl4-openssl-dev
libiw-dev
libnl-genl-3-dev
__EOS__
}


depends_pkgs | xargs sudo apt install -y
depends_opt_pkgs | xargs sudo apt install -y


#
# clone polybar
#
echo 'Clone polybar...'
if [ ! -e ${POLYBAR_CLONE_PATH} ]; then
    mkdir -p ${POLYBAR_CLONE_PATH}
fi
cd ${POLYBAR_CLONE_PATH}

if [ -e ./polybar/.git ]; then
    echo 'polybar already cloned!'
else
    git clone -b gaps ${POLYBAR_GIT_REPO}
fi
cd ./polybar


#
# Compile & Install
#
echo 'Compile & Install polybar...'
rm -rf build/
mkdir -p build && cd build/
cmake ..
sudo make install

echo 'Completed!'

polybar --version
exit 0
