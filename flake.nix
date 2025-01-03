{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      disko,
      nixos-facter-modules,
      ...
    }:
    let
      secrets =
        let
          inherit (builtins) fromJSON readFile;
        in
        with nixpkgs.lib;
        genAttrs [
          "cachix"
          "cloudflare"
          "github"
          "misc"
        ] (secretFile: fromJSON (readFile .secrets/${secretFile}.json));
    in
    {
      # nixos-anywhere --flake .#generic-nixos-facter --generate-hardware-config nixos-facter facter.json <hostname>
      nixosConfigurations.oc-runner = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit secrets; };
        modules = [
          ./configuration.nix
          disko.nixosModules.disko
          nixos-facter-modules.nixosModules.facter
          { config.facter.reportPath = ./facter.json; }
        ];
      };
    };
}
