{ config, pkgs, lib, ... }:
let 
unison-conf = "${pkgs.writeText "unison-conf"
''
root = /home/vili
root = ssh://nixos-cpu.vsinerva.fi//home/vili

watch = true
repeat = watch
prefer = newer
diff = diff -y -W 79 --suppress-common-lines
copyprog = rsync --inplace --compress
copyprogrest = rsync --partial --inplace --compress sshargs = -C

path = Desktop
path = Documents
path = Downloads
path = Music
path = Pictures
path = Projects
path = Public
path = School
path = Templates
path = Videos
path = Zotero
''}";
in
{
	networking = {
		hostName = "helium";
		firewall.allowedUDPPorts = [ 51820 51821 ];
		wg-quick.interfaces = {
			wg0 = {
				autostart = false;
				address = [ "172.16.0.2/24" ];
				dns = [ "192.168.0.1" "vsinerva.fi" ];
				privateKeyFile = "/root/wireguard-keys/privatekey-home";
				listenPort = 51820;

				peers = [
				{
					publicKey = "f9QoYPxyaxylUcOI9cE9fE9DJoEX4c6GUtr4p+rsd34=";
					allowedIPs = [ "0.0.0.0/0" ];
					endpoint = "wg.vsinerva.fi:51820";
				}
				];
			};
			wg1 = {
				autostart = false;
				address = [ "10.100.0.7/24" ];
				dns = [ "1.1.1.1" ];
				privateKeyFile = "/root/wireguard-keys/privatekey-netflix";
				listenPort = 51821;

				peers = [
				{
					publicKey = "XSYHg0utIR1j7kRsWFwuWNo4RPD47KP53cVa6qDPtRE=";
					allowedIPs = [ "0.0.0.0/0" "192.168.0.0/24" ];
					endpoint = "netflix.vsinerva.fi:51821";
				}
				];
			};
		};
	};

	nix.settings = {
		cores = 3;
		max-jobs = 4;
	};

	imports = [
			../base.nix
			../vili.nix
			../desktop.nix
			../development.nix
			../misc/libinput.nix
	];
	disabledModules = [ "services/x11/hardware/libinput.nix" ];

	nixpkgs.overlays = 
		[
		(final: prev:
		 {
		 moonlight-qt = prev.moonlight-qt.overrideAttrs (old: {
				 patches = (old.patches or []) ++ [ ../misc/mouse-accel.patch ];
				 });
		 })
		];

		environment.systemPackages = with pkgs; [
			zenmonitor moonlight-qt parsec-bin via
		];

		systemd.services = {
			unisonConfSymlink = {
				wantedBy = [ "multi-user.target" ];
				description = "Symlink for unison conf";
				serviceConfig = {
					Type = "oneshot";
					User = "vili";
					ExecStartPre = ''${pkgs.coreutils-full}/bin/mkdir -p /home/vili/.unison''; 
					ExecStart = ''${pkgs.coreutils-full}/bin/ln -sf ${unison-conf} /home/vili/.unison/cpu.prf''; 
				};
			};
			unisonSync = {
				wantedBy = [ "multi-user.target" ];
				after = [ "network.target" ];
				description = "unison filesync";
				serviceConfig = {
					Type = "exec";
					User = "vili";
					ExecStart = ''${pkgs.unison}/bin/unison -sshcmd ${pkgs.openssh}/bin/ssh cpu''; 
				};
			};
		};


# HARDWARE SPECIFIC
		boot.initrd.kernelModules = [ "amdgpu" ];
		hardware = {
			opengl.extraPackages = with pkgs; [
				rocmPackages.clr.icd
			];
			logitech.wireless = {
				enable = true;
				enableGraphical = true;
			};
		};

		services = {
			xserver = {
				videoDrivers = [ "amdgpu" "modesetting" ];
				deviceSection = ''
					Option "DRI" "2"
					Option "TearFree" "true"
					'';

				displayManager.setupCommands = ''
					${pkgs.xorg.xrandr}/bin/xrandr --output DisplayPort-0 --auto --pos 0x0 --primary --output eDP --auto --pos 3840x360
					'';
			};

			libinput.mouse = {
				accelProfile = "custom";
				accelPointsMotion = [ 0.00000 0.02000 0.04000 0.06000 0.08000 0.10000 0.12000 0.14000 0.16000 0.18000 0.20000 0.25250 0.31000 0.37250 0.44000 0.51250 0.59000 0.67250 0.76000 0.85250 0.95000 1.15500 1.37000 1.59500 1.83000 2.07500 2.33000 2.59500 2.87000 3.15500 3.45000 3.75500 4.07000 4.39500 4.73000 5.07500 5.43000 5.79500 6.17000 6.55500 6.95000 7.35500 7.77000 8.19500 8.63000 9.07500 9.53000 9.99500 10.47000 10.95500 11.45000 11.95000 ];
				accelStepMotion = 0.05;
			};

			redshift = {
				executable = "/bin/redshift-gtk";
				enable = true;
				temperature = {
					night = 2800;
					day = 6500;
				};
				brightness = {
					night = "0.5";
					day = "1";
				};
			};

			devmon.enable = true;
			gvfs.enable = true;
			udisks2.enable = true;
		};
		location = {
			latitude = 60.17;
			longitude = 24.94;
		};

# Swap + hibernate
	swapDevices = [
		{
			device = "/var/lib/swapfile";
			size = 16*1024;
		}
	];
	boot.resumeDevice = "/dev/mapper/luks-f6e1979b-0dee-4ee9-8170-10490019854b";
	boot.kernelParams = [ "resume_offset=44537856" ];
	services.logind = {
		lidSwitch = "hibernate";
	};

# Keychron Q11
		services.udev.extraRules = ''
			KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="01e0", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
		'';

# Bootloader.
		boot.loader.systemd-boot.enable = true;
		boot.loader.efi.canTouchEfiVariables = true;
}
