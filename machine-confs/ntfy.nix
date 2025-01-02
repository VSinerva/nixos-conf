{ pkgs, ... }:
{
  networking.hostName = "ntfy";

  imports = [
    ../base.nix
    ../services/ntfy.nix
  ];

  # HARDWARE SPECIFIC
  services.qemuGuest.enable = true;

  # Make sure this service updates later than the rest, to capture any notifs from the others
  system.autoUpgrade = {
    dates = pkgs.lib.mkForce "05:00";
    rebootWindow = pkgs.lib.mkForce {
      lower = "04:30";
      upper = "06:00";
    };
  };

}
