{ config, pkgs, ... }: {

  imports = [
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

  #Bluetooth 
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  service.blueman.enable = true;


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
    loader.timeout = 0;

  };

  services = {
    xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      layout = "br";
      xkbVariant = "thinkpad";
      displayManager = {
        gdm.enable = true;
      };
    };
  };

  service.dbus.enable = true;
  service.picom.enable = true;

  console.keyMap = "br-abnt2";


  networking = {
    hostName = "voyager";
    hostId = "19499fb6";
    firewall.enable = false;
    networkmanager.enable = true;
    usePredictableInterfaceNames = true;
  };

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

  #Audio Configuration
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.eduardo = {
    isNormalUser = true;
    description = "Eduardo";
    extraGroups = [ "networkmanager" "wheel" "video" "docker" "adbusers" ];
  };

  environment.systemPackages = with pkgs; [
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


  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  virtualisation.libvirtd.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
  ];

  virtualisation.docker.enable = true;


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
}
