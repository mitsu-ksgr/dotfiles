" created by Mitsuaki on 2013/12/22

"---------- 表示設定 ----------"
set number              " 行番号を表示
set title               " 編集中のファイル名を表示
set showmatch           " 対応括弧の強調表示
set matchtime=5         " showmatchのハイライト時間[秒]
set ruler               " 画面右下にカーソル位置を表示
set cursorline          " カーソル行をハイライト
set colorcolumn=80      " 80カラムにルーラを表示
set laststatus=2        " 画面下部のステータス行を表示
set nowrap              " 右端で折り返さない
syntax on               " シンタックスハイライトを有効
                        " 全角スペースをハイライト表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=white
match ZenkakuSpace /　/
colorscheme darkblue    " カラースキームを設定
"set virtualedit=all     " 文字が無い箇所でのカーソル移動を許可

"---------- 編集設定 ----------"
set tabstop=4           " <Tab>文字コードを展開する際の空白文字の数
set shiftwidth=4        " 自動的に挿入/削除される空白文字の数
set softtabstop=4       " キーボードで<Tab>を入力した際に挿入される空白文字の数
set autoindent          " オートインデント
set smartindent         " スマートインデント
set cindent             " Cインデント
set expandtab           " タブの代わりにスペースを挿入
set whichwrap=b,s,h,l,<,>,[,]   " カーソルがBOLやEOLに達しても止めずに動かす
set textwidth=0         " 自動改行を抑制
autocmd BufWritePre * :%s/\s\+$//e  " 保存時に行末のスペースを自動で削除する

"---------- 検索設定 ----------"
set ignorecase          " 大文字/小文字の区別をしない
set smartcase           " 大文字が含まれる検索時は区別をする
set wrapscan            " 最後まで検索したら最初に戻る


