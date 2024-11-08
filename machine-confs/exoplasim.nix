{ config, pkgs, ... }:
{
  imports = [ ../base.nix ];

  networking = {
    hostName = "exoplasim";

    firewall.allowedUDPPorts = [ 51821 ];

    wg-quick.interfaces = {
      wg0 = {
        address = [ "10.0.0.1/24" ];
        privateKeyFile = "/root/wireguard-keys/privatekey";
        listenPort = 51821;

        peers = [
          {
            publicKey = "9FOmHXs0CmDlW61noS7DqhgH5GfQHzg8ZMasyNQACSc=";
            presharedKeyFile = "/root/wireguard-keys/psk";
            allowedIPs = [ "10.0.0.2/32" ];
          }
        ];
      };
    };
  };

  # User worker
  users.users.worker = {
    isNormalUser = true;
    home = "/home/worker";
    description = "ExoPlaSim Worker";
    uid = 1001;
    extraGroups = [ "networkmanager" ];
    openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys ++ [
      # TODO add user-specific key
    ];
  };
  users.groups.worker.gid = 1001;

  # HARDWARE SPECIFIC
  services.qemuGuest.enable = true;
}
