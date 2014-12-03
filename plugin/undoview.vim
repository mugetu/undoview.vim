"=============================================================================
" undoview.vim - undolist viewer for vim.
" Version: 1.0
" Last Change: 2014/11/10 13:43:18.
" Author: mugetu
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================
scriptencoding utf-8

if !exists('g:undoview_enable')
  let g:undoview_enable = 1
elseif v:version < 703
  echoerr 'UndoView does not work this version of Vim "' . v:version . '".'
  finish
endif

if exists('g:loaded_undoview') || !g:undoview_enable
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

" Options check. "{{{
if !exists("g:UndoViewWidth")
    let g:UndoViewWidth = 40
endif

if !exists('g:UndoViewLeft')
    let g:UndoViewLeft = 0
endif

if !exists('g:UndoViewDiffVertical')
    let g:UndoViewDiffVertical = 1
endif

if !exists('g:UndoViewMaxCount')
    let g:UndoViewMaxCount = 200
endif
"}}}

" Plugin key-mappings. "{{{
nnoremap <silent> <Plug>(undoview) :UndoView<CR>
"ex) nmap <Leader>uv <Plug>(undoview)

if !hasmapto('<Plug>(undoview)')
      \ && (!exists('g:undoview_no_default_key_mappings')
      \   || !g:undoview_no_default_key_mappings)
  silent! map <unique> <Leader>uv <Plug>(undoview)
endif
"}}}

augroup undoview "{{{
augroup END"}}}

" Commands. "{{{
command! -nargs=0 UndoView       call undoview#UndoView(0)
command! -nargs=0 UndoViewToggle call undoview#UndoView(1)
command! -nargs=0 UndoViewUpdate call undoview#UndoView(2)
command! -nargs=0 UndoViewDiff   call undoview#UndoViewDiff()
command! -nargs=0 UndoViewClose  call undoview#UndoViewClose()
"}}}

let g:loaded_undoview = 1

let &cpo = s:save_cpo
unlet s:save_cpo

" __END__
" vim: foldmethod=marker
