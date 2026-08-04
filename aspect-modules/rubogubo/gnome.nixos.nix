{ aspects, ... }:
{
  services.xserver.enable = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  home-manager.users.rubogubo =
    { lib, ... }:
    {
      imports = [ aspects.desktop.gnome.home ];

      dconf.settings."org/gnome/shell".favorite-apps = lib.mkForce [
        "firefox.desktop"
        "app.zen_browser.zen.desktop"
        "com.raggesilver.BlackBox.desktop"
        "dev.zed.Zed.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Calendar.desktop"
        "org.gnome.Geary.desktop"
      ];
    };
}
