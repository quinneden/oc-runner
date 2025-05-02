{ nixos-rebuild-ng, writeShellApplication, ... }:

writeShellApplication {
  name = "deploy-oc-runner";
  runtimeInputs = [ nixos-rebuild-ng ];
  text = ''
    nixos-rebuild-ng switch \
      --flake .#oc-runner \
      --no-reexec \
      --show-trace \
      --target-host oc-runner
  '';
}

# writeShellApplication {
#   name = "deploy-oc-runner";
#   runtimeInputs = [ nixos-rebuild-ng ];
#   text = ''
#     nixos-rebuild-ng switch \
#       --flake .#oc-runner \
#       --no-reexec \
#       --show-trace \
#       --target-host quinn@oc-runner \
#       --build-host quinn@oc-runner \
#       --sudo
#   '';
# }
