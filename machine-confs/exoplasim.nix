{ config, pkgs, ... }:
{
  imports = [ ../base.nix ];

  networking = {
    hostName = "exoplasim";

    #  wg-quick.interfaces = {
    #    wg0 = {
    #      autostart = true;
    #      address = [
    #        "fd08:d473:bcca:f0::3/64"
    #        "2001:14ba:a08c:2df0::3/64"
    #      ];
    #      dns = [
    #        "fd08:d473:bcca::1"
    #        "vsinerva.fi"
    #      ];
    #      privateKeyFile = "/root/wireguard-keys/privatekey-home";
    #      listenPort = 51820;

    #      peers = [
    #        {
    #          publicKey = "f9QoYPxyaxylUcOI9cE9fE9DJoEX4c6GUtr4p+rsd34=";
    #          presharedKeyFile = "/root/wireguard-keys/psk-home";
    #          allowedIPs = [
    #            "fd08:d473:bcca::/64"
    #            "fd08:d473:bcca:f0::/64"
    #            "::/0"
    #          ];
    #          endpoint = "wg.vsinerva.fi:51820";
    #        }
    #      ];
    #    };
    #  };
  };

  # User worker
  users.users.worker = {
    isNormalUser = true;
    home = "/home/worker";
    description = "ExoPlaSim Worker";
    uid = 1001;
    extraGroups = [ "networkmanager" ];
    openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys ++ [ ];
    # hashedPasswordFile = "/root/hashed-passwords/worker";
  };
  users.groups.worker.gid = 1001;

  # HARDWARE SPECIFIC
  services.qemuGuest.enable = true;
}
