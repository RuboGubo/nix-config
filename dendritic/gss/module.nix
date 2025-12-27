{
  flake.modules = {
    nixos.gss =
      {
        config,
        pkgs,
        lib,
        inputs,
        ...
      }@args:
      {
        imports = [
          inputs.arion.nixosModules.arion
        ];

        virtualisation.arion = {
          backend = "podman-socket";

          projects.gss = {
            serviceName = "gss";

            settings = {
              imports = [ ./arion-compose.nix ];

              # Pass inputs explicitly through _module.args
              _module.args = {
                # Pass the inputs from the calling flake
                inherit (args) inputs;
              };
            };
          };
        };
      };

    homeManager.gss =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.arion ];
      };
  };
}
