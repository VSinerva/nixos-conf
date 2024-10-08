{ config, pkgs, ... }:
{
  assertions = [
    {
      assertion = config.users.users ? "vili";
      message = "User 'vili' needed for onlykey!";
    }
  ];

  environment.systemPackages = with pkgs; [
    onlykey
    onlykey-cli
    onlykey-agent
  ];

  services.udev.extraRules = with pkgs; ''
    ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", ENV{MTP_NO_PROBE}="1"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", OWNER:="vili", RUN+="${onlykey-cli}/bin/onlykey-cli settime"
    KERNEL=="ttyACM*", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", OWNER:="vili", RUN+="${onlykey-cli}/bin/onlykey-cli settime"
  '';
}
