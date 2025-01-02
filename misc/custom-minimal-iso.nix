{ pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    ./custom-iso-base.nix
  ];

  networking.networkmanager.enable = pkgs.lib.mkForce false;
}
