{ aspects, pkgs, ... }:
{
  imports = [ aspects.hanseo.common.nixos ];

  home-manager.users.hanseo =
    { config, lib, ... }:
    {
      imports = [ aspects.desktop.gnome.home ];

      home.language.base = "ko_KR.UTF-8";
      fonts.fontconfig.enable = true;

      home.packages = with pkgs; [
        firefox
        thunderbird
        seahorse
        prismlauncher
        libreoffice-qt
        hunspell
        hunspellDicts.en_GB-ise
        blackbox-terminal
        steam
        nanum
        resources
      ];

      programs.firefox = {
        enable = true;
        configPath = "${config.xdg.configHome}/mozilla/firefox";
        profiles.default.search.default = "ddg";
      };

      # Korean is Hanseo's primary input source; British English remains
      # available as the secondary hardware-keyboard layout.
      dconf.settings."org/gnome/desktop/input-sources".sources = lib.mkForce (
        with lib.hm.gvariant;
        [
          (mkTuple [
            "ibus"
            "hangul"
          ])
          (mkTuple [
            "xkb"
            "gb"
          ])
        ]
      );
    };
}
