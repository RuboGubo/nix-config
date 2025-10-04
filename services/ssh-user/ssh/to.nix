{
  settings,
  config,
  roles,
  lib,
  ...
}:
let
  # is_valid =
  #   user:
  #   (
  #     config.users.users ? "${user}"
  #     && (
  #       (config.users.users.${user}.isSystemUser or false)
  #       || (config.users.users.${user}.isNormalUser or false)
  #     )
  #   );
  # valid_users = lib.filter is_valid settings.users;
in
{
  config.users.users = lib.genAttrs settings.users (to_user: {
    isNormalUser = lib.mkDefault true; # I just gave up, I didn't want to have to do this :(  you can see my attepmts up above, but it never worked :(((((((((
    openssh.authorizedKeys.keys = [
      config.clan.core.vars.generators."key.ssh.${roles."ssh-from".settings.user}".files.public_key.value
    ];
  });
}
