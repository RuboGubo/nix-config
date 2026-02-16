{
  flake.modules.nixos.gss =
    {
      pkgs,
      inputs,
      config,
      ...
    }@args:
    {
      imports = [
        inputs.arion.nixosModules.arion
      ];

      environment.systemPackages = [
        pkgs.docker-client
      ];

      clan.core.vars.generators.gss = {
        share = true;
        prompts = {
          secret-env.description = "GSS secret.env";
          secret-env.type = "multiline";
          secret-env.persist = true;

          recipes-env.description = "Env file for the recipes service";
          recipes-env.type = "multiline";
          recipes-env.persist = true;
        };
      };

      virtualisation.podman = {
        enable = true;
        autoPrune.enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        defaultNetwork.settings = {
          # Required for container networking to be able to use names.
          dns_enabled = true;
        };
      };

      virtualisation.arion = {
        backend = "podman-socket";

        projects.gss = {
          serviceName = "gss";
          settings = {
            imports = [ inputs.self.modules.arion.gss ];

            # Pass inputs explicitly through _module.args
            _module.args = {
              # Pass the inputs from the calling flake
              vars = config.clan.core.vars.generators.gss.files;
              enableCertbot = true;
              inherit (args) inputs;
            };
          };
        };
      };
    };

  flake.modules.home.gss =
    { pkgs, osConfig, ... }:
    {
      home.file."services/gss/docker-compose.yaml".text =
        osConfig.virtualisation.arion.projects.gss.settings.out.dockerComposeYamlText;

      home.packages = [ pkgs.podman-compose ];
    };
}
