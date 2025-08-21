{ ... }:
{
  _class = "clan.service";
  manifest.name = "SSH User";
  manifest.description = "A service to set up ssh keys for an individual user";
  manifest.categories = [ "User" ];

  roles."ssh-from" = {
    interface =
      { lib, ... }:
      {
        options.user = lib.mkOption {
          type = lib.types.str;
          description = "The user to install the secret to.";
        };
        options.known_hosts = lib.mkOption { # Copied directly from https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/programs/ssh.nix
          default = { };
          type = lib.types.attrsOf (
              lib.types.submodule (
              {
                  name,
                  config,
                  options,
                  ...
              }:
              {
                  options = {
                  certAuthority = lib.mkOption {
                      type = lib.types.bool;
                      default = false;
                      description = ''
                      This public key is an SSH certificate authority, rather than an
                      individual host's key.
                      '';
                  };
                  hostNames = lib.mkOption {
                      type = lib.types.listOf lib.types.str;
                      default = [ name ] ++ config.extraHostNames;
                      defaultText = lib.literalExpression "[ ${name} ] ++ config.${options.extraHostNames}";
                      description = ''
                      A list of host names and/or IP numbers used for accessing
                      the host's ssh service. This list includes the name of the
                      containing `knownHosts` attribute by default
                      for convenience. If you wish to configure multiple host keys
                      for the same host use multiple `knownHosts`
                      entries with different attribute names and the same
                      `hostNames` list.
                      '';
                  };
                  extraHostNames = lib.mkOption {
                      type = lib.types.listOf lib.types.str;
                      default = [ ];
                      description = ''
                      A list of additional host names and/or IP numbers used for
                      accessing the host's ssh service. This list is ignored if
                      `hostNames` is set explicitly.
                      '';
                  };
                  publicKey = lib.mkOption {
                      default = null;
                      type = lib.types.nullOr lib.types.str;
                      example = "ecdsa-sha2-nistp521 AAAAE2VjZHN...UEPg==";
                      description = ''
                      The public key data for the host. You can fetch a public key
                      from a running SSH server with the {command}`ssh-keyscan`
                      command. The public key should not include any host names, only
                      the key type and the key itself.
                      '';
                  };
                  publicKeyFile = lib.mkOption {
                      default = null;
                      type = lib.types.nullOr lib.types.path;
                      description = ''
                      The path to the public key file for the host. The public
                      key file is read at build time and saved in the Nix store.
                      You can fetch a public key file from a running SSH server
                      with the {command}`ssh-keyscan` command. The content
                      of the file should follow the same format as described for
                      the `publicKey` option. Only a single key
                      is supported. If a host has multiple keys, use
                      {option}`programs.ssh.knownHostsFiles` instead.
                      '';
                  };
              };
          })
        );
      };
    };

    perInstance =
      {
        settings,
        pkgs,
        roles,
        ...
      }:
      {
        nixosModule =
          { config, ... }:
          {
            imports = [
              (import ./ssh/common.nix { inherit roles pkgs; })
              (import ./ssh/from.nix { inherit settings config pkgs; })
            ];
          };
      };
  };
  
  roles."ssh-to" = {
    interface =
      { lib, ... }:
      {
        options.users = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "The users to install the public key to. You can then log into that user using the private key.";
        };
      };

    perInstance =
      {
        settings,
        pkgs,
        roles,
        ...
      }:
      {
        nixosModule =
          { config, lib, ... }:
          {
            imports = [
              (import ./ssh/common.nix { inherit roles pkgs; })
              (import ./ssh/to.nix {
                inherit
                  settings
                  config
                  pkgs
                  roles
                  lib
                  ;
              })
            ];
          };
      };
  };
}
