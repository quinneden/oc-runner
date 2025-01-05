{ pkgs, ... }:
{
  services.github-nix-ci = {
    age.secretsDir = ../secrets;
    personalRunners = {
      "quinneden/nixos-asahi-package".num = 1;
    };
    runnerSettings = {
      extraPackages = [ pkgs.xz ];
    };
  };
}
