"====================================================================
"   vim 設定
set noswapfile          " スワップファイルを使用しない
set encoding=utf-8      " 内部文字コードをUTF-8に設定する

" 最後のカーソル位置を復元する
if has("autocmd")
    autocmd BufReadPost *
    \ if line ("'\"") > 0 && line ("'\"") <= line ("$") |
    \   exe "normal! g'\"" |
    \ endif
endif

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
set list
"set listchars=tab:.\ \,trail:_,nbsp:%,extends:$,precedes:$
"set listchars=tab:.\ \,trail:-,nbsp:%,eol:
set listchars=tab:.\ \,trail:_,nbsp:%,extends:$,precedes:$


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

" セミコロンでもコマンドに入れるようにする
noremap ; :

" インサートモードでもhjklで移動
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

" Shift時に多めに移動する
nnoremap <silent> J 10j
nnoremap <silent> K 10k
nnoremap <silent> H 10h
nnoremap <silent> L 10l
vnoremap J 10j
vnoremap K 10k
vnoremap H 10h
vnoremap L 10l

" 保存時に行末スペースを削除
autocmd BufWritePre * :%s/\s\+$//e


"====================================================================
"   検索設定
set ignorecase          " 大文字/小文字の区別をしない
set smartcase           " 大文字が含まれる検索時は区別をする
set wrapscan            " 最後まで検索したら最初に戻る
set hlsearch            " 検索単語を強調表示する


"====================================================================
"  netrw.vim
set splitright
let g:netrw_liststyle = 3   " Use TreeView.
let g:netrw_altv = 1        " 'v'でファイルを開いたら、右側に表示する
let g:netrw_alto = 1        " 'o'でファイルを開いたら、下に表示


"====================================================================
"   Golang
" for golang {{{
set rtp+=$GOROOT/misc/vim
exe "set rtp+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim")

set path+=$GOPATH/src/**
let g:gofmt_command = 'goimports'
au BufWritePre *.go Fmt
au BufNewFile,BufRead *.go set sw=4 noexpandtab ts=4 completeopt=menu,preview
au FileType go compiler go

autocmd FileType go :highlight goErr cterm=bold ctermfg=214
autocmd FileType go :match goErr /\<err\>/

" }}}


"====================================================================
"   Color Scheme
"colorscheme jellybeans
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


"====================================================================
"   Window Control
nnoremap s <Nop>
nnoremap ss <C-w>w
nnoremap sh <C-w>h
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
"call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
"call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
"`call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>+')
"call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>-')
"call submode#map('winsize', 'n', '', '>', '<C-w>>')
"call submode#map('winsize', 'n', '', '<', '<C-w><')
"call submode#map('winsize', 'n', '', '+', '<C-w>+')
"call submode#map('winsize', 'n', '', '-', '<C-w>-')


