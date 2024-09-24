{pkgs, ...}:
	let
    		toLua = str: "lua << EOF\n${str}\nEOF\n";
    		toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
in
{
programs.neovim = {
		enable = true;
		extraPackages = with pkgs; [

			nil
			asm-lsp
			gopls
			lua-language-server
			xclip
			wl-clipboard
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

#			nvim-treesitter.withAllGrammars
			nvim-treesitter-textobjects
			nvim-treesitter-endwise
			cmp_luasnip
			cmp-nvim-lsp
			luasnip
			friendly-snippets
			catppuccin-nvim
		];
		
		extraLuaConfig = ''
			${builtins.readFile ./options.lua}
		'';
	};
}
