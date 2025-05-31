{ pkgs, lib, ... }:
{
  imports = [
    ./common.nix
    ../../modules/gnome.nix
    ./flatpak.nix
  ];
  
  home.packages = with pkgs; [
    firefox
    jdk
    qemu
    gnomeExtensions.blur-my-shell
    gnomeExtensions.caffeine
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.docker
    gnomeExtensions.tiling-shell
    gnomeExtensions.do-not-disturb-while-screen-sharing-or-recording
    rustup
    discord
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
    zed-editor

    wireshark
    # Font
    nerd-fonts.jetbrains-mono
    nanum
    openfortivpn
  ];
  
  home.file."/home/rubogubo/.config/gtk-3.0/bookmarks" = {
    text = ''file:///home/rubogubo/Projects'';
    force = true;
  };
  
  home.file."/home/rubogubo/.config/Code/User/globalStorage/zokugun.sync-settings/settings.yml" = {
    source = ./vscode_sync_repo.yml;
    force = true;
  };
  home.file."/home/rubogubo/.config/VSCodium/User/globalStorage/zokugun.sync-settings/settings.yml" = {
    source = ./vscode_sync_repo.yml;
    force = true;
  };
  
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    userTasks = {
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
        "blur-my-shell@aunetx"
        "caffeine@patapon.info"
        "system-monitor@gnome-shell-extensions.gcampax.github.com"
        "nightthemeswitcher@romainvigier.fr"
        "do-not-disturb-while-screen-sharing-or-recording@marcinjahn.com"
        "tilingshell@ferrarodomenico.com"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
      ];

      favorite-apps = [
        "app.zen_browser.zen.desktop"
        "org.gnome.Console.desktop"
        "codium.desktop"
        "dev.zed.Zed.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Calendar.desktop"
        "org.gnome.Geary.desktop"
      ];
    };
    "org/gnome/shell/extensions/system-monitor".show-swap = false;
    # set wallpapers
    "org/gnome/desktop/background" = {
      picture-uri = "${./background/light/us.jpg}";
      # picture-uri-dark = toString ./background/dark/Firefox_wallpaper.png;
      picture-uri-dark = "${./background/dark/Starchitect.jpg}";
    };
    "org/gnome/desktop".accent-color = "green";
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
}
