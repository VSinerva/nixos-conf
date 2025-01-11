{ pkgs, ... }:
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
    settings.clat-v6-addr = "2001:14ba:a08c:2df0::3";
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
    ../services/moonlight.nix
    ../hardware-specific/keychron-q11.nix
    ../hardware-specific/trackball.nix
    ../hardware-specific/usb-automount.nix
    ../hardware-specific/laptop.nix
  ];

  system.autoUpgrade.allowReboot = pkgs.lib.mkForce false;

  swapDevices = pkgs.lib.mkForce [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  boot = {
    loader.timeout = 10;
    initrd.luks = {
      fido2Support = true;
      devices."nixos".fido2 = {
        passwordLess = true;
        credential = "f29b0760a6ec3b18b0a9958d77d8be8b15ff4fd90d42c3ceaeeb5d24a19c8f81315f52dae2262619c1da2be7562ec9dd94888c71a9326fea70dfe16214b5ea8ec014225afa01";
      };
    };
    resumeDevice = "/dev/mapper/nixos";
    kernelParams = [ "resume_offset=39292928" ];
  };
}
