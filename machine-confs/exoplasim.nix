{ config, pkgs, ... }:
{
  imports = [ ../base.nix ];

  # Networking conf including WireGuard
  networking = {
    hostName = "exoplasim";

    firewall.allowedUDPPorts = [ 51821 ];

    wg-quick.interfaces = {
      wg0 = {
        address = [ "10.0.0.1/24" ];
        privateKeyFile = "/root/wireguard-keys/privatekey";
        listenPort = 51821;

        peers = [
          #          {
          #            publicKey = "TODO";
          #            presharedKeyFile = "/root/wireguard-keys/psk";
          #            allowedIPs = [ "10.0.0.2/32" ];
          #          }
          {
            publicKey = "9FOmHXs0CmDlW61noS7DqhgH5GfQHzg8ZMasyNQACSc=";
            allowedIPs = [ "10.0.0.2/32" ];
          }
        ];
      };
    };
  };

  services.ddclient = {
    enable = true;
    usev4 = "";
    usev6 = "ifv6, ifv6=enp6s18";
    username = "vsinerva.fi-dynexo";
    domains = [ "exovpn.vsinerva.fi" ];
    passwordFile = "/var/lib/ddclient/password";
    server = "www.ovh.com";
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

  system.autoUpgrade.allowReboot = pkgs.lib.mkForce false;

  programs.rust-motd = {
    enable = true;
    enableMotdInSSHD = true;
    refreshInterval = "*:*:0/5";
    settings = {
      banner = {
        color = "green";
        command = ''
          ${pkgs.figlet}/bin/figlet "ExoPlaSim Worker";
          ${pkgs.coreutils-full}/bin/echo -e "$(${pkgs.procps}/bin/ps --User worker --user worker --forest --format start_time=STARTED,time=CPU_TIME,%cpu,%mem,comm)";
        '';
      };
      uptime.prefix = "System has been running for";
      filesystems = {
        Main = "/";
      };
      memory.swap_pos = "beside";
    };
  };

  # HARDWARE SPECIFIC
  services.qemuGuest.enable = true;
}
