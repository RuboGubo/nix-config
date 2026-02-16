{ ... }:
{
  _class = "clan.service";
  manifest.name = "RuboGubo";
  manifest.description = "The RuboGubo User";
  manifest.categories = [ "User" ];

  roles.server.perInstance.nixosModule =
    { inputs, ... }:
    {
      imports = [ ./common.nix ];
      home-manager.users."rubogubo".imports = [ 
        inputs.self.modules.homeManager.gss
        inputs.self.modules.homeManager.zsh
      ];
    };
  roles.desktop.perInstance.nixosModule.imports = [
    ./desktop.nix
    ./podman.nix
  ];
}
