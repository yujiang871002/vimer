"-----------------------------------------------------------------------------
" Key (re)Mappings
" 说明：使用:map命令，可以列出所有键盘映射。
"-----------------------------------------------------------------------------
" 定义快捷键的前缀（即<Leader>），默认值是'\'。
let g:mapleader = ','

map <F2> :NERDTreeToggle<CR>
map <F3> :TagbarToggle<CR>

"-----------------------------------------------------------------------------
" 用户定义函数
"-----------------------------------------------------------------------------
function! s:get_cache_dir(suffix)
  return resolve(expand('~/.cache' . '/' . a:suffix))
endfunction

function! EnsureExists(path)
  if !isdirectory(expand(a:path))
    call mkdir(expand(a:path), 'p')
  endif
endfunction

"-----------------------------------------------------------------------------
" 使用pathogen管理Vim插件
"-----------------------------------------------------------------------------
" get easier to use and more user friendly vim defaults
" CAUTION: This option breaks some vi compatibility.
"          Switch it off if you prefer real vi compatibility
set nocompatible

" 通过runtime命令将pathogen.vim加入vim的运行时环境
runtime bundle/pathogen/autoload/pathogen.vim
" 执行pathogen.vim中的infect函数
execute pathogen#infect()
" 生成帮助文件
execute pathogen#helptags()

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on

"-----------------------------------------------------------------------------
" configuring swap, backup and undo files.
"-----------------------------------------------------------------------------
" persistent undo
if exists('+undofile')
  set undofile
  let &undodir = s:get_cache_dir('undo.vim')
  call EnsureExists(&undodir)
endif

" backups
set backup
let &backupdir = s:get_cache_dir('backup.vim')
call EnsureExists(&backupdir)

" swap files
set swapfile
let &directory = s:get_cache_dir('swap.vim')
call EnsureExists(&directory)

"-----------------------------------------------------------------------------
" 解决编码问题
"-----------------------------------------------------------------------------
" " 自动判断编码时，依次尝试以下编码：
" set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1,default
" " 设置新文件的编码为 UTF-8 ,查看文件编码：set fileencoding
" set fileencoding=utf-8

" " 让vim自动识别文件格式
" set fileformats=unix,dos,mac
" " 设置（转换）文件格式,查看文件格式: set fileformat
" set fileformat=unix

" " 解决Windows下乱码问题
" if has('win32') || has('win64')
  " set encoding=utf-8
  " set langmenu=zh_CN.UTF-8
  " source $VIMRUNTIME/delmenu.vim
  " source $VIMRUNTIME/menu.vim
  " language message zh_CN.UTF-8
" endif

" 一段可以自动猜测编码的脚本,很强的
" Encoding settings
if has("multi_byte")
  " Set fileencoding priority
  if getfsize(expand("%")) > 0
    set fileencodings=ucs-bom,utf-8,cp936,big5,euc-jp,euc-kr,latin1
  else
    set fileencodings=cp936,big5,euc-jp,euc-kr,latin1
  endif
  " CJK environment detection and corresponding setting
  if v:lang =~ "^zh_CN"
    " Use cp936 to support GBK, euc-cn == gb2312
    set encoding=cp936
    set termencoding=cp936
    set fileencoding=cp936
  elseif v:lang =~ "^zh_TW"
    " cp950, big5 or euc-tw
    " Are they equal to each other?
    set encoding=big5
    set termencoding=big5
    set fileencoding=big5
  elseif v:lang =~ "^ko"
    " Copied from someone's dotfile, untested
    set encoding=euc-kr
    set termencoding=euc-kr
    set fileencoding=euc-kr
  elseif v:lang =~ "^ja_JP"
    " Copied from someone's dotfile, unteste
    set encoding=euc-jp
    set termencoding=euc-jp
    set fileencoding=euc-jp
  endif
  " Detect UTF-8 locale, and replace CJK setting if needed
  if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
    set encoding=utf-8
    set termencoding=utf-8
    set fileencoding=utf-8
  endif
else
  echoerr "Sorry, this version of (g)vim was not compiled with multi_byte"
endif

