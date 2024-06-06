# Config for laptop with AMD CPU and integrated graphics
{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ zenmonitor ];

  hardware.opengl.extraPackages = with pkgs; [ rocmPackages.clr.icd ];

  boot.initrd.kernelModules = [ "amdgpu" ];

  services = {
    xserver = {
      videoDrivers = [
        "amdgpu"
        "modesetting"
      ];
      deviceSection = ''
        Option "DRI" "2"
        Option "TearFree" "true"
      '';
    };

    logind.lidSwitch = "hibernate";
  };
}
