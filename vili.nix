#Config for main user 'vili'
{ config, pkgs, ... }:
{
  users.users.vili = {
    isNormalUser = true;
    home = "/home/vili";
    description = "Vili Sinervä";
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "audio" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBbGREoK1uVny1s8FK3KZ74Wmaf0VtifhqPyK69C/Gez vili@helium" ];
    hashedPasswordFile = "/home/vili/.hashedPasswordFile";
  };

  users.groups.vili.gid = 1000;

  programs.ssh = {
    startAgent = true;
    enableAskPassword = false;
  };
}
