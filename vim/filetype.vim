"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"   filetype.vim
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup filetypedetect
    au BufNewFile,BufRead *.rb      setfiletype ruby
    au BufNewFile,BufRead *.js      setfiletype js
    au BufNewFile,BufRead *.html    setfiletype html
    au BufNewFile,BufRead *.json    setfiletype json
augroup END

