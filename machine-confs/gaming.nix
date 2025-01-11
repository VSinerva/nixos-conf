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
  };

  users.users.vili = {
    hashedPasswordFile = pkgs.lib.mkForce null;
    extraGroups = [ "gamemode" ];
  };

  swapDevices = pkgs.lib.mkForce [
    {
      device = "/var/lib/swapfile";
      size = 4 * 1024;
    }
  ];

  # HARDWARE SPECIFIC
  services.qemuGuest.enable = true;
}
