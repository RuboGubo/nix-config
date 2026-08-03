# aspects

`aspects` is a flake-parts extension for arbitrarily nested module namespaces.
Every namespace can provide NixOS, Home Manager, nix-darwin, and flake-parts
modules while also aggregating matching modules from its children.

## Installation

```nix
{
  inputs.aspects.url = "github:your-name/aspects";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.aspects.flakeModules.default ];
    };
}
```

## Explicit definitions

An ordinary flake-parts module can define an aspect at any depth:

```nix
{
  aspects.steam = {
    nixos = { programs.steam.enable = true; };
    homeManager = { home.sessionVariables.STEAM_FRAME_FORCE_CLOSE = "1"; };
  };

  aspects.rubogubo.desktop.steam.nixos =
    { self, ... }:
    {
      imports = [ self.aspects.steam.nixos ];
      programs.steam.remotePlay.openFirewall = true;
    };
}
```

Consume the specialized module with:

```nix
imports = [ inputs.self.aspects.rubogubo.desktop.steam.nixos ];
```

Every namespace aggregates matching modules from its immediate children. Thus
`inputs.self.aspects.rubogubo.desktop.nixos` also includes the Steam module.
Use `_include`, `_exclude`, or `_aggregate = false` to control aggregation.
Modules reuse other modules through ordinary Nix `imports`; `aspects` provides
no separate inheritance mechanism. The module evaluator must receive `self`
through `specialArgs` when an import references `self.aspects`.

## Directory loader

```text
modules/
├── steam/
│   ├── nixos.nix
│   └── homeManager.nix
└── rubogubo/
    └── desktop/
        ├── mod.nix
        └── steam/
            ├── nixos.nix
            └── homeManager.nix
```

Load it from a flake-parts module:

```nix
{ inputs, ... }:
{
  aspects = inputs.aspects.lib.loadTree ./modules;
}
```

Or import a complete tree, including any aggregated `flakeParts.nix` modules:

```nix
imports = [
  inputs.aspects.flakeModules.default
  (inputs.aspects.lib.mkTree ./aspect-modules)
];
```

This is the intended replacement for a generic recursive import utility.

A directory's `mod.nix` is merged with its discovered children and typed module
files. It can be a plain attribute set or a function receiving `children` and
`path`:

```nix
{ children, path }:
{
  _include = [ "steam" ];

  nixos = {
    networking.networkmanager.enable = true;
  };
}
```

`children` contains children discovered from both directories and dotted files.
`path` is the logical namespace path, including expansion of dotted directory
names.

- `_include` is an allowlist of immediate children to aggregate.
- `_exclude` removes immediate children from aggregation.
- `_aggregate = false` disables child aggregation at that namespace.
- Directories and files prefixed with `_` are ignored by discovery.

### Dotted path shorthand

Dots in discovered file and directory names are namespace separators. These
layouts are equivalent:

```text
common/nixos.nix
common.nixos.nix
```

Likewise, `rubogubo.desktop/` is loaded as `aspects.rubogubo.desktop`.
Shorthands can be combined:

```text
rubogubo.desktop/steam.nixos.nix
```

This defines `aspects.rubogubo.desktop.steam.nixos`. Empty components,
underscore-prefixed components, and module-type names used as namespace
components are rejected so path interpretation stays unambiguous.
