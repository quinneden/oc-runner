{
  inputs = {
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    github-nix-ci.url = "github:juspay/github-nix-ci";

    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    secrets = {
      url = "git+ssh://git@github.com/quinneden/secrets.git?ref=main&shallow=1";
      inputs = { };
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      self,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib.extend (self: super: import ./lib { inherit (nixpkgs) lib; });

      forEachSystem =
        f:
        lib.genAttrs [
          "aarch64-darwin"
          "aarch64-linux"
        ] (system: f { pkgs = import nixpkgs { inherit system; }; });
    in
    {
      nixosConfigurations.oc-runner = lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs lib; };
        modules = [ ./config ];
      };

      devShells = forEachSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            name = "oc-runner";
            packages = [ self.packages.${pkgs.system}.deploy ];
          };
        }
      );

      packages = forEachSystem (
        { pkgs }:
        {
          deploy = pkgs.writeShellScriptBin "deploy" ''
            ${lib.getExe pkgs.nixos-rebuild-ng} switch \
              --show-trace --fast \
              --target-host root@oc-runner \
              --flake .#oc-runner
          '';
        }
      );
    };
}
