{
  flake.modules.homeManager.devenv =
    { pkgs-unstable, ... }:
    {
      home.packages = [ pkgs-unstable.devenv ];
    };
}
