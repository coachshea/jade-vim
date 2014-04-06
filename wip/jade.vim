" Set compiler options
if !exists("g:JadeCompiler")
  let g:JadeCompiler = 'jade -c'
endif
if !exists("g:JadeHtmlCompiler")
  let g:JadeHtmlCompiler = 'jade -P'
endif
let s:filetype = "js"

" Reset the JadeCompile variables for the current buffer.
function! s:JadeCompileResetVars()
  " Compiled output buffer
  let b:jade_compile_buf = -1
  let b:jade_compile_pos = []
endfunction

" Clean things up in the source buffer.
function! s:JadeCompileClose()
  exec bufwinnr(b:jade_compile_src_buf) 'wincmd w'
  silent! autocmd! JadeCompileAuWatch * <buffer>
  call s:JadeCompileResetVars()
endfunction

" Update the JadeCompile buffer given some input lines.
function! s:JadeCompileUpdate(startline, endline)
  let input = join(getline(a:startline, a:endline), "\n")

  " Move to the JadeCompile buffer.
  exec bufwinnr(b:jade_compile_buf) 'wincmd w'

  " Jade doesn't like empty input.
  if !len(input)
    return
  endif

  if s:filetype = 'js'
    let compiler = g:JadeCompiler
  elseif s:filetype = 'html'
    let compiler = g:JadeHtmlCompiler
  endif

  " Compile input.
  let output = system(compiler . ' 2>&1', input)

  " Be sure we're in the JadeCompile buffer before overwriting.
  if exists('b:jade_compile_buf')
    echoerr 'JadeCompile buffers are messed up'
    return
  endif

  " Replace buffer contents with new output and delete the last empty line.
  setlocal modifiable
    exec '% delete _'
    put! =output
    exec '$ delete _'
  setlocal nomodifiable

  " Highlight as JavaScript/html if there is no compile error.
  if v:shell_error
    setlocal filetype=
  elseif s:filetype = "js"
    setlocal filetype=javascript
  elseif s:filetype = "html"
    setlocal filetype=html
  endif

  call setpos('.', b:jade_compile_pos)
endfunction

" Update the JadeCompile buffer with the whole source buffer.
function! s:JadeCompileWatchUpdate()
  call s:JadeCompileUpdate(1, '$')
  exec bufwinnr(b:jade_compile_src_buf) 'wincmd w'
endfunction

" Peek at compiled Jade in a scratch buffer. We handle ranges like this
" to prevent the cursor from being moved (and its position saved) before the
" function is called.
function! s:JadeCompile(startline, endline, args)
  " If in the JadeCompile buffer, switch back to the source buffer and
  " continue.
  if !exists('b:jade_compile_buf')
    exec bufwinnr(b:jade_compile_src_buf) 'wincmd w'
  endif

  " Parse arguments.
  let size = str2nr(matchstr(a:args, '\<\d\+\>'))
  if a:args =~ '\<html\>'
    s:filetype = "html"
  else
    s:filetype = "js"
  endif

  " Determine default split direction.
  if exists('g:jade_compile_vert')
    let vert = 1
  else
    let vert = a:args =~ '\<vert\%[ical]\>'
  endif

  " Remove any watch listeners.
  silent! autocmd! JadeCompileAuWatch * <buffer>

  " Build the JadeCompile buffer if it doesn't exist.
  if bufwinnr(b:jade_compile_buf) == -1
    let src_buf = bufnr('%')
    let src_win = bufwinnr(src_buf)

    " Create the new window and resize it.
    if vert
      let width = size ? size : winwidth(src_win) / 2

      belowright vertical new
      exec 'vertical resize' width
    else
      " Try to guess the compiled output's height.
      let height = size ? size : winheight(src_win) / 2

      belowright new
      exec 'resize' height
    endif

    " We're now in the scratch buffer, so set it up.
    setlocal bufhidden=wipe buftype=nofile
    setlocal nobuflisted nomodifiable noswapfile nowrap

    autocmd BufWipeout <buffer> call s:JadeCompileClose()
    " Save the cursor when leaving the JadeCompile buffer.
    autocmd BufLeave <buffer> let b:jade_compile_pos = getpos('.')

    nnoremap <buffer> <silent> q :hide<CR>

    let b:jade_compile_src_buf = src_buf
    let buf = bufnr('%')

    " Go back to the source buffer and set it up.
    exec bufwinnr(b:jade_compile_src_buf) 'wincmd w'
    let b:jade_compile_buf = buf
  endif

  call s:JadeCompileWatchUpdate()

  augroup JadeCompileAuWatch
    autocmd InsertLeave <buffer> call s:JadeCompileWatchUpdate()
    autocmd BufWritePost <buffer> call s:JadeCompileWatchUpdate()
  augroup END
endfunction


" Don't overwrite variables.
if !exists("s:jade_compile_buf")
  call s:JadeCompileResetVars()
endif

" Peek at compiled Jade. consideration: add -buffer
command! -range=% -bar -nargs=* JadeWatch call s:JadeCompile(<line1>, <line2>, <q-args>)
" Run some Jade.
"command! -range=% -bar JadeHtml <line1>,<line2>:w !jade
"command! -range=% -bar JadeJs <line1>,<line2>:w !jade -c
