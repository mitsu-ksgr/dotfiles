"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"   filetype.vim
"
"   https://vim-jp.org/vimdoc-ja/filetype.html
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect
    au!
    au BufNewFile,BufRead *.rb      setfiletype ruby
    au BufNewFile,BufRead *.yaml    setfiletype yaml
    au BufNewFile,BufRead *.yml     setfiletype yaml
    au BufNewFile,BufRead *.js      setfiletype javascript
    au BufNewFile,BufRead *.cjs     setfiletype javascript
    au BufNewFile,BufRead *.html    setfiletype html
    au BufNewFile,BufRead *.json    setfiletype json
    au BufNewFile,BufRead *.sh      setfiletype sh
    au BufNewFile,BufRead *.toml    setfiletype toml
    au BufNewFile,BufRead *.md      setfiletype markdown
augroup END

