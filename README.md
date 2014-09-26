unite-everything
================

An [unite.vim](https://github.com/Shougo/unite.vim/) source to use with [Everything](http://www.voidtools.com/)

If you want to search asynchronously, [vimproc.vim](https://github.com/Shougo/vimproc.vim/) is required.

Usage:
------

### Synchronous

~~~viml
:Unite everything
~~~

### Asynchronous

~~~viml
:Unite everything/async
~~~

Customization:
-------------

### Customize everything

#### 'g:unite_source_everything_limit'

A number of output from everything.

Increase this makes more output candidates.

~~~vim
let g:unite_source_everything_limit = 100
~~~

#### 'g:unite_source_everything_full_path_search'

Setting `1` makes everything do a full path search.

~~~vim
let g:unite_source_everything_full_path_search = 0
~~~

#### 'g:unite_source_everything_posix_regexp_search'

Setting `1` makes everything search with basic POSIX regular expression.

~~~vim
let g:unite_source_everything_posix_regexp_search = 0
~~~

#### 'g:unite_source_everything_sort_by_full_path'

Setting `1` makes everything sort result by full path.

~~~vim
let g:unite_source_everything_sort_by_full_path = 0
~~~

#### 'g:unite_source_everything_case_sensitive_search'

Setting `1` makes everything do case sensitive search.

~~~vim
let g:unite_source_everything_case_sensitive_search = 0
~~~

### Customize unite-everything

#### 'g:unite_source_everything_cmd_path'

Path to `es.exe` executable. Specifiy full path if not in $PATH.

~~~vim
let g:unite_source_everything_cmd_path = 'es.exe'
~~~

#### 'g:unite_source_everything_ignore_pattern'

Exclude pattern for unite-everything source. Specify this vim regular expresion format.

#### 'g:unite_source_everything_async_minimum_length'

Minimum characters to start search in `:Unite everything/async`.

~~~vim
let g:unite_source_everything_async_minimum_length = 3
~~~

Requirements:
-------------

- [unite.vim](https://github.com/Shougo/unite.vim/)
- [vimproc.vim](https://github.com/Shougo/vimproc.vim/)
- [Everything](http://www.voidtools.com/download.php): Version 1.3 or newer is recommended
- [es.exe](http://www.voidtools.com/download.php)

Install:
--------

Make sure `unite.vim` `vimproc.vim` are avaiable.

I recommend install `Everything` with Everything Service for convince to use with `es.exe`.

Locate `es.exe` in $PATH or set the location to `g:unite_source_everything_cmd_path`.

License:
--------

MIT License.

Author:
-------

sgur `<sgurrr+vim@gmail.com>`

