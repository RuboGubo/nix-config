{
  flake.modules.homeManager.document-apps = { pkgs-unstable, ... }:
  {
    # unstable as i need the autoreloading to keep the scroll bar progress.
    home.packages = [ pkgs-unstable.papers ];
  };
}