"=============================================================================
" FILE: everything.vim
" Last Modified: 2013-06-28
" Description: everything のコマンドラインインタフェース(es.exe)を利用し、
"              unite から everything を利用するための source
" Requirement: everything.exe
"            : es.exe in $PATH
" Notes: ディレクトリ等がジャンクションだったりすると everything が検索してくれない
"=============================================================================

" Variables  "{{{
call unite#util#set_default('g:unite_source_everything_limit', 100)
" search entire path
call unite#util#set_default('g:unite_source_everything_full_path_search', 0)
" use POSIX regexp
call unite#util#set_default('g:unite_source_everything_posix_regexp_search', 0)
" sort result by full path string
call unite#util#set_default('g:unite_source_everything_sort_by_full_path', 0)
" case sensitive search
call unite#util#set_default('g:unite_source_everything_case_sensitive_search', 0)
" es.exe cmd path
call unite#util#set_default('g:unite_source_everything_cmd_path', 'es.exe')
"}}}

let s:available_es = executable(g:unite_source_everything_cmd_path)

let s:source =
      \ { 'name'                    : 'everything'
      \ , 'is_volatile'             : 1
      \ , 'max_candidates'          : 30
      \ , 'required_pattern_length' : 3
      \ }

let s:source_async =
      \ { 'name'                    : 'everything/async'
      \ , 'max_candidates'          : 30
      \ , 'required_pattern_length' : 1
      \ , 'hooks' : {}
      \ }

function! unite#sources#everything#define() "{{{
  let _ = []
  if unite#util#is_win() && s:available_es
    call add(_, s:source)
    if unite#util#has_vimproc()
      call add(_, s:source_async)
    endif
  endif
  return _
endfunction "}}}

function! s:source.change_candidates(args, context) "{{{
  let l:input = substitute(a:context.input, '^\a\+:\zs\*/', '/', '')
  " exec es.exe to list candidates
  let l:res = unite#util#substitute_path_separator(
        \ unite#util#system(g:unite_source_everything_cmd_path
        \ . ' -n ' . g:unite_source_everything_limit
        \ . (g:unite_source_everything_case_sensitive_search > 0 ? ' -i' : '')
        \ . (g:unite_source_everything_full_path_search > 0 ? ' -p' : '')
        \ . (g:unite_source_everything_posix_regexp_search > 0 ? ' -r' : '')
        \ . (g:unite_source_everything_sort_by_full_path > 0 ? ' -s' : '')
        \ . ' ' . l:input))
  let l:candidates = split(l:res, '\r\n\|\r\|\n')

  " if g:unite_source_file_ignore_pattern is set, use it to filter pattern
  if exists('g:unite_source_file_ignore_pattern') && g:unite_source_file_ignore_pattern != ''
    call filter(l:candidates, 'v:val !~ ' . string(g:unite_source_file_ignore_pattern))
  endif

  return s:build_candidates(candidates)
endfunction "}}}

function! s:source_async.hooks.on_close(args, context) "{{{
  while !a:context.source__subproc.stdout.eof
    call a:context.source__subproc.stdout.read()
  endwhile
  call a:context.source__subproc.kill(9)
endfunction "}}}

function! s:source_async.async_gather_candidates(args, context) "{{{
  let input = substitute(a:context.input, '^\a\+:\zs\*/', '/', '')

  if !has_key(a:context, 'source__last_input') || a:context.source__last_input != input
    let a:context.source__last_input = input
    return []
  endif

  if !has_key(a:context, 'source__term') ||
        \ has_key(a:context, 'source__term') && a:context.source__term != a:context.input
    let a:context.source__term = input

    if has_key(a:context, 'source__subproc')
      call vimproc#kill(a:context.source__subproc.pid, 9)
      call remove(a:context, 'source__subproc')
      call unite#force_redraw()
    endif

    echomsg 'QUERY' input
    let a:context.source__subproc =
          \ vimproc#popen3(g:unite_source_everything_cmd_path
          \ . ' -n ' . g:unite_source_everything_limit
          \ . (g:unite_source_everything_case_sensitive_search > 0 ? ' -i' : '')
          \ . (g:unite_source_everything_full_path_search > 0 ? ' -p' : '')
          \ . (g:unite_source_everything_posix_regexp_search > 0 ? ' -r' : '')
          \ . (g:unite_source_everything_sort_by_full_path > 0 ? ' -s' : '')
          \ . ' ' . iconv(input, &encoding, &termencoding))
  endif

  let res = []
  if has_key(a:context, 'source__subproc')
    while !a:context.source__subproc.stdout.eof
      let res = a:context.source__subproc.stdout.read_lines()
      if !empty(res)
        break
      endif
    endwhile
    call map(res, 'iconv(v:val, &termencoding, &encoding)')
  endif

  let candidates = map(res, 'unite#util#substitute_path_separator(v:val)')

  if exists('g:unite_source_file_ignore_pattern') && g:unite_source_file_ignore_pattern != ''
    call filter(candidates, 'v:val !~ ' . string(g:unite_source_file_ignore_pattern))
  endif

  return s:build_candidates(candidates)
endfunction "}}}

function! s:build_candidates(candidate_list) "{{{
  let dir_list = []
  let file_list = []
  for candidate in a:candidate_list
    let entry = {
          \ 'word'              : candidate,
          \ 'abbr'              : candidate,
          \ 'source'            : 'everything',
          \ 'action__path'      : candidate,
          \ 'action__directory' : unite#util#path2directory(candidate),
          \	}
    if isdirectory(candidate)
      if candidate !~ '^\%(/\|\a\+:/\)$'
        let entry.abbr .= '/'
      endif
      let entry.kind = 'directory'
      call add(dir_list, entry)
    else
      let entry.kind = 'file'
      call add(file_list, entry)
    endif
  endfor

  return file_list + dir_list
endfunction "}}}

" vim: foldmethod=marker
