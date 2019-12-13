"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"   filetype.vim
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup filetypedetect
    au!
    au BufNewFile,BufRead *.rb      setfiletype ruby
    au BufNewFile,BufRead *.yaml    setfiletype yaml
    au BufNewFile,BufRead *.yml     setfiletype yaml
    au BufNewFile,BufRead *.js      setfiletype javascript
    au BufNewFile,BufRead *.html    setfiletype html
    au BufNewFile,BufRead *.json    setfiletype json
    au BufNewFile,BufRead *.sh      setfiletype sh
augroup END

