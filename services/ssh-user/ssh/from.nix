{ lib, ... }:
{
  interface = {
    options.networks = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { ... }:
          {
            options = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Enable this wifi network";
              };
              autoConnect = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Automatically try to join this wifi network";
              };
            };
          }
        )
      );
      default = { };
      description = "Wifi networks to predefine";
    };
  };
}
