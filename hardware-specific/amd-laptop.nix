{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ zenmonitor ];

  hardware.graphics.extraPackages = with pkgs; [ rocmPackages.clr.icd ];

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

    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 40;

        #Optional helps save long term battery health
        START_CHARGE_THRESH_BAT0 = 60; # 60 and bellow it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

      };
    };
  };
}
