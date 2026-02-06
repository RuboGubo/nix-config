{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  users.users.rubogubo = {
    description = "RuboGubo";
    isNormalUser = lib.mkForce true;
    isSystemUser = lib.mkForce false;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "input"
      "podman"
      "docker"
    ];
    uid = 1000;
    shell = pkgs.zsh;
  };

  # Should be it's own service at some point
  nix.settings.substituters = [ "https://aseipp-nix-cache.global.ssl.fastly.net" ];
  nix.settings.trusted-users = [ "rubogubo" ];

  programs.nix-ld.enable = true;
  programs.zsh.enable = true;

  home-manager.backupFileExtension = "bak";
  home-manager.users."rubogubo" =
    {
      imports = [
        ../../modules/zsh.nix
      ];
      home.stateVersion = "25.11";

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
        tldr

        # dev tools
        devenv

        # Rust tools
        wasm-pack

        # Server Admin
        systemctl-tui
      ];

      programs.jujutsu = {
        enable = true;
        settings = {
          ui.default-command = "log";
          user = {
            email = "ruben.john.ward@gmail.com";
            name = "Ruben Ward";
          };
          remotes.origin.auto-track-bookmarks = "glob:ruben/*@*";
          git = {
            write-change-id-header = true;
          };
        };
      };

      programs.git = {
        enable = true;
        lfs.enable = true;
        settings = {
          user.name = "RuboGubo";
          user.email = "ruben.john.ward@gmail.com";
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
          push.rebase = false;
        };
      };

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableZshIntegration = true;
        config = {
          hide_env_diff = true;
        };
      };
    };
}
