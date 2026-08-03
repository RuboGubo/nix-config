{ inputs, ... }:
{
  imports = [ inputs.self.aspects.rubogubo.common.nixos ];

  home-manager.users."rubogubo".imports = [
    inputs.self.modules.homeManager.gss
  ];
}
