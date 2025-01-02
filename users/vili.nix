{ config, ... }:
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
    hashedPasswordFile = "/root/hashed-passwords/vili";
  };

  users.groups.vili.gid = 1000;
}
