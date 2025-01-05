let
  oc-runner = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH30QyMq1FxLm+r4rOlc2U98yHpZ0tL84WbuzQdTKdex";
  # quinn = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBw4QMkBtH2bsrFPaso3T1UMi5gjN1ZMePi3qjsD/s58";
  # root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA79gDrFlljadFGbiLyDJ0TieOyY9AOYrOTpg8+PKVPA";
  # macmini-m4 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICCHB5JZ8gQ3FFXnh2LMOkQZl1l/Ao6Er7hE5joFq45B";
  # quinn-macmini-m4 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyLtibXqcDXRQ8DzDUbVw71YA+k+L7fH7H3oPYyjFII";
  # allUsersOcRunner = [
  #   root
  #   quinn
  #   oc-runner
  # ];

in
{
  "quinn-passwd.age".publicKeys = [ oc-runner ];
  "root-passwd.age".publicKeys = [ oc-runner ];
  "cachix-pat.age".publicKeys = [ oc-runner ];
  "cloudflare-secret-access-key.age".publicKeys = [ oc-runner ];
  "cloudflare-access-key-id.age".publicKeys = [ oc-runner ];
  "github-token.age".publicKeys = [ oc-runner ];
  "gha-pat.age".publicKeys = [ oc-runner ];
}
