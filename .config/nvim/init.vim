" plug install script
if empty(glob("~/.local/share/nvim/site/autoload/plug.vim"))
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif
call plug#begin('~/.local/share/nvim/plugged')
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/Buffergator'
Plug 'vim-scripts/DeleteTrailingWhitespace'
Plug 'vim-scripts/L9'
Plug 'terryma/vim-multiple-cursors'
Plug 'bling/vim-airline'
Plug 'liuchengxu/vim-which-key'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" not sure how to get simplyfold for python to work...
Plug 'tmhedberg/simpylfold'
" if you enable vim-sneak, it replaces s with a custom key so rebind it...
"Plug 'justinmk/vim-sneak'
Plug 'junegunn/fzf', { 'dir': '~/.local/fzf', 'do': './install --all' } " fuzzy finder
Plug 'junegunn/fzf.vim'
"Plug 'ctrlpvim/ctrlp.vim'
call plug#end()

let mapleader = " "
let maplocalleader = "\\"

" ##### Mappings ######
nnoremap <Leader>wm :tab split<Enter>
nnoremap <Leader>ws :split<Enter><c-w>j
nnoremap <Leader>wS :split<Enter>
nnoremap <Leader>wv :vsplit<Enter><c-w>l
nnoremap <Leader>wV :vsplit<Enter>
nnoremap <Leader>wd :q<Enter>
nnoremap <Leader>wh <c-w>h
nnoremap <Leader>wj <c-w>j
nnoremap <Leader>wk <c-w>k
nnoremap <Leader>wl <c-w>l
nnoremap <Leader>bd :bp\|bd #<Enter>
nnoremap <Leader>lc :tabnew<Enter>
nnoremap <Leader>ln :tabn<Enter>
nnoremap <Leader>lp :tabp<Enter>
nnoremap <Leader>fo :Files<Enter>
nnoremap <Leader>s :Find 
nnoremap <Leader>an :NERDTreeFind<Enter>
nnoremap <Leader>ab :BuffergatorOpen<Enter>
nnoremap <Leader>gs :Gstatus<Enter>
nnoremap <Leader>gb :Gblame<Enter>
" switch to alternate file (the file previously visible in the current
" window). :buffers to see which one it is (indicated by # symbol).
nnoremap <silent> <Leader><Tab> :b#<Enter>
nnoremap <Leader> :WhichKey '<Space>'<CR>
nnoremap <LocalLeader> :<c-u>WhichKey  ','<CR>
"nnoremap <Leader>s :R rg 
nnoremap zz zzLkkzzrr

inoremap {<CR> {<CR>}<C-o>O
nnoremap <A-q> :q<CR>
nnoremap <A-w> :w<CR>
nnoremap <Leader>ev :tab vsplit $MYVIMRC<CR>
nnoremap <Leader>ebp :tab vsplit ~/.bash_profile<CR>
nnoremap <Leader>ebpl :tab vsplit ~/.bash_profile_local<CR>
nnoremap <Leader>ea :tab vsplit ~/.config/awesome/rc.lua<CR>
nnoremap <Leader>et :tab vsplit ~/.config/awesome/defaultCustom.lua<CR>
nnoremap <Leader>en :tab vsplit ~/Documents/notes.txt<CR>
nnoremap <Leader>esw :tab vsplit ~/.local/share/nvim/swap<CR>
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

" t-mux navigation
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
"function! InsertTabWrapper()
"   let col = col('.') - 1
"   if !col || getline('.')[col - 1] !~ '\k'
"       return "\<tab>"
"   else
"       return "\<c-p>"
"   endif
"ndfunction
"noremap <Tab> <c-r>=InsertTabWrapper()<CR>

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <S-Tab> <c-n>

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <S-F6> <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>=  <Plug>(coc-format-selected)
nmap <leader>=  <Plug>(coc-format-selected)

" ##### Settings #####
"notes: boolean options vs non-boolean options
" boolean options are turned on with 'set "name"' and turned off with 'set
" "noname"'. set "name?" will tell you the value of the option
" :options will show all options and their current values
"
" enable syntax highlighting and switch on highlighting the last used search pattern.
syntax enable
set ignorecase " this doesn't just ignore case in search strings, it ignores case in
" all vimscript commands as well, AND ignores case in the == equality operator!!
set fileformats=unix,dos,mac
set visualbell
set wildmode=list:longest,list:full
set wildignore+=tags
set expandtab
set tabstop=4
set shiftwidth=4
set autowrite     " Automatically :write before running commands
set timeoutlen=200 " for which key, so window shows up after this amount of milliseconds
set splitright " causes verticle splits to split on the right side instead of the left
" Display extra whitespace
set showbreak=↪\ 
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
" Give more space for displaying messages.
set cmdheight=2
" swap save after this many milliseconds
set updatetime=300
" Don't pass messages to |ins-completion-menu|
set shortmess+=c
set signcolumn=yes

" Create undo directory
let s:undoDir="/.config/nvim/undodir"
if !isdirectory($HOME . s:undoDir)
    call mkdir($HOME . s:undoDir, "p")
endif
set undofile
set undodir="$HOME . s:undoDir"

" ##### User Commands #####
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
command! -nargs=* -complete=shellcmd R vnew | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>
command! -nargs=* Src source $MYVIMRC


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


" ##### Plugin configuration #####
"let g:DeleteTrailingWhitespace_Action = 'delete'
"let g:DeleteTrailingWhitespace = 1
let g:NERDTreeDirArrowExpandable = '' " remove arrows in nerd tree
let g:NERDTreeDirArrowCollapsible = ''
let NERDTreeQuitOnOpen = 1 " exit nerdtree when entering a file
let NERDTreeAutoDeleteBuffer = 1 " delete buffer when file is deleted in NerdTree
let NERDTreeMinimalUI = 1
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
" auto close tab if only remaining window is NerdTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

let g:ctrlp_custom_ignore = {
  \ 'dir': '\v[\/]\.(git|hg|svn|pub|testing|util|Servers|.metadata|3rdPartySources|node_modules|build|intellij|pub|scripts|target)$',
  \ 'file': '\v\.(exe|so|dll|jar|jpg|pdf|sublime-project|sublime-workspace)$',
  \ }
let g:ctrlp_max_files = 0
let g:ctrlp_max_depth = 40
let NERDTreeHijackNetrw=1

" Use ripgrep instead https://github.com/BurntSushi/ripgrep
if executable('rg')
  " Use rg over Grep
  set grepprg=rg\ --vimgrep

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  "let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  "let g:ctrlp_use_caching = 0
endif

" Color scheme
if empty(glob("~/.config/nvim/colors/lucius.vim"))
    silent !curl -fLo ~/.config/nvim/colors/lucius.vim --create-dirs https://raw.githubusercontent.com/bag-man/dotfiles/master/lucius.vim
endif
set background=dark
colorscheme lucius
LuciusDarkLowContrast " makes the theme look good
"highlight NonText guibg=#060606
"highlight Folded  guibg=#0A0A0A guifg=#9090D0

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

"augroup AutoSaveFiles
"    au! AutoSaveFiles
"    au InsertLeave * call SaveFileTimer(strftime("%s"))
"    au TextChanged * call SaveFileTimer(strftime("%s"))
"augroup end
