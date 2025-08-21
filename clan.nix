{ self, inputs, ... }:
{
  imports = [
    inputs.clan-core.flakeModules.default
  ];
  clan = {
    inherit self;
    specialArgs = {
      inherit inputs;
    };
    # Ensure this is unique among all clans youinputs want to use.
    meta.name = "GreenSiren";

    modules."rubogubo" = import ./services/rubogubo;
    modules."local" = import ./services/local;
    modules."podman-compose" = import ./services/podman-compose;
    modules."ssh-user" = import ./services/ssh-user;
    modules."node1" = import ./services/node1;

    inventory = {
      machines = {
        node1 = {
          tags = [ "server" ];
          deploy.targetHost = "root@176.58.117.204";
          deploy.buildHost = "root@127.0.0.1";
        };
        green-laptop = {
          tags = [
            "desktop"
            "wifi"
          ];
          deploy.targetHost = "root@192.168.86.243";
          # deploy.buildHost = "root@192.168.86.243";
        };
        green = {
          tags = [
            "desktop"
            "wifi"
          ];
          deploy.targetHost = "root@192.168.86.26";
        };
      };
      instances = {
        # Actual useful stuff

        # node1 = {
        #   module = {
        #     name = "node1";
        #     input = "self";
        #   };

        #   # roles.default.machines."green-laptop" = { };
        # };

        # Server Admin
        ssh = {
          module = {
            name = "sshd";
            input = "clan-core";
          };

          roles.server.tags."all" = { };
          roles.client.tags."all" = { };
        };
        # podman-compose = {
        #   module.name = "podman-compose";

        #   roles.default.machines."node1".settings.path = ./podman-compose.yaml;
        # };
        rubogubo = {
          module = {
            name = "rubogubo";
            input = "self";
          };

          roles.server.tags."server" = { };
          roles.server.extraModules = [
            inputs.home-manager.nixosModules.home-manager
          ];
          roles.desktop.tags."desktop" = { };
          roles.desktop.extraModules = [
            inputs.home-manager.nixosModules.home-manager
          ];
        };
        rubogubo-password = {
          module = {
            name = "users";
            input = "clan-core";
          };
          roles.default.tags."all" = { };
          roles.default.settings.user = "rubogubo";
        };
        root-password = {
          module = {
            name = "users";
            input = "clan-core";
          };
          roles.default.tags."all" = { };
          roles.default.settings.user = "root";
        };
        local = {
          module = {
            name = "local";
            input = "self";
          };

          roles.server.tags."server" = { };
          roles.desktop.tags."desktop" = { };
        };
        wifi = {
          module = {
            name = "wifi";
            input = "clan-core";
          };

          # roles.default.settings.networks.glide = {};
          # roles.default.settings.networks.hanseo-phone = {};
          # roles.default.settings.networks.rubogubo-phone = {};
          roles.default.settings.networks."Home" = { };
          roles.default.tags."wifi" = { };
        };
        "flatpak" = {
          module = {
            name = "importer";
            input = "clan-core";
          };
          roles.default.tags."desktop" = { };
          roles.default.extraModules = [
            inputs.nix-flatpak.nixosModules.nix-flatpak
          ];
        };
        # "home-manager" = {
        #   module = {
        #     name = "importer";
        #     input = "clan-core";
        #   };
        #   roles.default.tags."all" = { };
        #   roles.default.extraModules = [
        #     inputs.home-manager.nixosModules.home-manager
        #   ];
        # };
        "ssh.rubogubo" = {
          module = {
            name = "ssh-user";
            input = "self";
          };

          roles."ssh-from".settings.user = "rubogubo";
          roles."ssh-to".settings.users = [
            "rubogubo"
            "root"
          ];

          roles."ssh-from".tags."desktop" = { };
          roles."ssh-to".tags."all" = { };
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
