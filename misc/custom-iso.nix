{ config, pkgs, ... }:
let
  partition-and-install = pkgs.writeScriptBin "partition-and-install" ''
    read -p "Erasing disk $1 Are you sure? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      parted $1 -- mklabel gpt
      parted $1 -- mkpart root ext4 512MB 100%
      parted $1 -- mkpart ESP fat32 1MB 512MB
      parted $1 -- set 2 esp on

      mkfs.ext4 -L nixos $1$2
      mkfs.fat -F 32 -n BOOT $1$3

      mount /dev/disk/by-label/nixos /mnt
      mkdir /mnt/boot
      mount -o umask=077 /dev/disk/by-label/BOOT /mnt/boot

      nixos-generate-config --root /mnt
      mv /mnt/etc/nixos/configuration.nix configuration.nix.old
      curl https://raw.githubusercontent.com/VSinerva/nixos-conf/main/misc/template-configuration.nix -o /mnt/etc/nixos/configuration.nix

      nixos-install
    fi
  '';
in
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    ../base.nix
  ];

  networking.networkmanager.enable = pkgs.lib.mkForce false;
  environment.systemPackages = [ partition-and-install ];

  #Many installs will need this, and it won't hurt either way
  services.qemuGuest.enable = true;

  #Prevent user from being locked out of the system before switching to proper config
  users.mutableUsers = pkgs.lib.mkForce true;
}
