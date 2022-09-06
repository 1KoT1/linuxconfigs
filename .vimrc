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
