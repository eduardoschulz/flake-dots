{pkgs, ...}: let
	username = "eduardo";
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
			neovim
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
			mpv
			transmission-gtk
			librewolf
			htop
			meslo-lg
			vesktop
			vencord
			mangohud
			st
			dmenu
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



}
