{
  hardware.nvidia-container-toolkit.enable = true;

  virtualisation.docker = {
    enable = true;
    liveRestore = false;
    daemon.settings = { "metrics-addr" = "0.0.0.0:9323"; };
  };
}
