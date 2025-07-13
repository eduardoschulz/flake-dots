{
  hardware.nvidia-container-toolkit.enable = true;

  virtualisation.docker = {
    enable = true;
    liveRestore = false;
    daemon.settings = { "metrics-addr" = "0.0.0.0:9323"; };
    daemon.settings.features.cdi = true;
    rootless.daemon.settings.features.cdi = true;
  };
}
