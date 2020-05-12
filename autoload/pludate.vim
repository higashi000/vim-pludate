let s:save_cpo = &cpo
set cpo&vim

function pludate#getNowDate()
   let s:V = vital#pludate#new()
   let s:DATETIME = s:V.import('DateTime')
   let s:J = s:V.import('Web.JSON')

   let l:date = {'month': s:DATETIME.now().month(), 'day': s:DATETIME.now().day()}

   return l:date
endfunction

function pludate#readPreviousUpdate()
   if !exists('g:pludateConfigPath')
      let g:pludateConfigPath = $HOME.'/.vim/'
   endif

   let s:V = vital#pludate#new()
   let s:J = s:V.import('Web.JSON')

   let l:pludateConfig = readfile(g:pludateConfigPath.'pludateConfig.json')

   return s:J.decode(l:pludateConfig[0])
endfunction

function pludate#update()
   let s:V = vital#pludate#new()
   let s:J = s:V.import('Web.JSON')

   if !exists('g:pludateInterval')
      let g:pludateInterval = 7
   endif

   if !exists('g:pludateConfigPath')
      let g:pludateConfigPath = $HOME.'/.vim/'
   endif

   let l:nowDate = pludate#getNowDate()
   let l:previousUpdate = pludate#readPreviousUpdate()

   let month31 = [1, 3, 5, 7, 8, 10, 12]
   let month30 = [4, 6, 9, 11]

   let l:encodeDate = [s:J.encode(l:nowDate)]
   let l:configPath = g:pludateConfigPath.'pludateConfig.json'

   if l:nowDate['month'] == l:previousUpdate['month']
         if l:nowDate['day'] >= l:previousUpdate['day'] + g:pludateInterval
            call writefile(l:encodeDate, l:configPath)
            return v:true
         else
            return v:false
         endif
   endif

   for month in month31
      if month == l:previousUpdate['month']
         if l:nowDate['day'] + 31 >= l:previousUpdate['day'] + g:pludateInterval
            call writefile(l:encodeDate, l:configPath)
            return v:true
         else
            return v:false
         endif
      endif
   endfor

   for month in month30
      if month == l:previousUpdate['month']
         if l:nowDate['day'] + 30 >= l:previousUpdate['day'] + g:pludateInterval
            call writefile(l:encodeDate, l:configPath)
            return v:true
         else
            return v:false
         endif
      endif
   endfor

   if 2 == l:previousUpdate['month']
         if l:nowDate['day'] + 29 >= l:previousUpdate['day'] + g:pludateInterval
            call writefile(l:encodeDate, l:configPath)
            return v:true
         else
            return v:false
         endif
   endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
