#!/bin/bash

#curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
#    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

if [ ! -d ~/.vim/autoload -a ! -f ~/.vim/autoload/plug.vim ]; then
    echo "installing vim-plug ..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "vim-plug installed!!"
else
    echo "vim-plug already installed"
fi

