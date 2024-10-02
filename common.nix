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

	fonts = {
		packages = with pkgs; [
			(nerdfonts.override { fonts = [  "CodeNewRoman" "NerdFontsSymbolsOnly" ]; })
		];
	};

}
