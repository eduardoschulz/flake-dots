{ config, pkgs, inputs, ... }:
let
  username = "eduardo";

in
{

  imports = [
    ../../nvim/nvim.nix
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


  };
  programs.home-manager.enable = true;
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";

    packages = with pkgs; [
    
      neofetch
    
      dunst
      feh
      git
      unzip
      virt-manager
      xdg-desktop-portal-gtk
      zoxide
      discord
      pandoc
      pavucontrol
      screen
      transmission-gtk
      htop
      meslo-lg
      kubectl
      networkmanagerapplet
      pasystray
      ungoogled-chromium

    ];
  };

  programs.kitty.enable = true;
  programs.alacritty = {
    enable = false;
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

  services.dunst = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
  };

  services.picom = {
    enable = true;
    vSync = true;
  };

}
