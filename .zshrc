###############################################################################
# zshrc
###############################################################################

#################################################
# Environment variables
#################################################
# utf-8
export LANG=ja_JP.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# エディタ
export EDITOR=/usr/local/bin/vim


##############################
# Mac OS X
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/sbin
export PATH=$PATH:/usr/local/share/python

##############################
# C++ Include/Library Path
export CPLUS_INCLUDE_PATH=/usr/local/include
#export CPLUS_LIBRARY_PATH=/usr/local/lib

# ccache
export CCACHE_COMPILERCHECK=content
export CCACHE_MAXSIZE=3G


##############################
# Java
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`


##############################
# Android SDK
#export ANDROID_HOME=/Applications/Develops/Android/adt-bundle-mac-x86_64/sdk
export ANDROID_HOME=/Applications/develop/android-sdk
export ANDROID_TOOLS=$ANDROID_HOME/tools
#export ANDROID_SDK_TOOLS=/Applications/Develops/Android/adt-bundle-mac-x86_64/sdk/platform-tools
export ANDROID_SDK_TOOLS=/Applications/develop/android-sdk/platform-tools
export PATH=$PATH:ANDROID_SDK_TOOLS:$ANDROID_TOOLS:$ANDROID_SDK_TOOLS

#############################
# cocos2d-x
# Add environment variable COCOS_CONSOLE_ROOT for cocos2d-x
export COCOS_CONSOLE_ROOT=~/Projects/github/cocos2d-x/tools/cocos2d-console/bin
export PATH=$COCOS_CONSOLE_ROOT:$PATH
# Add environment variable NDK_ROOT for cocos2d-x
export NDK_ROOT=/Applications/Develops/Android/android-ndk-r9
export PATH=$NDK_ROOT:$PATH
# Add environment variable ANDROID_SDK_ROOT for cocos2d-x
export ANDROID_SDK_ROOT=/Applications/Develops/Android/adt-bundle-mac-x86_64/sdk
export PATH=$ANDROID_SDK_ROOT:$PATH
export PATH=$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools:$PATH
# Add environment variable ANT_ROOT for cocos2d-x
export ANT_ROOT=/usr/local/bin
export PATH=$ANT_ROOT:$PATH


#############################
# My Command
export PATH=$PATH:$HOME/m2cmd

#################################################
# Command alias
#################################################
alias l='ls -lahG'
alias ls='ls -G'
alias ll='ls -lhG'
alias la='ls -aG'
alias lla='ls -lhaG'
alias c='clear'
alias cl='clear;l;'
alias frep='find . -type f -name "*.*" | xargs grep -n --color=auto '
alias grep='grep -n --color=auto '
alias tree='tree -NC'           # N:文字化け対策, C:色付けする
alias blank='awk "BEGIN{for(i=0;i<10;++i){print \"\";}}"'
alias g='git'
alias d='docker'
alias dcmp='docker-compose'
alias tidy5='/usr/local/Cellar/tidy-html5/5.1.25/bin/tidy'  # need `brew install tidy-html5`

# for Mac OS X
case ${OSTYPE} in
    darwin*)
        alias finder='open -a Finder .'
        alias chrome='open -a /Applications/browser/Google\ Chrome.app'
esac

# docker command
alias dcls-containers='docker rm -v $(docker ps -aq -f status=exited)'
alias dcls-images='docker rmi $(docker images -aq -f "dangling=true")'
alias drmf='docker rm -f $(d ps -aq)'


#################################################
# zsh
#################################################
setopt correct                  # "もしかして:"機能を有効
setopt nobeep                   # ビープを鳴らさない
setopt prompt_subst             # 色を使用する
setopt no_tify                  # バックグラウンド処理終了時に即時通知する
setopt auto_pushd               # cdしたら、自動的にpushdする
setopt pushd_ignore_dups        # でも重複ディレクトリは追加しない
setopt hist_ignore_dups         # 直前と同じコマンドをヒストリーに追加しない
setopt print_eight_bit          # 8bit文字を出力:日本語ファイル名を表示可能に。
setopt no_flow_control          # フローコントロールを無効にする
setopt interactive_comments     # '#'以降をコメントとして扱う
unsetopt auto_menu              # タブによるファイルの順番切り替えを行わない

# Command History
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
HISTTIMEFORMAT="[%Y-%M-%DT%H:%M:%S] "
setopt SHARE_HISTORY            # 履歴を共有する
setopt APPEND_HISTORY           # 履歴は上書きではなく追加で保存する
setopt EXTENDED_HISTORY         # 履歴に時刻情報も付加
setopt HIST_EXPIRE_DUPS_FIRST   # 履歴の保存上限到達時は、最も古いものから削除する
setopt HIST_FIND_NO_DUPS        # 履歴検索中、重複を飛ばす
setopt HIST_NO_STORE            # historyコマンドを履歴に含めない
setopt HIST_IGNORE_DUPS         # 前と同じコマンドは履歴に含めない
setopt HIST_IGNORE_ALL_DUPS     # 重複した履歴は含めない
setopt HIST_IGNORE_SPACE        # 履歴に余分な空白は含めない

# Prompt
autoload -Uz compinit           # 補完機能を有効にする
compinit
autoload -Uz colors; colors     # 補完でカラーを使用
autoload -Uz is-at-least        # zshバージョン比較用
autoload -Uz add-zsh-hook       # zshフック

# LS_COLORS
export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'


#################################################
# VCS
#################################################
autoload -Uz vcs_info
# zstyle ':vcs_info:*' enable git cvs svn hg bzr
zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' max-exports 3  # 通常メッセージ,警告メッセージ,エラーメッセージをエクスポートする
#zstyle ':vcs_info:*' formats '(%s)-[%b]'
#zstyle ':vcs_info:*' actionformats '(%s)-[$b|%a]'
#zstyle ":vcs_info:(svn|bzr):*" branchformat "%b:r%r"
#zstyle ":vcs_info:bzr:*" use-simple true
#zstyle ":vcs_info:*" max-exports 6

zstyle ':vcs_info:*' formats '[%s! %F{cyan}*%b%f]'
zstyle ':vcs_info:*' actionformats '[%F{cyan}*%b%f(%F{red}%a%f)]'

if is-at-least 4.3.10; then
   zstyle ':vcs_info:git:*' formats '[(%s) %F{cyan}*%b%f]' '%F{yellow}%c%u %m%f'
   zstyle ':vcs_info:git:*' actionformats '[(%s) %F{cyan}*%b%f(%F{red}%a%f)]' '%F{yellow}%c%u %m%f' '%F{red}<!%a>%f'
   zstyle ':vcs_info:git:*' check-for-changes true  # commitしていないものをチェック
   zstyle ':vcs_info:git:*' stagedstr "+"           # %cで表示する文字列
   zstyle ':vcs_info:git:*' unstagedstr "-"         # %uで表示する文字列
fi


#################################################
# Prompt
#################################################

OK="(*ﾟ－ﾟ) OK! "
NG="(-Д -;) NG! "


precmd() {
    local rprompt="[%F{magenta}%C%f]"

    psvar=()
    LANG=en_US.UTF-8 vcs_info

    if [[ -z ${vcs_info_msg_0_} ]]; then
        # do nothing...
    else
        local -a messages
        [[ -n "$vcs_info_msg_0_" ]] && messages+=( "${vcs_info_msg_0_}" )
        [[ -n "$vcs_info_msg_1_" ]] && messages+=( "${vcs_info_msg_1_}" )
        [[ -n "$vcs_info_msg_2_" ]] && messages+=( "${vcs_info_msg_2_}" )
        rprompt+="${(j: :)messages}"
    fi
    RPROMPT="$rprompt"
}

#PROMPT="[%m]$(vcs_prompt_info)%# "
#PROMPT="[%m][%1(v|%F{green}%1v%f|)]%# "
#PROMPT="[%*-%m]%# "
PROMPT="[%*]%# "
RPROMPT="[%F{magenta}%C%f]${vcs_info_msg_0_}"


#################################################
# Functions
#################################################
# iTerm2のタブ名を変更する
function title {
    echo -ne "\033]0;"$*"\007"
}

#############################
# Android
function logdog {
    local awk_arg="/$1/"'{print $0}'
    adb logcat | awk $awk_arg
}

#############################
# Peco
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(history -n 1 | eval &tac | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history


#################################################
# Python: pyenv
#################################################
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


#################################################
# Ruby: rbenv
#################################################
if which rbenv > /dev/null; then
    eval "$(rbenv init -)";
fi
export PATH=$PATH:$HOME/.rbenv/bin:


#################################################
# golang
#################################################
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin:$GOPATH/bin


#################################################
# Perl
#################################################
export PERL_LOCAL_LIB_ROOT="/Users/`whoami`/perl5:$PERL_LOCAL_LIB_ROOT";
export PERL_MB_OPT="--install_base "/Users/`whoami`/perl5"";
export PERL_MM_OPT="INSTALL_BASE=/Users/`whoami`/perl5";
export PERL5LIB="/Users/`whoami`/perl5/lib/perl5:$PERL5LIB";
export PATH="/Users/`whoami`/perl5/bin:$PATH";

#################################################
# nvm
#################################################
if [[ -s ~/.nvm/nvm.sh ]] ; then source ~/.nvm/nvm.sh ; fi

# Finish
echo "zshrc load completed!"


### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
eval $(thefuck --alias)