"-----------------------------------------------------------------------------
" 语法高亮
"-----------------------------------------------------------------------------
" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  " 开启语法高亮功能
  syntax enable
  " 允许用指定语法高亮配色方案替换默认方案
  syntax on
endif

"-----------------------------------------------------------------------------
" 主题风格
"-----------------------------------------------------------------------------
" Explicitly tell vim that the terminal supports 256 colors,
" need before setting the colorscheme
if (&term =~ "xterm") || (&term =~ "screen")
  set t_Co=256
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" https://github.com/tomasr/molokai.git
if filereadable(globpath(&runtimepath,'colors/molokai.vim'))
  colorscheme molokai
endif

"-----------------------------------------------------------------------------
" 显示中文帮助
"-----------------------------------------------------------------------------
if version >= 603
  set helplang=cn
  set encoding=utf-8
endif

"-----------------------------------------------------------------------------
" 快速开关注释
"-----------------------------------------------------------------------------
let NERDSpaceDelims = 1
let NERDRemoveExtraSpaces = 1

"-----------------------------------------------------------------------------
" 智能补全和模板补全
"-----------------------------------------------------------------------------
if has('lua')
  " Use neocomplete.
  let g:neocomplete#enable_at_startup = 1
  " Use smartcase.
  let g:neocomplete#enable_smart_case = 1
else
  " Use neocomplcache.
  let g:neocomplcache_enable_at_startup = 1
  " Use smartcase.
  let g:neocomplcache_enable_smart_case = 1
endif

"-----------------------------------------------------------------------------
" vim-airline
"-----------------------------------------------------------------------------
"Smarter tab line
let g:airline#extensions#tabline#enabled = 1
" enable/disable displaying index of the buffer.
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>+ <Plug>AirlineSelectNextTab

"-----------------------------------------------------------------------------
" 查看自定义函数原型：vim 配合 ctags/cocope 实现函数原型快速定位
"-----------------------------------------------------------------------------
if executable('ctags')
  " 该功能依赖于ctags工具。[9]安装好ctags后，在存放代码的文件夹
  "   ctags -R .
  " 即可生成一个描述代码结构的tags文件。
  " 实现vim对tags的自动递归查找:
  set autochdir    " 自动切换目录
  set tags=tags;   " 自动查找
  " 设置好后，可在Vim中使用如下功能:Ctrl-]转至最佳匹配的相应Tag，Ctrl-T返回上一个匹配。
  " 如果有多个匹配，g Ctrl-]可显示所有备选的tags。
  " 注意：tags文件不会自动更新，所以当你中途修改了代码时，应该手动重新生成tags文件，
  " vim会随时更新加载tags文件所以不用重启。当前重新生成ctags的快捷键为<Ctrl-F12>
  map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
endif

"-----------------------------------------------------------------------------
" Search Settings
"-----------------------------------------------------------------------------
set hlsearch        " Highlight search results
set incsearch       " Makes search act like search in modern browsers
set ignorecase      " Ignore case when searching
set smartcase       " When searching try to be smart about cases

" -----------------------------------------------------------------------------
" Search and replace
" http://vim.wikia.com/wiki/Search_and_replace
" -----------------------------------------------------------------------------
" 去掉所有的行尾空格    ：“:%s/\s\+$//”。
" 去掉所有的空白行      ：“:%s/\(\s*\n\)\+/\r/”。
" 去掉所有的“//”注释    ：“:%s!\s*//.*!!”。
" 去掉所有的“/* */”注释 ：“:%s!\s*/\*\_.\{-}\*/\s*! !g”。

"-----------------------------------------------------------------------------
" VIM 7.3+ has support for highlighting a specified column.
"-----------------------------------------------------------------------------
if exists('+colorcolumn')
  set colorcolumn=120
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>120v.\+', -1)
endif

"-----------------------------------------------------------------------------
" Highlighting that moves with the cursor
"-----------------------------------------------------------------------------
set cursorline cursorcolumn
autocmd WinLeave * setlocal nocursorline nocursorcolumn
autocmd WinEnter * setlocal cursorline cursorcolumn

