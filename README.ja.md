unite-everything
================

[Everything](http://www.voidtools.com/) を [unite.vim](https://github.com/Shougo/unite.vim/) から利用するための source です。

非同期に検索するためには [vimproc.vim](https://github.com/Shougo/vimproc.vim/) が必須となります。

Usage:
------

### 同期版

~~~viml
:Unite everything
~~~

### 非同期版

~~~viml
:Unite everything/async
~~~

Customization:
-------------

### everything に対する設定

#### 'g:unite_source_everything_limit'

everything から出力される候補の数です。
増加させると入力に対してより多くの候補を得ることができます。

~~~vim
let g:unite_source_everything_limit = 100
~~~

#### 'g:unite_source_everything_full_path_search'

`1` を指定すると、everything に対してパス全体の一部にマッチさせるように設定します。

~~~vim
let g:unite_source_everything_full_path_search = 0
~~~

#### 'g:unite_source_everything_posix_regexp_search'

`1` を指定すると、everything に対して POSIX 正規表現でのサーチをするように設定します。

~~~vim
let g:unite_source_everything_posix_regexp_search = 0
~~~

#### 'g:unite_source_everything_sort_by_full_path'

`1` を指定すると、everything に対して結果をソートして出力するよう設定します。

~~~vim
let g:unite_source_everything_sort_by_full_path = 0
~~~

#### 'g:unite_source_everything_case_sensitive_search'

`1` を指定すると、everything に対して大文字小文字を区別するように設定します。

~~~vim
let g:unite_source_everything_case_sensitive_search = 0
~~~

### unite-everything ソースに対する設定

#### 'g:unite_source_everything_cmd_path'

`es.exe` の実行ファイル名を指定します。$PATH上にない場合、フルパスで指定します。

~~~vim
let g:unite_source_everything_cmd_path = 'es.exe'
~~~

#### 'g:unite_source_everything_ignore_pattern'

unite-everything 側でマッチから除外するパターンを vim 正規表現で指定します。

#### 'g:unite_source_everything_async_minimum_length'

`unite everything/async` で、検索をに必要な最小の文字数を指定します。
この文字数が入力されたときに、検索が開始されます。

~~~vim
let g:unite_source_everything_async_minimum_length = 3
~~~

Requirements:
-------------

- [unite.vim](https://github.com/Shougo/unite.vim/)
- [vimproc.vim](https://github.com/Shougo/vimproc.vim/)
- [Everything](http://www.voidtools.com/download.php) Version 1.3系 Beta版の利用をお勧めします。
- [es.exe](http://www.voidtools.com/download.php)

Install:
--------

`unite.vim`, `vimproc.vim` については、利用できるようにしておいてください。

`Everything` については、`es.exe` からの利用を簡単にするため、サービスを有効にしてインストールしてください。

`es.exe` は、パスの通ったフォルダに保存するか、保存先のフォルダを
`g:unite_source_everything_cmd_path` に設定してください。

License:
--------

MIT License.

Author:
-------

sgur `<sgurrr+vim@gmail.com>`
