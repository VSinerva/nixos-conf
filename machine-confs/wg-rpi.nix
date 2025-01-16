{ pkgs, ... }:
let
  #  SSID = "ENTER_SSID";
  #  SSIDpassword = "ENTER_PASSWORD";
  #  interface = "wlan0";
  wg_interface = "end0";
  hostname = "netflix-huijaus";
  ddPassFile = "/root/wg-conf/ddPassFile";
in
{
  imports = [ ../base.nix ];

  environment.systemPackages = with pkgs; [
    wireguard-tools
    qrencode
  ];

  # enable NAT
  networking.nat.enable = true;
  networking.nat.externalInterface = wg_interface;
  networking.nat.internalInterfaces = [ "wg0" ];
  networking.firewall = {
    allowedUDPPorts = [ 51821 ];
  };

  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [ "10.100.0.1/24" ];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = 51821;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${wg_interface} -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ${wg_interface} -j MASQUERADE
      '';

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/root/wg-conf/private";

      peers = [
        {
          # Vili Android
          publicKey = "niKpC3+Pi4HrYITlzROzqRcxzfzRw1rjpxeJVOr/WAw=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        {
          # Miika Puhelin
          publicKey = "mcOs94W9jqn3SGgc8uWbnmUv0tja/P6tAvaCg3WYKlY=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
        {
          # Miika Kone
          publicKey = "7m7wnwNlmxZfUNvUOYNh4mTNbOsig7z2K/svUhDHFDY=";
          allowedIPs = [ "10.100.0.4/32" ];
        }
        {
          # Silja Puhelin
          publicKey = "f6wWd6KD63xwnKkre/ZgZxPJv9GfAXK9Zx/EQEq8cik=";
          allowedIPs = [ "10.100.0.5/32" ];
        }
        {
          # Silja Kone
          publicKey = "t9cmHc6/+0njdzsTFnnhEGKfhCa2VXFrTH9hF1jOCXw=";
          allowedIPs = [ "10.100.0.6/32" ];
        }
        {
          # Vili helium
          publicKey = "iGO375NT9EK5LH+E9vjPRRJp+UM4rZ2d1RMVR3f5R0c=";
          allowedIPs = [ "10.100.0.7/32" ];
        }
      ];
    };
  };

  services.ddclient = {
    enable = true;
    usev6 = "";
    domains = [ "netflix.vsinerva.fi" ];
    server = "www.ovh.com";
    username = "vsinerva.fi-dynraspi";
    passwordFile = ddPassFile;
  };
  #################### EVERYTHING BELOW THIS SHOULD NOT NEED TO CHANGE ####################

  nix.settings = {
    cores = 3;
    max-jobs = 2;
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
    ];
    loader = {
      systemd-boot.enable = pkgs.lib.mkForce false;
      efi.canTouchEfiVariables = pkgs.lib.mkForce false;
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = hostname;
    wireless = {
      enable = false;
      #      networks."${SSID}".psk = SSIDpassword;
      #      interfaces = [ interface ];
    };
  };
}
