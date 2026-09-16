{ pkgs, ... }: {
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = [
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk-sans
    ];
  };
}
