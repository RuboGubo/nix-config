{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  nixosConfig = config;
  cfg = config.services.sshUsers;
  identityNames = builtins.attrNames cfg;
  authorizedAccounts = lib.unique (lib.concatMap (name: cfg.${name}.access) identityNames);
in
{
  options.services.sshUsers = lib.mkOption {
    default = { };
    description = "Managed SSH identities and the local accounts they may access.";
    type = lib.types.attrsOf (
      lib.types.submodule {
        options.access = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Local accounts that may be accessed using this identity.";
        };
      }
    );
  };

  config = lib.mkMerge [
    {
      clan.core.vars.generators = lib.mapAttrs' (
        name: _:
        lib.nameValuePair "key.ssh.${name}" {
          prompts.private_key = {
            type = "hidden";
            persist = false;
            description = "Enter ${name}'s private key (empty to autogenerate)";
          };
          share = true;

          files.public_key.secret = false;
          files.private_key = {
            owner = name;
            # Preserve the existing metadata so adopting this module does not
            # mutate or regenerate an established Clan identity.
            mode = "0700";
            secret = true;
          };

          runtimeInputs = [ pkgs.openssh ];
          script = ''
            if [ ! -s "$prompts/private_key" ]; then
              ssh-keygen -t ed25519 -f ./key -N "" -C "${name}-clan"
              mv ./key $out/private_key
              mv ./key.pub $out/public_key
            else
              mv $prompts/private_key $out/private_key
              ssh-keygen -f $prompts/private_key -y > $out/public_key
            fi
          '';
        }
      ) cfg;

      users.users = lib.genAttrs authorizedAccounts (account: {
        isNormalUser = lib.mkDefault true;
        openssh.authorizedKeys.keys = map (
          name: config.clan.core.vars.generators."key.ssh.${name}".files.public_key.value
        ) (lib.filter (name: builtins.elem account cfg.${name}.access) identityNames);
      });

      # Install each identity wherever its managed SSH user is configured. These
      # are the same paths used by the previous Home Manager module and also work
      # on configurations that do not import Home Manager.
      systemd.tmpfiles.rules = lib.concatMap (
        name:
        let
          generator = config.clan.core.vars.generators."key.ssh.${name}";
          sshDirectory = "/home/${name}/.ssh";
        in
        [
          "d ${sshDirectory} 0700 ${name} - -"
          "L+ ${sshDirectory}/id_ed25519 - - - - ${generator.files.private_key.path}"
          "L+ ${sshDirectory}/id_ed25519.pub - - - - ${generator.files.public_key.path}"
        ]
      ) identityNames;
    }

    # Preserve Home Manager ownership of existing key links where it is
    # available, avoiding their removal during the first migration switch.
    (lib.optionalAttrs (builtins.hasAttr "home-manager" options) {
      home-manager.users = lib.genAttrs identityNames (
        name:
        { config, ... }:
        let
          generator = nixosConfig.clan.core.vars.generators."key.ssh.${name}";
        in
        {
          home.file."/home/${name}/.ssh/id_ed25519".source =
            config.lib.file.mkOutOfStoreSymlink generator.files.private_key.path;
          home.file."/home/${name}/.ssh/id_ed25519.pub".source =
            config.lib.file.mkOutOfStoreSymlink generator.files.public_key.path;
        }
      );
    })
  ];
}
