" Force-load our autoload overrides on top of voldikss/vim-translator's own
" copies. Vim's autoload lazily sources only the first matching file for a
" given function name, so without this the copies under after/autoload/
" would never actually be used.
runtime! autoload/translator.vim
runtime! autoload/translator/action.vim
