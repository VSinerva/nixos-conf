{ config, pkgs, ... }:
{
  networking = {
    hostName = "lithium";

    firewall.allowedUDPPorts = [ 51820 ];

    wg-quick.interfaces.wg0 = {
      autostart = true;
      address = [ "172.16.0.4/24" ];
      dns = [
        "192.168.0.1"
        "vsinerva.fi"
      ];
      privateKeyFile = "/root/wireguard-keys/privatekey-home";
      listenPort = 51820;

      peers = [
        {
          publicKey = "f9QoYPxyaxylUcOI9cE9fE9DJoEX4c6GUtr4p+rsd34=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "wg.vsinerva.fi:51820";
        }
      ];
    };
  };
  # Dirty hack to fix autostart failing due to DNS lookups
  systemd.services."wg-quick-wg0".serviceConfig = {
    Restart = "on-failure";
    RestartSec = "1s";
  };

  services.openssh.enable = pkgs.lib.mkForce false;
  services.fail2ban.enable = pkgs.lib.mkForce false;

  services.xserver.xkb.layout = pkgs.lib.mkForce "fi";

  imports = [
    ../base.nix
    ../users/vili.nix
    ../desktop.nix
    ../development.nix
    ../services/syncthing.nix
    ../services/redshift.nix
    ../hardware-specific/keychron-q11.nix
    ../hardware-specific/trackball.nix
    ../hardware-specific/usb-automount.nix
  ];

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

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  services.logind.lidSwitch = if config.boot.resumeDevice != "" then "hibernate" else "suspend";
}
