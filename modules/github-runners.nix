{ config, pkgs, ... }:
{
  services.github-runners = {
    oc-runner = {
      enable = true;
      extraLabels = [ "oc-runner" ];
      extraPackages = [ pkgs.cachix ];
      name = "oc-runner";
      noDefaultLabels = true;
      replace = true;
      tokenFile = config.sops.secrets.github_token.path;
      url = "https://github.com/quinneden/nixos-asahi-package";
    };

    oc-runner2 = {
      enable = false;
      extraLabels = [ "oc-runner2" ];
      extraPackages = [ ];
      name = "oc-runner2";
      noDefaultLabels = true;
      replace = true;
      tokenFile = config.sops.secrets."github/2025-05-02_oc-runner_ci-flake-lock".path;
      url = "https://github.com/quinneden/oc-runner";
    };
  };
}
