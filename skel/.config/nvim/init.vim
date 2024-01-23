"-----플러그인설정
call plug#begin()
"-color schema
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
"-트리
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
"-자동완성
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
"-자동완성For vsnip users.
Plug 'dcampos/nvim-snippy'
Plug 'dcampos/cmp-snippy'
"Plug 'hrsh7th/cmp-vsnip'
"Plug 'hrsh7th/vim-vsnip'
"-상태표시줄
Plug 'feline-nvim/feline.nvim'
call plug#end()

"-----Lua 설정
"lua vim.g.loaded_netrw = 1
"lua vim.g.loaded_netrwPlugin = 1
lua vim.opt.termguicolors = true
lua require("nvim-tree").setup()
lua require('autocomplete')
lua require('feline').setup()
lua require('feline').winbar.setup()
lua require('catppuccin').setup({transparent_background=true})

"-----기본설정
set mouse=
set clipboard=unnamedplus
colorscheme catppuccin " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
