{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  nix = {
    settings = {
       warn-dirty = true;
       experimental-features = "nix-command flakes";
       auto-optimise-store = true;
    };
  };

	security = {
		rtkit.enable = true;
		polkit.enable = true;
	};

	nixpkgs.config = {
		allowUnfree = true;
		allowUnfreePredicate = pkg: builtins.elem (builtins.parseDrvName pkg.name).name ["steam"];
	};

  # Bootloader.
  boot.loader.systemd-boot.enable = true;

	systemd = {
    # Create a separate slice for nix-daemon that is
    # memory-managed by the userspace systemd-oomd killer
    slices."nix-daemon".sliceConfig = {
      ManagedOOMMemoryPressure = "kill";
      ManagedOOMMemoryPressureLimit = "50%";
    };
    services."nix-daemon".serviceConfig.Slice = "nix-daemon.slice";

    # If a kernel-level OOM event does occur anyway,
    # strongly prefer killing nix-daemon child processes
    services."nix-daemon".serviceConfig.OOMScoreAdjust = 1000;
  };


  boot.loader.efi.canTouchEfiVariables = true;
 # boot.supportedFilesystems = [ "zfs" ];
 # boot.zfs.forceImportRoot = false;
  networking.hostId = "19499fb6";

  networking.hostName = "core"; # Define your hostname.
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    enable = true;
		layout = "us";
    xkbVariant = "";
		displayManager.gdm.enable = true;
		desktopManager.gnome.enable = true;
		windowManager.dwm.enable = true;
		libinput.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  #sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.eduardo = {
    isNormalUser = true;
    description = "Eduardo";
    extraGroups = [ "networkmanager" "wheel" "video" "docker" "adbusers" ];
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages

	
  # List packages installed in system profile. To search, run:
  # $ nix search wget
		environment.systemPackages = with pkgs; [
			neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
				wget
				iperf3
				git
				pciutils
				home-manager
				steam-run
				steam
				jre_minimal
				lact
		];
	

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

  # Open ports in the firewall.
   networking.firewall.enable = false;
   #networking.firewall.allowedTCPPorts = [ 9001 9002 3000 ];
   #networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
};	
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };


  # ld fix
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
		texlab 
		jre17_minimal
		jre8
	# add libs
  ];
  
#	hardware.opengl = {
#		enable = true;
#		driSupport = true;
#		driSupport32Bit = true;
#	};



  virtualisation.docker.enable = true;
  networking.usePredictableInterfaceNames = true;

 
  systemd.services.lactd = {
    description = "AMDGPU Control Daemon";
    enable = true;  
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    wantedBy = ["multi-user.target"];
  };



services.tailscale.enable = true;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
