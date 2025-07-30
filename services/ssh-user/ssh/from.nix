{
  config,
  settings,
  ...
}:
let
  clan-config = config;
in
{
  home-manager.users."${settings.user}" =
    { config, ... }:
    {
      home.file."/home/${settings.user}/.ssh/id_ed25519.pub".source =
        config.lib.file.mkOutOfStoreSymlink
          clan-config.clan.core.vars.generators."key.ssh.${settings.user}".files.public_key.path;
      home.file."/home/${settings.user}/.ssh/id_ed25519" = {
        source =
          config.lib.file.mkOutOfStoreSymlink
            clan-config.clan.core.vars.generators."key.ssh.${settings.user}".files.private_key.path;
      };
    };
}
