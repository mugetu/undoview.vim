"=============================================================================
" undoview.vim - undolist viewer for vim.
" Version: 1.0
" Last Change: 2014/11/10 13:42:43.
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

let s:save_cpo = &cpo
set cpo&vim

let s:keta = 0
let s:seq_cur = 0
let s:winnr = -1
let s:curline = 9
let s:fileline = 0

"=============================================================================
function! undoview#UndoView(toggle) "{{{
    let s:winnr = winnr()

    if a:toggle == 1
        let undoviewwinnr = bufwinnr('__UndoView__')
        if undoviewwinnr != -1
            exe undoviewwinnr . "wincmd w"
            exe "undoview#UndoViewClose"
            return
        endif
    endif

    let s:tree = undotree()

    let s:keta = len(s:tree['seq_last'])
    let s:seq_cur = s:tree['seq_cur']

    let undoviewwinnr = bufwinnr('__UndoView__')
    if undoviewwinnr == -1
        let openpos = g:UndoViewLeft ? 'topleft vertical ' : 'botright vertical '
        exe 'silent keepalt ' . openpos . g:UndoViewWidth . 'split ' . '__UndoView__'

        let s:curline = 9
    else
        exe undoviewwinnr . "wincmd w"
        exe "setlocal modifiable"
        exe "setlocal noreadonly"
        exe "normal ggVGd"
    endif

    exe "normal IUndo View\<CR>\<Esc>"
    exe "normal I\<CR>\<Esc>"
    exe "normal Iseq_last : [" . s:tree['seq_last'] . "]\<CR>\<Esc>"
    exe "normal Iseq_cur  : [" . s:tree['seq_cur'] . "]\<CR>\<Esc>"
    exe "normal IHelp     : <CR>:undo\<CR>\<Esc>"
    exe "normal I         : d   :current seq line diff\<CR>\<Esc>"
    exe "normal I         : q   :exit\<CR>\<Esc>"
    exe "normal I\<CR>\<Esc>"
    "exe "normal Ientries  : " . len(s:tree['entries']) . "\<CR>\<Esc>"

    call s:UndoPrint(s:tree['entries'], 0)
    exe "normal 1G" . s:curline . "G"

    " keybind
    exe "nnoremap <silent> <buffer> <CR> :call <SID>SelectedEntry()<CR>"
    exe "nnoremap <silent> <buffer> <2-LeftMouse> :call <SID>SelectedEntry()<CR>"
    exe "nnoremap <silent> <buffer> d :call <SID>DiffView(-1)<CR>"
    exe 'nnoremap <silent> <buffer> q :UndoViewClose<CR>'

    call s:InitWindow()

    exe "setlocal nomodifiable"

    if a:toggle == 1 || a:toggle == 2
        exe s:winnr . "wincmd w"
    endif

endfunction
" }}}
"=============================================================================
function! undoview#UndoViewDiff() "{{{
    let s:tree = undotree()

    let s:keta = len(s:tree['seq_last'])
    let s:seq_cur = s:tree['seq_cur']

    let l:chktree = s:tree['entries']
    let length = len(l:chktree) - 1
    while length >= 0

        let exists = has_key(l:chktree[length], 'save')
        if exists
            let l:seq = l:chktree[length]['seq']
            break
        endif

        let length -= 1

    endwhile

    call <SID>DiffView(l:seq)
endfunction
" }}}
"=============================================================================
function! undoview#UndoViewClose() "{{{

    let undoviewdiffwinnr = bufwinnr('__UndoViewDiff__')
    if undoviewdiffwinnr != -1
        exe undoviewdiffwinnr . "wincmd w"
        exe "bdel!"
        exe s:winnr . "wincmd w"
        exe "normal " . s:fileline . "G"
        return
    endif

    let undoviewwinnr = bufwinnr('__UndoView__')
    if undoviewwinnr != -1
        exe undoviewwinnr . "wincmd w"
        exe "bdel!"
        exe s:winnr . "wincmd w"
        return
    endif

