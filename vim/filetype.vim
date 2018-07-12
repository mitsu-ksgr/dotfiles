"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"   filetype.vim
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup filetypedetect
    au BufNewFile,BufRead *.rb      setfiletype ruby
    au BufNewFile,BufRead *.html    setfiletype html
augroup END

