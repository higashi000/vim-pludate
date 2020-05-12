if exists('g:loaded_pludata')
  finish
endif

let g:loaded_pludata = 1
let s:save_cpo = &cpo
set cpo&vim

if pludate#update()
   execute g:pludateUpdateCmd
endif

let &cpo = s:save_cpo
unlet s:save_cpo
