{
  modulesPath,
  lib,
  pkgs,
  secrets,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  users.users.quinn = {
    isNormalUser = true;
    initialPassword = "${secrets.misc.passwords.quinn}";
    extraGroups = [ "wheel" ];
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyLtibXqcDXRQ8DzDUbVw71YA+k+L7fH7H3oPYyjFII" # quinn@macmini-m4
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwWg+RhJjXVmxwh/JPJkYSQuQBomj0Zn1oNzdobvYEUAKBBjxNXH8HlzW7t6loi2M7TZ5Mn5Cqehy7cpZZgimHn73gDZZCU12MiIaOdyk46ncCrmci2SAA/EfuavyVPD9lBIJbm0lIThXyqgfJzxODxdFjLawnk17b5s8lOvZLor7khJwH65FS7gC1lKvnDfR2XeVGDSGn9DVkrCbdvriumX/jLjY2snc1wOzl11oh/mbxcLrDpHNgT9xv1O8Pr9hqkDFJSAJFr5C5zAlbZdmTWqyEaQ5aAwi4DXbycw3gQ3boS8usUC/MhvhAASO3aufBI9VRQtXJRkHfsbyIp9Zh"
  ];

  system.stateVersion = "24.05";
}
