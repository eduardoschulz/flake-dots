# Personal NixOS and Home-Manager configuration files 


## Repository Structure
```
desktop             # NixOS and HomeManager configuration for my Desktop
laptop              # NixOS and HomeManager configuration for my Laptop
nvim                # Configuration imported by both desktop and laptop homemanager

```
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


# TODO
- [x] Make homemanager import a nvim.nix file to install dependencies
- [ ] Add dwm and st as submodules of this repo
- [ ] Fix Treesitter
- [ ] Include some templates for development environments
