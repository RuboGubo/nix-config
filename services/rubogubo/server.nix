{ inputs, ... }:
{
  home-manager.users."rubogubo".imports = [
    inputs.self.modules.homeManager.gss
  ];
}
