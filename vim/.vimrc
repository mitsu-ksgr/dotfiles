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
set textwidth=0                     " disable auto word wrapping.
syntax on
filetype plugin indent on


"
" Appearance
"
set number
set visualbell
set showmatch
set wildmode=list:longest

if (exists('+colorcolumn'))
    set colorcolumn=80
    highlight ColorColumn ctermbg=9
endif


"
" Status line
"
set statusline=%f                       " file name
set statusline+=%m                      " change status
set statusline+=%r                      " readonly flag
set statusline+=%h                      " help buffer flag
set statusline+=%w                      " preview window flag

set statusline+=%=  " --- right-align following items ---
set statusline+=[%{&fileencoding}]      " file encoding
set statusline+=[%2c:%4l/%L]            " column, line, total-line
set laststatus=2


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
" Remove trailing whitespace
"
autocmd BufWritePre * :%s/\s\+$//ge


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
nnoremap H 10h
nnoremap J 10j
nnoremap K 10k
nnoremap L 10l
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
nnoremap s+ <C-w>+              " Resize view
nnoremap s- <C-w>-              " s+ / s- ... resize height
nnoremap s> <C-w>>              " s> / s< ... resize width
nnoremap s< <C-w><
nnoremap st :<C-u>tabnew<CR>    " New Tab
nnoremap tp gT                  " Move prev tab
nnoremap tn gt                  " Move next tab


"
" vim-plug
"
call plug#begin('~/.vim/plugged')
    Plug 'vim-jp/vimdoc-ja'
    Plug 'airblade/vim-gitgutter'
    Plug 'Shougo/vimproc.vim', {'do' : 'make'}
    Plug 'Shougo/unite.vim'     " depends on vimproc
    Plug 'scrooloose/nerdtree'

    " lsp
    Plug 'prabirshrestha/async.vim'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
    Plug 'natebosch/vim-lsc'

    " Color
    Plug 'cocopon/iceberg.vim'
    Plug 'luochen1990/rainbow'

    " Syntax Highlight
    Plug 'chr4/nginx.vim'
    Plug 'posva/vim-vue'
    Plug 'slim-template/vim-slim'
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()


"
" Plug airblade/vim-gitgutter
"
set updatetime=200          " Update interval

" sign column always on
if exists('&signcolumn')
  set signcolumn=yes
else
  let g:gitgutter_sign_column_always = 1
endif

" Refresh all visible buffers
nnoremap <silent> gr :<C-u>GitGutterAll<CR>


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
" Plug Shougo/unite
" https://github.com/Shougo/unite.vim
"
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1

if executable('hw')
    " Use hw (highway)
    " https://github.com/tkengo/highway
    let g:unite_source_grep_command = 'hw'
    let g:unite_source_grep_default_opts = '--no-group --no-color -a -i'
    let g:unite_source_grep_recursive_opt = ''
    let g:unite_source_rec_async_command='hw --no-color --no-group -l ""'
elseif executable('ag')
    " Use ag (the silver searcher)
    " https://github.com/ggreer/the_silver_searcher
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts =
                \ '-i --vimgrep --hidden --ignore ' .
                \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
    let g:unite_source_grep_recursive_opt = ''
    let g:unite_source_rec_async_command='ag --nocolor --nogroup -g ""'
elseif executable('pt')
    " Use pt (the platinum searcher)
    " https://github.com/monochromegane/the_platinum_searcher
    let g:unite_source_grep_command = 'pt'
    let g:unite_source_grep_default_opts = '--nogroup --nocolor'
    let g:unite_source_grep_recursive_opt = ''
    let g:unite_source_rec_async_command='ag --nocolor --nogroup -l ""'
endif

" search (g:word|G:current word) from current dir files.
nnoremap <silent> <space>g :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
nnoremap <silent> <space>G :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W><CR>

" search (s:word|S:current word) from current buffer.
nnoremap <silent> <space>s :<C-u>Unite grep:% -buffer-name=search-buffer<CR>
nnoremap <silent> <space>S :<C-u>Unite grep:% -buffer-name=search-buffer<CR><C-R><C-W><CR>

" Resumes the search-buffer that opened previously.
nnoremap <silent> <space>r :<C-u>UniteResume search-buffer<CR>

" Open files
nnoremap <silent> <space><CR> :<C-u>Unite file buffer<CR>
nnoremap <silent> <space>f :<C-u>Unite file_rec<CR>


"
" NERDTree
" https://github.com/scrooloose/nerdtree
"
let NERDTreeQuitOnOpen=1
let NERDTreeShowHidden=1
nnoremap <silent> <space><space> :NERDTreeToggle<CR>

" exit vim if the only window left open is a NERDTree.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


"
" Color scheme
"
set background=dark
try
    colorscheme iceberg
catch
endtry


"
" LSP
" https://github.com/prabirshrestha/vim-lsp
" https://github.com/prabirshrestha/vim-lsp/wiki/Servers-Go
"
let g:lsp_async_completion = 1
let g:lsp_diagnostics_echo_cursor = 1
if executable('gopls')
    augroup vimrc-lsp
        autocmd!
        au User lsp_setup call lsp#register_server({
            \ 'name': 'gopls',
            \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
            \ 'whitelist': ['go'],
            \ })
        autocmd BufWritePre *.go LspDocumentFormatSync
    augroup END
endif


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

