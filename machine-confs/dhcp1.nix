{ config, pkgs, ... }:
{
  imports = [ ../base.nix ];

  networking = {
    hostName = "dhcp1";
    firewall.allowedTCPPorts = [
      1400
      1401
    ];
  };

  users.users.node = {
    isNormalUser = true;
    home = "/home/node";
    description = "DHCP Cluster Node";
    uid = 1001;
    openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys ++ [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7NmrrP7rSU76qr/JEzdJYaulFYmn6f/y0YPevTjK2B simo@capscience.fi"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjdik9FU/tzpmAGJde/dh/RAuj+RatYxcwJGtIYVlbk cardno:19_036_796"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE4BHc8GiptScZ6vmdq1incgrEKFSjTvybktvc1FGmMG roysko.juho@gmail.com"
    ];
  };
  users.groups.worker.gid = 1001;

  environment.systemPackages = with pkgs; [
    gcc
    rustc
    cargo
  ];

  # HARDWARE SPECIFIC
  services.qemuGuest.enable = true;
}
