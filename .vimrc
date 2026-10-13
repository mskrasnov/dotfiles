" Some keybindings:
" 	<l>cc - comment line(s)
" 	<l>cu - uncomment line(s)
" 	<l>c<space> - toggle comment (comment/uncomment line(s))
" 	<l>ci - invert comments on the selected lines
" 	<l>cA - add a comment symbol to the end of string and enable insert mode
"	<l>n - focus to the Nerd Tree
"	C-t - toggle Nerd Tree
"	C-f - find
" (<l> - leader; `\` is default, C - Ctrl)

set nu
set lbr
set tabstop=4
set shiftwidth=4
set smarttab
set smartindent
syntax on
filetype plugin indent on
set mouse=a

call plug#begin()
		Plug 'dbakker/vim-projectroot'
		Plug 'preservim/nerdcommenter'
		Plug 'preservim/nerdtree'
		Plug 'morhetz/gruvbox'
		Plug 'vim-airline/vim-airline'
		Plug 'vim-airline/vim-airline-themes'
		Plug 'jreybert/vimagit'
		Plug 'voldikss/vim-floaterm'

		Plug 'prabirshrestha/vim-lsp'
		Plug 'mattn/vim-lsp-settings'
		Plug 'prabirshrestha/asyncomplete.vim'
		Plug 'prabirshrestha/asyncomplete-lsp.vim'
call plug#end()

let g:airline_theme='tomorrow'

filetype plugin on
let g:NERDCreateDefaultMappings = 1
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
let g:NERDCommentEmptyLines = 1

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
nnoremap <leader>t :FloatermToggle<CR>

colorscheme gruvbox
set background=dark

if executable('rust-analyzer')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rust-analyzer',
        \ 'cmd': {server_info->['rust-analyzer']},
        \ 'allowlist': ['rust'],
        \ })
endif

if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd']},
        \ 'allowlist': ['c'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
"vim.lsp.enable("rust_analyzer")
