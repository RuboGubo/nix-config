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
      name = roles."ssh-from".settings.user;
      value.openssh.authorizedKeys.keyFiles = [
        config.clan.core.vars.generators."key.ssh.${to_user}".files.public_key.path
      ];
    }) settings.users
  );
}
