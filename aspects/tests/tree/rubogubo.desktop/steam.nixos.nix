{ aspects, ... }:
{
  imports = [ aspects.steam.nixos ];

  test.customSteam = true;
}
