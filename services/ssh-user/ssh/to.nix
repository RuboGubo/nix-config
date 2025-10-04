{
  settings,
  config,
  roles,
  lib,
  ...
}:
{
  users.users = lib.genAttrs settings.users (to_user: {
    openssh.authorizedKeys.keys =
      lib.mkIf
        (
          config.users.users ? "${to_user}"
          && (
            (config.users.users.${to_user}.isSystemUser or false)
            || (config.users.users.${to_user}.isNormalUser or false)
          )
        )
        [
          config.clan.core.vars.generators."key.ssh.${roles."ssh-from".settings.user}".files.public_key.value
        ];
  });

}
