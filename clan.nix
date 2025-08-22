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
    # Ensure this is unique among all clans you want to use.
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
            inputs.nix-flatpak.nixosModules.nix-flatpak
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

          # roles.default.settings.networks.hanseo-phone = {};
          roles.default.settings.networks.rubogubo-phone = { };
          roles.default.settings.networks."Home" = { };
          roles.default.tags."wifi" = { };
        };
        "ssh.rubogubo" = {
          module = {
            name = "ssh-user";
            input = "self";
          };

          roles."ssh-from".settings = {
            known_hosts."gitlab.com".publicKey =
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
            user = "rubogubo";
          };
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
