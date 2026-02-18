{
  flake.modules.homeManager.zsh =
    { pkgs, lib, ... }:
    {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        autocd = true;

        initContent = ''
          bindkey '^H' backward-kill-word
        '';

        plugins = [
          {
            name = "zsh-nix-shell";
            file = "nix-shell.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "chisui";
              repo = "zsh-nix-shell";
              rev = "v0.8.0";
              sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
            };
          }
          {
            name = "zsh-jj";
            file = "zsh-jj.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "RuboGubo";
              repo = "zsh-jj";
              tag = "v";
              sha256 = "sha256-GDHTp53uHAcyVG+YI3Q7PI8K8M3d3i2+C52zxnKbSmw=";
            };
          }
        ];

        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "rust"
            "python"
            "ruby"
            "direnv"
          ];
          theme = "bira";
        };
        shellAliases = {
          clear = "clear && echo \"You should use ctrl+l to clear the terminal\"";
          ls = "eza --icons -h";
          c = "clear";
          w = "cargo watch -c -x";
          vim = "nvim";
          node1 = "ssh service@node1.greensiren.co.uk";
          node2 = "ssh service@node2.greensiren.co.uk";
          gac = "git add . && git commit -m ";
          gp = "git push";
          clip = "xclip -selection clipboard";
        };
      };
    };
}
