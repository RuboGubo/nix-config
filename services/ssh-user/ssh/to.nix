{ settings, config, ... }:
{
  users.users."${settings.user}".openssh.authorizedKeys.keyFiles = [
    config.clan.core.vars.generators."key.ssh.${settings.user}".files.public_key.path
  ];
}
