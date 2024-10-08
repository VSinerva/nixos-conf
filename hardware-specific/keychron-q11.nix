{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; if config.services.xserver.enable then [ via ] else [ ];

  # Keychron Q11
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="01e0", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';
}
