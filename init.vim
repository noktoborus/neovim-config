" neovim 0.7+ required.
" Ubuntu setup:
" # sudo add-apt-repository ppa:neovim-ppa/stable
" # sudo apt update


" system-to-neovim keyboard mapping
" by default support WSL and termux clipboard, see :help clipboard
vnoremap <C-x> "+d<CR>
vnoremap <C-c> "+y<CR>
inoremap <C-v> <Esc>"+p<CR>i

" Plugin manager: https://github.com/junegunn/vim-plug
call plug#begin('~/.config/nvim/plugged')

" LSP support
Plug 'neovim/nvim-lspconfig'

" LSP Features
Plug 'glepnir/lspsaga.nvim'

" Cursor world highligh
Plug 'RRethy/vim-illuminate'

" automatically cwd to lsp's project root
Plug 'ahmedkhalf/lsp-rooter.nvim'

" Autocomplition
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'

" For vsnip users.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" Git tools
Plug 'lewis6991/gitsigns.nvim'

" Search engine
Plug 'nvim-telescope/telescope.nvim'

" File manager
Plug 'nvim-telescope/telescope-file-browser.nvim'

" Plugin's frameworks
Plug 'nvim-lua/plenary.nvim'

" colorscheme
Plug 'morhetz/gruvbox'

" code coliring
Plug 'nvim-treesitter/nvim-treesitter'

" ???
Plug 'farmergreg/vim-lastplace'
Plug 'tpope/vim-sensible'
Plug 'junegunn/seoul256.vim'
Plug 'rcarriga/nvim-notify'
Plug 'fgheng/winbar.nvim'
call plug#end()

lua require('init')

"nnoremap  <C-n> <cmd>tabnext<cr>
"nnoremap  <C-p> <cmd>tabprevious<cr>
nnoremap  <C-n> <cmd>bnext<CR>
nnoremap  <C-p> <cmd>bprevious<CR>

au ColorScheme * hi Normal ctermbg=none guibg=none
colorscheme gruvbox

syntax on
set nowrap
set expandtab
set tabstop=2
set shiftwidth=2
set smarttab
set number
set termguicolors
set completeopt=menu,menuone,noselect
set list

let mapleader = " "

" List ???
nnoremap <Leader>ll <cmd>Telescope file_browser<CR>
" List Grep
nnoremap <Leader>lg <cmd>Telescope live_grep<CR>
" List Files
nnoremap <Leader>lf <cmd>Telescope find_files<CR>
" List History
nnoremap <Leader>lh <cmd>Telescope oldfiles<CR>
" it is Tabs
nnoremap <Tab> <cmd>lua require("telescope.builtin").buffers{}<CR>
" local Grep
nnoremap <Leader>/ <cmd>Telescope live_grep grep_open_files=true<CR>

" format (only selection) (Alt + f)
vnoremap <M-f> <cmd>lua vim.lsp.buf.format()<CR>
" format all (Alt-Shift + f)
nnoremap <M-S-f> <cmd>lua vim.lsp.buf.format()<CR>

" Git Deleted
nnoremap <Leader>gd <cmd>Gitsigns toggle_deleted<CR>
" Git Next hunk
nnoremap <Leader>gn <cmd>Gitsigns next_hunk<CR>
" Git Prev hunk
nnoremap <Leader>gp <cmd>Gitsigns prev_hunk<CR>
" Git Show hunk
nnoremap <Leader>gs <cmd>Gitsigns preview_hunk<CR>

" Help
noremap <C-h> <cmd>Lspsaga hover_doc<CR>
" Jump
noremap <C-j> <cmd>Lspsaga diagnostic_jump_next<CR>
" Objects
nnoremap <Leader>o <cmd>Lspsaga outline<CR>
" Rename
nnoremap <Leader>r <cmd>Lspsaga rename<CR>
" ??? Befinition? reBerences?
nnoremap <Leader>b <cmd>Lspsaga lsp_finder<CR>
" aCtion
noremap <Leader>c <cmd>Lspsaga code_action<CR>

" Terminal
noremap <C-t> <cmd>terminal<CR>

augroup custom_term
	autocmd!
	autocmd TermOpen * setlocal nonumber norelativenumber nolist bufhidden=hide
  autocmd TermOpen * startinsert
augroup END
