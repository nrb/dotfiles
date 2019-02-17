autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
map <buffer> <leader>g :GoDecls<CR>
map <buffer> <leader>@ :GoDecls<CR>
map <buffer> <leader>gd :GoDeclsDir 
