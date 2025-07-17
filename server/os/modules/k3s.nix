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
    role = "server";
    token = "314d6ffb427b9ba2c89704663f5a87d8"; #really really bad practice
    clusterInit = true;
    extraFlags = toString [
      "--write-kubeconfig-mode 640"
      "--write-kubeconfig-group wheel"
    ];
  };
}

