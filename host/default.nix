{
  config,
  inputs,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.lix-module.nixosModules.default
    ./disk-config.nix
    ../modules
  ];

  boot = {
    initrd.availableKernelModules = [ "virtio_scsi" ];
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      timeout = 0;
    };
  };

  nix = {
    nixPath = [ "nixpkgs=flake:nixpkgs" ];
    settings = {
      access-tokens = [ "github=@${config.sops.secrets.github_token.path}" ];
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
      trusted-users = [
        "quinn"
        "github-runner-oc-runner"
        "github-runner-oc-runner2"
      ];
      warn-dirty = false;
    };
  };

  users.users = {
    quinn = {
      isNormalUser = true;
      shell = pkgs.zsh;
      hashedPasswordFile = config.sops.secrets."passwords/quinn".path;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyLtibXqcDXRQ8DzDUbVw71YA+k+L7fH7H3oPYyjFII"
      ];
    };

    root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyLtibXqcDXRQ8DzDUbVw71YA+k+L7fH7H3oPYyjFII"
      ];
      hashedPasswordFile = config.sops.secrets."passwords/root".path;
    };
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

  networking = {
    hostName = "oc-runner";
    useDHCP = true;
  };

  nixpkgs.hostPlatform = "aarch64-linux";

  environment.systemPackages = with pkgs; [
    cachix
    curl
    eza
    fzf
    gh
    git
    git-crypt
    micro
    nix-fast-build
    stress-ng
    zoxide
  ];

  system.stateVersion = "24.05";
}
