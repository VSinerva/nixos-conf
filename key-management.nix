{ config, pkgs, ... }:
{
  assertions = [
    {
      assertion = config.users.users ? "vili";
      message = "User 'vili' needed for onlykey!";
    }
  ];

  environment.systemPackages = with pkgs; [
    (onlykey.override (prev: {
      node_webkit = prev.node_webkit.overrideAttrs {
        src = fetchurl {
          url = "https://dl.nwjs.io/v0.71.1/nwjs-v0.71.1-linux-x64.tar.gz";
          hash = "sha256-bnObpwfJ6SNJdOvzWTnh515JMcadH1+fxx5W9e4gl/4=";
        };
      };
    }))

    onlykey-cli
    onlykey-agent
  ];

  programs.ssh.startAgent = pkgs.lib.mkForce false; # TEMPORARY!
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  services.udev.extraRules = with pkgs; ''
    ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", ENV{MTP_NO_PROBE}="1"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", OWNER:="vili", RUN+="${onlykey-cli}/bin/onlykey-cli settime"
    KERNEL=="ttyACM*", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", OWNER:="vili", RUN+="${onlykey-cli}/bin/onlykey-cli settime"
  '';
}
