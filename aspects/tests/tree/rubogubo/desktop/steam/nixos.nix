{ self, ... }:
{
  imports = [ self.aspects.steam.nixos ];

  test.customSteam = true;
}
