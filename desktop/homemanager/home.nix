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
			#fuse-common
			freetype
			gcc
			gimp
			git
			unzip
			virt-manager
			xdg-desktop-portal-gtk
			zoxide
			firefox
			arduino-ide
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
			networkmanagerapplet 
			pasystray
			obsidian
            gnuplot
            st
            nitrogen
            mpv-unwrapped
            arandr
		];
	};
	
    programs.kitty = {
       enable = true;
       catppuccin.enable = true;
       font = {
           size = 14;
           name = "Meslo LG L ";
       };
       settings = {

           background_opacity = 0.9;
           confirm_os_window_close = 0;
           background_blur = 1;
       };

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

 /* stylix = { #TODO figure out how this thing works
    targets.gtk.enable = false;
    targets.firefox.enable = false;
	}; */

programs.ranger = {
    
};
programs.tmux = { enable = true;
	keyMode = "vi";
};

services.picom = {
	enable = true;
	vSync = true;
};


wayland.windowManager.hyprland = {
    
    enable = true;
    settings = {
        
        "$mod" = "SUPER";

    };

};





}
