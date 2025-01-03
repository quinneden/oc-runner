{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

  outputs =
    {
      nixpkgs,
      disko,
      nixos-facter-modules,
      ...
    }:
    {
      # nixos-anywhere --flake .#generic-nixos-facter --generate-hardware-config nixos-facter facter.json <hostname>
      nixosConfigurations.generic-nixos-facter = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./configuration.nix

          disko.nixosModules.disko
          nixos-facter-modules.nixosModules.facter

          { config.facter.reportPath = ./facter.json; }
        ];
      };
    };
}
