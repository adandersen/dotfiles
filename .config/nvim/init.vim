" plug install script
if empty(glob("~/.local/share/nvim/site/autoload/plug.vim"))
    !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif
call plug#begin('~/.local/share/nvim/plugged')
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/DeleteTrailingWhitespace'
Plug 'vim-scripts/L9'
"Plug 'terryma/vim-multiple-cursors'
Plug 'bling/vim-airline'
Plug 'liuchengxu/vim-which-key'
Plug 'ap/vim-css-color'
Plug 'stefandtw/quickfix-reflector.vim'
Plug 'tmhedberg/simpylfold'
" don't forget to :CocInstall coc-go etc.
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" if you enable vim-sneak, it replaces s with a custom key so rebind it...
"Plug 'justinmk/vim-sneak'
Plug 'junegunn/fzf', { 'dir': '~/.local/fzf', 'do': './install --all' } " fuzzy finder
Plug 'junegunn/fzf.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
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
" a :bn is needed since when deleting a buffer it goes to the one
" previous. Even this won't be perfect since buffers keep their numbers for
" the life of vim... Theres a work around using the arglist to renumber
" buffers by putting all open buffers in the arglist, then deleting all open
" buffers and reopening them off the arg list which will reorder them, but
" haven't tried it yet.
nnoremap <Leader>bd :bp\|bd #<Enter>
nnoremap <Leader>lc :tabnew<Enter>
nnoremap <Leader>ln :tabn<Enter>
nnoremap ( :tabp<Enter>
nnoremap <Leader>lp :tabp<Enter>
nnoremap ) :tabn<Enter>
nnoremap <Leader>ft :GFiles<Enter>
" not real grep, uses ripgrep through fzf
nnoremap <Leader>ff viw"+y :Rg<Enter>
nnoremap <Leader>hh :History<Enter>
nnoremap <Leader>h: :History:<Enter>
nnoremap <Leader>h/ :History/<Enter>
nnoremap <Leader>H :Helptags<Enter>
nnoremap <Leader>bb :Buffers
nnoremap <Leader>an :NERDTreeFind<Enter>
nnoremap <Leader>gg :Commits<Enter>
nnoremap <Leader>gs :Gstatus<Enter>
nnoremap <Leader>gc :Git commit -v -q<Enter>
nnoremap <Leader>ga :Git commit -v -q %<Enter>
nnoremap <Leader>gb :Git blame --date=relative<Enter>
nnoremap <Leader>gl :Git log<Enter>
nnoremap <Leader>gd :tab split<Enter>:Gvdiffsplit<Enter>
nnoremap <Leader>ge :Gedit<Enter>
nnoremap <Leader>gr :Gread<Enter>
nnoremap <Leader>gp :Ggrep<Enter>
nnoremap <Leader>gm :Gmove<Enter>
nnoremap <Leader>gw :Gwrite<Enter>
nnoremap <Leader>gpl :Git pull<Enter>
" switch to alternate file (the file previously visible in the current
" window). :buffers to see which one it is (indicated by # symbol).
nnoremap <silent> <Leader><Tab> :b#<Enter>
nnoremap <Leader> :WhichKey '<Space>'<CR>
nnoremap <LocalLeader> :<c-u>WhichKey  ','<CR>
nnoremap <Leader>zz zzLkkzz
nnoremap zz zz10jzz10k
nnoremap <Leader>/ :Lines 
nnoremap <Leader>// :BLines 

" quickfix bindings
nnoremap <Leader>qn :cnext<CR>
nnoremap <Leader>qp :cprevious<CR>
nnoremap <Leader>qc :cclose<CR>

" go file bindings
autocmd FileType go nmap <Leader>.b <Plug>(go-build)
autocmd FileType go nmap <Leader>.r <Plug>(go-run)
autocmd FileType go nmap <Leader>.t <Plug>(go-test)
autocmd FileType go nmap <Leader>.tt <Plug>(go-test-func)
autocmd FileType go nmap <Leader>.c <Plug>(go-coverage-toggle)
" function signature
autocmd FileType go nmap <Leader>.i <Plug>(go-info)
" interfaces a type implements
autocmd FileType go nmap <Leader>.ii <Plug>(go-implements)
" definition of a given type
autocmd FileType go nmap <Leader>.d <Plug>(go-describe)
" see callers of a function
autocmd FileType go nmap <Leader>.cc <Plug>(go-callers)
" find all references of a given type/function
autocmd FileType go nmap <Leader>.cr <Plug>(coc-references)

