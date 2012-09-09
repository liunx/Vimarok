" ============================================================================
" File:        Vimarok.vim
" Description: Show playlist of amarok and control it via dbus-python.
" Author:      Lei Liu <liunx163@163.com>
" Licence:     Vim licence
" Website:     
" Version:     0.1.0
" Note:        This plugin's window manage function was heavily inspired by
"              the 'Tagbar' & 'Taglist' plugin by Jan Larres & Yegappan
"              Lakshmanan and uses a few amount of code from them.
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
    echohl WarningMsg | echo 'The plugin Vimarok.vim needs Vim version >= 7 .' | echohl None
    finish
endif

if !has('python')
    echohl WarningMsg | echo 'Python may not installed' | echohl None
    finish
endif

" Prevent duplicate loading:
if &cp || exists('g:loaded_amarok_playlist')
    finish
endif

let g:loaded_amarok_playlist = 1


" Global variables {{{1
if !exists('g:amarok_volume_factor')
    let g:amarok_volume_factor = 1
endif
" value ms
if !exists('g:amarok_track_factor')
    let g:amarok_track_factor = 1000
endif
" }}}1

"======================================================================
" org.kde.amarok
" /Player
"======================================================================

" ---------------------------------------------------------------------
" ShowOSD {{{1
function! s:ShowOSD()
python << EOF
import dbus
import vim

try:
    bus = dbus.SessionBus()
    amarok = bus.get_object("org.kde.amarok",
                "/Player")

    amarok.ShowOSD()
