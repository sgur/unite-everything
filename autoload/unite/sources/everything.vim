"=============================================================================
" FILE: everything.vim
" Last Modified: 2010-11-16
" Description: everything のコマンドラインインタフェース(es.exe)を利用し、
"              unite から everything を利用するための source
" Requirement: everything.exe
"            : es.exe in $PATH
" Notes: ディレクトリ等がジャンクションだったりすると everything が検索してくれない
"=============================================================================

" Variables  "{{{
call unite#set_default('g:unite_source_everything_limit', 50)
" search entire path
call unite#set_default('g:unite_source_everything_full_path_search', 1)
" use POSIX regexp
call unite#set_default('g:unite_source_everything_posix_regexp_search', 0)
" sort result by full path string
call unite#set_default('g:unite_source_everything_sort_by_full_path', 0)
"}}}

function! unite#sources#everything#define()"{{{
	if unite#is_win() && s:available_vimproc && s:available_es
		return s:source
	endif
	return []
endfunction"}}}

let s:source = {
			\ 'name' : 'everything',
			\ 'is_volatile' : 1,
			\ 'max_candidates': g:unite_source_everything_limit,
			\}
let s:available_vimproc = globpath(&runtimepath, 'autoload/vimproc.vim') != '' && vimproc#version() > 0
let s:available_es = executable('es.exe')

function! s:source.gather_candidates(args, context)"{{{
	let l:input = substitute(a:context.input, '^\a\+:\zs\*/', '/', '')
	" use vimproc
	let l:res = vimproc#system('es' 
				\ . ' -n ' . g:unite_source_everything_limit
				\ . (g:unite_source_everything_full_path_search > 0 ? ' -p' : '')
				\ . (g:unite_source_everything_posix_regexp_search > 0 ? ' -r' : '')
				\ . (g:unite_source_everything_sort_by_full_path > 0 ? ' -s' : '')
				\ . ' ' . l:input)
	if &shellslash
		let l:res = substitute(l:res, '\\', '/', 'g')
	endif
	let l:candidates = split(l:res, '\r\n\|\r\|\n')

	let l:candidates_dir = []
	let l:candidates_file = []
	for l:entry in l:candidates
		let l:dict = { 'word' : l:entry, 'abbr' : l:entry, 'source' : 'everything',
					\ 'action__path' : l:entry,
					\ 'action__directory' : unite#path2directory(l:entry),
					\	}
		if isdirectory(l:entry)
			if l:entry !~ '^\%(/\|\a\+:/\)$'
				let l:dict.abbr .= '/'
			endif
			let l:dict.kind = 'directory'
			call add(l:candidates_dir, l:dict)
		else
			let l:dict.kind = 'file'
			call add(l:candidates_file, l:dict)
		endif
	endfor

	return l:candidates_dir + l:candidates_file
endfunction"}}}

" vim: foldmethod=marker
