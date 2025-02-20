{ config, ... }:
{
  users.users."cert-store" = {
    isNormalUser = true;
    description = "Read-only access to certs";
    openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys ++ [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHj2PK6LHsanSqaz8Gf/VqHaurd5e6Y7KnZNBiHb9adT nextcloud"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDiJZWlmiEkVzlf5/KV/jKkCGlgp8mnEeCnwk/dhdctJ gitea"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOgIXTr7HxC13UNZP0UCALBRJuiDh4U0Nnd4GPIE4RQR vaultwarden"
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBsctvJR4JOVoTAas0+lb8662EXFsQVNozTntnR7o5R1 opnsense"
  ];

}
