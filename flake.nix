{
  description = "My NixOS configuration flake";

  inputs = {
    # NixOS official package source, here using the nixos-23.11 branch
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    stylix = { url = "github:danth/stylix"; };
    dwm.url = "github:eduardoschulz/dwm";
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, stylix, dwm, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        desktop = lib.nixosSystem {
          inherit system;
          modules = [
            desktop/os/configuration.nix
            {
              environment.systemPackages = with pkgs;
                [ dwm.packages.${system}.dwm ];
            }
          ];
        };

        laptop = lib.nixosSystem {
          inherit system;
          modules = [
            laptop/os/configuration.nix
					];
        };

      };
      hmConfig = {
        desktop = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = [
            catppuccin.homeManagerModules.catppuccin
            stylix.homeManagerModules.stylix
            desktop/homemanager/home.nix
          ];
        };

        laptop = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = [
            catppuccin.homeManagerModules.catppuccin
            stylix.homeManagerModules.stylix
            laptop/homemanager/home.nix
          ];
        };
      };
    };
}
