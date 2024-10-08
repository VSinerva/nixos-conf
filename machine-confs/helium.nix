{ config, pkgs, ... }:
{
  networking = {
    hostName = "helium";

    wg-quick.interfaces = {
      wg0 = {
        autostart = true;
        address = [
          "fd08:d473:bcca:f0::2/64"
          "2001:14ba:a08c:2df0::2/64"
        ];
        dns = [
          "fd08:d473:bcca::1"
          "vsinerva.fi"
        ];
        privateKeyFile = "/root/wireguard-keys/privatekey-home";
        listenPort = 51820;

        peers = [
          {
            publicKey = "f9QoYPxyaxylUcOI9cE9fE9DJoEX4c6GUtr4p+rsd34=";
            presharedKeyFile = "/root/wireguard-keys/psk-home";
            allowedIPs = [
              "fd08:d473:bcca::/64"
              "fd08:d473:bcca:f0::/64"
              "::/0"
            ];
            endpoint = "wg.vsinerva.fi:51820";
          }
        ];
      };
      wg1 = {
        autostart = false;
        address = [ "10.100.0.7/24" ];
        dns = [ "1.1.1.1" ];
        privateKeyFile = "/root/wireguard-keys/privatekey-netflix";
        listenPort = 51820;

        peers = [
          {
            publicKey = "XSYHg0utIR1j7kRsWFwuWNo4RPD47KP53cVa6qDPtRE=";
            allowedIPs = [
              "0.0.0.0/0"
              "192.168.0.0/24"
            ];
            endpoint = "netflix.vsinerva.fi:51821";
          }
        ];
      };
    };
  };
  # Dirty hack to fix autostart failing due to DNS lookups
  systemd.services."wg-quick-wg0".serviceConfig = {
    Restart = "on-failure";
    RestartSec = "1s";
  };
  services.clatd = {
    enable = true;
    settings.clat-v6-addr = "2001:14ba:a08c:2df0::f2";
  };
  systemd.services.clatd.wants = [ "wg-quick-wg0.service" ];

  services.openssh.enable = pkgs.lib.mkForce false;
  services.fail2ban.enable = pkgs.lib.mkForce false;

  imports = [
    ../base.nix
    ../users/vili.nix
    ../desktop.nix
    ../development.nix
    ../services/syncthing.nix
    ../services/redshift.nix
    ../services/game-streaming.nix
    ../hardware-specific/keychron-q11.nix
    ../hardware-specific/trackball.nix
    ../hardware-specific/amd-laptop.nix
    ../hardware-specific/usb-automount.nix
    ../hardware-specific/onlykey.nix
  ];

  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --output DisplayPort-0 --auto --pos 0x0 --primary --output eDP --auto --pos 3840x360
  '';

  system.autoUpgrade.allowReboot = pkgs.lib.mkForce false;

  swapDevices = pkgs.lib.mkForce [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  boot = {
    initrd.luks.devices."luks-f6e1979b-0dee-4ee9-8170-10490019854b" = {
      keyFileSize = 8192;
      keyFile = "/dev/disk/by-id/usb-Kingston_DataTraveler_3.0_E0D55EA5741216B0A93E02B3-0:0";
      fallbackToPassword = true;
    };
    resumeDevice = "/dev/mapper/luks-f6e1979b-0dee-4ee9-8170-10490019854b";
    kernelParams = [ "resume_offset=44537856" ];
  };
}
