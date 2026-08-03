{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in
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
  nix.settings.substituters = [
    "https://aseipp-nix-cache.global.ssl.fastly.net"
    "https://nix-community.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
  nix.settings.trusted-users = [ "rubogubo" ];

  programs.nix-ld.enable = true;
  programs.zsh.enable = true;

  home-manager.backupFileExtension = "bak";
  home-manager.extraSpecialArgs = { inherit pkgs-unstable inputs; };
  home-manager.users."rubogubo" = {
    imports = [
      inputs.self.modules.homeManager.zsh
      inputs.self.aspects.rubogubo.devenv.home
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

      cachix

      # Command Line
      eza
      git
      zip
      bat
      just
      fastfetch
      cowsay
      tldr

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
        templates = {
          git_push_bookmark = ''"ruben-push-" ++ change_id.short()'';
          # Autogenerate for merge requests
          new_description = ''
            if(parents.len() > 1,
              "Merge " ++ parents.skip(1).map(|p| if(
                p.bookmarks(),
                p.bookmarks().first().name(),
                p.change_id().shortest(8)
              )).join(", ") ++ " into " ++ if(
                parents.first().bookmarks(),
                parents.first().bookmarks().first().name(),
                parents.first().change_id().shortest(8)
              ) ++ "\n",
              ""
            )
          '';
        };
        revsets.bookmark-advance-to = "@-";
        remotes.origin.auto-track-bookmarks = "ruben-*";
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
