{ config, ... }:
{
  assertions = [
    {
      assertion = config.services.xserver.enable;
      message = "Trackball does not work without a desktop!";
    }
  ];

  nixpkgs.overlays = [
    (final: prev: {
      moonlight-qt = prev.moonlight-qt.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ../misc/mouse-accel.patch ];
      });
    })
  ];

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  services.libinput.mouse = {
    accelProfile = "custom";
    accelStepMotion = 5.0e-2;
    accelPointsMotion = [
      0.0
      2.0e-2
      4.0e-2
      6.0e-2
      8.0e-2
      0.1
      0.12
      0.14
      0.16
      0.18
      0.2
      0.2525
      0.31
      0.3725
      0.44
      0.5125
      0.59
      0.6725
      0.76
      0.8525
      0.95
      1.155
      1.37
      1.595
      1.83
      2.075
      2.33
      2.595
      2.87
      3.155
      3.45
      3.755
      4.07
      4.395
      4.73
      5.075
      5.43
      5.795
      6.17
      6.555
      6.95
      7.355
      7.77
      8.195
      8.63
      9.075
      9.53
      9.995
      10.47
      10.955
      11.45
      11.95
    ];
  };
}
