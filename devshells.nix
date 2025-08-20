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
