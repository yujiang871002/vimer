"-----------------------------------------------------------------------------
" cscope find的用法:
"
" cs find c|d|e|f|g|i|s|t name
"
" s: 查找C语言符号，即查找函数名、宏、枚举值等出现的地方
" g: 查找函数、宏、枚举等定义的位置，类似ctags所提供的功能
" d: 查找本函数调用的函数
" c: 查找调用本函数的函数
" t: 查找指定的字符串
" e: 查找egrep模式，相当于egrep功能，但查找速度快多了
" f: 查找并打开文件，类似vim的find功能
" i: 查找包含本文件的文件
"
"-----------------------------------------------------------------------------

" This tests to see if vim was configured with the '--enable-cscope' option
" when it was compiled.  If it wasn't, time to recompile vim... 
if has("cscope")

  " 指定用来执行 cscope 的命令
  " set csprg=/usr/bin/cscope

  " 设定可以使用 quickfix 窗口来查看 cscope 结果
  " 可以用下面的命令来跳转:
  " :cw      // 打开quickfix
  " :cn      // 切换到下一个结果
  " :cp      // 切换到上一个结果
  " :cclose  // 关闭quickfix
  if has('quickfix')
    set cscopequickfix=s-,c-,d-,i-,t-,e-
  endif

  " 使支持用 Ctrl+]  和 Ctrl+t 快捷键在代码间跳转
  set cscopetag

  " check cscope for definition of a symbol before checking ctags: set to 1
  " if you want the reverse search order.
  set csto=0

  " Automatically make cscope connections
  " http://vim.wikia.com/wiki/Autoloading_Cscope_Database
  function! LoadCscope()
    let db = findfile("cscope.out", ".;")
    if (!empty(db))
      let path = strpart(db, 0, match(db, "/cscope.out$"))
      set nocscopeverbose " suppress 'duplicate connection' error
      exe "cs add " . db . " " . path
      set cscopeverbose
    endif
  endfunction
  au BufEnter /* call LoadCscope()

endif


