{ config, pkgs, ... }:
{
  assertions = [
    {
      assertion = config.services.xserver.enable;
      message = "Gaming does not work without a desktop!";
    }
  ];

  services.tlp.enable = true;

  programs = {
    steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    gamemode.enable = true;
  };
}
