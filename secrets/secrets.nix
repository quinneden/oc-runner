let
  admin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyLtibXqcDXRQ8DzDUbVw71YA+k+L7fH7H3oPYyjFII";
  # agenix-master = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH30QyMq1FxLm+r4rOlc2U98yHpZ0tL84WbuzQdTKdex";
  # quinn = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBw4QMkBtH2bsrFPaso3T1UMi5gjN1ZMePi3qjsD/s58";
  # root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA79gDrFlljadFGbiLyDJ0TieOyY9AOYrOTpg8+PKVPA";
  # macmini-m4 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICCHB5JZ8gQ3FFXnh2LMOkQZl1l/Ao6Er7hE5joFq45B";
  # allUsersOcRunner = [
  #   root
  #   quinn
  #   oc-runner
  # ];

in
{
  "quinn-passwd.age".publicKeys = [
    # agenix-master
    admin
  ];
  "quinn-ssh-pubkey.age".publicKeys = [
    # agenix-master
    admin
  ];
  # "host-ssh-pubkey.age".publicKeys = [ agenix-master ];
  "root-passwd.age".publicKeys = [
    # agenix-master
    admin
  ];
  "cachix-pat.age".publicKeys = [
    # agenix-master
    admin
  ];
  "cloudflare-secret-access-key.age".publicKeys = [
    # agenix-master
    admin
  ];
  "cloudflare-access-key-id.age".publicKeys = [
    # agenix-master
    admin
  ];
  "github-token.age".publicKeys = [
    # agenix-master
    admin
  ];
  "github-nix-ci/quinneden.token.age".publicKeys = [
    # agenix-master
    admin
  ];
  "tailscale.age".publicKeys = [
    # agenix-master
    admin
  ];
}
