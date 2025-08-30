{
  pkgs,
  ...
}:
{
  users.users.rubogubo = {
    description = "RuboGubo";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "input"
    ];
    uid = 1000;
    shell = pkgs.zsh;
  };

  # Should be it's own service at some point
  nix.settings.substituters = [ "https://aseipp-nix-cache.global.ssl.fastly.net" ];

  programs.zsh.enable = true;

  home-manager.backupFileExtension = "bak";
  home-manager.users."rubogubo" = {
    home.stateVersion = "24.11";

    home.file."Projects/.keep".text = "";

    home.packages = with pkgs; [
      inotify-tools
      hollywood
      age
      ssh-to-age
      sops
      gnupg
      nix-output-monitor
      pkg-config
      jq
      yq
      home-manager

      # Command Line
      eza
      git
      zip
      bat
      just
      fastfetch
      cowsay

      # dev tools
      devenv

      # Rust tools
      wasm-pack

      # Server Admin
      systemctl-tui
    ];

    programs.git = {
      enable = true;
      lfs.enable = true;
      userName = "RuboGubo";
      userEmail = "ruben.john.ward@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        push.rebase = false;
      };
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

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
      };
    };
  };
}
