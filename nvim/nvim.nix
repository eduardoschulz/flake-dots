/*
	Configuration for Desktop and Laptop Neovim.
*/
{pkgs, ...}:
	let
    		toLua = str: "lua << EOF\n${str}\nEOF\n";
    		toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";

				/* Spell Dictionaries */
				nvim-spell-pt-utf8-dictionary = builtins.fetchurl {
					url = "http://ftp.vim.org/vim/runtime/spell/pt.utf-8.spl";
					sha256 = "0fxnd9fvvxawmwas9yh47rakk65k7jjav1ikzcy7h6wmnq0c2pry";
				};

				nvim-spell-en-utf8-dictionary = builtins.fetchurl {
					url = "http://ftp.vim.org/vim/runtime/spell/en.utf-8.spl";
					sha256 = "0w1h9lw2c52is553r8yh5qzyc9dbbraa57w9q0r9v8xn974vvjpy";
				};
in
{
programs.neovim = {
		enable = true;
		extraPackages = with pkgs; [

            tectonic
			clang-tools
			nil
			asm-lsp
			gopls
			lua-language-server
			xclip
			wl-clipboard
            texlab
            ltex-ls
		];

		plugins = with pkgs.vimPlugins; [
		
			{
				plugin = nvim-lspconfig;
				config = toLuaFile ./plugin/lsp.lua; 
			}

			{
				plugin = comment-nvim;
				config = toLua "require(\"Comment\").setup()";
			}
			{
				plugin = lsp-zero-nvim;
				config = toLuaFile ./plugin/lsp.lua; 
			}

			{
				plugin = cmp-nvim-lsp;
				config = toLuaFile ./plugin/lsp.lua;
			}
			
			{
				plugin = nvim-cmp;
				config = toLuaFile ./plugin/lsp.lua;
			}

			{
				plugin = trouble-nvim;
				config = toLuaFile ./plugin/trouble.lua;
			}

			{
				plugin = lualine-nvim;
				config = toLuaFile ./plugin/line.lua;
			}

			{
				plugin = nvim-treesitter.withAllGrammars;
				config = toLuaFile ./plugin/ts.lua;
			}
			{
				plugin = nvim-web-devicons;
				config = toLua "require'nvim-web-devicons'.get_icons()";
			}
			{ 
				plugin = telescope-nvim;
				config = toLuaFile ./plugin/telescope.lua;
			}
            {
                plugin = chadtree;
                config = toLuaFile ./plugin/chadtree.lua;
            }
            
            {
                plugin = neoproj;
                config = toLuaFile ./plugin/neoproj.lua;
            }

			/* {
				plugin = luasnip;
				config = toLua "require('luasnip.loaders.from_vscode').lazy_load()";
			} */

			telescope-file-browser-nvim
#			nvim-treesitter.withAllGrammars
			nvim-treesitter-textobjects
			nvim-treesitter-endwise
			luasnip
			cmp_luasnip
			cmp-nvim-lsp
			friendly-snippets
			catppuccin-nvim
			cmp-path
			cmp-buffer
		];
		
		extraLuaConfig = ''
			${builtins.readFile ./options.lua}
		'';
	};

	xdg.configFile."nvim/spell/pt.utf-8.spl".source = nvim-spell-pt-utf8-dictionary;
	xdg.configFile."nvim/spell/en.utf-8.spl".source = nvim-spell-en-utf8-dictionary;
}