except dbus.exceptions.DBusException:
    vim.command("echohl WarningMsg | echo \"amarok not launch!\"
                \ | echohl None")
except dbus.exceptions.UnknownMethodException:
    vim.command("echohl WarningMsg | echo \"Unknown method?!\"
                \ | echohl None")
except:
    vim.command("echohl WarningMsg | echo \"Unknown exception! 
                \Checking your python evironment please!\"
                \ | echohl None")
EOF
endfunction
" }}}1

" ---------------------------------------------------------------------
" VolumeDown {{{1 
function! s:VolumeDown()
python << EOF
import dbus
import vim

try:
    # get global variable 
    fact = vim.eval("g:amarok_volume_factor")
    bus = dbus.SessionBus()
    amarok = bus.get_object("org.kde.amarok",
                "/Player")

    amarok.VolumeDown(int(fact))
except dbus.exceptions.DBusException:
    vim.command("echohl WarningMsg | echo \"amarok not launch!\"
                \ | echohl None")
except dbus.exceptions.UnknownMethodException:
    vim.command("echohl WarningMsg | echo \"Unknown method?!\"
                \ | echohl None")
except:
    vim.command("echohl WarningMsg | echo \"Unknown exception! 
                \Checking your python evironment please!\"
                \ | echohl None")
EOF
endfunction
" }}}1

" ---------------------------------------------------------------------
" VolumeUp {{{1 
function! s:VolumeUp()
python << EOF
import dbus
import vim

try:
    # get global variable 
    fact = vim.eval("g:amarok_volume_factor")
    bus = dbus.SessionBus()
    amarok = bus.get_object("org.kde.amarok",
                "/Player")

    amarok.VolumeUp(int(fact))
except dbus.exceptions.DBusException:
    vim.command("echohl WarningMsg | echo \"amarok not launch!\"
                \ | echohl None")
except dbus.exceptions.UnknownMethodException:
    vim.command("echohl WarningMsg | echo \"Unknown method?!\"
                \ | echohl None")
except:
    vim.command("echohl WarningMsg | echo \"Unknown exception! 
                \Checking your python evironment please!\"
                \ | echohl None")
EOF
endfunction
" }}}1

" ---------------------------------------------------------------------
" Play {{{1 
function! s:Play()
python << EOF
import dbus
import vim

try:
    bus = dbus.SessionBus()
    amarok = bus.get_object("org.kde.amarok",
                "/Player")
    amarok.Play()
except dbus.exceptions.DBusException:
    vim.command("echohl WarningMsg | echo \"amarok not launch!\"
                \ | echohl None")
except dbus.exceptions.UnknownMethodException:
    vim.command("echohl WarningMsg | echo \"Unknown method?!\"
                \ | echohl None")
except:
    vim.command("echohl WarningMsg | echo \"Unknown exception! 
                \Checking your python evironment please!\"
                \ | echohl None")

EOF
endfunction
" }}}1

" ---------------------------------------------------------------------
" Pause {{{1 
function! s:Pause()
python << EOF
import dbus
import vim

try:
    bus = dbus.SessionBus()
    amarok = bus.get_object("org.kde.amarok",
                "/Player")

    amarok.Pause()
except dbus.exceptions.DBusException:
    vim.command("echohl WarningMsg | echo \"amarok not launch!\"
                \ | echohl None")
except dbus.exceptions.UnknownMethodException:
    vim.command("echohl WarningMsg | echo \"Unknown method?!\"
                \ | echohl None")
except:
    vim.command("echohl WarningMsg | echo \"Unknown exception! 
                \Checking your python evironment please!\"
                \ | echohl None")
EOF
endfunction
" }}}1

" ---------------------------------------------------------------------
" Next {{{1 
function! s:Next()
python << EOF
import dbus
import vim

try:
    bus = dbus.SessionBus()
    amarok = bus.get_object("org.kde.amarok",
                "/Player")

    amarok.Next()
except dbus.exceptions.DBusException:
    vim.command("echohl WarningMsg | echo \"amarok not launch!\"
                \ | echohl None")
except dbus.exceptions.UnknownMethodException:
    vim.command("echohl WarningMsg | echo \"Unknown method?!\"
                \ | echohl None")
except:
    vim.command("echohl WarningMsg | echo \"Unknown exception! 
                \Checking your python evironment please!\"
                \ | echohl None")
EOF
    " do update
    doautocmd CursorHold
endfunction
" }}}1

" ---------------------------------------------------------------------
" Prev {{{1 
function! s:Prev()
python << EOF
import dbus
import vim

try:
    bus = dbus.SessionBus()
    amarok = bus.get_object("org.kde.amarok",
                "/Player")

    amarok.Prev()
except dbus.exceptions.DBusException:
    vim.command("echohl WarningMsg | echo \"amarok not launch!\"
                \ | echohl None")
except dbus.exceptions.UnknownMethodException:
    vim.command("echohl WarningMsg | echo \"Unknown method?!\"
                \ | echohl None")
except:
    vim.command("echohl WarningMsg | echo \"Unknown exception! 
                \Checking your python evironment please!\"
                \ | echohl None")
EOF
    " do update
    doautocmd CursorHold
endfunction
" }}}1

" ---------------------------------------------------------------------
" Stop {{{1 
function! s:Stop()
python << EOF
import dbus
import vim

try:
    bus = dbus.SessionBus()
    amarok = bus.get_object("org.kde.amarok",
                "/Player")

    amarok.Stop()
except dbus.exceptions.DBusException:
    vim.command("echohl WarningMsg | echo \"amarok not launch!\"
                \ | echohl None")
except dbus.exceptions.UnknownMethodException:
    vim.command("echohl WarningMsg | echo \"Unknown method?!\"
                \ | echohl None")
except:
    vim.command("echohl WarningMsg | echo \"Unknown exception! 
                \Checking your python evironment please!\"
                \ | echohl None")
EOF
endfunction
" }}}1

" ---------------------------------------------------------------------
" Mute {{{1 
function! s:ToggleMute()
python << EOF
import dbus
import vim

try:
    bus = dbus.SessionBus()
    amarok = bus.get_object("org.kde.amarok",
                "/Player")

    amarok.Mute()
except dbus.exceptions.DBusException:
    vim.command("echohl WarningMsg | echo \"amarok not launch!\"
                \ | echohl None")
except dbus.exceptions.UnknownMethodException:
    vim.command("echohl WarningMsg | echo \"Unknown method?!\"
                \ | echohl None")
except:
    vim.command("echohl WarningMsg | echo \"Unknown exception! 
                \Checking your python evironment please!\"
                \ | echohl None")
EOF
endfunction
" }}}1

" ---------------------------------------------------------------------
" ToggleRepeat {{{1 
function! s:ToggleRepeat()
python << EOF
import dbus
import vim

try:
    bus = dbus.SessionBus()
    amarok = bus.get_object("org.kde.amarok",
                "/Player")

    # get Repeat mode status
    stats = amarok.GetStatus()
    # (0,0,0[repeat],0) the repeat mode in third
    stats = stats[2]
    if stats == 1:
        amarok.Repeat(False)
        vim.command("echohl Question | 
                    \ echo \"Amarok: Repeat OFF\" | echohl None")
    elif stats == 0:
        amarok.Repeat(True)
        vim.command("echohl WarningMsg | 
                    \ echo \"Amarok: Repeat ON\" | echohl None")
except dbus.exceptions.DBusException:
    vim.command("echohl WarningMsg | echo \"amarok not launch!\"
                \ | echohl None")
except dbus.exceptions.UnknownMethodException:
    vim.command("echohl WarningMsg | echo \"Unknown method?!\"
                \ | echohl None")
except:
    vim.command("echohl WarningMsg | echo \"Unknown exception! 
                \Checking your python evironment please!\"
                \ | echohl None")
EOF
endfunction
" }}}1

" ---------------------------------------------------------------------
" GetMetadata {{{1 
" FIXME: We need a better format to display.
function! s:GetMetadata()
python << EOF
import dbus
import vim

try:
    bus = dbus.SessionBus()
    amarok = bus.get_object("org.kde.amarok",
                "/Player")

    metadict = amarok.GetMetadata()
    for k, v in metadict.iteritems():
        print k, v
except dbus.exceptions.DBusException:
    vim.command("echohl WarningMsg | echo \"amarok not launch!\"
                \ | echohl None")
except dbus.exceptions.UnknownMethodException:
    vim.command("echohl WarningMsg | echo \"Unknown method?!\"
                \ | echohl None")
except:
    vim.command("echohl WarningMsg | echo \"Unknown exception! 
                \Checking your python evironment please!\"
                \ | echohl None")
EOF
endfunction
" }}}1

" ---------------------------------------------------------------------
" Forward {{{1 
function! s:Forward()
python << EOF
import dbus
import vim

try:
    # get global variable 
    fact = vim.eval("g:amarok_track_factor")
    bus = dbus.SessionBus()
    amarok = bus.get_object("org.kde.amarok",
                "/Player")

    amarok.Forward(int(fact))
except dbus.exceptions.DBusException:
    vim.command("echohl WarningMsg | echo \"amarok not launch!\"
                \ | echohl None")
except dbus.exceptions.UnknownMethodException:
    vim.command("echohl WarningMsg | echo \"Unknown method?!\"
                \ | echohl None")
except:
    vim.command("echohl WarningMsg | echo \"Unknown exception! 
                \Checking your python evironment please!\"
                \ | echohl None")
EOF

" then show the position
call s:PositionGet()
endfunction
" }}}1

" ---------------------------------------------------------------------
" Backward {{{1 
function! s:Backward()
python << EOF
import dbus
import vim

try:
    # get global variable 
    fact = vim.eval("g:amarok_track_factor")
    bus = dbus.SessionBus()
    amarok = bus.get_object("org.kde.amarok",
                "/Player")

    amarok.Backward(int(fact))
except dbus.exceptions.DBusException:
    vim.command("echohl WarningMsg | echo \"amarok not launch!\"
                \ | echohl None")
except dbus.exceptions.UnknownMethodException:
    vim.command("echohl WarningMsg | echo \"Unknown method?!\"
                \ | echohl None")
except:
    vim.command("echohl WarningMsg | echo \"Unknown exception! 
                \Checking your python evironment please!\"
                \ | echohl None")
EOF

" then show the position
call s:PositionGet()
endfunction
" }}}1


" ---------------------------------------------------------------------
" PositionGet {{{1 
function! s:PositionGet()
python << EOF
import dbus
import vim

try:
    bus = dbus.SessionBus()
    amarok = bus.get_object("org.kde.amarok",
                "/Player")

    # we should get the length of first, so that we can
    # compute the position of the indicator.
    meta_data = amarok.GetMetadata()
    track_len = meta_data['mtime']
    curr_len = amarok.PositionGet()

    # convert to a human friendly format
    rate = int((float(curr_len) / float(track_len)) * 100)
    # min:sec.x keep on dot
    track = str(track_len / (60 * 1000)) + ":" + str((track_len % (60 * 1000)) / 1000) 
                \ + "." + str((track_len % 1000) / 100) 
    curr = str(curr_len / (60 * 1000)) + ":" + str((curr_len % (60 * 1000)) / 1000)
                \ + "." + str((curr_len % 1000) / 100) 
    # print in a human readable format
    vim.command("echohl WarningMsg |
                \ echo \"Audio:" + curr + " of " + track + " %" + str(rate) + "\"
                \ | echohl None")
except dbus.exceptions.DBusException:
    vim.command("echohl WarningMsg | echo \"amarok not launch!\"
                \ | echohl None")
except dbus.exceptions.UnknownMethodException:
    vim.command("echohl WarningMsg | echo \"Unknown method?!\"
                \ | echohl None")
except:
    vim.command("echohl WarningMsg | echo \"Unknown exception! 
                \Checking your python evironment please!\"
                \ | echohl None")
EOF
endfunction
" }}}1

" ---------------------------------------------------------------------
" StopAfterCurrent {{{1 
function! s:StopAfterCurrent()
python << EOF
import dbus
import vim

try:
    bus = dbus.SessionBus()
    amarok = bus.get_object("org.kde.amarok",
                "/Player")

    amarok.StopAfterCurrent()
except dbus.exceptions.DBusException:
    vim.command("echohl WarningMsg | echo \"amarok not launch!\"
                \ | echohl None")
except dbus.exceptions.UnknownMethodException:
    vim.command("echohl WarningMsg | echo \"Unknown method?!\"
                \ | echohl None")
except:
    vim.command("echohl WarningMsg | echo \"Unknown exception! 
                \Checking your python evironment please!\"
                \ | echohl None")
EOF
endfunction
" }}}1

" ---------------------------------------------------------------------
" the global commands {{{1

command! AmarokShowOSD          call s:ShowOSD()
command! AmarokVolumeDown       call s:VolumeDown()
command! AmarokVolumeUp         call s:VolumeUp()
command! AmarokPlay             call s:Play()
command! AmarokPause            call s:Pause()
command! AmarokNext             call s:Next()
command! AmarokPrev             call s:Prev()
command! AmarokStop             call s:Stop()
command! AmarokToggleMute       call s:ToggleMute()
command! AmarokToggleRepeat     call s:ToggleRepeat()
command! AmarokGetMetadata      call s:GetMetadata()
command! AmarokPositionGet      call s:PositionGet()
command! AmarokForward          call s:Forward()
command! AmarokBackward         call s:Backward()
command! AmarokStopAfterCurrent call s:StopAfterCurrent()
" }}}1

"======================================================================
" org.kde.amarok
" /TrackList
"======================================================================

" ---------------------------------------------------------------------
" Global variables {{{1
if !exists('g:amarok_playlist_width')
    let g:amarok_playlist_width = 30
endif
" default is right side 
if !exists('g:amarok_playlist_left')
    let g:amarok_playlist_left = 0
endif
" }}}1


" ---------------------------------------------------------------------
" script variables {{{1
let s:amarok_current_track = ""
let s:amarok_current_pos = 1
" }}}1

" ---------------------------------------------------------------------
" DisPlayList {{{1
function! s:DisPlayList()
python << EOF
import dbus
import vim

try:
    # get the playlist buffer
    curb = vim.current.buffer
    bus = dbus.SessionBus()
    amarok = bus.get_object("org.kde.amarok",
                "/TrackList")
    # first, get total tracks
    track_len = amarok.GetLength()
    for i in range(track_len):
        info = amarok.GetMetadata(i)
        title = info['title']
        curb.append(str(i + 1) + ":" + title.encode('utf-8'))

except dbus.exceptions.DBusException:
    vim.command("echohl WarningMsg | echo \"amarok not launch!\"
                \ | echohl None")
except dbus.exceptions.UnknownMethodException:
    vim.command("echohl WarningMsg | echo \"Unknown method?!\"
                \ | echohl None")
except:
    vim.command("echohl WarningMsg | echo \"Unexpected eception!\"
                \ | echohl None")

EOF
endfunction
" }}}1

" ---------------------------------------------------------------------
" UpdateStatus {{{1
"   Get current track, then highlight it.
function! s:UpdateStatus()
    call s:GetCurrentTrack()
    "echo s:amarok_current_track
    exe s:amarok_current_pos
    highlight MyGroup ctermbg=green guibg=green
    execute "match MyGroup /" . s:amarok_current_track . "/"
    redraw
endfunction
" }}}1

" ---------------------------------------------------------------------
" GetCurrentTrack {{{1
function! s:GetCurrentTrack()
python << EOF
import dbus
import vim

try:
    bus = dbus.SessionBus()
    amarok = bus.get_object("org.kde.amarok",
                "/TrackList")
    cur = amarok.GetCurrentTrack()
    meta = amarok.GetMetadata(cur)
    title = meta['title']
    vim.command("let s:amarok_current_track = \"" + str(cur + 1) 
                \+ ":" + title.encode('utf-8') + "\"")
    vim.command("let s:amarok_current_pos = " + str(cur + 1)) 
except dbus.exceptions.DBusException:
    vim.command("echohl WarningMsg | echo \"amarok not launch!\"
                \ | echohl None")
except dbus.exceptions.UnknownMethodException:
    vim.command("echohl WarningMsg | echo \"Unknown method?!\"
                \ | echohl None")
except:
    vim.command("echohl WarningMsg | echo \"Unexpected eception!\"
                \ | echohl None")

EOF
endfunction
" }}}1

" ---------------------------------------------------------------------
" PlayTrack {{{1
let s:amarok_play_track_num = 0
function! s:PlayTrack()
    let s:amarok_play_track_num = line('.')
python << EOF
import dbus
import vim

try:
    bus = dbus.SessionBus()
    amarok = bus.get_object("org.kde.amarok",
                "/TrackList")
    line = vim.eval('s:amarok_play_track_num')
    amarok.PlayTrack(int(line))
except dbus.exceptions.DBusException:
    vim.command("echohl WarningMsg | echo \"amarok not launch!\"
                \ | echohl None")
except dbus.exceptions.UnknownMethodException:
    vim.command("echohl WarningMsg | echo \"Unknown method?!\"
                \ | echohl None")
except:
    vim.command("echohl WarningMsg | echo \"Unexpected eception!\"
                \ | echohl None")

EOF
endfunction
" }}}1

" ---------------------------------------------------------------------
" ToggleLoop {{{1 
function! s:ToggleLoop()
python << EOF
import dbus
import vim

try:
    bus = dbus.SessionBus()
    amarok = bus.get_object("org.kde.amarok",
                "/Player")

    # get Loop mode status
    stats = amarok.GetStatus()
    # (0,0,0,0[loop]) the repeat mode in third
    stats = stats[3]
    amarok = bus.get_object("org.kde.amarok",
                "/TrackList")
    if stats == 1:
        amarok.SetLoop(False)
        vim.command("echohl Question | 
                    \ echo \"Amarok: Loop OFF\" | echohl None")
    elif stats == 0:
        amarok.SetLoop(True)
        vim.command("echohl WarningMsg | 
                    \ echo \"Amarok: Loop ON\" | echohl None")
except dbus.exceptions.DBusException:
    vim.command("echohl WarningMsg | echo \"amarok not launch!\"
                \ | echohl None")
except dbus.exceptions.UnknownMethodException:
    vim.command("echohl WarningMsg | echo \"Unknown method?!\"
                \ | echohl None")
except:
    vim.command("echohl WarningMsg | echo \"Unknown exception! 
                \Checking your python evironment please!\"
                \ | echohl None")
EOF
endfunction
" }}}1

" ---------------------------------------------------------------------
" ToggleRandom {{{1 
function! s:ToggleRandom()
python << EOF
import dbus
import vim

try:
    bus = dbus.SessionBus()
    amarok = bus.get_object("org.kde.amarok",
                "/Player")

    # get Random mode status
    stats = amarok.GetStatus()
    # (0,0[random],0,0) the repeat mode in third
    stats = stats[1]

    amarok = bus.get_object("org.kde.amarok",
                "/TrackList")
    if stats == 1:
        amarok.SetRandom(False)
        vim.command("echohl Question | 
                    \ echo \"Amarok: Random OFF\" | echohl None")
    elif stats == 0:
        amarok.SetRandom(True)
        vim.command("echohl WarningMsg | 
                    \ echo \"Amarok: Random ON\" | echohl None")
except dbus.exceptions.DBusException:
    vim.command("echohl WarningMsg | echo \"amarok not launch!\"
                \ | echohl None")
except dbus.exceptions.UnknownMethodException:
    vim.command("echohl WarningMsg | echo \"Unknown method?!\"
                \ | echohl None")
except:
    vim.command("echohl WarningMsg | echo \"Unknown exception! 
                \Checking your python evironment please!\"
                \ | echohl None")
EOF
endfunction
" }}}1
"======================================================================
" Below code from Tagbar & taglist.
" Thanks the authors of Tagbar & taglist:
" Jan Larres & Yegappan Lakshmanan
"======================================================================
" script variables {{{1
let s:autocommands_done = 0

" Initialization {{{1 

" s:CreateAutocommands() {{{2
function! s:CreateAutocommands() abort
    augroup PlayListAutoCmds
        autocmd!
        autocmd BufEnter  __PlayList__ nested call s:QuitIfOnlyWindow()
        autocmd CursorHold * call s:AutoUpdate()
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

    let openpos = g:amarok_playlist_left ? 'topleft vertical ' : 'botright vertical '
    exe 'silent keepalt ' . openpos . g:amarok_playlist_width . 'split ' . '__PlayList__'

    let &eventignore = eventignore_save

    call s:InitWindow()

    call s:winexec('wincmd p')

    " update play list
    call s:UpdatePlayList()

    " do auto update
    doautocmd CursorHold

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

    call s:MapKeys()
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

" s:UpdatePlayList() {{{2
function! s:UpdatePlayList() abort
    let winnr = bufwinnr('__PlayList__')
    if winnr == -1
        return
    endif

    " append playlist to the right window, then jump back.
    " get current window number
    let savewin = bufwinnr('%')
    call s:winexec(winnr . 'wincmd w')
    setlocal modifiable
    call s:DisPlayList()
    0,1d
    setlocal nomodifiable

    " jump back
    call s:winexec(savewin . 'wincmd w')
endfunction

" s:AutoUpdate() {{{2
function! s:AutoUpdate() abort
    let winnr = bufwinnr('__PlayList__')
    if winnr == -1
        return
    endif

    " UpdaetStatus
    " get current window number
    let savewin = bufwinnr('%')
    call s:winexec(winnr . 'wincmd w')
    call s:UpdateStatus()

    " jump back
    call s:winexec(savewin . 'wincmd w')

endfunction

" Map keys {{{2
function! s:MapKeys() abort
    nnoremap <script> <silent> <buffer> >    :call <SID>Next()<CR>
    nnoremap <script> <silent> <buffer> <    :call <SID>Prev()<CR>
    nnoremap <script> <silent> <buffer> ]    :call <SID>Forward()<CR>
    nnoremap <script> <silent> <buffer> [    :call <SID>Backward()<CR>
    nnoremap <script> <silent> <buffer> +    :call <SID>VolumeUp()<CR>
    nnoremap <script> <silent> <buffer> -    :call <SID>VolumeDown()<CR>
    nnoremap <script> <silent> <buffer> p    :call <SID>Play()<CR>
    nnoremap <script> <silent> <buffer> s    :call <SID>Stop()<CR>
    nnoremap <script> <silent> <buffer> r    :call <SID>ToggleRepeat()<CR>
    nnoremap <script> <silent> <buffer> m    :call <SID>ToggleMute()<CR>
    nnoremap <script> <silent> <buffer> o    :call <SID>ShowOSD()<CR>
    nnoremap <script> <silent> <buffer> $    :call <SID>StopAfterCurrent()<CR>
    nnoremap <script> <silent> <buffer> L    :call <SID>ToggleLoop()<CR>
    nnoremap <script> <silent> <buffer> R    :call <SID>ToggleRandom()<CR>
    nnoremap <script> <silent> <buffer> <CR>    :call <SID>PlayTrack()<CR>
    nnoremap <script> <silent> <buffer> <Space>    :call <SID>Pause()<CR>
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
