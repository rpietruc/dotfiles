syntax enable
color desert

filetype plugin indent on
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

"set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after

" Maps ctrl-c to find functions calling the function
nnoremap <F2> :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <F3> :cs find f <C-R>=expand("<cword>")<CR><CR>
nnoremap <F4> :A<CR><CR>

let Tlist_Compact_Format = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Close_On_Select = 1
nnoremap <C-l> :TlistToggle<CR>

au FileType c,cpp set expandtab
au FileType c set sw=2 ts=2
au FileType cpp set sw=4 ts=4

" git log requirement
set textwidth=72

set nocp
filetype plugin on
map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

