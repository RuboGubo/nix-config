{
  clan.modules."green_siren_services" = {
    _class = "clan.service";
    manifest.name = "Green Siren Services";
    manifest.description = "Sets up the services for Green Siren. Please make sure to run `just build` first.";
    manifest.categories = [ "Services" ];

    roles.default.perInstance.nixosModule =
      { inputs, ... }:
      {
        imports = [
          {
            programs.ssh.knownHosts."gitlab.com" = {
              publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
            };
          }
          inputs.self.modules.nixos.gss
        ];
      };
  };
}
