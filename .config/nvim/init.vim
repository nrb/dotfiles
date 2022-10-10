" Install plug.vim if it's not already installed.
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" git integration
Plug 'tpope/vim-fugitive'
" builds on fugitive to work with github
Plug 'tpope/vim-rhubarb'
" A simple tab line
Plug 'ap/vim-buftabline'

" Needed for Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
" Better telescope sorting
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" Telescope will use tree-sitter as an info source
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'altercation/vim-colors-solarized'
Plug 'morhetz/gruvbox'

" make typescript a little more livable
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'

Plug 'itspriddle/vim-shellcheck'

Plug 'ray-x/go.nvim'
Plug 'ray-x/guihua.lua'

Plug 'neovim/nvim-lspconfig'
call plug#end()



" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

" -------------------------------------------------------------------------------------------------
" settings
" -------------------------------------------------------------------------------------------------
set hidden " Allow vim to hide buffers rather than completely closing them
filetype on "detect files based on type
filetype plugin on "when a file is edited its plugin file is loaded (if there is one for the 
                   "detected filetype) 
filetype indent on "maintain indentation
set background=dark
colorscheme gruvbox
syntax on

" Format go files on save.
autocmd BufWritePre *.go lua vim.lsp.buf.formatting()
autocmd FileType go setlocal omnifunc=v:lua.vim.lsp.omnifunc
" Fix up go imports on save.
autocmd BufWritePre *.go lua goimports(1000)

" Format js files on save
autocmd BufWritePre *.js lua vim.lsp.buf.formatting()
autocmd FileType js setlocal omnifunc=v:lua.vim.lsp.omnifunc

set incsearch "persist search highlight
set hlsearch "highlight as search matches
set nu "enable line numbers
set splitbelow "default open splits below (e.g. :GoDoc)
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<,space:· "sets chars representing 
                                                       "invisibles when
                                                       ""`set list!` is called
set expandtab "insert space when tab key is pressed
set tabstop=4
set shiftwidth=4

set autoread " Make sure we auto-load changed files

" Better display for messages
set cmdheight=2

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" Set up a helpful, but minimal status bar
set statusline=
" Relative file path in the buffer
set statusline+=%f
" Modified, help, readonly, preview flags
set statusline+=\ %m%h%r%w\ 
" Styling
set statusline+=%#PmenuThumb#
" Display git branch in status line
set statusline+=%{FugitiveStatusline()}
" End styling
set statusline+=%*
" Seperate left/right
set statusline+=%=
" Report buffer
set statusline+=%#PmenuThumb#
" Display git branch in status line
set statusline+=%([buf:\ %n]%)
set statusline+=%*
" line,column virtual column, percentage through window
set statusline+=\ \ %(%l,%c%V\ %=\ %P%)

" Make finding things with standard vim tools a little easier.
" Put all the directories in my current directory on the search path
set path+=**
set wildignorecase
" Don't look in big directories generated by tools
set wildignore+=*/node_modules/*,*/build/*
" Allow a list of matches
set wildmode=list:full


" Show the buffer tabline if there are at least 2 tabs.
" Doesn't work for some reason, shows up as an unknown option
"set g:buftabline_show=1
" -------------------------------------------------------------------------------------------------
" mapping
" -------------------------------------------------------------------------------------------------
let mapleader = "," "leader key is ','

" set up jj as mode switch
map! jj <ESC>

" Better buffer controls
" Open a new empty buffer
nmap <leader>T :enew<cr>

nmap <leader>n :bnext<cr>
nmap <leader>p :bprevious<cr>
nmap <leader>w :bwipeout<cr>

" Remap ^z to suspend the session, the redraw on resume. Should fix drawing
" issues in tmux and doing ^z/fg
noremap ^z :suspend<bar>:redraw!<cr>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Toggle highlighting
" nnoremap <silent><expr> <Leader>h (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"t

" Auto complete to tab (this is breaking if I use it for literal tabs, though)
"inoremap <TAB> <C-X><C-O>

" disable vim's autoincrement/decrement
map <C-a> <Nop>
map <C-x> <Nop>
" -------------------------------------------------------------------------------------------------
" LSP configuration
" -------------------------------------------------------------------------------------------------
lua << EOF
-- Set up telescope for quick sorting
require('telescope').setup {
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }
}
require('telescope').load_extension('fzy_native')

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  ensure_installed = {
    "go",
    "rust",
    "python",
    "toml",
    "json",
    "yaml",
    "html",
    "vim",
    "bash"
  },
  autotag = {
    enable = true,
  }
}

local nvim_lsp = require('lspconfig')
local null_ls = require("null-ls")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d','<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_qflist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Customize gopls outside the setup loop.
nvim_lsp.gopls.setup{
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150
    },
    settings = {
      gopls = {
          experimentalPostfixCompletions = true,
          analyses = {
            unusedparams = true,
            shadow = true,
         },
         staticcheck = true,
        },
    },
}

-- Customize typescript's server outside the setup loop
local buf_map = function(bufnr, mode, lhs, rhs, opts)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or {
        silent = true,
    })
end
nvim_lsp.tsserver.setup({
    on_attach = function(client, bufnr)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false

        local ts_utils = require("nvim-lsp-ts-utils")
        ts_utils.setup({})
        ts_utils.setup_client(client)

        buf_map(bufnr, "n", "gs", ":TSLspOrganize<CR>")
        buf_map(bufnr, "n", "gi", ":TSLspRenameFile<CR>")
        buf_map(bufnr, "n", "go", ":TSLspImportAll<CR>")

        on_attach(client, bufnr)
    end,
})


null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.code_actions.eslint,
        null_ls.builtins.formatting.prettier
    },
    on_attach = on_attach
})

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'rust_analyzer' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

  function goimports(timeoutms)
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end
  end

require('go').setup()
EOF
