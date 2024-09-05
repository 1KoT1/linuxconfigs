:set number relativenumber
" Подсветить результаты поиска.
set hlsearch
" Убрать подсветку по нажатию <esc>.
" У конфига nnoremap <esc> :noh<return><esc> есть побочный эфект --
" сразу после открытия файла запускается режим ЗАМЕНА. Поэтому
" закоментарил конфиг.
"nnoremap <esc> :noh<return><esc>

set incsearch

let mapleader = ","

if has("syntax")
  syntax on
endif

" Всегда показывать строку состояния
let laststatus = 2

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
highlight DiffAdd     ctermbg=22
highlight DiffChange  ctermbg=22
highlight DiffDelete  ctermbg=22
highlight clear DiffText
highlight DiffText    ctermbg=52

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

call plug#begin()

	Plug 'lyokha/vim-xkbswitch'
	" You should build and install https://github.com/grwlf/xkb-switch
	
	Plug 'ycm-core/YouCompleteMe'
	Plug 'skywind3000/asyncrun.vim'
call plug#end()

autocmd BufRead,BufNewFile *.md setlocal spell spelllang=ru_yo,en_us
autocmd BufRead,BufNewFile *.txt setlocal spell spelllang=ru_yo,en_us
autocmd BufRead,BufNewFile CMakeLists.txt setlocal spell!
autocmd FileType gitcommit setlocal spell spelllang=ru_yo,en_us
" Вкл/выкл проверку орфографии:
" :set spell/spell!
" ]s - Следующее слово с ошибкой;
" [s - Предыдущее слово с ошибкой;
" ]S - (Обратите внимание на заглавную букву «S») — похоже на «] s», найти, но
" останавливаться только на плохих словах, а не на редкие слова или слова для
" другого региона.
" [S - по аналогии с «[s», но поиск в обратном направлении.
" z= - отобразить список замен;
" zg - Добавить в словарь;
" zw - Убрать из словаря;
" zG - Игнорировать слово;

" Включаю поддержку волнистого подчёркивания (undercurl)
let &t_Cs = "\e[4:3m"

highlight clear SpellBad
highlight SpellBad term=reverse cterm=undercurl ctermul=Red gui=undercurl guisp=Red
highlight clear SpellCap
highlight SpellCap term=reverse cterm=undercurl ctermul=Blue gui=undercurl guisp=Blue
highlight clear SpellRare
highlight SpellRare term=reverse cterm=undercurl ctermul=Magenta gui=undercurl guisp=Magenta
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=undercurl ctermul=Cyan gui=undercurl guisp=Cyan






" Включаю удобную переключалку раскладки клавиатуры.
let g:XkbSwitchEnabled = 1


autocmd filetype python map <F2> :YcmCompleter GoTo<CR>
autocmd filetype python nmap <leader>D <plug>(YCMHover)

" Auto close annoying windows on complete
let g:ycm_autoclose_preview_window_after_completion = 1

" Режим автодополнения команд
set wildmenu
set wildmode=longest:full,full
set wildoptions=pum

" Подключать .vimrc и каталога в которм запущен vim.
" secure для защиты, т.к. vim будет подключать .vimrc из любой директории, из
" которой вы его запустите.
set exrc
set secure
