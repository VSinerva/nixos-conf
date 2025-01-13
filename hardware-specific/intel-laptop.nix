{ config, pkgs, ... }:
{
  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
    ];
  };

  services = {
    xserver = pkgs.lib.mkIf config.services.xserver.enable {
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

    logind.lidSwitch = if config.boot.resumeDevice != "" then "hibernate" else "suspend";
  };
}
