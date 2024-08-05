{ config, pkgs, ... }:
let
  fetch-config-template = pkgs.writeScriptBin "fetch-config-template" ''
    mv configuration.nix configuration.nix.old
    ${pkgs.curl}/bin/curl https://raw.githubusercontent.com/VSinerva/nixos-conf/main/misc/template-configuration.nix -o configuration.nix
  '';
in
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    ../base.nix
  ];

  networking.networkmanager.enable = pkgs.lib.mkForce false;
  environment.systemPackages = [ fetch-config-template ];
}
