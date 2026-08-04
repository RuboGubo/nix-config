{ aspects, ... }:
{
  # The installer currently has no machine-independent aspects. Keeping an
  # explicit endpoint gives it the same composition boundary as deployed
  # machines and a place for future installer-specific aspects.
  imports = [
    aspects.rubogubo.ssh.nixos
    aspects.ssh.known-hosts.nixos
  ];
}