" SignColumn should match background
highlight clear SignColumn

" Current line number row will have same background color in relative mode
highlight clear LineNr

" Remove highlight color from current line number
highlight clear CursorLineNr

" -----------------------------------------------------------------------------
" Make Vim use the system clipboard as the default register
" -----------------------------------------------------------------------------
if has('clipboard')
  if has('unnamedplus')
    " When possible use + register for copy-paste
    set clipboard=unnamed,unnamedplus
  else
    " On mac and Windows, use * register for copy-paste
    set clipboard=unnamed
  endif
endif

"-----------------------------------------------------------------------------
" others
"-----------------------------------------------------------------------------
" Vim with default settings does not allow easy switching between multiple files
" in the same editor window. Users can use multiple split windows or multiple
" tab pages to edit multiple files, but it is still best to enable an option to
" allow easier switching between files.
"
" One such option is the 'hidden' option, which allows you to re-use the same
" window and switch from an unsaved buffer without saving it first. Also allows
" you to keep an undo history for multiple files when re-using the same window
" in this way. Note that using persistent undo also lets you undo in multiple
" files even in the same window, but is less efficient and is actually designed
" for keeping undo history after closing Vim entirely. Vim will complain if you
" try to quit without saving, and swap files will keep you safe if your computer
" crashes.
set hidden

" Note that not everyone likes working this way (with the hidden option).
" Alternatives include using tabs or split windows instead of re-using the same
" window as mentioned above, and/or either of the following options:
" set confirm
" set autowriteall

" Better command-line completion
set wildmenu

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=

" Display line numbers on the left
set number

" 禁止折行
set nowrap

" -----------------------------------------------------------------------------
" Super retab -- tab和space之间的互相转换
" http://vim.wikia.com/wiki/Super_retab#Script
" -----------------------------------------------------------------------------
" Return indent (all whitespace at start of a line), converted from
" tabs to spaces if what = 1, or from spaces to tabs otherwise.
" When converting to tabs, result has no redundant spaces.
function! Indenting(indent, what, cols)
  let spccol = repeat(' ', a:cols)
  let result = substitute(a:indent, spccol, '\t', 'g')
  let result = substitute(result, ' \+\ze\t', '', 'g')
  if a:what == 1
    let result = substitute(result, '\t', spccol, 'g')
  endif
  return result
endfunction

" Convert whitespace used for indenting (before first non-whitespace).
" what = 0 (convert spaces to tabs), or 1 (convert tabs to spaces).
" cols = string with number of columns per tab, or empty to use 'tabstop'.
" The cursor position is restored, but the cursor will be in a different
" column when the number of characters in the indent of the line is changed.
function! IndentConvert(line1, line2, what, cols)
  let savepos = getpos('.')
  let cols = empty(a:cols) ? &tabstop : a:cols
  execute a:line1 . ',' . a:line2 . 's/^\s\+/\=Indenting(submatch(0), a:what, cols)/e'
  call histdel('search', -1)
  call setpos('.', savepos)
endfunction

command! -nargs=? -range=% Space2Tab call IndentConvert(<line1>,<line2>,0,<q-args>)
command! -nargs=? -range=% Tab2Space call IndentConvert(<line1>,<line2>,1,<q-args>)
command! -nargs=? -range=% RetabIndent call IndentConvert(<line1>,<line2>,&et,<q-args>)

" -----------------------------------------------------------------------------
" 一键去除所有尾部空白
" -----------------------------------------------------------------------------
imap <leader>rb <ESC>:let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
nmap <leader>rb :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
vmap <leader>rb <ESC>:let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" -----------------------------------------------------------------------------
" 一键去除^M字符
" -----------------------------------------------------------------------------
imap <leader>rm <ESC>:%s/<c-v><c-m>//g<CR>
nmap <leader>rm :%s/<c-v><c-m>//g<CR>
vmap <leader>rm <ESC>:%s/<c-v><c-m>//g<CR>

" ----------------------------------------------------------------------------
" 退出vim后，内容显示在终端屏幕
" ----------------------------------------------------------------------------
set t_ti= t_te=

