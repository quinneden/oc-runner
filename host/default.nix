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
      trusted-users = [
        "quinn"
        "@github-runners"
      ];
      warn-dirty = false;
    };
  };

  nixpkgs = {
    hostPlatform = "aarch64-linux";
    overlays = [
      (final: prev: {
        nix-fast-build = inputs.nix-fast-build.packages.${prev.system}.nix-fast-build.override {
          inherit (inputs.lix-module.packages.${prev.system}) nix-eval-jobs;
        };
      })
    ];
  };

  users.users = {
    quinn = {
      isNormalUser = true;
      shell = pkgs.zsh;
      hashedPasswordFile = config.sops.secrets."passwords/quinn".path;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyLtibXqcDXRQ8DzDUbVw71YA+k+L7fH7H3oPYyjFII"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICF7nPf8dHNfBQqXzn18y5RsI0S7D1JxfD5dE/Xz/Wuc"
      ];
    };

    root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyLtibXqcDXRQ8DzDUbVw71YA+k+L7fH7H3oPYyjFII"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICF7nPf8dHNfBQqXzn18y5RsI0S7D1JxfD5dE/Xz/Wuc"
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

  environment.systemPackages = with pkgs; [
    cachix
    curl
    eza
    git
    micro
  ];

  system.stateVersion = "25.05";
}
