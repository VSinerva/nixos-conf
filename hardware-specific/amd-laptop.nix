# Config for laptop with AMD CPU and integrated graphics
{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ zenmonitor ];

  hardware.opengl.extraPackages = with pkgs; [ rocmPackages.clr.icd ];

  boot.initrd.kernelModules = [ "amdgpu" ];

  services = {
    xserver = pkgs.lib.mkIf config.services.xserver.enable {
      videoDrivers = [
        "amdgpu"
        "modesetting"
      ];
      deviceSection = ''
        Option "DRI" "2"
        Option "TearFree" "true"
      '';
    };

    logind.lidSwitch = if config.boot.resumeDevice != "" then "hibernate" else "suspend";
  };
}
