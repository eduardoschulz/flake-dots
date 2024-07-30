{
  description = "My NixOS configuration flake";

  inputs = {
    # NixOS official package source, here using the nixos-23.11 branch
#    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs"; 
		};
  };

  outputs = { self, nixpkgs, home-manager, ... }:
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
				
				modules = [ ./home.nix ];
			};
		};
	};
}
