#Main local NFS server with /home/vili etc.
{ config, pkgs, ... }:
{
	networking.firewall.allowedTCPPorts = [ 111 2049 4000 4001 4002 20048 ];
	networking.firewall.allowedUDPPorts = [ 111 2049 4000 4001 4002 20048 ];

	services.nfs.server =
	{
		enable = true;
		# fixed rpc.statd port; for (proxmox) firewall
		statdPort = 4000;
		lockdPort = 4001;
		mountdPort = 4002;
		extraNfsdConfig = '''';
		createMountPoints = true;
		exports =	''
				/mnt/srv/nixos-conf	192.168.0.0/23(rw,no_root_squash) 172.16.0.0/24(rw,no_root_squash) 192.168.2.0/23(no_root_squash) 192.168.4.0/22(no_root_squash) 192.168.8.0/23(no_root_squash)
				'';
	};
}
