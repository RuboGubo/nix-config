{ self, inputs, ... }:
{
  imports = [
    inputs.clan-core.flakeModules.default
    ./services/flake-module.nix
  ];
  clan = {
    inherit self;
    specialArgs = {
      inherit inputs self;
      inherit (self) aspects;
    };
    # Ensure this is unique among all clans you want to use.
    meta.name = "GreenSiren";

    inventory = {
      machines = {
        node1 = {
          tags = [
            "server"
            "gss"
          ];
          deploy.targetHost = "178.79.150.220";
        };
        green-laptop = {
          tags = [
            "desktop"
            "wifi"
          ];
          # Don't Specify deployment options, as they have no stable IP
        };
        green = {
          tags = [
            "desktop"
            "wifi"
          ];
          # Don't Specify deployment options, as they have no stable IP
        };
      };
      instances = {
        # Actual useful stuff

        # Server Admin
        tor = {
          roles.server.tags."all" = { };
        };
        ssh = {
          module = {
            name = "sshd";
            input = "clan-core";
          };

          roles.server.tags."all" = { };
          roles.client.tags."all" = { };
        };
        rubogubo-password = {
          module = {
            name = "users";
            input = "clan-core";
          };
          roles.default.tags."all" = { };
          roles.default.settings = {
            user = "rubogubo";
            share = true;
          };
        };
        root-password = {
          module = {
            name = "users";
            input = "clan-core";
          };
          roles.default.tags."all" = { };
          roles.default.settings = {
            user = "root";
            share = true;
          };
        };
        gss-password = {
          module = {
            name = "users";
            input = "clan-core";
          };
          roles.default.tags."gss" = { };
          roles.default.settings = {
            user = "gss";
            share = true;
          };
        };
        wifi = {
          module = {
            name = "wifi";
            input = "clan-core";
          };

          # roles.default.settings.networks.hanseo-phone = {};
          roles.default.settings.networks.rubogubo-phone = { };
          roles.default.settings.networks."Home" = { };
          roles.default.tags."wifi" = { };
        };
        clan-cache = {
          module = {
            name = "trusted-nix-caches";
            input = "clan-core";
          };
          roles.default.tags."all" = { };
        };
      };
    };
  };
}
