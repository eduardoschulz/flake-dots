{
  description = "My NixOS configuration flake";

  inputs = {
    # NixOS official package source, here using the nixos-25.05 branch
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";
    dwm-flake.url = "github:eduardoschulz/dwm";
    st-flake.url = "github:eduardoschulz/st";
    sops-nix.url = "github:Mic92/sops-nix";

  };

  outputs = { self, nixpkgs, home-manager, catppuccin, dwm-flake, st-flake, sops-nix, ... }:
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
    in
    {
      formatter.${system} = pkgs.nixpkgs-fmt;
      nixosConfigurations = {
        desktop = lib.nixosSystem {
          inherit system;
          modules = [
            desktop/os/configuration.nix
            {
              nixpkgs.overlays = [ dwmOverlay ];
            }
            sops-nix.nixosModules.sops
          ];
        };

        laptop = lib.nixosSystem {
          inherit system;
          modules = [
            laptop/os/configuration.nix
            {
              nixpkgs.overlays = [ dwmOverlay ];
            }
          ];
        };

        server = lib.nixosSystem {
          inherit system;
          modules = [
            sops-nix.nixosModules.sops
            server/os/configuration.nix
            { }
          ];
        };
      };
      hmConfig = {
        desktop = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = [
            catppuccin.homeModules.catppuccin
            desktop/homemanager/home.nix
            {
              nixpkgs.overlays = [ stOverlay ];
            }
          ];
        };

        server = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = [
            server/homemanager/home.nix
            { }
          ];
        };

        laptop = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = [
            catppuccin.homeModules.catppuccin
            laptop/homemanager/home.nix
            {
              nixpkgs.overlays = [ stOverlay ];
            }
          ];
        };
      };
    };
}
