{ config, pkgs, ... }:
{
  imports = [ ./laptop.nix ];

  environment.systemPackages = with pkgs; [ zenmonitor ];

  hardware.graphics.extraPackages = with pkgs; [ rocmPackages.clr.icd ];

  boot.initrd.kernelModules = [ "amdgpu" ];

  services = {
    xserver = pkgs.lib.mkIf config.services.xserver.enable { videoDrivers = [ "amdgpu" ]; };
  };
}
