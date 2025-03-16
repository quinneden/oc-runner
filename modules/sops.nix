{ inputs, ... }:
let
  secretsPath = "${inputs.secrets}/sops";
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = "${secretsPath}/default.yaml";
    validateSopsFiles = false;

    age = {
      sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
        "/root/.ssh/id_ed25519"
      ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    secrets = {
      github_token = { };

      github_token_oc_runner = { };

      "tailscale_auth_keys/oc-runner" = { };

      "passwords/quinn" = { };
      "passwords/root" = { };
    };
  };
}
