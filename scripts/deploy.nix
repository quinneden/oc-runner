{ lib, pkgs, ... }:
pkgs.writeShellScriptBin "deploy" ''
  ${lib.getExe pkgs.nixos-rebuild} switch \
    --show-trace --fast \
    --target-host root@oc-runner \
    --flake .#oc-runner
''