inoremap {<CR> {<CR>}O
nnoremap <Leader>ev :tab vsplit $MYVIMRC<CR>
nnoremap <Leader>ebp :tab vsplit ~/.bash_profile<CR>
nnoremap <Leader>ebpl :tab vsplit ~/.bash_profile_local<CR>
nnoremap <Leader>ebr :tab vsplit ~/.bashrc<CR>
nnoremap <Leader>ebrl :tab vsplit ~/.bashrc_local<CR>
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

" <C-i> is equivalent to ctrl-tab
" doesn't seem possible to map ctrl-shift-tab, kitty hijacks all ctrl-shift
" combinations
nnoremap <silent><C-n> :bn<Enter>
nnoremap <silent><C-p> :bp<Enter>

" t-mux navigation
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

nnoremap <C-p> :Files<Enter>
nnoremap <C-e> :Buffers<Enter>

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
" inoremap <silent><expr> <c-space> coc#refresh()
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
nmap <silent> <C-]> <Plug>(coc-definition)
nmap <silent> <MiddleMouse> <LeftMouse><Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Show documentation in preview window.
nnoremap <silent> <A-p> :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Symbol renaming.
nmap <leader>r  <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>=  <Plug>(coc-format-selected)
nmap <leader>=  <Plug>(coc-format-selected)

" ##### Settings #####
"notes: boolean options vs non-boolean options
" boolean options are turned on with 'set "name"' and turned off with 'set
" "noname"'. set "name?" will tell you the value of the option
" :options will show all options and their current values
"
" setting an option with `let &option = variable' will expand the variable.
" Just doing `set option = variable' will not expand and just set it to
" variable
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
set number
set relativenumber
" enable mouse for all vim modes (the a)
set mouse=a
" let vim_current_word do the highlighting
set nohlsearch
" don't let vim auto complete text
set completeopt+=menuone,noselect,noinsert

" Create undo directory
let undoDir = globpath($HOME, '.config/nvim/undodir')

if !isdirectory(undoDir)
    call mkdir(undoDir, "p")
endif
set undofile
let &undodir=undoDir

 " Add (Neo)Vim's native statusline support.
 " NOTE: Please see `:h coc-status` for integrations with external plugins that
 " provide custom statusline: lightline.vim, vim-airline.
 set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

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
"  not really needed anymore, just use Rg instead from fvf.vim
command! -bang -nargs=* Grep call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.venv/lib64/*" --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
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
let NERDTreeHijackNetrw=1
let g:NERDTreeGitStatusIndicatorMapCustom = {
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

let g:airline_statusline_ontop=0
let g:vim_current_word#highlight_delay = 100

" fzf
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }
let g:fzf_preview_window = ['right:60%', 'ctrl-/']

" go
let g:go_auto_sameids = 1
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_string_spellcheck = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1
let g:go_fmt_experimental = 1
let g:go_metalinter_autosave=1
let g:go_metalinter_autosave_enabled=['golint', 'govet']
" disable linters as that is taken care of by coc.nvim
let g:go_diagnostics_enabled = 0
let g:go_metalinter_enabled = []

" run go imports on file save
let g:go_fmt_command = "goimports"

" Use ripgrep instead https://github.com/BurntSushi/ripgrep
if executable('rg')
  set grepprg=rg\ --vimgrep
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
" auto close tab if only remaining window is NerdTree
augroup NerdTree
    au! NerdTree
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
augroup end

augroup FileTypeGroup
    au! FileTypeGroup
    autocmd FileType python setlocal colorcolumn=100
augroup end

" Using vim_current_word instead for now as I like it more
" Highlight the symbol and its references when holding the cursor.
"augroup CocGroup
"    au! CocGroup
"    au CursorHold * silent call CocActionAsync('highlight')
"augroup end

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


" plugins stolen from https://bitbucket.org/sjl/dotfiles/src/1cd90a0458e45ddfcb5b8b988133bf02a29f84c7/vim/vimrc?fileviewer=file-view-default#vimrc-3091

" Highlight Word {{{
"
" This mini-plugin provides a few mappings for highlighting words temporarily.
"
" Sometimes you're looking at a hairy piece of code and would like a certain
" word or two to stand out temporarily.  You can search for it, but that only
" gives you one color of highlighting.  Now you can use <leader>N where N is
" a number from 1-6 to highlight the current word in a specific color.

function! HiInterestingWord(n) " {{{
    " Save our location.
    normal! mz

    " Yank the current word into the z register.
    normal! "zyiw

    " Calculate an arbitrary match ID.  Hopefully nothing else is using it.
    let mid = 86750 + a:n

    " Clear existing matches, but don't worry if they don't exist.
    silent! call matchdelete(mid)

    " Construct a literal pattern that has to match at boundaries.
    let pat = '\V\<' . escape(@z, '\') . '\>'

    " Actually match the words.
    call matchadd("InterestingWord" . a:n, pat, 1, mid)

    " Move back to our original location.
    normal! `z
endfunction " }}}

" Mappings {{{

nnoremap <silent> <leader>1 :call HiInterestingWord(1)<cr>
nnoremap <silent> <leader>2 :call HiInterestingWord(2)<cr>
nnoremap <silent> <leader>3 :call HiInterestingWord(3)<cr>
nnoremap <silent> <leader>4 :call HiInterestingWord(4)<cr>
nnoremap <silent> <leader>5 :call HiInterestingWord(5)<cr>
nnoremap <silent> <leader>6 :call HiInterestingWord(6)<cr>
nnoremap <silent> <leader>0 :call clearmatches()<cr>

" }}}
" Default Highlights {{{

hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195

" }}}

