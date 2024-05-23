{ config, pkgs, ... }:
{
	networking.hostName = "vaultwarden";

	imports = [
		/mnt/nixos-conf/base.nix
			/mnt/nixos-conf/vaultwarden.nix
	];

# HARDWARE SPECIFIC

	services.qemuGuest.enable = true;

# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
}
