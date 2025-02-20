{ inputs, lib, ... }:

with lib;
{
  imports = [ inputs.agenix.nixosModules.default ];

  age = {
    identityPaths = [ "/var/keys/agenix_ssh_ed25519_key" ];
    secrets = mergeAttrsList (
      forEach (scanPaths' ".age" ../secrets) (s: {
        ${baseNameOf (removeSuffix ".age" (toString s))}.file = s;
      })
    );
  };
}
