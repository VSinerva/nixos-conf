{ config, pkgs, ... }:
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

  swapDevices = pkgs.lib.mkForce [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  boot = {
    #resumeDevice = "/dev/mapper/luks-f6e1979b-0dee-4ee9-8170-10490019854b";
    #kernelParams = [ "resume_offset=44537856" ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
