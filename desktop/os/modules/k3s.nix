{ config, lib, pkgs, ... }:

{
  # Define o secret via sops-nix
  /* sops.secrets."tokenk3s" = {
    mode = "0400";
    owner = "root";
    path = "/run/secrets/k3s-token";
  }; */

  # Configura o serviço do k3s
  services.k3s = {
    enable = true;
    role = "agent";
    #  tokenFile = config.sops.secrets."tokenk3s".path;
    token = "K1057fc00131313a95d64b9072cee14c4b8a806ddaa6eb879a7bec601c968dc5f00::server:d0dorl.2184oicbmsg21r2f";
    serverAddr = "https://192.168.0.129:6443";
  };
}

