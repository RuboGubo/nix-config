{
  pkgs,
  config,
  settings,
  ...
}:
let
  clan-config = config;
in
{
  clan.core.vars.generators."key.ssh.${settings.user}" = {
    prompts.private_key = {
      type = "hidden";
      persist = false;
      description = "Enter ${settings.user}'s private key (empty to autogenerate)";
    };
    share = true;

    files.public_key = {
      owner = settings.user;
      mode = "0644";
      secret = false;
    };
    files.private_key = {
      owner = settings.user;
      mode = "0700";
      secret = true;
    };

    runtimeInputs = [
      pkgs.openssh
    ];
    script = ''
      if [ ! -s "$prompts/private_key" ]; then
        ssh-keygen -t ed25519 -f ./key -N "" -C "${settings.user}"
        mv ./key $out/private_key
        mv ./key.pub $out/public_key
      else
        mv $prompts/private_key $out/private_key
        ssh-keygen -f $prompts/private_key -y > $out/public_key
      fi
    '';
  };

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
