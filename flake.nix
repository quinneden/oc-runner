{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    github-nix-ci.url = "github:juspay/github-nix-ci";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      disko,
      github-nix-ci,
      nixpkgs,
      ...
    }@inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
      ];

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
      nixosConfigurations.oc-runner = nixpkgs.lib.nixosSystem rec {
        system = "aarch64-linux";

        pkgs = import nixpkgs { inherit system; };

        specialArgs = {
          inherit inputs secrets;
        };

        modules = [
          ./configuration.nix
          disko.nixosModules.default
          github-nix-ci.nixosModules.default
        ];
      };

      apps = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          inherit (pkgs) writeShellApplication lib;

          deployScript = writeShellApplication {
            name = "deploy";
            runtimeInputs = [ pkgs.nixos-rebuild ];
            text = ''
              nixos-rebuild switch --show-trace --fast \
                --target-host "root@oc-runner" \
                --build-host "localhost" \
                --flake .#oc-runner
            '';
          };
        in
        rec {
          default = deploy;

          deploy = {
            type = "app";
            program = lib.getExe deployScript;
          };
        }
      );
    };
}
