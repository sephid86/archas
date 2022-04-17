"------------------------------
" Vim 설정파일
" 파일이름 : .vimrc
" 파일위치 : ~/.vimrc
" 필요사항 : vundle
"  jellybeans
"
" 만든사람 : 배달하는사람
"  http://k-lint.net
" Update : 2021-08-08
"------------------------------
set nocompatible
filetype off

"----- vundle -----
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
"Plugin 'fatih/vim-go'
Plugin 'scrooloose/nerdtree'
Plugin 'airblade/vim-gitgutter'
Plugin 'scrooloose/syntastic'
Plugin 'nanotech/jellybeans.vim'
Plugin 'vim-scripts/AutoComplPop'
"Plugin 'xolox/vim-easytags'
"Plugin 'tagbar'
"Plugin 'nathanaelkane/vim-indent-guides'
"Plugin 'blueyed/vim-diminactive'

call vundle#end()
filetype plugin indent on
"----- vundle -----

"----- vim-airline -----
"탭 라인 활성화
let g:airline#extensions#tabline#enabled = 1

"직선탭 독립구성 정의
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = '|'

"버퍼 번호를 보여준다
"let g:airline#extensions#tabline#buffer_nr_show = 1

"버퍼 번호 포맷
"let g:airline#extensions#tabline#buffer_nr_format = '%s:'

"포맷터 선택
let g:airline#extensions#tabline#formatter = 'default'

"Powerline 활성화- D2Coding 폰트 필요
let g:airline_powerline_fonts = 1
"----- vim-airline -----

"----- NERDTree -----
"nerdtree 토글 단축키 \nt
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
let NERDTreeShowHidden=1
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
"nmap <F8> :TagbarToggle<CR>
"----- NERDTree -----

"----- Jellybeans -----
"반투명 터미널 지원(젤리빈 활성화보다 앞에 있어야 함.)
let g:jellybeans_overrides = {
\    'background': { 'ctermbg': 'none', '256ctermbg': 'none' },
\}
if has('termguicolors') && &termguicolors
    let g:jellybeans_overrides['background']['guibg'] = 'none'
endif

"젤리빈 활성화
color jellybeans
"----- Jellybeans -----

"----- Key-map (임의 단축키 설정 - 일반모드) -----
noremap <Tab> :lclose<CR>:bn!<CR>
command G0 :G push
command G1 :G status
command G2 :G commit -a
noremap <C-End> :lclose<CR>:bp\|bd! #<CR>
noremap <A-home> :Errors<CR>
noremap <A-end> :lclose<CR>
noremap <A-pageup> :lclose<CR>:bp!<CR>
noremap <A-pagedown> :lclose<CR>:bn!<CR>
"----- Key-map (임의 단축키 설정 - 일반모드) -----

"----- Vim Base settings (vim 기본 설정들) -----
if has("syntax")                                                                
 syntax on
endif
set t_Co=256
set fileencodings=utf-8,euc-kr
set nu
set autoindent
set cindent
set smartindent
set smarttab
set expandtab
"set paste
"왜때문인지 paste 를 활성화 하면 자동들여쓰기가 안된다.

set tabstop=2
set shiftwidth=2
set softtabstop=2
set ts=2
set sw=2
set sts=2

set cursorline
set laststatus=2
set statusline=\ %<%l:%v\ [%P]%=%a\ %h%m%r\ %F\
set ignorecase
"----- Vim Base settings (vim 기본 설정들) -----

"----- Vim Add settings (vim 추가기능들) -----
"커서가 마지막으로 있었던 위치로 이동
au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\ exe "norm g`\"" |                                                             
\ endif
"----- Vim Add settings (vim 추가기능들) -----

"----- Syntastic -----
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']

"let g:syntastic_cpp_compiler = 'g++'
"let g:syntastic_cpp_compiler_options = "-std=c++11 -Wall -Wextra -Wpedantic -pthread -pipe `pkg-config --cflags --libs gtk+-3.0` -export-dynamic -lmysqlclient"
let g:syntastic_c_compiler = 'gcc'
let g:syntastic_c_compiler_options = "-std=c11 -Wextra -Wpedantic -pthread -pipe `pkg-config --cflags --libs gtk+-3.0` -export-dynamic -lmysqlclient"
"----- Syntastic -----

"----- tagbar -----
"nmap <F8> :TagbarToggle<CR>
"----- tagbar -----

au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm setf php

"----- GTK Syntax -----
"au BufNewFile,BufRead *.c so ~/.vim/gtk-vim-syntax/cairo.vim
"au BufNewFile,BufRead *.c so ~/.vim/gtk-vim-syntax/gdkpixbuf.vim
"au BufNewFile,BufRead *.c so ~/.vim/gtk-vim-syntax/glib.vim
"au BufNewFile,BufRead *.c so ~/.vim/gtk-vim-syntax/gtk3.vim
"au BufNewFile,BufRead *.c so ~/.vim/gtk-vim-syntax/xlib.vim
"----- GTK Syntax -----
