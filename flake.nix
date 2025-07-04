{
  description = "RuboGubo's Clan";
  inputs = {
    nixpkgs.follows = "clan-core/nixpkgs";
    clan-core.url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs =
    {
      self,
      clan-core,
      home-manager,
      nix-flatpak,
      nixpkgs,
      ...
    }:
    let
      # Usage see: https://docs.clan.lol
      clan = clan-core.lib.buildClan {
        inherit self;
        # Ensure this is unique among all clans you want to use.
        meta.name = "GreenSiren";

        modules."rubogubo" = import ./services/rubogubo;
        modules."local" = import ./services/local;
        modules."podman-compose" = import ./services/podman-compose;
        modules."ssh-user" = import ./services/ssh-user;

        inventory = {
          machines = {
            node1.tags = [ "server" ];
            green-laptop.tags = [
              "desktop"
              "wifi"
            ];
          };
          instances = {
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
              roles.desktop.tags."desktop" = { };
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
              roles.default.tags."wifi" = { };
            };
            "flatpak" = {
              module = {
                name = "importer";
                input = "clan-core";
              };
              roles.default.tags."desktop" = { };
              roles.default.extraModules = [
                nix-flatpak.nixosModules.nix-flatpak
              ];
            };
            "home-manager" = {
              module = {
                name = "importer";
                input = "clan-core";
              };
              roles.default.tags."all" = { };
              roles.default.extraModules = [
                home-manager.nixosModules.home-manager
              ];
            };
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
          };
        };

        # All machines in the ./machines will be imported.

        # Prerequisite: boot into the installer.
        # See: https://docs.clan.lol/getting-started/installer
        # local> mkdir -p ./machines/machine1
        # local> Edit ./machines/<machine>/configuration.nix to your liking.
        machines = {
          # You can also specify additional machines here.
          # somemachine = {
          #  imports = [ ./some-machine/configuration.nix ];
          # }
        };
      };
    in
    {
      inherit (clan) nixosConfigurations clanInternals;

      # Add the Clan cli tool to the dev shell.
      # Use "nix develop" to enter the dev shell.
      devShells =
        clan-core.inputs.nixpkgs.lib.genAttrs
          [
            "x86_64-linux"
            "aarch64-linux"
            "aarch64-darwin"
            "x86_64-darwin"
          ]
          (system: {
            default = clan-core.inputs.nixpkgs.legacyPackages.${system}.mkShell {
              packages = [
                clan-core.packages.${system}.clan-cli
                nixpkgs.legacyPackages.${system}.nixfmt-rfc-style
              ];
            };
          });
    };

}
