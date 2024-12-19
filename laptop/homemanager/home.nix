{config, pkgs, inputs, ...}: let
	username = "eduardo";

in {
	
	imports = [
		../../nvim/nvim.nix
        ../hypr.nix
	];


	fonts.fontconfig.enable = true;
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
		overlays = [
				(final: prev: {
					slstatus = prev.slstatus.overrideAttrs (old: {src = /home/eduardo/.config/slstatus;});
					st = prev.st.overrideAttrs (old: {src = /home/eduardo/.config/st;});
					surf = prev.surf.overrideAttrs (old: {src = /home/eduardo/.config/surf;});
				})
			];

			
  };	
	programs.home-manager.enable = true;
	home = {
		username = "${username}";
		homeDirectory = "/home/${username}";
		stateVersion = "24.05";

		packages = with pkgs; [
			wget
            jq
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
			st
			dmenu
			dunst
			kubectl
			networkmanagerapplet 
			pasystray
			obsidian
			slstatus
			surf
			nitrogen
            bemenu

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

			font = {
				size = 12;
				normal.family = "Meslo LG L ";
				italic.family = "Meslo LG L ";
				bold.family = "Meslo LG L ";
		};

		mouse = {
			hide_when_typing = true;
		};
		};


	};
	
programs.waybar = {
    enable = true;
    systemd.enable = true;

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
