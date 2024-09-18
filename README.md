# Personal NixOS and Home-Manager configuration files 


## Desktop
```shell
sudo nixos-rebuild --flake .#desktop     #this will build nixos and dwm 
nix build .#hmConfig.desktop.activationPackage  #this will build only homemanager
./result/activate
```

## Laptop
```shell
sudo nixos-rebuild --flake .#laptop    #this will build nixos and dwm 
nix build .#hmConfig.laptop.activationPackage  #this will build only homemanager
./result/activate
```


# TODO include repo link to dwm config
