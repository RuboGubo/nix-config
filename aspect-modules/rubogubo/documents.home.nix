{ pkgs-unstable, ... }:
{
  # Unstable is required for automatic reload while preserving scroll position.
  home.packages = [ pkgs-unstable.papers ];
}
