{
  description = "My NixOS configuration flake";

  inputs = {
    # NixOS official package source, here using the nixos-23.11 branch
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
#		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
#			inputs.nixpkgs.follows = "nixpkgs"; 
		};
		#nixvim = {
		#  url = "github:nix-community/nixvim";
		#	inputs.nixpkgs.follows = "nixpkgs";
		#};
		catppuccin.url = "github:catppuccin/nix";
		stylix = {
			url = "github:danth/stylix";
		};
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, stylix, ... }:
	let
		system = "x86_64-linux";
		pkgs = import nixpkgs {
			inherit system;
			config.allowUnfree = true;
		};
      	lib = nixpkgs.lib;
	in {
		nixosConfigurations = {
			eduardo = lib.nixosSystem {
				inherit system;
				modules = [ ./configuration.nix ];
			};
		};
		hmConfig = {
			eduardo = home-manager.lib.homeManagerConfiguration {
				pkgs = import nixpkgs { inherit system; };
				modules = [catppuccin.homeManagerModules.catppuccin stylix.homeManagerModules.stylix ./home.nix ];
			};
		};
	};
}
