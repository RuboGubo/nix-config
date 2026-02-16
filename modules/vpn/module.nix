{
  flake.modules.homeManager.uni_vpn =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.openfortivpn ];
    };
}
