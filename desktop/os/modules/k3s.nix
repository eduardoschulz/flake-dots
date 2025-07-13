{ config, lib, pkgs, ... }:

{
  # Define o secret via sops-nix
  sops.secrets."tokenk3s" = {
    mode = "0400";
    owner = "root";
    path = "/run/secrets/k3s-token";
  };

  # Configura o serviço do k3s
  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = config.sops.secrets."tokenk3s".path;
    serverAddr = "https://192.168.0.129:6443";
  };
}

