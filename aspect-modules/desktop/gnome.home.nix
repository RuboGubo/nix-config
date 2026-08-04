{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    gnomeExtensions.blur-my-shell
    gnomeExtensions.caffeine
    gnomeExtensions.night-theme-switcher
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
        pkgs.gnomeExtensions.tiling-shell.extensionUuid
        pkgs.gnomeExtensions.do-not-disturb-while-screen-sharing-or-recording.extensionUuid
        pkgs.gnomeExtensions.system-monitor.extensionUuid
      ];
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Console.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Calendar.desktop"
        "org.gnome.Geary.desktop"
      ];
    };

    "org/gnome/shell/extensions/system-monitor".show-swap = true;

    "org/gnome/desktop/background" = {
      picture-uri = "${../../background/light/us.jpg}";
      picture-uri-dark = "${../../background/dark/Starchitect.jpg}";
    };

    "org/gnome/desktop/interface" = {
      accent-color = "green";
      clock-show-weekday = true;
    };

    "org/gnome/shell/extensions/nightthemeswitcher/time" = {
      manual-schedule = true;
      sunrise = 5.25;
      sunset = 20.95;
    };

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

    "org/gnome/system/location".enabled = true;
    "org/gnome/shell/weather".automatic-location = true;

    "org/gnome/desktop/input-sources".sources = with lib.hm.gvariant; [
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
}
