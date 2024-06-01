# Syncthing instance
{ config, pkgs, ... }:
{
	services.syncthing = {
		enable = true;
		user = "vili";
		dataDir = "/home/vili/";

		settings = {
			devices = {
			};

			folders =
			let
				default = {
					devices = [];
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
