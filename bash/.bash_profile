#******************************************************************************
#
#   .bash_profile
#
#******************************************************************************
DOTPATH=${HOME}/dotfiles

if [ -f ${DOTPATH}/env/.profile ]; then
    . ${DOTPATH}/env/.profile
fi

unset DOTPATH
