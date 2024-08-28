{ config, pkgs, ... }:
{
  networking = {
    hostName = "helium";

    firewall.allowedUDPPorts = [
      51820
      51821
    ];

    wg-quick.interfaces = {
      wg0 = {
        autostart = true;
        address = [ "172.16.0.2/24" ];
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
      wg1 = {
        autostart = false;
        address = [ "10.100.0.7/24" ];
        dns = [ "1.1.1.1" ];
        privateKeyFile = "/root/wireguard-keys/privatekey-netflix";
        listenPort = 51821;

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
  ];

  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --output DisplayPort-0 --auto --pos 0x0 --primary --output eDP --auto --pos 3840x360
  '';

  swapDevices = pkgs.lib.mkForce [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  boot = {
    resumeDevice = "/dev/mapper/luks-f6e1979b-0dee-4ee9-8170-10490019854b";
    kernelParams = [ "resume_offset=44537856" ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
