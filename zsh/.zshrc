#******************************************************************************
#
#   .zshrc
#
#******************************************************************************
DOTPATH=${HOME}/dotfiles


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
setopt noclobber                # リダイレクトによる上書きを抑制する
unsetopt auto_menu              # タブによるファイルの順番切り替えを行わない

# completion
autoload -Uz compinit           # 補完機能を有効にする
compinit
autoload -Uz colors; colors     # 補完でカラーを使用
autoload -Uz is-at-least        # zshバージョン比較用
autoload -Uz add-zsh-hook       # zshフック




#------------------------------------------------------------------------------
#
#   History
#
#------------------------------------------------------------------------------
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




#------------------------------------------------------------------------------
#
#   VCS
#
#------------------------------------------------------------------------------
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




#------------------------------------------------------------------------------
#
#   Prompt
#
#------------------------------------------------------------------------------
# LS_COLORS
export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

OK="(*ﾟーﾟ)"
NG="(ﾉд<)"

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
PROMPT="[%*-%m]%# "
RPROMPT="[%F{magenta}%C%f]${vcs_info_msg_0_}"




#------------------------------------------------------------------------------
#
#   Functions
#
#------------------------------------------------------------------------------
#
# Peco
#
function peco-history-selection() {
    BUFFER=$(history -n 1 | tac | awk '!a[$0]++' | peco)
    CURSOR=$#buffer
    zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

function peco-ghq-cd() {
    local selected_dir=$(ghq list | peco --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        selected_dir="$(ghq root)/$selected_dir"
        BUFFER="cd ${selected_dir}"
    fi
    zle clean-screen
}
zle -N peco-ghq-cd
bindkey '^F' peco-ghq-cd


#
# AWS Helper
#
function aws-cfn-validate-template() {
    aws cloudformation validate-template --template-body file://$1
}
function aws-cfn-create() {
    aws cloudformation create-stack --stack-name $1 --template-body file://$2 ${@:3}
}
function aws-cfn-delete() {
    aws cloudformation delete-stack --stack-name $1
}


#------------------------------------------------------------------------------
#
#   Environment Dependents
#
#------------------------------------------------------------------------------
#
# Environment variables
#
if [ -f "${DOTPATH}/env/.env" ]; then
    source "${DOTPATH}/env/.env"
fi


#
# Comand aliases
#
if [ -f "${DOTPATH}/bash/.bash_aliases" ]; then
    source "${DOTPATH}/bash/.bash_aliases"
fi



# Finish
unset DOTPATH
echo "zshrc load completed!"

