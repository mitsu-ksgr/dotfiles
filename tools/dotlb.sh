#!/usr/bin/env bash
#
# dot linebreak
#
# 行の終わりが `.` になるように変換する.
#
# - 1. 改行をスペース ` ` に変換
# - 2. `. ` を `.\n` に変換
#

sed ':a;N;$!ba;s/\n/ /g' |\
sed 's/\. /\.\
/g'

