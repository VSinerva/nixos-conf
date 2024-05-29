{ config, pkgs, ... }:
{
	networking.hostName = "nextcloud";

	imports = [
		../base.nix
		../nextcloud.nix
	];

# HARDWARE SPECIFIC

	services.qemuGuest.enable = true;

# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
}
