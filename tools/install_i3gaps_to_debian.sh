#!/bin/sh

#
# i3gaps install support for debian streach
# - Airblader/i3 https://github.com/Airblader/i3
#
set -e

readonly I3GAP_GIT_REPO=https://www.github.com/Airblader/i3
readonly I3GAP_CLONE_PATH=$HOME/dev/src/github.com/Airblader

#
# Install dependent packages
#
echo 'Install dependent packages...'
depends_pkgs () {
    cat << __EOS__
i3
libxcb-keysyms1-dev
libpango1.0-dev
libxcb-util0-dev
xcb
libxcb1-dev
libxcb-icccm4-dev
libyajl-dev
libev-dev
libxcb-xkb-dev
libxcb-cursor-dev
libxkbcommon-dev
libxcb-xinerama0-dev
libxkbcommon-x11-dev
libstartup-notification0-dev
libxcb-randr0-dev
libxcb-xrm0
libxcb-xrm-dev
libxcb-shape0-dev
__EOS__
}

depends_pkgs | xargs sudo apt install -y


#
# clone i3-gaps
#
echo 'Clone i3-gaps...'
if [ ! -e ${I3GAP_CLONE_PATH} ]; then
    mkdir -p ${I3GAP_CLONE_PATH}
fi
cd ${I3GAP_CLONE_PATH}

if [ -e ./i3/.git ]; then
    echo 'i3-gaps already cloned!'
else
    git clone -b gaps ${I3GAP_GIT_REPO}
fi
cd ./i3


#
# Compile & Install
# cf. https://github.com/Airblader/i3/wiki/Compiling-&-Installing#basics
#
echo 'Compile & Install i3-gaps...'
autoreconf --force --install
rm -rf build/
mkdir -p build && cd build/
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make
sudo make install

echo 'Completed!'
i3 --version

exit 0
