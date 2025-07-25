_: {
  perSystem =
    { pkgs, inputs', ... }:
    {
      devShells = {
        default = pkgs.mkShellNoCC {
          packages = [
            inputs'.clan-core.packages.default
            pkgs.nil
            pkgs.compose2nix
            pkgs.just
            pkgs.nginx-language-server
            pkgs.systemctl-tui
          ];
        };
      };
    };
}
