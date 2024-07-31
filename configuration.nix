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

	nixpkgs.config = {
		allowUnfree = true;
		allowUnfreePredicate = pkg: builtins.elem (builtins.parseDrvName pkg.name).name ["steam"];
	};

	security = {
		rtkit.enable = true;
		polkit.enable = true;
	};


  # Bootloader.
  boot.loader.systemd-boot.enable = true;

  services = {
    dbus.enable = true;
    picom.enable = true;

    xserver = {
      enable = true;
      windowManager.dwm.enable = true;
      layout = "us";
			desktopManager.gnome.enable = true;
      displayManager = {
        lightdm.enable = true;
        #setupCommands = ''
        #  ${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --off --output DP-2 --off --output DP-3 --off --output HDMI-1 --mode 1920x1080 --pos 0x0 --rotate normal
        #'';
        autoLogin = {
          enable = false; 
          user = "eduardo";
        };
      };
    };
  };

  nixpkgs.overlays = [
    (final: prev: {
      dwm = prev.dwm.overrideAttrs (old: {src = /home/eduardo/.config/dwm;}); #FIX ME: Update with path to your dwm folder
    })
  ];

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
#  services.xserver = {
#    enable = true;
#		layout = "us";
#    xkbVariant = "";
#		displayManager.gdm.enable = true;
#		desktopManager.gnome.enable = true;
#j		libinput.enable = true;
# };

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
  };

  # Allow unfree packages

	
  # List packages installed in system profile. To search, run:
  # $ nix search wget
		environment.systemPackages = with pkgs; [
			 # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
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

  virtualisation.libvirtd.enable = true;
  # ld fix
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
		texlab 
		jre17_minimal
		jre8
	# add libs
  ];
  

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

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
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
