{ aspects, ... }:
{
  imports = [ aspects.ssh.users.nixos ];

  services.sshUsers.rubogubo.access = [
    "rubogubo"
    "root"
    "gss"
  ];
}
