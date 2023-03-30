function! ddc#util#print_error(string, name = 'ddc') abort
  echohl Error
  echomsg printf('[%s] %s', a:name,
        \ type(a:string) ==# v:t_string ? a:string : string(a:string))
  echohl None
endfunction

function! ddc#util#get_text(mode) abort
  return a:mode ==# 'c' ? getcmdline() :
        \ a:mode ==# 't' && !has('nvim') ? term_getline('', '.')
        \ : getline('.')
endfunction
function! ddc#util#get_input(event) abort
  const mode = a:event ==# 'InsertEnter' ? 'i' : mode()
  const is_insert = (mode ==# 'i') || (mode ==# 't')
  const text = ddc#util#get_text(mode)
  const col = mode() ==# 't' && !has('nvim') ?
        \ term_getcursor(bufnr('%'))[1] :
        \ mode() ==# 'c' ? getcmdpos() : col('.')
  const pos = mode ==# 'c' ? col - 1 :
        \ is_insert ? col - 1 : col
  const input = pos >= len(text) ?
        \     text :
        \     text->matchstr(
        \         '^.*\%' .. (is_insert || col <= 0 ? col : col - 1)
        \         .. 'c' .. (is_insert ? '' : '.'))

  return input
endfunction
function! ddc#util#get_next_input(event) abort
  const text = ddc#util#get_text(mode())
  return text[len(ddc#util#get_input(a:event)) :]
endfunction

function! ddc#util#benchmark(msg = '') abort
  let msg = a:msg
  if msg !=# ''
    let msg ..= ' '
  endif
  const diff = g:ddc#_started->reltime()->reltimefloat()
  call ddc#util#print_error(printf('%s%s: Took %f seconds.',
        \ msg, '<sfile>'->expand(), diff))
endfunction
