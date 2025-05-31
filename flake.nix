{
  description = "RuboGubo's Clan";
  inputs = {
    nixpkgs.follows = "clan-core/nixpkgs";
    clan-core.url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };
  
  outputs =
    { self, clan-core, home-manager, nix-flatpak, ... }:
    let
      # Usage see: https://docs.clan.lol
      clan = clan-core.lib.buildClan {
        inherit self;
        # Ensure this is unique among all clans you want to use.
        meta.name = "Green Siren";
        
        modules."local/rubogubo" = import ./services/rubogubo;
        modules."local/local" = import ./services/local;
        
        inventory = {
          machines = {
            node1.tags = [ "server" ];
          };
          instances = {
            rubogubo = {
              module.name = "local/rubogubo";
              
              roles.server.tags."server" = {};
              roles.desktop.tags."desktop" = {};  
            };
            local = {
              module.name = "local/local";
              
              roles.server.tags."server" = {};
              roles.desktop.tags."desktop" = {}; 
            };
          };
          services = {
            importer."home-manager" = {
              roles.default.tags = [ "all" ];
              roles.default.extraModules = [ home-manager.nixosModules.home-manager ];
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
              packages = [ clan-core.packages.${system}.clan-cli ];
            };
          });
    };

}
