{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.2-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "git+ssh://git@github.com/quinneden/secrets.git?ref=main&shallow=1";
      inputs = { };
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-fast-build = {
      url = "github:mic92/nix-fast-build";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      lib = nixpkgs.lib.extend (self: super: import ./lib { inherit (nixpkgs) lib; });

      forEachSystem =
        f:
        lib.genAttrs [ "aarch64-darwin" "aarch64-linux" ] (
          system: f { pkgs = import nixpkgs { inherit system; }; }
        );
    in
    {
      nixosConfigurations.oc-runner = lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs lib; };
        modules = [ ./host ];
      };

      packages = forEachSystem (
        { pkgs }:
        rec {
          default = deploy;
          # deploy = pkgs.callPackage ./scripts/deploy.nix { };
          deploy = pkgs.writeShellApplication {
            name = "deploy-oc-runner";
            runtimeInputs = [ pkgs.nixos-rebuild-ng ];
            text = ''
              nixos-rebuild-ng switch \
                --flake .#oc-runner \
                --no-reexec \
                --show-trace \
                --target-host root@oc-runner
            '';
          };
        }
      );
    };
}
