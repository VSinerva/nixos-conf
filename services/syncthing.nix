# Syncthing instance
{ config, pkgs, ... }:
{
  assertions = [
    {
      assertion = config.users.users ? "vili";
      message = "User 'vili' needed for syncthing!";
    }
  ];

  services.syncthing = {
    enable = true;
    user = "vili";
    dataDir = config.users.users.${config.services.syncthing.user}.home;

    settings = {
      devices = {
        "helium" = {
          id = "2MRUBSY-NHXYMAW-SY22RHP-CNNMHKR-DPDKMM4-2XV5F6M-6KSNLQI-DD4EOAM";
          addresses = [ "tcp://helium.vsinerva.fi:22000" ];
        };
        "nixos-cpu" = {
          id = "ZX35ARB-3ULEUV3-NNUEREF-DEDWOJU-GE7A4PP-T7O43NI-SU564OD-E26HHA4";
          addresses = [ "tcp://nixos-cpu.vsinerva.fi:22000" ];
        };
        "phone" = {
          id = "K6QCK2R-BU65RAC-PHTGLIA-24IHDXE-N6VNBAW-QYREMVD-XWGWKRA-VX2BNAK";
          addresses = [ "tcp://172.16.0.3:22000" ];
        };
      };

      folders =
        let
          default = {
            devices = [
              "helium"
              "nixos-cpu"
              "phone"
            ];
            versioning = {
              type = "trashcan";
              params.cleanoutDays = "30";
            };
            fsWatcherDelayS = 1;
          };
          default-no-phone = default // {
            devices = [
              "helium"
              "nixos-cpu"
            ];
          };
        in
        {
          "~/Documents" = default;
          "~/Downloads" = default-no-phone;
          "~/Music" = default-no-phone;
          "~/Pictures" = default;
          "~/Projects" = default;
          "~/School" = default;
          "~/Videos" = default-no-phone;
          "~/Zotero" = default;
        };

      options = {
        urAccepted = -1;
        localAnnounceEnabled = false;
        globalAnnounceEnabled = false;
        natEnabled = false;
        relaysEnabled = false;
      };
    };

    #TCP/UDP 22000 for transfers and UDP 21027 for discovery
    openDefaultPorts = true;
  };
}
