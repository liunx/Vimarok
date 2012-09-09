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
let s:autocommands_done = 0

" Initialization {{{1 

" s:CreateAutocommands() {{{2
function! s:CreateAutocommands() abort
    augroup PlayListAutoCmds
        autocmd!
        autocmd BufEnter  __PlayList__ nested call s:QuitIfOnlyWindow()

    augroup END

    let s:autocommands_done = 1

endfunction

" Window management {{{1
" s:ToggleWindow() {{{2
function! s:ToggleWindow() abort
    let tagbarwinnr = bufwinnr("__PlayList__")
    if tagbarwinnr != -1
        call s:CloseWindow()
        return
    endif

    call s:OpenWindow()

endfunction

" s:OpenWindow() {{{2
function! s:OpenWindow() abort
    let tagbarwinnr = bufwinnr('__PlayList__')
    if tagbarwinnr != -1
        if winnr() != tagbarwinnr
            call s:winexec(tagbarwinnr . 'wincmd w')
        endif
        return
    endif

    if !s:autocommands_done
        call s:CreateAutocommands()
    endif

    let eventignore_save = &eventignore
    set eventignore=all

    let openpos = g:tagbar_left ? 'topleft vertical ' : 'botright vertical '
    exe 'silent keepalt ' . openpos . g:tagbar_width . 'split ' . '__PlayList__'

    let &eventignore = eventignore_save

    call s:InitWindow()

    call s:winexec('wincmd p')

endfunction

" s:InitWindow() {{{2
function! s:InitWindow() abort
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

    let cpoptions_save = &cpoptions
    set cpoptions&vim

    let &cpoptions = cpoptions_save

endfunction

" s:CloseWindow() {{{2
function! s:CloseWindow() abort
    let tagbarwinnr = bufwinnr('__PlayList__')
    if tagbarwinnr == -1
        return
    endif

    let tagbarbufnr = winbufnr(tagbarwinnr)

    if winnr() == tagbarwinnr
        if winbufnr(2) != -1

            " Other windows are open, only close the tagbar one
            call s:winexec('close')

            " Try to jump to the correct window after closing
            call s:winexec('wincmd p')
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

endfunction

" s:UpdateWindow() {{{2
function! s:UpdateWindow() abort
    let plistwinnr = bufwinnr('__PlayList__')
    if plistwinnr == -1
        return
    endif
    echo "UpdateWindow"
endfunction

" Helper functions {{{1
" s:winexec() {{{2
function! s:winexec(cmd) abort
    let eventignore_save = &eventignore
    set eventignore=BufEnter

    execute a:cmd

    let &eventignore = eventignore_save
endfunction

" s:QuitIfOnlyWindow() {{{2
function! s:QuitIfOnlyWindow() abort
    " Check if there is more than window
    if winbufnr(2) == -1
        " Check if there is more than one tab page
        if tabpagenr('$') == 1
            " Before quitting Vim, delete the tagbar buffer so that
            " the '0 mark is correctly set to the previous buffer.
            bdelete
            quitall
        else
            close
        endif
    endif
endfunction

" Global commands {{{1
command! ToggleWindow call s:ToggleWindow()

" Modeline {{{1
" vim: ts=8 sw=4 sts=4 et foldenable foldmethod=marker foldcolumn=1
