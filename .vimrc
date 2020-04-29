" ### Begin Vundle setup and Plugins ###
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

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
Plugin 'liuchengxu/vim-which-key'
"Plugin 'justinmk/vim-sneak'

call vundle#end()

" ### Settings ###
" now can turn filetype functionality back on
filetype plugin indent on
" ### End Plugins and vundle setup ###


" ### Settings
syntax on
"set guifont=Consolas:h9:cANSI
set ignorecase " this doesn't just ignore case in search strings, it ignores case in
" all vimscript commands as well, AND ignores case in the == equality operator!!
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
set timeoutlen=400 " for which key, so window shows up after this amount of milliseconds
set splitright " causes verticle splits to split on the right side instead of the left

command! -nargs=* -complete=shellcmd R vnew | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>
command! -nargs=* Src source ~/.vimrc

"notes: boolean options vs non-boolean options
" boolean options are turned on with 'set "name"' and turned off with 'set
" "noname"'. set "name?" will tell you the value of the option
" :options will show all options and their current values

" ### End settings

" ### mappings
let mapleader = " "
let maplocalleader = "\\"

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<space>
nnoremap <Leader>wm :ToggleOnly<Enter>
nnoremap <Leader>ws :split<Enter><c-w>j
nnoremap <Leader>wS :split<Enter>
nnoremap <Leader>wv :vsplit<Enter><c-w>l
nnoremap <Leader>wV :vsplit<Enter>
nnoremap <Leader>bd :bp\|bd #<Enter>
nnoremap <Leader>wd :q<Enter>
nnoremap <Leader>wh <c-w>h
nnoremap <Leader>wj <c-w>j
nnoremap <Leader>wk <c-w>k
nnoremap <Leader>wl <c-w>l
nnoremap <Leader>lc :tabnew<Enter>
nnoremap <Leader>ln :tabn<Enter>
nnoremap <Leader>lp :tabp<Enter>
" switch to alternate file (the file previously visible in the current
" window). :buffers to see which one it is.
nnoremap <silent> <Leader><Tab> :b#<Enter>
nnoremap <leader> :WhichKey '<Space>'<CR>
nnoremap <localleader> :<c-u>WhichKey  ','<CR>
nnoremap <Leader>s :R rg 


"let s:window_number
"nnoremap gf gf | :

" t-mux navigation
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

inoremap {<CR> {<CR>}<C-o>O
nnoremap <A-q> :q<cr>
nnoremap <A-w> :w<cr>
nnoremap <leader>ev :tab vsplit $MYVIMRC<cr>
nnoremap <leader>es :source $MYVIMRC<cr>
nnoremap 0 ^
nnoremap ^ 0
nnoremap ` '
nnoremap ' `
nnoremap <Leader>" viw<Esc>a"<Esc>bi"<Esc>
nnoremap <Leader>' viw<Esc>a'<Esc>bi'<Esc>
" Wrap selected text in double or single quotes
" `< move to first visual selection character. `> move to last visual
" selection character.
vnoremap <Leader>" <Esc>`<i"<Esc>`>la"<Esc>
vnoremap <Leader>' <Esc>`<i'<Esc>`>la'<Esc>

" ### End mappings


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
colorscheme ron
highlight NonText guibg=#060606
highlight Folded  guibg=#0A0A0A guifg=#9090D0

" ### Autocommands (i.e. handle vim events)

" https://vi.stackexchange.com/questions/13864/bufwinleave-mkview-with-unnamed-file-error-32
augroup AutoSaveFolds " prevents auto commands from showing up twice when sourcing the file more than once
    "the command au! deletes all vimrc auto commands
    au! AutoSaveFolds
    " view files are about 500 bytes  
    " bufleave but not bufwinleave captures closing 2nd tab  
    " nested is needed by bufwrite* (if triggered via other autocmd)  
    " store all marks/folds in a file on exit
    autocmd BufWinLeave,BufLeave,BufWritePost ?* nested silent! mkview!  
    " load all marks/folds for a file on load
    autocmd BufWinEnter ?* silent! loadview
augroup end


let s:previousTime = strftime("%s")
let s:timerId = 0
function! SaveFileTimer(currentTime)
    let s:timePassed = a:currentTime - s:previousTime
    if s:timePassed >= 5
        :write
        echom "Wrote, Time " . a:currentTime
    else
        echom s:timerId
        if s:timerId > 0
            echom "timer stopped, id " . s:timerId
            call timer_stop(s:timerId)
        endif
        echom "skipped, Time: " . a:currentTime
        let s:timerId = timer_start(5000, 'SaveFileTimer')
    endif

    let s:previousTime = a:currentTime
endfunction
"hi a a a a a a 

"augroup AutoSaveFiles
"    au! AutoSaveFiles
"    au InsertLeave * call SaveFileTimer(strftime("%s"))
"    au TextChanged * call SaveFileTimer(strftime("%s"))
"augroup end

