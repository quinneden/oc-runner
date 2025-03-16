{ config, pkgs, ... }:
{
  services.github-runners = {
    oc-runner = {
      enable = true;
      extraLabels = [ "oc-runner" ];
      extraPackages = with pkgs; [
        cachix
        nix-fast-build
      ];
      name = "oc-runner";
      noDefaultLabels = true;
      replace = true;
      tokenFile = config.sops.secrets.github_token.path;
      url = "https://github.com/quinneden/nixos-asahi-package";
    };
  };
}
