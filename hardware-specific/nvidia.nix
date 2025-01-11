{ config, pkgs, ... }:
{
  hardware = {
    graphics.enable = true;
    nvidia = {
      open = true;
      forceFullCompositionPipeline = true;
    };
  };

  services = {
    xserver = pkgs.lib.mkIf config.services.xserver.enable {
      videoDrivers = [ "nvidia" ];
    };
  };
}
