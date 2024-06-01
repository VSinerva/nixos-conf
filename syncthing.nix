# Syncthing instance
{ config, pkgs, ... }:
{
	services.syncthing = {
		enable = true;
		user = "vili";
		dataDir = "/home/vili/";

		settings = {
			devices = {
				"helium" = { id = "2MRUBSY-NHXYMAW-SY22RHP-CNNMHKR-DPDKMM4-2XV5F6M-6KSNLQI-DD4EOAM"; };
				"nixos-cpu" = { id = "ZX35ARB-3ULEUV3-NNUEREF-DEDWOJU-GE7A4PP-T7O43NI-SU564OD-E26HHA4"; };
			};

			folders =
			let
				default = {
					devices = [ "helium" "nixos-cpu" ];
					versioning = {
						type = "trashcan";
						params.cleanoutDays = "30";
					};
				};
			in
			{
				"~/Desktop" = default;
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
