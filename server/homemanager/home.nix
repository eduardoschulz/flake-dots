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

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  programs.home-manager.enable = true;

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";

    packages = with pkgs; [
    ];

    programs.tmux = {
      enable = true;
      keyMode = "vi";
    };

  }
