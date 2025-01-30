{
  modulesPath,
  pkgs,
  config,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./hardware-configuration.nix
    ./modules/agenix.nix
    ./modules/disk-config.nix
    ./modules/gha-runners.nix
    ./modules/seatfiller.nix
    ./modules/zsh.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_6_6;

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    timeout = 0;
  };

  nix = {
    nixPath = [ "nixpkgs=flake:nixpkgs" ];
    settings = {
      access-tokens = [ "github=@${config.age.secrets.github-token.path}" ];
      accept-flake-config = true;
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-substituters = [
        "https://nix-community.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = [ "quinn" ];
      warn-dirty = false;
    };
  };

  users.users.quinn = {
    isNormalUser = true;
    shell = pkgs.zsh;
    hashedPasswordFile = config.age.secrets.quinn-passwd.path;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyLtibXqcDXRQ8DzDUbVw71YA+k+L7fH7H3oPYyjFII"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICF7nPf8dHNfBQqXzn18y5RsI0S7D1JxfD5dE/Xz/Wuc"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      PubkeyAuthentication = "yes";
    };
  };

  services.seatfiller.enable = true;

  networking.hostName = "oc-runner";

  environment.systemPackages = with pkgs; [
    cachix
    curl
    eza
    fzf
    gh
    git
    git-crypt
    micro
    stress-ng
    supervise
    zoxide
  ];

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyLtibXqcDXRQ8DzDUbVw71YA+k+L7fH7H3oPYyjFII" # quinn@macmini-m4
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICF7nPf8dHNfBQqXzn18y5RsI0S7D1JxfD5dE/Xz/Wuc"
    ];
    hashedPasswordFile = config.age.secrets.root-passwd.path;
  };

  system.stateVersion = "24.05";
}
