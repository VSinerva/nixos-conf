{ config, pkgs, ... }:
{
  networking.jool = {
    enable = true;
    nat64.default = { };
  };
}
