{ pkgs, inputs, ... }:
let
  # The PR author's maintainer entry has not landed in nixpkgs yet.
  kakaotalk =
    inputs.kakaotalk.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
      (old: {
        meta = old.meta // {
          maintainers = [ ];
        };
      });
in
{
  home.packages = [ kakaotalk ];
}
