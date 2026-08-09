" --- DISPLAY & THEME FIXES ---
" Force the mode (-- INSERT --) to be visible with a specific color
highlight ModeMsg ctermfg=white ctermbg=red cterm=bold

" Ensure the fix persists even if you change colorschemes
autocmd ColorScheme * highlight ModeMsg ctermfg=white ctermbg=red cterm=bold

" Always show the status line (essential for tmux/single files)
set laststatus=2

" Enable syntax highlighting
syntax on

" --- TERMINAL COMPATIBILITY ---
" Helps Vim handle colors correctly inside Ubuntu terminal and tmux
if (has("termguicolors"))
  set termguicolors
endif

" --- CODING PREFERENCES (Optional but Recommended) ---
set number              " Show line numbers
set ignorecase
set tabstop=4           " Number of spaces a tab counts for
set shiftwidth=4        " Number of spaces for auto-indent
set expandtab           " Convert tabs to spaces
set mouse=a             " Enable mouse support for scrolling/clicking
set autoindent
set clipboard=unnamedplus
set hlsearch
imap <c-s> <Esc>:w<CR>a
colorscheme slate
set cursorline          " Highlight the current line
set showtabline=2

