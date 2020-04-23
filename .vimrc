"setup for vundle
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"-------- Begin Plugins

" the vundle package, let vundle autoupdate itself
Plugin 'VundleVim/Vundle.vim'

"Plugin 'elixir-editors/vim-elixir'
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
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'caenrique/nvim-maximize-window-toggle'
Plugin 'joshdick/onedark.vim'
"Plugin 'justinmk/vim-sneak'

call vundle#end()
"-------- End Plugins and vundle setup

" now can turn filetype functionality back on
filetype plugin indent on
syntax on
" Leader
let mapleader = " "

"set guifont=Consolas:h9:cANSI
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

" yank to clipboard | let yy, D and P work with system clipboard
" If used in a tmux window, then copying to system clipboard doesnt work
" You must instead do 'prefix + ]' then 'space' to highlight, 'enter' to copy,
" then move to another window and 'prefix + ]' in insert mode to paste
"if has("clipboard")
"    set clipboard=unnamed " copy to the system clipboard

"  if has("unnamedplus") " X11 support
"      set clipboard+=unnamedplus
"  endif
"ndif


" Display extra whitespace
set showbreak=↪\ 
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·

" Plugin configuration
"let g:DeleteTrailingWhitespace_Action = 'delete'
"let g:DeleteTrailingWhitespace = 1
let g:ctrlp_custom_ignore = {
  \ 'dir': '\v[\/]\.(git|hg|svn|pub|testing|util|Servers|.metadata|3rdPartySources|node_modules|build|intellij|pub|scripts|target)$',
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
nnoremap <Leader>wm :ToggleOnly<Enter>
nnoremap <Leader>ws :split<Enter>
nnoremap <Leader>wv :vsplit<Enter>
nnoremap <Leader>wd :bp\|bd #<Enter>
nnoremap <Leader>wc :q<Enter>
nnoremap <Leader>wh <c-w>h
nnoremap <Leader>wj <c-w>j
nnoremap <Leader>wk <c-w>k
nnoremap <Leader>wl <c-w>l
nnoremap <Leader><Tab> :b#<Enter>

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
  "if exists("+lines")
  "  set lines=50
  "endif
  "if exists("+columns")
  "  set columns=100
  "endif
endif

" Color scheme
set background=dark
colorscheme onedark
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

" https://vi.stackexchange.com/questions/13864/bufwinleave-mkview-with-unnamed-file-error-32
augroup AutoSaveFolds " prevents auto commands from showing up twice when sourcing the file more than once
    "the command au! deletes all vimrc auto commands
    au!  
    " view files are about 500 bytes  
    " bufleave but not bufwinleave captures closing 2nd tab  
    " nested is needed by bufwrite* (if triggered via other autocmd)  
    " store all marks/folds in a file on exit
    autocmd BufWinLeave,BufLeave,BufWritePost ?* nested silent! mkview!  
    " load all marks/folds for a file on load
    autocmd BufWinEnter ?* silent! loadview
augroup end
