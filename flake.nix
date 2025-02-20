{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    github-nix-ci.url = "github:juspay/github-nix-ci";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      agenix,
      nixpkgs,
      self,
      ...
    }@inputs:
    let
      forEachSystem =
        f:
        nixpkgs.lib.genAttrs [
          "aarch64-darwin"
          "aarch64-linux"
        ] (system: f { pkgs = import nixpkgs { inherit system; }; });

      lib = nixpkgs.lib.extend (self: super: import ./lib { inherit (nixpkgs) lib; });
    in
    {
      nixosConfigurations.oc-runner = nixpkgs.lib.nixosSystem rec {
        system = "aarch64-linux";
        pkgs = import nixpkgs { inherit system; };
        specialArgs = { inherit inputs lib; };

        modules = [ ./config ];
      };

      devShells = forEachSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            name = "oc-runner";
            packages = [
              agenix.packages.${pkgs.system}.default
              self.packages.${pkgs.system}.deploy
            ];
          };
        }
      );

      packages = forEachSystem (
        { pkgs }:
        {
          deploy = pkgs.callPackage ./scripts/deploy.nix { inherit lib; };
        }
      );
    };
}
