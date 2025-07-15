{ config, pkgs, ... }:
let
  mkRunner =
    {
      enable ? true,
      extraLabels ? [ "oc-runner${idx}" ],
      extraPackages ? [ ],
      idx,
      repo,
    }:
    {
      inherit enable extraLabels extraPackages;
      name = "oc-runner${idx}";
      user = "github-runner-${idx}";
      group = "github-runners";
      ephemeral = true;
      noDefaultLabels = true;
      replace = true;
      tokenFile = config.sops.secrets.github_token.path;
      url = "https://github.com/quinneden/${repo}";
    };
in
{
  services.github-runners = {
    oc-runner = mkRunner {
      idx = "1";
      extraLabels = [ "oc-runner" ];
      extraPackages = with pkgs; [
        cachix
        nix-fast-build
      ];
      repo = "nixos-asahi-package";
    };
    oc-runner2 = mkRunner {
      idx = "2";
      extraLabels = [ "oc-runner2" ];
      extraPackages = with pkgs; [
        cachix
        nix-fast-build
      ];
      repo = "oc-runner";
    };
  };

  users.groups.github-runners = { };
  users.users = {
    github-runner-1 = {
      isSystemUser = true;
      group = "github-runners";
    };
    github-runner-2 = {
      isSystemUser = true;
      group = "github-runners";
    };
  };
}
