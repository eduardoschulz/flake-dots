# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [ "video=DP-1:2560x1080@74.99" "vm.swappiness=10" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "zfs" "ntfs" ];
  boot.zfs.forceImportRoot = false;

  boot.extraModprobeConfig = ''
    		 options zfs zfs_arc_max=4294967296 
    		 options zfs zfs_arc_min=1073741824
    	'';
  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/adf72096-dc4a-4577-afa0-2f19748ffa42";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/4237-F04B";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/d76fbb41-a76a-4e8b-bfcb-95a084295f14";
      fsType = "ext4";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/02057c80-bd2b-482a-85b0-d00a74020f36"; }];


  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp9s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
