" ============================================================================
" File:        tagbar.vim
" Description: List the current file's tags in a sidebar, ordered by class etc
" Author:      Jan Larres <jan@majutsushi.net>
" Licence:     Vim licence
" Website:     http://majutsushi.github.com/tagbar/
" Version:     2.4.1
" Note:        This plugin was heavily inspired by the 'Taglist' plugin by
"              Yegappan Lakshmanan and uses a small amount of code from it.
"
" Original taglist copyright notice:
"              Permission is hereby granted to use and distribute this code,
"              with or without modifications, provided that this copyright
"              notice is copied with it. Like anything else that's free,
"              taglist.vim is provided *as is* and comes with no warranty of
"              any kind, either expressed or implied. In no event will the
"              copyright holder be liable for any damamges resulting from the
"              use of this software.
" ============================================================================

if v:version < 700
  echohl WarningMsg | echo 'The plugin window.vim needs Vim version >= 7 .'| echohl None
  finish
endif

" Prevent duplicate loading:
if &cp || exists('g:loaded_amarok_playlist')
    finish
endif

let g:loaded_amarok_playlist = 1

" script variables {{{1
let s:debug = 0
let s:window_expanded = 0
" Known files {{{2
let s:known_files = {
    \ '_current' : {},
    \ '_files'   : {}
\ }

" s:known_files.getCurrent() {{{3
function! s:known_files.getCurrent() abort dict
    return self._current
endfunction

" s:known_files.setCurrent() {{{3
function! s:known_files.setCurrent(fileinfo) abort dict
    let self._current = a:fileinfo
endfunction

" s:known_files.get() {{{3
function! s:known_files.get(fname) abort dict
    return get(self._files, a:fname, {})
endfunction

" s:known_files.put() {{{3
" Optional second argument is the filename
function! s:known_files.put(fileinfo, ...) abort dict
    if a:0 == 1
        let self._files[a:1] = a:fileinfo
    else
        let fname = a:fileinfo.fpath
        let self._files[fname] = a:fileinfo
    endif
endfunction

" s:known_files.has() {{{3
function! s:known_files.has(fname) abort dict
    return has_key(self._files, a:fname)
endfunction

" s:known_files.rm() {{{3
function! s:known_files.rm(fname) abort dict
    if s:known_files.has(a:fname)
        call remove(self._files, a:fname)
    endif
endfunction

" Window management {{{1
" s:ToggleWindow() {{{2
function! s:ToggleWindow() abort
    call s:LogDebugMessage('ToggleWindow called')

    let tagbarwinnr = bufwinnr("[PlayList]")
    if tagbarwinnr != -1
        call s:CloseWindow()
        return
    endif

    call s:OpenWindow('')

    call s:LogDebugMessage('ToggleWindow finished')
endfunction

" s:OpenWindow() {{{2
function! s:OpenWindow(flags) abort
    call s:LogDebugMessage("OpenWindow called with flags: '" . a:flags . "'")

    let autofocus = a:flags =~# 'f'
    let jump      = a:flags =~# 'j'
    let autoclose = a:flags =~# 'c'

    let curfile = fnamemodify(bufname('%'), ':p')
    let curline = line('.')

    " If the tagbar window is already open check jump flag
    " Also set the autoclose flag if requested
    let tagbarwinnr = bufwinnr('[PlayList]')
    if tagbarwinnr != -1
        if winnr() != tagbarwinnr && jump
            call s:winexec(tagbarwinnr . 'wincmd w')
        endif
        call s:LogDebugMessage("OpenWindow finished, PlayList already open")
        return
    endif

    " Expand the Vim window to accomodate for the PlayList window if requested
    if g:tagbar_expand && !s:window_expanded && has('gui_running')
        let &columns += g:tagbar_width + 1
        let s:window_expanded = 1
    endif

    let eventignore_save = &eventignore
    set eventignore=all

    let openpos = g:tagbar_left ? 'topleft vertical ' : 'botright vertical '
    exe 'silent keepalt ' . openpos . g:tagbar_width . 'split ' . '[PlayList]'

    let &eventignore = eventignore_save

    call s:InitWindow(autoclose)

    if !(g:tagbar_autoclose || autofocus || g:tagbar_autofocus)
        call s:winexec('wincmd p')
    endif

    call s:LogDebugMessage('OpenWindow finished')
endfunction

