{ config, pkgs, ... }: {

  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix = {
    settings = {
      warn-dirty = true;
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg:
        builtins.elem (builtins.parseDrvName pkg.name).name [
          "steam"
          "steam-run"
        ];
    };
  };
  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  boot = {

    plymouth = {
      enable = true;
      theme = "hexagon";
      themePackages = with pkgs;
        [
          # By default we would install all themes
          (adi1090x-plymouth-themes.override {
            selected_themes = [ "hexagon" ];
          })
        ];
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd.luks.devices."luks-701dbd51-f2f6-47a8-8813-187b050f2ab1".device =
      "/dev/disk/by-uuid/701dbd51-f2f6-47a8-8813-187b050f2ab1";

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

  # Enable "Silent Boot"

  networking.hostName = "nixos"; # Define your hostname.
  programs.hyprland.enable = true;
  services = {
    dbus.enable = true;
    picom.enable = true;
    blueman.enable = true;
    # Bootloader.

    xserver = {
      enable = true;
      windowManager.dwm.enable = true;
    #  libinput.enable = true;  
    #	videoDrivers = [ "auto" ];
      desktopManager.gnome.enable = true;
      layout = "br";
      xkbVariant = "thinkpad";
      displayManager = {
          sddm.enable = true;
          #lightdm.enable = true;
   #   setupCommands = ''
   #     ${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --primary --mode 1600x900 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off
   #   '';
      #    autoLogin = {
      #      enable = false; 
      #      user = "eduardo";
      #      };
       };
    };
  };

  console.keyMap = "br-abnt2";

  networking.hostId = "19499fb6";

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

  environment.systemPackages = with pkgs; [
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    iperf3
    git
    pciutils
    curl
    acpi

    steam-run-free
  ];

  fonts = {
    packages = with pkgs; [
        nerd-fonts.code-new-roman
        nerd-fonts.symbols-only
    ];

  };
  programs.mtr.enable = true;
  services.openssh.enable = true;

  networking = {

    firewall.enable = false;
    /* firewall.allowedTCPPorts = [];
       firewall.allowedUDPPorts = [];
    */
  };

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

  services.printing = {
    enable = true;
    drivers = with pkgs; [ hplip ];
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
