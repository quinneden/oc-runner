{ lib, ... }:

with lib;
{
  scanPaths =
    path:
    map (f: (path + "/${f}")) (
      builtins.attrNames (
        filterAttrs (
          path: _type: (_type == "directory") || ((path != "default.nix") && (hasSuffix ".nix" path))
        ) (builtins.readDir path)
      )
    );

  scanPaths' =
    type: path:
    map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.filterAttrs (path: _type: (_type == type) || (lib.hasInfix type path)) (builtins.readDir path)
      )
    );
}
