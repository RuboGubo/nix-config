{
  flake.modules.homeManager.rubogubo-desktop =
    { inputs, ... }:
    {
      imports = [
        inputs.self.modules.homeManager.document-apps
      ];
    };
}
