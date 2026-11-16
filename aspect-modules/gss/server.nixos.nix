{
  pkgs,
  inputs,
  config,
  aspects,
  ...
}:
{
  imports = [
    inputs.arion.nixosModules.arion
    aspects.gss.firefly.nixos
    aspects.gss.nginx.nixos
  ];

  programs.ssh.knownHosts."gitlab.com".publicKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";

  environment.systemPackages = [ pkgs.docker-client ];

  # Keep Clan as the secret backend for now, without deriving the service
  # configuration from a Clan inventory role.
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
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.arion = {
    # The pinned Arion already supports the new journald settings options.
    package = import "${inputs.arion}/nix/arion.nix" { inherit pkgs; };
    backend = "podman-socket";

    projects.gss = {
      serviceName = "gss";
      settings = {
        imports = [ ./_arion.nix ];
        _module.args = {
          vars = config.clan.core.vars.generators.gss.files;
          enableCertbot = true;
          inherit inputs;
        };
      };
    };
  };
}
