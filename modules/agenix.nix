{
  age.identityPaths = [ "/var/keys/agenix_ssh_ed25519_key" ];

  age.secrets.quinn-passwd.file = ../secrets/quinn-passwd.age;
  age.secrets.root-passwd.file = ../secrets/root-passwd.age;
  age.secrets.cachix-pat.file = ../secrets/cachix-pat.age;
  age.secrets.cloudflare-secret-access-key.file = ../secrets/cloudflare-secret-access-key.age;
  age.secrets.cloudflare-access-key-id.file = ../secrets/cloudflare-access-key-id.age;
  age.secrets.github-token.file = ../secrets/github-token.age;
  # age.secrets.gha-pat.file = ../secrets/gha-pat.age;
}
