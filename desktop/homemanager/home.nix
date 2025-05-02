{ config, pkgs, inputs, ... }:

let
  username = "eduardo";
in
{
  imports = [
    ../../nvim/nvim.nix
    ../homemanager/modules/hypr/main.conf
    ../homemanager/modules/hypr/binds.nix
    ../homemanager/modules/hypr/monitor.nix
    ../homemanager/modules/hypr/hyprlock.nix
    ../homemanager/modules/hypr/hyprpaper.nix

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

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  programs.home-manager.enable = true;

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";

    packages = with pkgs; [
      wget
      ags
      neofetch
      cargo
      dunst
      feh
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
      networkmanagerapplet
      pasystray
      obsidian
      gnuplot
      st
      nitrogen
      mpv-unwrapped
      arandr
      wofi
      hyprpaper
      whitesur-cursors
      chromium
    ];

    sessionVariables = {
      XCURSOR_THEME = "WhiteSur-cursors";
      XCURSOR_SIZE = "24";
    };

    file.".icons/default/index.theme".text = ''
      [Icon Theme]
      Inherits=WhiteSur-cursors
    '';
  };

  programs.kitty = {
    enable = true;
    catppuccin.enable = true;
    font = {
      size = 14;
      name = "Meslo LG L";
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
      bell = {
        animation = "EaseOutExpo";
        duration = 0;
      };
      font = {
        size = 14;
        normal.family = "Meslo LG L";
        italic.family = "Meslo LG L";
        bold.family = "Meslo LG L";
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

  programs.ranger.enable = true;

  programs.tmux = {
    enable = true;
    keyMode = "vi";
  };

  services.picom = {
    enable = true;
    vSync = true;
  };

  gtk.cursorTheme = {
    name = "WhiteSur-cursors";
    size = 24;
    package = pkgs.whitesur-cursors;
  };

  programs.waybar.enable = true;

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
    };
  };

  programs.hyprlock.enable = true;
}