" s:InitWindow() {{{2
function! s:InitWindow(autoclose) abort
    call s:LogDebugMessage('InitWindow called with autoclose: ' . a:autoclose)

    setlocal filetype=tagbar

    setlocal noreadonly " in case the "view" mode is used
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nomodifiable
    setlocal nolist
    setlocal nonumber
    setlocal nowrap
    setlocal winfixwidth
    setlocal textwidth=0
    setlocal nocursorline
    setlocal nocursorcolumn
    setlocal nospell

    if exists('+relativenumber')
        setlocal norelativenumber
    endif

    setlocal nofoldenable
    setlocal foldcolumn=0
    " Reset fold settings in case a plugin set them globally to something
    " expensive. Apparently 'foldexpr' gets executed even if 'foldenable' is
    " off, and then for every appended line (like with :put).
    setlocal foldmethod&
    setlocal foldexpr&
    setlocal statusline=[PlayList]

    " Script-local variable needed since compare functions can't
    " take extra arguments
    let s:compare_typeinfo = {}

    let s:is_maximized = 0
    let s:short_help   = 1
    let s:new_window   = 1

    let w:autoclose = a:autoclose

    let cpoptions_save = &cpoptions
    set cpoptions&vim

    let &cpoptions = cpoptions_save

    call s:LogDebugMessage('InitWindow finished')
endfunction

" s:CloseWindow() {{{2
function! s:CloseWindow() abort
    call s:LogDebugMessage('CloseWindow called')

    let tagbarwinnr = bufwinnr('[PlayList]')
    if tagbarwinnr == -1
        return
    endif

    let tagbarbufnr = winbufnr(tagbarwinnr)

    if winnr() == tagbarwinnr
        if winbufnr(2) != -1
            " Other windows are open, only close the tagbar one

            let curfile = s:known_files.getCurrent()

            call s:winexec('close')

            " Try to jump to the correct window after closing
            call s:winexec('wincmd p')

            if !empty(curfile)
                let filebufnr = bufnr(curfile.fpath)

                if bufnr('%') != filebufnr
                    let filewinnr = bufwinnr(filebufnr)
                    if filewinnr != -1
                        call s:winexec(filewinnr . 'wincmd w')
                    endif
                endif
            endif
        endif
    else
        " Go to the tagbar window, close it and then come back to the
        " original window
        let curbufnr = bufnr('%')
        call s:winexec(tagbarwinnr . 'wincmd w')
        close
        " Need to jump back to the original window only if we are not
        " already in that window
        let winnum = bufwinnr(curbufnr)
        if winnr() != winnum
            call s:winexec(winnum . 'wincmd w')
        endif
    endif

    " If the Vim window has been expanded, and PlayList is not open in any other
    " tabpages, shrink the window again
    if s:window_expanded
        let tablist = []
        for i in range(tabpagenr('$'))
            call extend(tablist, tabpagebuflist(i + 1))
        endfor

        if index(tablist, tagbarbufnr) == -1
            let &columns -= g:tagbar_width + 1
            let s:window_expanded = 0
        endif
    endif

    call s:LogDebugMessage('CloseWindow finished')
endfunction

" s:ZoomWindow() {{{2
function! s:ZoomWindow() abort
    if s:is_maximized
        execute 'vert resize ' . g:tagbar_width
        let s:is_maximized = 0
    else
        vert resize
        let s:is_maximized = 1
    endif
endfunction

" s:CorrectFocusOnStartup() {{{2
" For whatever reason the focus will be on the PlayList window if
" tagbar#autoopen is used with a FileType autocommand on startup and
" g:tagbar_left is set. This should work around it by jumping to the window of
" the current file after startup.
function! s:CorrectFocusOnStartup() abort
    if bufwinnr('[PlayList]') != -1 && !g:tagbar_autofocus && !s:last_autofocus
        let curfile = s:known_files.getCurrent()
        if !empty(curfile) && curfile.fpath != fnamemodify(bufname('%'), ':p')
            let winnr = bufwinnr(curfile.fpath)
            if winnr != -1
                call s:winexec(winnr . 'wincmd w')
            endif
        endif
    endif
endfunction

" Debugging {{{1
" s:StartDebug() {{{2
function! s:StartDebug(filename) abort
    if empty(a:filename)
        let s:debug_file = 'tagbardebug.log'
    else
        let s:debug_file = a:filename
    endif

    " Empty log file
    exe 'redir! > ' . s:debug_file
    redir END

    " Check whether the log file could be created
    if !filewritable(s:debug_file)
        echomsg 'PlayList: Unable to create log file ' . s:debug_file
        let s:debug_file = ''
        return
    endif

    let s:debug = 1
endfunction

" s:StopDebug() {{{2
function! s:StopDebug() abort
    let s:debug = 0
    let s:debug_file = ''
endfunction

" s:LogDebugMessage() {{{2
function! s:LogDebugMessage(msg) abort
    if s:debug
        execute 'redir >> ' . s:debug_file
        silent echon strftime('%H:%M:%S') . ': ' . a:msg . "\n"
        redir END
    endif
endfunction

" Helper functions {{{1
" s:winexec() {{{2
function! s:winexec(cmd) abort
    call s:LogDebugMessage("Executing without autocommands: " . a:cmd)

    let eventignore_save = &eventignore
    set eventignore=BufEnter

    execute a:cmd

    let &eventignore = eventignore_save
endfunction

" Global commands {{{1
command! ToggleWindow call s:ToggleWindow()

" Modeline {{{1
" vim: ts=8 sw=4 sts=4 et foldenable foldmethod=marker foldcolumn=1
