{ inputs, aspects, ... }:
{
  imports = [ aspects.rubogubo.common.nixos ];

  home-manager.users."rubogubo".imports = [
    inputs.self.modules.homeManager.gss
  ];
}
