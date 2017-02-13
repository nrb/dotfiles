" This vimrc uses folds
"
" zR    open all folds
" zM    close all folds
" za    toggle fold at cursor position
" zj    move down to start of next fold
" zk    move up to end of previous fold

" vimrc command and mapping quick reference                    {{{1
" -----------------------------------------------------------------
"
" This is your vim configuration file. There are some shortcuts set
" up for you by default.  Here are the highlights:
"
" The mapleader has been switched from '\' to ',' anytime you see
" <leader> that is what this refers to.
"
"    <leader>t       -- opens the fuzzy finder coverage mode
"    <leader>h       -- toggles the highlight search
"    <leader>n       -- toggles the line numbers
"    <leader>a       -- starts an ack search in the CWD
"    <leader>T       -- Open new buffer
"    <leader>i       -- toggles invisible characters
"    <leader>\       -- toggle line wrapping
"    <leader>y       -- show the yankring
"    <leader><Enter> -- opens a line at the current column (this is
"                       the reverse of J)
"    <leader>c       -- Switch between light and dark colors
"    <leader>n       -- Switch to next buffer
"    <leader>p       -- Switch to previous buffer
"    jj              -- alternative to <ESC>
"    ;               -- alternative to :
"    ctrl + tab      -- cycle through buffers/tabs
"    <Enter>         -- open a new line (non-insert)
"    <S-Enter>       -- open a new line above (non-insert)
"    <leader>s       -- Toggle spell checking
"    <F2>            -- Toggle smart indent on paste
"    CTRL-=          -- Make the current window taller
"    CTRL-- (CTRL-DASH) -- Make the current window shorter
"
" I have set up some custom commands that might be of interest
"
"    MarkdownToHTML  -- Converts the current buffer into HTML and
"                       places it in a scratch buffer.
"    MarkdownToHTMLCopy -- Same as previous, but copies to clipboard
"    Shell           -- Runs a shell command and places it in the
"                       scratch buffer
"    TidyXML         -- Runs tidy in XML mode on the current buffer
"    TabStyle        -- Set the tab style and number, :TabStyle space 4
"    TerminalHere    -- Opens the terminal to the directory of the
"                       current buffer

" General setting                                              {{{1
" -----------------------------------------------------------------

" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
" across (heterogeneous) systems easier.
if has('win32') || has('win64')
  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

" FreeBSD security advisory for this one...
set nomodeline

" This setting prevents vim from emulating the original vi's
" bugs and limitations.
set nocompatible

" Set up pathogen
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
execute pathogen#infect()

" set the mapleader key
let mapleader = ","
let g:mapleader = ","

" set the default encoding
set enc=utf-8

" only increment numbers and letters
set nrformats=""

" Set the shell to sh, zsh and vim don't seem to play nice
set shell=sh

" set up jj as mode switch
map! jj <ESC>

