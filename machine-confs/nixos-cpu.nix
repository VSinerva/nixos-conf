{ config, pkgs, ... }:
{
	networking.hostName = "nixos-cpu";

	imports = [
		/mnt/nixos-conf/base.nix
			/mnt/nixos-conf/development.nix
			/mnt/nixos-conf/vili.nix
	];

# HARDWARE SPECIFIC

	services.qemuGuest.enable = true;

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

}
