{ pkgs, ... }:
{
  services.xserver.enable = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  home-manager.users."rubogubo" =
    { lib, ... }:
    {
      home.packages = with pkgs; [
        gnomeExtensions.blur-my-shell
        gnomeExtensions.caffeine
        gnomeExtensions.night-theme-switcher
        gnomeExtensions.docker
        gnomeExtensions.tiling-shell
        gnomeExtensions.do-not-disturb-while-screen-sharing-or-recording
        gnomeExtensions.system-monitor
      ];

      dconf.settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;

          enabled-extensions = [
            pkgs.gnomeExtensions.blur-my-shell.extensionUuid
            pkgs.gnomeExtensions.caffeine.extensionUuid
            pkgs.gnomeExtensions.night-theme-switcher.extensionUuid
            # pkgs.gnomeExtensions.docker.extensionUuid
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
