{ config, pkgs, ... }:
{
  services.github-runners = {
    oc-runner = {
      enable = true;
      ephemeral = true;
      extraLabels = [ "oc-runner" ];
      extraPackages = [ pkgs.cachix ];
      group = "github-runners";
      name = "oc-runner";
      noDefaultLabels = true;
      replace = true;
      tokenFile = config.sops.secrets.github_token.path;
      url = "https://github.com/quinneden/nixos-asahi-package";
      user = "github-runner-1";
    };

    # oc-runner2 = {
    #   enable = true;
    #   extraLabels = [ "oc-runner2" ];
    #   extraPackages = [ ];
    #   name = "oc-runner2";
    #   noDefaultLabels = true;
    #   replace = true;
    #   tokenFile = config.sops.secrets."fine_grained/2025-05-02_oc-runner_ci-flake-lock".path;
    #   url = "https://github.com/quinneden/oc-runner";
    # };
  };

  users.groups.github-runners = { };
  users.users = {
    github-runner-1 = {
      isSystemUser = true;
      group = "github-runners";
    };
  };
}
