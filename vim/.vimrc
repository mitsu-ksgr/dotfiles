"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"   .vimrc
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"
" File Encoding
"
set fenc=utf-8
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8


set nobackup
set noswapfile
set autoread
set hidden
set showcmd
set whichwrap=h,l,b,s,<,>,[,]
set nowrap
set backspace=indent,eol,start
syntax on
filetype plugin indent on


"
" Appearance
"
set number
set visualbell
set showmatch
set laststatus=2
set wildmode=list:longest

if (exists('+colorcolumn'))
    set colorcolumn=80
    highlight ColorColumn ctermbg=9
endif



"
" Indent
"
set smartindent
set expandtab
set autoindent
set tabstop=4
set shiftwidth=4
set softtabstop=4


"
" Hidden Characters
"
set list
"set listchars=tab:»-,trail:-,eol:↲,extends:«,nbsp:.
set listchars=tab:»-,trail:･,nbsp:⍽,extends:»,precedes:«
autocmd ColorScheme * highlight ZenkakuSpace cterm=underline ctermbg=yellow
autocmd VimEnter * match ZenkakuSpace /　/


"
" Search
"
set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>


"
" Cursor config
" Ref: https://qiita.com/Linda_pp/items/9e0c94eb82b18071db34
"
if has("vim_starting")
    let &t_SI .= "\e[5 q"   " Insert Mode
    let &t_EI .= "\e[5 q"   " Normal Mode
    let &t_SR .= "\e[5 q"   " Replace Mode
endif


"
" Restore last cursor position
"
if has("autocmd")
    autocmd BufReadPost *
    \   if line ("'\"") > 0 && line ("'\"") <= line ("$") |
    \       exe "normal! g'\"" |
    \   endif
endif


"
" Fcitx - Auto deactivate Fcitx when leave from insert-mode.
" Note: 多分vim8.1以降じゃないと動かない雰囲気
" Ref: Vimからfcitxを使う - https://qiita.com/sgur/items/aa443bc2aed6fe0eb138
"
set ttimeoutlen=150
set iminsert=0
set imsearch=0
set imcmdline
set imactivatefunc=ImActivate
function! ImActivate(active)
    if a:active
        "call system('fcitx-remote -o')
    else
        call system('fcitx-remote -c')
    endif
endfunction
set imstatusfunc=ImStatus
function! ImStatus()
    return system('fcitx-remote')[0] is# '2'
endfunction




"
" vim-plug
"
call plug#begin('~/.vim/plugged')
    Plug 'vim-jp/vimdoc-ja'
    Plug 'cocopon/iceberg.vim'
call plug#end()


"
" Color scheme
"
set background=dark
try
    colorscheme iceberg
catch
endtry

