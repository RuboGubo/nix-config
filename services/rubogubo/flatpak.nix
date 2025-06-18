{ ... }:
{
  # imports = [ nix-flatpak.homeManagerModules.nix-flatpak ];
  services.flatpak.packages = [
    # School
    "net.ankiweb.Anki"
    "me.iepure.devtoolbox"
    # Misc.
    "dev.bragefuglseth.Keypunch"
    "dev.bragefuglseth.Fretboard"
    "info.febvre.Komikku"
    "io.bassi.Amberol"
    "com.github.johnfactotum.Foliate"
    "im.bernard.Memorado"
    "io.gitlab.news_flash.NewsFlash"
    "org.ryujinx.Ryujinx"
    # Core apps
    "org.signal.Signal"
    "ca.desrt.dconf-editor"
    "org.gnome.Fractal"
    "com.spotify.Client"
    "io.gitlab.adhami3310.Impression"
    "com.github.neithern.g4music"
    "org.nickvision.cavalier"
    "io.github.alainm23.planify"
    "com.cburch.Logisim"
    "org.gnome.gitlab.somas.Apostrophe"
    # Audio/Production
    "com.obsproject.Studio"
    "com.github.wwmm.easyeffects"
    "org.pipewire.Helvum"
    "org.gnome.SoundRecorder"
    "de.haeckerfelix.Shortwave"
    # Dev
    "org.gnome.Connections"
    "io.github.giantpinkrobots.varia"
  ];
}
