{ config, pkgs, inputs, ...}: let
	username = "eduardo";
	nixvimconfig = import ./nixvim;

in {
	fonts.fontconfig.enable = true;
	xdg = {
		enable = true;
		userDirs = {
			enable = true;
			createDirectories = true;
		};
	};


	nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };	

	home = {
		username = "${username}";
		homeDirectory = "/home/${username}";
		stateVersion = "24.05";

		packages = with pkgs; [
			wget
			neofetch
			cargo
			dunst
			feh
			fuse-common
			freetype
			gcc
			gimp
			git
			alacritty
			unzip
			virt-manager
			xdg-desktop-portal-gtk
			zoxide
			firefox
			arduino
			discord
			zathura
			pandoc
			texliveFull
			pavucontrol
			nerdfonts
			gopls
			go
			screen
			transmission-gtk
			librewolf
			htop
			meslo-lg
			vesktop
			vencord
			mangohud
			st
			dmenu
			slstatus
			dunst
		];
	};
	
	programs.alacritty = {
		enable = true;
		settings = {
			window.opacity = 0.9;
			window.blur = true;
			#window.dimensions = {
			#lines = 3;
			#	columns = 200;
			#};
			font = {
				normal.family = "Bitstream Vera Sans Mono";
			};
			
		};
	};
	

 stylix = { #TODO figure out how this thing works
    targets.gtk.enable = false;
    targets.firefox.enable = false;
	};

#TODO Split into multiple config files
 programs.nixvim = {
	 enable = true;
	 defaultEditor = true;
	 colorschemes.catppuccin = {
	 	enable = true;
		settings.background.dark = "mocha";
	 };
 	 plugins = {
		harpoon = {
			enable = true;
		};

		telescope = {
			enable = true;
		};
		lsp = {
			enable = true;
			servers = {
				gopls.enable = true;
				marksman.enable = true;
			};







		};

		luasnip.enable = true;
		cmp-buffer = { enable = true; };
		cmp-emoji = { enable = true; };
		cmp-nvim-lsp = { enable = true; };
		cmp-path = { enable = true; };
		cmp_luasnip = { enable = true; };
		cmp = {
			enable = true;

			settings = {
				experimental = { ghost_text = true; };
				snippet.expand = ''
					function(args)
					require('luasnip').lsp_expand(args.body)
					end
					'';
				sources = [
				{ name = "nvim_lsp"; }
				{ name = "luasnip"; }
				{
					name = "buffer";
					option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
				}
				{ name = "nvim_lua"; }
				{ name = "path"; }
				{ name = "copilot"; }
				];

				formatting = {
					fields = [ "abbr" "kind" "menu" ];
					format =
# lua
						''
						function(_, item)
						local icons = {
							Namespace = "󰌗",
							Text = "󰉿",
							Method = "󰆧",
							Function = "󰆧",
							Constructor = "",
							Field = "󰜢",
							Variable = "󰀫",
							Class = "󰠱",
							Interface = "",
							Module = "",
							Property = "󰜢",
							Unit = "󰑭",
							Value = "󰎠",
							Enum = "",
							Keyword = "󰌋",
							Snippet = "",
							Color = "󰏘",
							File = "󰈚",
							Reference = "󰈇",
							Folder = "󰉋",
							EnumMember = "",
							Constant = "󰏿",
							Struct = "󰙅",
							Event = "",
							Operator = "󰆕",
							TypeParameter = "󰊄",
							Table = "",
							Object = "󰅩",
							Tag = "",
							Array = "[]",
							Boolean = "",
							Number = "",
							Null = "󰟢",
							String = "󰉿",
							Calendar = "",
							Watch = "󰥔",
							Package = "",
							Copilot = "",
							Codeium = "",
							TabNine = "",
						}

					local icon = icons[item.kind] or ""
						item.kind = string.format("%s %s", icon, item.kind or "")
						return item
						end
						'';
				};

				window = {
					completion = {
						winhighlight =
							"FloatBorder:CmpBorder,Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel";
						scrollbar = false;
						sidePadding = 0;
						border = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
					};

					settings.documentation = {
						border = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
						winhighlight =
							"FloatBorder:CmpBorder,Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel";
					};
				};

				mapping = {
					"<C-n>" = "cmp.mapping.select_next_item()";
					"<C-p>" = "cmp.mapping.select_prev_item()";
					"<C-j>" = "cmp.mapping.select_next_item()";
					"<C-k>" = "cmp.mapping.select_prev_item()";
					"<C-d>" = "cmp.mapping.scroll_docs(-4)";
					"<C-f>" = "cmp.mapping.scroll_docs(4)";
					"<C-Space>" = "cmp.mapping.complete()";
					"<S-Tab>" = "cmp.mapping.close()";
					"<Tab>" =
# lua 
						''
						function(fallback)
						local line = vim.api.nvim_get_current_line()
						if line:match("^%s*$") then
							fallback()
								elseif cmp.visible() then
								cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
						else
							fallback()
								end
								end
								'';
					"<Down>" =
# lua
						''
						function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
								elseif require("luasnip").expand_or_jumpable() then
								vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
						else
							fallback()
								end
								end
								'';
					"<Up>" =
# lua
						''
						function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
								elseif require("luasnip").jumpable(-1) then
								vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
						else
							fallback()
								end
								end
								'';
				};
			};
		};

	};
 };


programs.tmux = { enable = true;
	keyMode = "vi";

};

}
