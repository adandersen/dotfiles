"setup for vundle
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

"-------- Begin Plugins

" the vundle package, let vundle autoupdate itself
Plugin 'VundleVim/vundle'

Plugin 'scrooloose/nerdtree.git'
Plugin 'fugitive.vim'
Plugin 'Buffergator'
Plugin 'unimpaired.vim'
Plugin 'DeleteTrailingWhitespace'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'Solarized'
Plugin 'L9'
Plugin 'FuzzyFinder'
Plugin 'bling/vim-airline'
Plugin 'justinmk/vim-sneak'

call vundle#end()
"-------- End Plugins and vundle setup

" now can turn filetype functionality back on
filetype plugin indent on
syntax on
" Leader
let mapleader = " "

set guifont=Consolas:h9:cANSI
set ignorecase
set ruler
set fileformats=unix,dos,mac
set visualbell
set wildmenu
set wildmode=longest:full,full
set wildignore+=tags
set hlsearch
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set backupcopy=yes "needed for karma so it doesnt create a new file to save
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands

" Display extra whitespace
set list listchars=tab:��,trail:�,nbsp:�

" Plugin configuration
let g:DeleteTrailingWhitespace_Action = 'delete'
let g:DeleteTrailingWhitespace = 1
let g:ctrlp_custom_ignore = {
  \ 'dir': '\v[\/]\.(git|hg|svn|pub|testing|util|Servers|.metadata|3rdPartySources|archive|experiment|intellij|pub|scripts|target)$',
  \ 'file': '\v\.(exe|so|dll|jar|jpg|pdf|sublime-project|sublime-workspace)$',
  \ }
let g:ctrlp_max_files = 0
let g:ctrlp_max_depth = 40
let NERDTreeHijackNetrw=1

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<space>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif
"
" Put plugins and dictionaries in this dir (also on Windows)
let vimDir = '$HOME/.vim'
let &runtimepath.=','.vimDir

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand(vimDir . '/persistent-undo')
    " Create dirs
    call system('mkdir ' . vimDir)
    call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
endif

" set width and height of window
if has("gui_running")
  " GUI is running or is about to start.
  " Maximize gvim window (for an alternative on Windows, see simalt below).
  set lines=65 columns=230
else
  " This is console Vim.
  if exists("+lines")
    set lines=50
  endif
  if exists("+columns")
    set columns=100
  endif
endif

" Color scheme
set background=dark
"colorscheme solarized
highlight NonText guibg=#060606
highlight Folded  guibg=#0A0A0A guifg=#9090D0

nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

inoremap {<CR> {<CR>}<C-o>O
nnoremap <A-q> :q<cr>
nnoremap <A-w> :w<cr>
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

au! BufWritePost .vimrc source %

