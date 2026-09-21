" ============================================================================
" Override for voldikss/vim-translator's translator#action#window()
"
" `trans` (translate-shell) sometimes prepends a junk block about the
" target language code (e.g. ":ru", "RU", "сокращение", "Британская лига
" регбистов") before the actual dictionary entry. That junk always ends
" right before the first line that is exactly the queried word/phrase, and
" everything from there on matches plain `trans <word>` output. Drop the
" junk prefix, if any, before rendering.
"
" Our own script/translator.py replacement (see after/autoload/translator.vim)
" encodes each explain line's original indentation (word class -> sense ->
" synonyms) as leading '\t' characters instead of stripping it. Turn those
" back into indentation here so the popup shows the same tree `trans` shows
" in a terminal, rather than a flat bullet list.
"
" Loaded explicitly (see after/plugin/translator_fix.vim) via `runtime!`,
" since Vim's autoload only sources the first matching file for a given
" function name and would otherwise keep using the plugin's own copy.
" ============================================================================

function! s:drop_leading_junk(text, explains) abort
  let idx = index(a:explains, a:text)
  if idx <= 0
    return a:explains
  endif
  return a:explains[idx:]
endfunction

" Splits off leading '\t' depth markers, returns [depth, rest-of-line]
function! s:explain_depth(expl) abort
  let depth = 0
  let rest = a:expl
  while rest[0:0] ==# "\t"
    let depth += 1
    let rest = rest[1:]
  endwhile
  return [depth, rest]
endfunction

function! translator#action#window(translations) abort
  let marker = '• '
  let content = []
  if len(a:translations['text']) > 30
    let text = a:translations['text'][:30] . '...'
  else
    let text = a:translations['text']
  endif
  call add(content, printf('⟦ %s ⟧', text))

  for t in a:translations['results']
    if empty(t.paraphrase) && empty(t.explains)
      continue
    endif
    call add(content, '')
    call add(content, printf('─── %s ───', t.engine))
    if !empty(t.phonetic)
      let phonetic = marker . printf('[%s]', t.phonetic)
      call add(content, phonetic)
    endif
    if !empty(t.paraphrase)
      let paraphrase = marker . t['paraphrase']
      call add(content, paraphrase)
    endif
    if !empty(t.explains)
      let explains_list = s:drop_leading_junk(a:translations['text'], t.explains)
      for expl in explains_list
        let [depth, rest] = s:explain_depth(expl)
        let rest = translator#util#safe_trim(rest)
        if !empty(rest)
          let explains = repeat('  ', depth) . marker . rest
          call add(content, explains)
        endif
      endfor
    endif
  endfor
  call translator#logger#log(content)
  call translator#window#open(content)
endfunction
