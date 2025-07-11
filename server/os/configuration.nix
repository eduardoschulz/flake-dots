{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixserver"; # Define your hostname.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
   time.timeZone = "America/Sao_Paulo";

  # Enable the X11 windowing system.
  services.xserver.enable = false;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.desktopManager.gnome.enable = false;

  systemd.targets = {
     sleep.enable = false;
     suspend.enable = false;
     hibernate.enable = false;
     hybrid-sleep.enable = false;

  };
  
  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  users.users.eduardo = {
    isNormalUser = true;
    description = "Eduardo";
    extraGroups = [  "wheel" "docker" ];
  };

  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     git
   ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.openssh = {
     enable = true;
     settings = {
	PermitRootLogin = "yes";
};

};

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
   networking.firewall.enable = false;

  system.stateVersion = "25.05"; # Did you read the comment?

}

