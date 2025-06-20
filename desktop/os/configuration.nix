{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/zerotier/zerotier.nix
  ];
systemd.services.nix-daemon.environment.TMPDIR = "/var/tmp";

  nix = {
    settings = {
      warn-dirty = true;
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = pkg:
      builtins.elem (builtins.parseDrvName pkg.name).name [ "steam" ];
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    plymouth = {
      enable = true;
      theme = "abstract_ring_alt";
      themePackages = with pkgs;
        [
          # By default we would install all themes
          (adi1090x-plymouth-themes.override {
            selected_themes = [ "abstract_ring_alt" ];
          })
        ];
    };

    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;

  };

  # Bootloader.

  services = {
    dbus.enable = true;
    picom.enable = true;


  pulseaudio.enable = false;

    displayManager.sddm = {
        enable = true;
        theme = "purple_leaves";

    };



    xserver = {
      enable = true;
      windowManager.dwm.enable = true;
      videoDrivers = [ "amdgpu" "nouveau" ];

      config = ''
        Section "Device"
            Identifier "AMD"
            Driver "amdgpu"
            BusID "PCI:0:1:0"  
        EndSection

        Section "Device"
            Identifier "NVIDIA"
            Driver "nouveau"
            BusID "PCI:0:2:0"  
        EndSection
      '';

      xkb.layout = "us";
      desktopManager.gnome.enable = true;
      /* displayManager = {
        lightdm.enable = true;
        #setupCommands = ''
        #  ${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --off --output DP-2 --off --output DP-3 --off --output HDMI-1 --mode 1920x1080 --pos 0x0 --rotate normal
        #'';
        autoLogin = {
          enable = false;
          user = "eduardo";
        };
      }; */


    };
  };
  programs.hyprland = {
    enable = true;
  };

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
    extraGroups = [ "networkmanager" "wheel" "video" "dialout" "docker" "adbusers" ];
    shell = pkgs.zsh;
  };

    programs.zsh.enable = true;
  # Allow unfree packages

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    minikube
    iperf3
    git
    pciutils
    home-manager
    steam-run
    steam
    jre_minimal
    lact
    sddm-astronaut
  ];
  fonts = {
    packages = with pkgs; [
        nerd-fonts.code-new-roman
        nerd-fonts.symbols-only
    ];

  };

  # dwm.packages.${pkgs.system}.dwm
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.X11Forwarding = true;
  };

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

  virtualisation.docker = {
    enable = true;
    liveRestore = false;
    daemon.settings = { "metrics-addr" = "0.0.0.0:9323"; };
  };
  services.grafana = {
    enable = true;
    settings = {
      security.admin_password = "admin";
      server = {
        # Listening Address
        http_addr = "127.0.0.1";
        # and Port
        http_port = 3000;
        # Grafana needs to know on which domain and URL it's running
        #domain = "your.domain";
      #  root_url =
      #    "https://core.casa/grafana/"; # Not needed if it is `https://your.domain/`
        serve_from_sub_path = true;

      };
    };
  };

  networking.usePredictableInterfaceNames = true;

  systemd.services.lactd = {
    description = "AMDGPU Control Daemon";
    enable = true;
    serviceConfig = { ExecStart = "${pkgs.lact}/bin/lact daemon"; };
    wantedBy = [ "multi-user.target" ];
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "5s"; # "1m"
     exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9100;
      };
    };
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [{
          targets = [
            "localhost:${
              toString config.services.prometheus.exporters.node.port
            }"
            "192.168.122.230:9100"
            "192.168.122.78:9100"
            "192.168.122.82:9100"
          ];
        }];

      }

      {
        job_name = "docker";
        static_configs = [{
          targets = [
            "192.168.122.230:9323"
            "192.168.122.78:9323"
            "192.168.122.82:9323"
          ];
        }];
      }
    ];
  };
  services.cockpit = {
    enable = true;
    port = 9000;
    settings = {
        WebService = {
            AllowUnencrypted = true;
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
  system.stateVersion = "24.11"; # Did you read the comment?

}
