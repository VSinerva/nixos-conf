{ config, pkgs, ... }:
let
  create-partitions = pkgs.writeScriptBin "create-partitions" ''
    if [[ $# -ne 3 ]]
    then
      echo "Usage: create-partitions <device prefix> <BOOT suffix> <root suffix>"
      exit
    fi

    read -p "Erasing disk $1 -- Creating partition $1$2 as BOOT -- Creating partition $1$3 as root -- Are you sure? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      parted $1 -- mklabel gpt
      parted $1 -- mkpart ESP fat32 1MB 512MB
      parted $1 -- set 1 esp on
      parted $1 -- mkpart root ext4 512MB 100%
    fi

    read -p "Setup root partition encryption?" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      cryptsetup luksFormat $1$3
      if cryptsetup open $1$3 nixos
      then
        echo "Encrypted device accessible via /dev/mapper/nixos"
      fi
    fi
  '';
  create-filesystems = pkgs.writeScriptBin "create-filesystems" ''
    if [[ $# -ne 2 ]]
    then
      echo "Usage: make-filesystems <BOOT partition> <root partition>"
      exit
    fi

    mkfs.fat -F 32 -n BOOT $1
    mkfs.ext4 -L nixos $2
  '';
  prep-install = pkgs.writeScriptBin "prep-install" ''
    mkdir /mnt
    mount /dev/disk/by-label/nixos /mnt
    mkdir /mnt/boot
    mount -o umask=077 /dev/disk/by-label/BOOT /mnt/boot

    nixos-generate-config --root /mnt
    mv /mnt/etc/nixos/configuration.nix configuration.nix.old
    curl https://raw.githubusercontent.com/VSinerva/nixos-conf/main/misc/template-configuration.nix -o /mnt/etc/nixos/configuration.nix
  '';
in
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    ../base.nix
  ];

  environment.systemPackages = [
    pkgs.cryptsetup
    create-partitions
    create-filesystems
    prep-install
  ];

  isoImage.squashfsCompression = "gzip -Xcompression-level 1";

  #Many installs will need this, and it won't hurt either way
  services.qemuGuest.enable = true;
}
