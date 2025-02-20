{ ... }:
{
  services.openssh.knownHosts."cert-store.vsinerva.fi".publicKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP4FaKqA2rQbxpdRBdGtb2lb5El/zbGnvmDfdYJdrxH7";

  systemd.services.nginx = {
    wants = [ "mnt-acme.mount" ];
    after = [ "mnt-acme.mount" ];
  };

  fileSystems."/mnt/acme" = {
    device = "cert-store@cert-store.vsinerva.fi:/home/cert-store/acme/-.vsinerva.fi";
    fsType = "sshfs";
    options = [
      "nodev"
      "noatime"
      "allow_other"
      "IdentityFile=/etc/ssh/ssh_host_ed25519_key"
    ];
  };
}
