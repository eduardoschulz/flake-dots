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
    ../homemanager/modules/zsh.nix
    ../homemanager/modules/browsers.nix
    ../homemanager/modules/term.nix
    ../homemanager/modules/services.nix
    ../homemanager/modules/waybar/waybar.nix
    ../homemanager/modules/rofi/rofi.nix 

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
    sessionVariables.NIXOS_OZONE_WL = "1";
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
      gimp
      git
      unzip
      virt-manager
      xdg-desktop-portal-gtk
      zoxide
      arduino-ide
      discord
      zathura
      pandoc
      pavucontrol
      screen
      transmission-gtk
      htop
      meslo-lg
      vesktop
      vencord
      mangohud
      dmenu
      slstatus
      networkmanagerapplet
      pasystray
      libnotify
      obsidian
      gnuplot
      st
      nitrogen
      mpv-unwrapped
      arandr
      wofi
      whitesur-cursors
      hyprpaper
      ungoogled-chromium
      hyprpolkitagent
      wl-clipboard
      hyprshot
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


  programs.ranger.enable = true;

  programs.tmux = {
    enable = true;
    keyMode = "vi";
  };


  gtk.cursorTheme = {
    name = "WhiteSur-cursors";
    size = 24;
    package = pkgs.whitesur-cursors;
  };

}
