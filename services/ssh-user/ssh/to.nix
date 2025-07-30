{
  settings,
  config,
  roles,
  lib,
  ...
}:
{
  users.users = lib.listToAttrs (
    map (to_user: {
      name = to_user;
      value.openssh.authorizedKeys.keys = [
        config.clan.core.vars.generators."key.ssh.${roles."ssh-from".settings.user}".files.public_key.value
      ];
    }) settings.users
  );
}
