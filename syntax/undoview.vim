"=============================================================================
" undoview.vim - undolist viewer for vim.
" Version: 1.0
" Last Change: 2014/11/10 13:43:29.
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

if exists("b:current_syntax")
  finish
endif

" Color Setting
syntax match UndoViewTitle display "Undo View"
hi UndoViewTitle cterm=underline gui=underline
hi UndoViewTitle ctermfg=Cyan ctermbg=Grey guifg=Cyan guibg=bg

syntax match UndoViewSeq display "seq_last"
syntax match UndoViewSeq display "seq_cur"
syntax match UndoViewSeq display "entries"
syntax match UndoViewSeq display "Help"
hi UndoViewSeq ctermfg=lightBlue ctermbg=Grey guifg=lightBlue guibg=bg

syntax match UndoViewNum display "\[.*\]"
hi UndoViewNum ctermfg=Red ctermbg=Grey guifg=Red guibg=bg

syntax match UndoViewSplit display ": "
hi UndoViewSplit ctermfg=Green ctermbg=Grey guifg=Green guibg=bg

let b:current_syntax = "undoview"

" vim: foldmethod=marker
