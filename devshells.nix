{
  perSystem =
    { pkgs, inputs', ... }:
    {
      devShells = {
        default = pkgs.mkShellNoCC {
          packages = [
            inputs'.clan-core.packages.default
            pkgs.compose2nix
            pkgs.just
            pkgs.systemctl-tui
            pkgs.pciutils
          ];
        };
        debug = pkgs.mkShell {
          packages = [
            pkgs.python3
            pkgs.helix
          ];
          shellHook = ''
            export GIT_ROOT="$(git rev-parse --show-toplevel)"
            export PATH=$PATH:~/Projects/clan-core/pkgs/clan-cli/bin
          '';
        };
      };
    };
}
