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
alias l='ls -lahG --color=auto'
alias ls='ls -G --color=auto'
alias ll='ls -lhG --color=auto'
alias la='ls -aG --color=auto'
alias lla='ls -lahG --color=auto'

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

# Git
alias g='git'

# Docker
alias d='docker'
alias dcmp='docker-compose'
alias dcls-containers='docker rm -v $(docker ps -aq -f status=exited)'
alias dcls-images='docker rm $(docker images -aq -f "dangling=true")'
alias drmf='docker rm -f $(docker ps -aq)'

# k8s
alias kc='kubectl'


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



