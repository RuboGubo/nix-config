{ self, inputs, ... }:
{
  imports = [
    inputs.clan-core.flakeModules.default
    ./services/flake-module.nix
  ];
  clan = {
    inherit self;
    specialArgs = {
      inherit inputs;
    };
    # Ensure this is unique among all clans you want to use.
    meta.name = "GreenSiren";

    inventory = {
      machines = {
        node1 = {
          tags = [ "server" ];
          deploy.targetHost = "178.79.150.220";
          # deploy.buildHost = "localhost";
        };
        green-laptop = {
          tags = [
            "desktop"
            "wifi"
          ];
          deploy.targetHost = "root@localhost";
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

        green_siren_services = {
          module = {
            name = "green_siren_services";
            input = "self";
          };

          roles.default.machines."node1" = { };
        };

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
