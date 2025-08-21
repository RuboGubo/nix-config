{
  imports = [
    ./disko.nix
  ];
  networking.useNetworkd = true; # Need this to fix a very random bug.
  
  clan.core.settings.state-version.enable = true;
}