" hide the backup and swap files
set backupdir=~/.backup/vim,.,/tmp
set directory=~/.backup/vim/swap,.,/tmp
set backupskip=/tmp/*,/private/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*

" have fifty lines of command-line (etc) history:
set history=1000

if has('mouse')
    " have the mouse enabled all the time
    set mouse=a
    " make a menu popup on right click
    set mousemodel=popup
endif

" allow for switching buffers when a file has changes
set hidden

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" The first setting tells vim to use "autoindent" (that is, use the current
" line's indent level to set the indent level of new lines). The second makes
" vim attempt to intelligently guess the indent level of any new line based on
" the previous line.
set autoindent
set smartindent

" Visual settings                                              {{{1
" -----------------------------------------------------------------

" tell the bell to go beep itself!
set visualbell t_vb=

" Enhanced command menu ctrl + d to expand directories
set wildmenu
" list completions, then cycle through them
set wildmode=list:longest,full
set wildignore+=*.pyc,*.pyo,CVS,.svn,.git,*.mo,.DS_Store,*.pt.cache,*.Python,*.o,*.lo,*.la,*~,.AppleDouble
"
" turn on spell checking
"set spell spelllang=en_us
map <silent> <leader>s :set spell!<CR>

" This setting will cause the cursor to very briefly jump to a 
" brace/parenthese/bracket's "match" whenever you type a closing or 
" opening brace/parenthese/bracket.
set showmatch

" Display an incomplete command in the lower right corner of the Vim window
set showcmd

" Set a margin of lines when scrolling
set scrolloff=4

" This setting ensures that each window contains a statusline that displays the
" current cursor position.
set ruler

" set a custom status line similar to that of ":set ruler"
"set statusline=\ \ \ \ \ line:%l\ column:%c\ \ \ %M%Y%r%=%-14.(%t%)\ %p%%
" show the statusline in all windows
set laststatus=2

" turn on line numbers, aww yeah
set number
" Use raw line numbers on insert, relative in normal mode.
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

"
" By default, vim doesn't let the cursor stray beyond the defined text. This 
" setting allows the cursor to freely roam anywhere it likes in command mode.
" It feels weird at first but is quite useful.
"set virtualedit=all

" Scroll in smaller increments when going horizontal
set sidescroll=5

" Set the characters showing horizontal scrolling
set listchars+=precedes:←,extends:→

" toggle line wrapping on/off
map <silent> <leader>\ :set wrap!<CR>

" Pasting                                                      {{{1
" -----------------------------------------------------------------

" turn off smart indentation when pasting
set pastetoggle=<F2>

" Searching                                                    {{{1
" -----------------------------------------------------------------

" find as you type
set incsearch
" highlight the terms
set hlsearch
" make searches case-insensitive
set ignorecase
" unless they contain upper-case letters
set smartcase
" a toggle for search highlight
map <silent> <leader>h :set hlsearch!<CR>

" Colors and Syntax                                            {{{1
" -----------------------------------------------------------------

set background=dark
" turn on syntax highlighting
syntax on

" highlight all python syntax
let python_highlight_all=1

" gui and terminal compatible color scheme
set t_Co=256

" set global variables that will define the colorscheme
let g:light_theme='solarized'
let g:dark_theme='solarized'

" Use the "original" molokai theme colors instead of "dark"
let g:molokai_original=1

" Command to call the ColorSwitch funciton
command! -nargs=? -complete=customlist,s:completeColorSchemes ColorSwitcher :call s:colorSwitch(<q-args>)

" A function to toggle between light and dark colors
function! s:colorSwitch(...)
    " function to switch colorscheme
    function! ChangeMe(theme)
        execute('colorscheme '.a:theme)
        try
            execute('colorscheme '.a:theme.'_custom')
        catch /E185:/
            " There was no '_custom' scheme...
        endtry
    endfunction

    " Change to the specified theme
    if eval('a:1') != ""
        " check to see if we are passing in an existing var
        if exists(a:1)
            call ChangeMe(eval(a:1))
        else
            call ChangeMe(a:1)
        endif
        return
    endif

    " Toggle between a light and dark vim colorscheme
    if &background == 'dark'
        set background=light
        call ChangeMe(g:light_theme)
    elseif &background == 'light'
        set background=dark
        call ChangeMe(g:dark_theme)
    endif
endfunction

" completion function for colorscheme names
function! s:completeColorSchemes(A,L,P)
    let colorscheme_names = []
    for i in split(globpath(&runtimepath, "colors/*.vim"), "\n")
        let colorscheme_name = fnamemodify(i, ":t:r")
        if stridx(colorscheme_name, "_custom") < 0
            call add(colorscheme_names, colorscheme_name)
        endif
    endfor
    return filter(colorscheme_names, 'v:val =~ "^' . a:A . '"')
endfunction


" set the colorscheme
if hostname() == "Nolans-MacBook-Pro.local"
    call s:colorSwitch(g:light_theme)
else
    call s:colorSwitch(g:dark_theme)
endif

" switch between light and dark colors
map <silent> <leader>c :ColorSwitcher<CR>



" Custom functions and commands                                {{{1
" -----------------------------------------------------------------

" Tabs and spaces                                              {{{2
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" command to switch tab styles
command! -nargs=+ TabStyle :call s:TabChanger(<f-args>)

" function to switch between tabs and spaces
" initial idea taken from:
" http://github.com/twerth/dotfiles/blob/master/etc/vim/vimrc
function! s:TabChanger(...)
    let l:tab_type = a:1
    if !exists('a:2')
        let l:tab_length = 4
    else
        let l:tab_length = a:2
    endif
    exec 'set softtabstop=' . l:tab_length
    exec 'set shiftwidth=' . l:tab_length
    exec 'set tabstop=' . l:tab_length
    if l:tab_type == "space"
        set expandtab
    elseif l:tab_type =="tab"
        set noexpandtab
    endif
endfunction

TabStyle space 4

" Shell as scratch buffer                                      {{{2
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" function to run shell commands and create a scratch buffer (modified
" slightly so that it doesn't show the command and it's interpretation)
" http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window
" Example, show output of ls in a scratch buffer:
"
" :Shell ls -al
"
command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = '"'.fnameescape(expand(part)).'"'
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1,substitute(getline(1),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction

" Whitespace                                                   {{{2
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" A function to strip trailing whitespace and clean up afterwards so
" that the search history remains intact and cursor does not move.
" Taken from: http://vimcasts.org/episodes/tidying-whitespace
function! StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

" Markdown                                                     {{{2
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" run markdown on the current file and place the html in a scratch buffer
command! -nargs=0 MarkdownToHTML  call s:RunShellCommand('Markdown.pl %')
" replace the current buffer with the html version of the markdown
command! -nargs=0 MarkdownToHTMLReplace  %!Markdown.pl "%"
" copy the html version of the markdown to the clipboard (os x)
command! -nargs=0 MarkdownToHTMLCopy  !Markdown.pl "%" | pbcopy
" use pandoc to convert from html into markdown
command! -nargs=0 MarkdownFromHTML  %!pandoc -f html -t markdown "%"


" Open a buffer number in a vertical split                     {{{2
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Vertical Split Buffer Function
function! VerticalSplitBuffer(buffer)
    execute "vert belowright sb" a:buffer
endfunction

" Vertical Split Buffer Mapping
command! -nargs=1 Vbuffer call VerticalSplitBuffer(<f-args>)


" Plugins                                                      {{{1
" -----------------------------------------------------------------

" turn on filetype checking for plugins like pyflakes
filetype on                " enables filetype detection
filetype plugin indent on  " enables filetype specific plugins

" Ack                                                          {{{2
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" shortcut for ack search
map <leader>a :Ack!<Space>


" Dpaste                                                      {{{2
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
map <leader>L :Dpaste<CR>


" syntastic                                                    {{{2
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Enable signs support to visually see where errors/warnings appear
let g:syntastic_enable_signs=1
" Automatically open the location list when there are errors
let g:syntastic_auto_loc_list=0

" Flake8                                                       {{{2
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" Don't worry about line length
let g:flake8_max_line_length=110

let g:flake8_cmd="/usr/local/share/python/flake8"

" Yankring                                                     {{{2
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Show and hide the yankring history
nnoremap <silent> <leader>y :YRShow<CR>
" Set the maximum number of history
let g:yankring_max_history = 200
" Make the yankring set the numbered registers
let g:yankring_manage_numbered_reg = 1
" don't leave the history in my home dir
let g:yankring_history_dir = '$HOME/.backup/vim'

let g:loaded_delimitMate = 1


" Auto command settings                                        {{{1
" -----------------------------------------------------------------

if has("autocmd")
    " shell files
    au BufNewFile,BufRead .common* set filetype=sh

    " Vagrant files
    au BufNewFile,BufRead Vagrantfile set filetype=ruby


    au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm,*.jinja2 set ft=jinja

    " Misc. Files
    au BufRead,BufNewFile *.fountain set filetype=fountain
endif

" Cursor and window controls                                   {{{1
" -----------------------------------------------------------------

" Make cursor move by visual lines instead of file lines (when wrapping)
" This makes me feel more at home :)
map <up> gk
map k gk
imap <up> <C-o>gk
map <down> gj
map j gj
imap <down> <C-o>gj
map E ge

" window resizing
if bufwinnr(1)
  map + <C-W>+
  map - <C-W>-
endif

" Insert newlines with enter and shift + enter
map <S-Enter> O<ESC>
map <Enter> o<ESC>
" open a new line from the current spot (sort of the opposite of J)
map <leader><Enter> i<CR><ESC>

" sort versions in a versions.cfg
map <leader>V /\[versions\]<CR>jVG:g/^#/d<CR>gv:g/^$/d<CR>gv:sort i<CR>

" set up the invisible characters
set listchars+=tab:▸\ ,eol:¬
" show invisible characters by default
set list
" toggle invisible characters
noremap <silent> <leader>i :set list!<CR>

" Window management settings                                    {{{1
" -----------------------------------------------------------------

" Mapping window commands directly
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" GUI settings                                                 {{{1
" -----------------------------------------------------------------

if has("gui_running")

    " turn off the cursor blinking (who thinks that is a good idea?)
    "set guicursor+=a:blinkon0

    " Default size of window
    set columns=145
    set lines=45
    
    " automagically open NERDTree in a GUI
    autocmd VimEnter * exe 'NERDTreeToggle' | wincmd l
    " close the NERDTree when opening it's all text and vimperator
    " editors
    autocmd VimEnter,BufNewFile,BufRead /*/itsalltext/* exe 'NERDTreeClose'
    autocmd VimEnter,BufNewFile,BufRead /*/itsalltext/* set nospell

    " OS Specific
    if has("gui_macvim")
        "set fuoptions=maxvert,maxhorz " fullscreen options (MacVim only), resized window when changed to fullscreen
        set guifont=Ubuntu\ Mono:h10
        set guioptions-=T " remove toolbar
    endif

endif

" vim-airline                                                  {{{1
" -----------------------------------------------------------------
" Disable ctags support.
let g:airline#extensions#tagbar#enabled = 0

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
 let g:airline#extensions#tabline#fnamemod = ':t'

" Buffer shortcuts                                             {{{1
" -----------------------------------------------------------------
" Better buffer controls
" Open a new empty buffer
nmap <leader>T :enew<cr>

nmap <leader>n :bnext<cr>
nmap <leader>p :bprevious<cr>

" Remap ^z to suspend the session, the redraw on resume. Should fix drawing
" issues in tmux and doing ^z/fg
noremap ^z :suspend<bar>:redraw!<cr>

" turn on folds (must be the last lines in the file)
" vim: fdm=marker
