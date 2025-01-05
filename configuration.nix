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
    ./modules/zsh.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_6_6;

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    timeout = 0;
  };

  users.users.quinn = {
    isNormalUser = true;
    shell = pkgs.zsh;
    passwordFile = config.age.secrets.quinn-passwd.path;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyLtibXqcDXRQ8DzDUbVw71YA+k+L7fH7H3oPYyjFII" # quinn@macmini-m4
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "prohibit-password";
  };

  networking.hostName = "oc-runner";

  environment.systemPackages = with pkgs; [
    curl
    eza
    fzf
    gitMinimal
    micro
    zoxide
  ];

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyLtibXqcDXRQ8DzDUbVw71YA+k+L7fH7H3oPYyjFII" # quinn@macmini-m4
    ];
    passwordFile = config.age.secrets.root-passwd.path;
  };

  system.stateVersion = "24.05";
}
