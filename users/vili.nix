#Config for main user 'vili'
{ config, pkgs, ... }:
{
  users.users.vili = {
    isNormalUser = true;
    home = "/home/vili";
    description = "Vili Sinervä";
    uid = 1000;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
    ];
    openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys;
    hashedPasswordFile = "/home/vili/.hashedPasswordFile";
  };

  users.groups.vili.gid = 1000;

  programs.ssh = {
    startAgent = true;
    enableAskPassword = false;
  };
}
