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
" Coloring
Plug 'TheGLander/indent-rainbowline.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'

" LSP support
Plug 'neovim/nvim-lspconfig'

" LSP Features
Plug 'folke/trouble.nvim'
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
Plug 'NeogitOrg/neogit'
Plug 'sindrets/diffview.nvim' "       -- optional - Diff integration for neogit

" autosave
Plug 'okuuva/auto-save.nvim'

" Search engine
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-ui-select.nvim'

" File manager
Plug 'nvim-tree/nvim-tree.lua'

" Plugin's frameworks
Plug 'nvim-lua/plenary.nvim'

" colorscheme
Plug 'morhetz/gruvbox'

" code coliring
Plug 'nvim-treesitter/nvim-treesitter'

" markdown
Plug 'mzlogin/vim-markdown-toc'

" statusline
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'

" sessions
Plug 'Shatur/neovim-session-manager'

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
nnoremap  <A-Left> <cmd>bprevious<CR>
nnoremap  <A-Right> <cmd>bnext<CR>

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
set notagstack

let mapleader = " "

" Grep other files (Ctrl + g)
noremap <C-g> <cmd>Telescope live_grep<CR>
" Open new file (Ctrl + o)
noremap <C-o> <cmd>NvimTreeFindFileToggle<CR>
" find file to open (Alt + o)
noremap <M-o> <cmd>Telescope find_files<CR>
"" it is Tabs
nnoremap <Tab> <cmd>lua require("telescope.builtin").buffers{ ignore_current_buffer = true, sort_lastused = true, previewer = false }<CR>
" grep over open files (Ctrl + f)
noremap <C-f> <cmd>lua require('telescope.builtin').live_grep{ prompt_title = 'Grep over openned buffers', grep_open_files = true }<CR>


" format (only selection) (Space + f)
vnoremap <Leader>f <cmd>lua vim.lsp.buf.format()<CR>
" format all (Alt + f)
nnoremap <M-f> <cmd>lua vim.lsp.buf.format()<CR>

" Git Deleted
nnoremap <Leader>gd <cmd>Gitsigns toggle_deleted<CR>
" Git Next hunk
nnoremap <Leader>gn <cmd>Gitsigns next_hunk<CR>
" Git Prev hunk
nnoremap <Leader>gp <cmd>Gitsigns prev_hunk<CR>
" Git Show hunk
nnoremap <Leader>gs <cmd>Gitsigns preview_hunk<CR>
" Git blame
nnoremap <Leader>gb <cmd>Gitsigns blame_line<CR>
" Git reset hunk
nnoremap <Leader>gr <cmd>Gitsigns reset_hunk<CR>
" Git stage hunk
nnoremap <Leader>gS <cmd>Gitsigns stage_hunk<CR>
" Git unstage last staged hunk
nnoremap <Leader>gU <cmd>Gitsigns undo_stage_hunk<CR>
" Git temporary force push
nnoremap <Leader>gPP <cmd>:lua save_buffers_and_git_push_force()<CR>

" Help
nnoremap <Leader>h <cmd>Lspsaga hover_doc<CR>
" Jump
nnoremap <Leader>j <cmd>Lspsaga diagnostic_jump_next<CR>
" Trouble
nnoremap <Leader>t <cmd>TroubleToggle workspace_diagnostics<CR>
" Objects
nnoremap <Leader>o <cmd>Lspsaga outline<CR>
" Rename
nnoremap <Leader>r <cmd>Lspsaga rename<CR>
" ??? Befinition? reBerences?
"nnoremap <Leader>b <cmd>Lspsaga finder def+ref<CR>
nnoremap <Leader>b <cmd>TroubleToggle lsp_references<CR>
" aCtion
nnoremap <Leader>c <cmd>Lspsaga code_action<CR>
" Incoming calls
nnoremap <Leader>i <cmd>Lspsaga incoming_calls<CR>

" jumps ability: jump to older position
noremap <A-Up> <C-O>
" jumps ability: jump to newest position
noremap <A-Down> <C-I>

" Terminal
noremap <C-t> <cmd>echo "v for vertical-splitted terminal, s for horisontal, t for fullscreen"<CR>
noremap <C-t>t <cmd>tabe term://$SHELL<CR>
noremap <C-t>v <cmd>vsplit term://$SHELL<CR>
noremap <C-t>s <cmd>split term://$SHELL<CR>
tnoremap <Esc> <C-\><C-n>

augroup custom_term
	autocmd!
	autocmd TermOpen * setlocal nonumber norelativenumber nolist bufhidden=hide
  autocmd TermOpen * startinsert
augroup END

if has('nvim') && executable('nvr')
  let $GIT_EDITOR = 'nvr -cc split --remote-wait-silent'
  let $EDITOR = 'nvr --remote-tab-wait-silent'
  endif

set noswapfile
