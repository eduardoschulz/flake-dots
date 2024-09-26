/* A configuration that applies to both setups  */
{ config, pkgs, ...}:
{
	nix = {
    settings = {
       warn-dirty = true;
       experimental-features = "nix-command flakes";
       auto-optimise-store = true;
    };
  };

	nixpkgs = {
		overlays = [
			(final: prev: {
				dwm = prev.dwm.overrideAttrs (old: {src = ./dwm;});
				})
			];
	};
	fonts = {
		packages = with pkgs; [
			(nerdfonts.override { fonts = [  "CodeNewRoman" "NerdFontsSymbolsOnly" ]; })
		];
	};

}
