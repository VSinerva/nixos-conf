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

  users.users.ds_dhcp = {
    isNormalUser = true;
    home = "/home/ds_dhcp";
    description = "DHCP Cluster Node";
    uid = 1002;
    openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys ++ [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7NmrrP7rSU76qr/JEzdJYaulFYmn6f/y0YPevTjK2B simo@capscience.fi"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjdik9FU/tzpmAGJde/dh/RAuj+RatYxcwJGtIYVlbk cardno:19_036_796"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE4BHc8GiptScZ6vmdq1incgrEKFSjTvybktvc1FGmMG roysko.juho@gmail.com"
    ];
  };
  users.groups.ds_dhcp.gid = 1002;

  environment.systemPackages = with pkgs; [
    gcc
    rustc
    cargo
  ];

  programs.rust-motd = {
    enable = true;
    enableMotdInSSHD = true;
    refreshInterval = "*:*:0/5";
    settings = {
      banner = {
        color = "green";
        command = ''
          ${pkgs.figlet}/bin/figlet "DHCP Node";
          ${pkgs.coreutils-full}/bin/echo -e "$(${pkgs.procps}/bin/ps --User ds_dhcp --user ds_dhcp --forest --format start_time=STARTED,time=CPU_TIME,%cpu,%mem,comm)";
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
