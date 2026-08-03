{ self, pkgs, ... }:
{
  imports = [ self.aspects.local.common.nixos ];

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ hangul ];
  };

  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };
}
