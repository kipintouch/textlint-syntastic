
""""""""""""""""""""""""""""""""""""""""""""""""
"                                              "
" Originally written by: DamienCassou/textlint "
" LICENCE APPLY AS PER THE ORIGINAL CREATOR    "
"                                              "
""""""""""""""""""""""""""""""""""""""""""""""""

" TODO:
"   1. Better Error format (problems with %+G and %-G)
"   2. Check with Windows for non-bash (Program)

if exists('g:loaded_syntastic_tex_textlint_checker')     " {{{1
  finish
endif
let g:loaded_syntastic_tex_textlint_checker = 1

function! s:get_textlint()                               " {{{1
  if !exists('s:installDir')
    let s:installDir = ''
    if has('win32') || has('win64')
      let s:os         = "win"
      let s:installDir = expand("$VIM/vimfiles/local/textlint.py")
    elseif has('unix')
      let s:os         = "unix"
      let s:installDir = expand("~/.vim/local/latexlint/textlint.py")
    endif
  endif
  return [s:installDir, s:os]
endf

function! SyntaxCheckers_tex_textlint_IsAvailable() dict " {{{1
  return (len(s:get_textlint()) == 2) && (filereadable(s:get_textlint()[0]))
endf

" Save Local CPO                                         " {{{1
let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_tex_textlint_GetLocList() dict  " {{{1
  " get textlint exe's
    let textlint = s:get_textlint()

  " makeprogram
    let makeprg = self.makeprgBuild({
      \        'exe': 'python ' . textlint[0],
      \  'post_args': textlint[1],
      \   'filetype': 'tex' })

  " errorformat
    let errorformat='%f:%l.%c-%*[0-9.]:\ %m'
    " let errorformat='%f:%l.%c-%*[0-9.]:\ %m %C%+G\	%.%# %C%-G%.%#'

  " process makeprg
    let errors = SyntasticMake({ 'makeprg': makeprg,
        \ 'errorformat': errorformat })

  return errors
endfunction

" Register Textlint                                      " {{{1
call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'tex',
    \     'name': 'textlint' })

" Restore CPO                                            " {{{1
let &cpo = s:save_cpo
unlet s:save_cpo
