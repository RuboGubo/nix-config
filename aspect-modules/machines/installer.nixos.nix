{ aspects, lib, ... }:
{
  # The installer currently has no machine-independent aspects. Keeping an
  # explicit endpoint gives it the same composition boundary as deployed
  # machines and a place for future installer-specific aspects.
  imports = [
    aspects.rubogubo.ssh.nixos
    aspects.ssh.known-hosts.nixos
  ];

  # The NixOS installer profile defaults to passwordless root access. This
  # machine instead receives root's hash from Clan's root-password secret.
  users.users.root = {
    hashedPassword = lib.mkForce null;
    initialHashedPassword = lib.mkForce null;
  };
}
