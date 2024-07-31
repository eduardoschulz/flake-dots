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
	

 stylix = {
    targets.gtk.enable = false;
    targets.firefox.enable = false;
	};

# programs.nixvim = {
#	 enable = true;
#	 defaultEditor = true;
# 	 plugins = {
#		harpoon = {
#			enable = true;
#		};
#	};
# };

programs.neovim = {
	enable = false;
	defaultEditor = true;
	
	extraPackages = [
		pkgs.shfmt
	];

	plugins = [
		pkgs.vimPlugins.telescope-nvim
		{
			plugin = pkgs.vimPlugins.vimtex;
			config = "let g:vimtex_enabled = 1";
		}
		pkgs.vimPlugins.dracula-nvim

	];
	
	extraLuaConfig = ''
		vim.opt.relativenumber = true

		require('telescope').setup()
		'';
	viAlias = true;	
};


programs.tmux = {
	enable = true;
	keyMode = "vi";

};

}
