{ config, pkgs, ... }:
{
  assertions = [
    {
      assertion = config.users.users ? "vili";
      message = "User 'vili' needed for syncthing!";
    }
  ];

  boot.kernel.sysctl."fs.inotify.max_user_watches" = 204800;

  services.syncthing = {
    enable = true;
    user = "vili";
    dataDir = config.users.users.${config.services.syncthing.user}.home;

    settings = {
      devices = pkgs.lib.mkMerge [
        {
          "syncthing" = {
            id = "J6GNM4Z-2TWASPT-3P3EW4V-KZEQYFF-TXL22QX-4YTZ3WO-WLM7GQ7-NUP66A4";
            addresses = [ "tcp://syncthing.vsinerva.fi:22000" ];
          };
        }
        (pkgs.lib.mkIf (config.networking.hostName == "syncthing") {
          "helium" = {
            id = "2MRUBSY-NHXYMAW-SY22RHP-CNNMHKR-DPDKMM4-2XV5F6M-6KSNLQI-DD4EOAM";
            addresses = [ "tcp://helium.vsinerva.fi:22000" ];
          };
          "lithium" = {
            id = "S4ZORDV-QBY7QC7-FQHADMZ-NQSKJUA-7B7LQNS-CWJLSMG-JPMN7YJ-OVRDZQA";
            addresses = [ "tcp://lithium.vsinerva.fi:22000" ];
          };
          "phone" = {
            id = "K6QCK2R-BU65RAC-PHTGLIA-24IHDXE-N6VNBAW-QYREMVD-XWGWKRA-VX2BNAK";
            addresses = [ "tcp://phone.vsinerva.fi:22000" ];
          };
        })
      ];

      folders =
        let
          default = {
            devices = pkgs.lib.mkMerge [
              [ "syncthing" ]
              (pkgs.lib.mkIf (config.networking.hostName == "syncthing") [
                "helium"
                "lithium"
                "phone"
              ])
            ];
            versioning = {
              type = "trashcan";
              params.cleanoutDays = "30";
            };
            fsWatcherDelayS = 1;
          };
          default-no-phone = default // {
            devices = pkgs.lib.mkMerge [
              [ "syncthing" ]
              (pkgs.lib.mkIf (config.networking.hostName == "syncthing") [
                "helium"
                "lithium"
              ])
            ];
          };
        in
        {
          "~/Documents" = default;
          "~/Downloads" = default-no-phone;
          "~/Music" = default-no-phone;
          "~/Pictures" = default;
          "~/Projects" = default-no-phone;
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
