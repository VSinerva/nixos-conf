# Config for automounting USB devices
{ config, pkgs, ... }:
{
  services = {
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
  };
}
