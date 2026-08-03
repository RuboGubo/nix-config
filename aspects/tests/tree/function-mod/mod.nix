{ children, path }:
{
  _include = [ "child" ];

  nixos = {
    test.functionMod = children ? child && path == [ "function-mod" ];
  };
}
