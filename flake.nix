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
      disko,
      github-nix-ci,
      nixpkgs,
      ...
    }:
    let
      forEachSystem =
        f:
        nixpkgs.lib.genAttrs [
          "aarch64-darwin"
          "aarch64-linux"
        ] (system: f { pkgs = import nixpkgs { inherit system; }; });
    in
    {
      nixosConfigurations.oc-runner = nixpkgs.lib.nixosSystem rec {
        system = "aarch64-linux";

        pkgs = import nixpkgs { inherit system; };

        modules = [
          ./configuration.nix
          agenix.nixosModules.default
          disko.nixosModules.default
          github-nix-ci.nixosModules.default
        ];
      };

      devShells = forEachSystem (
        { pkgs }:
        let
          inherit (pkgs) lib mkShell writeShellScriptBin;

          deployScript = writeShellScriptBin "deploy" ''
            nixos-rebuild switch --show-trace --fast \
              --target-host root@oc-runner \
              --flake .#oc-runner
          '';
        in
        with lib;
        {
          default = mkShell {
            name = "oc-runner";
            packages = with pkgs; [
              nixos-rebuild
              agenix.packages.${system}.default
              deployScript
            ];
          };
        }
      );

      apps = forEachSystem (
        { pkgs }:
        let
          inherit (pkgs) writeShellApplication lib;
        in
        with lib;
        rec {
          default = deploy;

          deploy = {
            type = "app";
            program = getExe (writeShellApplication {
              name = "deploy";
              runtimeInputs = [ pkgs.nixos-rebuild ];
              text = ''
                nixos-rebuild switch --show-trace --fast \
                  --target-host root@oc-runner \
                  --flake .#oc-runner
              '';
            });
          };
        }
      );
    };
}
