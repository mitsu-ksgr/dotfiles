#!/bin/sh
#
# Claude Code の状態を tmux の pane オプション @cc_icon に書く hook
#
# usage: cc-state.sh <prompt|work|ask|stop|error|clear>   (stdin: hook の JSON)
#
#   prompt  プロンプトを送った。スラッシュコマンド名を @cc_cmd に覚える
#   work    作業に戻った (許可や質問のあと)
#   ask     許可・質問の待ち
#   stop    返答済み。@cc_cmd が対応表にあればその絵文字にする
#   error   エラーで止まった
#   clear   表示を消す
#
# 対応表: $CLAUDE_PROJECT_DIR とその親にある .claude/cc-state.conf (最初に見つかったもの)
#   <コマンド名> <絵文字>   例: catch-up ☀️
#
[ -n "$TMUX_PANE" ] || exit 0

ICON_WORK="🐝"
ICON_ASK="❓"
ICON_STOP="🌷"
ICON_ERROR="🔥"

input=$(cat)
pane="$TMUX_PANE"

case "$1" in
  prompt)
    cmd=$(printf '%s' "$input" | jq -r '.prompt // ""' | sed -n '1s|^/\([A-Za-z0-9:_-]*\).*|\1|p')
    tmux set -p -t "$pane" @cc_cmd "$cmd"
    icon=$ICON_WORK
    ;;
  work)
    icon=$ICON_WORK
    ;;
  ask)
    icon=$ICON_ASK
    ;;
  stop)
    icon=
    cmd=$(tmux show -pv -t "$pane" @cc_cmd 2>/dev/null)
    # 起動したディレクトリから親へたどり、最初に見つかった対応表を使う
    conf=
    dir="$CLAUDE_PROJECT_DIR"
    while [ -n "$dir" ]; do
      if [ -f "$dir/.claude/cc-state.conf" ]; then
        conf="$dir/.claude/cc-state.conf"
        break
      fi
      [ "$dir" = "/" ] && break
      dir=$(dirname "$dir")
    done
    if [ -n "$cmd" ] && [ -n "$conf" ]; then
      icon=$(awk -v c="$cmd" '$1 == c { print $2; exit }' "$conf")
    fi
    [ -n "$icon" ] || icon=$ICON_STOP
    ;;
  error)
    icon=$ICON_ERROR
    ;;
  clear)
    tmux set -pu -t "$pane" @cc_icon
    tmux set -pu -t "$pane" @cc_cmd
    exit 0
    ;;
  *)
    exit 0
    ;;
esac

tmux set -p -t "$pane" @cc_icon "$icon"
