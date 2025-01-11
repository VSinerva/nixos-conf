{ pkgs, ... }:
{
  networking.hostName = "gaming";

  imports = [
    ../base.nix
    ../users/vili.nix
    ../desktop.nix
    ../gaming.nix
    ../services/sunshine.nix
    #    ../hardware-specific/nvidia.nix
  ];

  services.clatd = {
    enable = true;
    settings.clat-v6-addr = "2001:14ba:a08c:2d00:51d1:dd88:2a12:afae";
  };

  users.users.vili.hashedPasswordFile = pkgs.lib.mkForce null;

  swapDevices = pkgs.lib.mkForce [
    {
      device = "/var/lib/swapfile";
      size = 4 * 1024;
    }
  ];

  # HARDWARE SPECIFIC
  services.qemuGuest.enable = true;
}
