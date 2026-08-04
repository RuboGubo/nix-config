{ aspects, ... }:
{
  imports = [ aspects.rubogubo.common.nixos ];

  home-manager.users."rubogubo".imports = [
    aspects.gss.compose.home
  ];
}
