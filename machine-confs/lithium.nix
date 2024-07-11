{
  config,
  pkgs,
  lib,
  ...
}:
{
  networking.hostName = "lithium";

  imports = [
    ../base.nix
    ../users/vili.nix
    ../desktop.nix
    ../development.nix
    ../services/redshift.nix
    ../hardware-specific/usb-automount.nix
  ];
}
