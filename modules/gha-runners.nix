{ inputs, pkgs, ... }:
{
  imports = [ inputs.github-nix-ci.nixosModules.default ];

  services.github-nix-ci = {
    age.secretsDir = ../secrets;
    personalRunners = {
      "quinneden/nixos-asahi-package".num = 1;
    };
    runnerSettings = {
      extraPackages = with pkgs; [
        cachix
        curl
        openssh
        nix-fast-build
        xz
      ];
    };
  };
}
