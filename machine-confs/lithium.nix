{ config, pkgs, ... }:
{
  networking = {
    hostName = "lithium";

    wg-quick.interfaces = {
      wg0 = {
        autostart = true;
        address = [
          "fd08:d473:bcca:f0::3/64"
          "2001:14ba:a08c:2df0::3/64"
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
    };
  };
  # Dirty hack to fix autostart failing due to DNS lookups
  systemd.services."wg-quick-wg0".serviceConfig = {
    Restart = "on-failure";
    RestartSec = "1s";
  };
  services.clatd = {
    enable = true;
    settings.clat-v6-addr = "2001:14ba:a08c:2df0::f3";
  };
  systemd.services.clatd.wants = [ "wg-quick-wg0.service" ];

  services.openssh.enable = pkgs.lib.mkForce false;
  services.fail2ban.enable = pkgs.lib.mkForce false;

  imports = [
    ../base.nix
    ../users/vili.nix
    ../desktop.nix
    ../development.nix
    ../onlykey.nix
    ../services/syncthing.nix
    ../services/redshift.nix
    ../hardware-specific/keychron-q11.nix
    ../hardware-specific/trackball.nix
    ../hardware-specific/usb-automount.nix
  ];

  system.autoUpgrade.allowReboot = pkgs.lib.mkForce false;

  swapDevices = pkgs.lib.mkForce [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  boot = {
    initrd.luks.devices."nixos" = {
      keyFileSize = 8192;
      keyFile = "/dev/disk/by-id/usb-Kingston_DataTraveler_3.0_E0D55EA5741216B0A93E02B3-0:0";
      fallbackToPassword = true;
    };

    resumeDevice = "/dev/mapper/nixos";
    kernelParams = [ "resume_offset=39292928" ];
  };
}
