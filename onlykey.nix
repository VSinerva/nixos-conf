{ config, pkgs, ... }:
{
  assertions = [
    {
      assertion = config.users.users ? "vili";
      message = "User 'vili' needed for onlykey!";
    }
  ];

  environment.systemPackages = with pkgs; [
    (onlykey.override (prev: {
      node_webkit = prev.node_webkit.overrideAttrs {
        src = fetchurl {
          url = "https://dl.nwjs.io/v0.71.1/nwjs-v0.71.1-linux-x64.tar.gz";
          hash = "sha256-bnObpwfJ6SNJdOvzWTnh515JMcadH1+fxx5W9e4gl/4=";
        };
      };
    }))

    onlykey-cli
    onlykey-agent
  ];

  hardware.onlykey.enable = true;
  security.pam.u2f.enable = true;
}