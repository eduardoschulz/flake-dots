{
  description = "My NixOS configuration flake";

  inputs = {
    # NixOS official package source, here using the nixos-23.11 branch
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
#    stylix = { url = "github:danth/stylix"; };
    dwm-flake.url = "github:eduardoschulz/dwm";
    st-flake.url = "github:eduardoschulz/st";
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, dwm-flake, st-flake, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
      dwmOverlay = final: prev: {
        dwm = dwm-flake.defaultPackage.${system};  
      };
      stOverlay = final: prev: {
        st = st-flake.defaultPackage.${system};  
      };
    in {
      nixosConfigurations = {
        desktop = lib.nixosSystem {
          inherit system;
          modules = [
            desktop/os/configuration.nix
            {
                nixpkgs.overlays = [dwmOverlay];
            }
          ];
        };

        laptop = lib.nixosSystem {
          inherit system;
          modules = [
            laptop/os/configuration.nix
            {
                nixpkgs.overlays = [dwmOverlay ];
            }
          ];
        };

      };
      hmConfig = {
        desktop = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = [
            catppuccin.homeManagerModules.catppuccin
            #stylix.homeManagerModules.stylix
            desktop/homemanager/home.nix
            { 
                nixpkgs.overlays = [stOverlay];
            }      

          ];
        };

        laptop = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = [
            catppuccin.homeManagerModules.catppuccin
            # stylix.homeManagerModules.stylix
            laptop/homemanager/home.nix
            {
                nixpkgs.overlays = [stOverlay];
            }
          ];
        };
      };
    };
}
