{ pkgs, aspects, ... }:
{
  imports = [
    aspects.rubogubo.common.nixos
    aspects.rubogubo.gnome.nixos
    aspects.rubogubo.flatpak.nixos
    aspects.rubogubo.podman.nixos

    aspects.hardware.printer.nixos
    aspects.hardware.fingerprint.nixos
  ];

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-sans
  ];
  fonts.enableDefaultPackages = true;

  home-manager.users."rubogubo" = {
    imports = [
      aspects.rubogubo.accounts.home
      aspects.vpn.uni.home
      aspects.rubogubo.profile.home
    ];

    home.username = "rubogubo";
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      # (import ../../modules/kakao.nix)
      # kakao
      xclip
      firefox
      thunderbird
      # rustup
      # discord
      python3
      # gcc
      seahorse
      zsh
      typescript
      prismlauncher
      pgadmin4-desktopmode
      libreoffice-qt
      hunspell
      hunspellDicts.en_GB-ise
      nfs-utils
      nixd
      podman-compose
      steam

      wireshark
      # Font
      nerd-fonts.jetbrains-mono
      noto-fonts
      nanum
      networkmanager-fortisslvpn
      resources

      # COM1008 tools
      insomnia
    ];

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/rubogubo/Projects/clan-config"; # sets NH_OS_FLAKE variable for you
    };

    programs.zed-editor = {
      package = pkgs.zed-editor-fhs;
      enable = true;
      extensions = [
        "nix"
        "toml"
        "html"
        "nginx"
        "Dockerfile"
        "git-firefly"
        "Justfile"
        "Catppuccin"
      ];
      extraPackages = with pkgs; [
        nil
        rust-analyzer
        taplo
        package-version-server
        nginx-language-server
        tinymist
        vscode-css-languageserver
        eslint
        vtsls
        typos-lsp
        ghc
      ];
      userSettings = {
        lsp.rust-analyzer.binary.path = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        edit_predictions.provider = "none";
        # autosave = "on_focus_change";
        autosave.after_delay.milliseconds = 500;
        buffer_font_family = "JetBrainsMono Nerd Font";
        terminal = {
          line_height = "standard";
          font_family = "JetBrainsMono Nerd Font";
        };
        theme = {
          mode = "system";
          light = "Catppuccin Latte";
          dark = "Catppuccin Mocha";
        };
      };
    };

    programs.firefox.profiles."default".search.default = "ddg";

    home.file."/home/rubogubo/.config/gtk-3.0/bookmarks" = {
      text = "file:///home/rubogubo/Projects";
      force = true;
    };

    home.file."/home/rubogubo/.config/Code/User/globalStorage/zokugun.sync-settings/settings.yml" = {
      source = ./_assets/vscode_sync_repo.yml;
      force = true;
    };
    home.file."/home/rubogubo/.config/VSCodium/User/globalStorage/zokugun.sync-settings/settings.yml" =
      {
        source = ./_assets/vscode_sync_repo.yml;
        force = true;
      };

    programs.vscodium = {
      enable = true;
      profiles.default.userTasks = {
        version = "2.0.0";
        tasks = [
          {
            label = "Install Settings Sync Dependencies";
            type = "shell";
            command = "codium --install-extension zokugun.sync-settings";
            presentation = {
              reveal = "never";
              close = true;
            };
          }
          {
            label = "Startup Settings Sync";
            command = "\${command:syncSettings.download}";
            dependsOn = [ "Install Settings Sync Dependencies" ];
            runOptions.runOn = "folderOpen";
            presentation = {
              reveal = "never";
              close = true;
            };
          }
        ];
      };
    };
  };
}
