#******************************************************************************
#
#   .zshenv
#
#******************************************************************************

#
# 基本的にここでは何も定義しないこと。
#
# .zshenv は非インタラクティブシェルでの実行時にもsourceされる。
# そのため、 .zshenv に環境固有の設定を定義してしまうと、
# その環境だけシェルスクリプトの挙動が変わってしまう可能性があり、
# 結果としてスクリプトの汎用性を損なってしまう原因につながる。
#
# 環境変数は dotfiles/env/env 或いは dotfiles/env/env.{dist_name} に定義する。
#

