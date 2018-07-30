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
" Key Remap
"
nnoremap s <Nop>
nnoremap ss :<C-u>sp<CR>        " Split Horizontal
nnoremap sv :<C-u>vs<CR>        " Split Vertical
nnoremap sh <C-w>h              " Move to split view
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sH <C-w>H              " Move view
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap st :<C-u>tabnew<CR>    " New Tab
nnoremap tp gT                  " Move prev tab
nnoremap tn gt                  " Move next tab


"
" vim-plug
"
call plug#begin('~/.vim/plugged')
    Plug 'vim-jp/vimdoc-ja'
    Plug 'cocopon/iceberg.vim'
    Plug 'airblade/vim-gitgutter'
    Plug 'luochen1990/rainbow'
    Plug 'posva/vim-vue'
call plug#end()


"
" Plug airblade/vim-gitgutter
"
set updatetime=250          " Update interval


"
" Plug luochen1990/rainbow
" https://github.com/luochen1990/rainbow
"
let g:rainbow_active = 1 
let g:rainbow_conf = {
\   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\   'separately': {
\       '*': {},
\       'cpp': {
\           'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold', 'start=/</ end=/>/ fold'],
\       },
\       'vim': {
\           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
\       },
\       'html': {
\           'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\       },
\       'css': 0,
\   }
\}


"
" Color scheme
"
set background=dark
try
    colorscheme iceberg
catch
endtry


"
" Load settings for each location.
" Ref: Hack #112: 場所ごとに設定を用意する - http://vim-jp.org/vim-users-jp/2009/12/27/Hack-112.html
"
augroup vimrc-local
    autocmd!
    autocmd BufNewFile,BufReadPre * call s:vimrc_local(expand('<afile>:p:h'))
augroup END
function! s:vimrc_local(loc)
    let files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
    for i in reverse(filter(files, 'filereadable(v:val)'))
        source `=i`
    endfor
endfunction

