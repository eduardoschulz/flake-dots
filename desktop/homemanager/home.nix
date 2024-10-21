{ config, pkgs, inputs, ...}: let
	username = "eduardo";

in {

	imports = [
		../../nvim/nvim.nix
	];

	fonts = {
		fontconfig.enable = true;
		};

	xdg = {
		enable = true;
		userDirs = {
			enable = true;
			createDirectories = true;
		};
	};

	catppuccin.flavor = "macchiato";

	nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };

		/* overlays = [
			(final: prev: {
			 st = prev.st.overrideAttrs (old: {src = /home/eduardo/.config/st;}); 
			 })
		]; */
  };	

	programs.home-manager.enable = true;
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
			dmenu
			slstatus
			dunst
			kubectl
			networkmanagerapplet 
			pasystray
			obsidian
		];
	};
	
	programs.alacritty = {
		enable = true;
		catppuccin.enable = true;
		settings = {
			window = {
				opacity = 0.9;
				blur = true;
				decorations = "full";
				dynamic_title = true;
			};
			bell.animation = "EaseOutExpo";
			bell.duration = 0;

		#	colors = {
		#		bright = {
		#			black = "0x988BA2";
		#			blue = "0x96CDFB";
	#				cyan = "0x89DCEB";
	#				green = "0xABE9B3";
	#				magenta = "0xF5C2E7";
	#				red = "0xF28FAD";
	#				white = "0xD9E0EE";
	#				yellow = "0xFAE3B0";
	#			};
	#			cursor = {
	#				cursor = "0xF5E0DC";
	#				text = "0x1E1D2F";
	#			};
	#			normal = {
	#				black = "0x6E6C7E";
	#				blue = "0x96CDFB";
	#				cyan = "0x89DCEB";
	#				green = "0xABE9B3";
	#				magenta = "0xF5C2E7";
	#				red = "0xF28FAD";
	#				white = "0xD9E0EE";
	#				yellow = "0xFAE3B0";
	#			};
	#			primary = {
	#				background = "0x1E1D2F";
	#				foreground = "0xD9E0EE";
	#			};
	#		};
			
			font = {
				size = 14;
				normal.family = "Meslo LG L ";
				italic.family = "Meslo LG L ";
				bold.family = "Meslo LG L ";
		};

		mouse = {
			hide_when_typing = true;
		};
		};


	};
	
services.dunst = {
	enable = true;
	catppuccin.enable = true;
};

 stylix = { #TODO figure out how this thing works
    targets.gtk.enable = false;
    targets.firefox.enable = false;
	};


programs.tmux = { enable = true;
	keyMode = "vi";
};

services.picom = {
	enable = true;
	vSync = true;
};

}
