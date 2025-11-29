set shell=/bin/zsh
set shiftwidth=4
set tabstop=4
set expandtab
set textwidth=0
set autoindent
set hlsearch
set clipboard=unnamed
syntax on

let mapleader = "\<Space>"

call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'nvim-lua/plenary.nvim'
Plug 'CopilotC-Nvim/CopilotChat.nvim'
call plug#end()

lua require('copilot-config')

" CopilotChat visual mode mappings
xmap <leader>ce <Cmd>CopilotChatExplain<CR>
xmap <leader>cr <Cmd>CopilotChatReview<CR>
xmap <leader>cf <Cmd>CopilotChatFix<CR>
xmap <leader>co <Cmd>CopilotChatOptimize<CR>
xmap <leader>cd <Cmd>CopilotChatDocs<CR>
xmap <leader>ct <Cmd>CopilotChatTests<CR>
