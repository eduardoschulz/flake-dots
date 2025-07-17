{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./modules/kubernetes.nix
      ./modules/cockpit.nix
      ./modules/docker.nix
      ./modules/k3s.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixserver"; # Define your hostname.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  nix = {
    settings = {
      warn-dirty = true;
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11"
    "nvidia-settings"
  ];
  nixpkgs.config.nvidia.acceptLicense = true;
  # Enable the X11 windowing system.
  services.xserver.enable = false;


  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    datacenter.enable = false;
  };

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
    extraGroups = [ "wheel" "docker" ];
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


  services.cloudflared = {
    enable = true;
    tunnels = {
      "ad2f2b43-48ca-4ca7-974c-e689d07f64a3" = {
        credentialsFile = "/home/eduardo/.cloudflare/token";
        default = "https_status:404";
      };
    };
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  networking.interfaces.enp3s0 = {
    useDHCP = false;
    ipv4.addresses = [{
      address = "192.168.0.100";
      prefixLength = 24;
    }];
  };

  networking.defaultGateway = "192.168.0.1";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];


  system.stateVersion = "25.05"; # Did you read the comment?

}

