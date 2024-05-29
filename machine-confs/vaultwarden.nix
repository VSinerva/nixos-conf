{ config, pkgs, ... }:
{
	networking.hostName = "vaultwarden";

	imports = [
		../base.nix
		../vaultwarden.nix
	];

# HARDWARE SPECIFIC

	services.qemuGuest.enable = true;

# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
}
