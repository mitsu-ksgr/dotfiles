#******************************************************************************
#
#  Alias definitions.
#
#******************************************************************************


#------------------------------------------------------------------------------
#
#   Common aliases
#
#------------------------------------------------------------------------------
# ls
alias l='ls -lahGN --color=auto'
alias ls='ls -GN --color=auto'
alias ll='ls -lhGN --color=auto'
alias la='ls -aGN --color=auto'
alias lla='ls -lahGN --color=auto'

# Clear
alias blank='awk "BEGIN{for(i=0; i<10; ++i){printf\"\";}}"'
alias c='clear'
alias cl='clear; l;'
alias cls='clear; ls;'
alias cll='clear; ll;'
alias cla='clear; la;'

# Utils
alias grep='grep -n --color=auto'
alias frep='find . -type f -name "*.*" | xargs grep -n --color=auto'
alias tree='tree -NC'   # N:文字化け対策, C:色付け
alias bokuno='sudo chown -R $USER:$USER'
alias japman='man -L ja_JP.utf8'

# Image Magick
alias imgsize='identify -format "%wx%h\n"'
function imgresize {
    # imgresize image.jpg 240x240
    # imgresize image.jpg 50%
    convert "$1" -resize "$2" "${1%.*}_$2.${1##*.}"
}

# Git
alias g='git'

# Docker
alias d='docker'
alias dcmp='docker compose'
alias dcls-containers='docker rm -v $(docker ps -aq -f status=exited)'
alias dcls-images='docker rm $(docker images -aq -f "dangling=true")'
alias drmf='docker rm -f $(docker ps -aq)'

# https://github.com/mitsu-ksgr/dcmp-fmt
alias dcmp-watch="watch -n 1 'docker compose ps --format json | dcmp-fmt'"

# k8s
alias kc='kubectl'

# jq
# see: https://github.com/stedolan/jq/issues/243
function jq_scheme {
    jq 'select(objects)|=[.] | map(paths(scalars)) | map(map(select(numbers)="[]") | join(".")) | unique'
}
function jq_paths {
    jq -r 'paths(scalars) as $p | ([$p[] | tostring] | join("."))'
}
function jq_flat {
    jq -r 'paths(scalars) as $p | [([$p[] | tostring] | join(".")), (getpath($p) | tojson)]| join(" = ")'
}


# funcs
function calc {
    [ $# -ge 1 ] && echo "scale=5; $1" | bc
}

function touchp {
    mkdir -p $(dirname "$1")
    touch "$1"
}

function chext {
    echo "${1%.*}.${2}"
}

#------------------------------------------------------------------------------
#
#   Load each os aliases
#
#------------------------------------------------------------------------------
#case "$(uname -s)" in
#    Linux)  source ./.bash_aliases.linux ;;
#    Darwin) source ./.bash_aliases.linux ;;
#esac

my_path="$(cd "$(dirname "${BASH_SOURCE:-${(%):-%N}}")"; pwd)"
dist_name="$(${my_path}/../tools/detect_distribution.sh)"
if [ -n "${dist_name}" -a -f "${my_path}/.bash_aliases.${dist_name}" ]; then
    source "${my_path}/.bash_aliases.${dist_name}" "${my_path}/.."
fi
unset my_path
unset dist_name



