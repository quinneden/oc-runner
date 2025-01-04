{
  modulesPath,
  pkgs,
  secrets,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./hardware-configuration.nix
    ./disk-config.nix
    ./modules/zsh.nix
  ];

  # boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    devices = [ "/dev/sda" ];
  };

  users.users.quinn = {
    isNormalUser = true;
    shell = pkgs.zsh;
    initialPassword = "${secrets.misc.passwords.quinn}";
    extraGroups = [ "wheel" ];
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  networking.hostName = "oc-runner";

  environment.systemPackages = with pkgs; [
    curl
    gitMinimal
    micro
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyLtibXqcDXRQ8DzDUbVw71YA+k+L7fH7H3oPYyjFII" # quinn@macmini-m4
  ];

  system.stateVersion = "24.05";
}
