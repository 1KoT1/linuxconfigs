:set number relativenumber
" Подсветить результаты поиска.
set hlsearch
" Убрать подсветку по нажатию <esc>.
" У конфига nnoremap <esc> :noh<return><esc> есть побочный эфект --
" сразу после открытия файла запускается режим ЗАМЕНА. Поэтому
" закоментарил конфиг.
"nnoremap <esc> :noh<return><esc>

set incsearch

if has("syntax")
  syntax on
endif

" Схема цветов для vimdiff
"   Префикс ctrem для консоли, префикс gui для графики
"   cterm - sets the style
"   ctermfg - set the text color
"   ctermbg - set the highlighting
"   gui - sets the style
"   guifg - set the text color
"   guibg - set the highlighting
"   DiffAdd - line was added
"   DiffDelete - line was removed
"   DiffChange - part of the line was changed (highlights the whole line)
"   DiffText - the exact part of the line that changed
"   Выбрать цвета для кронсоли: https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim?file=Xterm-color-table.png
"   Для gui обычная RGB нотация, к примеру #ff8080
highlight DiffAdd     cterm=bold ctermbg=43
highlight DiffChange  cterm=bold ctermbg=43
highlight DiffDelete  cterm=bold ctermbg=43
"highlight DiffText    cterm=bold ctermbg=43

set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan

if empty(glob('~/.vim/autoload/plug.vim'))
	silent execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Отступы
set tabstop=2
set shiftwidth=2
set smarttab
set smartindent

" Отступы C/C++
autocmd filetype c,cpp set cindent
autocmd filetype c,cpp set cinoptions=>s,:0,l1,g0,(0,Ws

" Клавиши для коментариев
autocmd filetype c,cpp vmap cc :norm i//<CR>
autocmd filetype c,cpp vmap uc :norm d2l<CR>




"     0: blinking block
"     1: blinking block (default)
"     2: steady block
"     3: blinking underline
"     4: steady underline
"     5: blinking bar (xterm)
"     6: steady bar (xterm)
"let &t_SI = "\<Esc>]50;CursorShape=4\x7"
"let &t_SR = "\<Esc>]50;CursorShape=2\x7"
"let &t_EI = "\<Esc>]50;CursorShape=2\x7"
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[2 q"
let &t_EI = "\<Esc>[2 q"

" Подключать .vimrc и каталога в которм запущен vim.
" secure для защиты, т.к. vim будет подключать .vimrc из любой директории, из
" которой вы его запустите.
set exrc
set secure
