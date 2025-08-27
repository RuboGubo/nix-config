{ pkgs, ... }:
{
  imports = [
    ./common.nix
    ./gnome.nix
    ./flatpak.nix
  ];

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
  fonts.enableDefaultPackages = true;

  home-manager.users."rubogubo" =
    { lib, ... }:
    {
      imports = [ ];

      home.username = "rubogubo";
      home.packages = with pkgs; [
        # (import ../../modules/kakao.nix)
        # kakao
        xclip
        firefox
        thunderbird
        jdk
        qemu
        gnomeExtensions.blur-my-shell
        gnomeExtensions.caffeine
        gnomeExtensions.night-theme-switcher
        gnomeExtensions.docker
        gnomeExtensions.tiling-shell
        gnomeExtensions.do-not-disturb-while-screen-sharing-or-recording
        gnomeExtensions.system-monitor
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
        jdt-language-server
        podman-compose

        wireshark
        # Font
        nerd-fonts.jetbrains-mono
        nanum
        openfortivpn
      ];

      programs.zed-editor = {
        enable = true;
        extraPackages = with pkgs; [
          nil
          rust-analyzer
          taplo-lsp
          package-version-server
        ];
        userSettings = {
          lsp.rust-analyzer.binary.path = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          autosave = "on_focus_change";
        };
      };

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
      dconf.settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;

          enabled-extensions = [
            pkgs.gnomeExtensions.blur-my-shell.extensionUuid
            pkgs.gnomeExtensions.caffeine.extensionUuid
            pkgs.gnomeExtensions.night-theme-switcher.extensionUuid
            pkgs.gnomeExtensions.docker.extensionUuid
            pkgs.gnomeExtensions.tiling-shell.extensionUuid
            pkgs.gnomeExtensions.do-not-disturb-while-screen-sharing-or-recording.extensionUuid
            pkgs.gnomeExtensions.system-monitor.extensionUuid
          ];

          favorite-apps = [
            "firefox.desktop"
            "app.zen_browser.zen.desktop"
            "org.gnome.Console.desktop"
            "dev.zed.Zed.desktop"
            "org.gnome.Nautilus.desktop"
            "org.gnome.Calendar.desktop"
            "org.gnome.Geary.desktop"
          ];
        };
        "org/gnome/shell/extensions/system-monitor".show-swap = false;
        # set wallpapers
        "org/gnome/desktop/background" = {
          picture-uri = "${../../modules/background/light/us.jpg}";
          # picture-uri-dark = toString ./background/dark/Firefox_wallpaper.png;
          picture-uri-dark = "${../../modules/background/dark/Starchitect.jpg}";
        };
        "org/gnome/desktop/interface".accent-color = "green";
        "org/gnome/shell/extensions/nightthemeswitcher/time" = {
          manual-schedule = true;
          # everything after is persentage of hour passed, for some reason
          sunrise = 5.25;
          sunset = 20.95;
        };
        # Dark mode for night time + night light
        "org/gnome/shell/extensions/nightthemeswitcher/commands" = {
          enabled = true;
          sunset = "gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true";
          sunrise = "gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false";
        };
        "org/gnome/mutter" = {
          edge-tiling = true;
          dynamic-workspaces = true;
        };
        "org/gnome/desktop/session" = with lib.hm.gvariant; {
          idle-delay = mkUint32 900;
        };
        "org/gnome/desktop/interface" = {
          clock-show-weekday = true;
        };
        "org/gnome/system/location" = {
          enabled = true;
        };
        "org/gnome/shell/weather" = {
          automatic-location = true;
        };
        "org/gnome/desktop/input-sources" = {
          sources = with lib.hm.gvariant; [
            (mkTuple [
              "xkb"
              "gb"
            ])
            (mkTuple [
              "ibus"
              "hangul"
            ])
          ];
        };
      };
    };
}
