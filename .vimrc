"====================================================================
"   vim 設定
set noswapfile          " スワップファイルを使用しない

" 最後のカーソル位置を復元する
if has("autocmd")
    autocmd BufReadPost *
    \ if line ("'\"") > 0 && line ("'\"") <= line ("$") |
    \   exe "normal! g'\"" |
    \ endif
endif


"====================================================================
"   NeoBundle   : https://github.com/Shougo/neobundle.vim
set nocompatible
filetype off

if has('vim_starting')
    set nocompatible    " Be iMproved
    set runtimepath+=~/.vim/bundle/neobundle.vim
endif
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

"------------------------------------------------
"   Add Plugins.
NeoBundle 'Shougo/unite.vim'
NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'thinca/vim-quickrun'         " Instant run.
NeoBundle 'nanotech/jellybeans.vim'     " Color Scheme
NeoBundle 'tomasr/molokai'              " Color Scheme
NeoBundle 'tyru/caw.vim'                " Comment Out


"   Plugin Setting
" caw.vim
nmap <C-K> <Plug>(caw:i:toggle)
vmap <C-K> <Plug>(caw:i:toggle)

"------------------------------------------------

call neobundle#end()
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck


"====================================================================
"   表示設定
set number              " 行番号を表示
set title               " 編集中のファイル名を表示
set showmatch           " 対応括弧の強調表示
set matchtime=5         " showmatchのハイライト時間[秒]
set ruler               " 画面右下にカーソル位置を表示
set cursorline          " カーソル行をハイライト
set colorcolumn=80      " 80カラムにルーラを表示
set laststatus=2        " 画面下部のステータス行を常に２行表示
set nowrap              " 右端で折り返さない
set cmdheight=2         " コマンドラインに使用される画面上の行数
"set virtualedit=all     " 文字が無い箇所でのカーソル移動を許可

" 特殊文字の見える化
"set list
"set listchars=tab:.\ \,trail:_,nbsp:%,extends:$,precedes:$

" 全角スペースをハイライト表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=white
match ZenkakuSpace /　/


"====================================================================
"   編集設定
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

" インサートモードでもhjklで移動
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

" 保存時に行末スペースを削除
autocmd BufWritePre * :%s/\s\+$//e


"====================================================================
"   検索設定
set ignorecase          " 大文字/小文字の区別をしない
set smartcase           " 大文字が含まれる検索時は区別をする
set wrapscan            " 最後まで検索したら最初に戻る
set hlsearch            " 検索単語を強調表示する


"====================================================================
"   Color Scheme
colorscheme jellybeans
if &term =~ "xterm-256color" || "screen-256color"
    set t_Co=256
    set t_Sf=[3%dm
    set t_Sb=[4%dm
elseif &term =~ "xterm-color"
    set t_Co=8
    set t_Sf=[3%dm
    set t_Sb=[4%dm
endif

syntax enable
syntax on
hi PmenuSel cterm=reverse ctermfg=33 ctermbg=222
"set background=dark








