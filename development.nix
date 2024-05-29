#Development setup
{ config, pkgs, ... }:
{
#################### Git configuration ####################
	programs.git = {
		enable = true;
		lfs.enable = true;
		config = {
			user = {
				email = "vili.m.sinerva@gmail.com";
				name = "Vili Sinervä";
				signingkey = "/home/vili/.ssh/id_ed25519.pub";
			};
			merge = {
				ff = "true";
			};
			pull = {
				ff = "only";
			};
			gpg.format = "ssh";
			commit.gpgsign = "true";
		};
	};

#################### Packages ####################
	environment.systemPackages = with pkgs; [
			cmake
			gnumake
			gcc
			gdb
			nodejs-slim
			clang clang-tools clang-analyzer
			docker-compose docker
			python311
			python311Packages.pip
			pypy3
			rustup
	];

#################### Neovim configuration ####################
	programs.neovim = {
		enable = true;
		defaultEditor = true;
		viAlias = true;
		vimAlias = true;
		configure = {
			packages.myVimPackage = with pkgs.vimPlugins; {
				start = [ nerdtree nerdtree-git-plugin 
					vim-gitgutter vim-fugitive vim-tmux-navigator
					coc-nvim coc-pairs
					coc-clangd coc-cmake
					coc-docker
					coc-json
					coc-ltex
					coc-markdownlint
					coc-sh
					coc-toml
					coc-yaml
					coc-pyright
					coc-tsserver
					coc-rust-analyzer
				];
			};
			customRC = 
			let
				coc-config = "${pkgs.writeTextDir "coc-settings.json"
''
{
	"workspace.ignoredFolders": [
		"$HOME",
		"$HOME/.cargo/**",
		"$HOME/.rustup/**"
	],
	rust-analyzer.inlayHints.bindingModeHints.enable: true,
	rust-analyzer.inlayHints.closureReturnTypeHints.enable: "always",
	rust-analyzer.inlayHints.discriminantHints.enable: "always",
	rust-analyzer.inlayHints.expressionAdjustmentHints.enable: "always",
	rust-analyzer.inlayHints.expressionAdjustmentHints.hideOutsideUnsafe: true,
	rust-analyzer.inlayHints.lifetimeElisionHints.enable: "always",
	rust-analyzer.inlayHints.lifetimeElisionHints.useParameterNames: true
}
''}";

			in
			''
			syntax on
			set foldmethod=syntax

			set number
			" set relativenumber
			set colorcolumn=100
			set signcolumn=yes
			let NERDTreeShowLineNumbers=1

			set background=dark

			set showcmd
			set scrolloff=16

			filetype plugin indent on
			set autoindent
			set shiftwidth=3
			set tabstop=3


			" Some servers have issues with backup files, see #649
			set nobackup
			set nowritebackup
			" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
			" delays and poor user experience
			set updatetime=300


			" Make <CR> to accept selected completion item or notify coc.nvim to format
			" <C-g>u breaks current undo, please make your own choice.
			inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
			\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
			" Navigate suggestion list with tab and shift-tab
			inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
			inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"

			" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
			autocmd BufEnter * if winnr() == winnr('h') && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
			\ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

			" Start NERDTree. If a file is specified, move the cursor to its window.
			autocmd StdinReadPre * let s:std_in=1
			autocmd VimEnter * NERDTree | if argc() > 0 || exists('s:std_in') | wincmd p | endif

			let g:coc_filetype_map = {'tex': 'latex'}
			let g:coc_config_home = "${coc-config}"

			let g:tmux_navigator_no_mappings = 1
			" noremap <silent> <C-i> :<C-U>TmuxNavigateLeft<cr>
			" noremap <silent> <C-n> :<C-U>TmuxNavigateDown<cr>
			" noremap <silent> <C-e> :<C-U>TmuxNavigateUp<cr>
			" noremap <silent> <C-o> :<C-U>TmuxNavigateRight<cr>
			noremap <silent> <C-h> :<C-U>TmuxNavigateLeft<cr>
			noremap <silent> <C-j> :<C-U>TmuxNavigateDown<cr>
			noremap <silent> <C-k> :<C-U>TmuxNavigateUp<cr>
			noremap <silent> <C-l> :<C-U>TmuxNavigateRight<cr>


			" Noremap i h
			" Noremap <S-i> <S-h>
			" Noremap n j
			" Noremap <S-n> <S-j>
			" Noremap e k
			" Noremap <S-e> <S-k>
			" Noremap o l
			" Noremap <S-o> <S-l>
			" Noremap h i
			" Noremap <S-h> <S-i>
			" Noremap l o
			" Noremap <S-l> <S-o>
			" Noremap j e
			" Noremap <S-j> <S-e>
			" Nnoremap k n
			" Nnoremap <S-k> <S-n>
			" Let NERDTreeMapOpenExpl='\e'
			'';
		};
	};
} 
