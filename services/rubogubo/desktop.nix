{ pkgs, inputs, ... }:
{
  imports = [
    ./common.nix
    ./gnome.nix
    ./flatpak.nix
    # inputs.self.modules.nixos.gss
  ];

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-sans
  ];
  fonts.enableDefaultPackages = true;

  home-manager.users."rubogubo" = {
    imports = [ 
      ./home/accounts.nix
    ];

    home.username = "rubogubo";
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      # (import ../../modules/kakao.nix)
      # kakao
      xclip
      firefox
      thunderbird
      jdk
      qemu
      rustup
      # discord
      python3
      gcc
      seahorse
      zsh
      typescript
      prismlauncher
      pgadmin4-desktopmode
      libreoffice-qt
      hunspell
      hunspellDicts.en_GB-ise
      ruby
      nfs-utils
      blackbox-terminal
      nixd
      podman-compose
      steam

      wireshark
      # Font
      nerd-fonts.jetbrains-mono
      noto-fonts
      nanum
      openfortivpn

      typewriter

      # COM1008 tools
      insomnia
    ];

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
        features.edit_prediction_provider = "none";
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
      text = ''file:///home/rubogubo/Projects'';
      force = true;
    };

    home.file."/home/rubogubo/.config/Code/User/globalStorage/zokugun.sync-settings/settings.yml" = {
      source = ./vscode_sync_repo.yml;
      force = true;
    };
    home.file."/home/rubogubo/.config/VSCodium/User/globalStorage/zokugun.sync-settings/settings.yml" =
      {
        source = ./vscode_sync_repo.yml;
        force = true;
      };

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
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