endfunction
" }}}
"=============================================================================
function! s:UndoPrint(tree, indent) "{{{
    let length = len(a:tree) - 1
    let counter = 0
    while length >= 0

        let exists = has_key(a:tree[length], 'alt')
        let haifun = ""
        if exists
            call s:UndoPrint(a:tree[length]['alt'], a:indent + 1)
            let haifun = "-+"
        endif

        let space = " "
        let indentcount = 0
        while indentcount < a:indent
            let space = space . "| "
            let indentcount += 1
        endwhile

        let thisketa = len(a:tree[length]['seq'])
        let ketaspace = ""
        let ketacount = s:keta - thisketa
        while ketacount > 0
            let ketaspace = ketaspace . " "
            let ketacount -= 1
        endwhile

        let seq_cur_point = "  "
        if s:seq_cur == a:tree[length]['seq']
            let seq_cur_point = "->"
        endif

        let save = " "
        let exists = has_key(a:tree[length], 'save')
        if exists
            let save = "S"
        endif

        "exe "normal I" . seq_cur_point . "[" . ketaspace . a:tree[length]['seq'] . "] " . strftime("%H:%M:%S", a:tree[length]['time']) . space . "o" . haifun . "\<CR>\<Esc>"
        exe "normal I" . seq_cur_point . "[" . ketaspace . a:tree[length]['seq'] . "] " . save . " " . strftime("%Y/%m/%d %H:%M:%S", a:tree[length]['time']) . space . "o" . haifun . "\<CR>\<Esc>"

        let length -= 1

        let counter += 1
        if (g:UndoViewMaxCount != 0) && (counter >= g:UndoViewMaxCount)
            break
        endif

    endwhile
    return
endfunction
" }}}
"=============================================================================
function! s:SelectedEntry() "{{{
   let line = getline(a:firstline)
   let s:curline = a:firstline
   let entrie_line_left = stridx(line, '[')
   let entrie_line_right = stridx(line, ']')
   if entrie_line_left == -1
       return
   endif
   if entrie_line_right == -1
       return
   endif

   let line = substitute(line, '.*\[\(.*\)\].*', '\1', 'g')
   let seq = substitute(line, ' ', '', 'g')

   let nr = winnr()
   exe s:winnr . "wincmd w"

   exe "undo " . seq

   call undoview#UndoView(0)

endfunction
" }}}
"=============================================================================
function! s:DiffView(seqnum) "{{{

    let l:cur = s:seq_cur

    if a:seqnum == -1

        let line = getline(a:firstline)
        let s:curline = a:firstline
        let entrie_line_left = stridx(line, '[')
        let entrie_line_right = stridx(line, ']')
        if entrie_line_left == -1
            return
        endif
        if entrie_line_right == -1
            return
        endif

        let line = substitute(line, '.*\[\(.*\)\].*', '\1', 'g')
        let l:seq = substitute(line, ' ', '', 'g')
        exe s:winnr . "wincmd w"

    else

        let l:seq = a:seqnum

    endif

    let s:winnr = winnr()
    let s:fileline = line(".")
    exe "undo " . l:seq
    exe "normal ggVGy"
    exe "undo " . l:cur
    exe "normal " . s:fileline . "G"

    let l:ft = &filetype
    exe "diffthis"

    let openpos = g:UndoViewDiffVertical ? 'vertical ' : ' '
    exe 'silent keepalt ' . openpos . 'split ' . '__UndoViewDiff__'

    exe "normal PGdd1G"

    exe "set ft=" . l:ft

    exe "diffthis"

    exe "setlocal nomodifiable"
    exe "setlocal number"

    " keybind
    exe 'nnoremap <silent> <buffer> q :UndoViewClose<CR>:windo diffoff<CR>'

endfunction
" }}}
"=============================================================================
function! s:InitWindow() "{{{

    setlocal readonly
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    setlocal modifiable
    setlocal filetype=undoview
    setlocal nolist
    setlocal nonumber
    setlocal nowrap
    setlocal winfixwidth
    setlocal textwidth=0
    setlocal cursorline
    setlocal nocursorcolumn

endfunction
" }}}
"=============================================================================

let &cpo = s:save_cpo
unlet s:save_cpo

" __END__
" vim: foldmethod=marker
